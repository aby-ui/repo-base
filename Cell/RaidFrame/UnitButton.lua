local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local I = Cell.iFuncs
local P = Cell.pixelPerfectFuncs
local A = Cell.animations
local LGI = LibStub:GetLibrary("LibGroupInfo")

CELL_SUMMON_ICONS_ENABLED = false
CELL_FADE_OUT_HEALTH_PERCENT = nil

-- local LibCLHealth = LibStub("LibCombatLogHealth-1.0")

local UnitGUID = UnitGUID
-- local UnitHealth = LibCLHealth.UnitHealth
local UnitClassBase = UnitClassBase
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitIsUnit = UnitIsUnit
local UnitIsConnected = UnitIsConnected
local UnitIsAFK = UnitIsAFK
local UnitIsFeignDeath = UnitIsFeignDeath
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGhost = UnitIsGhost
local UnitPowerType = UnitPowerType
local UnitPowerMax = UnitPowerMax
local UnitInRange = UnitInRange
local UnitIsVisible = UnitIsVisible
local SetRaidTargetIconTexture = SetRaidTargetIconTexture
local GetTime = GetTime
local GetRaidTargetIndex = GetRaidTargetIndex
local GetReadyCheckStatus = GetReadyCheckStatus
local UnitHasVehicleUI = UnitHasVehicleUI
-- local UnitInVehicle = UnitInVehicle
-- local UnitUsingVehicle = UnitUsingVehicle
local UnitIsCharmed = UnitIsCharmed
local UnitIsPlayer = UnitIsPlayer
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitThreatSituation = UnitThreatSituation
local GetThreatStatusColor = GetThreatStatusColor
local UnitExists = UnitExists
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local InCombatLockdown = InCombatLockdown
local UnitPhaseReason = UnitPhaseReason
-- local UnitBuff = UnitBuff
-- local UnitDebuff = UnitDebuff
local GetAuraDataByAuraInstanceID = C_UnitAuras.GetAuraDataByAuraInstanceID
local IsInRaid = IsInRaid
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local barAnimationType, highlightEnabled, predictionEnabled, absorbEnabled, shieldEnabled, overshieldEnabled

-------------------------------------------------
-- unit button func declarations
-------------------------------------------------
local UnitButton_UpdateAll
local UnitButton_UpdateAuras, UnitButton_UpdateRole, UnitButton_UpdateLeader, UnitButton_UpdateStatusIcon, UnitButton_UpdateStatusText
local UnitButton_UpdateHealthColor, UnitButton_UpdateNameColor
local UnitButton_UpdatePowerMax, UnitButton_UpdatePower, UnitButton_UpdatePowerType

-------------------------------------------------
-- unit button init indicators
-------------------------------------------------
local indicatorsInitialized
local enabledIndicators, indicatorNums, indicatorCustoms, indicatorShowDuplicates = {}, {}, {}, {}

local function UpdateIndicatorParentVisibility(b, indicatorName, enabled)
    if not (indicatorName == "debuffs" or indicatorName == "defensiveCooldowns" or indicatorName == "externalCooldowns" or indicatorName == "allCooldowns" or indicatorName == "dispels") then
        return
    end

    if enabled then
        b.indicators[indicatorName]:Show()
    else
        b.indicators[indicatorName]:Hide()
    end
end

local function UpdateIndicators(layout, indicatorName, setting, value, value2)
    if layout and layout ~= Cell.vars.currentLayout then return end

    F:Debug("|cffff7777UpdateIndicators:|r ", layout, indicatorName, setting, value, value2)
    if not indicatorName then -- init
        wipe(enabledIndicators)
        wipe(indicatorNums)

        for _, t in pairs(Cell.vars.currentLayoutTable["indicators"]) do
            -- update enabled
            if t["enabled"] then
                enabledIndicators[t["indicatorName"]] = true
            end
            -- update num
            if t["num"] then
                indicatorNums[t["indicatorName"]] = t["num"]
            end
            -- update aoehealing
            if t["indicatorName"] == "aoeHealing" then
                I:EnableAoEHealing(t["enabled"])
            end
            -- update targetCounter
            if t["indicatorName"] == "targetCounter" then
                I:EnableTargetCounter(t["enabled"])
            end
            -- update targetedSpells
            if t["indicatorName"] == "targetedSpells" then
                I:EnableTargetedSpells(t["enabled"])
            end
            -- update consumables
            if t["indicatorName"] == "consumables" then
                I:EnableConsumables(t["enabled"])
            end
            -- update healthThresholds
            if t["indicatorName"] == "healthThresholds" then
                I:UpdateHealthThresholds()
            end
            -- update custom
            if t["dispellableByMe"] ~= nil then
                indicatorCustoms[t["indicatorName"]] = t["dispellableByMe"]
            end
            -- if t["castByMe"] ~= nil then
            --     indicatorCustoms[t["indicatorName"]] = t["castByMe"]
            -- end
            if t["hideFull"] ~= nil then
                indicatorCustoms[t["indicatorName"]] = t["hideFull"]
            end
            if t["onlyShowTopGlow"] ~= nil then
                indicatorCustoms[t["indicatorName"]] = t["onlyShowTopGlow"]
            end
            if t["showDuplicate"] ~= nil then
                indicatorShowDuplicates[t["indicatorName"]] = t["showDuplicate"]
            end
        end

        -- update indicators
        F:IterateAllUnitButtons(function(b)
            -- NOTE: Remove old
            I:RemoveAllCustomIndicators(b)

            for _, t in pairs(Cell.vars.currentLayoutTable["indicators"]) do
                local indicator = b.indicators[t["indicatorName"]] or I:CreateIndicator(b, t)
                -- update position
                if t["position"] then
                    P:ClearPoints(indicator)
                    P:Point(indicator, t["position"][1], b, t["position"][2], t["position"][3], t["position"][4])
                end
                -- update anchor
                if t["anchor"] then
                    indicator:SetAnchor(t["anchor"])
                end
                -- update frameLevel
                if t["frameLevel"] then
                    indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+t["frameLevel"])
                end
                -- update size
                if t["size"] then
                    -- NOTE: debuffs: ["size"] = {{normalSize}, {bigSize}}
                    if t["indicatorName"] == "debuffs" then
                        indicator:SetSize(t["size"][1], t["size"][2])
                    else
                        P:Size(indicator, t["size"][1], t["size"][2])
                    end
                end
                -- update thickness
                if t["thickness"] then
                    indicator:SetThickness(t["thickness"])
                end
                -- update border
                if t["border"] then
                    indicator:SetBorder(t["border"])
                end
                -- update height
                if t["height"] then
                    P:Height(indicator, t["height"])
                end
                -- update height
                if t["textWidth"] then
                    indicator:UpdateTextWidth(t["textWidth"])
                end
                -- update alpha
                if t["alpha"] then
                    indicator:SetAlpha(t["alpha"])
                end
                -- update orientation
                if t["orientation"] then
                    indicator:SetOrientation(t["orientation"])
                end
                -- update font
                if t["font"] then
                    indicator:SetFont(unpack(t["font"]))
                end
                -- update format
                if t["format"] then
                    indicator:SetFormat(t["format"])
                    b.func.UpdateHealthText()
                end
                -- update color
                if t["color"] then
                    indicator:SetColor(unpack(t["color"]))
                end
                -- update colors
                if t["colors"] then
                    indicator:SetColors(t["colors"])
                end
                -- update texture
                if t["texture"] then
                    indicator:SetTexture(t["texture"])
                end
                -- update dispel highlight
                if t["highlightType"] then
                    indicator:UpdateHighlight(t["highlightType"])
                end
                -- update dispel icons
                if type(t["showDispelTypeIcons"]) == "boolean" then
                    indicator:ShowIcons(t["showDispelTypeIcons"])
                end
                -- update duration
                if type(t["showDuration"]) == "boolean" then
                    indicator:ShowDuration(t["showDuration"])
                end
                -- update duration
                if t["duration"] then
                    indicator:SetDuration(t["duration"])
                end
                -- update circled nums
                if type(t["circledStackNums"]) == "boolean" then
                    indicator:SetCircledStackNums(t["circledStackNums"])
                end
                -- update groupNumber
                if type(t["showGroupNumber"]) == "boolean" then
                    indicator:ShowGroupNumber(t["showGroupNumber"])
                end
                -- update vehicleNamePosition
                if t["vehicleNamePosition"] then
                    indicator:UpdateVehicleNamePosition(t["vehicleNamePosition"])
                end
                -- update role texture
                if t["roleTexture"] then
                    indicator:SetRoleTexture(t["roleTexture"])
                    indicator:HideDamager(t["hideDamager"])
                    UnitButton_UpdateRole(b)
                end
                -- tooltip
                if type(t["showTooltip"]) == "boolean" then
                    indicator:ShowTooltip(t["showTooltip"])
                end
                -- speed
                if t["speed"] then
                    indicator:SetSpeed(t["speed"])
                end

                -- init
                -- update name visibility
                if t["indicatorName"] == "nameText" then
                    if t["enabled"] then
                        indicator:Show()
                    else
                        indicator:Hide()
                    end
                elseif t["indicatorName"] == "playerRaidIcon" then
                    b.func.UpdatePlayerRaidIcon(t["enabled"])
                elseif t["indicatorName"] == "targetRaidIcon" then
                    b.func.UpdateTargetRaidIcon(t["enabled"])
                else
                    UpdateIndicatorParentVisibility(b, t["indicatorName"], t["enabled"])
                end
            
                --! update pixel perfect for built-in widgets
                if t["type"] == "built-in" then
                    if indicator.UpdatePixelPerfect then
                        indicator:UpdatePixelPerfect() 
                    end
                end
            end
            
            --! update pixel perfect for widgets
            b.func.UpdatePixelPerfect()
        end, indicatorsInitialized) -- -- NOTE: indicatorsInitialized = false, update ALL GROUP TYPE; indicatorsInitialized = true, just update CURRENT GROUP TYPE
        indicatorsInitialized = true
    else
        -- changed in IndicatorsTab
        if setting == "enabled" then
            enabledIndicators[indicatorName] = value

            if indicatorName == "aoeHealing" then
                I:EnableAoEHealing(value)
            elseif indicatorName == "targetCounter" then
                I:EnableTargetCounter(value)
            elseif indicatorName == "targetedSpells" then
                I:EnableTargetedSpells(value)
            elseif indicatorName == "consumables" then
                I:EnableConsumables(value)
            elseif indicatorName == "roleIcon" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateRole(b)
                end, true)
            elseif indicatorName == "leaderIcon" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateLeader(b)
                end, true)
            elseif indicatorName == "playerRaidIcon" then
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdatePlayerRaidIcon(value)
                end, true)
            elseif indicatorName == "targetRaidIcon" then
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateTargetRaidIcon(value)
                end, true)
            elseif indicatorName == "nameText" then
                F:IterateAllUnitButtons(function(b)
                    if value then
                        b.indicators[indicatorName]:Show()
                    else
                        b.indicators[indicatorName]:Hide()
                    end
                end, true)
            elseif indicatorName == "statusText" then
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateStatusText()
                end, true)
            elseif indicatorName == "healthText" then
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateHealthText()
                end, true)
            elseif indicatorName == "shieldBar" then
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateShield()
                end, true)
            elseif indicatorName == "healthThresholds" then
                if value then
                    I:UpdateHealthThresholds()
                end
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateHealth(b)
                end, true)
            else
                -- refresh
                F:IterateAllUnitButtons(function(b)
                    UpdateIndicatorParentVisibility(b, indicatorName, value)
                    if not value then
                        b.indicators[indicatorName]:Hide() -- hide indicators which is shown right now
                    end
                    UnitButton_UpdateAuras(b)
                end, true)
            end
        elseif setting == "position" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:ClearPoints(indicator)
                P:Point(indicator, value[1], b, value[2], value[3], value[4])
            end, true)
        elseif setting == "anchor" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetAnchor(value)
            end, true)
        elseif setting == "frameLevel" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+value)
            end, true)
        elseif setting == "size" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                if indicatorName == "debuffs" then
                    indicator:SetSize(value[1], value[2])
                    -- update debuffs' normal/big icon sizes
                    UnitButton_UpdateAuras(b)
                else
                    P:Size(indicator, value[1], value[2])
                end
            end, true)
        elseif setting == "size-border" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:Size(indicator, value[1], value[2])
                indicator:SetBorder(value[3])
            end, true)
        elseif setting == "thickness" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetThickness(value)
            end, true)
        elseif setting == "height" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:Height(indicator, value)
            end, true)
        elseif setting == "textWidth" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:UpdateTextWidth(value)
            end, true)
        elseif setting == "alpha" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetAlpha(value)
            end, true)
        elseif setting == "orientation" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetOrientation(value)
            end, true)
        elseif setting == "font" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFont(unpack(value))
            end, true)
        elseif setting == "format" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFormat(value)
                b.func.UpdateHealthText()
            end, true)
        elseif setting == "color" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetColor(unpack(value))
            end, true)
        elseif setting == "colors" then --! NOTE: for customColors。 其他的colors不调用widget.func，不发出通知，因为这些指示器都使用OnUpdate更新颜色。
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetColors(value)
            end, true)
        elseif setting == "nameColor" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateNameColor(b)
            end, true)
        elseif setting == "vehicleNamePosition" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:UpdateVehicleNamePosition(value)
            end, true)
        elseif setting == "statusColors" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateStatusText(b)
            end, true)
        elseif setting == "num" then
            indicatorNums[indicatorName] = value
            -- refresh
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "roleTexture" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetRoleTexture(value)
                UnitButton_UpdateRole(b)
            end, true)
        elseif setting == "texture" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetTexture(value)
            end, true)
        elseif setting == "duration" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "highlightType" then
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:UpdateHighlight(value)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "thresholds" then
            I:UpdateHealthThresholds()
            F:IterateAllUnitButtons(function(b)
                b.func.UpdateHealth(b)
            end, true)
        elseif setting == "checkbutton" then
            if value == "showGroupNumber" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowGroupNumber(value2)
                end, true)
            elseif value == "hideFull" then
                --! 血量文字指示器需要立即被刷新
                indicatorCustoms[indicatorName] = value2
                F:IterateAllUnitButtons(function(b)
                    b.func.UpdateHealthText()
                end, true)
            elseif value == "showDispelTypeIcons" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowIcons(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showDuration" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowDuration(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showTooltip" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowTooltip(value2)
                end, true)
            elseif value == "circledStackNums" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:SetCircledStackNums(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "hideDamager" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:HideDamager(value2)
                    UnitButton_UpdateRole(b)
                end, true)
            elseif value == "showDuplicate" then
                indicatorShowDuplicates[indicatorName] = value2
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateAuras(b)
                end, true)
            else
                indicatorCustoms[indicatorName] = value2
            end
        elseif setting == "create" then
            F:IterateAllUnitButtons(function(b)
                local indicator = I:CreateIndicator(b, value)
                -- update position
                if value["position"] then
                    P:ClearPoints(indicator)
                    P:Point(indicator, value["position"][1], b, value["position"][2], value["position"][3], value["position"][4])
                end
                -- update anchor
                if value["anchor"] then
                    indicator:SetAnchor(value["anchor"])
                end
                -- update size
                if value["size"] then
                    P:Size(indicator, value["size"][1], value["size"][2])
                end
                -- update size
                if value["frameLevel"] then
                    indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+value["frameLevel"])
                end
                -- update orientation
                if value["orientation"] then
                    indicator:SetOrientation(value["orientation"])
                end
                -- update font
                if value["font"] then
                    indicator:SetFont(unpack(value["font"]))
                end
                -- update color
                if value["color"] then
                    indicator:SetColor(unpack(value["color"]))
                end
                -- update colors
                if value["colors"] then
                    indicator:SetColors(value["colors"])
                end
                -- update texture
                if value["texture"] then
                    indicator:SetTexture(value["texture"])
                end
                -- update showDuration
                if value["showDuration"] then
                    indicator:ShowDuration(value["showDuration"])
                end
                -- update duration
                if value["duration"] then
                    indicator:SetDuration(value["duration"])
                end
                -- FirstRun: Healers
                if value["auras"] and #value["auras"] ~= 0 then
                    UnitButton_UpdateAuras(b)
                end
            end, true)
        elseif setting == "remove" then
            F:IterateAllUnitButtons(function(b)
                I:RemoveIndicator(b, indicatorName, value)
            end, true)
        elseif setting == "auras" then
            -- indicator auras changed, hide them all, then recheck whether to show
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:Hide()
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "blacklist" or setting == "customDefensives" or setting == "customExternals" or setting == "bigDebuffs" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "speed" then
            -- only Consumables indicator has this option for now
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:SetSpeed(value)
            end, true)
        end
    end
