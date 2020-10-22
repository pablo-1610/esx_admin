fx_version 'adamant'
game 'gta5'
description 'Pablo Z. Admin'
version '1.0'

--[[

	   PZ_Admin par Pablo Z

	Tous droits réservés © 2020

]]

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"server/main.lua",
	"staff.lua"
}

client_scripts {
	-- RageUI Version 1
	"src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
	"src/client/menu/windows/*.lua",

	-- Pz_admin
	"client/main.lua" ,
	"staff.lua"

}

dependencies {
	'mysql-async'
}
