-- sources:
-- https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.lua

-- leader is space.
vim.keymap.set('n', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '

---------------------------------------------------------
-- general prefs
---------------------------------------------------------
-- mandatory.
vim.opt.relativenumber = true
vim.opt.number = true

-- keep more context when scrolling (maybe 1 is enough? experiment)
vim.opt.scrolloff = 2
-- don't wrap by default
vim.opt.wrap = false
-- always show signcolumn (:h sign) so buffer doesn't jump around
vim.opt.signcolumn = 'yes'

-- folding
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent'
-- This is especially annoying in telescope previews so just simplifying it for now.
vim.opt.foldlevelstart = 99

-- splits
vim.opt.splitright = true
vim.opt.splitbelow = true
-- TODO: split binds <C-w> to simple
-- Actually might not, this is ok and leaves more shortcut space
-- Also makes more sense with other base binds that work inside <C-w> space
-- The caps lock rebind was mostly the reason for me to not worry about it lol.
-- ironic

-- undo history, goes to ~/.local/state/nvim/undo/ (clear every now and then)
vim.opt.undofile = true
-- As such, we don't need swapfile nor baks which are clutter
vim.opt.swapfile = false
vim.opt.backup = false
-- TODO: decide if this makes sense at all
vim.opt.updatetime = 200

-- idk from jonhoo
-- vim.opt.wildmode = 'list:longest'
-- ignore in wild match
vim.o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- big 8-space tabs?
-- idk if this collides with other formatting rules, need to see how this works
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 8
vim.opt.tabstop = 8
vim.opt.expandtab = false

-- search/replace is case-insensitive
vim.opt.ignorecase = true
-- except when searching with uppercase
vim.opt.smartcase = true

-- pls no beep (visualbell instead of novisualbell)
vim.opt.vb = true

-- diff stuff from jonhoo
-- more useful diffs (nvim -d) by ignoring whitespace
vim.opt.diffopt:append('iwhite')
-- and smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- long lines guide
vim.opt.colorcolumn = '80'
-- in Rust the rule is 100 instead
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })

-- use better colours
vim.opt.termguicolors = true

---------------------------------------------------------
-- rebinds
---------------------------------------------------------
-- TODO: quick open
-- TODO: search open buffers
--

-- Better netrw + vinegar
-- Toggleable with I if needed
vim.g.netrw_banner = 0
vim.g.netrw_winsize = '30'
-- vim-vinegar <3
vim.keymap.set('', '-', '<cmd>Explore<CR>')

-- Maintain visual mode after shifting indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move text around in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- quick save (new, test)
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- nvim can actually support tab for fold toggle so we don't need to do <s-tab>
-- (nevermind: https://stackoverflow.com/questions/18175647/jump-with-ctrl-i-doesnt-work-in-my-macvim-but-ctrl-o-works)
-- (<c-i> and tab are equivalent, but jumplist is more useful than folding, so keeping that.
vim.keymap.set('n', '<s-tab>', 'za')

-- clear search highlight
-- TODO: Find better keybind. Abandoned jonhoo's OG because <c-h> is what I want to use for splits
vim.keymap.set({ 'v', 'n' }, '<leader>ch', '<cmd>nohlsearch<cr>')

-- <leader><leader> toggles between active buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')

-- <leader>, shows/hides hidden characters
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')

-- center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- Copying to system clipboard made easy
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')

-- Subst made easier
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>')
-- I swear this one is also useful
vim.keymap.set('n', '<leader>S', ':s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>')

-- Replace word with yanked text
vim.keymap.set('x', '<leader>p', '"_dP')

-- Delete into black hole register to not lose yankboard
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

-- TODO: Figure out if "very magic" regexes are actually useful

-- Who needs arrow keys anyway?
vim.keymap.set({ 'n', 'i' }, '<up>', '<nop>')
vim.keymap.set({ 'n', 'i' }, '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')
-- left and right arrows can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')

-- j,k move visually if text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- center
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

---------------------------------------------------------
-- autocmds
---------------------------------------------------------
-- highlight yanked text
vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		pattern = '*',
		command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
	}
)

-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })

-- help filetype detection (add as needed)
-- vim.api.nvim_create_autocmd('BufRead', { pattern = '*.ext', command = 'set filetype=someft' })

-- Enable spelling for certain file types
local spellit = vim.api.nvim_create_augroup('spellit', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
	pattern = { 'text', 'markdown', 'md', 'gitcommit', 'tex', 'latex' },
	group = spellit,
	command = 'setlocal spell',
})
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
	pattern = { '*.txt', '*.md', '*.tex' },
	group = spellit,
	command = 'setlocal spell',
})

