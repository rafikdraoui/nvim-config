setlocal commentstring={#\ %s\ #}

let s:match_patterns = [
      \     ['if', 'elif', 'else', 'endif'],
      \     ['(end)\@<!(\w+) ', 'end\3'],
      \ ]

function! s:get_match_words(patterns)
  let acc = []
  for pattern_group in a:patterns
    call add(acc, s:make_pattern(pattern_group))
  endfor
  return join(acc, ',')
endfunction

function! s:make_pattern(pattern_list)
  let acc = []
  for atom in a:pattern_list
    call add(acc, s:wrap_atom(atom))
  endfor
  return join(acc, ':')
endfunction

function! s:wrap_atom(atom)
  let result = '({% )\@<=' . a:atom . '.\{-\} %}'
  return escape(result, '()+')
endfunction

let s:match_words = s:get_match_words(s:match_patterns)

if exists('b:match_words')
  let b:match_words .= ',' . s:match_words
else
  let b:match_words = s:match_words
endif
