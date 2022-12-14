local E, L = select(2, ...):unpack()

local ACD_Tooltip = E.Libs.ACD.tooltip
local DB_VERSION = 3

function E:CreateFontObjects()
	self.GameFontNormal = CreateFont("GameFontNormal-OmniCD")
	self.GameFontNormal:CopyFontObject("GameFontNormal")
	self.GameFontHighlight = CreateFont("GameFontHighlight-OmniCD")
	self.GameFontHighlight:CopyFontObject("GameFontHighlight")
	self.GameFontDisabled = CreateFont("GameFontDisable-OmniCD")
	self.GameFontDisabled:CopyFontObject("GameFontDisable")
	self.GameFontNormalSmall = CreateFont("GameFontNormalSmall-OmniCD")
	self.GameFontNormalSmall:CopyFontObject("GameFontNormalSmall")
	self.GameFontHighlightSmall = CreateFont("GameFontHighlightSmall-OmniCD")
	self.GameFontHighlightSmall:CopyFontObject("GameFontHighlightSmall")
	self.IconFont = CreateFont("IconFont-OmniCD")
	self.IconFont:CopyFontObject("GameFontHighlightSmallOutline")
	self.AnchorFont = CreateFont("AnchorFont-OmniCD")
	self.AnchorFont:CopyFontObject("GameFontNormal")
	self.StatusBarFont = CreateFont("StatusBarFont-OmniCD")
	self.StatusBarFont:CopyFontObject("GameFontHighlightHuge")
end

function E:UpdateFontObjects()
	local optionFont = self.profile.General.fonts.option
	local optionFontSmall = self.profile.General.fonts.optionSmall

	for i = 1, select("#", ACD_Tooltip:GetRegions()) do
		local region = select(i, ACD_Tooltip:GetRegions())
		if region and region:GetObjectType() == "FontString" then
			self:SetFontProperties(region, optionFont)
		end
	end
	self:SetFontProperties(self.GameFontNormal, optionFont)
	self:SetFontProperties(self.GameFontHighlight, optionFont)
	self:SetFontProperties(self.GameFontDisabled, optionFont)
	self:SetFontProperties(self.GameFontNormalSmall, optionFontSmall)
	self:SetFontProperties(self.GameFontHighlightSmall, optionFontSmall)
	self:SetFontProperties(self.AnchorFont, self.profile.General.fonts.anchor)
	self:SetFontProperties(self.IconFont, self.profile.General.fonts.icon)
	self:SetFontProperties(self.StatusBarFont, self.profile.General.fonts.statusBar)
end

function E:SetPixelMult()
	local _, screenheight = GetPhysicalScreenSize()
	local uiUnitFactor = 768 / screenheight
	local uiScale = UIParent:GetScale()
	self.PixelMult = uiUnitFactor / uiScale
	self.uiUnitFactor = uiUnitFactor
end

function E:OnInitialize()
	if not OmniCDDB or not OmniCDDB.version or  OmniCDDB.version < 2.51 then
		OmniCDDB = { version = DB_VERSION }
	elseif OmniCDDB.version < DB_VERSION then
		OmniCDDB.version = DB_VERSION
	end
	OmniCDDB.cooldowns = OmniCDDB.cooldowns or {}

	self.DB = LibStub("AceDB-3.0"):New("OmniCDDB", self.defaults, true)
	self.DB.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.DB.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.DB.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.global = self.DB.global
	self.profile = self.DB.profile
	self.db = self.profile.Party.arena

	if not self.preCata then
		self.DummyFrame:RegisterEvent('PET_BATTLE_OPENING_START')
	end
	self.DummyFrame:SetScript("OnEvent", function(self, event, ...)
		self[event](self, ...)
	end)

	self:CreateFontObjects()
	self:UpdateSpellList(true)
	self:SetupOptions()

end

function E:OnEnable()

	for i = 1, 13 do
		if i > 3 then
			ACD_Tooltip:AddLine(" ")
		else
			ACD_Tooltip:AddDoubleLine(" ", " ")
		end
	end

	self:LoadAddOns()


	self:SetPixelMult()
	self.BackdropTemplate(ACD_Tooltip)
	ACD_Tooltip:SetBackdropColor(0, 0, 0)
	ACD_Tooltip:SetBackdropBorderColor(0.3, 0.3, 0.3)

	self:Refresh()

	if self.global.loginMessage then
		print(self.LoginMessage)
	end

	self.enabled = true
