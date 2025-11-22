-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- giga smart, this fixes my movement in visual mode when im going up
-- vim.keymap.set("x", "ii", "2<Up>", { noremap = true })
vim.keymap.set("x", "q", 'i"', { noremap = true })

-- Hide bottom window, whatever it is
vim.keymap.set("n", "<leader>wb", "<C-w>j<C-w>c", { desc = "Close bottom window" })

-- Execute only the query under the cursor by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "dbui" },
  callback = function()
    vim.keymap.set("n", "<leader>S", "vap<Plug>(DBUI_ExecuteQuery)", { buffer = true })
  end,
})

-- Stop     Stop Stop
-- vim.keymap.set("v", "p", '"_dP', { silent = true })

vim.keymap.set("x", "p", function()
  return '"_d"' .. vim.v.register .. "P"
end, { expr = true, silent = true })

local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-PageDown>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-PageUp>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Default to inside motions
vim.keymap.set("o", "{", "i{") -- operator-pending mode
vim.keymap.set("o", '"', 'i"')
vim.keymap.set("o", "'", "i'")
vim.keymap.set("o", "(", "i(")
vim.keymap.set("o", "[", "i[")
vim.keymap.set("o", "<", "i[")

-- Visual mode inside motions
vim.keymap.set("x", '"', 'i"')
vim.keymap.set("x", "'", "i'")
vim.keymap.set("x", "(", "i(")
vim.keymap.set("x", "[", "i[")
vim.keymap.set("x", "{", "i{")
vim.keymap.set("x", "<", "i<")

vim.keymap.set({ "n", "v" }, ",", "<nop>")
-- vim.keymap.set("n", "c{", "ci{", { nowait = true })
-- vim.keymap.set("n", "c}", "ci}", { nowait = true })

vim.keymap.set({ "n", "x" }, "i", "<Up>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "<Down>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "<Left>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "l", "<Right>", { noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, "<C-y>", "<C-a>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "<C-h>", "<C-x>", { noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, ";", ":", { noremap = true })
vim.keymap.set({ "n", "x" }, ":", ";", { noremap = true })

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

vim.keymap.set("n", "<C-n>", "J", { desc = "Join lines" })

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
vim.keymap.set("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "Find files from root directory" })

vim.keymap.set({ "n", "v" }, "<C-u>", "<C-i>", { desc = "Jump forward" })
vim.keymap.set("n", "<leader>bc", 'ggVG"_dO<Esc>i', { desc = "Clear buffer" })
-- vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking" })

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
vim.keymap.set({ "n", "x" }, "J", "^")
vim.keymap.set({ "n", "x" }, "L", "$")

vim.keymap.set({ "n", "x" }, "I", "7k")
vim.keymap.set({ "n", "x" }, "K", "7j")

-- Insert mode mapping
vim.keymap.set({ "n", "x" }, "h", "i")

-- Operator pending motions (keep inside motions working)
local operators = { "i", "a" }
local delimiters = { "(", '"', "'", "[", "{" }

for _, op in ipairs(operators) do
  for _, delim in ipairs(delimiters) do
    vim.keymap.set("o", op .. delim, op .. delim)
  end
end

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

-- makes i work instantly in visual mode. The idea is to set the timeoutlen to 0 when entering visual mode.
function Vis(vmode)
  vim.opt.timeoutlen = 1
  vim.defer_fn(function() end, 10)
  return vmode
end

function ToggleTimeoutLen()
  if vim.opt.timeoutlen:get() <= 10 then
    vim.opt.timeoutlen = 1000 -- reset to default
  else
    vim.opt.timeoutlen = 10
  end
end

-- Expression mappings for entering visual mode
vim.keymap.set("n", "V", function()
  vim.opt.timeoutlen = 0
  return "V<Left><Right>"
end, { expr = true })

vim.keymap.set("n", "v", function()
  vim.opt.timeoutlen = 0
  return "v<Left><Right>"
end, { expr = true })

vim.keymap.set("n", "<C-v>", function()
  return Vis("<C-v>")
end, { expr = true })

-- Autocmd to reset timeoutlen when leaving visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "[vV\x16]*:[^vV\x16]*",
  callback = function()
    vim.opt.timeoutlen = 1000 -- reset to your preferred default
  end,
})
