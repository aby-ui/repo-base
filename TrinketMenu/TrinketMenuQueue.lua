--[[ TrinketMenuQueue : auto queue system ]]

local _G, type, string, tonumber, table, pairs, select = _G, type, string, tonumber, table, pairs, select

TrinketMenu.PausedQueue = { } -- 0 or 1 whether queue is paused

function TrinketMenu.QueueInit()
	TrinketMenuQueue = TrinketMenuQueue or {
		Stats = { }, -- indexed by id of trinket, delay, priority and keep
		Sort = { }, -- indexed by number, ids in order of use
		Enabled = { } -- 0 or 1 whether auto queue is on for the slot
	}
	TrinketMenuQueue.Sort[0] = TrinketMenuQueue.Sort[0] or { }
	TrinketMenuQueue.Sort[1] = TrinketMenuQueue.Sort[1] or { }
	TrinketMenu_SubQueueFrame:SetBackdropBorderColor(.3, .3, .3,1)
	TrinketMenu_ProfilesFrame:SetBackdropBorderColor(.3, .3, .3, 1)
	TrinketMenu_ProfilesListFrame:SetBackdropBorderColor(.3, .3, .3, 1)
	TrinketMenu_SortPriorityText:SetText("Priority")
	TrinketMenu_SortPriorityText:SetTextColor(.95, .95, .95)
	TrinketMenu_SortKeepEquippedText:SetText("Pause Queue")
	TrinketMenu_SortKeepEquippedText:SetTextColor(.95, .95, .95)
	TrinketMenu_SortListFrame:SetBackdropBorderColor(.3, .3, .3, 1)
	TrinketMenu.ReflectQueueEnabled()
	TrinketMenu.UpdateCombatQueue()
	TrinketMenuQueue.Profiles = TrinketMenuQueue.Profiles or { }
	TrinketMenu.ValidateProfile()
	TrinketMenu.OpenSort(0)
	TrinketMenu.OpenSort(1)
end

function TrinketMenu.ReflectQueueEnabled()
	TrinketMenu_Trinket0Check:SetChecked(TrinketMenuQueue.Enabled[0])
	TrinketMenu_Trinket1Check:SetChecked(TrinketMenuQueue.Enabled[1])
end

function TrinketMenu.OpenSort(which)
	TrinketMenu.CurrentlySorting = which
	TrinketMenu.PopulateSort(which)
	TrinketMenu.SortSelected = 0
	TrinketMenu_SortScrollScrollBar:SetValue(0)
	TrinketMenu.SortValidate()
	TrinketMenu.SortScrollFrameUpdate()
end

function TrinketMenu.GetID(bag, slot)
	local _, id
	if slot then
		_, _, id = string.find(GetContainerItemLink(bag, slot) or "", "item:(%d+)")
	else
		_, _, id = string.find(GetInventoryItemLink("player", bag) or "", "item:(%d+)")
	end
	return id
end

function TrinketMenu.GetNameByID(id)
	if id == 0 then
		return "-- stop queue here --", "Interface\\Buttons\\UI-GroupLoot-Pass-Up", 1
	else
		local name, _, quality, _, _, _, _, _, _, texture = GetItemInfo(id or "")
		return name, texture, quality
	end
end

-- adds id to which sort if it's not already in the list
function TrinketMenu.AddToSort(which, id)
	if not id then
		return
	end
	local found
	for i = 1, #TrinketMenuQueue.Sort[which] do
		found = found or TrinketMenuQueue.Sort[which][i] == id
	end
	if not found then
		table.insert(TrinketMenuQueue.Sort[which], id)
	end
end

