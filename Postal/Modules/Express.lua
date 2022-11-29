local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Express = Postal:NewModule("Express", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Express.description = L["Mouse click short cuts for mail."]
Postal_Express.description2 = L[ [[|cFFFFCC00*|r Shift-Click to take item/money from mail.
|cFFFFCC00*|r Ctrl-Click to return mail.
|cFFFFCC00*|r Alt-Click to move an item from your inventory to the current outgoing mail (same as right click in default UI).]] ]

local _G = getfenv(0)

-- WoW 10.0 Release Show/Hide Frame Handlers
function Postal_Express:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_Express:MAIL_SHOW() end
end

function Postal_Express:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(eventName, ...)
	local paneType = ...
	if paneType ==  Enum.PlayerInteractionType.MailInfo then Postal_Express:MAIL_CLOSED() end
end

function Postal_Express:MAIL_SHOW()
	if (Postal.db.profile.Express.EnableAltClick or Postal.db.profile.Express.BulkSend) and not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			self:HookScript(GameTooltip, "OnTooltipSetItem")
		else
			if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
				TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function (self, data)
					if self.OnTooltipSetItem then
						self:OnTooltipSetItem();
					end
				end)
			end
		end
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			self:RawHook("ContainerFrameItemButton_OnModifiedClick", true)
		end
		if Postal.WOWRetail then
			hooksecurefunc("HandleModifiedItemClick", Postal_Express.HandleModifiedItemClick)
		end
	end
	if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
		self:RegisterEvent("MAIL_CLOSED", "Reset")
	else
		Postal_Express:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", "Reset")
	end
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
end

function Postal_Express:MAIL_CLOSED()
end

function Postal_Express:Reset(event)
	if self:IsHooked(GameTooltip, "OnTooltipSetItem") then
		self:Unhook(GameTooltip, "OnTooltipSetItem")
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			self:Unhook("ContainerFrameItemButton_OnModifiedClick")
		end
	end
	if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
		self:UnregisterEvent("MAIL_CLOSED")
	else
		self:UnregisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
	end
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
end

function Postal_Express:OnEnable()
	self:RawHook("InboxFrame_OnClick", true)
	self:RawHook("InboxFrame_OnModifiedClick", "InboxFrame_OnClick", true) -- Eat all modified clicks too
	self:RawHook("InboxFrameItem_OnEnter", true)

	if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
		self:RegisterEvent("MAIL_SHOW")
	else
		Postal_Express:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW")
	end
end

-- Disabling modules unregisters all events/hook automatically
--function Postal_Express:OnDisable()
--end

local Postal_Express_cTip = CreateFrame("GameTooltip",'MailBagScanTooltip',nil,"GameTooltipTemplate")
local function Postal_Express_IsSoulbound(bag, slot)
    Postal_Express_cTip:SetOwner(UIParent, "ANCHOR_NONE")
    Postal_Express_cTip:SetBagItem(bag, slot)
    Postal_Express_cTip:Show()
    for i = 1,Postal_Express_cTip:NumLines() do
		local str = _G['MailBagScanTooltipTextLeft' .. i]
		if str and (str:GetText() == ITEM_SOULBOUND) then
            return true
        end
    end
    Postal_Express_cTip:Hide()
    return false
end

function Postal_Express:InboxFrameItem_OnEnter(this, motion)
	self.hooks["InboxFrameItem_OnEnter"](this, motion)
	local tooltip = GameTooltip

	local money, COD, _, hasItem, _, wasReturned, _, canReply = select(5, GetInboxHeaderInfo(this.index))
	if Postal.db.profile.Express.MultiItemTooltip and hasItem and hasItem > 1 then
		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local name, itemID, itemTexture, count, quality, canUse = GetInboxItem(this.index, i);
			if name then
				local itemLink = GetInboxItemLink(this.index, i) or name
				local tex = itemTexture and ("\124T%s:0\124t "):format(itemTexture) or ""
				if count > 1 then
					tooltip:AddLine(("%s%sx%d"):format(tex, itemLink, count))
				else
					tooltip:AddLine(("%s%s"):format(tex, itemLink))
				end
				-- this only works for first 10 items:
				--tooltip:AddTexture(itemTexture)
			end
		end
	end
	if (money > 0 or hasItem) and (not COD or COD == 0) then
		tooltip:AddLine(L["|cffeda55fShift-Click|r to take the contents."])
	end
	if not wasReturned and canReply then
		tooltip:AddLine(L["|cffeda55fCtrl-Click|r to return it to sender."])
	end
	tooltip:Show()
end

function Postal_Express:InboxFrame_OnClick(button, index)
	if IsShiftKeyDown() then
		local cod = select(6, GetInboxHeaderInfo(index))
		if cod <= 0 then
			AutoLootMailItem(index)
		end
		--button:SetChecked(not button:GetChecked())
	elseif IsControlKeyDown() then
		local wasReturned, _, canReply = select(10, GetInboxHeaderInfo(index))
		if not wasReturned and canReply then
			ReturnInboxItem(index)
		end
	else
		return self.hooks["InboxFrame_OnClick"](button, index)
	end
