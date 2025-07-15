return {
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        opts = require("configs.conform"),
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig")
        end,
        dependencies = {
            "folke/todo-comments.nvim",
        },
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },

    {
        "olimorris/codecompanion.nvim",
        opts = {
            strategies = {
                chat = {
                    keymaps = {
                        close = {
                            modes = {
                                i = "<cmd>q",
                                n = "<cmd>q",
                            },
                        },
                    },
                    tools = {
                        ["mcp"] = {
                            callback = function()
                                return require("mcphub.extensions.codecompanion")
                            end,
                            description = "Call tools and resources from the MCP Servers",
                        },
                    },
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "j-hui/fidget.nvim",
            "ravitemer/mcphub.nvim",
        },

        lazy = false,

        init = function()
            require("plugins.codecompanion.fidget-spinner"):init()
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,
                },
                panel = {
                    enabled = false,
                },
                should_attach = function(_, _)
                    return false
                end,
            })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = {},
            image = {},
            input = {}
        }
    },

    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local types = require("cmp.types")
            local compare = require("cmp.config.compare")
            local function deprioritize_snippet(entry1, entry2)
                if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
                    return false
                end
                if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
                    return true
                end
            end

            opts.sorting = {
                priority_weight = 2,
                comparators = {
                    deprioritize_snippet,
                    compare.offset,
                    compare.exact,
                    -- compare.scopes,
                    compare.score,
                    compare.recently_used,
                    compare.locality,
                    compare.kind,
                    compare.sort_text,
                    compare.length,
                    compare.order,
                },
            }
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "lazy.nvim",
                "LazyVim",
                "stevearc/conform.nvim",
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "bash",
                "c",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "graphql",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "latex",
                "liquid",
                "luadoc",
                "markdown",
                "markdown_inline",
                "matlab",
                "nasm",
                "nginx",
                "nix",
                "perl",
                "php",
                "phpdoc",
                "powershell",
                "printf",
                "prisma",
                "python",
                "query",
                "regex",
                "ruby",
                "sql",
                "svelte",
                "swift",
                "toml",
                "tsx",
                "typescript",
                "typst",
                "xml",
                "yaml",
                "zathurarc",
            },
        },
    },
}
