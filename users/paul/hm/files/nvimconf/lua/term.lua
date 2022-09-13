local set_dimension = function(dimension, size)
  return math.floor(vim.api.nvim_list_uis()[1][dimension] * size)
end

local set_float_dimension = function(dimension, size)
  return function(term)
    return set_dimension(dimension, size)
  end
end


require("toggleterm").setup{
  size = function(term)
    if term.direction == "horizontal" then
      return set_dimension("height", 0.4)
    elseif term.direction == "vertical" then
      return set_dimension("width", 0.4)
    end
  end,
  open_mapping = [[<localleader>`]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  -- shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  persist_size = false,
  direction = "horizontal", -- 'vertical' | 'horizontal' | 'window' | 'float'
  close_on_exit = true, -- close the terminal window when the process exits
  shell = "powershell.exe -nologo", -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    width = set_float_dimension("width", 0.7),
    height = set_float_dimension("height", 0.7),
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

local Terminal = require'toggleterm.terminal'.Terminal
local floating_pwsh = Terminal:new({
  cmd = "powershell.exe -nologo",
  direction = 'float',
})

function __floating_pwsh()
  floating_pwsh:toggle()
end

vim.api.nvim_set_keymap("n", "<localleader>op", "<cmd>lua __floating_pwsh()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<localleader>op", "<cmd>lua __floating_pwsh()<CR>", {noremap = true, silent = true})
