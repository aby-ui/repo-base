local _, MDT = ...
local L = MDT.L
local db
local twipe,tinsert,tremove,tgetn,CreateFrame = table.wipe,table.insert,table.remove,table.getn,CreateFrame

-- return true if a is more lower-left than b
local function is_lower_left(a, b)
    if a[1] < b[1] then return true end
    if a[1] > b[1] then return false end
    if a[2] < b[2] then return true end
    if a[2] > b[2] then return true end
    return false
end

-- return true if c is left of line a-b
local function is_left_of(a, b, c)
    local u1 = b[1] - a[1]
    local v1 = b[2] - a[2]
    local u2 = c[1] - a[1]
    local v2 = c[2] - a[2]
    return u1 * v2 - v1 * u2 < 0
end

local function convex_hull(pts)
    local lower_left = 1
    for i = 2, #pts do
        if is_lower_left(pts[i], pts[lower_left]) then lower_left = i end
    end

    local hull = {}
    local final = 1
    local tries = 0
    repeat
        table.insert(hull, lower_left)
        final = 1
        for j = 2, #pts do
            if lower_left == final or is_left_of(pts[lower_left], pts[final], pts[j]) then final = j end
        end
        lower_left = final
        tries = tries + 1
    until final == hull[1] or tries>100 --deadlocked here otherwise?!?

    local hullpts = {}
    for _, index in ipairs(hull) do
        table.insert(hullpts, pts[index])
    end
    return hullpts
end

local function cross(a,b)
    return a[1] * b[2] - a[2] * b[1]
end

