--[[ TrinketMenu 5.0.0 ]]--

TrinketMenu = { }

local _G, math, tonumber, string, type, pairs, ipairs, table, select = _G, math, tonumber, string, type, pairs, ipairs, table, select

-- localized strings required to support engineering bags
TrinketMenu.BAG = "Bag" -- 7th return of GetItemInfo on a normal bag
TrinketMenu.ENGINEERING_BAG = "Engineering Bag" -- 7th return of GetItemInfo on an engineering bag
TrinketMenu.TRADE_GOODS = "Trade Goods" -- 6th return of GetItemInfo on most engineered trinkets
TrinketMenu.DEVICES = "Devices" -- 7th return of GetItemInfo on most engineered trinkets
TrinketMenu.REQUIRES_ENGINEERING = "Requires Engineering" -- from tooltip when GetItemInfo ambiguous

function TrinketMenu.LoadDefaults()
	TrinketMenuOptions = TrinketMenuOptions or {
		IconPos = - 100,			-- angle of initial minimap icon position
		ShowIcon = "ON",			-- whether to show the minimap button
		SquareMinimap = "OFF",		-- whether the minimap is square instead of circular
		CooldownCount = "OFF",		-- whether to display numerical cooldown counters
		LargeCooldown = "ON",		-- whether cooldown numbers are large or small
		TooltipFollow = "OFF",		-- whether tooltips follow the mouse
		KeepOpen = "OFF",			-- whether menu hides after use
		KeepDocked = "ON",			-- whether to keep menu docked at all times
		Notify = "OFF",				-- whether a message appears when a trinket is ready
		DisableToggle = "OFF",		-- whether minimap button toggles trinkets
		NotifyUsedOnly = "OFF",		-- whether notify happens only on trinkets used
		NotifyChatAlso = "OFF",		-- whether to send notify to chat also
		Locked = "OFF",				-- whether windows can be moved/scaled/rotated
		ShowTooltips = "ON",		-- whether to display tooltips at all
		NotifyThirty = "OFF",		-- whether to notify cooldowns at 30 seconds instead of 0
		MenuOnShift = "OFF",		-- whether menu requires Shift to display
		TinyTooltips = "OFF",		-- whether tooltips display only name and cooldown
		SetColumns = "OFF",			-- whether number of columns in menu is chosen automatically
		Columns = 4,				-- if SetColumns "ON", number of columns before menu wraps
		ShowHotKeys = "OFF",		-- whether hotkeys show on trinkets
		StopOnSwap = "OFF",			-- whether to stop auto queue on all manual swaps
		RedRange = "OFF",			-- whether to monitor and red out out of range trinkets
		HidePetBattle = "ON",		-- whether to hide the trinkets while in a pet battle
		MenuOnRight = "OFF"			-- whether to open menu with right-click
	}
	TrinketMenuPerOptions = TrinketMenuPerOptions or {
		MainDock = "BOTTOMRIGHT",	-- corner of main window docked to
		MenuDock = "BOTTOMLEFT",	-- corner menu window is docked from
		MainOrient = "HORIZONTAL",	-- direction of main window
		MenuOrient = "VERTICAL",	-- direction of menu window
		XPos = 400,					-- left edge of main window
		YPos = 400,					-- top edge of main window
		MainScale = 1,				-- scaling of main window
		MenuScale = 1,				-- scaling of menu window
		Visible = "ON",				-- whether to display the trinkets
		FirstUse = true,			-- whether this is the first time this user has used the mod
		ItemsUsed = { },			-- table of trinkets used and their cooldown status
		Alpha = 1,					-- alpha of both windows
		Hidden = { }				-- table of trinkets hidden
	}
end

--[[ Misc Variables ]]--

TrinketMenu_Version = "5.0.4"
BINDING_HEADER_TRINKETMENU = "TrinketMenu"
setglobal("BINDING_NAME_CLICK TrinketMenu_Trinket0:LeftButton", "Use Top Trinket")
setglobal("BINDING_NAME_CLICK TrinketMenu_Trinket1:LeftButton", "Use Bottom Trinket")

TrinketMenu.MaxTrinkets = 30 -- add more to TrinketMenu_MenuFrame if this changes
TrinketMenu.BaggedTrinkets = { } -- indexed by number, 1-30 of trinkets in the menu
TrinketMenu.NumberOfTrinkets = 0 -- number of trinkets in the menu
TrinketMenu.CombatQueue = { } -- [0] or [1] = name of trinket queued for slot 0 or 1
TrinketMenu.Corners = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT"}

--[[ Local functions ]]--

-- dock-dependant offset and directions: MainDock..MenuDock
-- x/yoff   = offset MenuFrame is positioned to MainFrame
-- x/ydir   = direction trinkets are added to menu
-- x/ystart = starting offset when building a menu, relativePoint MenuDock
TrinketMenu.DockStats = {
	["TOPRIGHTTOPLEFT"] =			{ xoff = - 4, yoff = 0, xdir = 1, ydir = - 1, xstart = 8, ystart = - 8 },
	["BOTTOMRIGHTBOTTOMLEFT"] = 	{ xoff = - 4, yoff = 0, xdir = 1, ydir = 1, xstart = 8, ystart = 44 },
	["TOPLEFTTOPRIGHT"] =			{ xoff = 4, yoff = 0, xdir = - 1, ydir = - 1, xstart = - 44, ystart = - 8 },
	["BOTTOMLEFTBOTTOMRIGHT"] =		{ xoff = 4, yoff = 0, xdir = - 1, ydir = 1, xstart = - 44, ystart = 44 },
	["TOPRIGHTBOTTOMRIGHT"] =		{ xoff = 0, yoff = - 4, xdir = - 1, ydir = 1, xstart = - 44, ystart = 44 },
	["BOTTOMRIGHTTOPRIGHT"] =		{ xoff = 0, yoff = 4, xdir = - 1, ydir = - 1, xstart = - 44, ystart = - 8 },
	["TOPLEFTBOTTOMLEFT"] =			{ xoff = 0, yoff = - 4, xdir = 1, ydir = 1, xstart = 8, ystart = 44 },
	["BOTTOMLEFTTOPLEFT"] =			{ xoff = 0, yoff = 4, xdir = 1, ydir = - 1, xstart = 8, ystart = - 8 }
}

-- returns offset and direction depending on current docking. ie: TrinketMenu.DockInfo("xoff")
function TrinketMenu.DockInfo(arg1)
	local anchor = TrinketMenuPerOptions.MainDock..TrinketMenuPerOptions.MenuDock
	if TrinketMenu.DockStats[anchor] and arg1 and TrinketMenu.DockStats[anchor][arg1] then
		return TrinketMenu.DockStats[anchor][arg1]
	else
		return 0
	end
end

-- hide the docking markers
function TrinketMenu.ClearDocking()
	for i = 1, 4 do
		_G["TrinketMenu_MainDock_"..TrinketMenu.Corners[i]]:Hide()
		_G["TrinketMenu_MenuDock_"..TrinketMenu.Corners[i]]:Hide()
	end
end

-- returns true if the two values are close to each other
function TrinketMenu.Near(arg1, arg2)
	return (math.max(arg1, arg2) - math.min(arg1, arg2)) < 15
end

