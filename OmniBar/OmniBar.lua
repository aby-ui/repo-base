--print("|cff00dfff[OmniBar-v6.8]|r原作者|c00FF9900Curse:Jordon|r,由|c00FF9900NGA:伊甸外|r于7.23日翻译修改,输入|cff33ff99/bd|r设置.")
--翻译汉化修改：NGA  @伊甸外  barristan@sina.com  http://bbs.ngacn.cc/nuke.php?func=ucp&uid=7350579
-- OmniBar by Jordon

local addonName, addon = ...

OmniBar = LibStub("AceAddon-3.0"):NewAddon("OmniBar", "AceEvent-3.0", "AceHook-3.0")

local cooldowns = addon.Cooldowns

OmniBar.cooldowns = cooldowns

local order = {
	["DEMONHUNTER"] = 1,
	["DEATHKNIGHT"] = 2,
	["PALADIN"] = 3,
	["WARRIOR"] = 4,
	["DRUID"] = 5,
	["PRIEST"] = 6,
	["WARLOCK"] = 7,
	["SHAMAN"] = 8,
	["HUNTER"] = 9,
	["MAGE"] = 10,
	["ROGUE"] = 11,
	["MONK"] = 12,
}

local resets = addon.Resets

-- Defaults
local defaults = {
	size                 = 40,
	columns              = 8,
	padding              = 1,
	locked               = false,
	center               = false,
	border               = false,
	highlightTarget      = false,
	highlightFocus       = false,
	growUpward           = true,
	showUnused           = false,
	adaptive             = true,
	unusedAlpha          = 0.40,
	swipeAlpha           = 0.70,
	cooldownCount        = true,
	arena                = true,
	ratedBattleground    = true,
	battleground         = true,
	world                = true,
	scenario             = true,
	multiple             = true,
	glow                 = true,
	tooltips             = true,
	names                = false,
	maxIcons             = 500,
	align                = "CENTER",
    xOfs                 = -145,
    yOfs                 = -120,
}

local DB_VERSION = 4

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

local _

OmniBar.index = 1

OmniBar.bars = {}

function OmniBar:OnEnable()
	self.db = LibStub("AceDB-3.0"):New("OmniBarDB", {
		global = { version = DB_VERSION, cooldowns = {} },
		profile = { bars = {} }
	}, true)

	self.index = 1

	for i = #self.bars, 1, -1 do
		OmniBar:Delete(self.bars[i].key, true)
		table.remove(self.bars, i)
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:Initialize(key)
		self.index = self.index + 1
	end

	-- Create a default bar if none exist
	if self.index == 1 then
		self:Initialize("OmniBar1", "OmniBar")
		self.index = 2
	end

	if not self.registered then
		self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
		self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")

		self:SetupOptions()
		self.registered = true
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:AddBarToOptions(key)
	end

	self:Refresh(true)
end

function OmniBar:Delete(key, keepProfile)
	local bar = _G[key]
	if not bar then return end
	bar:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	bar:UnregisterEvent("PLAYER_ENTERING_WORLD")
	bar:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	bar:UnregisterEvent("PLAYER_TARGET_CHANGED")
	bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
	bar:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	bar:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		bar:UnregisterEvent("PLAYER_FOCUS_CHANGED")
		bar:UnregisterEvent("ARENA_OPPONENT_UPDATE")
		bar:UnregisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	end
	bar:Hide()
	if not keepProfile then self.db.profile.bars[key] = nil end
	self.options.args.bars.args[key] = nil
	LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
end

OmniBar.BackupCooldowns = {}

function OmniBar:CopyCooldown(cooldown)
	local copy = {}

	for _,v in pairs({"class", "charges", "parent", "name", "icon"}) do
		if cooldown[v] then
			copy[v] = cooldown[v]
		end
	end

	if cooldown.duration then
		if type(cooldown.duration) == "table" then
			copy.duration = {}
			for k, v in pairs(cooldown.duration) do
				copy.duration[k] = v
			end
		else
			copy.duration = { default = cooldown.duration }
		end
	end

	if cooldown.specID then
		copy.specID = {}
		for i = 1, #cooldown.specID do
			table.insert(copy.specID, cooldown.specID[i])
		end
	end

	return copy
