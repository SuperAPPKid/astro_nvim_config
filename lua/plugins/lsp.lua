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
          mappings.n["gR"] = {
            function()
              if not is_float() then goto_preview.goto_preview_references {} end
            end,
            desc = "Go to references of current symbol",
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
          vim.api.nvim_buf_set_option(bufr, "buflisted", true)
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
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>ld"] = { function() require("delimited").open_float() end, desc = "open diag" }
          maps.n["[d"] = { function() require("delimited").goto_prev() end, desc = "prev diag" }
          maps.n["]d"] = { function() require("delimited").goto_next() end, desc = "next diag" }
        end,
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
                cond = "testDocument/codeAction",
              },
            },
            v = {
              ["<Leader>lA"] = {
                function() require("actions-preview").code_actions() end,
                desc = "LSP code action",
                cond = "testDocument/codeAction",
              },
            },
          },
        },
      },
    },
    opts = {
      telescope = {},
    },
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
          maps.n["K"] = { "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover symbol details", cond = "textDocument/hover" }

          -- call hierarchy
          maps.n["<Leader>lc"] =
            { "<Cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls", cond = "callHierarchy/incomingCalls" }
          maps.n["<Leader>lC"] =
            { "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls", cond = "callHierarchy/outgoingCalls" }

          -- code action
          maps.n["<Leader>la"] =
            { "<Cmd>Lspsaga code_action<CR>", desc = "LSP code action", cond = "textDocument/codeAction" }
          maps.x["<Leader>la"] =
            { ":<C-U>Lspsaga code_action<CR>", desc = "LSP code action", cond = "textDocument/codeAction" }

          -- definition
          maps.n["gD"] = {
            "<Cmd>Lspsaga goto_definition<CR>",
            desc = "goto definition",
            cond = "textDocument/definition",
          }
          maps.n["gd"] =
            { "<Cmd>Lspsaga peek_definition<CR>", desc = "Peek definition", cond = "textDocument/definition" }

          -- typeDefinition
          maps.n["gy"] = {
            "<Cmd>Lspsaga goto_type_definition<CR>",
            desc = "goto type definition",
            cond = "textDocument/typeDefinition",
          }

          -- outline
          maps.n["<Leader>lS"] =
            { "<Cmd>Lspsaga outline<CR>", desc = "Symbols outline", cond = "textDocument/documentSymbol" }

          -- references
          maps.n["gr"] = {
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
        code_action = { extend_gitsigns = require("astrocore").is_available "gitsigns.nvim" },
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
    "stevearc/conform.nvim",
    event = "User AstroFile",
    cmd = "ConformInfo",
    dependencies = {
      "williamboman/mason.nvim",
      { "jay-babu/mason-null-ls.nvim", opts = { methods = { formatting = false } } },
      {
        "AstroNvim/astrocore",
        opts = {
          options = { opt = { formatexpr = "v:lua.require'conform'.formatexpr()" } },
          commands = {
            Format = {
              function(args)
                local range = nil
                if args.count ~= -1 then
                  local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                  range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                  }
                end
                require("conform").format { async = true, range = range }
              end,
              desc = "Format buffer",
              range = true,
            },
          },
          mappings = {
            n = {
              ["<Leader>lf"] = { function() vim.cmd.Format() end, desc = "Format buffer" },
              ["<Leader>uf"] = {
                function()
                  if vim.b.autoformat == nil then
                    if vim.g.autoformat == nil then vim.g.autoformat = true end
                    vim.b.autoformat = vim.g.autoformat
                  end
                  vim.b.autoformat = not vim.b.autoformat
                  require("astrocore").notify(
                    string.format("Buffer autoformatting %s", vim.b.autoformat and "on" or "off")
                  )
                end,
                desc = "Toggle autoformatting (buffer)",
              },
              ["<Leader>uF"] = {
                function()
                  if vim.g.autoformat == nil then vim.g.autoformat = true end
                  vim.g.autoformat = not vim.g.autoformat
                  vim.b.autoformat = nil
                  require("astrocore").notify(
                    string.format("Global autoformatting %s", vim.g.autoformat and "on" or "off")
                  )
                end,
                desc = "Toggle autoformatting (global)",
              },
            },
            v = {
              ["<Leader>lf"] = {
                function()
                  vim.cmd.Format()
                  vim.cmd [[execute "normal! \<Esc>"]]
                end,
                desc = "Format lines",
              },
            },
          },
        },
      },
      {
        "AstroNvim/astrolsp",
        opts = {
          formatting = {
            disabled = true,
          },
          mappings = {
            n = {
              ["<Leader>lf"] = false,
              ["<Leader>uf"] = false,
              ["<Leader>uF"] = false,
            },
            v = {
              ["<Leader>lf"] = false,
            },
          },
        },
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.autoformat == nil then vim.g.autoformat = true end
        local autoformat = vim.b[bufnr].autoformat
        if autoformat == nil then autoformat = vim.g.autoformat end
        if autoformat then
          return {
            timeout_ms = vim.tbl_get(require("astrolsp").config, "formatting", "timeout_ms") or 500,
          }
        end
      end,
    },
  },
}
