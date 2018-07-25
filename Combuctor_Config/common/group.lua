--[[
	group.lua
		Options group widget template
--]]

local CONFIG, Config = ...
local ADDON, Addon = Config.addon, _G[Config.addon]
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)

local Options = LibStub('Poncho-1.0')(nil, CONFIG, nil, nil, SushiGroup)
Options.frameID = 'inventory'
Options.sets = Addon.sets
Addon.Options = Options


--[[ Constructor ]]--

function Options:NewPanel(parent, title, subtitle, content)
	local panel = CreateFrame('Frame')
	panel.parent = parent
	panel.name = title
	panel:Hide()

	local group = self(panel)
	group.title, group.subtitle, group.content = title, subtitle, content
	group:SetPoint('BOTTOMRIGHT', -4, 5)
	group:SetPoint('TOPLEFT', 4, -11)
	group:SetResizing('HORIZONTAL')
	group:SetSize(0, 0)
	group:SetChildren(group.OnUpdate)

	InterfaceOptions_AddCategory(panel)
	return group
end

function Options:OnUpdate()
	self:CreateHeader(self.title, 'GameFontNormalLarge')
	self:CreateHeader(self.subtitle, 'GameFontHighlightSmall').bottom = 11
	self:content()
end


--[[ External API ]]--

function Options:Open()
 InterfaceOptionsFrame_OpenToCategory(self:GetParent())
 InterfaceOptionsFrame_OpenToCategory(self:GetParent())
end


--[[ Widgets ]]--

function Options:CreateHeader(text, font, underline)
	local child = self:Create('Header')
	child:SetText(text:gsub('ADDON', ADDON))
	child:SetUnderlined(underline)
	child:SetWidth(585)
	child:SetFont(font)
	return child
end

function Options:CreateRow(height, content)
	local group = self:Bind(Options(self))
	group.sets = self.sets
	group:SetResizing('HORIZONTAL')
	group:SetHeight(height)
	group:SetChildren(content)
	return group
end

function Options:CreateFauxScroll(maxEntries, entryHeight, content)
	local group = self:Bind(SushiFauxScrollGroup(self))
	group.sets = self.sets
	group:SetWidth(self:GetWidth())
	group:SetMaxDisplayed(13)
	group:SetEntrySize(26)
	group:SetChildren(content)
	return group
end

function Options:CreateFramesDropdown()
	local drop = self:Create('Dropdown')
	drop:SetValue(self.frameID)
	drop:SetLabel(L.Frame)
	drop:AddLine('inventory', INVENTORY_TOOLTIP)
	drop:AddLine('bank', BANK)
	drop:SetCall('OnInput', function(_, v)
		self.frameID = v
	end)

	if GetAddOnEnableState(UnitName('player'), ADDON .. '_GuildBank') >= 2 then
		drop:AddLine('guild', GUILD_BANK)
	end

	if GetAddOnEnableState(UnitName('player'), ADDON .. '_VoidStorage') >= 2 then
		drop:AddLine('vault', VOID_STORAGE)
	end

	return drop
end

function Options:CreateCheck(arg, onInput)
	local child = self:CreateInput('CheckButton', arg)
	child:SetCall('OnInput', function(self, v)
		self.sets[arg] = v
		Addon:UpdateFrames()

		if onInput then
			onInput(v)
		end
	end)

	return child
end

function Options:CreateSmallCheck(parent, ...)
	local check = self:CreateCheck(...)
	check:SetDisabled(not self.sets[parent])
	check:SetSmall(true)
	check.left = 20
	return check
end

function Options:CreatePercentSlider(arg, ...)
	local child = self:CreateSlider(arg, ...)
	child:SetCall('OnInput', function(self,v)
		self.sets[arg] = v/100
		Addon:UpdateFrames()
	end)

	child:SetValue(self.sets[arg] * 100)
	child:SetPattern('%s%')
	return child
end

function Options:CreateSlider(arg, min, max)
	local child = self:CreateInput('Slider', arg)
	child.bottom = 20
	child:SetRange(min, max)
	child:SetCall('OnInput', function(self,v)
		self.sets[arg] = v
		Addon:UpdateFrames()
	end)

	return child
end

function Options:CreateColor(arg)
	local color = self.sets[arg]
	local child = self:Create('ColorPicker')
	child:EnableAlpha(true)
	child:SetValue(color[1], color[2], color[3])
	child:SetText(L[arg:gsub('^.', strupper)])
	child:SetCall('OnInput', function(_, r,g,b,a)
		color[1], color[2], color[3], color[4] = r,g,b,a
		Addon:UpdateFrames()
	end)

	return child
end

function Options:CreateDropdown(arg, ...)
	local drop = self:CreateInput('Dropdown', arg)
	drop:AddLines(...)
	drop:SetCall('OnInput', function(self, v)
		self.sets[arg] = v
		Addon:UpdateFrames()
	end)
end

function Options:CreateInput(type, arg)
	local title = arg:gsub('^.', strupper)
	local child = self:Create(type)
	child:SetLabel(L[title])
	child:SetValue(self.sets[arg])
	child.sets = self.sets

	if L[title .. 'Tip'] then
		child:SetTip(L[title .. 'Tip'])
	end

	return child
end
