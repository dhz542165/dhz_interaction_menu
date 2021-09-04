----------------------BY DHZ----------------------
---------------discord.gg/ZKJcrDddYx--------------
----------------------BY DHZ----------------------
local ESX = nil
Player = {
	isDead = false,
	inAnim = false,
	crouched = false,
	handsup = false,
	pointing = false,
	noclip = false,
	godmode = false,
	ghostmode = false,
	showCoords = false,
	showName = false,
	gamerTags = {},
	group = 'user'
}

local PersonalMenu = {
    ItemSelected = {},
    ItemSelected2 = {},
    Warns = {},
    BillData = {},
    WeaponData = {}
}
local plyPed = PlayerPedId()
societymoney = nil
societymoney2 = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1000)
	end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

    RefreshMoney()

    RefreshMoney2()

    PersonalMenu.WeaponData = ESX.GetWeaponList()

	for i = 1, #PersonalMenu.WeaponData, 1 do
		if PersonalMenu.WeaponData[i].name == 'WEAPON_UNARMED' then
			PersonalMenu.WeaponData[i] = nil
		else
			PersonalMenu.WeaponData[i].hash = GetHashKey(PersonalMenu.WeaponData[i].name)
		end
    end
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			societymoney2 = ESX.Math.GroupDigits(money)
		end, ESX.PlayerData.job2.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		societymoney = ESX.Math.GroupDigits(money)
	end

	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		societymoney2 = ESX.Math.GroupDigits(money)
	end
