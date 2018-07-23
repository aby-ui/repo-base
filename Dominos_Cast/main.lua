--[[
	the main controller of dominos progress
--]]

local AddonName, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local CastBarModule = Dominos:NewModule('CastBar')

function CastBarModule:OnInitialize()
	_G.CastingBarFrame.ignoreFramePositionManager = true
	_G.CastingBarFrame:UnregisterAllEvents()
	_G.PetCastingBarFrame:UnregisterAllEvents()
end

function CastBarModule:Load()
	self.frame = Addon.CastBar:New('cast_new', {'player', 'vehicle'})
end

function CastBarModule:Unload()
	if self.frame then
		self.frame:Free()
		self.frame = nil
	end
end
