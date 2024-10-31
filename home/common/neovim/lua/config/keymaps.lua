-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<A-i>", function()
  require("toggleterm").toggle(nil, nil, nil, "float", nil)
end)
vim.keymap.set("t", "<A-i>", function()
  require("toggleterm").toggle(nil, nil, nil, "float", nil)
end)

vim.keymap.set("n", "<C-n>", vim.cmd.Neotree)