-- populates sorts adding any new trinkets
function TrinketMenu.PopulateSort(which)
	TrinketMenuQueue.Sort[which] = TrinketMenuQueue.Sort[which] or { }
	TrinketMenu.AddToSort(which,TrinketMenu.GetID(which + 13))
	TrinketMenu.AddToSort(which,TrinketMenu.GetID((1 - which) + 13))
	local _, equipLoc, id
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			id = TrinketMenu.GetID(i, j)
			_, _, _, _, _, _, _, _, equipLoc = GetItemInfo(id or "")
			if equipLoc=="INVTYPE_TRINKET" then
				TrinketMenu.AddToSort(which, id)
			end
		end
	end
	TrinketMenu.AddToSort(which, 0) -- id 0 is Stop
end

function TrinketMenu.SortScrollFrameUpdate()
	local offset = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll)
	local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
	FauxScrollFrame_Update(TrinketMenu_SortScroll, list and #list or 0, 9, 24)
	if list and list[1] then
		local r, g, b, found
		local texture, name, quality
		local item, itemName, itemIcon
		for i = 1, 9 do
			item = _G["TrinketMenu_Sort"..i]
			itemName = _G["TrinketMenu_Sort"..i.."Name"]
			itemIcon = _G["TrinketMenu_Sort"..i.."Icon"]
			idx = offset + i
			if idx <= #list then
				name, texture, quality = TrinketMenu.GetNameByID(list[idx])
				itemIcon:SetTexture(texture)
				itemName:SetText(name)
				if quality then -- GetItemInfo may not be valid early on after patches
					r, g, b = GetItemQualityColor(quality)
					itemName:SetTextColor(r, g, b)
					itemIcon:SetVertexColor(1, 1, 1)
				end
				item:Show()
				if idx == TrinketMenu.SortSelected then
					TrinketMenu.LockHighlight(item)
				else
					TrinketMenu.UnlockHighlight(item)
				end
			else
				item:Hide()
			end
		end
	end
end

function TrinketMenu.LockHighlight(frame)
	if type(frame) == "string" then
		frame = _G[frame]
	end
	if not frame then
		return
	end
	frame.lockedHighlight = 1
	_G[frame:GetName().."Highlight"]:Show()
end

function TrinketMenu.UnlockHighlight(frame)
	if type(frame) == "string" then
		frame = _G[frame]
	end
	if not frame then
		return
	end
	frame.lockedHighlight = nil
	_G[frame:GetName().."Highlight"]:Hide()
end

-- shows tooltip for items in the sort list
function TrinketMenu.SortTooltip(self)
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll) + self:GetID()
	local _
	local name, itemLink = GetItemInfo(TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][idx] or "")
	_, _, itemLink = string.find(itemLink or "","(item:%d+:%d+:%d+:%d+:%d+:%d+:%d+)")
	if itemLink and TrinketMenuOptions.ShowTooltips == "ON" then
		TrinketMenu.AnchorTooltip(self)
		GameTooltip:SetHyperlink(itemLink)
		GameTooltip:Show()
	else
		TrinketMenu.OnTooltip(self,"Stop Queue Here", "Move this to mark the lowest trinket to auto queue. Sometimes you may want a passive trinket with a click effect to be the end (Burst of Knowledge, Second Wind, etc).")
	end
end

function TrinketMenu.SortOnClick(self)
	TrinketMenu_SortDelay:ClearFocus()
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll) + self:GetID()
	if TrinketMenu.SortSelected == idx then
		TrinketMenu.SortSelected = 0
	else
		TrinketMenu.SortSelected = idx
	end
	TrinketMenu.SortScrollFrameUpdate()
	TrinketMenu.SortValidate()
end

