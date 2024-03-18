package stack


Static_Stack :: struct($T : typeid, $N : u32) where N > 1 {
	data : [N]T,
	size : u32,
}


size_ss :: proc(using s : ^$S/Static_Stack($T, $N)) -> u32 {
	return size
}


capacity_ss :: proc(using s : ^$S/Static_Stack($T, $N)) -> u32 {
	return N
}


is_empty_ss :: proc(using s : ^$S/Static_Stack($T, $N)) -> bool {
	return (size == 0)
}


is_full_ss :: proc(using s : ^$S/Static_Stack($T, $N)) -> bool {
	return (size == capacity(s))
}


pop_ss :: proc(using s: ^$S/Static_Stack($T, $N)) -> T {
	assert(is_empty(s) == false)
	size -= 1
	return data[size]
}


push_ss :: proc(using s: ^$S/Static_Stack($T, $N), i : T) -> T {
	assert(is_full(s) == false)
	data[size] = i
	size += 1
	return i
}


peek_ss :: proc(using s : ^$S/Static_Stack($T, $N)) -> T {
	assert(is_empty(s) == false)
	return data[size - 1]
}


clear_ss :: proc(using s : ^$S/Static_Stack($T, $N)) {
	size = 0
}
