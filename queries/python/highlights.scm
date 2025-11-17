;; extends

; Add custom highlight group for function and class definitions
(class_definition (identifier) @rafik.definition)
(function_definition (identifier) @rafik.definition)

; Highlight `breakpoint()` debugger calls as errors
((call
  function: (identifier) @error)
  (#eq? @error "breakpoint"))
