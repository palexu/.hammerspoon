
--- 一个闭包函数
function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

--- 快速打开Finder，微信，Chrome等等
hs.hotkey.bind({"alt"}, "E", open("Finder"))
hs.hotkey.bind({"alt"}, "W", open("WeChat"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "T", open("iTerm"))
hs.hotkey.bind({"alt"}, "S", open("Sublime Text"))
hs.hotkey.bind({"alt"}, "I", open("IntelliJ IDEA"))
hs.hotkey.bind({"alt"}, "M", open("NeteaseMusic"))

--- 切换wifi

local workWifi = 'shuli-wifi'
local outputDeviceName = 'Built-in Output'

local workUid = "A18D1BFD-4CD6-4A64-9677-EEAE623F1839"
local homeUid = "7500A4F7-72BD-4ABB-9D31-3934BBE13F39"

function ssidChangedCallback() -- 回调
    ssid = hs.wifi.currentNetwork() -- 获取当前 WiFi ssid
    local currentOutput = hs.audiodevice.current(false)
    if (ssid ~= nil) then
        if (ssid == workWifi) then
            uid = workUid -- 公司的位置 uid，后面会讲
            hs.notify.new({title="位置", informativeText="位置切换到公司"}):send() -- 发出通知
            if (currentOutput.name == outputDeviceName) then
                hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(true)
                hs.notify.new({title="声音", informativeText="在公司静音"}):send() -- 发出通知
            end
        else
            uid = homeUid
            hs.notify.new({title="位置", informativeText="位置切换到家里"}):send()
        end
        os.execute("scselect " ..uid .." > /dev/null") -- 切换网络位置
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start() -- 开始监控