-- Localization
local L = wMarkerLocales

-------------------------------------------------------
-- Ace Options Table
-------------------------------------------------------

wMarkerAce = LibStub("AceAddon-3.0"):GetAddon("wMarker")
local config = wMarkerAce:NewModule("wMarkerConfig", "AceEvent-3.0");
local dbRaid, dbWorld, dbFLoc = nil
wMarkerDB = nil
wFlaresDB = nil

function config:OnInitialize()
	dbRaid = wMarkerAce.db.profile.raid
	dbWorld = wMarkerAce.db.profile.world
	dbFLoc = wMarkerAce.db.profile.frameLoc

	--Look for old configs, Pre-Ace
	wMarkerDB = wMarkerDB or {}
	wFlaresDB = wFlaresDB or {}

	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileReset", "ConfigCheck")
	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileChanged","ConfigCheck")
	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileCopied","ConfigCheck")

	wMarkerAce:RegisterChatCommand("wmarker","SlashInput")
	wMarkerAce:RegisterChatCommand("wma","SlashInput")
	wMarkerAce:RegisterChatCommand("rc", "SlashReadyCheck")
	wMarkerAce:RegisterChatCommand("roc", "SlashRoleCheck")

	wMarkerAce:RegisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	wMarkerAce:RegisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	wMarkerAce:RegisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	wMarkerAce:RegisterEvent("PLAYER_REGEN_ENABLED","EventHandler")

	wMarkerAce.db.global.lastVer = GetAddOnMetadata("wMarker","Version")
end

function config:OnEnable()
	--Apply saved configs
	wMarkerAce:ConfigCheck()

end

function config:OnDisable()

	wMarkerAce.db.UnregisterAllCallbacks(wMarkerAce)

	wMarkerAce:UnregisterChatCommand("wmarker","SlashInput")
	wMarkerAce:UnregisterChatCommand("wma","SlashInput")
	wMarkerAce:UnregisterChatCommand("rc", "SlashReadyCheck")
	wMarkerAce:UnregisterChatCommand("roc", "SlashRoleCheck")

	wMarkerAce:UnregisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	wMarkerAce:UnregisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	wMarkerAce:UnregisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	wMarkerAce:UnregisterEvent("PLAYER_REGEN_ENABLED","EventHandler")
end

function wMarkerAce:ConfigCheck()
	dbRaid = wMarkerAce.db.profile.raid
	dbWorld = wMarkerAce.db.profile.world
	dbFLoc = wMarkerAce.db.profile.frameLoc

	-- Check if old configs exist, if not yet imported, complete the import
	if (wMarkerDB.locked ~= nil) and (wMarkerAce.db.global.imported == false or wMarkerAce.db.global.imported == nil) then wMarkerAce:ConfigImport() end

	-- Check for old loc exists in Ace, if yes, use these points and nil them
	if (dbRaid.point) then wMarkerAce.raidMain:ClearAllPoints(); wMarkerAce.raidMain:SetPoint(dbRaid.point, "UIParent", dbRaid.relPt, dbRaid.x, dbRaid.y); wMarkerAce:getLoc(wMarkerAce.raidMain); dbRaid.point, dbRaid.relPt, dbRaid.x, dbRaid.y = nil end
	wMarkerAce:setLoc(wMarkerAce.raidMain)
	if (dbWorld.point) then wMarkerAce.worldMain:ClearAllPoints(); wMarkerAce.worldMain:SetPoint(dbWorld.point, "UIParent", dbWorld.relPt, dbWorld.x, dbWorld.y); wMarkerAce:getLoc(wMarkerAce.worldMain); dbWorld.point, dbWorld.relPt, dbWorld.x, dbWorld.y = nil end
	wMarkerAce:setLoc(wMarkerAce.worldMain)

	wMarkerAce.raidMain:SetScale(dbRaid.scale)
	wMarkerAce.raidMain:SetAlpha(dbRaid.alpha)

	wMarkerAce.worldMain:SetScale(dbWorld.scale)
	wMarkerAce.worldMain:SetAlpha(dbWorld.alpha)

	wMarkerAce:updateClamp()
	wMarkerAce:updateVisibility()

	wMarkerAce:updateLock()
	wMarkerAce:backgroundVisibility()

	wMarkerAce:raidOrient()
	wMarkerAce:worldOrient()

	wMarkerAce:worldRetext(dbWorld.worldTex)