end
Cell:RegisterCallback("UpdateIndicators", "UnitButton_UpdateIndicators", UpdateIndicators)

-------------------------------------------------
-- unit button
-------------------------------------------------
--[[
unitButton = {
    state = {
        class, color, inRange, isAssistant, isLeader, name, role,
        unit, displayedUnit, health, healthMax, healthPercent, powerType
    },
    widget = {
        background, mouseoverHighlight, targetHighlight, readyCheckHighlight,
        healthBar, healthBarBackground, absorbsBar, shieldBar, incomingHeal, damageFlashTex, overShieldGlow,
        powerBar, powerBarBackground,
        statusTextFrame, statusText, timerText
        overlayFrame, nameText
        aggroBlink, leaderIcon, statusIcon, readyCheckIcon, roleIcon,
    },
    func = {
        ShowFlash, HideFlash,
        ShowTimer, HideTimer, UpdateTimer,
    },
    indicators = {},
    updateRequired,
    __updateElapsed,
}
]]

-------------------------------------------------
-- auras
-------------------------------------------------
-- NOTE: Weakened Soul has been removed in Dragonflight
-- won't show if not a priest, otherwise show mine only
-- local function FilterWeakenedSoul(spellId, caster)
--     if spellId ~= 6788 then return true end

--     if not Cell.vars.playerClassID == 5 then return end
--     return caster == "player"
-- end

-- cleuAuras
local cleuUnits = {}

local debuffs_indices = {} -- tooltips
local debuffs_current = {}
local debuffs_cache = {}
local debuffs_cache_count = {}
local debuffs_normal = {}
local debuffs_big = {}
local debuffs_dispel = {}
local debuffs_raid = {} -- store raid debuffs auraInstanceID
local debuffs_raid_refreshing = {} -- store raid debuffs refreshing status ([auraInstanceID] = refreshing)
local debuffs_raid_orders = {} -- store raid debuffs orders ([auraInstanceID] = order)
local debuffs_glowing_current = {}
local debuffs_glowing_cache = {}
local function UnitButton_UpdateDebuffs(self)
    local unit = self.state.displayedUnit

    if not debuffs_indices[unit] then debuffs_indices[unit] = {} end
    if not debuffs_current[unit] then debuffs_current[unit] = {} end
    if not debuffs_cache[unit] then debuffs_cache[unit] = {} end
    if not debuffs_cache_count[unit] then debuffs_cache_count[unit] = {} end
    if not debuffs_normal[unit] then debuffs_normal[unit] = {} end
    if not debuffs_big[unit] then debuffs_big[unit] = {} end
    if not debuffs_dispel[unit] then debuffs_dispel[unit] = {} end
    if not debuffs_raid[unit] then debuffs_raid[unit] = {} end
    if not debuffs_raid_refreshing[unit] then debuffs_raid_refreshing[unit] = {} end
    if not debuffs_raid_orders[unit] then debuffs_raid_orders[unit] = {} end
    if not debuffs_glowing_current[unit] then debuffs_glowing_current[unit] = {} end
    if not debuffs_glowing_cache[unit] then debuffs_glowing_cache[unit] = {} end
    self.state.BGOrb = nil

    -- user created indicators
    I:ResetCustomIndicators(self, "debuff")

    local startIndex, resurrectionFound, raidDebuffsFound = 1
    local glowType, glowOptions
    local refreshing, countIncreased, justApplied
    local index = 0

    AuraUtil.ForEachAura(unit, "HARMFUL", nil, function(auraInfo)
        local auraInstanceID = auraInfo.auraInstanceID
        local name = auraInfo.name
        local icon = auraInfo.icon
        local count = auraInfo.applications
        local debuffType = auraInfo.isHarmful and auraInfo.dispelName
        local expirationTime = auraInfo.expirationTime or 0
        local start = expirationTime - auraInfo.duration
        local duration = auraInfo.duration
        local source = auraInfo.sourceUnit
        local spellId = auraInfo.spellId
        -- local attribute = auraInfo.points[1] -- UnitAura:arg16

        index = index + 1
        debuffs_indices[unit][auraInstanceID] = index
        
        if duration then
            if Cell.vars.iconAnimation == "duration" then
                justApplied = debuffs_cache[unit][auraInstanceID] and (debuffs_cache[unit][auraInstanceID] < expirationTime) or false
                countIncreased = debuffs_cache_count[unit][auraInstanceID] and (count > debuffs_cache_count[unit][auraInstanceID]) or false
                refreshing = justApplied or countIncreased
            elseif Cell.vars.iconAnimation == "stack" then
                refreshing = debuffs_cache_count[unit][auraInstanceID] and (count > debuffs_cache_count[unit][auraInstanceID]) or false
            else
                refreshing = false
            end

            debuffs_current[unit][auraInstanceID] = true
            debuffs_cache[unit][auraInstanceID] = expirationTime
            debuffs_cache_count[unit][auraInstanceID] = count

            if enabledIndicators["debuffs"] and duration <= 600 and not Cell.vars.debuffBlacklist[spellId] then
                -- all debuffs / only dispellableByMe
                if not indicatorCustoms["debuffs"] or I:CanDispel(debuffType) then 
                    -- debuffs, may contain topDebuff
                    if startIndex <= indicatorNums["debuffs"]+indicatorNums["raidDebuffs"] then
                        startIndex = startIndex + 1
                        if Cell.vars.bigDebuffs[spellId] then
                            debuffs_big[unit][auraInstanceID] = refreshing
                        else
                            debuffs_normal[unit][auraInstanceID] = refreshing
                        end
                    end
                end
            end
            
            -- user created indicators
            I:UpdateCustomIndicators(self, auraInfo)

            -- prepare raidDebuffs
            local order = I:GetDebuffOrder(name, spellId, count)
            if enabledIndicators["raidDebuffs"] and order then
                raidDebuffsFound = true
                tinsert(debuffs_raid[unit], auraInstanceID)
                debuffs_raid_refreshing[unit][auraInstanceID] = refreshing
                debuffs_raid_orders[unit][auraInstanceID] = order

                if not indicatorCustoms["raidDebuffs"] then -- glow all
                    glowType, glowOptions = I:GetDebuffGlow(name, spellId, count)
                    if glowType and glowType ~= "None" then
                        debuffs_glowing_current[unit][glowType] = glowOptions
                        debuffs_glowing_cache[unit][glowType] = true
                    end
                end
            end

            if enabledIndicators["dispels"] and debuffType and debuffType ~= "" then
                -- all dispels / only dispellableByMe
                if not indicatorCustoms["dispels"] or I:CanDispel(debuffType) then
                    debuffs_dispel[unit][debuffType] = true
                end
            end

            -- resurrectionIcon
            if spellId == 160029 then
                resurrectionFound = true
                self.indicators.resurrectionIcon:SetTimer(start, duration)
            end

            -- BG orbs
            if spellId == 121164 then
                self.state.BGOrb = "blue"
            elseif spellId == 121175 then
                self.state.BGOrb = "purple"
            elseif spellId == 121176 then
                self.state.BGOrb = "green"
            elseif spellId == 121177 then
                self.state.BGOrb = "orange"
            end
        end
    end, true)
    
    -- update statusIcon
    UnitButton_UpdateStatusIcon(self)

    if not resurrectionFound then
        self.indicators.resurrectionIcon:Hide()
    end

    -- update raid debuffs
    if raidDebuffsFound or cleuUnits[unit] then
        startIndex = 1
        self.indicators.raidDebuffs:Show()

        -- cleuAuras
        local offset = 0
        if cleuUnits[unit] then
            offset = 1
            startIndex = startIndex + 1
        end

        -- sort indices
        -- NOTE: debuffs_raid_orders[unit] = { [auraInstanceID] = debuffOrder } used for sorting
        table.sort(debuffs_raid[unit], function(a, b)
            return debuffs_raid_orders[unit][a] < debuffs_raid_orders[unit][b]
        end)
        wipe(debuffs_raid_orders[unit])
        
        -- show
        local topGlowType, topGlowOptions
        for i = 1+offset, indicatorNums["raidDebuffs"] do
            if debuffs_raid[unit][i] then -- debuffs_raid[unit][i] -> auraInstanceID
                local auraInfo = GetAuraDataByAuraInstanceID(unit, debuffs_raid[unit][i])
                if auraInfo then
                    self.indicators.raidDebuffs[i]:SetCooldown((auraInfo.expirationTime or 0) - auraInfo.duration, auraInfo.duration, auraInfo.dispelName or "", auraInfo.icon, auraInfo.applications, debuffs_raid_refreshing[unit][debuffs_raid[unit][i]])
                    self.indicators.raidDebuffs[i].index = debuffs_indices[unit][debuffs_raid[unit][i]] -- NOTE: for tooltip
                    startIndex = startIndex + 1
                    -- use debuffs_raid_orders(wiped before) to store debuffs indices shown by raidDebuffs indicator
                    debuffs_raid_orders[unit][debuffs_raid[unit][i]] = true

                    if i == 1 then -- top
                        topGlowType, topGlowOptions = I:GetDebuffGlow(auraInfo.name, auraInfo.spellId, auraInfo.applications)
                    end
                end
            end
        end

        if cleuUnits[unit] then
            self.indicators.raidDebuffs[1]:SetCooldown(cleuUnits[unit][1], cleuUnits[unit][2], "cleu", cleuUnits[unit][3], 1)
            topGlowType, topGlowOptions = unpack(CellDB["cleuGlow"])
        end

        -- update raidDebuffs
        if startIndex > 1 then
            self.indicators.raidDebuffs:UpdateSize(startIndex - 1)
        end
        for i = startIndex, 3 do
            self.indicators.raidDebuffs[i]:Hide()
            self.indicators.raidDebuffs[i].index = nil
        end

        -- update glow
        if not indicatorCustoms["raidDebuffs"] then
            if topGlowType and topGlowType ~= "None" then
                -- to make sure top glow has highest priority
                debuffs_glowing_current[unit][topGlowType] = topGlowOptions
            end
            for t, o in pairs(debuffs_glowing_current[unit]) do
                self.indicators.raidDebuffs:ShowGlow(t, o, true)
            end
            for t, _ in pairs(debuffs_glowing_cache[unit]) do
                if not debuffs_glowing_current[unit][t] then
                    self.indicators.raidDebuffs:HideGlow(t)
                    debuffs_glowing_cache[unit][t] = nil
                end
            end
            wipe(debuffs_glowing_current[unit])
        else
            self.indicators.raidDebuffs:ShowGlow(topGlowType, topGlowOptions)
        end
    else
        self.indicators.raidDebuffs:Hide()
    end

    -- update debuffs
    startIndex = 1
    if enabledIndicators["debuffs"] then
        -- bigDebuffs first
        for auraInstanceID, refreshing in pairs(debuffs_big[unit]) do
            local auraInfo = GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            if auraInfo and (indicatorShowDuplicates["debuffs"] or not debuffs_raid_orders[unit][auraInstanceID]) and startIndex <= indicatorNums["debuffs"] then
                -- start, duration, debuffType, texture, count
                self.indicators.debuffs[startIndex]:SetCooldown((auraInfo.expirationTime or 0) - auraInfo.duration, auraInfo.duration, auraInfo.dispelName or "", auraInfo.icon, auraInfo.applications, refreshing, true)
                self.indicators.debuffs[startIndex].index = debuffs_indices[unit][auraInstanceID] -- NOTE: for tooltip
                self.indicators.debuffs[startIndex].isBigDebuff = true
                startIndex = startIndex + 1
            end
        end
        -- then normal debuffs
        for auraInstanceID, refreshing in pairs(debuffs_normal[unit]) do
            local auraInfo = GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            if auraInfo and (indicatorShowDuplicates["debuffs"] or not debuffs_raid_orders[unit][auraInstanceID]) and startIndex <= indicatorNums["debuffs"] then
                -- start, duration, debuffType, texture, count
                self.indicators.debuffs[startIndex]:SetCooldown((auraInfo.expirationTime or 0) - auraInfo.duration, auraInfo.duration, auraInfo.dispelName or "", auraInfo.icon, auraInfo.applications, refreshing)
                self.indicators.debuffs[startIndex].index = debuffs_indices[unit][auraInstanceID] -- NOTE: for tooltip
                self.indicators.debuffs[startIndex].isBigDebuff = false
                startIndex = startIndex + 1
            end
        end
    end

    -- update debuffs
    if startIndex > 1 then
        self.indicators.debuffs:UpdateSize()
    end
    for i = startIndex, 10 do
        self.indicators.debuffs[i]:Hide()
        self.indicators.debuffs[i].index = nil
        self.indicators.debuffs[i].isBigDebuff = nil
    end

    -- update dispels
    self.indicators.dispels:SetDispels(debuffs_dispel[unit])

    -- user created indicators
    I:ShowCustomIndicators(self, "debuff")

    -- update debuffs_cache
    for spellId, expirationTime in pairs(debuffs_cache[unit]) do
        -- lost or expired
        if not debuffs_current[unit][spellId] or (expirationTime ~= 0 and GetTime() >= expirationTime) then -- expirationTime == 0: no duration 
            debuffs_cache[unit][spellId] = nil
            debuffs_cache_count[unit][spellId] = nil
        end
    end

    wipe(debuffs_indices[unit])
    wipe(debuffs_current[unit])
    wipe(debuffs_normal[unit])
    wipe(debuffs_big[unit])
    wipe(debuffs_dispel[unit])
    wipe(debuffs_raid[unit])
    wipe(debuffs_raid_refreshing[unit])
    wipe(debuffs_raid_orders[unit])
