local Tags = {afkStatus = {}, offlineStatus = {}, customEvents = {}, powerMap = {}, moduleKey = "tags"}
local tagPool, functionPool, temp, regFontStrings, powerMap = {}, {}, {}, {}, Tags.powerMap
local L = ShadowUF.L

ShadowUF.Tags = Tags

-- Map the numeric index to the string
local numerics = {}
for id, color in pairs(PowerBarColor) do
	if( type(id) == "number" ) then
		numerics[color] = id
	end
end

for id, color in pairs(PowerBarColor) do
	if( type(id) == "string" and numerics[color] ) then
		powerMap[numerics[color]] = id
		powerMap[id] = true
	end
end

-- Avoid having to do string.match on every event
local powerFilters = {["SUF_POWERTYPE:CURRENT"] = "CURRENT"}
for powerType in pairs(PowerBarColor) do
	if( type(powerType) == "string" ) then
		powerFilters["SUF_POWERTYPE:" .. powerType] = powerType
	end
end

-- Register the associated events with all the tags
function Tags:RegisterEvents(parent, fontString, tags)
	local hasPowerFilters;
	-- Strip parantheses and anything inside them
	for tag in string.gmatch(tags, "%[(.-)%]") do
		-- The reason the original %b() match won't work, with [( ()group())] (or any sort of tag with ( or )
		-- was breaking the logic and stripping the entire tag, this is a quick fix to stop that.
		local tagKey = select(2, string.match(tag, "(%b())([%w%p]+)(%b())"))
		if( not tagKey ) then tagKey = select(2, string.match(tag, "(%b())([%w%p]+)")) end
		if( not tagKey ) then tagKey = string.match(tag, "([%w%p]+)(%b())") end

		tag = tagKey or tag

		local tagEvents = Tags.defaultEvents[tag] or ShadowUF.db.profile.tags[tag] and ShadowUF.db.profile.tags[tag].events
		if( tagEvents ) then
			for event in string.gmatch(tagEvents, "%S+") do
				-- Power filter event, store it instead
				if( powerFilters[event] ) then
					fontString.powerFilters = fontString.powerFilters or {}
					fontString.powerFilters[powerFilters[event]] = true

					if( powerFilters[event] == "CURRENT" ) then
						if( not hasPowerFilters ) then
							parent:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "UpdatePowerType")
							parent:RegisterUpdateFunc(self, "UpdatePowerType")
						end

						hasPowerFilters = true
					end

				-- Custom event registered by another module
				elseif( self.customEvents[event] ) then
					self.customEvents[event]:EnableTag(parent, fontString)
					fontString[event] = true
				-- Unit event
				elseif( Tags.eventType[event] ~= "unitless" or ShadowUF.Units.unitEvents[event] ) then
					local success, err = pcall(parent.RegisterUnitEvent, parent, event, fontString, "UpdateTags")
					if not success then
						-- switch the tag back
						ShadowUF.Units.unitEvents[event] = false
						Tags.eventType[event] = "unitless"

						parent:RegisterNormalEvent(event, fontString, "UpdateTags")
					end
				-- Everything else
				else
					parent:RegisterNormalEvent(event, fontString, "UpdateTags")
				end

				-- register UNIT_MANA event since its the only event that fires after repopping at a spirit healer
				if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
					parent:RegisterUnitEvent("UNIT_MANA", fontString, "UpdateTags")

					if ( parent.unit == "player" ) then
						parent:RegisterNormalEvent("PLAYER_UNGHOST", fontString, "UpdateTags")
					end
				end
			end
		end
	end
end

-- Update the cached power type
function Tags:UpdatePowerType(frame)
	local powerID, powerType = UnitPowerType(frame.unit)
	if( not powerMap[powerType] ) then powerType = powerMap[powerID] or "ENERGY" end

	for _, fontString in pairs(frame.fontStrings) do
		if( fontString.UpdateTags ) then
			fontString.powerType = powerType
			fontString:UpdateTags()
		end
	end
end

-- This pretty much means a tag was updated in some way (or deleted) so we have to do a full update to get the new values shown
function Tags:Reload()
	-- Kill cached functions, ugly I know but it ensures its fully updated with the new data
	table.wipe(functionPool)
	table.wipe(ShadowUF.tagFunc)
	table.wipe(tagPool)

	-- Now update frames
	for fontString, tags in pairs(regFontStrings) do
		self:Register(fontString.parent, fontString, tags)
		fontString.parent:RegisterUpdateFunc(fontString, "UpdateTags")
		fontString:UpdateTags()
	end
end

-- This is for bars that can be shown or hidden often, like druid power
function Tags:FastRegister(frame, parent)
	if( not frame.fontStrings ) then return end

	for _, fontString in pairs(frame.fontStrings) do
		-- Re-register anything that was already registered and is part of the parent
		if( regFontStrings[fontString] and ( not parent or fontString.parentBar == parent ) ) then
			fontString.UpdateTags = tagPool[regFontStrings[fontString]]
			fontString:Show()
		end
	end
end

function Tags:FastUnregister(frame, parent)
	if( not frame.fontStrings ) then return end

	for _, fontString in pairs(frame.fontStrings) do
		-- Redirect the updates to not do anything and hide it
		if( regFontStrings[fontString] and ( not parent or fontString.parentBar == parent ) ) then
			fontString.UpdateTags = ShadowUF.noop
			fontString:Hide()
		end
	end
end


