local ADDON, Addon = ...
local Mod = Addon:NewModule('Schedule')

local rowCount = 4

local requestKeystoneCheck

-- 1: Overflowing, 2: Skittish, 3: Volcanic, 4: Necrotic, 5: Teeming, 6: Raging, 7: Bolstering, 8: Sanguine, 9: Tyrannical, 10: Fortified, 11: Bursting, 12: Grievous, 13: Explosive, 14: Quaking
-- 1溢出 2无常 3火山 4死疽 5繁盛 6暴怒 7激励 8血池 9残暴 10坚韧 11崩裂 12重伤 13易爆 14震荡 15冷酷
local affixSchedule = {
	{ 10, 8, 4 },
	{ 9, 11, 2 },
	{ 10, 5, 14 },
	{ 9, 6, 4 },
	{ 10, 7, 2 },
	{ 9, 5, 3 },
	{ 10, 8, 12 },
	{ 9, 7, 13 },
	{ 10, 11, 14 },
	{ 9, 6, 3 },
	{ 10, 5, 13 },
	{ 9, 7, 12 },
}
local startWeek = time({year=2017,month=6,day=22,hour=7,min=0,sec=0})

local currentWeek

local function UpdateAffixes()
	if requestKeystoneCheck then
		Mod:CheckInventoryKeystone()
	end
    --163ui
    if not currentWeek and GetLocale():find("^zh") then
        local diff = time() - startWeek
        while diff < 0 do diff = diff + 24*60*60*7*#affixSchedule end
        currentWeek = math.floor(diff/(24*60*60*7)) % 12 + 1
        requestKeystoneCheck = false
    end
	if currentWeek then
		for i = 1, rowCount do
			local entry = Mod.Frame.Entries[i]
			entry:Show()

			local scheduleWeek = (currentWeek - 2 + i) % (#affixSchedule) + 1
			local affixes = affixSchedule[scheduleWeek]
			for j = 1, #affixes do
				local affix = entry.Affixes[j]
				affix:SetUp(affixes[j])
			end
		end
		Mod.Frame.Label:Hide()
	else
		for i = 1, rowCount do
			Mod.Frame.Entries[i]:Hide()
		end
		Mod.Frame.Label:Show()
	end
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
	--ChallengesFrame.WeeklyInfo.Child.WeeklyChest:ClearAllPoints()
	--ChallengesFrame.WeeklyInfo.Child.WeeklyChest:SetPoint("LEFT", 60, -45)

	local frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetSize(160, 110)
	frame:SetPoint("TOPLEFT", ChallengesFrame.WeeklyInfo.Child.WeeklyChest, "TOPRIGHT", 15, -15)
	Mod.Frame = frame

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetAtlas("ChallengeMode-guild-background")
	bg:SetAlpha(0.4)

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalMed2")
	title:SetText(Addon.Locale.scheduleTitle)
	title:SetPoint("TOPLEFT", 15, -7)

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize(146, 9)
	line:SetAtlas("ChallengeMode-RankLineDivider", false)
	line:SetPoint("TOP", 0, -20)

	local entries = {}
	for i = 1, rowCount do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetSize(130, 18)

		local text = entry:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetWidth(74)
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		text:SetText( Addon.Locale["scheduleWeek"..i] )
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
	label:SetText(Addon.Locale.scheduleMissingKeystone)
	frame.Label = label

	hooksecurefunc("ChallengesFrame_Update", UpdateAffixes)
end

function Mod:CheckInventoryKeystone()
	currentWeek = nil
	local currentAffixes = C_MythicPlus.GetCurrentAffixes()

	if currentAffixes then
		for index, affixes in ipairs(affixSchedule) do
			if currentAffixes[3] == affixes[1] and currentAffixes[1] == affixes[2] and currentAffixes[2] == affixes[3] then
				currentWeek = index
			end
		end
	else
		for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local slots = GetContainerNumSlots(container)
			for slot=1, slots do
				local _, _, _, _, _, _, slotLink = GetContainerItemInfo(container, slot)
				local itemString = slotLink and slotLink:match("|Hkeystone:([0-9:]+)|h(%b[])|h")
				if itemString then
					local info = { strsplit(":", itemString) }
					local mapLevel = tonumber(info[3])
					if mapLevel >= 7 then
						local affix1, affix2, affix3, affix4 = tonumber(info[4]), tonumber(info[5]), tonumber(info[6]), tonumber(info[7])
						for index, affixes in ipairs(affixSchedule) do
							if affix1 == affixes[1] and affix2 == affixes[2] and affix3 == affixes[3] then
								currentWeek = index
							end
						end
					end
				end
			end
		end
	end
	requestKeystoneCheck = false
end

function Mod:BAG_UPDATE()
	requestKeystoneCheck = true
end

function Mod:Startup()
	self:RegisterAddOnLoaded("Blizzard_ChallengesUI")
	self:RegisterEvent("BAG_UPDATE")
	requestKeystoneCheck = true
end
