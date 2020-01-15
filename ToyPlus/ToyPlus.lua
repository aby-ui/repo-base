local L = select(2, ...).L 

ToyPlus = LibStub("AceAddon-3.0"):NewAddon("ToyPlus", "AceConsole-3.0", "AceEvent-3.0")
local icon = LibStub("LibDBIcon-1.0")
local LibQTip = LibStub('LibQTip-1.0')
local ToyPlusToyDB = {}
ToyPlusToyDB.toyName, ToyPlusToyDB.toyIcon, ToyPlusToyDB.itemID = {}, {}, {}
ToyPlusToyDB.lastTime = time()

local ToyPlusLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("ToyPlusLDB", {
	type = "data source",
	text = "玩具",
	icon = "Interface\\Icons\\INV_Misc_Toy_09",
	OnClick = function(self, button)
		if button == "LeftButton" then
			ToyPlus:Launch()
		elseif button == "RightButton" then
            if InterfaceOptionsFrame:IsVisible() then
                InterfaceOptionsFrame:Hide()
			else
                InterfaceOptionsFrame_OpenToCategory(L"ToyPlus")
            end
		end
	end,
	OnEnter = function(self) ToyPlus:Broker(self) end,
})

function ToyPlus:OnInitialize()
	local defaults = {
		profile = {
			minimap = {
				hide = false,
			},
			rows = 2,
			columns = 5,
			scale = 26,
			hidemenu = false
		},
	}
	self.db = LibStub("AceDB-3.0"):New("ToyPlusDB", defaults)
	icon:Register("ToyPlus", ToyPlusLDB, self.db.profile.minimap)
	ToyPlus:RegisterChatCommand("toyplus", "Launch")
	ToyPlus:RegisterOptions()
	self.db.global.toyName = self.db.global.toyName or {}
	self.db.global.toyIcon = self.db.global.toyIcon or {}
	self.db.global.itemID = self.db.global.itemID or {}
	local toyAvail
	local locToys = {131900,115506,127669,86582,89614,88375,119178,131811,134024,109167,116113,118935,119093,127655,127669,
	139773,116120,86578,86583,86590,86594,102467,104329,113540,128223,134023,43824}--Toys that require locations
	if UnitFactionGroup("player") == "Alliance" then tinsert(locToys, 95567) else tinsert(locToys, 95568); tinsert(locToys, 115503) end
	for i = 1, #self.db.global.itemID do
		toyAvail = false
		if C_ToyBox.IsToyUsable(self.db.global.itemID[i]) then toyAvail = true end
		for x = 1, #locToys do
			if locToys[x] == self.db.global.itemID[i] then toyAvail = true end
		end
		if toyAvail == true then
			tinsert(ToyPlusToyDB.toyName, self.db.global.toyName[i])
			tinsert(ToyPlusToyDB.toyIcon, self.db.global.toyIcon[i])
			tinsert(ToyPlusToyDB.itemID, self.db.global.itemID[i])
		end
	end
	if self.db.profile.shown then ToyPlus:CreateFrame() end
	ToyPlus:RefreshToys()
end

function ToyPlus:RegisterOptions()-- Blizzard Options
	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable(L"ToyPlus", {
		type = 'group',
		args = {
			toyCols = {
				type = 'range',
				order = 1,
				name = L"Columns",
				get = function(info)
					return ToyPlus.db.profile.columns
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.columns = key
					ToyPlus:ToggleRows() end
				end,
				min = 2, max = 10, step = 1,
			},
			toyRows = {
				type = 'range',
				order = 2,
				name = L"Rows",
				get = function(info)
					return ToyPlus.db.profile.rows
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.rows = key
					ToyPlus:ToggleRows() end
				end,
				min = 1, max = 10, step = 1,
			},
			toyScale = {
				type = 'range',
				order = 3,
				name = L"Scale",
				get = function(info)
					return ToyPlus.db.profile.scale
				end,
				set = function(info, key)
					if not InCombatLockdown() then ToyPlus.db.profile.scale = key
					ToyPlus:ToggleRows() end
				end,
				min = 16, max = 48, step = 1,
			},
			togglebutton = {
				type = 'toggle',
				order = 4,
				name = L"Show Minimap Icon",
				get = function()
					return not ToyPlus.db.profile.minimap.hide
				end,
				set = ToyPlus.ToggleLDBIcon,
			},
			themebutton = {
				type = 'toggle',
				order = 5,
				name = L"Blue Theme",
				get = function()
					return ToyPlus.db.profile.theme
				end,
				set = ToyPlus.ThemeSwap,
			},
			hidemenubutton = {
				type = 'toggle',
				order = 6,
				name = "Hide Top Buttons",
				get = function()
					return ToyPlus.db.profile.hidemenu
				end,
				set = function()
					if not InCombatLockdown() then ToyPlus:HideMenu() end
				end,
			},
		},
	})
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(L"ToyPlus")
end

function ToyPlus:HideMenu()
	ToyPlus.db.profile.hidemenu = not ToyPlus.db.profile.hidemenu
	local toyFrame = _G["ToyPlusFrame"]
	if not toyFrame then return end
	local btnClose = _G["ToyPlusFrame_Close"]
	if ToyPlus.db.profile.hidemenu then
		btnClose:Hide()
		ToyPlus:ToggleRows()
	else
		btnClose:Show()
		toyFrame:SetHeight(toyFrame:GetHeight()+18)
		ToyPlus:ToggleRows()
	end
end

