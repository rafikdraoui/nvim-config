" vim: foldmethod=marker

" Options {{{1

let g:mapleader = ','

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=-1  " set to same as 'shiftwidth'
set shiftround  " indent to a multiple of 'shiftwidth'

" Line Wrapping
set linebreak
set breakindent  " keep indentation when wrapping lines
set cpoptions+=n breakindentopt=sbr  " display 'showbreak' symbol within the line number column

let &cedit="\<c-o>" " ...since <c-f> is shadowed by vim-rsi
set commentstring=#\ %s
set completeopt-=preview
set foldlevel=99  " start unfolded by default
set foldmethod=indent
set grepprg=rg\ --vimgrep grepformat^=%f:%l:%c:%m
set helpheight=1000  " maximize help window
set hidden  " allow switching buffers even if there are unsaved changes
set ignorecase smartcase  " case-insensitive search, unless query has capital letter
set inccommand=nosplit  " show preview of :substitute action interactively
set lazyredraw  " only redraw screen when necessary
set list listchars=tab:▸·,extends:❯,precedes:❮,nbsp:⁓
set matchpairs+=«:»
set nojoinspaces  " put only a single space after periods when joining lines
set noswapfile directory=''  " disable swapfile
set notimeout
set path-=/usr/include
set relativenumber number numberwidth=1 " use relative line number, but display absolute number on current line
set scrolloff=3
set signcolumn=yes
set splitbelow splitright
set tagcase=smart
set termguicolors
set title
set updatetime=1000
set wildmode=longest:full,full

" Speed up loading by explicitly setting python provider
let g:python3_host_prog = expand('~/.pyenv/versions/neovim/bin/python')

" Allow syntax highlighting of embedded lua in vimscript files
" c.f. $VIMRUNTIME/syntax/vim.vim
let g:vimsyn_embed= 'l'


" Mappings {{{1

" See also:
"   plugin/navigation_mappings.vim
"   plugin/window_mappings.vim

" Buffers
nnoremap <leader><leader> <c-^>
nnoremap <leader>b :ls<cr>:b<space>
nnoremap <leader>B :ls<cr>:sb<space>
" close quickfix window before `bdelete`, to avoid prematurely quitting vim
" (cf. g:qf_auto_quit)
nnoremap <silent> <leader><bs> :cclose <bar> :lclose <bar> :bdelete<cr>

" Use ctrl-s to save file
nnoremap <silent> <c-s> :update<cr>
inoremap <silent> <c-s> <esc>:update<cr>

" Move through wrapped lines (unless prefixed with a count)
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Do not increase/decrease numbers with ctrl-a/ctrl-x
nnoremap <c-a> <nop>
nnoremap <c-x> <nop>

" Make ctrl-g print the full path and buffer number by default
nnoremap <c-g> 2<c-g>

" Allow undoing readline-style deletion
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Yank and put from system clipboard
" Recursive maps so that miniyank plugin mappings are preserved
nmap gy "+y
xmap gy "+y
nmap gp "+p
xmap gp "+p
nmap gP "+P

" Copy last yank to system clipboard
nnoremap <silent> cp :ToSystemClipboard<cr>

" Toggle fold
nnoremap <space> za

" Easier substitute
nnoremap <leader>/ :%s/
xnoremap <leader>/ :s/

" Visually select last changed or yanked text
nnoremap gl `[v`]

" Consider already entered text as prefix when navigating command-line history
" The `wildmenumode()` guard is needed to preserve ctrl-n/ctrl-p behaviour
" when using completion menu.
cnoremap <expr> <c-n> wildmenumode() ? "<c-n>" : "<down>"
cnoremap <expr> <c-p> wildmenumode() ? "<c-p>" : "<up>"

" Join all lines in a paragraph (and make it repeatable through vim-repeat)
nnoremap <silent> gJ vipJ :call repeat#set('gJ')<cr>

" Make file paths in quickfix window relative to repo root
nnoremap <silent> <leader>a :cclose <bar> exe 'cd ' . git#repo_root() <bar> cwindow <bar> cd - <cr>

