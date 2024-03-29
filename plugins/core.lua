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
      {
        "petertriho/cmp-git",
        dependencies = "nvim-lua/plenary.nvim",
      },
    },
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.filetype({ "help", "lazy" }, {
        sources = {
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
    opts = function(_, opts)
      local cmp = require "cmp"
      require("cmp_git").setup {}
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
        { name = "luasnip", priority = 800 },
        { name = "buffer", priority = 700 },
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
            git = "Git",
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
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "miversen33/netman.nvim",
    },
    opts = function(_, opts)
      local utils = require "astronvim.utils"

      opts.sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
        "netman.ui.neo-tree",
      }
      opts.source_selector.show_separator_on_edge = true
      opts.source_selector.winbar = false

      -- add diagnostics
      for idx, source in ipairs(opts.source_selector.sources) do
        if source.source == "diagnostics" then
          table.remove(opts.source_selector.sources, idx)
          break
        end
      end
      opts.source_selector.sources =
        utils.list_insert_unique(opts.source_selector.sources, { source = "diagnostics", display_name = " Issue" })
      opts.diagnostics = {
        auto_preview = { enabled = true },
      }

      -- add remote
      opts.source_selector.sources =
        utils.list_insert_unique(opts.source_selector.sources, { source = "remote", display_name = "󰌘 Remote" })

      opts.filesystem = utils.extend_tbl(opts.filesystem, {
        follow_current_file = {
          leave_dirs_open = true,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".github",
          },
          always_show = {
            ".gitignored",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
          never_show_by_pattern = { -- uses glob style patterns
            "/**/..",
          },
        },
      })
    end,
  },

  -- You can disable default plugins as follows:
  -- { "s1n7ax/nvim-window-picker", enabled = false },

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
        map = "<C-r>",
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
    opts = function(_, opts)
      opts.triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for keymaps that start with a native binding
        v = { "d", "D", "s", "S", "f", "F", "t", "T", "y", "Y", "m", "M", "c", "C", "v", "V" },
        n = { "d", "D", "s", "S", "f", "F", "t", "T", "y", "Y", "m", "M", "c", "C", "v", "V" },
      }
      opts.plugins = {
        marks = false, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        presets = {
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = false, -- default bindings on <c-w>
          nav = false, -- misc bindings to work with windows
        },
      }
      return opts
    end,
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
    version = "^3",
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

  {
    "akinsho/toggleterm.nvim",
    config = function(_, opts)
      require("toggleterm").setup(opts)
      vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("my_toggle_term", { clear = true }),
        pattern = "term://*toggleterm#*",
        callback = function(args)
          vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], {
            desc = "Normal mode",
            noremap = true,
            silent = true,
            buffer = args.buf,
          })
          vim.keymap.set({ "n", "t" }, "<C-q>", function() require("astronvim.utils.buffer").close() end, {
            desc = "Close buffer",
            noremap = true,
            silent = true,
            buffer = args.buf,
          })
        end,
      })
    end,
    opts = {
      open_mapping = "<C-t>",
      float_opts = {
        border = "double",
        height = function(_) return vim.o.lines - 4 end,
        width = function(_) return math.floor(vim.o.columns * 0.9) end,
      },
    },
    keys = {
      "<C-t>", -- for lazy loading
    },
  },

  {
    "stevearc/dressing.nvim",
    opts = {
      input = { default_prompt = "" },
    },
  },
}
