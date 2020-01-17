--[[
  dropButton.lua
		A dropdown button with a delete option
--]]

local ADDON, Addon = ...
local Button = Addon:NewModule('DropButton', LibStub('Sushi-3.1').DropButton:NewClass(nil, ADDON .. 'DropButton'))
Button.right = Button.right + 10

function Button:Construct()
	local b = self:Super(Button):Construct()
	local del = CreateFrame('Button', nil, b)
	del:SetScript('OnClick', function() b:OnDelete() end)
	del:SetNormalAtlas('groupfinder-icon-redx')
	del:SetPoint('RIGHT', 10, 1)
	del:SetSize(10, 10)

	b.Delete = del
	return b
end

function Button:New(...)
	local b = self:Super(Button):New(...)
	b:SetCall('OnDelete', b.info.delFunc and function() b.info:delFunc() end)
	b.Delete:GetNormalTexture():SetDesaturated(not b.info.delFunc)
	b.Delete:SetEnabled(b.info.delFunc)
	return b
end

function Button:OnDelete()
	self:FireCalls('OnDelete')
	self:FireCalls('OnUpdate')
end