" Make `*` and `#` respect `smartcase`
nnoremap * /\<<c-r>=expand('<cword>')<cr>\><cr>
nnoremap # ?\<<c-r>=expand('<cword>')<cr>\><cr>

" Repeat the last command-line command
nnoremap Q @:

" Sort operator
nnoremap zs :echo "sort" <bar> set opfunc=opfunc#sort<cr>g@
xnoremap <silent> zs :<c-u>call opfunc#sort(visualmode())<cr>

" Open browser at url under cursor
nnoremap <silent> gx :call browse#url()<cr>

" Close preview window
nnoremap <silent> <leader>x :pclose<cr>

" Toggle spellcheck and spelllang
nnoremap <silent> cos :set spell! <cr>
nnoremap <silent> cof :execute 'setlocal spelllang=' . (&spelllang ==# 'en' ? 'fr' : 'en') <cr>

" Toggle cursorline
nnoremap <silent> col :set cursorline! <cr>

" Toggle wrap
nnoremap <silent> cow :set wrap! <bar> set wrap? <cr>

" Toggle relativenumber
nnoremap <silent> con :set relativenumber! <bar> set relativenumber? <cr>

" Switch to terminal buffer
nnoremap <silent> <leader>t :call buffers#get_terminal()<cr>
nnoremap <silent> <leader>T :split term://$SHELL<cr>

" Use <esc> to exit terminal mode (and alt-[ to send escape to terminal)
tnoremap <expr> <esc> &ft == 'fzf' ? "<c-c>" : "<c-\><c-n>"
tnoremap <a-[> <esc>

" Emulate i_CTRL-R
tnoremap <expr> <a-r> '<c-\><c-n>"'.nr2char(getchar()).'pi'

" Apply first spelling suggestion to current or next misspelled word
nnoremap Z ge]s1z=

" Use git-jump from within vim. Can pass a count of 1, 2, or 3 for `diff`,
" `staged`, and `merge` variants.
nnoremap <silent> <leader>j :Jump<cr>

" Trigger insert mode completions
inoremap ,f <c-x><c-f>
inoremap ,l <c-x><c-l>
inoremap ,t <c-x><c-]>
inoremap ,<tab> <c-x><c-o>

