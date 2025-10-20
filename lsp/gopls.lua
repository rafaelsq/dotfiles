-- https://github.com/neovim/neovim/blob/master/runtime/doc/lsp.txt#L810
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
  settings = {
    gopls = {
      ['local'] = string.gmatch(vim.fn.getcwd(), '/([^/]+)$')(),
      analyses = {
        unusedparams = true,
      },
      codelenses = {
        gc_details = true,
        test = true,
        generate = true,
      },
    }
  },
}
