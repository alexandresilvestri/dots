lvim.builtin.nvimtree.setup.view.width = { min = 20, max = 30 }
lvim.builtin.nvimtree.setup.view.adaptive_size = true

lvim.builtin.indentlines.options.use_treesitter = false
lvim.builtin.indentlines.options.use_treesitter_scope = false

require("lvim.lsp.manager").setup("ruff", {
  cmd = { "ruff", "server" },
})

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Inline Gitblame
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.current_line_blame_opts = {
  delay = 300,
  virt_text_pos = "eol", -- end of line
}
lvim.builtin.gitsigns.opts.current_line_blame_formatter =
  "  <author>, <author_time:%Y-%m-%d> · <summary>"

local predicates_kept_from_nvim_builtin = { ["has-ancestor?"] = true, ["has-parent?"] = true }
local ts_query = require "vim.treesitter.query"
local original_add_predicate = ts_query.add_predicate
ts_query.add_predicate = function(name, handler, opts)
  if predicates_kept_from_nvim_builtin[name] then
    return
  end
  return original_add_predicate(name, handler, opts)
end
