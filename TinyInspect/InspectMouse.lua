
-------------------------------------
-- 鼠标装等和天赋 Author: M
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")

local function FindLine(tooltip, keyword)
    local line, text
    for i = 2, tooltip:NumLines() do
        line = _G[tooltip:GetName() .. "TextLeft" .. i]
        text = line:GetText() or ""
        if (string.find(text, keyword)) then
            return line, i, _G[tooltip:GetName() .. "TextRight" .. i]
        end
    end
end

local LevelLabel = STAT_AVERAGE_ITEM_LEVEL .. ": "

local function AppendToGameTooltip(guid, ilevel, spec, weaponLevel, isArtifact)
    spec = spec or ""
    if (TinyInspectDB and not TinyInspectDB.EnableMouseSpecialization) then spec = "" end
    local _, unit = GameTooltip:GetUnit()
    if (not unit or UnitGUID(unit) ~= guid) then return end
    local ilvlLine, _, lineRight = FindLine(GameTooltip, LevelLabel)
    local ilvlText = format("%s|cffff8000%s|r", LevelLabel, ilevel)
    local specText = format("|cffb8b8b8%s|r", spec)
    if (weaponLevel and weaponLevel > 0 and TinyInspectDB.EnableMouseWeaponLevel) then
        ilvlText = ilvlText .. format(" (%s)", weaponLevel)
    end
    if (ilvlLine) then
        --lineRight:SetText(specText)
        ilvlLine:SetText(ilvlText .. " " .. specText)
    else
        --GameTooltip:AddDoubleLine(ilvlText, specText)
        GameTooltip:AddLine(ilvlText .. " " .. specText)
    end
    GameTooltip:Show()
end

--觸發觀察
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if (TinyInspectDB and not TinyInspectDB.EnableMouseItemLevel) then return end
    local _, unit = self:GetUnit()
    if (not unit) then return end
    local guid = UnitGUID(unit)
    if (not guid) then return end
    local hp = UnitHealthMax(unit)
    local data = GetInspectInfo(unit)
    if (data and data.hp == hp and data.ilevel > 0) then
        return AppendToGameTooltip(guid, floor(data.ilevel), data.spec, data.weaponLevel, data.isArtifact)
    end
    if (not CanInspect(unit) or not UnitIsVisible(unit)) then return end
    local inspecting = GetInspecting()
    if (inspecting) then
        if (inspecting.guid ~= guid) then
            return AppendToGameTooltip(guid, "n/a")
        else
            return AppendToGameTooltip(guid, "....")
        end
    end
    ClearInspectPlayer()
    NotifyInspect(unit)
    AppendToGameTooltip(guid, "...")
end)

--@see InspectCore.lua
LibEvent:attachTrigger("UNIT_INSPECT_READY", function(self, data)
    if (TinyInspectDB and not TinyInspectDB.EnableMouseItemLevel) then return end
    if (data.guid == UnitGUID("mouseover")) then
        AppendToGameTooltip(data.guid, floor(data.ilevel), data.spec, data.weaponLevel, data.isArtifact)
    end
end)
