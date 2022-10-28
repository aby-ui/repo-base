--[[
	general.lua
		General settings menu
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local General = Addon.OptionsGroup('GeneralOptions', '|TInterface/Addons/BagBrother/Art/'..ADDON..'-Small:16:16|t')

function General:Populate()
	self:AddCheck('locked')
	self:AddCheck('tipCount')

	if CanGuildBankRepair and self.sets.tipCount then
		local guild = self:AddCheck('countGuild')
		guild.left = guild.left + 10
		guild:SetSmall(true)
	end

	self:AddCheck('flashFind')
	self:AddCheck('displayBlizzard')

	local global = self:Add('Check', L.CharacterSpecific)
	global:SetChecked(Addon.profile ~= Addon.sets.global)
	global:SetCall('OnInput', function() self:ToggleGlobals() end)
end

function General:ToggleGlobals()
	if Addon.profile == Addon.sets.global then
		self:SetProfile(CopyTable(Addon.sets.global))
	else
		LibStub('Sushi-3.1').Popup {
			id = ADDON .. 'ConfirmGlobals',
			text = L.ConfirmGlobals, button1 = YES, button2 = NO,
			whileDead = 1, exclusive = 1, hideOnEscape = 1,
			OnAccept = function()
				self:SetProfile(nil)
				self:Update()
			end
		}
	end
end

function General:SetProfile(profile)
	Addon:SetCurrentProfile(profile)
	Addon.Frames:Update()
end