end

function wMarkerAce:ConfigImport()	
	local oldwDB = wMarkerDB
	local oldfDB = wFlaresDB
	dbRaid.locked = oldwDB.locked
	dbRaid.clamped = oldwDB.clamped
	dbRaid.shown = oldwDB.shown
	dbRaid.flipped = oldwDB.flipped
	dbRaid.vertical = oldwDB.vertical
	dbRaid.partyShow = oldwDB.partyShow
	dbRaid.targetShow = oldwDB.targetShow
	dbRaid.assistShow = oldwDB.assistShow
	dbRaid.bgHide = oldwDB.bgHide
	dbRaid.tooltips = oldwDB.tooltips
	dbRaid.iconSpace = oldwDB.iconSpace
	dbRaid.scale = oldwDB.scale
	dbRaid.alpha = oldwDB.alpha
	dbFLoc["wMarkerRaid"] = {"CENTER", "UIParent", oldwDB.relPt, oldwDB.x, oldwDB.y}

	dbWorld.locked = oldfDB.locked
	dbWorld.clamped = oldfDB.clamped
	dbWorld.shown = oldfDB.shown
	dbWorld.flipped = oldfDB.flipped
	dbWorld.vertical = oldfDB.vertical
	dbWorld.partyShow = oldfDB.partyShow
	dbWorld.targetShow = oldfDB.targetShow
	dbWorld.assistShow = oldfDB.assistShow
	dbWorld.bgHide = oldfDB.bgHide
	dbWorld.tooltips = oldfDB.tooltips
	dbWorld.scale = oldfDB.scale
	dbWorld.alpha = oldfDB.alpha
	dbFLoc["wMarkerWorld"] = {"CENTER", "UIParent", oldfDB.relPt, oldfDB.x, oldfDB.y}

	wMarkerAce.db.global.imported = true
	wMarkerDB = nil
	wFlaresDB = nil
	wMarkerAce:Print("Configurations imported from legacy wMarker")
end

