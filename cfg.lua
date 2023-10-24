local M = {}


-- update bg to nil
function emptyBG(name)
  local hl = vim.api.nvim_get_hl_by_name(name, {})
  if type(hl) == 'table' and hl.background then
    hl.background = nil
    vim.api.nvim_set_hl(0, name, hl)
  end
end

M.theme = function()

  ------------- higlight graphql
  vim.cmd('autocmd BufEnter *.graphql setf graphql')
  vim.cmd('autocmd BufEnter go.mod setf gomod')

  --------------------- TreeSitter
  require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "go", "gomod", "javascript", "tsx", "json", "yaml", "html", "css", "vue", "typescript", "python",
      "elixir", "graphql", "lua" },

    highlight = { enable = true },
    incremental_selection = { enable = true },
  }

  local theme = vim.env['THEME']

  vim.opt.termguicolors = true
  vim.opt.number = true
  vim.opt.signcolumn = 'yes'
  vim.opt.relativenumber = false

  if theme == 'ayu' then
    vim.g.ayucolor = "mirage"
  end

  vim.cmd('silent! colorscheme ' .. theme)

  -- fix for https://github.com/nvim-treesitter/nvim-treesitter/pull/3656
  vim.api.nvim_set_hl(0, '@variable', { link = 'Normal' })
  vim.api.nvim_set_hl(0, "NormalNC", { link = 'Normal' })

  -- transparent background
  emptyBG('Normal')
  emptyBG('SignColumn')
  emptyBG('Pmenu')

  if vim.g.colors_name == 'molokai' then
    vim.g.molokai_original = 1
    vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#3C3535', fg = '', bold = true })
    vim.api.nvim_set_hl(0, 'LineNr', { bg = '', fg = '#3C3535' })
  end

  -- highlight EOL
  vim.api.nvim_set_hl(0, 'WhitespaceEOL', { link = 'LspErrorHighlight' })
  vim.cmd [[
      match WhitespaceEOL /\\\@<!\s\+\%#\@<!$/
      augroup winenter_whitespaceeol
          autocmd!
          autocmd WinEnter * match WhiteSpaceEOL /\\\@<!\s\+\%#\@<!$/
      augroup END
    ]]

  -- only one status bar
  -- vim.o.laststatus = 3

  -- LSP
  vim.api.nvim_set_hl(0, 'LspCodeLens', { fg = '#88C0D0', underline = true })

  -- Tint inactive windows
  require("tint").setup({
    tint_background_colors = false,
    transforms = {
      function(r, g, b)

        local tx = 0.7
        local min = 70
        local max = 150
        if math.min(r, g, b) > min then
          if math.min(r, g, b) > max then
            tx = 0.5
          end

          return math.max(math.ceil(r * tx), 0),
              math.max(math.ceil(g * tx), 0),
              math.max(math.ceil(b * tx), 0)
        end
        return r, g, b
      end
    }
  })

  -- hover with border
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
end


M.statusBar = function()

  local colors = {
    blue   = '#61afef',
    green  = '#98c379',
    purple = '#c678dd',
    cyan   = '#56b6c2',
    red1   = '#e06c75',
    red2   = '#be5046',
    yellow = '#e5c07b',
    fg     = '#abb2bf',
    bg     = '#282c34',
    gray1  = '#828997',
    gray2  = '#2c323c',
    gray3  = '#4e5462',
  }

  require('lualine').setup {
    options = {
      component_separators = {
        left = "",
        right = ""
      },
      theme                = {
        normal = {
          a = { fg = colors.gray1 },
          b = { fg = colors.yellow },
          c = { fg = colors.green },
          x = { fg = colors.gray3 },
        },
        inactive = {
          a = { fg = colors.gray3 },
          b = { fg = colors.gray3 },
          c = { fg = colors.gray3 },
        },
      }
    },
    sections = {
      lualine_a = { 'filetype' },
      lualine_b = { "vim.trim(require'lsp-status'.status())" },
      lualine_c = {
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
        },
      },
      lualine_x = { 'encoding' },
      lualine_y = { 'location', 'diff' },
      lualine_z = { 'diagnostics' },
    },
  }
