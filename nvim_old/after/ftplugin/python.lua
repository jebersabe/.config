-- Python-specific settings
local set = vim.opt_local

-- Set Python-specific indentation (PEP 8)
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true

-- Line length for Python (PEP 8)
set.textwidth = 88
set.colorcolumn = "88"

-- Python-specific keymaps
local opts = { noremap = true, silent = true, buffer = true }

-- Run Python file
vim.keymap.set('n', '<leader>rp', ':w<CR>:!python3 %<CR>', { desc = '[R]un [P]ython file', buffer = true })

-- Python REPL
vim.keymap.set('n', '<leader>pr', ':terminal python3<CR>', { desc = '[P]ython [R]EPL', buffer = true })

-- Run Python tests
vim.keymap.set('n', '<leader>pt', ':w<CR>:!python3 -m pytest %<CR>', { desc = '[P]ython [T]est file', buffer = true })

-- Python documentation lookup
vim.keymap.set('n', '<leader>pd', ':!pydoc3 <cword><CR>', { desc = '[P]ython [D]ocumentation', buffer = true })

-- Quick docstring insertion
vim.keymap.set('n', '<leader>ds', 'o"""<CR><CR>"""<Esc>kA', { desc = '[D]oc[s]tring', buffer = true })

-- Add import statement at top
vim.keymap.set('n', '<leader>pi', 'ggO<Esc>cc', { desc = '[P]ython [I]mport at top', buffer = true })

-- Format with black if available
vim.keymap.set('n', '<leader>pb', ':!black %<CR>', { desc = '[P]ython [B]lack format', buffer = true })

-- Virtual environment info
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
            local venv_name = vim.fn.fnamemodify(venv, ":t")
            vim.b.venv_name = venv_name
        end
    end,
})
