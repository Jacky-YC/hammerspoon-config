local urlApi = 'https://www.yiketianqi.com/free/day?appid=32961884&appsecret=cGYBB9W1&unescape=1&cityid=101020100'
local menubar = hs.menubar.new()
local menuData = {}

local weaEmoji = {
   lei = '⛈',
   qing = '☀️',
   shachen = '😷',
   wu = '🌫',
   xue = '❄️',
   yu = '🌧',
   yujiaxue = '🌨',
   yun = '☁️',
   zhenyu = '🌧',
   yin = '⛅️',
   default = ''
}

function updateMenubar()
	 menubar:setTooltip("Weather Info")
    menubar:setMenu(menuData)
end

function getWeather()
   hs.http.doAsyncRequest(urlApi, "GET", nil,nil, function(code, body, htable)
      if code ~= 200 then
         print('get weather error:'..code)
         return
      end
      wi = hs.json.decode(body)
      menuData = {}
      weaEmo = weaEmoji[wi.wea_img]
      if wi ~= "nil" then 
         menubar:setTitle(weaEmoji[wi.wea_img])
         titlestr = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", wi.date,wi.city,weaEmo, wi.tem, wi.humidity, wi.air, wi.win_speed, wi.wea)
         item = { title = titlestr }
         table.insert(menuData, item)
         table.insert(menuData, {title = '-'})
      end
      updateMenubar()
   end)
end

menubar:setTitle('⌛')
getWeather()
updateMenubar()
hs.timer.doEvery(3600, getWeather)
