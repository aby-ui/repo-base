------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2010/10/16
------------------------------------------------------------

local wipe = wipe
local pairs = pairs
local type = type
local gsub = gsub
local tostring = tostring
local ipairs = ipairs
local InCombatLockdown = InCombatLockdown
local strtrim = strtrim
local strlen = strlen
local _G = _G
local ATTRIBUTE_NOOP = ATTRIBUTE_NOOP

local L = CompactRaid:GetLocale("ClickSets")
local module = CompactRaid:CreateModule("ClickSets", "CHAR", L["title"], L["desc"], 1, 1)
if not module then return end

module.initialOff = 1
module.BINDING_MODIFIERS = { "", "shift-", "ctrl-", "alt-", "ctrl-shift-", "alt-shift-", "alt-ctrl-", "alt-ctrl-shift-" }
module.ACTION_TYPES = { togglemenu = 1, target = 1, assist = 1, focus = 1, spell = 2, macro = 2, buildin = 2 }

local function AssignBindToUnitFrame(frame, modifier, id, action, extra)
	local bindType, bindKey, bindValue

	if action == "action" then

		bindType = extra

	elseif action == "spell" then

		bindType = "spell"
		bindKey = "spell"
		bindValue = extra

	elseif action == "buildin" then

		if extra == "emergent" then
			bindType = "macro"
			bindKey = "macrotext"
			bindValue = module:GetEmergentMacro()
		elseif extra == "special" then
			bindType = "macro"
			bindKey = "macrotext"
			bindValue = module:GetSpecialMacro()
		else
			bindType = "spell"
			bindKey = "spell"
			bindValue = extra
		end

	elseif action == "macro" then

		bindType = "macro"
		bindKey = "macrotext"
		bindValue = gsub(extra or "", "##", "@mouseover")
	end

	if bindType then
		frame:SetAttribute(modifier.."type"..id, bindType)
		if bindKey then
			frame:SetAttribute(modifier..bindKey..id, bindValue)
		end
	else
		bindType = ATTRIBUTE_NOOP
		if modifier == "" then
			if id == 1 then
				bindType = "target"
			elseif id == 2 then
				bindType = "togglemenu"
			end
		end
		frame:SetAttribute(modifier.."type"..id, bindType)
	end
end

local function AssignBind(modifier, id, action, extra)
	modifier, id = module:DecodeWheelButton(modifier, id)
	module:EnumUnitFrames(AssignBindToUnitFrame, modifier, id, action, extra)
end

local function ClearAll()
	local _, modifier, id
	for _, modifier in ipairs(module.BINDING_MODIFIERS) do
		for id = 1, 7 do
			AssignBind(modifier, id)
		end
	end
end

local function AssignAll()
	ClearAll()
	local key, value
	for key, value in pairs(module.talentdb) do
		if type(key) == "string" and type(value) == "string" then
			local modifier, id = strmatch(key, "(.-)(%d+)$")
			if id then
				local action, extra = strmatch(value, "(.-):(.+)")
				AssignBind(modifier, tonumber(id), action, extra)
			end
		end
	end
end

local function ConvertValue(data)
	-- old format: { [1-5] = { ["Shift/Ctrl/..."] = { action = "spell/macro/...", text = "spell name / macro text" } } }
	-- new format: { ["modifiers".."1-7"] = "action:target/assist/follow/focus" or "buildin:?/spell:?/macro:?" }
	if type(data) == "table" and data.action then
		local value
		if data.action == "spell" then
			if data.spelltext then
				value = "spell:"..data.spelltext -- User defined spell
			end
		elseif data.action == "macro" then
			if data.macrotext then
				value = "macro:"..data.macrotext
			end
		elseif module.ACTION_TYPES[data.action] == 1 then
			value = "action:"..data.action
		else
			value = "buildin:"..data.action -- Buildin spell
		end
		return value
	end
end

local function ConvertDB(db)
	-- Convert data from old version
	local index, data, converted
	for index, data in ipairs(db) do
		if type(data) == "table" then
			converted = 1
			local key, value
			if index > 5 then
				-- wheels
				local newValue = ConvertValue(data)
				if newValue then
					local modifier, newid = module:EncodeWheelButton(index)
					if modifier then
						db[modifier..newid] = newValue
					end
				end
			else
				for key, value in pairs(data) do
					local newValue = ConvertValue(value)
					if newValue then
						db[key..index] = newValue
					end
				end
			end
		end

		db[index] = nil
	end

	if converted then
		if not db["1"] then
			db["1"] = "action:target"
		end

		if not db["2"] then
			db["2"] = "action:togglemenu"
		end
	end
end

-- Change action "menu" to "togglemenu" for 5.3
local function Convert_ToggleMenu(db)
	local key, value
	for key, value in pairs(db) do
		if value == "action:menu" then
			db[key] = "action:togglemenu"
		end
	end
end

function module:OnCreateDynamic(frame)
	CompactRaid:CliqueUnregister(frame)

	local key, value
	for key, value in pairs(module.talentdb) do
		if type(key) == "string" and type(value) == "string" then
			local modifier, id = strmatch(key, "(.-)(%d+)$")
			if id then
				local action, extra = strmatch(value, "(.-):(.+)")
				modifier, id = module:DecodeWheelButton(modifier, tonumber(id))
				AssignBindToUnitFrame(frame, modifier, id, action, extra)
			end
		end
	end

	if self:HasWheelBinds() then
		self:EnableWheelCastOnFrame(frame)
	end
end

function module:OnTalentGroupChange(talentGroup, talentdb, firstTime)
	ConvertDB(talentdb)
	Convert_ToggleMenu(talentdb)
	AssignAll()
	self:UpdateWheelCast()
	self:InitOptionData()
end

function module:OnRestoreDefaults()
	AssignAll()
	self:UpdateWheelCast()
	self:InitOptionData()
end

function module:OnEnable()
	CompactRaid:CliqueUnregister()
end

function module:OnDisable()
	ClearAll()
	self:DisableWheelCast()
	CompactRaid:CliqueRegister()
end

function module:ChangeBinding(modifier, id, action, extra)
	if self.talentdb then
		self.talentdb[modifier..id] = action and extra and action..":"..extra or nil -- Save settings
		AssignBind(modifier, id, action, extra)
		self:UpdateWheelCast()
	end
end
