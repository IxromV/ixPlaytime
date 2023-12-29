ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

Time_System = {
  players_time = {},
  connected_players = {},
  original_list = {}
}

local itemIndex = 1

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

local open = false
local mainMenu = RageUI.CreateMenu("Playtime", "Interaction")
local subMenu1 = RageUI.CreateSubMenu(mainMenu, "Playtime", "Interaction")
local subMenu2 = RageUI.CreateSubMenu(mainMenu, "Playtime", "Interaction")
mainMenu.Closed = function()
    open = false
end


local function OpenMenu()
	if open then
		open = false
		return
	else
		RageUI.Visible(mainMenu, true)
		open = true
		Citizen.CreateThread(function()
			while open do
				RageUI.IsVisible(mainMenu, function()

          RageUI.Button("Temps de jeu", nil, {RightLabel = "→→"}, true, {
            onSelected = function()
              itemIndex = 1
              ESX.TriggerServerCallback("ixPlaytime:get_players_time", function(result)
                Time_System.players_time = result
              for i, player in pairs(result) do
                Time_System.original_list[i] = player
              end
              end)
            end
          }, subMenu1)

          RageUI.Button("Connecté(s)", nil, {RightLabel = "→→"}, true, {
            onSelected = function()
              ESX.TriggerServerCallback("ixPlaytime:get_connected_players", function(result)
                Time_System.connected_players = result
              end)
            end
          }, subMenu2)
				end)

        RageUI.IsVisible(subMenu1, function()

          RageUI.List("Ordre :", {"Aucun", "Croissant", "Décroissant", "Alphabétique"}, itemIndex, nil, {}, true, {
            onListChange = function(Index, Items)
              itemIndex = Index
              if itemIndex == 1 then 
                Time_System.players_time = Time_System.original_list
            elseif itemIndex == 2 then 
                table.sort(Time_System.players_time, function(a, b)
                  return a.playtime > b.playtime
              end)
            elseif itemIndex == 3 then 
              table.sort(Time_System.players_time, function(a, b)
                return a.playtime < b.playtime
              end)
            elseif itemIndex == 4 then
              table.sort(Time_System.players_time, function(a, b)
                return a.lastname:lower() < b.lastname:lower() 
            end)
            end
            end,
              onSelected = function()
            end,
        })
        RageUI.Line()
          for i = 1, #Time_System.players_time do 
            local playerData = Time_System.players_time[i]
            RageUI.Button(i.." - "..playerData.lastname.." "..playerData.firstname, "Equivalent : ~b~"..formatPlaytime(playerData.playtime), {RightLabel = ESX.Math.GroupDigits(playerData.playtime).." sec."}, true, {})
          end
        end)

        RageUI.IsVisible(subMenu2, function()
          for i = 1, #Time_System.connected_players do 
            local playerData = Time_System.connected_players[i]
            RageUI.Button(playerData.name, "Connecté depuis : ~b~"..formatPlaytime(playerData.value), {RightLabel = ESX.Math.GroupDigits(playerData.value).." sec."}, true, {})
          end
        end)
				Wait(1)
			end
		end)
	end
end

RegisterCommand(Playtime_Config.menu_command, function()
  ESX.TriggerServerCallback("ixPlaytime:get_group", function(result)
    for k, v in pairs(Playtime_Config.groups) do 
        if result == v then
          OpenMenu()
        end
    end
  end)
end)


