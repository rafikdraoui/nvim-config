vim.cmd.packadd("gitsigns.nvim")
local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "▍" },
    change = { text = "▍" },
    delete = { text = "_", show_count = true },
    topdelete = { text = "‾", show_count = true },
    changedelete = { text = "~", show_count = true },
  },

  on_attach = function(bufnr)
    local function map(l, r, description, mode)
      mode = mode or "n"
      local opts = { buffer = bufnr, desc = description }
      vim.keymap.set(mode, l, r, opts)
    end

    map("gj", function() gitsigns.next_hunk({ wrap = false }) end, "next hunk")
    map("gk", function() gitsigns.prev_hunk({ wrap = false }) end, "previous hunk")

    map("<leader>hp", gitsigns.preview_hunk, "preview hunk")

    map("<leader>hs", gitsigns.stage_hunk, "stage hunk")
    map("<leader>hS", gitsigns.stage_buffer, "stage buffer")
    map("<leader>hu", gitsigns.undo_stage_hunk, "undo stage hunk")

    map("<leader>hr", gitsigns.reset_hunk, "reset hunk")
    map("<leader>hR", gitsigns.reset_buffer, "reset buffer")

    map("ih", gitsigns.select_hunk, "select hunk", { "o", "x" })
  end,
})
