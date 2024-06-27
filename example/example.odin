package main

import yaml ".."
import "core:fmt"
import "core:os"

main :: proc() {
	fmt.println("---- Odin YAML Example ----")

	parser: yaml.parser_t
	if yaml.parser_initialize(&parser) == 0 {
		fmt.eprintln("failed to init parser")
		os.exit(1)
	}
	defer yaml.parser_delete(&parser)

	data, ok := os.read_entire_file("example/example.yaml")
	if !ok {
		fmt.eprintln("failed to read file")
		os.exit(1)
	}

	yaml.parser_set_input_string(&parser, raw_data(data), u64(len(data)))

	event: yaml.event_t

	fmt.println("---- Parsing ...")
	for yaml.parser_parse(&parser, &event) != 0 {
		fmt.printfln("---- Event: {}", event)
		if event.type == .NO_EVENT {
			break
		}
	}
	fmt.println("---- Parsing Done ----")
}

