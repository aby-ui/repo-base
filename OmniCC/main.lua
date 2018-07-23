--[[
	startup.lua
		initializes OmniCC
--]]

local OmniCC = CreateFrame('Frame', 'OmniCC')
local Classy = LibStub('Classy-1.0')
local L = OMNICC_LOCALS


--[[ Startup ]]--

function OmniCC:Startup()
	self.effects = {}
	self:SetupConfig()
	self:SetupCommands()
	self:RegisterEvent('VARIABLES_LOADED')
	self:SetScript('OnEvent', function(self, event)
		self[event](self)
	end)
	
	SetCVar('countdownForCooldowns', 0)
end

function OmniCC:VARIABLES_LOADED()
	self:StartupSettings()
	self.Actions:AddDefaults()
	self:SetupEvents()
	self:SetupHooks()
end


--[[ Setup ]]--

function OmniCC:SetupHooks()
	self.Meta = getmetatable(ActionButton1Cooldown).__index

	hooksecurefunc(self.Meta, 'SetCooldown', self.Cooldown.Start)
	hooksecurefunc(self.Meta, 'SetSwipeColor', self.Cooldown.OnColorSet)
	hooksecurefunc('SetActionUIButton', self.Actions.Add)
end

function OmniCC:SetupEvents()
	self:UnregisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function OmniCC:SetupConfig()
	local config = CreateFrame('Frame', 'OmniCC_Config', InterfaceOptionsFrame)
	config.name = 'OmniCC'
	config:SetScript('OnShow', function()
		local loaded, reason = LoadAddOn('OmniCC_Config')
		if not loaded then
			local string = config:CreateFontString(nil, nil, 'GameFontHighlight')
			local reason = _G['ADDON_'..reason]:lower()
			
			string:SetText(L.ConfigMissing:format('OmniCC_Config', reason))
			string:SetPoint('RIGHT', -40, 0)
			string:SetPoint('LEFT', 40, 0)
			string:SetHeight(30)
		end 

		InterfaceOptions_AddCategory(config)
		config:SetScript('OnShow', nil)
	end)
end

function OmniCC:SetupCommands()
	SLASH_OmniCC1 = '/omnicc'
	SLASH_OmniCC2 = '/occ'
	SlashCmdList['OmniCC'] = function(...)
		if comand == 'version' then
			print(L.Version:format(self:GetVersion()))
		elseif LoadAddOn('OmniCC_Config') then
			InterfaceOptionsFrame:Show()
			InterfaceOptionsFrame_OpenToCategory('OmniCC')
		end
	end
end


--[[ Events ]]--

function OmniCC:ACTIONBAR_UPDATE_COOLDOWN()
	self.Actions:Update()
end

function OmniCC:PLAYER_ENTERING_WORLD()
	self.Timer:ForAll('UpdateText')
end


--[[ Modules ]]--

function OmniCC:New(name, module)
	self[name] = module or Classy:New('Frame')
	return self[name]
end

OmniCC:Startup()