-- moves the MenuFrame to the dock position against MainFrame
function TrinketMenu.DockWindows()
	TrinketMenu.ClearDocking()
	if TrinketMenuOptions.KeepDocked == "ON" then
		TrinketMenu_MenuFrame:ClearAllPoints()
		if TrinketMenuOptions.Locked == "OFF" then
			TrinketMenu_MenuFrame:SetPoint(TrinketMenuPerOptions.MenuDock, "TrinketMenu_MainFrame", TrinketMenuPerOptions.MainDock, TrinketMenu.DockInfo("xoff"), TrinketMenu.DockInfo("yoff"))
		else
			TrinketMenu_MenuFrame:SetPoint(TrinketMenuPerOptions.MenuDock, "TrinketMenu_MainFrame", TrinketMenuPerOptions.MainDock, TrinketMenu.DockInfo("xoff") * 3, TrinketMenu.DockInfo("yoff") * 3)
		end
	end
	if TrinketMenu_MenuFrame:IsVisible() then
		TrinketMenu.BuildMenu()
	end
end

-- displays windows vertically or horizontally
function TrinketMenu.OrientWindows()
	if TrinketMenuPerOptions.MainOrient == "HORIZONTAL" then
		TrinketMenu_MainFrame:SetWidth(92)
		TrinketMenu_MainFrame:SetHeight(52)
	else
		TrinketMenu_MainFrame:SetWidth(52)
		TrinketMenu_MainFrame:SetHeight(92)
	end
end

