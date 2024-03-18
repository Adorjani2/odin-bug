package ecs


import "core:runtime"
import "core:mem"
import "core:slice"
import "../stack"


INVALID_ENTITY :: Entity{0xFFFFFFFF, 0xFFFFFFFF}


entity_id :: distinct u32


Entity :: struct {
    id : entity_id,
    generation : u32,
}


Error :: enum {
    None,
    Component_Not_Registered,
    Entity_Not_Valid,
    Entity_Does_Not_Have_This_Component,
    Entity_Already_Has_This_Component,
}


Entity_Info :: struct {
    entity : Entity,
    valid  : bool,
}


Context :: struct {
    component_lists : map[typeid]Component_List,

    entities : [dynamic]Entity_Info,
    current_entity_id : entity_id,
    free_slots : stack.Dynamic_Stack(Entity),

    entity_count : u32,
}


Extra_Data :: struct {
    owner : Entity,
}


Component_Wrapper :: struct($T : typeid) {
    using extra : Extra_Data,
    component   : T,
}


// @Todo: change lookup table from map to array so looking up stuff is O(1)
Component_List :: struct {
    type    : typeid,
    data    : runtime.Raw_Dynamic_Array,
    indices : map[Entity]u32,
    type_size : int,
}



init :: proc(using ctx : ^Context) {
    component_lists   = make(map[typeid]Component_List)
    entities          = make([dynamic]Entity_Info)
    current_entity_id = 0
    stack.init(&free_slots)
}



deinit :: proc(using ctx : ^Context) {
    for type, _ in &component_lists {
        list := &component_lists[type]
        delete(list.indices)
        free(list.data.data)
    }

    delete(component_lists)
    delete(entities)
    stack.deinit(&free_slots)
}



create_entity :: proc(using ctx : ^Context) -> Entity {
    entity : Entity
    
    if !stack.is_empty(&free_slots) {
        entity = stack.pop(&free_slots)
        entity.generation += 1
        entities[entity.id] = {entity, true}
    } else {
        entity = {current_entity_id, 0}
        current_entity_id += 1
        append(&entities, Entity_Info{entity, true})
    }
    
    entity_count += 1
    return entity
}



destroy_entity :: proc(using ctx : ^Context, entity : Entity) -> Error {
    if !is_entity_valid(ctx, entity) {
        return .Entity_Not_Valid
    }
    
    for type, component_list in component_lists {
        _remove_entity_from_component_list(&component_lists[type], entity)
    }

    stack.push(&free_slots, entity)
    entities[entity.id] = {INVALID_ENTITY, false}

    entity_count -= 1
    return .None
}



is_entity_valid :: proc(using ctx : ^Context, entity : Entity) -> bool {
    if entity == INVALID_ENTITY do return false
    if int(entity.id) > len(entities) do return false
    return (
        entities[entity.id].entity.id == entity.id &&
        entities[entity.id].valid &&
        entities[entity.id].entity.generation == entity.generation
    )
}



remove_component :: proc(using ctx : ^Context, entity : Entity, $T : typeid) -> Error {
    if !is_entity_valid(ctx, entity) {
        return .Entity_Not_Valid
    }

    if T not_in component_lists {
        return .Component_Not_Registered
    }

    if !has_component(ctx, entity, T) {
        return .Entity_Does_Not_Have_This_Component
    }

    list := &component_lists[T]
    _data := (^[dynamic]Component_Wrapper(T))(&list.data)
    index, _ := list.indices[entity] // must have it since it got throug the has_component() check
    moved_entity := _data[len(_data)-1].owner
    unordered_remove(_data, auto_cast index)
    list.indices[moved_entity] = index

    delete_key(&list.indices, entity)

    return .None
}



has_component :: proc(using ctx : ^Context, entity : Entity, $T : typeid) -> bool {
    if T not_in component_lists || !is_entity_valid(ctx, entity) {
        return false
    }
    return entity in component_lists[T].indices
}



get_component :: proc(using ctx :^Context, entity : Entity, $T : typeid) -> (^T, Error) {
    if !is_entity_valid(ctx, entity) {
        return nil, .Entity_Not_Valid
    }

    if !has_component(ctx, entity, T) {
        return nil, .Entity_Does_Not_Have_This_Component
    }

    list := component_lists[T]
    index, ok := list.indices[entity]
    if !ok {
        return nil, .Entity_Does_Not_Have_This_Component
    }

    _data := (^[dynamic]Component_Wrapper(T))(&list.data)
    return &_data[index].component, .None
}