end

-- create a lookup table since CombatLogGetCurrentEventInfo() returns 0 for spellId
local spellIdByName
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	spellIdByName = {}
	for id, value in pairs(cooldowns) do
		if not value.parent then spellIdByName[GetSpellInfo(id)] = id end
	end
end

function OmniBar:AddCustomSpells()
	-- Restore any overrides
	for k,v in pairs(self.BackupCooldowns) do
		cooldowns[k] = self:CopyCooldown(v)
	end

	-- Add custom spells
	for k,v in pairs(self.db.global.cooldowns) do
		-- Backup if we are going to override
		if cooldowns[k] and not cooldowns[k].custom and not self.BackupCooldowns[k] then
			self.BackupCooldowns[k] = self:CopyCooldown(cooldowns[k])
		end
		cooldowns[k] = v
		if spellIdByName then spellIdByName[GetSpellInfo(k)] = k end
	end

	-- Populate cooldowns with spell names and icons
	for spellId,_ in pairs(cooldowns) do
		local name, _, icon = GetSpellInfo(spellId)
		cooldowns[spellId].icon = icon
		cooldowns[spellId].name = name
	end

end

function OmniBar:Initialize(key, name)
	if not self.db.profile.bars[key] then
		self.db.profile.bars[key] = { name = name }
		for a,b in pairs(defaults) do
			self.db.profile.bars[key][a] = b
		end
	end

	self:AddCustomSpells()

	local f = _G[key] or CreateFrame("Frame", key, UIParent, "OmniBarTemplate")
	f:Show()
	f.settings = self.db.profile.bars[key]
	f.settings.align = f.settings.align or "CENTER"
	f.settings.maxIcons = f.settings.maxIcons or 500
	f.key = key
	f.icons = {}
	f.active = {}
	f.cooldowns = cooldowns
	f.detected = {}
	f.specs = {}
	f.BASE_ICON_SIZE = BASE_ICON_SIZE
	f.numIcons = 0
	f:RegisterForDrag("LeftButton")

	f.anchor.text:SetText(f.settings.name)

	-- Load the settings
	OmniBar_LoadSettings(f)

	-- Create the icons
	for spellID,_ in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(f, spellID) then
			OmniBar_CreateIcon(f)
		end
	end

	-- Create the duplicate icons
	for i = 1, MAX_DUPLICATE_ICONS do
		OmniBar_CreateIcon(f)
	end

	OmniBar_ShowAnchor(f)
	OmniBar_RefreshIcons(f)
	OmniBar_UpdateIcons(f)
	OmniBar_Center(f)

	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		f:RegisterEvent("PLAYER_FOCUS_CHANGED")
		f:RegisterEvent("ARENA_OPPONENT_UPDATE")
		f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	end

	f:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

	table.insert(self.bars, f)
end


function OmniBar:Create()

	local key

	while true do
		key = "OmniBar"..self.index
		self.index = self.index + 1
		if not self.db.profile.bars[key] then
			self:Initialize(key, "OmniBar "..self.index - 1)
			self:AddBarToOptions(key, true)
			return
		end
	end

end

function OmniBar:Refresh(full)
	for key,_ in pairs(self.db.profile.bars) do
		local f = _G[key]
		if f then
			f.container:SetScale(f.settings.size/BASE_ICON_SIZE)
			if full then
				OmniBar_OnEvent(f, "PLAYER_ENTERING_WORLD")
			else
				OmniBar_LoadPosition(f)
				OmniBar_UpdateIcons(f)
				OmniBar_Center(f)
			end
		end
	end
end

local Masque = LibStub and LibStub("Masque", true)

