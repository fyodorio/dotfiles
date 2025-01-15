-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Set font for GUI Neovim
vim.opt.guifont = "FiraCode Nerd Font:h16"

-- Ensure plugins are installed
lvim.plugins = {
    { "projekt0n/github-nvim-theme" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter-angular" }
}

-- Enable icons in NvimTree
lvim.builtin.nvimtree.setup.renderer.icons.show.file = true
lvim.builtin.nvimtree.setup.renderer.icons.show.folder = true

-- Enable icons in Bufferline
lvim.builtin.bufferline.options.show_buffer_icons = true

-- Enable true color support
vim.opt.termguicolors = true

-- Set the GitHub Light High Contrast theme 
lvim.colorscheme = "github_light_high_contrast" -- or github_light, github_dark_dimmed, etc.
