ESX = nil
local staffRank = nil
local staffService = false
local colorVar = nil
local selected = nil
local staffActions = {}
local possiblesQty = {}
local items = {}
local qty = 1

local function mug(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end


local function playerMarker(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

local function getItems()
    TriggerServerEvent("pz_admin:getItems")
end

local function alterMenuVisibility()
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main')))
end

local function registerMenus()
    RMenu.Add("pz_admin", "pz_admin_main", RageUI.CreateMenu("Menu d'administration","Rang: "..Pz_admin.ranks[staffRank].color..Pz_admin.ranks[staffRank].label))

    RMenu.Add('pz_admin', 'pz_admin_players', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_main'), "Interactions citoyens", "Interactions avec un citoyen"))
    RMenu:Get('pz_admin', 'pz_admin_players').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_players_interact', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_players'), "Interactions citoyens", "Interagir avec ce joueur"))
    RMenu:Get('pz_admin', 'pz_admin_players_interact').Closed = function()end

    RMenu.Add('pz_admin', 'pz_admin_players_remb', RageUI.CreateSubMenu(RMenu:Get('pz_admin', 'pz_admin_players_interact'), "Interactions citoyens", "Interagir avec ce joueur"))
    RMenu:Get('pz_admin', 'pz_admin_players_remb').Closed = function()end
    


    
end

local function initializeThread(rank,license)

    mug("Administration","~b~Statut du mode staff","Votre mode staff est pour le moment désactiver, vous pouvez l'activer au travers du ~o~[F11]")

    staffRank = rank
    colorVar = "~r~"

    for i = 1,100 do 
        table.insert(possiblesQty, tostring(i))
    end

    getItems()
    registerMenus()

    local actualRankPermissions = {}

    for perm,_ in pairs(Pz_admin.functions) do
        print(perm)
        actualRankPermissions[perm] = false
    end

    for _,perm in pairs(Pz_admin.ranks[staffRank].permissions) do 
        actualRankPermissions[perm] = true
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if IsControlJustPressed(1, 344) then alterMenuVisibility() end
        end
    end)

    Citizen.CreateThread(function()
         while true do 
            Citizen.Wait(800)
            if colorVar == "~r~" then colorVar = "~o~" else colorVar = "~r~" end 
        end 
    end)

    Citizen.CreateThread(function()
        while true do

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_main'),true,true,true,function()
                RageUI.Checkbox("Mode administration", nil, staffService, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    staffService = Checked;
                end, function()
                    staffService = true
                    mug("Administration","~b~Statut du mode staff","Vous êtes désormais: ~g~en administration~s~.")
                end, function()
                    staffService = false
                    mug("Administration","~b~Statut du mode staff","Vous êtes désormais ~r~hors administration~s~.")
                end)

                if staffService then
                    RageUI.Separator(colorVar.."/!\\ Mode administration actif /!\\")
                    RageUI.ButtonWithStyle("Interactions joueurs", "Intéragir avec les joueurs du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_players'))
                    RageUI.ButtonWithStyle("Interactions véhicules", "Intéragir avec les véhicules du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_vehicles'))

                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players'),true,true,true,function()
                for k,v in pairs(GetActivePlayers()) do 

                    RageUI.ButtonWithStyle("["..GetPlayerServerId(v).."] "..GetPlayerName(v), "Intéragir avec ce joueur", { RightLabel = "~b~Intéragir ~s~→→" }, true, function(_,a,s)
                        if a then playerMarker(v) end
                        if s then
                            selected = {c = v, s = GetPlayerServerId(v)}
                        end
                    end, RMenu:Get('pz_admin', 'pz_admin_players_interact'))

                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players_interact'),true,true,true,function()

                for i = 1,#Pz_admin.functions do
                    if Pz_admin.functions[i].cat == "player" then
                        if Pz_admin.functions[i].sep ~= nil then RageUI.Separator(Pz_admin.functions[i].sep) end
                        RageUI.ButtonWithStyle(Pz_admin.functions[i].label, "Appuyez pour faire cette action", { RightLabel = "~b~Éxecuter ~s~→→" }, actualRankPermissions[i] == true, function(_,a,s)
                            if a then playerMarker(selected.c) end
                            if s then
                                Pz_admin.functions[i].press(selected)
                            end
                        end)
                    end
                end
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("pz_admin",'pz_admin_players_remb'),true,true,true,function()
                RageUI.Separator("↓ ~b~Paramètrage ~s~↓")

                RageUI.List("Quantité: ~s~", possiblesQty, qty, nil, {}, true, function(Hovered, Active, Selected, Index)
        
                    qty = Index
                    
                end)
                RageUI.Separator("↓ ~o~Liste d'items ~s~↓")

                for k,v in pairs(items) do
                    RageUI.ButtonWithStyle(v.label, "Appuyez pour donner cet item", { RightLabel = "~b~Donner ~s~→→" }, true, function(_,a,s)
                        if s then
                            -- Don
                        end
                    end)
                end
            end, function()    
            end, 1)



            
            Citizen.Wait(0)
        end
    end)

    

    


end

RegisterNetEvent("pz_admin:remb")
AddEventHandler("pz_admin:remb", function(id)
    if colorVar == nil then return end
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_players_remb'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_players_remb')))
    
end)

RegisterNetEvent("pz_admin:teleport")
AddEventHandler("pz_admin:teleport", function(pos)
    SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, false, false, false, false)
end)

RegisterNetEvent("pz_admin:getItems")
AddEventHandler("pz_admin:getItems", function(table)
    items = table
end)

RegisterNetEvent("pz_admin:canUse")
AddEventHandler("pz_admin:canUse", function(ok, rank, license)
    if ok then initializeThread(rank,license) end
end)

Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

    TriggerServerEvent("pz_admin:canUse")
end)

