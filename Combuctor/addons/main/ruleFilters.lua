--[[
	ruleFilter.lua
		A list of tabs representing item rulesets
--]]

local ADDON, Addon = ...
local RuleFilter = Addon.Parented:NewClass('RuleFilter', 'Frame')

function RuleFilter:New(parent)
	local f = self:Super(RuleFilter):New(parent)
	f.buttons = {[0] = f}
	f:SetSize(10, 30)
	f:RegisterFrameSignal('RULES_UPDATED', 'Update')
	f:RegisterSignal('UPDATE_ALL', 'Update')
	f:Startup()
	f:Update()
	return f
end

function RuleFilter:Update()
	local n = 1

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

	if n == 2 then -- if one filter, hide all
		n = 1
	end

	for k = n, #self.buttons do
		self.buttons[k]:Hide()
	end
	self.numButtons = n
end


--[[ Side Filter ]]--

local SideFilter = Addon.RuleFilter:NewClass('SideFilter')
SideFilter.X, SideFilter.Y = 0, -17
SideFilter.Button = Addon.SideTab
SideFilter.FromPoint = 'TOPLEFT'
SideFilter.ToPoint = 'BOTTOMLEFT'

function SideFilter:Startup() end
function SideFilter:IsShowning(rule)
	return not rule.id:find('/')
end


--[[ Bottom Filter ]]--

local BottomFilter = Addon.RuleFilter:NewClass('BottomFilter')
BottomFilter.X, BottomFilter.Y = -10, 0
BottomFilter.Button = Addon.BottomTab
BottomFilter.FromPoint = 'LEFT'
BottomFilter.ToPoint = 'RIGHT'

function BottomFilter:Startup()
	self:RegisterFrameSignal('RULE_CHANGED', 'Update')
end

function BottomFilter:IsShowning(rule)
	local parent = self:GetFrame().rule
	return parent and (rule.id == parent or rule.id:match('^' .. parent .. '/.+'))
end
