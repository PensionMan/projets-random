weapondealerconfig = {}

weapondealerconfig.items = {

    {
        name = "Ak-47",
        classname = "weapon_ak472",
        ammotype = "SMG1",
        price = 100,
        model = "models/weapons/w_rif_ak47.mdl",
        taillechargeur = 30,
        type = "weapon"
    },

    {
        name = "Desert Eagle",
        classname = "weapon_deagle2",
        ammotype = "Pistol",
        price = 75,
        model = "models/weapons/w_pist_deagle.mdl",
        taillechargeur = 7,
        type = "weapon"
    },

    {
        name = "M4",
        classname = "weapon_m42",
        ammotype = "SMG1",
        price = 80,
        model = "models/weapons/w_rif_m4a1.mdl",
        taillechargeur = 30,
        type = "weapon"
    },

}

// utils : comme c'est un petit addon je ne créer pas une autre table ou même un autre fichier pour les utils (surtout qu'il n'y a qu'une fonction...)

if CLIENT then 

   function weapondealerconfig.createDButton(x, y, w, h, text, font, color, textcolor, parent, callback)
        local dbutton = vgui.Create("DButton", parent)
        dbutton:SetSize(w, h)
        dbutton:SetPos(x, y)
        dbutton:SetText("")

        dbutton.Paint = function(s, w, h)
            
            surface.SetDrawColor(color)
            surface.DrawRect(0, 0, w, h)

            if s:IsHovered() then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, w, h, 2) 
            end

            draw.SimpleText(text, font, w/2, h/2, textcolor, 1, 1)
        end

        dbutton.DoClick = callback

        return dbutton
    end

end
