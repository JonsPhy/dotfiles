return {
  "windwp/nvim-autopairs",
  opts = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    local Rule = require("nvim-autopairs.rule")
    npairs.add_rules({
      Rule("$", "$", { "tex", "markdown" }):with_move(function(opts)
        return opts.prev_char:match(".%$") ~= nil
      end),
    })
  end,
}
