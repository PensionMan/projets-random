--depth-first backtracking

local cells = {}

local space=0
local countCellRow = 41
local countCellColumn = 41
local cellSize = (1080-space*(countCellRow))/(countCellRow+1)

for x=1,countCellRow do
        cells[x] = {}
    for y=1,countCellColumn do
        cells[x][y]=1
    end
end

local DIRECTIONS = {
    {0, -2},  -- Haut
    {2, 0},   -- Droite
    {0, 2},   -- Bas
    {-2, 0}   -- Gauche
}


local function getCell(x,y)
    if x<1 or x>(countCellRow-1) or y<1 or y>(countCellRow-1) then return end
    local cell = cells[x][y]
    if cell!=1 then return end
    return cell
end


local function setPathCell(x,y,value)
    cells[x][y]=value||0
end

local function Shuffle(t)
    local shuffled = {}
    for i, v in ipairs(t) do
        shuffled[i] = v
    end
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    return shuffled
end

local function depthFirstBacktracking(x,y)
    setPathCell(x,y)
    local endPos=true
    local stack = {{x = x, y = y}}
    local loop=0
    while #stack > 0 do
        local current = stack[#stack]
        local cx,cy = current.x,current.y

        loop=loop+1

        local notfound = true

        for k, dir in ipairs(Shuffle(DIRECTIONS)) do
            local nx,ny=cx+dir[1],cy+dir[2]
            local cell = getCell(nx,ny)
            if !cell then continue end
            notfound=false
            setPathCell(cx+dir[1]/2,cy+dir[2]/2)
            setPathCell(nx,ny)
            table.insert(stack, {x = nx, y = ny})
            break
        end

        if notfound then
            table.remove(stack)
        end
    end
end

local function resetMaze()
    cells = {}
    for x=1,countCellRow do
        cells[x] = {}
        for y=1,countCellColumn do
            cells[x][y]=1
        end
    end
end

local function GenerateMaze()
    local s=SysTime()
    resetMaze()
    local x,y=(math.random(1,math.floor(countCellRow/2)))*2,
    (math.random(1,math.floor(countCellRow/2)))*2
    depthFirstBacktracking(x,y,countCellRow)
    cells[2][2] = 3
    cells[countCellRow-1][countCellRow-1] = 2
    print(Format('Maze générate in %fs size %sx%s (cells:%s)',SysTime()-s,countCellRow,countCellColumn,countCellRow*countCellColumn))
end

local function generatButton(text,color,LeftOrRight,parent,callback)
    surface.SetFont("Default")
    local wide = surface.GetTextSize(text)
    local bp = vgui.Create('DButton',parent)
    bp:SetText('')
    bp:SetWide(math.max(wide+8,40))
    bp:Dock(LeftOrRight)
    local alpha = 0
    function bp:Paint(w,h)
        alpha=Lerp(FrameTime()*20, alpha, self:IsHovered()&&128||0)
        draw.RoundedBox(4,0,0,w,h,Color(color.r,color.g,color.b,alpha))
        draw.SimpleText(text,"Default",w*.5,h*.5,color,1,1)
    end
    bp.DoClick=callback
    return bp
end

local function generatSlider(text,min,max,default,parent,callback)

    local slider = vgui.Create( "DSlider", parent )
    slider:SetDrawOnTop(true)
    slider:Dock(TOP)
    slider:DockMargin(10,5,0,0)
    slider:SetTall( 20 )

    function slider:Paint(w, h)
        surface.SetDrawColor(Color(60, 60, 60))
        surface.DrawRect(0, h/2.5, w, h/4)
    end

    function slider:OnValueChanged(x)
        callback(Lerp(x,min,max))
    end
    slider:SetSlideX(default)
    
end



local frame = vgui.Create('DFrame')
frame:SetTitle('')
frame:SetSize(ScrW(),ScrH())
frame:Center()
frame:MakePopup()
frame:ShowCloseButton(false)
frame:DockPadding(0,0,0,0)
function frame:Paint(w,h)
end

local header = vgui.Create('panel',frame)
header:Dock(TOP)
header:SetTall(25)
function header:Paint(w,h)
    draw.RoundedBoxEx(4,0,0,w,h,Color(24,24,24),true,true)
end

generatButton('X',Color(200,0,0),RIGHT,header,function()
    frame:Remove()
end)


local title = vgui.Create('DLabel',header)
title:Dock(LEFT)
title:DockMargin(4,0,0,0)
title:SetText( "Maze Solver v1" )
title:SetTextColor( color_white )
title:SetFont("Trebuchet18")
title:SizeToContents()



local center = vgui.Create('panel',frame)
center:Dock(FILL)
function center:Paint(w,h)
    surface.SetDrawColor(30,30,30)
    surface.DrawRect(0,0,w,h)
end

local renderMaze = vgui.Create('panel',center)
renderMaze:SetSize(1,1)

local lastValue=1
local colors = {
    [0] = Color(222,222,222),
    [1] = Color(22,22,22),
    [2] = Color(100,255,0),
    [3] = Color(255,100,0),
    [4] = Color(255,0,200)
}
local function setcolor(value)
    if lastValue==value then return end
    surface.SetDrawColor(colors[value])
end
function renderMaze:Paint(w,h)
    surface.SetDrawColor(255,255,255)
    surface.DrawRect(0,0,w,h)
    lastValue=-1
    local wide = space

    for x=1,countCellRow do
        local wide = (cellSize+space)*(x-1)
        
        for y=1,countCellColumn do
            local cell = cells[x][y]
            setcolor(cell)
            surface.DrawRect(
                wide,
                (cellSize+space)*(y-1),
                cellSize,
                cellSize
            )
        end
    end
end

local scroll = vgui.Create('DScrollPanel',center)
scroll:SetWide(250)
scroll:Dock(LEFT)
scroll:DockMargin(60,0,0,0)

local zoom = 0
timer.Simple(0,function()
    local originalWide,originaleTall = center:GetSize()
/*
    generatSlider('Zoom:',0,2/1820*ScrH(),0,scroll,function(x)
        zoom=x
        local wide,tall=Lerp(zoom,10,ScrH()-50),Lerp(zoom,10,ScrH()-50)
        local fixWide = math.floor((wide-space*countCellRow)/countCellRow)*countCellRow
        local fixTall = math.floor((wide-space*countCellColumn)/countCellColumn)*countCellColumn
        renderMaze:SetSize(fixWide,fixTall)
        cellSize = (fixWide-space*(countCellRow))/(countCellRow)
        
        local w, h = center:GetSize()
        renderMaze:SetPos(math.floor((w - fixWide) / 2), math.floor((h - fixTall) / 2))
    end)
*/
    
    generatSlider('Size:',3,ScrH()-51,0,scroll,function(x)
        countCellRow=math.floor(x/2)*2+1
        countCellColumn=math.floor(x/2)*2+1
        local fixWide = math.floor((ScrH()-50-space*countCellRow)/(countCellRow))*(countCellRow)
        local fixTall = math.floor((ScrH()-50-space*countCellColumn)/(countCellColumn))*(countCellColumn)
        renderMaze:SetSize(fixWide,fixTall)
        cellSize = (fixWide-space*(countCellRow))/(countCellRow)
        local w, h = center:GetSize()

        renderMaze:SetPos(math.floor((w - fixWide) / 2), math.floor((h - fixTall) / 2))
        resetMaze()
    end)
end)
local footer = vgui.Create('panel', frame)
footer:Dock(BOTTOM)
footer:SetTall(25)
function footer:Paint(w,h)
    draw.RoundedBoxEx(4,0,0,w,h,Color(24,24,24),false,false,true,true)
end

generatButton('Generate',Color(0,255,0),LEFT,footer,function()
    GenerateMaze()
end)
generatButton('Reset',Color(255,255,0),LEFT,footer,function()
    resetMaze()
end)

local label = vgui.Create('DLabel',footer)
label:SetText( "Solve:" )
label:SetTextColor( color_white )
label:SetFont("Default")
label:Dock(LEFT)
label:DockMargin(8,0,4,0)
label:SizeToContents()

local function copytable(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = copytable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function checkcell(x, y, node)

    if not node[x][y] then 
        return false 
    end

    if cells[x][y] == 1 or cells[x][y] == 4 then 
        node[x][y] = false
        return false
    end

    return true

end

local function heuristic(x1, y1, x2, y2) // A* : f = g + h pour calculer le cout total donc on prend l'heuristic ici (jsp pk je l'ai pas fait dans la fonction j'avais envie de le mettre la)
    return math.abs(x1 - x2) + math.abs(y1 - y2)
end

local function Asolving()
    local s = SysTime()
    local startX, startY = 2, 2
    local endX, endY = countCellRow-1, countCellRow-1
    
    cells[startX][startY] = 3
    cells[endX][endY] = 2
    
    local openList = {{x = startX, y = startY, g = 0, h = heuristic(startX, startY, endX, endY), parent = nil}}
    local closedList = {}
    
    while #openList > 0 do
        local currentIndex = 1
        local current = openList[1]
        for i, node in ipairs(openList) do
            if (node.g + node.h) < (current.g + current.h) then
                current = node
                currentIndex = i
            end
        end
        
        if current.x == endX && current.y == endY then // fin
            local path = {}
            local temp = current.parent
            while temp && !(temp.x == startX && temp.y == startY) do
                table.insert(path, 1, {x = temp.x, y = temp.y})
                cells[temp.x][temp.y] = 4
                temp = temp.parent
            end
            print(Format("Résolu en %fs", SysTime()-s))
            return path
        end
        
        table.remove(openList, currentIndex)
        closedList[current.x .. "," .. current.y] = true
        
        local neighbors = {
            {x = current.x, y = current.y - 1}, // top
            {x = current.x + 1, y = current.y}, // right
            {x = current.x, y = current.y + 1}, // left
            {x = current.x - 1, y = current.y}  // bot
        }
        
        for _, neighbor in ipairs(neighbors) do

            local neighX, neighY = neighbor.x, neighbor.y
            
            if cells[neighX] && cells[neighX][neighY] && (cells[neighX][neighY] == 0 || cells[neighX][neighY] == 2) && !closedList[neighX .. "," .. neighY] then // dégueulasse mais ça marche donc hassoul
                
                local g = current.g + 1
                local h = heuristic(neighX, neighY, endX, endY)
                
                local inOpenList = false
                for _, node in ipairs(openList) do // j'ai pas trouvé d'autres moyens
                    if node.x == neighX && node.y == neighY then
                        inOpenList = true
                        if g < node.g then
                            node.g = g
                            node.parent = current
                        end
                        break
                    end
                end
                
                if !inOpenList then
                    table.insert(openList, {
                        x = neighX, 
                        y = neighY, 
                        g = g, 
                        h = h, 
                        parent = current
                    })
                end
            end
        end
    end
end

generatButton('A*',Color(0,255,255),LEFT,footer,function()
    if countCellRow < 4 then print("labyrinthe trop petit") return end
    Asolving()
end)
