package yaml

import "base:runtime"
import "core:fmt"
import "core:os"
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

            m := decode_mapping(&parser, &e, allocator) or_return
            v = m
        case .MAPPING_END_EVENT:
            err = .Parse
            return
        case .SEQUENCE_START_EVENT:
            if v != nil {
                err = .Parse
                return
            }

            seq := decode_sequence(&parser, &e, allocator) or_return
            v = seq
        case .SEQUENCE_END_EVENT:
            err = .Parse
            return
        case .SCALAR_EVENT:
            if v != nil {
                err = .Parse
                return
            }

            s := decode_scalar(e, allocator) or_return
            v = s
        case .ALIAS_EVENT:
            err = .Unknown
            return
        case .NO_EVENT:
            err = .Unknown
            return
        }
    }

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

            sub_m := decode_mapping(parser, e, allocator) or_return
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

            seq := decode_sequence(parser, e, allocator) or_return
            fmt.printfln("----- Mapping \"{}\": {}", current_key, len(seq))
            m[current_key] = seq

            is_value = false
        case .SEQUENCE_END_EVENT:
        case .ALIAS_EVENT:
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
            } else {
                current_value := decode_scalar(e^, allocator) or_return

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
            m := decode_mapping(parser, e, allocator) or_return
            fmt.printfln("----- Sequence Element {}", len(m))
            append(&seq, m)
        case .MAPPING_END_EVENT:
        case .SEQUENCE_START_EVENT:
            sub_seq := decode_sequence(parser, e, allocator) or_return
            fmt.printfln("----- Sequence Element {}", len(sub_seq))
            append(&seq, sub_seq)
        case .SEQUENCE_END_EVENT:
            _seq = seq[:]
            return
        case .ALIAS_EVENT:
        case .SCALAR_EVENT:
            s := decode_scalar(e^, allocator) or_return
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
