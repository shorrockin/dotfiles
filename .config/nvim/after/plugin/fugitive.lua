vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = 'Fugitive: [G]it [s]tatus' })
vim.keymap.set("n", "<leader>gd", ':Git diff<CR>', { desc = 'Fugitive: [G]it [d]iff' })
vim.keymap.set("n", "<leader>gc", ':Git commit<CR>', { desc = 'Fugitive: [G]it [c]ommit' })
vim.keymap.set("n", "<leader>gp", ':Git push<CR>', { desc = 'Fugitive: [G]it [p]ush' })