end

local buffs_current = {}
local buffs_cache = {}
local buffs_cache_count = {}
local buffs_mirror_image = {}
local function UnitButton_UpdateBuffs(self)
    local unit = self.state.displayedUnit
    
    if not buffs_cache[unit] then buffs_cache[unit] = {} end
    if not buffs_cache_count[unit] then buffs_cache_count[unit] = {} end
    if not buffs_current[unit] then buffs_current[unit] = {} end
    self.state.BGFlag = nil
    
    -- user created indicators
    I:ResetCustomIndicators(self, "buff")

    local refreshing, countIncreased, justApplied
    local defensiveFound, externalFound, allFound, tankActiveMitigationFound, drinkingFound = 0, 0, 0, false, false
    
    AuraUtil.ForEachAura(unit, "HELPFUL", nil, function(auraInfo)
        local auraInstanceID = auraInfo.auraInstanceID
        local name = auraInfo.name
        local icon = auraInfo.icon
        local count = auraInfo.applications
        local debuffType = auraInfo.isHarmful and auraInfo.dispelName
        local expirationTime = auraInfo.expirationTime or 0
        local start = expirationTime - auraInfo.duration
        local duration = auraInfo.duration
        local source = auraInfo.sourceUnit
        local spellId = auraInfo.spellId
        local attribute = auraInfo.points[1] -- UnitAura:arg16

        if duration then
            if Cell.vars.iconAnimation == "duration" then
                justApplied = buffs_cache[unit][auraInstanceID] and (buffs_cache[unit][auraInstanceID] < expirationTime) or false
                countIncreased = buffs_cache_count[unit][auraInstanceID] and (count > buffs_cache_count[unit][auraInstanceID]) or false
                refreshing = justApplied or countIncreased
            elseif Cell.vars.iconAnimation == "stack" then
                refreshing = buffs_cache_count[unit][auraInstanceID] and (count > buffs_cache_count[unit][auraInstanceID]) or false
            else
                refreshing = false
            end
        
            buffs_current[unit][auraInstanceID] = true
            buffs_cache[unit][auraInstanceID] = expirationTime
            buffs_cache_count[unit][auraInstanceID] = count
        
            -- defensiveCooldowns
            if enabledIndicators["defensiveCooldowns"] and (I:IsDefensiveCooldown(name) or I:IsDefensiveCooldown(spellId)) and defensiveFound < indicatorNums["defensiveCooldowns"] then
                defensiveFound = defensiveFound + 1
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.defensiveCooldowns[defensiveFound]:SetCooldown(start, duration, nil, icon, count, refreshing)
            end

            -- externalCooldowns
            if enabledIndicators["externalCooldowns"] and I:IsExternalCooldown(name, source, unit) and externalFound < indicatorNums["externalCooldowns"] then
                externalFound = externalFound + 1
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.externalCooldowns[externalFound]:SetCooldown(start, duration, nil, icon, count, refreshing)
            end

            -- allCooldowns
            if enabledIndicators["allCooldowns"] and (I:IsExternalCooldown(name, source, unit) or I:IsDefensiveCooldown(name) or I:IsDefensiveCooldown(spellId)) and allFound < indicatorNums["allCooldowns"] then
                allFound = allFound + 1
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.allCooldowns[allFound]:SetCooldown(start, duration, nil, icon, count, refreshing)
            end

            -- tankActiveMitigation
            if enabledIndicators["tankActiveMitigation"] and I:IsTankActiveMitigation(name) then
                self.indicators.tankActiveMitigation:SetCooldown(start, duration)
                tankActiveMitigationFound = true
            end

            -- drinking
            if enabledIndicators["statusText"] and I:IsDrinking(name) then
                if not self.indicators.statusText:GetStatus() then
                    self.indicators.statusText:SetStatus("DRINKING")
                    self.indicators.statusText:Show()
                end
                drinkingFound = true
            end

            -- user created indicators
            I:UpdateCustomIndicators(self, auraInfo, refreshing)

            -- check BG flags for statusIcon
            if spellId == 156621 then
                self.state.BGFlag = "alliance"
            elseif spellId == 156618 then
                self.state.BGFlag = "horde"
            end
        end
    end, true)

    -- update statusIcon
    UnitButton_UpdateStatusIcon(self)

    -- check Mirror Image
    if buffs_mirror_image[unit] then
        if defensiveFound < indicatorNums["defensiveCooldowns"] then
            defensiveFound = defensiveFound + 1
            self.indicators.defensiveCooldowns[defensiveFound]:SetCooldown(buffs_mirror_image[unit], 40, nil, 135994, 0)
        end
        if allFound < indicatorNums["allCooldowns"] then
            allFound = allFound + 1
            self.indicators.allCooldowns[allFound]:SetCooldown(buffs_mirror_image[unit], 40, nil, 135994, 0)
        end
    end
    
    -- update defensiveCooldowns
    if defensiveFound > 0 then
        self.indicators.defensiveCooldowns:UpdateSize(defensiveFound)
    end
    for i = defensiveFound + 1, 5 do
        self.indicators.defensiveCooldowns[i]:Hide()
    end
    
    -- update externalCooldowns
    if externalFound > 0 then
        self.indicators.externalCooldowns:UpdateSize(externalFound)
    end
    for i = externalFound + 1, 5 do
        self.indicators.externalCooldowns[i]:Hide()
    end
    
    -- update allCooldowns
    if allFound > 0 then
        self.indicators.allCooldowns:UpdateSize(allFound)
    end
    for i = allFound + 1, 5 do
        self.indicators.allCooldowns[i]:Hide()
    end
    
    -- hide tankActiveMitigation
    if not tankActiveMitigationFound then
        self.indicators.tankActiveMitigation:Hide()
    end
    
    -- hide drinking
    if not drinkingFound and self.indicators.statusText:GetStatus() == "DRINKING" then
        self.indicators.statusText:Hide()
        self.indicators.statusText:SetStatus()
    end

    -- user created indicators
    I:ShowCustomIndicators(self, "buff")

    -- update buffs_cache
    for auraInstanceID, expirationTime in pairs(buffs_cache[unit]) do
        -- lost or expired
        if not buffs_current[unit][auraInstanceID] or (expirationTime ~= 0 and GetTime() >= expirationTime) then
            buffs_cache[unit][auraInstanceID] = nil
            buffs_cache_count[unit][auraInstanceID] = nil
        end
    end
    wipe(buffs_current[unit])
end

local function ResetAuraTables(unit)
    -- reset debuffs
    if debuffs_indices[unit] then wipe(debuffs_indices[unit]) end
    if debuffs_current[unit] then wipe(debuffs_current[unit]) end
    if debuffs_cache[unit] then wipe(debuffs_cache[unit]) end
    if debuffs_cache_count[unit] then wipe(debuffs_cache_count[unit]) end
    if debuffs_normal[unit] then wipe(debuffs_normal[unit]) end
    if debuffs_big[unit] then wipe(debuffs_big[unit]) end
    if debuffs_dispel[unit] then wipe(debuffs_dispel[unit]) end
    if debuffs_glowing_current[unit] then wipe(debuffs_glowing_current[unit]) end
    if debuffs_glowing_cache[unit] then wipe(debuffs_glowing_cache[unit]) end
    if debuffs_raid[unit] then wipe(debuffs_raid[unit]) end
    if debuffs_raid_refreshing[unit] then wipe(debuffs_raid_refreshing[unit]) end
    if debuffs_raid_orders[unit] then wipe(debuffs_raid_orders[unit]) end
    -- reset buffs
    if buffs_current[unit] then wipe(buffs_current[unit]) end
    if buffs_cache[unit] then wipe(buffs_cache[unit]) end
    if buffs_cache_count[unit] then wipe(buffs_cache_count[unit]) end
    -- reset
    buffs_mirror_image[unit] = nil
    cleuUnits[unit] = nil
end

-------------------------------------------------
-- check auras using CLEU
-------------------------------------------------
local cleu = CreateFrame("Frame")
cleu:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
cleu:SetScript("OnEvent", function()
    local _, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
    -- mirror image
    if spellId == 55342 and F:IsFriend(sourceFlags) then
        local b1, b2 = F:GetUnitButtonByGUID(sourceGUID)
        if subEvent == "SPELL_AURA_APPLIED" then
            if b1 and b1.state.unit then
                buffs_mirror_image[b1.state.unit] = GetTime()
            end
            if b2 and b2.state.unit then
                buffs_mirror_image[b2.state.unit] = GetTime()
            end
        elseif subEvent == "SPELL_AURA_REMOVED" then
            if b1 and b1.state.unit then
                buffs_mirror_image[b1.state.unit] = nil
            end
            if b2 and b2.state.unit then
                buffs_mirror_image[b2.state.unit] = nil
            end
        end
    end
    -- CLEU auras
    if I:CheckCleuAura(spellId) and F:IsFriend(destFlags) then
        local b1, b2 = F:GetUnitButtonByGUID(sourceGUID)
        if subEvent == "SPELL_AURA_APPLIED" then
            if b1 and b1.state.unit then
                cleuUnits[b1.state.unit] = {GetTime(), unpack(I:CheckCleuAura(spellId))}
                UnitButton_UpdateDebuffs(b1)
            end
            if b2 and b2.state.unit then
                cleuUnits[b2.state.unit] = {GetTime(), unpack(I:CheckCleuAura(spellId))}
                UnitButton_UpdateDebuffs(b2)
            end
        elseif subEvent == "SPELL_AURA_REMOVED" then
            if b1 and b1.state.unit then
                cleuUnits[b1.state.unit] = nil
                UnitButton_UpdateDebuffs(b1)
            end
            if b2 and b2.state.unit then
                cleuUnits[b2.state.unit] = nil
                UnitButton_UpdateDebuffs(b2)
            end
        end
    end
end)

