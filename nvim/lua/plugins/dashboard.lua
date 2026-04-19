return {
  "goolord/alpha-nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      [[                                                    ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "  Dosya ara", "<cmd>Telescope find_files<cr>"),
      dashboard.button("r", "  Son dosyalar", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("g", "  İçerik ara", "<cmd>Telescope live_grep<cr>"),
      dashboard.button("e", "  Yeni dosya", "<cmd>ene<cr>"),
      dashboard.button("c", "  Config", "<cmd>e $MYVIMRC<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("m", "  Mason", "<cmd>Mason<cr>"),
      dashboard.button("q", "  Çık", "<cmd>qa<cr>"),
    }

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"

    -- Green header
    vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })

    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end,
}
