-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cs",
--   callback = function()
--     vim.cmd("colorscheme riderdark") -- or whatever rider-like theme you prefer
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
--   callback = function()
--     vim.cmd("colorscheme vscode") -- or whatever vscode-like theme you prefer
--   end,
-- })
--
-- DIsables completions in claude files... maybe. They dont happen anymroe im not sure its this. It looks like it its
-- but im sure this didnt work.
--

-- require("mason-lspconfig").setup({
--   automatic_installation = { exclude = { "omnisharp" } },
-- })
-- local disabled_servers = { "omnisharp" }
-- vim.lsp.config("roslyn", {})
vim.lsp.config("roslyn", {
  on_attach = function()
    print("This will run when the server attaches!")
    vim.lsp.inlay_hint.enable(false)
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "claude", "markdown", "text" }, -- replace with your file types
  callback = function()
    vim.opt_local.completeopt = ""
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 then
      vim.cmd("cd " .. git_root)
    end
  end,
})

-- makes it so that .claude files auto refresh
local timers = {}

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.claude",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Clean up existing timer for this buffer
    if timers[bufnr] then
      timers[bufnr]:stop()
      timers[bufnr]:close()
    end

    local timer = vim.loop.new_timer()
    timers[bufnr] = timer

    timer:start(
      200,
      200,
      vim.schedule_wrap(function()
        -- Check if buffer still exists and is valid
        if vim.api.nvim_buf_is_valid(bufnr) then
          -- vim.print("something")
          vim.cmd("checktime")
        else
          -- Buffer was deleted, clean up
          timer:stop()
          timer:close()
          timers[bufnr] = nil
        end
      end)
    )
  end,
})

-- Cleanup on buffer delete
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufnr = tonumber(vim.fn.expand("<abuf>"))
    if timers[bufnr] then
      timers[bufnr]:stop()
      timers[bufnr]:close()
      timers[bufnr] = nil
    end
  end,
})

-- Treat bg-red-700 as one word
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css" },
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})

-- This will build the project (hardcoded to Api for now)
-- Get back the Errors
-- and make runs the build command and somehow puts the errors into the quick fix window
-- and the quick fix window gets opened with copen
vim.api.nvim_create_user_command("BuildApi", function()
  vim.cmd("compiler dotnet")
  vim.cmd(
    "set makeprg=dotnet\\ build\\ backend/MediaLib.Api\\ -nologo\\ -consoleloggerparameters:NoSummary\\ -consoleloggerparameters:ErrorsOnly"
  )
  vim.cmd("make")
  vim.cmd("copen")
end, {})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local buf = args.buf
--     vim.print("attching or whatever")
--
--     vim.lsp.inlay_hint.enable(false, {})
--     -- Remap K to 7 lines down in this buffer
--     vim.keymap.set("n", "K", "7<Down>", { noremap = true, silent = true, buffer = buf })
--
--     -- Optional: map hover to gh instead
--     vim.keymap.set("n", "gh", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = buf })
--   end,
-- })
--
-- -- default to inline hi nts off
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
--   end,
-- })
--
--

-- thse have an effect.  It changes how they look.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- vim.notify("lsp attaching btw")
    -- vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
    -- vim.lsp.inlay_hint.enable(false)
    -- vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
  end,
})
