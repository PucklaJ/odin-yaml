//+build windows amd64, darwin amd64, linux amd64, darwin amd64, linux amd64, windows amd64
package yaml

NULL_TAG :: `tag:yaml.org,2002:null`
BOOL_TAG :: `tag:yaml.org,2002:bool`
STR_TAG :: `tag:yaml.org,2002:str`
INT_TAG :: `tag:yaml.org,2002:int`
FLOAT_TAG :: `tag:yaml.org,2002:float`
TIMESTAMP_TAG :: `tag:yaml.org,2002:timestamp`
SEQ_TAG :: `tag:yaml.org,2002:seq`
MAP_TAG :: `tag:yaml.org,2002:map`
DEFAULT_SCALAR_TAG :: `tag:yaml.org,2002:str`
DEFAULT_SEQUENCE_TAG :: `tag:yaml.org,2002:seq`
DEFAULT_MAPPING_TAG :: `tag:yaml.org,2002:map`

char_t :: u8
version_directive_t :: struct {
    major: i32,
    minor: i32,
}
tag_directive_t :: struct {
    handle: ^char_t,
    prefix: ^char_t,
}
encoding_t :: enum i32 {ANY_ENCODING = 0, UTF8_ENCODING = 1, UTF16LE_ENCODING = 2, UTF16BE_ENCODING = 3, }
break_t :: enum i32 {ANY_BREAK = 0, CR_BREAK = 1, LN_BREAK = 2, CRLN_BREAK = 3, }
error_type_t :: enum i32 {NO_ERROR = 0, MEMORY_ERROR = 1, READER_ERROR = 2, SCANNER_ERROR = 3, PARSER_ERROR = 4, COMPOSER_ERROR = 5, WRITER_ERROR = 6, EMITTER_ERROR = 7, }
mark_t :: struct {
    index: size_t,
    line: size_t,
    column: size_t,
}
scalar_style_t :: enum i32 {ANY_SCALAR_STYLE = 0, PLAIN_SCALAR_STYLE = 1, SINGLE_QUOTED_SCALAR_STYLE = 2, DOUBLE_QUOTED_SCALAR_STYLE = 3, LITERAL_SCALAR_STYLE = 4, FOLDED_SCALAR_STYLE = 5, }
sequence_style_t :: enum i32 {ANY_SEQUENCE_STYLE = 0, BLOCK_SEQUENCE_STYLE = 1, FLOW_SEQUENCE_STYLE = 2, }
mapping_style_t :: enum i32 {ANY_MAPPING_STYLE = 0, BLOCK_MAPPING_STYLE = 1, FLOW_MAPPING_STYLE = 2, }
token_type_t :: enum i32 {NO_TOKEN = 0, STREAM_START_TOKEN = 1, STREAM_END_TOKEN = 2, VERSION_DIRECTIVE_TOKEN = 3, TAG_DIRECTIVE_TOKEN = 4, DOCUMENT_START_TOKEN = 5, DOCUMENT_END_TOKEN = 6, BLOCK_SEQUENCE_START_TOKEN = 7, BLOCK_MAPPING_START_TOKEN = 8, BLOCK_END_TOKEN = 9, FLOW_SEQUENCE_START_TOKEN = 10, FLOW_SEQUENCE_END_TOKEN = 11, FLOW_MAPPING_START_TOKEN = 12, FLOW_MAPPING_END_TOKEN = 13, BLOCK_ENTRY_TOKEN = 14, FLOW_ENTRY_TOKEN = 15, KEY_TOKEN = 16, VALUE_TOKEN = 17, ALIAS_TOKEN = 18, ANCHOR_TOKEN = 19, TAG_TOKEN = 20, SCALAR_TOKEN = 21, }
anon_0 :: struct {
    encoding: encoding_t,
}
anon_1 :: struct {
    value: ^char_t,
}
anon_2 :: struct {
    value: ^char_t,
}
anon_3 :: struct {
    handle: ^char_t,
    suffix: ^char_t,
}
anon_4 :: struct {
    value: ^char_t,
    length: size_t,
    style: scalar_style_t,
}
anon_5 :: struct {
    major: i32,
    minor: i32,
}
anon_6 :: struct {
    handle: ^char_t,
    prefix: ^char_t,
}
anon_7 :: struct #raw_union {stream_start: anon_0, alias: anon_1, anchor: anon_2, tag: anon_3, scalar: anon_4, version_directive: anon_5, tag_directive: anon_6, }
token_t :: struct {
    type: token_type_t,
    data: anon_7,
    start_mark: mark_t,
    end_mark: mark_t,
}
event_type_t :: enum i32 {NO_EVENT = 0, STREAM_START_EVENT = 1, STREAM_END_EVENT = 2, DOCUMENT_START_EVENT = 3, DOCUMENT_END_EVENT = 4, ALIAS_EVENT = 5, SCALAR_EVENT = 6, SEQUENCE_START_EVENT = 7, SEQUENCE_END_EVENT = 8, MAPPING_START_EVENT = 9, MAPPING_END_EVENT = 10, }
anon_8 :: struct {
    encoding: encoding_t,
}
anon_9 :: struct {
    start: ^tag_directive_t,
    end: ^tag_directive_t,
}
anon_10 :: struct {
    version_directive: ^version_directive_t,
    tag_directives: anon_9,
    implicit: i32,
}
anon_11 :: struct {
    implicit: i32,
}
anon_12 :: struct {
    anchor: ^char_t,
}
anon_13 :: struct {
    anchor: ^char_t,
    tag: ^char_t,
    value: ^char_t,
    length: size_t,
    plain_implicit: i32,
    quoted_implicit: i32,
    style: scalar_style_t,
}
anon_14 :: struct {
    anchor: ^char_t,
    tag: ^char_t,
    implicit: i32,
    style: sequence_style_t,
}
anon_15 :: struct {
    anchor: ^char_t,
    tag: ^char_t,
    implicit: i32,
    style: mapping_style_t,
}
anon_16 :: struct #raw_union {stream_start: anon_8, document_start: anon_10, document_end: anon_11, alias: anon_12, scalar: anon_13, sequence_start: anon_14, mapping_start: anon_15, }
event_t :: struct {
    type: event_type_t,
    data: anon_16,
    start_mark: mark_t,
    end_mark: mark_t,
}
node_type_t :: enum i32 {NO_NODE = 0, SCALAR_NODE = 1, SEQUENCE_NODE = 2, MAPPING_NODE = 3, }
node_t :: node_s
node_item_t :: i32
node_pair_t :: struct {
    key: i32,
    value: i32,
}
anon_17 :: struct {
    value: ^char_t,
    length: size_t,
    style: scalar_style_t,
}
anon_18 :: struct {
    start: ^node_item_t,
    end: ^node_item_t,
    top: ^node_item_t,
}
anon_19 :: struct {
    items: anon_18,
    style: sequence_style_t,
}
anon_20 :: struct {
    start: ^node_pair_t,
    end: ^node_pair_t,
    top: ^node_pair_t,
}
anon_21 :: struct {
    pairs: anon_20,
    style: mapping_style_t,
}
anon_22 :: struct #raw_union {scalar: anon_17, sequence: anon_19, mapping: anon_21, }
node_s :: struct {
    type: node_type_t,
    tag: ^char_t,
    data: anon_22,
    start_mark: mark_t,
    end_mark: mark_t,
}
anon_23 :: struct {
    start: ^node_t,
    end: ^node_t,
    top: ^node_t,
}
anon_24 :: struct {
    start: ^tag_directive_t,
    end: ^tag_directive_t,
}
document_t :: struct {
    nodes: anon_23,
    version_directive: ^version_directive_t,
    tag_directives: anon_24,
    start_implicit: i32,
    end_implicit: i32,
    start_mark: mark_t,
    end_mark: mark_t,
}
read_handler_t :: #type proc "c" (data: rawptr, buffer: ^u8, size: size_t, size_read: ^size_t) -> i32
simple_key_t :: struct {
    possible: i32,
    required: i32,
    token_number: size_t,
    mark: mark_t,
}
parser_state_t :: enum i32 {PARSE_STREAM_START_STATE = 0, PARSE_IMPLICIT_DOCUMENT_START_STATE = 1, PARSE_DOCUMENT_START_STATE = 2, PARSE_DOCUMENT_CONTENT_STATE = 3, PARSE_DOCUMENT_END_STATE = 4, PARSE_BLOCK_NODE_STATE = 5, PARSE_BLOCK_NODE_OR_INDENTLESS_SEQUENCE_STATE = 6, PARSE_FLOW_NODE_STATE = 7, PARSE_BLOCK_SEQUENCE_FIRST_ENTRY_STATE = 8, PARSE_BLOCK_SEQUENCE_ENTRY_STATE = 9, PARSE_INDENTLESS_SEQUENCE_ENTRY_STATE = 10, PARSE_BLOCK_MAPPING_FIRST_KEY_STATE = 11, PARSE_BLOCK_MAPPING_KEY_STATE = 12, PARSE_BLOCK_MAPPING_VALUE_STATE = 13, PARSE_FLOW_SEQUENCE_FIRST_ENTRY_STATE = 14, PARSE_FLOW_SEQUENCE_ENTRY_STATE = 15, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_KEY_STATE = 16, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_VALUE_STATE = 17, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_END_STATE = 18, PARSE_FLOW_MAPPING_FIRST_KEY_STATE = 19, PARSE_FLOW_MAPPING_KEY_STATE = 20, PARSE_FLOW_MAPPING_VALUE_STATE = 21, PARSE_FLOW_MAPPING_EMPTY_VALUE_STATE = 22, PARSE_END_STATE = 23, }
alias_data_t :: struct {
    anchor: ^char_t,
    index: i32,
    mark: mark_t,
}
anon_25 :: struct {
    start: ^u8,
    end: ^u8,
    current: ^u8,
}
anon_26 :: struct #raw_union {string_: anon_25, file: rawptr, }
anon_27 :: struct {
    start: ^char_t,
    end: ^char_t,
    pointer: ^char_t,
    last: ^char_t,
}
anon_28 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
anon_29 :: struct {
    start: ^token_t,
    end: ^token_t,
    head: ^token_t,
    tail: ^token_t,
}
anon_30 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
anon_31 :: struct {
    start: ^simple_key_t,
    end: ^simple_key_t,
    top: ^simple_key_t,
}
anon_32 :: struct {
    start: ^parser_state_t,
    end: ^parser_state_t,
    top: ^parser_state_t,
}
anon_33 :: struct {
    start: ^mark_t,
    end: ^mark_t,
    top: ^mark_t,
}
anon_34 :: struct {
    start: ^tag_directive_t,
    end: ^tag_directive_t,
    top: ^tag_directive_t,
}
anon_35 :: struct {
    start: ^alias_data_t,
    end: ^alias_data_t,
    top: ^alias_data_t,
}
parser_t :: struct {
    error: error_type_t,
    problem: cstring,
    problem_offset: size_t,
    problem_value: i32,
    problem_mark: mark_t,
    context_: cstring,
    context_mark: mark_t,
    read_handler: read_handler_t,
    read_handler_data: rawptr,
    input: anon_26,
    eof: i32,
    buffer: anon_27,
    unread: size_t,
    raw_buffer: anon_28,
    encoding: encoding_t,
    offset: size_t,
    mark: mark_t,
    stream_start_produced: i32,
    stream_end_produced: i32,
    flow_level: i32,
    tokens: anon_29,
    tokens_parsed: size_t,
    token_available: i32,
    indents: anon_30,
    indent: i32,
    simple_key_allowed: i32,
    simple_keys: anon_31,
    states: anon_32,
    state: parser_state_t,
    marks: anon_33,
    tag_directives: anon_34,
    aliases: anon_35,
    document: ^document_t,
}
write_handler_t :: #type proc "c" (data: rawptr, buffer: ^u8, size: size_t) -> i32
emitter_state_t :: enum i32 {EMIT_STREAM_START_STATE = 0, EMIT_FIRST_DOCUMENT_START_STATE = 1, EMIT_DOCUMENT_START_STATE = 2, EMIT_DOCUMENT_CONTENT_STATE = 3, EMIT_DOCUMENT_END_STATE = 4, EMIT_FLOW_SEQUENCE_FIRST_ITEM_STATE = 5, EMIT_FLOW_SEQUENCE_ITEM_STATE = 6, EMIT_FLOW_MAPPING_FIRST_KEY_STATE = 7, EMIT_FLOW_MAPPING_KEY_STATE = 8, EMIT_FLOW_MAPPING_SIMPLE_VALUE_STATE = 9, EMIT_FLOW_MAPPING_VALUE_STATE = 10, EMIT_BLOCK_SEQUENCE_FIRST_ITEM_STATE = 11, EMIT_BLOCK_SEQUENCE_ITEM_STATE = 12, EMIT_BLOCK_MAPPING_FIRST_KEY_STATE = 13, EMIT_BLOCK_MAPPING_KEY_STATE = 14, EMIT_BLOCK_MAPPING_SIMPLE_VALUE_STATE = 15, EMIT_BLOCK_MAPPING_VALUE_STATE = 16, EMIT_END_STATE = 17, }
anchors_t :: struct {
    references: i32,
    anchor: i32,
    serialized: i32,
}
anon_36 :: struct {
    buffer: ^u8,
    size: size_t,
    size_written: ^size_t,
}
anon_37 :: struct #raw_union {string_: anon_36, file: rawptr, }
anon_38 :: struct {
    start: ^char_t,
    end: ^char_t,
    pointer: ^char_t,
    last: ^char_t,
}
anon_39 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
anon_40 :: struct {
    start: ^emitter_state_t,
    end: ^emitter_state_t,
    top: ^emitter_state_t,
}
anon_41 :: struct {
    start: ^event_t,
    end: ^event_t,
    head: ^event_t,
    tail: ^event_t,
}
anon_42 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
anon_43 :: struct {
    start: ^tag_directive_t,
    end: ^tag_directive_t,
    top: ^tag_directive_t,
}
anon_44 :: struct {
    anchor: ^char_t,
    anchor_length: size_t,
    alias: i32,
}
anon_45 :: struct {
    handle: ^char_t,
    handle_length: size_t,
    suffix: ^char_t,
    suffix_length: size_t,
}
anon_46 :: struct {
    value: ^char_t,
    length: size_t,
    multiline: i32,
    flow_plain_allowed: i32,
    block_plain_allowed: i32,
    single_quoted_allowed: i32,
    block_allowed: i32,
    style: scalar_style_t,
}
emitter_t :: struct {
    error: error_type_t,
    problem: cstring,
    write_handler: write_handler_t,
    write_handler_data: rawptr,
    output: anon_37,
    buffer: anon_38,
    raw_buffer: anon_39,
    encoding: encoding_t,
    canonical: i32,
    best_indent: i32,
    best_width: i32,
    unicode: i32,
    line_break: break_t,
    states: anon_40,
    state: emitter_state_t,
    events: anon_41,
    indents: anon_42,
    tag_directives: anon_43,
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
    anchor_data: anon_44,
    tag_data: anon_45,
    scalar_data: anon_46,
    opened: i32,
    closed: i32,
    anchors: [^]anchors_t,
    last_anchor_id: i32,
    document: ^document_t,
}