end

M.yanks = function()
  local yanks = require 'nvim-yanks'
  yanks.setup()
  vim.keymap.set('n', '<space>y', yanks.Show, { silent = true })
end

M.goC = function()
  vim.opt.switchbuf = 'useopen'

  vim.api.nvim_set_hl(0, 'GocNormal', { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'GocCovered', { link = 'String' })
  vim.api.nvim_set_hl(0, 'GocUncovered', { link = 'Error' })

  if vim.env['THEME'] == 'nord' then
    vim.api.nvim_set_hl(0, 'GocUncovered', { fg = '#BF616A' })
  end

  local goc = require 'nvim-goc'

  goc.setup({ verticalSplit = false })

  vim.keymap.set('n', '<space>gcf', goc.Coverage, { silent = true })
  vim.keymap.set('n', '<space>gcc', goc.ClearCoverage, { silent = true })
  vim.keymap.set('n', '<space>gct', goc.CoverageFunc, { silent = true })
  vim.keymap.set('n', ']a', goc.Alternate, { silent = true })
  vim.keymap.set('n', '[a', goc.AlternateSplit, { silent = true })

  local cf = function(testCurrentFunction)
    local cb = function(path)
      if path then
        vim.cmd(":silent exec \"!xdg-open " .. path .. "\"")
      end
    end

    if testCurrentFunction then
      goc.CoverageFunc(nil, cb)
    else
      goc.Coverage(nil, cb)
    end
  end

  vim.keymap.set('n', '<space>gca', cf, { silent = true })
  vim.keymap.set('n', '<space>gcb', function() cf(true) end, { silent = true })
end

M.fzf = function()
  vim.env.FZF_DEFAULT_COMMAND = vim.env.FZF_DEFAULT_COMMAND .. ' --ignore "*generated*" --ignore "*mock*"'

  vim.cmd[[
    augroup go_search
      autocmd!
      " Ag
      autocmd FileType go command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*_test.go --ignore \*generated\* --ignore \*mock\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
      " Aga
      autocmd FileType go command! -bang -nargs=* Aga call fzf#vim#ag(<q-args>, '--ignore vendor --ignore \*generated\* --ignore \*mock\*', <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
    augroup END
  ]]

  vim.keymap.set('n', '<C-p>', ':Files<CR>', { silent = true })
  vim.keymap.set('n', '<space>b', ':Buffers<CR>', {})
  vim.keymap.set('n', '<space>f', ':BLines<CR>', {})

  -- clear buffers
  vim.keymap.set('n', '<space>cb', ':%bd|e#|bd#<CR>', {})


  -- select word under cursor
  vim.keymap.set('x', '<space>a', '"yy:Ag <c-r>y<cr>', {})

  -- search selection
  vim.keymap.set('n', '<space>a', ':Ag <c-r><c-w><cr>', {})


  --------------------- Fzf-lsp
  local fzf_lsp = require 'fzf_lsp'

  local bk = {
    fn = function() end,
    p = {},
  }

  vim.keymap.set('n', '<space>q', function() bk.fn(unpack(bk.p)) end, {})

  local function filter(fn)
    return (function(...)
      return (function(...)
        local result = select(2, ...)
        local fallback = type(result) == 'string'
        if fallback then
          result = select(3, ...)
        end
        if vim.tbl_islist(result) then
          result = vim.tbl_filter(function(v)
            return string.find(v.uri, "_test.go") == nil and
                string.find(v.uri, "mock") == nil
          end, result)
        end

        local p = { ... }
        if fallback then
          p[3] = result
        else
          p[2] = result
        end

        -- backup last
        bk = {
          fn = fn,
          p = p,
        }

        fn(unpack(p))
      end)(...)
    end)
  end

  vim.lsp.handlers["textDocument/codeAction"] = fzf_lsp.code_action_handler
  vim.lsp.handlers["textDocument/definition"] = fzf_lsp.definition_handler
  vim.lsp.handlers["textDocument/declaration"] = fzf_lsp.declaration_handler
  vim.lsp.handlers["textDocument/typeDefinition"] = fzf_lsp.type_definition_handler
  vim.lsp.handlers["textDocument/implementation"] = filter(fzf_lsp.implementation_handler)
  vim.lsp.handlers["textDocument/references"] = filter(fzf_lsp.references_handler)
  vim.lsp.handlers["textDocument/documentSymbol"] = fzf_lsp.document_symbol_handler
  vim.lsp.handlers["workspace/symbol"] = fzf_lsp.workspace_symbol_handler
  vim.lsp.handlers["callHierarchy/incomingCalls"] = fzf_lsp.incoming_calls_handler
  vim.lsp.handlers["callHierarchy/outgoingCalls"] = fzf_lsp.outgoing_calls_handler
end

M.git = function()
  vim.keymap.set('n', '<space>m', '<Plug>(git-messenger)', {})

  --------------------- GitGutter
  vim.g.gitgutter_map_keys = 0
  vim.keymap.set('n', '<space>hu', ':GitGutterUndoHunk<CR>', { noremap = true })
  vim.keymap.set('n', '<space>hp', ':GitGutterPreviewHunk<CR>', { noremap = true })
  vim.keymap.set('n', '<space>hs', ':GitGutterStageHunk<CR>', { noremap = true })
  vim.keymap.set('n', '<space>hd', ':GitGutterDiffOrig<CR>', { noremap = true })
  vim.keymap.set('n', '[c', ':GitGutterPrevHunk<CR>', { noremap = true })
  vim.keymap.set('n', ']c', ':GitGutterNextHunk<CR>', { noremap = true })

  ----------- custom
  vim.keymap.set('n', '<space>co', ':!git checkout %<CR><CR>', {})
end

--------------------- Tmux integration
-- use alt+<dir> to navigate between windows
M.tmux = function()
  vim.g.tmux_navigator_no_mappings = 1

  vim.keymap.set('n', '<A-h>', ':TmuxNavigateLeft<cr>', { silent = true })
  vim.keymap.set('n', '<A-j>', ':TmuxNavigateDown<cr>', { silent = true })
  vim.keymap.set('n', '<A-k>', ':TmuxNavigateUp<cr>', { silent = true })
  vim.keymap.set('n', '<A-l>', ':TmuxNavigateRight<cr>', { silent = true })
end

M.kitty = function()
  vim.g.kitty_navigator_no_mappings = 1

  vim.keymap.set('n', '<A-h>', ':KittyNavigateLeft<cr>', { silent = true })
  vim.keymap.set('n', '<A-j>', ':KittyNavigateDown<cr>', { silent = true })
  vim.keymap.set('n', '<A-k>', ':KittyNavigateUp<cr>', { silent = true })
  vim.keymap.set('n', '<A-l>', ':KittyNavigateRight<cr>', { silent = true })
end


M.lsp = function()
  local lsp = require 'lspconfig'
  local lsp_status = require('lsp-status')

  -- https://github.com/neovim/nvim-lspconfig/issues/115
  local function org_imports()
    local clients = vim.lsp.buf_get_clients()
    for _, client in pairs(clients) do
      local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
      params.context = { only = { "source.organizeImports" } }

      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end
  end

  local opts = { noremap = true, silent = true }

  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<space>g', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local setDir = false
  local on_attach = function(client, bufnr)
    -- use project root_dir
    if not setDir and client.config.root_dir then
      vim.api.nvim_set_current_dir(client.config.root_dir)
      setDir = true
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<c-]>', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<space>gvd', '<C-w>v <cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', '<space>gd', '<C-w>s <cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>gvD', '<C-w>v <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', '<space>gD', '<C-w>s <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<c-s>', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>gs', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>gW', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('x', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('i', '<C-c>', '<ESC><cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- disable tsserver formatter and use eslint codeAction fixAll instead
    if client.name == "tsserver" then
      client.server_capabilities.documentFormattingProvider = false
    elseif client.name == "eslint" then
      local function formatWithEslint()
        local clients = vim.lsp.buf_get_clients()

        for _, c in pairs(clients) do
          if client.name == "eslint" then
            local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
            params.context = { only = { "source.fixAll.eslint" } }

            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 5000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, c.offset_encoding)
                else
                  vim.lsp.buf.execute_command(r.command)
                end
              end
            end
          end
        end
      end
      vim.keymap.set('n', '<space>gf', formatWithEslint, opts)
    else
      vim.keymap.set('n', '<space>gf', function() vim.lsp.buf.format { async = true } end, opts)
    end

    if type(client.server_capabilities.codeLensProvider) == 'table' then
      vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)

      vim.api.nvim_create_autocmd("CursorHold,CursorHoldI,InsertLeave", {
        callback = vim.lsp.codelens.refresh, buffer = bufnr
      })
    end

    lsp_status.on_attach(client)
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

  local servers = { 'tsserver', 'pylsp', 'html', 'cssls', 'jsonls', 'vuels', 'dockerls', 'vimls',
    'rust_analyzer', 'graphql', 'ruby_ls', 'golangci_lint_ls' }
  for _, l in ipairs(servers) do
    lsp[l].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  -- https://github.com/neovim/neovim/blob/master/runtime/doc/lsp.txt#L810
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
      ['local'] = string.gmatch(vim.fn.getcwd(), '/([^/]+)$')(),
      analyses = {
        unusedparams = true,
      },
      codelenses = {
        gc_details = true,
        test = true,
      },
    },
  }

  -- https://github.com/simrat39/rust-tools.nvim
  -- local rt = require("rust-tools")

  -- rt.setup({
  --   server = {
  --     on_attach = function(_, bufnr)
  --       -- Hover actions
  --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
  --       -- Code action groups
  --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
  --     end,
  --   },
  -- })

  lsp.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = { kubernetes = "/k*s.yaml" },
      }
    }
  }

  lsp.eslint.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      packageManager = 'yarn',
    },
  }

  lsp.elixirls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { vim.fn.expand("~/.elixirls/language_server.sh") },
  }

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lsp.lua_ls.setup({
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = { globals = { "vim" } },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = { enable = false },
      },
    },
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go,*.rs" },
    callback = function()
      vim.lsp.buf.format({ sync = true })
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = org_imports,
  })

  --------------------- LspStatusBar

  lsp_status.register_progress()
  lsp_status.config({ status_symbol = '', diagnostics = false })
