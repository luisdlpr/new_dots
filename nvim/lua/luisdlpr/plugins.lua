local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- package manager

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

local plugins = {
	"folke/which-key.nvim",
	{
		"catppuccin/nvim", -- colorscheme
		name = "catppuccin",
		priority = 1000,
	},
	{
		"nvim-telescope/telescope.nvim", -- grep / fuzzy finder
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter", -- syntax highlighting
		build = ":TSUpdate",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"williamboman/mason.nvim", -- lsp
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"numToStr/Comment.nvim",
	},
	{
		"startup-nvim/startup.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"nvimtools/none-ls.nvim", -- better maintained fork of null-ls (non-lsp sources / cli tools to hook into lsp)
	},
	-- autocomplete and snippets (gets messy)
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets", -- generic snippets (vscode like)
		},
	},
	{
		"hrsh7th/nvim-cmp", -- powers autocompletion/snippet window
	},
	{
		"hrsh7th/cmp-nvim-lsp", -- calls lsp for any completions or snippets if possible
	},
	{
		"SmiteshP/nvim-navic",
	},
}

local opts = {}

require("lazy").setup(plugins, opts)

require("catppuccin").setup()
vim.cmd.colorscheme("catppuccin")

require("telescope").setup({
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
		},
	},
})

require("neo-tree").setup({
	filesystem = {
		window = {
			position = "current",
		},
		hijack_netrw_behaviour = "open_default",
	},
})

require("lualine").setup({
	options = { theme = "catppuccin" },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"python",
		"javascript",
		"html",
		"css",
		"dockerfile",
		"json",
		"sql",
		"tsx",
		"typescript",
	},
	auto_install = true,
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local navic = require("nvim-navic")

require("lspconfig").pyright.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
})
require("lspconfig").tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
})
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

require("Comment").setup()

require("startup").setup({ theme = "evil" })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua, -- install in :Mason
		require("null-ls").builtins.formatting.prettier, -- install in :Mason
		require("null-ls").builtins.diagnostics.eslint, -- install in :Mason
	},
	on_attach = function(client, bufnr) -- format on save
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end, -- end format on save
})

local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args) -- specify snippet engine
			require("luasnip").lsp_expand(args.body) -- use `luasnip` engine.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		-- { name = "vsnip" }, -- For vsnip users.
		{ name = "luasnip" }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})
