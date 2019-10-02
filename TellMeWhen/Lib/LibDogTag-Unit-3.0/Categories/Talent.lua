local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local wow_ver = select(4, GetBuildInfo())
local wow_500 = wow_ver >= 50000

local _G, table, setmetatable, rawget = _G, table, setmetatable, rawget
local UnitName, GetActiveTalentGroup, GetTalentTabInfo, UnitIsPlayer, GetNumTalentTabs =
	  UnitName, GetActiveTalentGroup, GetTalentTabInfo, UnitIsPlayer, GetNumTalentTabs

if wow_500 then
	GetActiveTalentGroup = GetActiveSpecGroup
	GetTalentTabInfo = GetSpecializationInfo
	GetNumTalentTabs = GetNumSpecializations
end

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local newList, del = DogTag.newList, DogTag.del

local function TalentSpec_func(unit) return nil end
local function TalentTree_func(unit) return nil end

DogTag:AddAddonFinder("Unit", "LibStub", "LibTalentQuery-1.0", function(LibTalentQuery)
	local talentSpecs, talentSpecNames
	local function mySort(alpha, bravo)
		return alpha[2] > bravo[2]
	end

	local function update(fullName, data)
		talentSpecs[fullName] = data[1][2] .. "/" .. data[2][2] .. "/" .. data[3][2]
		table.sort(data, mySort)

		if data[1][2] == 0 then
			talentSpecNames[fullName] = _G.NONE
		elseif data[1][2]*3/4 <= data[2][2] then
			if data[1][2]*3/4 <= data[3][2] then
				talentSpecNames[fullName] = L["Hybrid"]
			else
				talentSpecNames[fullName] = data[1][1] .. "/" .. data[2][1]
			end
		else
			talentSpecNames[fullName] = data[1][1]
		end
	end

	LibTalentQuery.RegisterCallback(DogTag_Unit, "TalentQuery_Ready", function(event, name, realm, unitId)
		local fullName = realm and name .. "-" .. realm or name

		if wow_500 then
			local inspectSpec = GetInspectSpecialization(unitId)
			local roleById = GetSpecializationInfoByID(inspectSpec)
			if roleById ~= nil then
				talentSpecNames[fullName] = select(2, GetSpecializationInfoByID(roleById))
			end
			return
		end

		local talentGroup = GetActiveTalentGroup(true)
		local data = newList()
		for i = 1, 3 do
			local _, name, _, _, points = GetTalentTabInfo(i, true, false, talentGroup)
			data[i] = newList(name, points)
		end
		update(fullName, data)
		for i = 1, 3 do
			data[i] = del(data[i])
		end
		data = del(data)

		DogTag:FireEvent("Talent")
	end)
	local playerName = UnitName("player")
	local lastUnit
	local function func(self, name)
		if name == playerName then
			if wow_500 then
				talentSpecNames[playerName] = select(2, GetSpecializationInfo(GetSpecialization()))
				return
			end

			local data = newList()
			for i = 1, 3 do
				local _, name, _, _, points = GetTalentTabInfo(i)
				data[i] = newList(name, points)
			end
			update(UnitName("player"), data)
			for i = 1, 3 do
				data[i] = del(data[i])
			end
			data = del(data)
			return rawget(self, name)
		else
			LibTalentQuery:Query(lastUnit)
		end

		return nil
	end
	local x = {__index=func}
	talentSpecs = setmetatable({}, x)
	talentSpecNames = setmetatable({}, x)
	x = nil

	local GetNameServer = DogTag_Unit.GetNameServer
	function TalentSpec_func(unit)
		if not UnitIsPlayer(unit) then
			return nil
		end
		lastUnit = unit
		return talentSpecs[GetNameServer(unit)]
	end
	function TalentTree_func(unit)
		if not UnitIsPlayer(unit) then
			return nil
		end
		lastUnit = unit
		return talentSpecNames[GetNameServer(unit)]
	end
end)

DogTag:AddTag("Unit", "TalentSpec", {
	code = function(args)
		return TalentSpec_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Talent",
	doc = L["Return the talent spec of unit if available"],
	example = '[TalentSpec] => "30/31/0"',
	category = L["Characteristics"]
})

DogTag:AddTag("Unit", "TalentTree", {
	code = function(args)
		return TalentTree_func
	end,
	dynamicCode = true,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Talent",
	doc = L["Return the talent tree of unit if available"],
	example = ('[TalentTree] => %q'):format("Holy/Prot"),
	category = L["Characteristics"]
})

end