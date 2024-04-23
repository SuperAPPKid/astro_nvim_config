-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

local utils = require "astrocore"
local is_available = utils.is_available

-- on_attach
local on_attach = function(client, bufnr)
  local mappings = {}

  if is_available "goto-preview" then
    local goto_preview = require "goto-preview"
    local function is_float()
      local win = vim.api.nvim_get_current_win()
      local config = vim.api.nvim_win_get_config(win)

      return config.relative ~= ""
    end

    if client.supports_method "textDocument/definition" then
      mappings["gD"] = {
        function()
          if not is_float() then require("telescope.builtin").lsp_definitions() end
        end,
        desc = "Go to the definition of current symbol",
      }
      mappings["gd"] = {
        function()
          if not is_float() then goto_preview.goto_preview_definition {} end
        end,
        desc = "Show the definition of current symbol",
      }
    end

    if client.supports_method "textDocument/typeDefinition" then
      mappings["gy"] = {
        function()
          if not is_float() then goto_preview.goto_preview_type_definition {} end
        end,
        desc = "Definition of current type",
      }
    end

    if client.supports_method "textDocument/implementation" then
      mappings["gI"] = {
        function()
          if not is_float() then goto_preview.goto_preview_implementation {} end
        end,
        desc = "Implementation of current symbol",
      }
    end

    if client.supports_method "textDocument/declaration" then
      mappings["gv"] = {
        function()
          if not is_float() then goto_preview.goto_preview_declaration {} end
        end,
        desc = "Declaration of current symbol",
      }
    end

    if client.supports_method "textDocument/references" then
      mappings["gR"] = {
        function()
          if not is_float() then require("telescope.builtin").lsp_references() end
        end,
        desc = "Go to references of current symbol",
      }
      mappings["gr"] = {
        function()
          if not is_float() then goto_preview.goto_preview_references {} end
        end,
        desc = "References of current symbol",
      }
      vim.keymap.del("n", "<leader>lR", { buffer = bufnr })
    end

    mappings["gC"] = {
      function() goto_preview.close_all_win {} end,
      desc = "Close all preview",
    }
  end

  if is_available "inc-rename.nvim" then
    mappings["<leader>lr"] = {
      ":IncRename ",
      desc = "Rename current symbol",
    }
  end

  utils.set_mappings({
    n = mappings,
  }, { buffer = bufnr })
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  version = false,
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
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
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      intelephense = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
      },
      clangd = {
        filetypes = { "c", "cpp", "opjc", "objcpp" },
        capabilities = {
          offsetEncoding = "utf-8",
        },
      },
      gopls = {
        settings = {
          gopls = {
            hints = {
              -- assignVariableTypes = true,
              -- compositeLiteralFields = true,
              -- compositeLiteralTypes = true,
              -- constantValues = true,
              -- functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
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
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
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
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
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
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = on_attach,
  },
}
