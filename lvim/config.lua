-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- Set font for GUI Neovim
vim.opt.guifont = "FiraCode Nerd Font:h16"

-- Ensure plugins are installed
lvim.plugins = {{"NeogitOrg/neogit"}, {"projekt0n/github-nvim-theme"}, {"nvim-tree/nvim-web-devicons"},
                {"nvim-treesitter/nvim-treesitter-angular"}}

-- Set up NeoGit
require("neogit").setup({
    -- Ensure NeoGit creates a local branch when checking out a remote branch
    branch = {
        create_on_checkout = true -- Automatically create a local branch when checking out a remote branch
    }
})

-- keybinding to open NeoGit
lvim.builtin.which_key.mappings["g"] = {
    name = "Git",
    n = {"<cmd>Neogit<cr>", "NeoGit"}, -- Open NeoGit
    b = {"<cmd>Telescope git_branches<cr>", "Search Branches"} -- Search branches with Telescope
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

-- Enable basic autosave
vim.opt.autowrite = true -- automatically write when leaving a modified buffer
vim.opt.autowriteall = true -- automatically write on various commands/events

-- Autosave with proper event format
local autosave_group = vim.api.nvim_create_augroup("Autosave", {
    clear = true
})
vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    group = autosave_group,
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            if vim.bo.buftype == "" then
                vim.cmd("silent! write")
            end
        end, 1000)
    end
})

-- Tree configuration
lvim.builtin.nvimtree.setup = {
    view = {
        width = 50,
        side = "left"
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true
    }
}

-- Window management settings
vim.opt.splitright = true -- New vertical splits go right
vim.opt.equalalways = false -- Don't auto-resize windows

-- Hide tabline (since we're using single buffers)
vim.opt.showtabline = 0

-- Preserve undo history
vim.opt.undofile = true

-- Decrease the timeout for key sequences
vim.opt.timeoutlen = 300 -- Time in milliseconds to wait for a mapped sequence to complete

-- Make sure which-key opens faster
lvim.builtin.which_key.setup.timeout = 300

-- Remove any direct mapping of <Space>f if it exists
lvim.keys.normal_mode["<Space>f"] = nil

-- Custom function to get relative path display 
local function relative_path_display(opts, path)
    local cwd = vim.fn.getcwd()
    local relative_path = path:gsub("^" .. vim.pesc(cwd) .. "/", "")
    return relative_path
end

-- Configure telescope defaults with relative path display and proper icon settings
lvim.builtin.telescope.defaults = vim.tbl_deep_extend("force", lvim.builtin.telescope.defaults, {
    path_display = relative_path_display,
    layout_config = {
        horizontal = {
            preview_width = 0.75 -- Take 75% of the window for preview
        },
        height = 0.9 -- Use 90% of screen height
    },
    file_ignore_patterns = {}, -- Optional: add patterns to ignore
    vimgrep_arguments = { -- Optional: improved grep settings
    "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden"}
})

-- Create custom recent files picker
local telescope = require('telescope.builtin')
local telescope_utils = require('telescope.utils')

-- Custom function for project-scoped recent files
local project_recent_files = function()
    local cwd = vim.fn.getcwd()
    telescope.oldfiles({
        cwd_only = true,
        tiebreak = function(current, existing)
            return vim.fn.getftime(current) > vim.fn.getftime(existing)
        end,
        path_display = relative_path_display
    })
end

-- Set up the file-related keybindings with relative path display
lvim.builtin.which_key.mappings["f"] = {
    name = "Files",
    f = {function()
        telescope.find_files({
            path_display = relative_path_display
        })
    end, "Find File"},
    r = {function()
        project_recent_files()
    end, "Recent Project Files"},
    g = {function()
        telescope.git_files({
            path_display = relative_path_display
        })
    end, "Git Files"},
    b = {function()
        telescope.file_browser({
            path_display = relative_path_display
        })
    end, "File Browser"},
    w = {function()
        telescope.live_grep({
            path_display = relative_path_display
        })
    end, "Search Words"}
}
