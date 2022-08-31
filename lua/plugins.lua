require("packer").startup({
  {
    { "wbthomason/packer.nvim", opt = true },

    -- Actions
    { "machakann/vim-sandwich" },
    { "svermeulen/vim-subversive" },
    { "tommcdo/vim-exchange" },
    { "tpope/vim-commentary" },
    { "tpope/vim-repeat" },

    -- Motions
    { "rhysd/clever-f.vim" },

    -- Text objects
    { "wellle/targets.vim" },

    -- Editing
    { "bfredl/nvim-miniyank" },
    { "simnalamburt/vim-mundo", cmd = "MundoToggle" },
    { "tpope/vim-rsi" },

    -- UI
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = function() require("config.telescope") end,
    },
    { "rafikdraoui/couleurs.vim" },

    -- Wrappers around git
    { "junegunn/gv.vim", cmd = "GV" },
    {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function() require("config.gitsigns") end,
    },
    { "rhysd/conflict-marker.vim" },
    { "rhysd/git-messenger.vim" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },
    { "whiteinge/diffconflicts" },

    -- Wrappers around other external programs
    {
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function() require("config.null_ls") end,
      opt = true,
    },
    { "ludovicchabant/vim-gutentags" },
    {
      "mfussenegger/nvim-lint",
      config = function() require("config.nvim_lint") end,
    },
    {
      "mhartington/formatter.nvim",
      config = function() require("config.formatter") end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function() require("config.lsp") end,
    },
    { "sebdah/vim-delve", ft = "go" },
    { "tpope/vim-eunuch" },
    { "vim-test/vim-test" },

    -- Tree-sitter
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function() require("config.treesitter") end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      requires = { "nvim-treesitter/nvim-treesitter" },
    },
    {
      "nvim-treesitter/playground",
      requires = { "nvim-treesitter/nvim-treesitter" },
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },

    -- Misc
    { "MTDL9/vim-log-highlighting" },
    {
      "akinsho/toggleterm.nvim",
      config = function() require("toggleterm").setup({ open_mapping = [[<c-\>]] }) end,
    },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    { "justinmk/vim-dirvish" },
    { "lewis6991/impatient.nvim" },
    { "neovimhaskell/haskell-vim" },
    { "norcalli/nvim-colorizer.lua" },
    { "rbong/vim-buffest" },
    { "romainl/vim-qf" },
    { "tpope/vim-characterize" },
    { "tpope/vim-projectionist" },
    { "tpope/vim-scriptease" },
    { "vimwiki/vimwiki", ft = "vimwiki" },
  },

  config = {
    compile_path = vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
    display = {
      open_cmd = "enew",
      keybindings = { quit = "gq" },
    },
  },
})
