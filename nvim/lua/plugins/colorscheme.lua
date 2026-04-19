return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      neotree = true,
      telescope = { enabled = true },
      which_key = true,
      indent_blankline = { enabled = true },
      mason = true,
      noice = true,
      notify = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
    custom_highlights = function(colors)
      return {
        CursorLine = { bg = colors.surface0 },
        CursorLineNr = { fg = colors.green, style = { "bold" } },
        LineNr = { fg = colors.surface2 },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
