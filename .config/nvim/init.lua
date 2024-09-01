
--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--

-- General Options
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set cursorline")
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins for lazy.nvim go here
require("lazy").setup({
  spec = {
    { "rebelot/kanagawa.nvim", priority = 1000 },
    { "nvim-telescope/telescope.nvim", tag = '0.1.8', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }},
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim", "3rd/image.nvim", } },
    { "nvim-lualine/lualine.nvim" },

    { "williamboman/mason.nvim"},
    { "williamboman/mason-lspconfig.nvim", opts = { auto_install = true } },
    { "neovim/nvim-lspconfig" },
    { "nvimtools/none-ls.nvim" },

    { "nvim-telescope/telescope-ui-select.nvim" },
    { "goolord/alpha-nvim" },

    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/cmp-nvim-lsp" },

    { "mfussenegger/nvim-dap" },
    { "OXY2DEV/markview.nvim" },
    { "folke/noice.nvim", event = "VeryLazy", opts = { }, dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", } }
  },
  checker = { enabled = true },
})

-- Requirements
local dap = require("dap")
local builtin = require('telescope.builtin')

-- Keymaps
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- I have no Idea what that does, but it might come in handy
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal right<CR>')
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
vim.keymap.set('n', '<leader>dc', dap.continue, {})

-- Telescope Config
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}
require("telescope").load_extension("ui-select")
-- Treesitter Config
local configs = require("nvim-treesitter.configs")
configs.setup({
  auto_install = true,
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})
-- Lualine Config (who could've guessed)
require('lualine').setup({
  options = { theme = 'gruvbox_dark' }
})
-- Alpha Config
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  [[                                                                       ]],
  [[                                                                       ]],
  [[                                                                       ]],
  [[                                                                       ]],
  [[                                                                     ]],
  [[       ████ ██████           █████      ██                     ]],
  [[      ███████████             █████                             ]],
  [[      █████████ ███████████████████ ███   ███████████   ]],
  [[     █████████  ███    █████████████ █████ ██████████████   ]],
  [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
  [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
  [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
  [[                                                                       ]],
  [[                                                                       ]],
  [[                                                                       ]],
}

alpha.setup(dashboard.opts)
-- Language Server Config
require('mason').setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
  auto_install = true
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  capabilities = capabilities
})
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
     -- null_ls.builtins.completion.spell,
     -- require("none-ls.diagnostics.eslint"),
    },
})
-- Snippets and Autocompletion
local cmp = require'cmp'
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
      { name = 'buffer' },
    })
})
-- Noice.nvim Setup
require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})

-- Colorscheme
vim.cmd("colorscheme kanagawa-dragon")
