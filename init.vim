" vim: foldmethod=marker

" Options {{{1

let g:mapleader = ','

set termguicolors
colorscheme gruvbox-custom

" Indentation
set expandtab
set shiftwidth=2
set softtabstop=-1  " set to same as 'shiftwidth'
set shiftround  " indent to a multiple of 'shiftwidth'

" Line Wrapping
set linebreak
set breakindent  " keep indentation when wrapping lines
set cpoptions+=n breakindentopt=sbr | let &showbreak='  ⋯'  " display `⋯` symbol within the line number column to denote wrapped lines

set foldlevel=99  " start unfolded by default
set foldmethod=indent
set helpheight=1000  " maximize help window
set hidden  " allow switching buffers even if there are unsaved changes
set ignorecase smartcase  " case-insensitive search, unless query has capital letter
set inccommand=nosplit  " show preview of :substitute action interactively
set lazyredraw  " only redraw screen when necessary
set list listchars=tab:▸·,extends:❯,precedes:❮,nbsp:⌴
set matchpairs+=«:»
set nojoinspaces  " put only a single space after periods when joining lines
set noswapfile directory=''  " disable swapfile
set notimeout
set path-=/usr/include
set relativenumber number  " use relative line number, but display absolute number on current line
set scrolloff=3
set splitbelow splitright
set tagcase=smart
set title
set wildmode=longest:full,full

" Speedup loading by explicitly setting python provider
let g:python3_host_prog = expand('~/.pyenv/versions/neovim/bin/python')


" Mappings {{{1

" See also: plugin/navigation_mappings.vim

" Buffers
nnoremap <leader><leader> <c-^>
nnoremap <silent> <leader><bs> :bdelete<cr>
nnoremap <leader>b :ls<cr>:b<space>

" Easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize windows using <alt> and h,j,k,l
nnoremap <silent> <M-h> <C-w><
nnoremap <silent> <M-l> <C-w>>
nnoremap <silent> <M-j> <C-W>-
nnoremap <silent> <M-k> <C-W>+
nnoremap <silent> <M-=> <C-W>=

" Redraw screen (since ctrl-l has been remapped for window movements)
nnoremap <c-space> <c-l>

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
" Recursive maps to so that miniyank plugin mappings are preserved
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

" Insert empty line below current line (leaving cursor at same position)
nnoremap <silent> <leader><cr> m':put =''<cr>g`'

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

" open browser at url under cursor
nnoremap <silent> gx :call browse#url()<cr>

" close preview window
nnoremap <silent> <leader>x :pclose<cr>

