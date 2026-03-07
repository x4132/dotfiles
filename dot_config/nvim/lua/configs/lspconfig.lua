-- load defaults (sets up capabilities, on_init, on_attach via LspAttach autocmd)
require("nvchad.configs.lspconfig").defaults()

-- servers with default config
local servers = {
    "html",
    "tailwindcss",
    "ts_ls",
    "jsonls",
    -- "htmx",
    "clangd",
}

-- enable servers with default config
for _, lsp in ipairs(servers) do
    vim.lsp.enable(lsp)
end

-- cssls with custom settings
vim.lsp.config("cssls", {
    settings = {
        css = {
            validate = true,
            lint = {
                unknownAtRules = "ignore",
            },
        },
        scss = {
            validate = true,
            lint = {
                unknownAtRules = "ignore",
            },
        },
        less = {
            validate = true,
            lint = {
                unknownAtRules = "ignore",
            },
        },
    },
})
vim.lsp.enable("cssls")

-- lua_ls with custom settings (extends NvChad defaults)
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            format = {
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                },
            },
        },
    },
})
