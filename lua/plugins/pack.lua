---@type LazySpec
return {
  { import = "plugins/packs" },

  -- csharp
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    ft = { "cs", "csproj", "cshtml" },
  },

  -- godot
  {
    "QuickGD/quickgd.nvim",
    ft = { "gdshader", "gdshaderinc" },
    cmd = { "GodotRun", "GodotRunLast", "GodotStart" },
    config = true,
  },

  -- json, yaml
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    dependencies = {
      {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
          ---@diagnostic disable: missing-fields
          config = {
            jsonls = {
              on_new_config = function(config)
                if not config.settings.json.schemas then config.settings.json.schemas = {} end
                vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
              end,
              settings = { json = { validate = { enable = true } } },
            },
            yamlls = {
              on_new_config = function(config)
                config.settings.yaml.schemas = vim.tbl_deep_extend(
                  "force",
                  config.settings.yaml.schemas or {},
                  require("schemastore").yaml.schemas()
                )
              end,
              settings = { yaml = { schemaStore = { enable = false, url = "" } } },
            },
          },
        },
      },
    },
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

  -- java
  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
      { "AstroNvim/astrolsp", opts = function(_, opts) opts.handlers.jdtls = false end },
    },
    config = function(_, opts)
      require("java").setup(opts)
      local lsp_opts = require("astrolsp").lsp_opts "jdtls"
      require("lspconfig").jdtls.setup(lsp_opts)
    end,
  },
}
