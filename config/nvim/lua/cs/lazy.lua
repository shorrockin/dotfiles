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

-- monkey patch spawn lazy command to avoid system level git config,
-- useful when the system might be configured in a way where we cannot
-- access public git repos
local lazy = require("lazy") -- first require lazy to ensure the vim.uv shim is applied

local spawn = require("lazy.manage.process").spawn
require("lazy.manage.process").spawn = function(cmd, opts)
	opts = opts or {}
	opts.env = vim.tbl_extend("force", opts.env or {}, { GIT_CONFIG_NOSYSTEM = "1" })
	return spawn(cmd, opts)
end

lazy.setup("plugins", {
	change_detection = {
		notify = false,
	},
})
