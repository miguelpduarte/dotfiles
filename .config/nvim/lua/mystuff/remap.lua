-- Makes leader key actually usable
vim.g.mapleader = " "

-- vim with some tasty vinegar
vim.keymap.set("n", "-", vim.cmd.Ex)

-- Because copying to system clipboard is always a pain
vim.keymap.set("n", "<leader>y", [["+y]])

-- Just makes a simple subst call easier
-- Stolen from https://github.com/ThePrimeagen/init.lua/blob/a184d58880787512c21429e1ab8bea74546dff75/lua/theprimeagen/remap.lua#L42
vim.keymap.set("n", "<leader>s", [[:%s/<C-r><C-w>/<C-r><C-W>/gI<Left><Left><Left>]])
-- Similar but just for current line. It was relevant at least once, I swear
vim.keymap.set("n", "<leader>S", [[:s/<C-r><C-w>/<C-r><C-W>/gI<Left><Left><Left>]])

-- Stolen from https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text that came also from ThePrimeagen vim confs
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

--[[
" folding!
" from https://youtube.com/watch?v=oqyq7ieds0e
set foldmethod=indent
" set foldlevelstart=99 " commented until i learn folds
" toggle fold at current position
nnoremap <s-tab> za
--]]

--[[
" Turning on spelling for some file types
" See https://vi.stackexchange.com/questions/6950
augroup enableSpellByDefault
    autocmd!
    " Enabling spellchecking by default on latex, markdown and git message
    " files
    autocmd FileType latex,tex,markdown,md,gitcommit,text setlocal spell
    autocmd BufRead,BufNewFile *.md,*.tex,*.txt setlocal spell
augroup END

--]]

-- Easier split navigation
-- (from https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.opt.splitbelow = true
vim.opt.splitright = true
-- set splitbelow
-- set splitright



--[[
" Just makes a simple subst call easier
" Stolen from https://github.com/ThePrimeagen/init.lua/blob/a184d58880787512c21429e1ab8bea74546dff75/lua/theprimeagen/remap.lua#L42
noremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>
" Stolen from https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text that
" came also from ThePrimeagen vim confs
xnoremap <leader>p "_dP
--]]
