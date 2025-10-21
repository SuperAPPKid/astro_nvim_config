-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  version = false,
  opts = function(_, opts)
    local capabilities = {}
    for k, v in pairs(vim.lsp.protocol.make_client_capabilities()) do
      if type(v) == "table" and v.dynamicRegistration ~= nil then
        capabilities[k] = { v = { dynamicRegistration = false } }
      end
    end

    local new_opts = {
      defaults = {
        hover = { border = "double", silent = true }, -- customize lsp hover window
      },
      -- Configuration table of features provided by AstroLSP
      features = {
        autoformat = true, -- enable or disable auto formatting on start
        codelens = true, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = false, -- enable/disable semantic token highlighting
      },
      -- Configuration of LSP file operation functionality
      file_operations = {
        -- the timeout when executing LSP client operations
        timeout = 10000,
        -- fully disable/enable file operation methods
        operations = {
          willRename = true,
          didRename = true,
          willCreate = true,
          didCreate = true,
          willDelete = true,
          didDelete = true,
        },
      },
      -- A custom flags table to be passed to all language servers  (`:h lspconfig-setup`)
      flags = {
        exit_timeout = 5000,
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
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
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
        golangci_lint_ls = {
          init_options = {
            command = {
              "golangci-lint",
              "run",
              "--output.json.path",
              "stdout",
              "--show-stats=false",
              "--issues-exit-code=1",
            },
          },
        },
        gopls = {
          settings = { -- check https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            gopls = {
              analyses = {
                ST1000 = false,
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
            ["language_server_reference_reference_finder.reference_timeout"] = 120,
          },
          handlers = {
            ["window/showMessage"] = function(_, _) end,
            ["window/showMessageRequest"] = function(_, _) return vim.NIL end,
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
        vue_ls = {
          on_init = function(client)
            client.handlers["tsserver/request"] = function(_, result, context)
              local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = "vtsls" }
              if #clients == 0 then
                vim.notify(
                  "Could not found `vtsls` lsp client, vue_lsp would not work without it.",
                  vim.log.levels.ERROR
                )
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = "typescript.tsserverRequest",
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                client:notify("tsserver/response", response_data)
              end)
            end
          end,
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

            if registry.is_installed "vue-language-server" then
              local vue_plugin_config = {
                name = "@vue/typescript-plugin",
                location = vim.fn.expand "$MASON/packages/vue-language-server/node_modules/@vue/language-server",
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
      -- Extra configuration for the `mason-lspconfig.nvim` plugin
      mason_lspconfig = {},
      -- customize how language servers are attached
      handlers = {
        -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
        function(server, handler_opts, skip_setup)
          if vim.fn.has "nvim-0.11.4" == 0 then
            for _, handler_opt in pairs(handler_opts) do
              -- HACK: workaround for https://github.com/neovim/neovim/issues/28058
              if type(handler_opt) == "table" and handler_opt.workspace then
                handler_opt.workspace.didChangeWatchedFiles = {
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

          if handler_opts.capabilities then
            handler_opts.capabilities = vim.tbl_deep_extend("force", handler_opts.capabilities, capabilities)
          else
            handler_opts.capabilities = capabilities
          end

          if not skip_setup then
            vim.lsp.config(server, handler_opts)
            vim.lsp.enable { server }
          end
        end,

        -- the key is the server that is being setup with `lspconfig`
        -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
        -- set to false to disable the setup of a language server
      },
      -- Configure buffer local user commands to add when attaching a language server
      commands = {},
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
      -- Configuration of mappings added when attaching a language server during the core `on_attach` function
      -- The first key into the table is the vim map mode (`:h map-modes`), and the value is a table of entries to be passed to `vim.keymap.set` (`:h vim.keymap.set`):
      --   - The key is the first parameter or the vim mode (only a single mode supported) and the value is a table of keymaps within that mode:
      --     - The first element with no key in the table is the action (the 2nd parameter) and the rest of the keys/value pairs are options for the third parameter.
      --       There is also a special `cond` key which can either be a string of a language server capability or a function with `client` and `bufnr` parameters that returns a boolean of whether or not the mapping is added.
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
      -- A list like table of servers that should be setup, useful for enabling language servers not installed with Mason.
      servers = {},
      -- A custom `on_attach` function to be run after the default `on_attach` function, takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
      on_attach = function(_, _) end,
    }

    return require("astrocore").extend_tbl(opts, new_opts)
  end,
}
