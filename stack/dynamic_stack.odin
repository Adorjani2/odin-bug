package stack


//import "core:mem"


Dynamic_Stack :: struct($T : typeid) {
	data : [dynamic]T,
	size : u32,
}


init_ds :: proc(s : ^$S/Dynamic_Stack($T)) {
    s.size = 0
    s.data = make([dynamic]T)
}


deinit_ds :: proc(s : ^$S/Dynamic_Stack($T)) {
    delete(s.data)
}


size_ds :: proc(s : ^$S/Dynamic_Stack($T)) -> u32 {
	return s.size
}


is_empty_ds :: proc(s : ^$S/Dynamic_Stack($T)) -> bool {
	return (s.size == 0)
}



import "core:log"



pop_ds :: proc(s: ^$S/Dynamic_Stack($T) loc := #caller_location) -> T {
    when ODIN_DEBUG {
        if is_empty(s) do log.fatalf("Out of bounds when popping from stack: %v", loc)
    }
	assert(is_empty(s) == false)
	s.size -= 1
	return s.data[s.size]
}


push_ds :: proc(s: ^$S/Dynamic_Stack($T), i : T, loc := #caller_location) -> T {
	if len(s.data) == auto_cast s.size {
		append(&s.data, i)
	} else {
		s.data[s.size] = i
	}

	s.size += 1
	return i
}


peek_ds :: proc(s : ^$S/Dynamic_Stack($T)) -> T {
	assert(is_empty(s) == false)
	return s.data[s.size - 1]
}


clear_ds :: proc(s : ^$S/Dynamic_Stack($T)) {
	s.size = 0
}
