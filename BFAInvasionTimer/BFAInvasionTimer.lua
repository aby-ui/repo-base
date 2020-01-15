
local name, mod = ...
local L = mod.L
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local Timer = C_Timer.After

local faction = UnitFactionGroup("player")
if faction == "Neutral" then return end

local frame = CreateFrame("Frame", name, UIParent)
frame:SetPoint("CENTER", UIParent, "CENTER")
frame:SetWidth(180)
frame:SetHeight(15)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:Show()
frame:SetScript("OnDragStart", function(f) f:StartMoving() end)
frame:SetScript("OnDragStop", function(f)
	f:StopMovingOrSizing()
	local a, _, b, c, d = f:GetPoint()
	f.db.profile.position[1] = a
	f.db.profile.position[2] = b
	f.db.profile.position[3] = c
	f.db.profile.position[4] = d
end)
do
	local function openOpts()
		EnableAddOn("BFAInvasionTimer_Options") -- Make sure it wasn't left disabled for whatever reason
		LoadAddOn("BFAInvasionTimer_Options")
		LibStub("AceConfigDialog-3.0"):Open(name)
	end
	SlashCmdList[name] = openOpts
	SLASH_BFAInvasionTimer1 = "/bit"
	SLASH_BFAInvasionTimer2 = "/bfainvasiontimer"
	frame:SetScript("OnMouseUp", function(_, btn)
		if btn == "RightButton" then
			openOpts()
		end
	end)
	frame:RegisterEvent("PLAYER_LOGIN")
end

local zoneNames = {
	C_Map.GetMapInfo(864).name, -- Vol'dun
	C_Map.GetMapInfo(896).name, -- Drustvar
	C_Map.GetMapInfo(862).name, -- Zuldazar
	C_Map.GetMapInfo(895).name, -- Tiragarde Sound
	C_Map.GetMapInfo(863).name, -- Nazmir
	C_Map.GetMapInfo(942).name, -- Stormsong Valley
}