end)

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnim('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				ClearPedTasks(PlayerPedId())

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
            elseif value == 'pants' then
                startAnim('re@construction', 'out_of_breath')
                Citizen.Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 55, ['pants_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
            elseif value == 'shoes' then
                startAnim('random@domestic', 'pickup_low')
                Citizen.Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 49, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
            elseif value == 'bag' then
                startAnim('clothingtie', 'try_tie_neutral_a')
                Citizen.Wait(1000)
				ClearPedTasks(PlayerPedId())
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnim('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				
				ClearPedTasks(PlayerPedId())

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function setAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = (accessory):lower()

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
					startAnim('mini@ears_defenders', 'takeoff_earsdefenders_idle')
					Citizen.Wait(250)
					
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'glasses' then
					mAccessory = 5
					startAnim('clothingspecs', 'try_glasses_positive_a')
					Citizen.Wait(1000)
					
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'helmet' then
					startAnim('missfbi4', 'takeoff_mask')
					Citizen.Wait(1000)
					
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'mask' then
					mAccessory = 0
					startAnim('missfbi4', 'takeoff_mask')
					Citizen.Wait(850)
					
					ClearPedTasks(PlayerPedId())
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			if _accessory == 'ears' then
                ESX.ShowNotification('Vous n\'avez pas de boucles d\'oreilles')
			elseif _accessory == 'glasses' then
                ESX.ShowNotification('Vous n\'avez pas de lunettes')
			elseif _accessory == 'helmet' then
                ESX.ShowNotification('Vous n\'avez pas de chapeau')
			elseif _accessory == 'mask' then
                ESX.ShowNotification('Vous n\'avez pas de masque')
			end
		end
	end, accessory)
end



local BaseMenu = ContextUI:CreateMenu(1, "Intéraction") 

local Personnage = ContextUI:CreateSubMenu(BaseMenu, "Mon personnage")
local vetements = ContextUI:CreateSubMenu(Personnage, "Vêtements")
local accessoires = ContextUI:CreateSubMenu(Personnage, "Accessoires")

local divers = ContextUI:CreateSubMenu(BaseMenu, "Divers")
local visuel = ContextUI:CreateSubMenu(divers, "Visuel")
local touches = ContextUI:CreateSubMenu(divers, "Touches")
local hud = ContextUI:CreateSubMenu(divers, "Option HUD")

local inventaire = ContextUI:CreateSubMenu(BaseMenu, "Sac à dos")
local items = ContextUI:CreateSubMenu(inventaire, "Objets")
local itemsuse = ContextUI:CreateSubMenu(items, "Objets")
local armes = ContextUI:CreateSubMenu(inventaire, "Armes")
local armesuse = ContextUI:CreateSubMenu(armes, "Armes")

local portefeuille = ContextUI:CreateSubMenu(BaseMenu, "Portefeuille")
local papiers = ContextUI:CreateSubMenu(portefeuille, "Papiers")
local factures = ContextUI:CreateSubMenu(portefeuille, "Factures")
local liquides = ContextUI:CreateSubMenu(portefeuille, "Liquide")
local emplois1 = ContextUI:CreateSubMenu(portefeuille, "Emplois principale")
local emplois2 = ContextUI:CreateSubMenu(portefeuille, "Emplois secondaire")

ContextUI:IsVisible(BaseMenu, function(Entity)
    if Entity.Model == `mp_m_freemode_01` then 
        ContextUI:Button("~g~Inventaire", nil, function(Selected)
            if (Selected) then
            end
        end, inventaire)
        ContextUI:Button("~b~Portefeuille", nil, function(Selected)
            if (Selected) then
            end
        end, portefeuille)
        ContextUI:Button("~r~Mon personnage", nil, function(Selected)
            if (Selected) then
            end
        end,Personnage)
        ContextUI:Button("~b~Divers", nil, function(Selected)
            if (Selected) then
            end
        end,divers)
    end
end)

ContextUI:IsVisible(Personnage, function(Entity)
    ContextUI:Button("Vêtements", nil, function(Selected)
        if (Selected) then
        end
    end,vetements)

    ContextUI:Button("Accessoires", nil, function(Selected)
        if (Selected) then
        end
    end,accessoires)
end)

ContextUI:IsVisible(vetements, function(Entity)
    ContextUI:Button("T-Shirt", nil, function(Selected)
        if (Selected) then
            setUniform('torso', plyPed)
        end
    end)
    ContextUI:Button("Pantalons", nil, function(Selected)
        if (Selected) then
            setUniform('pants', plyPed)
        end
    end)
    ContextUI:Button("Chaussures", nil, function(Selected)
        if (Selected) then
            setUniform('shoes', plyPed)
        end
    end)
    ContextUI:Button("Sac", nil, function(Selected)
        if (Selected) then
            setUniform('bag', plyPed)
        end
    end)
    ContextUI:Button("Kevlar", nil, function(Selected)
        if (Selected) then
            setUniform('bproof', plyPed)
        end
    end)
end)

ContextUI:IsVisible(accessoires, function(Entity)
    ContextUI:Button("Oreilles", nil, function(Selected)
        if (Selected) then
            setAccessory('Ears', plyPed)
        end
    end)
    ContextUI:Button("Lunettes", nil, function(Selected)
        if (Selected) then
            setAccessory('Glasses', plyPed)
        end
    end)
    ContextUI:Button("Chapeau", nil, function(Selected)
        if (Selected) then
            setAccessory('Helmet', plyPed)
        end
    end)
    ContextUI:Button("Masque", nil, function(Selected)
        if (Selected) then
            setAccessory('Mask', plyPed)
        end
    end)
end)

local ragdolling = false
ContextUI:IsVisible(divers, function(Entity)
    ContextUI:Button("Dormir/se réveiller", nil, function(Selected)
        if (Selected) then
            ragdolling = not ragdolling
            while ragdolling do
                Wait(0)
                local myPed = PlayerPedId()
                SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                ResetPedRagdollTimer(myPed)
                AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                ResetPedRagdollTimer(myPed)
                if IsControlJustPressed(0, 22) then 
                    break
                end
            end
        end
    end)

    ContextUI:Button("Visuel", nil, function(Selected)
        if (Selected) then
        end
    end,visuel)

    if Config.UtiliserTouches then
        ContextUI:Button("Touches", nil, function(Selected)
            if (Selected) then
            end
        end,touches)
    end

    ContextUI:Button("Options HUD", nil, function(Selected)
        if (Selected) then
        end
    end,hud)
end)

ContextUI:IsVisible(visuel, function(Entity)
    ContextUI:Button("Retirer le filtre", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('')
        end
    end)
    ContextUI:Button("Vue & lumières améliorées", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('tunnel')
        end
    end)
    ContextUI:Button("Vue & lumières améliorées 2", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('CS3_rail_tunnel')
        end
    end)
    ContextUI:Button("Vue & lumières améliorées 3", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('MP_lowgarage')
        end
    end)
    ContextUI:Button("Vue lumineux", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('rply_vignette_neg')
        end
    end)
    ContextUI:Button("Vue lumineux 2", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('rply_saturation_neg')
        end
    end)
    ContextUI:Button("Couleurs amplifiées", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('rply_saturation')
        end
    end)
    ContextUI:Button("Visual 1", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('yell_tunnel_nodirect')
        end
    end)
    ContextUI:Button("Blanc", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('rply_contrast_neg')
        end
    end)
    ContextUI:Button("Dégats", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('rply_vignette')
        end
    end)
    ContextUI:Button("Bouré", nil, function(Selected)
        if (Selected) then
            SetTimecycleModifier('stoned')
        end
    end)
end)

ContextUI:IsVisible(hud, function(Entity)
    ContextUI:Button("~r~Cacher~s~ la map", nil, function(Selected)
        if (Selected) then
            DisplayRadar(false)
        end
    end)
    ContextUI:Button("~g~Afficher~s~ la map", nil, function(Selected)
        if (Selected) then
            DisplayRadar(true)
        end
    end)

    if Config.RetraitHud then
        ContextUI:Button("Cacher/Afficher l'hud", nil, function(Selected)
            if (Selected) then
                if Config.UtiliserCommandePourRetirerHud then
                    ExecuteCommand(Config.CommandeRetirerHud)
                else
                    TriggerClientEvent(Config.Triggerpourretirerafficherhud)    
                end
            end    
        end)
    end    
end)

ContextUI:IsVisible(touches, function(Entity)
    if Config.UtiliserTouches then
        for _, v in pairs (Config.Touches) do
            ContextUI:Button(v.Nom, v.Touche, function(Selected)
                if (Selected) then
                end
            end)
        end 
    end       
end)

ContextUI:IsVisible(inventaire, function(Entity)
    ContextUI:Button("Items", nil, function(Selected)
        if (Selected) then
        end
    end, items)
    ContextUI:Button("Armes", nil, function(Selected)
        if (Selected) then
        end
    end, armes)
end)

ContextUI:IsVisible(armes, function(Entity)
    ESX.PlayerData = ESX.GetPlayerData()
    for i = 1, #PersonalMenu.WeaponData, 1 do
        if HasPedGotWeapon(PlayerPedId(), PersonalMenu.WeaponData[i].hash, false) then
            local ammo = GetAmmoInPedWeapon(PlayerPedId(), PersonalMenu.WeaponData[i].hash)
            ContextUI:Button(PersonalMenu.WeaponData[i].label .. ' [' .. ammo .. ']', nil, function(Selected)
                if (Selected) then
                    PersonalMenu.ItemSelected = PersonalMenu.WeaponData[i]
                end
            end,armesuse)
        end
    end
end)

ContextUI:IsVisible(armesuse, function(Entity)
    ContextUI:Button("Donner des munitions", nil, function(Selected)
        if (Selected) then
            local post, quantity = CheckQuantity(KeyboardInput('Nombre de munitions', '180'), '', 8)
            if post then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    local pPed = PlayerPedId()
                    local coords = GetEntityCoords(pPed)
                    local x,y,z = table.unpack(coords)
                    DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
                    if IsPedOnFoot(closestPed) then
                        local ammo = GetAmmoInPedWeapon(plyPed, PersonalMenu.ItemSelected.hash)
                        if ammo > 0 then
                            if quantity <= ammo and quantity >= 0 then
                                local finalAmmo = math.floor(ammo - quantity)
                                SetPedAmmo(plyPed, PersonalMenu.ItemSelected.name, finalAmmo)
                                TriggerServerEvent('VMLife:Weapon_addAmmoToPedS', GetPlayerServerId(closestPlayer), PersonalMenu.ItemSelected.name, quantity)
                                ESX.ShowNotification('Vous avez donné x '..quantity..' munitions à '..GetPlayerName(closestPlayer))
                            else
                                ESX.ShowNotification('Vous n\'avez pas assez de munitions')
                            end
                        else
                            ESX.ShowNotification("Vous n'avez pas de munitions")

                        end
                    else
                        ESX.ShowNotification('Vous ne pouvez pas donner des munitions dans un véhicule')
                    end
                else
                    ESX.ShowNotification("Aucun joueur proche")
                end
            else
                ESX.ShowNotification('Nombre de munitions invalide')
            end
        end
    end)
    ContextUI:Button("Jeter l'arme", nil, function(Selected)
        if (Selected) then
            if IsPedOnFoot(PlayerPedId()) then
                TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', PersonalMenu.ItemSelected.name)
            else
                ESX.ShowNotification('~r~Impossible~s~ de jeter l\'arme dans un véhicule')
            end
        end
    end)
end)

ContextUI:IsVisible(items, function(Entity)
    ESX.PlayerData = ESX.GetPlayerData()
    for i = 1, #ESX.PlayerData.inventory do
        if ESX.PlayerData.inventory[i].count > 0 then
            ContextUI:Button('[~r~' ..ESX.PlayerData.inventory[i].count.. '~s~] ~b~- ~s~' ..ESX.PlayerData.inventory[i].label, nil, function(Selected)
                if (Selected) then 
                    PersonalMenu.ItemSelected = ESX.PlayerData.inventory[i]
                end 
            end,itemsuse)
        end
    end
end)

ContextUI:IsVisible(itemsuse, function(Entity)
    ContextUI:Button("Utiliser", nil, function(Selected)
        if (Selected) then
            if PersonalMenu.ItemSelected.usable then
                TriggerServerEvent('esx:useItem', PersonalMenu.ItemSelected.name)
            else
                ESX.ShowNotification('Ceci n\'est ~r~pas~s~ utilisable')
            end
        end
    end)

    ContextUI:Button("Donner", nil, function(Selected)
        if (Selected) then
            local sonner,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez donner", '', '', 100))
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            local pPed = PlayerPedId()
            local coords = GetEntityCoords(pPed)
            local x,y,z = table.unpack(coords)
            DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
            if sonner then
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    if IsPedOnFoot(closestPed) then
                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', PersonalMenu.ItemSelected.name, quantity)
                    else
                        ESX.ShowNotification("Nombre d'items invalide")
                    end
                else
                    ESX.ShowNotification("Aucun joueur proche")
                end
            end
        end
    end)

    ContextUI:Button("Jeter", nil, function(Selected)
        if (Selected) then
            if PersonalMenu.ItemSelected.canRemove then
                local post,quantity = CheckQuantity(KeyboardInput("Nombres d'items que vous voulez jeter", '', '', 100))
                if post then
                    if not IsPedSittingInAnyVehicle(PlayerPed) then
                        TriggerServerEvent('esx:removeInventoryItem', 'item_standard', PersonalMenu.ItemSelected.name, quantity)
                    end
                end
            end
        end
    end)
end)

ContextUI:IsVisible(portefeuille, function(Entity)
    ContextUI:Button("Emplois", "~b~"..ESX.PlayerData.job.label.."~s~", function(Selected)
        if (Selected) then
        end
    end, emplois1)
    if Config.DoubleJob then
        ContextUI:Button("Emplois secondaire", "~r~"..ESX.PlayerData.job2.label.."~s~", function(Selected)
            if (Selected) then
            end
        end, emplois2)
    end    
    ContextUI:Button("Liquide", "~g~$"..ESX.Math.GroupDigits(ESX.PlayerData.money.."~s~"), function(Selected)
        if (Selected) then
            
        end
    end, liquides)
    ContextUI:Button("Factures", nil, function(Selected)
        if (Selected) then
        end
    end,factures)
    ContextUI:Button("Papiers", nil, function(Selected)
        if (Selected) then
        end
    end,papiers)
end)

ContextUI:IsVisible(emplois1, function(Entity)
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        if societymoney ~= nil then
            ContextUI:Button("Fond de l'entreprise", "[~g~"..societymoney.."$~s~]", function(Selected)
                if (Selected) then
                end
            end)
        end    
    end 

    ContextUI:Button("Grade", "~b~"..ESX.PlayerData.job.grade_label .."~s~", function(Selected)
        if (Selected) then
        end
    end)

    ContextUI:Button("Démisionner", nil, function(Selected)
        if (Selected) then
            TriggerServerEvent("dhzcontextui:demission1")
        end
    end) 
end)

ContextUI:IsVisible(emplois2, function(Entity)
    if Config.DoubleJob then
        if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
            if societymoney2 ~= nil then
                ContextUI:Button("Fond de l'entreprise", "[~r~"..societymoney2.."$~s~]", function(Selected)
                    if (Selected) then
                    end
                end)
            end    
        end 

        ContextUI:Button("Grade", "~b~"..ESX.PlayerData.job2.grade_label .."~s~", function(Selected)
            if (Selected) then
            end
        end)
    end    
end)

ContextUI:IsVisible(liquides, function(Entity)
    ContextUI:Button("~y~Donner~s~ de l'argent liquide", "~g~$"..ESX.Math.GroupDigits(ESX.PlayerData.money.."~s~"), function(Selected)
        if (Selected) then
            local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez donner", '', '', 1000))
            if black then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    if not IsPedSittingInAnyVehicle(closestPed) then
                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', ESX.PlayerData.money, quantity)
                    else
                        ESX.ShowNotification('Vous ne pouvez ~r~pas~s~ jetter de l\'argent dans un véhicule')
                    end
                else
                    ESX.ShowNotification('~r~Aucun~s~ joueur proche de vous !')
                end
            else
                ESX.ShowNotification('Somme ~r~invalide')
            end
        end
    end)

    ContextUI:Button("~r~Jeter~s~ de l'argent liquide", "~g~$"..ESX.Math.GroupDigits(ESX.PlayerData.money.."~s~"), function(Selected)
        if (Selected) then
            local black, quantity = CheckQuantity(KeyboardInput("Somme d'argent que vous voulez jeter", '', '', 1000))
            if black then
                if not IsPedSittingInAnyVehicle(PlayerPed) then
                    TriggerServerEvent('esx:removeInventoryItem', 'item_money', ESX.PlayerData.money, quantity)
                else
                    ESX.ShowNotification('Vous ne pouvez ~r~pas~s~ jetter de l\'argent dans un véhicule')
                end
            else
                ESX.ShowNotification('Somme ~r~invalide')
            end
        end
    end)
end)

ContextUI:IsVisible(factures, function(Entity)
    for i = 1, #PersonalMenu.BillData, 1 do
        ContextUI:Button(PersonalMenu.BillData[i].label, '[~y~$' .. ESX.Math.GroupDigits(PersonalMenu.BillData[i].amount.."~s~]"), function(Selected)
            if (Selected) then
                ESX.TriggerServerCallback('esx_billing:payBill', function()
                    ESX.TriggerServerCallback('dhz_personalmenu:Bill_getBills', function(bills) PersonalMenu.BillData = bills end)
                end, PersonalMenu.BillData[i].id)
            end
        end)
    end
end)

ContextUI:IsVisible(papiers, function(Entity)
    ContextUI:Button("~r~Montrer~s~ sa carte d'identité", nil, function(Selected)
        if (Selected) then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification("Aucun joueur à proximité")
            end
        end
    end)
    ContextUI:Button("~g~Regarder~s~ sa carte d'identité", nil, function(Selected)
        if (Selected) then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        end
    end)
    ContextUI:Button("~r~Montrer~s~ son permis de conduire", nil, function(Selected)
        if (Selected) then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
            else
                ESX.ShowNotification("Aucun joueur à proximité")
            end
        end
    end)
    ContextUI:Button("~g~Regarder~s~ son permis de conduire", nil, function(Selected)
        if (Selected) then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        end
    end)

    ContextUI:Button("~r~Montrer~s~ son permis d'armes", nil, function(Selected)
        if (Selected) then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification("Aucun joueur à proximité")
            end
        end
    end)
    ContextUI:Button("~g~Regarder~s~ son permis d'armes", nil, function(Selected)
        if (Selected) then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
        end
    end)
end)

Keys.Register("LMENU", "LMENU", "BaseMenu", function()
    ESX.TriggerServerCallback('dhz_personalmenu:Bill_getBills', function(bills)
        PersonalMenu.BillData = bills	
        ESX.PlayerData = ESX.GetPlayerData()
        ContextUI.Focus = not ContextUI.Focus;
    end)
end)