" Map some keys on the French-Canadian keyboard to their English (quasi)
" equivalents in normal mode
nnoremap Ç }
nnoremap ¨ {
nnoremap é /
nnoremap É ?
nnoremap è '


" Text Objects {{{1

" 'in line' (entire line without whitespace)
xnoremap <silent> il :<c-u>normal! g_v^<cr>
onoremap <silent> il :normal! g_v^<cr>

" 'around line' (entire line without trailing newline)
xnoremap <silent> al :<c-u>normal! $v0<cr>
onoremap <silent> al :normal! $v0<cr>

" 'in indentation' (indentation level without surrounding empty lines)
xnoremap <silent> ii :<c-u>call textobj#indent#in()<cr>
onoremap <silent> ii :call textobj#indent#in()<cr>

" 'around indentation' (indentation level and any surrounding empty lines)
xnoremap <silent> ai :<c-u>call textobj#indent#around()<cr>
onoremap <silent> ai :call textobj#indent#around()<cr>

" 'in number' (next number after cursor on current line)
xnoremap <silent> in :<c-u>call textobj#number#in()<cr>
onoremap <silent> in :call textobj#number#in()<cr>

" 'around number' (next number on line and surrounding whitespace)
xnoremap <silent> an :<c-u>call textobj#number#around()<cr>
onoremap <silent> an :call textobj#number#around()<cr>

" 'in «guillemets»'
xnoremap <silent> ig :<c-u>call textobj#guillemets#in()<cr>
onoremap <silent> ig :call textobj#guillemets#in()<cr>

" 'around «guillemets»'
xnoremap <silent> ag :<c-u>call textobj#guillemets#around()<cr>
onoremap <silent> ag :call textobj#guillemets#around()<cr>

" 'in entire buffer' (excludes leading and trailing empty lines)
xnoremap <silent> ie :<c-u>call textobj#entire#in()<cr>
onoremap <silent> ie :call textobj#entire#in()<cr>

" 'around entire buffer' (includes leading and trailing empty lines)
xnoremap <silent> ae :<c-u>call textobj#entire#around()<cr>
onoremap <silent> ae :call textobj#entire#around()<cr>


" Commands {{{1

command! TrimWhitespace call whitespace#trim()

" Delete other buffers
command! -bang Bonly call buffers#bonly(<bang>0)

" Scratch buffer
command! Scratch call scratch#create([])
command! -nargs=1 -complete=command Redir silent call scratch#redir(<q-args>)
command! -nargs=1 EditRegister call scratch#edit_register(<q-args>)
command! Clipboard EditRegister +

" minpac plugin manager
command! PackUpdate call pack#init() | call minpac#update() | call minpac#status({'open': 'tab'})
command! PackClean call pack#init() | call minpac#clean()

" copy last yank to system clipboard
command! ToSystemClipboard let @+ = @@

" set pwd to root of git repo (if applicable)
command! CdRoot call git#cd_root()

" set pwd to the directory containing the file loaded in buffer
command! CdBuffer cd %:p:h

" `git jump` from within vim
" need to use a patched version of git's contrib `git-jump` script
" https://gist.github.com/romainl/a3ddb1d08764b93183260f8cdf0f524f
command! -count=0 -nargs=* -complete=custom,GitJumpComplete Jump call git#jump(<f-args>)
function! GitJumpComplete(...)
  return join(['diff', 'staged', 'merge'], "\n")
endfunction


" Autocommands {{{1

" define autocmd group `vimrc` and initialize
augroup vimrc
  autocmd!
augroup END

" highlight yank
if has('nvim-0.5')
  autocmd vimrc TextYankPost * lua require'vim.highlight'.on_yank()
endif

" Trim whitespace on save
autocmd vimrc BufWritePre * TrimWhitespace

" Trigger `autoread` when file changes on disk
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * if empty(getcmdwintype()) | checktime | endif
autocmd vimrc FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Make terminal start in insert mode, and disable number and sign columns
autocmd vimrc TermOpen * startinsert | setlocal nonumber norelativenumber signcolumn=auto

" Set 'showbreak' symbol so that it aligns to the right of the line number
" column (whose width varies depending on the number of lines in the buffer.)
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * let &showbreak=repeat(' ', float2nr(floor(log10(line('$'))))) . '⋯'


" Colors {{{1
function! StatusLineUserHighlights() abort
  " Custom highlights for status line, using `hl-User{N}` for better
  " interaction with StatusLineNC.
  " We can't define the values in the colorscheme and just `hi link` them,
  " since doing so seem to not make highlights work properly on statusline of
  " non-active windows.

  " 'bold status line', used for filename
  " This is the same as StatusLine, but with the addition of the bold attribute.
  highlight User1 guifg=#504945 guibg=#ebdbb2 gui=inverse,bold

  " 'bold yellow', used for linting status
  highlight User2 guifg=#504945 guibg=#fabd2f gui=inverse,bold
endfunction
autocmd vimrc ColorScheme couleurs call StatusLineUserHighlights()

colorscheme couleurs


" Status line {{{1

let &statusline = ''

" filename, modified flag, preview flag, and filetype
let &statusline .= '%1*%f%*%m%w %y '

" git branch and change stats
let &statusline .= '%{git#statusline()} '

" spell checking
let &statusline .= '%{&spell ? printf("[spell=%s]", &spelllang) : ""} '

" linting
function! LintStatus() abort
  if g:ale_is_running
    return '[linting]'
  endif
  let num_errors = ale#statusline#Count(bufnr())['total']
  return num_errors > 0 ? printf('[lint:%d]', num_errors) : ''
endfunction
let &statusline .= '%2*%{LintStatus()}%* '

" line/column numbers
let &statusline .= '%= %p%% %4l/%L:%-2c'


" Plugins configuration {{{1

" signify {{{2
let g:signify_vcs_list = ['git']
let s:signify_sign = '•'
let g:signify_sign_add = s:signify_sign
let g:signify_sign_change = s:signify_sign
let g:signify_sign_changedelete = s:signify_sign
let g:signify_sign_delete = s:signify_sign
let g:signify_sign_delete_first_line = '‾'

nmap gj <plug>(signify-next-hunk)
nmap gk <plug>(signify-prev-hunk)
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)