-------------------------------------------------
-- functions
-------------------------------------------------
UnitButton_UpdateAuras = function(self, updatedAuras)
    if not indicatorsInitialized then return end

    local unit = self.state.displayedUnit
    if not unit then return end

    UnitButton_UpdateDebuffs(self)
    UnitButton_UpdateBuffs(self)
    --[[
    if not updatedAuras or updatedAuras.isFullUpdate then
        UnitButton_UpdateDebuffs(self)
        UnitButton_UpdateBuffs(self)
        return
    end

    if updatedAuras.removedAuraInstanceIDs then
        -- NOTE: auras removed, rescan
        UnitButton_UpdateDebuffs(self)
        UnitButton_UpdateBuffs(self)
    elseif updatedAuras.addedAuras then
        UnitButton_CheckAddedAuras(self, updatedAuras.addedAuras)
    end
    
    if updatedAuras.updatedAuraInstanceIDs then
        UnitButton_CheckUpdatedAuras(self, updatedAuras.updatedAuraInstanceIDs)
    end
    ]]
end

local function UpdateUnitHealthState(self, diff)
    local unit = self.state.displayedUnit

    local health = UnitHealth(unit) + (diff or 0)
    local healthMax = UnitHealthMax(unit)

    self.state.health = health
    self.state.healthMax = healthMax

    if healthMax == 0 then
        self.state.healthPercent = 0
    else
        self.state.healthPercent = health / healthMax
    end

    self.state.wasDead = self.state.isDead
    self.state.isDead = health == 0
    if self.state.wasDead ~= self.state.isDead then
        UnitButton_UpdateStatusText(self)
    end
    
    self.state.wasDeadOrGhost = self.state.isDeadOrGhost
    self.state.isDeadOrGhost = UnitIsDeadOrGhost(unit)
    if self.state.wasDeadOrGhost ~= self.state.isDeadOrGhost then
        UnitButton_UpdateHealthColor(self)
    end

    if enabledIndicators["healthText"] and healthMax ~= 0 then
        if health == healthMax then
            if not indicatorCustoms["healthText"] then
                self.indicators.healthText:SetHealth(health, healthMax)
                self.indicators.healthText:Show()
            else
                self.indicators.healthText:Hide()
            end
        else
            self.indicators.healthText:SetHealth(health, healthMax)
            self.indicators.healthText:Show()
        end
    else
        self.indicators.healthText:Hide()
    end
end

-------------------------------------------------
-- power filter funcs
-------------------------------------------------
local function GetRole(b)
    if b.state.role and b.state.role ~= "NONE" then
        return b.state.role
    end

    local info = LGI:GetCachedInfo(b.state.guid)
    if not info then return end
    return info.role
end

local function ShouldShowPowerBar(b)
    if not b.state.guid then
        return true
    end

    local class, role
    if b.state.inVehicle then
        class = "VEHICLE"
    elseif string.find(b.state.guid, "^Player") then
        class = b.state.class
        role = GetRole(b)
    elseif string.find(b.state.guid, "^Pet") then
        class = "PET"
    elseif string.find(b.state.guid, "^Creature") then
        class = "NPC"
    elseif string.find(b.state.guid, "^Vehicle") then
        class = "VEHICLE"
    end
    
    if class then
        if type(Cell.vars.currentLayoutTable["powerFilters"][class]) == "boolean" then
            return Cell.vars.currentLayoutTable["powerFilters"][class]
        else
            if role then
                return Cell.vars.currentLayoutTable["powerFilters"][class][role]
            else
                return true -- show power if role not found
            end
        end
    end

    return true
end

