#+build amd64, arm64
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

char :: u8
version_directive :: struct {
    major: i32,
    minor: i32,
}
tag_directive :: struct {
    handle: cstring,
    prefix: cstring,
}
encoding :: enum i32 {ANY_ENCODING = 0, UTF8_ENCODING = 1, UTF16LE_ENCODING = 2, UTF16BE_ENCODING = 3, }
break_ :: enum i32 {ANY_BREAK = 0, CR_BREAK = 1, LN_BREAK = 2, CRLN_BREAK = 3, }
error_type :: enum i32 {NO_ERROR = 0, MEMORY_ERROR = 1, READER_ERROR = 2, SCANNER_ERROR = 3, PARSER_ERROR = 4, COMPOSER_ERROR = 5, WRITER_ERROR = 6, EMITTER_ERROR = 7, }
mark :: struct {
    index: size,
    line: size,
    column: size,
}
scalar_style :: enum i32 {ANY_SCALAR_STYLE = 0, PLAIN_SCALAR_STYLE = 1, SINGLE_QUOTED_SCALAR_STYLE = 2, DOUBLE_QUOTED_SCALAR_STYLE = 3, LITERAL_SCALAR_STYLE = 4, FOLDED_SCALAR_STYLE = 5, }
sequence_style :: enum i32 {ANY_SEQUENCE_STYLE = 0, BLOCK_SEQUENCE_STYLE = 1, FLOW_SEQUENCE_STYLE = 2, }
mapping_style :: enum i32 {ANY_MAPPING_STYLE = 0, BLOCK_MAPPING_STYLE = 1, FLOW_MAPPING_STYLE = 2, }
token_type :: enum i32 {NO_TOKEN = 0, STREAM_START_TOKEN = 1, STREAM_END_TOKEN = 2, VERSION_DIRECTIVE_TOKEN = 3, TAG_DIRECTIVE_TOKEN = 4, DOCUMENT_START_TOKEN = 5, DOCUMENT_END_TOKEN = 6, BLOCK_SEQUENCE_START_TOKEN = 7, BLOCK_MAPPING_START_TOKEN = 8, BLOCK_END_TOKEN = 9, FLOW_SEQUENCE_START_TOKEN = 10, FLOW_SEQUENCE_END_TOKEN = 11, FLOW_MAPPING_START_TOKEN = 12, FLOW_MAPPING_END_TOKEN = 13, BLOCK_ENTRY_TOKEN = 14, FLOW_ENTRY_TOKEN = 15, KEY_TOKEN = 16, VALUE_TOKEN = 17, ALIAS_TOKEN = 18, ANCHOR_TOKEN = 19, TAG_TOKEN = 20, SCALAR_TOKEN = 21, }
anon_0 :: struct {
    encoding: encoding,
}
anon_1 :: struct {
    value: cstring,
}
anon_2 :: struct {
    value: cstring,
}
anon_3 :: struct {
    handle: cstring,
    suffix: cstring,
}
anon_4 :: struct {
    value: cstring,
    length: size,
    style: scalar_style,
}
anon_5 :: struct {
    major: i32,
    minor: i32,
}
anon_6 :: struct {
    handle: cstring,
    prefix: cstring,
}
anon_7 :: struct #raw_union {stream_start: anon_0, alias: anon_1, anchor: anon_2, tag: anon_3, scalar: anon_4, version_directive: anon_5, tag_directive: anon_6, }
token :: struct {
    type: token_type,
    data: anon_7,
    start_mark: mark,
    end_mark: mark,
}
event_type :: enum i32 {NO_EVENT = 0, STREAM_START_EVENT = 1, STREAM_END_EVENT = 2, DOCUMENT_START_EVENT = 3, DOCUMENT_END_EVENT = 4, ALIAS_EVENT = 5, SCALAR_EVENT = 6, SEQUENCE_START_EVENT = 7, SEQUENCE_END_EVENT = 8, MAPPING_START_EVENT = 9, MAPPING_END_EVENT = 10, }
anon_8 :: struct {
    encoding: encoding,
}
anon_9 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
}
anon_10 :: struct {
    version_directive: ^version_directive,
    tag_directives: anon_9,
    implicit: i32,
}
anon_11 :: struct {
    implicit: i32,
}
anon_12 :: struct {
    anchor: cstring,
}
anon_13 :: struct {
    anchor: cstring,
    tag: cstring,
    value: cstring,
    length: size,
    plain_implicit: i32,
    quoted_implicit: i32,
    style: scalar_style,
}
anon_14 :: struct {
    anchor: cstring,
    tag: cstring,
    implicit: i32,
    style: sequence_style,
}
anon_15 :: struct {
    anchor: cstring,
    tag: cstring,
    implicit: i32,
    style: mapping_style,
}
anon_16 :: struct #raw_union {stream_start: anon_8, document_start: anon_10, document_end: anon_11, alias: anon_12, scalar: anon_13, sequence_start: anon_14, mapping_start: anon_15, }
event :: struct {
    type: event_type,
    data: anon_16,
    start_mark: mark,
    end_mark: mark,
}
node_type :: enum i32 {NO_NODE = 0, SCALAR_NODE = 1, SEQUENCE_NODE = 2, MAPPING_NODE = 3, }
node :: node_s
node_item :: i32
node_pair :: struct {
    key: i32,
    value: i32,
}
anon_17 :: struct {
    value: cstring,
    length: size,
    style: scalar_style,
}
anon_18 :: struct {
    start: ^node_item,
    end: ^node_item,
    top: ^node_item,
}
anon_19 :: struct {
    items: anon_18,
    style: sequence_style,
}
anon_20 :: struct {
    start: ^node_pair,
    end: ^node_pair,
    top: ^node_pair,
}
anon_21 :: struct {
    pairs: anon_20,
    style: mapping_style,
}
anon_22 :: struct #raw_union {scalar: anon_17, sequence: anon_19, mapping: anon_21, }
node_s :: struct {
    type: node_type,
    tag: cstring,
    data: anon_22,
    start_mark: mark,
    end_mark: mark,
}
anon_23 :: struct {
    start: ^node,
    end: ^node,
    top: ^node,
}
anon_24 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
}
document :: struct {
    nodes: anon_23,
    version_directive: ^version_directive,
    tag_directives: anon_24,
    start_implicit: i32,
    end_implicit: i32,
    start_mark: mark,
    end_mark: mark,
}
read_handler :: #type proc "c" (data: rawptr, buffer: ^u8, size_: size, size_read: ^size) -> i32
simple_key :: struct {
    possible: i32,
    required: i32,
    token_number: size,
    mark: mark,
}
parser_state :: enum i32 {PARSE_STREAM_START_STATE = 0, PARSE_IMPLICIT_DOCUMENT_START_STATE = 1, PARSE_DOCUMENT_START_STATE = 2, PARSE_DOCUMENT_CONTENT_STATE = 3, PARSE_DOCUMENT_END_STATE = 4, PARSE_BLOCK_NODE_STATE = 5, PARSE_BLOCK_NODE_OR_INDENTLESS_SEQUENCE_STATE = 6, PARSE_FLOW_NODE_STATE = 7, PARSE_BLOCK_SEQUENCE_FIRST_ENTRY_STATE = 8, PARSE_BLOCK_SEQUENCE_ENTRY_STATE = 9, PARSE_INDENTLESS_SEQUENCE_ENTRY_STATE = 10, PARSE_BLOCK_MAPPING_FIRST_KEY_STATE = 11, PARSE_BLOCK_MAPPING_KEY_STATE = 12, PARSE_BLOCK_MAPPING_VALUE_STATE = 13, PARSE_FLOW_SEQUENCE_FIRST_ENTRY_STATE = 14, PARSE_FLOW_SEQUENCE_ENTRY_STATE = 15, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_KEY_STATE = 16, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_VALUE_STATE = 17, PARSE_FLOW_SEQUENCE_ENTRY_MAPPING_END_STATE = 18, PARSE_FLOW_MAPPING_FIRST_KEY_STATE = 19, PARSE_FLOW_MAPPING_KEY_STATE = 20, PARSE_FLOW_MAPPING_VALUE_STATE = 21, PARSE_FLOW_MAPPING_EMPTY_VALUE_STATE = 22, PARSE_END_STATE = 23, }
alias_data :: struct {
    anchor: cstring,
    index: i32,
    mark: mark,
}
anon_25 :: struct {
    start: ^u8,
    end: ^u8,
    current: ^u8,
}
anon_26 :: struct #raw_union {string_: anon_25, file: rawptr, }
anon_27 :: struct {
    start: cstring,
    end: cstring,
    pointer: cstring,
    last: cstring,
}
anon_28 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
anon_29 :: struct {
    start: ^token,
    end: ^token,
    head: ^token,
    tail: ^token,
}
anon_30 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
anon_31 :: struct {
    start: ^simple_key,
    end: ^simple_key,
    top: ^simple_key,
}
anon_32 :: struct {
    start: ^parser_state,
    end: ^parser_state,
    top: ^parser_state,
}
anon_33 :: struct {
    start: ^mark,
    end: ^mark,
    top: ^mark,
}
anon_34 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
    top: ^tag_directive,
}
anon_35 :: struct {
    start: ^alias_data,
    end: ^alias_data,
    top: ^alias_data,
}
parser :: struct {
    error: error_type,
    problem: cstring,
    problem_offset: size,
    problem_value: i32,
    problem_mark: mark,
    context_: cstring,
    context_mark: mark,
    read_handler: read_handler,
    read_handler_data: rawptr,
    input: anon_26,
    eof: i32,
    buffer: anon_27,
    unread: size,
    raw_buffer: anon_28,
    encoding: encoding,
    offset: size,
    mark: mark,
    stream_start_produced: i32,
    stream_end_produced: i32,
    flow_level: i32,
    tokens: anon_29,
    tokens_parsed: size,
    token_available: i32,
    indents: anon_30,
    indent: i32,
    simple_key_allowed: i32,
    simple_keys: anon_31,
    states: anon_32,
    state: parser_state,
    marks: anon_33,
    tag_directives: anon_34,
    aliases: anon_35,
    document: ^document,
}
write_handler :: #type proc "c" (data: rawptr, buffer: ^u8, size_: size) -> i32
emitter_state :: enum i32 {EMIT_STREAM_START_STATE = 0, EMIT_FIRST_DOCUMENT_START_STATE = 1, EMIT_DOCUMENT_START_STATE = 2, EMIT_DOCUMENT_CONTENT_STATE = 3, EMIT_DOCUMENT_END_STATE = 4, EMIT_FLOW_SEQUENCE_FIRST_ITEM_STATE = 5, EMIT_FLOW_SEQUENCE_ITEM_STATE = 6, EMIT_FLOW_MAPPING_FIRST_KEY_STATE = 7, EMIT_FLOW_MAPPING_KEY_STATE = 8, EMIT_FLOW_MAPPING_SIMPLE_VALUE_STATE = 9, EMIT_FLOW_MAPPING_VALUE_STATE = 10, EMIT_BLOCK_SEQUENCE_FIRST_ITEM_STATE = 11, EMIT_BLOCK_SEQUENCE_ITEM_STATE = 12, EMIT_BLOCK_MAPPING_FIRST_KEY_STATE = 13, EMIT_BLOCK_MAPPING_KEY_STATE = 14, EMIT_BLOCK_MAPPING_SIMPLE_VALUE_STATE = 15, EMIT_BLOCK_MAPPING_VALUE_STATE = 16, EMIT_END_STATE = 17, }
anchors :: struct {
    references: i32,
    anchor: i32,
    serialized: i32,
}
anon_36 :: struct {
    buffer: ^u8,
    size_: size,
    size_written: ^size,
}
anon_37 :: struct #raw_union {string_: anon_36, file: rawptr, }
anon_38 :: struct {
    start: cstring,
    end: cstring,
    pointer: cstring,
    last: cstring,
}
anon_39 :: struct {
    start: ^u8,
    end: ^u8,
    pointer: ^u8,
    last: ^u8,
}
anon_40 :: struct {
    start: ^emitter_state,
    end: ^emitter_state,
    top: ^emitter_state,
}
anon_41 :: struct {
    start: ^event,
    end: ^event,
    head: ^event,
    tail: ^event,
}
anon_42 :: struct {
    start: ^i32,
    end: ^i32,
    top: ^i32,
}
anon_43 :: struct {
    start: ^tag_directive,
    end: ^tag_directive,
    top: ^tag_directive,
}
anon_44 :: struct {
    anchor: cstring,
    anchor_length: size,
    alias: i32,
}
anon_45 :: struct {
    handle: cstring,
    handle_length: size,
    suffix: cstring,
    suffix_length: size,
}
anon_46 :: struct {
    value: cstring,
    length: size,
    multiline: i32,
    flow_plain_allowed: i32,
    block_plain_allowed: i32,
    single_quoted_allowed: i32,
    block_allowed: i32,
    style: scalar_style,
}
emitter :: struct {
    error: error_type,
    problem: cstring,
    write_handler: write_handler,
    write_handler_data: rawptr,
    output: anon_37,
    buffer: anon_38,
    raw_buffer: anon_39,
    encoding: encoding,
    canonical: i32,
    best_indent: i32,
    best_width: i32,
    unicode: i32,
    line_break: break_,
    states: anon_40,
    state: emitter_state,
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
    anchors: [^]anchors,
    last_anchor_id: i32,
    document: ^document,
}
size :: u64

