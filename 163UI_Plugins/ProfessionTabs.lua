U1PLUG["ProfessionTabs"] = function()

--------------------------------------------------
-- Changelog
--------------------------------------------------

--[[

--------------------------------------------------

Version: 1.2
Date: 2012-10-20

- Fixed issue with detecting profession ranks for races with profession skill bonuses

--------------------------------------------------

Version: 1.1
Date: 2012-08-31

- The toc file has been updated for patch 5.0.4
- Added support for TradeSkillDW
- Surveying has been added as a tab
- Tab selection accuracy has been improved
- Some code optimizations have been added
	- The GetProfessions and GetProfessionInfo APIs are now used rather than the IsSpellKnown API to obtain profession information
	- Tabs are now only created on demand
	- Tabs are now only updated when profession information changes

--------------------------------------------------

Version: 1.0.7
Date: 2010-11-13

- Added Cataclysm Professions
- Fixed TradeFrame tab positions
- Fixed tab update bug with TradeFrame

--------------------------------------------------

Version: 1.0.6
Date: 2010-10-31

- Adjusted the tab positions slightly. Shout out to EvilRick
- Updated toc

--------------------------------------------------

Version: 1.0.5
Date: 2010-07-23

- Updated to support the latest version of MrTrader
- Small rewrite in preparation for Cataclysm

--------------------------------------------------

Version: 1.0.4
Date: 2010-02-12

- Fixed the tab update problem with tradeskill based addons

--------------------------------------------------

Version: 1.0.3
Date: 02-12-10

- Added support for MrTrader

--------------------------------------------------

Version: 1.0.2
Date: 2010-02-11

- Code improvements

--------------------------------------------------

Version: 1.0.1
Date: 02-08-10

- Added support for AdvancedTradeSkillWindow and Skillet

--------------------------------------------------

Version: 1.0.0
Date: 2010-02-07

- Initial Release

--------------------------------------------------

--]]

--------------------------------------------------
-- Initialization
--------------------------------------------------

local IsCurrentSpell = IsCurrentSpell
local format = string.format
local next = next
local ranks = PROFESSION_RANKS
local _, class = UnitClass("player")
local tabs, spells = {}, {}

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", function(self, event) self[event](self, event) end)
handler:RegisterEvent("TRADE_SKILL_SHOW")
handler:RegisterEvent("TRADE_SKILL_CLOSE")
handler:RegisterEvent("TRADE_SHOW")
handler:RegisterEvent("SKILL_LINES_CHANGED")
handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

local defaults = {
	-- Primary Professions
	[171] = { true, false }, -- Alchemy
	[164] = { true, false }, -- Blacksmithing
	[333] = { true, true }, -- Enchanting
	[202] = { true, false }, -- Engineering
	[182] = { false, false }, -- Herbalism
	[773] = { true, true }, -- Inscription
	[755] = { true, true }, -- Jewelcrafting
	[165] = { true, false }, -- Leatherworking
	[186] = { true, false }, -- Mining
	[393] = { false, false }, -- Skinning
	[197] = { true, false }, -- Tailoring
	
	-- Secondary Professions
	[794] = { false, true }, -- Archaeology
	[185] = { true, true }, -- Cooking
	[129] = { true, false }, -- First Aid
	[356] = { false, false }, -- Fishing
}

if class == "DEATHKNIGHT" then spells[ #spells + 1 ] = 53428 end -- Runeforging
if class == "ROGUE" then spells[ #spells + 1 ] = 1804 end -- Pick Lock

local function UpdateSelectedTabs(object)
	if not handler:IsEventRegistered("CURRENT_SPELL_CAST_CHANGED") then
		handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	end
	
	for index = 1, #tabs[object] do
		local tab = tabs[object][index]
		tab:SetChecked(IsCurrentSpell(tab.name))
	end
end

local function ResetTabs(object)
	for index = 1, #tabs[object] do
		tabs[object][index]:Hide()
	end
	
	tabs[object].index = 0
end

local function UpdateTab(object, name, rank, texture)
	local index = tabs[object].index + 1
	local tab = tabs[object][index] or CreateFrame("CheckButton", nil, object, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate") 
	
	tab:ClearAllPoints()
	tab:SetPoint("TOPLEFT", object, "TOPRIGHT", object == ATSWFrame and -32 or 0, 16 + -44 * index)
	tab:SetNormalTexture(texture)
	tab:SetAttribute("type", "spell")
	tab:SetAttribute("spell", name)
	tab:Show()
	
	tab.name = name
	tab.tooltip = rank and rank ~= "" and format("%s (%s)", name, rank) or name
	
	tabs[object][index] = tabs[object][index] or tab
	tabs[object].index = tabs[object].index + 1
end

local function GetProfessionRank(currentSkill)
	for index = #ranks, 1, -1 do
		local requiredSkill, title = ranks[index][1], ranks[index][2]
		
		if currentSkill >= requiredSkill then
			return title
		end
	end
	return ""
end

local function HandleProfession(object, professionID)
	if professionID then
		local _, _, currentSkill, _, numAbilities, offset, skillID = GetProfessionInfo(professionID)
		
		if defaults[skillID] then
			for index = 1, numAbilities do
				if defaults[skillID][index] then
					local name = GetSpellBookItemName(offset + index, "profession")
					local rank = GetProfessionRank(currentSkill)
					local texture = GetSpellBookItemTexture(offset + index, "profession")
					
					if name and rank and texture then
						UpdateTab(object, name, rank, texture)
					end
				end
			end
		end
	end
end

local function HandleTabs(object)
	tabs[object] = tabs[object] or {}
	
	if InCombatLockdown() then
		handler:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		local firstProfession, secondProfession, archaeology, fishing, cooking, firstAid = GetProfessions()
		
		ResetTabs(object)
		
		HandleProfession(object, firstProfession)
		HandleProfession(object, secondProfession)
		HandleProfession(object, archaeology)
		HandleProfession(object, fishing)
		HandleProfession(object, cooking)
		HandleProfession(object, firstAid)
		
		for index = 1, #spells do
			if IsSpellKnown( spells[index] ) then
				local name, rank, texture = GetSpellInfo( spells[index] )
				UpdateTab(object, name, rank, texture)
			end
		end
	end
	
	UpdateSelectedTabs(object)
end

function handler:TRADE_SKILL_SHOW(event)
	local owner = ATSWFrame or MRTSkillFrame or SkilletFrame or TradeSkillFrame
	
	if IsAddOnLoaded("TradeSkillDW") and owner == TradeSkillFrame then
		self:UnregisterEvent(event)
	else
		HandleTabs(owner)
		self[event] = function() for object in next, tabs do UpdateSelectedTabs(object) end end
	end
end

function handler:TRADE_SKILL_CLOSE(event)
	for object in next, tabs do 
		if object:IsShown() then
			UpdateSelectedTabs(object)
		end
	end
end

function handler:TRADE_SHOW(event)
	local owner = TradeFrame
	
	HandleTabs(owner)
	self[event] = function() UpdateSelectedTabs(owner) end
end

function handler:PLAYER_REGEN_ENABLED(event)
	self:UnregisterEvent(event)
	
	for object in next, tabs do HandleTabs(object) end
end

function handler:SKILL_LINES_CHANGED()
	for object in next, tabs do HandleTabs(object) end
end

function handler:CURRENT_SPELL_CAST_CHANGED(event)
	local numShown = 0
	
	for object in next, tabs do 
		if object:IsShown() then
			numShown = numShown + 1
			UpdateSelectedTabs(object)
		end
	end
	
	if numShown == 0 then self:UnregisterEvent(event) end
end

end