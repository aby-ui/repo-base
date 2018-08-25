--[[---------------------------------------
	Loot button click hook
	- row: Loot row
	- button: Mouse button
	- handled: True if any previous caller acted on event

	Hook like this:
	local XLootButtonOnClick_Orig = XLootButtonOnClick
	function XLootButtonOnClick(row, button, handled)
		if not handled and thing_i_want_to_check then
			handled = true
			dostuff()
		end
		XLootButtonOnClick_Orig(row, button, handled)
	end
--]]---------------------------------------

-- Include QDKP2 compatibility by request
function XLootButtonOnClick(row, button, handled)
	if not handled 
		and QDKP2_IsManagingSession
		and IsAltKeyDown()
		and button == 'LeftButton'
		and GetLootSlotLink(row.slot)
		and QDKP2_IsManagingSession()
		and row.quality > GetLootThreshold()
		and (not QDKP2_BidM_isBidding())
	then
		pcall(QDKP2_BidM_StartBid, row.item)
		if QDKP2GUI_Roster then
			QDKP2GUI_Roster:ChangeList('bid')
			QDKP2GUI_Roster:Show()
		end
		return true
	end
	return handled
end

-- Create module
local addon, L = XLoot:NewModule("Frame")
-- Prepare frame/global
local XLootFrame = CreateFrame("Frame", "XLootFrame", UIParent)
XLootFrame.addon = addon
-- Grab locals
local mouse_focus, opt

-- Chat output
local print, wprint = print, print
local function xprint(text)
	wprint(('%s: %s'):format('|c2244dd22XLoot|r', tostring(text)))
end

-- Performance blah blah blah
-- Using this function is a pain in the ass.
local BIND_ON_NONE = 0
local BIND_ON_PICKUP = 1
local BIND_ON_EQUIP = 2
local function GetItemInfoTable(link)
	-- Variable names match wowpedia documentation
	local name, link, rarity, level, minLevel, type, subType, stackCount, equipLoc, fileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(link)
	if not name then return nil end
	-- But table names match common usage
	return {
		name = name,
		link = link,
		quality = rarity,
		level = level,
		minLevel = minLevel,
		typeName = type, -- type and subType are localzied
		subTypeName = subType,
		stackCount = stackCount,
		equipLoc = equipLoc,
		icon = fileDataID,
		sellPrice = itemSellPrice,
		typeID = itemClassID, -- class and subClass are not
		subTypeID = itemSubClassID,
		bindType = bindType, -- NONE|PICKUP|EQUIP|?
		-- expacID = expacID,
		-- itemSetID = itemSetID,
		isCraftingReagent = isCraftingReagent
	}
end

-------------------------------------------------------------------------------
-- Settings

local defaults = {
	profile = {
		frame_scale = 1.0,
		frame_alpha = 1.0,

		quality_color_frame = false,
		quality_color_slot = true,

		loot_texts_info = true,
		loot_texts_bind  = true,
		loot_texts_lock = true,

		loot_buttons_auto = true,

		font = STANDARD_TEXT_FONT,
		font_size_loot = 12,
		font_size_info = 10,
		font_size_quantity = 10,
		font_size_bottombuttons = 10,
		font_size_button_auto = 8,
		font_flag = "OUTLINE",

		loot_icon_size = 34,
		loot_row_height = 30,

		loot_highlight = true,
		 
		loot_alpha = 1.0,
		loot_collapse = false,
		
		frame_snap = true,
		frame_snap_offset_x = 0,
		frame_snap_offset_y = 0,
		frame_grow_upwards = false, -- Actually means "Snap to bottom item"

		loot_padding_top = 10,
		loot_padding_left = 10,
		loot_padding_right = 10,
		loot_padding_bottom = 10,
		
		frame_width_automatic = true,
		frame_width = 150,

		frame_position_x = GetScreenWidth()/2,
		frame_position_y = GetScreenHeight()/2,

		autoloots = {
			currency = 'never',
			tradegoods = 'never',
			quest = 'never',
			list = 'solo',
			all = 'never',
		},

		autoloot_item_list = '',
		
		frame_draggable = true,

		linkall_threshold = 2, -- Quality from 0 - 6, Poor - Artifact
		linkall_channel = 'RAID',
		linkall_show = 'group',

		old_close_button = false,

		frame_color_border = { .5, .5, .5, 1 },
		frame_color_backdrop = { 0, 0, 0, .7 },
		frame_color_gradient = { .5, .5, .5, .3 },
		loot_color_border = { .5, .5, .5, 1 },
		loot_color_backdrop = { 0, 0, 0, .9 },
		loot_color_gradient = { .5, .5, .5, .4 },
		loot_color_info = { .5, .5, .5, 1 },
		loot_color_button_auto = { .4, .8, .4, .6 },

		show_slot_errors = true,
	}
}

-------------------------------------------------------------------------------
-- Module init

function addon:OnInitialize()
	self:InitializeModule(defaults, XLootFrame)
	opt = self.db.profile
	XLootFrame.opt = opt
end