local OnEnter, ShowTip, HideTip
do
	local idNormal = faction == "Horde" and 13284 or 13283 -- Frontline Warrior
	local idWarMode = faction == "Horde" and 13388 or 13387 -- Frontline Veteran
	local achievementPlacement = faction == "Horde" and {
		4, -- Tiragarde Sound
		5, -- Nazmir
		1, -- Vol'dun
		3, -- Zuldazar
		2, -- Drustvar
		6, -- Stormsong Valley
	} or {
		4, -- Tiragarde Sound
		6, -- Stormsong Valley
		2, -- Drustvar
		1, -- Vol'dun
		5, -- Nazmir
		3, -- Zuldazar
	}
	--13317 pvp achiev
	local tt = CreateFrame("GameTooltip", "BFAITtooltip", UIParent, "GameTooltipTemplate")
	local FormatShortDate = FormatShortDate
	local IsWarModeDesired = C_PvP.IsWarModeDesired
	ShowTip = function(tip)
		local coloredZones = {}
		local id = IsWarModeDesired() and idWarMode or idNormal
		local _, name, _, _, month, day, year, description, _, _, _, _, wasEarnedByMe = GetAchievementInfo(id)
		if not wasEarnedByMe or not frame.db.profile.tooltipHideAchiev then
			if wasEarnedByMe then
				tip:AddDoubleLine(name, FormatShortDate(day, month, year), nil, nil, nil, .5, .5, .5)
			else
				tip:AddLine(name, nil, nil, nil, .5, .5, .5)
			end
			tip:AddLine(description, 1, 1, 1, true)
			for i = 1, GetAchievementNumCriteria(id) do
				local criteriaString, _, completed = GetAchievementCriteriaInfo(id, i)
				if completed == false then
					criteriaString = "|CFF808080 - " .. criteriaString .. "|r"
					coloredZones[achievementPlacement[i]] = "|CFF808080" .. zoneNames[achievementPlacement[i]] .. "|r "
				else
					criteriaString = "|CFF00FF00 - " .. criteriaString .. "|r"
					coloredZones[achievementPlacement[i]] = "|CFF00FF00" .. zoneNames[achievementPlacement[i]] .. "|r "
				end
				tip:AddLine(criteriaString)
			end
			tip:AddLine(" ")
		else
			for i = 1, GetAchievementNumCriteria(id) do
				local _, _, completed = GetAchievementCriteriaInfo(id, i)
				if completed == false then
					coloredZones[achievementPlacement[i]] = "|CFF808080" .. zoneNames[achievementPlacement[i]] .. "|r "
				else
					coloredZones[achievementPlacement[i]] = "|CFF00FF00" .. zoneNames[achievementPlacement[i]] .. "|r "
				end
			end
		end

		local splitLine = false
		if not frame.db.profile.tooltipHideMedals then
			splitLine = true
			-- Honorbound Service Medal / 7th Legion Service Medal
			local nName, nAmount, nIcon = GetCurrencyInfo(faction == "Horde" and 1716 or 1717)
			tip:AddDoubleLine(nName, ("|T%d:15:15:0:0:64:64:4:60:4:60|t %d"):format(nIcon, nAmount), 1, 1, 1, 1, 1, 1)
		end

		if splitLine then
			tip:AddLine(" ")
		end

		tip:AddLine(L.nextInvasions)
		if BFAInvasionData[1] ~= 0 then -- Have we seen our first invasion?
			-- 19hrs * 60min = 1,140min = *60sec = 68,400sec
			local elapsed = time() - BFAInvasionData[1]
			local lastKnownInvasionZone = BFAInvasionData[2]
			while elapsed > 68400 do
				elapsed = elapsed - 68400
				lastKnownInvasionZone = lastKnownInvasionZone + 1
				if lastKnownInvasionZone == 7 then lastKnownInvasionZone = 1 end
			end
			local nextAvailableZone = lastKnownInvasionZone == 6 and 1 or lastKnownInvasionZone+1
			local t = 68400-elapsed
			t = t+time()
			local upper, date = string.upper, date
			local check = date("%M", t)
			if check == "29" then
				t = t + 60 -- Round up to 00min if we're at 59min
			end
			if frame.db.profile.tooltip12hr then
				for i = 1, 4 do
					tip:AddDoubleLine(
						coloredZones[nextAvailableZone] .. _G["WEEKDAY_"..upper(date("%A", t))].." "..date("%I:%M", t) .. " " .. _G["TIMEMANAGER_"..upper(date("%p", t))],
						coloredZones[nextAvailableZone == 6 and 1 or nextAvailableZone+1] .. _G["WEEKDAY_"..upper(date("%A", t+68400))].." "..date("%I:%M", t+68400) .. " " .. _G["TIMEMANAGER_"..upper(date("%p", t+68400))],
						1, 1, 1, 1, 1, 1
					)
					t = t + 68400 + 68400
					nextAvailableZone = nextAvailableZone + 2
					if nextAvailableZone > 6 then
						if nextAvailableZone == 8 then
							nextAvailableZone = 2
						else
							nextAvailableZone = 1
						end
					end
				end
			else
				for i = 1, 4 do
					tip:AddDoubleLine(
						coloredZones[nextAvailableZone] .._G["WEEKDAY_"..upper(date("%A", t))].." "..date("%H:%M", t),
						coloredZones[nextAvailableZone == 6 and 1 or nextAvailableZone+1] .. _G["WEEKDAY_"..upper(date("%A", t+68400))].." "..date("%H:%M", t+68400),
						1, 1, 1, 1, 1, 1
					)
					t = t + 68400 + 68400
					nextAvailableZone = nextAvailableZone + 2
					if nextAvailableZone > 6 then
						if nextAvailableZone == 8 then
							nextAvailableZone = 2
						else
							nextAvailableZone = 1
						end
					end
				end
			end
		else
			tip:AddLine(L.waiting, 1, 1, 1)
        end
        tip:AddLine(" ")
        tip:AddLine("左键拖动，右键选项")
	end
	HideTip = function()
		tt:Hide()
	end
	OnEnter = function(f)
		tt:SetOwner(f, "ANCHOR_NONE")
		tt:SetPoint("BOTTOM", f, "TOP")
		ShowTip(tt)
		tt:Show()
	end
end

local function RearrangeBar()
	frame.Bar:ClearAllPoints()
	if frame.db.profile.growUp then
		frame.Bar:SetPoint("BOTTOM", frame, "TOP")
	else
		frame.Bar:SetPoint("TOP", frame, "BOTTOM")
	end
end
frame.RearrangeBar = RearrangeBar

local ChangeBarColor
do
	local quests = faction == "Horde" and {
		[54137] = true, -- Drustvar
		[53883] = true, -- Zuldazar
		[53939] = true, -- Tiragarde Sound
		[53885] = true, -- Vol'dun
		[54135] = true, -- Nazmir
		[54132] = true, -- Stormsong Valley
	} or {
		[53701] = true, -- Drustvar
		[54138] = true, -- Zuldazar
		[53711] = true, -- Tiragarde Sound
		[54134] = true, -- Vol'dun
		[54136] = true, -- Nazmir
		[51982] = true, -- Stormsong Valley
	}
	ChangeBarColor = function(id)
		if quests[id] then
			frame.Bar:Set("BFAInvasionTimer:complete", 1)
			frame.Bar:SetColor(unpack(frame.db.profile.colorComplete))
		end
	end
