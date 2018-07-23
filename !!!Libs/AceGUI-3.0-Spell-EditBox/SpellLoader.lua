local major = "AceGUI-3.0-SpellLoader"
local minor = 1

local SpellLoader = LibStub:NewLibrary(major, minor)
if( not SpellLoader ) then return end

SpellLoader.predictors = SpellLoader.predictors or {}
SpellLoader.spellList = SpellLoader.spellList or {}
SpellLoader.spellsLoaded = SpellLoader.spellsLoaded or 0

local SPELLS_PER_RUN = 500
local TIMER_THROTTLE = 0.10
local spells, predictors = SpellLoader.spellList, SpellLoader.predictors

function SpellLoader:RegisterPredictor(frame)
	self.predictors[frame] = true
end

function SpellLoader:UnregisterPredictor(frame)
	self.predictors[frame] = nil
end

function SpellLoader:StartLoading()
	if( self.loader ) then return end

	local blacklist = {
		["Interface\\Icons\\Trade_Alchemy"] = true,
		["Interface\\Icons\\Trade_BlackSmithing"] = true,
		["Interface\\Icons\\Trade_BrewPoison"] = true,
		["Interface\\Icons\\Trade_Engineering"] = true,
		["Interface\\Icons\\Trade_Engraving"] = true,
		["Interface\\Icons\\Trade_Fishing"] = true,
		["Interface\\Icons\\Trade_Herbalism"] = true,
		["Interface\\Icons\\Trade_LeatherWorking"] = true,
		["Interface\\Icons\\Trade_Mining"] = true,
		["Interface\\Icons\\Trade_Tailoring"] = true,
		["Interface\\Icons\\Temp"] = true,
	}
		
	local timeElapsed, totalInvalid, currentIndex = 0, 0, 0
	self.loader = CreateFrame("Frame")
	self.loader:SetScript("OnUpdate", function(self, elapsed)
		timeElapsed = timeElapsed + elapsed
		if( timeElapsed < TIMER_THROTTLE ) then return end
		timeElapsed = timeElapsed - TIMER_THROTTLE
		
		-- 5,000 invalid spells in a row means it's a safe assumption that there are no more spells to query
		if( totalInvalid >= 5000 ) then
			self:Hide()
			return
		end

		-- Load as many spells in
		for spellID=currentIndex + 1, currentIndex + SPELLS_PER_RUN do
			local name, rank, icon = GetSpellInfo(spellID)
			
			-- Pretty much every profession spell uses Trade_* and 99% of the random spells use the Trade_Engineering icon
			-- we can safely blacklist any of these spells as they are not needed. Can get away with this because things like
			-- Alchemy use two icons, the Trade_* for the actual crafted spell and a different icon for the actual buff
			-- Passive spells have no use as well, since they are well passive and can't actually be used
			if( name and not blacklist[icon] and rank ~= SPELL_PASSIVE ) then
				name = string.lower(name)
				
				SpellLoader.spellsLoaded = SpellLoader.spellsLoaded + 1
				spells[spellID] = string.lower(name)
				
				totalInvalid = 0
			else
				totalInvalid = totalInvalid + 1
			end
		end
		
		-- Every ~1 second it will update any visible predictors to make up for the fact that the data is delay loaded
		if( currentIndex % 5000 == 0 ) then
			for predictor in pairs(predictors) do
				if( predictor:IsVisible() ) then
					predictor:Query()
				end
			end
		end

		
		-- Increment and do it all over!
		currentIndex = currentIndex + SPELLS_PER_RUN
	end)
end