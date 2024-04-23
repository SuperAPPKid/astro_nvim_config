-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
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

      opts.window = {
        completion = cmp.config.window.bordered { border = "double" },
        documentation = cmp.config.window.bordered { border = "double" },
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
      local core = require "astrocore"

      opts.popup_border_style = "single"

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
      opts.source_selector.sources = core.list_insert_unique(
        opts.source_selector.sources,
        { { source = "diagnostics", display_name = " Issue" } }
      )
      opts.diagnostics = {
        auto_preview = { enabled = true },
      }

      -- add remote
      opts.source_selector.sources =
        core.list_insert_unique(opts.source_selector.sources, { { source = "remote", display_name = "󰌘 Remote" } })

      opts.filesystem = core.extend_tbl(opts.filesystem, {
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

  {
    "windwp/nvim-autopairs",
    -- config = function(plugin, opts)
    --   require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
    --   -- add more custom autopairs configuration such as custom rules
    --   local npairs = require "nvim-autopairs"
    --   local Rule = require "nvim-autopairs.rule"
    --   local cond = require "nvim-autopairs.conds"
    --   npairs.add_rules(
    --     {
    --       Rule("$", "$", { "tex", "latex" })
    --         -- don't add a pair if the next character is %
    --         :with_pair(cond.not_after_regex "%%")
    --         -- don't add a pair if  the previous character is xxx
    --         :with_pair(
    --           cond.not_before_regex("xxx", 3)
    --         )
    --         -- don't move right when repeat character
    --         :with_move(cond.none())
    --         -- don't delete if the next character is xx
    --         :with_del(cond.not_after_regex "xx")
    --         -- disable adding a newline when you press <cr>
    --         :with_cr(cond.none()),
    --     },
    --     -- disable for .vim files, but it work for another filetypes
    --     Rule("a", "a", "-vim")
    --   )
    -- end,
    opts = {
      fast_wrap = {
        map = "<C-r>",
      },
    },
  },

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
    "superappkid/nvim-dap-ui",
    version = false,
    branch = "custom-fork",
    opts = function(_, opts)
      opts.expand_lines = false
      opts.layouts = {
        {
          elements = {
            {
              id = "repl",
              size = 1,
            },
          },
          position = "bottom",
          size = 0.5,
        },
      }
      opts.floating.border = "double"
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
          vim.keymap.set({ "n", "t" }, "<C-q>", function() require("astrocore.buffer").close() end, {
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
      highlights = {
        NormalFloat = {
          link = "NormalDark",
        },
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

  {
    "nvim-telescope/telescope.nvim",
    version = false,
    opts = function(_, opts)
      local defaults = opts.defaults
      defaults.layout_config = {
        height = math.max(math.floor(vim.o.lines * 0.6), 25),
      }
      defaults.borderchars = {
        prompt = { "─", "│", " ", "│", "╭", "╮", " ", " " },
        results = { " ", "│", "─", "│", "│", "│", "┘", "└" },
        preview = { "─", "│", "─", "│", "╭", "┤", "┘", "└" },
      }

      defaults.prompt_prefix = " "
      defaults.selection_caret = " "
      defaults.entry_prefix = " "
      defaults.selection_strategy = "reset"

      opts.defaults = require("telescope.themes").get_ivy(defaults)
    end,
  },

  {
    {
      "neovim/nvim-lspconfig",
      opts = function(_, _) require("lspconfig.ui.windows").default_options.border = "double" end,
    },
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          border = "double",
        },
      },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    version = false,
  },

  {
    "RRethy/vim-illuminate",
    keys = {
      {
        "]c",
        function() require("illuminate").goto_next_reference() end,
        desc = "Move to next reference under cursor",
      },
      {
        "[c",
        function() require("illuminate").goto_prev_reference() end,
        desc = "Move to previous reference under cursor",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    keys = {
      {
        "<leader>xt",
        "<cmd>TodoTrouble<CR>",
        desc = "Todo (Trouble)",
      },
      {
        "<leader>ft",
        "<cmd>TodoTelescope<CR>",
        desc = "Find todo",
      },
      {
        "<leader>fT",
        function() require("telescope.builtin").colorscheme { enable_preview = true } end,
        desc = "Find themes",
      },
    },
  },
}
