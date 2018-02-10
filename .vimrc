"To have absolute line number in current line and relative in others
set number
set relativenumber
"Disables compatibility mode, necessary to have cool features
set nocp
filetype plugin on

"Tab configuration
set shiftwidth=0
set tabstop=4
set noexpandtab

"powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
"To always show powerline hehe
set laststatus=2
" Use 256 colours
set t_Co=256
