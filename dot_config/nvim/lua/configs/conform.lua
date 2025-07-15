local conform = require("conform.types")

local jsfmt = { "prettierd", "prettier", stop_after_first = true }
---@type conform.setupOpts
local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        javascript = jsfmt,
        javascriptreact = jsfmt,
        typescript = jsfmt,
        typescriptreact = jsfmt,
    },

    lsp_format = "last",

    -- format_on_save = {
    --     -- These options will be passed to conform.format()
    --     timeout_ms = 500,
    --     lsp_fallback = true,
    -- },
}

return options
