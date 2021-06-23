local E, L, C = select(2, ...):unpack()

local TestMod = CreateFrame("Frame")
local P = E["Party"]
local indicator
local config = {}

local addOnTestMode = {}

addOnTestMode.Grid2 = function(isTestEnabled)
	if isTestEnabled then
		if ( not IsAddOnLoaded("Grid2Options") ) then
			LoadAddOn("Grid2Options")
		end

		config.Grid2 = Grid2Options.editedTheme.layout.layouts["solo"]
		if config.Grid2 == "None" then
			Grid2Options.editedTheme.layout.layouts["solo"] = "By Group"
		end
	else
		Grid2Options.editedTheme.layout.layouts["solo"] = config.Grid2
	end

	Grid2Layout:ReloadLayout()
end

addOnTestMode.VuhDo = function(isTestEnabled)
	if isTestEnabled then
		config.VuhDo = VUHDO_CONFIG["HIDE_PANELS_SOLO"]
		VUHDO_CONFIG["HIDE_PANELS_SOLO"] = false
	else
		VUHDO_CONFIG["HIDE_PANELS_SOLO"] = config.VuhDo
	end

	VUHDO_getAutoProfile()
end

addOnTestMode.ElvUI = function(isTestEnabled)
	ElvUI[1]:GetModule("UnitFrames"):HeaderConfig(ElvUF_Party, isTestEnabled)
end

addOnTestMode.Aptechka = function(isTestEnabled)
	if isTestEnabled then
		config.Aptechka = Aptechka.db.profile.showSolo
		Aptechka.db.profile.showSolo = true
	else
		Aptechka.db.profile.showSolo = config.Aptechka
	end

	Aptechka:ReconfigureProtected()
end

addOnTestMode.HealBot = function(isTestEnabled) -- player frame always shown ?
	--HealBot_TestBars(isTestEnabled and 5) -- doesnt work. has test-names for unit key
end

addOnTestMode.Cell = function(isTestEnabled)
	if isTestEnabled then
		config.Cell = CellDB["general"]["showSolo"]
		CellDB["general"]["showSolo"] = true
	else
		CellDB["general"]["showSolo"] = config.Cell
		if UnitAffectingCombat("player") then
			TestMod:EndTestOOC()
			return
		end
	end

	Cell:Fire("UpdateVisibility", "solo")
end

function TestMod:Test(key)
	local active = E.customUF.active or "blizz"
	local groupSize = GetNumGroupMembers()

	P.test = not P.test

	if P.test then
		if groupSize < 2 and not addOnTestMode[active] and active ~= "blizz" then
			E.Write(string.format(E.STR.UNSUPPORTED_ADDON, active))
		end

		if UnitAffectingCombat("player") then
			P.test = false
			return E.Write(ERR_NOT_IN_COMBAT)
		end

		if active == "blizz" then
			if IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") then -- Grid2
				CompactRaidFrameManager:Show()
				CompactRaidFrameContainer:Show()
			elseif not E.db.position.detached then
				E.StaticPopup_Show("OMNICD_RELOADUI", E.STR.ENABLE_BLIZZARD_CRF)

				P.test = false
				return
			end
		elseif addOnTestMode[active] then
			addOnTestMode[active](P.test)
		end

		if not indicator then
			indicator = CreateFrame("Frame", nil, UIParent, "OmniCDTemplate")
			indicator.anchor.background:SetColorTexture(0, 0, 0, 1)
			indicator.anchor.background:SetGradientAlpha("Horizontal", 1, 1, 1, 1, 1, 1, 1, 0)
			indicator.anchor:SetHeight(15)
			indicator.anchor:EnableMouse(false)
			indicator:SetScript("OnHide", nil)
			indicator:SetScript("OnShow", nil)

			self:SetScript("OnEvent", function(self, event, ...)
				self[event](self, ...)
			end)
			indicator.anchor.text:SetFontObject(E.AnchorFont)
		end
		indicator.anchor.text:SetFormattedText("%s - %s", L["Test"], E.L_ZONE[key])
		E.SetWidth(indicator.anchor)

		self:RegisterEvent("PLAYER_LEAVING_WORLD")

		P:Refresh(true)

		local f = P.groupInfo[E.userGUID].bar
		indicator.anchor:ClearAllPoints()
		indicator.anchor:SetPoint("BOTTOMLEFT", f.anchor, "BOTTOMRIGHT")
		indicator.anchor:SetPoint("TOPLEFT", f.anchor, "TOPRIGHT")
		indicator:Show()

		--[[
		for i = 1, f.numIcons do
			local icon = f.icons[i]
			local flash = icon.flashAnim
			local newItemAnim = icon.newitemglowAnim
			if ( flash:IsPlaying() or newItemAnim:IsPlaying() ) then
				flash:Stop();
				newItemAnim:Stop();
			end
			if icon:IsVisible() then
				flash:Play();
				newItemAnim:Play();
			end
		end
		]]
		for i = 1, f.numIcons do
			local icon = f.icons[i]
			if not icon.AnimFrame:IsVisible() then
				icon.AnimFrame:Show()
				icon.AnimFrame.Anim:Play()
			end
		end
	else
		if active == "blizz" then
			if UnitAffectingCombat("player") then
				self:EndTestOOC()
			elseif IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") and (groupSize == 0 or not P:IsCRFActive()) then
				CompactRaidFrameManager:Hide()
				CompactRaidFrameContainer:Hide()
			end
		elseif addOnTestMode[active] then
			addOnTestMode[active](P.test)
		end

		table.wipe(config)
		indicator:Hide()
		self:UnregisterEvent("PLAYER_LEAVING_WORLD")

		P:Refresh(true)
	end
end

function TestMod:EndTestOOC()
	E.Write(L["Test frames will be hidden once player is out of combat"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function TestMod:PLAYER_REGEN_ENABLED()
	if not E.customUF.active or E.customUF.active == "blizz" then
		if IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") and (P:GetEffectiveNumGroupMembers() == 0 or not P:IsCRFActive()) then
			CompactRaidFrameManager:Hide()
			CompactRaidFrameContainer:Hide()
		end
	elseif E.customUF.active == "Cell" then
		Cell:Fire("UpdateVisibility", "solo")
	end

	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function TestMod:PLAYER_LEAVING_WORLD() -- [68]
	if P.test then
		self:Test()
	end
end

function P:Test(key)
	key = type(key) == "table" and key[2] or key
	self.testZone = key
	key = key or self.zone
	key = key == "none" and E.profile.Party.noneZoneSetting or (key == "scenario" and E.profile.Party.scenarioZoneSetting) or key
	E.db = E.profile.Party[key]
	E:SetActiveUnitFrameData()

	TestMod:Test(key)
end

P["TestMod"] = TestMod
E["addOnTestMode"] = addOnTestMode
