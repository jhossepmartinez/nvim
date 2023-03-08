return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            -- require'nvim-treesitter.install'.compilers = { "clang" }

            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "help",
                    "javascript",
                    "python",
                    "html",
                    "css",
                },
                highlight = { enable = true },
                autotag = { enable = true }
            })
        end,
    }
}

