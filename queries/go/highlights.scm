;; extends

; Add custom highlight group for definitions of functions/types/etc.

(function_declaration (identifier) @rafik.definition)
(method_declaration (field_identifier) @rafik.definition)

; top-level declarations only
(source_file (type_declaration (type_spec (type_identifier) @rafik.definition)))
(source_file (var_declaration (var_spec (identifier) @rafik.definition)))
(source_file (const_declaration (const_spec (identifier) @rafik.definition)))
