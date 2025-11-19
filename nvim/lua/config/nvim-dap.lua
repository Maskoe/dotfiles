local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

local netcoredbg_adapter = {
  type = "executable",
  command = mason_path,
  args = { "--interpreter=vscode" },
}

dap.adapters.netcoredbg = netcoredbg_adapter
dap.adapters.coreclr = netcoredbg_adapter

-- Function to start debugging with specified project
local function start_debug(project_name)
  local projectPath = "/home/mirco/projects/MediaLib/backend/" .. project_name
  local dllPath = projectPath .. "/bin/Debug/net9.0/" .. project_name .. ".dll"

  -- Update the configuration dynamically
  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      console = "internalConsole",
      request = "launch",
      cwd = projectPath,
      env = {
        ASPNETCORE_ENVIRONMENT = "Development",
      },
      program = dllPath,
    },
  }

  if dap.session() then
    dap.continue()
  else
    vim.cmd("wa")

    local start_time = vim.loop.now()
    local timer = vim.loop.new_timer()

    local function update_message()
      local elapsed = math.floor((vim.loop.now() - start_time) / 1000)
      vim.cmd('echo "Building ' .. project_name .. "... (" .. elapsed .. 's)"')
    end

    update_message()
    timer:start(1000, 1000, vim.schedule_wrap(update_message))

    vim.fn.jobstart("dotnet build", {
      cwd = projectPath,
      on_exit = function(job_id, exit_code)
        timer:stop()
        timer:close()
        vim.cmd('echo ""')

        if exit_code == 0 then
          vim.cmd('echo "Build successful, starting debugger for ' .. project_name .. '..."')
          dap.continue()
        else
          vim.notify("Build failed with exit code: " .. exit_code, vim.log.levels.ERROR)
        end
      end,
    })
  end
end

-- Create custom commands
vim.api.nvim_create_user_command("DbgApi", function()
  start_debug("MediaLib.Api")
end, {})

vim.api.nvim_create_user_command("DbgJobs", function()
  start_debug("MediaLib.Jobs")
end, {})

-- Keep your existing keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<S-F5>", function()
  require("dap").terminate()
end, opts)

map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", opts)
map("n", "<F9>", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<F8>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)
map(
  "n",
  "<leader>dt",
  "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
  { noremap = true, silent = true, desc = "debug nearest test" }
)
