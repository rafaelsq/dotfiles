-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
-- add `{ "venvPath": ".", "venv": ".venv" }` to pyrightconfig.json when using .venv
return {
  settings = {
    organizeImports = false
  }
}
