-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim.diagnostic.config({ virtual_text = false }) -- has no effect
-- vim.cmd("source ~/.vimrc")

require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})
