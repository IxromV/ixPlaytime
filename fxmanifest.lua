fx_version 'adamant'
game 'gta5'
author 'Ixrom from RFS Store - https://dsc.gg/rfsstore'


client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua"
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    'server/server.lua'
}

shared_script {
    "shared/*.lua",
    "server/functions.lua"
}



