-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local HBD = LibStub('HereBeDragons-2.0')

local CIRCLE = "Interface\\AddOns\\"..ADDON_NAME.."\\core\\artwork\\circle"
local LINE = "Interface\\AddOns\\"..ADDON_NAME.."\\core\\artwork\\line"

-------------------------------------------------------------------------------

local function ResetPin(pin)
    pin.texture:SetRotation(0)
    pin.texture:SetTexCoord(0, 1, 0, 1)
    pin.texture:SetVertexColor(1, 1, 1, 1)
    pin.frameOffset = 0
    pin:SetAlpha(1)
    if pin.SetScalingLimits then -- World map only!
        pin:SetScalingLimits(nil, nil, nil)
    end
    return pin.texture
end

-------------------------------------------------------------------------------
-------------------------- POI (Point of Interest) ----------------------------
-------------------------------------------------------------------------------

local POI = Class('POI')

function POI:Initialize(attrs)
    for k, v in pairs(attrs) do self[k] = v end
end

function POI:Render(map, template)
    -- draw a circle at every coord
    for i=1, #self, 1 do
        map:AcquirePin(template, self, self[i])
    end
end

function POI:Draw(pin, xy)
    local t = ResetPin(pin)
    local size = (pin.minimap and 10 or (pin.parentHeight * 0.012))
    size = size * ns:GetOpt('poi_scale')
    t:SetVertexColor(unpack({ns:GetColorOpt('poi_color')}))
    t:SetTexture(CIRCLE)
    pin:SetSize(size, size)
    return HandyNotes:getXY(xy)
end

-------------------------------------------------------------------------------
------------------------------------ GLOW -------------------------------------
-------------------------------------------------------------------------------

local Glow = Class('Glow', POI)

function Glow:Draw(pin, xy)
    local t = ResetPin(pin)

    local hn_alpha, hn_scale
    if pin.minimap then
        hn_alpha = HandyNotes.db.profile.icon_alpha_minimap
        hn_scale = HandyNotes.db.profile.icon_scale_minimap
    else
        hn_alpha = HandyNotes.db.profile.icon_alpha
        hn_scale = HandyNotes.db.profile.icon_scale
    end

    local size = 15 * hn_scale * self.scale

    t:SetTexture(self.icon)

    if self.r then
        t:SetVertexColor(self.r, self.g, self.b, self.a or 0.5)
    end

    pin.frameOffset = 1
    if pin.SetScalingLimits then -- World map only!
        pin:SetScalingLimits(1, 1.0, 1.2)
    end
    pin:SetAlpha(hn_alpha * self.alpha)
    pin:SetSize(size, size)
    return HandyNotes:getXY(xy)
end

-------------------------------------------------------------------------------
------------------------------------ PATH -------------------------------------
-------------------------------------------------------------------------------

local Path = Class('Path', POI)

function Path:Render(map, template)
    -- draw a circle at every coord and a line between them
    for i=1, #self, 1 do
        map:AcquirePin(template, self, CIRCLE, self[i])
        if i < #self then
            map:AcquirePin(template, self, LINE, self[i], self[i+1])
        end
    end
end

