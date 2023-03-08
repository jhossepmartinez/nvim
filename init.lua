local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.keymaps")
require("config.options")

require("lazy").setup("plugins")

require("config.autocmds")

vim.cmd("colorscheme rose-pine")

<<<<<<< HEAD
-- huhs
=======
>>>>>>> c48e14b449fceaa5800d415704ca78af76f2c66e
