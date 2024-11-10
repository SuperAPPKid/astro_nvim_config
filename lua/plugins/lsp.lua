local SymbolKind = vim.lsp.protocol.SymbolKind

---@type LazySpec
return {
  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    dependencies = {
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          local mappings = opts.mappings
          local goto_preview = require "goto-preview"
          local function is_float()
            local win = vim.api.nvim_get_current_win()
            local config = vim.api.nvim_win_get_config(win)

            return config.relative ~= ""
          end

          -- textDocument/definition
          -- mappings["gD"] = {
          --   function()
          --     if not is_float() then require("telescope.builtin").lsp_definitions() end
          --   end,
          --   desc = "Go to the definition of current symbol",
          --   cond = "textDocument/definition",
          -- }
          -- mappings["gd"] = {
          --   function()
          --     if not is_float() then goto_preview.goto_preview_definition {} end
          --   end,
          --   desc = "Show the definition of current symbol",
          --   cond = "textDocument/definition",
          -- }

          -- textDocument/typeDefinition
          -- mappings["gy"] = {
          --   function()
          --     if not is_float() then goto_preview.goto_preview_type_definition {} end
          --   end,
          --   desc = "Definition of current type",
          --   cond = "textDocument/typeDefinition",
          -- }

          -- textDocument/implementation
          mappings.n["gI"] = {
            function()
              if not is_float() then goto_preview.goto_preview_implementation {} end
            end,
            desc = "Implementation of current symbol",
            cond = "textDocument/implementation",
          }

          -- textDocument/declaration
          mappings.n["gv"] = {
            function()
              if not is_float() then goto_preview.goto_preview_declaration {} end
            end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          }

          -- textDocument/references
          mappings.n["gr"] = {
            function()
              if not is_float() then goto_preview.goto_preview_references {} end
            end,
            desc = "Goto references of current symbol",
            cond = "textDocument/references",
          }

          -- opts.on_attach = function(client, bufnr)
          --   if client.supports_method "textDocument/references" then
          --     vim.keymap.del("n", "<Leader>lR", { buffer = bufnr })
          --   end
          -- end
        end,
      },
    },
    config = function(_, opts) require("goto-preview").setup(opts) end,
    opts = function(_, opts)
      opts.width = 100
      opts.height = 25
      opts.border = "double"
      opts.stack_floating_preview_windows = false -- Whether to nest floating windows
      opts.preview_window_title = { enable = false }

      local jump_func = function(bufr)
        local function callback()
          local view = vim.fn.winsaveview()
          require("goto-preview").close_all_win { skip_curr_window = false }
          vim.api.nvim_set_option_value("buflisted", true, { buf = bufr })
          vim.cmd(string.format("buffer %s", vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))))
          vim.fn.winrestview(view)
          vim.cmd "normal! m'"
        end

        vim.keymap.set("n", "<CR>", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local tab_func = function(bufr)
        local callback = function()
          local view = vim.fn.winsaveview()
          local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

          require("goto-preview").close_all_win { skip_curr_window = false }
          vim.cmd(string.format("tabnew %s", f_name))
          vim.fn.winrestview(view)
          vim.cmd "normal! m'"
        end

        vim.keymap.set("n", "<Tab>", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local close_func = function(bufr)
        local callback = function() require("goto-preview").close_all_win { skip_curr_window = false } end
        vim.keymap.set("n", "q", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local buf_win_pairs = {}
      opts.post_open_hook = function(bufr, win)
        if buf_win_pairs[bufr] then return end

        buf_win_pairs[bufr] = win
        jump_func(bufr)
        tab_func(bufr)
        close_func(bufr)

        local group_id =
          vim.api.nvim_create_augroup(string.format("my-goto-preview_%s_%s", bufr, win), { clear = true })

        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(win),
          group = group_id,
          callback = function()
            buf_win_pairs[bufr] = nil
            vim.keymap.del("n", "<CR>", { buffer = bufr })
            vim.keymap.del("n", "<Tab>", { buffer = bufr })
            vim.keymap.del("n", "q", { buffer = bufr })
            vim.api.nvim_del_augroup_by_id(group_id)
          end,
        })
      end
      return opts
    end,
  },

  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "LspAttach",
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = function(_, opts)
      opts.cursorhold_update = false
      opts.doc_lines = 0
      opts.wrap = true
      opts.hint_enable = false
      opts.handler_opts = {
        border = "double", -- double, rounded, single, shadow, none, or a table of borders
      }
    end,
  },

  {
    "superappkid/delimited.nvim",
    config = true,
    event = "User AstroFile",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>ld"] = { function() require("delimited").open_float() end, desc = "open diag" }
          maps.n["[d"] = { function() require("delimited").goto_prev() end, desc = "Prev diag" }
          maps.n["]d"] = { function() require("delimited").goto_next() end, desc = "Next diag" }
        end,
      },
      {
        "AstroNvim/astroui",
        opts = {
          highlights = {
            init = {
              DelimitedError = { link = "DiagnosticUnderlineError" },
              DelimitedWarn = { link = "DiagnosticUnderlineWarn" },
              DelimitedInfo = { link = "DiagnosticUnderlineInfo" },
              DelimitedHint = { link = "DiagnosticUnderlineHint" },
            },
          },
        },
      },
    },
  },

  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      {
        "AstroNvim/astrolsp",
        ---@type AstroLSPOpts
        opts = {
          mappings = {
            n = {
              ["<Leader>lA"] = {
                function() require("actions-preview").code_actions() end,
                desc = "LSP code action",
                cond = "textDocument/codeAction",
              },
            },
            v = {
              ["<Leader>lA"] = {
                function() require("actions-preview").code_actions() end,
                desc = "LSP code action",
                cond = "textDocument/codeAction",
              },
            },
          },
        },
      },
    },
    opts = function(_, opts)
      local hl = require "actions-preview.highlight"
      opts.telescope = {}
      opts.highlight_command = {
        hl.delta "delta --no-gitconfig --paging=never --hunk-header-style=omit --file-style=omit --features=no-line-numbers",
        hl.diff_so_fancy(),
        hl.diff_highlight(),
      }
    end,
  },

  {
    "superappkid/lspsaga.nvim",
    event = "LspAttach",
    cmd = "Lspsaga",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          local maps = opts.mappings
          -- maps.n["K"] = { "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover symbol details", cond = "textDocument/hover" }

          -- call hierarchy
          maps.n["<Leader>lc"] =
            { "<Cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls", cond = "callHierarchy/incomingCalls" }
          maps.n["<Leader>lC"] =
            { "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls", cond = "callHierarchy/outgoingCalls" }

          -- code action
          maps.n["<Leader>la"] =
            { "<Cmd>Lspsaga code_action<CR>", desc = "LSP code action", cond = "textDocument/codeAction" }
          maps.v["<Leader>la"] =
            { ":<C-U>Lspsaga code_action<CR>", desc = "LSP code action", cond = "textDocument/codeAction" }

          -- definition
          maps.n["gD"] = {
            "<Cmd>Lspsaga goto_definition<CR>",
            desc = "Goto definition",
            cond = "textDocument/definition",
          }
          maps.n["gd"] =
            { "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek definition", cond = "textDocument/definition" }

          -- typeDefinition
          maps.n["gy"] = {
            "<Cmd>Lspsaga goto_type_definition<CR>",
            desc = "Goto type definition",
            cond = "textDocument/typeDefinition",
          }

          -- outline
          maps.n["<Leader>lS"] =
            { "<Cmd>Lspsaga outline<CR>", desc = "Symbols outline", cond = "textDocument/documentSymbol" }

          -- references
          maps.n["gR"] = {
            "<Cmd>Lspsaga finder<CR>",
            desc = "Search references",
            cond = function(client)
              return client.supports_method "textDocument/references"
                or client.supports_method "textDocument/implementation"
            end,
          }

          -- rename
          maps.n["<Leader>lr"] =
            { "<Cmd>Lspsaga rename<CR>", desc = "Rename current symbol", cond = "textDocument/rename" }
        end,
      },
    },
    opts = function()
      local astroui = require "astroui"
      local get_icon = function(icon) return astroui.get_icon(icon, 0, true) end
      return {
        symbol_in_winbar = { enable = false },
        callhierarchy = {
          keys = {
            toggle_or_req = "<CR>",
            edit = "o",
            vsplit = "|",
            split = "\\",
            tabe = "t",
            quit = "q",
            close = "<C-q>",
            shuttle = "<Tab>",
          },
        },
        definition = {
          save_pos = true,
          keys = {
            edit = "<CR>",
            vsplit = "|",
            split = "\\",
            tabe = "t",
            tabnew = "T",
            quit = "q",
            close = "<C-q>",
          },
        },
        finder = {
          keys = {
            toggle_or_open = "<CR>",
            vsplit = "|",
            split = "\\",
            tabe = "t",
            tabnew = "T",
            quit = "q",
            close = "<C-q",
            shuttle = "<Tab>",
          },
        },
        hover = {
          open_link = "<CR>",
          open_cmd = "!open",
        },
        lightbulb = { enable = false },
        outline = {
          auto_preview = false,
          keys = {
            toggle_or_jump = "<CR>",
            jump = "o",
          },
        },
        rename = {
          in_select = false,
          keys = {
            quit = "<C-q>",
          },
        },
        ui = {
          title = false,
          -- button = { "█", "█" },
          border = "double",
          code_action = get_icon "DiagnosticHint",
          expand = get_icon "FoldClosed",
          collapse = get_icon "FoldOpened",
        },
      }
    end,
  },

  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
        definition = false,
        git_authors = false,
      },
      target_symbol_kinds = { SymbolKind.Method, SymbolKind.Constructor, SymbolKind.Function },
      wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    lazy = true,
    specs = {
      {
        "AstroNvim/astroui",
        opts = function(_, opts)
          local hl = function(name) return vim.api.nvim_get_hl(0, { name = name }) end
          opts.highlights = require("astrocore").extend_tbl(opts.highlights, {
            init = {
              SymbolUsageRounding = { fg = hl("CursorLine").bg, italic = true },
              SymbolUsageContent = { bg = hl("CursorLine").bg, fg = hl("Comment").fg, italic = true },
            },
          })
        end,
      },
    },
    dependencies = {
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          -- HACK: fix initial buffer symbols not show
          local old_on_attach = opts.on_attach
          local done = false
          opts.on_attach = function(client, bufnr)
            if type(old_on_attach) == "function" then old_on_attach(client, bufnr) end
            if not done then
              require("symbol-usage").refresh()
              done = true
            end
          end
        end,
      },
    },
    opts = {
      kinds = {},
      filetypes = {
        go = {
          kinds = {
            SymbolKind.Interface,
            SymbolKind.Class,
            SymbolKind.Property,
            SymbolKind.Struct,
            SymbolKind.Field,
            SymbolKind.Enum,
            SymbolKind.Constant,
          },
        },
        lua = {
          kinds = {},
        },
        vue = {
          kinds = {
            SymbolKind.Variable,
            SymbolKind.Constant,
          },
        },
        javascript = {
          kinds = {
            SymbolKind.Variable,
            SymbolKind.Constant,
          },
        },
        typescript = {
          kinds = {
            SymbolKind.Variable,
            SymbolKind.Constant,
          },
        },
        typescriptreact = {
          kinds = {
            SymbolKind.Variable,
            SymbolKind.Constant,
          },
        },
        javascriptreact = {
          kinds = {
            SymbolKind.Variable,
            SymbolKind.Constant,
          },
        },
      },
      vt_position = "end_of_line",
      text_format = function(symbol)
        local res = {}

        local round_start = { "▐", "SymbolUsageRounding" }
        local round_end = { "▌", "SymbolUsageRounding" }

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end,
    },
  },
}