end

function Postal_Express:OnTooltipSetItem(tooltip, ...)
	local recipient = SendMailNameEditBox:GetText()
	if Postal.db.profile.Express.AutoSend and recipient ~= "" and SendMailFrame:IsVisible() and not CursorHasItem() then
		tooltip:AddLine(string.format(L["|cffeda55fAlt-Click|r to send this item to %s."], recipient))
	end
	if Postal.db.profile.Express.BulkSend and SendMailFrame:IsVisible() and not CursorHasItem() then
		tooltip:AddLine(L["|cffeda55fControl-Click|r to attach similar items."])
	end
end

function Postal_Express:ContainerFrameItemButtonOnModifiedClick(bag, slot, button)
	if button == "LeftButton" and IsAltKeyDown() and SendMailFrame:IsVisible() and not CursorHasItem() then
		local texture, count
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			texture = select(1, GetContainerItemInfo(bag, slot))
			count = select(2, GetContainerItemInfo(bag, slot))
		else
			if C_Container and C_Container.GetContainerItemInfo(bag, slot) then
				local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
				texture = itemInfo.iconFileID
				count = itemInfo.stackCount
			else
				texture = 0
				count = 0
			end
		end
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			PickupContainerItem(bag, slot)
		else
			C_Container.PickupContainerItem(bag, slot)
		end
		ClickSendMailItemButton()
		if Postal.db.profile.Express.AutoSend then
			for i = 1, ATTACHMENTS_MAX_SEND do
				-- get info about the attachment
				local itemName, itemID, itemTexture, stackCount, quality = GetSendMailItem(i)
				if SendMailNameEditBox:GetText() ~= "" and texture == itemTexture and count == stackCount then
					SendMailFrame_SendMail()
				end
			end
		end
	elseif button == "LeftButton" and IsControlKeyDown() and SendMailFrame:IsVisible() and not CursorHasItem() then
		local itemid
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			itemid = GetContainerItemID(bag, slot)
		else
			itemid = C_Container.GetContainerItemID(bag, slot)
		end
		if not itemid then return end
		local itemlocked
		if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
			itemlocked = select(3, GetContainerItemInfo(bag,slot))
		else
			if C_Container and C_Container.GetContainerItemInfo(bag,slot) then
				local itemInfo = C_Container.GetContainerItemInfo(bag,slot)
				itemlocked = itemInfo.isLocked
			else
				itemlocked = false
			end
		end
		local itemq, _,_, itemc, itemsc, _, itemes = select(3,GetItemInfo(itemid))
		itemes = itemes and #itemes > 0
		if Postal.db.profile.Express.BulkSend and itemq and itemc then
			local itemsinmail = 0
			for iloop = 1, ATTACHMENTS_MAX_SEND do
				if HasSendMailItem(iloop) then itemsinmail = itemsinmail + 1 end
			end
			-- itemc = itemq.."."..itemc
			itemsc = itemc.."."..(itemsc or "")
			local added = (itemlocked and 0) or -1
			for pass = 0,4 do
				local bmax = NUM_BAG_FRAMES
				if Postal.WOWRetail then
					bmax = bmax + NUM_REAGENTBAG_FRAMES
				end
				for b = 0,bmax do
					local numberOfSlots
					if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
						numberOfSlots = GetContainerNumSlots(b)
					else
						numberOfSlots = C_Container.GetContainerNumSlots(b)
					end
					for s = 1, numberOfSlots do
						local tid
						if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
							tid = GetContainerItemID(b, s)
						else
							tid = C_Container.GetContainerItemID(b, s)
						end
						local itemlocked2
						if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
							itemlocked2 = select(3, GetContainerItemInfo(b,s))
						else
							if C_Container and C_Container.GetContainerItemInfo(b,s) then
								local itemInfo = C_Container.GetContainerItemInfo(b,s)
								itemlocked2 = itemInfo.isLocked
							else
								itemlocked2 = false
							end
						end
						if not tid or itemlocked2 or Postal_Express_IsSoulbound(b, s) then
							-- item locked, already attached, soulbound
						else
							local tq, _,_, tc, tsc, _, tes = select(3,GetItemInfo(tid))
							-- tc = (tq or "").."."..(tc or "")
							tsc = (tc or "").."."..(tsc or "")
							tes = tes and #tes > 0
							if (pass == 0 and itemq == 0 and tq == 0) -- vendor trash
							or (pass == 0 and itemq == 2 and tq == 2 and itemes and tes) -- green boe gear
							or (pass == 1 and tid == itemid) -- identical items
							or (pass == 2 and tsc == itemsc) -- same subtype
							or (pass == 3 and tc == itemc)   -- same type
							or (pass == 4 and tq == itemq)   -- same quality
							then
								ClearCursor()
								if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
									PickupContainerItem(b, s)
								else
									C_Container.PickupContainerItem(b, s)
								end
								ClickSendMailItemButton()
								local itemlocked3
								if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
									itemlocked3 = select(3, GetContainerItemInfo(b,s))
								else
									if C_Container and C_Container.GetContainerItemInfo(b,s) then
										local itemInfo = C_Container.GetContainerItemInfo(b,s)
										itemlocked3 = itemInfo.isLocked
									else
										itemlocked3 = false
									end
								end
								if itemlocked3 then -- now locked => added
									added = added + 1
									itemsinmail = itemsinmail + 1
									if itemsinmail >= ATTACHMENTS_MAX_SEND then
										ClearCursor()
										return
									end
								else -- failed
									ClearCursor()
								end
							end
						end
					end
				end
				if added >= 1 then break end
			end
			ClearCursor()
		end
	else
		return
	end
