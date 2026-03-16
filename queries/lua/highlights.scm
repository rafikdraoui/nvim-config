;; extends

; Add custom highlight group for function definitions

; function fn(...) ... end
(function_declaration (identifier) @rafik.definition)

; local fn = function(...) ... end
(assignment_statement
  (variable_list
    name: (identifier) @rafik.definition )
  (expression_list (function_definition (parameters)))
)

; local M.fn = function(...) ... end
(assignment_statement
  (variable_list
    name:
      (dot_index_expression
        table: (identifier)
        field: (identifier) @rafik.definition
      )
  )
  (expression_list (function_definition (parameters)))
)
