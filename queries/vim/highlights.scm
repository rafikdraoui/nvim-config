;; extends

; Highlight mapping key codes (e.g. <leader>, <c-s>, etc.)
; The higher priority is required to also highlight the angled brackets, which
; otherwise would be highlighted as `<` and `>` operators.
(map_statement (map_side (keycode) @constant.builtin)
  (#set! "priority" 101))

; Consistently highlight environment variables, i.e. both the `$` symbol and
; the name.
((env_variable) @define (#set! "priority" 101))
