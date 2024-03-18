package ecs



add_components :: proc {
    add_component,
    add_components_2,
    add_components_3,
    add_components_4,
    add_components_5,
    add_components_6,
    add_components_7,
    add_components_8,
}

get_components :: proc {
    get_component,
    get_components_2,
    get_components_3,
    get_components_4,
    get_components_5,
}

remove_components :: proc {
    remove_component,
    remove_components_2,
    remove_components_3,
    remove_components_4,
    remove_components_5,
}


add_component :: proc(ctx : ^Context, entity : Entity, a : $A) -> (^A, Error) {
    return _add_component(ctx, entity, a)
}


add_components_2 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B) -> (^A, ^B, [2]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    return a, b, {err1, err2}
}


add_components_3 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B, c : $C) -> (^A, ^B, ^C, [3]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    return a, b, c, {err1, err2, err3}
}


add_components_4 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D) -> (^A, ^B, ^C, ^D, [4]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    d, err4 := _add_component(ctx, entity, d)
    return a, b, c, d, {err1, err2, err3, err4}
}


add_components_5 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E) -> (^A, ^B, ^C, ^D, ^E, [5]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    d, err4 := _add_component(ctx, entity, d)
    e, err5 := _add_component(ctx, entity, e)
    return a, b, c, d, e, {err1, err2, err3, err4, err5}
}


add_components_6 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E, f : $F) -> (^A, ^B, ^C, ^D, ^E, ^F, [6]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    d, err4 := _add_component(ctx, entity, d)
    e, err5 := _add_component(ctx, entity, e)
    f, err6 := _add_component(ctx, entity, f)
    return a, b, c, d, e, f, {err1, err2, err3, err4, err5, err6}
}



add_components_7 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E, f : $F, g : $G) -> (^A, ^B, ^C, ^D, ^E, ^F, ^G, [7]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    d, err4 := _add_component(ctx, entity, d)
    e, err5 := _add_component(ctx, entity, e)
    f, err6 := _add_component(ctx, entity, f)
    g, err7 := _add_component(ctx, entity, g)
    return a, b, c, d, e, f, g, {err1, err2, err3, err4, err5, err6, err7}
}



add_components_8 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E, f : $F, g : $G, h : $H) -> (^A, ^B, ^C, ^D, ^E, ^F, ^G, ^H, [8]Error) {
    a, err1 := _add_component(ctx, entity, a)
    b, err2 := _add_component(ctx, entity, b)
    c, err3 := _add_component(ctx, entity, c)
    d, err4 := _add_component(ctx, entity, d)
    e, err5 := _add_component(ctx, entity, e)
    f, err6 := _add_component(ctx, entity, f)
    g, err7 := _add_component(ctx, entity, g)
    g, err8 := _add_component(ctx, entity, h)
    return a, b, c, d, e, f, g, h, {err1, err2, err3, err4, err5, err6, err7, err8}
}



get_components_2 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B) -> (^A, ^B, [2]Error) {
    a, err1 := get_component(ctx, entity, a)
    b, err2 := get_component(ctx, entity, b)
    return a, b, {err1, err2}
}


get_components_3 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B, c : $C) -> (^A, ^B, ^C, [3]Error) {
    a, err1 := get_component(ctx, entity, a)
    b, err2 := get_component(ctx, entity, b)
    c, err3 := get_component(ctx, entity, c)
    return a, b, c, {err1, err2, err3}
}


get_components_4 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D) -> (^A, ^B, ^C, ^D, [4]Error) {
    a, err1 := get_component(ctx, entity, a)
    b, err2 := get_component(ctx, entity, b)
    c, err3 := get_component(ctx, entity, c)
    d, err4 := get_component(ctx, entity, d)
    return a, b, c, d, {err1, err2, err3, err4}
}


get_components_5 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E) -> (^A, ^B, ^C, ^D, ^E, [5]Error) {
    a, err1 := get_component(ctx, entity, a)
    b, err2 := get_component(ctx, entity, b)
    c, err3 := get_component(ctx, entity, c)
    d, err4 := get_component(ctx, entity, d)
    e, err5 := get_component(ctx, entity, e)
    return a, b, c, d, e, {err1, err2, err3, err4, err5}
}



remove_components_2 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B) -> [2]Error {
    err1 := remove_component(ctx, entity, a)
    err2 := remove_component(ctx, entity, b)
    return {err1, err2}
}


remove_components_3 :: proc(ctx : ^Context, entity : Entity, a : $A, b : $B, c : $C) -> [3]Error {
    err1 := remove_component(ctx, entity, a)
    err2 := remove_component(ctx, entity, b)
    err3 := remove_component(ctx, entity, c)
    return {err1, err2, err3}
}


remove_components_4 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D) -> [4]Error {
    err1 := remove_component(ctx, entity, a)
    err2 := remove_component(ctx, entity, b)
    err3 := remove_component(ctx, entity, c)
    err4 := remove_component(ctx, entity, d)
    return {err1, err2, err3, err4}
}


remove_components_5 :: proc(ctx, :^Context, entity : Entity, a : $A, b : $B, c : $C, d : $D, e : $E) -> [5]Error {
    err1 := remove_component(ctx, entity, a)
    err2 := remove_component(ctx, entity, b)
    err3 := remove_component(ctx, entity, c)
    err4 := remove_component(ctx, entity, d)
    err5 := remove_component(ctx, entity, e)
    return {err1, err2, err3, err4, err5}
}