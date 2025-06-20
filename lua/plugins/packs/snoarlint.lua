local analyzers_path = vim.fn.stdpath "data" .. "/mason/packages/sonarlint-language-server/extension/analyzers/"

local sonarlint_ft = {
  "c",
  "cpp",
  "css",
  "docker",
  "go",
  "html",
  "java",
  "javascript",
  "javascriptreact",
  "php",
  "python",
  "typescript",
  "typescriptreact",
  "xml",
  "yaml.docker-compose",
}

---@type LazySpec
return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  ft = sonarlint_ft,
  opts = {
    server = {
      cmd = {
        "sonarlint-language-server",
        "-stdio",
        "-analyzers",
        analyzers_path .. "sonargo.jar",
        analyzers_path .. "sonarhtml.jar",
        analyzers_path .. "sonariac.jar",
        analyzers_path .. "sonarjava.jar",
        analyzers_path .. "sonarjavasymbolicexecution.jar",
        analyzers_path .. "sonarjs.jar",
        analyzers_path .. "sonarphp.jar",
        analyzers_path .. "sonarpython.jar",
        analyzers_path .. "sonarxml.jar",
      },
    },
    filetypes = sonarlint_ft,
  },
}