wMarkerAce.options = {
	name = "wMarker",
	handler = wMarkerAce,
	type = 'group',
	args = {
		raidMarkers = {
			type = 'group',
			name = L["Raid marker"],
			order = 10,
			width = "full",
			args = {
				raidMarkersText = {
					type = "description",
					name = (wMarkerAce.titleText.." - "..L["Raid marker"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = "raidShowToggle",
					get = function(info) return dbRaid.shown end,
					order = 5,
					width = "full",
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = "raidLockToggle",
					get = function(info) return dbRaid.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = "raidClampToggle",
					get = function(info) return dbRaid.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = "raidReverseToggle",
					get = function(info) return dbRaid.flipped end,
					order = 20,
				},
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "raidVertToggle",
					get = function(info) return dbRaid.vertical end,
					order = 25,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = "raidPartyToggle",
					get = function(info) return dbRaid.partyShow end,
					order = 30,
				},
				targetCheck = {
					type = "toggle",
					name = L["Show only with a target"],
					set = "raidTargetToggle",
					get = function(info) return dbRaid.targetShow end,
					order = 35,					
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = "raidAssistToggle",
					get = function(info) return dbRaid.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = "raidBgToggle",
					get = function(info) return dbRaid.bgHide end,
					order = 45,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = "raidTooltipsToggle",
					get = function(info) return dbRaid.tooltips end,
					order = 50,
				},
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = "raidScaleSet",
					get = function(info) return dbRaid.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = "raidAlphaSet",
					get = function(info) return dbRaid.alpha end,
					order = 60
				},
				spacingSlider = {
					type = "range",
					name = L["Icon spacing"],
					min = -5,
					max = 15,
					step = 1,
					set = "raidSpacingSet",
					get = function(info) return dbRaid.iconSpace end,
					order = 65
				},
			},
		},
		worldMarkers = {
			type = 'group',
			name = L["World markers"],
			order = 20,
			args = {
				worldMarkersText = {
					type = "description",
					name = (wMarkerAce.titleText.." - "..L["World markers"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = "worldShowToggle",
					get = function(info) return dbWorld.shown end,
					order = 5,
					width = "full"
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = "worldLockToggle",
					get = function(info) return dbWorld.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = "worldClampToggle",
					get = function(info) return dbWorld.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = "worldReverseToggle",
					get = function(info) return dbWorld.flipped end,
					order = 20,
				},
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "worldVertToggle",
					get = function(info) return dbWorld.vertical end,
					order = 25,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = "worldPartyToggle",
					get = function(info) return dbWorld.partyShow end,
					order = 30,
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = "worldAssistToggle",
					get = function(info) return dbWorld.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = "worldBgToggle",
					get = function(info) return dbWorld.bgHide end,
					order = 45,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = "worldTooltipsToggle",
					get = function(info) return dbWorld.tooltips end,
					order = 50,
				},
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = "worldScaleSet",
					get = function(info) return dbWorld.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = "worldAlphaSet",
					get = function(info) return dbWorld.alpha end,
					order = 60
				},
				displayAsRadio = {
					type = "select",
					style = "radio",
					name = L["Display as"],
					values = {[1] = L["Blips"], [2] = L["Icons"]},
					set = "worldTexSelect",
					get = function(info) return dbWorld.worldTex end,
					order = 65
				},
			}
		},
		aboutSection = {
			type = "group",
			name = L["About"],
			order = 0,
			hidden = false,
			args = {
				wMarkerText = {
					type = "description",
					name = wMarkerAce.titleText,
					fontSize = "large",
					width = "full",
					order = 0,
				},
				versionText = {
					type = "description",
					name = string.format("%s%s:|r %s",wMarkerAce.color.yellow,L["Version"],GetAddOnMetadata("wMarker", "Version")),
					width = "full",
					order = 5,
				},
				aboutText = {
					type = "description",
					name = string.format("%s%s:|r %s",wMarkerAce.color.yellow,L["About"],GetAddOnMetadata("wMarker", "Notes")),
					width = "full",
					order = 10,
				},
				authorText = {
					type = "description",
					name = string.format("%s%s:|r Waky - Azuremyst",wMarkerAce.color.yellow,L["Author"]),
					width = "full",
					order = 15,
				},
				translationText = {
					type = "header",
					name = L["Translation credits"],
					width = "full",
					order = 20,
				},
				germanText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","German-deDE","TheGeek/StormCalai, Zaephyr81, Fiveyoushi, Morwo"),
					width = "full",
					order = 25,
				},
				spanishText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Spanish-esES","Waky"),
					width = "full",
					order = 30,
				},
				frenchText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","French-frFR","Kromdhar, Argone"),
					width = "full",
					order = 35,
				},
				traditionalChineseText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Traditional Chinese-zhTW","EKE"),
					width = "full",
					order = 40,
				},
				italianText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Italian-itIT","Fabsm"),
					width = "full",
					order = 45,
				},
				russianText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Russian-ruRU","katanaFAN, panzer48, RamyAlexis"),
					width = "full",
					order = 50,
				},
				simplifiedChineseText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Simplified Chinese-zhCN","dll32"),
					width = "full",
					order = 55,
				},
				koreanText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Koreak-koKR","cyberyahoo2"),
					width = "full",
					order = 60,
				},
			},
		},
	},
}

-------------------------------------------------------
-- Option Handlers
-------------------------------------------------------

--Raid Marker Handlers
function wMarkerAce:raidShowToggle()
	dbRaid.shown = not dbRaid.shown
	wMarkerAce:updateVisibility()
end

function wMarkerAce:raidLockToggle()
	dbRaid.locked = not dbRaid.locked
	wMarkerAce:updateLock()
end

function wMarkerAce:raidClampToggle()
	dbRaid.clamped = not dbRaid.clamped
	wMarkerAce:updateClamp();
end

function wMarkerAce:raidReverseToggle()
	dbRaid.flipped = not dbRaid.flipped
	wMarkerAce:raidOrient()
end

function wMarkerAce:raidVertToggle()
	dbRaid.vertical = not dbRaid.vertical
	wMarkerAce:raidOrient()
end

function wMarkerAce:raidPartyToggle()
	dbRaid.partyShow = not dbRaid.partyShow
	wMarkerAce:updateVisibility()
end

function wMarkerAce:raidTargetToggle()
	dbRaid.targetShow = not dbRaid.targetShow
	wMarkerAce:updateVisibility()
end

