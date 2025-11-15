-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- giga smart, this fixes my movement in visual mode when im going up
vim.keymap.set("v", "ii", "2<Up>", { noremap = true })
vim.keymap.set("v", "q", 'i"', { noremap = true })

-- Hide bottom window, whatever it is
vim.keymap.set("n", "<leader>wb", "<C-w>j<C-w>c", { desc = "Close bottom window" })

-- Execute only the query under the cursor by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "dbui" },
  callback = function()
    vim.keymap.set("n", "<leader>S", "vap<Plug>(DBUI_ExecuteQuery)", { buffer = true })
  end,
})

for _, cool in ipairs({ "n", "v" }) do
  vim.keymap.set(cool, "i", "<Up>", { noremap = true, silent = true })
  vim.keymap.set(cool, "k", "<Down>", { noremap = true, silent = true })
  vim.keymap.set(cool, "j", "<Left>", { noremap = true, silent = true })
  vim.keymap.set(cool, "l", "<Right>", { noremap = true, silent = true })

  vim.keymap.set(cool, "I", "7<Up>", { noremap = true, silent = true })
  vim.keymap.set(cool, "K", "7<Down>", { noremap = true, silent = true })
  vim.keymap.set(cool, "J", "^", { noremap = true, silent = true })
  vim.keymap.set(cool, "L", "$", { noremap = true, silent = true })

  vim.keymap.set(cool, "<C-y>", "<C-a>", { noremap = true, silent = true })
  vim.keymap.set(cool, "<C-h>", "<C-x>", { noremap = true, silent = true })

  vim.keymap.set("n", "gh", function()
    vim.lsp.buf.hover()
  end, { noremap = true, silent = true })

  vim.keymap.set("n", "<C-PageDown>", ":bnext<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<C-PageUp>", ":bprevious<CR>", { noremap = true, silent = true })

  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

  -- Make it easier to exit terminal mode
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  vim.keymap.set("t", "<C-i>", "<C-\\><C-n><C-w>k", { desc = "Terminal: Move up" })
  vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>j", { desc = "Terminal: Move down" })
  vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>h", { desc = "Terminal: Move left" })
  vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: Move right" })
  -- Window navigation from any mode
  vim.keymap.set({ "n" }, "<C-i>", "<C-w>k", { desc = "Move to window above" })
  vim.keymap.set({ "n" }, "<C-k>", "<C-w>j", { desc = "Move to window below" })
  vim.keymap.set({ "n" }, "<C-j>", "<C-w>h", { desc = "Move to window left" })
  vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Move to window right" })

  vim.keymap.set("n", "<leader>cw", ":let @+ = getcwd()<CR>", { desc = "Copy cwd to clipboard" })
  vim.keymap.set(cool, ";", ":", { noremap = true })
  vim.keymap.set(cool, ":", ";", { noremap = true })

  vim.keymap.set("n", "<C-n>", "J", { desc = "Join lines" })
end

vim.keymap.set("n", "<leader>;", "A;<Esc>", { desc = "Add semicolon to end of line" })
vim.keymap.set("n", "f", "<Nop>", { desc = "Search with s instead" })
vim.keymap.set("i", "<C-z>", "<Nop>", { desc = "Disable Ctrl-Z in insert mode" })
vim.keymap.set("n", "zz", ":wqall<CR>", { desc = "Save&Quit fr fr", silent = true })
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "Go To Definition", silent = true })
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Code Action", silent = true })
-- vim.keymap.set("n", "<C-w>", ":bdelete<CR>", { desc = "Close current Buffer" }, { noremap = true, silent = true })

-- Move single line up/down in normal mode
vim.keymap.set("n", "<A-i>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-k>", "<cmd>m .+1<CR>==", { desc = "Move line down" })

