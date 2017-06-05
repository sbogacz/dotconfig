" Source files, define ignores, and autocmd {{{
execute 'source' '~/.config/nvim/rubix/fzf.vim' 
execute 'source' '~/.config/nvim/rubix/rubix.vim' 


" stuff to ignore when tab completing
set wildignore+=
      \*.o,
      \*.obj,
      \*~,
      \*.so,
      \*.swp,
      \*.DS_Store

augroup MyAutoCmd
	autocmd!
augroup END

set hidden               " hide buffers when they are abandoned
set autoread             " reload files changed outside vim
set autochdir

" }}}

" Color scheme, syntax, and encoding {{{
colorscheme onedark		" colorscheme
set encoding=utf-8
syntax enable			" enable syntax processing

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (empty($TMUX))
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" }}}

" Tab settings {{{
set tabstop=4			" number of spaces per tab
set softtabstop=4		" number of spaces in tab while editing
set shiftwidth=4
set noexpandtab
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

" use clipboard register {{{
if has('clipboard')
  set clipboard=unnamed

  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif
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

" Re-mappings {{{
" W: Save
nnoremap W :w<cr>
" Q: Closes the window
nnoremap Q :q<cr>
" _ : Quick horizontal splits
nnoremap <silent> _ :sp<cr>
" | : Quick vertical splits
nnoremap <silent> <bar> :vsp<cr><Paste>
" ctrl-s: Save
inoremap <c-s> <esc>:w<cr>
" buffer nav
nnoremap <silent> Z :BufSurfBack<cr>
nnoremap <silent> X :BufSurfForward<cr>

" }}}

" Plugins (using vim-plug) {{{
" These get installed calling :PlugInstall
call plug#begin('~/.local/share/nvim/plugged')

" Git
Plug 'tpope/vim-fugitive'
" Go
Plug 'fatih/vim-go'
Plug 'nsf/gocode'
" Autocomplete, required pip3 install neovim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go'
" Status bars
Plug 'itchyny/lightline.vim'
" Broad language support
Plug 'sheerun/vim-polyglot'
" HackerNews client
Plug 'ryanss/vim-hackernews'
" Filesystem navigation
Plug 'scrooloose/nerdtree'
" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Start screen and session management
Plug 'mhinz/vim-startify'
" Show buffers in tabline
Plug 'ap/vim-buftabline'
" Buffer history navigation
Plug 'ton/vim-bufsurf'
" Syntax checking & linting
Plug 'neomake/neomake'
" Hive SQL highlighting
Plug 'autowitch/hive.vim'
" Markdown previewer
Plug 'neovim/node-host', { 'do': 'npm install' }
Plug 'vimlab/mdown.vim', { 'do': 'npm install' }
" Jupyter fron end for Neovim
Plug 'bfredl/nvim-ipy'
" Dart support
Plug 'dart-lang/dart-vim-plugin'
" Python support
Plug 'davidhalter/jedi-vim'
Plug 'mindriot101/vim-yapf'

call plug#end()
" }}}

" Custom grep {{{
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -inH
endif

" }}}

" Neomake config {{{
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_go_enabled_makers = [ 'gofmt', 'go', 'zblint' ]

autocmd MyAutoCmd BufWritePost * if expand('%') !~ '^fugitive:\/\/' | Neomake | endif

let g:neomake_go_gofmt_maker = {
  \ 'args': ['-l', '-e'],
  \ 'errorformat': '%E%f:%l:%c: %m,'
  \ }