-- turns move buttons on/off, moves the list to keep selected in view and keeps the sorting slot button highlighted
function TrinketMenu.SortValidate()
	local selected = TrinketMenu.SortSelected
	local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
	TrinketMenu_MoveTop:Enable()
	TrinketMenu_MoveUp:Enable()
	TrinketMenu_MoveDown:Enable()
	TrinketMenu_MoveBottom:Enable()
	if selected == 0 or #list < 2 then -- none selected, disable all
		TrinketMenu_MoveTop:Disable()
		TrinketMenu_MoveUp:Disable()
		TrinketMenu_MoveDown:Disable()
		TrinketMenu_MoveBottom:Disable()
	elseif selected == 1 then -- top selected, disable up
		TrinketMenu_MoveUp:Disable()
		TrinketMenu_MoveTop:Disable()
		TrinketMenu_MoveDown:Enable()
	elseif selected == #list then -- bottom selected, disable down
		TrinketMenu_MoveDown:Disable()
		TrinketMenu_MoveBottom:Disable()
	end
	local idx = FauxScrollFrame_GetOffset(TrinketMenu_SortScroll)
	if selected > 0 and list[selected] and list[selected] ~= 0 then
		TrinketMenu_SortDelay:Show()
		TrinketMenu_SortPriority:Show()
		TrinketMenu_SortKeepEquipped:Show()
		TrinketMenu_Delete:Enable()
	else
		TrinketMenu_SortDelay:Hide()
		TrinketMenu_SortPriority:Hide()
		TrinketMenu_SortKeepEquipped:Hide()
		TrinketMenu_Delete:Disable()
	end
	local stats = TrinketMenuQueue.Stats[list[TrinketMenu.SortSelected]]
	TrinketMenu_SortDelay:SetText(stats and (stats.delay or "0") or "0")
	TrinketMenu_SortPriority:SetChecked(stats and stats.priority)
	TrinketMenu_SortKeepEquipped:SetChecked(stats and stats.keep)
	if not IsShiftKeyDown() and selected > 0 then -- keep selected visible on list, moving thumb as needed, unless shift is down
		local parent = TrinketMenu_SortScrollScrollBar
		local offset
		if selected <= idx then
			offset = (selected == 1) and 0 or (parent:GetValue() - (parent:GetHeight() / 2))
			parent:SetValue(offset)
			PlaySound(1115)
		elseif selected >= (idx + 10) then
			offset = (selected == #list) and TrinketMenu_SortScroll:GetVerticalScrollRange() or (parent:GetValue() + (parent:GetHeight() / 2))
			parent:SetValue(offset)
			PlaySound(1115)
		end
	end
end

-- movement buttons
function TrinketMenu.SortMove(self)
	TrinketMenu_SortDelay:ClearFocus()
	local dir = ((self == TrinketMenu_MoveUp) and - 1) or ((self == TrinketMenu_MoveTop) and "top") or ((self == TrinketMenu_MoveDown) and 1) or ((self == TrinketMenu_MoveBottom) and "bottom")
	local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
	local idx1 = TrinketMenu.SortSelected
	if dir then
		local idx2 = ((dir == "top") and 1) or ((dir == "bottom") and #list) or idx1 + dir
		local temp = list[idx1]
		if tonumber(dir) then
			list[idx1] = list[idx2]
			list[idx2] = temp
		elseif dir == "top" then
			table.remove(list, idx1)
			table.insert(list, 1, temp)
		elseif dir == "bottom" then
			table.remove(list, idx1)
			table.insert(list, temp)
		end
		TrinketMenu.SortSelected = idx2
	elseif self == TrinketMenu_Profiles then
		TrinketMenu.SortSelected = 0
		TrinketMenu.ShowProfiles(TrinketMenu_SortListFrame:IsVisible())
	elseif self == TrinketMenu_Delete then
		table.remove(list, idx1)
		TrinketMenu.SortSelected = 0
	end
	TrinketMenu.SortValidate()
	TrinketMenu.SortScrollFrameUpdate()
end

function TrinketMenu.SortDelay_OnTextChanged()
	local delay = tonumber(TrinketMenu_SortDelay:GetText()) or 0
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or { }
	TrinketMenuQueue.Stats[id].delay = delay ~= 0 and delay or nil
end

function TrinketMenu.SortPriority_OnClick(self)
	local check = self:GetChecked()
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or { }
	TrinketMenuQueue.Stats[id].priority = check
end

function TrinketMenu.SortKeepEquipped_OnClick(self)
	local check = self:GetChecked()
	local id = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting][TrinketMenu.SortSelected]
	TrinketMenuQueue.Stats[id] = TrinketMenuQueue.Stats[id] or { }
	TrinketMenuQueue.Stats[id].keep = check
end

function TrinketMenu.TabCheck_OnClick(self)
	TrinketMenuQueue.Enabled[3 - self:GetID()] = self:GetChecked()
	TrinketMenu.UpdateCombatQueue()
end

--[[ Auto queue processing ]]

function TrinketMenu.TrinketNearReady(id)
    if id == 137362 and Aby_UnitDebuff("player", "督军的力竭") == nil then
        --print("TrinketNearReady", id, UnitDebuff("player", "督军的力竭"))
        --return 1
    end
	local start, duration = GetItemCooldown(id)
	if start == 0 or duration - (GetTime() - start) <= 30 then
		return 1
	end
end

function TrinketMenu.CanCooldown(inv)
	local _, _, enable = GetInventoryItemCooldown("player", inv)
	return enable == 1
end

-- this function quickly checks if conditions are right for a possible ProcessAutoQueue
function TrinketMenu.PeriodicQueueCheck()
	for i = 0, 1 do
		if TrinketMenuQueue.Enabled[i] then
			TrinketMenu.ProcessAutoQueue(i)
		end
	end
end

-- which = 0 or 1, decides if a trinket should be equipped and equips if so
function TrinketMenu.ProcessAutoQueue(which)
	local _, _, id, name = string.find(GetInventoryItemLink("player", 13 + which) or "", "item:(%d+).+%[(.+)%]")
	if not id then
		return
	end -- leave if no trinket equipped
	local start, duration, enable = GetInventoryItemCooldown("player", 13 + which)
	local timeLeft = GetTime() - start
    if id == "137362" then
        --print("ProcessAutoQueue", id, start, duration, UnitBuff("player", "督军的坚韧"))
        --return
    end
	local icon = _G["TrinketMenu_Trinket"..which.."Queue"]
	if IsInventoryItemLocked(13 + which) then
		return
	end -- leave if slot being swapped
	if UnitCastingInfo("player") then
		return
	end -- leave if player is casting
	if TrinketMenu.PausedQueue[which] then
		icon:SetVertexColor(1, .5, .5) -- leave if SetQueue(which, "PAUSE")
		return
	end
	local buff = GetItemSpell(id)
	if buff then
		if Aby_UnitAura("player",buff) or (start > 0 and (duration - timeLeft) > 30 and timeLeft < 1) then
			icon:SetDesaturated(true)
			return
		end
	end
	if TrinketMenuQueue.Stats[id] then
		if TrinketMenuQueue.Stats[id].keep then
			icon:SetVertexColor(1, .5, .5)
			return -- leave if .keep flag set on this item
		end
		if TrinketMenuQueue.Stats[id].delay then
			-- leave if currently equipped trinket is on cooldown for less than its delay
			if start > 0 and (duration - timeLeft) > 30 and timeLeft < TrinketMenuQueue.Stats[id].delay then
				icon:SetDesaturated(true)
				return
			end
		end
	end
	icon:SetDesaturated(false) -- normal queue operation, reflect that in queue inset
	icon:SetVertexColor(1, 1, 1)
	local name
	local ready = TrinketMenu.TrinketNearReady(id)
	if ready and TrinketMenu.CombatQueue[which] then
		TrinketMenu.CombatQueue[which] = nil
		TrinketMenu.UpdateCombatQueue()
	end
	local list, rank = TrinketMenuQueue.Sort[which]
	for i = 1, #list do
		if list[i] == 0 then
			rank = i
			break
		end
		if ready and list[i] == id then
			rank = i
			break
		end
	end
	if rank then
		for i = 1, rank do
			if not ready or enable == 0 or (TrinketMenuQueue.Stats[list[i]] and TrinketMenuQueue.Stats[list[i]].priority) then
				if TrinketMenu.TrinketNearReady(list[i]) then
					if GetItemCount(list[i]) > 0 and not IsEquippedItem(list[i]) then
						local _, bag, slot = TrinketMenu.FindItem(list[i])
						if bag then
							name = GetItemInfo(list[i])
							if TrinketMenu.CombatQueue[which] ~= name then
								TrinketMenu.EquipTrinketByName(name, 13 + which)
							end
							break
						end
					end
				end
			end
		end
	end
end

--[[ TrinketMenu.SetQueue and TrinketMenu.GetQueue ]]

-- These functions are for macros and mods to configure sort queues

-- TrinketMenu.SetQueue(0 or 1,"ON" or "OFF" or "PAUSE" or "RESUME" or "SORT"[,"sort list")
-- some examples:
-- TrinketMenu.SetQueue(1, "PAUSE") -- if queue is going, pause it
-- TrinketMenu.SetQueue(1, "RESUME") -- if queue is paused, resume it
-- TrinketMenu.SetQueue(1, "SORT", "Earthstrike", "Insignia of the Alliance", "Diamond Flask") -- set sort
-- TrinketMenu.SetQueue(0, "SORT", "Lifestone", "Darkmoon Card: Heroism") -- set sort for trinket 0
-- TrinketMenu.SetQueue(1, "SORT", "Pvp Profile") -- note you can replace list with a profile name
-- (a "stop the queue" is assumed at the end of the list)
function TrinketMenu.SetQueue(which, ...)
	local errorstub = "|cFFBBBBBBTrinketMenu:|cFFFFFFFF "
	if not which or not tonumber(which) or which < 0 or which > 1 then
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.."First parameter must be 0 for top trinket or 1 for bottom.")
		return
	end
	if (select("#", ...)) < 1 then
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.."Second parameter is either ON, OFF, PAUSE, RESUME or the beginning of a list of trinkets in a sort order.")
		return
	end
	if TrinketMenu_OptFrame:IsVisible() then
		TrinketMenu_OptFrame:Hide() -- close option frame if it's up. the mess otherwise would be scary
	end
	local cmd = (select(1, ...))
	if cmd == "ON" then
		TrinketMenuQueue.Enabled[which] = 1
		TrinketMenu.PausedQueue[which] = nil
	elseif cmd == "OFF" then
		TrinketMenuQueue.Enabled[which] = nil
		TrinketMenu.PausedQueue[which] = nil
	elseif cmd == "PAUSE" then
		TrinketMenu.PausedQueue[which] = 1
	elseif cmd == "RESUME" then
		TrinketMenu.PausedQueue[which] = nil
	elseif cmd == "SORT" and (select("#",...)) > 1 then
		local sortidx, inv, bag, slot, id = 1
		for i in pairs(TrinketMenuQueue.Sort[which]) do
			TrinketMenuQueue.Sort[which][i] = nil
		end
		--table.setn(TrinketMenuQueue.Sort[which], 0)
		local profile = TrinketMenu.GetProfileID((select(2,...)))
		if profile then
			for i = 2, #TrinketMenuQueue.Profiles[profile] do
				table.insert(TrinketMenuQueue.Sort[which], TrinketMenuQueue.Profiles[profile][i])
			end
		else
			for i = 2, (select("#", ...)) do
				inv, bag, slot = TrinketMenu.FindItem((select(i, ...)), 1) -- include inventory
				if inv then
					table.insert(TrinketMenuQueue.Sort[which], TrinketMenu.GetID(inv))
				elseif bag then
					table.insert(TrinketMenuQueue.Sort[which], TrinketMenu.GetID(bag, slot))
				else
					DEFAULT_CHAT_FRAME:AddMessage(errorstub.."Trinket or profile \""..(select(i, ...)).."\" not found.")
				end
			end
			table.insert(TrinketMenuQueue.Sort[which], 0)
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(errorstub.." Expected ON, OFF, PAUSE, RESUME or SORT+list")
	end
	TrinketMenu.ReflectQueueEnabled()
	TrinketMenu.UpdateCombatQueue()
