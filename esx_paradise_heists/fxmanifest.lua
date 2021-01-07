fx_wersion 'adamant'

game 'rdr3'
author 'Backdoor Script Kiddy'

description 'Paradise Heists'

version '1.0.0'


client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/client.lua',
	'client/fleeca.lua',
	'client/drilling.lua',
	'client/hacking.lua',

	'locales/en.lua',
	'locales/cs.lua',
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/server.lua',

	'locales/en.lua',
	'locales/cs.lua',
}

dependencies {
	'es_extended',
	'async'
}
