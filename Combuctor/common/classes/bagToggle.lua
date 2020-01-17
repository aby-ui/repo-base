--[[
	bagToggle.lua
		A style agnostic bag toggle button
--]]

local ADDON, Addon = ...
local Sushi = LibStub('Sushi-3.1')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local BagToggle = Addon.Tipped:NewClass('BagToggle', 'CheckButton', true)
local Dropdown = CreateFrame('Frame', ADDON .. 'BagToggleDropdown', nil, 'UIDropDownMenuTemplate')


--[[ Construct ]]--

function BagToggle:New(...)
	local b = self:Super(BagToggle):New(...)
	b:SetScript('OnHide', b.UnregisterAll)
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
		profile.showBags = not profile.showBags -- abyui or nil

		self:SendFrameSignal('BAG_FRAME_TOGGLED')
	else
		self:ToggleDropdown()
		self:Update()
	end
end

function BagToggle:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(BAGSLOTTEXT)

	if self:IsBagGroupShown() then
		GameTooltip:AddLine(L.TipHideBags:format(L.LeftClick), 1,1,1)
	else
		GameTooltip:AddLine(L.TipShowBags:format(L.LeftClick), 1,1,1)
	end

	GameTooltip:AddLine(L.TipFrameToggle:format(L.RightClick), 1,1,1)
	GameTooltip:Show()
end


--[[ API ]]--

function BagToggle:ToggleDropdown()
	local menu = {{text = L.TitleFrames:format(ADDON), isTitle = true}}
	local owners = {guild = self:GetOwnerInfo().guild or false}

	for i, frame in Addon.Frames:Iterate() do
		if frame.id ~= self:GetFrameID() and owners[frame.id] ~= false and Addon.Frames:IsEnabled(frame.id) then
			tinsert(menu, {
				text = frame.name,
				notCheckable = 1,
				func = function()
					Addon.Frames:Show(frame.id, owners[frame.id] or self:GetOwner())
				end
			})
		end
	end

	local drop = #menu > 2 and Sushi.Dropdown:Toggle(self)
	if drop then
		drop:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -11)
		drop:SetChildren(menu)
	elseif #menu == 2 then
		menu[2].func()
	end
end

function BagToggle:Update()
	self:SetChecked(self:IsBagGroupShown())
end

function BagToggle:IsBagGroupShown()
	return self:GetProfile().showBags
end
