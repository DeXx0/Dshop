ESX = nil
legalmenuOpen = false

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        for i = 1, #v.LegalPos, 1 do
            local blip = AddBlipForCoord(v.LegalPos[i].x, v.LegalPos[i].y, v.LegalPos[i].z)

            SetBlipSprite (blip, 52)
            SetBlipScale  (blip, 0.5)
            SetBlipColour (blip, 2)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('24/7')
            EndTextCommandSetBlipName(blip)
         end
     end
end)

local superet = {
    Base = { Header = {"shopui_title_conveniencestore", "shopui_title_conveniencestore"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Superette", Blocked = false },
	Data = { currentMenu = "ARTICLES DISPONIBLES", "Superette" },
    Events = {

        onSelected = function(self, _, btn, CMenu, menuData, currentButton, currentSlt, result)
            if btn.name == ">  Hamburger" then
                TriggerServerEvent('dexx_menu:buy', 10, "hamburger", "Hamburger")
          elseif btn.name == ">  Coca Cola" then
                TriggerServerEvent('dexx_menu:buy', 7, "cocacola", "Coca-cola")
          elseif btn.name == ">  Sandwich" then
                TriggerServerEvent('dexx_menu:buy', 5, "sandwich", "Sandwich")
          elseif btn.name == ">  Ice-Tea" then
                TriggerServerEvent('dexx_menu:buy', 7, "icetea", "Ice-tea")
          elseif btn.name == ">  Eau de source" then
                TriggerServerEvent('dexx_menu:buy', 3, "water", "Eau de source")
              end
        end,
    },

    Menu = {
        ["ARTICLES DISPONIBLES"] = {
            b = {
                {name = ">  Hamburger", ask = "~g~10$", askX = true},
                {name = ">  Eau de source", ask = "~g~3$", askX = true},
                {name = ">  Coca Cola", ask = "~g~7$", askX = true},
                {name = ">  Sandwich", ask = "~g~5$", askX = true},
                {name = ">  Ice-Tea", ask = "~g~7$", askX = true},
            }
        },
    }
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

function dexxSaveSkin()
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)
	TriggerEvent('skinchanger:getSkin', function(skin)
	TriggerServerEvent('esx_skin:save', skin)
	end)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(Config.Zones) do
            
            for i = 1, #v.LegalPos, 1 do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.LegalPos[i].x, v.LegalPos[i].y, v.LegalPos[i].z, true)
                if distance < 2.2 then
                    alert('Appuyez sur ~INPUT_CONTEXT~ pour discuter avec ~g~le vendeur~w~.')
                    if IsControlJustPressed(1,51) then  
                        CreateMenu(superet)
                    end
                end
            end
        end
    end
end)