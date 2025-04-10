---@type LazySpec
return {
  {
    "akinsho/toggleterm.nvim",
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
          mappings.n["<C-T>"] = { "<Cmd>ToggleTerm<CR>" }

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
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>fs"] = { "<Cmd>Telescope toggleterm_manager<CR>", desc = "Search Toggleterms" }
        end,
      },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<Leader>tl", "<Cmd>Telescope toggleterm_manager<CR>", desc = "Search Toggleterms" },
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
        },
      }
    end,
  },
}
