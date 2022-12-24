local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

tdDropDownDB = {}

local profiles = {}
local events = {}
local L = tdDropDown_Locale
local O = tdDropDown_Option

StaticPopupDialogs["TDDROPDOWN_DELETE_ALL"] = {preferredIndex = 3,
    text = L.DelAll,
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self, profile)
        if tdDropDownDB[profile] then
            table.wipe(tdDropDownDB[profile])
        end
    end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
    exclusive = 1,
}

O.MAX = O.MAX and tonumber(O.MAX) or 40

local function IsInList(list, text)
	for key, value in ipairs(list) do
		if value == text then
			return key
		end
	end
end

local function RemoveFromList(list, text)
	for key, value in ipairs(list) do
		if value and text and value:lower() == text:lower() then
            table.remove(list, key)
			return key
		end
	end
end

local function ToSortString(text)
	return format("%10d%s", string.len(text), text)
end

local function tdDropDown_HeaderClick(self)
	local pos = IsInList(tdDropDownDB[self.owner.profile], self.value)
	if pos then
		tremove(tdDropDownDB[self.owner.profile], pos)
		self.owner.editbox:SetText("")
	else
		tinsert(tdDropDownDB[self.owner.profile], self.value)
	end
	sort(tdDropDownDB[self.owner.profile], function(a, b)
		return ToSortString(a) < ToSortString(b)
	end)
end

local function tdDropDown_ButtonClick(self)
	self.owner.editbox:SetText(self.value)
	if self.owner.click then
		self.owner.click()
	end
end

local function tdDropdown_DeleteAll(self, arg1)
    StaticPopup_Show("TDDROPDOWN_DELETE_ALL", nil, nil, arg1);
end

local function tdDropDown_Initialize(self, dropdown, level)
	level = level or 1

	local list = tdDropDownDB[dropdown.profile]
	local text = dropdown.editbox:GetText()
	local info = {}

	if not text or text == "" or text == L.Search then text = nil end

	if text and level == 1 then
		local str = IsInList(list, text) and L.Del or L.Add

		info = { owner = dropdown, notCheckable = 1,}
		info.text = format(str, text)
		info.value = text;
		info.func = tdDropDown_HeaderClick
		LibDD:UIDropDownMenu_AddButton(info, 1)

		if #(list) > 0 then
			LibDD:UIDropDownMenu_AddSeparator(level)
		end
	end

	info = { owner = dropdown, func = tdDropDown_ButtonClick, fontObject = ChatFontNormal, }

	local start  = (level - 1) * O.MAX + 1
	for i = start, start + O.MAX - 1 do
		if not list[i] then
			break
		end
		info.text = list[i]
		info.value = list[i];
		LibDD:UIDropDownMenu_AddButton(info, level)
	end

	if #(list) > start + O.MAX - 1 then
		LibDD:UIDropDownMenu_AddSeparator(level)
		info.notCheckable = 1
		info.text = L.Next
		info.value = nil
		info.func = nil
		info.hasArrow = true
		info.fontObject = nil
		LibDD:UIDropDownMenu_AddButton(info, level)
    end

    --增加删除全部的功能
    if #list > 0 and level == 1 then
		LibDD:UIDropDownMenu_AddSeparator(level)

        info = { owner = dropdown, notCheckable = 1, }
        info.text = L.DelAll;
        info.value = L.DelAll;
        info.func = tdDropdown_DeleteAll;
        info.arg1 = dropdown.profile;
		LibDD:UIDropDownMenu_AddButton(info, 1)
    end
end

local function GetObjectByPath(path)
    local curr = _G
    for _, v in ipairs({strsplit(".", path)}) do
        local next = curr[v]
        if not next then return end
        curr = next
    end
    return curr
end

local setting_by_us
local function hookSetWidth(self, width)
	if setting_by_us then return end
	setting_by_us = 1
	--local point, rel, relPoint, x, y = self:GetPoint(1)
	--if point and point:find("RIGHT") then
	--	self:SetPoint(point, rel, relPoint, x - 19, y)
	--end
	self:SetWidth(width - 19)
	setting_by_us = nil
end

