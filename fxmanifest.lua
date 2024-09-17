fx_version 'cerulean'
game 'gta5'

description 'QB-ExoticCarSteal'
version '1.0.0'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/utils.lua',
    '@qb-core/client/zones/BoxZone.lua'
}

server_scripts {
    'server/main.lua'
}

lua54 'yes'
