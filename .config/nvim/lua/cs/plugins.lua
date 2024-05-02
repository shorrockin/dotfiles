local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Telescope: fuzzy finder: https://github.com/nvim-telescope/telescope.nvim
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
        }
    },

    -- Color Scheme: https://github.com/catppuccin/nvim
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },

    -- Treesitter: language parsing, highlighting, etc
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- Treesitter: context of current method
    'nvim-treesitter/nvim-treesitter-context',

    -- LSP Zero: easy lsp setup: https://github.com/VonHeikemen/lsp-zero.nvim
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/nvim-cmp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },

    -- Trouble: show error messages in gutter https://github.com/folke/trouble.nvim
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    -- Gitsigns: https://github.com/lewis6991/gitsigns.nvim - visual git indicators
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },

    -- Whichkey: https://github.com/folke/which-key.nvim - autocomplete key suggestions
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },

    -- Indentation Guides: https://github.com/lukas-reineke/indent-blankline.nvim
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
    },

    -- Tree view: https://github.com/nvim-tree/nvim-tree.lua
    'nvim-tree/nvim-tree.lua',

    -- Feline: status bar: https://github.com/famiu/feline.nvim
    'feline-nvim/feline.nvim',

    -- Harpoon: markers, quickly jump between files
    'theprimeagen/harpoon',

    -- Undotree: visually see history of a file, branch, etc, bound to leader-u
    'mbbill/undotree',

    -- Fugitive: git client, bind to gs (git-status): https://github.com/tpope/vim-fugitive
    'tpope/vim-fugitive',

    -- Sneak: easy motion with s key. Maybe remove in the future, not used much
    'justinmk/vim-sneak',

    -- Google copilot
    'github/copilot.vim',

    -- Allows for tmux and vim panes to use ctrl-[direction] keys interchangably
    'christoomey/vim-tmux-navigator',
}

-- conditionally try to load our private plugins allowing non-pulic modules
-- to be bootstrapped if it's defined
local ok, module = pcall(require, "private.plugins")
if ok then
    local private_plugins = module.plugins()
    for idx, plugin in ipairs(private_plugins) do
        table.insert(plugins, plugin)
    end
end

local opts = {}
require("lazy").setup(plugins, opts)
