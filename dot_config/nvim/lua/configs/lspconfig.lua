-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

local servers = {
    "html",
    "cssls",
    "tailwindcss",
    "sqlls",
    "ts_ls",
    "jsonls",
    "eslint",
    -- "htmx",
    "taplo",
    "gopls",
    "clangd",
    "tinymist",
    "bazelrc_lsp"
}
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    })
end

-- lspconfig.emmet_ls.setup({
--     on_attach = nvlsp.on_attach,
--     on_init = nvlsp.on_init,
--     capabilities = nvlsp.capabilities,
--     filetypes = {
--         "css",
--         "eruby",
--         "html",
--         "javascript",
--         "javascriptreact",
--         "less",
--         "sass",
--         "scss",
--         "svelte",
--         "pug",
--         "typescriptreact",
--         "vue",
--         "templ"
--     },
--     init_options = {
--         html = {
--             options = {
--                 -- for possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
--                 ["bem.enabled"] = true,
--                 ["jsx.enabled"] = true,
--             },
--         },
--     },
-- })

lspconfig.cssls.setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
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
            }
        },
        less = {
            validate = true,
            lint = {
                unknownAtRules = "ignore",
            }
        },
    },
})

lspconfig.lua_ls.setup({
    on_init = nvlsp.on_init,
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    settings = {
        runtime = {
            version = "LuaJIT",
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
            checkThirdParty = false,
            library = {
                vim.env.VIMRUNTIME,
            },
        },
        format = {
            defaultConfig = {
                indent_style = "space",
                indent_size = 4,
            },
        },
    },
})

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
