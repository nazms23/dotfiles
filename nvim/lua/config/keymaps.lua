local map = vim.keymap.set

-- Save
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Kaydet" })
map("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Kaydet" })

-- Quit
map("n", "<leader>q", "<cmd>bd<cr>", { desc = "Buffer kapat" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Tümünü kapat" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Sol pencere" })
map("n", "<C-j>", "<C-w>j", { desc = "Alt pencere" })
map("n", "<C-k>", "<C-w>k", { desc = "Üst pencere" })
map("n", "<C-l>", "<C-w>l", { desc = "Sağ pencere" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Yükseklik artır" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Yükseklik azalt" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Genişlik azalt" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Genişlik artır" })

-- Buffer navigation
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Sonraki buffer" })
map("n", "<S-Tab>", "<cmd>bprev<cr>", { desc = "Önceki buffer" })

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Satırı aşağı taşı" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Satırı yukarı taşı" })

-- Stay centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better paste (don't overwrite register)
map("x", "<leader>p", '"_dP', { desc = "Yapıştır (register koruma)" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Hepsini seç" })

-- Fold (kod bloğu daralt/aç)
map("n", "<leader>w", "za", { desc = "Fold toggle" })
map("n", "<leader>s", "zA", { desc = "Fold toggle (tümü)" })
