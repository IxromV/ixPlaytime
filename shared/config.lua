Playtime_Config = {

    menu_command = "time_menu", -- Commande afin d'ouvrir le menu en jeu
    groups = {"_dev", "admin"}, -- Groupes (staff) qui sont autorisés à effectuer la commande

    Webhook = {
        channel = "https://discordapp.com/api/webhooks/1179157693940904026/15ezd-LcPUCwEkvB87y7hPvYCGj_orC-G7Ko7b3AjFy6b-_bWHxrZG1vHs8f5LrQFABp",
        name = "RFS Store", -- Nom de la logs
        img = "https://media.discordapp.net/attachments/1183862528028200983/1183862925157466172/800-000.png?ex=6589e144&is=65776c44&hm=d50df426ab029aca97e027386dd4155b6abe46567e3470915f53467d8201e0e3&=&format=webp&quality=lossless&width=468&height=468",
        color = 2899536 -- Couleur de la logs
    },

    print_ = true, -- Print dans la console quand un joueur se déconnecte avec le temps de jeu de celui-ci

    servertime_command = "total_time" -- Commande (utilisable uniquement sur la console) permettant de print le temps de jeu total sur le serveur
}