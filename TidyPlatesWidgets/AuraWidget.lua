local _

local WidgetList = {}

local DebuffColumns = 3
local DebuffLimit = 6
local useWideIcons = true
local UpdateInterval = 0.2

local function AuraFilterFunction(aura, unit)
    if aura and aura.duration and (aura.duration < 30) then
        return true
    end
end

local AURA_TARGET_HOSTILE = 1
local AURA_TARGET_FRIENDLY = 2


-- Get a clean version of the function...  Avoid OmniCC interference
local CooldownNative = CreateFrame("Cooldown", nil, WorldFrame)
local SetCooldown = CooldownNative.SetCooldown




--* ---------------------------------------------------------------
--* Aura
--* ---------------------------------------------------------------

local function CreateAura(unit, index, filter, unitReaction, unitIsNPC)
    local name, icon, stacks, auraType, duration, expiration, caster, stealable, showPersonal, spellid, canApply, bossdebuff, castByPlayer, showAll, timeMod = UnitAura(unit, index, filter)
    return {
        name = name,
        texture = icon,
        stacks = stacks,
        type = auraType,
        duration = duration,
        expiration = expiration,
        caster = caster,
        stealable = stealable,
        showPersonal = showPersonal,
        spellid = spellid,
        canApply = canApply,
        bossdebuff = bossdebuff,
        castByPlayer = castByPlayer,
        showAll = showAll,
        timeMod = timeMod,
        reaction = unitReaction or (UnitIsFriend("player", unitid) and not UnitIsEnemy("player", unitid) --PVP UnitIsFriend=true
                                    and AURA_TARGET_FRIENDLY
                                    or AURA_TARGET_HOSTILE),
		isNPC = unitIsNPC,
        effect = filter,
        unit = unit,
    }
end

local function AuraSortFunction(a,b)
	return a.priority < b.priority
end



--* ---------------------------------------------------------------
--* AuraIcon
--* ---------------------------------------------------------------

local AuraIcon = {
    WideArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameWide",
    SquareArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameSquare",
    WideHighlightArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameHighlightWide",
    SquareHighlightArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameHighlightSquare",
    Font = "FONTS\\ARIALN.TTF",
}

function AuraIcon.Create(parent)
	local frame = CreateFrame("Frame", nil, parent)
    Mixin(frame, AuraIcon)

	frame.unit = nil
	frame.Parent = parent

	frame.Icon = frame:CreateTexture(nil, "BACKGROUND")
	frame.Border = frame:CreateTexture(nil, "ARTWORK")
	frame.BorderHighlight = frame:CreateTexture(nil, "ARTWORK")
	frame.Cooldown = CreateFrame("Cooldown", nil, frame, "TidyPlatesAuraWidgetCooldown")
    frame.Cooldown.SetCooldown = CooldownNative.SetCooldown
    frame.Cooldown.noCooldownCount = true --abyui
	frame.Cooldown:SetAllPoints(frame)
	frame.Cooldown:SetReverse(true)
	frame.Cooldown:SetHideCountdownNumbers(true)
	frame.Cooldown:SetDrawEdge(true)

	-- Text
	frame.TimeLeft = frame.Cooldown:CreateFontString(nil, "OVERLAY")
	frame.Stacks = frame.Cooldown:CreateFontString(nil, "OVERLAY")
	frame:Hide()

	return frame
end

