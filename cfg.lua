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
      "graphql", "lua", "terraform" },

    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
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

  goc.setup({ verticalSplit = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.go" },
    callback = function()
      vim.keymap.set('n', '<space>gcf', goc.Coverage, { silent = true })
      vim.keymap.set('n', '<space>gcc', goc.ClearCoverage, { silent = true })
      vim.keymap.set('n', '<space>gct', goc.CoverageFunc, { silent = true })
      vim.keymap.set('n', ']a', goc.Alternate, { silent = true })
      vim.keymap.set('n', '[a', goc.AlternateSplit, { silent = true })

      local cf = function(testCurrentFunction)
        local cb = function(path, index)
          if path then
            vim.cmd(":silent exec \"!xdg-open file://" .. path .. "\\\\#file" .. index .. "\"")
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
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.js,*.ts,*.tsx" },
    callback = function()
      vim.keymap.set('n', ']a', function() goc.AlternateFile(false, '.test', 'vert') end, { silent = true })
      vim.keymap.set('n', '[a', function() goc.AlternateFile(true, '.test', 'vert') end, { silent = true })
    end
  })
end

M.telescope = function()
  require('telescope').setup {
    defaults = {
      path_display = { "smart" },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '-g', '!go.sum',
        '-g', '!uv.lock',
        '-g', '!yarn.lock',
      },
      mappings = {
        i = {
          ["<C-`>"] = "close",
          ["<C-[>"] = "close"
        }
      }
    },
  }
  local builtin = require('telescope.builtin')
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = desc })
  end

  map('<C-p>', function() builtin.git_files({ show_untracked = true }) end, 'Telescope find files')
  map('<space>fg', builtin.live_grep, 'Telescope live grep')
  map('<space>a', function()
    builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
  end, 'Telescope live grep')
  map('<space>b', builtin.buffers, 'Telescope buffers')
  map('<space>fh', builtin.help_tags, 'Telescope help tags')

  -- LSP
  map('gr', builtin.lsp_references, 'LSP: [G]oto [R]eferences')
  map('gi', builtin.lsp_implementations, 'LSP: [G]oto [I]mplementation')
  map('gd', builtin.lsp_definitions, 'LSP: [G]oto [D]efinition')
  map('<space>gd', function()
    vim.cmd(':sp')
    builtin.lsp_definitions()
  end, 'LSP: [G]oto [D]efinition splitted')
  map('gs', builtin.lsp_document_symbols, 'LSP: Open [D]ocument [S]ymbols')
  map('gw', builtin.lsp_workspace_symbols, 'LSP: Open Workspace Symbols')
  map('gW', builtin.lsp_dynamic_workspace_symbols, 'LSP: Open Workspace Symbols')
  map('gt', builtin.lsp_type_definitions, 'LSP: [G]oto [T]ype Definition')
  map('<space>ld', function() builtin.diagnostics({ bufnr = 0 }) end, 'LSP: [L]ist [D]iagnostics')
end

M.gitsigns = function()
  local gitsigns = require('gitsigns')

  gitsigns.setup {
    signs = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '+' },
      change       = { text = '~' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end)

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end)

      -- Actions
      map('n', '<space>hs', gitsigns.stage_hunk)
      map('n', '<space>hr', gitsigns.reset_hunk)
      map('v', '<space>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('v', '<space>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
      map('n', '<space>hS', gitsigns.stage_buffer)
      map('n', '<space>hu', gitsigns.undo_stage_hunk)
      map('n', '<space>hR', gitsigns.reset_buffer)
      map('n', '<space>hp', gitsigns.preview_hunk)
      map('n', '<space>hb', function() gitsigns.blame_line { full = true } end)
      map('n', '<space>tb', gitsigns.toggle_current_line_blame)
      map('n', '<space>hd', gitsigns.diffthis)
      map('n', '<space>hD', function() gitsigns.diffthis('~') end)
      map('n', '<space>td', gitsigns.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
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
  local lsp_status = require('lsp-status')

  local opts = { noremap = true, silent = true }

  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<space>g', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<c-]>', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', '<space>gvd', '<C-w>v <cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- vim.keymap.set('n', '<space>gd', '<C-w>s <cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', '<space>gvD', '<C-w>v <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.keymap.set('n', '<space>gD', '<C-w>s <cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<c-s>', vim.lsp.buf.hover, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set({ 'n', 'i' }, '<c-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>gs', vim.lsp.buf.document_symbol, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set('n', '<space>gW', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set({ 'n', 'x' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('i', '<C-c>', '<ESC><cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.keymap.set('n', '<space>gf', function() vim.lsp.buf.format { async = true } end, opts)

    lsp_status.on_attach(client)
  end

  local lsp_group = vim.api.nvim_create_augroup('lsp', {})
  vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_group,
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client.server_capabilities.codeLensProvider then
        vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, { silent = true })

        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_create_autocmd({ 'InsertLeave', 'CursorHold' }, {
          group = vim.api.nvim_create_augroup(string.format('lsp-codelens-%s', bufnr), {}),
          buffer = bufnr,
          callback = function()
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end,
        })
      end
    end,
  })
  vim.api.nvim_create_autocmd('LspDetach', {
    group = lsp_group,
    callback = function(args)
      local group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', args.buf, args.data.client_id), {})
      pcall(vim.api.nvim_del_augroup_by_name, group)
    end,
  })

  -- shared
  vim.lsp.config('*', {
    on_attach = on_attach,
    capabilities = vim.tbl_extend('keep', require('cmp_nvim_lsp').default_capabilities(), lsp_status.capabilities),
    flags = {
      debounce_text_changes = 150,
    },
    root_markers = { '.git' },
  })

  for _, l in ipairs({
    'html', 'cssls', 'jsonls', 'dockerls', 'graphql', 'terraformls', 'ts_ls',
    'pyright', 'ruff', 'gopls', 'yamlls', 'eslint', 'mybiome', 'lua_ls',
    -- 'oxlint', 'vuels', 'vimls'
    -- 'pylsp',
    -- 'pyrefly'
    -- 'ty'
  }) do
    vim.lsp.enable(l)
  end

  -- avoid to install neovim in every py virtualenv
  vim.cmd [[
    augroup py_virtualenv
      if exists("$VIRTUAL_ENV")
          let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
      else
          let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
      endif
    augroup END
  ]]

  ---------------------

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go,*.py" },
    callback = function()
      vim.lsp.buf.format({ sync = true })
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go,*.py" },
    callback = function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.organizeImports" },
        },
        apply = true,
      })
      -- Optional: Add a small delay if you encounter race conditions,
      -- though `apply = true` should generally handle this.
      -- vim.wait(100)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*" },
    callback = function()
      if vim.bo.filetype == 'python' then
        vim.opt.colorcolumn = '88'
      elseif vim.bo.filetype == 'go' then
        vim.opt.expandtab = false
      else
        vim.opt.colorcolumn = '120'
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.js,*.ts,*.tsx" },
    callback = function()
      vim.keymap.set('n', '<space>fp', function() vim.cmd(':silent !yarn prettier -w %'); end, opts)
    end
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
  require("nvim-tree").setup({
    update_focused_file = {
      enable = true,
    },
  })

  vim.keymap.set('n', 'ntt', ':NvimTreeToggle<CR>', { noremap = true })
  vim.keymap.set('n', 'ntf', ':NvimTreeFindFile<CR>', { noremap = true })
end

return M
