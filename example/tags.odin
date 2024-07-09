package main

import yaml ".."
import "base:runtime"
import "core:fmt"
import "core:os"

main :: proc() {
    fmt.println("---- Odin YAML Example Tags ----")

    arena: runtime.Arena
    arena_alloc := runtime.arena_allocator(&arena)

    doc, err := yaml.decode("example/tags.yaml", arena_alloc)
    if err != .None {
        fmt.eprintfln("---- Decode Error: {}", err)
        os.exit(1)
    }

    fmt.println("---- Parsing Done\n")

    m := doc.(yaml.Mapping)

    for key, value in m {
        fmt.printfln("{} = {}", key, value)
    }
}
