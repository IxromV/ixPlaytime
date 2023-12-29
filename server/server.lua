ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
    MySQL.Async.fetchAll("SELECT * FROM playtime", {}, function(data)
            if data[1] ~= nil then
                for _, playerData in pairs(data) do
                    local xPlayer = ESX.GetPlayerFromIdentifier(playerData.identifier)
                    local identifier = playerData.identifier
                    playing_time = GetTime() - playerData.value
                    MySQL.Async.fetchAll("SELECT playtime FROM users WHERE identifier = @a", {
                        ["a"] = identifier
                    }, function(data_2)
                        local updatedPlaytime = data_2[1].playtime + playing_time
                        MySQL.Async.execute("UPDATE users SET playtime = @a WHERE identifier = @b", {
                            ["a"] = updatedPlaytime,
                            ["b"] = identifier
                        })
                        MySQL.Async.execute("DELETE FROM playtime WHERE identifier = @a", {
                            ["a"] = identifier
                        })
                        if Playtime_Config.print_ then
                        print("Ajout de "..formatPlaytime(playing_time).." pour le joueur "..xPlayer.name)
                        end
                    end)
                end
            end
    end) 
    Wait(2000)
    local connectedPlayers = ESX.GetPlayers()
        for i=1, #connectedPlayers, 1 do
            local src = connectedPlayers[i]
            local xPlayer = ESX.GetPlayerFromId(src)
            if xPlayer then
                local identifier = xPlayer.getIdentifier()
                MySQL.Async.execute("INSERT INTO playtime (identifier, value) VALUES (@a,@b)", {
                    ["@a"] = identifier,
                    ["@b"] = GetTime()
                })
            end
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
    MySQL.Async.fetchAll("SELECT * FROM playtime WHERE identifier = @a", {
        ["a"] = xPlayer.identifier
    }, function(data)
        if data[1] == nil then 
            MySQL.Async.execute("INSERT INTO playtime (identifier, value) VALUES (@a,@b)", {
                ["@a"] = xPlayer.identifier,
                ["@b"] = GetTime()
            })
        else
            MySQL.Async.execute("DELETE FROM playtime WHERE identifier = @a", {
                ["@a"] = xPlayer.identifier
            })
            Wait(50)
            MySQL.Async.execute("INSERT INTO playtime (identifier, value) VALUES (@a,@b)", {
                ["@a"] = xPlayer.identifier,
                ["@b"] = GetTime()
            })
        end
    end) 
end)

AddEventHandler('playerDropped', function(reason)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local playing_time = 0
    MySQL.Async.fetchAll("SELECT value FROM playtime WHERE identifier = @a", {
        ["@a"] = xPlayer.identifier
    }, function(data)
        if data[1] ~= nil then
            playing_time = GetTime() - data[1].value
            MySQL.Async.fetchAll("SELECT playtime FROM users WHERE identifier = @a", {
                ["a"] = xPlayer.identifier
            }, function(data_2)
                MySQL.Async.execute("UPDATE users SET playtime = @a WHERE identifier = @b", {
                    ["a"] = data_2[1].playtime + playing_time,
                    ["b"] = xPlayer.identifier
                })
                MySQL.Async.execute("DELETE FROM playtime WHERE identifier = @a", {
                    ["a"] = xPlayer.identifier
                })
            end)
            if Playtime_Config.print_ then
            print("Déconnexion de "..xPlayer.name.." || Temps de jeu "..formatPlaytime(playing_time))
            end
            local embed = {{ ["author"] = { ["name"] = Playtime_Config.Webhook.title, ["icon_url"] = Playtime_Config.Webhook.img }, ["color"] = Playtime_Config.Webhook.color, ["title"] = "Déconnexion "..xPlayer.name, ["description"] = "ID : "..src.."\rTemps de jeu : "..playing_time.." secondes\rEquivalent : "..formatPlaytime(playing_time).."\rRaison : "..reason, ["footer"] = { ["text"] = os.date("%d/%m/%Y - %H:%M:%S", GetTime()), ["icon_url"] = nil }, } } 
            PerformHttpRequest(Playtime_Config.Webhook.channel, function(err, text, headers) end, 'POST', json.encode({username = Playtime_Config.Webhook.name, embeds = embed, avatar_url = Playtime_Config.Webhook.img }), { ['Content-Type'] = 'application/json' })
        end
    end)
end)

ESX.RegisterServerCallback("ixPlaytime:get_players_time", function(source, cb)
    local result = {}
    MySQL.Async.fetchAll("SELECT * FROM users", {}, function(data)
        for _,v in pairs(data) do 
            table.insert(result, {identifier = v.identifier, firstname = v.firstname, lastname = v.lastname, playtime = v.playtime})
        end
        MySQL.Async.fetchAll("SELECT * FROM playtime", {}, function(data_2)
        for _,v in pairs(data_2) do 
            for _, player in pairs(result) do 
                if v.identifier == player.identifier then 
                    player.playtime = player.playtime + (GetTime() - v.value)
                end
            end
        end
        cb(result)
    end)
        
    end)
end)

ESX.RegisterServerCallback("ixPlaytime:get_connected_players", function(source, cb)
    local result = {}
    MySQL.Async.fetchAll("SELECT * FROM playtime", {}, function(data)
        for _, playerData in pairs(data) do
            local player = ESX.GetPlayerFromIdentifier(playerData.identifier)
            if player then
                local playerName = player.getName()
                local playtimeValue = (GetTime() - playerData.value)
                table.insert(result, {
                    name = playerName,
                    identifier = playerData.identifier,
                    value = playtimeValue
                })
            end
        end
        cb(result)
    end)
end)

ESX.RegisterServerCallback("ixPlaytime:get_group", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        cb(xPlayer.group)
    else
        cb(nil)
    end
end)

RegisterCommand(Playtime_Config.servertime_command, function(source)
    if source == 0 then
    local totalPlaytime = 0
        MySQL.Async.fetchAll('SELECT playtime FROM users', {}, function(result)
            for _, data in pairs(result) do
                totalPlaytime = totalPlaytime + data.playtime
            end
            print("――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――")
            print("Ton serveur comptabilise un temps de jeu total de : "..formatPlaytime(totalPlaytime))
            print("――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――")
        end)
    end
end)