function AuraIcon:TransformWideAura()
	self:SetWidth(26.5)
	self:SetHeight(14.5)
	-- Icon
	self.Icon:SetAllPoints(self)
	self.Icon:SetTexCoord(.07, 1-.07, .23, 1-.23)  -- obj:SetTexCoord(left,right,top,bottom)
	-- Border
	self.Border:SetWidth(32); self.Border:SetHeight(32)
	self.Border:SetPoint("CENTER", 1, -2)
	self.Border:SetTexture(self.WideArt)
	-- Highlight
	self.BorderHighlight:SetAllPoints(self.Border)
	self.BorderHighlight:SetTexture(self.WideHighlightArt)
	--  Time Text
	self.TimeLeft:SetFont(self.Font ,9, "OUTLINE")
	self.TimeLeft:SetShadowOffset(1, -1)
	self.TimeLeft:SetShadowColor(0,0,0,1)
	self.TimeLeft:SetPoint("RIGHT", 0, 8)
	self.TimeLeft:SetWidth(26)
	self.TimeLeft:SetHeight(16)
	self.TimeLeft:SetJustifyH("RIGHT")
	--  Stacks
	self.Stacks:SetFont(self.Font,10, "OUTLINE")
	self.Stacks:SetShadowOffset(1, -1)
	self.Stacks:SetShadowColor(0,0,0,1)
	self.Stacks:SetPoint("RIGHT", 0, -6)
	self.Stacks:SetWidth(26)
	self.Stacks:SetHeight(16)
	self.Stacks:SetJustifyH("RIGHT")
end

function AuraIcon:TransformSquareAura()
	self:SetWidth(16.5)
	self:SetHeight(14.5)
	-- Icon
	self.Icon:SetAllPoints(self)
	self.Icon:SetTexCoord(.10, 1-.07, .12, 1-.12)  -- obj:SetTexCoord(left,right,top,bottom)
	-- Border
	self.Border:SetWidth(32); self.Border:SetHeight(32)
	self.Border:SetPoint("CENTER", 0, -2)
	self.Border:SetTexture(self.SquareArt)
	-- Highlight
	self.BorderHighlight:SetAllPoints(self.Border)
	self.BorderHighlight:SetTexture(self.SquareHighlightArt)
	--  Time Text
	self.TimeLeft:SetFont(self.Font ,9, "OUTLINE")
	self.TimeLeft:SetShadowOffset(1, -1)
	self.TimeLeft:SetShadowColor(0,0,0,1)
	self.TimeLeft:SetPoint("RIGHT", 0, 8)
	self.TimeLeft:SetWidth(26)
	self.TimeLeft:SetHeight(16)
	self.TimeLeft:SetJustifyH("RIGHT")
	--  Stacks
	self.Stacks:SetFont(self.Font,10, "OUTLINE")
	self.Stacks:SetShadowOffset(1, -1)
	self.Stacks:SetShadowColor(0,0,0,1)
	self.Stacks:SetPoint("RIGHT", 0, -6)
	self.Stacks:SetWidth(26)
	self.Stacks:SetHeight(16)
	self.Stacks:SetJustifyH("RIGHT")
end

function AuraIcon:Expire()
	self.Parent:Update()
end

function AuraIcon:UpdateTime()
	if self.aura.expiration == 0 then
		self.TimeLeft:SetText("")
	else
		local timeleft = self.aura.expiration - GetTime()
		if timeleft > 60 then
			self.TimeLeft:SetText(floor(timeleft/60).."m")
		else
			self.TimeLeft:SetText(floor(timeleft))
		end
	end
end

function AuraIcon:UpdateAura(aura)
	if aura then
        self.aura = aura
        local duration = aura.duration
        local expiration = duration == 0 and 0 or aura.expiration

		self.Icon:SetTexture(aura.texture)
        self.Stacks:SetText(aura.stacks > 1 and aura.stacks or "")

		if aura.hasHighlight then
			self.BorderHighlight:SetVertexColor(aura.r, aura.g, aura.b)
			self.BorderHighlight:Show()
			self.Border:Hide()
		else
            self.BorderHighlight:Hide()
            self.Border:Show()
        end

		if duration > 0 and expiration > 0 then
			self.Cooldown:SetCooldown(expiration - duration, duration)
            self.NextUpdate = GetTime() + UpdateInterval
            self:SetScript("OnUpdate", self.OnUpdate)
        else
            self:SetScript("OnUpdate", nil)
        end

        self:UpdateTime()
        self:Show()

	else
        self.aura = nil
        self:SetScript("OnUpdate", nil)
		self:Hide()
	end
end

