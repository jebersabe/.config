-- Python testing with neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python"
            else
              return "python3"
            end
          end,
          pytest_discover_instances = true,
        }),
      },
      discovery = {
        enabled = true,
        concurrent = 1,
      },
      running = {
        concurrent = true,
      },
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
      },
      output = {
        enabled = true,
        open_on_run = "short",
      },
      quickfix = {
        enabled = false,
      },
    })
    
    -- Test keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "[T]est run nearest [T]est" }))
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "[T]est run [F]ile" }))
    vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, vim.tbl_extend("force", opts, { desc = "[T]est [D]ebug nearest" }))
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, vim.tbl_extend("force", opts, { desc = "[T]est [S]ummary" }))
    vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, vim.tbl_extend("force", opts, { desc = "[T]est [O]utput" }))
    vim.keymap.set("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, vim.tbl_extend("force", opts, { desc = "[T]est [O]utput panel" }))
    vim.keymap.set("n", "<leader>tl", function() require("neotest").run.run_last() end, vim.tbl_extend("force", opts, { desc = "[T]est run [L]ast" }))
    vim.keymap.set("n", "<leader>tw", function() require("neotest").watch.toggle() end, vim.tbl_extend("force", opts, { desc = "[T]est [W]atch" }))
    
    -- Jump between tests
    vim.keymap.set("n", "]t", function() require("neotest").jump.next({ status = "failed" }) end, vim.tbl_extend("force", opts, { desc = "Next failed test" }))
    vim.keymap.set("n", "[t", function() require("neotest").jump.prev({ status = "failed" }) end, vim.tbl_extend("force", opts, { desc = "Previous failed test" }))
  end,
}
