return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      -- https://github.com/sbulav/dotfiles/blob/master/nvim/lua/config/snippets.lua
      local ls = require("luasnip")
      local snip = ls.snippet
      local text = ls.text_node
      local insert = ls.insert_node

      require("luasnip").add_snippets(nil, {
        json = {
          snip({
            trig = "dpy",
            namr = "Debugpy",
            dscr = "VSCode launch json Python config",
          }, {
            text({ "{", "\t" }),
            text('"name": "'),
            insert(1, "Python"),
            text({ '",', "\t" }),
            text({ '"type": "python",', "\t" }),
            text({ '"request": "launch",', "\t" }),
            text({ '"program": "${workspaceFolder}/' }),
            insert(2, "file.py"),
            text({ '",', "\t" }),
            text('"python": "'),
            insert(3, "executable"),
            text({ '",', "\t" }),
            text('"args": ["'),
            insert(4, "args"),
            text({ '"]', "}" }),
          }),
        },
      })
      require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/snippets" })
    end,
  },
}
