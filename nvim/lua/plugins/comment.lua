return {
  "numToStr/Comment.nvim",
  keys = {
    { "gcc", mode = "n", desc = "Yorum toggle (satır)" },
    { "gc", mode = "v", desc = "Yorum toggle (seçili)" },
    { "<C-/>", "<cmd>normal gcc<cr>", mode = "n", desc = "Yorum toggle" },
    { "<C-/>", "<esc><cmd>'<,'>normal gcc<cr>", mode = "v", desc = "Yorum toggle" },
  },
  opts = {},
}
