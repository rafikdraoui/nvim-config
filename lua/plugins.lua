require("packer").startup({
  {
    { "wbthomason/packer.nvim", opt = true },

    -- Actions
    {
      "echasnovski/mini.surround",
      config = function() require("config.mini").surround() end,
    },
    { "svermeulen/vim-subversive" },
    { "tommcdo/vim-exchange" },
    { "tpope/vim-commentary" },
    { "tpope/vim-repeat" },

    -- Motions
    {
      "echasnovski/mini.jump",
      config = function() require("config.mini").jump() end,
    },

    -- Text objects
    {
      "echasnovski/mini.ai",
      config = function() require("config.mini").ai() end,
    },

    -- Editing
    { "bfredl/nvim-miniyank" },
    {
      "dcampos/nvim-snippy",
      config = function() require("config.snippy") end,
    },
    { "simnalamburt/vim-mundo", cmd = "MundoToggle" },
    { "tpope/vim-rsi" },

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
      "ibhagwan/fzf-lua",
      config = function() require("config.fzf") end,
    },
    {
      "leoluz/nvim-dap-go",
      requires = { "mfussenegger/nvim-dap" },
      after = "nvim-dap",
      config = function() require("dap-go").setup() end,
      ft = "go",
    },
    { "ludovicchabant/vim-gutentags" },
    { "mfussenegger/nvim-dap", config = function() require("config.dap") end },
    {
      "neovim/nvim-lspconfig",
      config = function() require("config.lsp") end,
    },
    { "simrat39/rust-tools.nvim" },
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
      cmd = { "TSPlaygroundToggle" },
    },

    -- Misc
    { "MTDL9/vim-log-highlighting" },
    {
      "akinsho/toggleterm.nvim",
      config = function() require("toggleterm").setup({ open_mapping = [[<c-\>]] }) end,
    },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    {
      "elihunter173/dirbuf.nvim",
      config = function() require("dirbuf").setup({ write_cmd = "DirbufSync -confirm" }) end,
    },
    {
      "lukas-reineke/lsp-format.nvim",
      config = function() require("lsp-format").setup() end,
    },
    { "norcalli/nvim-colorizer.lua" },
    {
      "phelipetls/jsonpath.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
    },
    { "rafikdraoui/couleurs.vim" },
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
    log = { level = "error" },
  },
})
