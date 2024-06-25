local M = {}


function M.setup(opts)

  opts = opts or {}

  vim.keymap.set("n", "<leader>t", function()

    local window = require("test.window")
    window.whid()

    if vim.fn.has("nvim-0.7.0") ~= 1 then
      vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
      return;
    end

    if opts.name then
      print("hello, " .. opts.name)
    else 
      print ("hello with no name")
    end

  end
  )
end

return M
