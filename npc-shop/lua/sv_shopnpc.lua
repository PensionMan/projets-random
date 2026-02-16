net.Receive("wepdealermsg", function(len, ply)

    local item = weapondealerconfig.items[net.ReadInt(7)]

    ply.isclosetodealer = false
    local sqr200 = 40000 // 200*200

    for k,v in pairs(ents.FindByClass("npc-weapon-dealer")) do 
        if ply:GetPos():Distance2DSqr(v:GetPos()) < sqr200 then 
            ply.isclosetodealer = true
            break
        end 
    end

    if !ply.isclosetodealer || ply:getDarkRPVar("money") < item.price then 
        MsgC(Color(255,0,0), "GUN DEALER EXPLOIT TENTATIVE :", ply:Nick(), ply:SteamID())
        return
    end 

    ply:setDarkRPVar("money", ply:getDarkRPVar("money") - item.price)

    if item.type == "weapon" then 

        ply:Give(item.classname)

    elseif item.type == "ammo" then // pour potentiellement rajouter des munitions dans le sh_config.lua. C'était pas le but de base donc je l'ai pas fait mais c'est possible.

        ply:GiveAmmo(item.amount, item.ammotype)
    end

    local q = POKEMON.database:query([[CREATE TABLE IF NOT EXISTS transactions(
        
        id INT AUTO_INCREMENT,
        arme VARCHAR(50),
        prix INT,
        date_action DATETIME DEFAULT CURRENT_TIMESTAMP,
        STEAMID64 VARCHAR(50) NOT NULL,
        PRIMARY KEY(id)
        
        )]])
    q:start() // je fais la table ici au moins vous l'avez sur le github, pck si je l'avait créer dans mon fichier où j'initialise ma db, il y aurait fallu que je rajoute ce fichier dans le commit et il n'a rien a voir avec l'addon de base... 

    local q = POKEMON.database:query(Format("INSERT INTO transactions (arme, prix, STEAMID64) VALUES ('%s', %d, '%s')", item.classname, item.price, ply:SteamID64()))
    q:start()
    
end)