function AuraIcon:OnUpdate(elapsed)
    if self.NextUpdate <= GetTime() then
        self.NextUpdate = self.NextUpdate + UpdateInterval
        self:UpdateTime()
    end
end

--* ---------------------------------------------------------------
--* AuraWidget
--* ---------------------------------------------------------------

local AuraWidget = {}

-- Create the Main Widget Body and Icon Array
function AuraWidget.Create(parent)

	-- Create Base frame
	local frame = CreateFrame("Frame", nil, parent)
    Mixin(frame, AuraWidget)
    frame:HookScript("OnHide", frame.OnHide)

	frame:SetWidth(128); frame:SetHeight(32); frame:Show()
	--frame.PollFunction = UpdateWidgetTime

	-- Create Icon Grid
	frame.AuraIconFrames = {}
	frame:UpdateConfig()

	-- Functions

	frame.Filter = nil
	frame.UpdateTarget = UpdateWidgetTarget
	return frame
end

function AuraWidget:OnHide()
    for unitid, widget in pairs(WidgetList) do
		if self == widget then WidgetList[unitid] = nil end
	end
end

function AuraWidget:Update()
    local unitid = self.unitid
    if not unitid then return end

    local unitReaction      = UnitIsFriend("player", unitid)
                              and AURA_TARGET_FRIENDLY
                              or AURA_TARGET_HOSTILE
	local unitIsNPC         = not UnitIsPlayer(unitid) and not UnitPlayerControlled(unitid)
    local AuraIconFrames    = self.AuraIconFrames
    local storedAuras       = {}
    local storedAuraCount   = 0
    local auraIndex         = 0
    local searchedDebuffs   = false
    local searchedBuffs     = false
    local auraFilter        = "HARMFUL"

    -- Cache displayable auras
    ------------------------------------------------------------------------------------------------------
    -- This block will go through the auras on the unit and make a list of those that should
    -- be displayed, listed by priority.

    repeat
        auraIndex = auraIndex + 1
        local aura = CreateAura(unitid, auraIndex, auraFilter, unitReaction, unitIsNPC)

        -- Auras are evaluated by an external function
        -- Pre-filtering before the icon grid is populated
        if aura.name then
            local show, priority, r, g, b = AuraFilterFunction(aura)
            -- Store Order/Priority
            if show then
                aura.priority = priority or 10
                if r then
                    aura.hasHighlight = true
                    aura.r, aura.g, aura.b = r, g, b
                end
                storedAuraCount = storedAuraCount + 1
                storedAuras[storedAuraCount] = aura
            end
        else
            if auraFilter == "HARMFUL" then
                searchedDebuffs = true
                auraFilter = "HELPFUL"
                auraIndex = 0
            else
                searchedBuffs = true
            end
        end

    until (searchedDebuffs and searchedBuffs)

    --* Display Auras
    local displayedAuraCount = min(storedAuraCount, DebuffLimit)
    if displayedAuraCount > 0 then
        self:Show()
        sort(storedAuras, AuraSortFunction)
        for i = 1, displayedAuraCount do
            local aura = storedAuras[i]
            if aura.spellid and aura.expiration then
                AuraIconFrames[i]:UpdateAura(aura)
            else
                AuraIconFrames[i]:UpdateAura()
            end
        end
        self.currentAuraCount = displayedAuraCount
    end

    -- Clear Extra Slots
    for i = displayedAuraCount + 1, DebuffLimit do
        AuraIconFrames[i]:UpdateAura()
    end

end

function AuraWidget:UpdateContext(unit)
	local unitid = unit.unitid
	self.unitid = unitid

	WidgetList[unitid] = self

	self:Update()
end

