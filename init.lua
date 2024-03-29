return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "kanagawa",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    config = {
      intelephense = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
      },
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = {
          -- "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          -- "tarPlugin",
          -- "tohtml",
          -- "tutor",
          -- "zipPlugin",
        },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    vim.opt.rtp:append(vim.fn.stdpath "config" .. "/lua/user/after")

    -- Set up custom filetypes
    vim.filetype.add {
      extension = {
        conf = "conf",
        env = "dotenv",
        tiltfile = "tiltfile",
        Tiltfile = "tiltfile",
        api = "api",
      },
      filename = {
        [".env"] = "dotenv",
        ["tsconfig.json"] = "jsonc",
        [".yamlfmt"] = "yaml",
      },
      pattern = {
        ["%.env%.[%w_.-]+"] = "dotenv",
      },
    }

    -- Autocmd
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup

    local isStdIn = false
    autocmd("StdinReadPre", {
      callback = function() isStdIn = true end,
    })
    autocmd("VimEnter", {
      callback = vim.schedule_wrap(function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 and not isStdIn then
          require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        else
          vim.api.nvim_del_augroup_by_name "resession_auto_save"
        end
      end),
    })

    vim.api.nvim_del_augroup_by_name "alpha_autostart" -- disable alpha auto start
    autocmd("VimEnter", {
      desc = "Start Oil when vim is opened with no arguments",
      group = augroup("oil_autostart", { clear = true }),
      callback = vim.schedule_wrap(function()
        local should_skip
        local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
        if
          vim.fn.argc() > 0 -- don't start when opening a file
          or #lines > 1 -- don't open if current buffer has more than 1 line
          or (#lines == 1 and lines[1]:len() > 0) -- don't open the current buffer if it has anything on the first line
          or #vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buflisted end, vim.api.nvim_list_bufs()) > 1 -- don't open if any listed buffers
          or not vim.o.modifiable -- don't open if not modifiable
        then
          should_skip = true
        else
          for _, arg in pairs(vim.v.argv) do
            if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
              should_skip = true
              break
            end
          end
        end
        if should_skip then return end
        require("oil").open()
      end),
    })
  end,
}
