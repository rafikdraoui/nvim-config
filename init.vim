" vim: foldmethod=marker

" speed up loading of lua modules
" c.f. https://github.com/neovim/neovim/pull/15436
lua require("impatient")

" Options {{{1

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
set cursorline cursorlineopt=number  " highlight current line number
set foldlevel=99  " start unfolded by default
set foldmethod=indent
set grepprg=rg\ --vimgrep grepformat^=%f:%l:%c:%m
set helpheight=1000  " maximize help window
set ignorecase smartcase  " case-insensitive search, unless query has capital letter
set lazyredraw  " only redraw screen when necessary
set list listchars=tab:▸·,extends:❯,precedes:❮,nbsp:⁓
set matchpairs+=«:»
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
set wildcharm=<c-z>
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

let g:mapleader = ','

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

" Yank and put from system clipboard
" Recursive maps so that miniyank plugin mappings are preserved
nmap gy "+y
xmap gy "+y
nmap gY "+Y
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

" Navigate between search matches while searching
cnoremap <expr> <tab> getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <s-tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<s-tab>"

" Insert the path of the directory of the current buffer
cnoremap <expr> <c-r>< expand('%:h').'/'

" Join all lines in a paragraph (and make it repeatable through vim-repeat)
nnoremap <silent> gJ vipJ :call repeat#set('gJ')<cr>

" Make file paths in quickfix window relative to repo root
nnoremap <silent> <leader>a :cclose <bar> exe 'cd ' . git#repo_root() <bar> cwindow <bar> cd - <cr>

" Make `*` and `#` respect `smartcase`
nnoremap * /\<<c-r>=expand('<cword>')<cr>\><cr>
nnoremap # ?\<<c-r>=expand('<cword>')<cr>\><cr>

" Run recorded macro on visual selection
function! ExecuteMacroOnSelection()
  execute ":'<,'>normal @" . nr2char(getchar())
endfunction
xnoremap @ :<c-u>call ExecuteMacroOnSelection()<cr>

nnoremap <leader>s :Grep<space>
nnoremap <leader>S :Grep!<space>

" Search operator
nnoremap <silent> gs :set opfunc=opfunc#search<cr>g@
xnoremap <silent> gs :<c-u>call opfunc#search(visualmode())<cr>
nmap gss gsiw

" Sort operator
nnoremap zs :echo "sort" <bar> set opfunc=opfunc#sort<cr>g@
xnoremap <silent> zs :<c-u>call opfunc#sort(visualmode())<cr>

" Open browser at url under cursor
nnoremap <silent> gx :call browse#url()<cr>

