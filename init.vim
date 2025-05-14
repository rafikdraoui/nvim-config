" vim: foldmethod=marker

" speed up loading of lua modules
lua vim.loader.enable()

" Define `P()` as a global Lua function to pretty-print values
lua _G.P = vim.print

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
set completeopt-=popup
set cursorline cursorlineopt=number  " highlight current line number
set foldlevel=99  " start unfolded by default
set foldmethod=indent
set grepprg=rg\ --vimgrep
set helpheight=1000  " maximize help window
set ignorecase smartcase  " case-insensitive search, unless query has capital letter
set lazyredraw  " only redraw screen when necessary
set list listchars=tab:▸·,extends:❯,precedes:❮,nbsp:⁓
set matchpairs+=«:»
set mouse=
set noswapfile directory=''  " disable swapfile
set notimeout
set relativenumber number numberwidth=1 " use relative line number, but display absolute number on current line
set scrolloff=3
set signcolumn=yes
set splitbelow splitright
set tagcase=smart
set termguicolors
set title
set updatetime=1000
set wildmode=longest:full,full

" Use dedicated directory for spelling word list files. It needs to be the
" "first directory in 'runtimepath' that is writable", according to the
" documentation of 'spellfile'.
let spellfiles_rtp = stdpath('data') .. '/spellfiles'
let &runtimepath=printf('%s,%s', spellfiles_rtp , &runtimepath)

" Allow syntax highlighting of embedded lua in vimscript files
" c.f. $VIMRUNTIME/syntax/vim.vim
let g:vimsyn_embed = 'l'

" Prevent loading of netrw plugin
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

colorscheme couleurs


" Mappings {{{1

let g:mapleader = ','

" Buffers
nnoremap <leader><leader> <c-^>
nnoremap <leader>b :ls<cr>:b<space>
nnoremap <leader>B :ls<cr>:sb<space>
" close quickfix window before `bdelete`, to avoid prematurely quitting vim
" (cf. g:qf_auto_quit)
nnoremap <silent> <leader><bs> :cclose <bar> :lclose <bar> :bdelete<cr>

" Navigate between windows
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-l> <c-w>l
nnoremap <a-p> <c-w>p
tnoremap <expr> <a-h> &ft == 'fzf' ? "<a-h>" : "<c-\><c-n><c-w>h"
tnoremap <expr> <a-j> &ft == 'fzf' ? "<a-j>" : "<c-\><c-n><c-w>j"
tnoremap <expr> <a-k> &ft == 'fzf' ? "<a-k>" : "<c-\><c-n><c-w>k"
tnoremap <expr> <a-l> &ft == 'fzf' ? "<a-l>" : "<c-\><c-n><c-w>l"
tnoremap <expr> <a-p> &ft == 'fzf' ? "<a-p>" : "<c-\><c-n><c-w>p"
xnoremap <a-h> <esc><c-w>h
xnoremap <a-j> <esc><c-w>j
xnoremap <a-k> <esc><c-w>k
xnoremap <a-l> <esc><c-w>l
xnoremap <a-p> <esc><c-w>p

" Resize windows
nnoremap <a-up> 3<c-w>+
nnoremap <a-down> 3<c-w>-
nnoremap <a-right> 3<c-w>>
nnoremap <a-left> 3<c-w><
nnoremap <a-=> <c-w>=
nnoremap <a--> <c-w>_<c-w><bar>

" 'Detach' window to new tab
nnoremap <c-w><c-d> <c-w>T

" Navigate between files in quickfix list
nnoremap <silent> [z :cpfile <cr>
nnoremap <silent> ]z :cnfile <cr>

" Use ctrl-s to save file
nnoremap <silent> <c-s> :update<cr>
inoremap <silent> <c-s> <esc>:update<cr>

" Quit window
nnoremap gq <cmd>quit<cr>

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

nnoremap <leader>s :Grep<space>
nnoremap <leader>S :Grep!<space>

" Search operator
nnoremap <silent> gs :set opfunc=v:lua.require'rafik.opfunc'.search<cr>g@
xnoremap <silent> gs :<c-u>lua require("rafik.opfunc").search(vim.fn.visualmode())<cr>
nmap gss gsiw

" Sort operator
nnoremap zs :echo "sort" <bar> set opfunc=v:lua.require'rafik.opfunc'.sort<cr>g@
xnoremap <silent> zs :<c-u>lua require("rafik.opfunc").sort(vim.fn.visualmode())<cr>

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

" Toggle colorscheme
nnoremap <silent> cog :execute 'colo ' . (g:colors_name ==# 'couleurs' ? 'gris' : 'couleurs') <cr>

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

" Browse commit/file/repo in GitHub
nnoremap <silent> go <cmd>GBrowse<cr>
xnoremap <silent> go :GBrowse<cr>

" Trigger insert mode completions
inoremap ,f <c-x><c-f>
inoremap ,l <c-x><c-l>
inoremap ,t <c-x><c-]>
inoremap ,<tab> <c-x><c-o>

" Display syntax highlight group of term under cursor
nnoremap <leader>H <cmd>Inspect<cr>

" Map some keys on the French-Canadian keyboard to their English (quasi)
" equivalents in normal mode
nnoremap Ç }
nnoremap ¨ {
nnoremap é /
nnoremap É ?
nnoremap è '
nnoremap È "


" Abbreviations {{{1

iabbrev Quebec Québec
iabbrev Montreal Montréal
cabbrev Q! q!
cabbrev CF Cfilter
