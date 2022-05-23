
local LS = LibStub:NewLibrary("LibSpecialization", 2)
if not LS then return end -- No upgrade needed

-- Throttle times for separate channels
LS.throttleTable = LS.throttleTable or {
	["RAID"] = 0,
	["PARTY"] = 0,
	["INSTANCE_CHAT"] = 0,
}
LS.throttleSendTable = LS.throttleSendTable or {
	["RAID"] = 0,
	["PARTY"] = 0,
	["INSTANCE_CHAT"] = 0,
}
-- Positions of roles
LS.positionTable = LS.positionTable or {
	-- Death Knight
	[250] = "MELEE", -- Blood (Tank)
	[251] = "MELEE", -- Frost (DPS)
	[252] = "MELEE", -- Unholy (DPS)
	-- Demon Hunter
	[577] = "MELEE", -- Havoc (DPS)
	[581] = "MELEE", -- Vengeance (Tank)
	-- Druid
	[102] = "RANGED", -- Balance (DPS Owl)
	[103] = "MELEE", -- Feral (DPS Cat)
	[104] = "MELEE", -- Guardian (Tank Bear)
	[105] = "RANGED", -- Restoration (Heal)
	-- Hunter
	[253] = "RANGED", -- Beast Mastery
	[254] = "RANGED", -- Marksmanship
	[255] = "MELEE", -- Survival
	-- Mage
	[62] = "RANGED", -- Arcane
	[63] = "RANGED", -- Fire
	[64] = "RANGED", -- Frost
	-- Monk
	[268] = "MELEE", -- Brewmaster (Tank)
	[269] = "MELEE", -- Windwalker (DPS)
	[270] = "MELEE", -- Mistweaver (Heal)
	-- Paladin
	[65] = "MELEE", -- Holy (Heal)
	[66] = "MELEE", -- Protection (Tank)
	[70] = "MELEE", -- Retribution (DPS)
	-- Priest
	[256] = "RANGED", -- Discipline (Heal)
	[257] = "RANGED", -- Holy (Heal)
	[258] = "RANGED", -- Shadow (DPS)
	-- Rogue
	[259] = "MELEE", -- Assassination
	[260] = "MELEE", -- Outlaw
	[261] = "MELEE", -- Subtlety
	-- Shaman
	[262] = "RANGED", -- Elemental (DPS)
	[263] = "MELEE", -- Enhancement (DPS)
	[264] = "RANGED", -- Restoration (Heal)
	-- Warlock
	[265] = "RANGED", -- Affliction
	[266] = "RANGED", -- Demonology
	[267] = "RANGED", -- Destruction
	-- Warrior
	[71] = "MELEE", -- Arms (DPS)
	[72] = "MELEE", -- Fury (DPS)
	[73] = "MELEE", -- Protection (Tank)
}
-- Player roles
LS.roleTable = LS.roleTable or {
	-- Death Knight
	[250] = "TANK", -- Blood (Tank)
	[251] = "DAMAGER", -- Frost (DPS)
	[252] = "DAMAGER", -- Unholy (DPS)
	-- Demon Hunter
	[577] = "DAMAGER", -- Havoc (DPS)
	[581] = "TANK", -- Vengeance (Tank)
	-- Druid
	[102] = "DAMAGER", -- Balance (DPS Owl)
	[103] = "DAMAGER", -- Feral (DPS Cat)
	[104] = "TANK", -- Guardian (Tank Bear)
	[105] = "HEALER", -- Restoration (Heal)
	-- Hunter
	[253] = "DAMAGER", -- Beast Mastery
	[254] = "DAMAGER", -- Marksmanship
	[255] = "DAMAGER", -- Survival
	-- Mage
	[62] = "DAMAGER", -- Arcane
	[63] = "DAMAGER", -- Fire
	[64] = "DAMAGER", -- Frost
	-- Monk
	[268] = "TANK", -- Brewmaster (Tank)
	[269] = "DAMAGER", -- Windwalker (DPS)
	[270] = "HEALER", -- Mistweaver (Heal)
	-- Paladin
	[65] = "HEALER", -- Holy (Heal)
	[66] = "TANK", -- Protection (Tank)
	[70] = "DAMAGER", -- Retribution (DPS)
	-- Priest
	[256] = "HEALER", -- Discipline (Heal)
	[257] = "HEALER", -- Holy (Heal)
	[258] = "DAMAGER", -- Shadow (DPS)
	-- Rogue
	[259] = "DAMAGER", -- Assassination
	[260] = "DAMAGER", -- Outlaw
	[261] = "DAMAGER", -- Subtlety
	-- Shaman
	[262] = "DAMAGER", -- Elemental (DPS)
	[263] = "DAMAGER", -- Enhancement (DPS)
	[264] = "HEALER", -- Restoration (Heal)
	-- Warlock
	[265] = "DAMAGER", -- Affliction
	[266] = "DAMAGER", -- Demonology
	[267] = "DAMAGER", -- Destruction
	-- Warrior
	[71] = "DAMAGER", -- Arms (DPS)
	[72] = "DAMAGER", -- Fury (DPS)
	[73] = "TANK", -- Protection (Tank)
}
LS.callbackMap = LS.callbackMap or {}
LS.frame = LS.frame or CreateFrame("Frame")

