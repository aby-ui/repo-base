local E, L, C = select(2, ...):unpack()

local TooltipID = CreateFrame("Frame")
LibStub("AceHook-3.0"):Embed(TooltipID)

local _G = _G
local select = select
local match = string.match
local UnitBuff, UnitDebuff, UnitAura = UnitBuff, UnitDebuff, UnitAura

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
		if match(text, strType) then -- runs twice on inspection
			return
		end
	end

	tooltip:AddLine("\n" .. strType .. " |cff33ff99" .. id, 1, 1, 1, true)
	tooltip:Show() -- resize window
end

local function AddAuraID(self, unit, index, auraType)
	if auraType == "HELPFUL" or auraType == "HARMFUL" then -- TODO: auraType == "MAW"
		local id = select(10, UnitAura(unit, index, auraType))
		if id then AppendID(self, id, ID_TYPE[auraType]) end
	end
end

local function AddBuffID(self, ...)
	local id = select(10, UnitBuff(...))
	if id then AppendID(self, id, ID_TYPE.HELPFUL) end
end

local function AddDebuffID(self, ...)
	local id = select(10, UnitDebuff(...))
	if id then AppendID(self, id, ID_TYPE.HARMFUL) end
end

local function AddSpellID(self)
	local id = select(2, self:GetSpell())
	if id then AppendID(self, id, ID_TYPE.SPELL) end
end

local function AddItemID(self)
	local itemLink = select(2, self:GetItem())
	if itemLink then
		local id = GetItemInfoInstant(itemLink)
		if id then AppendID(self, id, ID_TYPE.ITEM) end
	end
end

function TooltipID:HookAll()
	if self.hooked then
		return
	end

	self:SecureHook(GameTooltip, "SetUnitAura", AddAuraID) -- player
	self:SecureHook(GameTooltip, "SetUnitBuff", AddBuffID) -- target/focus
	self:SecureHook(GameTooltip, "SetUnitDebuff", AddDebuffID)
	self:HookScript(GameTooltip, "OnTooltipSetSpell", AddSpellID)
	self:HookScript(GameTooltip, "OnTooltipSetItem", AddItemID)

	self.hooked = true
end

function TooltipID:UnHookAll()
	if not self.hooked then
		return
	end

	self:UnhookAll()

	self.hooked = false
end

function TooltipID:SetHooks()
	if E.DB.profile.tooltipID then
		self:HookAll()
	else
		self:UnHookAll()
	end
end

E["TooltipID"] = TooltipID