" ALE {{{2
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_sign_error = '»'
let g:ale_sign_warning = '»'
let g:ale_echo_msg_format = '[%linter%]% code:% %s'

let g:ale_linters = {
\ 'fish': [],
\ 'go': ['gobuild', 'revive', 'golangci-lint'],
\ 'haskell': ['hdevtools'],
\ 'javascript': ['eslint'],
\ 'json': ['jsonlint'],
\ 'markdown': ['markdownlint'],
\ 'python': ['flake8', 'pylint', 'mypy'],
\ 'sh': ['shellcheck'],
\ 'vimwiki': [],
\}
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 1
let g:ale_go_revive_options = '-config $HOME/.config/revive.toml'
let g:ale_python_flake8_change_directory = 'project'
let g:ale_javascript_eslint_suppress_eslintignore = 1
let g:ale_javascript_eslint_suppress_missing_config = 1

let g:ale_fixers = {
\ 'css': ['prettier'],
\ 'elm': ['elm-format'],
\ 'fish': ['autofix#fish'],
\ 'go': ['goimports'],
\ 'haskell': ['hfmt'],
\ 'javascript': ['prettier'],
\ 'json': ['jq'],
\ 'python': ['black'],
\ 'rust': ['rustfmt'],
\ 'scss': ['prettier'],
\ 'sh': ['shfmt'],
\ 'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_sh_shfmt_options = '-i 2 -ci'
let g:ale_elm_format_options = '--elm-version=0.19 --yes'

nmap <leader>m <plug>(ale_detail)
nmap <leader>c <plug>(ale_lint)
nmap <leader>r <plug>(ale_reset)
nmap ]e <plug>(ale_next)
nmap [e <plug>(ale_previous)
nnoremap coa :ALEToggle <bar> let g:ale_enabled <cr>
nnoremap cox :call autofix#toggle() <cr>

let g:ale_is_running = v:false
autocmd vimrc User ALELintPre let g:ale_is_running = v:true | redrawstatus
autocmd vimrc User ALELintPost let g:ale_is_running = v:false | redrawstatus


" vimwiki {{{2
let s:wiki = {}
let s:wiki.path = $NOTES_DIR
let s:wiki.syntax = 'markdown'
let s:wiki.ext = '.md'
let s:wiki.links_space_char = '-'
let s:wiki.auto_tags = 1
let g:vimwiki_list = [s:wiki]

let g:vimwiki_folding = 'expr'
let g:vimwiki_global_ext = 0
let g:vimwiki_key_mappings = {
\ 'headers': 1,
\ 'links': 1,
\ 'lists': 1,
\ 'global': 0,
\ 'html': 0,
\ 'mouse': 0,
\ 'table_format': 0,
\ 'table_mappings': 0,
\ 'text_objs': 0,
\}

nnoremap <silent> <leader>ww :edit $NOTES_DIR/index.md<cr>
nnoremap <leader>n :Files $NOTES_DIR<cr>
autocmd vimrc BufReadPre $NOTES_DIR/* if !exists('g:loaded_vimiki') | packadd vimwiki | endif


" fzf  {{{2
if has('mac')
  set runtimepath+=/usr/local/opt/fzf
endif
nnoremap <c-f> :GFiles <cr>
nnoremap <c-h> :Helptags<cr>
let g:fzf_preview_window = []


" vim-sandwich {{{2

let g:textobj_sandwich_no_default_key_mappings = 1
xmap is <Plug>(textobj-sandwich-auto-i)
omap is <Plug>(textobj-sandwich-auto-i)
xmap as <Plug>(textobj-sandwich-auto-a)
omap as <Plug>(textobj-sandwich-auto-a)

let s:extra_recipes = [
\ {'buns': ['«', '»'], 'input': ['g']},
\ {'buns': ['(', ')'], 'input': ['p', 'b'], 'nesting': 1},
\]
autocmd vimrc BufRead,BufNewFile * call sandwich#util#addlocal(s:extra_recipes)


" vim-grepper {{{2
let g:grepper = {}
let g:grepper.dir = 'repo'
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.searchreg = 1  " add query to last-search register

nnoremap <leader>s :Grepper <cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
nmap gss gsiw


" vim-subversive {{{2
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)

nmap cs <plug>(SubversiveSubstituteRange)
xmap cs <plug>(SubversiveSubstituteRange)
nmap css <plug>(SubversiveSubstituteWordRange)
let g:subversiveCurrentTextRegister = 's'


" vim-test
let g:test#strategy = 'neovim'
let g:test#python#runner = 'pytest'
nnoremap <silent> t<c-n> :TestNearest<cr>
nnoremap <silent> t<c-f> :TestFile<cr>
nnoremap <silent> t<c-s> :TestSuite<cr>
nnoremap <silent> t<c-l> :TestLast<cr>
nnoremap <silent> t<c-g> :TestVisit<cr>


" nvim-treesitter {{{2
if has('nvim-0.5')
  packadd! nvim-treesitter
  packadd! nvim-treesitter-textobjects
  packadd! nvim-treesitter-refactor
  lua require'treesitter_setup'

  nnoremap <silent> g: <cmd>echo nvim_treesitter#statusline()<cr>
endif


" nvim-lspconfig {{{2
if has('nvim-0.5')
  packadd! nvim-lspconfig
  lua require'lsp_setup'
endif


" others {{{2

" disable netrw plugin, but still allow its autoloaded functions to be used,
" so that fugitive's `:Gbrowse` continue to work.
let g:loaded_netrwPlugin = 1

" vim-markdown (from default $VIMRUNTIME)
let g:markdown_folding = 1

" vim-rust
let g:rust_fold = 1

" dirvish
autocmd vimrc FileType dirvish setlocal statusline=%y\ %f

" miniyank
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
map <c-p> <Plug>(miniyank-cycle)
map <c-n> <Plug>(miniyank-cycleback)

" gutentags
let g:gutentags_file_list_command = {'markers': {'.git': 'git ls-files'}}
let g:gutentags_cache_dir = expand('~/.cache/tags')

" git-messenger
" see also `after/ftplugin/gitmessengerpopup.vim`
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_no_default_mappings = v:true
nmap gb <Plug>(git-messenger)

" vim-qf
nmap <leader>q <plug>(qf_qf_toggle_stay)
nmap <leader>z <plug>(qf_loc_toggle_stay)

" vim-fugitive
nnoremap <silent> <leader>g :Gstatus<cr>
nnoremap gh :Gbrowse<cr>
xnoremap gh :Gbrowse<cr>

" vim-projectionist
let g:projectionist_heuristics = {
\ 'go.mod': {
\   '*.go': {'alternate': '{}_test.go'},
\   '*_test.go': {'type': 'test', 'alternate': '{}.go'},
\  }
\}

" vim-delve
let g:delve_new_command = 'new'
let g:delve_sign_priority = 50  " higher than signify and ale signs

" vim-mundo
nnoremap <silent> cou :MundoToggle<cr>

" targets.vim
let g:targets_nl = ["\<Space>n", "\<Space>l"]

" coiled snake
let g:coiled_snake_foldtext_flags = ['static']

" clever-f
nmap <leader>f <Plug>(clever-f-reset)

" vim-hexokinase
nnoremap <silent> coh :packadd vim-hexokinase <bar> HexokinaseToggle <cr>


" Abbreviations {{{1

iabbrev Quebec Québec
iabbrev Montreal Montréal
cabbrev Q! q!
