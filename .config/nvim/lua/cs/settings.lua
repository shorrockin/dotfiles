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

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- faster responsiveness
vim.opt.updatetime = 50

-- displays a colored bar at 80 characters
-- vim.opt.colorcolumn = "80"

-- configures our spell checker
-- vim.opt.spell=true

-- turns off lsp logging, set to debug if we want, otherwise
-- grows indefinitely. stored in ~/.local/state/nvim/lsp.log
vim.lsp.set_log_level("off") 