function wMarkerAce:raidAssistToggle()
	dbRaid.assistShow = not dbRaid.assistShow
	wMarkerAce:updateVisibility()
end

function wMarkerAce:raidBgToggle()
	dbRaid.bgHide = not dbRaid.bgHide
	wMarkerAce:backgroundVisibility()
end

function wMarkerAce:raidTooltipsToggle()
	dbRaid.tooltips = not dbRaid.tooltips
end

function wMarkerAce:raidScaleSet(info, input)
	dbRaid.scale = input
	wMarkerAce.raidMain:SetScale(dbRaid.scale)
end

function wMarkerAce:raidAlphaSet(info, input)
	dbRaid.alpha = input
	wMarkerAce.raidMain:SetAlpha(dbRaid.alpha);
end

function wMarkerAce:raidSpacingSet(info, input)
	dbRaid.iconSpace = input
	wMarkerAce:raidOrient()
end

--World Marker Handlers
function wMarkerAce:worldShowToggle()
	dbWorld.shown = not dbWorld.shown
	wMarkerAce:updateVisibility()
end

function wMarkerAce:worldLockToggle()
	dbWorld.locked = not dbWorld.locked
	wMarkerAce:updateLock()
end

function wMarkerAce:worldClampToggle()
	dbWorld.clamped = not dbWorld.clamped
	wMarkerAce:updateClamp();
end

function wMarkerAce:worldReverseToggle()
	dbWorld.flipped = not dbWorld.flipped
	wMarkerAce:worldOrient()
end

function wMarkerAce:worldVertToggle()
	dbWorld.vertical = not dbWorld.vertical
	wMarkerAce:worldOrient()
end

function wMarkerAce:worldPartyToggle()
	dbWorld.partyShow = not dbWorld.partyShow
	wMarkerAce:updateVisibility()
end

function wMarkerAce:worldAssistToggle()
	dbWorld.assistShow = not dbWorld.assistShow
	wMarkerAce:updateVisibility()
end

function wMarkerAce:worldBgToggle()
	dbWorld.bgHide = not dbWorld.bgHide
	wMarkerAce:backgroundVisibility()
end

function wMarkerAce:worldTooltipsToggle()
	dbWorld.tooltips = not dbWorld.tooltips
end

function wMarkerAce:worldScaleSet(info, input)
	dbWorld.scale = input
	wMarkerAce.worldMain:SetScale(dbWorld.scale)
end

function wMarkerAce:worldAlphaSet(info, input)
	dbWorld.alpha = input
	wMarkerAce.worldMain:SetAlpha(dbWorld.alpha);
end

function wMarkerAce:worldTexSelect(info, input)
	dbWorld.worldTex = input
	wMarkerAce:worldRetext(dbWorld.worldTex)
end

-------------------------------------------------------
-- Helper Functions
-------------------------------------------------------

-- Based on Shadowed's Out of Combat function queue
wMarker_queuedFuncs = {};
function wMarkerAce:RegisterOOCFunc(self,func)
	if (type(func)=="string") then
		wMarker_queuedFuncs[func] = self;		
	else
		wMarker_queuedFuncs[self] = true;
	end	
end

-------------------------------------------------------
-- Frame Manipulation functions (Oh so many of them.)
-------------------------------------------------------

function wMarkerAce:updateVisibility()
	--Start off by saying both should be shown
	wMarkerAce.raidMain:Show()
	local worldMarks = true

	--Raid Marker check
	if (dbRaid.shown==false) then wMarkerAce.raidMain:Hide() end
	if (dbRaid.partyShow==true) then if (GetNumGroupMembers()==0) then wMarkerAce.raidMain:Hide() end end
	if (dbRaid.targetShow==true) then if not (UnitExists("target")) then wMarkerAce.raidMain:Hide() end end
	if (dbRaid.assistShow==true) then if (IsInRaid()) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then wMarkerAce.raidMain:Hide() end end

	--World Marker check
	if (dbWorld.shown==false) then worldMarks = false end
	if (dbWorld.partyShow==true) then if (GetNumGroupMembers()==0) then worldMarks = false end end
	if (dbWorld.assistShow==true) then if (IsInRaid()==true) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then worldMarks = false end end

	--World Marker hide/show
	if not (InCombatLockdown()) then
		if (worldMarks==true) then
			if not(wMarkerAce.worldMain:IsShown()) then 
				wMarkerAce.worldMain:Show() 
			end
		else
			if (wMarkerAce.worldMain:IsShown()) then
				wMarkerAce.worldMain:Hide()
			end
		end
	else
		wMarkerAce:RegisterOOCFunc(self,"updateVisibility");
	end
