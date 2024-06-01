-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  {
    import = "astrocommunity.bars-and-lines.dropbar-nvim",
    enabled = function() return vim.fn.has "nvim-0.10" == 1 end,
  },
  {
    "Bekaboo/dropbar.nvim",
    enabled = function() return vim.fn.has "nvim-0.10" == 1 end,
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>E"] = {
            function() require("dropbar.api").pick(vim.v.count ~= 0 and vim.v.count) end,
            desc = "dropbar",
          }
        end,
      },
    },
    opts = {
      bar = {
        pick = {
          pivots = "hjkluio890",
        },
      },
    },
  },

  { import = "astrocommunity.code-runner.executor-nvim" },
  {
    "google/executor.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>R"
          maps.n[prefix] = { desc = "󰙵 Executor" }
          maps.n[prefix .. "r"] = { "<cmd>ExecutorRun<CR>", desc = "Run (Executor)" }
          maps.n[prefix .. "R"] = { "<cmd>ExecutorSetCommand<CR>", desc = "Set Command (Executor)" }
          maps.n[prefix .. "d"] = { "<cmd>ExecutorShowDetail<CR>", desc = "Show Detail (Executor)" }
          maps.n[prefix .. "c"] = { "<cmd>ExecutorReset<CR>", desc = "Clear (Executor)" }
        end,
      },
    },
    opts = {
      use_split = false,
    },
  },

  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-git" },

  { import = "astrocommunity.debugging.nvim-bqf" },
  { import = "astrocommunity.debugging.nvim-chainsaw" },
  {
    "chrisgrieser/nvim-chainsaw",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>L"
          local plugin = require "chainsaw"
          maps.n[prefix] = { desc = "󱂅 Logging" }
          maps.n[prefix .. "L"] = {
            function() plugin.variableLog() end,
            desc = "log the name and value for current variable",
          }
          maps.n[prefix .. "A"] = {
            function() plugin.assertLog() end,
            desc = "assertion statement under the cursor",
          }
          maps.n[prefix .. "l"] = {
            function() plugin.messageLog() end,
            desc = "create log under the cursor",
          }
          maps.n[prefix .. "t"] = {
            function() plugin.timelog() end,
            desc = "create time log",
          }
          maps.n[prefix .. "d"] = {
            function() plugin.removeLogs() end,
            desc = "remove all log created by chainsaw",
          }
        end,
      },
    },
  },

  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  -- { import = "astrocommunity.debugging.nvim-dap-virtual-text" },

  -- { import = "astrocommunity.diagnostics.error-lens-nvim" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- { import = "astrocommunity.editing-support.chatgpt-nvim" },
  { import = "astrocommunity.editing-support.bigfile-nvim" },
  { import = "astrocommunity.editing-support.cloak-nvim" },
  {
    "laytan/cloak.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zk"] = {
            "<cmd>CloakToggle<CR>",
            desc = "cloak",
          }
        end,
      },
    },
  },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  -- { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  {
    "tomiis4/Hypersonic.nvim",
    opts = {
      enable_cmdline = false,
    },
  },
  -- { import = "astrocommunity.editing-support.multicursors-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  -- { import = "astrocommunity.editing-support.nvim-devdocs" },
  { import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.wildfire-nvim" },

  { import = "astrocommunity.game.leetcode-nvim" },
  {
    "kawre/leetcode.nvim",
    opts = {
      arg = "leetcode",
      lang = "golang",
    },
  },

  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.gist-nvim" },
  { import = "astrocommunity.git.gitlinker-nvim" },
  { import = "astrocommunity.git.neogit" },
  {
    "NeogitOrg/neogit",
    branch = "nightly",
  },

  { import = "astrocommunity.indent.indent-rainbowline" },

  { import = "astrocommunity.keybinding.hydra-nvim" },
  {
    "anuvyklack/hydra.nvim",
    opts = function(_, opts)
      local opts_hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]
      opts["Side scroll"] = {
        mode = "n",
        body = "z",
        heads = {
          { "h", "5zh", { desc = "←/→" } },
          { "l", "5zl", { desc = "←/→" } },
          { "H", "zH", { desc = "half screen ←/→" } },
          { "L", "zL", { desc = "half screen ←/→" } },
        },
      }
      opts["Options"] = {
        hint = opts_hint,
        config = {
          invoke_on_body = true,
          hint = {
            border = "double",
            position = "middle",
          },
        },
        mode = { "n", "x" },
        body = "<Leader>uo",
        heads = {
          {
            "n",
            function()
              if vim.o.number == true then
                vim.o.number = false
              else
                vim.o.number = true
              end
            end,
            { desc = "number" },
          },
          {
            "r",
            function()
              if vim.o.relativenumber == true then
                vim.o.relativenumber = false
              else
                vim.o.number = true
                vim.o.relativenumber = true
              end
            end,
            { desc = "relativenumber" },
          },
          {
            "v",
            function()
              if vim.o.virtualedit == "all" then
                vim.o.virtualedit = "block"
              else
                vim.o.virtualedit = "all"
              end
            end,
            { desc = "virtualedit" },
          },
          {
            "i",
            function()
              if vim.o.list == true then
                vim.o.list = false
              else
                vim.o.list = true
              end
            end,
            { desc = "show invisible" },
          },
          {
            "s",
            function()
              if vim.o.spell == true then
                vim.o.spell = false
              else
                vim.o.spell = true
              end
            end,
            { exit = true, desc = "spell" },
          },
          {
            "w",
            function()
              if vim.o.wrap ~= true then
                vim.o.wrap = true
                -- Dealing with word wrap:
                -- If cursor is inside very long line in the file than wraps
                -- around several rows on the screen, then 'j' key moves you to
                -- the next line in the file, but not to the next row on the
                -- screen under your previous position as in other editors. These
                -- bindings fixes this.
                vim.keymap.set(
                  "n",
                  "k",
                  function() return vim.v.count > 0 and "k" or "gk" end,
                  { expr = true, desc = "k or gk" }
                )
                vim.keymap.set(
                  "n",
                  "j",
                  function() return vim.v.count > 0 and "j" or "gj" end,
                  { expr = true, desc = "j or gj" }
                )
              else
                vim.o.wrap = false
                vim.keymap.del("n", "k")
                vim.keymap.del("n", "j")
              end
            end,
            { desc = "wrap" },
          },
          {
            "c",
            function()
              if vim.o.cursorline == true then
                vim.o.cursorline = false
              else
                vim.o.cursorline = true
              end
            end,
            { desc = "cursor line" },
          },
          { "<Esc>", nil, { exit = true } },
        },
      }
    end,
  },
  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },

  { import = "astrocommunity.lsp.actions-preview-nvim" },
  {
    "aznhe21/actions-preview.nvim",
    opts = {
      telescope = {},
    },
  },
  -- { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.lsplinks-nvim" },
  { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },

  { import = "astrocommunity.markdown-and-latex.peek-nvim" },

  { import = "astrocommunity.media.codesnap-nvim" },
  {
    "mistricky/codesnap.nvim",
    opts = {
      save_path = "~/Desktop",
      has_breadcrumbs = true,
      has_line_number = true,
      watermark = "",
      bg_theme = "sea",
    },
  },

  { import = "astrocommunity.motion.flash-nvim" },
  {
    "folke/flash.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local key = "Z"
          local value = {
            function()
              require("flash").jump {
                search = { mode = "search", max_length = 0 },
                label = { after = { 0, 0 } },
                pattern = "^",
              }
            end,
            desc = "jump to a line",
          }
          maps.n[key] = value
          maps.x[key] = value
          maps.o[key] = value
        end,
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      vim.api.nvim_set_hl(0, "FlashCursor", { link = "Normal" })
    end,
    opts = {
      labels = "hjukilonmyfdsgrewvct",
      label = {
        current = false,
      },
      modes = {
        search = {
          enabled = false,
        },
        treesitter = {
          labels = "hjukilonmyfdsgrewvct",
        },
      },
      prompt = {
        enabled = false,
      },
    },
  },
  { import = "astrocommunity.motion.mini-ai" },
  {
    "echasnovski/mini.ai",
    opts = {
      use_nvim_treesitter = false,
      n_lines = 1500,
      search_method = "cover",
      mappings = {
        around_next = "",
        inside_next = "",
        around_last = "",
        inside_last = "",
        goto_left = "",
        goto_right = "",
      },
      silent = true,
    },
  },
  -- { import = "astrocommunity.motion.tabout-nvim" },

  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.programming-language-support.xbase" },

  {
    import = "astrocommunity.recipes.heirline-vscode-winbar",
    enabled = function() return vim.fn.has "nvim-0.10" ~= 1 end,
  },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
  { import = "astrocommunity.recipes.vscode" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },

  { import = "astrocommunity.syntax.vim-easy-align" },

  { import = "astrocommunity.terminal-integration.flatten-nvim" },

  { import = "astrocommunity.test.nvim-coverage" },

  -- { import = "astrocommunity.utility.mason-tool-installer-nvim" },
  {
    import = "astrocommunity.utility.neodim",
    enabled = function() return vim.fn.has "nvim-0.10" == 1 end,
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      alpha = 0.75,
      blend_color = "#000000",
      update_in_insert = {
        enable = true,
        delay = 100,
      },
      hide = {
        virtual_text = false,
        signs = false,
        underline = false,
      },
    },
  },

  -- { import = "astrocommunity.worflow.hardtime-nvim" },

  { import = "astrocommunity.pack.angular" },
  { import = "astrocommunity.pack.ansible" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },
  {
    "p00f/clangd_extensions.nvim",
    optional = true,
    opts = { extensions = { autoSetHints = false } },
  },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.go" },
  {
    "leoluz/nvim-dap-go",
    config = function(_, opts)
      require("dap-go").setup(opts)

      local dap = require "dap"
      local go_debug_configs = dap.configurations.go
      dap.configurations.go = {}

      require("dap.ext.vscode").load_launchjs()
      for _, config in ipairs(go_debug_configs) do
        table.insert(dap.configurations["go"], config)
      end
    end,
  },
  {
    "ray-x/go.nvim",
    optional = true,
    opts = {
      lsp_inlay_hints = { enable = false },
      lsp_codelens = false,
    },
  },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.proto" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.ruby" },
  { import = "astrocommunity.pack.rust" },
  {
    "simrat39/rust-tools.nvim",
    optional = true,
    opts = { tools = { inlay_hints = { auto = false } } },
  },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.svelte" },
  { import = "astrocommunity.pack.swift" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.templ" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.wgsl" },
  { import = "astrocommunity.pack.yaml" },
}
