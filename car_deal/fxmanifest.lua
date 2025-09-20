fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    "vendors/RageUI/RMenu.lua",
	"vendors/RageUI/menu/RageUI.lua",
	"vendors/RageUI/menu/Menu.lua",
	"vendors/RageUI/menu/MenuController.lua",
	"vendors/RageUI/components/*.lua",
	"vendors/RageUI/menu/elements/*.lua",
	"vendors/RageUI/menu/items/*.lua",
	"vendors/RageUI/menu/panels/*.lua",
	"vendors/RageUI/menu/windows/*.lua",
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

