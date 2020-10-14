

--local pointer to details object
local Details = _G._detalhes
local debugmode = false --print debug lines
local verbosemode = false --auto open the chart panel
local _

local Loc = _G.LibStub("AceLocale-3.0"):GetLocale( "Details" )

--constants
local CONST_USE_PLAYER_EDPS = false

--> Generate damage chart for mythic dungeon runs

--[=[
The chart table needs to be stored saparated from the combat
Should the chart data be volatile?

--]=]

local mythicDungeonCharts = Details:CreateEventListener()
_G.DetailsMythicDungeonChartHandler = mythicDungeonCharts

function mythicDungeonCharts:Debug (...)
	if (debugmode or verbosemode) then
		print ("Details! DungeonCharts: ", ...)
	end
end

local addPlayerDamage = function (unitName, unitRealm)
	
	--get the combatlog name
	local CLName
	if (unitRealm and unitRealm ~= "") then
		CLName = unitName .. "-" .. unitRealm
	else
		CLName = unitName
	end
	
	--get the player data
	local playerData = mythicDungeonCharts.ChartTable.Players [CLName]
	
	--if this is the first tick for the player, ignore the damage done on this tick
	--this is done to prevent a tick tick with all the damage the player did on the previous segment
	local bIsFirstTick = false
	
	--check if the player data doesn't exists
	if (not playerData) then
		playerData = {
			Name = unitName,
			ChartData = {max_value = 0},
			Class = select (2, UnitClass (CLName)),
			
			--spec zero for now, need to retrive later during combat
			Spec = 0,
			
			--last damage to calc difference
			LastDamage = 0,
			
			--if started a new combat, need to reset the lastdamage
			LastCombatID = -1,
		}
		
		mythicDungeonCharts.ChartTable.Players [CLName] = playerData
		bIsFirstTick = true
	end
	
	--get the current combat
	local currentCombat = Details:GetCombat (DETAILS_SEGMENTID_CURRENT)
	if (currentCombat) then
	
		local isOverallSegment = false
		
		local mythicDungeonInfo = currentCombat.is_mythic_dungeon
		if (mythicDungeonInfo) then
			if (mythicDungeonInfo.TrashOverallSegment or mythicDungeonInfo.OverallSegment) then
				isOverallSegment = true
			end
		end
		
		if (not isOverallSegment) then
			--check if the combat has changed
			local segmentId = currentCombat.combat_id
			if (segmentId ~= playerData.LastCombatID) then
				playerData.LastDamage = 0
				playerData.LastCombatID = segmentId
				
				--mythicDungeonCharts:Debug ("Combat changed for player", CLName)
			end

			local actorTable = currentCombat:GetActor (DETAILS_ATTRIBUTE_DAMAGE, CLName)
			if (actorTable) then
				--update the player spec
				playerData.Spec = actorTable.spec
				
				if (bIsFirstTick) then
					--ignore previous damage
					playerData.LastDamage = actorTable.total
				end
				
				--get the damage done
				local damageDone = actorTable.total
				
				--check which data is used, dps or damage done
				if (CONST_USE_PLAYER_EDPS) then
					local eDps = damageDone / currentCombat:GetCombatTime()
					
					--add the damage to the chart table
					tinsert (playerData.ChartData, eDps)
					--mythicDungeonCharts:Debug ("Added dps for " , CLName, ":", eDps)
					
					if (eDps > playerData.ChartData.max_value) then
						playerData.ChartData.max_value = eDps
					end
				else
					--calc the difference and add to the table
					local damageDiff = floor (damageDone - playerData.LastDamage)
					playerData.LastDamage = damageDone				
					
					--add the damage to the chart table
					tinsert (playerData.ChartData, damageDiff)
					--mythicDungeonCharts:Debug ("Added damage for " , CLName, ":", damageDiff)
					
					if (damageDiff > playerData.ChartData.max_value) then
						playerData.ChartData.max_value = damageDiff
					end
				end
			else
				--player still didn't made anything on this combat, so just add zero
				tinsert (playerData.ChartData, 0)
			end
		end
	end
end

local tickerCallback = function (tickerObject)
	
	--check if is inside the dungeon
	local inInstance = IsInInstance();
	if (not inInstance) then
		mythicDungeonCharts:OnEndMythicDungeon()
		return
	end
	
	--check if still running the dungeon
	if (not mythicDungeonCharts.ChartTable or not mythicDungeonCharts.ChartTable.Running) then
		tickerObject:Cancel()
		return
	end
	
	--tick damage
	local totalPlayers = GetNumGroupMembers()
	for i = 1, totalPlayers-1 do
		local unitName, unitRealm = UnitName ("party" .. i)
		if (unitName) then
			addPlayerDamage (unitName, unitRealm)
		end
	end
	
	addPlayerDamage (UnitName ("player"))
end

