package yaml

import "base:runtime"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Mapping :: map[string]Value
Sequence :: []Value

Error :: enum {
    None,
    IO,
    Parse,
    Memory,
    Unknown,
}

Value :: union {
    i64,
    f64,
    string,
    Sequence,
    Mapping,
}

decode_from_file :: proc(
    file_name: string,
    allocator := context.allocator,
) -> (
    v: Value,
    err: Error,
) {
    data, ok := os.read_entire_file(file_name)
    if !ok do return v, .IO
    defer delete(data)
    return decode_from_bytes(data, allocator)
}

decode_from_bytes :: proc(
    data: []u8,
    allocator := context.allocator,
) -> (
    v: Value,
    err: Error,
) {
    parser: parser
    if parser_initialize(&parser) == 0 {
        err = .Parse
        return
    }
    defer parser_delete(&parser)

    parser_set_input_string(&parser, raw_data(data), u64(len(data)))

    // TODO: deallocation of event
    e: event
    aliases: Mapping
    defer delete(aliases)

    event_loop: for parser_parse(&parser, &e) != 0 {
        fmt.printfln("---- Event: {}", e.type)

        switch e.type {
        case .STREAM_START_EVENT:
        case .STREAM_END_EVENT:
            break event_loop
        case .DOCUMENT_START_EVENT:
        case .DOCUMENT_END_EVENT:
        case .MAPPING_START_EVENT:
            if v != nil {
                err = .Parse
                return
            }


            anchor := anchor_to_string(e.data.mapping_start.anchor)
            m := decode_mapping(&parser, &e, &aliases, allocator) or_return
            if anchor != nil do aliases[anchor.?] = m

            v = m
        case .MAPPING_END_EVENT:
            err = .Parse
            return
        case .SEQUENCE_START_EVENT:
            if v != nil {
                err = .Parse
                return
            }

            anchor := anchor_to_string(e.data.sequence_start.anchor)
            seq := decode_sequence(&parser, &e, &aliases, allocator) or_return
            if anchor != nil do aliases[anchor.?] = seq

            v = seq
        case .SEQUENCE_END_EVENT:
            err = .Parse
            return
        case .SCALAR_EVENT:
            if v != nil {
                err = .Parse
                return
            }

            anchor := anchor_to_string(e.data.scalar.anchor)
            s := decode_scalar(e, allocator) or_return
            if anchor != nil do aliases[anchor.?] = s

            v = s
        case .ALIAS_EVENT:
            fmt.println("---- Alias on highest level")
            err = .Parse
            return
        case .NO_EVENT:
        }
    }

    fmt.printfln("Aliases: {}", slice.map_keys(aliases))

    return
}

decode :: proc {
    decode_from_file,
    decode_from_bytes,
}

