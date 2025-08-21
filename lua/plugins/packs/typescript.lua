---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- set up autocommand to choose the correct language server
        typescript_deno_switch = {
          {
            event = "LspAttach",
            callback = function(args)
              local bufnr = args.buf
              local curr_client = vim.lsp.get_client_by_id(args.data.client_id)

              if curr_client and curr_client.name == "denols" then
                local clients = vim.lsp.get_clients {
                  bufnr = bufnr,
                  name = "vtsls",
                }
                for _, client in ipairs(clients) do
                  vim.lsp.stop_client(client.id, true)
                end
              end

              -- if vtsls attached, stop it if there is a denols server attached
              if curr_client and curr_client.name == "vtsls" then
                if next(vim.lsp.get_clients { bufnr = bufnr, name = "denols" }) then
                  vim.lsp.stop_client(curr_client.id, true)
                end
              end
            end,
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = vim.fn.exepath "js-debug-adapter", args = { "${port}" } },
        }
      end

      if not dap.adapters.node then
        dap.adapters.node = function(cb, config)
          if config.type == "node" then config.type = "pwa-node" end
          local pwa_adapter = dap.adapters["pwa-node"]
          if type(pwa_adapter) == "function" then
            pwa_adapter(cb, config)
          else
            cb(pwa_adapter)
          end
        end
      end

      local vscode_filetypes = require("dap.ext.vscode").type_to_filetypes
      vscode_filetypes["node"] = js_filetypes
      vscode_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },

  {
    "vuki656/package-info.nvim",
    event = "BufRead package.json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = true,
  },

  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    config = true,
  },
}