local function area(points)
    local res = cross(points[#points], points[1])
    for i = 1, #points-1 do
        res = res + cross(points[i], points[i+1])
    end
    return math.abs(res)/2
end

local function centroid(pts)
    local rx = 0
    local ry = 0

    local area = area(pts)
    for i = 1, #pts-1 do
        rx = rx + ((pts[i][1] + pts[i+1][1]) * ((pts[i][1] * pts[i+1][2]) - (pts[i+1][1] * pts[i][2])))
        ry = ry + ((pts[i][2] + pts[i+1][2]) * ((pts[i][1] * pts[i+1][2]) - (pts[i+1][1] * pts[i][2])))
    end
    rx = rx + ((pts[#pts][1] + pts[1][1]) * ((pts[#pts][1] * pts[1][2]) - (pts[1][1] * pts[#pts][2])))
    ry = ry + ((pts[#pts][2] + pts[1][2]) * ((pts[#pts][1] * pts[1][2]) - (pts[1][1] * pts[#pts][2])))
    rx = rx / (area * 6)
    ry = ry / (area * 6)
    return {rx, ry}
end

local function expand_polygon(poly, numCirclePoints)
    local res = {}
    local resIndex = 1
    for i = 1, #poly do
        local x = poly[i][1]
        local y = poly[i][2]
        local r = poly[i][3]*10
        local adjustedNumPoints = math.max(1,math.floor(numCirclePoints*poly[i][3]))

        for j = 1, adjustedNumPoints do
            local cx = x+r*math.cos(2*math.pi/adjustedNumPoints*j)
            local cy = y+r*math.sin(2*math.pi/adjustedNumPoints*j)
            res[resIndex] = {cx,cy,r}
            resIndex = resIndex + 1
        end

    end

    return res
end

---TexturePool
local activeTextures = {}
local texturePool = {}
local function getTexture()
    local size = tgetn(texturePool)
    if size == 0 then
        return MDT.main_frame.mapPanelFrame:CreateTexture(nil, "OVERLAY")
    else
        local tex = texturePool[size]
        tremove(texturePool, size)
        tex:SetRotation(0)
        tex:SetTexCoord(0, 1, 0, 1)
        tex:ClearAllPoints()
        tex.coords = nil
        tex.points = nil
        return tex
    end
end
local function releaseTexture(tex)
    tex:Hide()
    tinsert(texturePool,tex)
end

---ReleaseAllActiveTextures
function MDT:ReleaseHullTextures()
    for k,tex in pairs(activeTextures) do
        releaseTexture(tex)
    end
    twipe(activeTextures)
end

function MDT:DrawHullCircle(x, y, size, color, layer, layerSublevel)
    local circle = getTexture()
    circle:SetDrawLayer(layer, layerSublevel)
    circle:SetTexture("Interface\\AddOns\\MythicDungeonTools\\Textures\\Circle_White")
    circle:SetVertexColor(color.r,color.g,color.b,color.a)
    circle:SetWidth(1.1*size)
    circle:SetHeight(1.1*size)
    circle:ClearAllPoints()
    circle:SetPoint("CENTER", MDT.main_frame.mapPanelTile1,"TOPLEFT",x,y)
    circle:Show()
    tinsert(activeTextures,circle)
end

function MDT:DrawHullLine(x, y, a, b, size, color, smooth, layer, layerSublevel, lineFactor)
    local line = getTexture()
    line:SetTexture("Interface\\AddOns\\MythicDungeonTools\\Textures\\Square_White")
    line:SetVertexColor(color.r,color.g,color.b,color.a)
    DrawLine(line, MDT.main_frame.mapPanelTile1, x, y, a, b, size, lineFactor and lineFactor or 1.1,"TOPLEFT")
    line:SetDrawLayer(layer, layerSublevel)
    line:Show()
    line.coords = {x,y,a,b}
    tinsert(activeTextures,line)
    if smooth == true  then
        MDT:DrawHullCircle(x,y,size*0.9,color,layer,layerSublevel)
    end
end

function MDT:DrawHull(vertices,pullColor,pullIdx)
    --if true then return end
    local hull = convex_hull(vertices)
    if hull then

        hull = expand_polygon(hull,13)

        hull = convex_hull(hull)

        for i = 1, #hull do
            local a = hull[i]
            local b = hull[1]
            if i ~= #hull then b = hull[i+1] end
            --layerSublevel go from -8 to 7
            --we rotate through the layerSublevel to avoid collisions
            MDT:DrawHullLine(a[1], a[2], b[1], b[2], 3*(MDT.scaleMultiplier[MDT:GetDB().currentDungeonIdx] or 1), pullColor, true, "ARTWORK", pullIdx%16-8, 1)
        end
    end
end

local function getPullVertices(p,blips)
    local vertices = {}
    for enemyIdx,clones in pairs(p) do
        if tonumber(enemyIdx) then
            for _,cloneIdx in pairs(clones) do
                if MDT:IsCloneIncluded(enemyIdx, cloneIdx) then
                    for _,blip in pairs(blips) do
                        if (blip.enemyIdx == enemyIdx) and (blip.cloneIdx == cloneIdx) then
                            local endPoint, endRelativeTo, endRelativePoint, endX, endY = blip:GetPoint()
                            table.insert(vertices, {endX, endY, blip.normalScale})
                            break
                        end
                    end
                end
            end
        end
    end
    return vertices
end

function MDT:DrawAllHulls(pulls)
    MDT:ReleaseHullTextures()
    local preset = MDT:GetCurrentPreset()
    local blips = MDT:GetDungeonEnemyBlips()
    local vertices
    pulls = pulls or preset.value.pulls
    for pullIdx,p in pairs(pulls) do
        local r,g,b = MDT:DungeonEnemies_GetPullColor(pullIdx,pulls)
        vertices = getPullVertices(p,blips)
        MDT:DrawHull(vertices,{r=r, g=g, b=b, a=1},pullIdx)
    end
end

function MDT:FindClosestPull(x,y)
    local preset = MDT:GetCurrentPreset()
    local blips = MDT:GetDungeonEnemyBlips()
    local vertices,hull,center
    local centers = {}
    --1. construct all hulls of pulls in this sublevel
    for pullIdx,p in pairs(preset.value.pulls) do
        vertices = getPullVertices(p,blips)
        hull = convex_hull(vertices)
        --2. get centroid of each pull
        if hull and hull[#hull] then
            if #hull>2 then
                center = centroid(hull)
                centers[pullIdx]=center
            elseif #hull==2 then
                local x1 = hull[1][1]
                local y1 = hull[1][2]
                local x2 = hull[2][1]
                local y2 = hull[2][2]
                centers[pullIdx] = {(x1+x2)/2,(y1+y2)/2}
            elseif #hull==1 then
                local x1 = hull[1][1]
                local y1 = hull[1][2]
                centers[pullIdx] = {x1,y1}
            end
        end
    end
    --3. find closest centroid
    local centerDist = math.huge
    local centerIndex
    for k,center in pairs(centers) do
        local squaredDist = (x-center[1])^2+(y-center[2])^2
        if squaredDist<centerDist then
            centerDist = squaredDist
            centerIndex = k
        end
    end
    if centerIndex then
        return centerIndex,centers[centerIndex][1],centers[centerIndex][2]
    end

end
