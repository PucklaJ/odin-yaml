package yaml

import "base:runtime"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

Mapping :: map[string]Value
Sequence :: []Value

ErrorType :: enum {
    None,
    IO,
    Init,
    Parse,
    Memory,
}

ErrorLocation :: struct {
    line:   int,
    column: int,
}

Error :: struct {
    type: ErrorType,
    loc:  ErrorLocation,
}

Value :: union {
    i64,
    f64,
    bool,
    string,
    Sequence,
    Mapping,
}

decode_from_file :: proc(
    file_name: string,
    allocator := context.allocator,
) -> (
    v: Value,
    err: Maybe(Error),
) {
    data, ok := os.read_entire_file(file_name)
    if !ok do return v, Error{type = .IO}
    defer delete(data)
    return decode_from_bytes(data, allocator)
}

decode_from_bytes :: proc(
    data: []u8,
    allocator := context.allocator,
) -> (
    v: Value,
    err: Maybe(Error),
) {
    parser: parser
    if parser_initialize(&parser) == 0 {
        err = Error {
            type = .Init,
        }
        return
    }
    defer parser_delete(&parser)

    parser_set_input_string(&parser, raw_data(data), u64(len(data)))

    e: event
    aliases: Mapping
    document_started: bool

    event_loop: for parser_parse(&parser, &e) != 0 {
        if !document_started {
            defer event_delete(&e)

            #partial switch e.type {
            case .DOCUMENT_START_EVENT:
                document_started = true
            case .STREAM_END_EVENT:
                break event_loop
            }
            continue
        }

        switch e.type {
        case .STREAM_START_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .STREAM_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .DOCUMENT_START_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .DOCUMENT_END_EVENT:
            event_delete(&e)
            break event_loop
        case .MAPPING_START_EVENT:
            if v != nil {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(&e)
                return
            }


            anchor := anchor_to_string(e.data.mapping_start.anchor)
            event_delete(&e)
            m := decode_mapping(&parser, &e, &aliases, allocator) or_return
            if anchor != nil do aliases[anchor.?] = m

            v = m
        case .MAPPING_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .SEQUENCE_START_EVENT:
            if v != nil {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(&e)
                return
            }

            anchor := anchor_to_string(e.data.sequence_start.anchor)
            event_delete(&e)
            seq := decode_sequence(&parser, &e, &aliases, allocator) or_return
            if anchor != nil do aliases[anchor.?] = seq

            v = seq
        case .SEQUENCE_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .SCALAR_EVENT:
            if v != nil {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(&e)
                return
            }

            anchor := anchor_to_string(e.data.scalar.anchor)
            s := decode_scalar(e, allocator) or_return
            event_delete(&e)
            if anchor != nil do aliases[anchor.?] = s

            v = s
        case .ALIAS_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(&e)
            return
        case .NO_EVENT:
            event_delete(&e)
        }
    }

    alias_keys, mem_err := slice.map_keys(aliases)
    if mem_err != .None do return v, Error{type = .Memory, loc = {line = int(e.start_mark.line), column = int(e.start_mark.column)}}

    for key in alias_keys {
        delete(key)
    }
    delete(alias_keys)
    delete(aliases)

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
    err: Maybe(Error),
) {
    is_value: bool
    mem_err: runtime.Allocator_Error
    current_key: string

    m = make(Mapping, allocator = allocator)

    event_loop: for parser_parse(parser, e) != 0 {
        switch e.type {
        case .STREAM_START_EVENT,
             .STREAM_END_EVENT,
             .DOCUMENT_START_EVENT,
             .DOCUMENT_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(e)
            return
        case .MAPPING_START_EVENT:
            if !is_value {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(e)
                return
            }

            anchor := anchor_to_string(e.data.mapping_start.anchor)
            event_delete(e)
            sub_m := decode_mapping(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = sub_m

            // TODO: support merge keys with literal mappings
            m[current_key] = sub_m

            is_value = false
        case .MAPPING_END_EVENT:
            event_delete(e)
            return
        case .SEQUENCE_START_EVENT:
            if !is_value {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(e)
                return
            }

            anchor := anchor_to_string(e.data.sequence_start.anchor)
            event_delete(e)
            seq := decode_sequence(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = seq

            m[current_key] = seq

            is_value = false
        case .SEQUENCE_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(e)
            return
        case .ALIAS_EVENT:
            if !is_value {
                err = Error {
                    type = .Parse,
                    loc = {
                        line = int(e.start_mark.line),
                        column = int(e.start_mark.column),
                    },
                }
                event_delete(e)
                return
            }

            v, ok := decode_alias(e^, aliases)
            event_delete(e)
            if !ok do return m, Error{type = .Parse, loc = {line = int(e.start_mark.line), column = int(e.start_mark.column)}}

            if current_key == "<<" {
                delete(current_key, allocator)

                if sub_m, ok_m := v.(Mapping); !ok_m {
                    err = Error {
                        type = .Parse,
                        loc = {
                            line = int(e.start_mark.line),
                            column = int(e.start_mark.column),
                        },
                    }
                    return
                } else {
                    for key, value in sub_m {
                        m[key] = value
                    }
                    delete(sub_m)
                }
            } else {
                m[current_key] = v
            }

            is_value = false
        case .SCALAR_EVENT:
            if !is_value {
                defer event_delete(e)

                current_key, mem_err = strings.clone_from_cstring_bounded(
                    e.data.scalar.value,
                    int(e.data.scalar.length),
                    allocator,
                )
                if mem_err != .None {
                    err = Error {
                        type = .Memory,
                        loc = {
                            line = int(e.start_mark.line),
                            column = int(e.start_mark.column),
                        },
                    }
                    return
                }
            } else {
                anchor := anchor_to_string(e.data.scalar.anchor)
                current_value := decode_scalar(e^, allocator) or_return
                event_delete(e)
                if anchor != nil do aliases^[anchor.?] = current_value

                m[current_key] = current_value
            }

            is_value = !is_value
        case .NO_EVENT:
            event_delete(e)
        }
    }

    // No Mapping End encountered
    err = Error {
        type = .Parse,
        loc = {
            line = int(e.start_mark.line),
            column = int(e.start_mark.column),
        },
    }
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
    err: Maybe(Error),
) {
    seq := make([dynamic]Value, allocator)

    event_loop: for parser_parse(parser, e) != 0 {
        switch e.type {
        case .STREAM_START_EVENT,
             .STREAM_END_EVENT,
             .DOCUMENT_START_EVENT,
             .DOCUMENT_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(e)
            return
        case .MAPPING_START_EVENT:
            anchor := anchor_to_string(e.data.mapping_start.anchor)
            event_delete(e)
            m := decode_mapping(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = m

            append(&seq, m)
        case .MAPPING_END_EVENT:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            event_delete(e)
            return
        case .SEQUENCE_START_EVENT:
            anchor := anchor_to_string(e.data.sequence_start.anchor)
            event_delete(e)
            sub_seq := decode_sequence(parser, e, aliases, allocator) or_return
            if anchor != nil do aliases^[anchor.?] = sub_seq

            append(&seq, sub_seq)
        case .SEQUENCE_END_EVENT:
            _seq = seq[:]
            event_delete(e)
            return
        case .ALIAS_EVENT:
            v, ok := decode_alias(e^, aliases)
            event_delete(e)
            if !ok do return _seq, Error{type = .Parse, loc = {line = int(e.start_mark.line), column = int(e.start_mark.column)}}
            append(&seq, v)
        case .SCALAR_EVENT:
            anchor := anchor_to_string(e.data.scalar.anchor)
            s := decode_scalar(e^, allocator) or_return
            event_delete(e)
            if anchor != nil do aliases^[anchor.?] = s

            append(&seq, s)
        case .NO_EVENT:
        }
    }

    // No Sequence End encountered
    err = Error {
        type = .Parse,
        loc = {
            line = int(e.start_mark.line),
            column = int(e.start_mark.column),
        },
    }
    return
}

@(private = "file")
decode_scalar :: proc(
    e: event,
    allocator: runtime.Allocator,
) -> (
    v: Value,
    err: Maybe(Error),
) {
    value := strings.string_from_ptr(
        cast(^u8)e.data.scalar.value,
        int(e.data.scalar.length),
    )

    tag := e.data.scalar.tag

    switch tag {
    case "!!int":
        if value_i64, ok := strconv.parse_i64(value); ok {
            v = value_i64
        } else {
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            return
        }
    case "!!float":
        if value_f64, ok := strconv.parse_f64(value); ok {
            v = value_f64
        } else {
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            return
        }
    case "!!bool":
        switch value {
        case "true", "True", "TRUE", "yes", "Yes", "YES", "on", "On", "ON":
            v = true
        case "false", "False", "FALSE", "no", "No", "NO", "off", "Off", "OFF":
            v = false
        case:
            err = Error {
                type = .Parse,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            return
        }
    case "!!str":
        mem_err: runtime.Allocator_Error = ---
        v, mem_err = strings.clone(value, allocator)
        if mem_err != .None {
            err = Error {
                type = .Memory,
                loc = {
                    line = int(e.start_mark.line),
                    column = int(e.start_mark.column),
                },
            }
            return
        }
    case "!!null":
    case:
        if len(value) == 0 do break

        if value_i64, ok_i64 := strconv.parse_i64(value); ok_i64 {
            v = value_i64
        } else if value_f64, ok_f64 := strconv.parse_f64(value); ok_f64 {
            v = value_f64
        } else {
            switch value {
            case "true", "True", "TRUE", "yes", "Yes", "YES", "on", "On", "ON":
                v = true
            case "false",
                 "False",
                 "FALSE",
                 "no",
                 "No",
                 "NO",
                 "off",
                 "Off",
                 "OFF":
                v = false
            case "~", "null":
            case:
                mem_err: runtime.Allocator_Error = ---
                v, mem_err = strings.clone(value, allocator)
                if mem_err != .None {
                    err = Error {
                        type = .Memory,
                        loc = {
                            line = int(e.start_mark.line),
                            column = int(e.start_mark.column),
                        },
                    }
                    return
                }
            }
        }
    }


    return
}

@(private = "file")
decode_alias :: proc(e: event, aliases: ^Mapping) -> (v: Value, ok: bool) {
    alias := strings.string_from_null_terminated_ptr(
        cast(^u8)e.data.alias.anchor,
        1024,
    )

    v, ok = aliases^[alias]
    return
}

@(private = "file")
anchor_to_string :: #force_inline proc(anchor: cstring) -> Maybe(string) {
    if anchor != nil {
        alias := strings.clone_from_cstring(anchor)
        return alias
    }

    return nil
}

error_string :: proc(
    err: Maybe(Error),
    file_name: string = "yaml",
    allocator := context.allocator,
) -> string {
    b: strings.Builder
    strings.builder_init(&b, allocator)

    if e, ok := err.?; ok {
        strings.write_string(&b, file_name)
        strings.write_rune(&b, ':')
        strings.write_int(&b, e.loc.line + 1)
        strings.write_rune(&b, ':')
        strings.write_int(&b, e.loc.column + 1)
        strings.write_string(&b, ": ")

        switch e.type {
        case .Init:
            strings.write_string(&b, "error while initializing libyaml")
        case .IO:
            strings.write_string(&b, "io error")
        case .Memory:
            strings.write_string(&b, "memory allocation error")
        case .None:
            strings.write_string(&b, "success")
        case .Parse:
            strings.write_string(&b, "parse error")
        }
    } else {
        strings.write_string(&b, "None")
    }

    return strings.to_string(b)
}
