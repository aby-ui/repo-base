------------------------------------------------------------
-- WheelSupports.lua
--
-- Abin
-- 2012/3/10
------------------------------------------------------------

local ipairs = ipairs
local SecureHandlerExecute = SecureHandlerExecute
local _

local module = CompactRaid:GetModule("ClickSets")
if not module then return end

local WHEEL_UP_START = 6
local WHEEL_DOWN_MAP = 7
local WHEEL_DOWN_START = 14
local WHEEL_MAX = 21

function module:GetWheelMax()
	return WHEEL_MAX
end

function module:EncodeWheelButton(id)
	if id >= WHEEL_UP_START and id < WHEEL_DOWN_START then
		-- scroll up, mapped to buttons 6 - 13
		return module.BINDING_MODIFIERS[id - 5], WHEEL_UP_START
	elseif id >= WHEEL_DOWN_START and id <= WHEEL_MAX then
		-- scroll down, mapped to buttons 14 - 21
		return module.BINDING_MODIFIERS[id - 13], WHEEL_DOWN_MAP
	end
end

function module:DecodeWheelButton(modifier, id)
	if id ~= WHEEL_UP_START and id ~= WHEEL_DOWN_MAP then
		return modifier, id
	end

	local index
	local i, value
	for i, value in ipairs(module.BINDING_MODIFIERS) do
		if value == modifier then
			index = i
			break
		end
	end

	if not index then
		return modifier, id
	end

	if id == WHEEL_UP_START then
		-- scroll up, mapped to buttons 6 - 13
		return "", WHEEL_UP_START - 1 + index
	else
		-- scroll down, mapped to buttons 14 - 21
		return "", WHEEL_DOWN_START - 1 + index
	end
end

function module:EnableWheelCastOnFrame(frame)
	frame:SetAttribute("_onenter", [[
		self:ClearBindings()
		self:SetBindingClick(1, "MOUSEWHEELUP", self, "Button6")
		self:SetBindingClick(1, "SHIFT-MOUSEWHEELUP", self, "Button7")
		self:SetBindingClick(1, "CTRL-MOUSEWHEELUP", self, "Button8")
		self:SetBindingClick(1, "ALT-MOUSEWHEELUP", self, "Button9")
		self:SetBindingClick(1, "CTRL-SHIFT-MOUSEWHEELUP", self, "Button10")
		self:SetBindingClick(1, "ALT-SHIFT-MOUSEWHEELUP", self, "Button11")
		self:SetBindingClick(1, "ALT-CTRL-MOUSEWHEELUP", self, "Button12")
		self:SetBindingClick(1, "ALT-CTRL-SHIFT-MOUSEWHEELUP", self, "Button13")
		self:SetBindingClick(1, "MOUSEWHEELDOWN", self, "Button14")
		self:SetBindingClick(1, "SHIFT-MOUSEWHEELDOWN", self, "Button15")
		self:SetBindingClick(1, "CTRL-MOUSEWHEELDOWN", self, "Button16")
		self:SetBindingClick(1, "ALT-MOUSEWHEELDOWN", self, "Button17")
		self:SetBindingClick(1, "CTRL-SHIFT-MOUSEWHEELDOWN", self, "Button18")
		self:SetBindingClick(1, "ALT-SHIFT-MOUSEWHEELDOWN", self, "Button19")
		self:SetBindingClick(1, "ALT-CTRL-MOUSEWHEELDOWN", self, "Button20")
		self:SetBindingClick(1, "ALT-CTRL-SHIFT-MOUSEWHEELDOWN", self, "Button21")
	]])

	frame:SetAttribute("_onleave", [[
		self:ClearBindings()
	]])
end

function module:DisableWheelCastOnFrame(frame)
	frame:SetAttribute("_onenter", nil)
	frame:SetAttribute("_onleave", nil)
	SecureHandlerExecute(frame, [[
		self:ClearBindings()
	]])
end

function module:EnableWheelCast()
	self:EnumUnitFrames(self, "EnableWheelCastOnFrame")
end

function module:DisableWheelCast()
	self:EnumUnitFrames(self, "DisableWheelCastOnFrame")
end

function module:HasWheelBinds()
	local talentdb = self.talentdb
	if not talentdb then
		return
	end

	local modifier
	for _, modifier in ipairs(self.BINDING_MODIFIERS) do
		if talentdb[modifier..WHEEL_UP_START] or talentdb[modifier..WHEEL_DOWN_MAP] then
			return 1
		end
	end
end

function module:UpdateWheelCast()
	if self:HasWheelBinds() then
		self:EnableWheelCast()
	else
		self:DisableWheelCast()
	end
end
