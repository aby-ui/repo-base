
	--Spinning Cooldown Frame
	--[[
	frame.Cooldown = CreateFrame("Cooldown", nil, frame, "TidyPlatesAuraWidgetCooldown")
	frame.Cooldown:SetAllPoints(frame)
	frame.Cooldown:SetReverse(true)
	frame.Cooldown:SetHideCountdownNumbers(true)
	--]]


TidyPlatesWidgets.DebuffWidgetBuild = 2

local PlayerGUID = UnitGUID("player")
local PolledHideIn = TidyPlatesWidgets.PolledHideIn
local FilterFunction = function() return 1 end
local AuraMonitor = CreateFrame("Frame")
local WatcherIsEnabled = false
local WidgetList, WidgetGUID = {}, {}

local UpdateWidget

local TargetOfGroupMembers = {}
local DebuffColumns = 3
local DebuffLimit = 6
local inArena = false
local useWideIcons = true

local function DummyFunction() end

local function DefaultPreFilterFunction() return true end
local function DefaultFilterFunction(aura, unit) if aura and aura.duration and (aura.duration < 30) then return true end end

local AuraFilterFunction = DefaultFilterFunction
local AuraHookFunction

local AURA_TARGET_HOSTILE = 1
local AURA_TARGET_FRIENDLY = 2

local AURA_TYPE_BUFF = 1
local AURA_TYPE_DEBUFF = 6

-- Get a clean version of the function...  Avoid OmniCC interference
local CooldownNative = CreateFrame("Cooldown", nil, WorldFrame)
local SetCooldown = CooldownNative.SetCooldown

local _

local AuraType_Index = {
	["Buff"] = 1,
	["Curse"] = 2,
	["Disease"] = 3,
	["Magic"] = 4,
	["Poison"] = 5,
	["Debuff"] = 6,
}

local function SetFilter(func)
	if func and type(func) == "function" then
		FilterFunction = func
	end
end

local function GetAuraWidgetByGUID(guid)
	if guid then return WidgetGUID[guid] end
end

local function IsAuraShown(widget, aura)
		if widget and widget:IsShown() then
			return true
		end
end


-----------------------------------------------------
-- Default Filter
-----------------------------------------------------
local function DefaultFilterFunction(debuff)
	if (debuff.duration < 600) then
		return true
	end
end


-----------------------------------------------------
-- General Events
-----------------------------------------------------


local function EventUnitAura(unitid)
	local frame

	if unitid then frame = WidgetList[unitid] end

	if frame then UpdateWidget(frame) end

end



-----------------------------------------------------
-- Function Reference Lists
-----------------------------------------------------

local AuraEvents = {
	--["UNIT_TARGET"] = EventUnitTarget,
	["UNIT_AURA"] = EventUnitAura,
}

local function AuraEventHandler(frame, event, ...)
	local unitid = ...

	if event then
		local eventFunction = AuraEvents[event]
		eventFunction(...)
	end

end

-------------------------------------------------------------
-- Widget Object Functions
-------------------------------------------------------------

local function UpdateWidgetTime(frame, expiration)
	if expiration == 0 then
		frame.TimeLeft:SetText("")
	else
		local timeleft = expiration-GetTime()
		if timeleft > 60 then
			frame.TimeLeft:SetText(floor(timeleft/60).."m")
		else
			frame.TimeLeft:SetText(floor(timeleft))
			--frame.TimeLeft:SetText(floor(timeleft*10)/10)
		end
	end
end


local function UpdateIcon(frame, texture, duration, expiration, stacks, r, g, b)
	if frame and texture and expiration then
		-- Icon
		frame.Icon:SetTexture(texture)

		-- Stacks
		if stacks and stacks > 1 then frame.Stacks:SetText(stacks)
		else frame.Stacks:SetText("") end

		-- Highlight Coloring
		if r then
			frame.BorderHighlight:SetVertexColor(r, g or 1, b or 1)
			frame.BorderHighlight:Show()
			frame.Border:Hide()
		else frame.BorderHighlight:Hide(); frame.Border:Show()	end

		-- [[ Cooldown
		if duration and duration > 0 and expiration and expiration > 0 then
			SetCooldown(frame.Cooldown, expiration-duration, duration+.25)
			--frame.Cooldown:SetCooldown(expiration-duration, duration+.25)
		end
		--]]

		-- Expiration
		UpdateWidgetTime(frame, expiration)
		frame:Show()
		if expiration ~= 0 then PolledHideIn(frame, expiration) end

	elseif frame then
		PolledHideIn(frame, 0)
	end
