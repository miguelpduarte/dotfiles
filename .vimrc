" Installing vim-plug! (https://github.com/junegunn/vim-plug)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Adding plugins
" (Plugins will be downloaded under the specified directory.)
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/vim-gitbranch'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
" ii, ai, aI
Plug 'michaeljsmith/vim-indent-object'
Plug 'elixir-editors/vim-elixir'
" Elixir IDE-like stuff
Plug 'slashmili/alchemist.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" My configs:

" To have absolute line number in current line and relative in others
set number
set relativenumber

" Disables compatibility mode, necessary to have cool features
set nocp
syntax enable
filetype plugin on

""" Language-specific settings
" Auto format elixir files on save
autocmd BufWritePost *.exs silent :!mix format %
autocmd BufWritePost *.ex silent :!mix format %

" From https://github.com/changemewtf/no_plugins aka the
" youtube talk "How to Do 90% of What Plugins Do (With Just Vim)"
" Finding files
" Search down into subfolders
" (provides tab completion for all file related tasks)
set path+=**
set wildmenu

" Easier split navigation
" (From https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally)
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
set splitbelow
set splitright

" Folding!
" From https://youtube.com/watch?v=oqYQ7leDs0E
set foldmethod=indent
" set foldlevelstart=99 " Commented until I learn folds
" Toggle fold at current position
nnoremap <s-tab> za

" Completion options
" See "help 'complete'"
set complete=.,w,b,u,t,i,kspell

" Turning on spelling for some file types
" See https://vi.stackexchange.com/questions/6950
augroup enableSpellByDefault
    autocmd!
    " Enabling spellchecking by default on latex, markdown and git message
    " files
    autocmd FileType latex,tex,markdown,md,gitcommit setlocal spell
    autocmd BufRead,BufNewFile *.md,*.tex setlocal spell
augroup END

" Improving netrw
" Start in tree list mode (not yet sure if this is best since the pointer does not
" start in the current file/dir, but it's interesting
" to look at the structure at least)
" let g:netrw_liststyle=3
" Toggleable with I, in case it's necessary
let g:netrw_banner = 0
let g:netrw_winsize = '30'

" Tab configuration (test how this works with vim-sensible)
set softtabstop=4
set shiftwidth=4
set tabstop=8
set noexpandtab

" Use 256 colours
if !has('gui_running')
    set t_Co=256
endif

" Hiding the mode as it is already shown in the statusline
set noshowmode

" lightline (https://github.com/itchyny/lightline.vim) config
" cool statusline plugin that seems pretty lightweight, sensible and
" extensible!

" TODO: Add a switch for using powerline fonts or not (default to just text)
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename+modified']],
      \   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']],
      \ },
      \ 'inactive': {
      \   'left': [['filename+modified_inactive']],
      \   'right': [['lineinfo'], ['percent']],
      \ },
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [['close']],
      \ },
      \ 'tab': {
      \   'active': ['tabnum', 'filename', 'modified'],
      \   'inactive': ['tabnum', 'filename_inactive', 'modified'],
      \ },
      \ 'component': {
      \   'filename+modified': '%{LightlineFilepath()}%#BoldFileName#%{LightlineFilename()}%#ModifiedColor#%{LightlineModified()}',
      \   'filename+modified_inactive': '%{LightlineFilepath()}%{LightlineFilename()}%{LightlineModified()}',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineGitbranch',
      \   'readonly': 'LightlineReadonly',
      \   'fileformat': 'LightlineFileformat',
      \   'fileencoding': 'LightlineEncoding',
      \ },
      \ 'tab_component_function': {
      \   'filename': 'LightlineTabFileActive',
      \   'filename_inactive': 'LightlineTabFileInactive',
      \ },
      \ }

function! LightlineGitbranch()
    if exists('*gitbranch#name')
        let branch = gitbranch#name()
        return branch !=# '' ? ''.branch : ''
    endif
    return ''
endfunction

function! LightlineReadonly()
    return &readonly && &filetype !=# 'help' ? '' : ''
endfunction

" Was going to only show filename when active but the lack of highlighting
" makes this confusing
function! LightlineTabFileActive(n)
    return LightlineTabFilepath(a:n) . g:lightline#tab#filename(a:n)
endfunction

function! LightlineTabFileInactive(n)
    return LightlineTabFilepath(a:n) . g:lightline#tab#filename(a:n)
endfunction

function! LightlineTabFilepath(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let relativeparent = expand('#'.buflist[winnr - 1].':h')
    if relativeparent !=# '.'
	return relativeparent . '/'
    else
	return ''
    endif
endfunction

function! LightlineFilepath()
    let relativeparent = expand('%:h')
    if relativeparent !=# '.'
	return relativeparent . '/'
    else
	return ''
    endif
endfunction

function! LightlineFilename()
    " Adjusting based on mode - kinda hardcoded, but do not yet know much
    " vimscript so this works and I'll just roll with it I guess
    "
    " Using '{g:lightline.colorscheme}' makes this based on current theme and not always powerline
    " 4 length array: [guiforeground, guibackground, ctermfg, ctermbg]
    if mode() ==# 'i'
	let colors = g:lightline#colorscheme#{g:lightline.colorscheme}#palette.insert.left[1]
    else
	let colors = g:lightline#colorscheme#{g:lightline.colorscheme}#palette.normal.left[1]
    endif

    exe printf('hi BoldFileName ctermfg=%d ctermbg=%d guifg=%s guibg=%s term=bold cterm=bold',
              \ colors[2], colors[3], colors[0], colors[1])
    let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
    return filename
endfunction

function! LightlineModified()
    " As per https://github.com/itchyny/lightline.vim/issues/22 (with
    " adaptations)
    
    " Getting current colors for respective left component based on mode and
    " colorscheme
    if mode()[0] ==# 'i'
	let left_colors = g:lightline#colorscheme#{g:lightline.colorscheme}#palette.insert.left[1]
    else
	let left_colors = g:lightline#colorscheme#{g:lightline.colorscheme}#palette.normal.left[1]
    endif
    
    " Getting correct background colors for term and gui based on the current
    " colors
    let gui_bgcolor = left_colors[1]
    let term_bgcolor = left_colors[3]

    " Configuring the modified color
    let gui_modifiedcolor = '#ffaf00'
    let term_modifiedcolor = 214

    exe printf('hi ModifiedColor ctermfg=%d ctermbg=%d guifg=%s guibg=%s term=bold cterm=bold',
        \ term_modifiedcolor, term_bgcolor, gui_modifiedcolor, gui_bgcolor)

    let modified = &modified ? ' +' : &modifiable ? '' : ' -'
    return modified
endfunction

function! LightlineFileformat()
    return winwidth(0) > 90 ? &fileformat : ''
endfunction

function! LightlineEncoding()
    return winwidth(0) > 90 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

" end lightline configs
