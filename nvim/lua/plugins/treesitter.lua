return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  config = function()
    vim.treesitter.language.register("c_sharp", "cs")

    local ensure = {
      "c_sharp", "typescript", "tsx", "javascript",
      "html", "css", "json", "lua", "bash",
      "markdown", "markdown_inline", "vim", "vimdoc",
      "yaml", "toml", "regex",
    }

    -- Auto-install parsers
    local installed = vim.tbl_map(function(p) return p end, vim.api.nvim_get_runtime_file("parser/*.so", true))
    for _, lang in ipairs(ensure) do
      pcall(vim.treesitter.language.add, lang)
    end

    -- Enable highlight and indent
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
