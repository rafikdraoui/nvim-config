vim.cmd([[packadd packer.nvim]])

return require("packer").startup({
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

    -- Code linting and formatting
    { "dense-analysis/ale" },

    -- Wrappers around git
    { "junegunn/gv.vim", cmd = "GV" },
    {
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns")
      end,
    },
    { "rhysd/conflict-marker.vim" },
    { "rhysd/git-messenger.vim" },
    { "samoshkin/vim-mergetool" },
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },

    -- Wrappers around other external programs
    { "junegunn/fzf.vim" },
    { "ludovicchabant/vim-gutentags" },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("config.lsp")
      end,
      ft = { "go", "python" },
    },
    { "sebdah/vim-delve", ft = "go" },
    { "tpope/vim-eunuch" },
    { "vim-test/vim-test" },

    -- UI
    { "rafikdraoui/couleurs.vim" },
    { "romainl/vim-cool" },

    -- Tree-sitter
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
    },
    {
      "nvim-treesitter/nvim-treesitter-refactor",
      requires = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Misc
    { "MTDL9/vim-log-highlighting" },
    {
      "akinsho/nvim-toggleterm.lua",
      config = function()
        require("toggleterm").setup({ open_mapping = [[<c-\>]] })
      end,
    },
    { "justinmk/vim-dirvish" },
    { "kalekundert/vim-coiled-snake", ft = "python" },
    { "neovimhaskell/haskell-vim" },
    { "norcalli/nvim-colorizer.lua" },
    { "rbong/vim-buffest" },
    { "romainl/vim-qf" },
    { "tpope/vim-characterize" },
    { "tpope/vim-projectionist" },
    { "tpope/vim-scriptease" },
    { "tweekmonster/startuptime.vim" },
    { "vimwiki/vimwiki", ft = "vimwiki" },
  },

  config = {
    compile_path = vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",

    -- hacky, but needed to avoid spurious error when installing vim-coiled-snake plugin
    git = { subcommands = { submodules = "branch" } },

    display = {
      open_cmd = "enew",
      keybindings = { quit = "gq" },
    },
  },
})
