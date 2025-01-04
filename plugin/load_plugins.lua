local load_plugins = function()
  -- Load plugins that don't require any custom configuration.
  for _, p in ipairs({
    "cfilter", -- from default $VIMRUNTIME
    "diffconflicts",
    "jj-diffconflicts",
    "jsonpath.nvim",
    "vim-buffest",
    "vim-characterize",
    "vim-eunuch",
    "vim-log-highlighting",
    "vim-repeat",
    "vim-rsi",
    "vim-scriptease",
  }) do
    vim.cmd.packadd(p)
  end

  -- Load configuration for other plugins
  for _, p in ipairs({
    "dap",
    "fzf",
    "lsp",
    "mini",
    "snippy",
    "treesitter",
    "vim_test",
    "all_the_rest",
  }) do
    require("rafik.plugins." .. p)
  end
end

xpcall(
  load_plugins,
  function(err) vim.notify("error when loading plugins: " .. err, vim.log.levels.WARN) end
)
