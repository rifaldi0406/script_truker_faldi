fx_version 'cerulean'
game 'gta5'

lua54 'yes' -- ✅ Tambahkan baris ini

description 'Oil Delivery Job - QBCore with ox_target'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_target',
    'ox_lib'
}
