return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>t", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (alt)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Terminal (yan)" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal (float)" },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return 60
      end
    end,
    shade_terminals = false,
    float_opts = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Terminal mode'dan çıkış
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
  end,
}
