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
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.Update)
	b:RegisterForClicks('anyUp')
	b:Update()

	return b
end


--[[ Events ]]--

function BagToggle:OnClick(button)
	if button == 'LeftButton' then
		local profile = self:GetProfile()
		profile.showBags = not profile.showBags or nil
		self:SendFrameMessage('BAG_FRAME_TOGGLED')
	else
		local menu = {}
		local function addLine(id, name, addon)
			if id ~= self:GetFrameID() and (not addon or GetAddOnEnableState(UnitName('player'), addon) >= 2) then
				tinsert(menu, {
					text = name,
					notCheckable = 1,
					func = function()
						self:OpenFrame(id, addon)
					end
				})
			end
		end

		addLine('inventory', INVENTORY_TOOLTIP)
		addLine('bank', BANK)
		addLine('vault', VOID_STORAGE, ADDON .. '_VoidStorage')

		if Addon.Cache:GetPlayerGuild(self:GetPlayer()) then
			addLine('guild', GUILD_BANK, ADDON .. '_GuildBank')
		end

		if #menu > 1 then
			EasyMenu(menu, Dropdown, self, 0, 0, 'MENU')
		else
			self:OpenFrame(self:GetFrameID() == 'inventory' and 'bank' or 'inventory')
		end

		self:Update()
	end
end

function BagToggle:OnEnter()
	GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
	GameTooltip:SetText(BAGSLOTTEXT)

	if self:IsBagFrameShown() then
		GameTooltip:AddLine(L.TipHideBags, 1,1,1)
	else
		GameTooltip:AddLine(L.TipShowBags, 1,1,1)
	end

	GameTooltip:AddLine(L.TipFrameToggle, 1,1,1)
	GameTooltip:Show()
end

function BagToggle:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ API ]]--

function BagToggle:OpenFrame(id, addon)
	if not addon or LoadAddOn(addon) then
		Addon:CreateFrame(id):SetPlayer(self:GetPlayer())
		Addon:ShowFrame(id)
	end
end

function BagToggle:Update()
	self:SetChecked(self:IsBagFrameShown())
end

function BagToggle:IsBagFrameShown()
	return self:GetProfile().showBags
end
