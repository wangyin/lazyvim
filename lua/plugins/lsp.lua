return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "flake8",
        "clang-format",
        "black",
        "flake8",
        "pyright",
        "debugpy",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "jsonls",
        "clangd",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false,
      -- LSP Server Settings
      -- @type lspconfig.options
      servers = {
        pyright = {},
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.tbl_extend("force", opts.sources, {
        -- Lua
        nls.builtins.formatting.stylua,

        -- cpp
        nls.builtins.formatting.clang_format,

        -- python
        nls.builtins.diagnostics.flake8,
        nls.builtins.formatting.black,
      })
    end,
  },
}