function ToyPlus:ThemeSwap()
	ToyPlus.db.profile.theme = not ToyPlus.db.profile.theme
	local toyFrame = _G["ToyPlusFrame"]
	local toyPopout = _G["ToyPlus_Popout"]
	if toyFrame then
		if ToyPlus.db.profile.theme then toyFrame.texture:SetColorTexture(0, 0.1, 0.3, 0.7); toyFrame:SetBackdropBorderColor(0,0.564,1,1)
		else toyFrame.texture:SetColorTexture(0,0,0,0.5); toyFrame:SetBackdropBorderColor(0.5,0.5,0.5,1) end
	end
	if toyPopout then
		if ToyPlus.db.profile.theme then toyPopout.texture:SetColorTexture(0,0.1,0.3,0.7); toyPopout:SetBackdropBorderColor(0,0.564,1,1)
		else toyPopout.texture:SetColorTexture(0,0,0,0.5); toyPopout:SetBackdropBorderColor(0.5,0.5,0.5,1) end
	end
	for i = 1, 100 do -- Toy Buttons
		local toyIcon = _G["ToyPlus_Icon"..i]
		if toyIcon then
			local border = _G["ToyPlus_Icon"..i.."NormalTexture"]
			if ToyPlus.db.profile.theme then border:SetVertexColor(0,0.6,1,1)
			else border:SetVertexColor(0.6,0.6,0.6,1) end
		end
	end
end

function ToyPlus:ToggleLDBIcon()-- Toggle Minimap Icon
	ToyPlus.db.profile.minimap.hide = not ToyPlus.db.profile.minimap.hide
	if ToyPlus.db.profile.minimap.hide then icon:Hide("ToyPlus")
	else icon:Show("ToyPlus") end
end

function ToyPlus:GetCooldown(start, duration)
	local timeRem = SecondsToTime(duration-(GetTime()-start), true)
	if (duration-(GetTime()-start)) < 60 then timeRem = SecondsToTime(duration-(GetTime()-start)) end
	return timeRem
end

function ToyPlus:Broker(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
	if InCombatLockdown() then return end

	for i = 1, #ToyPlusToyDB.toyName do
		local toyBtn = _G["ToyPlus_brokerBtn"..i]
		if toyBtn then toyBtn:Hide() end
	end
	local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
	self.tooltip = tooltip
	tooltip:AddHeader(L'ToyPlus')
	tooltip:SetLineTextColor(1,0,0.7,1)
	tooltip:AddSeparator(1,0,0.5,1)
	tooltip:AddLine(L'Left-click menu icon to toggle toy buttons.')
	tooltip:AddLine(L'Right-click menu icon for configuration.')
	tooltip:AddSeparator(1,0,0.5,1)
	if not ToyPlusToyDB.itemID[1] or not C_ToyBox.GetIsFavorite(ToyPlusToyDB.itemID[1]) then
		tooltip:AddLine(L'No favourites found. Add some via the toy list.')
	else
		for i = 1, 40 do
			local toyName, itemID, toyIcon = ToyPlusToyDB.toyName[i], ToyPlusToyDB.itemID[i], ToyPlusToyDB.toyIcon[i]
			if toyName and itemID and toyIcon then
				if C_ToyBox.GetIsFavorite(itemID) then
					local start, duration = GetItemCooldown(itemID)
					local tRow = tooltip:GetLineCount()+1
					if start == 0 then 
						tooltip:AddLine("|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName)
						tooltip:SetLineTextColor(tRow,0,0.7,1)
					else
						local timeRem = ToyPlus:GetCooldown(start, duration)
						tooltip:AddLine("|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName.." ("..timeRem..")")  
						tooltip:SetLineTextColor(tRow,1,0,0)
					end
					tooltip:SetLineScript(tRow, "OnEnter", function(tt)
						local toyBtn = _G["ToyPlus_brokerBtn"..i]
						if not toyBtn then toyBtn = CreateFrame("Button", "ToyPlus_brokerBtn"..i, UIParent, "SecureActionButtonTemplate") end
						toyBtn:SetAttribute("type", "item")
						toyBtn:SetAttribute("item", toyName)
						toyBtn:SetFrameStrata(tt:GetFrameStrata())
						toyBtn:SetFrameLevel(tt:GetFrameLevel()+1)
						toyBtn:SetAllPoints(tt)
						toyBtn:Show()
						toyBtn:SetScript("OnEnter", function()
							local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
							if tooltip:IsShown() then
								local start, duration = GetItemCooldown(itemID)
								local timeRem = ToyPlus:GetCooldown(start, duration)
								if start == 0 or timeRem == "" then 
									tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName)
									tooltip:SetLineTextColor(tRow,1,1,0); toyBtn:RegisterForClicks("LeftButtonUp")
								else 
									tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName.." ("..timeRem..")")
									tooltip:SetLineTextColor(tRow,1,0,0); toyBtn:RegisterForClicks()
								end
							end
						end)
						toyBtn:SetScript("OnLeave", function()
							local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
							if tooltip:IsShown() then
								local start, duration = GetItemCooldown(itemID)
								local timeRem = ToyPlus:GetCooldown(start, duration)
								if start == 0 or timeRem == "" then 
									tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName)
									tooltip:SetLineTextColor(tRow,0,0.7,1); toyBtn:RegisterForClicks("LeftButtonUp")
								else 
									tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName.." ("..timeRem..")")
									tooltip:SetLineTextColor(tRow,1,0,0); toyBtn:RegisterForClicks()
								end
							end
						end)
						toyBtn:RegisterUnitEvent("ACTIONBAR_UPDATE_COOLDOWN")
						toyBtn:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE")
						toyBtn:RegisterUnitEvent("PLAYER_REGEN_DISABLED")
						toyBtn:SetScript("OnEvent", function(self, event)
							local tooltip = LibQTip:Acquire("ToyPlus_Tooltip", 1, "LEFT")
							if event == "ACTIONBAR_UPDATE_COOLDOWN" or "LOSS_OF_CONTROL_UPDATE" then
								if tooltip and tooltip:IsShown() and tRow <= tooltip:GetLineCount() then
									x = tRow - 5
									local toyName, itemID, toyIcon = ToyPlusToyDB.toyName[x], ToyPlusToyDB.itemID[x], ToyPlusToyDB.toyIcon[x]
									if itemID then 
										local start, duration = GetItemCooldown(itemID)
										local timeRem = ToyPlus:GetCooldown(start, duration)
										if start == 0 or timeRem == "" then
											tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName)
											tooltip:SetLineTextColor(tRow,0,0.7,1); toyBtn:RegisterForClicks("LeftButtonUp")
										else 
											tooltip:SetCell(tRow, 1, "|T"..toyIcon..":20:20:0:0:64:64:5:59:5:59|t "..toyName.." ("..timeRem..")")
											tooltip:SetLineTextColor(tRow,1,0,0); toyBtn:RegisterForClicks()
										end
									end
								end
							end
							if event == "PLAYER_REGEN_DISABLED" then 
								if tooltip and tooltip:IsShown() then
									tooltip:Hide()
									LibQTip:Release(tooltip)
									tooltip = nil
									for i = 1, #ToyPlusToyDB.toyName do
										local toyBtn = _G["ToyPlus_brokerBtn"..i]
										if toyBtn then toyBtn:Hide() end
									end
								end
							end
						end)
					end, tt)
				end
			end
		end
	end
	tooltip:SetAutoHideDelay(0.5, self)
	tooltip.OnRelease = function()
		LibQTip:Release(tooltip)
		tooltip = nil
		for i = 1, #ToyPlusToyDB.toyName do
			local toyBtn = _G["ToyPlus_brokerBtn"..i]
			if toyBtn then toyBtn:Hide() end
		end
	end
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function ToyPlus:ToysUpdated()
	if ToyPlusToyDB.lastTime == time() then return end
	ToyPlusToyDB.lastTime = time()
	if InCombatLockdown() then return end
    if(ToyBox and ToyBox:IsVisible()) then return end --163ui fix
	local toyFrame = _G["ToyPlusFrame"]
	local toyPopout = _G["ToyPlus_Popout"]
	self:RefreshToys()
	if toyFrame then ToyPlus:RefreshIcons(); ToyPlus:ToggleRows() end
	if toyPopout then ToyPlus:RefreshList(0, false, _G["ToyPlus_Popout_SearchBox"]:GetText()) end
	LibQTip:Release(ToyPlus.tooltip)
	ToyPlus.tooltip = nil
	for i = 1, #ToyPlusToyDB.toyName do
		local toyBtn = _G["ToyPlus_brokerBtn"..i]
		if toyBtn then toyBtn:Hide() end
	end
