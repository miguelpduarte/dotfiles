"To have absolute line number in current line and relative in others
set number
set relativenumber
"Disables compatibility mode, necessary to have cool features
set nocp
filetype plugin on

"Tab configuration
set softtabstop=4
set shiftwidth=4
set tabstop=8
set noexpandtab

"powerline
set rtp+=$HOME/.local/lib/python3.6/site-packages/powerline/bindings/vim/
"To always show powerline hehe
set laststatus=2
" Use 256 colours
set t_Co=256
