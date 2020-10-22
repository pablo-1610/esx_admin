local ESX = nil
local staffRank = nil
local staffService = false
local colorVar = nil
local items = {}
local staffActions = {}

local function mug(title, subject, msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
    ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end

local function getItems()
    TriggerServerEvent("pz_admin:getItems")
end

local function alterMenuVisibility()
    RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main'), not RageUI.Visible(RMenu:Get("pz_admin",'pz_admin_main')))
end

local function registerMenus()
    RMenu.Add("pz_admin", "pz_admin_main", RageUI.CreateMenu("Menu d'administration","Rang: "..Pz_admin.ranks[staffRank].color..Pz_admin.ranks[staffRank].label))
end

local function initializeThread(rank,license)
    staffRank = rank
    colorVar = "~r~"

    getItems()
    registerMenus()

    local actualRankPermissions = {}

    for perm,_ in pairs(Pz_admin.functions) do
        actualRankPermissions[perm].access = false
    end

    for _,perm in pairs(Pz_admin.ranks[staffRank].permissions) do 
        actualRankPermissions[perm].access = true
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if IsControlJustPressed(1, 344) do alterMenuVisibility() end
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

                -- RightLabel = "~b~Prendre~s~ →→"

                if staffService then

                    RageUI.Separator(colorVar.."/!\\ Mode administration actif /!\\")
                    RageUI.Separator("")
                    RageUI.ButtonWithStyle("Interactions joueurs", "Intéragir avec les joueurs du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_players'))

                    RageUI.ButtonWithStyle("Interactions véhicules", "Intéragir avec les véhicules du serveur", { RightLabel = "→→" }, true, function()
                    end, RMenu:Get('pz_admin', 'pz_admin_vehicles'))

                end
            end, function()    
            end, 1)
            Citizen.Wait(0)
        end
    end)

    

    


end

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
end)

