

--[[
	The Tidy Plates Healer Tracking system uses two concurrent methods:
		1. Direct query of the Battleground Scoreboard for Talent Specialization
		2. Active monitoring of the combat log for Healer-Only spells

		Q: Why do I use TWO methods?
			A: Querying the Battleground Scoreboard is the most accurate method,
		but it doesn't always work.  In addition, there are PvP encounters where
		you're not in a battleground.

--]]
local RoleList = {}

local function IsHealer(name)

	if name then
		local Role = RoleList[name]
		if Role == nil then
			RequestBattlefieldScoreData()
		else
			--if Role == "Healer" then print(name, "Marked as Healer") end
			return Role == "Healer"
		end
	end
end

---------------------------------------------------------------------------------------------------------
-- Widget
---------------------------------------------------------------------------------------------------------
local widgetPath = "Interface\\Addons\\TidyPlatesWidgets\\HealerWidget"
local friendlyHealerIcon = widgetPath.."\\Friendly"
local hostileHealerIcon = widgetPath.."\\Hostile"
local WidgetList = {}

-- Update Graphics
local function UpdateWidgetFrame(self, unit)
	-- Custom Code I
	--------------------------------------
	if unit.type == "PLAYER" and IsHealer(unit.name) then
		if unit.reaction == "HOSTILE" then
			self:Show()
			self.Icon:SetTexture(hostileHealerIcon)
		else self:Show();self.Icon:SetTexture(friendlyHealerIcon) end
	else self:_Hide() end
	--------------------------------------
	-- End Custom Code
end

-- Context
local function UpdateWidgetContext(self, unit)
	local guid = unit.guid
	self.guid = guid

	-- Add to Widget List
	if guid then
		WidgetList[guid] = self
	end

	-- Custom Code II
	--------------------------------------
	UpdateWidgetFrame(self, unit)
	--------------------------------------
	-- End Custom Code
end

local function ClearWidgetContext(self)
	local guid = self.guid
	if guid then
		WidgetList[guid] = nil
		self.guid = nil
	end
end

-- Widget Creation
local function CreateWidgetFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:Hide()

	-- Custom Code III
	--------------------------------------
	frame:SetHeight(32)
	frame:SetWidth(64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetAllPoints(frame)
	frame.Icon:SetTexture(defaultTexture)
	frame:SetAlpha(.7)
	--if not isEnabled then EnableWatcherFrame(true) end
	--------------------------------------
	-- End Custom Code

	-- Required Widget Code
	frame.UpdateContext = UpdateWidgetContext
	frame.Update = UpdateWidgetFrame
	frame._Hide = frame.Hide
	frame.Hide = function() ClearWidgetContext(frame); frame:_Hide() end

	return frame
end

TidyPlatesWidgets.CreateHealerWidget = CreateWidgetFrame



---------------------------------------------------------------------------------------------------------
-- Healer Tracking System
---------------------------------------------------------------------------------------------------------
local HealerListByGUID = {}
local HealerListByName = {}

local function ParseName(identifier)
	local name, server = select( 3, strfind(identifier, "([^-]+)-?(.*)"))
	return name, server
end

--[[
Detection Method 1:
Direct query of the Battleground Scoreboard for Talent Specialization
--]]

-- Class talent specs
local ClassRoles = {
	["Death Knight"] = {
		["Blood"]         = "Tank",
		["Frost"]         = "Melee",
		["Unholy"]        = "Melee",
	},
	["Druid"] = {
		["Balance"]       = "Ranged",
		["Guardian"]  = "Tank",
		["Feral Combat"]  = "Melee",
		["Feral"]  = "Melee",
		["Restoration"]   = "Healer",
	},
	["Hunter"] = {
		["Beast Mastery"] = "Ranged",
		["Marksmanship"]  = "Ranged",
		["Survival"]      = "Ranged",
	},
	["Mage"] = {
		["Arcane"]        = "Ranged",
		["Fire"]          = "Ranged",
		["Frost"]         = "Ranged",
	},
	["Paladin"] = {
		["Holy"]          = "Healer",
		["Protection"]    = "Tank",
		["Retribution"]   = "Melee",
	},
	["Priest"] = {
		["Discipline"]    = "Healer",
		["Holy"]          = "Healer",
		["Shadow"]        = "Ranged",
	},
	["Rogue"] = {
		["Assassination"] = "Melee",
		["Combat"]        = "Melee",
		["Subtlety"]      = "Melee",
	},
	["Shaman"] = {
		["Elemental"]     = "Ranged",
		["Enhancement"]   = "Melee",
		["Restoration"]   = "Healer",
	},
	["Warlock"] = {
		["Affliction"]    = "Ranged",
		["Demonology"]    = "Ranged",
		["Destruction"]   = "Ranged",
	},
	["Warrior"] = {
		["Arms"]          = "Melee",
		["Fury"]          = "Melee",
		["Protection"]    = "Tank",
	},
	["Monk"] = {
		["Windwalker"]          = "Melee",
		["Mistweaver"]          = "Healer",
		["Brewmaster"]    		= "Tank",
	},
}



-- local DisplayFaction = 0; if UnitFactionGroup("player") == "Horde" then DisplayFaction = 1 end
local NextUpdate = 0
local function UpdateRolesViaScoreboard()
	local now = GetTime()

	if now > NextUpdate then
		NextUpdate = now + 3		-- Throttles update frequency to every 3 seconds.
	else return end

	--print("Scoreboard Update", now)

	local UpdateIsNeeded = false
	local NumScores = GetNumBattlefieldScores()

	-- SetBattlefieldScoreFaction(DisplayFaction) -- faction 0=Horde, 1=Alliance

	if NumScores > 0 then
		for i = 1, NumScores do
			local name, _, _, _, _, faction, _, class, _, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i)
			--print(name, class, talentSpec)
			if name and class and ClassRoles[class] and talentSpec then
				local Role = ClassRoles[class][talentSpec]

				if RoleList[name] ~= Role then
					RoleList[name] = Role
					--if Role == "Healer" then print(name, Role, faction) end
					UpdateIsNeeded = true
				end
			end
		end
		if UpdateIsNeeded then TidyPlates:RequestDelegateUpdate() end
	end

