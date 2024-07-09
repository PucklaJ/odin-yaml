package main

import yaml ".."
import "base:runtime"
import "core:fmt"
import "core:os"

main :: proc() {
    fmt.println("---- Odin YAML Example Alias ----")

    arena: runtime.Arena
    arena_alloc := runtime.arena_allocator(&arena)

    doc, err := yaml.decode("example/alias.yaml", arena_alloc)
    if err != .None {
        fmt.eprintfln("---- Decode Error: {}", err)
        os.exit(1)
    }

    fmt.println("---- Parsing Done\n")

    m := doc.(yaml.Mapping)

    test_1 := m["test-1"].(yaml.Mapping)

    defaults := test_1["defaults"].(yaml.Mapping)

    fmt.printfln("test-1.defaults.adapter = \"{}\"", defaults["adapter"])
}
