---@type LazySpec
return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        on_attach = function(...) require("astrolsp").on_attach(...) end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = "rust",
    dependencies = {
      { "AstroNvim/astrolsp", opts = function(_, opts) opts.handlers.rust_analyzer = false end },
    },
    opts = function()
      local adapter
      local success, package = pcall(function() return require("mason-registry").get_package "codelldb" end)
      local cfg = require "rustaceanvim.config"
      if success then
        local package_path = vim.fn.expand "$MASON/packages/codelldb"
        local codelldb_path = package_path .. "/codelldb"
        local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"
        local this_os = vim.loop.os_uname().sysname

        -- The path in windows is different
        if this_os:find "Windows" then
          codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
          liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
        else
          -- The liblldb extension is .so for linux and .dylib for macOS
          liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
        end
        adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
      else
        adapter = cfg.get_codelldb_adapter()
      end

      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      local astrolsp_opts = (astrolsp_avail and astrolsp.lsp_opts "rust_analyzer") or {}
      local server = {
        ---@type table | (fun(project_root:string|nil, default_settings: table|nil):table) -- The rust-analyzer settings or a function that creates them.
        settings = function(project_root, default_settings)
          local astrolsp_settings = astrolsp_opts.settings or {}

          local merge_table = require("astrocore").extend_tbl(default_settings or {}, astrolsp_settings)
          local ra = require "rustaceanvim.config.server"
          -- load_rust_analyzer_settings merges any found settings with the passed in default settings table and then returns that table
          return ra.load_rust_analyzer_settings(project_root, {
            settings_file_pattern = "rust-analyzer.json",
            default_settings = merge_table,
          })
        end,
      }
      local final_server = require("astrocore").extend_tbl(astrolsp_opts, server)
      return {
        server = final_server,
        dap = { adapter = adapter, load_rust_types = true },
        tools = { enable_clippy = false },
      }
    end,
    config = function(_, opts) vim.g.rustaceanvim = require("astrocore").extend_tbl(opts, vim.g.rustaceanvim) end,
  },
}
