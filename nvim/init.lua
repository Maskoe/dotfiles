-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vim.diagnostic.config({ virtual_text = false }) -- has no effect
-- vim.cmd("source ~/.vimrc")

require("neotest").setup({
  adapters = {
    require("neotest-dotnet"),
  },
})
require("tiny-inline-diagnostic").setup({
  -- ...
  signs = {
    left = "",
    right = "",
    diag = "●",
    arrow = "    ",
    up_arrow = "    ",
    vertical = " │",
    vertical_end = " └",
  },
  blend = {
    factor = 0.22,
  },
  -- ...
})
