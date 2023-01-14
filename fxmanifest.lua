fx_version "adamant"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'
author 'Blue'

game "rdr3"




client_script {
    'data.lua',
    'client.lua',
}

server_scripts {
    'server.lua'
}

shared_scripts {
    'functions.lua',
    'language.lua',
    'config.lua',
}

