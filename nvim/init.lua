vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.winborder = "rounded"
vim.o.cursorline = true

vim.keymap.set("n", "<leader>o", ":w<CR> :update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>bd", ":bd<CR>")
vim.keymap.set("n", "<leader>m", ":w<CR> :make<CR>")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "{", "{zzzv")
vim.keymap.set("n", "}", "}zzzv")
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "gd", "gdzt")

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

-- LSP
vim.lsp.enable({ 'lua_ls', 'pyright' })

-- autocompletion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})

vim.cmd("colorscheme vague")

require "mini.pick".setup()
require "oil".setup({ view_options = { show_hidden = true } })

vim.keymap.set("n", "<Leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<Leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<Leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<Leader>b", ":Pick buffers<CR>")
vim.keymap.set("n", "<Leader>sg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<Leader>e", ":Oil<CR>")
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')

vim.keymap.set("i", "<", "<><Escape>i")
vim.keymap.set("i", "(", "()<Escape>i")
vim.keymap.set("i", "[", "[]<Escape>i")
vim.keymap.set("i", "{", "{}<Escape>i")
vim.keymap.set("i", "{{", "{{  }}<Escape>2hi")
vim.keymap.set("i", "'", "''<Escape>i")
vim.keymap.set('i', '"', '""<Escape>i')

