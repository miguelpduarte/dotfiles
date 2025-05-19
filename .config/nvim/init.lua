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
-- Default to indent
-- Otherwise, will use LSP or Treesitter if available, in that order.
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

-- path ~= vim.fn.stdpath('config')
-- and (vim.uv.fs_stat(path .. '/.luarc.json')
-- or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
			---@diagnostic disable-next-line: unused-local
			function MoonLightlineReadonly(opts)
				-- saving until the font is fixed
				-- return &readonly && &filetype !=# 'help' ? '' : ''
				return vim.bo.readonly and 'RO' or ''
			end

			-- https://github.com/itchyny/lightline.vim/issues/657
			-- previously vim.cmd
			-- TODO: Move to vim.api.nvim_exec2 probably
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
	{ 'tpope/vim-sleuth' },
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
				},
				pickers = {
					buffers = {
						mappings = {
							n = {
								["<leader>bd"] = require('telescope.actions').delete_buffer
							}
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
		-- TODO: Maybe disable this. Feel like it would be a good idea.
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
			-- Rust
			vim.lsp.config('rust_analyzer', {
				settings = {
					['rust-analyzer'] = {
						-- clippy instead of just cargo check
						check = {
							command = 'clippy',
						},
						cargo = {
							features = 'all',
						},
					},
				},
			})
			vim.lsp.enable('rust_analyzer')

			-- JS/TS
			vim.lsp.config('eslint', {
				-- settings = {
				-- 	workingDirectory = {
				-- 		-- default is "location"
				-- 		-- The docs are not very helpful, from the description these seem like the same...
				-- 		-- Ended up removing it because it was not working sometimes. Unsure why.
				-- 		mode = "auto",
				-- 	}
				-- },
				--- ESLint fix all on save - from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
				---@diagnostic disable-next-line: unused-local
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})
			vim.lsp.enable('eslint')
			vim.lsp.enable('biome')
			vim.lsp.enable('ts_ls')
			-- Svelte has its own LSP apparently, alongside ts_ls
			-- Consider the note here too: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#svelte
			vim.lsp.enable('svelte')

			-- CSS and HTML
			-- Enable (broadcasting) snippet capability for completion
			-- (From https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#cssls)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			vim.lsp.config('cssls', {
			  capabilities = capabilities,
			})
			vim.lsp.enable('cssls')
			-- Similarly for HTML
			vim.lsp.config('html', {
			  capabilities = capabilities,
			})
			vim.lsp.enable('html')
			-- Emmet LSP to write HTML more easily
			-- Chose this LSP over aca/emmet-ls as it seemed more active
			vim.lsp.config('emmet_language_server', {
				filetypes = { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "htmlangular", "svelte", "vue" }
			})
			vim.lsp.enable('emmet_language_server')
			-- JSON
			vim.lsp.config('jsonls', {
				capabilities = capabilities,
			})
			vim.lsp.enable('jsonls')

			-- Nix (using nil)
			vim.lsp.config('nil_ls', {
				settings = {
					['nil'] = {
						formatting = {
							command = { 'nix fmt' }
						}
					}
				}
			})
			vim.lsp.enable('nil_ls')


			-- Terraform
			vim.lsp.enable('terraformls')

			-- Lua
			-- Making it nice for neovim
			-- (From https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls)
			vim.lsp.config('lua_ls', {
			  on_init = function(client)
			    if client.workspace_folders then
			      local path = client.workspace_folders[1].name
			      if
				path ~= vim.fn.stdpath('config')
				and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			      then
				return
			      end
			    end

			    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			      runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
				  'lua/?.lua',
				  'lua/?/init.lua',
				},
			      },
			      -- Make the server aware of Neovim runtime files
			      workspace = {
				checkThirdParty = false,
				library = {
				  vim.env.VIMRUNTIME
				  -- Depending on the usage, you might want to add additional paths
				  -- here.
				  -- '${3rd}/luv/library'
				  -- '${3rd}/busted/library'
				}
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			      }
			    })
			  end,
			  settings = {
			    Lua = {}
			  }
			})
			vim.lsp.enable('lua_ls')

			-- jsonnet and libsonnet
			vim.lsp.enable('jsonnet_ls')

			-- TODO: Add bashls if desired again actually. But shellcheck tends to be good enough.

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			-- `open` defaults to true
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- In theory we could probably call into this multiple times, but let's keep it simple for now to avoid breakage
			-- (source: https://github.com/neovim/neovim/blob/2045e9700c7324cbd3772bc40b3b30b10cf65cc9/runtime/lua/vim/diagnostic.lua#L1164)
			vim.diagnostic.config({
				-- https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-text-handler-changed-from-opt-out-to-opt-in
				-- Unsure if I need/want this but I think I was using it before, so keeping the same behaviour
				-- If it's too noisy, can change to use the new current_line mode.
				virtual_text = true,
				-- Also https://gpanders.com/blog/whats-new-in-neovim-0-11/#virtual-lines
				virtual_lines = {
					-- This one seems noisier so only showing for the current cursor line
					current_line = true,
				},
			})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				-- group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- TODO: many of the below might no longer be needed: https://gpanders.com/blog/whats-new-in-neovim-0-11/#more-default-mappings
					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					-- GOTOs
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', 'gI', vim.lsp.buf.incoming_calls, opts)
					-- > Jumps to the definition of the type of the symbol under the cursor.
					-- Is probably more useful that I was giving it credit for.
					vim.keymap.set('n', 'gk', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					-- I'm pretty sure this will call lsp_signature.nvim
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					-- Don't really use these, maybe should remove:
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>f', function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Toggle LSP inlay hints with <leader>ih if available
					-- Additionally, enable it on attach, so it's enabled by default but also toggleable
					if vim.lsp.inlay_hint then
						vim.keymap.set('n', '<leader>ih', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, opts)
						vim.lsp.inlay_hint.enable(true)
					end
					-- if client.server_capabilities.inlayHintProvider then
					--     -- vim.lsp.inlay_hint(ev.buf, true)
					--     vim.lsp.inlay_hint.enable(ev.buf, true)
					-- end

					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end
					-- https://gpanders.com/blog/whats-new-in-neovim-0-11/#builtin-auto-completion
					if client:supports_method('textDocument/completion') then
						-- TODO: Make this a bit less noisy... has a lot of "Text"
						-- might be caused by a plugin though
						vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
					end
					-- Should no longer be necessary as per the above. TODO: test that
					-- -- Enable completion triggered by <c-x><c-o>
					-- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Prefer LSP folding if supported:
					-- (From https://neovim.io/doc/user/lsp.html#vim.lsp.foldexpr() example)
					if client:supports_method('textDocument/foldingRange') then
						local win = vim.api.nvim_get_current_win()
						vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
						-- sanity
						vim.o.foldmethod = 'expr'
					end

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
			-- Plug 'hrsh7th/cmp-cmdline' ? -- TODO: Actually this is probably useful, sounds like completion in the commandline
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					-- TODO: Imp: Might be a thing to get rid of now actually, check in nvim-cmp docs.
					-- Probably should replace with neovim native snippets since we have 0.10+
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body)
						vim.snippet.expand(args.body)
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
				-- TODO: More sources? Might be cool!
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					-- TODO: figure out what this is lol
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
		---@diagnostic disable-next-line: unused-local
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
	-- Global via treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"rust", "lua", "vim", "vimdoc",
					"query", "javascript", "typescript",
					"markdown", "markdown_inline",
					"terraform"
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				-- https://github.com/andymass/vim-matchup#tree-sitter-integration
				matchup = { enable = true },
			})

			-- TODO: Make this only apply for fts that we support with TS
			-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
			vim.o.foldmethod = 'expr'
			vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		end
	},
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
