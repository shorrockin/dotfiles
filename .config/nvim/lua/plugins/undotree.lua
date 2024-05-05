return {
    -- Undotree: visually see history of a file, branch, etc, bound to leader-u
    'mbbill/undotree',
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Undotree: [U]ndotree' })
    end
}
