require 'core.options'
require 'core.keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.o.termguicolors = true

require('lazy').setup({
	require "plugins.neotree",
    -- require "plugins.colortheme",
    require "plugins.bufferline",
    require "plugins.lualine",
    require "plugins.treesitter",
    require "plugins.telescope",
    require "plugins.nord",
    require "plugins.lsp",
    require "plugins.autocompletion",
    require "plugins.autoformatting",
    require "plugins.gitsigns",
    require "plugins.alpha",
    require "plugins.autoclose",
    -- require "plugins.markdown",
    require "plugins.hlsearch",
    require "plugins.lazygit",
    -- Python-specific plugins
    require "plugins.dap",
    require "plugins.testing",
    require "plugins.python-utils",
    require "plugins.python-snippets",
})
