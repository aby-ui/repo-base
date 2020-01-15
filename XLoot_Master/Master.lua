-- Create module
local addon, L = XLoot:NewModule("Master")
XLootMaster = addon
-- Grab locals
local print, wipe, match = print, table.wipe, string.match
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or _G.RAID_CLASS_COLORS
local hexColors = {}
local classesInRaid, class_players, classes_english = {}, {}, {}
local player_indices, index_name = {}, {}
local randoms = {}
local me = UnitName('player')
local my_index, banker_index, disenchanter_index
local candidate, color, lclass, className, slot, info, opt, eframe
-- Libraries
local LD

-------------------------------------------------------------------------------
-- Settings
local defaults = {
	profile = {
		menu_roll = true,
		menu_disenchant = true,
		menu_disenchanters = "",
		menu_bank = true,
		menu_bankers = "",
		menu_self = true,
		confirm_qualitythreshold = MASTER_LOOT_THREHOLD,
		award_qualitythreshold = 2,
		award_channel = 'AUTO',
		award_channel_secondary = 'NONE',
		award_guildannounce = false,
		award_special = true,
	}
}

-------------------------------------------------------------------------------
-- Module init
local eframe = CreateFrame("Frame")
function addon:OnInitialize()
	self:InitializeModule(defaults, eframe)
	opt = self.db.profile
	XLootMaster.opt = opt
	XLoot:SetSlashCommand("xlml", self.SlashHandler)
end

function addon:OnEnable()
	for i,class in ipairs(CLASS_SORT_ORDER) do
		classes_english[class] = true
	end
	
	for k, v in pairs(RAID_CLASS_COLORS) do
		hexColors[k] = "|c" .. v.colorStr
	end
	hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6*255, 0.6*255, 0.6*255)
	
	if CUSTOM_CLASS_COLORS then
		local function update()
			for k, v in pairs(CUSTOM_CLASS_COLORS) do
				hexColors[k] = "|c" .. v.colorStr
			end
		end
		CUSTOM_CLASS_COLORS:RegisterCallback(update)
		update()
	end
end

-- Utility functions
local function printall(...)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(string.join(", ",tostringall(...)))
	end
end
addon.printall = printall

local function dump(val)
	UIParentLoadAddOn("Blizzard_DebugTools")
	_G['xlminfostruct'] = val
	DevTools_DumpCommand('xlminfostruct')
	_G['xlminfostruct'] = nil
end
addon.dump = dump

local function OutChannel(channel)
	if channel == "NONE" then return end
	local out = channel
	if channel == "AUTO" then
		if IsInRaid() then
		  if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
		    out = "RAID_WARNING"
		  elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		    out = "INSTANCE_CHAT"
		  else
		    out = "RAID"
		  end
		elseif IsInGroup() then
		  if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		    out = "INSTANCE_CHAT"
		  else
		    out = "PARTY"
		  end
		else
			out = "SAY"
		end
	end
	return out
end

-- Addon functions
function addon.AnnounceAward(data)
	if data.quality >= opt.award_qualitythreshold then
		if data.special and not opt.award_special then return end
		local out = OutChannel(opt.award_channel)
		local text = (L.ITEM_AWARDED):format(data.pname,data.link)
		if data.special then
			text = text .. " ("..data.special..")"
		end
		if out then
			pcall(SendChatMessage, text, out)
		end
		local secondary = OutChannel(opt.award_channel_secondary)
		if secondary then
			pcall(SendChatMessage, text, secondary)
		end
		if opt.award_guildannounce and IsInGuild() then
			SendChatMessage(text, "GUILD")
		end
	end
end

