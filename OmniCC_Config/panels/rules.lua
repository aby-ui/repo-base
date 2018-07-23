--[[
	General configuration settings for OmniCC
--]]

local OmniCCOptions = OmniCCOptions
local OmniCC = OmniCC
local L = OMNICC_LOCALS

--fun constants!
local BUTTON_SPACING = 0
local SLIDER_SPACING = 24

local function groupIdToGroup(groupId)
	for i, group in pairs(OmniCC.sets.groups) do
		if group.id == groupId then
			return group
		end
	end
end

local RuleOptions = CreateFrame('Frame', 'OmniCCOptions_Rules')
RuleOptions:SetScript('OnShow', function(self)
	self:AddWidgets()
	self:SetScript('OnShow', nil)
end)

function RuleOptions:GetGroupRules()
	return groupIdToGroup(OmniCCOptions:GetGroupId()).rules
end


--[[ Widgets ]]--

function RuleOptions:AddWidgets()
	self.rules = self:AddRulesEditor()
	self.rules:SetPoint('TOPLEFT', 12, -12)
	self.rules:SetPoint('TOPRIGHT', -12, -12)
	self.rules:SetHeight(332)
	self.rules:Load()
end

function RuleOptions:UpdateValues()
	self.rules:UpdateList()
end

function RuleOptions:AddRulesEditor()
	local parent = self
	local editor = OmniCCOptions.ListEditor:New('List', parent)

	editor.OnAddItem = function(self, ruleToAdd)
		table.insert(parent:GetGroupRules(), ruleToAdd)
		OmniCC:UpdateGroups()
		return true
	end

	editor.OnRemoveItem = function(self, ruleToRemove)
		local rules = parent:GetGroupRules()
		for i, rule in pairs(rules) do
			if rule == ruleToRemove then
				table.remove(rules, i)
				OmniCC:UpdateGroups()
				return true
			end
		end
	end

	editor.GetItems = function(self)
		local rules = parent:GetGroupRules()
		table.sort(rules)
		return rules
	end

	return editor
end


--[[ Load the thing ]]--

OmniCCOptions:AddTab('rules', L.RuleSettings, RuleOptions)