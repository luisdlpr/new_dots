-- TD
-- autocomplete/snippets

vim.g.mapleader = " "

-- tab navigation
vim.keymap.set("n", "<Tab>", ":tabnext<CR>")
vim.keymap.set("n", "<leader><Tab>", ":tabprev<CR>")

-- explorer (NeoTree)
-- vim.keymap.set("n", "<leader>e", vim.cmd.Rexplore)
vim.keymap.set("n", "<leader>e", ":Neotree ./ filesystem toggle left<CR>")

-- telescope/grep/fuzzyfinder
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {}) -- make sure ripgrep is installed
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, {})
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, {})

-- lsp
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, {})

-- null/none-ls
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- move up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- comments
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
