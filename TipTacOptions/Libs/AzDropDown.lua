local L = LibStub("AceLocale-3.0"):GetLocale("TipTac") 
--[[
	### Rev 04 ###
	- Dropdowns can now overwrite the label in their init and selectvalue funcs.
	- Empty menus now show "No items".
	### Rev 05 ###
	- A menu entry now supports a .tip key, and will show a tooltip if it's a string.
	- The SelectValueFunc() now has a third parameter, the menu item index that was clicked.
	- The checkmark texture is now the green one used for readychecks in the raid tab.
	- Will now obey the .checked key if set, not only when it's true.
	- The autoselect feature of the last selected value, will not just select everything when nil.
	- The InitSelectedItem() function will not ignore an initialisation with nil anymore.
	### Rev 06 ###
	- The "menu.list" table now has a meta table which will automatically create a table or take one from storage.
	- If tables are creates through the new metatable index method, it will recycle old tables from storage.
	### Rev 07 ###
	- The menu will now hide itself, if any of it's parents was hidden.
	### Rev 09 ###
	- DropDown Text Object can no longer be wider than the width of the DropDown itself.
	### Rev 10 - 7.0.3/Legion ###
	- Fixed issue related to frame level, making the dropdown appear behind other frames. Thanks vincentSDSH.
	### Rev 11 - 7.3 ###
	- Fixed the PlaySound() issue
--]]

local REVISION = 11;
if (type(AzDropDown) == "table") and (AzDropDown.vers >= REVISION) then
	return;
end

AzDropDown = AzDropDown or {};
AzDropDown.vers = REVISION;

local menu;					-- only one menu exists globally that is shared across all created dropdowns
local measure;				-- fontString used to measure text width

local menuMaxItems = 15;
local menuItemHeight = 14;

local backDrop = { bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14, insets = { left = 2.5, right = 2.5, top = 2.5, bottom = 2.5 } };
local storage = {};

--------------------------------------------------------------------------------------------------------
--                                          Menu Functions                                            --
--------------------------------------------------------------------------------------------------------

-- MenuItem OnClick
local function MenuItem_OnClick(self,button)
	local table = menu.list[self.index];
	local parent = menu.parent;
	if (parent.isAutoSelect) then
		parent.label:SetText(table.text);
		parent.SelectedValue = table.value;
	end
	menu.SelectValueFunc(parent,table,self.index);
	menu:Hide();
end

-- MenuItem OnEnter
local function MenuItem_OnEnter(self)
	local entry = menu.list[self.index];
	if (type(entry.tip) == "string") then
		GameTooltip_SetDefaultAnchor(GameTooltip,self);
		GameTooltip:AddLine(entry.text,1,1,1);
		GameTooltip:AddLine(entry.tip,nil,nil,nil,1);
		GameTooltip:Show();
	end
end

-- HideGTT
local function HideGTT()
	GameTooltip:Hide();
end

