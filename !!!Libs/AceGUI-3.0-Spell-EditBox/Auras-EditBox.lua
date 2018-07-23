local AceGUI = LibStub("AceGUI-3.0")
do
	local Type = "Aura_EditBox"
	local Version = 1
	local filterCache = {}
	
	-- Tooltip scanning every single spell while it's loading would be not be that fun. Scanning spells as we search them (and get valid results)
	-- is a better solution since the results can be cached too.
	local function spellFilter(self, spellID)
		if( filterCache[spellID] ~= nil ) then return filterCache[spellID] end
		
		-- Very very few auras are over 100 yard range, and those are generally boss spells should be able to get away with this
		if( select(9, GetSpellInfo(spellID)) > 100 ) then
			filterCache[spellID] = true
			return false
		end
		
		-- We look for a description tag, 99% of auras have a description tag indicating what they are
		-- so we don't find one, then it's likely a safe assumption that it is not an aura
		self.tooltip:SetHyperlink("spell:" .. spellID)
		for i=1, self.tooltip:NumLines() do
			local text = self.tooltip["TextLeft" .. i]
			if( text ) then
				local r, g, b = text:GetTextColor()
				r = math.floor(r + 0.10)
				g = math.floor(g + 0.10)
				b = math.floor(b + 0.10)
				
				-- Gold first text, it's a profession link
				if( i == 1 and ( r ~= 1 or g ~= 1 or g ~= 1 ) ) then
					filterCache[spellID] = false
					return false
				-- Gold for anything else and it should be a valid aura
				elseif( r ~= 1 or g ~= 1 or b ~= 1 ) then
					filterCache[spellID] = true
					return true
				end
			end
		end

		filterCache[spellID] = false
		return false
	end
	
	-- I know theres a better way of doing this than this, but not sure for the time being, works fine though!
	local function Constructor()
		local self = AceGUI:Create("Predictor_Base")
		self.spellFilter = spellFilter
		return self
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
