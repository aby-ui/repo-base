--[[ groups.lua: manages group behaviour ]]--

local Addon = _G[...]

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

function Addon:GetCooldownSettings(cooldown)
	local id = self:GetCooldownGroupID(cooldown)
	if id then
		return self:GetGroupSettings(id)
	end
end

function Addon:GetCooldownGroupID(cooldown)
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

function Addon:GetGroupSettings(id)
	if self.sets then
		return self.sets.groupSettings[id]
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
	self.Cooldown:UpdateSettings()
	self.Display:ForActive("UpdateCooldownText")
end
