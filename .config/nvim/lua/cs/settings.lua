-- relative line number setup
vim.opt.nu = true
vim.opt.relativenumber = true

-- 8 tabs!? get out of here
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

-- turn off all temp files except for undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search setup
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- decreases update time which is time to write to swap
vim.opt.updatetime = 250

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- decrease mapped sequence wait time, displays which-key popup sooner
vim.o.timeout = true
vim.opt.timeoutlen = 300

-- enable mouse mode, useful for resizing
vim.opt.mouse = "a"

-- don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  Does not play well with neoclip
-- vim.opt.clipboard = 'unnamedplus'

-- preview substitutions live as you type
vim.opt.inccommand = "split"

-- makes the cursor flash
vim.opt.guicursor = "a:blinkon500"

-- show which line your cursor is on
vim.opt.cursorline = true

-- set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- displays a colored bar at 80 characters
-- vim.opt.colorcolumn = "80"

-- configures our spell checker
-- vim.opt.spell=true

-- turns off lsp logging, set to debug if we want, otherwise
-- grows indefinitely. stored in ~/.local/state/nvim/lsp.log
vim.lsp.set_log_level("off")
