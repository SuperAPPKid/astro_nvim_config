local utils = require "astronvim.utils"
local is_available = utils.is_available
return function(client, bufnr)
  local mappings = {}

  if is_available "goto-preview" then
    local goto_preview = require "goto-preview"
    if client.supports_method "textDocument/definition" then
      mappings["gD"] = {
        function() require("telescope.builtin").lsp_definitions() end,
        desc = "Go to the definition of current symbol",
      }
      mappings["gd"] = {
        function() goto_preview.goto_preview_definition {} end,
        desc = "Show the definition of current symbol",
      }
    end

    if client.supports_method "textDocument/typeDefinition" then
      mappings["gy"] = {
        function() goto_preview.goto_preview_type_definition {} end,
        desc = "Definition of current type",
      }
    end

    if client.supports_method "textDocument/implementation" then
      mappings["gI"] = {
        function() goto_preview.goto_preview_implementation {} end,
        desc = "Implementation of current symbol",
      }
    end

    if client.supports_method "textDocument/declaration" then
      mappings["gv"] = {
        function() goto_preview.goto_preview_implementation {} end,
        desc = "Declaration of current symbol",
      }
    end

    if client.supports_method "textDocument/references" then
      mappings["gR"] = {
        function() require("telescope.builtin").lsp_references() end,
        desc = "Go to references of current symbol",
      }
      mappings["gr"] = {
        function() goto_preview.goto_preview_references {} end,
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
