-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local HBD = LibStub('HereBeDragons-2.0')

local ARROW = 'Interface\\AddOns\\' .. ADDON_NAME .. '\\core\\artwork\\arrow'
local CIRCLE = 'Interface\\AddOns\\' .. ADDON_NAME .. '\\core\\artwork\\circle'
local LINE = 'Interface\\AddOns\\' .. ADDON_NAME .. '\\core\\artwork\\line'

-------------------------------------------------------------------------------

local function ResetPin(pin)
    pin.texture:SetRotation(0)
    pin.texture:SetTexCoord(0, 1, 0, 1)
    pin.texture:SetVertexColor(1, 1, 1, 1)
    pin.frameOffset = 0
    pin.rotation = nil
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

    -- normalize table values
    self.quest = ns.AsTable(self.quest)
    self.questDeps = ns.AsTable(self.questDeps)
end

function POI:IsCompleted()
    if self.quest and self.questAny then
        -- Completed if *any* attached quest ids are true
        for i, quest in ipairs(self.quest) do
            if C_QuestLog.IsQuestFlaggedCompleted(quest) then
                return true
            end
        end
    elseif self.quest then
        -- Completed only if *all* attached quest ids are true
        for i, quest in ipairs(self.quest) do
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then
                return false
            end
        end
        return true
    end
    return false
end

function POI:IsEnabled()
    -- Not enabled if any dependent quest ids are false
    if self.questDeps then
        for i, quest in ipairs(self.questDeps) do
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then
                return false
            end
        end
    end

    return not self:IsCompleted()
end

function POI:Render(map, template)
    -- draw a circle at every coord
    for i = 1, #self, 1 do map:AcquirePin(template, self, self[i]) end
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

    if self.r then t:SetVertexColor(self.r, self.g, self.b, self.a or 0.5) end

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
    for i = 1, #self, 1 do
        map:AcquirePin(template, self, CIRCLE, self[i])
        if i < #self then
            map:AcquirePin(template, self, LINE, self[i], self[i + 1])
        end
    end
end

function Path:Draw(pin, type, xy1, xy2)
    local t = ResetPin(pin)
    t:SetVertexColor(unpack({ns:GetColorOpt('path_color')}))
    t:SetTexture(type)

    -- constant size for minimaps, variable size for world maps
    local size = pin.minimap and 4 or (pin.parentHeight * 0.003)
    local line_width = pin.minimap and 60 or (pin.parentHeight * 0.05)

    -- apply user scaling
    size = size * ns:GetOpt('poi_scale')
    line_width = line_width * ns:GetOpt('poi_scale')

    if type == CIRCLE then
        pin:SetSize(size, size)
        return HandyNotes:getXY(xy1)
    elseif type == LINE then
        local x1, y1 = HandyNotes:getXY(xy1)
        local x2, y2 = HandyNotes:getXY(xy2)
        local line_length

        if pin.minimap then
            local mapID = HBD:GetPlayerZone()
            local wx1, wy1 = HBD:GetWorldCoordinatesFromZone(x1, y1, mapID)
            local wx2, wy2 = HBD:GetWorldCoordinatesFromZone(x2, y2, mapID)
            local wmapDistance = sqrt((wx2 - wx1) ^ 2 + (wy2 - wy1) ^ 2)
            local mmapDiameter = C_Minimap:GetViewRadius() * 2
            line_length = Minimap:GetWidth() * (wmapDistance / mmapDiameter)
            pin.rotation = -math.atan2(wy2 - wy1, wx2 - wx1)
        else
            local x1p = x1 * pin.parentWidth
            local x2p = x2 * pin.parentWidth
            local y1p = y1 * pin.parentHeight
            local y2p = y2 * pin.parentHeight
            line_length = sqrt((x2p - x1p) ^ 2 + (y2p - y1p) ^ 2)
            pin.rotation = -math.atan2(y2p - y1p, x2p - x1p)
        end
        pin:SetSize(line_length, line_width)
        pin.texture:SetRotation(pin.rotation)

        return (x1 + x2) / 2, (y1 + y2) / 2
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
    self.distance = sqrt(((x2 - x1) * 1.85) ^ 2 + (y2 - y1) ^ 2)
    self.segments = floor(self.distance / 0.015)

    self.path = {}
    for i = 0, self.segments, 1 do
        local segX = x1 + (x2 - x1) / self.segments * i
        local segY = y1 + (y2 - y1) / self.segments * i
        self.path[#self.path + 1] = HandyNotes:getCoord(segX, segY)
    end
end

function Line:Render(map, template)
    if map.minimap then
        for i = 1, #self.path, 1 do
            map:AcquirePin(template, self, CIRCLE, self.path[i])
            if i < #self.path then
                map:AcquirePin(template, self, LINE, self.path[i],
                    self.path[i + 1])
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

function Arrow:Render(map, template)
    -- draw a segmented line and the head of the arrow
    Line.Render(self, map, template)
    map:AcquirePin(template, self, ARROW, self[1], self[2])
end

function Arrow:Draw(pin, type, xy1, xy2)
    local x, y = Line.Draw(self, pin, type, xy1, xy2)
    if x and y then return x, y end -- circle or line

    -- constant size for minimaps, variable size for world maps
    local head_length = pin.minimap and 40 or (pin.parentHeight * 0.04)
    local head_width = pin.minimap and 15 or (pin.parentHeight * 0.015)
    head_length = head_length * ns:GetOpt('poi_scale')
    head_width = head_width * ns:GetOpt('poi_scale')
    pin:SetSize(head_width, head_length)

    local x1, y1 = HandyNotes:getXY(xy1)
    local x2, y2 = HandyNotes:getXY(xy2)
    if pin.minimap then
        local mapID = HBD:GetPlayerZone()
        local wx1, wy1 = HBD:GetWorldCoordinatesFromZone(x1, y1, mapID)
        local wx2, wy2 = HBD:GetWorldCoordinatesFromZone(x2, y2, mapID)
        pin.rotation = -math.atan2(wy2 - wy1, wx2 - wx1) + (math.pi / 2)
    else
        local x1p = x1 * pin.parentWidth
        local x2p = x2 * pin.parentWidth
        local y1p = y1 * pin.parentHeight
        local y2p = y2 * pin.parentHeight
        pin.rotation = -math.atan2(y2p - y1p, x2p - x1p) - (math.pi / 2)
    end
    pin.texture:SetRotation(pin.rotation)

    return x2, y2
end

-------------------------------------------------------------------------------

ns.poi = {POI = POI, Glow = Glow, Path = Path, Line = Line, Arrow = Arrow}
