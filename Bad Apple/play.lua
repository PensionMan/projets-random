framestable = framestable or util.JSONToTable(file.Read("bad_apple.json", "DATA"))

local colors = {}

for i=0, 15 do 
    colors[i] = HSLToColor(0, 0, 1/15*i )
end

local function drawframe(frame, x, y, w, h)

    for y, line in ipairs(framestable[frame]) do

        local tempx, w = 0

        for i = 1, #line, 2 do 

            w = line[i+1]*2
            surface.SetDrawColor(colors[line[i]])
            surface.DrawRect( tempx, (y-1)*2, w, 2 )

            tempx = tempx + w
        end

    end

end


local frame = 1
local start = CurTime() - 1/30
surface.PlaySound('bad_apple/music.mp3')

local badapple = vgui.Create( 'DFrame' )
badapple:SetSize( 480*2, 360*2 )
badapple:Center()
badapple:MakePopup()
badapple:ShowCloseButton(false)
badapple:SetTitle("")
function badapple:Paint(w,h)
    frame = math.floor((CurTime() - start)*30 % #framestable) 
    drawframe(frame)
end

local closebutton = vgui.Create("DButton", badapple)
closebutton:Dock(FILL)
closebutton:SetText("")
closebutton.Paint = function() end

closebutton.DoClick = function()

    badapple:Remove()
    RunConsoleCommand("stopsound")

end