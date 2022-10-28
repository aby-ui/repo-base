--[[
	shared.lua
		Options menu class with API shared among all panels
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local Group = Addon:NewModule('OptionsGroup', LibStub('Sushi-3.1').OptionsGroup:NewClass())


--[[ Groups ]]--

function Group:New(id, icons)
	local parent = self ~= Group and self
	local f = Addon:NewModule(id, Group:Super(Group):New(parent or (icons .. ' ' .. ADDON), parent and (L[id] .. ' ' .. icons)))
	f:SetFooter('By João Cardoso and Jason Greer')
	f:SetSubtitle(L[id .. 'Desc']:format(ADDON))
	f:SetChildren(function() f:Populate() end)
	f.sets, f.frame = Addon.sets, 'inventory'
	return f
end

function Group:AddRow(height, children)
	local group = self:Add('Group')
	group:SetHeight(height)
	group:SetResizing('HORIZONTAL')
	group:SetChildren(function(row) self.row = row; children(row); self.row = nil end)
	return group
end


--[[ Singletons ]]--

function Group:AddCheck(arg)
	local b = self:AddLabeled('Check', arg)
	b:SetCall('OnClick', function(_,_, v) self.sets[arg] = v end)
	b:SetValue(self.sets[arg])
	return b
end

function Group:AddColor(arg)
	local b = self:AddLabeled('ColorPicker', arg)
	b:SetCall('OnColor', function(_, v) self.sets[arg] = {v:GetRGBA()} end)
	b:SetValue(CreateColor(self.sets[arg][1], self.sets[arg][2], self.sets[arg][3], self.sets[arg][4]))
	return b
end

function Group:AddSlider(arg, min,max)
	local s = self:AddLabeled('Slider', arg)
	s:SetCall('OnValue', function(_, v) self.sets[arg] = v end)
	s:SetRange(min, max)
	s:SetValue(self.sets[arg])
	return s
end

function Group:AddPercentage(arg, min,max)
	local s = self:AddLabeled('Slider', arg)
	s:SetCall('OnValue', function(_, v) self.sets[arg] = v/100 end)
	s:SetRange(min or 1, max or 100)
	s:SetValue(self.sets[arg] * 100)
	s:SetPattern('%s%')
	return s
end

function Group:AddChoice(data)
	local choice = self:AddLabeled('DropChoice', data.arg)
	choice:SetCall('OnValue', function(_, v) self.sets[data.arg] = v end)
	choice:SetValue(self.sets[data.arg])
	choice:AddChoices(data)
	return choice
end

function Group:AddLabeled(class, id)
	local label = id:gsub('^.', strupper)
	local tip = L[label .. 'Tip']

	local f = (self.row or self):Add(class, L[label])
	f:SetCall('OnInput', function() Addon.Frames:Update() end)
	f:SetTip(tip and f:GetLabel(), tip)
	return f
end


--[[ Specific ]]--

function Group:AddFrameChoice()
	local choice = self:Add('DropChoice', L.Frame, self.frame)
	choice:SetCall('OnInput', function(_, id) self.frame = id end)

	for i, frame in Addon.Frames:Iterate() do
		if frame.addon ~= false then
			choice:AddChoices(frame.id, frame.name)
		end
	end
	return choice
end
