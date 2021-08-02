----------------------BY DHZ----------------------
---------------discord.gg/ZKJcrDddYx--------------
----------------------BY DHZ----------------------
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('dhz_personalmenu:Bill_getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}
	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end
		cb(bills)
	end)
end)

RegisterServerEvent('dhzcontextui:demission1')
AddEventHandler('dhzcontextui:demission1', function(job, grade)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob("unemployed", 0)	
end)

