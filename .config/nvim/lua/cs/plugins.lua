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
    -- Fuzzy finder for files: https://github.com/ibhagwan/fzf-lua
    {
        "ibhagwan/fzf-lua",
        opts = {
            files = { previewer = false },
            -- This is required to support older version of fzf
            fzf_opts = { ["--border"] = false },
            -- These settings reduce lag from slow git operations
            global_git_icons = false,
            git = {
                files = {
                    previewer = false,
                },
            },
        },
        config = function(_, opts)
            require("fzf-lua").setup(opts)
        end,
    },

    -- Color Scheme: https://github.com/catppuccin/nvim
    {
        'catppuccin/nvim',
        priority = 1000, -- load this before all the other start plugins
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
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        }
    },

    -- Whichkey: https://github.com/folke/which-key.nvim - autocomplete key suggestions
    {
        "folke/which-key.nvim",
        event = 'VimEnter', -- load after vim has started, speeds up load times
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    -- Crates: https://github.com/Saecki/crates.nvim - manages rust crate dependencies
    {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },

    -- Comment: https://github.com/numToStr/Comment.nvim
    -- comment out lines with gcc, or visual selection with gc
    -- gcc: comment out line
    -- gc: comment out visual selection
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    },

    -- Highlight todo, notes, etc in comments
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
    },

    -- Mini https://github.com/echasnovski/mini.nvim
    -- Collection of various small independent plugins/modules
    {
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [']quote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            -- Examples:
            --  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            --  - sd'   - [S]urround [D]elete [']quotes
            --  - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()
        end,
    },

    -- LuaLine: https://github.com/nvim-lualine/lualine.nvim - status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                    -- ... the rest of your lualine config
                }
            }
        end
    },

    -- Tree view: https://github.com/nvim-tree/nvim-tree.lua
    'nvim-tree/nvim-tree.lua',

    -- Undotree: visually see history of a file, branch, etc, bound to leader-u
    'mbbill/undotree',

    -- Google copilot
    'github/copilot.vim',

    -- Allows for tmux and vim panes to use ctrl-[direction] keys interchangably
    'christoomey/vim-tmux-navigator',

    -- Slueth: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
    -- adjusts tab widths etc based on file heuristics
    'tpope/vim-sleuth',

    { import = 'plugins' },
}

-- conditionally try to load our private plugins allowing non-pulic modules
-- to be bootstrapped if it's defined
local ok, module = pcall(require, "private.plugins")
if ok then
    local private_plugins = module.plugins()
    for _, plugin in ipairs(private_plugins) do
        table.insert(plugins, plugin)
    end
end

local opts = {}
require("lazy").setup(plugins, opts)
