---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
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
        nvim_vtsls = {
          {
            event = "LspAttach",
            desc = "Load nvim-vtsls with vtsls",
            callback = function(args)
              if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "vtsls" then
                require("vtsls")._on_attach(args.data.client_id, args.buf)
                vim.api.nvim_del_augroup_by_name "nvim_vtsls"
              end
            end,
          },
        },
      },
    },
  },

  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      autocmds = {
        eslint_fix_on_save = {
          cond = function(client) return client.name == "eslint" and vim.fn.exists ":EslintFixAll" > 0 end,
          {
            event = "BufWritePost",
            desc = "Fix all eslint errors",
            callback = function(args)
              if vim.F.if_nil(vim.b[args.buf].autoformat, vim.g.autoformat, true) then vim.cmd.EslintFixAll() end
            end,
          },
        },
      },
    },
  },

  {
    "sigmasd/deno-nvim",
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    dependencies = {
      { "AstroNvim/astrolsp", opts = function(_, opts) opts.handlers.denols = false end },
    },
    opts = function(_, opts)
      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then opts.server = astrolsp.lsp_opts "denols" end
    end,
  },

  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    config = true,
  },

  {
    "vuki656/package-info.nvim",
    event = "BufRead package.json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = true,
  },

  {
    "yioneko/nvim-vtsls",
    lazy = true,
    config = function(_, opts) require("vtsls").config(opts) end,
  },
}
