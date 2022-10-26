local ADDON, Addon = ...
local Mod = Addon:NewModule('Schedule')

local rowCount = 3

local requestPartyKeystones

-- 1:Overflowing, 2:Skittish, 3:Volcanic, 4:Necrotic, 5:Teeming, 6:Raging, 7:Bolstering, 8:Sanguine, 9:Tyrannical, 10:Fortified, 11:Bursting, 12:Grievous, 13:Explosive, 14:Quaking, 16:Infested, 117: Reaping, 119:Beguiling 120:Awakened, 121:Prideful, 122:Inspiring, 123:Spiteful, 124:Storming
-- 1溢出 2无常 3火山 4死疽 5繁盛 6暴怒 7激励 8血池 9残暴 10坚韧 11崩裂 12重伤 13易爆 14震荡 16寄生 117 收割 119 迷醉 120 觉醒 121 傲慢 122 鼓舞 123怨毒 124 风雷
local affixSchedule = {
	-- Shadowlands Season 2
	[1] =  {[1]=11, [2]=124,[3]=10}, -- 1 Bursting Storming Fortified - march 8,2022
	[2] =  {[1]=6,  [2]=3,  [3]=9},  -- 2 Raging Volcanic Tyrannical - march 15, 2022
	[3] =  {[1]=122,[2]=12, [3]=10}, -- 3 Inspiring Grievous Fortified - march 22, 2022
	[4] =  {[1]=123,[2]=4,  [3]=9},  -- 4 Spiteful Necrotic Tyrannical - march 29, 2022
	[5] =  {[1]=7,  [2]=14, [3]=10}, -- 5 Bolstering Quaking Fortified - april 5, 2022
	[6] =  {[1]=8,  [2]=124,[3]=9},  -- 6 Sanguine Storming Tyrannical - april 12, 2022
	[7] =  {[1]=6,  [2]=13, [3]=10}, -- 7 Raging Explosive Fortified - april 19, 2022
	[8] =  {[1]=11, [2]=3,  [3]=9},  -- 8 Bursting Volcanic Tyrannical - april 26, 2022
	[9] =  {[1]=123,[2]=4, [3]=10}, -- 9 Spiteful Necrotic Fortified - may 3, 2022
	[10] = {[1]=122,[2]=14, [3]=9},  --10 Inspiring Quaking Tyrannical - may 10, 2022
	[11] = {[1]=8,  [2]=12,  [3]=10}, --11 Sanguine Grievous Fortified - may 17, 2022
	[12] = {[1]=7,  [2]=13, [3]=9},  --12 Bolstering Explosive Tyrannical - may 24, 2022
}

local scheduleEnabled = true
local affixScheduleUnknown = false
local currentWeek
local currentKeystoneMapID
local currentKeystoneLevel
local unitKeystones = {}

local function GetNameForKeystone(keystoneMapID, keystoneLevel)
	local keystoneMapName = keystoneMapID and C_ChallengeMode.GetMapUIInfo(keystoneMapID)
	if keystoneMapID and keystoneMapName then
		keystoneMapName = gsub(keystoneMapName, ".-%-", "") -- Mechagon
		keystoneMapName = gsub(keystoneMapName, ".-"..HEADER_COLON, "") -- Tazavesh
		return string.format("%s (%d)", keystoneMapName, keystoneLevel)
	end
end

local function UpdatePartyKeystones()
	Mod:CheckCurrentKeystone(false)
	if requestPartyKeystones then
		Mod:SendPartyKeystonesRequest()
	end

	if not scheduleEnabled then return end
	if not IsAddOnLoaded("Blizzard_ChallengesUI") then return end

	local playerRealm = select(2, UnitFullName("player")) or ""

	local e = 1
	for i = 1, 4 do
		local entry = Mod.PartyFrame.Entries[e]
		local name, realm = UnitName("party"..i)

		if name then
			local fullName
			if not realm or realm == "" then
				fullName = name.."-"..playerRealm
			else
				fullName = name.."-"..realm
			end

			if unitKeystones[fullName] ~= nil then
				local keystoneName
				if unitKeystones[fullName] == 0 then
					keystoneName = NONE
				else
					keystoneName = GetNameForKeystone(unitKeystones[fullName][1], unitKeystones[fullName][2])
				end
				if keystoneName then
					entry:Show()
					local _, class = UnitClass("party"..i)
					local color = RAID_CLASS_COLORS[class]
					entry.Text:SetText(name)
					entry.Text:SetTextColor(color:GetRGBA())
					entry.Text2:SetText(keystoneName:gsub("塔扎维什：", ""):gsub("重返卡拉赞（(.-)层）", "卡拉赞%1"))
					e = e + 1
				end
			end
		end
	end
	if e == 1 then
		Mod.AffixFrame:ClearAllPoints()
		Mod.AffixFrame:SetPoint("LEFT", ChallengesFrame.WeeklyInfo.Child.WeeklyChest, "RIGHT", 130, 0)
		Mod.PartyFrame:Hide()
	else
		Mod.AffixFrame:ClearAllPoints()
		Mod.AffixFrame:SetPoint("TOPLEFT", ChallengesFrame.WeeklyInfo.Child.WeeklyChest, "TOPRIGHT", 130, 55)
		Mod.PartyFrame:Show()
	end
	while e <= 4 do
		Mod.PartyFrame.Entries[e]:Hide()
		e = e + 1
	end
