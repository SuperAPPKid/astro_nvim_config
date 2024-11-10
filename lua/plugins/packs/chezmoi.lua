local chezmoi_enabled = vim.fn.executable "chezmoi" == 1

---@type LazySpec
return {
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
}
