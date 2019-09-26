--[[
	bagToggle.lua
		A style agnostic bag toggle button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon:NewClass('BagToggle', 'CheckButton')
local Dropdown = CreateFrame('Frame', ADDON .. 'BagToggleDropdown', nil, 'UIDropDownMenuTemplate')


--[[ Constructor ]]--

function BagToggle:New(parent)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent, ADDON .. self.Name .. 'Template'))
	b:SetScript('OnHide', b.UnregisterSignals)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.OnShow)
	b:RegisterForClicks('anyUp')
	b:Update()

	return b
end


--[[ Events ]]--

function BagToggle:OnShow()
	self:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	self:Update()
end

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		local profile = self:GetProfile()
		profile.showBags = not profile.showBags

		self:SendFrameSignal('BAG_FRAME_TOGGLED')
	else
		self:ToggleDropdown()
		self:Update()
	end
end

function BagToggle:OnEnter()
	GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
	GameTooltip:SetText(BAGSLOTTEXT)

	if self:IsBagFrameShown() then
		GameTooltip:AddLine(L.TipHideBags:format(L.LeftClick), 1,1,1)
	else
		GameTooltip:AddLine(L.TipShowBags:format(L.LeftClick), 1,1,1)
	end

	GameTooltip:AddLine(L.TipFrameToggle:format(L.RightClick), 1,1,1)
	GameTooltip:Show()
end

function BagToggle:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ API ]]--

function BagToggle:ToggleDropdown()
	local menu = {}
	local function addLine(id, name, addon, owner)
		if id ~= self:GetFrameID() then
			tinsert(menu, {
				text = name,
				notCheckable = 1,
				func = function() self:OpenFrame(id, addon, owner) end
			})
		end
	end

	addLine('inventory', INVENTORY_TOOLTIP)
	addLine('bank', BANK)

	if Addon.HasVault then
		addLine('vault', VOID_STORAGE, ADDON .. '_VoidStorage')
	end

	local guild = Addon.HasGuild and self:GetOwnerInfo().guild
	if guild then
		addLine('guild', GUILD_BANK, ADDON .. '_GuildBank', guild)
	end

	if #menu > 1 then
		EasyMenu(menu, Dropdown, self, 0, 0, 'MENU')
	else
		menu[1].func()
	end
end

function BagToggle:OpenFrame(id, addon, owner)
	if not addon or LoadAddOn(addon) then
		Addon:CreateFrame(id):SetOwner(owner or self:GetOwner())
		Addon:ShowFrame(id)
	end
end

function BagToggle:Update()
	self:SetChecked(self:IsBagFrameShown())
end

function BagToggle:IsBagFrameShown()
	return self:GetProfile().showBags
end
