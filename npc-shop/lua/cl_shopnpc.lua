surface.CreateFont("GunName", {
    font = "Coolvetica",
    size = 22,
    weight = 600,
    antialias = true,
    shadow = true,
})

surface.CreateFont("GunInfos", {
    font = "Roboto",
    size = math.floor(19 * (ScrH() / 1440)),
    weight = 400,
    antialias = true,
})

surface.CreateFont("BuyBut", {
    font = "ChatFont",
    size = math.floor(30 * (ScrH() / 1440)),
    weight = 400,
    antialias = true,
})

local function shopmenuinit()

    local basepanel = vgui.Create("BaseShopPanel")

    local maincontainer = vgui.Create("DScrollPanel", basepanel)
    maincontainer:SetSize(basepanel:GetWide()-90, basepanel:GetTall()-40)
    maincontainer:SetPos(50,40)

    local sbar = maincontainer:GetVBar()
    sbar:SetHideButtons(true)

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(126, 126, 126))
    end

    for id, guninfo in pairs(weapondealerconfig.items) do

        local gunpanel = vgui.Create("DPanel", maincontainer)
        gunpanel:Dock(TOP)
        gunpanel:DockMargin(0,40,0,0)
        gunpanel:SetTall(ScrH()*0.15)

        gunpanel.Paint = function(s,w,h)
            surface.SetDrawColor(Color(120,120,160,18))
            surface.DrawRect(0,0,w,h)
        end

        local visualizer = vgui.Create("DModelPanel", gunpanel)
        visualizer:Dock(LEFT)
        visualizer:SetWidth(ScrW()*0.08)
        visualizer:SetModel(guninfo.model)
        function visualizer:LayoutEntity(Entity) end

        local eyepos = visualizer.Entity:GetPos()
        eyepos:Add(Vector(50, 0, 0)) 

        visualizer:SetLookAt(visualizer.Entity:GetPos())
        visualizer:SetCamPos(eyepos) 
        visualizer.Entity:SetAngles(Angle(0, 55, 0)) 

        visualizer:SetFOV(40)

        local infospanel = vgui.Create("DPanel", gunpanel)
        infospanel:Dock(FILL)
        infospanel:DockMargin(15, 10, 20, 10)
        infospanel.Paint = function(s,w,h)
            surface.SetDrawColor(Color(5,5,5,235))
            surface.DrawRect(0,0,w,h)
        end

        local nom = vgui.Create("DLabel", infospanel)
        nom:SetFont("GunName")
        nom:SetText(guninfo.name.." :")
        nom:Dock(TOP)
        nom:SetTall(30)
        nom:DockMargin(10, 5, 0, 0)

        local separator = vgui.Create("DPanel", infospanel)
        separator:Dock(TOP)
        separator:SetTall(2)
        separator.Paint = function(s,w,h)
            surface.SetDrawColor(Color(110,110,180))
            surface.DrawRect(0,0,w,h)
        end

        local ammotype = vgui.Create("DLabel", infospanel)
        ammotype:SetFont("GunInfos")
        ammotype:SetText("Type de munitions : ".. guninfo.ammotype)
        ammotype:Dock(TOP)
        ammotype:SetTall(math.floor(25 * (ScrH() / 1440)))
        ammotype:DockMargin(10, 5, 0, 0)
        ammotype:SetTextColor(Color(111,0,255))

        local taillechargeur = vgui.Create("DLabel", infospanel)
        taillechargeur:SetFont("GunInfos")
        taillechargeur:SetText("Capacité d'un chargeur : ".. guninfo.taillechargeur)
        taillechargeur:Dock(TOP)
        taillechargeur:SetTall(math.floor(25 * (ScrH() / 1440)))
        taillechargeur:DockMargin(10, 5, 0, 0)
        taillechargeur:SetTextColor(Color(111,0,255))

        local price = vgui.Create("DLabel", infospanel)
        price:SetFont("GunInfos")
        price:SetText("Prix : $".. guninfo.price)
        price:Dock(TOP)
        price:SetTall(math.floor(25 * (ScrH() / 1440)))
        price:DockMargin(10, 5, 0, 0)
        price:SetTextColor(Color(111,0,255))

        local buybuttoncolor = Color(255,0,0,180)

        if guninfo.price < LocalPlayer():getDarkRPVar("money") then
            buybuttoncolor = Color(0,255,0,110)
        end

        local buybutton = weapondealerconfig.createDButton(ScrW()*0.13, ScrH()*0.05, ScrW()*0.0521 ,ScrH()*0.0463, "Acheter", "BuyBut", buybuttoncolor, Color(255,255,255), infospanel, function()

            if guninfo.price < LocalPlayer():getDarkRPVar("money") then
                net.Start("wepdealermsg")
                net.WriteInt(id, 7)
                net.SendToServer()
            else
                chat.AddText(Color(255,0,0), "Vous n'avez pas assez d'argent.")
            end

        end)
        
    end

end

net.Receive("wepdealermsg", shopmenuinit)