-- Move visual selection up/down
vim.keymap.set("x", "<A-i>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
vim.keymap.set("x", "<A-k>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set("n", "<leader>space", "<leader>fF", { desc = "Default space space to search real root directory" })

vim.keymap.set({ "n", "v" }, "<C-u>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "<leader>bc", 'ggVG"_dO<Esc>i', { desc = "Clear buffer" })
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking" })

vim.keymap.set("n", "<leader>MA", ":normal! mA<CR>", { desc = "Set mark A" })
vim.keymap.set("n", "<leader>ma", ":normal! 'A<CR>", { desc = "Go to mark A" })

vim.keymap.set("n", "<leader>MB", ":normal! mB<CR>", { desc = "Set mark B" })
vim.keymap.set("n", "<leader>mb", ":normal! 'B<CR>", { desc = "Go to mark B" })

vim.keymap.set("n", "<leader>MC", ":normal! mC<CR>", { desc = "Set mark C" })
vim.keymap.set("n", "<leader>mc", ":normal! 'C<CR>", { desc = "Go to mark C" })

vim.keymap.set("i", "<C-.>", function()
  require("blink.cmp").show()
end, { desc = "Trigger completion" })

vim.keymap.set("n", "dw", "diw")
vim.keymap.set("n", "cw", "ciw")
vim.keymap.set("n", "yw", "yiw")
vim.keymap.set("n", "vw", "viw")

vim.keymap.set("n", "<CR>", "o<Esc>", { desc = "Add new line below and stay in normal mode" })

vim.keymap.set("n", "<C-S-i>", "<c-w>+", { noremap = true, silent = true }) -- grow upward
vim.keymap.set("n", "<C-S-k>", "<c-w>-", { noremap = true, silent = true }) -- shrink down
vim.keymap.set("n", "<C-S-l>", "<c-w>5<", { noremap = true, silent = true }) -- grow left
vim.keymap.set("n", "<C-S-j>", "<c-w>5>", { noremap = true, silent = true }) -- grow right

vim.keymap.set("n", "<leader>xs", ":BuildApi<CR>", { desc = "Show build errors" })

-- Join lines
vim.keymap.set({ "n", "v" }, "<C-->", "J")

-- Extreme horizontal and vertical moving
vim.keymap.set({ "n", "v" }, "J", "^")
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

vim.keymap.set({ "n", "v" }, "I", "7k")
vim.keymap.set({ "n", "v" }, "K", "7j")

-- Insert mode mapping
vim.keymap.set({ "n", "v" }, "h", "i")

-- Operator pending motions (keep inside motions working)
local operators = { "i", "a" }
local delimiters = { "(", '"', "'", "[", "{" }

for _, op in ipairs(operators) do
  for _, delim in ipairs(delimiters) do
    vim.keymap.set("o", op .. delim, op .. delim)
  end
end

-- Visual mode inside motions
vim.keymap.set("v", '"', 'i"')
vim.keymap.set("v", "'", "i'")
vim.keymap.set("v", "(", "i(")
vim.keymap.set("v", "[", "i[")
vim.keymap.set("v", "{", "i{")

-- Shorthand for inside operations
local actions = { "y", "d", "c" }
local inside_mappings = {
  ['"'] = '"',
  ["'"] = "'",
  ["("] = "(",
  ["["] = "[",
  ["{"] = "{",
}

for _, action in ipairs(actions) do
  for key, delim in pairs(inside_mappings) do
    vim.keymap.set("n", action .. key, action .. "i" .. delim)
  end
end

-- Timeout setting
-- vim.opt.timeoutlen = 300

-- ERROR NAVIGATION via leader xe and nN

local error_nav_active = false

local function restore_search()
  if error_nav_active then
    vim.keymap.del("n", "n")
    vim.keymap.del("n", "N")
    error_nav_active = false
  end
end

local function setup_error_navigation()
  if error_nav_active then
    return
  end

  error_nav_active = true

  vim.keymap.set("n", "n", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Next error" })

  vim.keymap.set("n", "N", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Previous error" })

  -- Restore on various search triggers
  vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    pattern = { "/", "\\?" },
    once = true,
    callback = restore_search,
  })

  -- Also restore on * and #
  local original_star = vim.keymap.set("n", "*", function()
    restore_search()
    vim.cmd("normal! *")
  end, { desc = "Search word under cursor" })

  local original_hash = vim.keymap.set("n", "#", function()
    restore_search()
    vim.cmd("normal! #")
  end, { desc = "Search word under cursor backwards" })
end

vim.keymap.set("n", "<leader>xe", function()
  setup_error_navigation()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Start error navigation" })