end

function wMarkerAce:updateLock()
	if (dbRaid.locked==true) then
		wMarkerAce.raidMain.moverLeft:SetAlpha(0)
		wMarkerAce.raidMain.moverLeft:EnableMouse(false)
		wMarkerAce.raidMain.moverRight:SetAlpha(0)
		wMarkerAce.raidMain.moverRight:EnableMouse(false)
	elseif (dbRaid.locked==false) then
		wMarkerAce.raidMain.moverLeft:SetAlpha(1)
		wMarkerAce.raidMain.moverLeft:EnableMouse(true)
		wMarkerAce.raidMain.moverRight:SetAlpha(1)
		wMarkerAce.raidMain.moverRight:EnableMouse(true)
	end
	if (dbWorld.locked==true) then
		wMarkerAce.worldMain.moverLeft:SetAlpha(0)
		wMarkerAce.worldMain.moverLeft:EnableMouse(false)
		wMarkerAce.worldMain.moverRight:SetAlpha(0)
		wMarkerAce.worldMain.moverRight:EnableMouse(false)
	elseif (dbWorld.locked==false) then
		wMarkerAce.worldMain.moverLeft:SetAlpha(1)
		wMarkerAce.worldMain.moverLeft:EnableMouse(true)
		wMarkerAce.worldMain.moverRight:SetAlpha(1)
		wMarkerAce.worldMain.moverRight:EnableMouse(true)
	end
end

function wMarkerAce:backgroundVisibility()
	if (dbRaid.bgHide==true) then
		wMarkerAce.raidMain.iconFrame:SetBackdropColor(0,0,0,0)
		wMarkerAce.raidMain.iconFrame:SetBackdropBorderColor(0,0,0,0)
		wMarkerAce.raidMain.controlFrame:SetBackdropColor(0,0,0,0)
		wMarkerAce.raidMain.controlFrame:SetBackdropBorderColor(0,0,0,0)
	elseif (dbRaid.bgHide==false) then
		wMarkerAce.raidMain.iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		wMarkerAce.raidMain.iconFrame:SetBackdropBorderColor(1,1,1,1)
		wMarkerAce.raidMain.controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		wMarkerAce.raidMain.controlFrame:SetBackdropBorderColor(1,1,1,1)
	end
	if (dbWorld.bgHide==true) then
		wMarkerAce.worldMain:SetBackdropColor(0,0,0,0)
		wMarkerAce.worldMain:SetBackdropBorderColor(0,0,0,0)
	elseif (dbWorld.bgHide==false) then
		wMarkerAce.worldMain:SetBackdropColor(0.1,0.1,0.1,0.7)
		wMarkerAce.worldMain:SetBackdropBorderColor(1,1,1,1)
	end
end

function wMarkerAce:updateClamp()
	wMarkerAce.raidMain:SetClampedToScreen(dbRaid.clamped or false)
	wMarkerAce.worldMain:SetClampedToScreen(dbWorld.clamped or false)
end

function wMarkerAce:raidFrameFormat(orient)
	if (orient=="horiz") then
		wMarkerAce.raidMain:SetSize(225+(dbRaid.iconSpace*7),35)
		wMarkerAce.raidMain.iconFrame:SetSize(170+(dbRaid.iconSpace*7),35)
		wMarkerAce.raidMain.controlFrame:SetSize(55,35)
		wMarkerAce.raidMain.iconFrame:SetPoint("LEFT", wMarkerAce.raidMain, "LEFT")
		wMarkerAce.raidMain.controlFrame:SetPoint("RIGHT", wMarkerAce.raidMain, "RIGHT")
		wMarkerAce.raidMain.moverLeft:SetSize(20,35)
		wMarkerAce.raidMain.moverRight:SetSize(20,35)
		wMarkerAce.raidMain.moverLeft:SetPoint("RIGHT",wMarkerAce.raidMain,"LEFT")
		wMarkerAce.raidMain.moverRight:SetPoint("LEFT",wMarkerAce.raidMain,"RIGHT")
	elseif (orient=="vert") then
		wMarkerAce.raidMain:SetSize(35,225+(dbRaid.iconSpace*7))
		wMarkerAce.raidMain.iconFrame:SetSize(35,170+(dbRaid.iconSpace*7))
		wMarkerAce.raidMain.controlFrame:SetSize(35,55)
		wMarkerAce.raidMain.iconFrame:SetPoint("TOP", wMarkerAce.raidMain, "TOP")
		wMarkerAce.raidMain.controlFrame:SetPoint("BOTTOM", wMarkerAce.raidMain, "BOTTOM")
		wMarkerAce.raidMain.moverLeft:SetSize(35,20)
		wMarkerAce.raidMain.moverRight:SetSize(35,20)
		wMarkerAce.raidMain.moverLeft:SetPoint("BOTTOM",wMarkerAce.raidMain,"TOP")
		wMarkerAce.raidMain.moverRight:SetPoint("TOP",wMarkerAce.raidMain,"BOTTOM")
	end