local function ShowPowerBar(b, s)
    if b:IsShown() then
        b:RegisterEvent("UNIT_POWER_FREQUENT")
        b:RegisterEvent("UNIT_MAXPOWER")
        b:RegisterEvent("UNIT_DISPLAYPOWER")
    end
    b.widget.powerBar:Show()
    b.widget.powerBarLoss:Show()
    b.widget.gapTexture:Show()

    P:ClearPoints(b.widget.healthBar)
    P:ClearPoints(b.widget.powerBar)
    if b.orientation == "horizontal" then
        P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", 1, -1)
        P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, s + 2)
        P:Point(b.widget.powerBar, "TOPLEFT", b.widget.healthBar, "BOTTOMLEFT", 0, -1)
        P:Point(b.widget.powerBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    else
        P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", 1, -1)
        P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -(s + 2), 1)
        P:Point(b.widget.powerBar, "TOPLEFT", b.widget.healthBar, "TOPRIGHT", 1, 0)
        P:Point(b.widget.powerBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    end

    if b:IsShown() then
        -- update now
        UnitButton_UpdatePowerMax(b)
        UnitButton_UpdatePower(b)
        UnitButton_UpdatePowerType(b)
    end
end

local function HidePowerBar(b)
    b:UnregisterEvent("UNIT_POWER_FREQUENT")
    b:UnregisterEvent("UNIT_MAXPOWER")
    b:UnregisterEvent("UNIT_DISPLAYPOWER")
    b.widget.powerBar:Hide()
    b.widget.powerBarLoss:Hide()
    b.widget.gapTexture:Hide()

    P:ClearPoints(b.widget.healthBar)
    P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", 1, -1)
    P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
end

-- local roleUpdater = CreateFrame("Frame")
-- function roleUpdater:UnitUpdated(event, guid, unit, info)
--     if Cell.vars.currentLayoutTable and Cell.vars.currentLayoutTable["powerSize"] ~= 0 then
--         local b = F:GetUnitButtonByGUID(guid)
--         if not b then return end

--         if ShouldShowPowerBar(b) then
--             ShowPowerBar(b, Cell.vars.currentLayoutTable["powerSize"])
--         else
--             HidePowerBar(b)
--         end
--     end
-- end
-- LGIST.RegisterCallback(roleUpdater, "GroupInSpecT_Update", "UnitUpdated")

-------------------------------------------------
-- unit button functions
-------------------------------------------------
local function UnitButton_UpdateTarget(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    if UnitIsUnit(unit, "target") then
        if highlightEnabled then self.widget.targetHighlight:Show() end
    else
        self.widget.targetHighlight:Hide()
    end
end

UnitButton_UpdateRole = function(self)
    local unit = self.state.unit
    if not unit then return end

    local roleIcon = self.indicators.roleIcon

    if enabledIndicators["roleIcon"] then
        local role = UnitGroupRolesAssigned(unit)
        self.state.role = role

        roleIcon:SetRole(role)
    else
        roleIcon:Hide()
    end
end

UnitButton_UpdateLeader = function(self, event)
    local unit = self.state.unit
    if not unit then return end
    
    local leaderIcon = self.indicators.leaderIcon

    if enabledIndicators["leaderIcon"] then
        if InCombatLockdown() or event == "PLAYER_REGEN_DISABLED" then
            leaderIcon:Hide()
            return
        end

        local isLeader = UnitIsGroupLeader(unit)
        self.state.isLeader = isLeader
        local isAssistant = UnitIsGroupAssistant(unit) and IsInRaid()
        self.state.isAssistant = isAssistant
        
        leaderIcon:SetIcon(isLeader, isAssistant)
    else
        leaderIcon:Hide()
    end
end

local function UnitButton_UpdatePlayerRaidIcon(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local playerRaidIcon = self.indicators.playerRaidIcon

    local index = GetRaidTargetIndex(unit)

    if enabledIndicators["playerRaidIcon"] then
        if index then
            SetRaidTargetIconTexture(playerRaidIcon.tex, index)
            playerRaidIcon:Show()
        else
            playerRaidIcon:Hide()
        end
    else
        playerRaidIcon:Hide()
    end
end

local function UnitButton_UpdateTargetRaidIcon(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local targetRaidIcon = self.indicators.targetRaidIcon

    local index = GetRaidTargetIndex(unit.."target")

    if enabledIndicators["targetRaidIcon"] then
        if index then
            SetRaidTargetIconTexture(targetRaidIcon.tex, index)
            targetRaidIcon:Show()
        else
            targetRaidIcon:Hide()
        end
    else
        targetRaidIcon:Hide()
    end
end

local READYCHECK_STATUS = {
    ready = {t = READY_CHECK_READY_TEXTURE, c = {0, 1, 0, 1}},
    waiting = {t = READY_CHECK_WAITING_TEXTURE, c = {1, 1, 0, 1}},
    notready = {t = READY_CHECK_NOT_READY_TEXTURE, c = {1, 0, 0, 1}},
}
local function UnitButton_UpdateReadyCheck(self)
    local unit = self.state.unit
    if not unit then return end
    
    local status = GetReadyCheckStatus(unit)
    self.state.readyCheckStatus = status

    if status then
        -- self.widget.readyCheckHighlight:SetVertexColor(unpack(READYCHECK_STATUS[status].c))
        -- self.widget.readyCheckHighlight:Show()
        self.indicators.readyCheckIcon:SetTexture(READYCHECK_STATUS[status].t)
        self.indicators.readyCheckIcon:Show()
    else
        -- self.widget.readyCheckHighlight:Hide()
        self.indicators.readyCheckIcon:Hide()
    end
end

local function UnitButton_FinishReadyCheck(self)
    if self.state.readyCheckStatus == "waiting" then
        -- self.widget.readyCheckHighlight:SetVertexColor(unpack(READYCHECK_STATUS.notready.c))
        self.indicators.readyCheckIcon:SetTexture(READYCHECK_STATUS.notready.t)
    end
    C_Timer.After(6, function()
        -- self.widget.readyCheckHighlight:Hide()
        self.indicators.readyCheckIcon:Hide()
    end)
end

UnitButton_UpdatePowerMax = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local value = UnitPowerMax(unit)
    if value > 0 then
        if barAnimationType == "Smooth" then
            self.widget.powerBar:SetMinMaxSmoothedValue(0, value)
        else
            self.widget.powerBar:SetMinMaxValues(0, value)
        end
        self.widget.powerBar:Show()
        self.widget.powerBarLoss:Show()
    else
        self.widget.powerBar:Hide()
        self.widget.powerBarLoss:Hide()
    end
end

UnitButton_UpdatePower = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    if barAnimationType == "Smooth" then
        self.widget.powerBar:SetSmoothedValue(UnitPower(unit))
    else
        self.widget.powerBar:SetValue(UnitPower(unit))
    end
end

UnitButton_UpdatePowerType = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local r, g, b, lossR, lossG, lossB
    local a = Cell.loaded and CellDB["appearance"]["lossAlpha"] or 1

    if not UnitIsConnected(unit) then
        r, g, b = 0.5, 0.5, 0.5
        lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
    else
        r, g, b, lossR, lossG, lossB, self.state.powerType = F:GetPowerColor(unit, self.state.class)
    end

    self.widget.powerBar:SetStatusBarColor(r, g, b)
    self.widget.powerBarLoss:SetVertexColor(lossR, lossG, lossB)
end

local function UnitButton_UpdateHealthMax(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    UpdateUnitHealthState(self)

    if barAnimationType == "Smooth" then
        self.widget.healthBar:SetMinMaxSmoothedValue(0, self.state.healthMax)
    else
        self.widget.healthBar:SetMinMaxValues(0, self.state.healthMax)
    end

    if Cell.vars.useGradientColor then
        UnitButton_UpdateHealthColor(self)
    end
end

local function UnitButton_UpdateHealth(self, diff)
    local unit = self.state.displayedUnit
    if not unit then return end

    UpdateUnitHealthState(self, diff)
    local healthPercent = self.state.healthPercent
    
    if barAnimationType == "Flash" then
        self.widget.healthBar:SetValue(self.state.health)
        local diff = healthPercent - (self.state.healthPercentOld or healthPercent)
        if diff >= 0 then
            self.func.HideFlash()
        elseif diff <= -0.05 and diff >= -1 then --! player (just joined) UnitHealthMax(unit) may be 1 ====> diff == -maxHealth
            self.func.ShowFlash(abs(diff))
        end
    elseif barAnimationType == "Smooth" then
        self.widget.healthBar:SetSmoothedValue(self.state.health)
    else
        self.widget.healthBar:SetValue(self.state.health)
    end

    if Cell.vars.useGradientColor then
        UnitButton_UpdateHealthColor(self)
    end

    self.state.healthPercentOld = healthPercent

    if enabledIndicators["healthThresholds"] then
        self.indicators.healthThresholds:CheckThreshold(healthPercent)
    else
        self.indicators.healthThresholds:Hide()
    end

    if CELL_FADE_OUT_HEALTH_PERCENT then
        if self.state.inRange and healthPercent < CELL_FADE_OUT_HEALTH_PERCENT then
            A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
        else
            A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
        end
    end
end

local function UnitButton_UpdateHealPrediction(self)
    if not predictionEnabled then
        self.widget.incomingHeal:Hide()
        return
    end

    local unit = self.state.displayedUnit
    if not unit then return end

    local value = UnitGetIncomingHeals(unit) or 0
    if value == 0 then 
        self.widget.incomingHeal:Hide()
        return
    end

    UpdateUnitHealthState(self)

    self.widget.incomingHeal:SetValue(value / self.state.healthMax)
end

local function UnitButton_UpdateShieldAbsorbs(self)
    local unit = self.state.displayedUnit
    if not unit then return end
    
    local value = UnitGetTotalAbsorbs(unit)
    if value > 0 then
        UpdateUnitHealthState(self)
        local shieldPercent = value / self.state.healthMax

        if enabledIndicators["shieldBar"] then
            self.indicators.shieldBar:Show()
            self.indicators.shieldBar:SetValue(shieldPercent)
        else
            self.indicators.shieldBar:Hide()
        end
        
        self.widget.shieldBar:SetValue(shieldPercent)
    else
        self.indicators.shieldBar:Hide()
        self.widget.shieldBar:Hide()
        self.widget.overShieldGlow:Hide()
    end
end

local function UnitButton_UpdateHealAbsorbs(self)
    if not absorbEnabled then
        self.widget.absorbsBar:Hide()
        return
    end

    local unit = self.state.displayedUnit
    if not unit then return end
    
    local value = UnitGetTotalHealAbsorbs(unit)
    if value > 0 then
        UpdateUnitHealthState(self)

        local absorbsPercent = value / self.state.healthMax
        if absorbsPercent > self.state.healthPercent then
            absorbsPercent = self.state.healthPercent
        end
        self.widget.absorbsBar:SetValue(absorbsPercent)
    else
        self.widget.absorbsBar:Hide()
    end
end

local function UnitButton_UpdateThreat(self)
    local unit = self.state.displayedUnit
    if not unit or not UnitExists(unit) then return end

    local status = UnitThreatSituation(unit)
    if status and status >= 2 then
        if enabledIndicators["aggroBlink"] then
            self.indicators.aggroBlink:ShowAggro(GetThreatStatusColor(status))
        end
        if enabledIndicators["aggroBorder"] then
            self.indicators.aggroBorder:ShowAggro(GetThreatStatusColor(status))
        end
    else
        self.indicators.aggroBlink:Hide()
        self.indicators.aggroBorder:Hide()
    end
end

local function UnitButton_UpdateThreatBar(self)
    if not enabledIndicators["aggroBar"] then 
        self.indicators.aggroBar:Hide()
        return
    end

    local unit = self.state.displayedUnit
    if not unit or not UnitExists(unit) then return end

    -- isTanking, status, scaledPercentage, rawPercentage, threatValue = UnitDetailedThreatSituation(unit, mobUnit)
    local _, status, scaledPercentage, rawPercentage = UnitDetailedThreatSituation(unit, "target")
    if status then
        self.indicators.aggroBar:Show()
        self.indicators.aggroBar:SetSmoothedValue(scaledPercentage)
        self.indicators.aggroBar:SetStatusBarColor(GetThreatStatusColor(status))
    else
        self.indicators.aggroBar:Hide()
    end
end

local LRC = LibStub:GetLibrary("LibRangeCheck-2.0")
local function UnitButton_UpdateInRange(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local inRange

    if F:UnitInGroup(unit) then
         -- NOTE: UnitInRange only works with group members
        local checked
        inRange, checked = UnitInRange(unit)
        if not checked then
            inRange = UnitIsVisible(unit)
        end
    else
        local minRangeIfVisible, maxRangeIfVisible = LRC:GetRange(unit, true)
        inRange = maxRangeIfVisible and maxRangeIfVisible <= 40
    end

    self.state.inRange = inRange
    if Cell.loaded then
        if self.state.inRange ~= self.state.wasInRange then
            if inRange then
                if CELL_FADE_OUT_HEALTH_PERCENT then
                    if not self.state.healthPercent or self.state.healthPercent < CELL_FADE_OUT_HEALTH_PERCENT then
                        A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
                    else
                        A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
                    end
                else
                    A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
                end
            else
                A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
            end
        end
        self.state.wasInRange = inRange
        -- self:SetAlpha(inRange and 1 or CellDB["appearance"]["outOfRangeAlpha"])
    end
end

local function UnitButton_UpdateVehicleStatus(self)
    local unit = self.state.unit
    if not unit then return end

    if UnitHasVehicleUI(unit) then -- or UnitInVehicle(unit) or UnitUsingVehicle(unit) then
        self.state.inVehicle = true
        if unit == "player" then
            self.state.displayedUnit = "vehicle"
        else
            -- local prefix, id, suffix = strmatch(unit, "([^%d]+)([%d]*)(.*)")
            local prefix, id = strmatch(unit, "([^%d]+)([%d]+)")
            self.state.displayedUnit = prefix.."pet"..id
        end
        self.indicators.nameText:UpdateVehicleName()
    else
        self.state.inVehicle = nil
        self.state.displayedUnit = self.state.unit
        self.indicators.nameText.vehicle:SetText("")
    end
    
    if Cell.loaded and Cell.vars.currentLayoutTable["powerSize"] ~= 0 then
        if ShouldShowPowerBar(self) then
            ShowPowerBar(self, Cell.vars.currentLayoutTable["powerSize"])
        else
            HidePowerBar(self)
        end
    end
end

UnitButton_UpdateStatusIcon = function(self)
    local unit = self.state.unit
    if not unit then return end
    
    -- https://wow.gamepedia.com/API_UnitPhaseReason
    local phaseReason = UnitPhaseReason(unit)
    
    local icon = self.indicators.statusIcon
    icon:SetIgnoreParentAlpha(false)
    
    -- Interface\FrameXML\CompactUnitFrame.lua, CompactUnitFrame_UpdateCenterStatusIcon
    if UnitInOtherParty(unit) then
        icon:SetVertexColor(1, 1, 1, 1)
        icon:SetTexture("Interface\\LFGFrame\\LFG-Eye")
        -- icon:SetTexCoord(0.125, 0.25, 0.25, 0.5)
        -- icon:SetTexCoord(0.145, 0.23, 0.29, 0.46)
        icon:SetTexCoord(0.14, 0.235, 0.28, 0.47)
        -- icon:ShowBorder("Interface\\Common\\RingBorder")
        icon:Show()
    elseif UnitHasIncomingResurrection(unit) then
        icon:SetVertexColor(1, 1, 1, 1)
        icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Rez")
        icon:SetTexCoord(0, 1, 0, 1)
        -- icon:HideBorder()
        icon:Show()
    elseif CELL_SUMMON_ICONS_ENABLED and C_IncomingSummon.HasIncomingSummon(unit) then
        local status = C_IncomingSummon.IncomingSummonStatus(unit)
        if status == Enum.SummonStatus.Pending then
            icon:SetAtlas("Raid-Icon-SummonPending")
            icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        elseif status == Enum.SummonStatus.Accepted then
            icon:SetAtlas("Raid-Icon-SummonAccepted")
            icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            C_Timer.After(6, function() UnitButton_UpdateStatusIcon(self) end)
        elseif status == Enum.SummonStatus.Declined then
            icon:SetAtlas("Raid-Icon-SummonDeclined")
            icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            C_Timer.After(6, function() UnitButton_UpdateStatusIcon(self) end)
        end
        icon:Show()
    elseif UnitIsPlayer(unit) and phaseReason and not self.state.inVehicle then
        if phaseReason == 3 then -- chromie, yellow
            icon:SetVertexColor(1, 1, 0)
        elseif phaseReason == 2 then -- warmode, red
            icon:SetVertexColor(1, 0.6, 0.6)
        elseif phaseReason == 1 then -- sharding, green
            icon:SetVertexColor(0.5, 1, 0.5)
        else -- 0, phasing
            icon:SetVertexColor(1, 1, 1)
        end
        icon:SetTexture("Interface\\TargetingFrame\\UI-PhasingIcon")
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        -- icon:HideBorder()
        icon:Show()
    -- elseif UnitIsDeadOrGhost(unit) then
    --     icon:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")
    --     icon:SetTexCoord(0, 1, 0, 1)
    --     icon:Show()
    elseif self.state.BGFlag then
        icon:SetIgnoreParentAlpha(true)
        icon:SetVertexColor(1, 1, 1, 1)
        icon:SetAtlas("nameplates-icon-flag-"..self.state.BGFlag)
        icon:SetTexCoord(0, 1, 0, 1)
        -- icon:HideBorder()
        icon:Show()
    elseif self.state.BGOrb then
        icon:SetIgnoreParentAlpha(true)
        icon:SetVertexColor(1, 1, 1, 1)
        icon:SetAtlas("nameplates-icon-orb-"..self.state.BGOrb)
        icon:SetTexCoord(0, 1, 0, 1)
        -- icon:HideBorder()
        icon:Show()
    else
        icon:Hide()
    end
end

UnitButton_UpdateStatusText = function(self)
    local statusText = self.indicators.statusText
    if not enabledIndicators["statusText"] then
        statusText:Hide()
        statusText:SetStatus()
        return
    end

    local unit = self.state.unit
    if not unit then return end

    self.state.guid = UnitGUID(unit) -- update!
    if not self.state.guid then return end

    if not UnitIsConnected(unit) and UnitIsPlayer(unit) then
        statusText:Show()
        statusText:SetStatus("OFFLINE")
        statusText:ShowTimer()
    elseif UnitIsAFK(unit) then
        statusText:Show()
        statusText:SetStatus("AFK")
        statusText:ShowTimer()
    elseif UnitIsFeignDeath(unit) then
        statusText:Show()
        statusText:SetStatus("FEIGN")
        statusText:HideTimer(true)
    elseif UnitIsDeadOrGhost(unit) then
        statusText:Show()
        statusText:HideTimer(true)
        if UnitIsGhost(unit) then
            statusText:SetStatus("GHOST")
        else
            statusText:SetStatus("DEAD")
        end
    elseif C_IncomingSummon.HasIncomingSummon(unit) then
        statusText:Show()
        statusText:HideTimer()
        local status = C_IncomingSummon.IncomingSummonStatus(unit)
        if status == Enum.SummonStatus.Pending then
            statusText:SetStatus("PENDING")
        elseif status == Enum.SummonStatus.Accepted then
            statusText:SetStatus("ACCEPTED")
            C_Timer.After(6, function() UnitButton_UpdateStatusText(self) end)
        elseif status == Enum.SummonStatus.Declined then
            statusText:SetStatus("DECLINED")
            C_Timer.After(6, function() UnitButton_UpdateStatusText(self) end)
        end
    elseif statusText:GetStatus() == "DRINKING" then
        -- update colors
        statusText:Show()
        statusText:SetStatus("DRINKING")
    else
        statusText:Hide()
        statusText:HideTimer(true)
        statusText:SetStatus()
    end
end

local function UnitButton_UpdateName(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.name = UnitName(unit)
    self.state.fullName = F:UnitFullName(unit)
    self.state.class = UnitClassBase(unit)
    self.state.guid = UnitGUID(unit)
    self.state.isPlayer = UnitIsPlayer(unit)

    self.indicators.nameText:UpdateName()
end

UnitButton_UpdateNameColor = function(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.class = UnitClassBase(unit) --! update class or it may be nil

    local nameText = self.indicators.nameText

    if not Cell.loaded then
        nameText:SetColor(1, 1, 1)
        return 
    end
    
    if UnitIsPlayer(unit) then -- player
        if not UnitIsConnected(unit) then
            nameText:SetColor(F:GetClassColor(self.state.class))
        elseif UnitIsCharmed(unit) then
            nameText:SetColor(F:GetClassColor(self.state.class))
        else
            if Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][1] == "class_color" then
                nameText:SetColor(F:GetClassColor(self.state.class))
            else
                nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][2]))
            end
        end
    elseif string.find(unit, "pet") then -- pet
        if Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][1] == "class_color" then
            nameText:SetColor(0.5, 0.5, 1)
        else
            nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][2]))
        end
    else -- npc
        if Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][1] == "class_color" then
            nameText:SetColor(0, 1, 0.2)
        else
            nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["nameColor"][2]))
        end
    end
end

UnitButton_UpdateHealthColor = function(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.class = UnitClassBase(unit) --! update class or it may be nil

    local barR, barG, barB
    local lossR, lossG, lossB
    local barA, lossA = 1, 1
    
    if Cell.loaded then
        barA =  CellDB["appearance"]["barAlpha"]
        lossA =  CellDB["appearance"]["lossAlpha"]
    end

    if UnitIsPlayer(unit) then -- player
        if not UnitIsConnected(unit) then
            barR, barG, barB = 0.4, 0.4, 0.4
            lossR, lossG, lossB = 0.4, 0.4, 0.4
        elseif UnitIsCharmed(unit) then
            barR, barG, barB = 0.5, 0, 1
            lossR, lossG, lossB = barR*0.2, barG*0.2, barB*0.2
        elseif self.state.inVehicle then
            barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0, 1, 0.2)
        else
            barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, F:GetClassColor(self.state.class))
        end
    elseif string.find(unit, "pet") then -- pet
        barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0.5, 0.5, 1)
    else -- npc
        barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0, 1, 0.2)
    end

    -- local r, g, b = RAID_CLASS_COLORS["DEATHKNIGHT"]:GetRGB()
    self.widget.healthBar:SetStatusBarColor(barR, barG, barB, barA)
    self.widget.healthBarLoss:SetVertexColor(lossR, lossG, lossB, lossA)
    self.widget.incomingHeal:SetVertexColor(barR, barG, barB)
end

