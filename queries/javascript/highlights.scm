;; extends

; Add custom highlight group for function and class definitions
(class (identifier) @rafik.definition)
(function_declaration (identifier) @rafik.definition)
(method_definition (property_identifier) @rafik.definition)
