" Enable syntax folding
" Inspired by the `gitDiff` syntax item in `syntax/git.vim`
syn region diffGitFile start="^\%(diff --git \)\@=" end="^\%(diff --git \)\@=" contains=ALL fold
