-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSTooltipScanners = private.NewLib("RareScannerTooltipScanners")

-- RareScanner general libraries
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- NPCs tooltip scanner
---============================================================================

local tooltipNames = {}
local lootTooltip

local function GetTooltipNameScanner()
	local now = GetTime()
	for i, tip in ipairs(tooltipNames) do
		if (not tip.npcID or now - tip.lastUpdate > 0.5) then
			tip.lastUpdate = now
			return tip
		end
	end

	local tip = CreateFrame('GameTooltip', 'TooltipNpcName' .. (#tooltipNames + 1), UIParent, 'GameTooltipTemplate')
	tip:Show()
	tip:SetHyperlink('unit:')
	tip.lastUpdate = now
	tinsert(tooltipNames, tip)
	return tip
end

function RSTooltipScanners.ScanNpcName(npcID)
	local tip = GetTooltipNameScanner()
	tip:SetOwner(UIParent, 'ANCHOR_NONE')
	tip.npcID = npcID or 0
	tip:SetScript('OnTooltipSetUnit', function(self)
		local tipName = self:GetName()
		local name, _ = _G[tipName .. 'TextLeft1']:GetText(), _G[tipName ..'TextLeft2']:GetText()
		if (name) then
			--Cannot use RSNpcDB.SetNpcName(self.npcID, name), cyclic import!
			private.dbglobal.rare_names[GetLocale()][npcID] = name
		end
		self:SetScript('OnTooltipSetUnit', nil)
		self.npcID = nil
	end)
	tip:SetHyperlink('unit:Creature-0-0-0-0-' .. npcID .. '-0')
end

---============================================================================
-- Loot tooltip scanner
---============================================================================

function RSTooltipScanners.ScanLoot(itemLink, value)
	-- Init tooltip
	if (not lootTooltip) then
		lootTooltip = CreateFrame("GAMETOOLTIP", "RSToolTipScan", nil, "GameTooltipTemplate")
		lootTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
	
	lootTooltip:SetHyperlink(itemLink)
	
	local foundText = false
	for i=1, lootTooltip:NumLines() do
		if (_G["RSToolTipScanTextLeft"..i]) then
			local toolTipText = _G["RSToolTipScanTextLeft"..i]:GetText()
			if (toolTipText and RSUtils.Contains(toolTipText, value)) then
				foundText = true
				break
			end
		end
	end

	return foundText
end
