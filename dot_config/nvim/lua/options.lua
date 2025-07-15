require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
o.undofile = true
o.timeoutlen = 300
o.relativenumber = true
o.tabstop = 4
o.shiftwidth = 4
o.wrap = false

o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldenable = false
