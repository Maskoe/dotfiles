-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.autoread = true
-- vim.lsp.handlers["textDocument/inlayHint"] = function() end
-- vim.lsp.inlay_hint.enable(false)

vim.filetype.add({
  extension = {
    claude = "markdown",
  },
})

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false

vim.opt.wildmenu = true
vim.opt.wildmode = "full"