end

local StartBar
local hiddenBars = false
do
    local dragStart, dragStop = frame:GetScript("OnDragStart"), frame:GetScript("OnDragStop")
    frame:SetScript("OnDragStart", nil)
    frame:SetScript("OnDragStop", nil)
	local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
	StartBar = function(text, timeLeft, rewardQuestID, icon, paused)
		if frame.Bar then frame.Bar:Stop() end
		local bar = candy:New(media:Fetch("statusbar", frame.db.profile.barTexture), frame.db.profile.width, frame.db.profile.height)
		frame.Bar = bar

		bar:SetScript("OnEnter", OnEnter)
		bar:SetScript("OnLeave", HideTip)

        local openOpts = frame:GetScript("OnMouseUp")
        bar:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" then return end
            dragStart(frame)
        end)
        bar:SetScript("OnMouseUp", function(self, button)
            if button == "RightButton" then return openOpts(frame, button) end
            dragStop(frame)
        end)

		bar:SetParent(frame)
		bar:SetLabel(text)
		bar.candyBarLabel:SetJustifyH(frame.db.profile.alignText)
		bar.candyBarDuration:SetJustifyH(frame.db.profile.alignTime)
		bar:SetDuration(timeLeft)
		bar:Set("BFAInvasionTimer:icon", icon)
		if rewardQuestID > 0 then
			if IsQuestFlaggedCompleted(rewardQuestID) then
				bar:SetColor(unpack(frame.db.profile.colorComplete))
				bar:Set("BFAInvasionTimer:complete", 1)
			else
				bar:SetColor(unpack(frame.db.profile.colorIncomplete))
				bar:Set("BFAInvasionTimer:complete", 0)
			end
		else
			bar:SetColor(unpack(frame.db.profile.colorNext))
		end
		bar.candyBarBackground:SetVertexColor(unpack(frame.db.profile.colorBarBackground))
		bar:SetTextColor(unpack(frame.db.profile.colorText))
		if frame.db.profile.icon then
			bar:SetIcon(icon)
			bar:SetIconPosition(frame.db.profile.alignIcon)
		end
		bar:SetTimeVisibility(frame.db.profile.timeText)
		bar:SetLabelVisibility(frame.db.profile.labelText)
		bar:SetFill(frame.db.profile.fill)
		local flags = nil
		if frame.db.profile.monochrome and frame.db.profile.outline ~= "NONE" then
			flags = "MONOCHROME," .. frame.db.profile.outline
		elseif frame.db.profile.monochrome then
			flags = "MONOCHROME"
		elseif frame.db.profile.outline ~= "NONE" then
			flags = frame.db.profile.outline
		end
		bar.candyBarLabel:SetFont(media:Fetch("font", frame.db.profile.font), frame.db.profile.fontSize, flags)
		bar.candyBarDuration:SetFont(media:Fetch("font", frame.db.profile.font), frame.db.profile.fontSize, flags)
		if paused then -- Searching bars
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		elseif rewardQuestID > 0 then -- Invasion duration bars
			bar:Start(25200) -- 7hrs = 60*6 = 420min = 420*60 = 25,200sec
		else -- Next invasion bars
			bar:Start(43200) -- 12hrs = 60*12 = 720min = 720*60 = 43,200sec
		end
		RearrangeBar()
		if hiddenBars then
			bar:Hide()
		end
	end
end

local StartBroker
do
	local obj
	local prevTime, label, repeater = 0, "", false
	local function update()
		prevTime = prevTime - 60
		obj.text = label..": ".. SecondsToTime(prevTime, true)
	end
	StartBroker = function(text, timeLeft, icon)
		if not obj then
			obj = LibStub("LibDataBroker-1.1"):NewDataObject("BFAInvasionTimer", {
				type = "data source",
				icon = icon,
				text = text..": ".. SecondsToTime(timeLeft, true),
				OnTooltipShow = function(tooltip)
					if not tooltip or not tooltip.AddLine or not tooltip.AddDoubleLine then return end
					ShowTip(tooltip)
				end
			})
		end
		if obj then
			obj.icon = icon
			obj.text = text..": ".. SecondsToTime(timeLeft, true)
			prevTime = timeLeft
			label = text
			if repeater then repeater:Cancel() end
			repeater = C_Timer.NewTicker(60, update)
		end
	end
