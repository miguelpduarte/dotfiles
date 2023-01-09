-- line number settings
vim.opt.nu = true
vim.opt.relativenumber = true

-- Should confirm the desired settings since this currently collides with my .vimrc
-- Check out http://vimcasts.org/episodes/tabs-and-spaces/ and https://old.reddit.com/r/vim/comments/4c1r7b/help_me_set_up_better_indentation_d/
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Interesting concept to try out now: instead of using swap or backup, persist undos and use undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't leave the search highlighted, but please highlight it incrementally
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Prime uses 8 but I have smaller screens lol
vim.opt.scrolloff = 4

-- Fast updatetime. See help 'updatetime'
vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
