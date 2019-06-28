------------------------------------------------------------
-- Manager.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local type = type
local CreateFrame = CreateFrame
local format = format
local pairs = pairs
local ReloadUI = ReloadUI
local wipe = wipe
local InCombatLockdown = InCombatLockdown
local _G = _G

local _, addon = ...
local L = addon.L

local function Module_GetVisual(self, frame)
	return self.__visualFrames[frame]
end

local function Module_FindUnitFrame(self, unit, byGuid)
	return addon:FindUnitFrame(unit, byGuid)
end

local function Module_FindVisual(self, unit, byGuid)
	local unitFrame = Module_FindUnitFrame(self, unit, byGuid)
	if unitFrame then
		return Module_GetVisual(self, unitFrame)
	end
end

local function Module_EnumVisuals(self, object, func, ...)
	return addon._EnumFrames(self.__visualFrames, object, func, ...)
end

local function VisualFrame_GetUnitFrame(self)
	return self._unitFrame
end

local function OnCreateVisualEnumProc(unitFrame, module, dynamic)
	if Module_GetVisual(module, unitFrame) then
		return
	end

	local visualParent = unitFrame.visualParent
	local visual = CreateFrame(module.visualType or "Frame", module.visualName and visualParent:GetName().."_"..module.visualName or nil, visualParent, module.visualTemplate)
	visual:Hide()
	visual._unitFrame = unitFrame
	visual.GetUnitFrame = VisualFrame_GetUnitFrame
	module.__visualFrames[unitFrame] = visual
	module:OnCreateVisual(visual, unitFrame, dynamic)
end

local function OnUpdateNotifyEnumProc(frame, module)
	addon:CallModule(module, "OnUnitChange", frame, frame:GetUnitInfo())
	addon:CallModule(module, "OnUnitFlagChange", frame, frame:GetUnitFlag())
	addon:CallModule(module, "OnRangeChange", frame, frame:IsInRange())
	addon:CallModule(module, "OnRoleIconChange", frame, frame:GetRoleIconStatus())
	addon:CallModule(module, "OnRaidIconChange", frame, frame:GetRaidIconStatus())
	addon:CallModule(module, "OnAurasChange", frame, frame:GetUnitInfo())
end

local function EnumModuleProc_OnUnitNotify(module, frame, func, ...)
	if module:IsEnabled() then
		addon:CallModule(module, func, frame, ...)
	end
end

addon:RegisterEventCallback("OnUnitNotify", function(frame, func, ...)
	addon:EnumModules(EnumModuleProc_OnUnitNotify, frame, func, ...)
end)

local function CopyDefaultDB(module, key, db, ...)
	if type(db) ~= "table" then
		return
	end

	local defaults
	if type(module.GetDefaultDB) == "function" then
		defaults = module:GetDefaultDB(key, ...)
	end

	wipe(db)
	if defaults then
		addon.tcopy(defaults, db)
	end
end

local function Module_IsSpecsSynced(self)
	return self.spec and self.chardb.talent_Synced and "talent_Synced" or nil
end

local function Module_SyncSpecs(self)
	if not self.spec then
		return
	end

	local syncdb = self.chardb.talent_Synced
	if type(syncdb) ~= "table" then
		syncdb = addon.tcopy(self.talentdb)
		self.chardb.talent_Synced = syncdb
	end

	self.talentdb = syncdb
	self:Print(L["sync dual-talent enabled"])
	addon:BroadcastEvent("OnModuleSync", self)
end

local function Module_UnsyncSpecs(self)
	if not self.spec then
		return
	end

	local specdb = self.chardb["talent"..addon.spec]
	if type(specdb) ~= "table" then
		specdb = addon.tcopy(self.talentdb)
		self.chardb["talent"..addon.spec] = specdb
	end

	self.talentdb = specdb
	self.chardb.talent_Synced = nil
	self:Print(L["sync dual-talent disabled"])
	addon:BroadcastEvent("OnModuleUnsync", self)
end

local function Module_ShowVisuals(self, show)
	Module_EnumVisuals(self, show and "Show" or "Hide")
end

local function Module_IsEnabled(self)
	if self.dbType == "ACCOUNT" then
		return not self.db.disabled
	elseif self.dbType == "CHAR" then
		return not self.chardb.disabled
	else
		return true
	end
end

local function Module_Enable(self, force)
	if not force and self:IsEnabled() then
		return
	end

	if self.dbType == "ACCOUNT" then
		self.db.disabled = nil
	elseif self.dbType == "CHAR" then
		self.chardb.disabled = nil
	end

	if type(self.OnCreateVisual) == "function" then
		addon:EnumUnitFrames(OnCreateVisualEnumProc, self)
	end

	if type(self.OnEnable) == "function" then
		self:OnEnable()
	end

	if self.spec then
		self:OnSpecChange(addon.spec)
	end

	addon:EnumUnitFrames(OnUpdateNotifyEnumProc, self)

	self:Print(L["module enabled"])
	addon:BroadcastEvent("OnModuleEnable", self)