end
ToyPlus:RegisterEvent("TOYS_UPDATED", "ToysUpdated")
ToyPlus:RegisterEvent("PLAYER_LOGIN", "ToysUpdated")

function ToyPlus:StorePosition()
	local toyFrame = _G["ToyPlusFrame"]
	if toyFrame then ToyPlus.db.profile.anchorPoint, _, ToyPlus.db.profile.relativePoint, ToyPlus.db.profile.anchorX, ToyPlus.db.profile.anchorY = toyFrame:GetPoint() end
end
ToyPlus:RegisterEvent("PLAYER_LOGOUT", "StorePosition")

function ToyPlus:ToggleRows()
	local fra = _G["ToyPlusFrame"]
	if fra then
		ToyPlus:RefreshIcons()
		local toyRows, toyCols, toyScale = ToyPlus.db.profile.rows, ToyPlus.db.profile.columns, ToyPlus.db.profile.scale
		local toyTotal = toyRows*toyCols
		local prevToy
		for i = 1, toyTotal do --Set Icon Position
			local toyIcon = _G["ToyPlus_Icon"..i]
			if toyIcon then
				if i == 1 then
					if ToyPlus.db.profile.hidemenu then toyIcon:SetPoint("TOPLEFT",fra,"TOPLEFT",7,-8) else toyIcon:SetPoint("TOPLEFT",fra,"TOPLEFT",7,-27) end
					prevToy = toyIcon
				elseif i == (toyCols+1) or i == ((toyCols*2)+1) or i == ((toyCols*3)+1) or i == ((toyCols*4)+1) or i == ((toyCols*5)+1)	 
				or i == ((toyCols*6)+1) or i == ((toyCols*7)+1) or i == ((toyCols*8)+1) or i == ((toyCols*9)+1) then 
					toyIcon:SetPoint("TOPLEFT",prevToy,"BOTTOMLEFT",0,-7)
					prevToy = toyIcon
				else
					toyIcon:SetPoint("TOPLEFT",_G["ToyPlus_Icon"..(i-1)],"TOPRIGHT",7,0) 
				end
				toyIcon:SetSize(toyScale,toyScale)
			end
		end
		for i = 1, 100 do --Show/Hide Icons
			local toyIcon = _G["ToyPlus_Icon"..i]
			if i <= toyTotal then
				if toyIcon then
					if ToyPlusToyDB.itemID[i] then toyIcon:Show() else toyIcon:Hide() end
				end
			else
				if toyIcon then toyIcon:Hide() end
			end
		end

		local fraH = 27+(toyRows*(toyScale+7))--Adjust for scale
		fraH=floor(fraH)
		if fraH%2 ~= 0 then fraH=fraH-1 end
		fra:SetHeight(fraH)
		local fraW = 8+(toyCols*(toyScale+7))
		fraW=floor(fraW)
		if fraW%2 ~= 0 then fraW=fraW+1 end
		fra:SetWidth(fraW)

		local btnAddRow = _G["ToyPlusFrame_AddRow"]
		local btnLessRow = _G["ToyPlusFrame_LessRow"]
		local btnClose = _G["ToyPlusFrame_Close"]
		local btnPopout = _G["ToyPlusFrame_Popout"]
		local btnLabel = _G["ToyPlusFrame_Label"]

		local toyRows = ToyPlus.db.profile.rows

		if toyCols == 2 then btnAddRow:Hide(); btnLessRow:Hide(); btnLabel:Hide()
		elseif toyCols == 3 or toyCols == 4 then btnAddRow:Show(); btnLessRow:Show(); btnLabel:Hide()
		else btnAddRow:Show(); btnLessRow:Show(); btnLabel:Show() end

		if toyRows == 1 then btnLessRow:Hide() end
		if toyRows == 10 then btnAddRow:Hide() end

		if ToyPlus.db.profile.hidemenu then 
			btnClose:Hide(); btnPopout:Hide(); btnAddRow:Hide(); btnLessRow:Hide(); btnLabel:Hide()
			local x = _G["ToyPlusFrame"]:GetHeight()
			_G["ToyPlusFrame"]:SetHeight(x-18)
		else
			btnClose:Show(); btnPopout:Show()
		end
	end
