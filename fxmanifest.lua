fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Sobing4413'
name 'exter-gruppe6job'
description 'GruppeSechs Job System 4.0'

version '2.0.0'

files {
    'web/**',
    'web/assets/**',
	'web/assets/font/**',
}

ui_page 'web/index.html'


client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/**.lua',
	'locales/**.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/core.lua',
	'server/**.lua',
}

shared_scripts {
	'shared/config.lua',
	'shared/bridge.lua',
    'shared/utils.lua',
	'locales/**.lua'
}

escrow_ignore {
	'shared/**',
	'locales/**.lua'
}