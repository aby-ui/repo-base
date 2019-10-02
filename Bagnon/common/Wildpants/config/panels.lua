--[[
	panels.lua
		Configuration panels
--]]

local CONFIG, Config = ...
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)

local PATRONS = {{title='Jenkins',people={'Gnare','Arriana Sylvester','SirZooro','ProfessahX'}},{},{title='Ambassador',people={'Sembiance','Fernando Bandeira','Michael Irving','Julia F','Peggy Webb','Lolari','Craig Falb','Mary Barrentine','Grey Sample','Patryk Kalis','Lifeprayer','Steve Lund'}}} -- generated patron list
local SLOT_COLOR_TYPES = {}
for id, name in pairs(Addon.BAG_TYPES) do
	if not tContains(SLOT_COLOR_TYPES, name) then
		tinsert(SLOT_COLOR_TYPES, name)
	end
end

sort(SLOT_COLOR_TYPES)
tinsert(SLOT_COLOR_TYPES, 1, 'normal')

local Expanded = {}
local SetProfile = function(profile)
	Addon:SetCurrentProfile(profile)
	Addon:UpdateFrames()
	Addon.GeneralOptions:Update()
end


--[[ Panels ]]--

Addon.GeneralOptions = Addon.Options:NewPanel(nil, ADDON, L.GeneralDesc, function(self)
	self:CreateCheck('locked')
	self:CreateCheck('tipCount')

	if CanGuildBankRepair then
		self:CreateSmallCheck('tipCount', 'countGuild')
	end

	if Config.fading then
		self:CreateCheck('fading')
	end

	self:CreateCheck('flashFind')
	self:CreateCheck('displayBlizzard', ReloadUI)

	local global = self:CreateChild('Check')
	global:SetLabel(L.CharacterSpecific)
	global:SetValue(Addon.profile ~= Addon.sets.global)
	global:SetCall('OnInput', function(_, v)
		if Addon.profile == Addon.sets.global then
			SetProfile(CopyTable(Addon.sets.global))
		else
			SushiPopup:Display {
				id = ADDON .. 'ConfirmGlobals',
				OnAccept = function() SetProfile(nil) end,
				whileDead = 1, exclusive = 1, hideOnEscape = 1,
				button1 = YES, button2 = NO,
				text = L.ConfirmGlobals,
			}
		end
	end)
end)

Addon.FrameOptions = Addon.Options:NewPanel(ADDON, L.FrameSettings, L.FrameSettingsDesc, function(self)
	self.sets = Addon.profile[self.frameID]
	self:CreateFramesDropdown()
	self:CreateCheck('enabled'):SetDisabled(self.frameID ~= 'inventory' and self.frameID ~= 'bank')

	if self.sets.enabled then
		-- Display
		self:CreateHeader(DISPLAY, 'GameFontHighlight', true)
		self:CreateRow(Config.displayRowHeight, function(row)
			if Config.components then
				if self.frameID ~= 'guild' then
					row:CreateCheck('bagToggle')
					row:CreateCheck('sort')
				end

				row:CreateCheck('search')
				row:CreateCheck('options')
				row:CreateCheck('broker')

				if self.frameID ~= 'vault' then
					row:CreateCheck('money')
				end
			end

			if Config.tabs then
				row:CreateCheck('leftTabs')
			end
		end)

		-- Appearance
		self:CreateHeader(L.Appearance, 'GameFontHighlight', true)
		self:CreateRow(70, function(row)
			if Config.colors then
				row:CreateColor('color')
				row:CreateColor('borderColor')
			end

			row:CreateCheck('reverseBags')
			row:CreateCheck('reverseSlots')
			row:CreateCheck('bagBreak')

			if REAGENTBANK_CONTAINER and self.frameID == 'bank' then
				row:CreateCheck('exclusiveReagent')
			end
		end)

		self:CreateRow(162, function(row)
			row:CreateDropdown('strata', 'LOW',LOW, 'MEDIUM',AUCTION_TIME_LEFT2, 'HIGH',HIGH)
			row:CreatePercentSlider('alpha', 1, 100)
			row:CreatePercentSlider('scale', 20, 300):SetCall('OnInput', function(self,v)
				local new = v/100
				local old = self.sets.scale
				local ratio = new / old

				self.sets.x =  self.sets.x / ratio
				self.sets.y =  self.sets.y / ratio
				self.sets.scale = new
				Addon:UpdateFrames()
			end)

			row:Break()
			row:CreatePercentSlider('itemScale', 20, 200)
			row:CreateSlider('spacing', -15, 15)

			if Config.columns then
				row:CreateSlider('columns', 1, 50)
			end
		end).bottom = -50
	end
end)

