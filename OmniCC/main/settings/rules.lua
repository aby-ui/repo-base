-- Rules API
-- Rules are use for looking up what theme to apply to a cooldown
local _, Addon = ...

function Addon:AddRule(id, theme)
	if not id then
		error("Usage: OmniCC:AddRule('id', [theme])", 2)
	end

	local rules = self.db.profile.rules

	-- skip if the rule already exists
	for _, rule in pairs(rules) do
		if rule.id == id then
			return false
		end
	end

	local rule = {
		id = id,
		theme = theme or self:GetDefaultThemeID(),
		enabled = true,
		priority = #rules + 1,
		patterns = { }
	}

	tinsert(rules, rule)
	return rule, #rules
end

function Addon:RemoveRule(id)
	if not id then
		error("Usage: OmniCC:RemoveRule('id')", 2)
	end

	local rules = self.db.profile.rules

	for i, rule in pairs(rules) do
		if rule.id == id then
			tremove(rules, i)
			return true
		end
	end
end

function Addon:SetRulePriority(id, priority)
	if not (id and priority) then
		error("Usage: OmniCC:SetRulePriority('id', priority)", 2)
	end

	local updated = false

	for _, rule in pairs(self.db.profile.rules) do
		if rule.id == id and rule.priority ~= priority then
			rule.priority = priority
			updated = true
			break
		end
	end

	if updated then
		self:ReorderRules()
	end

	return updated
end

function Addon:ReorderRules()
	table.sort(self.db.profile.rules, function(l, r)
		return l.priority < (r.priority or math.huge)
	end)

	for i, rule in pairs(self.db.profile.rules) do
		rule.priority = i
	end
end

function Addon:HasRule(id)
	if not id then
		error("Usage: OmniCC:HasRule('id')", 2)
	end

	for _, rule in pairs(self.db.profile.rules) do
		if rule.id == id then
			return true
		end
	end
end

function Addon:GetRulesets()
	return ipairs(self.db.profile.rules)
end

function Addon:NumRulesets()
	return #self.db.profile.rules
end

do
	local function nextActiveRule(rules, index)
		if not rules then return end

		for i = index + 1, #rules do
			local rule = rules[i]
			if rule.enabled then
				return i, rule
			end
		end
	end

	function Addon:GetActiveRulesets()
		return nextActiveRule, self.db.profile.rules, 0
	end
end

function Addon:GetMatchingRule(name)
	if name then
		for _, rule in self:GetActiveRulesets() do
			local patterns = rule.patterns
			for i = 1, #patterns do
				if name:match(patterns[i]) then
					return rule
				end
			end
		end
	end

	return false
end