-- create a lookup table to translate spec names into IDs
local specNames = {}
if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
	for classID = 1, MAX_CLASSES do
		local _, classToken = GetClassInfo(classID)
		specNames[classToken] = {}
		for i = 1, GetNumSpecializationsForClassID(classID) do
			local id, name = GetSpecializationInfoForClassID(classID, i)
			specNames[classToken][name] = id
		end
	end
end

local function IsHostilePlayer(unit)
	if not unit then return end
	local reaction = UnitReaction("player", unit)
	if not reaction then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and not UnitIsPossessed(unit)
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		local width = self.anchor.text:GetWidth() + 29
		self.anchor:SetSize(width, 30)
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local name = self:GetName()
	local key = name.."Icon"..self.numIcons
	local f = _G[key] or CreateFrame("Button", key, _G[name.."Icons"], "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if not specID then return true end
	if not cooldowns[spellID].specID then return true end
	for i = 1, #cooldowns[spellID].specID do
		if cooldowns[spellID].specID[i] == specID then return true end
	end
	return false
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and spell.class == class and SpellBelongsToSpec(spellID, specID) then
			OmniBar_AddIcon(self, spellID, sourceGUID, nil, true, nil, specID)
		end
	end
end

local function IconIsSource(iconGUID, guid)
	if not guid then return end
	if string.len(iconGUID) == 1 then
		-- arena target
		return UnitGUID("arena"..iconGUID) == guid
	end
	return iconGUID == guid
end

function OmniBar_UpdateBorders(self)
	for i = 1, #self.active do
		local border
		local guid = self.active[i].sourceGUID
		if guid then
			if self.settings.highlightFocus and IconIsSource(guid, UnitGUID("focus")) then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			if self.settings.highlightTarget and IconIsSource(guid, UnitGUID("target")) then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		else
			local class = select(2, UnitClass("focus"))
			if self.settings.highlightFocus and class and IsHostilePlayer("focus") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			class = select(2, UnitClass("target"))
			if self.settings.highlightTarget and class and IsHostilePlayer("target") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		end

		-- Set dim
		self.active[i]:SetAlpha(self.settings.unusedAlpha and self.active[i].cooldown:GetCooldownTimes() == 0 and not border and
			self.settings.unusedAlpha or 1)
	end
end

function OmniBar_UpdateArenaSpecs(self)
	if self.zone ~= "arena" then return end
	for i = 1, 5 do
		local specID = GetArenaOpponentSpec(i)
		if specID and specID > 0 then
			local name = GetUnitName("arena"..i, true)
			if name then self.specs[name] = specID end
		end
	end
end

function OmniBar_SetZone(self, refresh)
	local disabled = self.disabled
	local _, zone = IsInInstance()
	-- if zone == "none" then
	-- 	SetMapToCurrentZone()
	-- 	zone = GetCurrentMapAreaID()
	-- end

	self.zone = zone
	local rated = IsRatedBattleground and IsRatedBattleground()
	self.disabled = (zone == "arena" and not self.settings.arena) or
		(rated and not self.settings.ratedBattleground) or
		(zone == "pvp" and not self.settings.battleground and not rated) or
		(zone == "scenario" and not self.settings.scenario) or
		(zone ~= "arena" and zone ~= "pvp" and zone ~= "scenario" and not self.settings.world)

	if refresh or disabled ~= self.disabled then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)
		if zone == "arena" and not self.disabled then
			wipe(self.detected)
			wipe(self.specs)
			OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE")
		end
	end

end

