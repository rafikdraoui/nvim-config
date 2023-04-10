" vim: foldmethod=marker

" speed up loading of lua modules
lua vim.loader.enable()

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
set mouse=
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

colorscheme couleurs


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
nnoremap gV `[v`]

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
nnoremap <silent> gs :set opfunc=v:lua.require'lib.opfunc'.search<cr>g@
xnoremap <silent> gs :<c-u>lua require("lib/opfunc").search(vim.fn.visualmode())<cr>
nmap gss gsiw

" Sort operator
nnoremap zs :echo "sort" <bar> set opfunc=v:lua.require'lib.opfunc'.sort<cr>g@
xnoremap <silent> zs :<c-u>lua require("lib/opfunc").sort(vim.fn.visualmode())<cr>

" Open browser at url under cursor
nnoremap <silent> gx <cmd>Browse<cr>

" Toggle spellcheck and spelllang
nnoremap <silent> cos :set spell! <cr>
nnoremap <silent> col :execute 'setlocal spelllang=' . (&spelllang ==# 'en' ? 'fr' : 'en') <cr>

" Toggle cursorline highlighting
nnoremap <silent> coc <cmd>execute 'set cursorlineopt=' . (&culopt ==# 'number' ? 'both' : 'number')<cr>

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
nnoremap <leader>H <cmd>Inspect<cr>

" Map some keys on the French-Canadian keyboard to their English (quasi)
" equivalents in normal mode
nnoremap Ç }
nnoremap ¨ {
nnoremap é /
nnoremap É ?
nnoremap è '


" Plugins configuration {{{1
" See also:
"   lua/plugins.lua
"   lua/config/*.lua

" disable netrw plugin
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" markdown ftplugin (from default $VIMRUNTIME)
let g:markdown_folding = 1

" cfilter (from default $VIMRUNTIME)
packadd! cfilter

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
nnoremap <leader>n <cmd>FzfLua files cwd=$NOTES_DIR prompt=Notes>\ <cr>

" fzf-lua
nnoremap <c-f> <cmd>FzfLua git_files<cr>
nnoremap <c-h> <cmd>FzfLua help_tags<cr>
nnoremap <leader>r <cmd>FzfLua resume<cr>

nnoremap ,pd <cmd>FzfLua git_files cwd=~/dotfiles prompt=Dotfiles>\ <cr>
nnoremap ,pp <cmd>lua require("switch_repo").switch({ search_paths = vim.g.switch_repo_default_search_paths })<cr>
nnoremap ,pv <cmd>lua require("switch_repo").switch({prompt = "Vim plugins", search_paths = vim.api.nvim_get_runtime_file("pack", true) })<cr>

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

" miniyank
nmap p <Plug>(miniyank-autoput)
xmap p <Plug>(miniyank-autoput)
nmap P <Plug>(miniyank-autoPut)
xmap P <Plug>(miniyank-autoPut)
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

" nvim-treesitter
nnoremap <silent> g: <cmd>echo nvim_treesitter#statusline()<cr>
nnoremap <silent> coh <cmd>TSBufToggle highlight<cr>

" formatting
let g:enable_formatting = 1
let g:lsp_format_filetypes = ['go', 'rust']
nnoremap cox <cmd>let g:enable_formatting = !g:enable_formatting <bar> let g:enable_formatting<cr>


" Abbreviations {{{1

iabbrev Quebec Québec
iabbrev Montreal Montréal
cabbrev Q! q!
cabbrev CF Cfilter
