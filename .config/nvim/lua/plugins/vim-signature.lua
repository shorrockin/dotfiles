return {
    -- Vim Signature: https://github.com/kshenoy/vim-signature
    -- marks in the gutter
    "kshenoy/vim-signature",
    config = function()
        vim.keymap.set('n', '<leader>tm', vim.cmd.SignatureToggle, { desc = 'Signature: [T]oggle All [M]arks' })
        vim.keymap.set('n', '<leader>dam', ":delmarks!<CR>", { desc = 'Signature: [D]elete [A]ll [M]arks' })
    end
}
