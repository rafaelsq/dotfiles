-- pip install "python-lsp-server[all]" --break-system-packages
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
return {
  settings = {
    pylsp = {
      plugins = {
        pylint_lint = {
          enabled = false,
        }
      }
    }
  }
}
