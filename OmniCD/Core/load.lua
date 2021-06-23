local E, L, C = select(2, ...):unpack()

local ACD_Tooltip = E.Libs.ACD.tooltip
local DB_VERSION = 2.51

function E:OnInitialize()
	-- make changes to profile import on db updates

	if not OmniCDDB or not OmniCDDB.version or OmniCDDB.version < 2.5 then
		OmniCDDB = { version = DB_VERSION }
	elseif OmniCDDB.version < DB_VERSION then
		if OmniCDDB.version < 2.51 then
			for profileKey, v in pairs(OmniCDDB.profiles) do
				local moduleOption = v.Party
				if moduleOption then
					for zone, t in pairs(moduleOption) do
						if zone == "none" or zone == "scenario" then
							OmniCDDB.profiles[profileKey].Party[zone] = nil
						elseif type(t) == "table" and t.highlight and t.highlight.markedSpells then
							wipe(t.highlight.markedSpells)
						end
					end
				end
			end
		end

		OmniCDDB.version = DB_VERSION
	end

	OmniCDDB.cooldowns = OmniCDDB.cooldowns or {}

	self.DB = LibStub("AceDB-3.0"):New("OmniCDDB", self.defaults, true)
	self.DB.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.DB.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.DB.RegisterCallback(self, "OnProfileReset", "Refresh")

	self.global = self.DB.global
	self.profile = self.DB.profile
	self.db = self.DB.profile.Party.arena

	self:CreateFontObjects()
	self:UpdateSpellList(true)
	self:SetupOptions()
	self:EnableVersionCheck()
end

function E:OnEnable()
	--[AC] C_ChatInfo.RegisterAddonMessagePrefix("OmniCD")
	self.Comms:RegisterComm("OmniCD", "CHAT_MSG_ADDON")

	-- 15 dummy lines to set font (2 doublelines exists as default)
	for i = 1, 13 do
		if i > 3 then
			ACD_Tooltip:AddLine(".")
		else
			ACD_Tooltip:AddDoubleLine(".", ".")
		end
	end

	self:LoadAddOns()
	self:Refresh()

	if self.DB.profile.loginMsg then
		print(self.LoginMessage)
	end

	self.enabled = true
end

function E:Refresh(arg)
	self.profile = self.DB.profile

	self:UpdateFontObjects()

	for k in pairs(self.moduleOptions) do
		local module = self[k]
		local enabled = self.GetModuleEnabled(k) -- [36]
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

	self.TooltipID:SetHooks()

	if arg == "OnProfileReset" then
		self.global.disableElvMsg = nil
	end
end

do
	local today = tonumber(date("%y%m%d"))
	local groupSize = 0
	local version = E.Version:gsub("[^%d]", "")
	version = tonumber(version)
	local enabled
	local timer

	local function DisableVersionCheck(f)
		f:UnregisterAllEvents()
		f:SetScript("OnEvent", nil)
		enabled = nil
	end

	local function sendVersion()
		if enabled then
			if IsInRaid() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", version, (not IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInRaid(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "RAID")
			elseif IsInGroup() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", version, (not IsInGroup(LE_PARTY_CATEGORY_HOME) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) and "INSTANCE_CHAT" or "PARTY")
			elseif IsInGuild() then
				C_ChatInfo.SendAddonMessage("OMNICD_VERSION", version, "GUILD")
			end
		end
		timer = nil
	end

	local function VersionCheck_OnEvent(f, event, prefix, message, _, sender)
		if event == "CHAT_MSG_ADDON" then
			if prefix ~= "OMNICD_VERSION" or sender == E.userNameWithRealm then
				return
			end

			local ver = tonumber(message)
			if ver and ver > version then
				local diff = ver - version
				local text = diff > 10 and L["Major update"] or (diff > 1 and L["Minor update"]) or L["Hotfix"]
				text = format("|cfff16436 " .. L["A new update is available. (%s)"], text)
				if E.DB.profile.notifyNew then
					E.Write(text)
				end
				E.DB.global.oodMsg = text
				E.DB.global.oodVer = ver
				E.DB.global.oodChk = today

				DisableVersionCheck(f)
			end
		elseif event == "GROUP_ROSTER_UPDATE" then
			local num = GetNumGroupMembers()
			if num and num > groupSize then
				if not timer then
					timer = E.TimerAfter(10, sendVersion)
				end
			end
			groupSize = num
		elseif event == "PLAYER_ENTERING_WORLD" then
			if not timer then
				timer = E.TimerAfter(10, sendVersion)
			end
		end
	end

	function E:EnableVersionCheck()
		if today <= (self.DB.global.oodChk or 0) then
			return
		end

		local ver = self.DB.global.oodVer
		if ver then
			if ver > version then
				if self.DB.profile.notifyNew then
					self.Write(self.DB.global.oodMsg)
				end
				return
			end
			self.DB.global.oodMsg = nil
		end

		enabled = C_ChatInfo.RegisterAddonMessagePrefix("OMNICD_VERSION")
		local f = CreateFrame("Frame")
		f:RegisterEvent("CHAT_MSG_ADDON")
		f:RegisterEvent("GROUP_ROSTER_UPDATE")
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", VersionCheck_OnEvent)
	end
end

do
	local function ShowHideAllBars_OnEvent(f, event)
		if event == "PET_BATTLE_OPENING_START" then
			for k in pairs(E.moduleOptions) do
				local module = E[k]
				if module.test then
					module:Test()
				end

				local func = module.HideAllBars
				if func then
					func(module)
				end
			end

			f:RegisterEvent("PET_BATTLE_CLOSE")
		elseif event == "PET_BATTLE_CLOSE" then
			for k in pairs(E.moduleOptions) do
				local module = E[k]
				local func = module.Refresh
				if func then
					func(module)
				end
			end

			f:UnregisterEvent("PET_BATTLE_CLOSE")
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PET_BATTLE_OPENING_START")
	f:SetScript("OnEvent", ShowHideAllBars_OnEvent)

	E.dummyFrame = f
end

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
	-- Update tooltip font
	local optionFont = self.profile.General.fonts.option

	for i = 1, select("#", ACD_Tooltip:GetRegions()) do
		local region = select(i, ACD_Tooltip:GetRegions())
		if region and region:GetObjectType() == "FontString" then
			self.SetFont(region, optionFont)
		end
	end

	-- Update our fontobjects
	self.SetFont(self.GameFontNormal, optionFont)
	self.SetFont(self.GameFontHighlight, optionFont)
	self.SetFont(self.GameFontDisabled, optionFont)
	local optionFontSmall = self.profile.General.fonts.optionSmall
	self.SetFont(self.GameFontNormalSmall, optionFontSmall)
	self.SetFont(self.GameFontHighlightSmall, optionFontSmall)

	self.SetFont(self.AnchorFont, self.profile.General.fonts.anchor)
	self.SetFont(self.IconFont, self.profile.General.fonts.icon)
	self.SetFont(self.StatusBarFont, self.profile.General.fonts.statusBar)
end