-- scan inventory and build MenuFrame
function TrinketMenu.BuildMenu()
	if not IsShiftKeyDown() and TrinketMenuOptions.MenuOnShift == "ON" then
		return
	end
	local idx, i, j, k, texture = 1
	local _, itemLink, itemID, itemName, equipSlot, itemTexture
	-- go through bags and gather trinkets into .BaggedTrinkets
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			itemLink = GetContainerItemLink(i, j)
			if itemLink then
				_, _, itemID, itemName = string.find(GetContainerItemLink(i, j) or "", "item:(%d+).+%[(.+)%]")
				_, _, _, _, _, _, _, _, equipSlot, itemTexture = GetItemInfo(itemID or "")
				if equipSlot == "INVTYPE_TRINKET" and (IsAltKeyDown() or not TrinketMenuPerOptions.Hidden[itemID]) then
					if not TrinketMenu.BaggedTrinkets[idx] then
						TrinketMenu.BaggedTrinkets[idx] = { }
					end
					TrinketMenu.BaggedTrinkets[idx].id = itemID
					TrinketMenu.BaggedTrinkets[idx].bag = i
					TrinketMenu.BaggedTrinkets[idx].slot = j
					TrinketMenu.BaggedTrinkets[idx].name = itemName
					TrinketMenu.BaggedTrinkets[idx].texture = itemTexture
					idx = idx + 1
				end
			end
		end
	end
	TrinketMenu.NumberOfTrinkets = math.min(idx - 1, TrinketMenu.MaxTrinkets)
	if TrinketMenu.NumberOfTrinkets < 1 then
		-- user has no bagged trinkets :(
		TrinketMenu_MenuFrame:Hide()
	else
		-- display trinkets outward from docking point
		local col, row, xpos, ypos = 0, 0, TrinketMenu.DockInfo("xstart"), TrinketMenu.DockInfo("ystart")
		local max_cols = 1
		if TrinketMenu.NumberOfTrinkets > 24 then
			max_cols = 5
		elseif TrinketMenu.NumberOfTrinkets > 18 then
			max_cols = 4
		elseif TrinketMenu.NumberOfTrinkets > 12 then
			max_cols = 3
		elseif TrinketMenu.NumberOfTrinkets > 4 then
			max_cols = 2
		end
		if TrinketMenuOptions.SetColumns == "ON" and TrinketMenuOptions.Columns then
			max_cols = TrinketMenuOptions.Columns
		end
		local item, icon
		for i = 1, TrinketMenu.NumberOfTrinkets do
			item = _G["TrinketMenu_Menu"..i]
			icon = _G["TrinketMenu_Menu"..i.."Icon"]
			icon:SetTexture(TrinketMenu.BaggedTrinkets[i].texture)
			if TrinketMenuPerOptions.Hidden[TrinketMenu.BaggedTrinkets[i].id] then
				icon:SetDesaturated(true)
			else
				icon:SetDesaturated(false)
			end
			item:SetPoint("TOPLEFT", "TrinketMenu_MenuFrame", TrinketMenuPerOptions.MenuDock, xpos, ypos)
			if TrinketMenuPerOptions.MenuOrient == "VERTICAL" then
				xpos = xpos + TrinketMenu.DockInfo("xdir") * 40
				col = col + 1
				if col == max_cols then
					xpos = TrinketMenu.DockInfo("xstart")
					col = 0
					ypos = ypos + TrinketMenu.DockInfo("ydir") * 40
					row = row + 1
				end
				item:Show()
			else
				ypos = ypos + TrinketMenu.DockInfo("ydir") * 40
				col = col + 1
				if col == max_cols then
					ypos = TrinketMenu.DockInfo("ystart")
					col = 0
					xpos = xpos + TrinketMenu.DockInfo("xdir") * 40
					row = row + 1
				end
				item:Show()
			end
		end
		for i = (TrinketMenu.NumberOfTrinkets + 1), TrinketMenu.MaxTrinkets do
			_G["TrinketMenu_Menu"..i]:Hide()
		end
		if col == 0 then
			row = row - 1
		end
		if TrinketMenuPerOptions.MenuOrient == "VERTICAL" then
			TrinketMenu_MenuFrame:SetWidth(12 + (max_cols * 40))
			TrinketMenu_MenuFrame:SetHeight(12 + ((row + 1) * 40))
		else
			TrinketMenu_MenuFrame:SetWidth(12 + ((row + 1) * 40))
			TrinketMenu_MenuFrame:SetHeight(12 + (max_cols * 40))
		end
		TrinketMenu.UpdateMenuCooldowns()
		TrinketMenu_MenuFrame:Show()
		TrinketMenu.StartTimer("MenuMouseover")
	end
end

function TrinketMenu.Initialize()
	local options = TrinketMenuOptions
	options.KeepDocked = options.KeepDocked or "ON" -- new option for 2.1
	options.Notify = options.Notify or "OFF" -- 2.1
	options.DisableToggle = options.DisableToggle or "OFF" -- new option for 2.2
	options.NotifyUsedOnly = options.NotifyUsedOnly or "OFF" -- 2.2
	options.NotifyChatAlso = options.NotifyChatAlso or "OFF" -- 2.2
	options.ShowTooltips = options.ShowTooltips or "ON" -- 2.3
	options.NotifyThirty = options.NotifyThirty or "OFF" -- 2.5
	options.SquareMinimap = options.SquareMinimap or "OFF" -- 2.6
	options.MenuOnShift = options.MenuOnShift or "OFF" -- 2.6
	options.TinyTooltips = options.TinyTooltips or "OFF" -- 3.0
	options.SetColumns = options.SetColumns or "OFF" -- 3.0
	options.Columns = options.Columns or 4 -- 3.0
	options.LargeCooldown = options.LargeCooldown or "OFF" -- 3.0
	options.ShowHotKeys = options.ShowHotKeys or "OFF" -- 3.0
	TrinketMenuPerOptions.ItemsUsed = TrinketMenuPerOptions.ItemsUsed or { } -- 3.0
	options.StopOnSwap = options.StopOnSwap or "OFF" -- 3.2
	options.HideOnLoad = options.HideOnLoad or "OFF" -- 3.4
	options.RedRange = options.RedRange or "OFF" -- 3.54
	options.HidePetBattle = options.HidePetBattle or "ON" -- 6.0.3
	TrinketMenuPerOptions.Alpha = TrinketMenuPerOptions.Alpha or 1 -- 3.5
	TrinketMenuPerOptions.Hidden = TrinketMenuPerOptions.Hidden or { }
	options.MenuOnRight = options.MenuOnRight or "OFF" -- 3.61
	if TrinketMenuPerOptions.XPos and TrinketMenuPerOptions.YPos then
		TrinketMenu_MainFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", TrinketMenuPerOptions.XPos, TrinketMenuPerOptions.YPos)
	end
	if TrinketMenuPerOptions.MainScale then
		TrinketMenu_MainFrame:SetScale(TrinketMenuPerOptions.MainScale)
	end
	if TrinketMenuPerOptions.MenuScale then
		TrinketMenu_MenuFrame:SetScale(TrinketMenuPerOptions.MenuScale)
	end
	TrinketMenu.ReflectAlpha()
	TrinketMenu_Trinket0:SetAttribute("type", "item")
	TrinketMenu_Trinket1:SetAttribute("type", "item")
	TrinketMenu_Trinket0:SetAttribute("slot", 13)
	TrinketMenu_Trinket1:SetAttribute("slot", 14)
	if TrinketMenu.QueueInit then
		-- alt has a special purpose if queue installed
		TrinketMenu_Trinket0:SetAttribute("alt-slot*", ATTRIBUTE_NOOP)
		TrinketMenu_Trinket1:SetAttribute("alt-slot*", ATTRIBUTE_NOOP)
	end
	TrinketMenu_Trinket0:SetAttribute("shift-slot*", ATTRIBUTE_NOOP)
	TrinketMenu_Trinket1:SetAttribute("shift-slot*", ATTRIBUTE_NOOP)
	TrinketMenu.ReflectMenuOnRight()
	TrinketMenu.InitTimers()
	TrinketMenu.CreateTimer("UpdateWornTrinkets", TrinketMenu.UpdateWornTrinkets, .75)
	TrinketMenu.CreateTimer("DockingMenu", TrinketMenu.DockingMenu, .2, 1)
	TrinketMenu.CreateTimer("MenuMouseover", TrinketMenu.MenuMouseover, .25, 1)
	TrinketMenu.CreateTimer("TooltipUpdate", TrinketMenu.TooltipUpdate, 1, 1)
	TrinketMenu.CreateTimer("CooldownUpdate", TrinketMenu.CooldownUpdate, 1, 1)
	TrinketMenu.CreateTimer("RedRange", TrinketMenu.RedRangeUpdate, .33, 1)
	--hooksecurefunc("UseInventoryItem", TrinketMenu.newUseInventoryItem)
	--hooksecurefunc("UseAction", TrinketMenu.newUseAction)
	TrinketMenu.InitOptions()
	TrinketMenu.UpdateWornTrinkets()
	TrinketMenu.DockWindows()
	TrinketMenu.OrientWindows()
	--if TrinketMenuOptions.NotifyThirty == "ON" or TrinketMenuOptions.Notify == "ON" then
		TrinketMenu.StartTimer("CooldownUpdate")
	--end
	TrinketMenu.ReflectRedRange()
	if TrinketMenuPerOptions.Visible == "ON" and (GetInventoryItemLink("player", 13) or GetInventoryItemLink("player", 14)) then
		TrinketMenu_MainFrame:Show()
	end
	-- fix for OmniCC by N00bZXI
	TrinketMenu_MainFrame:SetFrameLevel(1)
	TrinketMenu_MenuFrame:SetFrameLevel(1)
	TrinketMenu_Trinket0:SetFrameLevel(2)
	TrinketMenu_Trinket1:SetFrameLevel(2)
	for i = 1, 30 do
		_G["TrinketMenu_Menu"..i]:SetFrameLevel(2)
	end

end

function TrinketMenu.ReflectMenuOnRight()
	TrinketMenu_Trinket0:SetAttribute("slot2", TrinketMenuOptions.MenuOnRight == "ON" and ATTRIBUTE_NOOP or nil)
	TrinketMenu_Trinket1:SetAttribute("slot2", TrinketMenuOptions.MenuOnRight == "ON" and ATTRIBUTE_NOOP or nil)
end

-- returns true if the player is really dead or ghost, not merely FD
function TrinketMenu.IsPlayerReallyDead()
	return UnitIsDeadOrGhost("player")
end

function TrinketMenu.ItemInfo(slot)
	local _
	local link, id, name, equipLoc, texture = GetInventoryItemLink("player", slot)
	if link then
		local _, _, id = string.find(link, "item:(%d+)")
		name, _, _, _, _, _, _, _, equipLoc, texture = GetItemInfo(id)
	else
		_, texture = GetInventorySlotInfo("Trinket"..(slot - 13).."Slot")
	end
	return texture, name, equipLoc
end

function TrinketMenu.FindItem(name, includeInventory)
	if includeInventory then
		for i = 13, 14 do
			if string.find(GetInventoryItemLink("player", i) or "", name, 1, 1) then
				return i
			end
		end
	end
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			if string.find(GetContainerItemLink(i, j) or "", name, 1, 1) then
				return nil, i, j
			end
		end
	end
end

--[[ Frame Scripts ]]--

function TrinketMenu.OnLoad(self)
	SlashCmdList["TrinketMenuCOMMAND"] = TrinketMenu.SlashHandler
	SLASH_TrinketMenuCOMMAND1 = "/trinketmenu"
	SLASH_TrinketMenuCOMMAND2 = "/trinket"
	self:RegisterEvent("PLAYER_LOGIN")
end

local shown
function TrinketMenu.OnEvent(self, event, ...)
	if event == "UNIT_INVENTORY_CHANGED" then
		local unitID = ...
		if unitID == "player" then
			TrinketMenu.UpdateWornTrinkets()
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        TrinketMenu.UpdateWornTrinkets()
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
		TrinketMenu.UpdateWornCooldowns(1)
	elseif event == "PET_BATTLE_OPENING_START" then
		if TrinketMenuOptions.HidePetBattle == "ON" then
			shown = TrinketMenu_MainFrame:IsShown()
			if shown then
				TrinketMenu_MainFrame:Hide()
			end
		end
	elseif event == "PET_BATTLE_CLOSE" then
		if TrinketMenuOptions.HidePetBattle == "ON" and shown then
			TrinketMenu_MainFrame:Show()
		end
	elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_UNGHOST" or event == "PLAYER_ALIVE") and not TrinketMenu.IsPlayerReallyDead() then
		if TrinketMenu.CombatQueue[0] or TrinketMenu.CombatQueue[1] then
			TrinketMenu.EquipTrinketByName(TrinketMenu.CombatQueue[0], 13)
			TrinketMenu.EquipTrinketByName(TrinketMenu.CombatQueue[1], 14)
			TrinketMenu.CombatQueue[0] = nil
			TrinketMenu.CombatQueue[1] = nil
			TrinketMenu.UpdateCombatQueue()
		end
		TrinketMenu_OptMenuOnRight:Enable()
	elseif event == "UPDATE_BINDINGS" then
		TrinketMenu.KeyBindingsChanged()
	elseif event == "PLAYER_REGEN_DISABLED" then
		TrinketMenu_OptMenuOnRight:Disable()
	elseif event == "PLAYER_LOGIN" then
		TrinketMenu.LoadDefaults()
		TrinketMenu.Initialize()
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_UNGHOST")
		self:RegisterEvent("PLAYER_ALIVE")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")
        self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		self:RegisterEvent("UPDATE_BINDINGS")
		self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		self:RegisterEvent("PET_BATTLE_OPENING_START")
		self:RegisterEvent("PET_BATTLE_CLOSE")
	end
end

function TrinketMenu.UpdateWornTrinkets()
	local texture, name = TrinketMenu.ItemInfo(13)
	TrinketMenu_Trinket0Icon:SetTexture(texture)
	texture, name = TrinketMenu.ItemInfo(14)
	TrinketMenu_Trinket1Icon:SetTexture(texture)
	TrinketMenu_Trinket0Icon:SetDesaturated(false)
	TrinketMenu_Trinket0:SetChecked(false)
	TrinketMenu_Trinket1Icon:SetDesaturated(false)
	TrinketMenu_Trinket1:SetChecked(false)
	TrinketMenu.UpdateWornCooldowns()
	if TrinketMenu_MenuFrame:IsVisible() then
		TrinketMenu.BuildMenu()
	end
end

function TrinketMenu.SlashHandler(msg)
	local _, _, which, profile = string.find(msg, "load (.+) (.+)")
	if profile and TrinketMenu.SetQueue then
		which = string.lower(which)
		if which == "top" or which == "0" then
			which = 0
		elseif which == "bottom" or which == "1" then
			which = 1
		end
		if type(which) == "number" then
			TrinketMenu.SetQueue(which, "SORT", profile)
			return
		end
	end
	msg = string.lower(msg)
	if not msg or msg == "" then
		TrinketMenu.ToggleFrame(TrinketMenu_MainFrame)
	elseif string.find(msg, "^opt") or string.find(msg, "^config") then
		TrinketMenu.ToggleFrame(TrinketMenu_OptFrame)
	elseif msg == "lock" then
		TrinketMenuOptions.Locked = "ON"
		TrinketMenu.DockWindows()
		TrinketMenu.ReflectLock()
	elseif msg == "unlock" then
		TrinketMenuOptions.Locked = "OFF"
		TrinketMenu.DockWindows()
		TrinketMenu.ReflectLock()
	elseif msg == "reset" then
		TrinketMenu.ResetSettings()
	elseif string.find(msg, "alpha") then
		local _, _, alpha = string.find(msg, "alpha (.+)")
		alpha = tonumber(alpha)
		if alpha and alpha > 0 and alpha <= 1.0 then
			TrinketMenuPerOptions.Alpha = alpha
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00TrinketMenu alpha:")
			DEFAULT_CHAT_FRAME:AddMessage("trinket alpha (number) : set alpha from 0.1 to 1.0")
		end
		TrinketMenu.ReflectAlpha()
	elseif string.find(msg, "scale") then
		local _, _, menuscale = string.find(msg, "scale menu (.+)")
		if tonumber(menuscale) then
			TrinketMenu.FrameToScale = TrinketMenu_MenuFrame
			TrinketMenu.ScaleFrame(menuscale)
		end
		local _, _, mainscale = string.find(msg, "scale main (.+)")
		if tonumber(mainscale) then
			TrinketMenu.FrameToScale = TrinketMenu_MainFrame
			TrinketMenu.ScaleFrame(mainscale)
		end
		if not tonumber(menuscale) and not tonumber(mainscale) then
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00TrinketMenu scale:")
			DEFAULT_CHAT_FRAME:AddMessage("/trinket scale main (number) : set exact main scale")
			DEFAULT_CHAT_FRAME:AddMessage("/trinket scale menu (number) : set exact menu scale")
			DEFAULT_CHAT_FRAME:AddMessage("ie, /trinket scale menu 0.85")
			DEFAULT_CHAT_FRAME:AddMessage("Note: You can drag the lower-right corner of either window to scale.  This slash command is for those who want to set an exact scale.")
		end
		TrinketMenu.FrameToScale = nil
		TrinketMenuPerOptions.MainScale = TrinketMenu_MainFrame:GetScale()
		TrinketMenuPerOptions.MenuScale = TrinketMenu_MenuFrame:GetScale()
	elseif string.find(msg, "load") then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00TrinketMenu load:")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket load (top|bottom) profilename\nie: /trinket load bottom PvP")
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00TrinketMenu useage:")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket or /trinketmenu : toggle the window")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket reset : reset all settings")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket opt : summon options window")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket lock|unlock : toggles window lock")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket scale main|menu (number) : sets an exact scale")
		DEFAULT_CHAT_FRAME:AddMessage("/trinket load top|bottom profilename : loads a profile to top or bottom trinket")
	end
