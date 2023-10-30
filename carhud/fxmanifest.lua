fx_version 'adamant'
games { 'gta5' }
lua54 "yes"
ui_page 'html/ui.html'

files {
	'html/*',
}
shared_scripts { '@ox_lib/init.lua' }
client_script 'client.lua'
server_script 'server.lua'

exports {
	'SetFuel',
	'GetFuel'
}


