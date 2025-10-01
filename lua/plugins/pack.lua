---@type LazySpec
return {
  { import = "plugins/packs" },

  -- csharp
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    lazy = true,
    dependencies = {
      {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
          ---@diagnostic disable: missing-fields
          config = {
            omnisharp = {
              handlers = {
                ["textDocument/definition"] = function() require("omnisharp_extended").definition_handler() end,
                ["textDocument/typeDefinition"] = function() require("omnisharp_extended").type_definition_handler() end,
                ["textDocument/references"] = function() require("omnisharp_extended").references_handler() end,
                ["textDocument/implementation"] = function() require("omnisharp_extended").implementation_handler() end,
              },
            },
          },
        },
      },
    },
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
      { "ricardoramirezr/blade-nav.nvim" },
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
    opts = function(_, opts)
      local is_available = require("astrocore").is_available
      opts.features = {
        pickers = {
          enable = true,
          provider = (is_available "telescope.nvim" and "telescope")
            or (is_available "snacks.nvim" and "snacks")
            or "ui.select",
        },
      }
    end,
  },

  {
    "darfink/vim-plist",
    config = function() vim.g.plist_display_format = "json" end,
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

      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then
        astrolsp.lsp_setup "jdtls"
      else
        vim.lsp.config("jdtls", {})
        vim.lsp.enable { "jdtls" }
      end
    end,
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