" Toggle spellcheck and spelllang
nnoremap <silent> cos :set spell! <cr>
nnoremap <silent> cof :execute 'setlocal spelllang=' . (&spelllang ==# 'en' ? 'fr' : 'en') <cr>

" Toggle cursorline highlighting
nnoremap <silent> col <cmd>execute 'set cursorlineopt=' . (&culopt ==# 'number' ? 'both' : 'number')<cr>

" Toggle wrap
nnoremap <silent> cow :set wrap! <bar> set wrap? <cr>

" Toggle relativenumber
nnoremap <silent> con :set relativenumber!<cr>

" Toggle dark/light background
nnoremap <silent> cob :execute 'set bg=' . (&bg ==# 'dark' ? 'light' : 'dark') <cr>

" Use <esc> to exit terminal mode (and alt-[ to send escape to terminal)
tnoremap <expr> <esc> "<c-\><c-n>"
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

" load packer.nvim plugin
nnoremap <silent> cop <cmd>lua require("plugins")<cr>

" Display syntax highlight group of term under cursor
nnoremap <leader>H <cmd>TSHighlightCapturesUnderCursor<cr>

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

" Delete other buffers
command! -bang Bonly call buffers#bonly(<bang>0)

" Scratch buffer
command! Scratch call scratch#create([])
command! -nargs=1 -complete=command Redir silent call scratch#redir(<q-args>)

command! PackSync lua require "plugins"; vim.cmd[[PackerSync]]

" copy last yank to system clipboard
command! ToSystemClipboard let @+ = @@

" set pwd to root of git repo (if applicable)
command! CdRoot call git#cd_root()

" set pwd to the directory containing the file loaded in buffer
command! CdBuffer cd %:p:h

" Open web browser at given URL (or url under cursor if no argument given)
" This is mostly needed to support Fugitive's `:GBrowse`
command! -nargs=? Browse call browse#url(<f-args>)

" Browse documentation
command! -nargs=* PyDoc call docs#python(<f-args>)
command! -nargs=* GoDoc call docs#golang(<f-args>)

" `git jump` from within vim
" need to use a patched version of git's contrib `git-jump` script
" https://gist.github.com/romainl/a3ddb1d08764b93183260f8cdf0f524f
command! -count=0 -nargs=* -complete=custom,GitJumpComplete Jump call git#jump(<f-args>)
function! GitJumpComplete(...)
  return join(['diff', 'staged', 'merge'], "\n")
endfunction

" Use ripgrep to search for a term in the current git repository. When [!] is
" added, the search is done in the pwd instead.
" The query is added to the vim search register and search history.
command! -nargs=+ -bang -complete=tag Grep call grep#run(<bang>0, <f-args>)

command! Format lua vim.lsp.buf.formatting_seq_sync()

function! MaybeFormat() abort
  if get(g:, 'enable_formatting', 0)
    Format
  endif
endfunction
command! MaybeFormat call MaybeFormat()


" Autocommands {{{1

" define autocmd group `vimrc` and initialize
augroup vimrc
  autocmd!
augroup END

" highlight yank
autocmd vimrc TextYankPost * lua require'vim.highlight'.on_yank()

" Trigger `autoread` when file changes on disk
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * if empty(getcmdwintype()) | checktime | endif
autocmd vimrc FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Make terminal start in insert mode, and disable number and sign columns
autocmd vimrc TermOpen * startinsert | setlocal nonumber norelativenumber signcolumn=auto

" Set 'showbreak' symbol so that it aligns to the right of the line number
" column (whose width varies depending on the number of lines in the buffer.)
autocmd vimrc FocusGained,BufEnter,CursorHold,CursorHoldI * let &showbreak=repeat(' ', float2nr(floor(log10(line('$'))))) . '⋯'

" Run :PackerCompile whenever plugins config is saved
" Uses `*` instead of `$HOME` in the file pattern so that it also works when
" editing the original file in the dotfiles repository.
autocmd vimrc BufWritePost */.config/nvim/lua/plugins.lua source <afile> | PackerCompile

" Set filetype to 'text' if no filetype is detected
autocmd vimrc BufWinEnter * if empty(&filetype) | setfiletype text | endif

" Format files on save (if enabled)
autocmd vimrc BufWritePre * MaybeFormat


" Color scheme {{{1

" Set status line custom highlights when colorscheme is changed
autocmd vimrc ColorScheme * call statusline#set_highlights()
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
  let num_errors = luaeval('#vim.diagnostic.get(0)')
  return num_errors > 0 ? printf('[lint:%d]', num_errors) : ''
endfunction
let &statusline .= '%2*%{LintStatus()}%* '

" line/column numbers
let &statusline .= '%= %p%% %4l/%L:%-2c'


" Plugins configuration {{{1
" See also:
"   lua/plugins.lua
"   lua/config/*.lua

" disable netrw plugin
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" markdown ftplugin (from default $VIMRUNTIME)
let g:markdown_folding = 1

" rust ftplugin (from default $VIMRUNTIME)
let g:rust_fold = 1

" vimwiki
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
nnoremap <leader>n <cmd>Telescope find_files cwd=$NOTES_DIR<cr>

" telescope
nnoremap <c-f> <cmd>Telescope git_files<cr>
nnoremap <c-h> <cmd>Telescope help_tags<cr>
nnoremap <leader>r <cmd>Telescope resume<cr>

" vim-sandwich
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

" vim-subversive
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap cs <plug>(SubversiveSubstituteRange)
xmap cs <plug>(SubversiveSubstituteRange)
nmap css <plug>(SubversiveSubstituteWordRange)
let g:subversiveCurrentTextRegister = 's'

" vim-test
function! ToggleTermStrategy(cmd) abort
  call luaeval("require('toggleterm').exec(_A[1])", [a:cmd])
endfunction
let g:test#custom_strategies = {'toggleterm': function('ToggleTermStrategy')}
let g:test#strategy = 'toggleterm'

let g:test#python#runner = 'pytest'
let g:test#go#gotest#executable = 'gotest'
nnoremap <silent> t<c-n> :TestNearest<cr>
nnoremap <silent> t<c-f> :TestFile<cr>
nnoremap <silent> t<c-s> :TestSuite<cr>
nnoremap <silent> t<c-l> :TestLast<cr>
nnoremap <silent> t<c-g> :TestVisit<cr>

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
" see also: after/ftplugin/gitmessengerpopup.vim
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_no_default_mappings = v:true
nmap gb <Plug>(git-messenger)

" vim-qf
" see also: after/ftplugin/qf.vim
nmap <leader>q <plug>(qf_qf_toggle_stay)
nmap <leader>z <plug>(qf_loc_toggle_stay)

" vim-fugitive
let g:fugitive_legacy_commands = 0
nnoremap <silent> <leader>g <cmd>Git<cr>
nnoremap gh :GBrowse<cr>
xnoremap gh :GBrowse<cr>

" vim-mergetool
nmap <leader>mt <plug>(MergetoolToggle)
nnoremap <silent> <leader>mb :call mergetool#toggle_layout('mr,b')<CR>

" vim-projectionist
let g:projectionist_heuristics = {
\ 'go.mod': {
\   '*.go': {'alternate': '{}_test.go'},
\   '*_test.go': {'type': 'test', 'alternate': '{}.go'},
\  },
\ '*.py': {
\   '*.py': {'alternate': 'test_{}.py'},
\   'test_*.py': {'type': 'test', 'alternate': '{}.py'},
\  }
\}

" vim-delve
let g:delve_new_command = 'new'
let g:delve_sign_priority = 50  " higher than gitsigns and diagnostic

" vim-mundo
nnoremap <silent> cou :MundoToggle<cr>

" targets.vim
let g:targets_nl = ["\<Space>n", "\<Space>l"]

" clever-f
let g:clever_f_fix_key_direction = 1
nmap <leader>f <Plug>(clever-f-reset)

" nvim-colorizer
nnoremap <silent> coh <cmd>ColorizerToggle<cr>

" nvim-treesitter
nnoremap <silent> g: <cmd>echo nvim_treesitter#statusline()<cr>

" diagnostics
lua require("config/diagnostic")
let g:diagnostic_enabled = 1

function! ToggleDiagnostic() abort
  if get(g:, 'diagnostic_enabled', 0)
    lua vim.diagnostic.disable()
  else
    lua vim.diagnostic.enable()
  endif
  let g:diagnostic_enabled = !g:diagnostic_enabled
endfunction
nnoremap cod <cmd>call ToggleDiagnostic()<cr>

nnoremap <leader>c <cmd>lua vim.diagnostic.setloclist({open = true })<cr>
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float({scope = "line", header = false })<cr>
nnoremap [e <cmd>lua vim.diagnostic.goto_prev({ wrap = false, float = false })<cr>
nnoremap ]e <cmd>lua vim.diagnostic.goto_next({ wrap = false, float = false })<cr>

" formatting
let g:enable_formatting = 1
nnoremap cox <cmd>let g:enable_formatting = !g:enable_formatting <bar> let g:enable_formatting<cr>

" filetype detection
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0
lua require("config/filetype")


" Abbreviations {{{1

iabbrev Quebec Québec
iabbrev Montreal Montréal
cabbrev Q! q!