end

function wMarkerAce:raidOrientFormat(dir)
	for k,v in pairs(wMarkerAce.raidMain.icon) do v:ClearAllPoints() end
	wMarkerAce.raidMain.clearIcon:ClearAllPoints()
	wMarkerAce.raidMain.readyCheck:ClearAllPoints()
	wMarkerAce.raidMain.moverLeft:ClearAllPoints()
	wMarkerAce.raidMain.moverRight:ClearAllPoints()
	if (dir==1) then -- Normal
		wMarkerAce.raidMain.icon["Skull"]:SetPoint("LEFT", wMarkerAce.raidMain.iconFrame, "LEFT",5,0)
		for i = 2,8,1 do wMarkerAce.raidMain.icon[i]:SetPoint("LEFT", wMarkerAce.raidMain.icon[i-1], "RIGHT",dbRaid.iconSpace,0) end
		wMarkerAce.raidMain.clearIcon:SetPoint("LEFT", wMarkerAce.raidMain.controlFrame, "LEFT",10,0)
		wMarkerAce.raidMain.readyCheck:SetPoint("LEFT", wMarkerAce.raidMain.clearIcon, "RIGHT")
		wMarkerAce:raidFrameFormat("horiz")
	elseif (dir==2) then -- Backwards
		wMarkerAce.raidMain.icon["Star"]:SetPoint("LEFT",wMarkerAce.raidMain.iconFrame,"LEFT",5,0)
		for i = 7,1,-1 do wMarkerAce.raidMain.icon[i]:SetPoint("LEFT",wMarkerAce.raidMain.icon[i+1],"RIGHT",dbRaid.iconSpace,0) end
		wMarkerAce.raidMain.clearIcon:SetPoint("LEFT", wMarkerAce.raidMain.controlFrame, "LEFT",10,0)
		wMarkerAce.raidMain.readyCheck:SetPoint("LEFT", wMarkerAce.raidMain.clearIcon, "RIGHT")
		wMarkerAce:raidFrameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		wMarkerAce.raidMain.icon["Skull"]:SetPoint("TOP", wMarkerAce.raidMain.iconFrame, "TOP",0,-5)
		for i = 2,8,1 do wMarkerAce.raidMain.icon[i]:SetPoint("TOP",wMarkerAce.raidMain.icon[i-1], "BOTTOM",0,0-dbRaid.iconSpace) end
		wMarkerAce.raidMain.clearIcon:SetPoint("TOP", wMarkerAce.raidMain.controlFrame, "TOP",0,-10)
		wMarkerAce.raidMain.readyCheck:SetPoint("TOP", wMarkerAce.raidMain.clearIcon, "BOTTOM")
		wMarkerAce:raidFrameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		wMarkerAce.raidMain.icon["Star"]:SetPoint("TOP", wMarkerAce.raidMain.iconFrame, "TOP",0,-5)
		for i = 7,1,-1 do wMarkerAce.raidMain.icon[i]:SetPoint("TOP", wMarkerAce.raidMain.icon[i+1], "BOTTOM",0,0-dbRaid.iconSpace) end
		wMarkerAce.raidMain.clearIcon:SetPoint("TOP", wMarkerAce.raidMain.controlFrame, "TOP",0,-10)
		wMarkerAce.raidMain.readyCheck:SetPoint("TOP", wMarkerAce.raidMain.clearIcon, "BOTTOM")
		wMarkerAce:raidFrameFormat("vert")
	end