function addon:OnEnable()
	-- Register events
	XLootFrame:RegisterEvent("LOOT_OPENED")
	XLootFrame:RegisterEvent("LOOT_CLOSED")
	XLootFrame:RegisterEvent("LOOT_SLOT_CLEARED")
	XLootFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
	XLootFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

	-- Disable default frame
	LootFrame:UnregisterEvent("LOOT_OPENED")
	LootFrame:UnregisterEvent("LOOT_CLOSED")
	LootFrame:UnregisterEvent("LOOT_SLOT_CLEARED")

	-- Register for escape close
	table.insert(UISpecialFrames, "XLootFrame")
	
	-- Reattach master looter frame
	MasterLooterFrame:SetScript('OnShow', 
	function(self)
		if XLootFrame:IsVisible() then 
			MasterLooterFrame:SetFrameLevel(XLootFrame:GetFrameLevel()+2)
			MasterLooterFrame:ClearAllPoints()
			MasterLooterFrame:SetPoint("BOTTOM",XLootFrame,"TOP")
		end
	end)
end

local preview_loot = {
	{ 52722, false, true, true },
	{ 31304, true, false, false },
	{ 37254, true, false, false },
	{ 13262, true, false, false },
	{ 15487, false, false, false }
}

for i=1,#preview_loot do
	XLootTooltip:SetItemByID(preview_loot[i][1])
	GetItemInfo(preview_loot[i][1])
end

function addon:ApplyOptions(in_options)
	opt, XLootFrame.opt = self.opt, self.opt
	if XLootFrame.built then
		XLootFrame:UpdateAppearance()
		XLootFrame:Update(true)
	end
	XLootFrame:ParseAutolootList()
	-- Update preview frame in options
	if in_options then
		local Fake = XLootFakeFrame
		Fake.opt = opt
		Fake:UpdateAppearance()
		local slot, max_width, max_quality = 0, 0, 0
		for i,v in ipairs(preview_loot) do
			local t = GetItemInfoTable(v[1])
			-- local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v[1])
			if not t then
				-- xprint("Error: Failed to get information for an item in the configuration preview window. Please re-open the options window in a moment.")
			else
				t.quantity = 1
				t.slotType = LOOT_SLOT_ITEM
				slot = slot + 1
				local row = Fake.rows[slot]
				row.item = t.link
				row.quality = t.quality
				Fake.slots[slot] = row
				max_width = math.max(max_width, row:Update(t))
				max_quality = math.max(max_quality, t.quality)
			end
		end
		do
			local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered, rarity = GetCurrencyInfo(828)
			if name and texture then
				local row =  Fake.rows[slot+1]
				max_width = math.max(max_width, row:Update({
					name = name,
					icon = texture,
					quality = rarity,
					slotType = LOOT_SLOT_CURRENCY,
					quantity = 5,
				}))
				Fake.slots[#preview_loot+1] = row
			end
		end
		Fake:SizeAndColor(max_width, max_quality)
	end
end

function addon:OnOptionsShow(panel)
	-- Create preview frame
	local frame = XLootFakeFrame
	if not frame then
		frame = CreateFrame('Frame', 'XLootFakeFrame', panel)
		frame.fake = true
		frame.opt = XLootFrame.opt
		self:BuildLootFrame(frame)
		frame:SetPoint('TOPLEFT', panel, 'TOPRIGHT', 25, 25)
		self:ApplyOptions(true)
	end
	frame:Show()
end

function addon:OnOptionsHide(panel)
	XLootFakeFrame:Hide()
end

local IsGroupState = {
	always = function() return true end,
	never = function() return false end,
	raid = IsInRaid,
	group = IsInGroup,
	party = function() return IsInGroup() and not IsInRaid() end,
	solo = function() return not IsInGroup() end
}

-------------------------------------------------------------------------------
-- Link All

local LinkLoot, LinkDropdown
do
	local output = { }
	function LinkLoot(channel, isExtraChannel)
		local output, key, buffer = output, 1
		local sf = string.format

		if UnitExists('target') then
			output[1] = sf('%s:', UnitName('target'))
		end

		local linkthreshold, reached = opt.linkall_threshold
		for i=1, GetNumLootItems() do
			if GetLootSlotType(i) == LOOT_SLOT_ITEM then 
				local texture, item, quantity, rarity = GetLootSlotInfo(i)
				local link = GetLootSlotLink(i)
				if rarity >= linkthreshold then
					reached = true
					buffer = sf('%s%s%s', (output[key] and output[key].." " or ""), (quantity > 1 and quantity.."x" or ""), link)
					if strlen(buffer) > 255 then
						key = key + 1
						output[key] = (quantity > 1 and quantity.."x" or "")..link
					else
						output[key] = buffer
					end
				end
			end
		end

		if not reached then
			xprint(L.linkall_threshold_missed)
			return false
		end
		if (channel == 'RAID' or channel == 'RAID_WARNING') and not IsInRaid() and IsInGroup() then
			channel = 'PARTY'
		end
		for k, v in pairs(output) do
			v  = string.gsub(v, "\n", " ", 1, true) -- DIE NEWLINES, DIE A HORRIBLE DEATH
			SendChatMessage(v, channel)
			output[k] = nil
		end

		return true
	end

	
	local function Click(dropdown, channel)
		LinkLoot(channel)
	end
	
	LinkDropdown = CreateFrame('Frame', 'XLootLinkDropdown')
	LinkDropdown.displayMode = 'MENU'
	local channels = {
		{ 'SAY', CHAT_MSG_SAY },
		{ 'PARTY', CHAT_MSG_PARTY },
		{ 'RAID', CHAT_MSG_RAID },
		{ 'RAID_WARNING', CHAT_MSG_RAID_WARNING },
		{ 'GUILD', CHAT_MSG_GUILD },
		{ 'OFFICER', CHAT_MSG_OFFICER },
	}
	local info = { }
	LinkDropdown.initialize = function(self, level)
		for i, c in ipairs(channels) do
			wipe(info)
			info.text = c[2]
			info.arg1 = c[1]
			info.func = Click
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, 1)
		end
	end
