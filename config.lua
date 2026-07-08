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
