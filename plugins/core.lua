return {
  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "███    ██ ██    ██ ██ ███    ███",
        "████   ██ ██    ██ ██ ████  ████",
        "██ ██  ██ ██    ██ ██ ██ ████ ██",
        "██  ██ ██  ██  ██  ██ ██  ██  ██",
        "██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astronvim.utils.status"
      local hl = status.hl

      opts.tabline = { -- bufferline
        { -- file tree padding
          condition = function(self)
            self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
            return status.condition.buffer_matches(
              { filetype = { "aerial", "dapui_.", "dap-repl", "neo%-tree", "NvimTree", "edgy" } },
              vim.api.nvim_win_get_buf(self.winid)
            )
          end,
          provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
          hl = { bg = "tabline_bg" },
        },

        status.heirline.make_buflist(status.component.file_info {
          file_icon = {
            condition = function(self) return not self._show_picker end,
            hl = hl.file_icon "tabline",
          },
          unique_path = {
            hl = function(self) return hl.get_attributes(self.tab_type .. "_path") end,
          },
          padding = { left = 1, right = 1 },
          hl = function(self)
            local tab_type = self.tab_type
            if self._show_picker and self.tab_type ~= "buffer_active" then tab_type = "buffer_visible" end
            return hl.get_attributes(tab_type)
          end,
          surround = false,
        }),

        -- component for each buffer tab
        status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist { -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          },
        },
      }
      return opts
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function(_, opts)
      local ft = require "Comment.ft"
      ft({ "api" }, ft.get "go")
      require("Comment").setup(opts)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-calc" },
      {
        "Exafunction/codeium.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      require("codeium").setup {}

      local kind_icons = {
        Text = "󰉿",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰆧",
        Class = "󰌗",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰇽",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
        Codeium = "󰚩",
        Copilot = "",
      }

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "buffer", priority = 800 },
        { name = "luasnip", priority = 600 },
        { name = "codeium", priority = 500 },
      }, {
        { name = "calc", priority = 1000 },
        { name = "path", priority = 500 },
      })

      opts.formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local menu_name = ({
            nvim_lsp = "LSP",
            luasnip = "Snippet",
            buffer = "Buffer",
            path = "PATH",
            emoji = "emoji",
            calc = "Calc",
            codeium = "Codeium",
            cmdline = "cmd",
          })[entry.source.name]
          vim_item.kind = "[" .. kind_icons[vim_item.kind] .. "] " .. vim_item.kind
          vim_item.menu = "[" .. menu_name .. "]"
          return vim_item
        end,
      }

      return opts
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        follow_current_file = {
          leave_dirs_open = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          always_show = {
            ".gitignored",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  -- {
  --   "L3MON4D3/LuaSnip",
  --   config = function(plugin, opts)
  --     require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     local luasnip = require "luasnip"
  --     luasnip.filetype_extend("javascript", { "javascriptreact" })
  --   end,
  -- },

  {
    "windwp/nvim-autopairs",
    opts = {
      fast_wrap = {
        map = "<A-w>",
      },
    },
  },

  -- By adding to the which-key config and using our helper function you can add more which-key registered bindings
  {
    "folke/which-key.nvim",
    --   config = function(plugin, opts)
    --     require "plugins.configs.which-key"(plugin, opts) -- include the default astronvim config that calls the setup call
    --     -- Add bindings which show up as group name
    --     local wk = require "which-key"
    --     wk.register({
    --       b = { name = "Buffer" },
    --     }, { mode = "n", prefix = "<leader>" })
    --   end,
    -- opts = function(_, opts)
    --   opts.triggers_blacklist = {
    --     -- list of mode / prefixes that should never be hooked by WhichKey
    --     -- this is mostly relevant for keymaps that start with a native binding
    --     i = { "j", "k", "d", "D", "s", "S" },
    --     v = { "j", "k", "d", "D", "s", "S" },
    --     n = { "d", "D", "s", "S" },
    --   }
    --   return opts
    -- end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "White", { fg = "#FFFFFF" })
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      opts.indent = {
        char = "│",
      }
      opts.scope = {
        char = "┃",
        include = {
          node_type = { ["*"] = { "*" } },
        },
      }
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      opts.expand_lines = false
      opts.layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 0.3,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 0.4,
        },
      }
    end,
  },
}
