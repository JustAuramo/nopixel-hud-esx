resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
lua54 "yes"
client_script {
    'config.lua',
	'client/*.lua'
}

server_script {
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/*.css',
    'html/*.js',
    'html/img/*.png',
}

exports {
    'sendfpscarhud',
    'enhancements'
}