-- Make Menu Item
local function CreateMenuItem()
	local item = CreateFrame("Button",nil,menu);
	item:SetHeight(menuItemHeight);
	item:SetHitRectInsets(-12,-10,0,0);
	item:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	item:SetScript("OnClick",MenuItem_OnClick);
	item:SetScript("OnEnter",MenuItem_OnEnter);
	item:SetScript("OnLeave",HideGTT);

	item.text = item:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	item.text:SetPoint("LEFT",2,0);

	item.check = item:CreateTexture(nil,"ARTWORK");
	item.check:SetTexture(READY_CHECK_READY_TEXTURE);
	item.check:SetWidth(14);
	item.check:SetHeight(14);
	item.check:SetPoint("RIGHT",item,"LEFT");
	item.check:Hide();

	if (#menu.items == 0) then
		item:SetPoint("TOPLEFT",20,-8);
		menu.scroll:SetPoint("TOPLEFT",item);
	else
		item:SetPoint("TOPLEFT",menu.items[#menu.items],"BOTTOMLEFT");
		item:SetPoint("TOPRIGHT",menu.items[#menu.items],"BOTTOMRIGHT");
		menu.scroll:SetPoint("BOTTOMRIGHT",item);
	end

	menu.items[#menu.items + 1] = item;
	return item;
end

-- Updates the dropdown list -- A dropdown menu entry can contain the following table keys: text, value, header, checked, tip
local function Menu_UpdateList()
	FauxScrollFrame_Update(menu.scroll,#menu.list,menuMaxItems,menuItemHeight);
	local item, entry;
	local index = menu.scroll.offset;
	-- Loop
	for i = 1, menuMaxItems do
		index = (index + 1);
		item = menu.items[i] or CreateMenuItem();
		if (index <= #menu.list) then
			entry = menu.list[index];
			item.text:SetText(entry.text);
			item.index = index;
			item.text:SetTextColor(1,entry.header and 0.82 or 1,entry.header and 0 or 1);
			if (entry.header) then
				item:Disable();
			else
				item:Enable();
			end
			if (entry.checked) or (entry.checked == nil and menu.parent.isAutoSelect and entry.value ~= nil and entry.value == menu.parent.SelectedValue) then
				item.check:Show();
			else
				item.check:Hide();
			end
			item:Show();
		else
			item:Hide();
		end
	end
end

-- Create Menu
local function CreateMenu()
	menu = CreateFrame("Frame",nil,nil);
	menu:SetBackdrop(backDrop);
	menu:SetBackdropColor(0.1,0.1,0.1,1);
	menu:SetBackdropBorderColor(0.4,0.4,0.4,1);
	menu:SetToplevel(true);
	menu:SetClampedToScreen(true);
	menu:SetFrameStrata("FULLSCREEN_DIALOG");
	menu:SetScript("OnHide",function(self) if (self:IsShown()) then self:Hide(); end end);
	menu:Hide();

	measure = menu:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	measure:Hide();

	menu.scroll = CreateFrame("ScrollFrame","AzDropDownScroll"..REVISION,menu,"FauxScrollFrameTemplate");
	menu.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,menuItemHeight,Menu_UpdateList); end);

	menu.items = {};
	menu.list = setmetatable({},{ __index = function(t,k) t[k] = #storage > 0 and tremove(storage,#storage) or {}; return t[k]; end });
end

-- InitMenu
local function InitMenu(parent,initFunc,selectValueFunc,point,parentPoint)
	if (not initFunc) then
		return;
	end
	-- Set DropDown Parent
	menu.parent = parent;
	menu:SetParent(parent);
	-- Anchor to Parent
	menu:ClearAllPoints();
	menu:SetPoint(point or "TOPRIGHT",parent,parentPoint or "BOTTOMRIGHT");
	menu:SetFrameLevel(parent:GetFrameLevel() + 2);
	-- Clear Old List & Init the New
	for index, tbl in ipairs(menu.list) do
		wipe(tbl);
		storage[#storage + 1] = tbl;
	end
	wipe(menu.list);
	menu.SelectValueFunc = selectValueFunc;
	menu.InitFunc = initFunc;
	initFunc(parent,menu.list);
	-- Show "No items" for empty lists & Update List
	if (#menu.list == 0) then
		menu.list[1].text = "No items"; menu.list[1].header = true;
	end
	Menu_UpdateList();
	-- Set Width
	local maxItemWidth = 0;
	for _, table in ipairs(menu.list) do
		measure:SetText(table.text);
		maxItemWidth = max(maxItemWidth,measure:GetWidth() + 10);
	end
	if (#menu.list > menuMaxItems) then
		maxItemWidth = (maxItemWidth + 12);
		menu.items[1]:SetPoint("TOPRIGHT",-28,-8);
	else
		menu.items[1]:SetPoint("TOPRIGHT",-16,-8);
	end
	menu:SetWidth(maxItemWidth + 38);
	menu:SetHeight(min(#menu.list,menuMaxItems) * menuItemHeight + 16);
end

--------------------------------------------------------------------------------------------------------
--                                        Drop Down Functions                                         --
--------------------------------------------------------------------------------------------------------

-- DropDown OnClick
local function DropDown_OnClick(self,button)
	local parent = self:GetParent();
	AzDropDown.ToggleMenu(parent,parent.InitFunc,parent.SelectValueFunc);
end

-- Init Selected DropDown Item
local function DropDown_InitSelectedItem(self,selectedValue)
	if (not menu) then
		CreateMenu();
	end
	self.label:SetText(L["|cff00ff00Select Value..."]);
	InitMenu(self,self.InitFunc,self.SelectValueFunc);
	self.SelectedValue = selectedValue;
	for _, table in ipairs(menu.list) do
		if (table.value == selectedValue) then
			self.label:SetText(table.text);
			return;
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                        "Exported" Functions                                        --
--------------------------------------------------------------------------------------------------------

-- Hides the menu
function AzDropDown.HideMenu()
	if (menu) then
		menu:Hide();
	end
end

-- Toggles menu visibility
function AzDropDown.ToggleMenu(parent,initFunc,selectValueFunc,point,parentPoint)
	if (not parent or not initFunc or not selectValueFunc) then
		return;
	end
	if (not menu) then
		CreateMenu();
	end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);	-- "igMainMenuOptionCheckBoxOn"
	if (menu:IsShown()) and (menu.parent == parent) then
		menu:Hide();
	else
		InitMenu(parent,initFunc,selectValueFunc,point,parentPoint);
		menu:Show();
	end
end

-- Creates a dropdown menu
function AzDropDown.CreateDropDown(parent,width,isAutoSelect,initFunc,selectValueFunc)
	if (not parent or not width) then
		return;
	end
	local dd = CreateFrame("Frame",nil,parent);
	dd:SetWidth(width);
	dd:SetHeight(24);
	dd:SetBackdrop(backDrop);
	dd:SetBackdropColor(0.1,0.1,0.1,1);
	dd:SetBackdropBorderColor(0.4,0.4,0.4,1);

	dd.button = CreateFrame("Button",nil,dd);
	dd.button:SetPoint("TOPRIGHT");
	dd.button:SetPoint("BOTTOMRIGHT");
	dd.button:SetWidth(24);
	dd.button:SetHitRectInsets(-1 * (width - dd.button:GetWidth()),0,0,0);
	dd.button:SetScript("OnClick",DropDown_OnClick);

	dd.button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
	dd.button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
	dd.button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled");
	dd.button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight");

	dd.label = dd:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	dd.label:SetPoint("RIGHT",dd.button,"LEFT",-2,0);
	dd.label:SetPoint("LEFT",dd,"LEFT",4,0);
	dd.label:SetJustifyH("RIGHT");

	dd.isAutoSelect = isAutoSelect;

	dd.InitFunc = initFunc;
	dd.SelectValueFunc = selectValueFunc;
	dd.InitSelectedItem = DropDown_InitSelectedItem;
	return dd;
end