end

function TrinketMenu.ResetSettings()
	StaticPopupDialogs["TRINKETMENURESET"] = {
		text = "Are you sure you want to reset TrinketMenu to default state and reload the UI?",
		button1 = "Yes", button2 = "No", showAlert = 1, timeout = 0, whileDead = 1,
		OnAccept = function()
			TrinketMenuOptions = nil
			TrinketMenuPerOptions = nil
			TrinketMenuQueue = nil
			ReloadUI()
		end
	}
	StaticPopup_Show("TRINKETMENURESET")
end

--[[ Window Movement ]]--

function TrinketMenu.MainFrame_OnMouseUp(self)
	local arg1 = GetMouseButtonClicked()
	if arg1 == "LeftButton" then
		self:StopMovingOrSizing()
		TrinketMenuPerOptions.XPos = TrinketMenu_MainFrame:GetLeft()
		TrinketMenuPerOptions.YPos = TrinketMenu_MainFrame:GetTop()
	elseif TrinketMenuOptions.Locked == "OFF" then
		if TrinketMenuPerOptions.MainOrient == "VERTICAL" then
			TrinketMenuPerOptions.MainOrient = "HORIZONTAL"
		else
			TrinketMenuPerOptions.MainOrient = "VERTICAL"
		end
		TrinketMenu.OrientWindows()
	end
end

function TrinketMenu.MainFrame_OnMouseDown(self)
	if GetMouseButtonClicked() == "LeftButton" and TrinketMenuOptions.Locked == "OFF" then
		self:StartMoving()
	end
end

--[[ Timers ]]

function TrinketMenu.InitTimers()
	TrinketMenu.TimerPool = { }
	TrinketMenu.Timers = { }
end

function TrinketMenu.CreateTimer(name, func, delay, rep)
	TrinketMenu.TimerPool[name] = {func = func, delay = delay, rep = rep, elapsed = delay}
end

function TrinketMenu.IsTimerActive(name)
	for i, j in ipairs(TrinketMenu.Timers) do
		if j == name then
			return i
		end
	end
	return nil
