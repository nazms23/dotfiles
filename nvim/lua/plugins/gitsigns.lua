return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 500,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", gs.next_hunk, "Sonraki hunk")
      map("n", "[h", gs.prev_hunk, "Önceki hunk")
      map("n", "<leader>gp", gs.preview_hunk, "Hunk önizle")
      map("n", "<leader>gr", gs.reset_hunk, "Hunk sıfırla")
      map("n", "<leader>gb", gs.blame_line, "Satır blame")
    end,
  },
}
