----------------------BY DHZ----------------------
---------------discord.gg/ZKJcrDddYx--------------
----------------------BY DHZ----------------------
local ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1000)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

function CheckQuantity(number)
    number = tonumber(number)
    if type(number) == 'number' then
        number = ESX.Math.Round(number)
        if number > 0 then
            return true, number
        end
    end
    return false, number
end
  
function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end
  
RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
    ESX.PlayerData.money = money
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)
  
RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
            break
        end
    end
end)
