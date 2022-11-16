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

function RSTooltipScanners.ScanNpcName(npcID)
	local tooltipData = C_TooltipInfo.GetHyperlink('unit:Creature-0-0-0-0-' .. npcID .. '-0')
	if (tooltipData) then
		TooltipUtil.SurfaceArgs(tooltipData)
		for _, line in ipairs(tooltipData.lines) do
			TooltipUtil.SurfaceArgs(line)
		end
		
		if (tooltipData.lines and tooltipData.lines[1] and tooltipData.lines[1].leftText) then
			private.dbglobal.rare_names[GetLocale()][npcID] = tooltipData.lines[1].leftText
		end
	end
end

---============================================================================
-- Loot tooltip scanner
---============================================================================

function RSTooltipScanners.ScanLoot(itemLink, value)
	local foundText = false
	
	local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
	if (tooltipData) then
		TooltipUtil.SurfaceArgs(tooltipData)
		for _, line in ipairs(tooltipData.lines) do
			TooltipUtil.SurfaceArgs(line)
		end
		
		if (tooltipData.lines) then
			for i=1, #tooltipData.lines do
				if (tooltipData.lines[i]) then
					local toolTipText = tooltipData.lines[i].leftText
					if (toolTipText and RSUtils.Contains(toolTipText, value)) then
						foundText = true
						break
					end
				end
			end
		end
	end
	
	return foundText
end