function mythicDungeonCharts:OnBossDefeated()

	local currentCombat = Details:GetCurrentCombat()
	local segmentType = currentCombat:GetCombatType()
	local bossInfo = currentCombat:GetBossInfo()
	local mythicLevel = C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo()
	
	if (mythicLevel and mythicLevel > 0) then
		if (mythicDungeonCharts.ChartTable and mythicDungeonCharts.ChartTable.Running and bossInfo) then

			local copiedBossInfo = Details:GetFramework().table.copy ({}, bossInfo)
			tinsert (mythicDungeonCharts.ChartTable.BossDefeated, {time() - mythicDungeonCharts.ChartTable.StartTime, copiedBossInfo, currentCombat:GetCombatTime()})
			mythicDungeonCharts:Debug ("Boss defeated, time saved", currentCombat:GetCombatTime())
		else
			if (mythicDungeonCharts.ChartTable and mythicDungeonCharts.ChartTable.EndTime ~= -1) then
				local now = time()
				--check if the dungeon just ended
				if (mythicDungeonCharts.ChartTable.EndTime + 2 >= now) then
				
					if (bossInfo) then
						local copiedBossInfo = Details:GetFramework().table.copy ({}, bossInfo)
						tinsert (mythicDungeonCharts.ChartTable.BossDefeated, {time() - mythicDungeonCharts.ChartTable.StartTime, copiedBossInfo, currentCombat:GetCombatTime()})
						mythicDungeonCharts:Debug ("Boss defeated, time saved, but used time aproximation:", mythicDungeonCharts.ChartTable.EndTime + 2, now, currentCombat:GetCombatTime())
					end
				end
			else
				mythicDungeonCharts:Debug ("Boss defeated, but no chart capture is running")
			end
		end
	else
		mythicDungeonCharts:Debug ("Boss defeated, but isn't a mythic dungeon boss fight")
	end
end

function mythicDungeonCharts:OnStartMythicDungeon()

	if (not Details.mythic_plus.show_damage_graphic) then
		mythicDungeonCharts:Debug ("Dungeon started, no capturing mythic dungeon chart data, disabled on profile")
		if (verbosemode) then
			mythicDungeonCharts:Debug ("OnStartMythicDungeon() not allowed")
		end
		return
	else
		mythicDungeonCharts:Debug ("Dungeon started, new capture started")
	end

	mythicDungeonCharts.ChartTable = {
		Running = true,
		Players = {},
		ElapsedTime = 0,
		StartTime = time(),
		EndTime = -1,
		DungeonName = "",

		--store when each boss got defeated in comparison with the StartTime
		BossDefeated = {},
	}
	
	mythicDungeonCharts.ChartTable.Ticker = C_Timer.NewTicker (1, tickerCallback)
	
	--save the chart for development
	if (debugmode) then
		_detalhes.mythic_plus.last_mythicrun_chart = mythicDungeonCharts.ChartTable
	end

	if (verbosemode) then
		mythicDungeonCharts:Debug ("OnStartMythicDungeon() success")
	end
end

function mythicDungeonCharts:OnEndMythicDungeon()
	if (mythicDungeonCharts.ChartTable and mythicDungeonCharts.ChartTable.Running) then
	
		--> stop capturinfg
		mythicDungeonCharts.ChartTable.Running = false
		mythicDungeonCharts.ChartTable.ElapsedTime = time() - mythicDungeonCharts.ChartTable.StartTime
		mythicDungeonCharts.ChartTable.EndTime = time()
		mythicDungeonCharts.ChartTable.Ticker:Cancel()

		local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
		mythicDungeonCharts.ChartTable.DungeonName = name
		
		--> check if is inside the dungeon
		--> many players just leave the dungeon in order the re-enter and start the run again, the chart window is showing in these cases data to an imcomplete run.
		local isInsideDungeon = IsInInstance()
		if (not isInsideDungeon) then
			mythicDungeonCharts:Debug ("OnEndMythicDungeon() player wasn't inside the dungeon.")
			return
		end
		
		mythicDungeonCharts:Debug ("Dungeon ended successfully, chart data capture stopped, scheduling to open the window.")
		
		--> the run is valid, schedule to open the chart window
		_detalhes.mythic_plus.delay_to_show_graphic = 5
		C_Timer.After (_detalhes.mythic_plus.delay_to_show_graphic or 5, mythicDungeonCharts.ShowReadyPanel)
		
		if (verbosemode) then
			mythicDungeonCharts:Debug ("OnEndMythicDungeon() success!")
		end
	else
		mythicDungeonCharts:Debug ("Dungeon ended, no chart data was running")
		if (verbosemode) then
			mythicDungeonCharts:Debug ("OnEndMythicDungeon() fail")
		end
	end
end

mythicDungeonCharts:RegisterEvent ("COMBAT_MYTHICDUNGEON_START", "OnStartMythicDungeon")
mythicDungeonCharts:RegisterEvent ("COMBAT_MYTHICDUNGEON_END", "OnEndMythicDungeon")
mythicDungeonCharts:RegisterEvent ("COMBAT_BOSS_DEFEATED", "OnBossDefeated")

-- /run _G.DetailsMythicDungeonChartHandler.ShowChart(); DetailsMythicDungeonChartFrame.ShowChartFrame()
-- /run _G.DetailsMythicDungeonChartHandler.ShowReadyPanel()

