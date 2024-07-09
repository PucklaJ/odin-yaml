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
    test_2 := m["test-2"].(yaml.Sequence)
    list_of_items := m["list_of_items"].(yaml.Sequence)

    defaults := test_1["defaults"].(yaml.Mapping)
    development := test_1["development"].(yaml.Mapping)
    test := test_1["test"].(yaml.Mapping)

    fmt.printfln("test-1.defaults.adapter = \"{}\"", defaults["adapter"])
    fmt.printfln("test-1.defaults.host = \"{}\"", defaults["host"])

    fmt.printfln(
        "test-1.development.database = \"{}\"",
        development["database"],
    )
    fmt.printfln("test-1.development.adapter = \"{}\"", development["adapter"])
    fmt.printfln("test-1.development.host = \"{}\"", development["host"])

    fmt.printfln("test-1.test.database = \"{}\"", test["database"])
    fmt.printfln("test-1.test.adapter = \"{}\"", test["adapter"])
    fmt.printfln("test-1.test.host = \"{}\"", test["host"])

    for item, idx in test_2 {
        fmt.printfln("test-2[{}] = {}", idx, item)
    }

    for item, idx in list_of_items {
        fmt.printfln("list_of_items[{}] = {}", idx, item)
    }
}