end

-------------------------------------------------------------------------------
-- Frame creation
--  Helpers
--  >Rows
--  >Loot frame

-- Universal events
local function OnDragStart()
	if opt.frame_draggable then
		XLootFrame:StartMoving()
	end
end

local function OnDragStop()
	XLootFrame:StopMovingOrSizing()
	opt.frame_position_x = XLootFrame:GetLeft()
	opt.frame_position_y = opt.frame_grow_upwards and XLootFrame:GetBottom() or XLootFrame:GetTop()
end

-- Fontstring sizes
local function AdjustFontstringSize(self)
	local text = self:GetText()
	self:SetHeight(self:GetStringHeight())
	self:SetText(text)
end

-- Colors
local function Darken(mult, ...)
	local r, g, b, a = ...
	if type(r) == 'table' then
		r, g, b, a = unpack(r)
	end
	return r * mult, g * mult, b * mult, a or 1
end

local function GetColor(self, key, mult)
	local skin, raw, default, t = self.skin, rawget(self.opt, key), defaults.profile[key]
	assert(default, "No default color specified for key " .. key)
	-- Use options if different from defaults
	if raw and (raw[1] ~= default[1] or raw[2] ~= default[2] or raw[3] ~= default[3] or raw[4] ~= default[4]) then
		t = raw
	-- Use skin if options are defaults
	elseif skin[key] then
		t = skin[key]
	-- Use defaults
	else
		t = default
	end
	-- Darken
	if mult then
		return Darken(mult, t)
	end
	return unpack(t)
end


