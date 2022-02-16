
local addonName, L = ...
DSH_ADDON = DSH_ADDON or LibStub("AceAddon-3.0"):NewAddon("DSH_ADDON", "AceConsole-3.0")
local DSH = DSH_ADDON
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local L = LibStub ("AceLocale-3.0"):GetLocale ("DominationSocketHelper")
if (not L) then
	print ("|cFFFFAA00Domination Socket Helper|r: Can't load locale. Something went wrong.|r")
	return
end

DSH.LDBOpen = false

local function hideLDBSet(f)
	f:SetScript("OnUpdate", nil)
	DSH.LDBOpen = false
	DSH.SetC:Hide()
	DSH:UpdateSetContainer()
end

local function onUpdate(f)
	if not f:IsMouseOver() and not DSH.SetC:IsMouseOver() then
		hideLDBSet(f)
	end
end

local function onClick(f)
	if InCombatLockdown() then return end

	hideLDBSet(f)
	DSH:OpenFirstDomSocketItem()
end

local function onEnter(f)
	if InCombatLockdown() then return end
	DSH.LDBButton = f
	DSH.LDBOpen = true

	f:SetScript("OnUpdate", onUpdate)
	
	DSH.EF:RegisterEvent("CHAT_MSG_LOOT")

	if not DSH.SetC then
		DSH:CreateSetContainer()
	end
	
	DSH:UpdateSetContainer()

end

local LDB = ldb:NewDataObject("Domination Socket Manager", {type = "data source", text = "Domination Socket Manager", OnClick = onClick, OnEnter = onEnter, icon = "Interface\\Icons\\inv_misc_questionmark"})
local setIcons = {1003591, 1392550, 457655}

function DSH:UpdateLDBText(text)
	if text then
		LDB.icon = setIcons[DSH.db.char.sets[text].icon] or "Interface\\Icons\\inv_misc_gem_variety_02"
		if #text < 4 then --fix for elvui which wont show short names
			text = text .. "   "
		end
		LDB.text = text
	else
		LDB.text = L["NOT_SAVED"]
		LDB.icon = "Interface\\Icons\\inv_misc_questionmark"
	end
end