let g:neomake_go_zblint_maker = {
  \ 'exe': 'zb',
  \ 'args': [
  \   '--package',
  \   '--log-level', 'INFO',
  \   'lint',
  \   '-n',
  \   '-D', 'gotype',
  \   '-D', 'deadcode',
  \   '-D', 'interfacer',
  \   '-D', 'unconvert',
  \   '-D', 'varcheck',
  \ ],
  \ 'append_file': 0,
  \ 'cwd': '%:h',
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

let g:neomake_go_gometalinter_maker = {
  \ 'args': [
  \   '--tests',
  \   '--enable-gc',
  \   '--concurrency=3',
  \   '--fast',
  \   '-D', 'aligncheck',
  \   '-D', 'gocyclo',
  \   '-D', 'gotype',
  \   '-E', 'gofmt',
  \   '-E', 'goimports',
  \   '-E', 'misspell',
  \   '-E', 'unused',
  \ ],
  \ 'append_file': 0,
  \ 'cwd': '%:h',
  \ 'mapexpr': 'neomake_bufdir . "/" . v:val',
  \ 'errorformat':
  \   '%E%f:%l:%c:%trror: %m,' .
  \   '%W%f:%l:%c:%tarning: %m,' .
  \   '%E%f:%l::%trror: %m,' .
  \   '%W%f:%l::%tarning: %m'
  \ }

" }}}

" Startify config {{{
let g:startify_show_sessions = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_update_oldfiles = 1
let g:startify_session_sort = 1

"}}}

" NERDtree config {{{
nnoremap <leader>nt :NERDTreeToggle<cr>
" }}}

" Vim-Go config {{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 0
"let g:go_fmt_options = '-s '
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>dd <Plug>(go-def)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
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
let g:go_metalinter_deadline = "30s"

" Disable polyglot to not interfere with vim-go's autocomplete
let g:polyglot_disabled = ['go']

" }}}

" Deoplete config {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#skip_chars = ['(', ')']
if !exists('g:deoplete#keyword_patterns')
    let g:deoplete#keyword_patterns = {}
endif
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources = {}
let g:deoplete#sources.go = ['go']
" }}}

" lightline config {{{
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \			    [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
	  \	'component': {
      \   'readonly': '%{&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
	  \ }
" }}}

" FZF Config {{{
nnoremap <silent> <c-p> :FilesProjectDir<cr>
nnoremap <silent> <c-b> :Buffers<cr>
nnoremap <silent> <c-f> :RubixHistory<cr>
nnoremap <silent> <c-s><c-a> :RgRepeat<cr>
nnoremap <silent> <c-s><c-s> :RgProjectDirCursor<cr>
nnoremap <silent> <c-s><c-d> :RgProjectDirPrompt<cr>
nnoremap <silent> <c-s><c-f> :BLines<cr>

let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '10' }
let g:fzf_nvim_statusline = 0

command! -bang FilesProjectDir call fzf#vim#files(rubix#project_dir(), <bang>0)
command! -bang FilesBufferDir  call fzf#vim#files(rubix#buffer_dir(),  <bang>0)
command! -bang FilesCurrentDir call fzf#vim#files(rubix#current_dir(), <bang>0)
command! -bang FilesInputDir   call fzf#vim#files(rubix#input_dir(),   <bang>0)

command! -bang -nargs=* RgProjectDir call rubix#fzf#rg(<q-args>, rubix#project_dir(), <bang>0)
command! -bang -nargs=* RgBufferDir  call rubix#fzf#rg(<q-args>,  rubix#buffer_dir(), <bang>0)
command! -bang -nargs=* RgCurrentDir call rubix#fzf#rg(<q-args>, rubix#current_dir(), <bang>0)
command! -bang -nargs=* RgInputDir   call rubix#fzf#rg(<q-args>,   rubix#input_dir(), <bang>0)

command! -bang -nargs=* AgProjectDir call rubix#fzf#ag(<q-args>, rubix#project_dir(), <bang>0)
command! -bang -nargs=* AgBufferDir  call rubix#fzf#ag(<q-args>,  rubix#buffer_dir(), <bang>0)
command! -bang -nargs=* AgCurrentDir call rubix#fzf#ag(<q-args>, rubix#current_dir(), <bang>0)
command! -bang -nargs=* AgInputDir   call rubix#fzf#ag(<q-args>,   rubix#input_dir(), <bang>0)

command! -bang RgProjectDirCursor call rubix#fzf#rg(expand('<cword>'), rubix#project_dir(), <bang>0)
command! -bang RgBufferDirCursor  call rubix#fzf#rg(expand('<cword>'), rubix#buffer_dir(),  <bang>0)
command! -bang RgCurrentDirCursor call rubix#fzf#rg(expand('<cword>'), rubix#current_dir(), <bang>0)
command! -bang RgInputDirCursor   call rubix#fzf#rg(expand('<cword>'), rubix#input_dir(),   <bang>0)

command! -bang AgProjectDirCursor call rubix#fzf#ag(expand('<cword>'), rubix#project_dir(), <bang>0)
command! -bang AgBufferDirCursor  call rubix#fzf#ag(expand('<cword>'), rubix#buffer_dir(),  <bang>0)
command! -bang AgCurrentDirCursor call rubix#fzf#ag(expand('<cword>'), rubix#current_dir(), <bang>0)
command! -bang AgInputDirCursor   call rubix#fzf#ag(expand('<cword>'), rubix#input_dir(),   <bang>0)

command! -bang RgProjectDirPrompt call rubix#fzf#rg(rubix#input_word(), rubix#project_dir(), <bang>0)
command! -bang RgBufferDirPrompt  call rubix#fzf#rg(rubix#input_word(), rubix#buffer_dir(),  <bang>0)
command! -bang RgCurrentDirPrompt call rubix#fzf#rg(rubix#input_word(), rubix#current_dir(), <bang>0)
command! -bang RgInputDirPrompt   call rubix#fzf#rg(rubix#input_word(), rubix#input_dir(),   <bang>0)

command! -bang AgProjectDirPrompt call rubix#fzf#ag(rubix#input_word(), rubix#project_dir(), <bang>0)
command! -bang AgBufferDirPrompt  call rubix#fzf#ag(rubix#input_word(), rubix#buffer_dir(),  <bang>0)
command! -bang AgCurrentDirPrompt call rubix#fzf#ag(rubix#input_word(), rubix#current_dir(), <bang>0)
command! -bang AgInputDirPrompt   call rubix#fzf#ag(rubix#input_word(), rubix#input_dir(),   <bang>0)

command! -bang RgRepeat call rubix#fzf#rg_repeat(<bang>0)
command! -bang AgRepeat call rubix#fzf#ag_repeat(<bang>0)
command! -bang RubixHistory call rubix#fzf#history(<bang>0)

" }}}

" jedi (Python) config {{{
"autocmd BufWritePost *.py Yapf<cr>
" }}}

" vim: foldmethod=marker:foldlevel=0
