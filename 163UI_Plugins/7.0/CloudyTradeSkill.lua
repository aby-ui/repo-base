--[[------------------------------------------------------------
CloudyTradeSkill  https://wow.curseforge.com/addons/cloudy-trade-skill
- Resize default TradeSkill UI
- Add profession tabs to the TradeSkillFrame
- Fix search feature (now you can use shift+click to search items like before)
- Fix Legion recipe link error
---------------------------------------------------------------]]

--[[
	Cloudy TradeSkill
	Copyright (c) 2016, Cloudyfa
	All rights reserved.
]]


--- Initialization ---
local itemDisplay = 30
local numTabs = 0
local function InitDB()
	itemDisplay = U1DB.CloudyTradeSkillItemDisplay or itemDisplay
end


--- Create Frame ---
local f = CreateFrame('Frame', 'CloudyTradeSkill')
f:RegisterEvent('TRADE_SKILL_LIST_UPDATE')
f:RegisterEvent('PLAYER_LOGIN')


--- Local Functions ---
--[==[
	--- Check Current Tab ---
	local function isCurrentTab(self)
		if self.tooltip and IsCurrentSpell(self.tooltip) then
			self:SetChecked(true)
		else
			self:SetChecked(false)
		end
	end

	--- Add Tab Button ---
	local function addTab(id, index, isSub)
		local name, _, icon = GetSpellInfo(id)
		if (not name) or (not icon) then return end

		local tab = _G['CTradeSkillTab' .. index] or CreateFrame('CheckButton', 'CTradeSkillTab' .. index, TradeSkillFrame, 'SpellBookSkillLineTabTemplate,SecureActionButtonTemplate')
		tab:SetPoint('TOPLEFT', TradeSkillFrame, 'TOPRIGHT', 0, -44 * index + (-50 * isSub))

		tab:SetScript('OnEvent', isCurrentTab)
		tab:RegisterEvent('CURRENT_SPELL_CAST_CHANGED')

		tab.id = id
		tab.tooltip = name
		tab:SetAttribute('type', 'spell')
		tab:SetAttribute('spell', name)
		tab:SetNormalTexture(icon)
		tab:Show()

		isCurrentTab(tab)
	end

	--- Remove Tab Buttons ---
	local function removeTabs()
		for i = 1, numTabs do
			local tab = _G['CTradeSkillTab' .. i]
			if tab and tab:IsShown() then
				tab:UnregisterEvent('CURRENT_SPELL_CAST_CHANGED')
				tab:Hide()
			end
		end
	end

	--- Check Profession Useable ---
	local function isUseable(id)
		local name = GetSpellInfo(id)
		return IsUsableSpell(name)
	end

	--- Update Profession Tabs ---
	local function updateTabs()
		local mainTabs, subTabs = {}, {}

		local _, class = UnitClass('player')
		if class == 'DEATHKNIGHT' and isUseable(53428) then
			mainTabs[1] = 53428 --RuneForging
		elseif class == 'ROGUE' and isUseable(1804) then
			subTabs[1] = 1804 --PickLock
		end

		local prof1, prof2, arch, fishing, cooking, firstaid = GetProfessions()
		local profs = {prof1, prof2, cooking, firstaid}
		for _, prof in pairs(profs) do
			local num, offset, _, _, _, spec = select(5, GetProfessionInfo(prof))
			if (spec and spec ~= 0) then num = 1 end
			for i = 1, num do
				if not IsPassiveSpell(offset + i, BOOKTYPE_PROFESSION) then
					local _, id = GetSpellBookItemInfo(offset + i, BOOKTYPE_PROFESSION)
					if (i == 1) then
						mainTabs[#mainTabs + 1] = id
					else
						subTabs[#subTabs + 1] = id
					end
				end
			end
		end

		local sameTabs = true
		for i = 1, #mainTabs do
			local tab = _G['CTradeSkillTab' .. i]
			if tab and not (tab.id == mainTabs[i]) then
				sameTabs = false
				break
			end
		end

		if not sameTabs or not (numTabs == #mainTabs + #subTabs) then
			removeTabs()
			numTabs = #mainTabs + #subTabs
			for i = 1, numTabs do
				addTab(mainTabs[i] or subTabs[i - #mainTabs], i, mainTabs[i] and 0 or 1)
			end
		end
	end
--]==]

	--- Update Frame Size ---
	local function updateSize()
		TradeSkillFrame:SetHeight(itemDisplay * 16 + 96) --496
		TradeSkillFrame.RecipeInset:SetHeight(itemDisplay * 16 + 10) --410
		TradeSkillFrame.DetailsInset:SetHeight(itemDisplay * 16 - 10) --390
		TradeSkillFrame.DetailsFrame:SetHeight(itemDisplay * 16 - 15) --385
		TradeSkillFrame.DetailsFrame.Background:SetHeight(itemDisplay * 16 - 17) --383

		if TradeSkillFrame.RecipeList.FilterBar:IsVisible() then
			TradeSkillFrame.RecipeList:SetHeight(itemDisplay * 16 - 11) --389
		else
			TradeSkillFrame.RecipeList:SetHeight(itemDisplay * 16 + 5) --405
		end
	end

	--- Mouse Click Events ---
	local offsetX, offsetY
	local function resizeBar_OnMouseDown(self, button)
		if (button == 'LeftButton') and not InCombatLockdown() then
			offsetX = TradeSkillFrame:GetLeft()
			offsetY = TradeSkillFrame:GetTop()

			TradeSkillFrame:SetResizable(true)
			TradeSkillFrame:SetMinResize(670, offsetY/2 + 100)
			TradeSkillFrame:SetMaxResize(670, offsetY - 50)
			TradeSkillFrame:StartSizing('BOTTOM')
		end
	end
	local function resizeBar_OnMouseUp(self, button)
		if (button == 'LeftButton') and not InCombatLockdown() then
			TradeSkillFrame:StopMovingOrSizing()
			TradeSkillFrame:SetResizable(false)
			TradeSkillFrame:ClearAllPoints()
			TradeSkillFrame:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', offsetX, offsetY)

			local item = (TradeSkillFrame:GetHeight() - 96) / 16
			itemDisplay = floor(item, 0.5)
            U1DB.CloudyTradeSkillItemDisplay = itemDisplay
			updateSize()
		end
	end

	--- Change Mouse Cursor ---
	local function resizeBar_OnEnter()
		if not InCombatLockdown() then
			SetCursor('CAST_CURSOR')
		end
	end
	local function resizeBar_OnLeave()
		if not InCombatLockdown() then
			ResetCursor()
		end
    end

CoreDependCall("Blizzard_TradeSkillUI", function()
--- Refresh Recipe List ---
    hooksecurefunc('HybridScrollFrame_Update', function(self, ...)
        if (self == TradeSkillFrame.RecipeList) then
            if self.FilterBar:IsVisible() then
                self:SetHeight(itemDisplay * 16 - 11) --389
            else
                self:SetHeight(itemDisplay * 16 + 5) --405
            end
        end
    end)

    --- Create Resize Bar ---
    local resizeBar = CreateFrame('Button', nil, TradeSkillFrame)
    TradeSkillFrame._resizeBar = resizeBar
    resizeBar:SetPoint("BOTTOMLEFT", TradeSkillFrame)
    resizeBar:SetPoint("BOTTOMRIGHT", TradeSkillFrame)
    resizeBar:SetHeight(16)
    --resizeBar:SetAllPoints(TradeSkillFrameBottomBorder) --broken in 8.1
    resizeBar:SetScript('OnMouseDown', resizeBar_OnMouseDown)
    resizeBar:SetScript('OnMouseUp', resizeBar_OnMouseUp)
    resizeBar:SetScript('OnEnter', resizeBar_OnEnter)
    resizeBar:SetScript('OnLeave', resizeBar_OnLeave)

    if TradeSkillFrame then updateSize() end

    --- Fix SearchBox ---
    hooksecurefunc('ChatEdit_InsertLink', function(link)
        if link and TradeSkillFrame and TradeSkillFrame:IsShown() then
            local text = strmatch(link, '|h%[(.+)%]|h|r')
            if text then
                text = strmatch(text, ':%s(.+)') or text
                TradeSkillFrame.SearchBox:SetText(text:lower())
            end
        end
    end)
    TradeSkillFrame.SearchBox:SetWidth(205)


    --- Fix RecipeLink ---
    local getRecipe = C_TradeSkillUI.GetRecipeLink
    C_TradeSkillUI.GetRecipeLink = function(link)
        if link and (link ~= '') then
            return getRecipe(link)
        end
    end
end)

--- Handle Events ---
f:SetScript('OnEvent', function(self, event, ...)
	if (event == 'PLAYER_LOGIN') then
		InitDB()
		if TradeSkillFrame then updateSize() end
	elseif (event == 'TRADE_SKILL_LIST_UPDATE') then
		if TradeSkillFrame and TradeSkillFrame.RecipeList then
			if TradeSkillFrame.RecipeList.buttons and #TradeSkillFrame.RecipeList.buttons < (itemDisplay + 2) then
				HybridScrollFrame_CreateButtons(TradeSkillFrame.RecipeList, 'TradeSkillRowButtonTemplate', 0, 0)
			end
			--if not InCombatLockdown() then
			--	updateTabs()
			--end
		end
	end
end)

