---@type LazySpec
return {
  {
    "fang2hou/blink-copilot",
    event = "User AstroFile",
  },

  {
    "Saghen/blink.cmp",
    version = "*",
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
      "MahanRahmati/blink-nerdfont.nvim",
      "ribru17/blink-cmp-spell",
      "hrsh7th/cmp-calc",
      "kdheepak/cmp-latex-symbols",
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      completion = {
        menu = {
          auto_show = true,
          border = "double",
          draw = {
            columns = { { "label" }, { "kind_icon", "kind", gap = 1 }, { "source_name" } },
            components = {
              source_name = {
                text = function(ctx)
                  local override_names = {
                    codeium = "Codeium",
                    copilot = "Copilot",
                    latex_symbols = "Latex",
                  }
                  return "[" .. (override_names[ctx.source_name] or ctx.source_name) .. "]"
                end,
                highlight = "BlinkCmpKind",
              },
            },
          },
        },
        documentation = {
          auto_show = false,
          window = { border = "double" },
        },
        list = {
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = function(_) return vim.fn.getcmdtype() == ":" end,
          },
        },
        keymap = {
          ["<CR>"] = { "accept", "fallback" },
          ["<ESC>"] = {
            "hide",
            function(_)
              local ctrl_c = vim.api.nvim_replace_termcodes("<C-c>", true, false, true)
              vim.api.nvim_feedkeys(ctrl_c, "n", true)
            end,
          },
          ["<C-J>"] = { "select_next", "fallback" },
          ["<C-K>"] = { "select_prev", "fallback" },
          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<Right>"] = { "fallback" },
          ["<Left>"] = { "fallback" },
        },
      },
      fuzzy = {
        sorts = {
          function(a, b)
            local sort = require "blink.cmp.fuzzy.sort"
            if a.source_id == "spell" and b.source_id == "spell" then return sort.label(a, b) end
          end,
          "exact",
          "score",
          "kind",
          "sort_text",
          "label",
        },
      },
      keymap = {
        ["<C-E>"] = {
          function()
            require("blink.cmp").hide()
            require("codeium.virtual_text").complete()
            return true
          end,
        },
        ["<C-Y>"] = { "show", "show_documentation", "hide_documentation" },
      },
      signature = {
        enabled = true,
        window = {
          border = "double",
        },
      },
      sources = {
        default = function()
          return {
            "calc",
            "codeium",
            "copilot",
            "git",
            "latex_symbols",
            "lazydev",
            "lsp",
            "nerdfont",
            "path",
            "snippets",
            "spell",
          }
        end,
        per_filetype = {
          help = {},
          lazy = {},
          oil = {},
          sagarename = {},
          AvanteInput = { "avante" },
        },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
          },
          buffer = {
            score_offset = 900,
          },
          calc = {
            name = "calc",
            module = "blink.compat.source",
            score_offset = 800,
          },
          codeium = {
            name = "codeium",
            module = "codeium.blink",
            async = true,
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind_hl = "MiniIconsOrange"
              end
              return items
            end,
            score_offset = 600,
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,
            opts = {
              max_completions = 3,
              max_attempts = 4,
              kind_name = "Copilot", ---@type string | false
              kind_icon = "", ---@type string | false
              kind_hl = "MiniIconsOrange", ---@type string | false
              debounce = 200, ---@type integer | false
              auto_refresh = {
                backward = false,
                forward = false,
              },
            },
            score_offset = 700,
          },
          git = {
            name = "Git",
            module = "blink-cmp-git",
            opts = {
              before_reload_cache = false,
              git_centers = {
                github = {
                  issue = { enable = false },
                  pull_request = { enable = false },
                  mention = { enable = false },
                },
                gitlab = {
                  issue = { enable = false },
                  pull_request = { enable = false },
                  mention = { enable = false },
                },
              },
            },
          },
          latex_symbols = {
            name = "latex_symbols",
            module = "blink.compat.source",
            score_offset = 800,
            opts = {
              -- 0 mixed Show the command and insert the symbol
              -- 1 julia Show and insert the symbol
              -- 2 latex Show and insert the command
              strategy = 0,
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 800,
          },
          lsp = {
            score_offset = 1000,
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind_icon = "󰚩"
              end
              return items
            end,
          },
          nerdfont = {
            module = "blink-nerdfont",
            name = "Nerd",
            score_offset = 700,
          },
          path = {
            score_offset = 600,
          },
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            score_offset = 800,
            opts = {
              -- EXAMPLE: Only enable source in `@spell` captures, and disable it
              -- in `@nospell` captures.
              enable_in_context = function()
                local curpos = vim.api.nvim_win_get_cursor(0)
                local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                local in_spell_capture = false
                for _, cap in ipairs(captures) do
                  if cap.capture == "spell" then
                    in_spell_capture = true
                  elseif cap.capture == "nospell" then
                    return false
                  end
                end
                return in_spell_capture
              end,
            },
          },
        },
      },
    },
  },
}
