local Addon = select(2, ...)
local Menu = Addon:CreateClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

local nextName = Addon:CreateNameGenerator('Menu')

function Menu:New(parent)
	local f = self:Bind(CreateFrame('Frame', nextName(), parent or _G.UIParent, "UIPanelDialogTemplate"))

	f.panels = {}
	f:EnableMouse(true)
	f:SetToplevel(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetFrameStrata('DIALOG')

	-- title region
	local tr = CreateFrame('Frame', nil, f, 'TitleDragAreaTemplate')
	tr:SetAllPoints(f:GetName() .. 'TitleBG')

	--title text
	local text = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	text:SetPoint('CENTER', tr)
	f.text = text

	-- panel selector
	local panelSelector = Addon.PanelSelector:New(f)
	panelSelector:SetPoint('TOPLEFT', tr, 'BOTTOMLEFT', 2, -6)
	panelSelector:SetPoint('TOPRIGHT', tr, 'BOTTOMRIGHT', 0, -6)
	panelSelector:SetHeight(20)
	panelSelector.OnSelect = function(_, id)
		f:OnShowPanel(id)
	end
	f.panelSelector = panelSelector

	-- panel container
	local panelContainer = Addon.ScrollableContainer:New(f)
	panelContainer:SetPoint('TOPLEFT', panelSelector, 'BOTTOMLEFT', 4, -4)
	panelContainer:SetPoint('TOPRIGHT', panelSelector, 'BOTTOMRIGHT', 0, -4)
	panelContainer:SetPoint('BOTTOM', 0, 10)
	f.panelContainer = panelContainer

	f:SetSize(300, 400)
	return f
end

--tells the panel what frame we're pointed to
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
	local ratio = _G.UIParent:GetScale() / frame:GetEffectiveScale()
	local x = frame:GetLeft() / ratio
	local y = frame:GetTop() / ratio

	self:ClearAllPoints()
	self:SetPoint('TOPRIGHT', _G.UIParent, 'BOTTOMLEFT', x, y)
end

function Menu:NewPanel(id)
	self.panelSelector:AddPanel(id)

	local panel = Addon.Panel:New()
	-- panel:SetAllPoints(self.panelContainer)
	-- panel:Hide()

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
				self.panelContainer:SetChild(panel)
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

function Menu:AddAdvancedPanel()
	local panel = self:NewPanel(L.Advanced)

	panel:AddAdvancedOptions()

	return panel
end

Addon.Menu = Menu