end

function TrinketMenu.StartTimer(name, delay)
	TrinketMenu.TimerPool[name].elapsed = delay or TrinketMenu.TimerPool[name].delay
	if not TrinketMenu.IsTimerActive(name) then
		table.insert(TrinketMenu.Timers, name)
		TrinketMenu_TimersFrame:Show()
	end
end

function TrinketMenu.StopTimer(name)
	local idx = TrinketMenu.IsTimerActive(name)
	if idx then
		table.remove(TrinketMenu.Timers, idx)
		if #TrinketMenu.Timers < 1 then
			TrinketMenu_TimersFrame:Hide()
		end
	end
end

function TrinketMenu.TimersFrame_OnUpdate(elapsed)
	local timerPool
	for _, name in ipairs(TrinketMenu.Timers) do
		timerPool = TrinketMenu.TimerPool[name]
		timerPool.elapsed = timerPool.elapsed - elapsed
		if timerPool.elapsed < 0 then
			timerPool.func()
			if timerPool.rep then
				timerPool.elapsed = timerPool.delay
			else
				TrinketMenu.StopTimer(name)
			end
		end
	end
end

function TrinketMenu.TimerDebug()
	local on = "|cFF00FF00On"
	local off = "|cFFFF0000Off"
	DEFAULT_CHAT_FRAME:AddMessage("|cFF44AAFFTrinketMenu_TimersFrame is "..(TrinketMenu_TimersFrame:IsVisible() and on or off))
	for i in pairs(TrinketMenu.TimerPool) do
		DEFAULT_CHAT_FRAME:AddMessage(i.." is "..(TrinketMenu.IsTimerActive(i) and on or off))
	end
end

--[[ OnClicks ]]

function TrinketMenu.MainTrinket_OnClick(self)
	local arg1 = GetMouseButtonClicked()
	self:SetChecked(false)
    if IsAltKeyDown() and arg1 == "RightButton" then
        local which = self:GetID() - 13
        if TrinketMenu_OptFrame:IsVisible() and TrinketMenu.CurrentlySorting == which then
            TrinketMenu.ToggleFrame(TrinketMenu_OptFrame)
        else
            if not TrinketMenu_OptFrame:IsVisible() then
                TrinketMenu.ToggleFrame(TrinketMenu_OptFrame)
            end
            _G["TrinketMenu_Tab"..(3-which)]:Click()
        end
    elseif arg1 == "RightButton" and TrinketMenuOptions.MenuOnRight == "ON" then
		if TrinketMenu_MenuFrame:IsVisible() then
			TrinketMenu_MenuFrame:Hide()
		else
			TrinketMenu.BuildMenu()
		end
	elseif IsShiftKeyDown() then
		if ChatFrame1EditBox:IsVisible() then
			ChatFrame1EditBox:Insert(GetInventoryItemLink("player", self:GetID()))
		end
	elseif IsAltKeyDown() and TrinketMenu.QueueInit then
		local which = self:GetID() - 13
		if TrinketMenuQueue.Enabled[which] then
			TrinketMenu.CombatQueue[self:GetID() - 13] = nil
			TrinketMenuQueue.Enabled[which] = nil
		else
			TrinketMenuQueue.Enabled[which] = 1
		end
		TrinketMenu.ReflectQueueEnabled()
		-- toggle queue
		TrinketMenu.UpdateCombatQueue()
	else
		TrinketMenu.ReflectTrinketUse(self:GetID())
	end
end

function TrinketMenu.MenuTrinket_OnClick(self)
	local arg1 = GetMouseButtonClicked()
	self:SetChecked(false)
	local bag, slot = TrinketMenu.BaggedTrinkets[self:GetID()].bag
	local slot = TrinketMenu.BaggedTrinkets[self:GetID()].slot
	if IsShiftKeyDown() and ChatFrame1EditBox:IsVisible() then
		ChatFrame1EditBox:Insert(GetContainerItemLink(bag, slot))
	elseif IsAltKeyDown() then
		local _, _, itemID = string.find(GetContainerItemLink(bag, slot) or "", "item:(%d+)")
		if TrinketMenuPerOptions.Hidden[itemID] then
			TrinketMenuPerOptions.Hidden[itemID] = nil
		else
			TrinketMenuPerOptions.Hidden[itemID] = 1
		end
		TrinketMenu.BuildMenu()
	else
		local slot = (arg1 == "LeftButton") and 13 or 14
		if TrinketMenu.QueueInit then
			local _, _, canCooldown = GetContainerItemCooldown(TrinketMenu.BaggedTrinkets[self:GetID()].bag,TrinketMenu.BaggedTrinkets[self:GetID()].slot)
			if canCooldown == 0 or TrinketMenuOptions.StopOnSwap == "ON" then -- if incoming trinket can't go on cooldown
				TrinketMenuQueue.Enabled[slot - 13] = nil -- turn off autoqueue
				TrinketMenu.ReflectQueueEnabled()
			end
		end
		TrinketMenu.EquipTrinketByName(TrinketMenu.BaggedTrinkets[self:GetID()].name, slot)
		if not IsShiftKeyDown() and TrinketMenuOptions.KeepOpen == "OFF" then
			TrinketMenu_MenuFrame:Hide()
		end
	end
end

--[[ Docking ]]

function TrinketMenu.MenuFrame_OnMouseDown(button)
	if button == "LeftButton" and TrinketMenuOptions.Locked == "OFF" then
		TrinketMenu_MenuFrame:StartMoving()
		if TrinketMenuOptions.KeepDocked == "ON" then
			TrinketMenu.StartTimer("DockingMenu")
		end
	end
end

function TrinketMenu.MenuFrame_OnMouseUp(button)
	if button == "LeftButton" then
		TrinketMenu.StopTimer("DockingMenu")
		TrinketMenu_MenuFrame:StopMovingOrSizing()
		if TrinketMenuOptions.KeepDocked == "ON" then
			TrinketMenu.DockWindows()
		end
	elseif TrinketMenuOptions.Locked == "OFF" then
		if TrinketMenuPerOptions.MenuOrient == "VERTICAL" then
			TrinketMenuPerOptions.MenuOrient = "HORIZONTAL"
		else
			TrinketMenuPerOptions.MenuOrient = "VERTICAL"
		end
		TrinketMenu.BuildMenu()
	end
end

