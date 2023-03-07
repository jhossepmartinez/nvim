return {
    -- Lsp Zero
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        dependencies = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},             -- Required
            {"williamboman/mason.nvim"},           -- Optional
            {"williamboman/mason-lspconfig.nvim"}, -- Optional

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},         -- Required
            {"hrsh7th/cmp-nvim-lsp"},     -- Required
            {"hrsh7th/cmp-buffer"},       -- Optional
            {"hrsh7th/cmp-path"},         -- Optional
            {"saadparwaiz1/cmp_luasnip"}, -- Optional
            {"hrsh7th/cmp-nvim-lua"},     -- Optional

            -- Snippets
            {"L3MON4D3/LuaSnip"},             -- Required
            {"rafamadriz/friendly-snippets"}, -- Optional
        },
        config = function()
            local lsp = require('lsp-zero').preset({
                name = 'minimal',
                set_lsp_keymaps = true,
                manage_nvim_cmp = true,
                suggest_lsp_servers = false,
            })

            lsp.ensure_installed({
                "lua_ls",
                "clangd",
                "vimls",
                "tsserver",
                "html",
                "pyright",
                "tailwindcss"
            })

            lsp.configure("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })

            lsp.configure("tailwindcss", {
                on_attach = function(client, bufnr)
                    require("tailwindcss-colors").buf_attach(bufnr)
                end
            })

            lsp.setup_nvim_cmp({
                sources = {
                    { name = 'nvim_lsp', keyword_length = 2}
                }
            })

            lsp.setup()
        end
    },
    {
        "glepnir/lspsaga.nvim",
        lazy = false,
        config = function()
            require("lspsaga").setup({})
        end,
        keys = {
            { "gd", "<cmd>Lspsaga peek_definition<CR>" },
            { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
            { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>" }
        }

    }
}