-- Build individual loot row
local mouse_focus
local BuildRow
do
	local RowPrototype = XLoot.NewPrototype()
	-- Text helpers
	local function smalltext(text)
		text:SetDrawLayer'OVERLAY'
		text:SetHeight(10)
		text:SetJustifyH'LEFT'
		text.ext = ext
	end

	local function textpoints(text, item, row, x)
		text:SetPoint('LEFT', item, 'RIGHT', x, 0)
		text:SetPoint('RIGHT', row, 'RIGHT', -4, 0)
	end

	function RowPrototype:OffsetText(text, y)
		text:SetPoint('TOP', self, 0, y)
	end
	
	-- Color overrides
	function RowPrototype:SetBorderColor(r, g, b, a)
		self:_SetBorderColor(r, g, b, a or 1)
		self.frame_item:SetBorderColor(r, g, b, a or 1)
	end

	function RowPrototype:SetHighlightColor(r, g, b)
		self:SetHighlightColor(r, g, b)
		self.frame_item:SetHighlightColor(r, g, b)
	end

	-- Frame events
	do
		local function Row_ShowTooltip_Inner(self)
			local f
			local type = GetLootSlotType(self.slot)
			if type == LOOT_SLOT_ITEM then
				f = GameTooltip.SetLootItem
			elseif type == LOOT_SLOT_CURRENCY then
				f = GameTooltip.SetLootCurrency
			else
				return nil
			end
			GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 32, 0)
			f(GameTooltip, self.slot)
			CursorUpdate(self)
		end
		
		function RowPrototype:ShowTooltip()
			pcall(Row_ShowTooltip_Inner, self)
		end
	end		
	
	function RowPrototype:HighlightEnter()
		if self._highlights then
			self.frame_item:ShowHighlight()
		end
	end
	
	function RowPrototype:HighlightLeave()
		if self._highlights then
			self.frame_item:HideHighlight()
		end
	end
	
	function RowPrototype:OnEnter()
		self:HighlightEnter(self)
		mouse_focus = self
		self:ShowTooltip()
	end

	function RowPrototype:OnLeave()
		mouse_focus = nil
		self:HighlightLeave(self)
		GameTooltip:Hide()
		ResetCursor()
	end

	function RowPrototype:OnClick(button)
		if not XLootButtonOnClick(self, button) then
			if IsModifiedClick() then
				HandleModifiedItemClick(GetLootSlotLink(self.slot))
			else
	 			LootButton_OnClick(self, button)
			end
		end
	end

	function RowPrototype:Auto_OnClick(button)
		self:Hide()
		if opt.autoloot_item_list ~= '' then
			opt.autoloot_item_list = opt.autoloot_item_list .. ',' .. self.parent.item_name
		else
			opt.autoloot_item_list = self.parent.item_name
		end
		self.parent.owner:ParseAutolootList()
		self.parent:OnClick(button)
	end

	function RowPrototype:Auto_OnEnter()
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
		GameTooltip:SetText(L.button_auto_tooltip)
		GameTooltip:Show()
		self.text:SetTextColor(Darken(2, self.parent.owner:GetColor('loot_color_button_auto')))
	end

	function RowPrototype:Auto_OnLeave()
		GameTooltip:Hide()
		self.text:SetTextColor(self.parent.owner:GetColor('loot_color_button_auto'))
	end

	function RowPrototype:Auto_OnShow()
		self.parent.text_name:SetPoint('RIGHT', self, 'LEFT')
	end

	function RowPrototype:Auto_OnHide()
		self.parent.text_name:SetPoint('RIGHT', self.parent, 'RIGHT', -6, 0)
	end
	
	-- Appearance/skin updates
	local resize_texts = {'text_name', 'text_info'}
	function RowPrototype:UpdateAppearance()
		local owner, opt = self.owner, self.owner.opt

		-- Align frames
		self:SetPoint('LEFT', opt.loot_padding_left, 0)
		self:SetPoint('RIGHT', -opt.loot_padding_right, 0)

		-- Colors
		self:SetBorderColor(owner:GetColor('loot_color_border'))
		self:SetBackdropColor(owner:GetColor('loot_color_backdrop', 0.7))
		self:SetGradientColor(owner:GetColor('loot_color_gradient'))
		self.frame_item:SetGradientColor(owner:GetColor('loot_color_gradient'))
		self.text_info:SetTextColor(owner:GetColor('loot_color_info'))
		self.text_button_auto:SetTextColor(owner:GetColor('loot_color_button_auto'))
		self:SetAlpha(opt.loot_alpha)

		
		-- Text
		self.text_name:SetFont(opt.font, opt.font_size_loot)
		self.text_info:SetFont(opt.font, opt.font_size_info)
		self.text_quantity:SetFont(opt.font, opt.font_size_quantity, opt.font_flag)
		self.text_bind:SetFont(opt.font, 8, opt.font_flag)
		self.text_locked:SetFont(opt.font, 9, opt.font_flag)
		self.text_locked:SetText(LOCKED) -- Can't set text until font is set
		self.text_button_auto:SetFont(opt.font, opt.font_size_button_auto, opt.font_flag)
		self.text_button_auto:SetText(L.button_auto)
		self.button_auto:SetWidth(self.text_button_auto:GetStringWidth()+4)
		self.button_auto:SetHeight(self.text_button_auto:GetStringHeight()+4)

		-- Resize fontstrings
		for i=1,#resize_texts do
			local fontstring = self[resize_texts[i]]
			local text = fontstring:GetText()
			fontstring:SetText("A")
			AdjustFontstringSize(fontstring)
			fontstring:SetText(text)
		end

		-- Dimensions
		self.frame_item:SetWidth(opt.loot_icon_size)
		self.frame_item:SetHeight(opt.loot_icon_size)
		self:SetHeight(opt.loot_row_height)
		
		-- Calculated row height
		owner.row_height = self:GetHeight() + owner.skin.row_spacing

		-- Highlight textures
		if opt.loot_highlight then
			if not self._highlights then
				owner:Highlight(self, 'row_highlight')
				owner:Highlight(self.frame_item, 'item_highlight')
			end
			self:SetHighlightColor(.8, .8, .8, .8)
			self.frame_item:SetHighlightColor(.8, .8, .8, .8)
		elseif self._highlights then
			self:SetHighlightColor(0, 0, 0, 0)
			self.frame_item:SetHighlightColor(0, 0, 0, 0)
		end

		-- Clear layout cache
		self.layout = nil
	end

	-- Bind texts
	local binds = {
		[1] = ('|cffff4422%s|r '):format(L.bind_on_pickup_short),
		[2] = ('|cff44ff44%s|r '):format(L.bind_on_equip_short),
		[3] = ('|cff2244ff%s|r '):format(L.bind_on_use_short),
		-- account = 'BoA'
	}

	-- Update slot with loot
	function RowPrototype:Update(slotData)
		local r, g, b, hex
		local owner = self:GetParent()
		local opt = owner.opt
		local text_info, text_name, text_bind = '', '', ''
		self.item_name = slotData.name
		
		-- Items
		local layout = 'simple'
		if slotData.slotType == LOOT_SLOT_ITEM then
			r, g, b, hex = GetItemQualityColor(slotData.quality or 0)
			
			text_name = ('|c%s%s|r'):format(hex, slotData.name)
			
			if opt.loot_texts_info then -- This is a bit gnarly
				local equip = slotData.typeName == ENCHSLOT_WEAPON and ENCHSLOT_WEAPON or slotData.equipLoc ~= '' and _G[slotData.equipLoc] or ''
				local itemtype = (slotData.subTypeName == 'Junk' and slotData.quality > 0) and MISCELLANEOUS or slotData.subTypeName
				text_info = ((type(equip) == 'string' and equip ~= '') and equip..', ' or '') .. itemtype
				layout = 'detailed'
			end
			
			if opt.loot_texts_bind and slotData.bindType then
				text_bind = binds[slotData.bindType] or ''
			end
			
		-- Currency
		else
			r, g, b = .4, .4, .4
			text_name = slotData.name:gsub('\n', ', ')
		end
		
		-- Strings
		self.text_name:SetText(text_name)
		self.text_info:SetText(text_info)
		self.text_bind:SetText(text_bind)
		self.text_quantity:SetText(slotData.quantity > 1 and slotData.quantity or nil)
		if slotData.questID or slotData.isQuestItem then
			self.text_info:SetTextColor(1, .8, .1)
		else
			self.text_info:SetTextColor(owner:GetColor('loot_color_info'))
		end
		local name_width = self.text_name:GetStringWidth()

		-- Icon
		self.texture_item:SetTexture(slotData.icon)
		if slotData.locked and opt.loot_texts_lock then
			self.text_locked:Show()
		else
			self.text_locked:Hide()
		end
		
		-- Layout
		if self.layout ~= layout then
			self.layout = layout
			if layout == 'simple' then
				self.text_name:SetPoint('LEFT', self.frame_item, 'RIGHT', 2, 0)
			else
				self.text_name:SetPoint('LEFT', self.frame_item, 'RIGHT', 2, (self.text_info:GetHeight()/2))
			end
		end

		-- Quality coloring
		if opt.quality_color_slot then
			self:SetBorderColor(Darken(owner.skin.color_mod, r, g, b))
		end
		
		-- Quest icon
		if slotData.questID then
			self.texture_bang:Show()
		else
			self.texture_bang:Hide()
		end
		
		-- Autoloot button
		if opt.loot_buttons_auto and (self.owner.fake or (opt.autoloots.list ~= 'never' and slotData.slotType == LOOT_SLOT_ITEM and not self.owner.auto_items[slotData.name])) then
			self.button_auto:Show()
			name_width = name_width + self.button_auto:GetWidth() - 6
		else
			self.button_auto:Hide()
		end

		-- Attach
		if self.i == 1 then
			self:SetPoint('TOP', 0, -opt.loot_padding_top)
		else
			self:SetPoint('TOP', owner.rows[self.i-1], 'BOTTOM', 0, owner.skin.row_offset)
		end
		
		self:Show()
		
		return max(self.text_info:GetStringWidth() + 2, name_width)
	end

	-- Factory
	function BuildRow(frame, i)
		local frame_name, opt, fake = frame:GetName()..'Button'..i, frame.opt, frame.fake
		-- Create frames
		local row = CreateFrame('Button', not fake and frame_name or nil, frame)
		local item = CreateFrame('Frame', nil, row)
		local button_auto = CreateFrame('Button', nil, row)
		local tex = item:CreateTexture(not fake and frame_name..'IconTexture' or nil, 'BACKGROUND')
		local bang = item:CreateTexture(nil, 'OVERLAY')
		row.owner = frame
		row.frame_item = item
		row.texture_item = tex
		row.texture_bang = bang
		row.button_auto = button_auto
		row.i = i

		-- Skin row
		frame:Skin(row)
		frame:Skin(item, 'item')

		-- Apply prototype after skin to override method
		RowPrototype:New(row)

		-- Create fontstrings
		local name = row:CreateFontString(not fake and frame_name..'Text' or nil)
		local info = row:CreateFontString()
		local bind = item:CreateFontString()
		local quantity = item:CreateFontString()
		local locked = item:CreateFontString()
		local auto = button_auto:CreateFontString()
		row.text_name = name
		row.text_info = info
		row.text_bind = bind
		row.text_locked = locked
		row.text_quantity = quantity
		row.text_button_auto = auto

		-- Setup fontstrings
		smalltext(name)
		smalltext(info)
		smalltext(bind)
		smalltext(locked)
		smalltext(quantity)
		smalltext(auto)
		name:SetPoint('RIGHT', row, 'RIGHT', -6, 0)
		info:SetPoint('TOPLEFT', name, 'BOTTOMLEFT', 8, 0)
		info:SetPoint('RIGHT', row, 'RIGHT', -4, 0)
		textpoints(name, item, row, 2)
		textpoints(info, item, row, 8)
		info:SetPoint('TOP', name, 'BOTTOM')
		bind:SetPoint('BOTTOMLEFT', 2, 2)
		quantity:SetPoint('BOTTOMRIGHT', -2, 2)
		quantity:SetJustifyH('RIGHT')
		locked:SetPoint('CENTER')
		locked:SetTextColor(1, .2, .1)
		auto:SetPoint('CENTER')

		item:SetPoint('LEFT', 0, 0)
		tex:SetPoint('TOPLEFT', 3, -3)
		tex:SetPoint('BOTTOMRIGHT', -3, 3)
		tex:SetTexCoord(.07,.93,.07,.93)
		bang:SetPoint('BOTTOMRIGHT')
		bang:SetWidth(16)
		bang:SetHeight(16)
		bang:SetTexture([[Interface\Minimap\ObjectIcons.blp]])
		bang:SetTexCoord(1/8, 2/8, 1/8, 2/8)

		button_auto:SetPoint('TOPRIGHT', -2, -4)
		button_auto:SetScript('OnEnter', row.Auto_OnEnter)
		button_auto:SetScript('OnLeave', row.Auto_OnLeave)
		button_auto:SetScript('OnShow', row.Auto_OnShow)
		button_auto:SetScript('OnHide', row.Auto_OnHide)
		button_auto.parent = row
		button_auto.text = auto

		-- Supplimental events for a configuration instance
		if fake then
			row:RegisterForClicks()
			row:SetScript('OnEnter', row.HighlightEnter)
			row:SetScript('OnLeave', row.HighlightLeave)
		-- Events for actual loot frame
		else
			row:RegisterForDrag('LeftButton')
			row:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
			row:SetScript('OnDragStart', OnDragStart)
			row:SetScript('OnDragStop', OnDragStop)
			row:SetScript('OnClick', row.OnClick)
			row:SetScript('OnEnter', row.OnEnter)
			row:SetScript('OnLeave', row.OnLeave)
			button_auto:RegisterForClicks('LeftButtonUp')
			button_auto:SetScript('OnClick', row.Auto_OnClick)
		end

		-- Apply appearance
		row:UpdateAppearance()
		
		return row
	end
