hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

Install:andUse("RecursiveBinder")
local singleKey = spoon.RecursiveBinder.singleKey

local meta = {"ctrl", "alt"}
local meh = {"ctrl", "alt", "shift"}
local hyper = {"ctrl", "alt", "cmd", "shift"}

-- Typing ----------------------------------------------------------------------

-- Type arrows
hs.hotkey.bind(
  meh, ",", function() pasteit(" -> ") end
)
hs.hotkey.bind(
  meh, ".", function() pasteit(" => ") end
)
-- Terminate current line in code that uses semicolon separators
hs.hotkey.bind(
  meh, "return",
  function()
    hs.eventtap.keyStroke({"cmd"}, "right", 0)
    pasteit(";")
  end
)
-- Pad current line
hs.hotkey.bind(
  meh, "=",
  function()
    hs.eventtap.keyStroke({"ctrl"}, "a", 0)
    hs.eventtap.keyStroke({"cmd", "shift"}, "right", 0)
    hs.eventtap.keyStroke({"cmd"}, "c")
    local text = hs.pasteboard.getContents()
    text = string.sub(text .. string.rep(string.sub(text, -1), 80), 1, 80)
    pasteit(text)
  end
)

-- Passwords
local pk = hs.hotkey.modal.new(meh, "p")
local pa = {}
function pk:entered()
  pa = hs.alert(
    "Password mode\n1-tlah, 2-sa, 3-bih, 4-qo1\n5-@hs, 6-@sa, 7-@sk",
    hs.alert.defaultStyle,
    hs.screen.mainScreen(),
    "inf"
  )
end
hs.fnutils.each(
  hs.settings.get("HSSecrets"), -- Set manually in settings manager
  function(p)
    pk:bind(
      {"shift"}, p.key,
      function()
        pasteit(p.text)
        hs.alert.closeSpecific(pa)
        pk:exit()
      end
    )
  end
)
pk:bind(
  {}, "escape",
  function()
    hs.alert.closeSpecific(pa)
    pk:exit()
  end
)

-- Translate selection
hs.hotkey.bind(
  meh, "0",
  function()
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.dialog.alert(
      300, 300,
      function()
        return exec("pbpaste|trans -b", false)
      end,
      "Translation",
      "",
      "Close"
    )
  end
)

-- Window management -----------------------------------------------------------

hs.window.animationDuration = 0

-- Move offscreen windows back to being fully visible
hs.hotkey.bind(
  hyper, "r",
  function()
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:fullFrame()
    local wins = hs.window.visibleWindows()
    for i, win in ipairs(wins) do
      local frame = win:frame()
      if not frame:inside(screenFrame) then
        win:moveToScreen(screen, true, true)
      end
    end
  end
)

-- Move cursor to other screen
hs.hotkey.bind(
  hyper, "\\",
  function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.setAbsolutePosition(center)
    local win = get_window_under_pointer()
    if (win) then
      win:focus()
    end
    -- hs.eventtap.keyStroke(hyper, "return", 0)
  end
)

-- Show where the cursor is
Install:andUse(
  "MouseCircle",
  {
    hotkeys = {
      show = {hyper, "return"}
    }
  }
)

-- yabai twm stuff -------------------------------------------------------------

local yabai_path = "/opt/homebrew/bin/yabai"

function yabai(cmd)
  output = exec(yabai_path .. " -m " .. cmd , false)
  return output
end

-- Focus window within space
hs.hotkey.bind({"alt"}, "j", function() yabai("window --focus west") end)
hs.hotkey.bind({"alt"}, "k", function() yabai("window --focus south") end)
hs.hotkey.bind({"alt"}, "i", function() yabai("window --focus north") end)
hs.hotkey.bind({"alt"}, "l", function() yabai("window --focus east") end)

-- Stack window within space
hs.hotkey.bind({"alt", "cmd"}, "j", function() yabai("window --stack west") end)
hs.hotkey.bind({"alt", "cmd"}, "k", function() yabai("window --stack south") end)
hs.hotkey.bind({"alt", "cmd"}, "i", function() yabai("window --stack north") end)
hs.hotkey.bind({"alt", "cmd"}, "l", function() yabai("window --stack east") end)

-- Focus window within stack
hs.hotkey.bind({"alt", "cmd", "shift"}, "j", function() yabai("window --focus stack.first") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "k", function() yabai("window --focus stack.next") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "i", function() yabai("window --focus stack.prev") end)
hs.hotkey.bind({"alt", "cmd", "shift"}, "l", function() yabai("window --focus stack.recent") end)

-- Swap windows within space
hs.hotkey.bind({"ctrl", "alt"}, "j", function() yabai("window --swap west") end)
hs.hotkey.bind({"ctrl", "alt"}, "k", function() yabai("window --swap south") end)
hs.hotkey.bind({"ctrl", "alt"}, "i", function() yabai("window --swap north") end)
hs.hotkey.bind({"ctrl", "alt"}, "l", function() yabai("window --swap east") end)

