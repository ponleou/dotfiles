require("config.lazy")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- Leader map
vim.g.mapleader = " "

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Move single line up/down in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Comment line/visual selection with ctrl /
vim.keymap.set("n", "<C-/>", "gcc", { remap = true })
vim.keymap.set("v", "<C-/>", "gc", { remap = true })

-- Enable line numbers (relative)
vim.opt.number = true
vim.opt.relativenumber = true

-- Use system clipboard for all yank
vim.opt.clipboard = "unnamedplus"

-- Disable yank on delete (and edit)
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "x", '"_x')
vim.keymap.set({ "n", "v" }, "X", '"_X')
vim.keymap.set({ "n", "v" }, "s", '"_s')
vim.keymap.set({ "n", "v" }, "S", '"_S')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

-- Rebind yank on delete (and edit) with leader
vim.keymap.set({ "n", "v" }, "<leader>d", "d")
vim.keymap.set({ "n", "v" }, "<leader>D", "D")
vim.keymap.set({ "n", "v" }, "<leader>x", "x")
vim.keymap.set({ "n", "v" }, "<leader>X", "X")
vim.keymap.set({ "n", "v" }, "<leader>s", "s")
vim.keymap.set({ "n", "v" }, "<leader>S", "S")
vim.keymap.set({ "n", "v" }, "<leader>c", "c")
vim.keymap.set({ "n", "v" }, "<leader>C", "C")

if vim.g.vscode then
	vim.o.cmdheight = 2000
end