end

-- returns 1 or nil if queue is enabled, and a table containing an ordered list of the trinkets
function TrinketMenu.GetQueue(which)
	if not which or not tonumber(which) or which < 0 or which > 1 then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFBBBBBBTrinketMenu.GetQueue:|cFFFFFFFF Parameter must be 0 for top trinket or 1 for bottom.")
		return
	end
	local trinketList, name = { }
	for i = 1, #TrinketMenuQueue.Sort[which] do
		name = TrinketMenu.GetNameByID(TrinketMenuQueue.Sort[which][i])
		table.insert(trinketList, name)
	end
	return TrinketMenuQueue.Enabled[which], trinketList
end

--[[ Profiles ]]

-- add="add" or "remove" to add or remove "frame" from UISpecialFrames
function TrinketMenu.Escable(frame, add)
	local found
	for i in pairs(UISpecialFrames) do
		found = found or (UISpecialFrames[i] == frame and i)
	end
	if not found and add == "add" then
		table.insert(UISpecialFrames, frame)
	elseif found and add == "remove" then
		table.remove(UISpecialFrames, found)
	end
end

-- shows profile if show non-nil. TrinketMenu_ProfilesFrame has an OnHide that calls this with nil
function TrinketMenu.ShowProfiles(show)
	local normalTexture = TrinketMenu_Profiles:GetNormalTexture()
	local pushedTexture = TrinketMenu_Profiles:GetPushedTexture()
	if show then
		TrinketMenu_SortListFrame:Hide()
		TrinketMenu_ProfilesFrame:Show()
		normalTexture:SetTexCoord(.875, 1, .25, .375)
		pushedTexture:SetTexCoord(.75, .875, .25, .375)
		TrinketMenu.Escable("TrinketMenu_ProfilesFrame", "add")
		TrinketMenu.Escable("TrinketMenu_OptFrame", "remove")
	else
		TrinketMenu_SortListFrame:Show()
		TrinketMenu_ProfilesFrame:Hide()
		pushedTexture:SetTexCoord(.875, 1, .25, .375)
		normalTexture:SetTexCoord(.75, .875, .25, .375)
		TrinketMenu.Escable("TrinketMenu_ProfilesFrame", "remove")
		TrinketMenu.Escable("TrinketMenu_OptFrame", "add")
	end
