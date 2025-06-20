#+build linux amd64, linux arm64, linux i386, linux arm32, windows amd64, windows arm64, windows i386, windows arm32, darwin amd64, darwin arm64, darwin i386, darwin arm32, freebsd amd64, openbsd amd64, netbsd amd64, freebsd arm64, openbsd arm64, netbsd arm64, freebsd i386, openbsd i386, netbsd i386, freebsd arm32, openbsd arm32, netbsd arm32
package yaml

import "core:c/libc"

NULL_TAG :: "tag:yaml.org,2002:null"
BOOL_TAG :: "tag:yaml.org,2002:bool"
STR_TAG :: "tag:yaml.org,2002:str"
INT_TAG :: "tag:yaml.org,2002:int"
FLOAT_TAG :: "tag:yaml.org,2002:float"
TIMESTAMP_TAG :: "tag:yaml.org,2002:timestamp"
SEQ_TAG :: "tag:yaml.org,2002:seq"
MAP_TAG :: "tag:yaml.org,2002:map"
DEFAULT_SCALAR_TAG :: "tag:yaml.org,2002:str"
DEFAULT_SEQUENCE_TAG :: "tag:yaml.org,2002:seq"
DEFAULT_MAPPING_TAG :: "tag:yaml.org,2002:map"

char :: u8
version_directive_s :: struct {
    major: i32,
    minor: i32,
}
version_directive :: version_directive_s
tag_directive_s :: struct {
    handle: cstring,
    prefix: cstring,
}
tag_directive :: tag_directive_s
encoding_e :: enum u32 {ANY_ENCODING = 0, UTF8_ENCODING = 1, UTF16LE_ENCODING = 2, UTF16BE_ENCODING = 3 }
encoding :: encoding_e
break_e :: enum u32 {ANY_BREAK = 0, CR_BREAK = 1, LN_BREAK = 2, CRLN_BREAK = 3 }
break_ :: break_e
error_type_e :: enum u32 {NO_ERROR = 0, MEMORY_ERROR = 1, READER_ERROR = 2, SCANNER_ERROR = 3, PARSER_ERROR = 4, COMPOSER_ERROR = 5, WRITER_ERROR = 6, EMITTER_ERROR = 7 }
error_type :: error_type_e
mark_s :: struct {
    index: uint,
    line: uint,
    column: uint,
}
mark :: mark_s
scalar_style_e :: enum u32 {ANY_SCALAR_STYLE = 0, PLAIN_SCALAR_STYLE = 1, SINGLE_QUOTED_SCALAR_STYLE = 2, DOUBLE_QUOTED_SCALAR_STYLE = 3, LITERAL_SCALAR_STYLE = 4, FOLDED_SCALAR_STYLE = 5 }
scalar_style :: scalar_style_e
sequence_style_e :: enum u32 {ANY_SEQUENCE_STYLE = 0, BLOCK_SEQUENCE_STYLE = 1, FLOW_SEQUENCE_STYLE = 2 }
sequence_style :: sequence_style_e
mapping_style_e :: enum u32 {ANY_MAPPING_STYLE = 0, BLOCK_MAPPING_STYLE = 1, FLOW_MAPPING_STYLE = 2 }
mapping_style :: mapping_style_e
token_type_e :: enum u32 {NO_TOKEN = 0, STREAM_START_TOKEN = 1, STREAM_END_TOKEN = 2, VERSION_DIRECTIVE_TOKEN = 3, TAG_DIRECTIVE_TOKEN = 4, DOCUMENT_START_TOKEN = 5, DOCUMENT_END_TOKEN = 6, BLOCK_SEQUENCE_START_TOKEN = 7, BLOCK_MAPPING_START_TOKEN = 8, BLOCK_END_TOKEN = 9, FLOW_SEQUENCE_START_TOKEN = 10, FLOW_SEQUENCE_END_TOKEN = 11, FLOW_MAPPING_START_TOKEN = 12, FLOW_MAPPING_END_TOKEN = 13, BLOCK_ENTRY_TOKEN = 14, FLOW_ENTRY_TOKEN = 15, KEY_TOKEN = 16, VALUE_TOKEN = 17, ALIAS_TOKEN = 18, ANCHOR_TOKEN = 19, TAG_TOKEN = 20, SCALAR_TOKEN = 21 }
token_type :: token_type_e
stream_start_struct_anon_0 :: struct {
    encoding_m: encoding,
}
alias_struct_anon_1 :: struct {
    value: cstring,
}
anchor_struct_anon_2 :: struct {
    value: cstring,
}
tag_struct_anon_3 :: struct {
    handle: cstring,
    suffix: cstring,
}
scalar_struct_anon_4 :: struct {
    value: cstring,
    length: uint,
    style: scalar_style,
}
version_directive_struct_anon_5 :: struct {
    major: i32,
    minor: i32,
}
tag_directive_struct_anon_6 :: struct {
    handle: cstring,
    prefix: cstring,
}
data_union_anon_7 :: struct #raw_union {
    stream_start: stream_start_struct_anon_0,
    alias: alias_struct_anon_1,
    anchor: anchor_struct_anon_2,
    tag: tag_struct_anon_3,
    scalar: scalar_struct_anon_4,
    version_directive_m: version_directive_struct_anon_5,
    tag_directive_m: tag_directive_struct_anon_6,
}
token_s :: struct {
    type: token_type,
    data: data_union_anon_7,
    start_mark: mark,
    end_mark: mark,
}
token :: token_s
event_type_e :: enum u32 {NO_EVENT = 0, STREAM_START_EVENT = 1, STREAM_END_EVENT = 2, DOCUMENT_START_EVENT = 3, DOCUMENT_END_EVENT = 4, ALIAS_EVENT = 5, SCALAR_EVENT = 6, SEQUENCE_START_EVENT = 7, SEQUENCE_END_EVENT = 8, MAPPING_START_EVENT = 9, MAPPING_END_EVENT = 10 }
event_type :: event_type_e
stream_start_struct_anon_8 :: struct {
    encoding_m: encoding,
}
tag_directives_struct_anon_9 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
}
document_start_struct_anon_10 :: struct {
    version_directive_m: ^version_directive,
    tag_directives: tag_directives_struct_anon_9,
    implicit: i32,
}
document_end_struct_anon_11 :: struct {
    implicit: i32,
}
alias_struct_anon_12 :: struct {
    anchor: cstring,
}
scalar_struct_anon_13 :: struct {
    anchor: cstring,
    tag: cstring,
    value: cstring,
    length: uint,
    plain_implicit: i32,
    quoted_implicit: i32,
    style: scalar_style,
}
sequence_start_struct_anon_14 :: struct {
    anchor: cstring,
    tag: cstring,
    implicit: i32,
    style: sequence_style,
}
mapping_start_struct_anon_15 :: struct {
    anchor: cstring,
    tag: cstring,
    implicit: i32,
    style: mapping_style,
}
data_union_anon_16 :: struct #raw_union {
    stream_start: stream_start_struct_anon_8,
    document_start: document_start_struct_anon_10,
    document_end: document_end_struct_anon_11,
    alias: alias_struct_anon_12,
    scalar: scalar_struct_anon_13,
    sequence_start: sequence_start_struct_anon_14,
    mapping_start: mapping_start_struct_anon_15,
}
event_s :: struct {
    type: event_type,
    data: data_union_anon_16,
    start_mark: mark,
    end_mark: mark,
}
event :: event_s
node_type_e :: enum u32 {NO_NODE = 0, SCALAR_NODE = 1, SEQUENCE_NODE = 2, MAPPING_NODE = 3 }
node_type :: node_type_e
scalar_struct_anon_17 :: struct {
    value: cstring,
    length: uint,
    style: scalar_style,
}
node_item :: i32
items_struct_anon_18 :: struct {
    start: ^node_item,
    end: ^node_item,
    top: ^node_item,
}
sequence_struct_anon_19 :: struct {
    items: items_struct_anon_18,
    style: sequence_style,
}
node_pair_s :: struct {
    key: i32,
    value: i32,
}
node_pair :: node_pair_s
pairs_struct_anon_20 :: struct {
    start: ^node_pair,
    end: ^node_pair,
    top: ^node_pair,
}
mapping_struct_anon_21 :: struct {
    pairs: pairs_struct_anon_20,
    style: mapping_style,
}
data_union_anon_22 :: struct #raw_union {
    scalar: scalar_struct_anon_17,
    sequence: sequence_struct_anon_19,
    mapping: mapping_struct_anon_21,
}
node_s :: struct {
    type: node_type,
    tag: cstring,
    data: data_union_anon_22,
    start_mark: mark,
    end_mark: mark,
}
node :: node_s
nodes_struct_anon_23 :: struct {
    start: ^node,
    end: ^node,
    top: ^node,
}
tag_directives_struct_anon_24 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
}
document_s :: struct {
    nodes: nodes_struct_anon_23,
    version_directive_m: ^version_directive,
    tag_directives: tag_directives_struct_anon_24,
    start_implicit: i32,
    end_implicit: i32,
    start_mark: mark,
    end_mark: mark,
}
document :: document_s
read_handler :: #type proc "c" (data: rawptr, buffer: ^u8, size: uint, size_read: ^uint) -> i32
simple_key_s :: struct {
    possible: i32,
    required: i32,
    token_number: uint,
    mark_m: mark,
}
simple_key :: simple_key_s
parser_state_e :: enum u32 {PARSE_STREAM_START_STATE = 0, PARSE_IMPLICIT_DOCUMENT_START_STATE = 1, PARSE_DOCUMENT_START_STATE = 2, PARSE_DOCUMENT_CONTENT_STATE = 3, PARSE_DOCUMENT_END_STATE = 4, PARSE_BLOCK_NODE_STATE = 5, PARSE_BLOCK_NODE_OR_INDENTLESS_SEQUENCE_STATE = 6, PARSE_FLOW_NODE_STATE = 7, PARSE_BLOCK_SEQUENCE_FIRST_ENTRY_STATE = 8, PARSE_BLOCK_SEQUENCE_ENTRY_STATE = 9, PARSE_INDENTLESS_SEQUENCE_ENTRY_STATE = 10, PARSE_BLOCK_MAPPING_FIRST_KEY_STATE = 11, PARSE_BLOCK_MAPPING_KEY_STATE = 12, PARSE_BLOCK_MAPPING_VALUE_STATE = 13, PARSE_FLOW_SEQUENCE_FIRST_ENTRY_STATE = 14, PARSE_FLOW_SEQUENCE_ENTRY_STATE = 15, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_KEY_STATE = 16, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_VALUE_STATE = 17, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_END_STATE = 18, PARSE_FLOW_MAPPING_FIRST_KEY_STATE = 19, PARSE_FLOW_MAPPING_KEY_STATE = 20, PARSE_FLOW_MAPPING_VALUE_STATE = 21, PARSE_FLOW_MAPPING_EMPTY_VALUE_STATE = 22, PARSE_END_STATE = 23 }
parser_state :: parser_state_e
alias_data_s :: struct {
    anchor: cstring,
    index: i32,
    mark_m: mark,
}
alias_data :: alias_data_s
string_struct_anon_25 :: struct {
    start: ^u8,
    end: ^u8,
    current: ^u8,
}
input_union_anon_26 :: struct #raw_union {
    string_m: string_struct_anon_25,
    file: ^libc.FILE,
}
buffer_struct_anon_27 :: struct {
    start: cstring,
    end: cstring,
    pointer: cstring,
    last: cstring,
}
raw_buffer_struct_anon_28 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
tokens_struct_anon_29 :: struct {
    start: ^token,
    end: ^token,
    head: ^token,
    tail: ^token,
}
indents_struct_anon_30 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
simple_keys_struct_anon_31 :: struct {
    start: ^simple_key,
    end: ^simple_key,
    top: ^simple_key,
}
states_struct_anon_32 :: struct {
    start: ^parser_state,
    end: ^parser_state,
    top: ^parser_state,
}
marks_struct_anon_33 :: struct {
    start: ^mark,
    end: ^mark,
    top: ^mark,
}
tag_directives_struct_anon_34 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
    top: ^tag_directive,
}
aliases_struct_anon_35 :: struct {
    start: ^alias_data,
    end: ^alias_data,
    top: ^alias_data,
}
parser_s :: struct {
    error: error_type,
    problem: cstring,
    problem_offset: uint,
    problem_value: i32,
    problem_mark: mark,
    context_m: cstring,
    context_mark: mark,
    read_handler_m: ^read_handler,
    read_handler_data: rawptr,
    input: input_union_anon_26,
    eof: i32,
    buffer: buffer_struct_anon_27,
    unread: uint,
    raw_buffer: raw_buffer_struct_anon_28,
    encoding_m: encoding,
    offset: uint,
    mark_m: mark,
    stream_start_produced: i32,
    stream_end_produced: i32,
    flow_level: i32,
    tokens: tokens_struct_anon_29,
    tokens_parsed: uint,
    token_available: i32,
    indents: indents_struct_anon_30,
    indent: i32,
    simple_key_allowed: i32,
    simple_keys: simple_keys_struct_anon_31,
    states: states_struct_anon_32,
    state: parser_state,
    marks: marks_struct_anon_33,
    tag_directives: tag_directives_struct_anon_34,
    aliases: aliases_struct_anon_35,
    document_m: ^document,
}
parser :: parser_s
write_handler :: #type proc "c" (data: rawptr, buffer: ^u8, size: uint) -> i32
emitter_state_e :: enum u32 {EMIT_STREAM_START_STATE = 0, EMIT_FIRST_DOCUMENT_START_STATE = 1, EMIT_DOCUMENT_START_STATE = 2, EMIT_DOCUMENT_CONTENT_STATE = 3, EMIT_DOCUMENT_END_STATE = 4, EMIT_FLOW_SEQUENCE_FIRST_ITEM_STATE = 5, EMIT_FLOW_SEQUENCE_ITEM_STATE = 6, EMIT_FLOW_MAPPING_FIRST_KEY_STATE = 7, EMIT_FLOW_MAPPING_KEY_STATE = 8, EMIT_FLOW_MAPPING_SIMPLE_VALUE_STATE = 9, EMIT_FLOW_MAPPING_VALUE_STATE = 10, EMIT_BLOCK_SEQUENCE_FIRST_ITEM_STATE = 11, EMIT_BLOCK_SEQUENCE_ITEM_STATE = 12, EMIT_BLOCK_MAPPING_FIRST_KEY_STATE = 13, EMIT_BLOCK_MAPPING_KEY_STATE = 14, EMIT_BLOCK_MAPPING_SIMPLE_VALUE_STATE = 15, EMIT_BLOCK_MAPPING_VALUE_STATE = 16, EMIT_END_STATE = 17 }
emitter_state :: emitter_state_e
anchors_s :: struct {
    references: i32,
    anchor: i32,
    serialized: i32,
}
anchors :: anchors_s
string_struct_anon_36 :: struct {
    buffer: ^u8,
    size: uint,
    size_written: ^uint,
}
output_union_anon_37 :: struct #raw_union {
    string_m: string_struct_anon_36,
    file: ^libc.FILE,
}
buffer_struct_anon_38 :: struct {
    start: cstring,
    end: cstring,
    pointer: cstring,
    last: cstring,
}
raw_buffer_struct_anon_39 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
states_struct_anon_40 :: struct {
    start: ^emitter_state,
    end: ^emitter_state,
    top: ^emitter_state,
}
events_struct_anon_41 :: struct {
    start: ^event,
    end: ^event,
    head: ^event,
    tail: ^event,
}
indents_struct_anon_42 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
tag_directives_struct_anon_43 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
    top: ^tag_directive,
}
anchor_data_struct_anon_44 :: struct {
    anchor: cstring,
    anchor_length: uint,
    alias: i32,
}
tag_data_struct_anon_45 :: struct {
    handle: cstring,
    handle_length: uint,
    suffix: cstring,
    suffix_length: uint,
}
scalar_data_struct_anon_46 :: struct {
    value: cstring,
    length: uint,
    multiline: i32,
    flow_plain_allowed: i32,
    block_plain_allowed: i32,
    single_quoted_allowed: i32,
    block_allowed: i32,
    style: scalar_style,
}
emitter_s :: struct {
    error: error_type,
    problem: cstring,
    write_handler_m: ^write_handler,
    write_handler_data: rawptr,
    output: output_union_anon_37,
    buffer: buffer_struct_anon_38,
    raw_buffer: raw_buffer_struct_anon_39,
    encoding_m: encoding,
    canonical: i32,
    best_indent: i32,
    best_width: i32,
    unicode: i32,
    line_break: break_,
    states: states_struct_anon_40,
    state: emitter_state,
    events: events_struct_anon_41,
    indents: indents_struct_anon_42,
    tag_directives: tag_directives_struct_anon_43,
    indent: i32,
    flow_level: i32,
    root_context: i32,
    sequence_context: i32,
    mapping_context: i32,
    simple_key_context: i32,
    line: i32,
    column: i32,
    whitespace: i32,
    indention: i32,
    open_ended: i32,
    anchor_data: anchor_data_struct_anon_44,
    tag_data: tag_data_struct_anon_45,
    scalar_data: scalar_data_struct_anon_46,
    opened: i32,
    closed: i32,
    anchors_m: ^anchors,
    last_anchor_id: i32,
    document_m: ^document,
}
emitter :: emitter_s