local throttleTable = LS.throttleTable
local throttleSendTable = LS.throttleSendTable
local callbackMap = LS.callbackMap
local positionTable = LS.positionTable
local roleTable = LS.roleTable
local frame = LS.frame

local next, type, error, tonumber, format = next, type, error, tonumber, string.format
local Ambiguate, GetTime, IsInGroup, IsInRaid = Ambiguate, GetTime, IsInGroup, IsInRaid
local GetSpecialization, GetSpecializationInfo = GetSpecialization, GetSpecializationInfo
local SendAddonMessage = C_ChatInfo.SendAddonMessage
local pName = UnitName("player")

if not C_ChatInfo.RegisterAddonMessagePrefix("LibSpec") then
	error("LibSpecialization: Failed to register the addon prefix.")
end
frame:SetScript("OnEvent", function(_, _, prefix, msg, channel, sender)
	if prefix == "LibSpec" and throttleTable[channel] then
		if msg == "R" then
			local t = GetTime()
			if t - throttleTable[channel] > 4 then
				throttleTable[channel] = t
				local spec = GetSpecialization()
				if type(spec) == "number" and spec > 0 then
					local id = GetSpecializationInfo(spec)

					if id then
						if positionTable[id] then
							SendAddonMessage("LibSpec", format("%d", id), channel)
						else
							error(format("LibSpecialization: Unknown ID %q", id))
						end
					end
				end
			end
			return
		end

		local specId = tonumber(msg)
		local role, position = roleTable[specId], positionTable[specId]
		if role and position then
			for _,func in next, callbackMap do
				func(specId, role, position, Ambiguate(sender, "none"), channel)
			end
		end
	end
end)
frame:RegisterEvent("CHAT_MSG_ADDON")

-- Allow requesting only your specialization
function LS:MySpecialization()
	local spec = GetSpecialization()
	if type(spec) == "number" and spec > 0 then
		local specId, _, _, _, role = GetSpecializationInfo(spec)

		if specId and role then
			local position = positionTable[specId]
			if position then
				return specId, role, position
			else
				error(format("LibSpecialization: Unknown specId %q", specId))
			end
		end
	end
end

-- For automatic group handling, don't pass a channel. The order is INSTANCE_CHAT > RAID > GROUP.
function LS:RequestSpecialization(channel)
	if channel and not throttleSendTable[channel] then
		error("LibSpecialization: Incorrect channel type for :RequestSpecialization.")
	else
		if not channel and IsInGroup() then
			channel = IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY"
		end

		local specId, role, position = LS:MySpecialization()
		for _,func in next, callbackMap do
			func(specId, role, position, pName, channel) -- This allows us to show our own spec info when not grouped
		end

		if channel then
			local t = GetTime()
			if t - throttleSendTable[channel] > 4 then
				throttleSendTable[channel] = t
				SendAddonMessage("LibSpec", "R", channel)
			end
		end
	end
end

function LS:Register(addon, func)
	if not addon or addon == LS then
		error("LibSpecialization: You must pass your own addon name or object to :Register.")
	end

	local t = type(func)
	if t == "string" then
		callbackMap[addon] = function(...) addon[func](addon, ...) end
	elseif t == "function" then
		callbackMap[addon] = func
	else
		error("LibSpecialization: Incorrect function type for :Register.")
	end
end

function LS:Unregister(addon)
	if not addon or addon == LS then
		error("LibSpecialization: You must pass your own addon name or object to :Unregister.")
	end
	callbackMap[addon] = nil
end

