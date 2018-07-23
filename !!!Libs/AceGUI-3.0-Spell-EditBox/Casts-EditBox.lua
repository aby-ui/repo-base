local AceGUI = LibStub("AceGUI-3.0")
do
	local Type = "Cast_EditBox"
	local Version = 1
	local filterCache = {}
	
	local function spellFilter(self, spellID)
		if( filterCache[spellID] ~= nil ) then return filterCache[spellID] end
		
		-- Scan first line to figure out if it's a profession
		self.tooltip:SetHyperlink("spell:" .. spellID)
		local r, g, b = self.tooltip.TextLeft1:GetTextColor()
		r = math.floor(r + 0.10)
		g = math.floor(g + 0.10)
		b = math.floor(b + 0.10)
		
		if( r ~= 1 or g ~= 1 or b ~= 1 ) then
			filterCache[spellID] = false
			return false
		end
		
		-- Hide all spells without a cast time
		filterCache[spellID] = select(7, GetSpellInfo(spellID)) > 0
		return filterCache[spellID]
	end
	
	-- I know theres a better way of doing this than this, but not sure for the time being, works fine though!
	local function Constructor()
		local self = AceGUI:Create("Predictor_Base")
		self.spellFilter = spellFilter
		return self
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