end

function E:Refresh(arg)
	self.profile = self.DB.profile

	self:UpdateFontObjects()

	for moduleName in pairs(self.moduleOptions) do
		local module = self[moduleName]

		local init = module.Initialize
		if init and type(init) == "function" then
			init()
			module.Initialize = nil
		end

		local enabled = self:GetModuleEnabled(moduleName)
		if enabled then
			if module.enabled then
				module:Refresh(true)
			else
				module:Enable()
			end
		else
			module:Disable()
		end
	end

	if arg == "OnProfileReset" then
		self.global.disableElvMsg = nil
	end
end

function E:GetModuleEnabled(moduleName)
	return self.profile.modules[moduleName]
end

function E:SetModuleEnabled(moduleName, isEnabled)
	self.profile.modules[moduleName] = isEnabled

	local module = self[moduleName]
	if isEnabled then
		module:Enable()
	else
		module:Disable()
	end
end

function E.DummyFrame:PET_BATTLE_CLOSE()
	for moduleName in pairs(E.moduleOptions) do
		local module = E[moduleName]
		local func = module.Refresh
		if type(func) == "function" then
			func(module, true)
		end
	end
	E.DummyFrame:UnregisterEvent('PET_BATTLE_CLOSE')
end

function E.DummyFrame:PET_BATTLE_OPENING_START()

	for moduleName in pairs(E.moduleOptions) do
		local module = E[moduleName]
		local func = module.Test
		if type(func) == "function" and module.isInTestMode then
			func(module)
		end

		local func = module.HideAllBars
		if type(func) == "function" then
			func(module)
		end
	end
	E.DummyFrame:RegisterEvent('PET_BATTLE_CLOSE')
end

do
	local currentVersion = tonumber(E.Version:gsub("[^%d]", ""))
	local today = tonumber(date("%y%m%d"))
	local groupSize = 0
	local checkEnabled
	local checkTimer

	local function SendVersion()
		if checkEnabled then
			if IsInRaid() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", currentVersion, (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
			elseif IsInGroup() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", currentVersion, (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
			elseif IsInGuild() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", currentVersion, "GUILD")
			end
		end
		checkTimer = nil
	end

	local function VersionCheck_OnEvent(self, event, prefix, version, _, sender)
		if event == 'CHAT_MSG_ADDON' then
			if prefix ~= "OMNICD_VERSION" or sender == E.userNameWithRealm then
				return
			end
			version = tonumber(version)
			if version and version > currentVersion then
				local diff = version - currentVersion
				local text = diff > 10 and L["Major update"] or (diff > 1 and L["Minor update"]) or L["Hotfix"]
				text = format(L["A new update is available. |cff99cdff(%s)"], text)
				if E.global.notifyNew then
					--E.write(text)
				end
				E.global.updateVersion = version
				E.global.updateType = text
				E.global.updateCheckDate = today

				self:UnregisterAllEvents()
				self:SetScript("OnEvent", nil)
				checkEnabled = nil
			end
		elseif event == 'GROUP_ROSTER_UPDATE' then
			local num = GetNumGroupMembers()
			if num and num > groupSize then
				if not checkTimer then
					checkTimer = C_Timer.NewTimer(10, SendVersion)
				end
			end
			groupSize = num
		elseif event == 'PLAYER_ENTERING_WORLD' then
			if not checkTimer then
				checkTimer = C_Timer.NewTimer(10, SendVersion)
			end
		end
	end

	function E:EnableVersionCheck()
		local updateVersion = self.global.updateVersion
		if updateVersion then
			if currentVersion >= updateVersion then
				self.global.updateType = nil
			end
			if today == self.global.updateCheckDate then
				return
			end
			if currentVersion < updateVersion then
				if self.global.notifyNew then
					self.write(self.global.updateType)
				end
				return
			end
		end

		checkEnabled = C_ChatInfo.RegisterAddonMessagePrefix("OMNICD_VERSION")
		local f = CreateFrame("Frame")
		f:RegisterEvent('CHAT_MSG_ADDON')
		f:RegisterEvent('GROUP_ROSTER_UPDATE')
		f:RegisterEvent('PLAYER_ENTERING_WORLD')
		f:SetScript("OnEvent", VersionCheck_OnEvent)
		self.useVersionCheck = true
	end
end
