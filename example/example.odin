package main

import yaml ".."
import "base:runtime"
import "core:fmt"
import "core:os"

main :: proc() {
    fmt.println("---- Odin YAML Example ----")

    arena: runtime.Arena
    arena_alloc := runtime.arena_allocator(&arena)

    doc, err := yaml.decode("example/example.yaml", arena_alloc)
    if err != nil {
        fmt.eprintfln(
            "---- {}",
            yaml.error_string(err, "example/example.yaml"),
        )
        os.exit(1)
    }

    fmt.println("---- Parsing Done\n")

    m := doc.(yaml.Mapping)

    fmt.printfln("age = {}", m["age"])
    fmt.printfln("salary = {}", m["salary"])
    fmt.printfln("message = \"{}\"", m["message"])

    employees := m["employees"].(yaml.Sequence)

    for employee, idx in employees {
        e := employee.(yaml.Mapping)
        fmt.printfln("employee[{}].age = {}", idx, e["age"])
        fmt.printfln("employee[{}].salary = {}", idx, e["salary"])
        fmt.printfln("employee[{}].message = \"{}\"", idx, e["message"])
    }

    inventory := m["inventory"].(yaml.Sequence)

    for item, idx in inventory {
        fmt.printfln("inventory[{}] = {}", idx, item)
    }

    father := m["father"].(yaml.Mapping)

    fmt.printfln("father.age = {}", father["age"])
    fmt.printfln("father.salary = {}", father["salary"])
    fmt.printfln("father.message = \"{}\"", father["message"])

    runtime.arena_destroy(&arena)
}