end

function wMarkerAce:raidOrient()
	if (dbRaid.flipped==false) and (dbRaid.vertical==false) then
		wMarkerAce:raidOrientFormat(1)
	elseif (dbRaid.flipped==true) and (dbRaid.vertical==false) then 
		wMarkerAce:raidOrientFormat(2)	
	elseif (dbRaid.flipped==false) and (dbRaid.vertical==true) then
		wMarkerAce:raidOrientFormat(3)
	elseif (dbRaid.flipped==true) and (dbRaid.vertical==true) then
		wMarkerAce:raidOrientFormat(4)
	end
end

function wMarkerAce:worldFrameFormat(orient)
	if (orient=="horiz") then
		wMarkerAce.worldMain:SetSize(190,30)
		wMarkerAce.worldMain.moverLeft:SetSize(20,30)
		wMarkerAce.worldMain.moverRight:SetSize(20,30)
		wMarkerAce.worldMain.moverLeft:SetPoint("RIGHT",wMarkerAce.worldMain,"LEFT")
		wMarkerAce.worldMain.moverRight:SetPoint("LEFT",wMarkerAce.worldMain,"RIGHT")
	elseif (orient=="vert") then
		wMarkerAce.worldMain:SetSize(30,190)
		wMarkerAce.worldMain.moverLeft:SetSize(30,20)
		wMarkerAce.worldMain.moverRight:SetSize(30,20)
		wMarkerAce.worldMain.moverLeft:SetPoint("BOTTOM",wMarkerAce.worldMain,"TOP")
		wMarkerAce.worldMain.moverRight:SetPoint("TOP",wMarkerAce.worldMain,"BOTTOM")
	end
end

function wMarkerAce:worldOrientFormat(dir)
	for k,v in pairs(wMarkerAce.worldMain.marker) do v:ClearAllPoints() end
	wMarkerAce.worldMain.clearIcon:ClearAllPoints()
	wMarkerAce.worldMain.moverLeft:ClearAllPoints()
	wMarkerAce.worldMain.moverRight:ClearAllPoints()
	if (dir==1) then -- Normal
		wMarkerAce.worldMain.marker["Square"]:SetPoint("LEFT", wMarkerAce.worldMain, "LEFT",5,0)
		for i = 2,8 do wMarkerAce.worldMain.marker[i]:SetPoint("LEFT", wMarkerAce.worldMain.marker[i-1], "RIGHT") end
		wMarkerAce.worldMain.clearIcon:SetPoint("LEFT",wMarkerAce.worldMain.marker["Skull"],"RIGHT",3,0)
		wMarkerAce:worldFrameFormat("horiz")
	elseif (dir==2) then -- Backwards
		wMarkerAce.worldMain.marker["Skull"]:SetPoint("LEFT",wMarkerAce.worldMain,"LEFT",5,0)
		for i = 7,1,-1 do wMarkerAce.worldMain.marker[i]:SetPoint("LEFT",wMarkerAce.worldMain.marker[i+1],"RIGHT") end
		wMarkerAce.worldMain.clearIcon:SetPoint("LEFT",wMarkerAce.worldMain.marker["Square"],"RIGHT",3,0)
		wMarkerAce:worldFrameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		wMarkerAce.worldMain.marker["Square"]:SetPoint("TOP", wMarkerAce.worldMain, "TOP",0,-5)
		for i = 2,8 do wMarkerAce.worldMain.marker[i]:SetPoint("TOP",wMarkerAce.worldMain.marker[i-1], "BOTTOM") end
		wMarkerAce.worldMain.clearIcon:SetPoint("TOP",wMarkerAce.worldMain.marker["Skull"],"BOTTOM",0,-3)
		wMarkerAce:worldFrameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		wMarkerAce.worldMain.marker["Skull"]:SetPoint("TOP", wMarkerAce.worldMain, "TOP",0,-5)
		for i = 7,1,-1 do wMarkerAce.worldMain.marker[i]:SetPoint("TOP", wMarkerAce.worldMain.marker[i+1], "BOTTOM") end
		wMarkerAce.worldMain.clearIcon:SetPoint("TOP",wMarkerAce.worldMain.marker["Square"],"BOTTOM",0,-3)
		wMarkerAce:worldFrameFormat("vert")
	end
