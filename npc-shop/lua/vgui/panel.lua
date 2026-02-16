local GradiantMatdown = Material("gui/gradient_down")

local basepanel = {}

function basepanel:Init(  )

    self:SetSize(ScrW()/3, ScrH()/2)
    self:Center()
    self:MakePopup()

    local closebtn = weapondealerconfig.createDButton(self:GetWide()-30, 0, 30 ,30, "x","Default", Color(220,0,0,80), Color(255,255,255), self, function()
        self:Remove()
    end)

end

function basepanel:Paint(w, h)

    surface.SetDrawColor(80,80,130)
    surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(Color(0,0,0))
    surface.SetMaterial(GradiantMatdown)
    surface.DrawTexturedRect(0, 0, w, h)
	
end

vgui.Register("BaseShopPanel", basepanel, "DPanel")
