return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Pocco81/DAPInstall.nvim",
    },
    lazy = true,
    keys = {
      { "<leader>db", "<cmd> DapToggleBreakpoint<CR>", desc = "Debug: toggle breakpoint" },
      { "<leader>dt", "<cmd> DapTerminate<CR>", desc = "Debug: terminate" },
      { "<leader>dc", "<cmd> DapContinue<CR>", desc = "Debug: continue" },
      { "<leader>di", "<cmd> DapStepInto<CR>", desc = "Debug: step into" },
      { "<leader>do", "<cmd> DapStepOut<CR>", desc = "Debug: step out" },
      { "<leader>ds", "<cmd> DapStepOver<CR>", desc = "Debug: step over" },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python3",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "Launch file",
          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
          program = "${file}", -- This configuration will launch the current file if used.
          pythonPath = function()
            --The below line will work for virtualenvwrapper, as vim.env.VIRTUAL_ENV points to the active env directory if you use it
            --Test the variable by running :lua print(vim.env.VIRTUAL_ENV) and find your path from there if it is defined
            local conda = vim.fn.environ()["CONDA_PREFIX"]
            if conda then
              return conda .. "/bin/python"
            end
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable (done above).
            return "/usr/bin/python"
          end,
        },
      }

      local dap_breakpoint = {
        error = {
          text = "🛑",
          texthl = "LspDiagnosticsSignError",
          linehl = "",
          numhl = "",
        },
        rejected = {
          text = "",
          texthl = "LspDiagnosticsSignHint",
          linehl = "",
          numhl = "",
        },
        stopped = {
          text = "⭐️",
          texthl = "LspDiagnosticsSignInformation",
          linehl = "DiagnosticUnderlineInfo",
          numhl = "LspDiagnosticsSignInformation",
        },
      }
      vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
      vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
      vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

      require("dap.ext.vscode").load_launchjs()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local present, dapui = pcall(require, "dapui")
      if not present then
        return
      end

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
          -- Example:
          -- stacks = {
          --   open = "<CR>",
          --   expand = "o",
          -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        },
      })

      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      require("dap").listeners.before.disconnect["dapui_config"] = function()
        dapui.close()
      end
      require("dap").listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      require("dap").listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