@(default_calling_convention = "c")
foreign yaml_runic {
    @(link_name = "yaml_get_version_string")
    get_version_string :: proc() -> cstring ---

    @(link_name = "yaml_get_version")
    get_version :: proc(major: ^i32, minor: ^i32, patch: ^i32) ---

    @(link_name = "yaml_token_delete")
    token_delete :: proc(token: ^token_t) ---

    @(link_name = "yaml_stream_start_event_initialize")
    stream_start_event_initialize :: proc(event: ^event_t, encoding: encoding_t) -> i32 ---

    @(link_name = "yaml_stream_end_event_initialize")
    stream_end_event_initialize :: proc(event: ^event_t) -> i32 ---

    @(link_name = "yaml_document_start_event_initialize")
    document_start_event_initialize :: proc(event: ^event_t, version_directive: ^version_directive_t, tag_directives_start: ^tag_directive_t, tag_directives_end: ^tag_directive_t, implicit: i32) -> i32 ---

    @(link_name = "yaml_document_end_event_initialize")
    document_end_event_initialize :: proc(event: ^event_t, implicit: i32) -> i32 ---

    @(link_name = "yaml_alias_event_initialize")
    alias_event_initialize :: proc(event: ^event_t, anchor: ^char_t) -> i32 ---

    @(link_name = "yaml_scalar_event_initialize")
    scalar_event_initialize :: proc(event: ^event_t, anchor: ^char_t, tag: ^char_t, value: ^char_t, length: i32, plain_implicit: i32, quoted_implicit: i32, style: scalar_style_t) -> i32 ---

    @(link_name = "yaml_sequence_start_event_initialize")
    sequence_start_event_initialize :: proc(event: ^event_t, anchor: ^char_t, tag: ^char_t, implicit: i32, style: sequence_style_t) -> i32 ---

    @(link_name = "yaml_sequence_end_event_initialize")
    sequence_end_event_initialize :: proc(event: ^event_t) -> i32 ---

    @(link_name = "yaml_mapping_start_event_initialize")
    mapping_start_event_initialize :: proc(event: ^event_t, anchor: ^char_t, tag: ^char_t, implicit: i32, style: mapping_style_t) -> i32 ---

    @(link_name = "yaml_mapping_end_event_initialize")
    mapping_end_event_initialize :: proc(event: ^event_t) -> i32 ---

    @(link_name = "yaml_event_delete")
    event_delete :: proc(event: ^event_t) ---

    @(link_name = "yaml_document_initialize")
    document_initialize :: proc(document: ^document_t, version_directive: ^version_directive_t, tag_directives_start: ^tag_directive_t, tag_directives_end: ^tag_directive_t, start_implicit: i32, end_implicit: i32) -> i32 ---

    @(link_name = "yaml_document_delete")
    document_delete :: proc(document: ^document_t) ---

    @(link_name = "yaml_document_get_node")
    document_get_node :: proc(document: ^document_t, index: i32) -> ^node_t ---

    @(link_name = "yaml_document_get_root_node")
    document_get_root_node :: proc(document: ^document_t) -> ^node_t ---

    @(link_name = "yaml_document_add_scalar")
    document_add_scalar :: proc(document: ^document_t, tag: ^char_t, value: ^char_t, length: i32, style: scalar_style_t) -> i32 ---

    @(link_name = "yaml_document_add_sequence")
    document_add_sequence :: proc(document: ^document_t, tag: ^char_t, style: sequence_style_t) -> i32 ---

    @(link_name = "yaml_document_add_mapping")
    document_add_mapping :: proc(document: ^document_t, tag: ^char_t, style: mapping_style_t) -> i32 ---

    @(link_name = "yaml_document_append_sequence_item")
    document_append_sequence_item :: proc(document: ^document_t, sequence: i32, item: i32) -> i32 ---

    @(link_name = "yaml_document_append_mapping_pair")
    document_append_mapping_pair :: proc(document: ^document_t, mapping: i32, key: i32, value: i32) -> i32 ---

    @(link_name = "yaml_parser_initialize")
    parser_initialize :: proc(parser: ^parser_t) -> i32 ---

    @(link_name = "yaml_parser_delete")
    parser_delete :: proc(parser: ^parser_t) ---

    @(link_name = "yaml_parser_set_input_string")
    parser_set_input_string :: proc(parser: ^parser_t, input: ^u8, size: size_t) ---

    @(link_name = "yaml_parser_set_input_file")
    parser_set_input_file :: proc(parser: ^parser_t, file: rawptr) ---

    @(link_name = "yaml_parser_set_input")
    parser_set_input :: proc(parser: ^parser_t, handler: read_handler_t, data: rawptr) ---

    @(link_name = "yaml_parser_set_encoding")
    parser_set_encoding :: proc(parser: ^parser_t, encoding: encoding_t) ---

    @(link_name = "yaml_parser_scan")
    parser_scan :: proc(parser: ^parser_t, token: ^token_t) -> i32 ---

    @(link_name = "yaml_parser_parse")
    parser_parse :: proc(parser: ^parser_t, event: ^event_t) -> i32 ---

    @(link_name = "yaml_parser_load")
    parser_load :: proc(parser: ^parser_t, document: ^document_t) -> i32 ---

    @(link_name = "yaml_emitter_initialize")
    emitter_initialize :: proc(emitter: ^emitter_t) -> i32 ---

    @(link_name = "yaml_emitter_delete")
    emitter_delete :: proc(emitter: ^emitter_t) ---

    @(link_name = "yaml_emitter_set_output_string")
    emitter_set_output_string :: proc(emitter: ^emitter_t, output: ^u8, size: size_t, size_written: ^size_t) ---

    @(link_name = "yaml_emitter_set_output_file")
    emitter_set_output_file :: proc(emitter: ^emitter_t, file: rawptr) ---

    @(link_name = "yaml_emitter_set_output")
    emitter_set_output :: proc(emitter: ^emitter_t, handler: write_handler_t, data: rawptr) ---

    @(link_name = "yaml_emitter_set_encoding")
    emitter_set_encoding :: proc(emitter: ^emitter_t, encoding: encoding_t) ---

    @(link_name = "yaml_emitter_set_canonical")
    emitter_set_canonical :: proc(emitter: ^emitter_t, canonical: i32) ---

    @(link_name = "yaml_emitter_set_indent")
    emitter_set_indent :: proc(emitter: ^emitter_t, indent: i32) ---

    @(link_name = "yaml_emitter_set_width")
    emitter_set_width :: proc(emitter: ^emitter_t, width: i32) ---

    @(link_name = "yaml_emitter_set_unicode")
    emitter_set_unicode :: proc(emitter: ^emitter_t, unicode: i32) ---

    @(link_name = "yaml_emitter_set_break")
    emitter_set_break :: proc(emitter: ^emitter_t, line_break: break_t) ---

    @(link_name = "yaml_emitter_emit")
    emitter_emit :: proc(emitter: ^emitter_t, event: ^event_t) -> i32 ---

    @(link_name = "yaml_emitter_open")
    emitter_open :: proc(emitter: ^emitter_t) -> i32 ---

    @(link_name = "yaml_emitter_close")
    emitter_close :: proc(emitter: ^emitter_t) -> i32 ---

    @(link_name = "yaml_emitter_dump")
    emitter_dump :: proc(emitter: ^emitter_t, document: ^document_t) -> i32 ---

    @(link_name = "yaml_emitter_flush")
    emitter_flush :: proc(emitter: ^emitter_t) -> i32 ---

}

when (ODIN_OS == .Windows) && (ODIN_ARCH == .amd64) {

foreign import yaml_runic "system:yaml.lib"

}

when (ODIN_OS == .Darwin) && (ODIN_ARCH == .amd64) {

size_t :: __darwin_size_t
__darwin_size_t :: u64

}

when (ODIN_OS == .Linux) && (ODIN_ARCH == .amd64) || (ODIN_OS == .Darwin) && (ODIN_ARCH == .amd64) {

foreign import yaml_runic "system:yaml"

}

when (ODIN_OS == .Linux) && (ODIN_ARCH == .amd64) || (ODIN_OS == .Windows) && (ODIN_ARCH == .amd64) {

size_t :: u64

}

