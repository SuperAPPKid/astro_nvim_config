-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local dashboard = require "alpha.themes.dashboard"
      -- customize the dashboard header
      dashboard.section.header.val = {
        "███    ██ ██    ██ ██ ███    ███",
        "████   ██ ██    ██ ██ ████  ████",
        "██ ██  ██ ██    ██ ██ ██ ████ ██",
        "██  ██ ██  ██  ██  ██ ██  ██  ██",
        "██   ████   ████   ██ ██      ██",
      }
      dashboard.config.opts.noautocmd = false
      return opts
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function(_, opts)
      local ft = require "Comment.ft"
      ft({ "api" }, ft.get "go")
      ft({ "gowork" }, ft.get "gomod")
      require("Comment").setup(opts)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "chrisgrieser/cmp-nerdfont" },
      -- { "hrsh7th/cmp-emoji" },
      { "js-everts/cmp-tailwind-colors", enabled = false },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-calc" },
      { "f3fora/cmp-spell" },
      {
        "Exafunction/codeium.nvim",
        commit = "937667b2cadc7905e6b9ba18ecf84694cf227567",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        config = function(_, opts) require("codeium").setup(opts) end,
        opts = {
          enable_chat = true,
        },
      },
    },
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype({ "help", "lazy" }, {
        sources = {
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
    opts = function(_, opts)
      local cmp = require "cmp"

      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "nvim_lua", priority = 900 },
        { name = "buffer", priority = 800 },
        { name = "luasnip", priority = 700 },
        { name = "nerdfont", priority = 700 },
        -- { name = "emoji", priority = 700 },
        { name = "codeium", priority = 600 },
        { name = "path", priority = 500 },
        { name = "spell", priority = 400 },
        { name = "calc", priority = 300 },
      }

      local kind_icons = {
        Text = "",
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
        Struct = "󱥒",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
        Codeium = "󰚩",
        Copilot = "",
      }

      local menu_names = {
        nvim_lsp = "LSP",
        nvim_lua = "lua",
        luasnip = "Snippet",
        buffer = "Buffer",
        path = "PATH",
        emoji = "emoji",
        calc = "Calc",
        spell = "Spell",
        codeium = "Codeium",
        cmdline = "cmd",
        git = "Git",
      }

      opts.formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          local ok, hl_colors = pcall(require, "nvim-highlight-colors")
          local color_item = ok and hl_colors.format(entry, { kind = item.kind })

          if color_item and color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = " " .. color_item.abbr .. " " .. item.kind
          else
            item.kind = " " .. kind_icons[item.kind] .. " " .. item.kind
          end

          local menu_name = menu_names[entry.source.name]
          if menu_name then item.menu = "[" .. menu_name .. "]" end
          return item
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
      opts.filesystem.hijack_netrw_behavior = "disabled"

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
    --         -- disable adding a newline when you press <CR>
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
    opts = {
      preset = "modern",
      filter = function(mapping)
        if (mapping.desc or "") == "" then return false end
        local blacklist = ({
          v = { "s", "S", "f", "F", "t", "T" },
          x = { "s", "S", "f", "F", "t", "T" },
          n = { "s", "S", "f", "F", "t", "T" },
        })[mapping.mode]
        if blacklist and vim.tbl_contains(blacklist, mapping.lhs) then return false end
        return true
      end,
      triggers = {
        { "<auto>", mode = "nsx" },
        -- { "<Leader>", mode = { "x" } },
        -- { "g", mode = { "x" } },
        -- { "]", mode = { "x" } },
        -- { "[", mode = { "x" } },
      },
      defer = function(ctx)
        if vim.list_contains({ "d", "y", "m", "c" }, ctx.operator) then return true end
        return vim.list_contains({ "<C-V>", "V", "v" }, ctx.mode)
      end,
      sort = { "group", "alphanum" },
      plugins = {
        marks = false, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = { enabled = false },
        presets = {
          operators = false,
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = false, -- default bindings on <c-w>
          nav = false, -- misc bindings to work with windows
          z = false,
          g = false,
        },
      },
      win = {
        padding = { 0, 0 }, -- extra window padding [top/bottom, right/left]
        border = "double",
      },
      show_help = false,
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      opts.indent = {
        char = "│",
      }
      opts.scope = {
        char = "┃",
        include = {
          node_type = { ["*"] = { "*" } },
        },
      }
      opts.exclude = {
        filetypes = {
          "markdown",
        },
      }
    end,
  },

  {
    "stevearc/dressing.nvim",
    opts = {
      input = { default_prompt = "" },
    },
  },

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

  {
    "kevinhwang91/nvim-ufo",
    version = false,
  },

  {
    "folke/todo-comments.nvim",
    keys = {
      {
        "<Leader>xt",
        "<Cmd>TodoTrouble<CR>",
        desc = "Todo (Trouble)",
      },
      {
        "<Leader>ft",
        "<Cmd>TodoTelescope<CR>",
        desc = "Find todo",
      },
      {
        "<Leader>fT",
        function() require("telescope.builtin").colorscheme { enable_preview = true } end,
        desc = "Find themes",
      },
    },
  },

  {
    "RRethy/vim-illuminate",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["]r"] = {
            function() require("illuminate").goto_next_reference() end,
            desc = maps.n["]r"].desc or "Move to next reference under cursor",
          }
          maps.n["[r"] = {
            function() require("illuminate").goto_prev_reference() end,
            desc = maps.n["[r"].desc or "Move to previous reference under cursor",
          }
        end,
      },
    },
  },

  {
    "b0o/SchemaStore.nvim",
    enabled = false,
  },

  {
    "max397574/better-escape.nvim",
    opts = function(_, opts)
      opts.mappings = {
        i = { j = { j = "<Esc>" } },
        c = {},
        t = {},
        v = {},
        s = {},
      }
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function(_, opts)
      opts.override_by_extension = opts.override_by_extension or {}
      opts.override_by_extension["blade.php"] = {
        icon = "󰫐",
        color = "#f05340",
        cterm_color = "203",
        name = "Blade",
      }
      opts.override_by_extension["php"] = {
        icon = "󰟆",
        color = "#a074c4",
        cterm_color = "140",
        name = "Php",
      }
    end,
  },
}
