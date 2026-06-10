-- Raycast window handling stuff -----------------------------------------------

local function raywin(command)
  hs.http.get(string.format("raycast://extensions/raycast/window-management/%s", command))
end

hs.hotkey.bind({"ctrl", "alt"}, "j", function() raywin("left-half") end)
print("akk")
return true