function TrinketMenu.DockingMenu()
	local main = TrinketMenu_MainFrame
	local menu = TrinketMenu_MenuFrame
	local mainscale = TrinketMenu_MainFrame:GetScale()
	local menuscale = TrinketMenu_MenuFrame:GetScale()
	local near = TrinketMenu.Near
	if near(main:GetRight() * mainscale,menu:GetLeft() * menuscale) then
		if near(main:GetTop() * mainscale,menu:GetTop() * menuscale) then
			TrinketMenuPerOptions.MainDock = "TOPRIGHT"
			TrinketMenuPerOptions.MenuDock = "TOPLEFT"
		elseif near(main:GetBottom() * mainscale,menu:GetBottom() * menuscale) then
			TrinketMenuPerOptions.MainDock = "BOTTOMRIGHT"
			TrinketMenuPerOptions.MenuDock = "BOTTOMLEFT"
		end
	elseif near(main:GetLeft() * mainscale,menu:GetRight() * menuscale) then
		if near(main:GetTop() * mainscale,menu:GetTop() * menuscale) then
			TrinketMenuPerOptions.MainDock = "TOPLEFT"
			TrinketMenuPerOptions.MenuDock = "TOPRIGHT"
		elseif near(main:GetBottom() * mainscale,menu:GetBottom() * menuscale) then
			TrinketMenuPerOptions.MainDock = "BOTTOMLEFT"
			TrinketMenuPerOptions.MenuDock = "BOTTOMRIGHT"
		end
	elseif near(main:GetRight() * mainscale,menu:GetRight() * menuscale) then
		if near(main:GetTop() * mainscale,menu:GetBottom() * menuscale) then
			TrinketMenuPerOptions.MainDock = "TOPRIGHT"
			TrinketMenuPerOptions.MenuDock = "BOTTOMRIGHT"
		elseif near(main:GetBottom() * mainscale,menu:GetTop() * menuscale) then
			TrinketMenuPerOptions.MainDock = "BOTTOMRIGHT"
			TrinketMenuPerOptions.MenuDock = "TOPRIGHT"
		end
	elseif near(main:GetLeft() * mainscale,menu:GetLeft() * menuscale) then
		if near(main:GetTop() * mainscale,menu:GetBottom() * menuscale) then
			TrinketMenuPerOptions.MainDock = "TOPLEFT"
			TrinketMenuPerOptions.MenuDock = "BOTTOMLEFT"
		elseif near(main:GetBottom() * mainscale,menu:GetTop() * menuscale) then
			TrinketMenuPerOptions.MainDock = "BOTTOMLEFT"
			TrinketMenuPerOptions.MenuDock = "TOPLEFT"
		end
	end
	TrinketMenu.ClearDocking()
	_G["TrinketMenu_MainDock_"..TrinketMenuPerOptions.MainDock]:Show()
	_G["TrinketMenu_MenuDock_"..TrinketMenuPerOptions.MenuDock]:Show()
end

function TrinketMenu.MenuMouseover()
	if (not MouseIsOver(TrinketMenu_MainFrame)) and (not MouseIsOver(TrinketMenu_MenuFrame)) and not IsShiftKeyDown() and (TrinketMenuOptions.KeepOpen == "OFF") then
		TrinketMenu.StopTimer("MenuMouseover")
		TrinketMenu_MenuFrame:Hide()
	end
end

--[[ Cooldowns ]]

function TrinketMenu.UpdateWornCooldowns(maybeGlobal)
	local start, duration, enable = GetInventoryItemCooldown("player", 13)
	CooldownFrame_Set(TrinketMenu_Trinket0Cooldown, start, duration, enable)
	start, duration, enable = GetInventoryItemCooldown("player", 14)
	CooldownFrame_Set(TrinketMenu_Trinket1Cooldown, start, duration, enable)
	if not maybeGlobal then
		TrinketMenu.WriteWornCooldowns()
	end
end

function TrinketMenu.UpdateMenuCooldowns()
	local start,duration,enable
	for i = 1, TrinketMenu.NumberOfTrinkets do
		start,duration,enable = GetContainerItemCooldown(TrinketMenu.BaggedTrinkets[i].bag, TrinketMenu.BaggedTrinkets[i].slot)
		CooldownFrame_Set(_G["TrinketMenu_Menu"..i.."Cooldown"], start, duration, enable)
	end
	TrinketMenu.WriteMenuCooldowns()
end

--[[ Item use ]]

function TrinketMenu.ReflectTrinketUse(slot)
	_G["TrinketMenu_Trinket"..(slot - 13)]:SetChecked(true)
	TrinketMenu.StartTimer("UpdateWornTrinkets")
	local _, _, id = string.find(GetInventoryItemLink("player", slot) or "", "item:(%d+)")
	if id then
		TrinketMenuPerOptions.ItemsUsed[id] = 0 -- 0 is an indeterminate state, cooldown will figure if it's worth watching
	end
end

function TrinketMenu.newUseInventoryItem(slot)
	if slot == 13 or slot == 14 and not MerchantFrame:IsVisible() then
		TrinketMenu.ReflectTrinketUse(slot)
	end
end

function TrinketMenu.newUseAction(slot)
	if IsEquippedAction(slot) then
		TrinketMenu_TooltipScan:SetOwner(WorldFrame, "ANCHOR_NONE")
		TrinketMenu_TooltipScan:SetAction(slot)
		local _, trinket0 = TrinketMenu.ItemInfo(13)
		local _, trinket1 = TrinketMenu.ItemInfo(14)
		if GameTooltipTextLeft1:GetText() == trinket0 then
			TrinketMenu.ReflectTrinketUse(13)
		elseif GameTooltipTextLeft1:GetText() == trinket1 then
			TrinketMenu.ReflectTrinketUse(14)
		end
	end
end

--[[ Tooltips ]]

function TrinketMenu.WornTrinketTooltip(self)
	if TrinketMenuOptions.ShowTooltips == "OFF" then
		return
	end
	local id = self:GetID()
	TrinketMenu.TooltipOwner = self
	TrinketMenu.TooltipType = "INVENTORY"
	TrinketMenu.TooltipSlot = id
	TrinketMenu.TooltipBag = TrinketMenu.CombatQueue[id - 13]
	TrinketMenu.StartTimer("TooltipUpdate", 0)
end

function TrinketMenu.MenuTrinketTooltip(self)
	if TrinketMenuOptions.ShowTooltips == "OFF" then
		return
	end
	local id = self:GetID()
	TrinketMenu.TooltipOwner = self
	TrinketMenu.TooltipType = "BAG"
	TrinketMenu.TooltipBag = TrinketMenu.BaggedTrinkets[id].bag
	TrinketMenu.TooltipSlot = TrinketMenu.BaggedTrinkets[id].slot
	TrinketMenu.StartTimer("TooltipUpdate", 0)
end

function TrinketMenu.ClearTooltip()
	GameTooltip:Hide()
	TrinketMenu.StopTimer("TooltipUpdate")
	TrinketMenu.TooltipType = nil
end

function TrinketMenu.AnchorTooltip(self)
	if TrinketMenuOptions.TooltipFollow == "ON" then
		if self.GetLeft and self:GetLeft() and self:GetLeft() < 400 then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		end
	else
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
	end
end

-- updates the tooltip created in the functions above
function TrinketMenu.TooltipUpdate()
	if TrinketMenu.TooltipType then
		local cooldown
		TrinketMenu.AnchorTooltip(TrinketMenu.TooltipOwner)
		if TrinketMenu.TooltipType == "BAG" then
			GameTooltip:SetBagItem(TrinketMenu.TooltipBag, TrinketMenu.TooltipSlot)
			cooldown = GetContainerItemCooldown(TrinketMenu.TooltipBag, TrinketMenu.TooltipSlot)
		else
			GameTooltip:SetInventoryItem("player", TrinketMenu.TooltipSlot)
			cooldown = GetInventoryItemCooldown("player", TrinketMenu.TooltipSlot)
		end
		TrinketMenu.ShrinkTooltip(TrinketMenu.TooltipOwner) -- if TinyTooltips on, shrink it
		if TrinketMenu.TooltipType == "INVENTORY" and TrinketMenu.TooltipBag then
			GameTooltip:AddLine("Queued: "..TrinketMenu.TooltipBag)
		end
		GameTooltip:Show()
		if cooldown == 0 then
			-- stop updates if this trinket has no cooldown
			TrinketMenu.TooltipType = nil
			TrinketMenu.StopTimer("TooltipUpdate")
		end
	end

