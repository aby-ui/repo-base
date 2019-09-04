--[[
	commands.lua
		Defines keybindings and a slash command menu
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)


--[[ Keybindings ]]--

do
	local ADDON_UPPER = ADDON:upper()
	_G['BINDING_HEADER_' .. ADDON_UPPER] = ADDON
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_TOGGLE'] = L.ToggleBags
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_BANK_TOGGLE'] = L.ToggleBank
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_VAULT_TOGGLE'] = L.ToggleVault
	_G['BINDING_NAME_' .. ADDON_UPPER .. '_GUILD_TOGGLE'] = L.ToggleGuild
end


--[[ Slash Commands ]]--

function Addon:CreateSlashCommands(...)
	for i = 1, select('#', ...) do
		local command = select(i, ...)
		SlashCmdList[command] = function(...) self:OnSlashCommand(...) end
		_G['SLASH_'..command..'1'] = '/' .. command
	end
end

function Addon:OnSlashCommand(cmd)
	cmd = cmd and cmd:lower() or ''

	if cmd == 'bank' then
		self:ToggleFrame('bank')
	elseif cmd == 'bags' or cmd == 'inventory' then
		self:ToggleFrame('inventory')
	elseif cmd == 'guild' and Addon.HasGuild and LoadAddOn(ADDON .. '_GuildBank')then
		self:ToggleFrame('guild')
	elseif cmd == 'vault' and Addon.HasVault and LoadAddOn(ADDON .. '_VoidStorage') then
		self:ToggleFrame('vault')
	elseif cmd == 'version' then
		print('|cff33ff99' .. ADDON .. '|r version ' .. GetAddOnMetadata(ADDON, 'Version'))
	elseif cmd == 'config' or cmd == 'options' then
		self:ShowOptions()
	else
		self:PrintHelp()
	end
end

function Addon:PrintHelp()
	local function PrintCmd(cmd, desc, addon)
		if not addon or GetAddOnEnableState(UnitName('player'), addon) >= 2 then
			print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
		end
	end

	print('|cff33ff99' .. ADDON .. '|r ' .. L.Commands)
	PrintCmd('bags', L.CmdShowInventory)
	PrintCmd('bank', L.CmdShowBank)
	PrintCmd('guild', L.CmdShowGuild, ADDON .. '_GuildBank')
	PrintCmd('vault', L.CmdShowVault,  ADDON .. '_VoidStorage')
	PrintCmd('config/options', L.CmdShowOptions)
	PrintCmd('version', L.CmdShowVersion)
end

--[[ Options ]]--

function Addon:CreateOptionsLoader()
	CreateFrame('Frame', nil, InterfaceOptionsFrame):SetScript('OnShow', function(self)
		LoadAddOn(ADDON .. '_Config')
	end)
end

function Addon:ShowOptions()
	if LoadAddOn(ADDON .. '_Config') then
		InterfaceOptionsFrame_OpenToCategory(ADDON)
		InterfaceOptionsFrame_OpenToCategory(ADDON) -- sometimes once not enough
	end
end