end


local function AuraSortFunction(a,b)
	return a.priority < b.priority
end


local function UpdateIconGrid(frame, unitid)

		if not unitid then return end

		local unitReaction
		if UnitIsFriend("player", unitid) then unitReaction = AURA_TARGET_FRIENDLY
		else unitReaction = AURA_TARGET_HOSTILE end
		local unitIsNPC = not UnitPlayerControlled(unitid)

		local AuraIconFrames = frame.AuraIconFrames
		local storedAuras = {}
		local storedAuraCount = 0

		-- Cache displayable auras
		------------------------------------------------------------------------------------------------------
		-- This block will go through the auras on the unit and make a list of those that should
		-- be displayed, listed by priority.
		local auraIndex = 0
		local moreAuras = true

		local searchedDebuffs, searchedBuffs = false, false
		local auraFilter = "HARMFUL"

		repeat

			auraIndex = auraIndex + 1

			local aura = {}

			do
				local name, icon, stacks, auraType, duration, expiration, caster, isStealable, _, spellid = UnitAura(unitid, auraIndex, auraFilter)		-- UnitaAura

				aura.name = name
				aura.texture = icon
				aura.stacks = stacks
				aura.type = auraType
				aura.effect = auraFilter
				aura.duration = duration
				aura.reaction = unitReaction
                aura.isNPC = unitIsNPC
                aura.isStealable = isStealable
				aura.expiration = expiration
				aura.caster = caster
				aura.spellid = spellid
				aura.unit = unitid 		-- unitid of the plate
			end

			-- Gnaw , false, icon, 0 stacks, nil type, duration 1, expiration 8850.436, caster pet, false, false, 91800

			-- Auras are evaluated by an external function
			-- Pre-filtering before the icon grid is populated
			if aura.name then
				local show, priority, r, g, b = AuraFilterFunction(aura)
				--print(aura.name, show, priority)
				--show = true
				-- Store Order/Priority
				if show then

					aura.priority = priority or 10
					aura.r, aura.g, aura.b = r, g, b

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


		-- Display Auras
		------------------------------------------------------------------------------------------------------
		local AuraSlotCount = 1
		if storedAuraCount > 0 then
			frame:Show()
			sort(storedAuras, AuraSortFunction)

			for index = 1,  storedAuraCount do
				if AuraSlotCount > DebuffLimit then break end
				local aura = storedAuras[index]
				if aura.spellid and aura.expiration then

					-- Call function to display the aura
					UpdateIcon(AuraIconFrames[AuraSlotCount], aura.texture, aura.duration, aura.expiration, aura.stacks, aura.r, aura.g, aura.b)

					AuraSlotCount = AuraSlotCount + 1
					frame.currentAuraCount = index
				end
			end

		end

		-- Clear Extra Slots
		for AuraSlotEmpty = AuraSlotCount, DebuffLimit do UpdateIcon(AuraIconFrames[AuraSlotEmpty]) end

end

function UpdateWidget(frame)
		local unitid = frame.unitid

		UpdateIconGrid(frame, unitid)
end

-- Context Update (mouseover, target change)
local function UpdateWidgetContext(frame, unit)
	local unitid = unit.unitid
	frame.unitid = unitid

	WidgetList[unitid] = frame

	UpdateWidget(frame)
end

local function ClearWidgetContext(frame)
	for unitid, widget in pairs(WidgetList) do
		if frame == widget then WidgetList[unitid] = nil end
	end
end

local function ExpireFunction(icon)
	UpdateWidget(icon.Parent)
end