--show a small panel telling the chart is ready to show
function mythicDungeonCharts.ShowReadyPanel()
	
	--check if is enabled
	if (not _detalhes.mythic_plus.show_damage_graphic) then
		return
	end
	
	--create the panel
	if (not mythicDungeonCharts.ReadyFrame) then
		mythicDungeonCharts.ReadyFrame = CreateFrame ("frame", "DetailsMythicDungeonReadyFrame", UIParent, "BackdropTemplate")
		local f = mythicDungeonCharts.ReadyFrame
		
		f:SetSize (255, 80)
		f:SetPoint ("center", UIParent, "center", 300, 0)
		f:SetFrameStrata ("LOW")
		f:EnableMouse (true)
		f:SetMovable (true)
		f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f:SetBackdropColor (0, 0, 0, 0.9)
		f:SetBackdropBorderColor (0, 0, 0, 1)
		DetailsFramework:ApplyStandardBackdrop (f)
		DetailsFramework:CreateTitleBar (f, "Details! Damage Graphic for M+")

		f:Hide()
		
		--register to libwindow
		local LibWindow = LibStub ("LibWindow-1.1")
		LibWindow.RegisterConfig (f, Details.mythic_plus.mythicrun_chart_frame_ready)
		LibWindow.RestorePosition (f)
		LibWindow.MakeDraggable (f)
		LibWindow.SavePosition (f)
		
		--show button
		f.ShowButton = DetailsFramework:CreateButton (f, function() mythicDungeonCharts.ShowChart(); f:Hide() end, 80, 20, Loc ["STRING_SLASH_SHOW"])
		f.ShowButton:SetTemplate (DetailsFramework:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		f.ShowButton:SetPoint ("topright", f, "topright", -5, -30)
		
		--discart button
		f.DiscartButton = DetailsFramework:CreateButton (f, function() f:Hide() end, 80, 20, Loc ["STRING_DISCARD"])
		f.DiscartButton:SetTemplate (DetailsFramework:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
		f.DiscartButton:SetPoint ("right", f.ShowButton, "left", -5, 0)
		
		--disable feature check box (dont show this again)
		local on_switch_enable = function (self, _, value)
			_detalhes.mythic_plus.show_damage_graphic = not value
		end
		local notAgainSwitch, notAgainLabel = DetailsFramework:CreateSwitch (f, on_switch_enable, not _detalhes.mythic_plus.show_damage_graphic, _, _, _, _, _, _, _, _, _, Loc ["STRING_MINITUTORIAL_BOOKMARK4"], DetailsFramework:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"), "GameFontHighlightLeft")
		notAgainSwitch:ClearAllPoints()
		notAgainLabel:SetPoint ("left", notAgainSwitch, "right", 2, 0)
		notAgainSwitch:SetPoint ("bottomleft", f, "bottomleft", 5, 5)
		notAgainSwitch:SetAsCheckBox()
	end
	
	mythicDungeonCharts.ReadyFrame:Show()
end

function mythicDungeonCharts.ShowChart()

	if (not mythicDungeonCharts.Frame) then
		
		mythicDungeonCharts.Frame = CreateFrame ("frame", "DetailsMythicDungeonChartFrame", UIParent, "BackdropTemplate")
		local f = mythicDungeonCharts.Frame
		
		f:SetSize (1200, 620)
		f:SetPoint ("center", UIParent, "center", 0, 0)
		f:SetFrameStrata ("LOW")
		f:EnableMouse (true)
		f:SetMovable (true)
		f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f:SetBackdropColor (0, 0, 0, 0.9)
		f:SetBackdropBorderColor (0, 0, 0, 1)
		
		--minimized frame
		mythicDungeonCharts.FrameMinimized = CreateFrame ("frame", "DetailsMythicDungeonChartFrameminimized", UIParent, "BackdropTemplate")
		local fMinimized = mythicDungeonCharts.FrameMinimized
		
		fMinimized:SetSize (160, 24)
		fMinimized:SetPoint ("center", UIParent, "center", 0, 0)
		fMinimized:SetFrameStrata ("LOW")
		fMinimized:EnableMouse (true)
		fMinimized:SetMovable (true)
		fMinimized:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		fMinimized:SetBackdropColor (0, 0, 0, 0.9)
		fMinimized:SetBackdropBorderColor (0, 0, 0, 1)
		fMinimized:Hide()
		
		f.IsMinimized = false
		
		--titlebar
			local titlebar = CreateFrame ("frame", nil, f, "BackdropTemplate")
			titlebar:SetPoint ("topleft", f, "topleft", 2, -3)
			titlebar:SetPoint ("topright", f, "topright", -2, -3)
			titlebar:SetHeight (20)
			titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar:SetBackdropColor (.5, .5, .5, 1)
			titlebar:SetBackdropBorderColor (0, 0, 0, 1)
			
			--> title
			local titleLabel = _detalhes.gump:NewLabel (titlebar, titlebar, nil, "titulo", "Plugins", "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
			titleLabel:SetPoint ("center", titlebar , "center")
			titleLabel:SetPoint ("top", titlebar , "top", 0, -5)
			f.TitleText = titleLabel
			
		--titlebar when minimized
			local titlebarMinimized = CreateFrame ("frame", nil, fMinimized, "BackdropTemplate")
			titlebarMinimized:SetPoint ("topleft", fMinimized, "topleft", 2, -3)
			titlebarMinimized:SetPoint ("topright", fMinimized, "topright", -2, -3)
			titlebarMinimized:SetHeight (20)
			titlebarMinimized:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebarMinimized:SetBackdropColor (.5, .5, .5, 1)
			titlebarMinimized:SetBackdropBorderColor (0, 0, 0, 1)
			
			--> title
			local titleLabelMinimized = _detalhes.gump:NewLabel (titlebarMinimized, titlebarMinimized, nil, "titulo", "Dungeon Run Chart", "GameFontHighlightLeft", 10, {227/255, 186/255, 4/255})
			titleLabelMinimized:SetPoint ("left", titlebarMinimized , "left", 4, 0)
			--titleLabelMinimized:SetPoint ("top", titlebarMinimized , "top", 0, -5)
			f.TitleTextMinimized = titleLabelMinimized
		
		_detalhes:FormatBackground (f)
		_detalhes:FormatBackground (fMinimized)
		
		tinsert (UISpecialFrames, "DetailsMythicDungeonChartFrame")
		
		--register to libwindow
		local LibWindow = LibStub ("LibWindow-1.1")
		LibWindow.RegisterConfig (f, Details.mythic_plus.mythicrun_chart_frame)
		LibWindow.RestorePosition (f)
		LibWindow.MakeDraggable (f)
		LibWindow.SavePosition (f)
		
		LibWindow.RegisterConfig (fMinimized, Details.mythic_plus.mythicrun_chart_frame_minimized)
		LibWindow.RestorePosition (fMinimized)
		LibWindow.MakeDraggable (fMinimized)
		LibWindow.SavePosition (fMinimized)
		
		f.ChartFrame = Details:GetFramework():CreateChartPanel (f, 1200, 600, "DetailsMythicDungeonChartGraphicFrame")
		f.ChartFrame:SetPoint ("topleft", f, "topleft", 5, -20)
		
		f.ChartFrame.FrameInUse = {}
		f.ChartFrame.FrameFree = {}
		f.ChartFrame.TextureID = 1
		
		f.ChartFrame.ShowHeader = true
		f.ChartFrame.HeaderOnlyIndicator = true
		f.ChartFrame.HeaderShowOverlays = false
		
		f.ChartFrame.Graphic.DrawLine = mythicDungeonCharts.CustomDrawLine
		
		f.ChartFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f.ChartFrame:SetBackdropColor (0, 0, 0, 0.0)
		f.ChartFrame:SetBackdropBorderColor (0, 0, 0, 0)
		
		f.ChartFrame:EnableMouse (false)
		
		f.ChartFrame.CloseButton:Hide()
		
		f.BossWidgetsFrame = CreateFrame ("frame", "$parentBossFrames", f, "BackdropTemplate")
		f.BossWidgetsFrame:SetFrameLevel (f:GetFrameLevel()+10)
		f.BossWidgetsFrame.Widgets = {}
		
		f.BossWidgetsFrame.GraphPin = f.BossWidgetsFrame:CreateTexture (nil, "overlay")
		f.BossWidgetsFrame.GraphPin:SetTexture ([[Interface\BUTTONS\UI-RadioButton]])
		f.BossWidgetsFrame.GraphPin:SetTexCoord (17/64, 32/64, 0, 1)
		f.BossWidgetsFrame.GraphPin:SetSize (16, 16)
		
		f.BossWidgetsFrame.GraphPinGlow = f.BossWidgetsFrame:CreateTexture (nil, "artwork")
		f.BossWidgetsFrame.GraphPinGlow:SetTexture ([[Interface\Calendar\EventNotificationGlow]])
		f.BossWidgetsFrame.GraphPinGlow:SetTexCoord (0, 1, 0, 1)
		f.BossWidgetsFrame.GraphPinGlow:SetSize (14, 14)
		f.BossWidgetsFrame.GraphPinGlow:SetBlendMode ("ADD")
		f.BossWidgetsFrame.GraphPinGlow:SetPoint ("center", f.BossWidgetsFrame.GraphPin, "center", 0, 0)

		f:Hide()
		
		function f.ShowChartFrame()
			if (f.IsMinimized) then
				f.IsMinimized = false
				fMinimized:Hide()
				f:Show()
			else
				f:Show()
			end
		end
		
		local closeButton = CreateFrame ("button", "$parentCloseButton", f, "UIPanelCloseButton")
		closeButton:GetNormalTexture():SetDesaturated (true)
		closeButton:SetWidth (24)
		closeButton:SetHeight (24)
		closeButton:SetPoint ("topright", f, "topright", 0, -1)
		closeButton:SetFrameLevel (f:GetFrameLevel()+16)
		
		local minimizeButton = CreateFrame ("button", "$parentCloseButton", f, "UIPanelCloseButton")
		minimizeButton:GetNormalTexture():SetDesaturated (true)
		minimizeButton:SetWidth (24)
		minimizeButton:SetHeight (24)
		minimizeButton:SetPoint ("right", closeButton, "left", 2, 0)
		minimizeButton:SetFrameLevel (f:GetFrameLevel()+16)
		minimizeButton:SetNormalTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Up]])
		minimizeButton:SetPushedTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Down]])
		minimizeButton:SetHighlightTexture ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Highlight]])
		
		local closeButtonWhenMinimized = CreateFrame ("button", "$parentCloseButton", fMinimized, "UIPanelCloseButton")
		closeButtonWhenMinimized:GetNormalTexture():SetDesaturated (true)
		closeButtonWhenMinimized:SetWidth (24)
		closeButtonWhenMinimized:SetHeight (24)
		closeButtonWhenMinimized:SetPoint ("topright", fMinimized, "topright", 0, -1)
		closeButtonWhenMinimized:SetFrameLevel (fMinimized:GetFrameLevel()+16)
		
		local minimizeButtonWhenMinimized = CreateFrame ("button", "$parentCloseButton", fMinimized, "UIPanelCloseButton")
		minimizeButtonWhenMinimized:GetNormalTexture():SetDesaturated (true)
		minimizeButtonWhenMinimized:SetWidth (24)
		minimizeButtonWhenMinimized:SetHeight (24)
		minimizeButtonWhenMinimized:SetPoint ("right", closeButtonWhenMinimized, "left", 2, 0)
		minimizeButtonWhenMinimized:SetFrameLevel (fMinimized:GetFrameLevel()+16)
		minimizeButtonWhenMinimized:SetNormalTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Up]])
		minimizeButtonWhenMinimized:SetPushedTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Down]])
		minimizeButtonWhenMinimized:SetHighlightTexture ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Highlight]])
		
		closeButtonWhenMinimized:SetScript ("OnClick", function()
			f.IsMinimized = false
			fMinimized:Hide()
			minimizeButtonWhenMinimized:SetNormalTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Up]])
			minimizeButtonWhenMinimized:SetPushedTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Down]])
		end)
		
		--> replace the default click function
		local minimize_func = function (self)
			if (f.IsMinimized) then
				f.IsMinimized = false
				fMinimized:Hide()
				f:Show()
				minimizeButtonWhenMinimized:SetNormalTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Up]])
				minimizeButtonWhenMinimized:SetPushedTexture ([[Interface\BUTTONS\UI-Panel-HideButton-Down]])
			else
				f.IsMinimized = true
				f:Hide()
				fMinimized:Show()
				minimizeButtonWhenMinimized:SetNormalTexture ([[Interface\BUTTONS\UI-Panel-CollapseButton-Up]])
				minimizeButtonWhenMinimized:SetPushedTexture ([[Interface\BUTTONS\UI-Panel-CollapseButton-Up]])
			end
		end
		
		minimizeButton:SetScript ("OnClick", minimize_func)
		minimizeButtonWhenMinimized:SetScript ("OnClick", minimize_func)
		
		--enabled box
		-- /run _G.DetailsMythicDungeonChartHandler.ShowChart(); DetailsMythicDungeonChartFrame.ShowChartFrame()
		local on_switch_enable = function (_, _, state)
			_detalhes.mythic_plus.show_damage_graphic = state
		end
		local enabledSwitch, enabledLabel = Details.gump:CreateSwitch (f, on_switch_enable, _detalhes.mythic_plus.show_damage_graphic, _, _, _, _, _, _, _, _, _, "Enabled", Details.gump:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"), "GameFontHighlightLeft")
		enabledSwitch:SetAsCheckBox()
		enabledSwitch.tooltip = "Show this chart at the end of a mythic dungeon run.\n\nIf disabled, you can reactivate it again at the options panel > streamer settings."
		enabledLabel:SetPoint ("right", minimizeButton, "left", -22, 0)
		enabledSwitch:SetSize (16, 16)
		Details.gump:SetFontColor (enabledLabel, "gray")
		enabledSwitch.checked_texture:SetVertexColor (.75, .75, .75)
		
		local leftDivisorLine = f.BossWidgetsFrame:CreateTexture (nil, "overlay")
		leftDivisorLine:SetSize (2, f.ChartFrame.Graphic:GetHeight())
		leftDivisorLine:SetColorTexture (1, 1, 1, 1)
		leftDivisorLine:SetPoint ("bottomleft", f.ChartFrame.Graphic.TextFrame, "bottomleft", -2, 0)
		
		local bottomDivisorLine = f.BossWidgetsFrame:CreateTexture (nil, "overlay")
		bottomDivisorLine:SetSize (f.ChartFrame.Graphic:GetWidth(), 2)
		bottomDivisorLine:SetColorTexture (1, 1, 1, 1)
		bottomDivisorLine:SetPoint ("bottomleft", f.ChartFrame.Graphic.TextFrame, "bottomleft", 0, 0)
		
		f.ChartFrame.Graphic:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f.ChartFrame.Graphic:SetBackdropColor (.5, .50, .50, 0.8)
		f.ChartFrame.Graphic:SetBackdropBorderColor (0, 0, 0, 0.5)
		
		function f.ChartFrame.RefreshBossTimeline (self, bossTable, elapsedTime)
			
			for i, bossTable in ipairs (mythicDungeonCharts.ChartTable.BossDefeated) do
				
				local bossWidget = f.BossWidgetsFrame.Widgets [i]
				if (not bossWidget) then
					local newBossWidget = CreateFrame ("frame", "$parentBossWidget" .. i, f.BossWidgetsFrame, "BackdropTemplate")
					newBossWidget:SetSize (64, 32)
					newBossWidget:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
					newBossWidget:SetBackdropColor (0, 0, 0, 0.1)
					newBossWidget:SetBackdropBorderColor (0, 0, 0, 0)
					
					local bossAvatar = Details:GetFramework():CreateImage (newBossWidget, "", 64, 32, "border")
					bossAvatar:SetPoint ("bottomleft", newBossWidget, "bottomleft", 0, 0)
					newBossWidget.AvatarTexture = bossAvatar
					
					local verticalLine = Details:GetFramework():CreateImage (newBossWidget, "", 1, f.ChartFrame.Graphic:GetHeight(), "overlay")
					verticalLine:SetColorTexture (1, 1, 1, 0.3)
					verticalLine:SetPoint ("bottomleft", newBossWidget, "bottomright", 0, 0)
					
					local timeText = Details:GetFramework():CreateLabel (newBossWidget)
					timeText:SetPoint ("bottomright", newBossWidget, "bottomright", 0, 0)
					newBossWidget.TimeText = timeText
					
					local timeBackground = Details:GetFramework():CreateImage (newBossWidget, "", 30, 12, "artwork")
					timeBackground:SetColorTexture (0, 0, 0, 0.5)
					timeBackground:SetPoint ("topleft", timeText, "topleft", -2, 2)
					timeBackground:SetPoint ("bottomright", timeText, "bottomright", 2, 0)
					
					f.BossWidgetsFrame.Widgets [i] = newBossWidget
					bossWidget = newBossWidget
				end
				
				local chartLength = f.ChartFrame.Graphic:GetWidth()
				local secondsPerPixel = chartLength / elapsedTime
				local xPosition = bossTable[1] * secondsPerPixel
				
				bossWidget:SetPoint ("bottomright", f.ChartFrame.Graphic, "bottomleft", xPosition, 0)
				
				bossWidget.TimeText:SetText (Details:GetFramework():IntegerToTimer (bossTable[1]))
				
				if (bossTable[2].bossimage) then
					bossWidget.AvatarTexture:SetTexture (bossTable[2].bossimage)
				else
					local bossAvatar = Details:GetBossPortrait (nil, nil, bossTable[2].name, bossTable[2].ej_instance_id)
					bossWidget.AvatarTexture:SetTexture (bossAvatar)
				end
			end
		end

	end
	
	mythicDungeonCharts.Frame.ChartFrame:Reset()
	
	if (not mythicDungeonCharts.ChartTable) then
		if (debugmode) then
			--development
			if (Details.mythic_plus.last_mythicrun_chart) then
				--load the last mythic dungeon run chart
				local t = {}
				Details:GetFramework().table.copy (t, Details.mythic_plus.last_mythicrun_chart)
				mythicDungeonCharts.ChartTable = t
				mythicDungeonCharts:Debug ("no valid data, saved data loaded")
			else
				mythicDungeonCharts:Debug ("no valid data and no saved data, canceling")
				mythicDungeonCharts.Frame:Hide()
				return
			end
		else
			mythicDungeonCharts.Frame:Hide()
			mythicDungeonCharts:Debug ("no data found, canceling")
			if (verbosemode) then
				mythicDungeonCharts:Debug ("mythicDungeonCharts.ShowChart() failed: no chart table")
			end
			return
		end
	end
	
	local charts = mythicDungeonCharts.ChartTable.Players
	local classDuplicated = {}
	
	mythicDungeonCharts.PlayerGraphIndex = {}

	for playerName, playerTable in pairs (charts) do
		
		local chartData = playerTable.ChartData
		local lineName = playerTable.Name
		
		classDuplicated [playerTable.Class] = (classDuplicated [playerTable.Class] or 0) + 1
		
		local lineColor
		if (playerTable.Class) then
			local classColor = mythicDungeonCharts.ClassColors [playerTable.Class .. classDuplicated [playerTable.Class]]
			if (classColor) then
				lineColor = {classColor.r, classColor.g, classColor.b}
			else
				lineColor = {1, 1, 1}
			end
		else
			lineColor = {1, 1, 1}
		end
		
		local combatTime = mythicDungeonCharts.ChartTable.ElapsedTime
		local texture = "line"
		
		--lowess smooth
		--chartData = mythicDungeonCharts.LowessSmoothing (chartData, 75)
		chartData = mythicDungeonCharts.Frame.ChartFrame:CalcLowessSmoothing (chartData, 75)
		
		local maxValue = 0
		for i = 1, #chartData do
			if (chartData [i] > maxValue) then
				maxValue = chartData [i]
			end
		end
		chartData.max_value = maxValue
		
		mythicDungeonCharts.Frame.ChartFrame:AddLine (chartData, lineColor, lineName, combatTime, texture, "SMA")
		tinsert (mythicDungeonCharts.PlayerGraphIndex, playerName)
		
		--[=[
		local smoothFactor = 0.075
		local forecastSmoothFactor = 1 - smoothFactor
		local lastForecast = chartData[1]
		local chartLag = {lastForecast}
		local maxValue = lastForecast
		
		for i = 2, #chartData do
			local forecast = (chartData[i] * smoothFactor) + (lastForecast * forecastSmoothFactor)
			tinsert (chartLag, forecast)
			lastForecast = forecast
			
			if (forecast > maxValue) then
				maxValue = forecast
			end
		end
		chartLag.max_value = maxValue

		mythicDungeonCharts.Frame.ChartFrame:AddLine (chartLag, lineColor, lineName, combatTime, texture, "SMA")		
		--]=]
	end
	
	mythicDungeonCharts.Frame.ChartFrame:RefreshBossTimeline (mythicDungeonCharts.ChartTable.BossDefeated, mythicDungeonCharts.ChartTable.ElapsedTime)
	
	--generate boss time table
	local bossTimeTable = {}
	for i, bossTable in ipairs (mythicDungeonCharts.ChartTable.BossDefeated) do
		local combatTime = bossTable [3] or math.random (10, 30)

		tinsert (bossTimeTable, bossTable[1])
		tinsert (bossTimeTable, bossTable[1] - combatTime)
	end
	
	mythicDungeonCharts.Frame.ChartFrame:AddOverlay (bossTimeTable, {1, 1, 1, 0.05}, "Show Boss", "")
	
	--local phrase = " Average Dps (under development)\npress Escape to hide, Details! Alpha Build." .. _detalhes.build_counter .. "." .. _detalhes.realversion
	local phrase = "Details!: Average Dps for "
	
	mythicDungeonCharts.Frame.ChartFrame:SetTitle ("")
	Details:GetFramework():SetFontSize (mythicDungeonCharts.Frame.ChartFrame.chart_title, 14)
	
	mythicDungeonCharts.Frame.TitleText:SetText (mythicDungeonCharts.ChartTable.DungeonName and phrase .. mythicDungeonCharts.ChartTable.DungeonName or phrase)
	
	mythicDungeonCharts.Frame.ShowChartFrame()
	
	if (verbosemode) then
		mythicDungeonCharts:Debug ("mythicDungeonCharts.ShowChart() success")
	end
end

local showID = 0
local HideTooltip = function (ticker)
	if (showID == ticker.ShowID) then
		GameCooltip2:Hide()
		mythicDungeonCharts.Frame.BossWidgetsFrame.GraphPin:Hide()
		mythicDungeonCharts.Frame.BossWidgetsFrame.GraphPinGlow:Hide()
	end
end
local PixelFrameOnEnter = function (self)
	local playerName = self.PlayerName
	--get the percent from the pixel height relative to the chart window
	local dps = self.Height / mythicDungeonCharts.Frame.ChartFrame:GetHeight()
	--multiply the max dps with the percent
	dps = mythicDungeonCharts.Frame.ChartFrame.Graphic.max_value * dps
	
	mythicDungeonCharts.Frame.BossWidgetsFrame.GraphPin:SetPoint ("center", self, "center", 0, 0)
	mythicDungeonCharts.Frame.BossWidgetsFrame.GraphPin:Show()
	mythicDungeonCharts.Frame.BossWidgetsFrame.GraphPinGlow:Show()

	GameCooltip2:Preset (2)
	GameCooltip2:SetOption ("FixedWidth", 100)
	GameCooltip2:SetOption ("TextSize", 10)
	local onlyName = _detalhes:GetOnlyName (playerName)
	GameCooltip2:AddLine (onlyName)
	
	local classIcon, L, R, B, T = _detalhes:GetClassIcon (mythicDungeonCharts.ChartTable.Players [playerName] and mythicDungeonCharts.ChartTable.Players [playerName].Class)
	GameCooltip2:AddIcon (classIcon, 1, 1, 16, 16, L, R, B, T)
	
	GameCooltip2:AddLine (Details:GetCurrentToKFunction()(nil, floor (dps)))
	
	GameCooltip2:SetOwner (self)
	GameCooltip2:Show()
	showID = showID + 1
end
local PixelFrameOnLeave = function (self)
	local timer = C_Timer.NewTimer (1, HideTooltip)
	timer.ShowID = showID
end

local TAXIROUTE_LINEFACTOR = 128 / 126 -- Multiplying factor for texture coordinates
local TAXIROUTE_LINEFACTOR_2 = TAXIROUTE_LINEFACTOR / 2 -- Half of that
function mythicDungeonCharts:CustomDrawLine (C, sx, sy, ex, ey, w, color, layer, linetexture, graphIndex)
	local relPoint = "BOTTOMLEFT"
	
	if sx == ex then
		if sy == ey then
			return
		else
			return self:DrawVLine(C, sx, sy, ey, w, color, layer)
		end
	elseif sy == ey then
		return self:DrawHLine(C, sx, ex, sy, w, color, layer)
	end
	
	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end
	
	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	
	if linetexture then --> this data series texture
		T:SetTexture(linetexture)
	elseif C.CustomLine then --> overall chart texture
		T:SetTexture(C.CustomLine)
	else --> no texture assigned, use default
		T:SetTexture(TextureDirectory.."line")
	end
	
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])
	-- Determine dimensions and center point of line
	local dx, dy = ex - sx, ey - sy
	local cx, cy = (sx + ex) / 2, (sy + ey) / 2

	-- Normalize direction if necessary
	if (dx < 0) then
		dx, dy = -dx, -dy
	end

	-- Calculate actual length of line
	local l = sqrt((dx * dx) + (dy * dy))

	-- Sin and Cosine of rotation, and combination (for later)
	local s, c = -dy / l, dx / l
	local sc = s * c

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2
		Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx
		TRy = BRx
	else
		Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2
		Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy
		TRx = TLy
	end

	-- Thanks Blizzard for adding (-)10000 as a hard-cap and throwing errors!
	-- The cap was added in 3.1.0 and I think it was upped in 3.1.1
	-- (way less chance to get the error)
	if TLx > 10000 then TLx = 10000 elseif TLx < -10000 then TLx = -10000 end
	if TLy > 10000 then TLy = 10000 elseif TLy < -10000 then TLy = -10000 end
	if BLx > 10000 then BLx = 10000 elseif BLx < -10000 then BLx = -10000 end
	if BLy > 10000 then BLy = 10000 elseif BLy < -10000 then BLy = -10000 end
	if TRx > 10000 then TRx = 10000 elseif TRx < -10000 then TRx = -10000 end
	if TRy > 10000 then TRy = 10000 elseif TRy < -10000 then TRy = -10000 end
	if BRx > 10000 then BRx = 10000 elseif BRx < -10000 then BRx = -10000 end
	if BRy > 10000 then BRy = 10000 elseif BRy < -10000 then BRy = -10000 end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy)
	T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt)
	T:SetPoint("TOPRIGHT", C, relPoint, cx + Bwid, cy + Bhgt)
	T:Show()
	
	--[=
	
	local playerName = mythicDungeonCharts.PlayerGraphIndex [graphIndex]
	if (mythicDungeonCharts.Frame.ChartFrame.TextureID % 3 == 0 and playerName) then
	
		local pixelFrame = tremove (mythicDungeonCharts.Frame.ChartFrame.FrameFree)
		if (not pixelFrame) then
			local newFrame = CreateFrame ("frame", nil, mythicDungeonCharts.Frame.ChartFrame, "BackdropTemplate")
			newFrame:SetSize (1, 1)

			--newFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 2, tile = true})
			--newFrame:SetBackdropColor (0, 0, 0, 1)
			newFrame:SetScript ("OnEnter", PixelFrameOnEnter)
			newFrame:SetScript ("OnLeave", PixelFrameOnLeave)
			
			pixelFrame = newFrame
		end
		
		pixelFrame:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt)
		pixelFrame:SetPoint("TOPRIGHT", C, relPoint, cx + Bwid, cy + Bhgt)
		
		tinsert (mythicDungeonCharts.Frame.ChartFrame.FrameInUse, pixelFrame)
		pixelFrame.PlayerName = playerName
		pixelFrame.Height = ey
		
	end
	
	mythicDungeonCharts.Frame.ChartFrame.TextureID = mythicDungeonCharts.Frame.ChartFrame.TextureID + 1
	--]=]
	
	return T