end

function ToyPlus:RefreshToys() -- Add Toys to DB
	local saveSearch = "" --Save filter then wipe it
	if ToyBox then saveSearch = ToyBox.searchBox:GetText(); ToyBox.searchBox:SetText("") end
	C_ToyBox.SetCollectedShown(true)
	C_ToyBox.SetAllSourceTypeFilters(true)
	C_ToyBox.SetFilterString("")

	local toyTotal = C_ToyBox.GetNumTotalDisplayedToys()
	local toyTotalLearned = C_ToyBox.GetNumLearnedDisplayedToys()
	local toyNum = 1
	if toyTotalLearned > 0 then
		wipe(ToyPlus.db.global.toyName); wipe(ToyPlus.db.global.itemID); wipe(ToyPlus.db.global.toyIcon)
		for i = 1, toyTotal do
			local itemNo = C_ToyBox.GetToyFromIndex(i)
			if itemNo ~= -1 then
				local itemID, toyName, toyIcon, toyFave = C_ToyBox.GetToyInfo(itemNo)
				if itemID and PlayerHasToy(itemID) then
					ToyPlus.db.global.toyName[toyNum] = toyName
					ToyPlus.db.global.itemID[toyNum] = itemID
					ToyPlus.db.global.toyIcon[toyNum] = toyIcon
					toyNum=toyNum+1
				end
			end
		end
	end
	--Add toys to session db
	wipe(ToyPlusToyDB.toyName); wipe(ToyPlusToyDB.toyIcon); wipe(ToyPlusToyDB.itemID)
	local toyAvail
	local locToys = {131900,115506,127669,86582,89614,88375,119178,131811,134024,109167,116113,118935,119093,127655,127669,
	139773,116120,86578,86583,86590,86594,102467,104329,113540,128223,134023,43824}--Toys that require locations
	if UnitFactionGroup("player") == "Alliance" then tinsert(locToys, 95567) else tinsert(locToys, 95568); tinsert(locToys, 115503) end
	for i = 1, #self.db.global.itemID do
		toyAvail = false
		if C_ToyBox.IsToyUsable(self.db.global.itemID[i]) then toyAvail = true end
		for x = 1, #locToys do
			if locToys[x] == self.db.global.itemID[i] then toyAvail = true end
		end
		if toyAvail == true then
			tinsert(ToyPlusToyDB.toyName, self.db.global.toyName[i])
			tinsert(ToyPlusToyDB.toyIcon, self.db.global.toyIcon[i])
			tinsert(ToyPlusToyDB.itemID, self.db.global.itemID[i])
		end
	end
	if ToyBox then ToyBox.searchBox:SetText(saveSearch); C_ToyBox.SetFilterString(saveSearch) end
end

function ToyPlus:Launch()
	if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
	if C_ToyBox.GetToyFromIndex(1) ~= -1 then
		ToyPlus:RefreshToys()
		local toyFrame = _G["ToyPlusFrame"]
		local toyPopout = _G["ToyPlus_Popout"]
		if not toyFrame then
			ToyPlus:CreateFrame()
			ToyPlus.db.profile.shown = true
		else
			if toyFrame:IsVisible() then
				local btnPopout = _G["ToyPlusFrame_Popout"]
				toyFrame:Hide()
				ToyPlus.db.profile.shown = false
				btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
				if toyPopout then toyPopout:Hide() end
			else
				toyFrame:Show() 
				ToyPlus.db.profile.shown = true
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffToy Box hasn't been loaded or no toys found.", 0, 0.7, 1)
	end
end

