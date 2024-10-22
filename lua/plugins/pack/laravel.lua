---@type LazySpec
return {
  {
    "adalessa/laravel.nvim",
    fmt = { "php", "blade" },
    cmd = { "Composer", "Npm", "Yarn", "Laravel", "LaravelModel" },
    specs = {
      { "AstroNvim/astroui", opts = { icons = { Laravel = "󰫐", IdeHelper = "󱚌" } } },
    },
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
}
