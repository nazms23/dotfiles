return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    ensure_installed = {
      "c_sharp",
      "typescript",
      "tsx",
      "javascript",
      "html",
      "css",
      "json",
      "lua",
      "bash",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "yaml",
      "toml",
      "regex",
    },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
