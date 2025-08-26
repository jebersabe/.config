-- Python debugging with nvim-dap
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- Setup DAP UI
    dapui.setup()
    
    -- Setup virtual text
    require("nvim-dap-virtual-text").setup()
    
    -- Setup Python debugging
    require("dap-python").setup("python3")
    
    -- Python debugging configurations
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            return venv .. "/bin/python"
          else
            return "/usr/bin/python3"
          end
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " ")
        end,
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            return venv .. "/bin/python"
          else
            return "/usr/bin/python3"
          end
        end,
      },
    }
    
    -- DAP keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "[D]ebug toggle [B]reakpoint" }))
    vim.keymap.set("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "[D]ebug [C]ontinue" }))
    vim.keymap.set("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "[D]ebug step [I]nto" }))
    vim.keymap.set("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "[D]ebug step [O]ver" }))
    vim.keymap.set("n", "<leader>dt", dap.step_out, vim.tbl_extend("force", opts, { desc = "[D]ebug step ou[T]" }))
    vim.keymap.set("n", "<leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "[D]ebug [R]EPL" }))
    vim.keymap.set("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "[D]ebug [U]I toggle" }))
    
    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
