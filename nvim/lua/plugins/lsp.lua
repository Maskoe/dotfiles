return {

  {
    "neovim/nvim-lspconfig",
    --
    opts = {
      -- no effect
      diagnostics = {
        virtual_text = {
          current_line = true,
        },
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

  -- No im pretty sure its this one that stps the dumb autocompletion in .cuade files
  {
    "saghen/blink.cmp",
    -- enabled = false,
    opts = {
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

                -- item.label = item.label .. "  " .. item.score_offset
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
        cs = { "csharpier" },
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
        "csharpier",
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

  -- little bit better inline diagnostics, but not good enough
  -- {
  --   "dgagn/diagflow.nvim",
  --   -- event = 'LspAttach', This is what I use personnally and it works great
  --   opts = {},
  -- },
}
