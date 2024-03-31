local utils = require "astronvim.utils"
local is_available = utils.is_available
return function(client, bufnr)
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