end

local FindInvasion
local justLoggedIn = true
do
	local GetAreaPOISecondsLeft = C_AreaPoiInfo.GetAreaPOISecondsLeft
	local isWaiting = false
	-- Vol'dun > Drustvar > Zuldazar > Tiragarde Sound > Nazmir > Stormsong Valley
	local zonePOIIds = {
		5970, -- Vol'dun
		5964, -- Drustvar
		5973, -- Zuldazar
		5896, -- Tiragarde Sound
		5969, -- Nazmir
		5966, -- Stormsong Valley
	}
	local icons = {
		236645, -- Interface/Icons/Achievement_PVP_O_A
		236594, -- Interface/Icons/Achievement_PVP_A_H
		236645, -- Interface/Icons/Achievement_PVP_O_A
		236594, -- Interface/Icons/Achievement_PVP_A_H
		236645, -- Interface/Icons/Achievement_PVP_O_A
		236594, -- Interface/Icons/Achievement_PVP_A_H
	}
	local questIds = faction == "Horde" and {
		53885, -- Vol'dun
		54137, -- Drustvar
		53883, -- Zuldazar
		53939, -- Tiragarde Sound
		54135, -- Nazmir
		54132, -- Stormsong Valley
	} or {
		54134, -- Vol'dun
		53701, -- Drustvar
		54138, -- Zuldazar
		53711, -- Tiragarde Sound
		54136, -- Nazmir
		51982, -- Stormsong Valley
	}
	FindInvasion = function()
		local mode = frame.db.profile.mode
		local found = false

		for i = 1, #zonePOIIds do
			local timeLeftSeconds = GetAreaPOISecondsLeft(zonePOIIds[i])
			-- On some realms timeLeftSeconds can return massive values during the initialization of a new event
			if timeLeftSeconds and timeLeftSeconds > 60 and timeLeftSeconds < 25201 then -- 7 hours: (7*60)*60 = 25200
				if mode == 2 then
					StartBroker(zoneNames[i], timeLeftSeconds, icons[i])
				else
					StartBar(zoneNames[i], timeLeftSeconds, questIds[i], icons[i])
					frame:RegisterEvent("QUEST_TURNED_IN")
				end
				Timer(timeLeftSeconds+60, FindInvasion)
				found = true
				-- Not fighting a boss, didn't just log in, assault has just spawned (7hrs - 10min = 24600), feature is enabled
				if not IsEncounterInProgress() and not justLoggedIn and timeLeftSeconds > 24600 and frame.db.profile.zoneWarnings then
					FlashClientIcon()
					local text = "|T".. icons[i] ..":15:15:0:0:64:64:4:60:4:60|t ".. ZONE_UNDER_ATTACK:format(zoneNames[i])
					print("|cFF33FF99BFAInvasionTimer|r:", text)
					RaidNotice_AddMessage(RaidBossEmoteFrame, text, {r=1, g=1, b=1})
					PlaySound(8959, "Master", false) -- SOUNDKIT.RAID_WARNING
				end
				justLoggedIn = false

				local curTime = time()
				local elapsed = 25200-timeLeftSeconds
				local latestInvasionTime = curTime - elapsed
				BFAInvasionData[1] = latestInvasionTime
				BFAInvasionData[2] = i
				break
			end
		end

		if not found then
			if BFAInvasionData[1] ~= 0 then
				local elapsed = time() - BFAInvasionData[1]
				local lastKnownInvasionZone = BFAInvasionData[2]
				-- 19hrs * 60min = 1,140min = *60sec = 68,400sec
				while elapsed > 68400 do
					elapsed = elapsed - 68400
					lastKnownInvasionZone = lastKnownInvasionZone + 1
					if lastKnownInvasionZone == 7 then lastKnownInvasionZone = 1 end
				end
				local t = 68400-elapsed
				local nextAvailableZone = lastKnownInvasionZone == 6 and 1 or lastKnownInvasionZone+1

				if t > 43200 then -- 12hrs * 60min = 720min = *60sec = 43,200sec
					-- If it's longer than 43k then an invasion is currently active.
					-- Loop every second until the API call responds with valid results.
					Timer(1, FindInvasion)
					if not isWaiting then
						isWaiting = true
						if mode == 2 then
							StartBroker(L.waiting, 0, 1044517) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
						else
							StartBar(L.waiting, t, 0, 1044517, true) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
							frame:UnregisterEvent("QUEST_TURNED_IN")
						end
					end
					return
				end

				if mode == 2 then
					StartBroker(L.next:format(zoneNames[nextAvailableZone]), t, 1044517) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
				else
					StartBar(L.next:format(zoneNames[nextAvailableZone]), t, 0, 1044517) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
					frame:UnregisterEvent("QUEST_TURNED_IN")
				end

				Timer(t + 5, FindInvasion)
			else
				Timer(60, FindInvasion)
				if not isWaiting then
					isWaiting = true
					if mode == 2 then
						StartBroker(L.waiting, 0, 1044517) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
					else
						StartBar(L.waiting, 1000, 0, 1044517, true) -- 1044517 = Interface/Icons/Achievement_Garrison_Invasion
					end
				end
			end
		end

		if isWaiting then
			isWaiting = false
		end
	end