-------------------------------------------------------------
-- Widget Frames
-------------------------------------------------------------
local WideArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameWide"
local SquareArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameSquare"
local WideHighlightArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameHighlightWide"
local SquareHighlightArt = "Interface\\AddOns\\TidyPlatesWidgets\\Aura\\AuraFrameHighlightSquare"
local AuraFont = "FONTS\\ARIALN.TTF"

local function Enable()
	AuraMonitor:SetScript("OnEvent", AuraEventHandler)

	for event in pairs(AuraEvents) do AuraMonitor:RegisterEvent(event) end

	--TidyPlatesUtility:EnableGroupWatcher()
	WatcherIsEnabled = true

end

local function Disable()
	AuraMonitor:SetScript("OnEvent", nil)
	AuraMonitor:UnregisterAllEvents()
	WatcherIsEnabled = false

	for unitid, widget in pairs(WidgetList) do
		if frame == widget then WidgetList[unitid] = nil end
	end

end


local function TransformWideAura(frame)
	frame:SetWidth(26.5)
	frame:SetHeight(14.5)
	-- Icon
	frame.Icon:SetAllPoints(frame)
	frame.Icon:SetTexCoord(.07, 1-.07, .23, 1-.23)  -- obj:SetTexCoord(left,right,top,bottom)
	-- Border
	frame.Border:SetWidth(32); frame.Border:SetHeight(32)
	frame.Border:SetPoint("CENTER", 1, -2)
	frame.Border:SetTexture(WideArt)
	-- Highlight
	frame.BorderHighlight:SetAllPoints(frame.Border)
	frame.BorderHighlight:SetTexture(WideHighlightArt)
	--  Time Text
	frame.TimeLeft:SetFont(AuraFont ,9, "OUTLINE")
	frame.TimeLeft:SetShadowOffset(1, -1)
	frame.TimeLeft:SetShadowColor(0,0,0,1)
	frame.TimeLeft:SetPoint("RIGHT", 0, 8)
	frame.TimeLeft:SetWidth(26)
	frame.TimeLeft:SetHeight(16)
	frame.TimeLeft:SetJustifyH("RIGHT")
	--  Stacks
	frame.Stacks:SetFont(AuraFont,10, "OUTLINE")
	frame.Stacks:SetShadowOffset(1, -1)
	frame.Stacks:SetShadowColor(0,0,0,1)
	frame.Stacks:SetPoint("RIGHT", 0, -6)
	frame.Stacks:SetWidth(26)
	frame.Stacks:SetHeight(16)
	frame.Stacks:SetJustifyH("RIGHT")
end

local function TransformSquareAura(frame)
	frame:SetWidth(16.5)
	frame:SetHeight(14.5)
	-- Icon
	frame.Icon:SetAllPoints(frame)
	frame.Icon:SetTexCoord(.10, 1-.07, .12, 1-.12)  -- obj:SetTexCoord(left,right,top,bottom)
	-- Border
	frame.Border:SetWidth(32); frame.Border:SetHeight(32)
	frame.Border:SetPoint("CENTER", 0, -2)
	frame.Border:SetTexture(SquareArt)
	-- Highlight
	frame.BorderHighlight:SetAllPoints(frame.Border)
	frame.BorderHighlight:SetTexture(SquareHighlightArt)
	--  Time Text
	frame.TimeLeft:SetFont(AuraFont ,9, "OUTLINE")
	frame.TimeLeft:SetShadowOffset(1, -1)
	frame.TimeLeft:SetShadowColor(0,0,0,1)
	frame.TimeLeft:SetPoint("RIGHT", 0, 8)
	frame.TimeLeft:SetWidth(26)
	frame.TimeLeft:SetHeight(16)
	frame.TimeLeft:SetJustifyH("RIGHT")
	--  Stacks
	frame.Stacks:SetFont(AuraFont,10, "OUTLINE")
	frame.Stacks:SetShadowOffset(1, -1)
	frame.Stacks:SetShadowColor(0,0,0,1)
	frame.Stacks:SetPoint("RIGHT", 0, -6)
	frame.Stacks:SetWidth(26)
	frame.Stacks:SetHeight(16)
	frame.Stacks:SetJustifyH("RIGHT")
