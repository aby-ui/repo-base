local Addon = select(2, ...)
local Menu = Addon:CreateClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

local nextName = Addon:CreateNameGenerator('Menu')

local MENU_WIDTH = 428
local MENU_HEIGHT = 320

function Menu:New(parent)
	local menu = self:Bind(CreateFrame('Frame', nextName(), parent or UIParent, "UIPanelDialogTemplate"))

	menu:Hide()
	menu:SetSize(MENU_WIDTH, MENU_HEIGHT)
	menu:EnableMouse(true)
	menu:SetToplevel(true)
	menu:SetMovable(true)
	menu:SetClampedToScreen(true)
	menu:SetFrameStrata('DIALOG')

	-- title region
	local tr = CreateFrame('Frame', nil, menu, 'TitleDragAreaTemplate')
	tr:SetAllPoints(menu:GetName() .. 'TitleBG')

	-- title text
	local text = menu:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	text:SetPoint('CENTER', tr)
	menu.text = text

	-- panels
	menu.panels = {}

	-- panel selector
	local panelSelector = Addon.PanelSelector:New(menu)
	panelSelector:SetPoint('TOPLEFT', tr, 'BOTTOMLEFT', 2, -4)
	panelSelector:SetPoint('BOTTOMRIGHT', menu, 'BOTTOMLEFT', 2 + 120, 10)
	panelSelector.OnSelect = function(_, id) menu:OnShowPanel(id) end
	menu.panelSelector = panelSelector

	-- panel container
	local panelContainer = Addon.ScrollableContainer:New(menu)
	panelContainer:SetPoint('TOPLEFT', panelSelector, 'TOPRIGHT', 2, 0)
	panelContainer:SetPoint('BOTTOMRIGHT', -4, 10)
	menu.panelContainer = panelContainer

	return menu
end

-- tells the panel what frame we're pointed to
function Menu:SetOwner(owner)
	if self.panels then
		for _, panel in pairs(self.panels) do
			panel:SetOwner(owner)
		end
	end

	self.text:SetFormattedText(L.BarSettings, owner:GetDisplayName())
	self:Anchor(owner)
end

function Menu:Anchor(frame)
	local ratio = UIParent:GetScale() / frame:GetEffectiveScale()
	local x = frame:GetLeft() / ratio
	local y = frame:GetTop() / ratio

	self:ClearAllPoints()
	self:SetPoint('TOPRIGHT', _G.UIParent, 'BOTTOMLEFT', x, y)
end

function Menu:NewPanel(id)
	self.panelSelector:AddPanel(id)

	local panel = Addon.Panel:New()

	self.panels[id] = panel

	return panel
end

function Menu:ShowPanel(id)
	return self.panelSelector:Select(id)
end

function Menu:OnShowPanel(id)
	if self.panels then
		for i, panel in pairs(self.panels) do
			if i == id then
				panel:Show()
				self.panelContainer:SetContent(panel)
			else
				panel:Hide()
			end
		end
	end
end

function Menu:AddLayoutPanel()
	local panel = self:NewPanel(L.Layout)

	panel:AddLayoutOptions()

	return panel
end

function Menu:AddBasicLayoutPanel()
	local panel = self:NewPanel(L.Layout)

	panel:AddBasicLayoutOptions()

	return panel
end

function Menu:AddAdvancedPanel(basic)
	local panel = self:NewPanel(L.Advanced)

	panel:AddAdvancedOptions(basic)

	return panel
end

function Menu:AddFadingPanel()
	local panel = self:NewPanel(L.Fading)

	panel:AddFadingOptions()

	return panel
end

Addon.Menu = Menu