end

local function CheckIfInRaid()
	if frame.db.profile.hideInRaid then
		local _, iType = GetInstanceInfo()
		if iType == "raid" then
			hiddenBars = true
			frame.Bar:Hide()
		elseif hiddenBars then
			hiddenBars = false
			frame.Bar:Show()
		end
	end
end

frame:SetScript("OnEvent", function(f)
	f:UnregisterEvent("PLAYER_LOGIN")

	if type(BFAInvasionData) ~= "table" then
		BFAInvasionData = {0, 0}
	end

	-- saved variables database setup
	local defaults = {
		profile = {
			lock = false,
			position = {"CENTER", "CENTER", 0, 0},
			fontSize = 10,
			barTexture = "Blizzard Raid Bar",
			outline = "NONE",
			monochrome = false,
			font = media:GetDefault("font"),
			width = 200,
			height = 20,
			icon = true,
			timeText = true,
			labelText = true,
			fill = false,
			growUp = false,
			alignText = "LEFT",
			alignTime = "RIGHT",
			alignIcon = "LEFT",
			colorText = {1,1,1,1},
			colorComplete = {0,1,0,1},
			colorIncomplete = {1,0,0,1},
			colorNext = {0.25,0.33,0.68,1},
			colorBarBackground = {0,0,0,0.75},
			tooltip12hr = true,
			tooltipHideAchiev = false,
			tooltipHideMedals = false,
			zoneWarnings = true,
			hideInRaid = false,
			mode = 1,
		},
	}
	f.db = LibStub("AceDB-3.0"):New("BFAInvasionTimerDB", defaults, true)

	f:ClearAllPoints()
	f:SetPoint(f.db.profile.position[1], UIParent, f.db.profile.position[2], f.db.profile.position[3], f.db.profile.position[4])
    f:StopMovingOrSizing()

	local bg = f:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(f)
	bg:SetColorTexture(0, 1, 0, 0.3)
	f.bg = bg
	local header = f:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
	header:SetAllPoints(f)
	header:SetText(name)
	f.header = header

	if true or f.db.profile.lock then
		f:EnableMouse(false)
		f:SetMovable(false)
		f.bg:Hide()
		f.header:Hide()
    end
    f:SetMovable(true) f.SetMovable = noop or function() end
    hooksecurefunc(f, "StopMovingOrSizing", function(f)
        if f.db.profile.mode == 3 and select(2, f:GetPoint()) ~= WorldMapFrame then
            f:ClearAllPoints()
            f:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", f:GetLeft() - WorldMapFrame:GetLeft(), f:GetTop() - WorldMapFrame:GetTop())
        end
    end)

	if f.db.profile.mode == 3 then
		f:SetParent(WorldMapFrame)
		f:SetFrameStrata("FULLSCREEN")
		f:SetFrameLevel(10)
	end

	FindInvasion()

	Timer(15, function()
		justLoggedIn = false
		if BFAInvasionData[1] == 0 then
			print("|cFF33FF99BFA入侵计时|r:", L.firstRunWarning)
		end
		local x = GetLocale()
		if x == "koKR" then -- XXX temp, Options/Locales needs updated
			print("|cFF33FF99BFAInvasionTimer|r is missing locale for", x, "and needs your help! Please visit the project page on GitHub for more info.")
		end
	end)

	if f.db.profile.mode == 1 then
		CheckIfInRaid()
		f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	end

	f:SetScript("OnEvent", function(_, event, id)
		if event == "QUEST_TURNED_IN" then
			ChangeBarColor(id)
		else
			CheckIfInRaid()
		end
	end)
end)

