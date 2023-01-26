fx_version 'cerulean'
game 'gta5'

author 'teig'
description 'Lumberjack (made by teig)'
version '1.1.0'

shared_script { 	'@qb-core/shared/locale.lua',
'config.lua',
'locales/en.lua',
}

client_scripts {
    'client/*.lua'
}

server_scripts {'server/*.lua'}



lua54 'yes'

