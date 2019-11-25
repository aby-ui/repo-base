-- Themes API
-- In OmniCC, a theme is a set of settings that define how cooldowns look

local _, Addon = ...

function Addon:AddTheme(id, name)
	if type(id) ~= "string" then
		error('Usage: {theme} = OmniCC:AddTheme("id", ["name"])', 3)
	end

	local themes = self.db.profile.themes

	local theme = rawget(themes, id)
	if not theme then
		theme = CopyTable(self:GetDefaultTheme())
		theme.name = name or id
		themes[id] = theme

		return theme
	end
end

function Addon:RemoveTheme(id)
	if type(id) ~= "string" then
		error('Usage: removed = OmniCC:RemoveTheme("id")', 3)
	end

	local themes = self.db.profile.themes
	if rawget(themes, id) ~= nil then
		-- when a theme is removed, adjust any rules using that theme
		-- to use the default theme instead
		for _, rule in pairs(self.db.profile.rules) do
			if rule.theme == id then
				rule.theme = self:GetDefaultThemeID()
			end
		end

		themes[id] = nil
		return true
	end
end

function Addon:GetTheme(id)
	if type(id) ~= "string" then
		error('Usage: {theme} = OmniCC:GetTheme("id")', 3)
	end

	return self.db.profile.themes[id]
end

function Addon:HasTheme(id)
	return id and rawget(self.db.profile.themes, id)
end

function Addon:GetDefaultThemeID()
	return self.db.profile.defaultTheme
end

function Addon:GetDefaultTheme()
	return self:GetTheme(self:GetDefaultThemeID())
end

function Addon:GetThemes()
	return pairs(self.db.profile.themes)
end