end

function Postal_Express:ContainerFrameItemButton_OnModifiedClick(this, button, ...)
	local bag, slot = this:GetParent():GetID(), this:GetID()
	Postal_Express:ContainerFrameItemButtonOnModifiedClick(bag, slot, button)	
	return self.hooks["ContainerFrameItemButton_OnModifiedClick"](this, button, ...)
end

function Postal_Express.HandleModifiedItemClick(itemLink, itemLocation)
	if itemLocation ~= nil then -- item location is only not nil for bag item clicks
		local button = GetMouseButtonClicked()
		local bag, slot = itemLocation.bagID, itemLocation.slotIndex
		Postal_Express:ContainerFrameItemButtonOnModifiedClick(bag, slot, button)
	end
end

function Postal_Express.SetEnableAltClick(dropdownbutton, arg1, arg2, checked)
	local self = Postal_Express
	Postal.db.profile.Express.EnableAltClick = checked
	if checked then
		if MailFrame:IsVisible() and not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
			self:HookScript(GameTooltip, "OnTooltipSetItem")
			if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
				self:RawHook("ContainerFrameItemButton_OnModifiedClick", true)
			end
		end
	else
		if not Postal.db.profile.Express.BulkSend and self:IsHooked(GameTooltip, "OnTooltipSetItem") then
			self:Unhook(GameTooltip, "OnTooltipSetItem")
			if Postal.WOWClassic or Postal.WOWBCClassic or Postal.WOWWotLKClassic then
				self:Unhook("ContainerFrameItemButton_OnModifiedClick")
			end	
		end
	end
	-- A hack to get the next button to disable/enable
	local i, j = string.match(dropdownbutton:GetName(), "DropDownList(%d+)Button(%d+)")
	j = tonumber(j) + 1
	if checked then
		_G["DropDownList"..i.."Button"..j]:Enable()
		_G["DropDownList"..i.."Button"..j.."InvisibleButton"]:Hide()
	else
		_G["DropDownList"..i.."Button"..j]:Disable()
		_G["DropDownList"..i.."Button"..j.."InvisibleButton"]:Show()
	end
end

function Postal_Express.SetAutoSend(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.Express.AutoSend = checked
end

function Postal_Express.SetBulkSend(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.Express.BulkSend = checked
    local self = Postal_Express
    if checked then
   		if MailFrame:IsVisible() and not self:IsHooked(GameTooltip, "OnTooltipSetItem") then
   			self:HookScript(GameTooltip, "OnTooltipSetItem")
   			self:RawHook("ContainerFrameItemButton_OnModifiedClick", true)
   		end
   	else
   		if not Postal.db.profile.Express.EnableAltClick and self:IsHooked(GameTooltip, "OnTooltipSetItem") then
   			self:Unhook(GameTooltip, "OnTooltipSetItem")
   			self:Unhook("ContainerFrameItemButton_OnModifiedClick")
   		end
   	end
end

function Postal_Express.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	info.isNotRadio = 1
	if level == 1 + self.levelAdjust then
		local db = Postal.db.profile.Express
		info.keepShownOnClick = 1

		info.text = L["Enable Alt-Click to send mail"]
		info.func = Postal_Express.SetEnableAltClick
		info.checked = db.EnableAltClick
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Auto-Send on Alt-Click"]
		info.func = Postal_Express.SetAutoSend
		info.checked = db.AutoSend
		info.disabled = not Postal.db.profile.Express.EnableAltClick
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Auto-Attach similar items on Control-Click"]
		info.func = Postal_Express.SetBulkSend
		info.checked = db.BulkSend
		info.disabled = nil
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Add multiple item mail tooltips"]
		info.func = Postal.SaveOption
		info.checked = db.MultiItemTooltip
		info.arg1 = "Express"
		info.arg2 = "MultiItemTooltip"
		info.disabled = nil
		UIDropDownMenu_AddButton(info, level)
	end
end
