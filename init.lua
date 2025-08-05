local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.8' })
Plug('neovim/nvim-lspconfig')
Plug('mason-org/mason.nvim')
Plug('mason-org/mason-lspconfig.nvim')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')
Plug('stevearc/conform.nvim')

vim.call('plug#end')

require('conform').setup({
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang_format" },
        cpp = { "clang_format" },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>f', function()
    require('conform').format({ lsp_fallback = true })
end)

require("mason").setup()
require("mason-lspconfig").setup()

vim.cmd.colorscheme('retrobox')
vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

local cmp = require('cmp')

cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    }),
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').clangd.setup({
    cmd = { "/usr/bin/clangd" },
    capabilities = capabilities,
})
