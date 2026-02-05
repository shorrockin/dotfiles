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

-- setting determines how automatic formatting such as text wrapping will operate.
-- t: Auto-wrap text using the 'textwidth' setting
-- c: Auto-wrap comments using 'textwidth', inserting commentstring
-- q: Allow formatting of comments using gq
-- r: Automatically insert the comment leader when hitting <Enter> in Insert mode
-- n: Recognize numbered lists
-- 1: When formatting a paragraph, keep one space between sentences (interpreted
--    as a colon/period/semi-colon/question mark/exclamation mark followed by a
--    closing bracket or quote, space and capital letter).
vim.opt.formatoptions = "tcqrn1"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  Does not play well with neoclip
vim.opt.clipboard = "unnamedplus"

-- Enable OSC52 clipboard support for SSH sessions (Neovim 0.10+)
-- This allows copying to local system clipboard when connected via SSH
if vim.env.SSH_CONNECTION then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end

-- preview substitutions live as you type
vim.opt.inccommand = "split"

-- makes the cursor flash
vim.opt.guicursor = "a:blinkon500"

-- show which line your cursor is on
vim.opt.cursorline = true

-- style on the hover window borders
vim.opt.winborder = "rounded"

-- set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- displays a colored bar at 80 characters
-- vim.opt.colorcolumn = "80"

-- configures our spell checker
-- vim.opt.spell=true

-- turns off lsp logging, set to debug if we want, otherwise
-- grows indefinitely. stored in ~/.local/state/nvim/lsp.log
vim.lsp.set_log_level("off")