end

local HealerSpells = {
        -- Priest
		----------
        [47540] = "PRIEST", -- Penance
        [88625] = "PRIEST", -- Holy Word: Chastise
        [88684] = "PRIEST", -- Holy Word: Serenity
        [88685] = "PRIEST", -- Holy Word: Sanctuary
        [89485] = "PRIEST", -- Inner Focus
        [10060] = "PRIEST", -- Power Infusion
        [33206] = "PRIEST", -- Pain Suppression
        [62618] = "PRIEST", -- Power Word: Barrier
        [724]   = "PRIEST",   -- Lightwell
        [14751] = "PRIEST", -- Chakra
        [34861] = "PRIEST", -- Circle of Healing
        [47788] = "PRIEST", -- Guardian Spirit

        -- Druid
        ---------
		[18562] = "DRUID", -- Swiftmend
        [17116] = "DRUID", -- Nature's Swiftness
        [48438] = "DRUID", -- Wild Growth
        [33891] = "DRUID", -- Tree of Life

        -- Shaman
		---------
        [974]   = "SHAMAN", -- Earth Shield
        [17116] = "SHAMAN", -- Nature's Swiftness
        [16190] = "SHAMAN", -- Mana Tide Totem
        [61295] = "SHAMAN", -- Riptide


        -- Paladin
		----------
        [20473] = "PALADIN", -- Holy Shock
        [31842] = "PALADIN", -- Divine Favor
        [53563] = "PALADIN", -- Beacon of Light
        [31821] = "PALADIN", -- Aura Mastery
        [85222] = "PALADIN", -- Light of Dawn

        -- Monk
		---------
        [115175] = "MONK", -- Soothing Mist
        [115294] = "MONK", -- Mana Tea
        [115310] = "MONK", -- Revival
        [116670] = "MONK", -- Uplift
        [116680] = "MONK", -- Thunder Focus Tea
        [116849] = "MONK", -- Life Cocoon
        [116995] = "MONK", -- Surging mist
        [119611] = "MONK", -- Renewing mist
        [132120] = "MONK", -- Envelopping Mist

		-- http://www.icy-veins.com/mistweaver-monk-wow-pve-healing-rotation-cooldowns-abilities
		-- http://www.wowhead.com/spells=-12.10.270
}

local SpellEvents = {
	["SPELL_HEAL"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_CAST_START"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
}

local function IsEnemyPlayer(flags)
	if (bit.band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0) and (bit.band(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0) then
		return true
	end
end

local function WipeLists()
		RoleList = wipe(RoleList)
		HealerListByGUID = wipe(HealerListByGUID)
		HealerListByName = wipe(HealerListByName)
end

local Events = {}

function Events.PLAYER_ENTERING_WORLD()
	WipeLists()
	return
end

function Events.UPDATE_BATTLEFIELD_SCORE()
	--print("UPDATE_BATTLEFIELD_SCORE")
	UpdateRolesViaScoreboard()
	return
end

function Events.COMBAT_LOG_EVENT_UNFILTERED()
	-- Combat Log Unfiltered
	--local timestamp, combatevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlag, spellid  = ...		-- WoW 4.2
	local timestamp, combatevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlag, spellid = CombatLogGetCurrentEventInfo()	-- wow 8.0		-- WoW 8.0

	if IsEnemyPlayer(sourceFlags) and sourceGUID and sourceName then					-- Filter: Only Enemy Players
		if SpellEvents[combatevent] then								-- Filter: Specific spell events
			if HealerSpells[spellid] then								-- Filter: Known Healing Spells
				local rawName = strsplit("-", sourceName)				-- Strip server name
				if RoleList[rawName] ~= "Healer" then
					RoleList[rawName] = "Healer"
					TidyPlates:RequestDelegateUpdate()
				end
			end
		end
	end
end

local function CombatEventHandler(frame, event, ...)
	local handler = Events[event]
	if handler then handler(...) end
end

local HealerTrackWatcher = CreateFrame("Frame")

local function Enable()
	--print("TidyPlatesWidgets.HealerTrack:Enable")
	HealerTrackWatcher:SetScript("OnEvent", CombatEventHandler)
	HealerTrackWatcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	HealerTrackWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
	HealerTrackWatcher:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	WipeLists()
end

local function Disable()
	HealerTrackWatcher:SetScript("OnEvent", nil)
	HealerTrackWatcher:UnregisterAllEvents()
	WipeLists()
end

TidyPlatesUtility.EnableHealerTrack = Enable
TidyPlatesUtility.DisableHealerTrack = Disable
TidyPlatesUtility.IsHealer = IsHealer