end

-- Create a Wide Aura Icon
local function CreateAuraIcon(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame.unit = nil
	frame.Parent = parent

	frame.Icon = frame:CreateTexture(nil, "BACKGROUND")
	frame.Border = frame:CreateTexture(nil, "ARTWORK")
	frame.BorderHighlight = frame:CreateTexture(nil, "ARTWORK")
	frame.Cooldown = CreateFrame("Cooldown", nil, frame, "TidyPlatesAuraWidgetCooldown")

	frame.Cooldown:SetAllPoints(frame)
	frame.Cooldown:SetReverse(true)
	frame.Cooldown:SetHideCountdownNumbers(true)
	frame.Cooldown:SetDrawEdge(true)

	-- Text
	--frame.TimeLeft = frame:CreateFontString(nil, "OVERLAY")
	frame.TimeLeft = frame.Cooldown:CreateFontString(nil, "OVERLAY")
	--frame.Stacks = frame:CreateFontString(nil, "OVERLAY")
	frame.Stacks = frame.Cooldown:CreateFontString(nil, "OVERLAY")

	-- Information about the currently displayed aura
	frame.AuraInfo = {
		Name = "",
		Icon = "",
		Stacks = 0,
		Expiration = 0,
		Type = "",
	}

	frame.Expire = ExpireFunction
	frame.Poll = UpdateWidgetTime
	frame:Hide()

	return frame
end

local function UpdateIconConfig(frame)
	local iconTable = frame.AuraIconFrames

	if iconTable then
		-- Create Icons
		for index = 1, DebuffLimit do
			local icon = iconTable[index] or CreateAuraIcon(frame)
			iconTable[index] = icon
			-- Apply Style
			if useWideIcons then TransformWideAura(icon) else TransformSquareAura(icon) end
		end

		-- Set Anchors
		iconTable[1]:ClearAllPoints()
		iconTable[1]:SetPoint("LEFT", frame)
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

local function UpdateWidgetConfig(frame)
	UpdateIconConfig(frame)
end


-- Create the Main Widget Body and Icon Array
local function CreateAuraWidget(parent, style)

	-- Create Base frame
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(128); frame:SetHeight(32); frame:Show()
	--frame.PollFunction = UpdateWidgetTime

	-- Create Icon Grid
	frame.AuraIconFrames = {}
	UpdateIconConfig(frame)

	-- Functions
	frame._Hide = frame.Hide
	frame.Hide = function() ClearWidgetContext(frame); frame:_Hide() end

	frame.Filter = nil
	frame.UpdateContext = UpdateWidgetContext
	frame.Update = UpdateWidgetContext
	frame.UpdateConfig = UpdateWidgetConfig
	frame.UpdateTarget = UpdateWidgetTarget
	return frame
end

local function UseSquareDebuffIcon()
	useWideIcons = false
	DebuffColumns = 5
	DebuffLimit = DebuffColumns * 2
	TidyPlates:ForceUpdate()
end

local function UseWideDebuffIcon()
	useWideIcons = true
	DebuffColumns = 3
	DebuffLimit = DebuffColumns * 2
	TidyPlates:ForceUpdate()
end


local function SetAuraFilter(func)
	if func and type(func) == 'function' then
		AuraFilterFunction = func
	end
end


-----------------------------------------------------
-- External
-----------------------------------------------------
-- TidyPlatesWidgets.GetAuraWidgetByGUID = GetAuraWidgetByGUID
TidyPlatesWidgets.IsAuraShown = IsAuraShown

TidyPlatesWidgets.UseSquareDebuffIcon = UseSquareDebuffIcon
TidyPlatesWidgets.UseWideDebuffIcon = UseWideDebuffIcon

TidyPlatesWidgets.SetAuraFilter = SetAuraFilter


TidyPlatesWidgets.CreateAuraWidget = CreateAuraWidget

TidyPlatesWidgets.EnableAuraWatcher = Enable
TidyPlatesWidgets.DisableAuraWatcher = Disable

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


