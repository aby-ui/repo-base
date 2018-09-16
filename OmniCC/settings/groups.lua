--[[
	groups.lua
		manages group behaviour
--]]

local Addon = _G[...]

Addon.Cache = {}


--[[ Queries ]]--

function Addon:GetGroupSettingsFor(cooldown)
	local group = self:GetGroup(cooldown)

	if group then
		return self:GetGroupSettings(group)
	end
end

function Addon:GetGroupSettings(group)
	if self.sets then
		return self.sets.groupSettings[group]
	end
end

function Addon:GetGroup(cooldown)
	local id = self.Cache[cooldown]
	if not id then
		id = self:FindGroup(cooldown)
		self.Cache[cooldown] = id
	end

	return id
end

local function getFirstAncestorWithName(cooldown)
	local frame = cooldown
	repeat
		local name = frame:GetName()
		if name then
			return name
		end
		frame = frame:GetParent()
	until not frame
end

function Addon:FindGroup(cooldown)
	if self.sets then
		local name = getFirstAncestorWithName(cooldown)

		if name then
			local groups = self.sets.groups

			for i = #groups, 1, -1 do
				local group = groups[i]

				if group.enabled then
					for _, pattern in pairs(group.rules) do
						if name:match(pattern) then
							return group.id
						end
					end
				end
			end
		end

		return 'base'
	end
end

function Addon:GetGroupIndex(id)
	for i, group in pairs(self.sets.groups) do
		if group.id == id then
			return i
		end
	end
end

--[[ Modifications ]]--

function Addon:AddGroup(id)
	if not self:GetGroupIndex(id) then
		self.sets.groupSettings[id] = self:StartupGroup(CopyTable(self.sets.groupSettings['base']))
		tinsert(self.sets.groups, {id = id, rules = {}, enabled = true})

		self:UpdateGroups()
		return true
	end
end

function Addon:RemoveGroup(id)
	local index = self:GetGroupIndex(id)
	if index then
		self.sets.groupSettings[id] = nil
		tremove(self.sets.groups, index)

		self:UpdateGroups()
		return true
	end
end

function Addon:UpdateGroups()
	for cooldown, group in pairs(self.Cache) do
		local newGroup = self:FindGroup(cooldown)
		if group ~= newGroup then
			self.Cache[cooldown] = newGroup
			self.Display:ForActive("UpdateTimer")
		end
	end
end