@(default_calling_convention = "c")
foreign yaml_runic {
    @(link_name = "yaml_get_version_string")
    get_version_string :: proc() -> cstring ---

    @(link_name = "yaml_get_version")
    get_version :: proc(major: ^i32, minor: ^i32, patch: ^i32) ---

    @(link_name = "yaml_token_delete")
    token_delete :: proc(token_p: ^token) ---

    @(link_name = "yaml_stream_start_event_initialize")
    stream_start_event_initialize :: proc(event_p: ^event, encoding_p: encoding) -> i32 ---

    @(link_name = "yaml_stream_end_event_initialize")
    stream_end_event_initialize :: proc(event_p: ^event) -> i32 ---

    @(link_name = "yaml_document_start_event_initialize")
    document_start_event_initialize :: proc(event_p: ^event, version_directive_p: ^version_directive, tag_directives_start: ^tag_directive, tag_directives_end: ^tag_directive, implicit: i32) -> i32 ---

    @(link_name = "yaml_document_end_event_initialize")
    document_end_event_initialize :: proc(event_p: ^event, implicit: i32) -> i32 ---

    @(link_name = "yaml_alias_event_initialize")
    alias_event_initialize :: proc(event_p: ^event, anchor: cstring) -> i32 ---

    @(link_name = "yaml_scalar_event_initialize")
    scalar_event_initialize :: proc(event_p: ^event, anchor: cstring, tag: cstring, value: cstring, length: i32, plain_implicit: i32, quoted_implicit: i32, style: scalar_style) -> i32 ---

    @(link_name = "yaml_sequence_start_event_initialize")
    sequence_start_event_initialize :: proc(event_p: ^event, anchor: cstring, tag: cstring, implicit: i32, style: sequence_style) -> i32 ---

    @(link_name = "yaml_sequence_end_event_initialize")
    sequence_end_event_initialize :: proc(event_p: ^event) -> i32 ---

    @(link_name = "yaml_mapping_start_event_initialize")
    mapping_start_event_initialize :: proc(event_p: ^event, anchor: cstring, tag: cstring, implicit: i32, style: mapping_style) -> i32 ---

    @(link_name = "yaml_mapping_end_event_initialize")
    mapping_end_event_initialize :: proc(event_p: ^event) -> i32 ---

    @(link_name = "yaml_event_delete")
    event_delete :: proc(event_p: ^event) ---

    @(link_name = "yaml_document_initialize")
    document_initialize :: proc(document_p: ^document, version_directive_p: ^version_directive, tag_directives_start: ^tag_directive, tag_directives_end: ^tag_directive, start_implicit: i32, end_implicit: i32) -> i32 ---

    @(link_name = "yaml_document_delete")
    document_delete :: proc(document_p: ^document) ---

    @(link_name = "yaml_document_get_node")
    document_get_node :: proc(document_p: ^document, index: i32) -> ^node ---

    @(link_name = "yaml_document_get_root_node")
    document_get_root_node :: proc(document_p: ^document) -> ^node ---

    @(link_name = "yaml_document_add_scalar")
    document_add_scalar :: proc(document_p: ^document, tag: cstring, value: cstring, length: i32, style: scalar_style) -> i32 ---

    @(link_name = "yaml_document_add_sequence")
    document_add_sequence :: proc(document_p: ^document, tag: cstring, style: sequence_style) -> i32 ---

    @(link_name = "yaml_document_add_mapping")
    document_add_mapping :: proc(document_p: ^document, tag: cstring, style: mapping_style) -> i32 ---

    @(link_name = "yaml_document_append_sequence_item")
    document_append_sequence_item :: proc(document_p: ^document, sequence: i32, item: i32) -> i32 ---

    @(link_name = "yaml_document_append_mapping_pair")
    document_append_mapping_pair :: proc(document_p: ^document, mapping: i32, key: i32, value: i32) -> i32 ---

    @(link_name = "yaml_parser_initialize")
    parser_initialize :: proc(parser_p: ^parser) -> i32 ---

    @(link_name = "yaml_parser_delete")
    parser_delete :: proc(parser_p: ^parser) ---

    @(link_name = "yaml_parser_set_input_string")
    parser_set_input_string :: proc(parser_p: ^parser, input: ^u8, size: uint) ---

    @(link_name = "yaml_parser_set_input_file")
    parser_set_input_file :: proc(parser_p: ^parser, file: ^libc.FILE) ---

    @(link_name = "yaml_parser_set_input")
    parser_set_input :: proc(parser_p: ^parser, handler: ^read_handler, data: rawptr) ---

    @(link_name = "yaml_parser_set_encoding")
    parser_set_encoding :: proc(parser_p: ^parser, encoding_p: encoding) ---

    @(link_name = "yaml_parser_scan")
    parser_scan :: proc(parser_p: ^parser, token_p: ^token) -> i32 ---

    @(link_name = "yaml_parser_parse")
    parser_parse :: proc(parser_p: ^parser, event_p: ^event) -> i32 ---

    @(link_name = "yaml_parser_load")
    parser_load :: proc(parser_p: ^parser, document_p: ^document) -> i32 ---

    @(link_name = "yaml_emitter_initialize")
    emitter_initialize :: proc(emitter_p: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_delete")
    emitter_delete :: proc(emitter_p: ^emitter) ---

    @(link_name = "yaml_emitter_set_output_string")
    emitter_set_output_string :: proc(emitter_p: ^emitter, output: ^u8, size: uint, size_written: ^uint) ---

    @(link_name = "yaml_emitter_set_output_file")
    emitter_set_output_file :: proc(emitter_p: ^emitter, file: ^libc.FILE) ---

    @(link_name = "yaml_emitter_set_output")
    emitter_set_output :: proc(emitter_p: ^emitter, handler: ^write_handler, data: rawptr) ---

    @(link_name = "yaml_emitter_set_encoding")
    emitter_set_encoding :: proc(emitter_p: ^emitter, encoding_p: encoding) ---

    @(link_name = "yaml_emitter_set_canonical")
    emitter_set_canonical :: proc(emitter_p: ^emitter, canonical: i32) ---

    @(link_name = "yaml_emitter_set_indent")
    emitter_set_indent :: proc(emitter_p: ^emitter, indent: i32) ---

    @(link_name = "yaml_emitter_set_width")
    emitter_set_width :: proc(emitter_p: ^emitter, width: i32) ---

    @(link_name = "yaml_emitter_set_unicode")
    emitter_set_unicode :: proc(emitter_p: ^emitter, unicode: i32) ---

    @(link_name = "yaml_emitter_set_break")
    emitter_set_break :: proc(emitter_p: ^emitter, line_break: break_) ---

    @(link_name = "yaml_emitter_emit")
    emitter_emit :: proc(emitter_p: ^emitter, event_p: ^event) -> i32 ---

    @(link_name = "yaml_emitter_open")
    emitter_open :: proc(emitter_p: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_close")
    emitter_close :: proc(emitter_p: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_dump")
    emitter_dump :: proc(emitter_p: ^emitter, document_p: ^document) -> i32 ---

    @(link_name = "yaml_emitter_flush")
    emitter_flush :: proc(emitter_p: ^emitter) -> i32 ---

}

when (ODIN_OS == .Linux) && (ODIN_ARCH == .amd64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/linux/x86_64/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Linux) && (ODIN_ARCH == .arm64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/linux/aarch64/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Linux) && (ODIN_ARCH == .i386) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/linux/x86/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Linux) && (ODIN_ARCH == .arm32) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/linux/arm/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Windows) && (ODIN_ARCH == .amd64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/windows/x86_64/yaml.lib"
} else {
    foreign import yaml_runic "lib/windows/x86_64/yamld.lib"
}

} else when (ODIN_OS == .Windows) && (ODIN_ARCH == .arm64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/windows/aarch64/yaml.lib"
} else {
    foreign import yaml_runic "lib/windows/aarch64/yamld.lib"
}

} else when (ODIN_OS == .Windows) && (ODIN_ARCH == .i386) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/windows/x86/yaml.lib"
} else {
    foreign import yaml_runic "lib/windows/x86/yamld.lib"
}

} else when (ODIN_OS == .Windows) && (ODIN_ARCH == .arm32) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/windows/arm/yaml.lib"
} else {
    foreign import yaml_runic "lib/windows/arm/yamld.lib"
}

} else when (ODIN_OS == .Darwin) && (ODIN_ARCH == .amd64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/macos/x86_64/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Darwin) && (ODIN_ARCH == .arm64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/macos/aarch64/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Darwin) && (ODIN_ARCH == .i386) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/macos/x86/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else when (ODIN_OS == .Darwin) && (ODIN_ARCH == .arm32) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/macos/arm/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "system:libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

}