-------------------------------------------------
-- cleu health updater
-------------------------------------------------
local cleuHealthUpdater = CreateFrame("Frame", "CellCleuHealthUpdater")
cleuHealthUpdater:SetScript("OnEvent", function()
    local _, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22 = CombatLogGetCurrentEventInfo()
    
    local b1, b2 = F:GetUnitButtonByGUID(destGUID)
    if not b1 then return end

    local diff
    if subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
        -- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
        diff = arg15
    elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then
        -- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
        diff = -arg15
    elseif subEvent == "SWING_DAMAGE" then
        -- amount
        diff = -arg12
    elseif subEvent == "RANGE_DAMAGE" then
        -- spellId, spellName, spellSchool, amount
        diff = -arg15
    elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
        -- environmentalType, amount
        diff = -arg13
    end

    if diff and diff ~= 0 then
        if b1 then UnitButton_UpdateHealth(b1, diff) end
        if b2 then UnitButton_UpdateHealth(b2, diff) end
    end
end)

local function UpdateCLEU()
    if CellDB["general"]["useCleuHealthUpdater"] then
        cleuHealthUpdater:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        cleuHealthUpdater:UnregisterAllEvents()
    end
end
Cell:RegisterCallback("UpdateCLEU", "UnitButton_UpdateCLEU", UpdateCLEU)

-------------------------------------------------
-- update all
-------------------------------------------------
UnitButton_UpdateAll = function(self)
    if not self:IsVisible() then return end

    UnitButton_UpdateVehicleStatus(self)
    UnitButton_UpdateName(self)
    UnitButton_UpdateNameColor(self)
    UnitButton_UpdateHealthMax(self)
    UnitButton_UpdateHealth(self)
    UnitButton_UpdateHealPrediction(self)
    UnitButton_UpdateStatusText(self)
    UnitButton_UpdateHealthColor(self)
    UnitButton_UpdateTarget(self)
    UnitButton_UpdatePlayerRaidIcon(self)
    UnitButton_UpdateTargetRaidIcon(self)
    UnitButton_UpdateShieldAbsorbs(self)
    UnitButton_UpdateHealAbsorbs(self)
    UnitButton_UpdateInRange(self)
    UnitButton_UpdateRole(self)
    UnitButton_UpdateLeader(self)
    UnitButton_UpdateReadyCheck(self)
    UnitButton_UpdateThreat(self)
    UnitButton_UpdateThreatBar(self)
    UnitButton_UpdateStatusIcon(self)
    UnitButton_UpdateAuras(self)

    if Cell.loaded then
        if Cell.vars.currentLayoutTable["powerSize"] ~= 0 then
            -- 单位按钮显示、专精、载具发生变化时
            if ShouldShowPowerBar(self) then
                ShowPowerBar(self, Cell.vars.currentLayoutTable["powerSize"])
            else
                HidePowerBar(self)
            end
        end
    else
        UnitButton_UpdatePowerType(self)
        UnitButton_UpdatePowerMax(self)
        UnitButton_UpdatePower(self)
    end
end

