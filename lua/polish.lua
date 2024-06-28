-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.filetype.add {
  extension = {
    conf = "conf",
    env = "dotenv",
    tiltfile = "tiltfile",
    Tiltfile = "tiltfile",
    api = "api",
    http = "http",
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
