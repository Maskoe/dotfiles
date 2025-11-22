local function in_treesitter_capture(capture)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if vim.api.nvim_get_mode().mode == "i" then
    col = col - 1
  end

  local buf = vim.api.nvim_get_current_buf()
  local get_captures_at_pos = require("vim.treesitter").get_captures_at_pos

  local captures_at_cursor = vim.tbl_map(function(x)
    return x.capture
  end, get_captures_at_pos(buf, row - 1, col))

  if vim.tbl_isempty(captures_at_cursor) then
    return false
  elseif type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture) then
    return true
  elseif type(capture) == "table" then
    for _, v in ipairs(capture) do
      if vim.tbl_contains(captures_at_cursor, v) then
        return true
      end
    end
  end
  return false
end

return {

  {
    "neovim/nvim-lspconfig",
    --
    opts = {
      -- no effect
      diagnostics = {
        virtual_text = false,
        -- virtual_text = { . this.this. wow.
        --   current_line = true, wow... this..   this. this. wh this. wh this. wh.. this.
        -- },
      },
      inlay_hints = {
        enabled = false,
      },
      servers = {
        omnisharp = false, -- Explicitly disable THIS ONE ACTUALLY WORKS
        ["*"] = {
          keys = {
            { "K", "7j", desc = "Move down 7 lines", mode = "n" },
          },
        },
      },
    },
  },

  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    ft = { "cs", "razor" },
    opts = {},
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      -- lsp = {
      --   hover = {
      --     ---@type NoiceViewOptions
      --     opts = { border = "double" }, -- merged with defaults from documentation
      --   },
      -- },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%.%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
    end,
  },

  -- No im pretty sure its this one that stps the dumb autocompletion in .cuade files wow. this is
  {
    "saghen/blink.cmp",
    -- enabled = false,
    opts = {
      snippets = {
        preset = "luasnip",
      },
      sources = {
        providers = {
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                local cmp_item_kind = require("blink.cmp.types").CompletionItemKind

                -- Prioritize properties
                if item.kind == cmp_item_kind.Property or item.kind == cmp_item_kind.Field then
                  item.score_offset = item.score_offset + 1
                end

                -- Then methods
                if item.kind == cmp_item_kind.Operator then
                  item.score_offset = item.score_offset - 1
                end

                -- And filter out the mega annoying ones
                local annoying = { "As<>", "As", "ToString", "Dispose", "Equals" }
                for _, annoying_item in ipairs(annoying) do
                  if item.label == annoying_item then
                    item.score_offset = item.score_offset - 2
                  end
                end
              end

              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
              end, items)
            end,
          },
        },
      },
      completion = {
        ghost_text = { enabled = false },
        menu = {
          auto_show = function()
            return not in_treesitter_capture("comment") and not require("luasnip").expand_or_jumpable()
          end,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", "source_name", "source_id" },
            },
          },
        },
      },
      enabled = function()
        local disabled_filetypes = { "markdown", "text", "gitcommit" }
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end,
      keymap = {
        ["<Tab>"] = { "accept", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["."] = {
          function(cmp)
            local item = require("blink.cmp.completion.list").get_selected_item()
            if item then
              local kinds = require("blink.cmp.types").CompletionItemKind
              if
                vim.tbl_contains({ kinds.Variable, kinds.Property, kinds.Enum, kinds.Keyword, kinds.Field }, item.kind)
              then
                cmp.select_and_accept()

                vim.schedule(function()
                  local cursor_pos = vim.api.nvim_win_get_cursor(0)
                  local new_pos = { cursor_pos[1], cursor_pos[2] + 1 }
                  vim.api.nvim_buf_set_text(
                    0,
                    cursor_pos[1] - 1,
                    cursor_pos[2],
                    cursor_pos[1] - 1,
                    cursor_pos[2],
                    { "." }
                  )
                  vim.api.nvim_win_set_cursor(0, new_pos)
                  cmp.show()
                end)

                return true
              end
            end
            return false
          end,
          "accept",
          "fallback",
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = true },
      picker = {
        win = {
          preview = {
            wo = {
              number = false,
              relativenumber = false,
              signcolumn = "no",
              wrap = true, -- <--- Add this line
            },
          },
        },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "<leader>o",
          normal_cur = "<leader>oo",
          normal_line = "<leader>O",
          normal_cur_line = "<leader>OO",
          visual = "<leader>o",
          visual_line = "<leader>O",
          delete = "<leader>do",
          change = "<leader>co",
          change_line = "<leader>cO",
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- cs = { "csharpier" },
        cs = { "roslyn" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      automatic_installation = false,
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = {
        "lua-language-server",

        "xmlformatter",
        -- "csharpier",
        "prettier",

        "stylua",
        -- "bicep-lsp",
        "html-lsp",
        "css-lsp",
        "eslint-lsp",
        "typescript-language-server",
        "json-lsp",
        "rust-analyzer",

        -- !
        "roslyn",
        "rzls",
      },
    },
  },

  {
    "gbprod/yanky.nvim",
    event = "LazyFile",
    opts = {
      system_clipboard = {
        sync_with_ring = not vim.env.SSH_CONNECTION,
      },
      highlight = { timer = 150 },
    },
    keys = {
      {
        "<leader>p",
        function()
          if LazyVim.pick.picker.name == "telescope" then
            require("telescope").extensions.yank_history.yank_history({})
          elseif LazyVim.pick.picker.name == "snacks" then
            Snacks.picker.yanky()
          else
            vim.cmd([[YankyRingHistory]])
          end
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
      -- Keep Yanky for normal mode
      { "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n" }, desc = "Put Text Before Cursor" },
      -- Override for visual mode to not yank replaced text
      { "p", '"_dP', mode = { "x" }, desc = "Put Without Yanking Replaced Text" },
      { "P", '"_dp', mode = { "x" }, desc = "Put Before Without Yanking Replaced Text" },
    },
  },
}
