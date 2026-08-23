return {
  "huashuai/nvim-comment-overlay",
  event = "VeryLazy",
  config = function()
    require("comment-overlay").setup({
      keymaps = {
        add = "<leader>coa",
        delete = "<leader>cod",
        edit = "<leader>coe",
        next = "<leader>con",
        prev = "<leader>cop",
        toggle_list = "<leader>col",
        toggle_signs = "<leader>cos",
      },
    })

    -- Override descriptions to match our convention
    local map = function(mode, keys, cmd, desc)
      vim.keymap.set(mode, keys, cmd, { desc = "[c]omment [o]verlay: " .. desc })
    end

    -- Extra bindings not covered by the plugin's keymaps config
    map("n", "<leader>cor", "<cmd>CommentResolve<CR>", "[r]esolve")
    map("n", "<leader>cot", "<cmd>CommentReply<CR>", "reply ([t]hread)")
  end,
}