function Path:Draw(pin, type, xy1, xy2)
    local t = ResetPin(pin)
    t:SetVertexColor(unpack({ns:GetColorOpt('path_color')}))
    t:SetTexture(type)

    -- constant size for minimaps, variable size for world maps
    local size = pin.minimap and 5 or (pin.parentHeight * 0.005)
    local line_width = pin.minimap and 60 or (pin.parentHeight * 0.05)

    -- apply user scaling
    size = size * ns:GetOpt('poi_scale')
    line_width = line_width * ns:GetOpt('poi_scale')

    if type == CIRCLE then
        pin:SetSize(size, size)
        return HandyNotes:getXY(xy1)
    else
        local x1, y1 = HandyNotes:getXY(xy1)
        local x2, y2 = HandyNotes:getXY(xy2)
        local line_length

        if pin.minimap then
            local mapID = HBD:GetPlayerZone()
            local wx1, wy1 = HBD:GetWorldCoordinatesFromZone(x1, y1, mapID)
            local wx2, wy2 = HBD:GetWorldCoordinatesFromZone(x2, y2, mapID)
            local wmapDistance = sqrt((wx2-wx1)^2 + (wy2-wy1)^2)
            local mmapDiameter = C_Minimap:GetViewRadius() * 2
            line_length = Minimap:GetWidth() * (wmapDistance / mmapDiameter)
            t:SetRotation(-math.atan2(wy2-wy1, wx2-wx1))
        else
            local x1p = x1 * pin.parentWidth
            local x2p = x2 * pin.parentWidth
            local y1p = y1 * pin.parentHeight
            local y2p = y2 * pin.parentHeight
            line_length = sqrt((x2p-x1p)^2 + (y2p-y1p)^2)
            t:SetRotation(-math.atan2(y2p-y1p, x2p-x1p))
        end
        pin:SetSize(line_length, line_width)

        return (x1+x2)/2, (y1+y2)/2
    end
end

-------------------------------------------------------------------------------
------------------------------------ LINE -------------------------------------
-------------------------------------------------------------------------------

local Line = Class('Line', Path)

function Line:Initialize(attrs)
    Path.Initialize(self, attrs)

    -- draw a segmented line between two far-away points
    local x1, y1 = HandyNotes:getXY(self[1])
    local x2, y2 = HandyNotes:getXY(self[2])

    -- find an appropriate number of segments
    self.distance = sqrt(((x2-x1) * 1.85)^2 + (y2-y1)^2)
    self.segments = floor(self.distance / 0.015)

    self.path = {}
    for i=0, self.segments, 1 do
        self.path[#self.path + 1] = HandyNotes:getCoord(
            x1 + (x2-x1) / self.segments * i,
            y1 + (y2-y1) / self.segments * i
        )
    end
end

function Line:Render(map, template)
    if map.minimap then
        for i=1, #self.path, 1 do
            map:AcquirePin(template, self, CIRCLE, self.path[i])
            if i < #self.path then
                map:AcquirePin(template, self, LINE, self.path[i], self.path[i+1])
            end
        end
    else
        map:AcquirePin(template, self, CIRCLE, self[1])
        map:AcquirePin(template, self, CIRCLE, self[2])
        map:AcquirePin(template, self, LINE, self[1], self[2])
    end
end

-------------------------------------------------------------------------------
------------------------------------ ARROW ------------------------------------
-------------------------------------------------------------------------------

local Arrow = Class('Arrow', Line)

function Arrow:Initialize(attrs)
    Line.Initialize(self, attrs)

    local x1, y1 = HandyNotes:getXY(self[1])
    local x2, y2 = HandyNotes:getXY(self[2])
    local angle = math.atan2(y2 - y1, (x2 - x1) * 1.85) + (math.pi * 0.5)
    local xdiff = math.cos(angle) * (self.distance / self.segments / 4)
    local ydiff = math.sin(angle) * (self.distance / self.segments / 4)

    local xl, yl = HandyNotes:getXY(self.path[#self.path - 1])
    self.corner1 = HandyNotes:getCoord(xl + xdiff, yl + ydiff)
    self.corner2 = HandyNotes:getCoord(xl - xdiff, yl - ydiff)
end

function Arrow:Render(map, template)
    -- draw a segmented line
    Line.Render(self, map, template)

    -- draw the head of the arrow
    map:AcquirePin(template, self, CIRCLE, self.corner1)
    map:AcquirePin(template, self, CIRCLE, self.corner2)
    map:AcquirePin(template, self, LINE, self.corner1, self.path[#self.path])
    map:AcquirePin(template, self, LINE, self.corner2, self.path[#self.path])
    map:AcquirePin(template, self, LINE, self.corner1, self.corner2)
end

-------------------------------------------------------------------------------

ns.poi = {
    POI=POI,
    Glow=Glow,
    Path=Path,
    Line=Line,
    Arrow=Arrow
}
