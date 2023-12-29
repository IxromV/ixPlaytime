ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


GetTime = function() 
	local date = os.date('*t')
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local adjustedHour = (date.hour) % 24 
    local timeString = string.format("%04d-%02d-%02d %02d:%02d:%02d",
        date.year, date.month, date.day, adjustedHour, date.min, date.sec)
    local convertedTime = os.time(os.date("*t", os.time{year=date.year, month=date.month, day=date.day, hour=adjustedHour, min=date.min, sec=date.sec}))
    return(convertedTime)
end

function formatPlaytime(totalSeconds)
    local days = math.floor(totalSeconds / (24 * 60 * 60))
    local hours = math.floor((totalSeconds % (24 * 60 * 60)) / (60 * 60))
    local minutes = math.floor((totalSeconds % (60 * 60)) / 60)
    local seconds = totalSeconds % 60
  
    local result = ""
    if days > 0 then
        result = result .. days .." jour"
        if days > 1 then
            result = result .."s"
        end
        result = result .." "
    end
    if hours > 0 then
        result = result .. hours .." heure"
        if hours > 1 then
            result = result .."s"
        end
        result = result .. " "
    end
    if minutes > 0 then
        result = result .. minutes .. " minute"
        if minutes > 1 then
            result = result .. "s"
        end
        result = result .. " "
    end
    if seconds > 0 or result == "" then
        result = result .. seconds .. " seconde"
        if seconds > 1 then
            result = result .. "s"
        end
    end
    return result
end