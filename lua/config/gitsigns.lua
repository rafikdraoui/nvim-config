require("gitsigns").setup({
  signs = {
    add = { text = "▍" },
    change = { text = "▍" },
    delete = { text = "_", show_count = true },
    topdelete = { text = "‾", show_count = true },
    changedelete = { text = "~", show_count = true },
  },
  keymaps = {
    noremap = true,

    ["n gj"] = '<cmd>lua require"gitsigns.actions".next_hunk({wrap = false})<cr>',
    ["n gk"] = '<cmd>lua require"gitsigns.actions".prev_hunk({wrap = false})<cr>',

    ["o ih"] = ':<c-u>lua require"gitsigns.actions".select_hunk()<cr>',
    ["x ih"] = ':<c-u>lua require"gitsigns.actions".select_hunk()<cr>',

    ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<cr>',

    ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<cr>',
    ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<cr>',

    ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<cr>',
    ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<cr>',
  },
})
