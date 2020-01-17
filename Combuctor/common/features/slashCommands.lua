--[[
	commands.lua
		Defines keybindings and a slash command menu
--]]


local ADDON, Addon = ...
local Slash = Addon:NewModule('Commands')
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

function Slash:OnEnable()
	for i, command in ipairs({ADDON, Addon.Slash})  do
		SlashCmdList[command] = self.OnSlashCommand
		_G['SLASH_'..command..'1'] = '/' .. command
	end
end

function Slash.OnSlashCommand(cmd)
	local cmd = cmd and cmd:lower() or ''
	if cmd == 'bags' or cmd == 'inventory' then
		Addon.Frames:Toggle('inventory')
	elseif cmd == 'bank' then
		Addon.Frames:Toggle('bank')
	elseif cmd == 'guild' then
		Addon.Frames:Toggle('guild')
	elseif cmd == 'vault' then
		Addon.Frames:Toggle('vault')
	elseif cmd == 'version' then
		print('|cff33ff99' .. ADDON .. '|r version ' .. Addon.Version)
	elseif cmd == 'config' or cmd == 'options' then
		Addon:ShowOptions()
	else
		Slash:PrintHelp()
	end
end

function Slash:PrintHelp()
	print('|cff33ff99' .. ADDON .. '|r ' .. L.Commands)
	self:Print('bags', L.CmdShowInventory)
	self:Print('bank', L.CmdShowBank)
	self:Print('guild', L.CmdShowGuild, Addon.LoadGuild)
	self:Print('vault', L.CmdShowVault, Addon.LoadVault)
	self:Print('config/options', L.CmdShowOptions)
	self:Print('version', L.CmdShowVersion)
end

function Slash:Print(cmd, desc, requirement)
	if requirement ~= false then
		print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end
end
