return {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.nord_contrast = true
        vim.g.nord_borders = false
        vim.g.nord_disable_background = true
        vim.g.nord_italic = false
        vim.g.nord_uniform_diff_background = true
        vim.g.nord_bold = false
        vim.cmd.colorscheme("nord")
        -- Load the colorscheme
    require("nord").setup({
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
        borders = true, -- Enable the border between verticaly split windows visible
        errors = { mode = "bg" }, -- Display mode for errors and diagnostics
                                -- values : [bg|fg|none]
        search = { theme = "vim" }, -- theme for highlighting search results
                                  -- values : [vim|vscode]
        styles = {
            comments = { italic = true },
            keywords = {},
            functions = {},
            variables = {},

            -- To customize lualine/bufferline
            bufferline = {
                current = {},
                modified = { italic = true },
            },
        },

        -- colorblind mode
        -- see https://github.com/EdenEast/nightfox.nvim#colorblind
        -- simulation mode has not been implemented yet.
        colorblind = {
            enable = true,
            preserve_background = false,
            severity = {
                protan = 1.0,
                deutan = 0.0,
                tritan = 0.0,
            },
        },

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with all highlights and the colorScheme table
      on_highlights = function(highlights, colors) end,
    })
    end
}
