------------------------------------------------------------
-- API.lua
--
-- Abin
-- 2012/3/08
------------------------------------------------------------
-- API
--
-- module = CompactRaid:FindModule("RaidDebuff") -- Get the "RaidDebuff" module reference
-- valid = module:VerifyExpansion(id) -- Verify the expansion(Major version: 1-Classic, 2-TBC, 3-WotLK, 4-Cataclysm, 5-MoP, 6-WoD, 7-?, ...)
-- debuff = module:RegisterDebuff(tierId, instanceId, bossId, spellId, level) -- Register a debuff

------------------------------------------------------------

local type = type
local tinsert = tinsert
local pairs = pairs
local ipairs = ipairs
local wipe = wipe
local strlower = strlower
local GetSpellInfo = GetSpellInfo
local floor = floor
local format = format
local strmatch = strmatch
local tonumber = tonumber
local GetCurrentMapContinent = Pre80API.GetCurrentMapContinent
local tinsert = tinsert
local GetInstanceInfo = GetInstanceInfo
local GetRealZoneText = GetRealZoneText
local EJ_SelectInstance = EJ_SelectInstance
local EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
local EJ_GetInstanceByIndex = EJ_GetInstanceByIndex
local EJ_GetNumTiers = EJ_GetNumTiers
local EJ_GetTierInfo = EJ_GetTierInfo
local EJ_GetCurrentTier = EJ_GetCurrentTier

local L = CompactRaid:GetLocale("RaidDebuff")
local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local tierList = {}
local pendingList = {}
local initDone

local function GetInstance(tierId, instanceId)
	local tier = tierList[tierId]
	if tier then
		return tier.instances[instanceId]
	end
end

function module:GetNumTiers()
	return  #tierList
end

function module:GetTierName(tierId)
	local tier = tierList[tierId]
	if tier then
		return tier.name
	end
end

function module:GetCurrentTier()
	return EJ_GetCurrentTier()
end

function module:RegisterDebuff(tierId, instanceId, bossId, spellId, level, custom)
	if initDone then
		local instance = GetInstance(tierId, instanceId)
		if not instance then
			return
		end

		local debuff = instance:RegisterDebuff(bossId, spellId, level, custom)
		if not debuff then
			return
		end

		if custom and self.db then
			self.db.customDebuffs[format("%d,%d,%d", tierId, instanceId, spellId)] = format("%d,%d", debuff.bossId, debuff.level)
		end

		return debuff
	else
		tinsert(pendingList, { tierId = tierId, instanceId = instanceId, bossId = bossId, spellId = spellId, level = level, custom = custom })
	end
end

function module:EnumInstances(tierId, instanceType, func, arg1)
	if type(func) ~= "function" then
		return
	end

	local tier = tierList[tierId]
	if not tier then
		return
	end

	if type(instanceType) == "string" then
		instanceType = strlower(instanceType)
	end

	if instanceType ~= "raid" and instanceType ~= "party" then
		instanceType = nil
	end

	local id, data
	for id, data in pairs(tier.instances) do
		if not instanceType or instanceType == data.type then
			if arg1 then
				func(arg1, id, data.name, data.debuffCount)
			else
				func(id, data.name, data.debuffCount)
			end
		end
	end
end

function module:EnumBosses(tierId, instanceId, func, arg1)
	if type(func) ~= "function" then
		return
	end

	local instance = GetInstance(tierId, instanceId)
	if not instance then
		return
	end

	local i
	for i = 1, #instance.bosses do
		local data = instance.bosses[i]
		if arg1 then
			func(arg1, data.id, data.name, data.debuffCount)
		else
			func(data.id, data.name, data.debuffCount)
		end
	end
end

function module:EnumDebuffs(tierId, instanceId, bossId, func, arg1)
	if type(func) ~= "function" then
		return
	end

	local instance = GetInstance(tierId, instanceId)
	if not instance then
		return
	end

	if not bossId then
		bossId = 0
	end

	local name, data
	for name, data in pairs(instance.debuffs) do
		if data.bossId == bossId then
			if arg1 then
				func(arg1, name, data)
			else
				func(name, data)
			end
		end
	end