function ToyPlus:ShowList()
	local toyPopout = _G["ToyPlus_Popout"]
	local toyFrame = _G["ToyPlusFrame"]
	ToyPlus:RefreshToys()
	if not toyPopout then
		toyPopout = CreateFrame("Frame", "ToyPlus_Popout", UIParent)
		toyPopout:SetFrameStrata("HIGH")
		toyPopout:EnableMouse(true)
		toyPopout:RegisterForDrag("LeftButton")
		toyPopout:SetPoint("BOTTOMLEFT", toyFrame, "BOTTOMRIGHT",-1,0)
		toyPopout:SetSize(286,229)
		toyPopout.texture = toyPopout:CreateTexture()
		toyPopout.texture:SetPoint("TOPLEFT", toyPopout, 2, -2)
		toyPopout.texture:SetPoint("BOTTOMRIGHT", toyPopout, -2, 2)
		local backdrop = { -- Border
		  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		  tile = false, tileSize = 8, edgeSize = 8,
		  insets = { left = 2, right = 2, top = 2, bottom = 2 } }
		toyPopout:SetBackdrop(backdrop)
		if ToyPlus.db.profile.theme then toyPopout.texture:SetColorTexture(0,0.1,0.3,0.7); toyPopout:SetBackdropBorderColor(0,0.564,1,1)
		else toyPopout.texture:SetColorTexture(0,0,0,0.5); toyPopout:SetBackdropBorderColor(0.5,0.5,0.5,1) end
		toyPopout:Show()
		toyPopout:RegisterUnitEvent("PLAYER_REGEN_DISABLED")
		toyPopout:SetScript("OnEvent", function(self, event)
			if toyPopout:IsVisible() then
				toyPopout:Hide()
				btnPopout = _G["ToyPlusFrame_Popout"]
				btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			end
		end)
		local label = toyPopout:CreateFontString("$parent_SearchLabel", "DIALOG","GameFontNormal")
		label:SetPoint("TOPLEFT",toyPopout,"TOPLEFT",8,-8)
		label:SetText(L"Search:")
		local searchBox = CreateFrame("EditBox", "$parent_SearchBox", toyPopout, "SearchBoxTemplate")
		searchBox:EnableMouse(true)
		searchBox:SetAutoFocus(false)
		searchBox:SetFontObject("ChatFontSmall")
		searchBox:SetMaxLetters(20)
		searchBox:SetSize(198, 12)
		searchBox:SetPoint("TOPLEFT", toyPopout, "TOPLEFT", 65, -8)
		searchBox:Show()
		searchBox:SetScript("OnTextChanged", function(self, event)
			if not InCombatLockdown() then
				SearchBoxTemplate_OnTextChanged(self);
				ToyPlus:RefreshList(0, _, searchBox:GetText())
			end
		end)
		local scrFra = CreateFrame("ScrollFrame", "ToyPlus_ScrollFrame", toyPopout)
		scrFra:SetPoint("TOPLEFT", 2, -27)--edited
		scrFra:SetPoint("BOTTOMRIGHT", -2, 2)
		toyPopout.scrollframe = scrFra
		local scrBar = CreateFrame("Slider", "ToyPlus_Slider", scrFra, "UIPanelScrollBarTemplate")
		scrBar:SetPoint("TOPLEFT", toyPopout, "TOPRIGHT", -19, -19)
		scrBar:SetPoint("BOTTOMLEFT", toyPopout, "BOTTOMRIGHT", 19, 19)
		scrBar:SetMinMaxValues(1, 100)
		scrBar:SetValueStep(1)
		scrBar.scrollStep = 100
		scrBar:SetValue(0)
		scrBar:SetWidth(16)
		scrBar:SetOrientation('VERTICAL')
		scrBar:SetScript("OnValueChanged", function (self, value) scrFra:SetVerticalScroll(value) end)
		toyPopout.scrollbar = scrBar
		scrFra:EnableMouseWheel(true)
		scrFra:SetScript("OnMouseWheel",
			function(self, delta) 
				local x = scrBar:GetValue(); local y = scrBar:GetValueStep()
				if delta == 1 then scrBar:SetValue(x-y)
				else scrBar:SetValue(x+y) end
		end)
		local scrContent = CreateFrame("Frame", "ToyPlus_Content", scrFra)
		scrContent:SetSize(50,50)
		scrFra.content = scrContent 
		scrFra:SetScrollChild(scrContent)
		--Checkboxes
		local x, y = 1, 1
		for i = 1, #ToyPlusToyDB.toyName do
			local itemNo = ToyPlusToyDB.itemID[i]
			local itemID, toyName, toyIconStr, toyFave = C_ToyBox.GetToyInfo(itemNo)
			local chkbox = CreateFrame("CheckButton", "ToyPlus_Check"..i, scrContent, "UICheckButtonTemplate")
			local chktxt =  _G[chkbox:GetName().."Text"]
			chkbox:SetSize(25, 25)
			chktxt:SetJustifyH("Left")
			if C_ToyBox.GetIsFavorite(itemID) then chkbox:SetChecked(true) else chkbox:SetChecked(false) end
			chktxt:SetText("|T"..toyIconStr..":22:22:0:0:64:64:5:59:5:59|t "..toyName)
			chkbox:SetPoint("TOPLEFT",scrContent,"TOPLEFT",1, y)
			chkbox:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then
					if InCombatLockdown() then 
						DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1)
						if chkbox:GetChecked(true) then chkbox:SetChecked(false) else chkbox:SetChecked(true) end
						return
					end
					if chkbox:GetChecked(true) then ToyPlus:RefreshList(itemID, true, _G["ToyPlus_Popout_SearchBox"]:GetText())
					else ToyPlus:RefreshList(itemID, false, _G["ToyPlus_Popout_SearchBox"]:GetText()) end
				end
			end)
			chkbox:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetToyByItemID(itemID)
			end)
			chkbox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			y=y-18
		end
		if #ToyPlusToyDB.toyName > 11 then
			x = (#ToyPlusToyDB.toyName*18)-196
			scrBar:SetMinMaxValues(1, x)
			scrBar:SetValueStep(x/50)
			scrBar.scrollStep = (x/50)
		else scrBar:Hide() end
	else
		if toyPopout:IsVisible() then toyPopout:Hide() else toyPopout:Show() end
	end
end

function ToyPlus:RefreshList(itemID, toyFave, toySearch)
	if itemID ~= 0 then C_ToyBox.SetIsFavorite(itemID, toyFave) end
	ToyPlus:RefreshToys()
	local chkID = 1
	local toyNum = 0
	for i = 1, #ToyPlusToyDB.toyName do
		local itemNo = ToyPlusToyDB.itemID[i]
		local itemID, toyName, toyIconStr, toyFave = C_ToyBox.GetToyInfo(itemNo)
		if toyName and not toySearch or toySearch == "" or string.find(string.lower(toyName), string.lower(toySearch)) then
			toyNum = toyNum+1
			local chkbox = _G["ToyPlus_Check"..toyNum]
			if not chkbox then-- Create Checkbox
				local scrContent = _G["ToyPlus_Content"]
				if not scrContent then break end
				chkbox = CreateFrame("CheckButton", "ToyPlus_Check"..toyNum, scrContent, "UICheckButtonTemplate")
				chkbox:SetSize(25, 25)
				local chktxt =  _G[chkbox:GetName().."Text"]
				chktxt:SetJustifyH("Left")
				local y = 19
				y=y-(18*toyNum)
				chkbox:SetPoint("TOPLEFT",scrContent,"TOPLEFT",1, y)
			end
			local chktxt =  _G[chkbox:GetName().."Text"]				
			chktxt:SetText("|T"..toyIconStr..":22:22:0:0:64:64:5:59:5:59|t "..toyName)
			if itemID then 
				if C_ToyBox.GetIsFavorite(itemID) then chkbox:SetChecked(true) else chkbox:SetChecked(false) end 
			end
			chkbox:SetScript("OnClick", function(self, button)
				if button == "LeftButton" then
					if InCombatLockdown() then 
						DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1)
						if chkbox:GetChecked(true) then chkbox:SetChecked(false) else chkbox:SetChecked(true) end
						return 
					end
					if chkbox:GetChecked(true) then ToyPlus:RefreshList(itemID, true, _G["ToyPlus_Popout_SearchBox"]:GetText())
					else ToyPlus:RefreshList(itemID, false, _G["ToyPlus_Popout_SearchBox"]:GetText()) end
				end
			end)
			chkbox:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetToyByItemID(itemID)
			end)
			chkbox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			chkbox:Show()
		end
	end
	local scrBar = _G["ToyPlus_Slider"]
	if scrBar then
		scrBar:SetValue(0)
		if toyNum > 11 then
			x = (toyNum*18)-196
			scrBar:SetMinMaxValues(1,x)
			scrBar:SetValueStep(40)
			scrBar.scrollStep = 40
			scrBar:Show(); scrBar:Enable()
		else
			scrBar:SetMinMaxValues(1,1)
			scrBar:SetValueStep(1)
			scrBar.scrollStep = 1
			scrBar:Hide(); scrBar:Disable()
		end
	end
	for i = 1, #ToyPlusToyDB.toyName do
		if i > toyNum then
			local chkbox = _G["ToyPlus_Check"..i]
			if chkbox then chkbox:Hide() end
		end
	end
