" Color scheme, syntax, and encoding {{{
colorscheme badwolf		" colorscheme
set encoding=utf-8
syntax enable			" enable syntax processing
" }}}

" Tab settings {{{
set tabstop=4			" number of spaces per tab
set softtabstop=4		" number of spaces in tab while editing
" }}}

" Line numbers {{{
set number				" see line numbers
" }}}

" Code folding {{{
set foldenable			" enable folding 
set foldlevelstart=10	" would open most folds by default
set foldnestmax=10		" would nest at most 10 folds
set foldmethod=indent	" fold based on indentation level
nnoremap <space> za		" use space to open/close folds
" }}}

" Mode lines {{{
set modelines=1			" check for files w/custom vim format
" }}}

" Cursor movement {{{
nnoremap j gj			" move cursor down by visual line
nnoremap k gk			" move cursor up by visual line
nnoremap B ^			" use B for beginning of line
nnoremap E $			" use E for end of line
" }}}

" Leader key definition {{{
let mapleader=","
" }}}

" Plugins (using vim-plug) {{{
" These get installed calling :PlugInstall
call plug#begin('~/.local/share/nvim/plugged')

" Git
Plug 'tpope/vim-fugitive'
" Go
Plug 'fatih/vim-go'
Plug 'nsf/gocode'
" autocomplete, required pip3 install neovim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --clang-completer' } " the do runs the command on updates, which is required
" status bars
Plug 'itchyny/lightline.vim'

call plug#end()
" }}}

" Vim-Go config {{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_commang = "goimports"
let g:go_fmt_fail_silently = 0
let g:go_fmt_options = '-s '
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
let g:go_metalinter_enabled  = [
      \ 'deadcode',
      \ 'errcheck',
      \ 'gas',
      \ 'goconst',
      \ 'gofmt',
      \ 'goimports',
      \ 'golint',
      \ 'gosimple',
      \ 'gotype',
      \ 'ineffassign',
      \ 'interfacer',
      \ 'misspell',
      \ 'staticcheck',
      \ 'unconvert',
      \ 'unused',
      \ 'varcheck',
      \ 'vet',
      \ 'vetshadow',
\ ]
" }}}

" lightline config {{{
let g:lightline = {
	  \	'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
	  \ }
" }}}
" vim: foldmethod=marker:foldlevel=0