-- Swap and split windows within space
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function() yabai("window --warp west") end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function() yabai("window --warp south") end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "i", function() yabai("window --warp north") end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function() yabai("window --warp east") end)

hs.hotkey.bind(meh, "u", function() yabai("window --display west; yabai -m display --focus west") end)
hs.hotkey.bind(meh, "o", function() yabai("window --display east; yabai -m display --focus east") end)

local term_path = [[/opt/homebrew/bin/wezterm --config 'window_decorations="INTEGRATED_BUTTONS|RESIZE"']]
hs.hotkey.bind(meh, "\\", function() os.execute(term_path .. " start --always-new-process &") end)

-- Install stackline for visual indication of stack windows
local stackline = require "stackline"
stackline:init({paths = {yabai = yabai_path}})
stackline.config:toggle("appearance.showIcons")

-- Visual menu for less common stuff
local yabaiMap = {
  [singleKey("s", "Space +")] = {
    [singleKey("r", "Rotate")] = function() yabai("space --rotate 270") end,
    [singleKey("x", "Mirror x-axis")] = function() yabai("space --mirror x-axis") end,
    [singleKey("y", "Mirror y-axis")] = function() yabai("space --mirror y-axis") end,
    [singleKey("b", "Balance")] = function() yabai("space --balance") end
  },
  [singleKey("f", "Fullscreen")] = function() yabai("window --toggle zoom-fullscreen") end,
  [singleKey("F", "Native fullscreen")] = function() yabai("window --toggle native-fullscreen") end,
  [singleKey("d", "Detach")] = function() yabai("window --toggle float --grid 4:4:1:1:2:2") end
}
hs.hotkey.bind(meh, "y", spoon.RecursiveBinder.recursiveBind(yabaiMap))

-- Configuration switching -----------------------------------------------------

local wifi = Install:andUse(
  "WiFiTransitions",
  {
    config = {
      actions = {
        {to = "SvensWifi", cmd = "lpoptions -d HP_Color_LaserJet_M254dw__718986_"},
        {to = "KVD-WLAN", cmd = "lpoptions -d _10_11_30_25_2"},
      }
    },
    start = true,
  }
)

-- Menu stuff ------------------------------------------------------------------

function trashSizes()
  local text = exec([[du -sh ~/.Trash  | awk -F'/' '{print $1 $3}']])
  hs.dialog.blockAlert("Trash size on all volumes", text:gsub("[ \t]+", " on "), "Close")
end

function switchSoundOutput(to)
  hs.osascript.applescript(
    [[
    tell application "System Preferences"
      reveal anchor "output" of pane id "com.apple.preference.sound"
    end tell

    tell application "System Events" to tell process "System Preferences"
      repeat until exists tab group 1 of window 1
      end repeat
      tell table 1 of scroll area 1 of tab group 1 of window 1
        select (row 1 where value of text field 1 is "]] ..
      to .. [[")
      end tell
    end tell
    quit application "System Preferences"
    ]]
  )
end

-- Must be global or the menu will be garbage collected
menu = hs.menubar.new(true, "svenax-HS")
menu:setTitle("HS")
menu:setMenu(
  {
    {title = "Trash Sizes", fn = trashSizes},
    {title = "Restart Yabai", fn = function()
      exec("yabai --restart-service", true)
      notify("Yabai config loaded")
    end},
    {title = "-"},
    {title = "Open Folders", menu = {
      {title = "Applications", fn = function() exec("open /Applications", true) end},
      {title = "Downloads", fn = function() exec("open ~/Downloads", true) end},
      {title = "Library", fn = function() exec("open /Library", true) end},
      {title = "~/Library", fn = function() exec("open ~/Library", true) end},
    }},
    {title = "Sound Output", menu = {
      {title = "Internal", fn = function() switchSoundOutput("MacBook Pro Speakers") end},
      {title = "Headphones", fn = function() switchSoundOutput("Bose QC45") end},
    }},
    {title = "-"},
  }
)

-- Helpers ---------------------------------------------------------------------

function notify(text, title)
  title = title or ""
  hs.notify.show("Hammerspoon", title, text)
end

function pasteit(text)
  hs.pasteboard.setContents(text)
  hs.eventtap.keyStroke({"cmd"}, "v")
  hs.pasteboard.clearContents()
end

function exec(cmd, with_env)
  output = hs.execute(cmd, with_env)
  return output
end

function get_window_under_pointer()
  -- Invoke `hs.application` because `hs.window.orderedWindows()` doesn't
  -- do it and breaks itself
  local _ = hs.application
  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()
  return hs.fnutils.find(
    hs.window.orderedWindows(),
    function(w)
      return my_screen == w:screen() and my_pos:inside(w:frame())
    end
  )
end

-- Reload config ---------------------------------------------------------------

Install:andUse("ReloadConfiguration", {start = true})
notify("Hammerspoon config loaded")
