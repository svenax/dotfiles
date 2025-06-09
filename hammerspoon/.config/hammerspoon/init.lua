hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

hs.loadSpoon("RecursiveBinder")
local singleKey = spoon.RecursiveBinder.singleKey

local meta = {"ctrl", "alt"}
local meh = {"ctrl", "alt", "shift"}
local hyper = {"ctrl", "alt", "cmd", "shift"}

-- Typing ----------------------------------------------------------------------

-- Type arrows
hs.hotkey.bind(
  meh, ",", function() pasteit("->") end
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
local passMap = {}
hs.fnutils.each(
  hs.settings.get("HSSecrets"), -- Set manually in settings manager
  function(item)
    passMap[{{"shift"}, item.key, item.title}] = function() typeit(item.text) end
  end
)
hs.hotkey.bind(meh, "p", spoon.RecursiveBinder.recursiveBind(passMap))

-- Window management -----------------------------------------------------------

-- local ray = require "raycast"

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

hs.hotkey.bind(
  hyper, "\\",
  function()
    hs.urlevent.openURL("warp://action/new_window?path=.")
  end
)

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
    -- {title = "Restart Yabai", fn = function()
    --   exec("yabai --restart-service", true)
    --   notify("Yabai config loaded")
    -- end},
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

function typeit(text)
  hs.eventtap.keyStrokes(text)
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
