return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Dosya ara" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "İçerik ara" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffer listesi" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Yardım ara" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Son dosyalar" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git commitleri" },
    { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git durum" },
  },
  opts = {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        width = 0.87,
        height = 0.80,
      },
      file_ignore_patterns = {
        "node_modules", ".git/", "bin/", "obj/",
        "%.o", "%.a", "%.out", "%.class", "%.pdf",
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
