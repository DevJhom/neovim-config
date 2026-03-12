return {
  -- {
  --   "catppuccin/nvim", 
  --   lazy = false,
  --   name = "catppuccin", 
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "catppuccin"
  --   end
  -- }, 
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
      })
      vim.cmd.colorscheme("vscode")
    end,
  }
}