end

function wMarkerAce:worldOrient(dir)
	if not (UnitAffectingCombat("player")) then
		if (dbWorld.flipped==false) and (dbWorld.vertical==false) then
			wMarkerAce:worldOrientFormat(1)
		elseif (dbWorld.flipped==true) and (dbWorld.vertical==false) then 
			wMarkerAce:worldOrientFormat(2)	
		elseif (dbWorld.flipped==false) and (dbWorld.vertical==true) then
			wMarkerAce:worldOrientFormat(3)
		elseif (dbWorld.flipped==true) and (dbWorld.vertical==true) then
			wMarkerAce:worldOrientFormat(4)
		end
	else
		--World Markers frame cannot be changed while in combat since they're SecureActionButtons
		wMarkerAce:RegisterOOCFunc(self,"worldOrient");
	end
end

function wMarkerAce:worldRetext(tex)
	if (tex==1) then
		for k,v in pairs(wMarkerAce.worldMain.marker) do v:SetNormalTexture("interface\\minimap\\partyraidblips") end
		wMarkerAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.75,0.875,0,0.25)
		wMarkerAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0,0.25)
		wMarkerAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0,0.125,0.25,0.5)
		wMarkerAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.625,0.75,0,0.25)
		wMarkerAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0.375,0.5,0,0.25)
		wMarkerAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0.25,0.5)
		wMarkerAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0.875,1,0,0.25)
		wMarkerAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.5,0.625,0,0.25)
	else
		for k,v in pairs(wMarkerAce.worldMain.marker) do v:SetNormalTexture("interface\\targetingframe\\ui-raidtargetingicons") end
		wMarkerAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
		wMarkerAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
		wMarkerAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
		wMarkerAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
		wMarkerAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		wMarkerAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
		wMarkerAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
		wMarkerAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

function wMarkerAce:getLoc(frame, savedVar)
	local point, relativeTo, relPt, xOff, yOff = frame:GetPoint()
	if (relativeTo == nil) then relativeTo = _G["UIParent"] end
	dbFLoc[savedVar or frame:GetName()] = {point, relativeTo:GetName(), relPt, xOff, yOff};
end

function wMarkerAce:setLoc(frame, savedVar)
	if dbFLoc[savedVar or frame:GetName()] then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(dbFLoc[savedVar or frame:GetName()]))
	else
		self:getLoc(frame)
	end
end

-------------------------------------------------------
-- Slash Command Handlers
-------------------------------------------------------

function wMarkerAce:SlashInput(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("wMarker")
	else
		if (input=="lock") then
			wMarkerAce:raidLockToggle()
			wMarkerAce:worldLockToggle()
		elseif (input=="show") then
			dbRaid.shown=true
			dbWorld.shown=true
			wMarkerAce:updateVisibility()
		elseif (input=="hide") then
			dbRaid.shown=false
			dbWorld.shown=false
			wMarkerAce:updateVisibility()
		elseif (input=="clamp") then
			wMarkerAce:raidClampToggle(); 
			wMarkerAce:worldClampToggle()
		elseif (input=="options") then
			LibStub("AceConfigDialog-3.0"):Open("wMarker")
		end
	end
end

function wMarkerAce:SlashReadyCheck()
	DoReadyCheck();
end

function wMarkerAce:SlashRoleCheck()
	InitiateRolePoll();
end

-------------------------------------------------------
-- Event Handler
-------------------------------------------------------

function wMarkerAce:EventHandler(event, arg1, arg2, ...)

	if (event=="GROUP_ROSTER_UPDATE") or (event=="RAID_ROSTER_UPDATE") or (event=="PLAYER_TARGET_CHANGED") then
		wMarkerAce:updateVisibility()
	elseif (event=="PLAYER_REGEN_ENABLED") then
		-- Based on Shadowed's Out of Combat function queue
		for func, handler in pairs(wMarker_queuedFuncs) do
			if (type(handler)=="table") then
				handler[func](handler);
			elseif (type(func)=="string") then
				_G[func]();
			else
				func();
			end
		end
		
		for func in pairs(wMarker_queuedFuncs) do
			wMarker_queuedFuncs[func] = nil;
		end

	end

end