end

function module:IsDebuffRegistered(tierId, instanceId, debuffName)
	local instance = GetInstance(tierId, instanceId)
	if instance then
		return instance.debuffs[debuffName]
	end
end

function module:GetInstanceName(tierId, instanceId)
	local instance = GetInstance(tierId, instanceId)
	if instance then
		return instance.name
	end
end

local function NormalizeLevel(level, default)
	if type(level) == "number" then
		level = floor(level)
		if level < 0 then
			level = 0
		end

		if level > 5 then
			level = 5
		end
	else
		level = default
	end

	return level
end

function module:SetDebuffLevel(tierId, instanceId, spellId, level)
	if type(spellId) ~= "number" then
		return
	end

	local instance = GetInstance(tierId, instanceId)
	if not instance then
		return
	end

	local name = GetSpellInfo(spellId)
	if not name then
		return
	end

	local debuff = instance.debuffs[name]
	if not debuff then
		return
	end

	level = NormalizeLevel(level, debuff.defLevel)
	debuff.level = level

	local key = format("%d,%d,%d", tierId, instanceId, spellId)
	if debuff.custom then
		self.db.customDebuffs[key] = format("%d,%d", debuff.bossId, level)
	else
		if debuff.level == debuff.defLevel then
			self.db.userLevels[key] = nil
		else
			self.db.userLevels[key] = level
		end
	end

	return level
end

local function InitDebuffLevel(tierId, instanceId, spellId, level)
	local instance = GetInstance(tierId, instanceId)
	if not instance then
		return
	end

	level = NormalizeLevel(level)
	if not level then
		return
	end

	local debuff = instance.debuffs[GetSpellInfo(spellId)]
	if debuff then
		debuff.level = level
		return level
	end
end

local function ParseValues(value)
	if type(value) == "string" then
		local id1, id2, id3 = strmatch(value, "(%d+),(%d+),(%d+)")
		if id1 and id2 and id3 then
			return tonumber(id1), tonumber(id2), tonumber(id3)
		end
	end
end

local function ParseValues2(value)
	if type(value) == "string" then
		local id1, id2 = strmatch(value, "(%d+),(%d+)")
		if id1 and id2 then
			return tonumber(id1), tonumber(id2)
		end
	end
end

function module:ApplyUserLevels()
	-- Apply user-modified priorities
	local key, level
	for key, level in pairs(self.db.userLevels) do
		local valid = type(key) == "string" and type(level) == "number"
		if valid then
			local tierId, instanceId, spellId = ParseValues(key)
			valid = InitDebuffLevel(tierId, instanceId, spellId, level)
		end

		if not valid then
			self.db.userLevels[key] = nil
		end
	end
end

function module:ClearUserLevels()
	local _, tier, instance
	for _, tier in pairs(tierList) do
		for _, instance in pairs(tier.instances) do
			local debuff
			for _, debuff in pairs(instance.debuffs) do
				debuff.level = debuff.defLevel
			end
		end
	end
end

function module:GetZoneDebuffs()
	local zone = GetInstanceInfo() or GetRealZoneText()
	if not zone then
		return
	end

	local _, continent = GetCurrentMapContinent()

	local _, tier
	for _, tier in pairs(tierList) do
		local id, data
		for id, data in pairs(tier.instances) do
			if data.name == zone or data.name == continent then
				--print("zone debuff: ", data.name)
				return data.debuffs
			end
		end
	end
end

function module:DeleteCustomDebuff(tierId, instanceId, spellId)
	local instance = GetInstance(tierId, instanceId)
	if not instance then
		return
	end

	local name = GetSpellInfo(spellId)
	if not name then
		return
	end

	local debuff = instance.debuffs[name]
	if not debuff or not debuff.custom then
		return
	end

	instance.debuffs[name] = nil
	instance.debuffCount = instance.debuffCount - 1
	self.db.customDebuffs[format("%d,%d,%d", tierId, instanceId, spellId)] = nil
	return debuff