end

-- Build frame
do
	local FramePrototype = XLoot.NewPrototype()
	-- Frame snapping
	function FramePrototype:SnapToCursor()
		local x, y = GetCursorPosition()
		local f = self
		local s = f:GetEffectiveScale()

		if opt.frame_snap then
			-- Horizontal position
			if not f:IsShown() then
				x = (x / s) - 25
				local sWidth, fWidth, uWidth = GetScreenWidth(), f:GetWidth(), UIParent:GetWidth()
				if uWidth > sWidth then sWidth = uWidth end
				if x + fWidth > sWidth then x = sWidth - fWidth end
				if x < 0 then x = 0 end
				x = x + opt.frame_snap_offset_x
			else
				x = f:GetLeft() or x
			end
   
			-- Vertical position
			y = (y / s) + 25 * (opt.frame_grow_upwards and -1 or 1)
			local sHeight, fHeight, uHeight = GetScreenHeight(), f:GetHeight(), UIParent:GetHeight()
			if uHeight > sHeight then sHeight = uHeight end
			if y > sHeight then y = sHeight end
			if y - fHeight < 0 then y = fHeight end
			y = y + opt.frame_snap_offset_y
		else
			x = opt.frame_position_x or x
			y = opt.frame_position_y or y
		end
   
		-- Apply
		f:ClearAllPoints()
		f:SetPoint((opt.frame_grow_upwards and "BOTTOMLEFT" or "TOPLEFT"), UIParent, "BOTTOMLEFT", x, y)
	end

	-- function FramePrototype:SetAlpha(alpha)
	-- 	self.backdrop:SetAlpha(alpha)
	-- end

	
	-- Link loot menu
	function FramePrototype:LinkClick(button)
		if button == 'RightButton' then
			ToggleDropDownMenu(1, nil, LinkDropdown, self)--, GetCursorPosition())
		else
			LinkLoot(self:GetParent().opt.linkall_channel)
		end
	end

	function FramePrototype:OnHide()
		pcall(LootFrame_OnHide)
		for i,v in ipairs(self.rows) do
			v:Hide()
		end
		-- CloseLoot()
	end
	
	-- Bottom buttons
	local function BottomButton(frame, name, text, justify)
		local b = CreateFrame('Button', name, frame)
		b.text = b:CreateFontString(name..'Text', 'DIALOG')--, 'GameFontNormalSmall')
		b.text:SetFont(frame.opt.font, frame.opt.font_size_bottombuttons)
		b.text:SetText('|c22AAAAAA'..text)
		b.text:SetJustifyH(justify)
		b.text:SetAllPoints(b)
		b:SetFrameLevel(8)
		b:SetHeight(16)
		b:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
		b:ClearAllPoints()
		b:SetPoint('BOTTOM', 0, 3)
		b:SetHitRectInsets(-4, -4, 3, -2)
		b:Show()
		return b
	end

	function FramePrototype:UpdateHeight()
		if self.row_height then
			self:SetHeight(
				((self.link:IsShown() or not opt.old_close_button) and 6 or 0)
				 + opt.loot_padding_top
				 + opt.loot_padding_bottom
				 + #self.slots * self.row_height)
		end
	end

	function FramePrototype:UpdateWidth(width_max)
		local width = self.opt.frame_width_automatic and (width_max + 70) or (self.opt.frame_width + 50)
		self:SetWidth(width)
		width = width * 0.5 - 10
		self.link:SetWidth(width)
		self.close:SetWidth(width)
	end

	function FramePrototype:UpdateLinkButton()
		local target, show, now = self.opt.linkall_channel, self.opt.linkall_show, false
		if show == 'auto' then
			if target == 'SAY' or
				((target == 'GUILD' or target == 'OFFICER') and IsInGuild()) or
				((target == 'RAID' or target == 'RAID_WARNING') and IsInRaid()) or
				(target == 'PARTY' and IsInGroup())
			then
				now = true
			end
		else
			now = IsGroupState[show]()
		end
		if now then
			self.link:Show()
		else
			self.link:Hide()
		end
	end
	
	function FramePrototype:SizeAndColor(max_width, max_quality)
		-- Update frame
		self:UpdateLinkButton()
		self:UpdateHeight()
		self:UpdateWidth(max_width)
		
		-- Color frame
		if self.opt.quality_color_frame then
			self.overlay:SetBorderColor(GetItemQualityColor(max_quality))
		end
	end
	
	-- Update skin/appearance
	function FramePrototype:UpdateAppearance()
		self.skin = self:Reskin()
		self.skin.row_offset = self.skin.row_spacing * -1

		-- Update colors/other
		self:SetScale(self.opt.frame_scale)
		self.overlay:SetAlpha(self.opt.frame_alpha)
		self.overlay:SetBorderColor(self:GetColor('frame_color_border'))
		self.overlay:SetGradientColor(self:GetColor('frame_color_gradient'))
		self.overlay:SetBackdropColor(self:GetColor('frame_color_backdrop', 0.7))
		
		-- Update loot frames
		for i, row in ipairs(self.rows) do
			row:UpdateAppearance()
		end
		
		-- Resize frame
		if #self.slots > 0 and self.opt.frame_width_automatic then
			local max_width, max = 0, math.max
			for i, slot in ipairs(self.slots) do
				max_width = max(max_width, slot.text_name:GetStringWidth(), slot.text_info:GetStringWidth())
			end
			self:UpdateWidth(max_width)
		end

		-- Show close buttons
		if opt.old_close_button then
			self.close:Hide()
			self.old_close:Show()
		else
			self.close:Show()
			self.old_close:Hide()
		end

		-- Text
		self.close.text:SetFont(opt.font, opt.font_size_bottombuttons)
		self.link.text:SetFont(opt.font, opt.font_size_bottombuttons)
	end

	-- Factory
	function addon:BuildLootFrame(f)
		local name = f:GetName()
		-- Setup frame
		FramePrototype:New(f)
		f:SetFrameStrata('DIALOG')
		f:SetFrameLevel(5)
		f:EnableMouse(1)
		
		-- Set up frame skins
		XLoot:MakeSkinner(f, {
			item = {
				backdrop = false
			},
			row_highlight = {
				type = 'highlight'
			},
			item_highlight = {
				type = 'highlight',
				layer = 'OVERLAY'
			}
		})

		
		-- Use a secondary frame for backdrop/border to allow the "frame" opacity to be changed
		local overlay = CreateFrame('Frame', nil, f)
		overlay:SetFrameLevel(5)
		overlay:SetAllPoints()
		f:Skin(overlay)
		f.overlay = overlay

		-- Link all button
		local link = BottomButton(f, name..'Link', L.button_link, 'MIDDLE')
		link:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		link:SetPoint('LEFT', 6, 0)
		f.link = link

		-- Close button
		local close = BottomButton(f, name..'Close', L.button_close, 'MIDDLE')
		close:SetPoint('RIGHT', -6, 0)
		f.close = close

		-- Legacy close button
		local x = CreateFrame("Button", nil, f)
		x:SetWidth(30)
		x:SetHeight(30)
		local xtex = [[Interface\Buttons\UI-Panel-MinimizeButton-]]
		x:SetNormalTexture(xtex..'Up')
		x:SetPushedTexture(xtex..'Down')
		x:SetHighlightTexture(xtex..'Highlight')
		x:SetPoint('TOPRIGHT', 3, 3)
		x:SetHitRectInsets(3, 3, 3, 3)
		x:SetFrameLevel(f:GetFrameLevel()+2)
		-- f:Skin(x)
		-- x:SetBorderColor(.7, .7, .7)
		f.old_close = x


		-- Events
		if not f.fake then
			f:SetMovable(1)
			f:RegisterForDrag('LeftButton')
			f:SetScript('OnDragStart', OnDragStart)
			f:SetScript('OnDragStop', OnDragStop)
			f:SetScript('OnHide', f.OnHide)
			link:SetScript('OnClick', f.LinkClick)

			-- WoW now shows an error if any parameter is passed, and OnClick passes one
			local function CloseLoot_Nil()
				CloseLoot()
			end

			close:SetScript('OnClick', CloseLoot_Nil)
			x:SetScript('OnClick', CloseLoot_Nil)
		end

		f.GetColor = GetColor

		f.rows = setmetatable({}, { __index = function(t, k)
			local row = BuildRow(f, k)
			t[k] = row
			return row
		end })

		f.slots_index = {}
		f.slots = {}

		f:UpdateAppearance()
		f.built = true
	end
end

-- Main loot handler
local auto, auto_items = {}, {}
function XLootFrame:ParseAutolootList()
	wipe(auto_items)
	for item in opt.autoloot_item_list:gmatch("%s*([^,]+)%s*") do
		auto_items[item] = true
	end
end

local auto_states = {
	always = true,
	group = true, -- Secretly "Always" shh
	never = false,
	solo = nil,
	party = nil,
	raid = nil
}


function addon:GROUP_ROSTER_UPDATE()
	auto_states.solo = not IsInGroup()
	auto_states.raid = IsInRaid()
	auto_states.party = not auto_states.raid
end

local function clear(slot)
	if not slot then return nil end
	slot.slot = nil
	slot.item = nil
	slot.quality = nil
	slot:Hide()
end

local function BoPRefresh()
	for i, row in pairs(XLootFrame.rows) do
		clear(row)
	end
	XLootFrame:Update(false, true)
end

local _bag_slots, GetItemBindType = {}, XLoot.GetItemBindType
function XLootFrame:Update(no_snap, is_refresh)
	local numloot = GetNumLootItems()
	if numloot == 0 then return nil end
	local max = math.max

	-- Construct frame
	if not self.built then
		addon:BuildLootFrame(self)
		self:ParseAutolootList()
		self.auto_items = auto_items
		addon:GROUP_ROSTER_UPDATE()
	end

	-- References
	local rows, slots, slots_index = self.rows, wipe(self.slots), wipe(self.slots_index)
	local bag_slots -- Only assigned if we start autolooting
	
	-- Autolooting options
	local auto, auto_items = auto, auto_items
	for k,v in pairs(opt.autoloots) do
		auto[k] = auto_states[v]
	end

	-- Update rows
	local max_quality, max_width, our_slot, slot, need_refresh = 0, 0, 0
	for slot = 1, numloot do
		local _, icon, name, quantity, currencyID, quality, locked, isQuestItem, questID, startsQuest = pcall(GetLootSlotInfo, slot)
		-- Already looted or erroring slot
		if not name then
			if not is_refresh and opt.show_slot_errors then
				xprint(L.slot_name_error:format(tostring(slot)))
			end

		elseif not icon then
			if not is_refresh and opt.show_slot_errors then
				xprint(L.slot_icon_error:format(tostring(slot)))
			end

		else
			local autoloot = false
			local slotType, slotData = GetLootSlotType(slot)
			if slotType == LOOT_SLOT_ITEM then
				slotData = GetItemInfoTable(GetLootSlotLink(slot))
				slotData.slotType = slotType
				slotData.quantity = quantity
				slotData.locked = locked
				slotData.questItem = isQuestItem
				slotData.questID = questID
				slotData.startsQuest = startsQuest
			else
				slotData = {
					name = name,
					icon = icon,
					slotType = slotType,
					quantity = quantity,
					quality = quality,
					locked = locked,
					-- questItem = isQuestItem,
					-- questID = questID,
					-- startsQuest = startsQuest,
					bindType = 0
				}
			end

			-- There's no reason to try to autoloot when refreshing the frame
			if not is_refresh then
				-- Autolooting currency
				if (auto.all or auto.currency) and (slotType == LOOT_SLOT_MONEY or slotType == LOOT_SLOT_CURRENCY) then
					autoloot = true
				-- Quest items			
				elseif (auto.all or auto.quest) and (isQuestItem or startsQuest) then
					autoloot = true
				-- Autolooting items
				elseif
					auto.all
					or (auto.list and auto_items[name])
					or (auto.tradegoods and slotData.isCraftingReagent)
				then
					-- Cache available space
					--  Specific bag types make this a bit more annoying
					if not bag_slots then
						bag_slots = wipe(_bag_slots)
						for i = 0, NUM_BAG_SLOTS do
							local open, family = GetContainerNumFreeSlots(i)
							if family then
								bag_slots[family] = bag_slots[family] and bag_slots[family] + open or open
							end
						end
					end

					local family = GetItemFamily(slotData.link)
					-- Empty slots
					family = (family and family <= 4096) and family or 0
					if bag_slots[0] > 0 or (bag_slots[family] and bag_slots[family] > 0) then
						autoloot = true
						-- Update remaining space estimate
						family = bag_slots[family] and family or 0
						bag_slots[family] = bag_slots[family] - 1

					-- Space in existing stacks
					else
						local partial = GetItemCount(slotData.link) % slotData.stackCount
						if partial > 0 and (partial + quantity < slotData.stackCount) then
							autoloot = true
						end
					end
				end

				if autoloot then
					need_refresh = true
					LootSlot(slot)
				end
			end

				
			-- Show slot
			if
				not autoloot
				or is_refresh
			then
				our_slot = our_slot + 1
				local row = rows[our_slot]
				slots[our_slot] = row
				
				-- Default UI and tooltip data
				row.item = slotData.link
				row.quality = slotData.quality
				row.slot = slot
				row.frame_slot = our_slot
				row:SetID(slot)
				
				-- Update row
				local width = row:Update(slotData)
				
				max_width = max(width, max_width)
				max_quality = max(slotData.quality or 0, max_quality)
			end
		end
	end

	if not is_refresh and need_refresh then
		C_Timer.After(0.8, BoPRefresh)
	end

	-- Exit if we autolooted everything
	if our_slot == 0 then
		-- CloseLoot()
		return nil
	end
	
	self:SizeAndColor(max_width, max_quality)

	-- Show
	if not no_snap and not is_refresh then
		self:SnapToCursor()
	end
	self:Show()
end

function addon:LOOT_CLOSED()
	if type(XLootFrame.rows) == 'table' then
		for i, row in pairs(XLootFrame.rows) do
			clear(row)
		end
		wipe(XLootFrame.slots)
	end
	XLootFrame:Hide()
	StaticPopup_Hide('LOOT_BIND')
	if UIDropDownMenu_GetCurrentDropDown() == LinkDropdown then
		CloseDropDownMenus()
	end
end

function addon:LOOT_OPENED()
	if GetNumLootItems() > 0 then
		if not XLootFrame:IsShown() and IsFishingLoot() then
			PlaySound(SOUNDKIT.FISHING_REEL_IN)
		end
		XLootFrame:Update()
	else
		PlaySound(SOUNDKIT.LOOT_WINDOW_OPEN_EMPTY)
		CloseLoot()
	end
end

function addon:LOOT_SLOT_CLEARED(slot)
	local slots = XLootFrame.slots
	-- Apparently auto-looting addons like EasyLoot will cause strange issues
	if slots == nil then
		return
	end
	for id, row in ipairs(slots) do
		if row.slot == slot then
			clear(row)
			if XLootFrame.opt.loot_collapse then
				local prev, next = slots[id-1], slots[id+1]
				if prev and next then
					next:SetPoint('TOP', prev, 'BOTTOM', nil, XLootFrame.skin.row_offset)
				elseif next then
					next:SetPoint('TOP', 0, -opt.loot_padding_top)
				end
				table.remove(slots, id)
				XLootFrame:UpdateHeight()
			end
		end
	end
end

-- Show compare tooltip when shift pressed
-- Without using OnUpdate for all frames
function addon:MODIFIER_STATE_CHANGED(self, modifier, state)
	if IsShiftKeyDown() and not IsAltKeyDown() and (GetNumLootItems() ~= 0) and mouse_focus and MouseIsOver(mouse_focus) then
		mouse_focus:ShowTooltip()
	end
end

local function option_handler(msg)
	if not addon:SlashHandler(msg) then
		addon:ShowOptions()
	end
	--local what, arg, data = string.split(' ', msg, 3)
	--local what, arg, data = msg:match'^(%w+)%s?([A-Za-z\_]*)%s?(.*)$'
end
-- SLASH_XLOOT1 = '/xloot'
-- SlashCmdList['XLOOT'] = option_handler


--[[
Notes:
LootSlotHasItem() -- MoP generic 'check if slot has any loot', meaning item/coin/currency etc
LootSlotIsCoin(slot) etc are replaced by GetLootSlotType(slot) == LOOT_SLOT_* checks
]]



