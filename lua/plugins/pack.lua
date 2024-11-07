local chezmoi_enabled = vim.fn.executable "chezmoi" == 1

---@type LazySpec
return {
  -- chezmoi
  {
    "alker0/chezmoi.vim",
    enabled = chezmoi_enabled,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              ["chezmoi#use_tmp_buffer"] = 1,
              ["chezmoi#source_dir_path"] = os.getenv "HOME" .. "/.local/share/chezmoi",
            },
          },
        },
      },
    },
  },
  {
    "xvzc/chezmoi.nvim",
    enabled = chezmoi_enabled,
    lazy = true,
    config = function(_, opts)
      require("chezmoi").setup(opts)
      require("telescope").load_extension "chezmoi"
    end,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          autocmds = {
            chezmoi = {
              {
                event = { "BufRead", "BufNewFile" },
                pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/*" },
                callback = function() vim.schedule(require("chezmoi.commands.__edit").watch) end,
              },
            },
          },
          mappings = {
            n = {
              ["<Leader>f."] = {
                function() require("telescope").extensions.chezmoi.find_files() end,
                desc = "Find chezmoi config",
              },
            },
          },
        },
      },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    opts = {
      edit = {
        watch = false,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
        on_watch = false,
      },
      telescope = {
        select = { "<CR>" },
      },
    },
  },

  -- dart
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    ft = "dart",
    config = function(_, opts)
      require("flutter-tools").setup(opts)
      require("telescope").load_extension "flutter"
    end,
    opts = function(_, opts)
      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then opts.lsp = astrolsp.lsp_opts "dartls" end
      opts.debugger = { enabled = true }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- HACK: Disables the select treesitter textobjects because the Dart treesitter parser is very inefficient. Hopefully this gets fixed and this block can be removed in the future.
      -- Reference: https://github.com/AstroNvim/AstroNvim/issues/2707
      local select = vim.tbl_get(opts, "textobjects", "select")
      if select then select.disable = require("astrocore").list_insert_unique(select.disable, { "dart" }) end
    end,
  },

  -- larvel
  {
    "adalessa/laravel.nvim",
    fmt = { "php", "blade" },
    cmd = { "Composer", "Npm", "Yarn", "Laravel", "LaravelModel" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
      "Bleksak/laravel-ide-helper.nvim",
      { "ricardoramirezr/blade-nav.nvim", dependencies = { "hrsh7th/nvim-cmp" } },
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local gen = "Gen"
          local genAll = "GenAll"
          opts.commands["LaravelModel"] = {
            function(cmd)
              local args = cmd.fargs
              if args[1] == "GenAll" then require("laravel-ide-helper").generate_models() end
              if args[1] == "Gen" then require("laravel-ide-helper").generate_models(vim.fn.expand "%") end
            end,
            nargs = 1,
            complete = function() return { gen, genAll } end,
            desc = "Generate Model Info for current model",
          }
        end,
      },
    },
    config = true,
  },

  -- ruby
  {
    "suketa/nvim-dap-ruby",
    ft = "ruby",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = true,
  },
}