local function CreateDropDown(profile, short, move, click, over, short_hook)
	if not profile then return end

	local editbox = GetObjectByPath(profile == "BrowseName" and "AuctionHouseFrame.SearchBar.SearchBox" or profile)
	if not editbox then return end

	tdDropDownDB[profile] = tdDropDownDB[profile] or {}

	local name = editbox:GetName() or profile
	local dropdown = LibDD:Create_UIDropDownMenu(name.."Dropdown", editbox) --CreateFrame("Frame", name.."Dropdown", editbox, UIDropDownMenuTemplate)

	local width = editbox:GetWidth()
	if short or short_hook then
		editbox:SetWidth(width - 19) --hookSetWidth(editbox, width)
	end
	if short_hook then
		hooksecurefunc(editbox, "SetWidth", hookSetWidth)
	end
	if move then
        for i=1, editbox:GetNumPoints() do
			local point, relative, rpoint, x, y = editbox:GetPoint(i)
			if string.find(point, "RIGHT") then
				--editbox:ClearAllPoints()
				editbox:SetPoint(point, relative, rpoint, x - 19, y)
			end
		end
	end

	local button = CreateFrame("Button", name.."Button", editbox)
	button:SetWidth(24);button:SetHeight(25)
	button:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
	button:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
	button:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
	if over then
		button:SetPoint("RIGHT", editbox, "RIGHT", 2, 0)
	else
		button:SetPoint("LEFT", editbox, "RIGHT", -5, 0)
	end
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	button.dropdown = dropdown
	dropdown.editbox = editbox
	dropdown.profile = profile
	dropdown.click = click

	button:SetScript("OnClick", function(self, arg1)
		if arg1 == "LeftButton" then
			LibDD:ToggleDropDownMenu(1, nil, self.dropdown, self, - width , 0)
		else
			self.dropdown.editbox:SetText("")
		end
	end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(format(L.Num, #(tdDropDownDB[self.dropdown.profile])), 1, 1, 1)
		GameTooltip:AddLine(L.ShowList)
		GameTooltip:AddLine(L.ClearInput)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	button.HandlesGlobalMouseEvent = function(_, buttonID, event) return event == "GLOBAL_MOUSE_DOWN" and buttonID == "LeftButton" end

	LibDD:UIDropDownMenu_Initialize(dropdown, function(self, level) tdDropDown_Initialize(self, dropdown, level) end, O.Menu and "MENU" or nil);
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "VARIABLES_LOADED" then
		local old
		old = "TradeSkillFrame.SearchBox" if tdDropDownDB[old] then tdDropDownDB["ProfessionsFrame.CraftingPage.RecipeList.SearchBox"] = tdDropDownDB[old] tdDropDownDB[old] = nil end
		old = "AchievementFrame.searchBox" if tdDropDownDB[old] then tdDropDownDB["AchievementFrame.SearchBox"] = tdDropDownDB[old] tdDropDownDB[old] = nil end
		old = "FriendsFrameBroadcastInput" if tdDropDownDB[old] then tdDropDownDB["FriendsFrameBattlenetFrame.BroadcastFrame.EditBox"] = tdDropDownDB[old] tdDropDownDB[old] = nil end
		old = "BuyName"; tdDropDownDB[old] = nil
		old = "TradeSkillFrameSearchBox"; tdDropDownDB[old] = nil
	end
	if profiles[event] then
		for key = #profiles[event],1,-1 do
			local value = profiles[event][key];
			if value.func(...) then
				CreateDropDown(value.profile, value.short, value.move, value.click, value.over, value.short_hook)
				if value.hook then value.hook() end
				tremove(profiles[event], key)
			end
		end
		if #(profiles[event]) <= 0 then
			self:UnregisterEvent(event)
			events[event] = nil
		end
	end
end)

function tdInsertValueIfNotExist(profile, value)
	local list = tdDropDownDB[profile];
	if value and value:len()> 0 then
        RemoveFromList(list, value);
		table.insert(list, 1, value);
	end
end

function tdCreateDropDown(table)
	if not table or not table.profile then return end

	local event = table.event or "VARIABLES_LOADED"
	local func = table.func or function() return true end

	profiles[event] = profiles[event] or {}
	tinsert(profiles[event], {
		profile = table.profile,
		func = func,
		short = table.short,
		move = table.move,
		click = table.click,
		over = table.over,
		hook = table.hook,
		short_hook = table.short_hook,
	})
	if not events[event] then
		f:RegisterEvent(event)
		events[event] = true
	end
end

tdCreateDropDownDirect = CreateDropDown