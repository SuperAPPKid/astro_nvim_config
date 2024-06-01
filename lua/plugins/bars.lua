return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      local condition = require "astroui.status.condition"

      opts.tabline = { -- bufferline
        { -- automatic sidebar padding
          condition = function(self)
            self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
            self.winwidth = vim.api.nvim_win_get_width(self.winid)
            return self.winwidth ~= vim.o.columns -- only apply to sidebars
              and not require("astrocore.buffer").is_valid(vim.api.nvim_win_get_buf(self.winid)) -- if buffer is not in tabline
          end,
          provider = function(self) return (" "):rep(self.winwidth + 1) end,
          hl = { bg = "tabline_bg" },
        },

        status.heirline.make_buflist(status.component.file_info {
          file_icon = {
            condition = function(self) return not self._show_picker end,
            hl = status.hl.file_icon "tabline",
          },
          filename = {},
          filetype = false,
          unique_path = {
            hl = function(self) return status.hl.get_attributes(self.tab_type .. "_path") end,
          },
          padding = { left = 1, right = 1 },
          hl = function(self)
            local tab_type = self.tab_type
            if self._show_picker and self.tab_type ~= "buffer_active" then tab_type = "buffer_visible" end
            return status.hl.get_attributes(tab_type)
          end,
          surround = false,
        }),

        -- component for each buffer tab
        status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color

        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist { -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "buffer"), true) end,
          },
        },
      }

      opts.statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } }, -- add the mode text
        status.component.git_branch {
          on_click = false,
          hl = { fg = "#e5c07b" },
        },
        status.component.git_diff { on_click = false },
        status.component.fill(),
        status.component.file_info {
          file_icon = false,
          filetype = false,
          surround = {
            separator = "right",
            color = "file_info_bg",
            condition = condition.has_filetype,
          },
          filename = {
            modify = ":p:.",
          },
        },
        status.component.diagnostics {
          on_click = false,
          surround = {
            separator = "left",
            color = "diagnostics_bg",
            condition = condition.has_diagnostics,
          },
        },
        status.component.fill(),
        status.component.cmd_info {
          surround = {
            separator = "right",
            color = "cmd_info_bg",
            condition = function()
              return condition.is_hlsearch() or condition.is_macro_recording() or condition.is_statusline_showcmd()
            end,
          },
        },
        status.component.lsp {
          on_click = false,
          lsp_progress = false,
          padding = { left = 1, right = 1 },
          hl = { fg = "#c678dd", bold = true },
          lsp_client_names = {
            icon = { kind = "", padding = { left = 0, right = 0 } },
          },
        },
        {
          provider = status.provider.file_icon { padding = { left = 1, right = 1 } },
          hl = status.hl.file_icon "statusline",
        },
        {
          provider = status.provider.filetype { padding = { left = 0, right = 1 } },
          hl = { fg = "#e06c75", bold = true },
        },
        {
          provider = status.provider.file_encoding { padding = { left = 0, right = 1 } },
          hl = { fg = "#d19a66", bold = true },
        },
        {
          provider = status.provider.ruler { padding = { left = 0, right = 1 } },
          hl = { fg = "#98c379", bold = true },
        },
        {
          provider = status.provider.percentage { padding = { left = 0, right = 1 } },
          hl = { fg = "#61afef", bold = true },
        },
        {
          provider = status.provider.scrollbar(),
          hl = { fg = "#e5c07b", bold = true },
        },
      }

      if vim.fn.has "nvim-0.10" == 1 then
        opts.statuscolumn = nil -- statuscolumn
      end
    end,
  },

  {
    "luukvbaal/statuscol.nvim",
    enabled = function() return vim.fn.has "nvim-0.10" == 1 end,
    event = "User AstroFile",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        ft_ignore = {
          "dapui_.*",
          "dap-repl",
          "terminal",
          "lspinfo",
          "mason",
          "lazy",
          "fzf",
          "qf",
          "neo-tree",
          "neo-tree-popup",
          "neo-tree-preview",
          "NvimTree",
          "TelescopePrompt",
          "alpha",
          "sagaoutline",
        },
        segments = {
          {
            sign = {
              namespace = { "todo", "dap", "diagnostic" },
              colwidth = 2,
              -- auto = true,
            },
            click = "v:lua.ScSa",
          },
          {
            sign = {
              namespace = { "gitsigns_extmark_signs_" },
              colwidth = 1,
              -- auto = true,
            },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            text = { builtin.foldfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },
}
