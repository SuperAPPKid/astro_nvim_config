-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
local function decode_json_file(filename)
  local file = io.open(filename, "r")
  if file then
    local content = file:read "*all"
    file:close()

    local ok, data = pcall(vim.fn.json_decode, content)
    if ok and type(data) == "table" then return data end
  end
end

local function has_nested_key(json, ...) return vim.tbl_get(json, ...) ~= nil end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  version = false,
  opts = function(_, opts)
    local register_capability_handler = vim.lsp.handlers["client/registerCapability"]

    local new_opts = {
      -- Configuration table of features provided by AstroLSP
      features = {
        autoformat = true, -- enable or disable auto formatting on start
        codelens = true, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = false, -- enable/disable semantic token highlighting
      },
      -- customize lsp formatting options
      formatting = {
        -- control auto formatting on save
        format_on_save = {
          enabled = true, -- enable or disable format on save globally
          allow_filetypes = { -- enable format on save for specified filetypes only
            -- "go",
          },
          ignore_filetypes = { -- disable format on save for specified filetypes
            -- "python",
          },
        },
        disabled = { -- disable formatting capabilities for the listed language servers
          -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
          -- "lua_ls",
        },
        timeout_ms = 500, -- default format timeout
        -- filter = function(client) -- fully override the default formatting function
        --   return true
        -- end
      },
      -- enable servers that you already have installed without mason
      servers = {
        -- "pyright"
      },
      -- Configure default capabilities for language servers (`:h vim.lsp.protocol.make_client.capabilities()`)
      capabilities = {},
      -- customize language server configuration options passed to `lspconfig`
      ---@diagnostic disable: missing-fields
      config = {
        basedpyright = {
          before_init = function(_, c)
            if not c.settings then c.settings = {} end
            if not c.settings.python then c.settings.python = {} end
            c.settings.python.pythonPath = vim.fn.exepath "python"
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedImport = "information",
                  reportUnusedFunction = "information",
                  reportUnusedVariable = "information",
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemberAccess = "none",
                  reportOptionalSubscript = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },
        },
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp" },
          capabilities = {
            offsetEncoding = "utf-8",
          },
        },
        cssls = { init_options = { provideFormatter = false } },
        denols = {
          root_dir = function(...) return require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")(...) end,
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                ST1003 = true,
                deprecated = false,
                fieldalignment = false,
                fillreturns = true,
                nilness = true,
                nonewvars = true,
                shadow = true,
                undeclaredname = true,
                unreachable = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              codelenses = {
                generate = true, -- show the `go generate` lens.
                regenerate_cgo = true,
                test = false,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = true,
                functionTypeParameters = false,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              buildFlags = { "-tags", "integration" },
              completeUnimported = true,
              diagnosticsDelay = "500ms",
              gofumpt = true,
              matcher = "Fuzzy",
              semanticTokens = true,
              staticcheck = true,
              symbolMatcher = "fuzzy",
              usePlaceholders = false,
            },
          },
        },
        html = { init_options = { provideFormatter = false } },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                autoRequire = false,
              },
              hint = {
                enable = true,
                arrayIndex = "Disable",
              },
            },
          },
        },
        phpactor = {
          init_options = {
            ["language_server_reference_reference_finder.reference_timeout"] = 180,
          },
          handlers = {
            ["window/showMessage"] = function(_, _) end,
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  "target",
                },
              },
              check = {
                command = "clippy",
                extraArgs = {
                  "--no-deps",
                },
              },
            },
          },
        },
        svelte = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        tailwindcss = {
          root_dir = function(fname)
            local root_pattern = require("lspconfig").util.root_pattern

            -- First, check for common Tailwind config files
            local root = root_pattern(
              "tailwind.config.mjs",
              "tailwind.config.cjs",
              "tailwind.config.js",
              "tailwind.config.ts",
              "postcss.config.js",
              "config/tailwind.config.js",
              "assets/tailwind.config.js"
            )(fname)
            -- If not found, check for package.json dependencies
            if not root then
              local package_root = root_pattern "package.json"(fname)
              if package_root then
                local package_data = decode_json_file(package_root .. "/package.json")
                if
                  package_data
                  and (
                    has_nested_key(package_data, "dependencies", "tailwindcss")
                    or has_nested_key(package_data, "devDependencies", "tailwindcss")
                  )
                then
                  root = package_root
                end
              end
            end
            return root
          end,
        },
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
        volar = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },
        vtsls = {
          filetypes = require("astrocore").list_insert_unique(vim.tbl_get(opts, "config", "vtsls", "filetypes") or {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          }, { "vue" }),
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            vtsls = {
              enableMoveToFileCodeAction = true,
              tsserver = {
                globalPlugins = {},
              },
            },
          },
          before_init = function(_, config)
            local registry_ok, registry = pcall(require, "mason-registry")
            if not registry_ok then return end
            local vuels = registry.get_package "vue-language-server"

            if vuels:is_installed() then
              local volar_install_path =
                vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server"

              local vue_plugin_config = {
                name = "@vue/typescript-plugin",
                location = volar_install_path,
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              }

              require("astrocore").list_insert_unique(
                config.settings.vtsls.tsserver.globalPlugins,
                { vue_plugin_config }
              )
            end
          end,
        },
      },
      -- customize how language servers are attached
      handlers = {
        -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
        function(server, handler_opts)
          if vim.fn.has "nvim-0.11" ~= 1 then
            for _, handler_opt in pairs(handler_opts) do
              -- HACK: workaround for https://github.com/neovim/neovim/issues/28058
              if type(handler_opt) == "table" and handler_opt.workspace then
                handler_opt.workspace.didChangeWatchedFiles = {
                  dynamicRegistration = true,
                  relativePatternSupport = false,
                }
                break
              end
            end
          end

          -- HACK: fix https://github.com/neovim/nvim-lspconfig/issues/2542
          local old_on_init = handler_opts.on_init
          handler_opts.on_init = function(client, initialization_result)
            if type(old_on_init) == "function" then old_on_init(client, initialization_result) end

            if client.server_capabilities then
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
              client.server_capabilities.semanticTokensProvider = false -- turn off semantic tokens
            end
          end

          require("lspconfig")[server].setup(handler_opts)
        end,

        -- the key is the server that is being setup with `lspconfig`
        -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
        -- set to false to disable the setup of a language server
      },
      -- Configure buffer local auto commands to add when attaching a language server
      autocmds = {
        -- first key is the `augroup` to add the auto commands to (:h augroup)
        lsp_document_highlight = {
          -- Optional condition to create/delete auto command group
          -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
          -- condition will be resolved for each client on each execution and if it ever fails for all clients,
          -- the auto commands will be deleted for that buffer
          cond = "textDocument/documentHighlight",
          -- cond = function(client, bufnr) return client.name == "lua_ls" end,
          -- list of auto commands to set
          {
            -- events to trigger
            event = { "CursorHold", "CursorHoldI" },
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "Document Highlighting",
            callback = function()
              -- vim.lsp.buf.document_highlight()
            end,
          },
          {
            event = { "CursorMoved", "CursorMovedI", "BufLeave" },
            desc = "Document Highlighting Clear",
            callback = function()
              -- vim.lsp.buf.clear_references()
            end,
          },
        },
      },
      lsp_handlers = {
        ["client/registerCapability"] = function(err, res, ctx)
          local ret = register_capability_handler(err, res, ctx)
          -- local attached_client = M.attached_clients[ctx.client_id]
          -- if attached_client then
          --   M.on_attach(attached_client, vim.api.nvim_get_current_buf())
          -- end
          return ret
        end,
      },
      -- mappings to be set up on attaching of a language server
      mappings = {
        n = {
          K = false,
          gk = false,
          ["<Leader>lh"] = false,
          -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
          -- gD = {
          --   function() vim.lsp.buf.declaration() end,
          --   desc = "Declaration of current symbol",
          --   cond = "textDocument/declaration",
          -- },
          -- ["<Leader>uY"] = {
          --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          --   desc = "Toggle LSP semantic highlight (buffer)",
          --   cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
          -- },
        },
      },
      on_attach = function(_, _) end,
    }
    return require("astrocore").extend_tbl(opts, new_opts)
  end,
}
