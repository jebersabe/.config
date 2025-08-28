local set = vim.opt_local
set.shiftwidth = 2

-- local function find_node_ancestor(types, node)
--   if not node then
--     return nil
--   end
--
--   if vim.tbl_contains(types, node:type()) then
--     return node
--   end
--
--   local parent = node:parent()
--
--   find_node_ancestor(types, parent)
--
-- end
--
-- local function add_dtype()
--   vim.api.nvim_feedkeys('t', 'n', true)
--   local current_node = vim.treesitter.get_node()
--   local key_value_node = find_node_ancestor()
--   print(current_node)
--   print(key_value_node)
-- end
--
-- vim.keymap.set('i', 't', add_dtype, { buffer = true })
--
