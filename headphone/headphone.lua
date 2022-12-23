
-- SONY MDR-1000X
local bleDeviceID = 'd4-4b-b6-7d-95-fe'


function bluetoothSwitch(state)
  -- state: 0(off), 1(on)
  cmd = "/usr/local/bin/blueutil --power "..(state)
  print(cmd)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function disconnectBluetooth()
  cmd = "/usr/local/bin/blueutil --disconnect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

local function connectBluetooth(retry)
  cmd = "/usr/local/bin/blueutil --connect "..(bleDeviceID)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
  if result then 
    print("connect bluetooth success. ")
    speaker = hs.speech.new()
    speaker:speak("方糖已连接!")
  else 
    if retry >= 3 then 
      print("Reconnect bluetooth more than max times.")
      return
    end
    print("reconnect bluethooth in 3 seconds!")
    os.execute("sleep " .. 3)
    connectBluetooth(retry+1)
  end
end

function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
      print("screensDidSleep")
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
      print("screensDidWake")
    elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
      print("screensDidLock")
      disconnectBluetooth()
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
      print("screensDidUnlock")
      connectBluetooth(0)
    end
end

connectBluetooth(0)
caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
