return {
    -- Comment: https://github.com/numToStr/Comment.nvim
    -- comment out lines with gcc, or visual selection with gc
    -- gcc: comment out line
    -- gc: comment out visual selection
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
}