-- Register a font string with the tag system
local powerEvents = {["UNIT_POWER_UPDATE"] = true, ["UNIT_POWER_FREQUENT"] = true, ["UNIT_MAXPOWER"] = true}
local frequencyCache = {}
local function createTagFunction(tags, resetCache)
	if( tagPool[tags] and not resetCache ) then
		return tagPool[tags], frequencyCache[tags]
	end

	-- Using .- prevents supporting tags such as [foo ([)]. Supporting that and having a single pattern
	local formattedText = string.gsub(string.gsub(tags, "%%", "%%%%"), "[[].-[]]", "%%s")
	formattedText = string.gsub(formattedText, "|", "||")
	formattedText = string.gsub(formattedText, "||c", "|c")
	formattedText = string.gsub(formattedText, "||r", "|r")

	local args = {}
	local lowestFrequency = 9999

	for tag in string.gmatch(tags, "%[(.-)%]") do
		-- Tags that use pre or appends "foo(|)" etc need special matching, which is what this will handle
		local cachedFunc = not resetCache and functionPool[tag] or ShadowUF.tagFunc[tag]
		if( not cachedFunc ) then
			local hasPre, hasAp = true, true
			local tagKey = select(2, string.match(tag, "(%b())([%w%p]+)(%b())"))
			if( not tagKey ) then hasPre, hasAp = true, false tagKey = select(2, string.match(tag, "(%b())([%w%p]+)")) end
			if( not tagKey ) then hasPre, hasAp = false, true tagKey = string.match(tag, "([%w%p]+)(%b())") end

			frequencyCache[tag] = tagKey and (Tags.defaultFrequents[tagKey] or ShadowUF.db.profile.tags[tagKey] and ShadowUF.db.profile.tags[tagKey].frequency)

			local tagFunc = tagKey and ShadowUF.tagFunc[tagKey]
			if( tagFunc ) then
				local startOff, endOff = string.find(tag, tagKey)
				local pre = hasPre and string.sub(tag, 2, startOff - 2)
				local ap = hasAp and string.sub(tag, endOff + 2, -2)

				if( pre and ap ) then
					cachedFunc = function(...)
						local str = tagFunc(...)
						if( str ) then return pre .. str .. ap end
					end
				elseif( pre ) then
					cachedFunc = function(...)
						local str = tagFunc(...)
						if( str ) then return pre .. str end
					end
				elseif( ap ) then
					cachedFunc = function(...)
						local str = tagFunc(...)
						if( str ) then return str .. ap end
					end
				end

				functionPool[tag] = cachedFunc
			end
		else
			frequencyCache[tag] = Tags.defaultFrequents[tag] or ShadowUF.db.profile.tags[tag] and ShadowUF.db.profile.tags[tag].frequency
		end


		-- Figure out the lowest frequency rate we update at
		if( frequencyCache[tag] ) then
			lowestFrequency = math.min(lowestFrequency, frequencyCache[tag])
		end

		-- It's an invalid tag, simply return the tag itself wrapped in brackets
		if( not cachedFunc ) then
			functionPool[tag] = functionPool[tag] or function() return string.format("[%s-error]", tag) end
			cachedFunc = functionPool[tag]
		end

		table.insert(args, cachedFunc)
	end

	frequencyCache[tags] = lowestFrequency < 9999 and lowestFrequency or nil
	tagPool[tags] = function(fontString, frame, event, unit, powerType)
		-- we can only run on frames with units set
		if not fontString.parent.unit then
			return
		end

		if( event and powerType and fontString.powerFilters and powerEvents[event] ) then
			if( not fontString.powerFilters[powerType] and ( not fontString.powerFilters.CURRENT or fontString.powerType ~= powerType ) ) then
				return
			end
		end

		for id, func in pairs(args) do
			temp[id] = func(fontString.parent.unit, fontString.parent.unitOwner, fontString) or ""
		end

		fontString:SetFormattedText(formattedText, unpack(temp))
	end

	return tagPool[tags], frequencyCache[tags]
end

local function createMonitorTimer(fontString, frequency)
	if( not fontString.monitor or fontString.monitor.frequency ~= frequency ) then
		if fontString.monitor then
			fontString.monitor:Cancel()
		end
		fontString.monitor  = C_Timer.NewTicker(frequency, function() fontString:UpdateTags() end)
		fontString.monitor.frequency = frequency
	end
end

local function cancelMonitorTimer(fontString)
	if( fontString.monitor ) then
		fontString.monitor:Cancel()
		fontString.monitor = nil
	end
end

function Tags:Register(parent, fontString, tags, resetCache)
	-- Unregister the font string first if we did register it already
	if( fontString.UpdateTags ) then
		self:Unregister(fontString)
	end

	fontString.parent = parent
	regFontStrings[fontString] = tags

	-- And give other frames an easy way to force an update
	local frequency
	fontString.UpdateTags, frequency = createTagFunction(tags, resetCache)

	if( frequency ) then
		createMonitorTimer(fontString, frequency)
	elseif( fontString.monitor ) then
		cancelMonitorTimer(fontString)
	end

	-- Register any needed event
	self:RegisterEvents(parent, fontString, tags)
end

function Tags:Unregister(fontString)
	regFontStrings[fontString] = nil

	-- Unregister it as using HC
	for key, module in pairs(self.customEvents) do
		if( fontString[key] ) then
			fontString[key] = nil
			module:DisableTag(fontString.parent, fontString)
		end
	end

	-- Kill any tag data
	cancelMonitorTimer(fontString)
	fontString.parent:UnregisterAll(fontString)
	fontString.powerFilters = nil
	fontString.UpdateTags = nil
	fontString:SetText("")

	-- See if we need to unregister events
	local parent = fontString.parent
	local hasPowerFilter
	for _, f in pairs(parent.fontStrings) do
		if( f.powerFilters and f.powerFilters.CURRENT ) then
			hasPowerFilter = true
			break
		end
	end

	if( not hasPowerFilter ) then
		parent:UnregisterSingleEvent("UNIT_DISPLAYPOWER", self)
		parent:UnregisterUpdateFunc(self, "UpdatePowerType")
	end
end

-- Helper functions for tags, the reason I store it in ShadowUF is it's easier to type ShadowUF than ShadowUF.modules.Tags, and simpler for users who want to implement it.
function ShadowUF:Hex(r, g, b)
	if( type(r) == "table" ) then
		if( r.r ) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

function ShadowUF:FormatLargeNumber(number)
	if( number < 9999 ) then
		return number
	elseif( number < 999999 ) then
		return string.format("%.1fk", number / 1000)
	elseif( number < 99999999 ) then
		return string.format("%.2fm", number / 1000000)
	end

	return string.format("%dm", number / 1000000)
end

function ShadowUF:SmartFormatNumber(number)
	if( number < 999999 ) then
		return number
	elseif( number < 99999999 ) then
		return string.format("%.2fm", number / 1000000)
	end

	return string.format("%dm", number / 1000000)
end

function ShadowUF:GetClassColor(unit)
	if( not UnitIsPlayer(unit) ) then
		return nil
	end

	local class = select(2, UnitClass(unit))
	return class and ShadowUF:Hex(ShadowUF.db.profile.classColors[class])
end

function ShadowUF:FormatShortTime(seconds)
	if( seconds >= 3600 ) then
		return string.format("%dh", seconds / 3600)
	elseif( seconds >= 60 ) then
		return string.format("%dm", seconds / 60)
	end

	return string.format("%ds", seconds)
end

-- Name abbreviation
local function abbreviateName(text)
	return string.sub(text, 1, 1) .. "."
end

Tags.abbrevCache = setmetatable({}, {
	__index = function(tbl, val)
		val = string.gsub(val, "([^%s]+) ", abbreviateName)
		rawset(tbl, val, val)
		return val
end})

-- Going to have to start using an env wrapper for tags I think
local Druid = {}
Druid.CatForm = GetSpellInfo(768)
Druid.MoonkinForm = GetSpellInfo(24858)
Druid.TravelForm = GetSpellInfo(783)
Druid.BearForm = GetSpellInfo(5487)
Druid.TreeForm = GetSpellInfo(33891)
Druid.AquaticForm = GetSpellInfo(1066)
Druid.SwiftFlightForm = GetSpellInfo(40120)
Druid.FlightForm = GetSpellInfo(33943)
ShadowUF.Druid = Druid

Tags.defaultTags = {
	["rune:timer"] = [[function(unit, unitOwner, fontString)
		local endTime = fontString.block.endTime
		return endTime and string.format("%.1f", endTime - GetTime()) or nil
	end]],
	["totem:timer"] = [[function(unit, unitOwner, fontString)
		local endTime = fontString.block.endTime
		return endTime and string.format("%.1f", endTime - GetTime()) or nil
	end]],
	["hp:color"] = [[function(unit, unitOwner)
		return ShadowUF:Hex(ShadowUF.modules.healthBar.getGradientColor(unit))
	end]],
	["short:druidform"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end

		local Druid = ShadowUF.Druid
		if( ShadowUF.UnitAuraBySpell(unit, Druid.CatForm) ) then
			return ShadowUF.L["C"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.TreeForm) ) then
			return ShadowUF.L["T"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.MoonkinForm) ) then
			return ShadowUF.L["M"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.BearForm) ) then
			return ShadowUF.L["B"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.SwiftFlightForm) or ShadowUF.UnitAuraBySpell(unit, Druid.FlightForm) ) then
			return ShadowUF.L["F"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.TravelForm) ) then
			return ShadowUF.L["T"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.AquaticForm) ) then
			return ShadowUF.L["A"]
		end
	end]],
	["druidform"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end

		local Druid = ShadowUF.Druid
		if( ShadowUF.UnitAuraBySpell(unit, Druid.CatForm) ) then
			return ShadowUF.L["Cat"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.TreeForm) ) then
			return ShadowUF.L["Tree"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.MoonkinForm) ) then
			return ShadowUF.L["Moonkin"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.BearForm) ) then
			return ShadowUF.L["Bear"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.SwiftFlightForm) or ShadowUF.UnitAuraBySpell(unit, Druid.FlightForm) ) then
			return ShadowUF.L["Flight"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.TravelForm) ) then
			return ShadowUF.L["Travel"]
		elseif( ShadowUF.UnitAuraBySpell(unit, Druid.AquaticForm) ) then
			return ShadowUF.L["Aquatic"]
		end
	end]],
	["guild"] = [[function(unit, unitOwner)
		return GetGuildInfo(unitOwner)
	end]],
	["abbrev:name"] = [[function(unit, unitOwner)
		local name = UnitName(unitOwner) or UNKNOWN
		return string.len(name) > 10 and ShadowUF.Tags.abbrevCache[name] or name
	end]],
	["unit:situation"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)
		if( state == 3 ) then
			return ShadowUF.L["Aggro"]
		elseif( state == 2 ) then
			return ShadowUF.L["High"]
		elseif( state == 1 ) then
			return ShadowUF.L["Medium"]
		end
	end]],
	["situation"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")
		if( state == 3 ) then
			return ShadowUF.L["Aggro"]
		elseif( state == 2 ) then
			return ShadowUF.L["High"]
		elseif( state == 1 ) then
			return ShadowUF.L["Medium"]
		end
	end]],
	["unit:color:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)

		return state and state > 0 and ShadowUF:Hex(GetThreatStatusColor(state))
	end]],
	["unit:color:aggro"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)

		return state and state >= 3 and ShadowUF:Hex(GetThreatStatusColor(state))
	end]],
	["color:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")

		return state and state > 0 and ShadowUF:Hex(GetThreatStatusColor(state))
	end]],
	["color:aggro"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")

		return state and state >= 3 and ShadowUF:Hex(GetThreatStatusColor(state))
	end]],
	--["unit:scaled:threat"] = [[function(unit, unitOwner, fontString)
	--	local scaled = select(3, UnitDetailedThreatSituation(unit))
	--	return scaled and string.format("%d%%", scaled)
	--end]],
	["scaled:threat"] = [[function(unit, unitOwner)
		local scaled = select(3, UnitDetailedThreatSituation("player", "target"))
		return scaled and string.format("%d%%", scaled)
	end]],
	["general:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player")
		if( state == 3 ) then
			return ShadowUF.L["Aggro"]
		elseif( state == 2 ) then
			return ShadowUF.L["High"]
		elseif( state == 1 ) then
			return ShadowUF.L["Medium"]
		end
	end]],
	["color:gensit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player")

		return state and state > 0 and ShadowUF:Hex(GetThreatStatusColor(state))
	end]],
	["status:time"] = [[function(unit, unitOwner)
		local offlineStatus = ShadowUF.Tags.offlineStatus
		if( not UnitIsConnected(unitOwner) ) then
			offlineStatus[unitOwner] = offlineStatus[unitOwner] or GetTime()
			return string.format(ShadowUF.L["Off:%s"], ShadowUF:FormatShortTime(GetTime() - offlineStatus[unitOwner]))
		end

		offlineStatus[unitOwner] = nil
	end]],
	["afk:time"] = [[function(unit, unitOwner)
		if( not UnitIsConnected(unitOwner) ) then return end

		local afkStatus = ShadowUF.Tags.afkStatus
		local status = UnitIsAFK(unitOwner) and ShadowUF.L["AFK:%s"] or UnitIsDND(unitOwner) and ShadowUF.L["DND:%s"]
		if( status ) then
			afkStatus[unitOwner] = afkStatus[unitOwner] or GetTime()
			return string.format(status, ShadowUF:FormatShortTime(GetTime() - afkStatus[unitOwner]))
		end

		afkStatus[unitOwner] = nil
	end]],
	["pvp:time"] = [[function(unit, unitOwner)
		if( GetPVPTimer() >= 300000 ) then
			return nil
		end

		return string.format(ShadowUF.L["PVP:%s"], ShadowUF:FormatShortTime(GetPVPTimer() / 1000))
	end]],
	["afk"] = [[function(unit, unitOwner, fontString)
		return UnitIsAFK(unitOwner) and ShadowUF.L["AFK"] or UnitIsDND(unitOwner) and ShadowUF.L["DND"]
	end]],
	["close"] = [[function(unit, unitOwner) return "|r" end]],
	["smartrace"] = [[function(unit, unitOwner)
		return UnitIsPlayer(unit) and ShadowUF.tagFunc.race(unit) or ShadowUF.tagFunc.creature(unit)
	end]],
	["reactcolor"] = [[function(unit, unitOwner)
		local color
		if( not UnitIsFriend(unit, "player") and UnitPlayerControlled(unit) ) then
			if( UnitCanAttack("player", unit) ) then
				color = ShadowUF.db.profile.healthColors.hostile
			else
				color = ShadowUF.db.profile.healthColors.enemyUnattack
			end
		elseif( UnitReaction(unit, "player") ) then
			local reaction = UnitReaction(unit, "player")
			if( reaction > 4 ) then
				color = ShadowUF.db.profile.healthColors.friendly
			elseif( reaction == 4 ) then
				color = ShadowUF.db.profile.healthColors.neutral
			elseif( reaction < 4 ) then
				color = ShadowUF.db.profile.healthColors.hostile
			end
		end

		return color and ShadowUF:Hex(color)
	end]],
	["class"] = [[function(unit, unitOwner)
		return UnitIsPlayer(unit) and UnitClass(unit)
	end]],
	["classcolor"] = [[function(unit, unitOwner) return ShadowUF:GetClassColor(unit) end]],
	["creature"] = [[function(unit, unitOwner) return UnitCreatureFamily(unit) or UnitCreatureType(unit) end]],
	["curhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		return ShadowUF:FormatLargeNumber(UnitHealth(unit))
	end]],
	["colorname"] = [[function(unit, unitOwner)
		local color = ShadowUF:GetClassColor(unitOwner)
		local name = UnitName(unitOwner) or UNKNOWN
		if( not color ) then
			return name
		end

		return string.format("%s%s|r", color, name)
	end]],
	["curpp"] = [[function(unit, unitOwner)
		if( UnitPowerMax(unit) <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end

		return ShadowUF:FormatLargeNumber(UnitPower(unit))
	end]],
	["curmaxhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		return string.format("%s/%s", ShadowUF:FormatLargeNumber(UnitHealth(unit)), ShadowUF:FormatLargeNumber(UnitHealthMax(unit)))
	end]],
	["smart:curmaxhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		return string.format("%s/%s", ShadowUF:SmartFormatNumber(UnitHealth(unit)), ShadowUF:SmartFormatNumber(UnitHealthMax(unit)))
	end]],
	["absolutehp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		return string.format("%s/%s", UnitHealth(unit), UnitHealthMax(unit))
	end]],
	["abscurhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		return UnitHealth(unit)
	end]],
	["absmaxhp"] = [[function(unit, unitOwner) return UnitHealthMax(unit) end]],
	["abscurpp"] = [[function(unit, unitOwner)
		if( UnitPowerMax(unit) <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end

		return UnitPower(unit)
	end]],
	["absmaxpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		return power > 0 and power or nil
	end]],
	["absolutepp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", maxPower)
		elseif( maxPower <= 0 ) then
			return nil
		end

		return string.format("%s/%s", power, maxPower)
	end]],
	["curmaxpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", ShadowUF:FormatLargeNumber(maxPower))
		elseif( maxPower <= 0 ) then
			return nil
		end

		return string.format("%s/%s", ShadowUF:FormatLargeNumber(power), ShadowUF:FormatLargeNumber(maxPower))
	end]],
	["smart:curmaxpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", maxPower)
		elseif( maxPower <= 0 ) then
			return nil
		end

		return string.format("%s/%s", ShadowUF:SmartFormatNumber(power), ShadowUF:SmartFormatNumber(maxPower))
	end]],
	["levelcolor"] = [[function(unit, unitOwner)
		if( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
			return nil
		end

		local level = UnitLevel(unit)
		if( level < 0 and UnitClassification(unit) == "worldboss" ) then
			return nil
		end

		if( UnitCanAttack("player", unit) ) then
			local color = ShadowUF:Hex(GetQuestDifficultyColor(level > 0 and level or 99))
			if( not color ) then
				return level > 0 and level or "??"
			end

			return color .. (level > 0 and level or "??") .. "|r"
		else
			return level > 0 and level or "??"
		end
	end]],
	["faction"] = [[function(unit, unitOwner) return UnitFactionGroup(unitOwner) end]],
	["level"] = [[function(unit, unitOwner)
		if( UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) ) then
			return UnitBattlePetLevel(unit)
		end

		local level = UnitLevel(unit)
		return level > 0 and level or UnitClassification(unit) ~= "worldboss" and "??" or nil
	end]],
	["maxhp"] = [[function(unit, unitOwner) return ShadowUF:FormatLargeNumber(UnitHealthMax(unit)) end]],
	["maxpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		if( power <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end

		return ShadowUF:FormatLargeNumber(power)
	end]],
	["missinghp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end

		local missing = UnitHealthMax(unit) - UnitHealth(unit)
		if( missing <= 0 ) then return nil end
		return "-" .. ShadowUF:FormatLargeNumber(missing)
	end]],
	["missingpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		if( power <= 0 ) then
			return nil
		end

		local missing = power - UnitPower(unit)
		if( missing <= 0 ) then return nil end
		return "-" .. ShadowUF:FormatLargeNumber(missing)
	end]],
	["def:name"] = [[function(unit, unitOwner)
		local deficit = ShadowUF.tagFunc.missinghp(unit, unitOwner)
		if( deficit ) then return deficit end

		return ShadowUF.tagFunc.name(unit, unitOwner)
	end]],
	["name"] = [[function(unit, unitOwner) return UnitName(unitOwner) or UNKNOWN end]],
	["server"] = [[function(unit, unitOwner)
		local server = select(2, UnitName(unitOwner))
		if( UnitRealmRelationship(unitOwner) == LE_REALM_RELATION_VIRTUAL ) then
			return nil
		end

		return server ~= "" and server or nil
	end]],
	["perhp"] = [[function(unit, unitOwner)
		local max = UnitHealthMax(unit)
		if( max <= 0 or UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) ) then
			return "0%"
		end

		return math.floor(UnitHealth(unit) / max * 100 + 0.5) .. "%"
	end]],
	["perpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		if( maxPower <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) ) then
			return "0%"
		end

		return string.format("%d%%", math.floor(UnitPower(unit) / maxPower * 100 + 0.5))
	end]],
	["plus"] = [[function(unit, unitOwner) local classif = UnitClassification(unit) return (classif == "elite" or classif == "rareelite") and "+" end]],
	["race"] = [[function(unit, unitOwner) return UnitRace(unit) end]],
	["rare"] = [[function(unit, unitOwner) local classif = UnitClassification(unit) return (classif == "rare" or classif == "rareelite") and ShadowUF.L["Rare"] end]],
	["sex"] = [[function(unit, unitOwner) local sex = UnitSex(unit) return sex == 2 and ShadowUF.L["Male"] or sex == 3 and ShadowUF.L["Female"] end]],
	["smartclass"] = [[function(unit, unitOwner) return UnitIsPlayer(unit) and ShadowUF.tagFunc.class(unit) or ShadowUF.tagFunc.creature(unit) end]],
	["status"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return ShadowUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return ShadowUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return ShadowUF.L["Offline"]
		end
	end]],
	["sshards"] = [[function(unit, unitOwner)
		local points = UnitPower(ShadowUF.playerUnit, Enum.PowerType.SoulShards)
		return points and points > 0 and points
	end]],
	["hpower"] = [[function(unit, unitOwner)
		local points = UnitPower(ShadowUF.playerUnit, Enum.PowerType.HolyPower)
		return points and points > 0 and points
	end]],
	["monk:chipoints"] = [[function(unit, unitOwner)
		local points = UnitPower(ShadowUF.playerUnit, Enum.PowerType.Chi)
		return points and points > 0 and points
	end]],
	["cpoints"] = [[function(unit, unitOwner)
		if( UnitHasVehicleUI("player") and UnitHasVehiclePlayerFrameUI("player") ) then
			local points = GetComboPoints("vehicle")
			if( points == 0 ) then
				points = GetComboPoints("vehicle", "vehicle")
			end

			return points
		else
			return UnitPower("player", Enum.PowerType.ComboPoints)
		end
	end]],
	["smartlevel"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		if( classif == "worldboss" ) then
			return ShadowUF.L["Boss"]
		else
			local plus = ShadowUF.tagFunc.plus(unit)
			local level = ShadowUF.tagFunc.level(unit)
			if( plus ) then
				return level .. plus
			else
				return level
			end
		end
	end]],
	["dechp"] = [[function(unit, unitOwner)
		local maxHealth = UnitHealthMax(unit)
		if( maxHealth <= 0 ) then
			return "0.0%"
		end

		return string.format("%.1f%%", (UnitHealth(unit) / maxHealth) * 100)
	end]],
	["classification"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		if( classif == "rare" ) then
			return ShadowUF.L["Rare"]
		elseif( classif == "rareelite" ) then
			return ShadowUF.L["Rare Elite"]
		elseif( classif == "elite" ) then
			return ShadowUF.L["Elite"]
		elseif( classif == "worldboss" ) then
			return ShadowUF.L["Boss"]
		elseif( classif == "minus" ) then
			return ShadowUF.L["Minion"]
		end

		return nil
	end]],
	["shortclassification"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		return classif == "rare" and "R" or classif == "rareelite" and "R+" or classif == "elite" and "+" or classif == "worldboss" and "B" or classif == "minus" and "M"
	end]],
	["group"] = [[function(unit, unitOwner)
		if( not UnitInRaid(unitOwner) ) then return nil end
		local name, server = UnitName(unitOwner)
		if( server and server ~= "" ) then
			name = string.format("%s-%s", name, server)
		end

		for i=1, GetNumGroupMembers() do
			local raidName, _, group = GetRaidRosterInfo(i)
			if( raidName == name ) then
				return group
			end
		end

		return nil
	end]],
	["druid:curpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		return ShadowUF:FormatLargeNumber(UnitPower(unit, Enum.PowerType.Mana))
	end]],
	["druid:abscurpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		return UnitPower(unit, Enum.PowerType.Mana)
	end]],
	["druid:curmaxpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end

		local maxPower = UnitPowerMax(unit, Enum.PowerType.Mana)
		local power = UnitPower(unit, Enum.PowerType.Mana)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", ShadowUF:FormatLargeNumber(maxPower))
		elseif( maxPower == 0 and power == 0 ) then
			return nil
		end

		return string.format("%s/%s", ShadowUF:FormatLargeNumber(power), ShadowUF:FormatLargeNumber(maxPower))
	end]],
	["druid:absolutepp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end

		return UnitPower(unit, Enum.PowerType.Mana)
	end]],
	["sec:curpp"] = [[function(unit, unitOwner)
		local class = select(2, UnitClass(unit))
		local powerType = UnitPowerType(unit)
		if( class == "DRUID" ) then
			if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		elseif( class == "PRIEST" ) then
			if( powerType ~= Enum.PowerType.Insanity ) then return nil end
		elseif( class == "SHAMAN" ) then
			if( powerType ~= Enum.PowerType.Maelstrom ) then return nil end
		else
			return nil
		end
		return ShadowUF:FormatLargeNumber(UnitPower(unit, Enum.PowerType.Mana))
	end]],
	["sec:abscurpp"] = [[function(unit, unitOwner)
		local class = select(2, UnitClass(unit))
		local powerType = UnitPowerType(unit)
		if( class == "DRUID" ) then
			if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		elseif( class == "PRIEST" ) then
			if( powerType ~= Enum.PowerType.Insanity ) then return nil end
		elseif( class == "SHAMAN" ) then
			if( powerType ~= Enum.PowerType.Maelstrom ) then return nil end
		else
			return nil
		end
		return UnitPower(unit, Enum.PowerType.Mana)
	end]],
	["sec:curmaxpp"] = [[function(unit, unitOwner)
		local class = select(2, UnitClass(unit))
		local powerType = UnitPowerType(unit)
		if( class == "DRUID" ) then
			if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		elseif( class == "PRIEST" ) then
			if( powerType ~= Enum.PowerType.Insanity ) then return nil end
		elseif( class == "SHAMAN" ) then
			if( powerType ~= Enum.PowerType.Maelstrom ) then return nil end
		else
			return nil
		end

		local maxPower = UnitPowerMax(unit, Enum.PowerType.Mana)
		local power = UnitPower(unit, Enum.PowerType.Mana)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", ShadowUF:FormatLargeNumber(maxPower))
		elseif( maxPower == 0 and power == 0 ) then
			return nil
		end

		return string.format("%s/%s", ShadowUF:FormatLargeNumber(power), ShadowUF:FormatLargeNumber(maxPower))
	end]],
	["sec:absolutepp"] = [[function(unit, unitOwner)
		local class = select(2, UnitClass(unit))
		local powerType = UnitPowerType(unit)
		if( class == "DRUID" ) then
			if( powerType ~= Enum.PowerType.Rage and powerType ~= Enum.PowerType.Energy and powerType ~= Enum.PowerType.LunarPower ) then return nil end
		elseif( class == "PRIEST" ) then
			if( powerType ~= Enum.PowerType.Insanity ) then return nil end
		elseif( class == "SHAMAN" ) then
			if( powerType ~= Enum.PowerType.Maelstrom ) then return nil end
		else
			return nil
		end

		return UnitPower(unit, Enum.PowerType.Mana)
	end]],
	["per:incheal"] = [[function(unit, unitOwner, fontString)
		local heal = UnitGetIncomingHeals(unit)
		local maxHealth = UnitHealthMax(unit)
		return heal and heal > 0 and maxHealth > 0 and string.format("%d%%", (heal / maxHealth) * 100)
	end]],
	["abs:incheal"] = [[function(unit, unitOwner, fontString)
	    local heal = UnitGetIncomingHeals(unit)
		return heal and heal > 0 and string.format("%d", heal)
	end]],
	["incheal"] = [[function(unit, unitOwner, fontString)
	    local heal = UnitGetIncomingHeals(unit)
		return heal and heal > 0 and ShadowUF:FormatLargeNumber(heal)
	end]],
	["incheal:name"] = [[function(unit, unitOwner, fontString)
	    local heal = UnitGetIncomingHeals(unit)
		return heal and heal > 0 and string.format("+%d", heal) or ShadowUF.tagFunc.name(unit, unitOwner, fontString)
	end]],
	["monk:abs:stagger"] = [[function(unit, unitOwner)
		local stagger = UnitStagger(unit)
		return stagger and stagger > 0 and stagger
	end]],
	["monk:stagger"] = [[function(unit, unitOwner)
		local stagger = UnitStagger(unit)
		return stagger and stagger > 0 and ShadowUF:FormatLargeNumber(stagger)
	end]],
	["abs:incabsorb"] = [[function(unit, unitOwner, fontString)
	    local absorb = UnitGetTotalAbsorbs(unit)
		return absorb and absorb > 0 and absorb
	end]],
	["incabsorb"] = [[function(unit, unitOwner, fontString)
	    local absorb = UnitGetTotalAbsorbs(unit)
		return absorb and absorb > 0 and ShadowUF:FormatLargeNumber(absorb)
	end]],
	["incabsorb:name"] = [[function(unit, unitOwner, fontString)
	    local absorb = UnitGetTotalAbsorbs(unit)
		return absorb and absorb > 0 and string.format("+%d", absorb) or ShadowUF.tagFunc.name(unit, unitOwner, fontString)
	end]],
	["abs:healabsorb"] = [[function(unit, unitOwner, fontString)
	    local absorb = UnitGetTotalHealAbsorbs(unit)
		return absorb and absorb > 0 and absorb
	end]],
	["healabsorb"] = [[function(unit, unitOwner, fontString)
	    local absorb = UnitGetTotalHealAbsorbs(unit)
		return absorb and absorb > 0 and ShadowUF:FormatLargeNumber(absorb)
	end]],
	["unit:raid:targeting"] = [[function(unit, unitOwner, fontString)
		if( GetNumGroupMembers() == 0 ) then return nil end
		local guid = UnitGUID(unit)
		if( not guid ) then return "0" end

		local total = 0
		for i=1, GetNumGroupMembers() do
			local unit = ShadowUF.raidUnits[i]
			if( UnitGUID(ShadowUF.unitTarget[unit]) == guid ) then
				total = total + 1
			end
		end
		return total
	end]],
	["unit:raid:assist"] = [[function(unit, unitOwner, fontString)
		if( GetNumGroupMembers() == 0 ) then return nil end
		local guid = UnitGUID(ShadowUF.unitTarget[unit])
		if( not guid ) then return "--" end

		local total = 0
		for i=1, GetNumGroupMembers() do
			local unit = ShadowUF.raidUnits[i]
			if( UnitGUID(ShadowUF.unitTarget[unit]) == guid ) then
				total = total + 1
			end
		end
		return total
	end]],
}

