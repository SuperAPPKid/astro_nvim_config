return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",

  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
  -- { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  {
    "RRethy/vim-illuminate",
    keys = {
      {
        "]c",
        function() require("illuminate").goto_next_reference() end,
        mode = "n",
        desc = "Move to next reference under cursor",
      },
      {
        "[c",
        function() require("illuminate").goto_prev_reference() end,
        mode = "n",
        desc = "Move to previous reference under cursor",
      },
      {
        "a",
        function() require("illuminate").textobj_select() end,
        mode = { "o", "x" },
        desc = "Selects the reference under cursor",
      },
    },
  },

  { import = "astrocommunity.code-runner.executor-nvim" },
  {
    "google/executor.nvim",
    opts = {
      use_split = false,
    },
    keys = function(_, keys)
      local executor_prefix = "<leader>R"
      table.insert(keys, { executor_prefix, desc = "Executor" })
      table.insert(keys, { executor_prefix .. "r", "<cmd>ExecutorRun<CR>", desc = "Run (Executor)" })
      table.insert(keys, { executor_prefix .. "R", "<cmd>ExecutorSetCommand<CR>", desc = "Set Command (Executor)" })
      table.insert(keys, { executor_prefix .. "d", "<cmd>ExecutorShowDetail<CR>", desc = "Show Detail (Executor)" })
      table.insert(keys, { executor_prefix .. "c", "<cmd>ExecutorReset<CR>", desc = "Clear (Executor)" })
      return keys
    end,
  },

  { import = "astrocommunity.color.ccc-nvim" },
  { import = "astrocommunity.color.headlines-nvim" },
  { import = "astrocommunity.color.tint-nvim" },

  { import = "astrocommunity.completion.cmp-cmdline" },

  { import = "astrocommunity.debugging.nvim-bqf" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },

  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- { import = "astrocommunity.editing-support.chatgpt-nvim" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  {
    "tomiis4/Hypersonic.nvim",
    opts = {
      enable_cmdline = false,
    },
  },
  { import = "astrocommunity.editing-support.multicursors-nvim" },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.treesj" },
  {
    "Wansmer/treesj",
    keys = function(_, _)
      return {
        { "<leader>j", "<CMD>TSJToggle<CR>", desc = "Toggle Treesitter Join" },
      }
    end,
  },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.wildfire-nvim" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  {
    "folke/zen-mode.nvim",
    keys = function(_, _)
      return {
        { "<leader>zz", "<CMD>ZenMode<CR>", desc = "Toggle ZenMode" },
      }
    end,
    opts = {
      window = {
        width = 0.85,
        height = 0.95,
        options = {
          number = true,
          relativenumber = true,
        },
      },
    },
  },

  { import = "astrocommunity.file-explorer/oil-nvim" },

  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
  {
    "sindrets/diffview.nvim",
    opts = {
      hooks = {
        view_opened = function() require("diffview.actions").toggle_files() end,
      },
    },
    keys = function(_, keys)
      local last_tabpage = vim.api.nvim_get_current_tabpage()

      table.insert(keys, {
        "<leader>gd",
        function()
          local lib = require "diffview.lib"
          local view = lib.get_current_view()
          if view then
            -- Current tabpage is a Diffview: go to previous tabpage
            vim.api.nvim_set_current_tabpage(last_tabpage)
          else
            for _, v in ipairs(lib.views) do
              local tabn = vim.api.nvim_tabpage_get_number(v.tabpage)
              vim.cmd.tabclose(tabn)
            end

            last_tabpage = vim.api.nvim_get_current_tabpage()

            vim.cmd "DiffviewOpen -uno -- %"
          end
        end,
        desc = "Open Diffview",
      })
    end,
  },
  { import = "astrocommunity.git.gist-nvim" },
  { import = "astrocommunity.git.neogit" },
  -- { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.git.openingh-nvim" },

  { import = "astrocommunity.indent.indent-tools-nvim" },

  { import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },

  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },

  -- { import = "astrocommunity.media.vim-wakatime" },

  { import = "astrocommunity.motion.flash-nvim" },
  {
    "folke/flash.nvim",
    opts = {
      labels = "hjukilosdfetg",
      modes = {
        search = {
          enabled = false,
        },
        treesitter = {
          labels = "hjukilosdfetg",
        },
      },
    },
  },
  { import = "astrocommunity.motion.mini-ai" },
  {
    "echasnovski/mini.ai",
    -- opts = {
    --   silent = true,
    -- },
  },
  { import = "astrocommunity.motion.nvim-surround" },
  {
    "kylechui/nvim-surround",
    opts = {
      keymaps = {
        normal = "yu",
        delete = "du",
        change = "cu",
      },
    },
  },
  { import = "astrocommunity.motion.nvim-spider" },
  { import = "astrocommunity.motion.vim-matchup" },

  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.programming-language-support.rest-nvim" },

  {
    import = "astrocommunity.project.nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  -- { import = "astrocommunity.scrolling.satellite-nvim" },

  { import = "astrocommunity.search.nvim-hlslens" },

  { import = "astrocommunity.syntax.vim-easy-align" },

  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.test.nvim-coverage" },

  { import = "astrocommunity.utility.nvim-toggler" },

  -- { import = "astrocommunity.worflow.hardtime-nvim" },

  { import = "astrocommunity.pack.angular" },
  { import = "astrocommunity.pack.ansible" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },
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
  { import = "astrocommunity.pack.svelte" },
  { import = "astrocommunity.pack.swift" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.wgsl" },
  { import = "astrocommunity.pack.yaml" },
}