end

-- normal tooltip for options
function TrinketMenu.OnTooltip(self, line1, line2)
	if TrinketMenuOptions.ShowTooltips == "ON" then
		TrinketMenu.AnchorTooltip(self)
		if line1 then
			GameTooltip:AddLine(line1)
			GameTooltip:AddLine(line2, .8, .8, .8, 1)
			GameTooltip:Show()
		else
			local name = self:GetName() or ""
			for i = 1, #TrinketMenu.CheckOptInfo do
				if name == "TrinketMenu_Opt"..TrinketMenu.CheckOptInfo[i][1] and TrinketMenu.CheckOptInfo[i][3] then
					TrinketMenu.OnTooltip(self, TrinketMenu.CheckOptInfo[i][3], TrinketMenu.CheckOptInfo[i][4])
				end
			end
			for i = 1, #TrinketMenu.TooltipInfo do
				if TrinketMenu.TooltipInfo[i][1] == name and TrinketMenu.TooltipInfo[i][2] then
					TrinketMenu.OnTooltip(self, TrinketMenu.TooltipInfo[i][2], TrinketMenu.TooltipInfo[i][3])
				end
			end
		end
	end
end

-- strip format reordering in global strings
TrinketMenu.ITEM_SPELL_CHARGES = string.gsub(ITEM_SPELL_CHARGES, "%%%d%$d", "%%d")

function TrinketMenu.ShrinkTooltip(owner)
	if TrinketMenuOptions.TinyTooltips == "ON" then
		local r, g, b = GameTooltipTextLeft1:GetTextColor()
		local name = GameTooltipTextLeft1:GetText()
		local line, cooldown, charge
		for i = 2, GameTooltip:NumLines() do
			line = _G["GameTooltipTextLeft"..i]
			if line:IsVisible() then
				line = line:GetText() or ""
				if string.find(line,COOLDOWN_REMAINING) then
					cooldown = line
				end
				if string.find(line,TrinketMenu.ITEM_SPELL_CHARGES) then
					charge = line
				end
			end
		end
		TrinketMenu.AnchorTooltip(owner)
		GameTooltip:AddLine(name, r, g, b)
		GameTooltip:AddLine(charge, 1, 1, 1)
		GameTooltip:AddLine(cooldown, 1, 1, 1)
	end
end

-- returns 1 if the item at bag(,slot) is an engineered trinket
function TrinketMenu.IsEngineered(bag, slot)
	local item = slot and GetContainerItemLink(bag, slot) or GetInventoryItemLink("player", bag)
	if item then
		local _, _, _, _, _, itemType, itemSubtype, _, itemLoc = GetItemInfo(item)
		if itemType == TrinketMenu.TRADE_GOODS and itemSubtype == TrinketMenu.DEVICES and itemLoc == "INVTYPE_TRINKET" then
			return 1
		end
		TrinketMenu_TooltipScan:SetOwner(WorldFrame, "ANCHOR_NONE")
		TrinketMenu_TooltipScan:SetHyperlink(item)
		for i = 1, TrinketMenu_TooltipScan:NumLines() do
			if string.match(_G["TrinketMenu_TooltipScanTextLeft"..i]:GetText() or "", TrinketMenu.REQUIRES_ENGINEERING) then
				return 1
			end
		end
	end
end

-- returns bag,slot of a free bag space, if one found.  engineering true if only looking for an engineering bag
function TrinketMenu.FindSpace(engineering)
	local bagType
	for i = 4, 0, -1 do
		bagType = (select(7, GetItemInfo(GetInventoryItemLink("player", 19 + i) or "")))
		if (engineering and bagType == TrinketMenu.ENGINEERING_BAG) or (not engineering and bagType == TrinketMenu.BAG) then
			for j = 1, GetContainerNumSlots(i) do
				if not GetContainerItemLink(i, j) then
					return i, j
				end
			end
		end
	end
end

--[[ Combat Queue ]]

function TrinketMenu.EquipTrinketByName(name, slot)
	if not name then return end
	if UnitAffectingCombat("player") or TrinketMenu.IsPlayerReallyDead() then
		-- queue trinket
		local queue = TrinketMenu.CombatQueue
		local which = slot - 13 -- 0 or 1
		if queue[which] == name and not imperative then
			queue[which] = nil
		elseif queue[1 - which] == name then
			queue[1 - which] = nil
			queue[which] = name
		else
			queue[which] = name
		end
	elseif not CursorHasItem() and not SpellIsTargeting() then
		local _, b, s = TrinketMenu.FindItem(name)
		if b then
			local _, _, isLocked = GetContainerItemInfo(b, s)
			if not isLocked and not IsInventoryItemLocked(slot) then
				-- neither container item nor inventory item locked, perform swap
				local directSwap = 1 -- assume a direct swap will happen
				if (select(7, GetItemInfo(GetInventoryItemLink("player", 19 + b) or ""))) == TrinketMenu.ENGINEERING_BAG then
					-- incoming trinket is in an engineering bag
					if not TrinketMenu.IsEngineered(slot) then
						-- outgoing trinket can't go inside it
						local freeBag,freeSlot = TrinketMenu.FindSpace()
						if freeBag then
							PickupInventoryItem(slot)
							PickupContainerItem(freeBag, freeSlot)
							PickupContainerItem(b, s)
							EquipCursorItem(slot)
							directSwap = nil
						end
					end
				elseif TrinketMenu.IsEngineered(slot) and not TrinketMenu.IsEngineered(b, s) then
					-- outgoing trinket is engineered, incoming trinket is not
					local freeBag, freeSlot = TrinketMenu.FindSpace(1)
					if freeBag then
						-- move outgoing trinket to engineering bag, equip incoming trinket
						PickupInventoryItem(slot)
						PickupContainerItem(freeBag, freeSlot)
						PickupContainerItem(b, s)
						EquipCursorItem(slot)
						directSwap = nil
					end
				end
				if directSwap then
					PickupContainerItem(b, s)
					PickupInventoryItem(slot)
				end
				_G["TrinketMenu_Trinket"..(slot - 13).."Icon"]:SetDesaturated(true)
				TrinketMenu.StartTimer("UpdateWornTrinkets") -- in case it's not equipped (stunned, etc)
			end
		end
	end
	TrinketMenu.UpdateCombatQueue()
end

function TrinketMenu.UpdateCombatQueue()
	local _, bag, slot
	for which = 0, 1 do
		local trinket = TrinketMenu.CombatQueue[which]
		local icon = _G["TrinketMenu_Trinket"..which.."Queue"]
		icon:Hide()
		if trinket then
			_, bag, slot = TrinketMenu.FindItem(trinket)
			if bag then
				icon:SetTexture(GetContainerItemInfo(bag, slot))
				icon:Show()
			end
		elseif TrinketMenu.QueueInit and TrinketMenuQueue and TrinketMenuQueue.Enabled[which] then
			icon:SetTexture("Interface\\AddOns\\TrinketMenu\\Textures\\TrinketMenu-Gear")
			icon:Show()
		end
	end
