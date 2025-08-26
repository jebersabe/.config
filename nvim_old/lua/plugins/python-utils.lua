-- Python-specific utilities and enhancements
return {
  {
    -- Better Python indentation
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },
  {
    -- Python text objects
    "jeetsukumaran/vim-pythonsense",
    ft = "python",
  },
  {
    -- Python docstring generation
    "danymat/neogen",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
      
      vim.keymap.set("n", "<leader>nf", function()
        require("neogen").generate({ type = "func" })
      end, { desc = "[N]eogen [F]unction docstring" })
      
      vim.keymap.set("n", "<leader>nc", function()
        require("neogen").generate({ type = "class" })
      end, { desc = "[N]eogen [C]lass docstring" })
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    -- Python REPL integration
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = {"python3"},
              format = require("iron.fts.common").bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").bottom(40),
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      })
      
      -- Python REPL keymaps
      vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>', { desc = '[R]EPL [S]tart' })
      vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>', { desc = '[R]EPL [R]estart' })
      vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = '[R]EPL [F]ocus' })
      vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = '[R]EPL [H]ide' })
    end,
  },
}
