return {
    -- Undotree: visually see history of a file, branch, etc, bound to leader-u
    'mbbill/undotree',
    config = function()
        vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = 'Undotree: [T]oggle [U]ndotree' })
    end
}