function AuraWidget:UpdateConfig()
	local iconTable = self.AuraIconFrames

	if iconTable then
		-- Create Icons
		for index = 1, DebuffLimit do
			local icon = iconTable[index] or AuraIcon.Create(self)
			iconTable[index] = icon
			-- Apply Style
			if useWideIcons then
                icon:TransformWideAura()
            else
                icon:TransformSquareAura()
            end
		end

		-- Set Anchors
		iconTable[1]:ClearAllPoints()
		iconTable[1]:SetPoint("LEFT", self)
		for index = 2, DebuffColumns do
		  iconTable[index]:ClearAllPoints()
		  iconTable[index]:SetPoint("LEFT", iconTable[index-1], "RIGHT", 5, 0)
		end

		iconTable[DebuffColumns+1]:ClearAllPoints()
		iconTable[DebuffColumns+1]:SetPoint("BOTTOMLEFT", iconTable[1], "TOPLEFT", 0, 8)
		for index = (DebuffColumns+2), DebuffLimit do
		  iconTable[index]:ClearAllPoints()
		  iconTable[index]:SetPoint("LEFT", iconTable[index-1], "RIGHT", 5, 0)
		end
	end
end




--* ---------------------------------------------------------------
--* AuraMonitor
--* ---------------------------------------------------------------

local AuraMonitor = CreateFrame("Frame", nil, nil)

local function EventUnitAura(unitid)
    if unitid then
        local frame = WidgetList[unitid]
        if frame then
            frame:Update()
        end
    end
end

local AuraEvents = {
	["UNIT_AURA"] = EventUnitAura,
}

local function AuraEventHandler(frame, event, ...)
    local unitid = ...

    if event then
        local eventFunction = AuraEvents[event]
        eventFunction(...)
    end

end

-----------------------------------------------------
-- External
-----------------------------------------------------

function TidyPlatesWidgets.UseSquareDebuffIcon()
	useWideIcons = false
	DebuffColumns = 5
	DebuffLimit = DebuffColumns * 2
	TidyPlates:ForceUpdate()
end

function TidyPlatesWidgets.UseWideDebuffIcon()
	useWideIcons = true
	DebuffColumns = 3
	DebuffLimit = DebuffColumns * 2
	TidyPlates:ForceUpdate()
end

function TidyPlatesWidgets.SetAuraFilter(func)
	if func and type(func) == 'function' then
		AuraFilterFunction = func
	end
end

function TidyPlatesWidgets.IsAuraShown(widget, aura)
    if widget and widget:IsShown() then
        return true
    end
end

function TidyPlatesWidgets.EnableAuraWatcher()
	AuraMonitor:SetScript("OnEvent", AuraEventHandler)

	for event in pairs(AuraEvents) do AuraMonitor:RegisterEvent(event) end
end

function TidyPlatesWidgets.DisableAuraWatcher()
	AuraMonitor:SetScript("OnEvent", nil)
	AuraMonitor:UnregisterAllEvents()

	for unitid, widget in pairs(WidgetList) do
		if self == widget then WidgetList[unitid] = nil end
	end
end

TidyPlatesWidgets.CreateAuraWidget = AuraWidget.Create

-----------------------------------------------------
-- Soon to be deprecated
-----------------------------------------------------

local PlayerDispelCapabilities = {
	["Curse"] = false,
	["Disease"] = false,
	["Magic"] = false,
	["Poison"] = false,
}

local function UpdatePlayerDispelTypes()
	PlayerDispelCapabilities["Curse"] = IsSpellKnown(51886) or IsSpellKnown(475) or IsSpellKnown(2782)
	PlayerDispelCapabilities["Poison"] = IsSpellKnown(2782) or IsSpellKnown(32375) or IsSpellKnown(4987) or (IsSpellKnown(527) and IsSpellKnown(33167))
	PlayerDispelCapabilities["Magic"] = (IsSpellKnown(4987) and IsSpellKnown(53551)) or (IsSpellKnown(2782) and IsSpellKnown(88423)) or (IsSpellKnown(527) and IsSpellKnown(33167)) or (IsSpellKnown(51886) and IsSpellKnown(77130)) or IsSpellKnown(32375)
	PlayerDispelCapabilities["Disease"] = IsSpellKnown(4987) or IsSpellKnown(528)
end

local function CanPlayerDispel(debuffType)
	return PlayerDispelCapabilities[debuffType or ""]
end

TidyPlatesWidgets.CanPlayerDispel = CanPlayerDispel


