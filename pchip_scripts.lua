-- HELP FROM: https://pavelmakhov.com/2016/01/how-to-create-widget

local awful = require("awful")

-- FROM: https://github.com/jcmuller/my-awesome-wm-config/blob/master/rc.lua
function run_once(cmd)
  if not cmd then
    do return nil end
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. cmd .. " || (" .. cmd .. ")")
end

function battery_percentage()
  -- THIS IS DEPENDENT UPON MODS TO /usr/bin/battery.sh
  local fh = io.open("/tmp/battery", "r")
  if fh == nil then
    percent = "NB"
  else
    percent = fh:read()
    fh:close()
  end
  
  local fh = io.open("/tmp/charging", "r")
  if fh == nil then
    icon = ""
  else
    local tmp = fh:read()
    if tmp == "0" then
      icon = ""
    else
      icon = "⚡"
    end
    fh:close()
  end
  return " " .. icon .. percent .. " "
end

function get_brightness()
  -- GET CURRENT BRIGHTNESS
  local fh = io.open("/sys/class/backlight/backlight/actual_brightness", "r")
  if fh == nil then
    brightlevel = " 8"
  else
    local tmp = tonumber(fh:read())
    if tmp < 10 then
      brightlevel = " "..tmp
    else
      brightlevel = tmp
    end
    fh:close()
  end
  return brightlevel
end

function change_brightness(chg, val)
--
  local level = 0
  if chg == "dec" then
    level = val - 1
  else
    level = val + 1
  end
  if level < 1 then
    level = 1
  elseif level > 10 then
    level = 10
  else
    level = level
  end
  local cmd = "echo "..level.." > /sys/class/backlight/backlight/brightness"
  awful.util.spawn_with_shell(cmd)
  return get_brightness()
end


