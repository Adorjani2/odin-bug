# Odin bug

Error messages I got so far:

1:
-
```
ecs.odin(193:13) Error: '_data[index]' of type 'Component_Wrapper(T)' has no field 'component'
        return &_data[index].component, .None
                ^~~~~~~~~~~^
        Suggestion: Did you mean?
                component
```

2:
-
```
ecs.odin(304:34) Error: Too many values in structure literal, expected 0, got 2
        item := Component_Wrapper(T){ed, component}
```


3:
-
```
ecs.odin(235:23) Error: 'we' of type '^ecs.Component_Wrapper(T)' has no field 'component'
        append(&ret, &we.component)
                      ^^
```


4:
-
```
ecs.odin(235:9) Error: No procedures or ambiguous call for procedure group 'append' that match with the given arguments
        append(&ret, &we.component)
        ^~~~~^
        Given argument types: (^[dynamic]^Perspective_Camera_Component, ecs/ecs.odin(304:34) ^Component_Wrapper($T=Perspective_Camera_Component))
Did you mean to use one of the following:
Error:  runtime.append_elem        :: proc(array: ^$T/[dynamic]$E, arg: E, loc := #caller_location) -> (n: int, err: Allocator_Error)            at C:/Odin/base/runtime/core_builtin.odin(450:1)
Too many values in structure literal, expected 0, got 2
        item := Component_Wrapper(T){ed, component}     runtime.append_elems       :: proc(array: ^$T/[dynamic]$E, args: ..E, loc := #caller_location) -> (n: int, err: Allocator_Error)         at C:/Odin/base/runtime/core_builtin.odin(499:1
)

                runtime.append_elem_string :: proc(array: ^$T/[dynamic]$E/u8, arg: $A/string, loc := #caller_location) -> (n: int, err: Allocator_Error) at C:/Odin/base/runtime/core_builtin.odin(519:1)


                             ^^
```



5: the first error here was from a different file in the main project where I use this code
-
```
program.odin(105:16) Error: 'c' of type 'Component_Wrapper(T)' has no field 'component'
        if c.component.primary {
           ^
        Suggestion: Did you mean?
                component

C:/Dev/odin_bugs/Telya bug/src/engine/scene/ecs/ecs.odin(304:34) Error: Too many values in structure literal, expected 0, got 2

item := Component_Wrapper(T){ed, component}


                             ^^
```
