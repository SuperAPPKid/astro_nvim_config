-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.filetype.add {
  extension = {
    api = "goctl",
    conf = "conf",
    env = "dotenv",
    gdshaderinc = "gdshaderinc",
    gotmpl = "helm",
    http = "http",
    pcss = "postcss",
    postcss = "postcss",
    pg = "sql",
    templ = "templ",
    tiltfile = "tiltfile",
    Tiltfile = "tiltfile",
  },
  filename = {
    [".env"] = "dotenv",
    ["Chart.yaml"] = "yaml",
    ["Chart.lock"] = "yaml",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["tsconfig.json"] = "jsonc",
    [".yamlfmt"] = "yaml",
  },
  pattern = {
    [".*%.blade%.php"] = "blade",
    ["%.env%.[%w_.-]+"] = "dotenv",
    ["helmfile.*%.ya?ml"] = "helm",
  },
}
