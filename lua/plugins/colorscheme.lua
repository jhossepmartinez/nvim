return {
    {
        "rose-pine/neovim",
        lazy = false,
        config = function()
            require("rose-pine").setup({
                disable_background = true
            })
        end
    },
    {
        "Julpikar/night-owl.nvim"
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                transparent = true,
            })
        end
    },
}
