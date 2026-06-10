-- yabai twm stuff -------------------------------------------------------------

local yabai_path = "/opt/homebrew/bin/yabai"

local function yabai(cmd)
  output = exec(yabai_path .. " -m " .. cmd , false)
  return output
end

local function yabai2(cmd1, cmd2)
  yabai(cmd1)
  return yabai(cmd2)
end

local function jkil(mod, cmd)
  hs.hotkey.bind(mod, "j", function() yabai(string.format("%s west", cmd)) end)
  hs.hotkey.bind(mod, "k", function() yabai(string.format("%s south", cmd)) end)
  hs.hotkey.bind(mod, "i", function() yabai(string.format("%s north", cmd)) end)
  hs.hotkey.bind(mod, "l", function() yabai(string.format("%s east", cmd)) end)
end

jkil({"alt"}, "window --focus")-- Focus window within space
jkil({"alt", "cmd"}, "window --stack")-- Stack window within space
jkil({"ctrl", "alt"}, "window --swap") -- Swap windows within space
jkil({"ctrl", "alt", "cmd"}, "window --warp") -- Swap and split windows within space

-- Focus window within stack
hs.hotkey.bind({"alt", "cmd", "shift"}, "j", function() yabai("window --focus stack.first") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "k", function() yabai("window --focus stack.next") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "i", function() yabai("window --focus stack.prev") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "l", function() yabai("window --focus stack.recent") end)

-- Visual menu for less common stuff
local yabaiMap = {
  [singleKey("s", "Space +")] = {
    [singleKey("r", "Rotate left")] = function() yabai("space --rotate 270") end,
    [singleKey("R", "Rotate right")] = function() yabai("space --rotate 90") end,
    [singleKey("x", "Mirror x-axis")] = function() yabai("space --mirror x-axis") end,
    [singleKey("y", "Mirror y-axis")] = function() yabai("space --mirror y-axis") end,
    [singleKey("b", "Balance")] = function() yabai("space --balance") end
  },
  [singleKey("z", "Zoom +")] = {
    [singleKey("f", "Fullscreen")] = function() yabai("window --toggle zoom-fullscreen") end,
    [singleKey("F", "Native")] = function() yabai("window --toggle native-fullscreen") end,
    [singleKey("d", "Detach")] = function() yabai("window --toggle float --grid 4:4:1:1:2:2") end
  },
  [singleKey("m", "Move +")] = {
    [singleKey("1", "Space 1")] = function() yabai2("window --space 1", "space --focus 1") end,
    [singleKey("2", "Space 2")] = function() yabai2("window --space 2", "space --focus 2") end,
    [singleKey("3", "Space 3")] = function() yabai2("window --space 3", "space --focus 3") end,
    [singleKey("4", "Space 4")] = function() yabai2("window --space 4", "space --focus 4") end,
    [singleKey("5", "Space 5")] = function() yabai2("window --space 5", "space --focus 5") end,
    [singleKey("p", "Win prev disp")] = function() yabai2("window --display west", "display --focus west") end,
    [singleKey("n", "Win next disp")] = function() yabai2("window --display east", "display --focus east") end,
    [singleKey("P", "Spc prev disp")] = function() yabai2("space --display west", "display --focus west") end,
    [singleKey("N", "Spc next disp")] = function() yabai2("space --display east", "display --focus east") end
  }
}
hs.hotkey.bind(meh, "y", spoon.RecursiveBinder.recursiveBind(yabaiMap))

-- Install stackline for visual indication of stack windows
local stackline = require "stackline"
stackline:init({paths = {yabai = yabai_path}})
stackline.config:toggle("appearance.showIcons")
