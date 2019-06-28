------------------------------------------------------------
-- Scrollable.lua
--
-- Abin
-- 2012/1/26
------------------------------------------------------------

local type = type
local InCombatLockdown = InCombatLockdown

local _, addon = ...
local L = addon.L
local templates = addon.templates

local PREFIX = [[
	local count = self:GetAttribute("spellCount") or 0
	if count > 1 then
		local index = self:GetAttribute("index") - (delta or 0)
		if index < 1 then
			index = count
		elseif index > count then
			index = 1
		end
		self:SetAttribute("index", index)
		local spell = self:GetAttribute("spellList"..index)
		local attr = self:GetAttribute("scrollattr")
		if attr then
			self:SetAttribute(attr, spell)
		end
]]

local SURFIX = [[
		self:CallMethod("_OnIndexChanged", index, 1)
	end
]]

local function Button_UpdateAttribute(self, index)
	-- local attr = self:GetAttribute("scrollattr")
	-- if attr then
	-- 	local value = self:GetAttribute("spellList"..index)
	-- 	self:SetAttribute(attr, value)
	-- end
    if(index) then self:SetAttribute('index', index) end
    return self:Execute[[ self:RunAttribute'_onmousewheel' ]]
end

local function Button_OnIndexChanged(self, index, save)
	self.index = index
	self:SetSpell(self.spellList[index])
	if self.spellList2 then
		self:SetSpell2(self.spellList2[index])
	end

	if save then
		addon:SaveData("specdb", self.key, index)
	end

	self:Call("OnIndexChanged", index, self.spell)
end

local function Button_SetMaxIndex(self, maxIndex)
	if InCombatLockdown() then
		return
	end

	if type(maxIndex) ~= "number" or maxIndex < 1 or maxIndex >= #self.spellList then
		maxIndex = nil
	end

	self.maxIndex = maxIndex
	if maxIndex then
		self:SetAttribute("spellCount", maxIndex)
		if self.index > maxIndex then
			Button_OnIndexChanged(self, maxIndex, 1)
			Button_UpdateAttribute(self, maxIndex)
		end
	else
		self:SetAttribute("spellCount", #self.spellList)
	end
end

local function Button_OnTalentSwitch(self)
	local index = addon:LoadData("specdb", self.key)
	if type(index) ~= "number" or index < 1 or index > #self.spellList then
		index = 1
	end

	self:SetAttribute("index", index)
	Button_OnIndexChanged(self, index)
	Button_UpdateAttribute(self, index)
	self:UpdateTimer()
end

local function Button_GetListSpell(self, index)
	return self.spellList[index]
end

local function Button_ModifyListSpell(self, index, data)
	if type(data) ~= "table" then
		return
	end

	local old = Button_GetListSpell(self, index)
	if data ~= old then
		self.spellList[index] = data
		if self.index == index then
			Button_OnIndexChanged(self, index)
			Button_UpdateAttribute(self, index)
			self:UpdateTimer()
		end
	end

	return old
end

local function Button_OnTooltipScrollText(self, tooltip)
	tooltip:AddLine(L["mouse wheel choose"]..self.category, 1, 1, 1, 1)
end

function templates.SetButtonScrollable(button, spellList, attr, snippet)
	if type(attr) ~= "string" then
		attr = "spell"
	end

	if type(spellList) ~= "table" then
		spellList = {}
	end

	button.spellList = spellList
	local scrollSnippet = PREFIX
	if type(snippet) == "string" then
		scrollSnippet = scrollSnippet.."\n"..snippet
	end
	scrollSnippet = scrollSnippet.."\n"..SURFIX

	button:SetAttribute("_onmousewheel", scrollSnippet)
	button:SetAttribute("index", 1)
	button:SetAttribute("spellCount", #spellList)
	button:SetAttribute("scrollattr", attr)

	local i
	for i = 1, #spellList do
		local data = spellList[i]
		if type(data) == "table" then
			button:SetAttribute("spellList"..i, data.id)
			if i == 1 then
				button:SetAttribute(attr, data.id) --fix
			end
		end
	end

	button.OnTooltipScrollText = Button_OnTooltipScrollText
	button._OnIndexChanged = Button_OnIndexChanged
	button.SetMaxIndex = Button_SetMaxIndex
	button.GetListSpell = Button_GetListSpell
	button.ModifyListSpell = Button_ModifyListSpell
	Button_OnIndexChanged(button, 1)
	button:HookMethod("OnTalentSwitch", Button_OnTalentSwitch)


    button.__UpdateScrollAttr_163 = Button_UpdateAttribute
end