@(private = "file")
decode_mapping :: proc(
    parser: ^parser,
    e: ^event,
    aliases: ^Mapping,
    allocator: runtime.Allocator,
) -> (
    m: Mapping,
    err: Error,
) {
    fmt.println("----- Parsing Mapping ...")

    is_value: bool
    mem_err: runtime.Allocator_Error
    current_key: string

    m = make(Mapping, allocator = allocator)

    event_loop: for parser_parse(parser, e) != 0 {
        fmt.printfln("---- Event {}", e.type)

        switch e.type {
        case .STREAM_START_EVENT, .STREAM_END_EVENT, .DOCUMENT_START_EVENT, .DOCUMENT_END_EVENT:
            err = .Parse
            return
        case .MAPPING_START_EVENT:
            if !is_value {
                err = .Parse
                return
            }

            anchor := anchor_to_string(e.data.mapping_start.anchor)
            sub_m := decode_mapping(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = sub_m

            fmt.printfln("----- Mapping \"{}\": {}", current_key, len(sub_m))
            m[current_key] = sub_m

            is_value = false
        case .MAPPING_END_EVENT:
            return
        case .SEQUENCE_START_EVENT:
            if !is_value {
                err = .Parse
                return
            }

            anchor := anchor_to_string(e.data.sequence_start.anchor)
            seq := decode_sequence(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = seq

            fmt.printfln("----- Mapping \"{}\": {}", current_key, len(seq))
            m[current_key] = seq

            is_value = false
        case .SEQUENCE_END_EVENT:
            err = .Parse
            return
        case .ALIAS_EVENT:
            if !is_value {
                err = .Parse
                return
            }

            v, ok := decode_alias(e^, aliases)
            if !ok do return m, .Parse
            m[current_key] = v

            is_value = false
        case .SCALAR_EVENT:
            if !is_value {
                current_key, mem_err = strings.clone_from_cstring_bounded(
                    e.data.scalar.value,
                    int(e.data.scalar.length),
                    allocator,
                )
                if mem_err != .None {
                    err = .Memory
                    return
                }

                fmt.printfln("----- Key {}", current_key)
            } else {
                anchor := anchor_to_string(e.data.scalar.anchor)
                current_value := decode_scalar(e^, allocator) or_return
                if anchor != nil do aliases^[anchor.?] = current_value

                fmt.printfln(
                    "----- Mapping \"{}\" = \"{}\"",
                    current_key,
                    current_value,
                )

                m[current_key] = current_value
            }

            is_value = !is_value
        case .NO_EVENT:
        }
    }

    // No Mapping End encountered
    err = .Parse
    return
}

@(private = "file")
decode_sequence :: proc(
    parser: ^parser,
    e: ^event,
    aliases: ^Mapping,
    allocator: runtime.Allocator,
) -> (
    _seq: Sequence,
    err: Error,
) {
    fmt.println("----- Parsing Sequence ...")

    seq := make([dynamic]Value, allocator)

    event_loop: for parser_parse(parser, e) != 0 {
        fmt.printfln("---- Event {}", e.type)

        switch e.type {
        case .STREAM_START_EVENT:
        case .STREAM_END_EVENT:
            break event_loop
        case .DOCUMENT_START_EVENT:
        case .DOCUMENT_END_EVENT:
        case .MAPPING_START_EVENT:
            anchor := anchor_to_string(e.data.mapping_start.anchor)
            m := decode_mapping(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = m

            fmt.printfln("----- Sequence Element {}", len(m))
            append(&seq, m)
        case .MAPPING_END_EVENT:
            err = .Parse
            return
        case .SEQUENCE_START_EVENT:
            anchor := anchor_to_string(e.data.sequence_start.anchor)
            sub_seq := decode_sequence(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = sub_seq

            fmt.printfln("----- Sequence Element {}", len(sub_seq))
            append(&seq, sub_seq)
        case .SEQUENCE_END_EVENT:
            _seq = seq[:]
            return
        case .ALIAS_EVENT:
            v, ok := decode_alias(e^, aliases)
            if !ok do return _seq, .Parse
            append(&seq, v)
        case .SCALAR_EVENT:
            anchor := anchor_to_string(e.data.scalar.anchor)
            s := decode_scalar(e^, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = s

            fmt.printfln("----- Sequence Element {}", s)
            append(&seq, s)
        case .NO_EVENT:
        }
    }

    // No Sequence End encountered
    err = .Parse
    return
}

@(private = "file")
decode_scalar :: proc(
    e: event,
    allocator: runtime.Allocator,
) -> (
    v: Value,
    err: Error,
) {
    value := strings.string_from_ptr(
        cast(^u8)e.data.scalar.value,
        int(e.data.scalar.length),
    )

    if value_i64, ok_i64 := strconv.parse_i64(value); ok_i64 {
        v = value_i64
    } else if value_f64, ok_f64 := strconv.parse_f64(value); ok_f64 {
        v = value_f64
    } else {
        mem_err: runtime.Allocator_Error = ---
        v, mem_err = strings.clone(value, allocator)
        if mem_err != .None {
            err = .Memory
            return
        }
    }

    fmt.printfln("----- Scalar {}", v)

    return
}

@(private = "file")
decode_alias :: proc(e: event, aliases: ^Mapping) -> (v: Value, ok: bool) {
    alias := strings.string_from_null_terminated_ptr(
        cast(^u8)e.data.alias.anchor,
        1024,
    )

    fmt.printfln("----- Alias {}", alias)

    v, ok = aliases^[alias]
    return
}

@(private = "file")
anchor_to_string :: #force_inline proc(anchor: cstring) -> Maybe(string) {
    if anchor != nil {
        alias := strings.clone_from_cstring(anchor)
        fmt.printfln("----- Anchor {}", alias)
        return alias
    }

    return nil
}