end

function module:ApplyCustomDebuffs()
	-- Apply custom debuffs
	local key, value
	for key, value in pairs(self.db.customDebuffs) do
		local valid = type(key) == "string" and type(value) == "string"
		if valid then
			local tierId, instanceId, spellId = ParseValues(key)
			local bossId, level = ParseValues2(value)
			if tierId and instanceId and spellId and bossId and level then
				valid = module:RegisterDebuff(tierId, instanceId, bossId, spellId, level, 1)
			end
		end

		if not valid then
			self.db.customDebuffs[key] = nil
		end
	end
end

function module:ClearCustomDebuffs()
	local _, tier, instance
	for _, tier in pairs(tierList) do
		for _, instance in pairs(tier.instances) do
			local name, debuff
			for name, debuff in pairs(instance.debuffs) do
				if debuff.custom then
					instance.debuffs[name] = nil
				end
			end
		end
	end
end

------------------------------------------------
-- Internal Utilities
------------------------------------------------

local function FindBoss(bosses, id)
	local general
	local _, data
	for _, data in ipairs(bosses) do
		if data.id == id then
			return data
		end

		if data.id == 0 then
			general = data
		end
	end

	return general, 1
end

local function Instance_RegisterDebuff(self, bossId, spellId, level, custom)
	local name, _, icon = GetSpellInfo(spellId)
	if not name then
		return
	end

	level = NormalizeLevel(level, 2)

	local boss, general = FindBoss(self.bosses, bossId)
	if general then
		bossId = 0
	end

	local debuff = self.debuffs[name]
	if debuff then
		return
	end

	debuff = {}
	self.debuffs[name] = debuff
	self.debuffCount = self.debuffCount + 1
	boss.debuffCount = boss.debuffCount + 1

	debuff.id = spellId
	debuff.name = name
	debuff.icon = icon
	debuff.link = "|cff71d5ff|Hspell:"..spellId.."|h["..name.."]|h|r"
	debuff.level = level
	debuff.defLevel = level
	debuff.bossId = bossId
	debuff.custom = custom

	return debuff
end

local function BuildBossList(instanceId)
	EJ_SelectInstance(instanceId)
	local list = {}
	local i
	for i = 1, 255 do
		local name, _, id = EJ_GetEncounterInfoByIndex(i)
		if not name or not id then
			break
		end

		tinsert(list, { id = id, name = name, debuffCount = 0 })
	end

	tinsert(list, { id = 0, name = GENERAL, debuffCount = 0 })
	return list
end

local function BuildInstanceList(tier, instanceType, list)
	local arg = instanceType == "raid"
	EJ_SelectTier(tier)
	local i
	for i = 1, 255 do
		local id, name = EJ_GetInstanceByIndex(i, arg)
		if not id or not name then
			break
		end

		local data = { id = id, name = name, type = instanceType, debuffCount = 0, debuffs = {} }
		data.RegisterDebuff = Instance_RegisterDebuff
		list[id] = data
		data.bosses = BuildBossList(id)
	end
end

function module:InitAPI()
	local i
	local numTiers = EJ_GetNumTiers()
	for i = 1, numTiers do
		local tier = {}
		tier.name = EJ_GetTierInfo(i)
		tier.id = i
		tier.instances = {}
		BuildInstanceList(i, "raid", tier.instances)
		BuildInstanceList(i, "party", tier.instances)
		tinsert(tierList, tier)
	end

	initDone = 1
	local _, data
	for _, data in pairs(pendingList) do
		self:RegisterDebuff(data.tierId, data.instanceId, data.bossId, data.spellId, data.level, data.custom)
	end

	wipe(pendingList)
end
