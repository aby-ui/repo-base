local OmniCC = CreateFrame('Frame', 'OmniCC', InterfaceOptionsFrame)
local L = _G.OMNICC_LOCALS

function OmniCC:Startup()
	self.effects = {}

	self:SetupCommands()

	self:SetScript('OnEvent', function(f, event, ...)
		f[event](f, event, ...)
	end)

	self:SetScript('OnShow', function(f)
		LoadAddOn('OmniCC_Config')

		f:SetScript('OnShow', nil)
	end)

	SetCVar('countdownForCooldowns', 0)

	self:RegisterEvent('VARIABLES_LOADED')
end

function OmniCC:SetupCommands()
	SLASH_OmniCC1 = '/omnicc'

	SLASH_OmniCC2 = '/occ'

	SlashCmdList['OmniCC'] = function(...)
		if ... == 'version' then
			print(L.Version:format(self:GetVersion()))
		elseif self.ShowOptionsMenu or LoadAddOn('OmniCC_Config') then
			if type(self.ShowOptionsMenu) == "function" then
				self:ShowOptionsMenu()
			end
		end
	end
end

function OmniCC:SetupEvents()
	self:UnregisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function OmniCC:SetupHooks()
	self.Meta = getmetatable(ActionButton1Cooldown).__index

	hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", function(cooldown)
		cooldown.noCooldownCount = true
		self.Cooldown.Stop(cooldown)
	end)

	hooksecurefunc(self.Meta, 'SetCooldown', self.Cooldown.Start)
	hooksecurefunc(self.Meta, 'SetSwipeColor', self.Cooldown.OnColorSet)
	hooksecurefunc('SetActionUIButton', self.Actions.Add)


end

--[[ Events ]]--

function OmniCC:ACTIONBAR_UPDATE_COOLDOWN()
	self.Actions:Update()
end

function OmniCC:PLAYER_ENTERING_WORLD()
	self.Timer:ForAll('UpdateText')
end

function OmniCC:VARIABLES_LOADED()
	self:StartupSettings()
	self.Actions:AddDefaults()
	self:SetupEvents()
	self:SetupHooks()
end

--[[ Modules ]]--

function OmniCC:New(name, module)
	self[name] = module or LibStub('Classy-1.0'):New('Frame')
	return self[name]
end

OmniCC:Startup()