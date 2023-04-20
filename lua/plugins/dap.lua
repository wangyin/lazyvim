return {
  {
    "mfussenegger/nvim-dap",
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
          args = function()
            local cmd_args = vim.fn.input("CommandLine Args:")
            local params = {}
            for param in string.gmatch(cmd_args, "[^%s]+") do
              table.insert(params, param)
            end
            return params
          end,
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

      local dap_breakpoint_color = {
        breakpoint = {
          ctermbg = 0,
          fg = "#993939",
          bg = "#31353f",
        },
        logpoing = {
          ctermbg = 0,
          fg = "#61afef",
          bg = "#31353f",
        },
        stopped = {
          ctermbg = 0,
          fg = "#98c379",
          bg = "#31353f",
        },
      }

      vim.api.nvim_set_hl(0, "DapBreakpoint", dap_breakpoint_color.breakpoint)
      vim.api.nvim_set_hl(0, "DapLogPoint", dap_breakpoint_color.logpoing)
      vim.api.nvim_set_hl(0, "DapStopped", dap_breakpoint_color.stopped)

      local dap_breakpoint = {
        error = {
          text = "",
          texthl = "DapBreakpoint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        condition = {
          text = "ﳁ",
          texthl = "DapBreakpoint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        rejected = {
          text = "",
          texthl = "DapBreakpint",
          linehl = "DapBreakpoint",
          numhl = "DapBreakpoint",
        },
        logpoint = {
          text = "",
          texthl = "DapLogPoint",
          linehl = "DapLogPoint",
          numhl = "DapLogPoint",
        },
        stopped = {
          text = "",
          texthl = "DapStopped",
          linehl = "DapStopped",
          numhl = "DapStopped",
        },
      }

      vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
      vim.fn.sign_define("DapBreakpointCondition", dap_breakpoint.condition)
      vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
      vim.fn.sign_define("DapLogPoint", dap_breakpoint.logpoint)
      vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)

      require("dap.ext.vscode").load_launchjs()
    end,
  },
}
