-- TODO:
--  - Write a description.

local _E
local hook

CreateFrame("GameTooltip", "LilSparkyDataScanTooltip", UIParent, "GameTooltipTemplate")
LilSparkyDataScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function FixedGetTradeSkillReagentItemLink(i, j)
    local tooltip = LilSparkyDataScanTooltip
    tooltip:ClearLines()
    tooltip:SetTradeSkillItem(i,j)
    local _, reagentLink = tooltip:GetItem()
    return reagentLink
end

local pipe = function(id)
	local itemLink = GetTradeSkillItemLink(id)

	if(itemLink) then
		oGlow:CallFilters('tradeskill', TradeSkillSkillIcon, _E and itemLink)
	end

	for i=1, GetTradeSkillNumReagents(id) do
		local reagentFrame = _G['TradeSkillReagent' .. i .. 'IconTexture']
		local reagentLink = FixedGetTradeSkillReagentItemLink(id, i)

		oGlow:CallFilters('tradeskill', reagentFrame, _E and reagentLink)
	end
end

local doHook = function()
	if(not hook) then
		hook = function(...)
			if(_E) then return pipe(...) end
		end

        hooksecurefunc(TradeSkillFrame.RecipeList, "SetSelectedRecipeID", hook)
	end
end

local function ADDON_LOADED(self, event, addon)
	if(addon == 'Blizzard_TradeSkillUI') then
		doHook()
		self:UnregisterEvent(event, ADDON_LOADED)
	end
end

local update = function(self)
	local id = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
	if(id and IsAddOnLoaded('Blizzard_TradeSkillUI')) then
		return pipe(id)
	end
end

local enable = function(self)
	_E = true

	if(IsAddOnLoaded("Blizzard_TradeSkillUI")) then
		doHook()
	else
		self:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local disable = function(self)
	_E = nil

	self:UnregisterEvent('ADDON_LOADED', ADDON_LOADED)
end

oGlow:RegisterPipe('tradeskill', enable, disable, update, 'Profession frame', nil)