" Toggle spellcheck and spelllang
nnoremap <silent> cos :set spell! <cr>
nnoremap <silent> cof :execute 'setlocal spelllang=' . (&spelllang ==# 'en' ? 'fr' : 'en') <cr>

" Toggle cursorline
nnoremap <silent> col :set cursorline! <cr>

" Toggle wrap
nnoremap <silent> cow :set wrap! <bar> set wrap? <cr>

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


" Autocommands {{{1

" define autocmd group `vimrc` and initialize
augroup vimrc
  autocmd!
augroup END

" highlight yank
autocmd vimrc TextYankPost * call highlight_yank#highlight(v:event.operator, v:event.regtype, v:event.inclusive)

" Trim whitespace on save
autocmd vimrc BufWritePre * TrimWhitespace

" Trigger `autoread` when file changes on disk
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * if empty(getcmdwintype()) | checktime | endif
autocmd vimrc FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Make terminal start in insert mode
autocmd vimrc TermOpen * startinsert


" Status line {{{1

" Custom highlight for filename.
" This is the same as StatusLine, but with the addition of the bold attribute.
highlight User1 guifg=#504945 guibg=#ebdbb2 gui=inverse,bold

let &statusline = ''

" filename, modified flag, preview flag, and filetype
let &statusline .= '%1*%f%*%m%w %y '

" git branch and change stats
let &statusline .= '%{git#statusline()} '

" spell checking
let &statusline .= '%{&spell ? "[spell=" . &spelllang . "]" : ""} '

" linting
let &statusline .= '%{g:ale_is_running ? "[linting]" : ""} '

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
let g:ale_open_list = 1
let g:ale_set_signs = 0

let g:ale_linters = {
\ 'fish': [],
\ 'haskell': ['hdevtools'],
\ 'javascript': ['standard'],
\ 'json': ['jsonlint'],
\ 'markdown': ['markdownlint'],
\ 'python': ['cdroot_flake8', 'pylint', 'mypy'],
\ 'sh': ['shellcheck'],
\}
let g:ale_python_flake8_change_directory = 0

let g:ale_fixers = {
\ 'elm': ['elm-format'],
\ 'fish': ['autofix#fish'],
\ 'haskell': ['hfmt'],
\ 'javascript': ['standard'],
\ 'json': ['jq'],
\ 'python': ['black'],
\ 'sh': ['shfmt'],
\ 'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1
let g:ale_sh_shfmt_options = '-i 2 -ci'
let g:ale_elm_format_options = '--elm-version=0.19 --yes'

nmap <leader>c <plug>(ale_lint)
nmap <leader>r <plug>(ale_reset)
nmap ]e <plug>(ale_next)
nmap [e <plug>(ale_previous)
nnoremap coa :ALEToggle <bar> let g:ale_enabled <cr>
nnoremap cox :let g:ale_fix_on_save = !g:ale_fix_on_save <bar> let g:ale_fix_on_save <cr>

let g:ale_is_running = v:false
autocmd vimrc User ALELintPre let g:ale_is_running = v:true | redrawstatus
autocmd vimrc User ALELintPost let g:ale_is_running = v:false | redrawstatus


" fzf  {{{2
if has('mac')
  set runtimepath+=/usr/local/opt/fzf
endif
nnoremap <c-f> :GFiles <cr>
nnoremap <leader>t :Tags <cr>
nnoremap <leader>h :Helptags <cr>


" vim-sandwich {{{2

" Disable single `s` to avoid conflict with vim-sandwich mappings
nnoremap s <nop>

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


" vim-sneak {{{2
map f <Plug>Sneak_f
map F <Plug>Sneak_F

map <leader>f <Plug>Sneak_s
map <leader>F <Plug>Sneak_S

map t <Plug>Sneak_t
map T <Plug>Sneak_T

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1


" vim-grepper {{{2
let g:grepper = {}
let g:grepper.dir = 'repo'
let g:grepper.tools = ['rg', 'git', 'grep']
let g:grepper.searchreg = 1  " add query to last-search register

nnoremap <leader>s :Grepper <cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)


" others {{{2

" disable netrw plugin, but still allow its autoloaded functions to be used,
" so that fugitive's `:Gbrowse` continue to work.
let g:loaded_netrwPlugin = 1

" vim-markdown
let g:markdown_folding = 1

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

" vim-polyglot
let g:polyglot_disabled = ['markdown']  " use default vim-markdown plugin instead
let g:elm_format_autosave = 0  " from `elm-vim`, not needed since `ale` takes care of this
let g:python_highlight_space_errors = 0  " from `vim-python/python-syntax`

" git-messenger
" see also `after/ftplugin/gitmessengerpopup.vim`
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_no_default_mappings = v:true
nmap gb <Plug>(git-messenger)

" vim-qf
nmap <leader>q <plug>(qf_qf_toggle_stay)
nmap <leader>z <plug>(qf_loc_toggle_stay)

" vim-json
" see also `after/ftplugin/json.vim`
let g:vim_json_syntax_conceal = 1

" vim-fugitive
nnoremap <silent> <leader>g :Gstatus<cr>
nnoremap gh :Gbrowse<cr>

" vim-mundo
nnoremap <silent> cou :MundoToggle<cr>

" vim-signature
nnoremap <silent> com :call marks#toggle()<cr>

" targets.vim
let g:targets_nl = ["\<Space>n", "\<Space>l"]

" coiled snake
let g:coiled_snake_foldtext_flags = ['static']


" Varia {{{1

iabbrev Quebec Québec
iabbrev Montreal Montréal
