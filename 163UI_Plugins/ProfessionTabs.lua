U1PLUG["ProfessionTabs"] = function()

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
	[356] = { true, false }, -- Fishing
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

local function UpdateTab(object, name, rank, texture, spellId)
	local index = tabs[object].index + 1
	local tab = tabs[object][index] or CreateFrame("CheckButton", nil, object, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate") 
	
	tab:ClearAllPoints()
    local anchor = object --abyui
    anchor = anchor == TradeSkillFrame and TradeSkillFrame.OptionalReagentList and TradeSkillFrame.OptionalReagentList:IsShown() and TradeSkillFrame.OptionalReagentList or anchor
    anchor = anchor == TradeFrame and RecentTradeFrame and RecentTradeFrame:IsShown() and RecentTradeFrame or anchor
	tab:SetPoint("TOPLEFT", anchor, "TOPRIGHT", anchor == ATSWFrame and -32 or 0, 16 + -44 * index)
	tab:SetNormalTexture(texture)
	tab:SetAttribute("type", "spell")
	tab:SetAttribute("spell", spellId and tostring(spellId) or name) --必须用字符串, SECURE_ACTIONS.spell
	tab:RegisterForClicks("AnyUp", "AnyDown")
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
					local name, _, spellId = GetSpellBookItemName(offset + index, "profession")
					local rank = GetProfessionRank(currentSkill)
					local texture = GetSpellBookItemTexture(offset + index, "profession")
					
					if name and rank and texture then
						UpdateTab(object, name, rank, texture, spellId)
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
	local owner = ATSWFrame or MRTSkillFrame or SkilletFrame or ProfessionsFrame
	
	if IsAddOnLoaded("TradeSkillDW") and owner == ProfessionsFrame then
		self:UnregisterEvent(event)
	else
		HandleTabs(owner)
		self[event] = function() HandleTabs(owner) for object in next, tabs do UpdateSelectedTabs(object) end end
		--abyui
        if ProfessionsFrame and ProfessionsFrame.DetailsFrame and ProfessionsFrame.OptionalReagentList then
            hooksecurefunc(ProfessionsFrame.DetailsFrame, "RefreshDisplay", function()
                self[event]()
            end)
        end
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

    if RunOnNextFrame then --abyui
        RunOnNextFrame(function()
            HandleTabs(owner)
            UpdateSelectedTabs(owner)
        end)
    else
        HandleTabs(owner)
	    self[event] = function() UpdateSelectedTabs(owner) end
    end
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