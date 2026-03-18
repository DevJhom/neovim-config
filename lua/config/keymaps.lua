vim.keymap.set("n", "<leader>vc", function()
  vim.cmd("edit $MYVIMRC")
end)

vim.keymap.set("n", "<C-Up>", "<C-w>+", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", "<C-w>-", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", "<C-w>>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", "<C-w><", { desc = "Increase width" })