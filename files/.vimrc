set tabstop=4
set shiftwidth=4 smarttab
set expandtab
set number
set nowrap
syntax on
set mouse=a
colorscheme slate
hi Normal guibg=NONE cterm=NONE
set sidescroll=1
set cursorline
hi CursorLine gui=underline cterm=underline
set termwinsize=10x0
cd %:p:h
autocmd BufReadPost *
    \ if line("\"") > 0 && line("'\"") <= line ("$") |
    \ exe "normal! g`\"" |
    \ endif
let &t_SI = "\e[5 q"
let &t_EI = "\e[6 q"
set wildmenu
nmap <silent> <C-Left> :tabprevious<CR>
nmap <silent> <C-Right> :tabnext<CR>
nmap <silent> <cr> :$tabnew<CR>
nmap <silent> <Tab> :NERDTree<CR>
nmap <silent> <C-Q> :q<CR>
nmap <silent> <C-W> :w<CR>
nmap <silent> <C-X> :x<CR>
nmap <silent> <C-T> :bot term<CR>
nmap <silent> <C-S-Up> :wincmd k<CR>
nmap <silent> <C-S-Down> :wincmd j<CR>
nmap <silent> <C-S-Left> :wincmd h<CR>
nmap <silent> <C-S-Right> :wincmd l<CR>
tnoremap <silent> <C-S-Up> <c-\><c-n> 
set backspace=indent,eol,start