@(default_calling_convention = "c")
foreign yaml_runic {
    @(link_name = "yaml_get_version_string")
    get_version_string :: proc() -> cstring ---

    @(link_name = "yaml_get_version")
    get_version :: proc(major: ^i32, minor: ^i32, patch: ^i32) ---

    @(link_name = "yaml_token_delete")
    token_delete :: proc(token: ^token) ---

    @(link_name = "yaml_stream_start_event_initialize")
    stream_start_event_initialize :: proc(event: ^event, encoding: encoding) -> i32 ---

    @(link_name = "yaml_stream_end_event_initialize")
    stream_end_event_initialize :: proc(event: ^event) -> i32 ---

    @(link_name = "yaml_document_start_event_initialize")
    document_start_event_initialize :: proc(event: ^event, version_directive: ^version_directive, tag_directives_start: ^tag_directive, tag_directives_end: ^tag_directive, implicit: i32) -> i32 ---

    @(link_name = "yaml_document_end_event_initialize")
    document_end_event_initialize :: proc(event: ^event, implicit: i32) -> i32 ---

    @(link_name = "yaml_alias_event_initialize")
    alias_event_initialize :: proc(event: ^event, anchor: cstring) -> i32 ---

    @(link_name = "yaml_scalar_event_initialize")
    scalar_event_initialize :: proc(event: ^event, anchor: cstring, tag: cstring, value: cstring, length: i32, plain_implicit: i32, quoted_implicit: i32, style: scalar_style) -> i32 ---

    @(link_name = "yaml_sequence_start_event_initialize")
    sequence_start_event_initialize :: proc(event: ^event, anchor: cstring, tag: cstring, implicit: i32, style: sequence_style) -> i32 ---

    @(link_name = "yaml_sequence_end_event_initialize")
    sequence_end_event_initialize :: proc(event: ^event) -> i32 ---

    @(link_name = "yaml_mapping_start_event_initialize")
    mapping_start_event_initialize :: proc(event: ^event, anchor: cstring, tag: cstring, implicit: i32, style: mapping_style) -> i32 ---

    @(link_name = "yaml_mapping_end_event_initialize")
    mapping_end_event_initialize :: proc(event: ^event) -> i32 ---

    @(link_name = "yaml_event_delete")
    event_delete :: proc(event: ^event) ---

    @(link_name = "yaml_document_initialize")
    document_initialize :: proc(document: ^document, version_directive: ^version_directive, tag_directives_start: ^tag_directive, tag_directives_end: ^tag_directive, start_implicit: i32, end_implicit: i32) -> i32 ---

    @(link_name = "yaml_document_delete")
    document_delete :: proc(document: ^document) ---

    @(link_name = "yaml_document_get_node")
    document_get_node :: proc(document: ^document, index: i32) -> ^node ---

    @(link_name = "yaml_document_get_root_node")
    document_get_root_node :: proc(document: ^document) -> ^node ---

    @(link_name = "yaml_document_add_scalar")
    document_add_scalar :: proc(document: ^document, tag: cstring, value: cstring, length: i32, style: scalar_style) -> i32 ---

    @(link_name = "yaml_document_add_sequence")
    document_add_sequence :: proc(document: ^document, tag: cstring, style: sequence_style) -> i32 ---

    @(link_name = "yaml_document_add_mapping")
    document_add_mapping :: proc(document: ^document, tag: cstring, style: mapping_style) -> i32 ---

    @(link_name = "yaml_document_append_sequence_item")
    document_append_sequence_item :: proc(document: ^document, sequence: i32, item: i32) -> i32 ---

    @(link_name = "yaml_document_append_mapping_pair")
    document_append_mapping_pair :: proc(document: ^document, mapping: i32, key: i32, value: i32) -> i32 ---

    @(link_name = "yaml_parser_initialize")
    parser_initialize :: proc(parser: ^parser) -> i32 ---

    @(link_name = "yaml_parser_delete")
    parser_delete :: proc(parser: ^parser) ---

    @(link_name = "yaml_parser_set_input_string")
    parser_set_input_string :: proc(parser: ^parser, input: ^u8, size: size) ---

    @(link_name = "yaml_parser_set_input_file")
    parser_set_input_file :: proc(parser: ^parser, file: rawptr) ---

    @(link_name = "yaml_parser_set_input")
    parser_set_input :: proc(parser: ^parser, handler: read_handler, data: rawptr) ---

    @(link_name = "yaml_parser_set_encoding")
    parser_set_encoding :: proc(parser: ^parser, encoding: encoding) ---

    @(link_name = "yaml_parser_scan")
    parser_scan :: proc(parser: ^parser, token: ^token) -> i32 ---

    @(link_name = "yaml_parser_parse")
    parser_parse :: proc(parser: ^parser, event: ^event) -> i32 ---

    @(link_name = "yaml_parser_load")
    parser_load :: proc(parser: ^parser, document: ^document) -> i32 ---

    @(link_name = "yaml_emitter_initialize")
    emitter_initialize :: proc(emitter: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_delete")
    emitter_delete :: proc(emitter: ^emitter) ---

    @(link_name = "yaml_emitter_set_output_string")
    emitter_set_output_string :: proc(emitter: ^emitter, output: ^u8, size_: size, size_written: ^size) ---

    @(link_name = "yaml_emitter_set_output_file")
    emitter_set_output_file :: proc(emitter: ^emitter, file: rawptr) ---

    @(link_name = "yaml_emitter_set_output")
    emitter_set_output :: proc(emitter: ^emitter, handler: write_handler, data: rawptr) ---

    @(link_name = "yaml_emitter_set_encoding")
    emitter_set_encoding :: proc(emitter: ^emitter, encoding: encoding) ---

    @(link_name = "yaml_emitter_set_canonical")
    emitter_set_canonical :: proc(emitter: ^emitter, canonical: i32) ---

    @(link_name = "yaml_emitter_set_indent")
    emitter_set_indent :: proc(emitter: ^emitter, indent: i32) ---

    @(link_name = "yaml_emitter_set_width")
    emitter_set_width :: proc(emitter: ^emitter, width: i32) ---

    @(link_name = "yaml_emitter_set_unicode")
    emitter_set_unicode :: proc(emitter: ^emitter, unicode: i32) ---

    @(link_name = "yaml_emitter_set_break")
    emitter_set_break :: proc(emitter: ^emitter, line_break: break_) ---

    @(link_name = "yaml_emitter_emit")
    emitter_emit :: proc(emitter: ^emitter, event: ^event) -> i32 ---

    @(link_name = "yaml_emitter_open")
    emitter_open :: proc(emitter: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_close")
    emitter_close :: proc(emitter: ^emitter) -> i32 ---

    @(link_name = "yaml_emitter_dump")
    emitter_dump :: proc(emitter: ^emitter, document: ^document) -> i32 ---

    @(link_name = "yaml_emitter_flush")
    emitter_flush :: proc(emitter: ^emitter) -> i32 ---

}

when (ODIN_OS == .Linux) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/linux/libyaml.a"
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
    foreign import yaml_runic "lib/windows/arm64/yaml.lib"
} else {
    foreign import yaml_runic "lib/windows/arm64/yamld.lib"
}

} else when (ODIN_OS == .Darwin) && (ODIN_ARCH == .amd64) {

when #config(YAML_STATIC, false) {
    foreign import yaml_runic "lib/macos/x86_64/libyaml.a"
} else {
    foreign import yaml_runic "system:yaml"
}

} else {

when #config(YAML_STATIC, false) {
    when ODIN_OS == .Darwin {
    foreign import yaml_runic "system:yaml"
} else {
    foreign import yaml_runic "system:libyaml.a"
}
} else {
    foreign import yaml_runic "system:yaml"
}

}

