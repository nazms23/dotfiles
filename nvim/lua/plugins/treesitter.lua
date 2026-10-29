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

    -- Eksik parser'lari arka planda kur (main dali: tree-sitter-cli paketi gerekli)
    local missing = vim.tbl_filter(function(lang)
      return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) == 0
    end, ensure)
    if #missing > 0 and vim.fn.executable("tree-sitter") == 1 then
      require("nvim-treesitter").install(missing)
    end
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