end

local function UpdateFrame()
	if not scheduleEnabled then return end
	
	Mod:CheckAffixes()
	Mod.AffixFrame:Show()
	Mod.PartyFrame:Show()
	Mod.KeystoneText:Show()

	local weeklyChest = ChallengesFrame.WeeklyInfo.Child.WeeklyChest
	weeklyChest:ClearAllPoints()
	weeklyChest:SetPoint("LEFT", 120, -30) --abyui

	local description = ChallengesFrame.WeeklyInfo.Child.Description
	description:SetWidth(240)
	description:ClearAllPoints()
	description:SetPoint("TOP", weeklyChest, "TOP", 0, 75)

	local currentKeystoneName = GetNameForKeystone(C_MythicPlus.GetOwnedKeystoneChallengeMapID(), C_MythicPlus.GetOwnedKeystoneLevel())
	if currentKeystoneName then
		Mod.KeystoneText:Show()
		Mod.KeystoneText:SetText( string.format(Addon.Locale.currentKeystoneText, currentKeystoneName) )
	else
		Mod.KeystoneText:Hide()
	end

	if currentWeek and not affixScheduleUnknown then
		for i = 1, rowCount do
			local entry = Mod.AffixFrame.Entries[i]
			entry:Show()

			local scheduleWeek = (currentWeek - 1 + i) % (#affixSchedule) + 1
			local affixes = affixSchedule[scheduleWeek]
			for j = 1, #affixes do
				local affix = entry.Affixes[j]
				affix:SetUp(affixes[j])
			end
		end
		Mod.AffixFrame.Label:Hide()
	else
		for i = 1, rowCount do
			Mod.AffixFrame.Entries[i]:Hide()
		end
		Mod.AffixFrame.Label:Show()
	end
	UpdatePartyKeystones()
end

local function makeAffix(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(16, 16)

	local border = frame:CreateTexture(nil, "OVERLAY")
	border:SetAllPoints()
	border:SetAtlas("ChallengeMode-AffixRing-Sm")
	frame.Border = border

	local portrait = frame:CreateTexture(nil, "ARTWORK")
	portrait:SetSize(14, 14)
	portrait:SetPoint("CENTER", border)
	frame.Portrait = portrait

	frame.SetUp = ScenarioChallengeModeAffixMixin.SetUp
	frame:SetScript("OnEnter", ScenarioChallengeModeAffixMixin.OnEnter)
	frame:SetScript("OnLeave", GameTooltip_Hide)

	return frame
end

function Mod:Blizzard_ChallengesUI()
	if not scheduleEnabled then return end
	
	local frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetSize(246, 92)
	frame:SetPoint("TOPLEFT", ChallengesFrame.WeeklyInfo.Child.WeeklyChest, "TOPRIGHT", -20, 30)
	Mod.AffixFrame = frame

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetAtlas("ChallengeMode-guild-background")
	bg:SetAlpha(0.4)

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalMed2")
	title:SetText(Addon.Locale.scheduleTitle)
	title:SetPoint("TOPLEFT", 15, -7)

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize(232, 9)
	line:SetAtlas("ChallengeMode-RankLineDivider", false)
	line:SetPoint("TOP", 0, -20)

	local entries = {}
	for i = 1, rowCount do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetSize(216, 18)

		local text = entry:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetWidth(120)
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		text:SetText( Addon.Locale["scheduleWeek"..i+1] )
		text:SetPoint("LEFT")
		entry.Text = text

		local affixes = {}
		local prevAffix
		for j = 3, 1, -1 do
			local affix = makeAffix(entry)
			if prevAffix then
				affix:SetPoint("RIGHT", prevAffix, "LEFT", -4, 0)
			else
				affix:SetPoint("RIGHT")
			end
			prevAffix = affix
			affixes[j] = affix
		end
		entry.Affixes = affixes

		if i == 1 then
			entry:SetPoint("TOP", line, "BOTTOM")
		else
			entry:SetPoint("TOP", entries[i-1], "BOTTOM")
		end

		entries[i] = entry
	end
	frame.Entries = entries

	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	label:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 10, 0)
	label:SetPoint("TOPRIGHT", line, "BOTTOMRIGHT", -10, 0)
	label:SetJustifyH("CENTER")
	label:SetJustifyV("MIDDLE")
	label:SetHeight(72)
	label:SetWordWrap(true)
	if affixScheduleUnknown then
		label:SetText(Addon.Locale.scheduleUnknown)
	else
		label:SetText(Addon.Locale.scheduleMissingKeystone)
	end
	frame.Label = label

	local frame2 = CreateFrame("Frame", nil, ChallengesFrame)
	frame2:SetSize(246, 110)
	frame2:SetPoint("TOP", frame, "BOTTOM", 0, -5)
	Mod.PartyFrame = frame2

	local bg2 = frame2:CreateTexture(nil, "BACKGROUND")
	bg2:SetAllPoints()
	bg2:SetAtlas("ChallengeMode-guild-background")
	bg2:SetAlpha(0.4)

	local title2 = frame2:CreateFontString(nil, "ARTWORK", "GameFontNormalMed2")
	title2:SetText(Addon.Locale.partyKeysTitle)
	title2:SetPoint("TOPLEFT", 15, -7)

	local line2 = frame2:CreateTexture(nil, "ARTWORK")
	line2:SetSize(232, 9)
	line2:SetAtlas("ChallengeMode-RankLineDivider", false)
	line2:SetPoint("TOP", 0, -20)

	local entries2 = {}
	for i = 1, 4 do
		local entry = CreateFrame("Frame", nil, frame2)
		entry:SetSize(216, 18)

		local text = entry:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetWidth(120)
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		text:SetText()
		text:SetPoint("LEFT")
		entry.Text = text

		local text2 = entry:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        local f1,f2,f3 = text2:GetFont()
        text2:SetFont(f1, 14, f3)
		text2:SetWidth(190)
		text2:SetJustifyH("RIGHT")
		text2:SetWordWrap(false)
		text2:SetText()
		text2:SetPoint("RIGHT")
		entry.Text2 = text2

		if i == 1 then
			entry:SetPoint("TOP", line2, "BOTTOM")
		else
			entry:SetPoint("TOP", entries2[i-1], "BOTTOM")
		end

		entries2[i] = entry
	end
	frame2.Entries = entries2

	local keystoneText = ChallengesFrame.WeeklyInfo.Child:CreateFontString(nil, "ARTWORK", "GameFontNormalMed2")
	keystoneText:SetPoint("TOP", ChallengesFrame.WeeklyInfo.Child, "TOP", 0, -113)
	keystoneText:SetWidth(320)
	Mod.KeystoneText = keystoneText

	hooksecurefunc(ChallengesFrame, "Update", UpdateFrame)
end

function Mod:GetInventoryKeystone()
	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do
			local _, _, _, _, _, _, slotLink = GetContainerItemInfo(container, slot)
			local itemString = slotLink and slotLink:match("|Hkeystone:([0-9:]+)|h(%b[])|h")
			if itemString then
				return slotLink, itemString
			end
		end
	end
end

function Mod:CheckAffixes()
	currentWeek = nil
	local currentAffixes = C_MythicPlus.GetCurrentAffixes()

	if currentAffixes then
		for index, affixes in ipairs(affixSchedule) do
			local matches = 0
			for _, affix in ipairs(currentAffixes) do
				if affix.id == affixes[1] or affix.id == affixes[2] or affix.id == affixes[3] then
					matches = matches + 1
				end
			end
			if matches >= 3 then
				currentWeek = index
			end
		end
	end
end

local bagUpdateTimerStarted = false
function Mod:BAG_UPDATE()
	if not bagUpdateTimerStarted then
		bagUpdateTimerStarted = true
		C_Timer.After(2, function()
			Mod:CheckCurrentKeystone()
			bagUpdateTimerStarted = false
		end)
	end
end

function Mod:CHAT_MSG_LOOT(...)
	local lootString, _, _, _, unit = ...
	if string.match(lootString, "|Hitem:158923:") then
		if UnitName("player") == unit then
			self:CheckCurrentKeystone(false)
		else
			self:SetPartyKeystoneRequest()
		end
	end
end

function Mod:SetPartyKeystoneRequest()
	requestPartyKeystones = true
	if IsAddOnLoaded("Blizzard_ChallengesUI") and ChallengesFrame:IsShown() then
		self:SendPartyKeystonesRequest()
		UpdatePartyKeystones()
	end
end

function Mod:SendPartyKeystonesRequest()
	requestPartyKeystones = false
	self:SendAddOnComm("request", "PARTY")
end

local hadKeystone = false
function Mod:CheckCurrentKeystone(announce)
	local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()

    if not keystoneMapID or keystoneMapID <= 0 or not keystoneLevel or keystoneLevel <= 1 then return end


	if keystoneMapID ~= currentKeystoneMapID or keystoneLevel ~= currentKeystoneLevel then
        if currentKeystoneLevel and (currentKeystoneLevel < keystoneLevel - 1 or currentKeystoneLevel > keystoneLevel + 3) then return end
        --if DEBUG_MODE then print("AngryKeystone", hadKeystone, keystoneMapID, keystoneLevel, currentKeystoneMapID, currentKeystoneLevel) end
		currentKeystoneMapID = keystoneMapID
		currentKeystoneLevel = keystoneLevel

		if hadKeystone and announce ~= false and Addon.Config.announceKeystones then
            if DEBUG_MODE then pdebug() end
			local itemLink = self:GetInventoryKeystone()
			if itemLink and IsInGroup(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage(string.format(Addon.Locale.newKeystoneAnnounce, itemLink), "PARTY")
			end
		end

		hadKeystone = true
		self:SendCurrentKeystone()
	end
end

function Mod:SendCurrentKeystone()
	local keystoneMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
	
	local message = "0"
	if keystoneLevel and keystoneMapID then
		message = string.format("%d:%d", keystoneMapID, keystoneLevel)
	end

	self:SendAddOnComm(message, "PARTY")
end

function Mod:ReceiveAddOnComm(message, type, sender)
	if message == "request" then
		requestPartyKeystones = false
		self:SendCurrentKeystone()
	elseif message == "0" then
		if unitKeystones[sender] ~= 0 then
			unitKeystones[sender] = 0
			UpdatePartyKeystones()
		end
	else
		local arg1, arg2 = message:match("^(%d+):(%d+)$")
		local keystoneMapID = arg1 and tonumber(arg1)
		local keystoneLevel = arg2 and tonumber(arg2)
		if keystoneMapID and keystoneLevel and (unitKeystones[sender] == nil or unitKeystones[sender] == 0
				or not (unitKeystones[sender][1] == keystoneMapID and unitKeystones[sender][2] == keystoneLevel)) then
			unitKeystones[sender] = { keystoneMapID, keystoneLevel }
			UpdatePartyKeystones()
		end
	end
end

function Mod:CHALLENGE_MODE_START()
	self:CheckCurrentKeystone(false)
	C_Timer.After(2, function() self:CheckCurrentKeystone(false) end)
	self:SetPartyKeystoneRequest()
end

function Mod:CHALLENGE_MODE_COMPLETED()
	self:CheckCurrentKeystone()
	C_Timer.After(2, function() self:CheckCurrentKeystone() end)
	self:SetPartyKeystoneRequest()
end

function Mod:CHALLENGE_MODE_UPDATED()
	self:CheckCurrentKeystone(false)
end

function Mod:Startup()
	scheduleEnabled = Addon.Config.schedule
	
	self:RegisterAddOnLoaded("Blizzard_ChallengesUI")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetPartyKeystoneRequest")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("CHAT_MSG_LOOT")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	self:RegisterEvent("CHALLENGE_MODE_START")
	self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE", "CHALLENGE_MODE_UPDATED")
	self:RegisterEvent("CHALLENGE_MODE_LEADERS_UPDATE", "CHALLENGE_MODE_UPDATED")
	self:RegisterEvent("CHALLENGE_MODE_MEMBER_INFO_UPDATED", "CHALLENGE_MODE_UPDATED")
	self:RegisterAddOnComm()
	self:CheckCurrentKeystone()

	C_Timer.After(3, function()
		C_MythicPlus.RequestCurrentAffixes()
		C_MythicPlus.RequestRewards()
	end)

	--C_Timer.NewTicker(60, function() self:CheckCurrentKeystone() end) --abyui
	
	requestPartyKeystones = true
end