end

function TrinketMenu.ProfilesFrame_OnHide()
	PlaySound(624)
	TrinketMenu.ResetProfileSelected()
	TrinketMenu.ShowProfiles(nil)
end

function TrinketMenu.ResetProfileSelected()
	TrinketMenu.ProfileSelected = nil
	TrinketMenu_ProfileName:SetText("")
	TrinketMenu.ProfileScrollFrameUpdate()
	TrinketMenu.ValidateProfile()
end

function TrinketMenu.ProfileScrollFrameUpdate()
	local offset = FauxScrollFrame_GetOffset(TrinketMenu_ProfileScroll)
	local list = TrinketMenuQueue.Profiles
	FauxScrollFrame_Update(TrinketMenu_ProfileScroll, #(list) or 0, 7, 20)
	local item
	for i = 1, 7 do
		idx = offset + i
		item = _G["TrinketMenu_Profile"..i]
		if idx <= #list then
			_G["TrinketMenu_Profile"..i.."Name"]:SetText(list[idx][1])
			item:Show()
			if TrinketMenu.ProfileSelected == idx then
				item:LockHighlight()
			else
				item:UnlockHighlight()
			end
		else
			item:Hide()
		end
	end
	if #list == 0 then
		TrinketMenu_Profile1Name:SetText("No profiles saved yet.")
		TrinketMenu_Profile1:Show()
		TrinketMenu_Profile1:UnlockHighlight()
	end

end

function TrinketMenu.ProfileList_OnClick(self)
	if #TrinketMenuQueue.Profiles > 0 then
		local idx = self:GetID() + FauxScrollFrame_GetOffset(TrinketMenu_ProfileScroll)
		if TrinketMenu.ProfileSelected == idx then
			TrinketMenu.ProfileSelected = nil
			TrinketMenu_ProfileName:SetText("")
		else
			TrinketMenu.ProfileSelected = idx
			TrinketMenu_ProfileName:SetText(TrinketMenuQueue.Profiles[idx][1])
		end
		TrinketMenu.ProfileScrollFrameUpdate()
		TrinketMenu.ValidateProfile()
	end
end

function TrinketMenu.GetProfileID(name)
	for i = 1, #TrinketMenuQueue.Profiles do
		if TrinketMenuQueue.Profiles[i][1] == name then
			return i
		end
	end
end

function TrinketMenu.ValidateProfile()
	local name = TrinketMenu_ProfileName:GetText() or ""
	TrinketMenu_ProfilesDelete:Disable()
	TrinketMenu_ProfilesLoad:Disable()
	TrinketMenu_ProfilesSave:Disable()
	if TrinketMenu.GetProfileID(name) then
		TrinketMenu_ProfilesDelete:Enable()
		TrinketMenu_ProfilesLoad:Enable()
	end
	if strlen(name) > 0 then
		TrinketMenu_ProfilesSave:Enable()
	end
end

function TrinketMenu.ProfileName_OnTextChanged()
	TrinketMenu.ProfileSelected = TrinketMenu.GetProfileID(TrinketMenu_ProfileName:GetText())
	TrinketMenu.ProfileScrollFrameUpdate()
	TrinketMenu.ValidateProfile()
end

function TrinketMenu.ProfilesButton_OnClick(self)
	local idx = TrinketMenu.ProfileSelected
	local name = TrinketMenu_ProfileName:GetText() or ""
	if self == TrinketMenu_ProfilesDelete then
		if idx and TrinketMenuQueue.Profiles[idx] then
			table.remove(TrinketMenuQueue.Profiles, idx)
		end
		TrinketMenu.ResetProfileSelected()
	elseif self == TrinketMenu_ProfilesSave then
		if idx and TrinketMenuQueue.Profiles[idx] then
			table.remove(TrinketMenuQueue.Profiles, idx)
		end
		table.insert(TrinketMenuQueue.Profiles, 1, {name})
		local list = TrinketMenuQueue.Sort[TrinketMenu.CurrentlySorting]
		local save = TrinketMenuQueue.Profiles[1]
		for i = 1, #list do
			table.insert(save, list[i])
			if list[i] == 0 then
				break
			end
		end
		TrinketMenu_ProfilesFrame:Hide()
	elseif self == TrinketMenu_ProfilesLoad then
		TrinketMenu.LoadProfile(TrinketMenu.CurrentlySorting, idx)
	elseif self == TrinketMenu_ProfilesCancel then
		TrinketMenu_ProfilesFrame:Hide()
	end
end

function TrinketMenu.ProfileList_OnDoubleClick(self)
	if #TrinketMenuQueue.Profiles > 0 then
		local idx = self:GetID() + FauxScrollFrame_GetOffset(TrinketMenu_ProfileScroll)
		if TrinketMenuQueue.Profiles[idx] then
			TrinketMenu.LoadProfile(TrinketMenu.CurrentlySorting, idx)
		end
	end
end

function TrinketMenu.LoadProfile(which, idx)
	local list = TrinketMenuQueue.Sort[which]
	local load = TrinketMenuQueue.Profiles[idx]
	for i in pairs(list) do
		list[i] = nil
	end
	--table.setn(list, 0)
	for i = 2, #load do
		table.insert(list, load[i])
	end
	TrinketMenu_ProfilesFrame:Hide()
	TrinketMenu.OpenSort(which)
	if TrinketMenuOptions.HideOnLoad == "ON" then
		TrinketMenu_OptFrame:Hide()
	end
end
