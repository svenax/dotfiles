vim.cmd [[
try
  colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=light
endtry
]]