end

function ToyPlus:RefreshIcons()
	local toyRows = ToyPlus.db.profile.rows
	local toyCols = ToyPlus.db.profile.columns
	local toyTotal = toyRows*toyCols
	for i = 1, toyTotal do
		if ToyPlusToyDB.itemID[i] then
			local itemID, toyName, toyIconStr = ToyPlusToyDB.itemID[i], ToyPlusToyDB.toyName[i], ToyPlusToyDB.toyIcon[i]
			local toyFrame = _G["ToyPlusFrame"]
			local toyIcon = _G["ToyPlus_Icon"..i]
			if not toyIcon then
				toyIcon = CreateFrame("Button", "ToyPlus_Icon"..i, toyFrame, "SecureActionButtonTemplate,ActionButtonTemplate")
				toyIcon:RegisterUnitEvent("ACTIONBAR_UPDATE_COOLDOWN"); toyIcon:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE")
				toyIcon:SetAttribute("type", "item")
				toyIcon:SetAttribute("item", toyName)
				toyIcon:RegisterForDrag("LeftButton")
				toyIcon:SetSize(30,30)
				toyIcon:SetPoint("TOPLEFT","ToyPlusFrame","TOPLEFT",6,-27)
				toyIcon.icon:SetTexture(toyIconStr)
				toyIcon.icon:SetTexCoord(0.1,0.9,0.1,0.9)
				local border = _G["ToyPlus_Icon"..i.."NormalTexture"]
				border:SetVertexColor(0,0.6,1,1)
				local toyCD = CreateFrame("Cooldown", "$parent_CD", toyIcon, "CooldownFrameTemplate")
				toyCD:SetAllPoints(toyIcon)
			end
			local toyCD = _G["ToyPlus_Icon"..i.."_CD"]
			local start, duration = GetItemCooldown(itemID)
			if start == 0 then toyCD:SetCooldown(0,0) else toyCD:SetCooldown(start, duration) end
			toyIcon:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetToyByItemID(itemID)
			end)
			toyIcon:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			toyIcon:SetScript("OnDragStart", function(self)
				C_ToyBox.PickupToyBoxItem(itemID)
			end)
			toyIcon:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					if ToyPlusToyDB.itemID[i] then
						local isFavorite = C_ToyBox.GetIsFavorite(ToyPlusToyDB.itemID[i])
						if isFavorite then
							local menu = {
							    { text = L"Remove Favorite", func = function()
							        if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
								if _G["ToyPlus_Popout"] then C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], false); ToyPlus:RefreshList(0, false, _G["ToyPlus_Popout_SearchBox"]:GetText())
								else C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], false); ToyPlus:RefreshList(0, false) end
							     end },
							}
							local menuFrame = CreateFrame("Frame", "ToyPlus_FaveMenu", UIParent, "UIDropDownMenuTemplate")
							EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
						else
							local menu = {
							    { text = L"Add Favorite", func = function()
								if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
								if _G["ToyPlus_Popout"] then C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], true); ToyPlus:RefreshList(0, false, _G["ToyPlus_Popout_SearchBox"]:GetText())
								else C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], true); ToyPlus:RefreshList(0, false) end
							     end },
							}
							local menuFrame = CreateFrame("Frame", "ToyPlus_FaveMenu", UIParent, "UIDropDownMenuTemplate")
							EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
						end
					end
				end
			end)
			toyIcon.icon:SetTexture(toyIconStr)
			toyIcon.icon:SetTexCoord(0.1,0.9,0.1,0.9)
			toyIcon:SetAttribute("item", toyName)
			toyIcon:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetToyByItemID(itemID)
			end)
			toyIcon:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			toyIcon:SetScript("OnDragStart", function(self)
				C_ToyBox.PickupToyBoxItem(itemID)
			end)
			toyIcon:SetScript("OnEvent", function(self, event, ...)
				if event == "ACTIONBAR_UPDATE_COOLDOWN" then
					local start, duration
					start, duration = GetItemCooldown(itemID)
					if start == 0 then toyCD:SetCooldown(0, 0) else toyCD:SetCooldown(start, duration) end
				end
			end)
		else
			local toyIcon = _G["ToyPlus_Icon"..i]
			if toyIcon then toyIcon:Hide() end
		end
	end