function OmniBar_OnEvent(self, event)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, _, sourceGUID, sourceName, sourceFlags, _,_,_,_,_, spellID, spellName = CombatLogGetCurrentEventInfo()
		if self.disabled then return end
		if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED") and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			if spellID == 0 and spellIdByName then spellID = spellIdByName[spellName] end
			if cooldowns[spellID] then
				OmniBar_UpdateArenaSpecs(self)
				OmniBar_AddIcon(self, spellID, sourceGUID, sourceName)
			end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i] and self.active[i].spellID and self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
								OmniBar_CooldownFinish(self.active[i].cooldown, true)
								return
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		OmniBar_SetZone(self, true)

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		OmniBar_SetZone(self, true)

	elseif event == "UPDATE_BATTLEFIELD_STATUS" then -- IsRatedBattleground() doesn't return valid response until this event
		OmniBar_SetZone(self)

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and specNames[classToken] and specNames[classToken][talentSpec] then
				self.specs[name] = specNames[classToken][talentSpec]
			end
		end

	elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" then
		if self.disabled or not self.settings.adaptive then return end
		for i = 1, 5 do
			local specID = GetArenaOpponentSpec(i)
			if specID and specID > 0 then
				-- only add icons if show unused is checked
				if not self.settings.showUnused then return end
				if not self.detected[i] then
					local class = select(6, GetSpecializationInfoByID(specID))
					OmniBar_AddIconsByClass(self, class, i, specID)
					self.detected[i] = class
				end
			end
		end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		if self.disabled then return end

		-- update icon borders
		OmniBar_UpdateBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add icons if show adaptive is checked
		if not self.settings.showUnused or not self.settings.adaptive then return end

		-- only add icons when we're in combat
		--if event == "PLAYER_TARGET_CHANGED" and not InCombatLockdown() then return end

		local unit = "playertarget"
		if IsHostilePlayer(unit) then
			local guid = UnitGUID(unit)
			local _, class = UnitClass(unit)
			if class then
				if self.detected[guid] then return end
				self.detected[guid] = class
				OmniBar_AddIconsByClass(self, class)
			end
		end
	end
end

function OmniBar_LoadSettings(self)

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	OmniBar_LoadPosition(self)
	OmniBar_RefreshIcons(self)
	OmniBar_UpdateIcons(self)
	OmniBar_Center(self)
end

function OmniBar_SavePosition(self, set)
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
	local frameStrata = self:GetFrameStrata()
	relativeTo = relativeTo and relativeTo:GetName() or "UIParent"
	if set then
		if set.point then point = set.point end
		if set.relativeTo then relativeTo = set.relativeTo end
		if set.relativePoint then relativePoint = set.relativePoint end
		if set.xOfs then xOfs = set.xOfs end
		if set.yOfs then yOfs = set.yOfs end
		if set.frameStrata then frameStrata = set.frameStrata end
	end

	if not self.settings.position then
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativeTo = relativeTo
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
	self.settings.position.frameStrata = frameStrata
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		local point = self.settings.position.point or "CENTER"
		local relativeTo = self.settings.position.relativeTo or "UIParent"
		local relativePoint = self.settings.position.relativePoint or "CENTER"
		local xOfs = self.settings.position.xOfs or 0
		local yOfs = self.settings.position.yOfs or 0
		self:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
		if not self.settings.position.frameStrata then self.settings.position.frameStrata = "MEDIUM" end
		self:SetFrameStrata(self.settings.position.frameStrata)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
		OmniBar_SavePosition(self)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	local key = "spell"..spellID
	if type(self.settings[key]) == "boolean" then
		if self.settings[key] then
			return true
		end
	elseif not self.settings.noDefault and cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and icon.cooldown:GetCooldownTimes() > 0 and not force then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			if self.omnicc then
				self.omnicc:HookScript('OnHide', function()
					OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
				end)
			end
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	local flash = icon.flashAnim
	local newItemGlowAnim = icon.newitemglowAnim

	if flash:IsPlaying() or newItemGlowAnim:IsPlaying() then
		flash:Stop()
		newItemGlowAnim:Stop()
	end

	if not bar.settings.showUnused then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		self.icons[i].flash:SetAlpha(0)
		self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused and not self.settings.adaptive then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.finish = start + icon.duration
	icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
end


