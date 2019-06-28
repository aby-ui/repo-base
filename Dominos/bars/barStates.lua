--[[
	barStates.lua
		A thingy for mapping stateIds to macro states
--]]
local _, Addon = ...
local states = {}

local getStateIterator = function(type, i)
	for j = i + 1, #states do
		local state = states[j]
		if state and ((not type) or state.type == type) then
			return j, state
		end
	end
end

local BarStates = {
	add = function(self, state, index)
		if index then
			return table.insert(states, index, state)
		end
		return table.insert(states, state)
	end,
	getAll = function(self, type)
		return getStateIterator, type, 0
	end,
	get = function(self, id)
		for i, v in pairs(states) do
			if v.id == id then
				return v
			end
		end
	end,
	map = function(self, f)
		local results = {}
		for k, v in ipairs(states) do
			if f(v) then
				table.insert(results, v)
			end
		end
		return results
	end
}
Addon.BarStates = BarStates

local addState = function(stateType, stateId, stateValue, stateText)
	return BarStates:add {
		type = stateType,
		id = stateId,
		value = stateValue,
		text = stateText
	}
end

-- keybindings
addState("modifier", "selfcast", "[mod:SELFCAST]", AUTO_SELF_CAST_KEY_TEXT)
addState("modifier", "ctrlAltShift", "[mod:alt,mod:ctrl,mod:shift]")
addState("modifier", "ctrlAlt", "[mod:alt,mod:ctrl]")
addState("modifier", "altShift", "[mod:alt,mod:shift]")
addState("modifier", "ctrlShift", "[mod:ctrl,mod:shift]")
addState("modifier", "alt", "[mod:alt]", ALT_KEY)
addState("modifier", "ctrl", "[mod:ctrl]", CTRL_KEY)
addState("modifier", "shift", "[mod:shift]", SHIFT_KEY)

-- paging
for i = 2, 6 do
	addState("page", "page" .. i, ("[bar:%d]"):format(i), _G["BINDING_NAME_ACTIONPAGE" .. i])
end

-- class
do
	local class = select(2, UnitClass("player"))

	if class == "DRUID" then
		if Addon:IsBuild("classic") then
			addState(
				"class",
				"moonkin",
				function()
					return ("[form:%d]"):format(GetNumShapeshiftForms())
				end,
				GetSpellInfo(24858)
			)
		else
			addState("class", "moonkin", "[bonusbar:4]", GetSpellInfo(24858))
			addState(
				"class",
				"tree",
				function()
					return ("[form:%d]"):format(GetNumShapeshiftForms() + 1)
				end,
				GetSpellInfo(33891)
			)
		end

		addState("class", "bear", "[bonusbar:3]", GetSpellInfo(5487))

		addState("class", "prowl", "[bonusbar:1,stealth]", GetSpellInfo(5215))
		addState("class", "cat", "[bonusbar:1]", GetSpellInfo(768))
	elseif class == "ROGUE" then
		if GetSpellInfo(185313) then
			addState("class", "shadowdance", "[form:2]", GetSpellInfo(185313))
		end

		addState("class", "stealth", "[bonusbar:1]", GetSpellInfo(1784))
	elseif class == "WARRIOR" and Addon:IsBuild("classic") then
		addState("class", "battle", "[bonusbar:1]", GetSpellInfo(2457))
		addState("class", "defensive", "[bonusbar:2]", GetSpellInfo(71))
		addState("class", "berserker", "[bonusbar:3]", GetSpellInfo(2458))
	elseif class == "PRIEST" and Addon:IsBuild("classic") then
		addState("class", "shadowform", "[form:1]", GetSpellInfo(16592))
	end
end

-- race
do
	local race = select(2, UnitRace("player"))
	if race == "NightElf" then
		local name = (GetSpellInfo(58984) or GetSpellInfo(20580))
		addState("class", "shadowmeld", "[stealth]", name)
	end
end

-- target reaction
addState("target", "help", "[help]")
addState("target", "harm", "[harm]")
addState("target", "notarget", "[noexists]")

-- automatic updating for UPDATE_SHAPESHIFT_FORMS
do
	local f = CreateFrame("Frame")
	f:Hide()
	f:SetScript(
		"OnEvent",
		function()
			if not InCombatLockdown() then
				Addon.ActionBar:ForAll("UpdateStateDriver")
			end
		end
	)
	f:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
end