Addon.DisplayOptions = Addon.Options:NewPanel(ADDON, L.DisplaySettings, L.DisplaySettingsDesc, function(self)
	self:CreateHeader(L.DisplayInventory, 'GameFontHighlight', true)
	self:CreateRow(35*5, function(row)
		for i, event in ipairs {'Bank', 'Guildbank', 'Auction', 'Mail', 'Player', 'Trade', 'Gems', 'Scrapping', 'Craft'} do
			row:CreateCheck('display' .. event).right = 220
		end
	end)

	self:CreateHeader(L.CloseInventory, 'GameFontHighlight', true)
	self:CreateRow(35*3, function(row)
		for i, event in ipairs {'Bank', 'Vendor', 'Map', 'Combat', 'Vehicle'} do
			row:CreateCheck('close' .. event).right = 220
		end
	end)
end)

Addon.ColorOptions = Addon.Options:NewPanel(ADDON, L.ColorSettings, L.ColorSettingsDesc, function(self)
	-- Items
	self:CreateHeader(ITEMS, 'GameFontHighlight', true)
	self:CreateRow(35*2, function(row)
		row:CreateCheck('glowQuality')
		row:CreateCheck('glowQuest')
		row:CreateCheck('glowSets')
		row:CreateCheck('glowUnusable')
		row:CreateCheck('glowNew')
	end)
	self:CreatePercentSlider('glowAlpha', 1, 100):SetWidth(585)

	-- Slots
	self:CreateHeader(TRADESKILL_FILTER_SLOTS, 'GameFontHighlight', true).top = 15
	self:CreateCheck('emptySlots')
	self:CreateCheck('colorSlots').bottom = 11

	if self.sets.colorSlots then
		self:CreateRow(180, function(self)
			for i, name in ipairs(SLOT_COLOR_TYPES) do
				self:CreateColor(name .. 'Color').right = 144
			end
		end)
	end
end)

if Config.supportRules then
	Addon.RulesOptions = Addon.Options:NewPanel(ADDON, L.RuleSettings, L.RuleSettingsDesc, function(self)
		self.sets = Addon.profile[self.frameID]
		self:CreateFramesDropdown()

		self:CreateFauxScroll(13, 26, function(self)
			local entries = {}
			for _,parent in Addon.Rules:IterateParents() do
				tinsert(entries, parent)

				if Expanded[parent.id] then
					for _,child in pairs(parent.children) do
						tinsert(entries, child)
					end
				end
			end
			self:SetNumEntries(#entries)

			for i = self:FirstEntry(), self:LastEntry() do
				local rule = entries[i]
				local id, isSub = rule.id, rule.id:find('/')

				local button = self:CreateChild(isSub and 'Check' or 'ExpandCheck')
				button:SetChecked(not self.sets.hiddenRules[id])
				button:SetLabel(rule.icon and format('|T%s:%d|t %s', rule.icon, 26, rule.name) or rule.name)
				button.left = button.left + (isSub and 24 or 0)
				button:SetCall('OnClick', function()
					if self.sets.hiddenRules[id] then
						tinsert(self.sets.rules, id)
					else
						for i, rule in ipairs(self.sets.rules) do
							if rule == id then
								tremove(self.sets.rules, i)
							end
						end
					end

				 	self.sets.hiddenRules[id] = not self.sets.hiddenRules[id]
					Addon:UpdateFrames()
				end)

				if not isSub then
					button:SetExpanded(Expanded[rule.id])
					button:SetCall('OnExpand', function(button, v)
						Expanded[rule.id] = v
					end)
				end
			end
		end).top = 10
	end)
end

Addon.PatronList = SushiCreditsGroup:CreateOptionsCategory(ADDON)
Addon.PatronList:SetWebsite('http://www.patreon.com/jaliborc')
Addon.PatronList:SetFooter('By João Cardoso and Jason Greer')
Addon.PatronList:SetPeople(PATRONS)
Addon.PatronList:SetAddon(ADDON)
