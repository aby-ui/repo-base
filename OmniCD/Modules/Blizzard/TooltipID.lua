local E = select(2, ...):unpack()

local TT = CreateFrame("Frame")
LibStub("AceHook-3.0"):Embed(TT)

local strmatch = strmatch
local UnitBuff, UnitDebuff, UnitAura = UnitBuff, UnitDebuff, UnitAura
local C_TooltipInfo_GetUnitDebuffByAuraInstanceID = C_TooltipInfo and C_TooltipInfo.GetUnitDebuffByAuraInstanceID
local C_TooltipInfo_GetUnitBuffByAuraInstanceID = C_TooltipInfo and C_TooltipInfo.GetUnitBuffByAuraInstanceID

local ID_TYPE = {
	["HELPFUL"] = "Buff ID:",
	["HARMFUL"] = "Debuff ID:",
	["SPELL"] = "Spell ID:",
	["ITEM"] = "Item ID:",
}

local function AppendID(tooltip, id, strType)
	for i = 1, 15 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local text = frame and frame:GetText()

		if not text then break end
		if strmatch(text, strType) then
			return
		end
	end

	tooltip:AddLine("\n" .. strType .. " |cff33ff99" .. id, 1, 1, 1, true)
	tooltip:Show()
end

local function AddAuraID(self, unit, slotNumber, auraType)
	if auraType == "HELPFUL" or auraType == "HARMFUL" then
		local _,_,_,_,_,_,_,_,_, id = UnitAura(unit, slotNumber, auraType)
		if id then AppendID(self, id, ID_TYPE[auraType]) end
	end
end

local AddBuffID = E.isDF and function(self, unitTokenString, auraInstanceID)
	local data = C_TooltipInfo_GetUnitBuffByAuraInstanceID(unitTokenString, auraInstanceID)
	local id = data.args[2].intVal
	if id then AppendID(self, id, ID_TYPE.HELPFUL) end
end or function(self, ...)
	local id = select(10, UnitBuff(...))
	if id then AppendID(self, id, ID_TYPE.HELPFUL) end
end

local AddDebuffID = E.isDF and function(self, unitTokenString, auraInstanceID)
	local data = C_TooltipInfo_GetUnitDebuffByAuraInstanceID(unitTokenString, auraInstanceID)
	local id = data.args[2].intVal
	if id then AppendID(self, id, ID_TYPE.HARMFUL) end
end or function(self, ...)
	local id = select(10, UnitDebuff(...))
	if id then AppendID(self, id, ID_TYPE.HARMFUL) end
end

local function AddSpellID(tooltip)
	if (tooltip == GameTooltip or tooltip == EmbeddedItemTooltip) then
		local _, id = tooltip:GetSpell()
		if id then AppendID(tooltip, id, ID_TYPE.SPELL) end
	end
end

local function AddItemID(tooltip)
	if (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
		local _, itemLink = tooltip:GetItem()
		if itemLink then
			local id = GetItemInfoInstant(itemLink)
			if id then AppendID(tooltip, id, ID_TYPE.ITEM) end
		end
	end
end

function TT:HookAll()
	if self.hooked then
		return
	end

	self:SecureHook(GameTooltip, "SetUnitAura", AddAuraID)
	if E.isDF then
		self:SecureHook(GameTooltip, "SetUnitBuffByAuraInstanceID", AddBuffID)
		self:SecureHook(GameTooltip, "SetUnitDebuffByAuraInstanceID", AddDebuffID)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, AddSpellID)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.PetAction, AddSpellID)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, AddItemID)
	else
		self:SecureHook(GameTooltip, "SetUnitBuff", AddBuffID)
		self:SecureHook(GameTooltip, "SetUnitDebuff", AddDebuffID)
		self:HookScript(GameTooltip, "OnTooltipSetSpell", AddSpellID)
		self:HookScript(GameTooltip, "OnTooltipSetItem", AddItemID)
	end

	self.hooked = true
end

function TT:UnHookAll()
	if not self.hooked then
		return
	end

	self:UnhookAll()

	self.hooked = false
end

function TT:SetHooks()
	if self.enabled then
		self:HookAll()
	else
		self:UnHookAll()
	end
end

E["TooltipID"] = TT