end

function ToyPlus:CreateFrame()
	local toyFrame = CreateFrame("Frame", "ToyPlusFrame", UIParent)--Toy Icons Frame
	toyFrame:SetFrameStrata("BACKGROUND")
	toyFrame:SetClampedToScreen(true)
	toyFrame:SetMovable(true); toyFrame:EnableMouse(true)
	toyFrame:RegisterForDrag("LeftButton")
	toyFrame:SetScript("OnDragStart", toyFrame.StartMoving)
	toyFrame:SetScript("OnDragStop", function(self, button) 
		toyFrame:StopMovingOrSizing()
		ToyPlus:StorePosition()
	end)
	if ToyPlus.db.profile.anchorPoint and ToyPlus.db.profile.relativePoint and ToyPlus.db.profile.anchorX and ToyPlus.db.profile.anchorY then 
		toyFrame:SetPoint(ToyPlus.db.profile.anchorPoint, UIParent, ToyPlus.db.profile.relativePoint, ToyPlus.db.profile.anchorX, ToyPlus.db.profile.anchorY)
	else toyFrame:SetPoint("CENTER") end
	toyFrame:SetSize(185,96)
	toyFrame.texture = toyFrame:CreateTexture()
	toyFrame.texture:SetPoint("TOPLEFT", toyFrame, 2, -2)
	toyFrame.texture:SetPoint("BOTTOMRIGHT", toyFrame, -2, 2)
	local backdrop = {
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  tile = false, tileSize = 8, edgeSize = 8,
	  insets = { left = 2, right = 2, top = 2, bottom = 2 }
	}
	toyFrame:SetBackdrop(backdrop)
	if ToyPlus.db.profile.theme then toyFrame.texture:SetColorTexture(0, 0.1, 0.3, 0.7); toyFrame:SetBackdropBorderColor(0,0.564,1,1)
	else toyFrame.texture:SetColorTexture(0,0,0,0.5); toyFrame:SetBackdropBorderColor(0.5,0.5,0.5,1) end
	
	toyFrame:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then InterfaceOptionsFrame_OpenToCategory("ToyPlus") end
	end)
	toyFrame:Show()
	local label = toyFrame:CreateFontString("$parent_Label","OVERLAY","GameFontNormal")
	label:SetPoint("TOPRIGHT",toyFrame,"TOPRIGHT",-26,-6)
	label:SetText(L"Toy List")
	label:Hide()
	local btn = CreateFrame("BUTTON", "$parent_Close", toyFrame, "UIPanelCloseButton")
	btn:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", -1, 2)
	btn:SetSize(30,30)
	btn:Show(); btn:Enable()
	btn:SetScript("OnClick", function (self, button, down) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
			ToyPlus:StorePosition()
			toyFrame:Hide()
			ToyPlus.db.profile.shown = false
			local fra2 = _G["ToyPlus_Popout"]
			if fra2 then
				fra2:Hide(); _G["ToyPlusFrame_Popout"].texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
			end
		end 
	end)
	local btnAddRow = CreateFrame("BUTTON", "$parent_AddRow", toyFrame)
	btnAddRow:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", 32, -6)
	btnAddRow:SetAlpha(1); btnAddRow:Show(); btnAddRow:Enable()
	btnAddRow:SetSize(14,14)
	btnAddRow.texture = btnAddRow:CreateTexture()
	btnAddRow.texture:SetAllPoints(btnAddRow)
	btnAddRow.texture:SetDrawLayer("ARTWORK", -1)
	btnAddRow.texture:SetTexture("Interface\\PaperDollInfoFrame\\Character-Plus")
	btnAddRow:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't adjust rows in combat.", 0, 0.7, 1) return end
			ToyPlus.db.profile.rows = ToyPlus.db.profile.rows + 1
			ToyPlus:ToggleRows()
		end
	end)
	local btnLessRow = CreateFrame("BUTTON", "$parent_LessRow", toyFrame)
	btnLessRow:SetPoint("TOPLEFT", toyFrame, "TOPLEFT", 51, -6)
	btnLessRow:SetAlpha(1); btnLessRow:Show(); btnLessRow:Enable()
	btnLessRow:SetSize(16,16)
	btnLessRow.texture = btnLessRow:CreateTexture()
	btnLessRow.texture:SetAllPoints(btnLessRow)
	btnLessRow.texture:SetDrawLayer("ARTWORK", -1)
	btnLessRow.texture:SetTexture("Interface\\WorldMap\\Dash_64")
	btnLessRow:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't adjust rows in combat.", 0, 0.7, 1) return end
			ToyPlus.db.profile.rows = ToyPlus.db.profile.rows - 1
			ToyPlus:ToggleRows()
		end
	end)
	local btnPopout = CreateFrame("BUTTON", "$parent_Popout", toyFrame)
	btnPopout:SetPoint("TOPRIGHT", toyFrame, "TOPRIGHT", 0, 0)
	btnPopout:SetAlpha(1); btnPopout:Show(); btnPopout:Enable()
	btnPopout:SetSize(25,25)
	btnPopout.texture = btnPopout:CreateTexture()
	btnPopout.texture:SetTexCoord(0,1,0,1)
	btnPopout.texture:SetAllPoints(btnPopout)
	btnPopout.texture:SetDrawLayer("ARTWORK", -1)
	btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
    btnPopout:RegisterForClicks("AnyUp")
	btnPopout:SetScript("OnClick", function (self, button) 
		if button == "LeftButton" then
			local fra = _G["ToyPlus_Popout"]
			if fra and fra:IsVisible() then
				btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
				fra:Hide()
			else
				if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
				btnPopout.texture:SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up")
				ToyPlus:ShowList()
			end
        elseif button == "RightButton" then
			InterfaceOptionsFrame_OpenToCategory(L"ToyPlus")
        end
	end)
	local iconH, iconV = 6, -27
	for i = 1, 100 do -- Toy Buttons
		if ToyPlusToyDB.toyName[i] then
			local toyName = ToyPlusToyDB.toyName[i]
			local toyIconStr = ToyPlusToyDB.toyIcon[i]
			local itemID = ToyPlusToyDB.itemID[i]
			toyIcon = CreateFrame("BUTTON","ToyPlus_Icon"..i,toyFrame, "SecureActionButtonTemplate,ActionButtonTemplate")--Icons
			toyIcon:RegisterUnitEvent("ACTIONBAR_UPDATE_COOLDOWN"); toyIcon:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE")
			toyIcon:SetAttribute("type", "item")
			toyIcon:SetAttribute("item", toyName)
			toyIcon:RegisterForDrag("LeftButton")
			toyIcon:SetSize(30,30)
			toyIcon:SetPoint("TOPLEFT",toyFrame,"TOPLEFT",6,-27)
			toyIcon.icon:SetTexture(toyIconStr)
			toyIcon.icon:SetTexCoord(0.1,0.9,0.1,0.9)
			toyIcon.icon:Show()
			local border = _G["ToyPlus_Icon"..i.."NormalTexture"]
			if ToyPlus.db.profile.theme then border:SetVertexColor(0,0.6,1,1)
			else border:SetVertexColor(0.6,0.6,0.6,1) end
			local toyCD = CreateFrame("Cooldown","$parent_CD",toyIcon, "CooldownFrameTemplate")
			toyCD:SetAllPoints(toyIcon)
			local start, duration = GetItemCooldown(itemID)
			if start ~= 0 then toyCD:SetCooldown(start, duration) end
			toyIcon:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:SetToyByItemID(itemID)
			end)
			toyIcon:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			toyIcon:SetScript("OnDragStart", function(self)
				C_ToyBox.PickupToyBoxItem(itemID)
			end)
			toyIcon:SetScript("OnEvent", function(self, event, ...)
				if event == "ACTIONBAR_UPDATE_COOLDOWN" or "LOSS_OF_CONTROL_UPDATE" then
					local start, duration = GetItemCooldown(itemID)
					if start == 0 then toyCD:SetCooldown(0, 0) else toyCD:SetCooldown(start, duration) end
				end
			end)
			toyIcon:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					if ToyPlusToyDB.itemID[i] then
						local isFavorite, menu = C_ToyBox.GetIsFavorite(ToyPlusToyDB.itemID[i])
						if isFavorite then
							menu = {
							    { text = L"Remove Favorite", func = function()
							       if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
							       if _G["ToyPlus_Popout"] then C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], false); ToyPlus:RefreshList(0, false, _G["ToyPlus_Popout_SearchBox"]:GetText())
							       else C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], false); ToyPlus:RefreshList(0, false) end
							     end },
							}
						else
							menu = {
							    { text = L"Add Favorite", func = function()
								if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage(L"ToyPlus: Error: \124cffffffffCan't do that while in combat.", 0, 0.7, 1); return end
								if _G["ToyPlus_Popout"] then C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], true); ToyPlus:RefreshList(0, false, _G["ToyPlus_Popout_SearchBox"]:GetText()) 
								else C_ToyBox.SetIsFavorite(ToyPlusToyDB.itemID[i], true); ToyPlus:RefreshList(0, false) end
							     end },
							}
						end
						local menuFrame = CreateFrame("Frame", "ToyPlus_FaveMenu", UIParent, "UIDropDownMenuTemplate")
						EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
					end
				end
			end)
			toyIcon:Hide()
		end
	end
	ToyPlus:ToggleRows()
	ToyPlus.db.profile.shown = true
end
