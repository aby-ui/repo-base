local XLoot = LibStub("AceAddon-3.0"):NewAddon(select(2, ...), "XLoot")
_G.XLoot = XLoot
local L = XLoot.L
local print, wprint = print, print

-------------------------------------------------------------------------------
-- Settings
local defaults = {
	profile = {
		skin = "smooth",
		skin_anchors = false
	}
}


-------------------------------------------------------------------------------
-- Module helpers

-- Return module localization with new module
local _NewModule = XLoot.NewModule
function XLoot:NewModule(module_name, ...)
	local new = _NewModule(self, module_name, ...)
	return new, self["L_"..module_name]
end

local _GetModule = XLoot.GetModule
function XLoot:GetModule(module_name, ...)
	return module_name == "Core" and XLoot or _GetModule(self, module_name, ...)
end

-- Set up basic event handler
local function SetEventHandler(addon, frame)
	if not frame then
		frame = CreateFrame("Frame")
		addon.eframe = frame
	end
	frame:SetScript("OnEvent", function(self, event, ...)
		if addon[event] then
			addon[event](addon, ...)
		end
	end)
end

XLoot.slash_commands = {}
function XLoot:SetSlashCommand(slash, func)
	local key = "XLOOT_"..slash
	_G["SLASH_"..key.."1"] = "/"..slash
	_G.SlashCmdList[key] = func
end

function XLoot:ShowOptionPanel(module)
	if not XLootOptions then
		EnableAddOn("XLoot_Options")
		LoadAddOn("XLoot_Options")
	end
	XLootOptions:OpenPanel(module)
end

function XLoot:ApplyOptions(in_options)
	self.opt = self.db.profile
	-- Update skin
	XLoot:SetSkin(self.opt.skin)
	for _,v in ipairs(XLoot.skinners) do
		v:Reskin()
	end
	-- Update all modules
	for k,v in pairs(XLoot.modules) do
		if v.db then
			v.opt = v.db.profile
		end
		if v.ApplyOptions then
			v:ApplyOptions(in_options)
		end
	end
end

-- Add shortcuts for modules
XLoot:SetDefaultModulePrototype({
	InitializeModule = function(self, defaults, frame)
		local module_name = self:GetName()
		-- Set up DB namespace
		self.db = XLoot.db:RegisterNamespace(module_name, defaults)
		self.opt = self.db.profile
		
		function self.ShowOptions()
			XLoot:ShowOptionPanel(self)
		end
		-- Default slash command
		XLoot:SetSlashCommand(("XLoot"..module_name):lower(), self.ShowOptions)
		-- Set event handler
		self:SetEventHandler(frame)
	end,
	SetEventHandler = SetEventHandler,
	OnProfileChanged = XLoot.OnProfileChanged,
})

-------------------------------------------------------------------------------
-- Prototype helper

function XLoot.Prototype_New(self, new)
	local new = new or {}
	for k,v in pairs(self) do
		if k ~= "New" and k ~= "_New" then
			if new[k] ~= nil then
				new['_'..k] = new[k]
			end
			rawset(new, k, v)
		end
	end
	return new
end

function XLoot.NewPrototype()
	return { New = XLoot.Prototype_New, _New = XLoot.Prototype_New }
end

-------------------------------------------------------------------------------
-- Addon init

function XLoot:OnInitialize()
	-- Init DB
	self.db = LibStub("AceDB-3.0"):New("XLootADB", defaults, true)
	self.opt = self.db.profile
	self.db.RegisterCallback(self, "OnProfileChanged", "ApplyOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "ApplyOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "ApplyOptions")
	-- Load skins, import Masque skins
	self:SkinsOnInitialize()
end

function XLoot:OnEnable()
	-- Check for old addons
	for _,name in ipairs({ "XLoot1.0", "XLootGroup", "XLootMaster", "XLootMonitor" }) do
		if IsAddOnLoaded(name) then
			DisableAddOn(name)
			wprint(("|c2244dd22XLoot|r now includes |c2244dd22%s|r - the old version will be disabled on next load, and no longer needs to be installed."):format(name))
		end
	end	

	-- Create option stub
	local stub = CreateFrame("Frame", "XLootConfigPanel", UIParent)
	stub.name = "XLoot"
	stub:Hide()
	InterfaceOptions_AddCategory(stub)
	stub:SetScript("OnShow", function() self:ShowOptionPanel(self) end)
	self:SetSlashCommand("xloot", function() self:ShowOptionPanel(self) end)
end