end


------------ completion
M.cmp = function()
  local cmp = require('cmp')

  vim.opt.completeopt = 'menu,menuone,noselect'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

        -- set a name for each source
        vim_item.menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
      { name = 'ultisnips' },
      { name = 'nvim_lsp' },
      -- { name = 'buffer' },
    }),
    experimental = {
      ghost_text = true
    }
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- add c-y to :
  vim.keymap.set('c', '<C-y>', '', {
    callback = function()
      cmp.confirm({ select = false })
    end,
  })

  --------------------- Snippet
  vim.g.UltiSnipsExpandTrigger = "<tab>"
  vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
  vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
end


M.scrollbar = function()
  require("scrollbar").setup({
    handle = {
      color = '#171b21',
    },
    handlers = {
      search = true,
    },
  })
end

M.search = function()
  vim.keymap.set('n', 'n', '<cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('n', 'N', '<cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('n', '*', '*<cmd>lua require("hlslens").start()<CR>', { noremap = true })
  vim.keymap.set('n', '#', '#<cmd>lua require("hlslens").start()<CR>', { noremap = true })
  vim.keymap.set('n', 'g*', 'g*<cmd>lua require("hlslens").start()<CR>', { noremap = true })
  vim.keymap.set('n', 'g#', 'g#<cmd>lua require("hlslens").start()<CR>', { noremap = true })

  vim.api.nvim_set_hl(0, 'HlSearchLens', { link = 'Comment' })
  -- vim.api.nvim_set_hl(0, 'HlSearchNear', {link='Info'})
end

M.tabbar = function()
  require('bufferline').setup {
    options = {
      mode = "tabs",
    }
  }
end

M.signature = function()
  require "lsp_signature".setup({})
end

M.tree = function()
  require("nvim-tree").setup()
end

return M
