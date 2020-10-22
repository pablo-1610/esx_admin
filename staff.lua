Pz_admin = {

    functions = {
        ["revive"] = {
            cat = "player",
            press = function(selectedPlayer)

            end
        }
    },

    ranks = {
        [2] = {
            label = "Admin", 
            color = "~r~",
            permissions = {
                "revive"
            },
        },

        [1] = {
            label = "Modérateur", 
            color = "~o~",
            permissions = {
                "revive"
            },
        }
    },

    staffList ={
        ["license:8a3920fcd94fb7875a3a8933588a526f70fd4213"] = 2 -- Alex
    },

    itemList = {

    }



    
}