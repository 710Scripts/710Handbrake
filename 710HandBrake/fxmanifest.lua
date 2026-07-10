fx_version 'cerulean'
game 'gta5'

author '710Scripts'
description 'Realistic handbrake system with HUD, sounds and multi-language support - Open Source'
version '3.3.0'

ui_page 'html/ui.html'

client_scripts {
    'config.lua',
    'locale/en.lua',
    'locale/es.lua',
    'locale/fr.lua',
    'locale/de.lua',
    'locale/pt.lua',
    'locale/ru.lua',
    'locale/it.lua',
    'locale/zh.lua',
    'locale/ja.lua',
    'locale/ko.lua',
    'locale/ar.lua',
    'locale/nl.lua',
    'locale/pl.lua',
    'locale/sv.lua',
    'locale/tr.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}

files {
    'html/ui.html',
    'html/sounds/*.ogg',
    'html/images/*.png'
}

provide 'handbrake'