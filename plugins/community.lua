return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",

  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.bars-and-lines.heirline-vscode-winbar" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      bar = {
        pick = {
          pivots = "hjkluio890",
        },
      },
    },
    keys = {
      {
        "<leader>E",
        function() require("dropbar.api").pick(vim.v.count ~= 0 and vim.v.count) end,
        mode = "n",
        desc = "dropbar",
      },
    },
  },
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
      local prefix = "<leader>R"

      require("astronvim.utils").set_mappings {
        n = {
          [prefix] = { desc = "󰙵 Executor" },
        },
      }

      table.insert(keys, { prefix .. "r", "<cmd>ExecutorRun<CR>", desc = "Run (Executor)" })
      table.insert(keys, { prefix .. "R", "<cmd>ExecutorSetCommand<CR>", desc = "Set Command (Executor)" })
      table.insert(keys, { prefix .. "d", "<cmd>ExecutorShowDetail<CR>", desc = "Show Detail (Executor)" })
      table.insert(keys, { prefix .. "c", "<cmd>ExecutorReset<CR>", desc = "Clear (Executor)" })
      return keys
    end,
  },

  { import = "astrocommunity.color.ccc-nvim" },
  {
    "uga-rosa/ccc.nvim",
    tag = "v1.7.2",
  },
  -- { import = "astrocommunity.color.tint-nvim" },

  { import = "astrocommunity.completion.cmp-cmdline" },

  { import = "astrocommunity.debugging.nvim-bqf" },
  { import = "astrocommunity.debugging.nvim-chainsaw" },
  {
    "chrisgrieser/nvim-chainsaw",
    keys = function(_, _)
      local prefix = "<leader>L"
      local plugin = require "chainsaw"

      require("astronvim.utils").set_mappings {
        n = {
          [prefix] = { desc = "󱂅 Logging" },
        },
      }
      return {
        {
          prefix .. "L",
          function() plugin.variableLog() end,
          desc = "log the name and value for current variable",
        },
        {
          prefix .. "A",
          function() plugin.assertLog() end,
          desc = "assertion statement under the cursor",
        },
        {
          prefix .. "l",
          function() plugin.messageLog() end,
          desc = "create log under the cursor",
        },
        {
          prefix .. "t",
          function() plugin.timelog() end,
          desc = "create time log",
        },
        {
          prefix .. "d",
          function() plugin.removeLogs() end,
          desc = "remove all log created by chainsaw",
        },
      }
    end,
  },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  -- { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
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
  {
    "ThePrimeagen/refactoring.nvim",
    keys = function(_, keys)
      require("astronvim.utils").set_mappings {
        n = {
          ["<leader>r"] = { desc = "󱁤 Refactor" },
        },
      }
      return keys
    end,
  },
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
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.wildfire-nvim" },

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
      local find_target_tab = function(cmd)
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

          vim.cmd(cmd)
        end
      end

      table.insert(keys, {
        "<leader>gd",
        function() find_target_tab "DiffviewOpen -uno -- %" end,
        desc = "Open File Diff",
      })

      table.insert(keys, {
        "<leader>gD",
        function() find_target_tab "DiffviewFileHistory %" end,
        desc = "Open File History",
      })
    end,
  },
  { import = "astrocommunity.git.gist-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.git.openingh-nvim" },

  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },

  -- { import = "astrocommunity.media.vim-wakatime" },

  { import = "astrocommunity.motion.flash-nvim" },
  {
    "folke/flash.nvim",
    config = function(_, opts)
      require("flash").setup(opts)
      vim.api.nvim_set_hl(0, "FlashCursor", { link = "Normal" })
    end,
    opts = {
      labels = "hjukilosdfetg",
      label = {
        current = false,
      },
      modes = {
        search = {
          enabled = false,
        },
        treesitter = {
          labels = "hjukilosdfetg",
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
  { import = "astrocommunity.motion.tabout-nvim" },

  { import = "astrocommunity.programming-language-support.csv-vim" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  { import = "astrocommunity.programming-language-support.xbase" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  -- { import = "astrocommunity.scrolling.satellite-nvim" },

  { import = "astrocommunity.search.nvim-hlslens" },

  -- { import = "astrocommunity.syntax.vim-easy-align" },

  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.test.nvim-coverage" },

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
