return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "BufReadPost",
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " " }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Dosyalar",
          highlight = "Directory",
          text_align = "center",
        },
      },
      separator_style = "thin",
      show_close_icon = false,
      show_buffer_close_icons = true,
      hover = { enabled = true, delay = 200, reveal = { "close" } },
    },
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
  },
}
