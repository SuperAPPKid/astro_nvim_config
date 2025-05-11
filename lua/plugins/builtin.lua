-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = true,
  },

  {
    "numToStr/Comment.nvim",
    enabled = true,
    config = function(_, opts)
      local ft = require "Comment.ft"
      ft({ "goctl" }, ft.get "go")
      require("Comment").setup(opts)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "miversen33/netman.nvim",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>e"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Filesystem" }
          opts.mappings.n["<Leader>B"] = { "<Cmd>Neotree source=buffers toggle<CR>", desc = "Toggle Buffers" }
          opts.mappings.n["<Leader>G"] = { "<Cmd>Neotree source=git_status toggle<CR>", desc = "Toggle Git" }
          opts.mappings.n["<Leader>D"] = { "<Cmd>Neotree source=diagnostics toggle<CR>", desc = "Toggle Diagnostics" }
        end,
      },
    },
    init = function()
      require("utils").git_broadcast = function() require("neo-tree.events").fire_event "git_event" end
    end,
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
        map = "<C-R>",
      },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      delay = 0,
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
    "neovim/nvim-lspconfig",
    opts = function(_, _) require("lspconfig.ui.windows").default_options.border = "double" end,
  },

  {
    "folke/todo-comments.nvim",
    keys = {
      {
        "<Leader>ft",
        "<Cmd>TodoTelescope<CR>",
        desc = "Find todo",
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
