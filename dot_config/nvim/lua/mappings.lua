require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fg", "<leader>fw") -- Telescope findall
map("n", "<C-c>", "<C-s>")
map("n", "<leader>se", vim.diagnostic.setqflist)
map("n", "<leader>of", vim.diagnostic.open_float)
map("n", "<leader>ca", vim.lsp.buf.code_action)

map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
map("v", "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
