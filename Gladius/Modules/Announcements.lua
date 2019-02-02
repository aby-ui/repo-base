local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Announcements"))
end
local L = Gladius.L

-- global functions
local mathfloor = math.floor
local strfind = string.find
local string = string

local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local IsAddOnLoaded = IsAddOnLoaded
local IsArenaSkirmish = IsArenaSkirmish
local IsInInstance = IsInInstance
local SendChatMessage = SendChatMessage
local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitName = UnitName

local UNKNOWN = UNKNOWN
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local Announcements = Gladius:NewModule("Announcements", false, false, {
	announcements = {
		drinks = true,
		enemies = true,
		health = true,
		resurrect = true,
		spec = true,
		healthThreshold = 25,
		dest = "party"
	}
})

function Announcements:OnEnable()
	-- Register events
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	-- register custom events
	--self:RegisterMessage("GLADIUS_SPEC_UPDATE")
	-- Table holding messages to throttle
	self.throttled = { }
	-- enemy detected
	self.enemy = { }
end

function Announcements:OnDisable()
	self:UnregisterAllEvents()
end

-- Needed to not throw Lua errors
function Announcements:GetAttachTo()
	return ""
end

-- Reset throttled messages
function Announcements:Reset(unit)
	self.throttled = { }
	self.enemy = { }
end

-- New enemy announcement
function Announcements:Show(unit)
	self:UNIT_NAME_UPDATE(nil, unit)
end

function Announcements:UNIT_NAME_UPDATE(event, unit)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" or not strfind(unit, "arena") or strfind(unit, "pet") then
		return
	end
	if not Gladius.db.announcements.enemies or not UnitName(unit) then
		return
	end
	local name = UnitName(unit)
	if name == UNKNOWN or not name then
		return
	end
	if not self.enemy[unit] then
		self:Send(string.format("%s - %s", name, UnitClass(unit) or ""), 2, unit)
		self.enemy[unit] = true
	end
end

--[[function Announcements:GLADIUS_SPEC_UPDATE(event, unit)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" or not strfind(unit, "arena") or strfind(unit, "pet") or not Gladius.db.announcements.spec then
		return
	end
	self:Send(string.format(L["SPEC DETECTED: %s (%s)"], UnitName(unit), Gladius.buttons[unit].spec), 2, unit)
end]]

function Announcements:UNIT_HEALTH(event, unit)
	if not unit then
		return
	end
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" or not strfind(unit, "arena") or strfind(unit, "pet") or not Gladius.db.announcements.health then
		return
	end
	local healthPercent = mathfloor((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
	if healthPercent < Gladius.db.announcements.healthThreshold then
		self:Send(string.format(L["LOW HEALTH: %s (%s)"], UnitName(unit), UnitClass(unit)), 10, unit)
	end
end

function Announcements:UNIT_AURA(event, unit)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" or not strfind(unit, "arena") or strfind(unit, "pet") or not Gladius.db.announcements.drinks then
		return
	end
	local index
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, i, "HELPFUL")
		if spellID == 57073 then
			index = i
			break
		end
	end
	if index then
		self:Send(string.format(L["DRINKING: %s (%s)"], UnitName(unit), UnitClass(unit)), 2, unit)
	end
end

function Announcements:ARENA_PREP_OPPONENT_SPECIALIZATIONS(event, ...)
	if not Gladius.db.announcements.spec then
		return
	end
	for i = 1, GetNumArenaOpponentSpecs() do
		--local prepFrame = _G["ArenaPrepFrame"..i]
		--prepFrame.specPortrait = _G["ArenaPrepFrame"..i.."SpecPortrait"]
		local specID = GetArenaOpponentSpec(i)
		if specID > 0 then
			--local _, spec, _, specIcon, _, _, class = GetSpecializationInfoByID(specID)
			local id, name, description, icon, role, class = GetSpecializationInfoByID(specID)
			--[[if(class) then
				prepFrame.classPortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
				prepFrame.classPortrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS[strupper(class)]))
			end
				SetPortraitToTexture(prepFrame.specPortrait, specIcon)
				prepFrame:Show()
			else
				prepFrame:Hide()]]
			self:Send("Enemy Spec: "..name.." "..class)
		end
		--else
		--prepFrame:Hide()
	end
end

local RES_SPELLS = {
	[2008] = true, -- Ancestral Spirit
	[50769] = true, -- Revive
	[2006] = true, -- Resurrection
	[7328] = true, -- Redemption
	[50662] = true -- Resuscitate
}

function Announcements:UNIT_SPELLCAST_START(event, unit, lineGUID, spellID)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" or not strfind(unit, "arena") or strfind(unit, "pet") or not Gladius.db.announcements.resurrect then
		return
	end
	if RES_SPELLS[spellID] then
		self:Send(string.format(L["RESURRECTING: %s (%s)"], UnitName(unit), UnitClass(unit)), 2, unit)
	end
end