end


mythicDungeonCharts.ClassColors = {
	["HUNTER1"] = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
	["HUNTER2"] = { r = 0.47, g = 0.63, b = 0.25, colorStr = "ffabd473" },
	["HUNTER3"] = { r = 0.27, g = 0.43, b = 0.05, colorStr = "ffabd473" },
	
	["WARLOCK1"] = { r = 0.53, g = 0.53, b = 0.93, colorStr = "ff8788ee" },
	["WARLOCK2"] = { r = 0.33, g = 0.33, b = 0.73, colorStr = "ff8788ee" },
	["WARLOCK3"] = { r = 0.13, g = 0.13, b = 0.53, colorStr = "ff8788ee" },
	
	["PRIEST1"] = { r = 1.0, g = 1.0, b = 1.0, colorStr = "ffffffff" },
	["PRIEST2"] = { r = 0.8, g = 0.8, b = 0.8, colorStr = "ffffffff" },
	["PRIEST3"] = { r = 0.6, g = 0.6, b = 0.6, colorStr = "ffffffff" },
	
	["PALADIN1"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
	["PALADIN2"] = { r = 0.76, g = 0.35, b = 0.53, colorStr = "fff58cba" },
	["PALADIN3"] = { r = 0.56, g = 0.15, b = 0.33, colorStr = "fff58cba" },
	
	["MAGE1"] = { r = 0.25, g = 0.78, b = 0.92, colorStr = "ff3fc7eb" },
	["MAGE2"] = { r = 0.05, g = 0.58, b = 0.72, colorStr = "ff3fc7eb" },
	["MAGE3"] = { r = 0.0, g = 0.38, b = 0.52, colorStr = "ff3fc7eb" },
	
	["ROGUE1"] = { r = 1.0, g = 0.96, b = 0.41, colorStr = "fffff569" },
	["ROGUE2"] = { r = 0.8, g = 0.76, b = 0.21, colorStr = "fffff569" },
	["ROGUE3"] = { r = 0.6, g = 0.56, b = 0.01, colorStr = "fffff569" },
	
	["DRUID1"] = { r = 1.0, g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
	["DRUID2"] = { r = 0.8, g = 0.29, b = 0.04, colorStr = "ffff7d0a" },
	["DRUID3"] = { r = 0.6, g = 0.09, b = 0.04, colorStr = "ffff7d0a" },
	
	["SHAMAN1"] = { r = 0.0, g = 0.44, b = 0.87, colorStr = "ff0070de" },
	["SHAMAN2"] = { r = 0.0, g = 0.24, b = 0.67, colorStr = "ff0070de" },
	["SHAMAN3"] = { r = 0.0, g = 0.04, b = 0.47, colorStr = "ff0070de" },
	
	["WARRIOR1"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
	["WARRIOR2"] = { r = 0.58, g = 0.41, b = 0.23, colorStr = "ffc79c6e" },
	["WARRIOR3"] = { r = 0.38, g = 0.21, b = 0.03, colorStr = "ffc79c6e" },
	
	["DEATHKNIGHT1"] = { r = 0.77, g = 0.12 , b = 0.23, colorStr = "ffc41f3b" },
	["DEATHKNIGHT2"] = { r = 0.57, g = 0.02 , b = 0.03, colorStr = "ffc41f3b" },
	["DEATHKNIGHT3"] = { r = 0.37, g = 0.02 , b = 0.03, colorStr = "ffc41f3b" },
	
	["MONK1"] = { r = 0.0, g = 1.00 , b = 0.59, colorStr = "ff00ff96" },
	["MONK2"] = { r = 0.0, g = 0.8 , b = 0.39, colorStr = "ff00ff96" },
	["MONK3"] = { r = 0.0, g = 0.6 , b = 0.19, colorStr = "ff00ff96" },
	
	["DEMONHUNTER1"] = { r = 0.64, g = 0.19, b = 0.79, colorStr = "ffa330c9" },
	["DEMONHUNTER2"] = { r = 0.44, g = 0.09, b = 0.59, colorStr = "ffa330c9" },
	["DEMONHUNTER3"] = { r = 0.24, g = 0.09, b = 0.39, colorStr = "ffa330c9" },
};


if (debugmode) then
	C_Timer.After (1, mythicDungeonCharts.ShowChart)
end