end

--[[ Notify ]]

function TrinketMenu.Notify(msg)
	PlaySound(4146)
	if MikSBT then -- send via MSBT if it exists
		MikSBT.DisplayMessage(msg, "Notification", true, 255, 0, 0, nil, nil, nil, nil)
	elseif SCT_Display then -- send via SCT if it exists
		SCT_Display(msg, {r = .2, g = .7, b = .9})
	elseif Parrot then -- send via Parrot if it exists
		Parrot:ShowMessage(msg, "Notification", true, 255, 0, 0, nil, nil, nil, nil)
	elseif xCT then -- send via xCT if it exists
		ct.frames[3]:AddMessage(msg, 255, 0, 0)
	elseif xCT_Plus then -- send via xCT+ if it exists
		xCT_Plus:AddMessage("general", msg, {1, 0, 0})
	elseif SHOW_COMBAT_TEXT == "1" then -- or default UI's SCT
		CombatText_AddMessage(msg, CombatText_StandardScroll, .2, .7, .9)
	else
		-- send vis UIErrorsFrame if neither SCT exists
		UIErrorsFrame:AddMessage(msg, .2, .7, .9, 1, UIERRORS_HOLD_TIME)
	end
	if TrinketMenuOptions.NotifyChatAlso == "ON" then
		DEFAULT_CHAT_FRAME:AddMessage("|cff33b2e5"..msg)
	end
end

function TrinketMenu.CooldownUpdate()
	local inv, bag, slot, start, duration, name, remain
	for i in pairs(TrinketMenuPerOptions.ItemsUsed) do
		start,duration = GetItemCooldown(i)
		if start and TrinketMenuPerOptions.ItemsUsed[i] < 3 then
			TrinketMenuPerOptions.ItemsUsed[i] = TrinketMenuPerOptions.ItemsUsed[i] + 1 -- count for 3 seconds before seeing if this is a real cooldown
		elseif start then
			if start > 0 then
				remain = duration - (GetTime() - start)
				if TrinketMenuPerOptions.ItemsUsed[i] < 5 then
					if remain > 29 then
						TrinketMenuPerOptions.ItemsUsed[i] = 30 -- first actual cooldown greater than 30 seconds, tag it for 30+0 notify
					elseif remain > 5 then
						TrinketMenuPerOptions.ItemsUsed[i] = 5 -- first actual cooldown less than 30 but greater than 5, tag for 0 notify
					end
				end
			end
			if TrinketMenuPerOptions.ItemsUsed[i] == 30 and start > 0 and remain < 30 then
				if TrinketMenuOptions.NotifyThirty == "ON" then
					name = GetItemInfo(i)
					if name then
						TrinketMenu.Notify(name.." ready soon!")
					end
				end
				TrinketMenuPerOptions.ItemsUsed[i] = 5 -- tag for just 0 notify now
			elseif TrinketMenuPerOptions.ItemsUsed[i] == 5 and start == 0 then
				if TrinketMenuOptions.Notify == "ON" then
					name = GetItemInfo(i)
					if name then
						TrinketMenu.Notify(name.." ready!")
					end
				end
			end
			if start == 0 then
				TrinketMenuPerOptions.ItemsUsed[i] = nil
			end
		end
	end
	-- update cooldown numbers
	if TrinketMenuOptions.CooldownCount == "ON" then
		if TrinketMenu_MainFrame:IsVisible() then
			TrinketMenu.WriteWornCooldowns()
		end
		if TrinketMenu_MenuFrame:IsVisible() then
			TrinketMenu.WriteMenuCooldowns()
		end
	end
	if TrinketMenu.PeriodicQueueCheck then
		TrinketMenu.PeriodicQueueCheck()
	end
end

function TrinketMenu.WriteWornCooldowns()
	local start, duration
	start, duration = GetInventoryItemCooldown("player", 13)
	TrinketMenu.WriteCooldown(TrinketMenu_Trinket0Time, start, duration)
	start, duration = GetInventoryItemCooldown("player", 14)
	TrinketMenu.WriteCooldown(TrinketMenu_Trinket1Time, start, duration)
end

function TrinketMenu.WriteMenuCooldowns()
	local start, duration
	for i = 1, TrinketMenu.NumberOfTrinkets do
		start, duration = GetContainerItemCooldown(TrinketMenu.BaggedTrinkets[i].bag, TrinketMenu.BaggedTrinkets[i].slot)
		TrinketMenu.WriteCooldown(_G["TrinketMenu_Menu"..i.."Time"], start, duration)
	end
end

function TrinketMenu.WriteCooldown(where, start, duration)
	local cooldown = duration - (GetTime() - start)
	if start == 0 or TrinketMenuOptions.CooldownCount == "OFF" then
		where:SetText("")
	elseif cooldown < 3 and not where:GetText() then
		-- this is a global cooldown. don't display it. not accurate but at least not annoying
	else
		where:SetText((cooldown < 60 and math.floor(cooldown + .5).." s") or (cooldown < 3600 and math.ceil(cooldown / 60).." m") or math.ceil(cooldown / 3600).." h")
	end
end

function TrinketMenu.OnShow()
	TrinketMenuPerOptions.Visible = "ON"
	if TrinketMenuOptions.KeepOpen == "ON" then
		TrinketMenu.BuildMenu()
	end
end

function TrinketMenu.OnHide()
	TrinketMenuPerOptions.Visible = "OFF"
	TrinketMenu_MenuFrame:Hide()
end

function TrinketMenu.ReflectAlpha()
	TrinketMenu_MainFrame:SetAlpha(TrinketMenuPerOptions.Alpha)
	TrinketMenu_MenuFrame:SetAlpha(TrinketMenuPerOptions.Alpha)
end

--[[ Key bindings ]]

function TrinketMenu.KeyBindingsChanged()
	if TrinketMenuOptions.ShowHotKeys == "ON" then
		local key
		for i = 0, 1 do
			key = GetBindingKey("CLICK TrinketMenu_Trinket"..i..":LeftButton")
			_G["TrinketMenu_Trinket"..i.."HotKey"]:SetText(GetBindingText(key or "", nil, 1))
		end
	else
		TrinketMenu_Trinket0HotKey:SetText("")
		TrinketMenu_Trinket1HotKey:SetText("")
	end
end

--[[ Monitor Range ]]

function TrinketMenu.ReflectRedRange()
	if TrinketMenuOptions.RedRange == "ON" then
		TrinketMenu.StartTimer("RedRange")
	else
		TrinketMenu.StopTimer("RedRange")
		TrinketMenu_Trinket0Icon:SetVertexColor(1, 1, 1)
		TrinketMenu_Trinket1Icon:SetVertexColor(1, 1, 1)
	end
end

function TrinketMenu.RedRangeUpdate()
	local item
	for i = 13, 14 do
		item = GetInventoryItemLink("player", i)
		if item and IsItemInRange(item) == 0 then
			_G["TrinketMenu_Trinket"..(i - 13).."Icon"]:SetVertexColor(1, .3, .3)
		else
			_G["TrinketMenu_Trinket"..(i - 13).."Icon"]:SetVertexColor(1, 1, 1)
		end
	end
end
