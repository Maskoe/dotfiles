local dapui = require("dapui")
local dap = require("dap")

--- open ui immediately when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- default configuration

-- https://emojipedia.org/en/stickers/search?q=circle
vim.fn.sign_define("DapBreakpoint", {
  text = "⚪",
  texthl = "DapBreakpointSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})

vim.fn.sign_define("DapStopped", {
  text = "🔴",
  texthl = "yellow",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "⭕",
  texthl = "DapStoppedSymbol",
  linehl = "DapBreakpoint",
  numhl = "DapBreakpoint",
})

dapui.setup()
-- more minimal ui
dapui.setup({
  expand_lines = true,

  controls = { enabled = false }, -- no extra play/step buttons
  floating = { border = "rounded" },

  -- Set dapui window
  render = {
    max_type_length = 60,
    max_value_lines = 200,
  },

  -- Only one layout: just the "scopes" (variables) list at the bottom
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.8 }, -- 100% of this panel is scopes
        { id = "repl", size = 0.2 }, -- 100% of this panel is scopes
      },
      size = 45, -- height in lines (adjust to taste)
      position = "bottom", -- "left", "right", "top", "bottom"
    },
  },
})

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("n", "<leader>du", function()
  dapui.toggle()
end, { desc = "DAP UI toggle" })

map({ "n", "v" }, "<leader>dw", function()
  dapui.eval(nil, { enter = true })
end, { desc = "DAP Add word under cursor to Watches" })

map({ "n", "v" }, "Q", function()
  dapui.eval()
end, { desc = "DAP Peek" })