function OmniBar_AddIcon(self, spellID, sourceGUID, sourceName, init, test, specID)
	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end

	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if not init or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if not self.active[i].sourceGUID then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if sourceGUID and IconIsSource(self.active[i].sourceGUID, sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if not icon then
		if #self.active >= self.settings.maxIcons then return end
		if not self.settings.multiple and duplicate then return end
		for i = 1, #self.icons do
			if not self.icons[i]:IsVisible() then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end

	-- We couldn't find a frame to use
	if not icon then return end

	local now = GetTime()

	if specID then
		icon.specID = specID
	else
		if sourceName and sourceName ~= COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and self.specs[sourceName] then
			icon.specID = self.specs[sourceName]
		end
	end

	icon.class = cooldowns[spellID].class
	icon.sourceGUID = sourceGUID
	icon.icon:SetTexture(cooldowns[spellID].icon)
	icon.spellID = spellID
	icon.added = now

	if icon.charges and cooldowns[originalSpellID].charges and icon:IsVisible() then
		local start, duration = icon.cooldown:GetCooldownTimes()
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			if self.settings.glow then
				icon.flashAnim:Play()
				icon.newitemglowAnim:Play()
			end
			return icon
		end
	elseif cooldowns[originalSpellID].charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		icon.Count:SetText(nil)
	end

	local name = self.settings.names and sourceGUID and type(sourceGUID) == "string" and select(6, GetPlayerInfoByGUID(sourceGUID))
	if test and self.settings.names then name = "Name" end
	icon.Name:SetText(name)

	if cooldowns[originalSpellID].duration then
		if type(cooldowns[originalSpellID].duration) == "table" then
			if icon.specID and cooldowns[originalSpellID].duration[icon.specID] then
				icon.duration = cooldowns[originalSpellID].duration[icon.specID]
			else
				icon.duration = cooldowns[originalSpellID].duration.default
			end
		else
			icon.duration = cooldowns[originalSpellID].duration
		end
	else -- child doesn't have a custom duration, use parent
		if type(cooldowns[spellID].duration) == "table" then
			if icon.specID and cooldowns[spellID].duration[icon.specID] then
				icon.duration = cooldowns[spellID].duration[icon.specID]
			else
				icon.duration = cooldowns[spellID].duration.default
			end
		else
			icon.duration = cooldowns[spellID].duration
		end
	end

	-- We don't want duration to be too long if we're just testing
	if test then icon.duration = math.random(5,30) end

	-- Masque
	if Masque then
		icon.MasqueGroup = Masque:Group("OmniBar", cooldowns[spellID].name)
		icon.MasqueGroup:AddButton(icon, {
			FloatingBG = false,
			Icon = icon.icon,
			Cooldown = icon.cooldown,
			Flash = false,
			Pushed = false,
			Normal = icon:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icon:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	icon:Show()

	if not init then
		OmniBar_StartCooldown(self, icon, now)
		if self.settings.glow then
			icon.flashAnim:Play()
			icon.newitemglowAnim:Play()
		end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		self.icons[i].cooldown:SetHideCountdownNumbers(not self.settings.cooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = not self.settings.cooldownCount

		-- Set swipe alpha
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil
	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, nil, true)
	end
end

local function ExtractDigits(str)
	if not str then return 0 end
	if type(str) == "number" then return str end
	local num = str:gsub("%D", "")
	return tonumber(num) or 0
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = ExtractDigits(a.sourceGUID), ExtractDigits(b.sourceGUID)
			if a.class == b.class then
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return order[a.class] < order[b.class]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		table.sort(self.active, function(a, b) return a.added == b.added and a.spellID < b.spellID or a.added < b.added end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				if self.settings.align == "CENTER" then
					self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				else
					self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, (BASE_ICON_SIZE+padding)*rows*grow)
				end

				count = 0
				rows = rows + 1
			else
				if self.settings.align == "RIGHT" then
					self.active[i]:SetPoint("TOPRIGHT", self.active[i-1], "TOPLEFT", -1 * padding, 0)
				else
					self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
				end
			end

		else
			if self.settings.align == "CENTER" then
				self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
			else
				self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, 0)
			end
		end
	end
	OmniBar_ShowAnchor(self)
end

function OmniBar:Test()
	for key,_ in pairs(self.db.profile.bars) do
		OmniBar_Test(_G[key])
	end
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function()
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
end
