return {
    -- Neotree
    {
        "nvim-neo-tree/neo-tree.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim"
        },
        keys = {
            { "<Leader>nm", "<cmd>Neotree toggle<CR>"}
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    width = 25,
                }
            })
            vim.cmd("Neotree toggle")
        end
    },
    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        opts = {
            options = {
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "NeoTree",
                        text_align = "left",
                        separator = true,
                        highlight = "Directory"
                    }
                },
                sort_by = "insert_after_current",
            }
        },
        keys = {
            { "<S-j>", "<cmd>BufferLineCycleNext<CR>" },
            { "<S-k>", "<cmd>BufferLineCyclePrev<CR>" }
        }
    },
    -- Lualine
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                disabled_filetypes = { "neo-tree" }
            }
        }
    }
}