---------------------------------------------------------
-- plugin configs
---------------------------------------------------------
-- Using lazy.nvim atm
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- setup plugins now
require('lazy').setup({
	-- Visuals
	-- Decide on colorscheme later, going with this for now
	{
		"folke/tokyonight.nvim",
		-- make sure we load this during startup if it is your main colorscheme
		lazy = false,
		-- make sure to load this before all the other start plugins
		priority = 1000,
		config = function()
			-- load the colorscheme here
			-- give me night with that night
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	-- status line
	{
		'itchyny/lightline.vim',
		lazy = false,
		dependencies = {
			'itchyny/vim-gitbranch',
		},
		config = function()
			-- dont show mode as it's already in lightline
			vim.o.showmode = false
			vim.g.lightline = {
				colorscheme = 'tokyonight',
				active = {
					left = {
						{ 'mode', 'paste' },
						{ 'gitbranch', 'readonly', 'filename+modified' },
					},
					right = {
						{ 'lineinfo' },
						{ 'percent' },
						{ 'fileformat', 'fileencoding', 'filetype' },
					},
				},
				-- TODone: fix the errors when this comes into play (splits)
				-- for now it was slowing me down too much so I'll fix it later
				-- it was just the silly {} that was one level too small lol.
				-- TODO: simplify these configs. Probably can just use the normal filename+modified if modified just changes foreground color
				inactive = {
					left = { { 'filename+modified_inactive' } },
					right = {
						{ 'lineinfo' },
						{ 'percent' },
					},
				},

				-- I'm pretty sure that these are the defaults, so we can unset them so we don't have to worry about the custom fn shenanigans
				-- Either that or they actually don't have any effect, as there didn't seem to be any difference in the tabname and it didn't have a fullname anyway
				-- tabline = {
				-- 	left = { { 'tabs' } },
				-- 	right = { { 'close' } },
				-- },
				-- tab = {
				-- 	active = { 'tabnum', 'filename', 'modified' },
				-- 	inactive = { 'tabnum', 'filename_inactive', 'modified' },
				-- },

				component = {
					-- TODO: bold filename is not working with tokyonight. maybe just use the bold highlight group thingies and don't change the colour?
					['filename+modified'] = '%{LightlineFilepath()}%#BoldFileName#%{LightlineFilename()}%#ModifiedColor#%{LightlineModified()}',
					-- TODO: highlight the modified also when inactive (was setting wrong background color) - maybe only change fg color?
					['filename+modified_inactive'] = '%{LightlineFilepath()}%{LightlineFilename()}%{LightlineModified()}',
				},
				component_function = {
					gitbranch = 'LightlineGitbranch',
					readonly = 'LightlineReadonly',
					fileformat = 'LightlineFileFormat',
					fileencoding = 'LightlineEncoding',
				},
				-- No longer needed since we removed the above
				-- tab_component_function = {
				-- 	filename = 'LightlineTabFileActive',
				-- 	filename_inactive = 'LightlineTabFileInactive',
				-- },
			}
			function MoonLightlineReadonly(opts)
				-- saving until the font is fixed
				-- return &readonly && &filetype !=# 'help' ? '' : ''
				return vim.api.nvim_buf_get_option(0, 'readonly') and 'RO' or ''
			end

			-- https://github.com/itchyny/lightline.vim/issues/657
			-- previously vim.cmd
			vim.api.nvim_exec(
			[[
			" function! LightlineReadonly()
			" 	return &readonly && &filetype !=# 'help' ? '' : ''
			" endfunction
			function! g:LightlineReadonly()
				return v:lua.MoonLightlineReadonly({})
			endfunction

			" TODO: port these to Lua later
			function! LightlineGitbranch()
			    if exists('*gitbranch#name')
				let branch = gitbranch#name()
				return branch !=# '' ? ''.branch : ''
			    endif
			    return ''
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

			    " -- TODO: Actually just set the foreground, as the background should be autoset?

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

			function! LightlineFileFormat()
			    return winwidth(0) > 90 ? &fileformat : ''
			endfunction

			function! LightlineEncoding()
			    return winwidth(0) > 90 ? (&fenc !=# '' ? &fenc : &enc) : ''
			endfunction

			]]
			, true)
		end,
	},
	

	-- essentials
	{ 'tpope/vim-repeat' },
	{ 'tpope/vim-surround' },
	{ 'tpope/vim-commentary' },
	-- ii, ai, aI
	{ 'michaeljsmith/vim-indent-object' },

	-- utilities
	-- telescope for easy ootb fuzzy finder
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('telescope').setup({
				defaults = {
					mappings = {
						n = {
							["<C-s>"] = "select_horizontal"
						}
					}
				}
			})

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<C-p>', builtin.git_files)
			vim.keymap.set('n', '<leader>tf', builtin.find_files)
			vim.keymap.set('n', '<leader>tg', builtin.live_grep)

			vim.keymap.set('n', '<leader>tb', builtin.buffers)
			vim.keymap.set('n', '<leader>tj', builtin.jumplist)
			vim.keymap.set('n', '<leader>tm', builtin.marks)
			vim.keymap.set('n', '<leader>th', builtin.help_tags)
		end,
	},
	-- TODO: leap? Ver se preciso depois de me habituar um pouco
	-- TODO: algum tipo de telescope ou fuzzy finder generico
	-- undotree
	{
		'mbbill/undotree',
		config = function()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
			-- If we are in split hell and need to jump directly
			vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeFocus)
		end,
	},
	-- auto-cd to root of git project
	{
		'notjedi/nvim-rooter.lua',
		config = function()
			require('nvim-rooter').setup()
		end,
	},
	-- better %
	{
		'andymass/vim-matchup',
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = 'popup' }
		end
	},

	-- LSP-related
	-- LSP
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- Setup language servers.
			local lspconfig = require('lspconfig')

			-- Rust
			lspconfig.rust_analyzer.setup({
				-- Server-specific settings. See `:help lspconfig-setup`
				settings = {
					['rust-analyzer'] = {
						-- clippy instead of just cargo check
						check = {
							command = 'clippy',
						},
						cargo = {
							features = 'all',
						},
						-- TODO: figure out if I want this
						imports = {
							group = {
								-- default is true
								enable = false,
							},
						rustfmt = {
							extraArgs = { '+nightly' },
						},
					},
				},
			})

			-- JS/TS
			lspconfig.eslint.setup({
				--- ESLint fix all on save - from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})


			-- jsonnet and libsonnet
			-- (needs manually installed grafana LSP binary in path)
			require('lspconfig').jsonnet_ls.setup({})

			-- I think this probably doesn't work so TODO fix
			-- also can probably just use shellcheck in the meantime
			-- Bash LSP
			local configs = require('lspconfig.configs')
			if not configs.bash_lsp and vim.fn.executable('bash-language-server') == 1 then
				configs.bash_lsp = {
					default_config = {
						cmd = { 'bash-language-server', 'start' },
						filetypes = { 'sh' },
						root_dir = require('lspconfig').util.find_git_ancestor,
						init_options = {
							settings = {
								args = {}
							}
						}
					}
				}
			end
			if configs.bash_lsp then
				lspconfig.bash_lsp.setup({})
			end

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			-- `open` defaults to true
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				-- group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					-- I'm pretty sure this will call lsp_signature.nvim
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					-- Not 100% sure about keybind practicality
					vim.keymap.set('n', 'gI', vim.lsp.buf.incoming_calls, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- if client.server_capabilities.inlayHintProvider then
					--     -- vim.lsp.inlay_hint(ev.buf, true)
					--     vim.lsp.inlay_hint.enable(ev.buf, true)
					-- end

					-- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
					-- *and* there's some way to make it only apply to the current line.
					-- if client.server_capabilities.inlayHintProvider then
					--     vim.lsp.inlay_hint(ev.buf, true)
					-- end

					-- -- None of this semantics tokens business.
					-- -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
					-- client.server_capabilities.semanticTokensProvider = nil
				end,
			})
		end
	},
	-- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			-- Plug 'hrsh7th/cmp-cmdline' ?
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},
	-- inline function signatures
	{
		'ray-x/lsp_signature.nvim',
		event = 'VeryLazy',
		opts = {},
		config = function(_, opts)
			-- Get signatures (and _only_ signatures) when in argument lists.
			require("lsp_signature").setup({
				doc_lines = 0,
				handler_opts = {
					border = "none"
				},
			})
		end,
	},

	-- language support
	-- toml
	'cespare/vim-toml',
	-- yaml
	{
		'cuducos/yaml.nvim',
		ft = { 'yaml' },
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
	},
	-- rust
	{
		'rust-lang/rust.vim',
		ft = { 'rust' },
		config = function()
			-- autofmt on save
			vim.g.rustfmt_autosave = 1
			vim.g.rustfmt_emit_files = 1
			vim.g.rustfmt_fail_silently = 0
			vim.g.rustfmt_clip_command = 'pbcopy'
		end
	},
	-- markdown
	{
		'plasticboy/vim-markdown',
		ft = { 'markdown' },
		dependencies = {
			'godlygeek/tabular',
		},
		config = function()
			-- support fromt-matter in.md files
			vim.g.vim_markdown_frontmatter = 1
			-- insert in lists at the same level
			vim.g.vim_markdown_new_list_item_indent = 0
			-- don't add bullets when wrapping:
			-- https://github.com/preservim/vim-markdown/issues/232
			vim.g.vim_markdown_auto_insert_bullets = 0
		end
	},
	-- jsonnet and libsonnet
	'google/vim-jsonnet',
	-- TODO: asciidoc
})

--[[
colorscheme retrobox

" Better split navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
set splitbelow
set splitright

" Folding!
" (syntax and stuff is better using nvim and treesitter but this is ok for
" now)
set foldmethod=indent
set foldlevelstart=99
" Toggle fold at current pos
nnoremap <s-tab> za

" TODO: Tab configuration
]]--