-- Default tag events
Tags.defaultEvents = {
	["totem:timer"]				= "SUF_TOTEM_TIMER",
	["rune:timer"]				= "SUF_RUNE_TIMER",
	["hp:color"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH",
	["short:druidform"]			= "UNIT_AURA",
	["druidform"]				= "UNIT_AURA",
	["guild"]					= "UNIT_NAME_UPDATE",
	["per:incheal"]				= "UNIT_HEAL_PREDICTION",
	["abs:incheal"]				= "UNIT_HEAL_PREDICTION",
	["incheal:name"]			= "UNIT_HEAL_PREDICTION",
	["incheal"]					= "UNIT_HEAL_PREDICTION",
	["abs:incabsorb"]			= "UNIT_ABSORB_AMOUNT_CHANGED",
	["incabsorb"]				= "UNIT_ABSORB_AMOUNT_CHANGED",
	["incabsorb:name"]			= "UNIT_ABSORB_AMOUNT_CHANGED",
	["abs:healabsorb"]			= "UNIT_HEAL_ABSORB_AMOUNT_CHANGED",
	["healabsorb"]				= "UNIT_HEAL_ABSORB_AMOUNT_CHANGED",
	-- ["crtabs"]				= "CRTABS",
	-- ["abs:crtabs"]			= "CRTABS",
	-- ["crtabs:name"]			= "CRTABS",
	["afk"]						= "PLAYER_FLAGS_CHANGED", -- Yes, I know it's called PLAYER_FLAGS_CHANGED, but arg1 is the unit including non-players.
	["afk:time"]				= "PLAYER_FLAGS_CHANGED UNIT_CONNECTION",
	["status:time"]				= "UNIT_POWER_FREQUENT UNIT_CONNECTION",
	["pvp:time"]				= "PLAYER_FLAGS_CHANGED",
	["curhp"]               	= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION",
	["abscurhp"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION",
	["curmaxhp"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION",
	["absolutehp"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION",
	["smart:curmaxhp"]			= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION",
	["curpp"]               	= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT",
	["abscurpp"]            	= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER",
	["curmaxpp"]				= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER",
	["absolutepp"]				= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER",
	["smart:curmaxpp"]			= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER",
	["druid:curpp"]  	    	= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_DISPLAYPOWER",
	["druid:abscurpp"]      	= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_DISPLAYPOWER",
	["druid:curmaxpp"]			= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["druid:absolutepp"]		= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["sec:curpp"]  	    		= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_DISPLAYPOWER",
	["sec:abscurpp"]      		= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_DISPLAYPOWER",
	["sec:curmaxpp"]			= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["sec:absolutepp"]			= "SUF_POWERTYPE:MANA UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["sshards"]					= "SUF_POWERTYPE:SOUL_SHARDS UNIT_POWER_FREQUENT",
	["hpower"]					= "SUF_POWERTYPE:HOLY_POWER UNIT_POWER_FREQUENT",
	["level"]               	= "UNIT_LEVEL UNIT_FACTION PLAYER_LEVEL_UP",
	["levelcolor"]				= "UNIT_LEVEL UNIT_FACTION PLAYER_LEVEL_UP",
	["maxhp"]               	= "UNIT_MAXHEALTH",
	["def:name"]				= "UNIT_NAME_UPDATE UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT",
	["absmaxhp"]				= "UNIT_MAXHEALTH",
	["maxpp"]               	= "SUF_POWERTYPE:CURRENT UNIT_MAXPOWER",
	["absmaxpp"]				= "SUF_POWERTYPE:CURRENT UNIT_MAXPOWER",
	["missinghp"]           	= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION",
	["missingpp"]           	= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER",
	["name"]                	= "UNIT_NAME_UPDATE",
	["abbrev:name"]				= "UNIT_NAME_UPDATE",
	["server"]					= "UNIT_NAME_UPDATE",
	["colorname"]				= "UNIT_NAME_UPDATE",
	["perhp"]               	= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION",
	["perpp"]               	= "SUF_POWERTYPE:CURRENT UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_CONNECTION",
	["status"]              	= "UNIT_HEALTH UNIT_HEALTH_FREQUENT PLAYER_UPDATE_RESTING UNIT_CONNECTION",
	["smartlevel"]          	= "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED",
	["cpoints"]             	= "UNIT_POWER_FREQUENT PLAYER_TARGET_CHANGED",
	["rare"]                	= "UNIT_CLASSIFICATION_CHANGED",
	["classification"]      	= "UNIT_CLASSIFICATION_CHANGED",
	["shortclassification"] 	= "UNIT_CLASSIFICATION_CHANGED",
	["dechp"]					= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH",
	["group"]					= "GROUP_ROSTER_UPDATE",
	["unit:color:aggro"]		= "UNIT_THREAT_SITUATION_UPDATE",
	["color:aggro"]				= "UNIT_THREAT_SITUATION_UPDATE",
	["situation"]				= "UNIT_THREAT_SITUATION_UPDATE",
	["color:sit"]				= "UNIT_THREAT_SITUATION_UPDATE",
	["scaled:threat"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["general:sit"]				= "UNIT_THREAT_SITUATION_UPDATE",
	["color:gensit"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:scaled:threat"]		= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:color:sit"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:situation"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["monk:chipoints"]			= "SUF_POWERTYPE:LIGHT_FORCE UNIT_POWER_FREQUENT",
}

-- Default update frequencies for tag updating, used if it's needed to override the update speed
-- or it can't be purely event based
Tags.defaultFrequents = {
	["afk"] = 1,
	["afk:time"] = 1,
	["status:time"] = 1,
	["pvp:time"] = 1,
	["scaled:threat"] = 1,
	["unit:scaled:threat"] = 1,
	["unit:raid:targeting"] = 0.50,
	["unit:raid:assist"] = 0.50,
	["monk:stagger"] = 0.25,
	["monk:abs:stagger"] = 0.25
}

-- Default tag categories
Tags.defaultCategories = {
	["totem:timer"]				= "classtimer",
	["rune:timer"]				= "classtimer",
	["hp:color"]				= "health",
	["abs:incabsorb"]			= "health",
	["incabsorb"]				= "health",
	["incabsorb:name"]			= "health",
	["per:incheal"]				= "health",
	["abs:incheal"]				= "health",
	["incheal"]					= "health",
	["incheal:name"]			= "health",
	["smart:curmaxhp"]			= "health",
	["smart:curmaxpp"]			= "health",
	["afk"]						= "status",
	["afk:time"]				= "status",
	["status:time"]				= "status",
	["pvp:time"]				= "status",
	["cpoints"]					= "classspec",
	["smartlevel"]				= "classification",
	["classification"]			= "classification",
	["shortclassification"]		= "classification",
	["rare"]					= "classification",
	["plus"]					= "classification",
	["sex"]						= "misc",
	["smartclass"]				= "classification",
	["smartrace"]				= "classification",
	["status"]					= "status",
	["race"]					= "classification",
	["level"]					= "classification",
	["maxhp"]					= "health",
	["maxpp"]					= "power",
	["missinghp"]				= "health",
	["missingpp"]				= "power",
	["name"]					= "misc",
	["abbrev:name"]				= "misc",
	["server"]					= "misc",
	["perhp"]					= "health",
	["perpp"]					= "power",
	["class"]					= "classification",
	["classcolor"]				= "classification",
	["creature"]				= "classification",
	["short:druidform"]			= "classification",
	["druidform"]				= "classification",
	["curhp"]					= "health",
	["curpp"]					= "power",
	["curmaxhp"]				= "health",
	["curmaxpp"]				= "power",
	["levelcolor"]				= "classification",
	["def:name"]				= "health",
	["faction"]					= "classification",
	["colorname"]				= "misc",
	["guild"]					= "misc",
	["absolutepp"]				= "power",
	["absolutehp"]				= "health",
	["absmaxhp"]				= "health",
	["abscurhp"]				= "health",
	["absmaxpp"]				= "power",
	["abscurpp"]				= "power",
	["reactcolor"]				= "classification",
	["dechp"]					= "health",
	["group"]					= "misc",
	["close"]					= "misc",
	["druid:curpp"]     	    = "classspec",
	["druid:abscurpp"]  	    = "classspec",
	["druid:curmaxpp"]			= "classspec",
	["druid:absolutepp"]		= "classspec",
	["sec:curpp"]     	    	= "classspec",
	["sec:abscurpp"]  	    	= "classspec",
	["sec:curmaxpp"]			= "classspec",
	["sec:absolutepp"]			= "classspec",
	["sshards"]					= "classspec",
	["hpower"]					= "classspec",
	["situation"]				= "playerthreat",
	["color:sit"]				= "playerthreat",
	["scaled:threat"]			= "playerthreat",
	["general:sit"]				= "playerthreat",
	["color:gensit"]			= "playerthreat",
	["color:aggro"]				= "playerthreat",
	["unit:scaled:threat"]		= "threat",
	["unit:color:sit"]			= "threat",
	["unit:situation"]			= "threat",
	["unit:color:aggro"]		= "threat",
	["unit:raid:assist"]		= "raid",
	["unit:raid:targeting"] 	= "raid",
	["monk:chipoints"]			= "classspec",
	["monk:stagger"]			= "classspec",
	["monk:abs:stagger"]		= "classspec"
}

-- Default tag help
Tags.defaultHelp = {
	["totem:timer"]				= L["How many seconds a totem has left before disappearing."],
	["rune:timer"]				= L["How many seconds before a rune recharges."],
	["abs:incabsorb"]			= L["Absolute damage absorption value on the unit, if 10,000 damage will be absorbed, it will show 10,000."],
	["incabsorb"]				= L["Shorten damage absorption, if 13,000 damage will e absorbed, it will show 13k."],
	["incabsorb:name"]			= L["If the unit has a damage absorption shield on them, it will show the absolute absorb value, otherwise the units name."],
	["hp:color"]				= L["Color code based on percentage of HP left on the unit, this works the same way as the color by health option. But for text instead of the entire bar."],
	["guild"]					= L["Show's the units guild name if they are in a guild."],
	["short:druidform"]			= L["Short version of [druidform], C = Cat, B = Bear, F = Flight and so on."],
	["druidform"]				= L["Returns the units current form if they are a druid, Cat for Cat Form, Moonkin for Moonkin and so on."],
	["per:incheal"]				= L["Percent of the players current health that's being healed, if they have 100,000 total health and 15,000 is incoming then 15% is shown."],
	["abs:incheal"]				= L["Absolute incoming heal value, if 10,000 healing is incoming it will show 10,000."],
	["incheal"]					= L["Shorten incoming heal value, if 13,000 healing is incoming it will show 13k."],
	["abs:healabsorb"]			= L["Absolute heal absorb value, if 16,000 healing will be absorbed, it will show 16,000."],
	["healabsorb"]				= L["Shorten heal absorb value, if 17,000 healing will be absorbed, it will show 17k."],
	["incheal:name"]			= L["If the unit has heals incoming, it will show the absolute incoming heal value, otherwise it will show the units name."],
	["smart:curmaxhp"]			= L["Smart number formating for [curmaxhp], numbers below 1,000,000 are left as is, numbers above 1,000,000 will use the short version such as 1m."],
	["smart:curmaxpp"]			= L["Smart number formating for [curmaxpp], numbers below 1,000,000 are left as is, numbers above 1,000,000 will use the short version such as 1m."],
	["pvp:time"]				= L["Shows how long until your PVP flag drops, will not show if the flag is manually on or you are in a hostile zone.|n|nThis will only work for yourself, you cannot use it to see the time left on your party or raid."],
	["afk:time"]				= L["Shows how long an unit has been AFK or DND."],
	["status:time"]				= L["Shows how long an unit has been offline."],
	["afk"]						= L["Shows AFK, DND or nothing depending on the units away status."],
	["cpoints"]					= L["Total number of combo points you have on your target."],
	["hpower"]					= L["Total number of active holy power."],
	["sshards"]					= L["Total number of active soul shards."],
	["smartlevel"]				= L["Smart level, returns Boss for bosses, +50 for a level 50 elite mob, or just 80 for a level 80."],
	["classification"]			= L["Units classification, Rare, Rare Elite, Elite, Boss or Minion nothing is shown if they aren't any of those."],
	["shortclassification"]		= L["Short classifications, R for Rare, R+ for Rare Elite, + for Elite, B for Boss or M for Minion nothing is shown if they aren't any of those."],
	["rare"]					= L["Returns Rare if the unit is a rare or rare elite mob."],
	["plus"]					= L["Returns + if the unit is an elite or rare elite mob."],
	["sex"]						= L["Returns the units sex."],
	["smartclass"]				= L["If the unit is a player then class is returned, if it's a NPC then the creature type."],
	["smartrace"]				= L["If the unit is a player then race is returned, if it's a NPC then the creature type."],
	["status"]					= L["Shows Offline, Dead, Ghost or nothing depending on the units current status."],
	["race"]					= L["Units race, Blood Elf, Tauren, Troll (unfortunately) and so on."],
	["level"]					= L["Level without any coloring."],
	["maxhp"]					= L["Max health, uses a short format, 17750 is formatted as 17.7k, values below 10000 are formatted as is."],
	["maxpp"]					= L["Max power, uses a short format, 16000 is formatted as 16k, values below 10000 are formatted as is."],
	["missinghp"]				= L["Amount of health missing, if none is missing nothing is shown. Uses a short format, -18500 is shown as -18.5k, values below 10000 are formatted as is."],
	["missingpp"]				= L["Amount of power missing,  if none is missing nothing is shown. Uses a short format, -13850 is shown as 13.8k, values below 10000 are formatted as is."],
	["name"]					= L["Unit name"],
	["server"]					= L["Unit server, if they are from your server then nothing is shown."],
	["perhp"]					= L["Returns current health as a percentage, if the unit is dead or offline than that is shown instead."],
	["perpp"]					= L["Returns current power as a percentage."],
	["class"]					= L["Class name without coloring, use [classcolor][class][close] if you want the class name to be colored by class."],
	["classcolor"]				= L["Color code for the class, use [classcolor][class][close] if you want the class text to be colored by class"],
	["creature"]				= L["Creature type, returns Felguard if the unit is a Felguard, Wolf if it's a Wolf and so on."],
	["curhp"]					= L["Current health, uses a short format, 11500 is formatted as 11.5k, values below 10000 are formatted as is."],
	["curpp"]					= L["Current power, uses a short format, 12750 is formatted as 12.7k, values below 10000 are formatted as is."],
	["curmaxhp"]				= L["Current and maximum health, formatted as [curhp]/[maxhp], if the unit is dead or offline then that is shown instead."],
	["curmaxpp"]				= L["Current and maximum power, formatted as [curpp]/[maxpp]."],
	["levelcolor"]				= L["Returns the color code based off of the units level compared to yours. If you cannot attack them then no color is returned."],
	["def:name"]				= L["When the unit is mising health, the [missinghp] tag is shown, when they are at full health then the [name] tag is shown. This lets you see -1000 when they are missing 1000 HP, but their name when they are not missing any."],
	["faction"]					= L["Units alignment, Thrall will return Horde, Magni Bronzebeard will return Alliance."],
	["colorname"]				= L["Unit name colored by class."],
	["absolutepp"]				= L["Shows current and maximum power in absolute form, 18000 power will be showed as 18000 power."],
	["absolutehp"]				= L["Shows current and maximum health in absolute form, 17500 health will be showed as 17500 health."],
	["absmaxhp"]				= L["Shows maximum health in absolute form, 14000 health is showed as 14000 health."],
	["abscurhp"]				= L["Shows current health value in absolute form meaning 15000 health is shown as 15000."],
	["absmaxpp"]				= L["Shows maximum power in absolute form, 13000 power is showed as 13000 power."],
	["abscurpp"]				= L["Shows current power value in absolute form, 15000 power will be displayed as 1500 still."],
	["reactcolor"]				= L["Reaction color code, use [reactcolor][name][close] to color the units name by their reaction."],
	["dechp"]					= L["Shows the units health as a percentage rounded to the first decimal, meaning 61 out of 110 health is shown as 55.4%."],
	["abbrev:name"]				= L["Abbreviates unit names above 10 characters, \"Dark Rune Champion\" becomes \"D.R.Champion\" and \"Dark Rune Commoner\" becomes \"D.R.Commoner\"."],
	["group"]					= L["Shows current group number of the unit."],
	["close"]					= L["Closes a color code, prevents colors from showing up on text that you do not want it to."],
	["druid:curpp"]         	= string.format(L["Works the same as [%s], but this is only shown if the unit is in Cat or Bear form."], "currpp"),
	["druid:abscurpp"]      	= string.format(L["Works the same as [%s], but this is only shown if the unit is in Cat or Bear form."], "abscurpp"),
	["druid:curmaxpp"]			= string.format(L["Works the same as [%s], but this is only shown if the unit is in Cat or Bear form."], "curmaxpp"),
	["druid:absolutepp"]		= string.format(L["Works the same as [%s], but this is only shown if the unit is in Cat or Bear form."], "absolutepp"),
	["sec:curpp"]         		= string.format(L["Works the same as [%s], but always shows mana and is only shown if mana is a secondary power."], "curpp"),
	["sec:abscurpp"]      		= string.format(L["Works the same as [%s], but always shows mana and is only shown if mana is a secondary power."], "abscurpp"),
	["sec:curmaxpp"]			= string.format(L["Works the same as [%s], but always shows mana and is only shown if mana is a secondary power."], "curmaxpp"),
	["sec:absolutepp"]			= string.format(L["Works the same as [%s], but always shows mana and is only shown if mana is a secondary power."], "absolutepp"),
	["situation"]				= L["Returns text based on your threat situation with your target: Aggro for Aggro, High for being close to taking aggro, and Medium as a general warning to be wary."],
	["color:sit"]				= L["Returns a color code of the threat situation with your target: Red for Aggro, Orange for High threat and Yellow to be careful."],
	["scaled:threat"]			= L["Returns a scaled threat percent of your aggro on your current target, always 0 - 100%."],
	["general:sit"]				= L["Returns text based on your general threat situation on all units: Aggro for Aggro, High for being near to pulling aggro and Medium as a general warning."],
	["color:gensit"]			= L["Returns a color code of your general threat situation on all units: Red for Aggro, Orange for High threat and Yellow to watch out."],
	["unit:scaled:threat"]		= L["Returns the scaled threat percentage for the unit, if you put this on a party member you would see the percentage of how close they are to getting any from any hostile mobs. Always 0 - 100%.|nThis cannot be used on target of target or focus target types of units."],
	["unit:color:sit"]			= L["Returns the color code for the units threat situation in general: Red for Aggro, Orange for High threat and Yellow to watch out.|nThis cannot be used on target of target or focus target types of units."],
	["unit:situation"]			= L["Returns text based on the units general threat situation: Aggro for Aggro, High for being close to taking aggro, and Medium as a warning to be wary.|nThis cannot be used on target of target or focus target types of units."],
	["unit:color:aggro"]		= L["Same as [unit:color:sit] except it only returns red if the unit has aggro, rather than transiting from yellow -> orange -> red."],
	["color:aggro"]				= L["Same as [color:sit] except it only returns red if you have aggro, rather than transiting from yellow -> orange -> red."],
	["unit:raid:targeting"]		= L["How many people in your raid are targeting the unit, for example if you put this on yourself it will show how many people are targeting you. This includes you in the count!"],
	["unit:raid:assist"]		= L["How many people are assisting the unit, for example if you put this on yourself it will show how many people are targeting your target. This includes you in the count!"],
	["monk:chipoints"]			= L["How many Chi points you currently have."],
	["monk:stagger"]			= L["Shows the current staggered damage, if 12,000 damage is staggered, shows 12k."],
	["monk:abs:stagger"]		= L["Shows the absolute staggered damage, if 16,000 damage is staggered, shows 16,000."]
}

Tags.defaultNames = {
	["totem:timer"]				= L["Totem Timer"],
	["rune:timer"]				= L["Rune Timer"],
	["abs:incabsorb"]			= L["Damage absorption (Absolute)"],
	["incabsorb"]				= L["Damage absorption (Short)"],
	["incabsorb:name"]			= L["Damage absorption/Name"],
	["per:incheal"]				= L["Incoming heal (Percent)"],
	["incheal:name"]			= L["Incoming heal/Name"],
	["abs:healabsorb"]			= L["Heal Absorb (Absolute)"],
	["healabsorb"]				= L["Heal Absorb (Short)"],
	["unit:scaled:threat"]		= L["Unit scaled threat"],
	["unit:color:sit"]			= L["Unit colored situation"],
	["unit:situation"]			= L["Unit situation name"],
	["hp:color"]				= L["Health color"],
	["guild"]					= L["Guild name"],
	["druidform"]				= L["Druid form"],
	["short:druidform"]			= L["Druid form (Short)"],
	["abs:incheal"]				= L["Incoming heal (Absolute)"],
	["incheal"]					= L["Incoming heal (Short)"],
	["abbrev:name"]				= L["Name (Abbreviated)"],
	["smart:curmaxhp"]			= L["Cur/Max HP (Smart)"],
	["smart:curmaxpp"]			= L["Cur/Max PP (Smart)"],
	["pvp:time"]				= L["PVP timer"],
	["afk:time"]				= L["AFK timer"],
	["status:time"]				= L["Offline timer"],
	["afk"]						= L["AFK status"],
	["cpoints"]					= L["Combo points"],
	["hpower"]					= L["Holy power"],
	["sshards"]					= L["Soul shards"],
	["smartlevel"]				= L["Smart level"],
	["classification"]			= L["Classification"],
	["shortclassification"]		= L["Short classification"],
	["rare"]					= L["Rare indicator"],
	["plus"]					= L["Short elite indicator"],
	["sex"]						= L["Sex"],
	["smartclass"]				= L["Class (Smart)"],
	["smartrace"]				= L["Race (Smart)"],
	["status"]					= L["Status"],
	["race"]					= L["Race"],
	["level"]					= L["Level"],
	["maxhp"]					= L["Max HP (Short)"],
	["maxpp"]					= L["Max power (Short)"],
	["missinghp"]				= L["Missing HP (Short)"],
	["missingpp"]				= L["Missing power (Short)"],
	["name"]					= L["Unit name"],
	["server"]					= L["Unit server"],
	["perhp"]					= L["Percent HP"],
	["perpp"]					= L["Percent power"],
	["class"]					= L["Class"],
	["classcolor"]				= L["Class color tag"],
	["creature"]				= L["Creature type"],
	["curhp"]					= L["Current HP (Short)"],
	["curpp"]					= L["Current Power (Short)"],
	["curmaxhp"]				= L["Cur/Max HP (Short)"],
	["curmaxpp"]				= L["Cur/Max Power (Short)"],
	["levelcolor"]				= L["Level (Colored)"],
	["def:name"]				= L["Deficit/Unit Name"],
	["faction"]					= L["Unit faction"],
	["colorname"]				= L["Unit name (Class colored)"],
	["absolutepp"]				= L["Cur/Max power (Absolute)"],
	["absolutehp"]				= L["Cur/Max HP (Absolute)"],
	["absmaxhp"]				= L["Max HP (Absolute)"],
	["abscurhp"]				= L["Current HP (Absolute)"],
	["absmaxpp"]				= L["Max power (Absolute)"],
	["abscurpp"]				= L["Current power (Absolute)"],
	["reactcolor"]				= L["Reaction color tag"],
	["dechp"]					= L["Decimal percent HP"],
	["group"]					= L["Group number"],
	["close"]					= L["Close color"],
	["druid:curpp"]         	= L["Current power (Druid)"],
	["druid:abscurpp"]      	= L["Current power (Druid/Absolute)"],
	["druid:curmaxpp"]			= L["Cur/Max power (Druid)"],
	["druid:absolutepp"]		= L["Cur/Max power (Druid/Absolute)"],
	["sec:curpp"]         		= L["Current power (Secondary)"],
	["sec:abscurpp"]      		= L["Current power (Secondary/Absolute)"],
	["sec:curmaxpp"]			= L["Cur/Max power (Secondary)"],
	["sec:absolutepp"]			= L["Cur/Max power (Secondary/Absolute)"],
	["situation"]				= L["Threat situation"],
	["color:sit"]				= L["Color code for situation"],
	["scaled:threat"]			= L["Scaled threat percent"],
	["general:sit"]				= L["General threat situation"],
	["color:gensit"]			= L["Color code for general situation"],
	["color:aggro"]				= L["Color code on aggro"],
	["unit:color:aggro"]		= L["Unit color code on aggro"],
	["unit:raid:targeting"]		= L["Raid targeting unit"],
	["unit:raid:assist"]		= L["Raid assisting unit"],
	["monk:chipoints"]			= L["Chi Points"],
	["monk:stagger"]			= L["Stagger (Monk)"],
	["monk:abs:stagger"]		= L["Stagger (Monk/Absolute)"]
}

-- List of event types
Tags.eventType = {
	["UNIT_POWER_FREQUENT"] = "power",
	["UNIT_MAXPOWER"] = "power",
	["UNIT_ABSORB_AMOUNT_CHANGED"] = "health",
	["UNIT_HEALTH_FREQUENT"] = "health",
	["UNIT_HEALTH"] = "health",
	["UNIT_MAXHEALTH"] = "health",
	["GROUP_ROSTER_UPDATE"] = "unitless",
	["RAID_TARGET_UPDATE"] = "unitless",
	["PLAYER_TARGET_CHANGED"] = "unitless",
	["PARTY_LEADER_CHANGED"] = "unitless",
	["PLAYER_ENTERING_WORLD"] = "unitless",
	["PLAYER_REGEN_DISABLED"] = "unitless",
	["PLAYER_REGEN_ENABLED"] = "unitless",
	["PLAYER_XP_UPDATE"] = "unitless",
	["PLAYER_TOTEM_UPDATE"] = "unitless",
	["PLAYER_LEVEL_UP"] = "unitless",
	["UPDATE_EXHAUSTION"] = "unitless",
	["PLAYER_UPDATE_RESTING"] = "unitless",
	["UNIT_COMBO_POINTS"] = "unitless",
	["PARTY_LOOT_METHOD_CHANGED"] = "unitless",
	["READY_CHECK"] = "unitless",
	["READY_CHECK_FINISHED"] = "unitless",
	["RUNE_POWER_UPDATE"] = "unitless",
	["RUNE_TYPE_UPDATE"] = "unitless",
	["UPDATE_FACTION"] = "unitless",
}

-- Tag groups that have a special filter that can't be used on certain units, like the threat API's
Tags.unitBlacklist = {
	["threat"]	= "%w+target",
}

-- Single tags that can only be used on a single unit
Tags.unitRestrictions = {
	["pvp:time"] = "player",
	["totem:timer"] = "player",
	["rune:timer"] = "player"
}

Tags.anchorRestriction = {
	["totem:timer"] = "$totemBar",
	["rune:timer"] = "$runeBar"
}

-- Event scanner to automatically figure out what events a tag will need
local function loadAPIEvents()
	if( Tags.APIEvents ) then return end
	Tags.APIEvents = {
		["InCombatLockdown"]		= "PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED",
		["UnitLevel"]				= "UNIT_LEVEL UNIT_FACTION",
		["UnitBattlePetLevel"]		= "UNIT_LEVEL UNIT_FACTION",
		["UnitName"]				= "UNIT_NAME_UPDATE",
		["UnitClassification"]		= "UNIT_CLASSIFICATION_CHANGED",
		["UnitFactionGroup"]		= "UNIT_FACTION PLAYER_FLAGS_CHANGED",
		["UnitHealth%("]			= "UNIT_HEALTH UNIT_HEALTH_FREQUENT",
		["UnitHealthMax"]			= "UNIT_MAXHEALTH",
		["UnitPower%("]				= "UNIT_POWER_FREQUENT",
		["UnitPowerMax"]			= "UNIT_MAXPOWER",
		["UnitPowerType"]			= "UNIT_DISPLAYPOWER",
		["UnitIsDead"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT",
		["UnitIsGhost"]				= "UNIT_HEALTH UNIT_HEALTH_FREQUENT",
		["UnitIsConnected"]			= "UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION",
		["UnitIsAFK"]				= "PLAYER_FLAGS_CHANGED",
		["UnitIsDND"]				= "PLAYER_FLAGS_CHANGED",
		["UnitIsPVP"]				= "PLAYER_FLAGS_CHANGED UNIT_FACTION",
		["UnitIsGroupLeader"]		= "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE",
		["UnitIsPVPFreeForAll"]		= "PLAYER_FLAGS_CHANGED UNIT_FACTION",
		["UnitCastingInfo"]			= "UNIT_SPELLCAST_START UNIT_SPELLCAST_STOP UNIT_SPELLCAST_FAILED UNIT_SPELLCAST_INTERRUPTED UNIT_SPELLCAST_DELAYED",
		["UnitChannelInfo"]			= "UNIT_SPELLCAST_CHANNEL_START UNIT_SPELLCAST_CHANNEL_STOP UNIT_SPELLCAST_CHANNEL_INTERRUPTED UNIT_SPELLCAST_CHANNEL_UPDATE",
		["UnitAura"]				= "UNIT_AURA",
		["UnitBuff"]				= "UNIT_AURA",
		["UnitDebuff"]				= "UNIT_AURA",
		["UnitXPMax"]				= "UNIT_PET_EXPERIENCE PLAYER_XP_UPDATE PLAYER_LEVEL_UP",
		["UnitGetTotalAbsorbs"]		= "UNIT_ABSORB_AMOUNT_CHANGED",
		["UnitXP%("]				= "UNIT_PET_EXPERIENCE PLAYER_XP_UPDATE PLAYER_LEVEL_UP",
		["GetTotemInfo"]			= "PLAYER_TOTEM_UPDATE",
		["GetXPExhaustion"]			= "UPDATE_EXHAUSTION",
		["GetWatchedFactionInfo"]	= "UPDATE_FACTION",
		["GetRuneCooldown"]			= "RUNE_POWER_UPDATE",
		["GetRuneType"]				= "RUNE_TYPE_UPDATE",
		["GetRaidTargetIndex"]		= "RAID_TARGET_UPDATE",
		["GetComboPoints"]			= "UNIT_POWER_FREQUENT",
		["GetNumSubgroupMembers"]	= "GROUP_ROSTER_UPDATE",
		["GetNumGroupMembers"]		= "GROUP_ROSTER_UPDATE",
		["GetRaidRosterInfo"]		= "GROUP_ROSTER_UPDATE",
		["GetReadyCheckStatus"]		= "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED",
		["GetLootMethod"]			= "PARTY_LOOT_METHOD_CHANGED",
		["GetThreatStatusColor"]	= "UNIT_THREAT_SITUATION_UPDATE",
		["UnitThreatSituation"]		= "UNIT_THREAT_SITUATION_UPDATE",
		["UnitDetailedThreatSituation"] = "UNIT_THREAT_SITUATION_UPDATE",
	}
end

-- Scan the actual tag code to find the events it uses
local alreadyScanned = {}
function Tags:IdentifyEvents(code, parentTag)
	-- Already scanned this tag, prevents infinite recursion
	if( parentTag and alreadyScanned[parentTag] ) then
		return ""
	-- Flagged that we already took care of this
	elseif( parentTag ) then
		alreadyScanned[parentTag] = true
	else
		for k in pairs(alreadyScanned) do alreadyScanned[k] = nil end
		loadAPIEvents()
	end

	-- Scan our function list to see what APIs are used
	local eventList = ""
	for func, events in pairs(self.APIEvents) do
		if( string.match(code, func) ) then
			eventList = eventList .. events .. " "
		end
	end

	-- Scan if they use any tags, if so we need to check them as well to see what content is used
	for tag in string.gmatch(code, "tagFunc%.(%w+)%(") do
		local c = ShadowUF.Tags.defaultTags[tag] or ShadowUF.db.profile.tags[tag] and ShadowUF.db.profile.tags[tag].func
		eventList = eventList .. " " .. self:IdentifyEvents(c, tag)
	end

	-- Remove any duplicate events
	if( not parentTag ) then
		local tagEvents = {}
		for event in string.gmatch(string.trim(eventList), "%S+") do
			tagEvents[event] = true
		end

		eventList = ""
		for event in pairs(tagEvents) do
			eventList = eventList .. event .. " "
		end
	end

	-- And give them our nicely outputted data
	return string.trim(eventList or "")
end


-- Checker function, makes sure tags are all happy
--[===[@debug@
function Tags:Verify()
	local fine = true
	for tag, events in pairs(self.defaultEvents) do
		if( not self.defaultTags[tag] ) then
			print(string.format("Found event for %s, but no tag associated with it.", tag))
			fine = nil
		end
	end

	for tag, data in pairs(self.defaultTags) do
		if( not self.defaultTags[tag] ) then
			print(string.format("Found tag for %s, but no event associated with it.", tag))
			fine = nil
		end

		if( not self.defaultHelp[tag] ) then
			print(string.format("Found tag for %s, but no help text associated with it.", tag))
			fine = nil
		end

		if( not self.defaultNames[tag] ) then
			print(string.format("Found tag for %s, but no name associated with it.", tag))
			fine = nil
		end

		if( not self.defaultCategories[tag] ) then
			print(string.format("Found tag for %s, but no category associated with it.", tag))
			fine = nil
		end

		local funct, msg = loadstring("return " .. data)
		if( not funct and msg ) then
			print(string.format("Failed to load tag %s.", tag))
			print(msg)
			fine = nil
		else
			funct("player")
		end
	end

	if( fine ) then
		print("Verified tags, everything is fine.")
	end
end
--@end-debug@]===]