function addon.GiveLoot(frame, special)
	local slot = LootFrame.selectedSlot
	local quality = LootFrame.selectedQuality
	local itemname = LootFrame.selectedItemName
	local id = frame.value
	local link = GetLootSlotLink(slot)	
	local pname = index_name[id]
	
	local data = { slot = slot, link = link, special = special, quality = quality, pname = pname, id = id  }
	local dialog
	
 	if ( quality >= opt.confirm_qualitythreshold ) then
 		dialog = StaticPopup_Show("CONFIRM_XLOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[quality].hex..itemname..FONT_COLOR_CODE_CLOSE, pname)
		if dialog then
			dialog.data = data
		end
 	else
		addon.AnnounceAward(data)
		GiveMasterLoot(slot, id)
 	end
	CloseDropDownMenus()
end

function addon.SpawnRoll(frame)
	DoMasterLootRoll(frame.value)
end

function addon.RaidRoll(frame, players)
	-- Bail when loot frame is closed, avoiding nil error. Should be done better.
	if not GetLootSlotLink(LootFrame.selectedSlot) then return nil end
	local to = #players
	local out = OutChannel("AUTO")
	if to >=1 then
		eframe:RegisterEvent("CHAT_MSG_SYSTEM")
		if out then
			SendChatMessage("Raid Roll:"..GetLootSlotLink(LootFrame.selectedSlot),out) -- localize this
			local k,names = 1,""
			for i=1,to do
				names = (k==1) and (i..":"..index_name[i]) or (names..", "..i..":"..index_name[i])
				if i==to or k==3 then
					SendChatMessage(names,out)
					names = ""
				end
				k = k<3 and k+1 or 1
			end
		end
 		RandomRoll(1,to)
 	end
end

function addon:CHAT_MSG_SYSTEM(...)
	local who, roll, from, to = XLoot.Deformat(..., RANDOM_ROLL_RESULT)
	if who == me then
		eframe.value = tonumber(roll)
		eframe:UnregisterEvent("CHAT_MSG_SYSTEM")
		addon.GiveLoot(eframe)
	end
end

function addon.AddMenuTitle(title)
	info.isTitle = nil
	info.text = title
	info.textHeight = 12
	info.notCheckable = 1
	info.disabled = 1
	info.disablecolor = YELLOW_FONT_COLOR_CODE
	info.notClickable = 1
	UIDropDownMenu_AddButton(info)
	info.notClickable = nil
	info.disablecolor = nil
end

function addon.AddMenuSeparator()
	info.disabled = 1
  info.text = ""
  info.hasArrow = nil
  UIDropDownMenu_AddButton(info, level)
end

function addon.BuildPartyMenu(level)
	-- In a party
	if level == 1 then
		for i=1, MAX_PARTY_MEMBERS+1, 1 do
			candidate,lclass,className = GetMasterLootCandidate(slot,i)
			index_name[i] = candidate
			if candidate then
				-- Add candidate button
				info.text = candidate
				info.colorCode = hexColors[className] or hexColors["UNKNOWN"]
				info.textHeight = 12
				info.value = i
				info.notCheckable = 1
				info.hasArrow = nil
				info.isTitle = nil
				info.disabled = nil
				info.func = addon.GiveLoot
				UIDropDownMenu_AddButton(info)
			end
		end
	end
end

function addon.BuildRaidMenuRecipients(level)
	if level == 1 then
		if (my_index and opt.menu_self) or (banker_index and opt.menu_bank) or (disenchanter_index and opt.menu_disenchant) then
			-- XLootMaster.AddMenuSeparator()
	    info.disabled = nil
			info.isTitle = nil
			info.text = L.RECIPIENTS
			info.colorCode = YELLOW_FONT_COLOR_CODE
			info.textHeight = 12
			info.hasArrow = 1
			info.notCheckable = 1
			info.value = "RECIPIENTS"
			info.func = nil
			info.disabled = nil
			UIDropDownMenu_AddButton(info)
		end
	elseif level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == "RECIPIENTS" then -- special recipients submenu
			if my_index then
				candidate,lclass,className = GetMasterLootCandidate(slot,my_index)
				if candidate and candidate == me then
					info.colorCode = hexColors[className] or hexColors["UNKNOWN"]
					info.isTitle = nil
					info.textHeight = 12
					info.value = my_index
					info.notCheckable = 1
					info.text = L.ML_SELF
					info.func = addon.GiveLoot
					info.arg1 = L.ML_SELF
					info.icon = "Interface\\GossipFrame\\VendorGossipIcon"
					UIDropDownMenu_AddButton(info,level)
				end
			end
			if banker_index and opt.menu_bank then
				candidate,lclass,className = GetMasterLootCandidate(slot,banker_index)
				if candidate and addon.listPriority(candidate, opt.menu_bankers) then
					info.colorCode = "|cffffffff"
					info.isTitle = nil
					info.textHeight = 12
					info.value = banker_index
					info.notCheckable = 1
					info.text = L.ML_BANKER.." ("..candidate..")"
					info.func = addon.GiveLoot
					info.arg1 = L.ML_BANKER
					info.icon = "Interface\\Minimap\\Tracking\\Banker"
					UIDropDownMenu_AddButton(info,level)
				end
			end
			if disenchanter_index and opt.menu_disenchant then
				candidate,lclass,className = GetMasterLootCandidate(slot,disenchanter_index)
				if candidate and addon.listPriority(candidate, opt.menu_disenchanters) then
					info.colorCode = "|cffffffff"
					info.isTitle = nil
					info.textHeight = 12
					info.value = disenchanter_index
					info.notCheckable = 1
					info.text = L.ML_DISENCHANTER.." ("..candidate..")"
					info.func = addon.GiveLoot
					info.arg1 = L.ML_DISENCHANTER
					info.icon = "Interface\\Buttons\\UI-GroupLoot-DE-Up"
					UIDropDownMenu_AddButton(info,level)
				end
			end
		end
	end
end

function addon.BuildMenuSpecialRolls(level)
	if level == 1 then
		info.isTitle = nil
		info.text = L.SPECIALROLLS
		info.colorCode = YELLOW_FONT_COLOR_CODE
		info.textHeight = 12
		info.hasArrow = 1
		info.notCheckable = 1
		info.value = "SPECIALROLLS"
		info.func = nil
		info.disabled = nil
		UIDropDownMenu_AddButton(info)		
	elseif level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == "SPECIALROLLS" then -- special rolls submenu
			info.colorCode = "|cffffffff"
			info.isTitle = nil
			info.textHeight = 12
			info.value = slot
			info.notCheckable = 1
			info.hasArrow = nil
			info.text = REQUEST_ROLL
			info.func = addon.SpawnRoll
			info.icon = "Interface\\Buttons\\UI-GroupLoot-Dice-Up"
			UIDropDownMenu_AddButton(info,level)
			
			if IsInRaid() and next(randoms) and opt.menu_roll then
				info.colorCode = "|cffffffff"
				info.isTitle = nil
				info.textHeight = 12
				info.value = randoms[math.random(1, #randoms)]
				info.notCheckable = 1
				info.text = L.ML_RANDOM
				info.func = addon.RaidRoll
 				info.arg1 = randoms
				info.icon = "Interface\\Buttons\\UI-GroupLoot-Coin-Up"
				UIDropDownMenu_AddButton(info,level)
			end
		end		
	end
end

function addon.normalize_toon_list(str)
	str = str:gsub("%s+",",")
	str = str:gsub("%p+",",")
	str = str:lower()
	return ","..str..","
end

function addon.listPriority(name, list)
	list = addon.normalize_toon_list(list)
	return select(1,list:find(addon.normalize_toon_list(name)))
end

function addon.BuildRaidMenu(level)
	-- In a raid
	if level == 1 then
		wipe(player_indices)
		wipe(index_name)
		wipe(classesInRaid)
		wipe(class_players)
		wipe(randoms)
		local disenchant_rank, bank_rank = 10000, 10000
		my_index, banker_index, disenchanter_index = nil,nil,nil
		for i = 1, MAX_RAID_MEMBERS do
			candidate,lclass,className = GetMasterLootCandidate(slot,i)
			if candidate then
				classesInRaid[className] = lclass
				table.insert(randoms, i)
				if candidate == me then
					my_index = i
				end
				local br = addon.listPriority(candidate, opt.menu_bankers)
				if br and br < bank_rank then
					banker_index = i
					bank_rank = br
				end
				local dr = addon.listPriority(candidate, opt.menu_disenchanters)
				if dr and dr < disenchant_rank then
					disenchanter_index = i
					disenchant_rank = dr
				end
				player_indices[candidate] = i
				index_name[i] = candidate
				if not class_players[className] then class_players[className] = {} end
				table.insert(class_players[className],candidate)
			end
		end
		for i, class in ipairs(CLASS_SORT_ORDER) do
			local cname = classesInRaid[class]
			if cname then
				info.isTitle = nil
				info.text = cname
				info.colorCode = hexColors[class] or hexColors["UNKNOWN"]
				info.textHeight = 12
				info.hasArrow = 1
				info.notCheckable = 1
				info.value = class
				info.func = nil
				info.disabled = nil
				UIDropDownMenu_AddButton(info)
			end
		end
		
		addon.BuildRaidMenuRecipients(level)
	
	elseif level == 2 then
		-- raid class menu
		if classes_english[UIDROPDOWNMENU_MENU_VALUE] then -- classes submenus
			if next(class_players[UIDROPDOWNMENU_MENU_VALUE]) then
				table.sort(class_players[UIDROPDOWNMENU_MENU_VALUE])
				for _,cand in ipairs(class_players[UIDROPDOWNMENU_MENU_VALUE]) do
					-- Add candidate button
					info.text = cand
					info.colorCode = hexColors[UIDROPDOWNMENU_MENU_VALUE] or hexColors["UNKNOWN"]
					info.textHeight = 12
					info.value = player_indices[cand]
					info.notCheckable = 1
					info.disabled = nil
					info.func = addon.GiveLoot
					UIDropDownMenu_AddButton(info,level)
				end
			end
		end
		
		addon.BuildRaidMenuRecipients(level)
		addon.BuildMenuSpecialRolls(level)
		
	end
end

function addon.DropdownInit()
	slot = LootFrame.selectedSlot or 0
	info = UIDropDownMenu_CreateInfo()
	
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		
		addon.AddMenuTitle(GIVE_LOOT)
		if ( IsInRaid() ) then
			addon.BuildRaidMenu(UIDROPDOWNMENU_MENU_LEVEL)
		else
			addon.BuildPartyMenu(UIDROPDOWNMENU_MENU_LEVEL)
		end
		-- XLootMaster.AddMenuSeparator()
		addon.BuildMenuSpecialRolls(UIDROPDOWNMENU_MENU_LEVEL)
		
 	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then

		addon.BuildRaidMenu(UIDROPDOWNMENU_MENU_LEVEL)

 	end	
end
UIDropDownMenu_Initialize(GroupLootDropDown, addon.DropdownInit, "MENU")


BINDING_HEADER_XLOOTMASTER = "XLootMaster"

StaticPopupDialogs["CONFIRM_XLOOT_DISTRIBUTION"] = {
	text = CONFIRM_LOOT_DISTRIBUTION,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self,data)
		addon.AnnounceAward(data)
		GiveMasterLoot(data.slot, data.id);
	end,
	timeout = 0,
	hideOnEscape = 1,
	preferredIndex = 3,
}

function addon.SlashHandler(msg)
	addon.ShowOptions()
end