end

local function Module_Disable(self)
	if not self:IsEnabled() then
		return
	end

	if self.dbType == "ACCOUNT" then
		self.db.disabled = 1
	elseif self.dbType == "CHAR" then
		self.chardb.disabled = 1
	end

	self:UnregisterAllEvents()
	self:UnregisterTick()

	Module_ShowVisuals(self)

	if type(self.OnDisable) == "function" then
		self:OnDisable()
	end

	self:Print(L["module disabled"])
	addon:BroadcastEvent("OnModuleDisable", self)
end

local function Module_OnSpecChange(self, spec)
	if not self.spec then
		return
	end

	if Module_IsSpecsSynced(self) then
		self.talentdb = self.chardb.talent_Synced
		self:pcall(self.OnTalentGroupChange, self, "sync", self.talentdb)

		if self.optionPage then
			self.optionPage:SetSpecSymbol(0)
		end
	else
		local key = "talent"..spec
		local firstTime
		local talentdb = self.chardb[key]
		if type(self.chardb[key]) ~= "table" then
			firstTime = 1
			talentdb = {}
			self.chardb[key] = talentdb
			CopyDefaultDB(self, "talent", talentdb, spec)
		end
		self.talentdb = talentdb
		self:pcall(self.OnTalentGroupChange, self, spec, talentdb, firstTime)

		if self.optionPage then
			self.optionPage:SetSpecSymbol()
		end
	end
end

function addon:OnCreateModule(module, key, title, desc, spec, secure)
	module.name = key
	module.title = title or key
	module.desc = desc
	module.spec = spec
	module.secure = secure
	module.__visualFrames = {}

	module.Print = self.Print
	module.pcall = self.pcall
	module.RequestRestoreDefaults = self.RestoreModuleDefaults
	module.IsSpecsSynced = Module_IsSpecsSynced
	module.SyncSpecs = Module_SyncSpecs
	module.UnsyncSpecs = Module_UnsyncSpecs
	module.GetVisual = Module_GetVisual
	module.ShowVisuals = Module_ShowVisuals
	module.EnumVisuals = Module_EnumVisuals
	module.EnumUnitFrames = self.EnumUnitFrames
	module.OnSpecChange = Module_OnSpecChange
	module.FindUnitFrame = Module_FindUnitFrame
	module.FindVisual = Module_FindVisual

	module.IsEnabled = Module_IsEnabled
	module.Enable = Module_Enable
	module.Disable = Module_Disable

	self:BroadcastEvent("OnModuleCreated", module)
end

------------------------------------------------------------
-- Internal module events handling
------------------------------------------------------------

local function OnDynamicUnitFrameCreated(unitFrame)
	local i
	for i = 1, addon:NumModules() do
		local module = addon:GetModule(i)
		if module and module:IsEnabled() then
			addon:CallModuleFunc(module, "OnCreateDynamic", unitFrame)
			if type(module.OnCreateVisual) == "function" then
				OnCreateVisualEnumProc(unitFrame, module, 1)
			end
			OnUpdateNotifyEnumProc(unitFrame, module)
		end
	end
end

function addon:OnModulesInitDone()
	addon:CallAllEnabledModules("Enable", 1)
	addon:RegisterEventCallback("UnitButtonCreated", OnDynamicUnitFrameCreated)
end

------------------------------------------------------------
-- For modules' "Restore Defaults" features, new feature added in 0.2 beta
------------------------------------------------------------

local function OnConfirmRestore(module)
	if module.secure and InCombatLockdown() then
		module:Print(L["cannot cange these settings while in combat"], 1, 0, 0)
		return
	end

	if module ~= addon:GetCoreModule() then
		if module.dbType == "ACCOUNT" then
			CopyDefaultDB(module, "account", module.db)
		elseif module.dbType == "CHAR" then
			local talentKey, talentdb
			if module.spec and module.talentdb then
				talentKey = module:IsSpecsSynced()
				if not talentKey then
					talentKey = "talent"..(addon.spec or 1)
				end
				talentdb = module.talentdb
				CopyDefaultDB(module, "talent", talentdb)
			end

			CopyDefaultDB(module, "char", module.chardb)
			if talentKey then
				module.chardb[talentKey] = talentdb
			end
		end
	end

	if type(module.OnRestoreDefaults) == "function" then
		module:OnRestoreDefaults()
	end

	if module.requestReload then
		ReloadUI()
	else
		module:Print(L["defaults restored"])
		addon:BroadcastEvent("OnModuleRestoreDefaults", module)
	end
end

function addon:RestoreModuleDefaults(module)
	if type(module) == "table" then
		local text = format(module.requestReload and L["restore defaults text reloadui"] or L["restore defaults text"], module.title or module.name or UNKNOWN)
		addon:PopupShowConfirm(text, OnConfirmRestore, module)
	end
end