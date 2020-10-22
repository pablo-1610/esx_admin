Pz_admin = {
    
    utils = {
        keyboard = function(title,mess)
            AddTextEntry("FMMC_MPM_NA", title)
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", mess, "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0)
                Wait(0)
            end
            if (GetOnscreenKeyboardResult()) then
                local result = GetOnscreenKeyboardResult()
                if result then
                    return result
                end
            end
        end
    },

    functions = {

        [1] = {
            cat = "player",
            sep = "↓ ~b~Téleportations ~s~↓",
            label = "Téléportation sur le joueur",
            press = function(selectedPlayer)
                local ped = GetPlayerPed(selectedPlayer.c)
                local pos = GetEntityCoords(ped)
                SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
            end
        },

        [2] = {
            cat = "player",
            sep = nil,
            label = "Téleportation sur moi",
            press = function(selectedPlayer)
                local pos = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("pz_admin:bring", selectedPlayer.s, pos)
            end
        },

        [3] = {
            cat = "player",
            sep =  "↓ ~o~Actions diverses ~s~↓",
            label = "Réanimer le joueur",
            press = function(selectedPlayer)
                TriggerServerEvent("pz_admin:revive", selectedPlayer.s)
            end
        },


        [4] = {
            cat = "player",
            sep = nil,
            label = "Envoyer un message",
            press = function(selectedPlayer)
                local message = Pz_admin.utils.keyboard("Message","Entrez un message:")
                TriggerServerEvent("pz_admin:message", selectedPlayer.s, message)
            end
        },

        [5] = {
            cat = "player",
            sep = nil,
            label = "Rembourser le joueur",
            press = function(selectedPlayer)
                TriggerEvent("pz_admin:remb", selectedPlayer.s)
            end
        },

        [6] = {
            cat = "player",
            sep =  "↓ ~r~Sanctions ~s~↓",
            label = "Expulser le joueur",
            press = function(selectedPlayer)
                local message = Pz_admin.utils.keyboard("Raison","Entrez une raison:")
                if message ~= nil then
                    TriggerServerEvent("pz_admin:kick", selectedPlayer.s, message)
                    ESX.ShowNotification("~g~Kick effectué!")
                end
            end
        },

        [7] = {
            cat = "player",
            sep = nil,
            label = "Bannir le joueur",
            press = function(selectedPlayer)
                local reason = Pz_admin.utils.keyboard("Raison", "Entrez une raison")
                if reason ~= nil then 
                    local time = Pz_admin.utils.keyboard("Durée", "Entrez une durée")
                    if time ~= nil then
                        print("test")
                
                        TriggerServerEvent("pz_admin:ban", PlayerId(),selectedPlayer.s, reason, time)
                        print("test2")
                    end
                end
            end
        },

        


        
    },

    ranks = {
        [2] = {
            label = "Admin", 
            color = "~r~",
            permissions = {
                1,2,3,4,5,6,7
            },
        },

        [1] = {
            label = "Modérateur", 
            color = "~o~",
            permissions = {
                1
            },
        }
    },

    staffList ={
        ["license:8a3920fcd94fb7875a3a8933588a526f70fd4213"] = 2, -- Alex
        ["license:d67dec9ddd7c3d7f4e160f675224b06eb5a2d008"] = 2 -- PAblo
    },

    itemList = {

    }



    
}