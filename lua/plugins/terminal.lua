---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
    cmd = {
      "TermSelect",
      "TermExec",
      "TermNew",
      "ToggleTerm",
      "ToggleTermToggleAll",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
      "ToggleTermSendCurrentLine",
      "ToggleTermSetName",
    },
    dependencies = {
      "ryanmsnyder/toggleterm-manager.nvim",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.autocmds.my_toggle_term = {
            {
              event = "TermOpen",
              pattern = "term://*toggleterm#*",
              callback = function(args)
                vim.keymap.set("t", "<C-N>", [[<C-\><C-n>]], {
                  desc = "Normal mode",
                  noremap = true,
                  silent = true,
                  buffer = args.buf,
                })
                vim.keymap.set({ "n", "t" }, "<C-Q>", function() require("astrocore.buffer").close() end, {
                  desc = "Close buffer",
                  noremap = true,
                  silent = true,
                  buffer = args.buf,
                })
                vim.keymap.set({ "n", "t" }, "<C-T>", function() vim.cmd "hide" end, {
                  desc = "Toggle buffer",
                  noremap = true,
                  silent = true,
                  buffer = args.buf,
                })
              end,
            },
          }

          local mappings = opts.mappings
          mappings.n["<C-T>"] = {
            function()
              local terms = require("toggleterm.terminal").get_all()
              if #terms < 2 then
                return "<Cmd>ToggleTerm<CR>"
              else
                return "<Cmd>Telescope toggleterm_manager<CR>"
              end
            end,
            expr = true,
          }
          mappings.n["<Leader>tr"] = {
            function()
              local terms = require("toggleterm.terminal").get_all(true)
              if #terms ~= 0 then return "<Cmd>ToggleTermSetName<CR>" end
            end,
            expr = true,
          }
          mappings.n["<Leader>tf"] = { "<Cmd>TermNew direction=float<CR>", desc = "TermNew float" }
          mappings.n["<Leader>th"] = { "<Cmd>TermNew direction=horizontal<CR>", desc = "TermNew horizontal split" }
          mappings.n["<Leader>tv"] = { "<Cmd>TermNew direction=vertical<CR>", desc = "TermNew vertical split" }

          if vim.fn.executable "lazygit" == 1 then
            local show_lazygit = function()
              local worktree = require("astrocore").file_worktree()
              local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir)
                or ""
              require("astrocore").toggle_term_cmd {
                cmd = "lazygit " .. flags,
                direction = "float",
                on_exit = function() require("utils").git_broadcast() end,
              }
            end

            opts.autocmds.lazygit_commit = {
              {
                event = "BufDelete",
                callback = function(args)
                  local path = vim.api.nvim_buf_get_name(args.buf)
                  local last_dir = vim.fn.fnamemodify(path, ":h:t")
                  local fname = vim.fn.fnamemodify(path, ":t")
                  if last_dir .. "/" .. fname == ".git/COMMIT_EDITMSG" then vim.schedule(show_lazygit) end
                end,
              },
            }

            mappings.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
            local lazygit = { callback = show_lazygit, desc = "ToggleTerm lazygit" }

            mappings.n["<Leader>tg"] = { lazygit.callback, desc = lazygit.desc }
            mappings.n["<Leader>gg"] = { lazygit.callback, desc = lazygit.desc }
            mappings.n["<Leader>tl"] = false
          end

          if vim.fn.executable "yazi" == 1 then
            mappings.n["<Leader>ty"] = {
              function()
                local edit_cmd = ""
                local file_path = vim.fn.expand "%:p"
                local fm_tmpfile = vim.fn.getcwd() .. ".tmp"
                local feedkeys = function(keys)
                  local key_termcode = vim.api.nvim_replace_termcodes(keys, true, true, true)
                  vim.api.nvim_feedkeys(key_termcode, "n", false)
                end
                require("astrocore").toggle_term_cmd {
                  direction = "float",
                  cmd = string.format([[yazi "%s" --chooser-file "%s"]], file_path, fm_tmpfile),
                  dir = vim.fn.expand "%:p:h",
                  on_open = function(term)
                    edit_cmd = "edit"
                    vim.keymap.set("t", "<Tab>", function()
                      edit_cmd = "tabedit"
                      feedkeys "<CR>"
                    end, { noremap = true, silent = true, buffer = term.bufnr })
                    vim.keymap.set("t", "\\", function()
                      edit_cmd = "split"
                      feedkeys "<CR>"
                    end, { noremap = true, silent = true, buffer = term.bufnr })
                    vim.keymap.set("t", "|", function()
                      edit_cmd = "vsplit"
                      feedkeys "<CR>"
                    end, { noremap = true, silent = true, buffer = term.bufnr })
                  end,
                  on_exit = function()
                    local file = io.open(fm_tmpfile, "r")
                    if file ~= nil then
                      local file_name = file:read "*a"
                      file:close()
                      os.remove(fm_tmpfile)
                      vim.uv
                        .new_timer()
                        :start(0, 0, vim.schedule_wrap(function() vim.cmd(edit_cmd .. " " .. file_name) end))
                    end
                  end,
                }
              end,
              desc = "ToggleTerm yazi",
            }
          end

          if vim.fn.executable "lazydocker" == 1 then
            mappings.n["<Leader>td"] = {
              function() require("astrocore").toggle_term_cmd { direction = "float", cmd = "lazydocker" } end,
              desc = "ToggleTerm lazydocker",
            }
          end

          if vim.fn.executable "btop" == 1 then
            mappings.n["<Leader>tt"] = {
              function() require("astrocore").toggle_term_cmd { cmd = "btop", direction = "float" } end,
              desc = "ToggleTerm btop",
            }
          end

          if vim.fn.executable "gemini" == 1 then
            mappings.n["<Leader>tG"] = {
              function() require("astrocore").toggle_term_cmd { cmd = "gemini", direction = "float" } end,
              desc = "ToggleTerm gemini",
            }
          end

          local gdu
          if vim.fn.has "win32" == 1 then
            gdu = "gdu_windows_amd64.exe"
          elseif vim.fn.has "mac" == 1 then
            gdu = "gdu-go"
          else
            gdu = "gdu"
          end
          if vim.fn.executable(gdu) == 1 then
            mappings.n["<Leader>tu"] = {
              function() require("astrocore").toggle_term_cmd { cmd = gdu, direction = "float" } end,
              desc = "ToggleTerm gdu",
            }
          else
            mappings.n["<Leader>tu"] = false
          end
        end,
      },
    },
    opts = {
      open_mapping = false,
      float_opts = {
        border = "double",
        height = function(_) return vim.o.lines - 3 end,
        width = function(_) return vim.o.columns end,
      },
      highlights = {
        NormalFloat = {
          link = "NormalDark",
        },
      },
    },
  },

  {
    "willothy/flatten.nvim",
    opts = {
      nest_if_no_args = true,
      window = { open = "alternate" },
    },
    lazy = false,
    priority = 99999,
  },

  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("toggleterm-manager").setup(opts)
      require("telescope").load_extension "toggleterm_manager"
    end,
    opts = function(_, opts)
      local term_icon = require("astroui").get_icon "Terminal"
      opts.titles = { prompt = term_icon .. " Terminals" }
      opts.results = { term_icon = term_icon }
      opts.mappings = {
        n = {
          ["<CR>"] = { -- toggles terminal open/closed
            action = function(...) require("toggleterm-manager").actions.toggle_term(...) end,
            exit_on_action = true,
          },
          ["<C-r>"] = { -- provides a prompt to rename a terminal
            action = function(...) require("toggleterm-manager").actions.rename_term(...) end,
            exit_on_action = false,
          },
          ["<C-d>"] = { -- deletes a terminal buffer
            action = function(...) require("toggleterm-manager").actions.delete_term(...) end,
            exit_on_action = false,
          },
          ["<C-n>"] = { -- creates a new terminal buffer
            action = function(...) require("toggleterm-manager").actions.create_term(...) end,
            exit_on_action = false,
          },
          ["<C-t>"] = {
            action = function(buf, _) require("telescope.actions").close(buf) end,
            exit_on_action = true,
          },
          ["<C-\\>"] = {
            action = function(buf, _) require("telescope.actions").close(buf) end,
            exit_on_action = true,
          },
        },
        i = {
          ["<CR>"] = { -- toggles terminal open/closed
            action = function(...) require("toggleterm-manager").actions.toggle_term(...) end,
            exit_on_action = true,
          },
          ["<C-r>"] = { -- provides a prompt to rename a terminal
            action = function(...) require("toggleterm-manager").actions.rename_term(...) end,
            exit_on_action = false,
          },
          ["<C-d>"] = { -- deletes a terminal buffer
            action = function(...) require("toggleterm-manager").actions.delete_term(...) end,
            exit_on_action = false,
          },
          ["<C-n>"] = { -- creates a new terminal buffer
            action = function(...) require("toggleterm-manager").actions.create_term(...) end,
            exit_on_action = false,
          },
          ["<C-t>"] = {
            action = function(buf, _) require("telescope.actions").close(buf) end,
            exit_on_action = true,
          },
          ["<C-\\>"] = {
            action = function(buf, _) require("telescope.actions").close(buf) end,
            exit_on_action = true,
          },
        },
      }
    end,
  },
}