-------------------------------------------------
-- unit button events
-------------------------------------------------
local function UnitButton_RegisterEvents(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_MAXHEALTH")
    
    self:RegisterEvent("UNIT_POWER_FREQUENT")
    self:RegisterEvent("UNIT_MAXPOWER")
    self:RegisterEvent("UNIT_DISPLAYPOWER")
    
    self:RegisterEvent("UNIT_AURA")
    
    self:RegisterEvent("UNIT_HEAL_PREDICTION")
    self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
    self:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
    
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITED_VEHICLE")
    
    self:RegisterEvent("INCOMING_SUMMON_CHANGED")
    self:RegisterEvent("UNIT_FLAGS") -- afk
    self:RegisterEvent("UNIT_FACTION") -- mind control
    
    self:RegisterEvent("UNIT_CONNECTION") -- offline
    self:RegisterEvent("PLAYER_FLAGS_CHANGED") -- afk
    self:RegisterEvent("UNIT_NAME_UPDATE") -- unknown target
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA") --? update status text

    -- self:RegisterEvent("PARTY_LEADER_CHANGED") -- GROUP_ROSTER_UPDATE
    -- self:RegisterEvent("PLAYER_ROLES_ASSIGNED") -- GROUP_ROSTER_UPDATE
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")

    self:RegisterEvent("PLAYER_TARGET_CHANGED")

    if Cell.loaded then
        if enabledIndicators["playerRaidIcon"] then
            self:RegisterEvent("RAID_TARGET_UPDATE")
        end
    else
        self:RegisterEvent("RAID_TARGET_UPDATE")
    end
    if Cell.loaded then
        if enabledIndicators["targetRaidIcon"] then
            self:RegisterEvent("UNIT_TARGET")
        end
    else
        self:RegisterEvent("UNIT_TARGET")
    end
    
    self:RegisterEvent("READY_CHECK")
    self:RegisterEvent("READY_CHECK_FINISHED")
    self:RegisterEvent("READY_CHECK_CONFIRM")
    
    self:RegisterEvent("UNIT_PHASE") -- warmode, traditional sources of phasing such as progress through quest chains
    self:RegisterEvent("PARTY_MEMBER_DISABLE")
    self:RegisterEvent("PARTY_MEMBER_ENABLE")
    self:RegisterEvent("INCOMING_RESURRECT_CHANGED")
    
    -- self:RegisterEvent("VOICE_CHAT_CHANNEL_ACTIVATED")
    -- self:RegisterEvent("VOICE_CHAT_CHANNEL_DEACTIVATED")
    
    -- self:RegisterEvent("UNIT_PET")
    self:RegisterEvent("UNIT_PORTRAIT_UPDATE") -- pet summoned far away
    
    -- LibCLHealth.RegisterCallback(self, "COMBAT_LOG_HEALTH", function(event, unit, eventType)
    -- 	-- eventType - either nil when event comes from combat log, or "UNIT_HEALTH" to indicate events that can carry  update to death/ghost states
    -- 	-- print(event, unit, health)
    -- 	UnitButton_UpdateHealth(self)
    -- end)

    UnitButton_UpdateAll(self)
end

local function UnitButton_UnregisterEvents(self)
    self:UnregisterAllEvents()
end

local function UnitButton_OnEvent(self, event, unit, arg)
    if unit and (self.state.displayedUnit == unit or self.state.unit == unit) then
        if  event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" then
            self.updateRequired = 1
        
        elseif event == "UNIT_NAME_UPDATE" then
            UnitButton_UpdateName(self)
            UnitButton_UpdateNameColor(self)
            UnitButton_UpdateHealthColor(self)
        
        elseif event == "UNIT_MAXHEALTH" then
            UnitButton_UpdateHealthMax(self)
            UnitButton_UpdateHealth(self)
            UnitButton_UpdateHealPrediction(self)
            UnitButton_UpdateShieldAbsorbs(self)
            UnitButton_UpdateHealAbsorbs(self)
            
        elseif event == "UNIT_HEALTH" then
            UnitButton_UpdateHealth(self)
            UnitButton_UpdateHealPrediction(self)
            UnitButton_UpdateShieldAbsorbs(self)
            UnitButton_UpdateHealAbsorbs(self)
            -- UnitButton_UpdateStatusText(self)
    
        elseif event == "UNIT_HEAL_PREDICTION" then
            UnitButton_UpdateHealPrediction(self)
    
        elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
            UnitButton_UpdateShieldAbsorbs(self)
    
        elseif event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
            UnitButton_UpdateHealAbsorbs(self)
    
        elseif event == "UNIT_MAXPOWER" then
            UnitButton_UpdatePowerMax(self)
            UnitButton_UpdatePower(self)
    
        elseif event == "UNIT_POWER_FREQUENT" then
            UnitButton_UpdatePower(self)
    
        elseif event == "UNIT_DISPLAYPOWER" then
            UnitButton_UpdatePowerMax(self)
            UnitButton_UpdatePower(self)
            UnitButton_UpdatePowerType(self)
    
        elseif event == "UNIT_AURA" then
            UnitButton_UpdateAuras(self, arg)
    
        elseif event == "UNIT_TARGET" then
            UnitButton_UpdateTargetRaidIcon(self)
            
        elseif event == "PLAYER_FLAGS_CHANGED" or event == "UNIT_FLAGS" or event == "INCOMING_SUMMON_CHANGED" then
            if CELL_SUMMON_ICONS_ENABLED then UnitButton_UpdateStatusIcon(self) end
            UnitButton_UpdateStatusText(self)
            
        elseif event == "UNIT_FACTION" then -- mind control
            UnitButton_UpdateNameColor(self)
            UnitButton_UpdateHealthColor(self) 
            
        elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
            UnitButton_UpdateThreat(self)

        elseif event == "INCOMING_RESURRECT_CHANGED" or event == "UNIT_PHASE" or event == "PARTY_MEMBER_DISABLE" or event == "PARTY_MEMBER_ENABLE" then
            UnitButton_UpdateStatusIcon(self)
    
        elseif event == "READY_CHECK_CONFIRM" then
            UnitButton_UpdateReadyCheck(self)

        elseif event == "UNIT_PORTRAIT_UPDATE" then -- pet summoned far away
            if self.state.healthMax == 0 then
                self.updateRequired = 1
            end
        end

    else
        if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
            self.updateRequired = 1

        elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" then
            UnitButton_UpdateLeader(self, event)
    
        elseif event == "PLAYER_TARGET_CHANGED" then
            UnitButton_UpdateTarget(self)
            UnitButton_UpdateThreatBar(self)
        
        elseif event == "UNIT_THREAT_LIST_UPDATE" then
            UnitButton_UpdateThreatBar(self)
    
        elseif event == "RAID_TARGET_UPDATE" then
            UnitButton_UpdatePlayerRaidIcon(self)
            UnitButton_UpdateTargetRaidIcon(self)
    
        elseif event == "READY_CHECK" then
            UnitButton_UpdateReadyCheck(self)
    
        elseif event == "READY_CHECK_FINISHED" then
            UnitButton_FinishReadyCheck(self)
        
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            UnitButton_UpdateStatusText(self)

        -- elseif event == "VOICE_CHAT_CHANNEL_ACTIVATED" or event == "VOICE_CHAT_CHANNEL_DEACTIVATED" then
        -- 	VOICE_CHAT_CHANNEL_MEMBER_SPEAKING_STATE_CHANGED
        end
    end
end

local function UnitButton_OnAttributeChanged(self, name, value)
    if name == "unit" then
        if not value or value ~= self.state.unit then
            -- NOTE: when unitId for this button changes
            if self.__unitGuid then -- self.__unitGuid is deleted when hide
                -- print("deleteUnitGuid:", self:GetName(), self.state.unit, self.__unitGuid)
                if not self.isSpotlight then Cell.vars.guids[self.__unitGuid] = nil end
                self.__unitGuid = nil
            end
            if self.__unitName then
                if not self.isSpotlight then Cell.vars.names[self.__unitName] = nil end
                self.__unitName = nil
            end
            wipe(self.state)
        end

        if type(value) == "string" then
            self.state.unit = value
            self.state.displayedUnit = value
            if string.find(value, "^raid%d+$") then Cell.unitButtons.raid.units[value] = self end
            -- for omnicd
            if string.match(value, "raid%d") then
                local i = string.match(value, "%d")
                _G["CellRaidFrameMember"..i] = self
                self.unitid = value
            end

            ResetAuraTables(value)
        end
    end
end

-------------------------------------------------
-- unit button show/hide/enter/leave
-------------------------------------------------
Cell.vars.guids = {} -- guid to unitid
Cell.vars.names = {} -- name to unitid

local function UnitButton_OnShow(self)
    -- self.updateRequired = nil -- prevent UnitButton_UpdateAll twice. when convert party <-> raid, GROUP_ROSTER_UPDATE fired.
    UnitButton_RegisterEvents(self)

    --[[
    if self.state.unit then
        -- NOTE: update Cell.vars.guids
        local guid = UnitGUID(self.state.unit)
        if guid then
            Cell.vars.guids[guid] = self.state.unit
        end
        --! NOTE: can't get valid name immediately after an unseen player joining into group
        self.__timer = C_Timer.NewTicker(0.5, function()
            local name = GetUnitName(self.state.unit, true)
            if name and name ~= _G.UNKNOWN then
                Cell.vars.names[name] = self.state.unit
                self.__timer:Cancel()
                self.__timer = nil
            end
        end)
        -- print("show", self.state.unit, guid, name)
    end
    ]]
end

local function UnitButton_OnHide(self)
    UnitButton_UnregisterEvents(self)

    if self.state.unit then
        ResetAuraTables(self.state.unit)
    end
    -- NOTE: update Cell.vars.guids
    -- print("hide", self.state.unit, self.__unitGuid, self.__unitName)
    if self.__unitGuid then
        if not self.isSpotlight then Cell.vars.guids[self.__unitGuid] = nil end
        self.__unitGuid = nil
    end
    if self.__unitName then
        if not self.isSpotlight then Cell.vars.names[self.__unitName] = nil end
        self.__unitName = nil
    end
    self.__displayedGuid = nil
    F:RemoveElementsExceptKeys(self.state, "unit", "displayedUnit")
end

local function UnitButton_OnEnter(self)
    if highlightEnabled then self.widget.mouseoverHighlight:Show() end
    
    local unit = self.state.displayedUnit
    if not unit then return end
    
    F:ShowTooltips(self, "unit", unit)
end

local function UnitButton_OnLeave(self)
    self.widget.mouseoverHighlight:Hide()
    GameTooltip:Hide()
end

local UNKNOWN = _G.UNKNOWN
local UNKNOWNOBJECT = _G.UNKNOWNOBJECT
local function UnitButton_OnTick(self)
    local e = (self.__tickCount or 0) + 1
    if e >= 2 then -- every 0.5 second
        e = 0
        
        if self.state.unit and self.state.displayedUnit then
            local displayedGuid = UnitGUID(self.state.displayedUnit)
            if displayedGuid ~= self.__displayedGuid then
                -- NOTE: displayed unit entity changed
                F:RemoveElementsExceptKeys(self.state, "unit", "displayedUnit")
                self.__displayedGuid = displayedGuid
                self.updateRequired = 1
            end

            local guid = UnitGUID(self.state.unit)
            if guid and guid ~= self.__unitGuid then
                -- print("guidChanged:", self:GetName(), self.state.unit, guid)
                -- NOTE: unit entity changed
                -- update Cell.vars.guids
                self.__unitGuid = guid
                if not self.isSpotlight then Cell.vars.guids[guid] = self.state.unit end

                -- NOTE: only save players' names
                if UnitIsPlayer(self.state.unit) then
                    -- update Cell.vars.names
                    local name = GetUnitName(self.state.unit, true)
                    if (name and self.__nameRetries and self.__nameRetries >= 4) or (name and name ~= UNKNOWN and name ~= UNKNOWNOBJECT) then
                        self.__unitName = name
                        if not self.isSpotlight then Cell.vars.names[name] = self.state.unit end
                        self.__nameRetries = nil
                    else
                        -- NOTE: update on next tick
                        -- 国服可以起名为“未知目标”，干！就只多重试4次好了
                        self.__nameRetries = (self.__nameRetries or 0) + 1
                        self.__unitGuid = nil 
                    end
                end
            end
        end
    end

    self.__tickCount = e

    UnitButton_UpdateInRange(self)
    
    if self.updateRequired then
        self.updateRequired = nil
        UnitButton_UpdateAll(self)
    end

    --! for targettarget
    if self:GetAttribute("refreshOnUpdate") then
        UnitButton_UpdateAll(self)
    end
end

local function UnitButton_OnUpdate(self, elapsed)
    local e = (self.__updateElapsed or 0) + elapsed
    if e > 0.25 then
        UnitButton_OnTick(self)
        e = 0
    end
    self.__updateElapsed = e
end

-------------------------------------------------
-- unit button init
-------------------------------------------------
-- local startTimeCache, statusCache = {}, {}
local startTimeCache = {}

-- Layer(statusTextFrame) -- frameLevel:27 ----------
-- ARTWORK 
--	statusText, timerText
-------------------------------------------------
-- Layer(overlayFrame) -- frameLevel:7 ----------
-- OVERLAY
--	-7 readyCheckIcon, statusIcon
-- ARTWORK 
--	top nameText, statusText, timerText
--	-7 playerRaidIcon, roleIcon, leaderIcon
-------------------------------------------------

-- Layer(healthBar) -- frameLevel:5 -----------------
-- ARTWORK 
--	-5 overShieldGlow
--	-6 incomingHeal, damageFlash, absorbsBar
--	-7 shieldBar
-------------------------------------------------

-- Layer(button) -- frameLevel:3 -----------------
-- OVERLAY 
-- ARTWORK 
--	-6 healthBar, powerBar
--	-7 healthBarBackground, powerBarBackground
-- BORDER
--	0 background(button)
-- BACKGROUND
--	0 readyCheckHighlight
--	-1 mouseoverHighlight
--	-2 targetHighlight
-------------------------------------------------
-- BACKGROUND BORDER ARTWORK OVERLAY HIGHLIGHT

-- NOTE: prevent a nil method error
local DumbFunc = function() end

function F:UnitButton_OnLoad(button)
    local name = button:GetName()

    button.widget = {}
    button.state = {}
    button.func = {}
    button.indicators = {}

    -- background
    -- local background = button:CreateTexture(name.."Background", "BORDER")
    -- button.widget.background = background
    -- background:SetAllPoints(button)
    -- background:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
    -- background:SetVertexColor(0, 0, 0, 1)

    -- backdrop
    button:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    button:SetBackdropColor(0, 0, 0, 1)
    button:SetBackdropBorderColor(0, 0, 0, 1)
    
    -- healthbar
    local healthBar = CreateFrame("StatusBar", name.."HealthBar", button)
    button.widget.healthBar = healthBar
    -- P:Point(healthBar, "TOPLEFT", button, "TOPLEFT", 1, -1)
    -- P:Point(healthBar, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 4)
    healthBar:SetStatusBarTexture(Cell.vars.texture)
    healthBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    healthBar:SetFrameLevel(5)
    
    -- hp loss
    local healthBarLoss = button:CreateTexture(name.."HealthBarLoss", "ARTWORK", nil , -7)
    button.widget.healthBarLoss = healthBarLoss
    -- P:Point(healthBarLoss, "TOPRIGHT", healthBar)
    -- P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    healthBarLoss:SetTexture(Cell.vars.texture)

    -- powerbar
    local powerBar = CreateFrame("StatusBar", name.."PowerBar", button)
    button.widget.powerBar = powerBar
    -- P:Point(powerBar, "TOPLEFT", healthBar, "BOTTOMLEFT", 0, -1)
    -- P:Point(powerBar, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    powerBar:SetStatusBarTexture(Cell.vars.texture)
    powerBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    powerBar:SetFrameLevel(6)

    local gapTexture = button:CreateTexture(nil, "BORDER")
    button.widget.gapTexture = gapTexture
    -- P:Point(gapTexture, "BOTTOMLEFT", powerBar, "TOPLEFT")
    -- P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "TOPRIGHT")
    -- P:Height(gapTexture, 1)
    gapTexture:SetColorTexture(0, 0, 0, 1)

    -- power loss
    local powerBarLoss = button:CreateTexture(name.."PowerBarLoss", "ARTWORK", nil , -7)
    button.widget.powerBarLoss = powerBarLoss
    -- P:Point(powerBarLoss, "TOPRIGHT", powerBar)
    -- P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    powerBarLoss:SetTexture(Cell.vars.texture)

    button.func.SetPowerSize = function(size)
        if size == 0 then
            HidePowerBar(button)
        else
            if ShouldShowPowerBar(button) then
                ShowPowerBar(button, size)
            else
                HidePowerBar(button)
            end
        end
    end
    
    -- incoming heal
    local incomingHeal = healthBar:CreateTexture(name.."IncomingHealBar", "ARTWORK", nil, -6)
    button.widget.incomingHeal = incomingHeal
    -- P:Point(incomingHeal, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
    -- P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    incomingHeal:SetTexture(Cell.vars.texture)
    incomingHeal:SetAlpha(0.4)
    incomingHeal:Hide()
    incomingHeal.SetValue = DumbFunc

    -- shield bar
    local shieldBar = healthBar:CreateTexture(name.."ShieldBar", "ARTWORK", nil, -7)
    button.widget.shieldBar = shieldBar
    -- P:Point(shieldBar, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
    -- P:Point(shieldBar, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    shieldBar:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")
    shieldBar:SetHorizTile(true)
    shieldBar:SetVertTile(true)
    shieldBar:SetVertexColor(1, 1, 1, 0.4)
    shieldBar:Hide()
    shieldBar.SetValue = DumbFunc

    -- over-shield glow
    local overShieldGlow = healthBar:CreateTexture(name.."OverShieldGlow", "OVERLAY")
    button.widget.overShieldGlow = overShieldGlow
    overShieldGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
    overShieldGlow:SetBlendMode("ADD")
    -- P:Point(overShieldGlow, "BOTTOMLEFT", healthBar, "BOTTOMRIGHT", -4, 0)
    -- P:Point(overShieldGlow, "TOPLEFT", healthBar, "TOPRIGHT", -4, 0)
    -- overShieldGlow:SetWidth(8)
    overShieldGlow:Hide()

    -- absorbs bar
    local absorbsBar = healthBar:CreateTexture(name.."AbsorbsBar", "OVERLAY")
    button.widget.absorbsBar = absorbsBar
    -- P:Point(absorbsBar, "TOPRIGHT", healthBar:GetStatusBarTexture())
    -- P:Point(absorbsBar, "BOTTOMRIGHT", healthBar:GetStatusBarTexture())
    absorbsBar:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")
    absorbsBar:SetHorizTile(true)
    absorbsBar:SetVertTile(true)
    absorbsBar:SetVertexColor(1, 0.1, 0.1, 0.9)
    absorbsBar:SetBlendMode("ADD")
    absorbsBar:Hide()
    absorbsBar.SetValue = DumbFunc

    button.func.UpdateShields = function()
        predictionEnabled = CellDB["appearance"]["healPrediction"]
        absorbEnabled = CellDB["appearance"]["healAbsorb"]
        shieldEnabled = CellDB["appearance"]["shield"]
        overshieldEnabled = CellDB["appearance"]["overshield"]

        UnitButton_UpdateHealPrediction(button)
        UnitButton_UpdateHealAbsorbs(button)
        UnitButton_UpdateShieldAbsorbs(button)
    end

    -- bar animation
    -- flash
    local damageFlashTex = healthBar:CreateTexture(name.."DamageFlash", "ARTWORK", nil, -6)
    button.widget.damageFlashTex = damageFlashTex
    damageFlashTex:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    damageFlashTex:SetVertexColor(1, 1, 1, 0.7)
    -- P:Point(damageFlashTex, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
    -- P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    damageFlashTex:Hide()
    damageFlashTex.SetValue = DumbFunc

    -- damage flash animation group
    local damageFlashAG = damageFlashTex:CreateAnimationGroup()
    local alpha = damageFlashAG:CreateAnimation("Alpha")
    alpha:SetFromAlpha(0.7)
    alpha:SetToAlpha(0)
    alpha:SetDuration(0.2)
    damageFlashAG:SetScript("OnPlay", function(self)
        damageFlashTex:Show()
    end)
    damageFlashAG:SetScript("OnFinished", function(self)
        damageFlashTex:Hide()
    end)

    button.func.ShowFlash = function(lostPercent)
        damageFlashTex:SetValue(lostPercent)
        -- damageFlashTex:Show()
        damageFlashAG:Play()
    end

    button.func.HideFlash = function()
        damageFlashAG:Finish()
    end

    -- smooth
    Mixin(healthBar, SmoothStatusBarMixin)
    Mixin(powerBar, SmoothStatusBarMixin)

    button.func.UpdateAnimation = function()
        barAnimationType = CellDB["appearance"]["barAnimation"]
        if aType ~= "Flash" then
            damageFlashAG:Finish()
        end
    end

    button.func.SetTexture = function(tex)
        healthBar:SetStatusBarTexture(tex)
        healthBarLoss:SetTexture(tex)
        powerBar:SetStatusBarTexture(tex)
        powerBarLoss:SetTexture(tex)
        incomingHeal:SetTexture(tex)
        damageFlashTex:SetTexture(tex)
    end

    button.func.UpdateColor = function()
        UnitButton_UpdateHealthColor(button)
        UnitButton_UpdatePowerType(button)
        button:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
    end

    -- bar orientation
    button.func.SetOrientation = function(orientation, rotateTexture)
        button.orientation = orientation
        healthBar:SetOrientation(orientation)
        healthBar:SetRotatesTexture(rotateTexture)
        powerBar:SetOrientation(orientation)
        powerBar:SetRotatesTexture(rotateTexture)
        
        button.indicators.healthThresholds:SetOrientation(orientation)

        if rotateTexture then
            F:RotateTexture(healthBarLoss, 90)
            F:RotateTexture(powerBarLoss, 90)
            F:RotateTexture(incomingHeal, 90)
            F:RotateTexture(damageFlashTex, 90)
            -- F:RotateTexture(shieldBar, 90)
            -- F:RotateTexture(absorbsBar, 90)
        else
            F:RotateTexture(healthBarLoss, 0)
            F:RotateTexture(powerBarLoss, 0)
            F:RotateTexture(incomingHeal, 0)
            F:RotateTexture(overShieldGlow, 0)
            F:RotateTexture(damageFlashTex, 0)
            -- F:RotateTexture(shieldBar, 0)
            -- F:RotateTexture(absorbsBar, 0)
        end
        
        if orientation == "horizontal" then
            -- update healthBarLoss
            P:ClearPoints(healthBarLoss)
            P:Point(healthBarLoss, "TOPRIGHT", healthBar)
            P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            
            -- update powerBarLoss
            P:ClearPoints(powerBarLoss)
            P:Point(powerBarLoss, "TOPRIGHT", powerBar)
            P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            
            -- update gapTexture
            P:ClearPoints(gapTexture)
            P:Point(gapTexture, "BOTTOMLEFT", powerBar, "TOPLEFT")
            P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "TOPRIGHT")
            P:Height(gapTexture, 1)
            
            -- update incomingHeal
            P:ClearPoints(incomingHeal)
            P:Point(incomingHeal, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            function incomingHeal:SetValue(incomingPercent)
                local barWidth = healthBar:GetWidth()
                local incomingHealWidth = incomingPercent * barWidth
                local lostHealthWidth = barWidth * (1 - button.state.healthPercent)
            
                -- print(incomingPercent, barWidth, incomingHealWidth, lostHealthWidth)
                -- FIXME: if incomingPercent is a very tiny number, like 0.005
                -- P:Scale(incomingHealWidth) ==> 0
                --! if width is set to 0, then the ACTUAL width may be 256!!!

                if lostHealthWidth == 0 then
                    incomingHeal:Hide()
                else
                    if lostHealthWidth > incomingHealWidth then
                        incomingHeal:SetWidth(incomingHealWidth)
                    else
                        incomingHeal:SetWidth(lostHealthWidth)
                    end
                    incomingHeal:Show()
                end
            end
            
            -- update shieldBar
            P:ClearPoints(shieldBar)
            P:Point(shieldBar, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            P:Point(shieldBar, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            function shieldBar:SetValue(shieldPercent)
                local barWidth = healthBar:GetWidth()
                if shieldPercent + button.state.healthPercent > 1 then -- overshield
                    local p = 1 - button.state.healthPercent
                    if p ~= 0 then
                        if shieldEnabled then
                            shieldBar:SetWidth(p * barWidth)
                            shieldBar:Show()
                        else
                            shieldBar:Hide()
                        end
                    else
                        shieldBar:Hide()
                    end
                    if overshieldEnabled then
                        overShieldGlow:Show()
                    else
                        overShieldGlow:Hide()
                    end
                else
                    if shieldEnabled then
                        shieldBar:SetWidth(shieldPercent * barWidth)
                        shieldBar:Show()
                    else
                        shieldBar:Hide()
                    end
                    overShieldGlow:Hide()
                end
            end
            
            -- update overShieldGlow
            P:ClearPoints(overShieldGlow)
            P:Point(overShieldGlow, "BOTTOMLEFT", healthBar, "BOTTOMRIGHT", -4, 0)
            P:Point(overShieldGlow, "TOPLEFT", healthBar, "TOPRIGHT", -4, 0)
            P:Width(overShieldGlow, 8)
            F:RotateTexture(overShieldGlow, 0)
            
            -- update absorbsBar
            P:ClearPoints(absorbsBar)
            P:Point(absorbsBar, "TOPRIGHT", healthBar:GetStatusBarTexture())
            P:Point(absorbsBar, "BOTTOMRIGHT", healthBar:GetStatusBarTexture())
            function absorbsBar:SetValue(absorbsPercent)
                local barWidth = healthBar:GetWidth()
                absorbsBar:SetWidth(absorbsPercent * barWidth)
                absorbsBar:Show()
            end
            
            -- update damageFlashTex
            P:ClearPoints(damageFlashTex)
            P:Point(damageFlashTex, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            function damageFlashTex:SetValue(lostPercent)
                local barWidth = healthBar:GetWidth()
                damageFlashTex:SetWidth(barWidth * lostPercent)
            end
        else -- vertical
            P:ClearPoints(healthBarLoss)
            P:Point(healthBarLoss, "TOPRIGHT", healthBar)
            P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
            
            -- update powerBarLoss
            P:ClearPoints(powerBarLoss)
            P:Point(powerBarLoss, "TOPRIGHT", powerBar)
            P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "TOPLEFT")
            
            -- update gapTexture
            P:ClearPoints(gapTexture)
            P:Point(gapTexture, "TOPRIGHT", powerBar, "TOPLEFT")
            P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "BOTTOMLEFT")
            P:Width(gapTexture, 1)
            
            -- update incomingHeal
            P:ClearPoints(incomingHeal)
            P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
            P:Point(incomingHeal, "BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            function incomingHeal:SetValue(incomingPercent)
                local barHeight = healthBar:GetHeight()
                local incomingHealHeight = incomingPercent * barHeight
                local lostHealthHeight = barHeight * (1 - button.state.healthPercent)
            
                if lostHealthHeight == 0 then
                    incomingHeal:Hide()
                else
                    if lostHealthHeight > incomingHealHeight then
                        incomingHeal:SetHeight(incomingHealHeight)
                    else
                        incomingHeal:SetHeight(lostHealthHeight)
                    end
                    incomingHeal:Show()
                end
            end
            
            -- update shieldBar
            P:ClearPoints(shieldBar)
            P:Point(shieldBar, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
            P:Point(shieldBar, "BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            function shieldBar:SetValue(shieldPercent)
                local barHeight = healthBar:GetHeight()
                if shieldPercent + button.state.healthPercent > 1 then -- overshield
                    local p = 1 - button.state.healthPercent
                    if p ~= 0 then
                        if shieldEnabled then
                            shieldBar:SetHeight(p * barHeight)
                            shieldBar:Show()
                        else
                            shieldBar:Hide()
                        end
                    else
                        shieldBar:Hide()
                    end
                    if overshieldEnabled then
                        overShieldGlow:Show()
                    else
                        overShieldGlow:Hide()
                    end
                else
                    if shieldEnabled then
                        shieldBar:SetHeight(shieldPercent * barHeight)
                        shieldBar:Show()
                    else
                        shieldBar:Hide()
                    end
                    overShieldGlow:Hide()
                end
            end
            
            -- update overShieldGlow
            P:ClearPoints(overShieldGlow)
            P:Point(overShieldGlow, "BOTTOMLEFT", healthBar, "TOPLEFT", 0, -4)
            P:Point(overShieldGlow, "BOTTOMRIGHT", healthBar, "TOPRIGHT", 0, -4)
            P:Height(overShieldGlow, 8)
            F:RotateTexture(overShieldGlow, 90)
            
            -- update absorbsBar
            P:ClearPoints(absorbsBar)
            P:Point(absorbsBar, "TOPLEFT", healthBar:GetStatusBarTexture())
            P:Point(absorbsBar, "TOPRIGHT", healthBar:GetStatusBarTexture())
            function absorbsBar:SetValue(absorbsPercent)
                local barHeight = healthBar:GetHeight()
                absorbsBar:SetHeight(absorbsPercent * barHeight)
                absorbsBar:Show()
            end
            
            -- update damageFlashTex
            P:ClearPoints(damageFlashTex)
            P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
            P:Point(damageFlashTex, "BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
            function damageFlashTex:SetValue(lostPercent)
                local barHeight = healthBar:GetHeight()
                damageFlashTex:SetHeight(barHeight * lostPercent)
            end
        end
    end

    -- target highlight
    local targetHighlight = CreateFrame("Frame", name.."TargetHighlight", button, "BackdropTemplate")
    button.widget.targetHighlight = targetHighlight
    targetHighlight:EnableMouse(false)
    targetHighlight:SetFrameLevel(6)
    -- targetHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    -- P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT", -1, 1)
    -- P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    targetHighlight:Hide()
    
    -- mouseover highlight
    local mouseoverHighlight = CreateFrame("Frame", name.."MouseoverHighlight", button, "BackdropTemplate")
    button.widget.mouseoverHighlight = mouseoverHighlight
    mouseoverHighlight:EnableMouse(false)
    mouseoverHighlight:SetFrameLevel(7)
    -- mouseoverHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    -- P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT", -1, 1)
    -- P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    mouseoverHighlight:Hide()

    button.func.UpdateHighlightColor = function()
        targetHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["targetColor"]))
        mouseoverHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["mouseoverColor"]))
    end
    
    button.func.UpdateHighlightSize = function()
        local size = CellDB["appearance"]["highlightSize"]
        
        if size ~= 0 then
            highlightEnabled = true
            
            P:ClearPoints(targetHighlight)
            P:ClearPoints(mouseoverHighlight)

            -- update point
            if size < 0 then
                size = abs(size)
                P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT")
                P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT")
                P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT")
                P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT")
            else
                P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT", -size, size)
                P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", size, -size)
                P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT", -size, size)
                P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", size, -size)
            end

            -- update thickness
            targetHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(size)})
            mouseoverHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(size)})

            -- update color
            targetHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["targetColor"]))
            mouseoverHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["mouseoverColor"]))

            UnitButton_UpdateTarget(button) -- 0->!0 show highlight again
        else
            highlightEnabled = false
            targetHighlight:Hide()
            mouseoverHighlight:Hide()
        end
    end

    -- readyCheck highlight
    -- local readyCheckHighlight = button:CreateTexture(name.."ReadyCheckHighlight", "BACKGROUND")
    -- button.widget.readyCheckHighlight = readyCheckHighlight
    -- readyCheckHighlight:SetPoint("TOPLEFT", -1, 1)
    -- readyCheckHighlight:SetPoint("BOTTOMRIGHT", 1, -1)
    -- readyCheckHighlight:SetTexture("Interface\\Buttons\\WHITE8x8")
    -- readyCheckHighlight:Hide()

    --* tsGlowFrame (Targeted Spells)
    local tsGlowFrame = CreateFrame("Frame", name.."TSGlowFrame", button)
    button.widget.tsGlowFrame = tsGlowFrame
    tsGlowFrame:SetAllPoints(button)


    --* srGlowFrame (Spell Request)
    local srGlowFrame = CreateFrame("Frame", name.."SRGlowFrame", button)
    button.widget.srGlowFrame = srGlowFrame
    srGlowFrame:SetAllPoints(button)
    
    --* drGlowFrame (Dispel Request)
    local drGlowFrame = CreateFrame("Frame", name.."DRGlowFrame", button)
    button.widget.drGlowFrame = drGlowFrame
    drGlowFrame:SetAllPoints(button)

    --* overlayFrame
    local overlayFrame = CreateFrame("Frame", name.."OverlayFrame", button)
    button.widget.overlayFrame = overlayFrame
    overlayFrame:SetFrameLevel(8) -- button:GetFrameLevel() == 4
    overlayFrame:SetAllPoints(button)

    -- aggro bar
    local aggroBar = Cell:CreateStatusBar(name.."AggroBar", overlayFrame, 18, 2, 100, true)
    button.indicators.aggroBar = aggroBar
    -- aggroBar:SetPoint("BOTTOMLEFT", overlayFrame, "TOPLEFT", 1, 0)
    aggroBar:Hide()

    -- raidIcons
    button.func.UpdatePlayerRaidIcon = function(enabled)
        if not button:IsShown() then return end
        UnitButton_UpdatePlayerRaidIcon(button)
        if enabled then
            button:RegisterEvent("RAID_TARGET_UPDATE")
        else
            button:UnregisterEvent("RAID_TARGET_UPDATE")
        end
    end
    button.func.UpdateTargetRaidIcon = function(enabled)
        if not button:IsShown() then return end
        UnitButton_UpdateTargetRaidIcon(button)
        if enabled then
            button:RegisterEvent("UNIT_TARGET")
        else
            button:UnregisterEvent("UNIT_TARGET")
        end
    end

    -- healthText
    button.func.UpdateHealthText = function()
        if button.state.displayedUnit then
            UpdateUnitHealthState(button)
        end
    end

    -- statusText
    button.func.UpdateStatusText = function()
        UnitButton_UpdateStatusText(button)
    end

    -- shields
    button.func.UpdateShield = function()
        UnitButton_UpdateShieldAbsorbs(button)
    end

    -- pixel perfect
    button.func.UpdatePixelPerfect = function(updateIndicators)
        button:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
        button:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
        button:SetBackdropBorderColor(0, 0, 0, 1)
        P:Resize(button)

        P:Repoint(healthBar)
        P:Repoint(healthBarLoss)
        P:Repoint(powerBar)
        P:Repoint(powerBarLoss)
        P:Repoint(gapTexture)
        P:Resize(gapTexture)

        P:Repoint(incomingHeal)
        P:Repoint(shieldBar)
        P:Repoint(overShieldGlow)
        P:Repoint(absorbsBar)
        P:Repoint(damageFlashTex)
        
        button.func.UpdateHighlightSize()

        if updateIndicators then
            -- indicators
            for _, i in pairs(button.indicators) do
                if i.UpdatePixelPerfect then
                    i:UpdatePixelPerfect() 
                end
            end
        end
    end

    -- FIXME: fix boss 678
    button.func.UpdateAll = UnitButton_UpdateAll
    button.func.UpdateHealth = UnitButton_UpdateHealth
    button.func.UpdateHealthMax = UnitButton_UpdateHealthMax
    button.func.UpdateAuras = UnitButton_UpdateAuras

    -- indicators
    I:CreateNameText(button)
    I:CreateStatusText(button)
    I:CreateHealthText(button)
    I:CreateStatusIcon(button)
    I:CreateRoleIcon(button)
    I:CreateLeaderIcon(button)
    I:CreateReadyCheckIcon(button)
    I:CreateAggroBlink(button)
    I:CreateAggroBorder(button)
    I:CreatePlayerRaidIcon(button)
    I:CreateTargetRaidIcon(button)
    I:CreateShieldBar(button)
    I:CreateAoEHealing(button)
    I:CreateDefensiveCooldowns(button)
    I:CreateExternalCooldowns(button)
    I:CreateAllCooldowns(button)
    I:CreateTankActiveMitigation(button)
    I:CreateDebuffs(button)
    I:CreateDispels(button)
    I:CreateRaidDebuffs(button)
    I:CreateTargetedSpells(button)
    I:CreateTargetCounter(button)
    I:CreateConsumables(button)
    I:CreateHealthThresholds(button)

    -- events
    button:SetScript("OnAttributeChanged", UnitButton_OnAttributeChanged) -- init
    button:HookScript("OnShow", UnitButton_OnShow)
    button:HookScript("OnHide", UnitButton_OnHide) -- use _onhide for click-castings
    button:HookScript("OnEnter", UnitButton_OnEnter) -- SecureHandlerEnterLeaveTemplate
    button:HookScript("OnLeave", UnitButton_OnLeave) -- SecureHandlerEnterLeaveTemplate
    button:SetScript("OnUpdate", UnitButton_OnUpdate)
    button:SetScript("OnEvent", UnitButton_OnEvent)
    button:RegisterForClicks("AnyDown")
end
