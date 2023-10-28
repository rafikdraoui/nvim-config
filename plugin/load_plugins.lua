local load_plugins = function()
  -- Load plugins that don't require any custom configuration.
  -- The following plugins are not included here, because they are lazy-loaded
  -- (see `plugin/lazy_loading.lua`):
  --   * gv.vim
  --   * nvim-dap-go
  --   * vim-startuptime
  for _, p in ipairs({
    "cfilter", -- from default $VIMRUNTIME
    "conflict-marker.vim",
    "diffconflicts",
    "jsonpath.nvim",
    "vim-buffest",
    "vim-characterize",
    "vim-commentary",
    "vim-eunuch",
    "vim-exchange",
    "vim-log-highlighting",
    "vim-repeat",
    "vim-rhubarb",
    "vim-rsi",
    "vim-scriptease",
  }) do
    vim.cmd.packadd(p)
  end

  -- Load configuration for other plugins
  for _, p in ipairs({
    "dap",
    "fzf",
    "gitsigns",
    "lsp",
    "mini",
    "snippy",
    "treesitter",
    "vim_test",
    "vimwiki",
    "all_the_rest",
  }) do
    require("plugins." .. p)
  end
end

local ok = pcall(load_plugins)
if not ok then
  vim.notify("error when loading plugins", vim.log.levels.WARN)
end