get_component_list :: proc(using ctx : ^Context, $T : typeid, allocator := context.temp_allocator) -> ([]T, Error) {
    mapper_proc :: proc(e : Component_Wrapper(T)) -> T {
        return T(e.component)
    }

    filtered, error := get_component_list_wrapped(ctx, T)
    if error != .None {
        return nil, error
    }

    return slice.mapper(filtered[:], mapper_proc, allocator), .None
}



get_component_list_wrapped :: proc(using ctx : ^Context, $T : typeid) -> ([]Component_Wrapper(T), Error) {
    list, ok := component_lists[T]
    if !ok {
        return nil, .Component_Not_Registered
    }

    _data := (^[dynamic]Component_Wrapper(T))(&list.data)
    return _data[:], .None
}


get_component_list_ptr :: proc(using ctx : ^Context, $T : typeid, allocator := context.temp_allocator) -> ([]^T, Error) {
    list, ok := component_lists[T]
    if !ok {
        return nil, .Component_Not_Registered
    }

    _data := (^[dynamic]Component_Wrapper(T))(&list.data)
    ret := make([dynamic]^T, allocator)

    for _, ind in _data {
        we := &_data[ind]
        append(&ret, &we.component)
    }

    return ret[:], .None
}


get_registered_components :: proc(using ctx : ^Context, allocator := context.temp_allocator) -> [dynamic]typeid {
    arr := make([dynamic]typeid, allocator)
    for type, _ in &component_lists {
        append(&arr, type)
    }
    return arr
}


clear_component_list :: proc(using ctx : ^Context, $T : typeid) -> Error {
    component_list, ok := &component_lists[T]
    if !ok {
        return .Component_Not_Registered
    }
    component_list.data.len = 0
    clear(&component_list.indices)
    return .None
}


entity_to_uid :: proc(e : Entity) -> u64 {
    a := u64(e.id)
    b := u64(e.generation) << 32
    return a | b 
}


uid_to_entity :: proc(uid : u64) -> Entity {
    id  := entity_id(uid)
    gen := u32(uid >> 32)
    return Entity{id, gen}
}


get_all_entities :: proc(using ctx : ^Context, allocator := context.allocator) -> []Entity {
    arr   := make([]Entity, entity_count, allocator)
    index := 0

    for e in entities {
        if e.valid && is_entity_valid(ctx, e.entity) {
            arr[index] = e.entity
            index += 1
        }
    }

    return arr
}


@private
_add_component :: proc(using ctx : ^Context, entity : Entity, component : $T) -> (^T, Error) {
    if !is_entity_valid(ctx, entity) {
        return nil, .Entity_Not_Valid
    }

    _register_component(ctx, T)
    if has_component(ctx, entity, T) {
        return nil, .Entity_Already_Has_This_Component
    }

    ed := Extra_Data{entity}
    list := &component_lists[T]
    item := Component_Wrapper(T){ed, component}
    _data := (^[dynamic]Component_Wrapper(T))(&list.data)
    index := u32(len(_data))
    append(_data, Component_Wrapper(T)(item))

    list.indices[entity] = index

    return &_data[index].component, .None
}



@private
_register_component :: proc(using ctx : ^Context, $T : typeid) {
    if T in component_lists {
        return
    }

    component_lists[T] = {}
    list := &component_lists[T]
    list.type = T
    list.type_size = size_of(Component_Wrapper(T))
    tmp := make([dynamic]Component_Wrapper(T))
    list.data = ((^runtime.Raw_Dynamic_Array)(&tmp))^
    list.indices = make(map[Entity]u32)
}



@private
_remove_entity_from_component_list :: proc(using list : ^Component_List, _entity : Entity) {
    index, ok := indices[_entity]
    if !ok {
        return
    }

    // scary pointer magic to delete a component at runtime
    data_slice := mem.byte_slice(data.data, data.len * type_size)
    destroy_ptr := &data_slice[index * auto_cast type_size] // @Bug: "Index 0 is out of range 0..<0"
    move_ptr := &data_slice[(data.len-1) * auto_cast type_size]
    moved_entity : Entity
    mem.copy(&moved_entity, move_ptr, size_of(Entity))
    mem.copy(destroy_ptr, move_ptr, auto_cast type_size)
    indices[moved_entity] = index
    data.len -= 1

    delete_key(&indices, _entity)
}