-- Sends an announcement
-- Param unit is only used for class coloring of messages
function Announcements:Send(msg, throttle, unit)
	local color = unit and RAID_CLASS_COLORS[UnitClass(unit)] or {r = 0, g = 1, b = 0}
	local dest = Gladius.db.announcements.dest
	local skirmish = IsArenaSkirmish()
	local isArena, isRegistered = IsActiveBattlefieldArena()
	if skirmish or not isRegistered then
		dest = "instance"
	end
	if not self.throttled then
		self.throttled = { }
	end
	-- Throttling of messages
	if throttle and throttle > 0 then
		if not self.throttled[msg] then
			self.throttled[msg] = GetTime() + throttle
		elseif self.throttled[msg] < GetTime() then
			self.throttled[msg] = nil
		else
			return
		end
	end
	if dest == "self" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Gladius|r: "..msg)
	end
	-- change destination to party if not raid leader/officer.
	if dest == "rw" and not UnitIsGroupLeader() and not UnitIsGroupAssistant() and GetNumGroupMembers() > 0 then
		dest = "party"
	end
	-- party chat
	if dest == "party" and (GetNumGroupMembers() > 0) then
		SendChatMessage(msg, "PARTY")
	-- instance chat
	elseif dest == "instance" and (GetNumGroupMembers() > 0) then
		SendChatMessage(msg, "INSTANCE_CHAT")
	-- raid chat
	elseif dest == "raid" and (GetNumGroupMembers() > 0) then
		SendChatMessage(msg, "RAID")
	-- say
	elseif dest == "say" then
		SendChatMessage(msg, "SAY")
	-- raid warning
	elseif dest == "rw" then
		SendChatMessage(msg, "RAID_WARNING")
	-- floating combat text
	elseif dest == "fct" and IsAddOnLoaded("Blizzard_CombatText") then
		CombatText_AddMessage(msg, COMBAT_TEXT_SCROLL_FUNCTION, color.r, color.g, color.b)
	-- MikScrollingBattleText
	elseif dest == "msbt" and IsAddOnLoaded("MikScrollingBattleText") then
		MikSBT.DisplayMessage(msg, MikSBT.DISPLAYTYPE_NOTIFICATION, false, color.r * 255, color.g * 255, color.b * 255)
	-- xCT
	elseif dest == "xct" and IsAddOnLoaded("xCT") then
		ct.frames[3]:AddMessage(msg, color.r * 255, color.g * 255, color.b * 255)
	-- xCT+
	elseif dest == "xctplus" and IsAddOnLoaded("xCT+") then
		xCT_Plus:AddMessage("general", msg, {color.r, color.g, color.b})
	-- Scrolling Combat Text
	elseif dest == "sct" and IsAddOnLoaded("sct") then
		SCT:DisplayText(msg, color, nil, "event", 1)
	-- Parrot
	elseif dest == "parrot" and IsAddOnLoaded("parrot") then
		Parrot:ShowMessage(msg, "Notification", false, color.r, color.g, color.b)
	end
end

local function getOption(info)
	return Gladius.dbi.profile.announcements[info[#info]]
end

local function setOption(info, value)
	Gladius.dbi.profile.announcements[info[#info]] = value
end

function Announcements:GetOptions()
	local destValues = {
		["self"] = L["Self"],
		["party"] = L["Party"],
		["instance"] = L["Instance Chat"],
		["raid"] = L["Raid"],
		["say"] = L["Say"],
		["rw"] = L["Raid Warning"],
		["sct"] = L["Scrolling Combat Text"],
		["msbt"] = L["MikScrollingBattleText"],
		["fct"] = L["Blizzard's Floating Combat Text"],
		["parrot"] = L["Parrot"],
		["xct"] = L["xCT"],
		["xctplus"] = L["xCT Plus"]
	}
	return {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			get = getOption,
			set = setOption,
			args = {
				options = {
					type = "group",
					name = L["Options"],
					inline = true,
					order = 1,
					disabled = function()
						return not Gladius.db.modules[self.name]
					end,
					args = {
						dest = {
							type = "select",
							name = L["Destination"],
							desc = L["Choose how your announcements are displayed."],
							values = destValues,
							order = 5,
						},
						healthThreshold = {
							type = "range",
							name = L["Low health threshold"],
							desc = L["Choose how low an enemy must be before low health is announced."],
							disabled = function()
								return not Gladius.db.announcements.health
							end,
							min = 1,
							max = 100,
							step = 1,
							order = 10,
						},
					},
				},
				announcements = {
					type = "group",
					name = L["Announcement toggles"],
					inline = true,
					order = 5,
					disabled = function()
						return not Gladius.db.modules[self.name]
					end,
					args = {
						enemies = {
							type = "toggle",
							name = L["New enemies"],
							desc = L["Announces when new enemies are discovered."],
							order = 10,
						},
						drinks = {
							type = "toggle",
							name = L["Drinking"],
							desc = L["Announces when enemies sit down to drink."],
							order = 20,
						},
						health = {
							type = "toggle",
							name = L["Low health"],
							desc = L["Announces when an enemy drops below a certain health threshold."],
							order = 30,
						},
						resurrect = {
							type = "toggle",
							name = L["Resurrection"],
							desc = L["Announces when an enemy tries to resurrect a teammate."],
							order = 40,
						},
						spec = {
							type = "toggle",
							name = L["Spec Detection"],
							desc = L["Announces when the spec of an enemy was detected."],
							order = 40,
						},
					},
				},
			},
		}
	}
end
