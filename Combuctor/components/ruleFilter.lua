--[[
	ruleFilter.lua
		A list of tabs representing item rulesets
--]]

local ADDON, Addon = ...
local RuleFilter = Addon:NewClass('RuleFilter', 'Frame')

function RuleFilter:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	f.buttons = {[-1] = f}
	f:SetSize(10, 30)

	for _, signal in pairs(f.Signals) do
		f:RegisterFrameSignal(signal, 'Update')
	end

	f:RegisterFrameSignal('RULES_UPDATED', 'Update')
	f:RegisterSignal('UPDATE_ALL', 'Update')
	f:Update()

	return f
end

function RuleFilter:Update()
	local n = 0

	for i, id in ipairs(self:GetFrame().profile.rules) do
		local rule = Addon.Rules:Get(id)
		if rule and self:IsShowning(rule) then
			local button = self.buttons[n] or self.Button:New(self)
			button:SetPoint(self.FromPoint, self.buttons[n-1], self.ToPoint, self.X, self.Y)
			button:Setup(id, rule.name, rule.icon)

			self.buttons[n] = button
			n = n + 1
		end
	end

	if n == 1 then -- if one filter, hide all
		n = 0
	end

	for k = n, #self.buttons do
		self.buttons[k]:Hide()
	end
	self.numButtons = n
end


--[[ Side Filter ]]--

local SideFilter = Addon:NewClass('SideFilter', 'Frame', RuleFilter)
SideFilter.Signals = {}
SideFilter.Button = Addon.SideTab
SideFilter.X, SideFilter.Y = 0, -17
SideFilter.FromPoint = 'TOPLEFT'
SideFilter.ToPoint = 'BOTTOMLEFT'

function SideFilter:IsShowning(rule)
	return not rule.id:find('/')
end


--[[ Bottom Filter ]]--

local BottomFilter = Addon:NewClass('BottomFilter', 'Frame', RuleFilter)
BottomFilter.Signals = {'RULE_CHANGED'}
BottomFilter.Button = Addon.BottomTab
BottomFilter.X, BottomFilter.Y = -10, 0
BottomFilter.FromPoint = 'LEFT'
BottomFilter.ToPoint = 'RIGHT'

function BottomFilter:IsShowning(rule)
	return rule.id:match(self:GetFrame().rule .. '/.+')
end
