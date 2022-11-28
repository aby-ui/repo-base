
do
	local Details = Details
	if (not Details) then
		print ("Details! Not Found.")
		return
	end

	local _
	local DF = _G.DetailsFramework
	local _ipairs = ipairs
	local unpack = _G.unpack
	local gameCooltip = GameCooltip2

	--> minimal details version required to run this plugin
	local MINIMAL_DETAILS_VERSION_REQUIRED = 136
	local COMPARETWO_VERSION = "v1.0.0"

	--> create a plugin object
	local compareTwo = Details:NewPluginObject ("Details_Compare2", _G.DETAILSPLUGIN_ALWAYSENABLED)
	--> just localizing here the plugin's main frame
	local frame = compareTwo.Frame

	--> set the description
	compareTwo:SetPluginDescription("Replaces the default comparison window on the player breakdown.")

	--> when receiving an event from details, handle it here
	local handle_details_event = function (event, ...)

		if (event == "COMBAT_PLAYER_ENTER") then

		elseif (event == "COMBAT_PLAYER_LEAVE") then

		elseif (event == "PLUGIN_DISABLED") then
			--> plugin has been disabled at the details options panel

		elseif (event == "PLUGIN_ENABLED") then
			--> plugin has been enabled at the details options panel

		elseif (event == "DETAILS_DATA_SEGMENTREMOVED") then
			--> old segment got deleted by the segment limit

		elseif (event == "DETAILS_DATA_RESET") then
			--> combat data got wiped

		end
	end

	function compareTwo.InstallAdvancedCompareWindow()

        --colors to use on percent number
		local red = "FFFFAAAA"
		local green = "FFAAFFAA"
		local plus = red .. "-" 
		local minor = green .. "+"

		local comparisonFrameSettings = {
			--main player scroll frame
			mainScrollWidth = 250,
			petColor = "|cFFCCBBBB",

			--spell scroll
			spellScrollHeight = 300,
			spellLineAmount = 14,
			spellLineHeight = 20,

			--target scroll
			targetScrollHeight = 130,
			targetScrollLineAmount = 6,
			targetScrollLineHeight = 20,

			--comparison scrolls
			comparisonScrollWidth = 140,
			targetMaxLines = 16,
			targetTooltipLineHeight = 16,

			--font settings
			fontSize = 10,
			playerNameSize = 12,
			playerNameYOffset = 12,

			--line colors
			lineOnEnterColor = {.85, .85, .85, .5},

			--tooltips
			tooltipBorderColor = {.2, .2, .2, .9},
		}

		local comparisonLineContrast = {{1, 1, 1, .1}, {1, 1, 1, 0}}
		local latestLinesHighlighted = {}
		local comparisonTooltips = {nextTooltip = 0}
		local comparisonTargetTooltips = {nextTooltip = 0}

		local resetTargetComparisonTooltip = function()
			comparisonTargetTooltips.nextTooltip = 0
			for _, tooltip in ipairs (comparisonTargetTooltips) do
				for i = 1, #tooltip.lines do
					local line = tooltip.lines [i]
					line.spellIcon:SetTexture ("")
					line.spellName:SetText ("")
					line.spellAmount:SetText ("")
					line.spellPercent:SetText ("")
					line:Hide()
				end
				
				tooltip:Hide()
				tooltip:ClearAllPoints()
			end
		end
		
		local resetComparisonTooltip = function()
			comparisonTooltips.nextTooltip = 0
			for _, tooltip in ipairs (comparisonTooltips) do
				tooltip:Hide()
				tooltip:ClearAllPoints()
			end
		end
		
		local getTargetComparisonTooltip = function()
			comparisonTargetTooltips.nextTooltip = comparisonTargetTooltips.nextTooltip + 1
			local tooltip = comparisonTargetTooltips [comparisonTargetTooltips.nextTooltip]
			
			if (tooltip) then
				return tooltip
			end
			
			tooltip = CreateFrame ("frame", nil, UIParent, "BackdropTemplate")
			tooltip:SetFrameStrata ("tooltip")
			tooltip:SetSize (1, 1)
			_detalhes.gump:CreateBorder (tooltip)
			tooltip:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			tooltip:SetBackdropColor (.2, .2, .2, .99)
			tooltip:SetBackdropBorderColor (unpack (comparisonFrameSettings.tooltipBorderColor))
			tooltip:SetHeight (77)
			
			local bg_color = {0.5, 0.5, 0.5}
			local bg_texture = [[Interface\AddOns\Details\images\bar_background]]
			local bg_alpha = 1
			local bg_height = 12
			local colors = {{26/255, 26/255, 26/255}, {19/255, 19/255, 19/255}, {26/255, 26/255, 26/255}, {34/255, 39/255, 42/255}, {42/255, 51/255, 60/255}}
			
			--player name label
			tooltip.player_name_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.player_name_label:SetPoint ("bottomleft", tooltip, "topleft", 1, 2)
			tooltip.player_name_label:SetTextColor (1, .7, .1, .834)
			DetailsFramework:SetFontSize (tooltip.player_name_label, 11)
			
			local name_bg = tooltip:CreateTexture (nil, "artwork")
			name_bg:SetTexture (bg_texture)
			name_bg:SetPoint ("bottomleft", tooltip, "topleft", 0, 1)
			name_bg:SetPoint ("bottomright", tooltip, "topright", 0, 1)
			name_bg:SetHeight (bg_height + 2)
			name_bg:SetAlpha (bg_alpha)
			name_bg:SetVertexColor (unpack (colors[2]))
			
			comparisonTargetTooltips [comparisonTargetTooltips.nextTooltip] = tooltip
			
			tooltip.lines = {}
			
			local lineHeight = comparisonFrameSettings.targetTooltipLineHeight
			local fontSize = 10
			
			for i = 1, comparisonFrameSettings.targetMaxLines do
				local line = CreateFrame ("frame", nil, tooltip, "BackdropTemplate")
				line:SetPoint ("topleft", tooltip, "topleft", 0, -(i-1) * (lineHeight + 1))
				line:SetPoint ("topright", tooltip, "topright", 0, -(i-1) * (lineHeight + 1))
				line:SetHeight (lineHeight)
				
				line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				line:SetBackdropColor (0, 0, 0, 0.2)
				
				local spellIcon = line:CreateTexture ("$parentIcon", "overlay")
				spellIcon:SetSize (lineHeight -2 , lineHeight - 2)
				
				local spellName = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
				local spellAmount = line:CreateFontString ("$parentAmount", "overlay", "GameFontNormal")
				local spellPercent = line:CreateFontString ("$parentPercent", "overlay", "GameFontNormal")
				DetailsFramework:SetFontSize (spellName, fontSize)
				DetailsFramework:SetFontSize (spellAmount, fontSize)
				DetailsFramework:SetFontSize (spellPercent, fontSize)
				
				spellIcon:SetPoint ("left", line, "left", 2, 0)
				spellName:SetPoint ("left", spellIcon, "right", 2, 0)
				spellAmount:SetPoint ("right", line, "right", -2, 0)
				spellPercent:SetPoint ("right", line, "right", -40, 0)
				
				spellName:SetJustifyH ("left")
				spellAmount:SetJustifyH ("right")
				spellPercent:SetJustifyH ("right")
				
				line.spellIcon = spellIcon
				line.spellName = spellName
				line.spellAmount = spellAmount
				line.spellPercent = spellPercent
				
				tooltip.lines [#tooltip.lines+1] = line
				
				if (i % 2 == 0) then
					line:SetBackdropColor (unpack (comparisonLineContrast [1]))
					line.BackgroundColor = comparisonLineContrast [1]
				else
					line:SetBackdropColor (unpack (comparisonLineContrast [2]))
					line.BackgroundColor = comparisonLineContrast [2]
				end
			end
			
			return tooltip
		end
		
		local getComparisonTooltip = function()
			comparisonTooltips.nextTooltip = comparisonTooltips.nextTooltip + 1
			local tooltip = comparisonTooltips [comparisonTooltips.nextTooltip]
			
			if (tooltip) then
				return tooltip
			end
			
			tooltip = CreateFrame ("frame", nil, UIParent, "BackdropTemplate")
			tooltip:SetFrameStrata ("tooltip")
			tooltip:SetSize (1, 1)
			_detalhes.gump:CreateBorder (tooltip)
			tooltip:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			tooltip:SetBackdropColor (0, 0, 0, 1)
			tooltip:SetBackdropBorderColor (unpack (comparisonFrameSettings.tooltipBorderColor))
			tooltip:SetHeight (77)
			
			comparisonTooltips [comparisonTooltips.nextTooltip] = tooltip
			
			--prototype
			local y = -3
			local x_start = 2
			
			local bg_color = {0.5, 0.5, 0.5}
			local bg_texture = [[Interface\AddOns\Details\images\bar_background]]
			local bg_alpha = 1
			local bg_height = 12
			local colors = {{26/255, 26/255, 26/255}, {19/255, 19/255, 19/255}, {26/255, 26/255, 26/255}, {34/255, 39/255, 42/255}, {42/255, 51/255, 60/255}}
			
			local background = tooltip:CreateTexture (nil, "border")
			background:SetTexture ([[Interface\SPELLBOOK\Spellbook-Page-1]])
			background:SetTexCoord (.6, 0.1, 0, 0.64453125)
			background:SetVertexColor (0, 0, 0, 0.2)
			background:SetPoint ("topleft", tooltip, "topleft", 0, 0)
			background:SetPoint ("bottomright", tooltip, "bottomright", 0, 0)
			
			--player name label
			tooltip.player_name_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.player_name_label:SetPoint ("bottomleft", tooltip, "topleft", 1, 2)
			tooltip.player_name_label:SetTextColor (1, .7, .1, .834)
			DetailsFramework:SetFontSize (tooltip.player_name_label, 11)
			
			local name_bg = tooltip:CreateTexture (nil, "artwork")
			name_bg:SetTexture (bg_texture)
			name_bg:SetPoint ("bottomleft", tooltip, "topleft", 0, 1)
			name_bg:SetPoint ("bottomright", tooltip, "topright", 0, 1)
			name_bg:SetHeight (bg_height + 2)
			name_bg:SetAlpha (bg_alpha)
			name_bg:SetVertexColor (unpack (colors[2]))
			
			--cast line
			tooltip.casts_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.casts_label:SetPoint ("topleft", tooltip, "topleft", x_start, -2 + (y*0))
			tooltip.casts_label:SetText ("Casts:")
			tooltip.casts_label:SetJustifyH ("left")
			tooltip.casts_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.casts_label2:SetPoint ("topright", tooltip, "topright", -x_start, -2 + (y*0))
			tooltip.casts_label2:SetText ("0")
			tooltip.casts_label2:SetJustifyH ("right")
			tooltip.casts_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.casts_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -2 + (y*0))
			tooltip.casts_label3:SetText ("0")
			tooltip.casts_label3:SetJustifyH ("right")
			
			--hits
			tooltip.hits_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.hits_label:SetPoint ("topleft", tooltip, "topleft", x_start, -14 + (y*1))
			tooltip.hits_label:SetText ("Hits:")
			tooltip.hits_label:SetJustifyH ("left")
			tooltip.hits_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.hits_label2:SetPoint ("topright", tooltip, "topright", -x_start, -14 + (y*1))
			tooltip.hits_label2:SetText ("0")
			tooltip.hits_label2:SetJustifyH ("right")
			tooltip.hits_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.hits_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -14 + (y*1))
			tooltip.hits_label3:SetText ("0")
			tooltip.hits_label3:SetJustifyH ("right")
			
			--average
			tooltip.average_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.average_label:SetPoint ("topleft", tooltip, "topleft", x_start, -26 + (y*2))
			tooltip.average_label:SetText ("Average:")
			tooltip.average_label:SetJustifyH ("left")
			tooltip.average_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.average_label2:SetPoint ("topright", tooltip, "topright", -x_start, -26 + (y*2))
			tooltip.average_label2:SetText ("0")
			tooltip.average_label2:SetJustifyH ("right")
			tooltip.average_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.average_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -26 + (y*2))
			tooltip.average_label3:SetText ("0")
			tooltip.average_label3:SetJustifyH ("right")
			
			--critical
			tooltip.crit_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.crit_label:SetPoint ("topleft", tooltip, "topleft", x_start, -38 + (y*3))
			tooltip.crit_label:SetText ("Critical:")
			tooltip.crit_label:SetJustifyH ("left")
			tooltip.crit_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.crit_label2:SetPoint ("topright", tooltip, "topright", -x_start, -38 + (y*3))
			tooltip.crit_label2:SetText ("0")
			tooltip.crit_label2:SetJustifyH ("right")
			tooltip.crit_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.crit_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -38 + (y*3))
			tooltip.crit_label3:SetText ("0")
			tooltip.crit_label3:SetJustifyH ("right")
			
			--uptime
			tooltip.uptime_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.uptime_label:SetPoint ("topleft", tooltip, "topleft", x_start, -50 + (y*4))
			tooltip.uptime_label:SetText ("Uptime:")
			tooltip.uptime_label:SetJustifyH ("left")
			tooltip.uptime_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.uptime_label2:SetPoint ("topright", tooltip, "topright", -x_start, -50 + (y*4))
			tooltip.uptime_label2:SetText ("0")
			tooltip.uptime_label2:SetJustifyH ("right")
			tooltip.uptime_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			tooltip.uptime_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -50 + (y*4))
			tooltip.uptime_label3:SetText ("0")
			tooltip.uptime_label3:SetJustifyH ("right")
			
			for i = 1, 5 do
				local bg_line1 = tooltip:CreateTexture (nil, "artwork")
				bg_line1:SetTexture (bg_texture)
				bg_line1:SetPoint ("topleft", tooltip, "topleft", 0, -2 + (((i-1) * 12) * -1) + (y * (i-1)) + 2)
				bg_line1:SetPoint ("topright", tooltip, "topright", -0, -2 + (((i-1) * 12) * -1)  + (y * (i-1)) + 2)
				bg_line1:SetHeight (bg_height + 4)
				bg_line1:SetAlpha (bg_alpha)
				bg_line1:SetVertexColor (unpack (colors[i]))
			end
			
			return tooltip
		end
		
		--fill the tooltip for the main player being compared
		--actualPlayerName is the name of the player being compared, playerName can be the name of a pet
		local fillMainSpellTooltip = function (line, rawSpellTable, actualPlayerName, playerName)
			local tooltip = getComparisonTooltip()
			local formatFunc = Details:GetCurrentToKFunction()
			local spellId = rawSpellTable.id
			
			tooltip.player_name_label:SetText (Details:GetOnlyName (actualPlayerName))
			
			local fullPercent = "100%"
			local noData = "-"
			
			--amount of casts
			local castAmount = 0
			local combatObject = Details:GetCombatFromBreakdownWindow()
			local playerMiscObject = combatObject:GetActor (DETAILS_ATTRIBUTE_MISC, playerName)
			
			if (playerMiscObject) then
				castAmount = playerMiscObject.spell_cast and playerMiscObject.spell_cast [spellId] or 0
				tooltip.casts_label2:SetText (fullPercent)
				tooltip.casts_label3:SetText (castAmount)
				DetailsFramework:SetFontColor (tooltip.casts_label2, "gray")
				DetailsFramework:SetFontColor (tooltip.casts_label3, "white")
			else
				tooltip.casts_label2:SetText (noData)
				tooltip.casts_label3:SetText (noData)
				DetailsFramework:SetFontColor (tooltip.casts_label2, "silver")
				DetailsFramework:SetFontColor (tooltip.casts_label3, "silver")
			end
			
			--hit amount
			tooltip.hits_label2:SetText (fullPercent)
			DetailsFramework:SetFontColor (tooltip.hits_label2, "gray")
			tooltip.hits_label3:SetText (rawSpellTable.counter)
			DetailsFramework:SetFontColor (tooltip.hits_label3, "white")
			
			--average
			tooltip.average_label2:SetText (fullPercent)
			DetailsFramework:SetFontColor (tooltip.average_label2, "gray")
			local average = rawSpellTable.total / rawSpellTable.counter
			tooltip.average_label3:SetText (formatFunc (_, average))
			
			--critical strikes
			tooltip.crit_label2:SetText (fullPercent)
			DetailsFramework:SetFontColor (tooltip.crit_label2, "gray")
			tooltip.crit_label3:SetText (rawSpellTable.c_amt)
			
			--uptime
			local uptime = 0
			if (playerMiscObject) then
				local spell = playerMiscObject.debuff_uptime_spells and playerMiscObject.debuff_uptime_spells._ActorTable and playerMiscObject.debuff_uptime_spells._ActorTable [spellId]
				if (spell) then
					local minutos, segundos = floor (spell.uptime / 60), floor (spell.uptime % 60)
					uptime = spell.uptime
					tooltip.uptime_label2:SetText (fullPercent)
					tooltip.uptime_label3:SetText (minutos .. "m " .. segundos .. "s")
					
					DetailsFramework:SetFontColor (tooltip.uptime_label2, "gray")
					DetailsFramework:SetFontColor (tooltip.uptime_label3, "white")
				else
					tooltip.uptime_label2:SetText (noData)
					tooltip.uptime_label3:SetText (noData)
					DetailsFramework:SetFontColor (tooltip.uptime_label2, "gray")
					DetailsFramework:SetFontColor (tooltip.uptime_label3, "gray")
				end
			else
				tooltip.uptime_label2:SetText (noData)
				tooltip.uptime_label3:SetText (noData)
				DetailsFramework:SetFontColor (tooltip.uptime_label2, "gray")
				DetailsFramework:SetFontColor (tooltip.uptime_label3, "gray")
			end
			
			--show tooltip
			tooltip:SetPoint ("bottom", line, "top", 0, 2)
			tooltip:SetWidth (line:GetWidth())
			tooltip:Show()
			
			--highlight line
			line:SetBackdropColor (unpack (comparisonFrameSettings.lineOnEnterColor))
			latestLinesHighlighted [#latestLinesHighlighted + 1] = line
			
			return true, castAmount, rawSpellTable.counter, average, rawSpellTable.c_amt, uptime
		end
		
		local getPercentComparison = function (value1, value2)
			if (value1 == 0 and value2 == 0) then
				return "|c" .. minor .. "0%|r"
			
			elseif (value1 >= value2) then
				local diff = value1 - value2
				local up

				if (diff == 0 or value2 == 0) then --stop div by zero ptr
					up = "0"
				else
					up = diff / value2 * 100
					up = floor (up)
					
					if (up > 999) then
						up = "" .. 999
					end
				end
				
				return "|c" .. minor .. up .. "%|r"
			else
				local diff = value2 - value1
				local down

				if (diff == 0 or value1 == 0) then --stop div by zero ptr
					down = "0"
				else
					down = diff / value1 * 100
					down = floor (down)
					if (down > 999) then
						down = "" .. 999
					end
				end
				
				return "|c" .. plus .. down .. "%|r"
			end		
		end
		
		--fill the tooltip for comparison lines
		--actualPlayerName is the name of the player being compared, playerName can be the name of a pet
		local fillComparisonSpellTooltip = function (line, rawSpellTable, actualPlayerName, playerName, mainCastAmount, mainHitCounter, mainAverageDamage, mainCritAmount, mainAuraUptime)
			local tooltip = getComparisonTooltip()
			local formatFunc = Details:GetCurrentToKFunction()
			local spellId = rawSpellTable.id
			local noData = "-"

			tooltip.player_name_label:SetText (Details:GetOnlyName (actualPlayerName))
			
			--amount of casts	
			local castAmount = 0	
			local combatObject = Details:GetCombatFromBreakdownWindow()			
			local playerMiscObject = combatObject:GetActor (DETAILS_ATTRIBUTE_MISC, playerName)
			
			if (playerMiscObject) then
				castAmount = playerMiscObject.spell_cast and playerMiscObject.spell_cast [spellId] or 0
				tooltip.casts_label2:SetText (getPercentComparison (mainCastAmount, castAmount))
				tooltip.casts_label3:SetText (castAmount)
				DetailsFramework:SetFontColor (tooltip.casts_label2, "white")
				DetailsFramework:SetFontColor (tooltip.casts_label3, "white")
			else
				tooltip.casts_label2:SetText (noData)
				tooltip.casts_label3:SetText (noData)
				DetailsFramework:SetFontColor (tooltip.casts_label2, "silver")
				DetailsFramework:SetFontColor (tooltip.casts_label3, "silver")
			end
			
			--hits
			tooltip.hits_label2:SetText (getPercentComparison (mainHitCounter, rawSpellTable.counter))
			tooltip.hits_label3:SetText (rawSpellTable.counter)
			DetailsFramework:SetFontColor (tooltip.hits_label2, "white")
			DetailsFramework:SetFontColor (tooltip.hits_label3, "white")
			
			--average
			local average = rawSpellTable.total / rawSpellTable.counter
			tooltip.average_label2:SetText (getPercentComparison (mainAverageDamage, average))
			tooltip.average_label3:SetText (formatFunc (_, average))
			DetailsFramework:SetFontColor (tooltip.average_label3, "white")
			DetailsFramework:SetFontColor (tooltip.average_label2, "white")
			
			--critical strikes
			tooltip.crit_label2:SetText (getPercentComparison (mainCritAmount, rawSpellTable.c_amt))
			tooltip.crit_label3:SetText (rawSpellTable.c_amt)
			DetailsFramework:SetFontColor (tooltip.crit_label2, "white")
			DetailsFramework:SetFontColor (tooltip.crit_label2, "white")
			
			--uptime
			local uptime = 0
			if (playerMiscObject) then
				local spell = playerMiscObject.debuff_uptime_spells and playerMiscObject.debuff_uptime_spells._ActorTable and playerMiscObject.debuff_uptime_spells._ActorTable [spellId]
				if (spell) then
					local minutos, segundos = floor (spell.uptime / 60), floor (spell.uptime % 60)
					uptime = spell.uptime
					tooltip.uptime_label2:SetText (getPercentComparison (mainAuraUptime, uptime))
					tooltip.uptime_label3:SetText (minutos .. "m " .. segundos .. "s")
					
					DetailsFramework:SetFontColor (tooltip.uptime_label2, "white")
					DetailsFramework:SetFontColor (tooltip.uptime_label3, "white")
				else
					tooltip.uptime_label2:SetText (noData)
					tooltip.uptime_label3:SetText (noData)
					DetailsFramework:SetFontColor (tooltip.uptime_label2, "gray")
					DetailsFramework:SetFontColor (tooltip.uptime_label3, "gray")
				end
			else
				tooltip.uptime_label2:SetText (noData)
				tooltip.uptime_label3:SetText (noData)
				DetailsFramework:SetFontColor (tooltip.uptime_label2, "gray")
				DetailsFramework:SetFontColor (tooltip.uptime_label3, "gray")
			end
			
			--show tooltip
			tooltip:SetPoint ("bottom", line, "top", 0, 2)
			tooltip:SetWidth (line:GetWidth())
			tooltip:Show()
			
			--highlight line
			line:SetBackdropColor (unpack (comparisonFrameSettings.lineOnEnterColor))
			latestLinesHighlighted [#latestLinesHighlighted + 1] = line
		end
		
		local comparisonLineOnEnter = function (self)
			local scrollFrame = self:GetParent()
			local frame = scrollFrame:GetParent()
			
			if (not frame.GetPlayerInfo) then
				frame = frame:GetParent()
			end
		
			--check if this is a spell or a target line
			if (self.lineType == "mainPlayerSpell" or self.lineType == "comparisonPlayerSpell") then
			
				--get data
				local spellTable = self.spellTable
				local isPet = spellTable.npcId
				local npcId = spellTable.npcId
				local spellId = spellTable.spellId
				
				local mainPlayerObject = frame.GetMainPlayerObject()
				local mainSpellTable = frame.GetMainSpellTable()
				local allComparisonFrames = frame.GetAllComparisonFrames()
				
				local mainFrameScroll = frame.mainFrameScroll
				local playerObject, playerName = frame.GetPlayerInfo (scrollFrame)
				
				--store the spell information from the main tooltip
				local mainHasTooltip, castAmount, hitCounter, averageDamage, critAmount, auraUptime
				
				--iterate on the main player scroll and find the line
				local mainFrameLines = mainFrameScroll:GetFrames()
				for i = 1, #mainFrameLines do 
					local line = mainFrameLines [i]
					if (line.spellTable and line:IsShown()) then
						if (isPet) then
							if (line.spellTable.spellId == spellId and line.spellTable.npcId == npcId) then
								--main line for the hover over spell
								local rawSpellTable = line.spellTable.rawSpellTable
								mainHasTooltip, castAmount, hitCounter, averageDamage, critAmount, auraUptime = fillMainSpellTooltip (line, rawSpellTable, mainPlayerObject:Name(), line.spellTable.originalName)
								break
							end
						else
							if (line.spellTable.spellId == spellId and not line.spellTable.npcId) then
								--main line for the hover over spell
								local rawSpellTable = line.spellTable.rawSpellTable
								mainHasTooltip, castAmount, hitCounter, averageDamage, critAmount, auraUptime = fillMainSpellTooltip (line, rawSpellTable, mainPlayerObject:Name(), mainPlayerObject:Name())
								break
							end
						end
					end
				end
				
				if (mainHasTooltip) then
					--iterate among all other comparison scrolls
					for i = 1, #allComparisonFrames do
						local comparisonFrame = allComparisonFrames [i]
						if (comparisonFrame:IsShown()) then
							local scrollFrame = comparisonFrame.spellsScroll
							local playerObject, playerName = frame.GetPlayerInfo (comparisonFrame)
							
							local frameLines = scrollFrame:GetFrames()
							for i = 1, #frameLines do 
								local line = frameLines [i]
								if (line.spellTable and line:IsShown() and line.spellTable.rawSpellTable) then
									if (isPet) then
										if (line.spellTable.spellId == spellId and line.spellTable.npcId == npcId) then
											--line for the hover over spell in a comparison scroll frame
											local rawSpellTable = line.spellTable.rawSpellTable
											fillComparisonSpellTooltip (line, rawSpellTable, playerName, line.spellTable.originalName, castAmount, hitCounter, averageDamage, critAmount, auraUptime)
										end
									else
										if (line.spellTable.spellId == spellId and not line.spellTable.npcId) then
											--line for the hover over spell in a comparison scroll frame
											local rawSpellTable = line.spellTable.rawSpellTable
											fillComparisonSpellTooltip (line, rawSpellTable, playerName, playerName, castAmount, hitCounter, averageDamage, critAmount, auraUptime)
										end
									end
								end
							end
						end
					end
				end
				
				
				
				
			elseif (self.lineType == "mainPlayerTarget" or self.lineType == "comparisonPlayerTarget") then
				
				local targetName = self.targetTable.originalName
				local attribute = Details:GetDisplayTypeFromBreakdownWindow()
				
				--build a list of spells used by the main actor
				local mainPlayerObject = frame.GetMainPlayerObject()
				local damageDoneBySpell = {}
				
				--find the main line
				--iterate on the main player scroll and find the line
				local mainLine
				local mainFrameScroll = frame.targetFrameScroll
				local mainFrameLines = mainFrameScroll:GetFrames()
				
				for i = 1, #mainFrameLines do 
					local line = mainFrameLines [i]
					if (line.targetTable and line:IsShown()) then
						if (line.targetTable.originalName == targetName) then
							mainLine = line
							break
						end
					end
				end
				
				if (not mainLine) then
					return
				end
				
				--spells
				for spellId, spellTable in pairs (mainPlayerObject:GetActorSpells()) do
					local damageOnTarget = spellTable.targets [targetName]
					if (damageOnTarget and damageOnTarget > 0) then
						damageDoneBySpell [#damageDoneBySpell + 1] = {spellTable, damageOnTarget, mainPlayerObject:Name(), mainPlayerObject, false}
					end
				end
				
				--pets
				for _, petName in ipairs (mainPlayerObject:Pets()) do
					local petObject = Details:GetCombatFromBreakdownWindow():GetActor (attribute, petName)
					if (petObject) then
						for spellId, spellTable in pairs (petObject:GetActorSpells()) do
							local damageOnTarget = spellTable.targets [targetName]
							if (damageOnTarget and damageOnTarget > 0) then
								damageDoneBySpell [#damageDoneBySpell + 1] = {spellTable, damageOnTarget, petName, petObject, DetailsFramework:GetNpcIdFromGuid (petObject.serial)}
							end
						end
					end
				end
				
				table.sort (damageDoneBySpell, DetailsFramework.SortOrder2)

				local tooltip = getTargetComparisonTooltip()
				local formatFunc = Details:GetCurrentToKFunction()
				local mainHasTooltip = false
				tooltip.player_name_label:SetText (mainPlayerObject:GetDisplayName())
				
				for i = 1, #damageDoneBySpell do
					local damageTable = damageDoneBySpell [i]
					local spellTable = damageTable [1]
					local damageDone = damageTable [2]
					local actorName = damageTable [3]
					local actorObject = damageTable [4]
					local npcId = damageTable [5]
					
					local spellName, _, spellIcon = Details.GetSpellInfo (spellTable.id)
					
					local line = tooltip.lines [i]
					if (not line) then
						break
					end
					
					if (npcId) then
						spellName = spellName .. " (" .. comparisonFrameSettings.petColor .. actorName:gsub (" <.*", "") .. "|r)"
					end
					
					line.spellName:SetText (spellName)
					DetailsFramework:TruncateText (line.spellName, mainFrameScroll:GetWidth() - 110)
					
					line.spellIcon:SetTexture (spellIcon)
					line.spellIcon:SetTexCoord (.1, .9, .1, .9)
					line.spellAmount:SetText ("100%")
					DetailsFramework:SetFontColor (line.spellAmount, "gray")
					line.spellPercent:SetText (formatFunc (_, damageDone))
					
					line:Show()
					mainHasTooltip = true
				end
				
				--comparison
				if (mainHasTooltip) then
					local allComparisonFrames = frame.GetAllComparisonFrames()
					local combatObject = Details:GetCombatFromBreakdownWindow()
					
					--iterate among all other comparison scrolls
					for i = 1, #allComparisonFrames do
						local comparisonFrame = allComparisonFrames [i]
						if (comparisonFrame:IsShown()) then
							local scrollFrame = comparisonFrame.targetsScroll
							local playerObject, playerName = frame.GetPlayerInfo (comparisonFrame)
							
							local targetLines = scrollFrame:GetFrames()
							for o = 1, #targetLines do
								local line = targetLines [o]
								if (line and line.targetTable and line:IsShown()) then
									if (line.targetTable.originalName == targetName) then
										
										--get a tooltip for this actor
										local actorTooltip = getTargetComparisonTooltip()
										
										actorTooltip:SetPoint ("bottom", line, "top", 0, 2)
										actorTooltip:SetWidth (line:GetWidth())
										actorTooltip:SetHeight (min (comparisonFrameSettings.targetMaxLines, #damageDoneBySpell) * comparisonFrameSettings.targetTooltipLineHeight + comparisonFrameSettings.targetMaxLines)
										actorTooltip:Show()
										
										actorTooltip.player_name_label:SetText (playerObject:GetDisplayName())
										
										--highlight line
										line:SetBackdropColor (unpack (comparisonFrameSettings.lineOnEnterColor))
										latestLinesHighlighted [#latestLinesHighlighted + 1] = line
										
										--iterate among all spells in the first tooltip and fill here
										--if is a pet line, need to get the data from the player pet instead
										
										
										for a = 1, #damageDoneBySpell do
											local damageTable = damageDoneBySpell [a]
											local spellTable = damageTable [1]
											local damageDone = damageTable [2]
											local actorName = damageTable [3]
											local actorObject = damageTable [4]
											local npcId = damageTable [5]
											
											local foundSpell
											
											-- i is also the tooltip line index
											
											if (not npcId) then
												local spellObject = playerObject:GetSpell (spellTable.id)
												if (spellObject) then
													local damageOnTarget = spellObject.targets [targetName] or 0
													if (damageOnTarget > 0) then
														--this actor did damage on this target, add into the tooltip
														local tooltipLine = actorTooltip.lines [a]
														if (not tooltipLine) then
															break
														end
														
														local spellName, _, spellIcon = Details.GetSpellInfo (spellTable.id)
														
														tooltipLine.spellName:SetText ("")
														tooltipLine.spellIcon:SetTexture (spellIcon)
														tooltipLine.spellIcon:SetTexCoord (.1, .9, .1, .9)
														
														-- calculate percent 
														local mainSpellDamageOnTarget = 0
														-- find this spell in the main actor table
														for u = 1, #damageDoneBySpell do
															local mainSpell = damageDoneBySpell [u]

															local spellTableMain = damageTable [1]
															local damageDoneMain = damageTable [2]
															local actorNameMain = damageTable [3]
															local actorObjectMain = damageTable [4]
															local npcIdMain = damageTable [5]
															
															if (not npcIdMain and spellTableMain.id == spellObject.id) then
																--found the spell in the main table
																mainSpellDamageOnTarget = damageDoneMain
																break
															end
														end
														
														tooltipLine.spellAmount:SetText (getPercentComparison (mainSpellDamageOnTarget, damageOnTarget))
														tooltipLine.spellPercent:SetText (formatFunc (_, damageOnTarget))
														
														tooltipLine:Show()
														foundSpell = true
													end
												end
											else
												--iterate among all pets the player has and find one with the same npcId
												for _, petName in ipairs (playerObject:Pets()) do
													local petObject = combatObject:GetActor (attribute, petName)
													if (petObject) then
														local petNpcId = DetailsFramework:GetNpcIdFromGuid (petObject.serial)
														if (petNpcId and petNpcId == npcId) then
															--found the correct pet
															local spellObject = petObject:GetSpell (spellTable.id)
															if (spellObject) then
																local damageOnTarget = spellObject.targets [targetName] or 0
																if (damageOnTarget > 0) then
																	--this pet did damage on this target, add into the tooltip

																	local tooltipLine = actorTooltip.lines [a]
																	if (not tooltipLine) then
																		break
																	end
																	
																	-- calculate percent 
																	local mainSpellDamageOnTarget = 0
																	-- find this spell in the main actor table
																	for u = 1, #damageDoneBySpell do
																		local mainSpell = damageDoneBySpell [u]

																		local spellTableMain = damageTable [1]
																		local damageDoneMain = damageTable [2]
																		local actorNameMain = damageTable [3]
																		local actorObjectMain = damageTable [4]
																		local npcIdMain = damageTable [5]
																		
																		if (npcIdMain and npcIdMain == petNpcId and spellTableMain.id == spellObject.id) then
																			--found the spell in the main table
																			mainSpellDamageOnTarget = damageDoneMain
																			break
																		end
																	end
																	
																	local spellName, _, spellIcon = Details.GetSpellInfo (spellTable.id)
																	
																	tooltipLine.spellName:SetText ("")
																	tooltipLine.spellIcon:SetTexture (spellIcon)
																	tooltipLine.spellIcon:SetTexCoord (.1, .9, .1, .9)
																	tooltipLine.spellAmount:SetText (getPercentComparison (mainSpellDamageOnTarget, damageOnTarget))
																	tooltipLine.spellPercent:SetText (formatFunc (_, damageOnTarget))
																	
																	tooltipLine:Show()
																	foundSpell = true
																end
															end
														end
													end
												end

											end
											
											if (not foundSpell) then
												--add an empty line in the tooltip
												local tooltipLine = actorTooltip.lines [a]
												if (tooltipLine) then
													tooltipLine:Show()
												end
											end
										end
										
										--break the loop to find the correct line
										break
									end
								end
							end
						end
					end
				end
				
				--highlight line
				mainLine:SetBackdropColor (unpack (comparisonFrameSettings.lineOnEnterColor))
				latestLinesHighlighted [#latestLinesHighlighted + 1] = mainLine
				
				tooltip:SetPoint ("bottom", mainLine, "top", 0, 2)
				tooltip:SetWidth (mainLine:GetWidth())
				tooltip:SetHeight (min (comparisonFrameSettings.targetMaxLines, #damageDoneBySpell) * comparisonFrameSettings.targetTooltipLineHeight + comparisonFrameSettings.targetMaxLines)
				tooltip:Show()
			end
		end
		
		local comparisonLineOnLeave = function (self)
			for i = #latestLinesHighlighted, 1, -1 do
				local line = latestLinesHighlighted [i]
				line:SetBackdropColor (unpack (line.BackgroundColor))
				tremove (latestLinesHighlighted, i)
			end
			
			resetComparisonTooltip()
			resetTargetComparisonTooltip()
		end

		local playerComparisonCreate = function (tab, frame)
			
			frame.isComparisonTab = true
			
			--regular functions for comparison API
			function frame.GetMainPlayerName()
				return frame.mainPlayerObject:Name()
			end
			function frame.GetMainPlayerObject()
				return frame.mainPlayerObject
			end
			
			function frame.GetMainSpellTable()
				return frame.mainSpellTable
			end
			function frame.GetMainTargetTable()
				return frame.mainTargetTable
			end
			
			function frame.GetAllComparisonFrames()
				return frame.comparisonFrames
			end
			
			function frame.GetPlayerInfo (f)
				if (f.mainPlayerObject) then
					return f.mainPlayerObject, f.mainPlayerObject:Name()
				else
					return f.playerObject, f.playerObject:Name()
				end
			end
			
			--main player spells (scroll box with the spells the player used)
			local mainPlayerCreateline = function (self, index)
				local lineHeight = self.lineHeight
				local lineWidth = self.scrollWidth
				local fontSize = self.fontSize
				
				local line = CreateFrame ("button", "$parentLine" .. index, self, "BackdropTemplate")
				line:SetPoint ("topleft", self, "topleft", 1, -((index-1) * (lineHeight+1)))
				line:SetSize (lineWidth -2, lineHeight)
				
				line:SetScript ("OnEnter", comparisonLineOnEnter)
				line:SetScript ("OnLeave", comparisonLineOnLeave)
				
				line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				line:SetBackdropColor (0, 0, 0, 0.2)
				
				local spellIcon = line:CreateTexture ("$parentIcon", "overlay")
				spellIcon:SetSize (lineHeight -2 , lineHeight - 2)
				
				local spellName = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
				local spellAmount = line:CreateFontString ("$parentAmount", "overlay", "GameFontNormal")
				local spellPercent = line:CreateFontString ("$parentPercent", "overlay", "GameFontNormal")
				DetailsFramework:SetFontSize (spellName, fontSize)
				DetailsFramework:SetFontSize (spellAmount, fontSize)
				DetailsFramework:SetFontSize (spellPercent, fontSize)
				
				spellIcon:SetPoint ("left", line, "left", 2, 0)
				spellName:SetPoint ("left", spellIcon, "right", 2, 0)
				spellAmount:SetPoint ("right", line, "right", -2, 0)
				spellPercent:SetPoint ("right", line, "right", -40, 0)
				
				spellName:SetJustifyH ("left")
				spellAmount:SetJustifyH ("right")
				spellPercent:SetJustifyH ("right")
				
				line.spellIcon = spellIcon
				line.spellName = spellName
				line.spellAmount = spellAmount
				line.spellPercent = spellPercent
				
				return line
			end

			--the refresh function receives an already prepared table and just update the lines
			local mainPlayerRefreshSpellScroll = function (self, data, offset, totalLines)
				for i = 1, totalLines do
					local index = i + offset
					local spellTable = data [index]
					
					if (spellTable) then
						local line = self:GetLine (i)
						
						--store the line into the spell table
						spellTable.line = line
						line.spellTable = spellTable
						
						local spellId = spellTable.spellId
						local spellName = spellTable.spellName
						local spellIcon = spellTable.spellIcon
						local amountDone = spellTable.amount
						
						line.spellId = spellId
						
						line.spellIcon:SetTexture (spellIcon)
						line.spellIcon:SetTexCoord (.1, .9, .1, .9)
						
						line.spellName:SetText (spellName)
						DetailsFramework:TruncateText (line.spellName, line:GetWidth() - 70)
						
						local formatFunc = Details:GetCurrentToKFunction()
						line.spellAmount:SetText (formatFunc (_, amountDone))

						if (i % 2 == 0) then
							line:SetBackdropColor (unpack (comparisonLineContrast [1]))
							line.BackgroundColor = comparisonLineContrast [1]
						else
							line:SetBackdropColor (unpack (comparisonLineContrast [2]))
							line.BackgroundColor = comparisonLineContrast [2]
						end
					end
				end
			end
			
			local mainPlayerRefreshTargetScroll = function (self, data, offset, totalLines)
				for i = 1, totalLines do
					local index = i + offset
					local targetTable = data [index]
					
					if (targetTable) then
						local line = self:GetLine (i)
						
						--store the line into the target table
						targetTable.line = line
						line.targetTable = targetTable
						
						local targetName = targetTable.targetName
						local amountDone = targetTable.amount
						
						line.targetName = targetName
						
						line.spellIcon:SetTexture ("") --todo - fill this texture
						line.spellIcon:SetTexCoord (.1, .9, .1, .9)
						
						line.spellName:SetText (targetName)
						DetailsFramework:TruncateText (line.spellName, line:GetWidth() - 50)
						
						local formatFunc = Details:GetCurrentToKFunction()
						line.spellAmount:SetText (formatFunc (_, amountDone))

						if (i % 2 == 0) then
							line:SetBackdropColor (unpack (comparisonLineContrast [1]))
							line.BackgroundColor = comparisonLineContrast [1]
						else
							line:SetBackdropColor (unpack (comparisonLineContrast [2]))
							line.BackgroundColor = comparisonLineContrast [2]
						end
					end
				end
			end
			
			--main player spells scroll
			local mainPlayerFrameScroll = DetailsFramework:CreateScrollBox (frame, "$parentComparisonMainPlayerSpellsScroll", mainPlayerRefreshSpellScroll, {}, comparisonFrameSettings.mainScrollWidth, comparisonFrameSettings.spellScrollHeight, comparisonFrameSettings.spellLineAmount, comparisonFrameSettings.spellLineHeight)
			mainPlayerFrameScroll:SetPoint ("topleft", frame, "topleft", 5, -30)
			mainPlayerFrameScroll.lineHeight = comparisonFrameSettings.spellLineHeight
			mainPlayerFrameScroll.scrollWidth = comparisonFrameSettings.mainScrollWidth
			mainPlayerFrameScroll.fontSize = comparisonFrameSettings.fontSize
			
			mainPlayerFrameScroll:HookScript ("OnVerticalScroll", function (self, offset) 
				frame.RefreshAllComparisonScrollFrames()
			end)			
			
			--create lines
			for i = 1, comparisonFrameSettings.spellLineAmount do 
				local line = mainPlayerFrameScroll:CreateLine (mainPlayerCreateline)
				line.lineType = "mainPlayerSpell"
			end
			DetailsFramework:ReskinSlider (mainPlayerFrameScroll)
			
			frame.mainFrameScroll = mainPlayerFrameScroll
			
			--main player targets (scroll box with enemies the player applied damage)
			local mainTargetFrameScroll = DetailsFramework:CreateScrollBox (frame, "$parentComparisonMainPlayerTargetsScroll", mainPlayerRefreshTargetScroll, {}, comparisonFrameSettings.mainScrollWidth, comparisonFrameSettings.targetScrollHeight, comparisonFrameSettings.targetScrollLineAmount, comparisonFrameSettings.targetScrollLineHeight)
			mainTargetFrameScroll:SetPoint ("topleft", mainPlayerFrameScroll, "bottomleft", 0, -20)
			mainTargetFrameScroll.lineHeight = comparisonFrameSettings.targetScrollLineHeight
			mainTargetFrameScroll.scrollWidth = comparisonFrameSettings.mainScrollWidth
			mainTargetFrameScroll.fontSize = comparisonFrameSettings.fontSize
			
			--create lines
			for i = 1, comparisonFrameSettings.targetScrollLineAmount do 
				local line = mainTargetFrameScroll:CreateLine (mainPlayerCreateline)
				line.lineType = "mainPlayerTarget"
			end
			DetailsFramework:ReskinSlider (mainTargetFrameScroll)
			
			frame.targetFrameScroll = mainTargetFrameScroll

			--main player name
			frame.mainPlayerName = DetailsFramework:CreateLabel (mainPlayerFrameScroll)
			frame.mainPlayerName:SetPoint ("topleft", mainPlayerFrameScroll, "topleft", 2, comparisonFrameSettings.playerNameYOffset)
			frame.mainPlayerName.fontsize = comparisonFrameSettings.playerNameSize
			
			--create the framework for the comparing players
			local settings = {
				--comparison frame
				height = 600,
			}
			
			frame.comparisonFrames = {}
			frame.comparisonScrollFrameIndex = 0
			
			function frame.ResetComparisonFrames()
				frame.comparisonScrollFrameIndex = 0
				for _, comparisonFrame in ipairs (frame.comparisonFrames) do
					comparisonFrame:Hide()
					comparisonFrame.playerObject = nil
					comparisonFrame.spellsScroll.playerObject = nil
				end
			end
			
			local comparisonPlayerRefreshTargetScroll  = function (self, data, offset, totalLines)
				offset = FauxScrollFrame_GetOffset (mainPlayerFrameScroll)
				
				for i = 1, totalLines do
					local index = i + offset
					local targetTable = data [index]
					
					if (targetTable) then
						local line = self:GetLine (i)
						line:SetWidth (comparisonFrameSettings.comparisonScrollWidth - 2)
						
						--store the line into the target table
						targetTable.line = line
						line.targetTable = targetTable
						
						line.spellIcon:SetTexture ("")
						
						local mainPlayerAmount = targetTable.mainTargetAmount
						local amountDone = targetTable.amount
						
						if (mainPlayerAmount) then
							local formatFunc = Details:GetCurrentToKFunction()
							
							if (mainPlayerAmount > amountDone) then
								local diff = mainPlayerAmount - amountDone
								local up = diff / amountDone * 100
								up = floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								
								line.spellPercent:SetText ("|c" .. minor .. up .. "%|r")
							else
								local diff = amountDone - mainPlayerAmount
								local down = diff / mainPlayerAmount * 100
								down = floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								
								line.spellPercent:SetText ("|c" .. plus .. down .. "%|r")
							end
							
							line.spellAmount:SetText (formatFunc (_, amountDone))
						else
							line.spellPercent:SetText ("")
							line.spellAmount:SetText ("")
						end

						if (i % 2 == 0) then
							line:SetBackdropColor (unpack (comparisonLineContrast [1]))
							line.BackgroundColor = comparisonLineContrast [1]
						else
							line:SetBackdropColor (unpack (comparisonLineContrast [2]))
							line.BackgroundColor = comparisonLineContrast [2]
						end
					end
				end
			end
			
			--refresh a spell scroll on a comparison frame
			local comparisonPlayerRefreshSpellScroll = function (self, data, offset, totalLines)
			
				offset = FauxScrollFrame_GetOffset (mainPlayerFrameScroll)
			
				for i = 1, totalLines do
					local index = i + offset
					local spellTable = data[index]
					
					if (spellTable) then
						local line = self:GetLine(i)
						line:SetWidth(comparisonFrameSettings.comparisonScrollWidth - 2)
						
						--store the line into the spell table
						spellTable.line = line
						line.spellTable = spellTable
						
						local spellId = spellTable.spellId
						local spellName = spellTable.spellName
						local spellIcon = spellTable.spellIcon
						local amountDone = spellTable.amount
						
						line.spellId = spellId
						
						line.spellIcon:SetTexture(spellIcon)
						line.spellIcon:SetTexCoord(.1, .9, .1, .9)
						
						line.spellName:SetText("") --won't show the spell name, only the icon
						
						local percent = 1
						
						local mainFrame = self:GetParent().mainPlayer
						local mainSpellTable = self:GetParent().mainSpellTable
						local mainPlayerAmount = spellTable.mainSpellAmount
						
						if (mainPlayerAmount) then
							local formatFunc = Details:GetCurrentToKFunction()
							
							if (mainPlayerAmount > amountDone) then
								local diff = mainPlayerAmount - amountDone
								local up

								if (diff == 0 or mainPlayerAmount == 0) then --stop div by zero ptr
									up = "0"
								else
									up = diff / amountDone * 100
									up = floor (up)
									if (up > 999) then
										up = "" .. 999
									end
								end
								
								line.spellPercent:SetText ("|c" .. minor .. up .. "%|r")
							else
								local down
								local diff = amountDone - mainPlayerAmount
								if (diff == 0 or mainPlayerAmount == 0) then --stop div by zero ptr
									down = "0"
								else
									down = diff / mainPlayerAmount * 100
									down = floor(down)
									if (down > 999) then
										down = "" .. 999
									end
								end
								
								line.spellPercent:SetText("|c" .. plus .. down .. "%|r")
							end
							
							line.spellAmount:SetText(formatFunc(_, amountDone))
						else
							line.spellPercent:SetText("")
							line.spellAmount:SetText("")
						end

						if (i % 2 == 0) then
							line:SetBackdropColor (unpack (comparisonLineContrast [1]))
							line.BackgroundColor = comparisonLineContrast [1]
						else
							line:SetBackdropColor (unpack (comparisonLineContrast [2]))
							line.BackgroundColor = comparisonLineContrast [2]
						end
					end
				end
			end			
			
			function frame.RefreshAllComparisonScrollFrames()
				for _, comparisonFrame in ipairs (frame.comparisonFrames) do
					comparisonFrame.spellsScroll:Refresh()
				end
			end
			
			--get a frame which has two scrolls, one for spells and another for targets
			function frame.GetComparisonScrollFrame()
				frame.comparisonScrollFrameIndex = frame.comparisonScrollFrameIndex + 1
				
				local comparisonFrame = frame.comparisonFrames [frame.comparisonScrollFrameIndex]
				if (comparisonFrame) then
					comparisonFrame:Show()
					return comparisonFrame
				end
				
				local newComparisonFrame = CreateFrame ("frame", "DetailsComparisonFrame" .. frame.comparisonScrollFrameIndex, frame, "BackdropTemplate")
				frame.comparisonFrames [frame.comparisonScrollFrameIndex] = newComparisonFrame
				newComparisonFrame:SetSize (comparisonFrameSettings.comparisonScrollWidth, settings.height)
				
				if (frame.comparisonScrollFrameIndex == 1) then
					newComparisonFrame:SetPoint ("topleft", mainPlayerFrameScroll, "topright", 30, 0)
				else
					newComparisonFrame:SetPoint ("topleft", frame.comparisonFrames [frame.comparisonScrollFrameIndex - 1], "topright", 10, 0)
				end
				
				--create the spell comparison scroll
					--player name
					newComparisonFrame.playerName = DetailsFramework:CreateLabel (newComparisonFrame)
					newComparisonFrame.playerName:SetPoint ("topleft", newComparisonFrame, "topleft", 2, comparisonFrameSettings.playerNameYOffset)
					newComparisonFrame.playerName.fontsize = comparisonFrameSettings.playerNameSize
					
					--spells scroll
					local spellsScroll = DetailsFramework:CreateScrollBox (newComparisonFrame, "$parentComparisonPlayerSpellsScroll", comparisonPlayerRefreshSpellScroll, {}, comparisonFrameSettings.comparisonScrollWidth, comparisonFrameSettings.spellScrollHeight, comparisonFrameSettings.spellLineAmount, comparisonFrameSettings.spellLineHeight)
					spellsScroll:SetPoint ("topleft", newComparisonFrame, "topleft", 0, 0)
					spellsScroll.lineHeight = comparisonFrameSettings.spellLineHeight
					spellsScroll.scrollWidth = comparisonFrameSettings.mainScrollWidth
					spellsScroll.fontSize = comparisonFrameSettings.fontSize
					_G [spellsScroll:GetName() .. "ScrollBar"]:Hide()
					
						--create lines
						for i = 1, comparisonFrameSettings.spellLineAmount do 
							local line = spellsScroll:CreateLine (mainPlayerCreateline)
							line.lineType = "comparisonPlayerSpell"
						end
						DetailsFramework:ReskinSlider (spellsScroll)
						
						newComparisonFrame.spellsScroll = spellsScroll
					
					--targets scroll
					local targetsScroll = DetailsFramework:CreateScrollBox (newComparisonFrame, "$parentComparisonPlayerTargetsScroll", comparisonPlayerRefreshTargetScroll, {}, comparisonFrameSettings.comparisonScrollWidth, comparisonFrameSettings.targetScrollHeight, comparisonFrameSettings.targetScrollLineAmount, comparisonFrameSettings.targetScrollLineHeight)
					targetsScroll:SetPoint ("topleft", newComparisonFrame, "topleft", 0, -comparisonFrameSettings.spellScrollHeight - 20)
					targetsScroll.lineHeight = comparisonFrameSettings.spellLineHeight
					targetsScroll.scrollWidth = comparisonFrameSettings.mainScrollWidth
					targetsScroll.fontSize = comparisonFrameSettings.fontSize
					_G [targetsScroll:GetName() .. "ScrollBar"]:Hide()
					
						--create lines
						for i = 1, comparisonFrameSettings.targetScrollLineAmount do 
							local line = targetsScroll:CreateLine (mainPlayerCreateline)
							line.lineType = "comparisonPlayerTarget"
						end
						DetailsFramework:ReskinSlider (targetsScroll)
						
						newComparisonFrame.targetsScroll = targetsScroll
					
				return newComparisonFrame
			end
			
			if (not frame.__background) then
				DetailsFramework:ApplyStandardBackdrop(frame)
				frame.__background:SetAlpha(0.6)
			end
		end
		
		local buildSpellAndTargetTables = function (player, combat, attribute)
			--build the spell list for the main player including pets
			local allPlayerSpells = player:GetActorSpells()
			local resultSpellTable = {}
			
			for spellId, spellTable in pairs(allPlayerSpells) do
				local spellName, _, spellIcon = Details.GetSpellInfo (spellId)
				resultSpellTable [#resultSpellTable + 1] = {spellId, spellTable.total, spellName = spellName, spellIcon = spellIcon, spellId = spellId, amount = spellTable.total, rawSpellTable = spellTable}
			end
			
			--pets
			local petAbilities = {}
			for _, petName in ipairs(player:Pets()) do
				local petObject = combat:GetActor(attribute, petName)
				if (petObject) then
					local allPetSpells = petObject:GetActorSpells()
					local petNpcId = DetailsFramework:GetNpcIdFromGuid(petObject.serial)
					for spellId, spellTable in pairs(allPetSpells) do
						petAbilities[spellId] = petAbilities[spellId] or {total = 0, rawSpellTable = spellTable}
						petAbilities[spellId].total = petAbilities[spellId].total + spellTable.total
					end
				end
			end

			for spellId, petSpellTable in pairs(petAbilities) do
				local spellName, _, spellIcon = Details.GetSpellInfo(spellId)
				resultSpellTable [#resultSpellTable + 1] = {spellId, petSpellTable.total, spellName = spellName, spellIcon = spellIcon, spellId = spellId, amount = petSpellTable.total, rawSpellTable = petSpellTable.rawSpellTable}
			end
			
			table.sort (resultSpellTable, DetailsFramework.SortOrder2)
			
			--build the target list for the main player
			local resultTargetTable = {}
			for targetName, amountDone in pairs (player.targets) do
				resultTargetTable [#resultTargetTable + 1] = {targetName, amountDone, targetName = Details:RemoveOwnerName (targetName), amount = amountDone, originalName = targetName, rawPlayerObject = player}
			end
			
			table.sort (resultTargetTable, DetailsFramework.SortOrder2)
			
			return resultSpellTable, resultTargetTable
		end
		
		--main tab function to be executed when the tab is shown
		local playerComparisonFill = function (tab, player, combat)
			local frame = tab.frame

			--update player name
			frame.mainPlayerName.text = player:GetDisplayName()
			
			frame.mainPlayerObject = player
			frame.mainFrameScroll.mainPlayerObject = player
			
			--reset the comparison scroll frame
			frame.ResetComparisonFrames()
			resetComparisonTooltip()
			resetTargetComparisonTooltip()
			
			local attribute = Details:GetDisplayTypeFromBreakdownWindow()
			local resultSpellTable, resultTargetTable = buildSpellAndTargetTables (player, combat, attribute)

			--update the two main scroll frames
			frame.mainFrameScroll:SetData (resultSpellTable)
			frame.mainFrameScroll:Refresh()
			
			frame.targetFrameScroll:SetData (resultTargetTable)
			frame.targetFrameScroll:Refresh()
			
			frame.mainSpellTable = resultSpellTable
			frame.mainTargetTable = resultTargetTable
			
			--search the combat for players with the same spec and build a scroll frame for them
			--to keep consistency, sort these players with the max amount of damage or healing they have done
			local actorContainer = combat:GetContainer (attribute)
			local playersWithSameSpec = {}
			
			for _, playerObject in actorContainer:ListActors() do
				if (playerObject:IsPlayer() and playerObject.spec == player.spec and playerObject.serial ~= player.serial) then
					playersWithSameSpec [#playersWithSameSpec + 1] = {playerObject, playerObject.total}
				end
			end
			
			table.sort (playersWithSameSpec, DetailsFramework.SortOrder2)
			
			frame.comparisonSpellTable = {}
			frame.comparisonTargetTable = {}
			
			for i = 1, #playersWithSameSpec do
				--other player with the same spec
				local playerObject = playersWithSameSpec[i][1]
				local otherPlayerSpellTable, otherPlayerTargetTable = buildSpellAndTargetTables (playerObject, combat, attribute)
				
				frame.comparisonSpellTable [#frame.comparisonSpellTable + 1] = otherPlayerSpellTable
				frame.comparisonTargetTable [#frame.comparisonTargetTable + 1] = otherPlayerTargetTable
				
				local comparisonFrame = frame.GetComparisonScrollFrame()
				comparisonFrame.mainPlayer = player
				comparisonFrame.mainSpellTable = resultSpellTable
				comparisonFrame.mainTargetTable = resultTargetTable
				
				comparisonFrame.playerObject = playerObject
				comparisonFrame.playerName.text = playerObject:GetDisplayName()
				
				--iterate among spells of the main player and check if the spell exists on this player
					local otherPlayerResultSpellTable = {}
					
					for i = 1, #resultSpellTable do
						local spellTable = resultSpellTable [i]
						
						local found = false
						
						--iterate amont spell of the other player which the main player is being compared
						for o = 1, #otherPlayerSpellTable do
							local otherSpellTable = otherPlayerSpellTable[o]
						
							--check if this is a pet
							if (spellTable.npcId) then
								--match the npcId before match the spellId
								if (otherSpellTable.npcId == spellTable.npcId) then
									if (otherSpellTable.spellId == spellTable.spellId) then
										found = true
										--insert the amount of the main spell in the table
										otherSpellTable.mainSpellAmount = spellTable.amount
										otherPlayerResultSpellTable [#otherPlayerResultSpellTable+1] = otherSpellTable
										break
									end
								end
							else
								if (otherSpellTable.spellId == spellTable.spellId) then
									found = true
									--insert the amount of the main spell in the table
									otherSpellTable.mainSpellAmount = spellTable.amount
									otherPlayerResultSpellTable [#otherPlayerResultSpellTable+1] = otherSpellTable
									break
								end
							end
						end
						
						if (not found) then
							otherPlayerResultSpellTable [#otherPlayerResultSpellTable+1] = {0, 0, spellName = "", spellIcon = "", spellId = 0, amount = 0}
						end
					end

					--call the update function
					comparisonFrame.spellsScroll.playerObject = playerObject
					comparisonFrame.spellsScroll:SetData (otherPlayerResultSpellTable)
					comparisonFrame.spellsScroll:Refresh()
				
				--iterate among targets of the main player and check if the target exists on this player
					local otherPlayerResultTargetsTable = {}
					
					for i = 1, #resultTargetTable do
						local targetTable = resultTargetTable [i]
						
						local found = false
						
						--iterate amont targets of the other player which the main player is being compared
						for o = 1, #otherPlayerTargetTable do
							local otherTargetTable = otherPlayerTargetTable[o]
						
							if (otherTargetTable.originalName == targetTable.originalName) then
								found = true
								--insert the amount of the main spell in the table
								otherTargetTable.mainTargetAmount = targetTable.amount
								otherPlayerResultTargetsTable [#otherPlayerResultTargetsTable+1] = otherTargetTable
								break
							end
						end

						if (not found) then
							otherPlayerResultTargetsTable [#otherPlayerResultTargetsTable+1] = {"", 0, targetName = "", amount = 0, originalName = ""}
						end
					end

					--call the update function
					comparisonFrame.targetsScroll:SetData (otherPlayerResultTargetsTable)
					comparisonFrame.targetsScroll:Refresh()
			end
		end

		local iconTableCompare = {
			texture = [[Interface\AddOns\Details\images\icons]],
			--coords = {363/512, 381/512, 0/512, 17/512},
			coords = {383/512, 403/512, 0/512, 15/512},
			width = 16,
			height = 14,
		}

		Details:CreatePlayerDetailsTab ("New Compare", "Compare", --[1] tab name [2] localized name
			function (tabOBject, playerObject)  --[2] condition
				
				local attribute = Details:GetDisplayTypeFromBreakdownWindow()
				local combat = Details:GetCombatFromBreakdownWindow()
				
				if (attribute > 2) then
					return false
				end
				
				local playerSpec = playerObject.spec or "no-spec"
				local playerSerial = playerObject.serial
				local showTab = false
				
				for index, actor in _ipairs (combat [attribute]._ActorTable) do 
					if (actor.spec == playerSpec and actor.serial ~= playerSerial) then
						showTab = true
						break
					end
				end
				
				if (showTab) then
					return true
				end
				
				--return false
				return true --debug?
			end,
			
			playerComparisonFill, --[3] fill function
			
			nil, --[4] onclick
			
			playerComparisonCreate, --[5] oncreate
			iconTableCompare, --[6] icon table

			{
				attributes = {
					[1] = {1, 2, 3, 4, 5, 6, 7, 8},
					[2] = {1, 2, 3, 4, 5, 6, 7, 8},
				},
				tabNameToReplace = "Compare",
			} --replace tab [attribute] = [sub attributes]
		)
	end

---------------------------------------------------------------------------------------------------------------------------------------

	function compareTwo:OnEvent(_, event, ...)
		if (event == "ADDON_LOADED") then
			local AddonName = select(1, ...)
			if (AddonName == "Details_Compare2") then
				--> every plugin must have a OnDetailsEvent function
				function compareTwo:OnDetailsEvent(event, ...)
					return handle_details_event(event, ...)
				end

				--> Install: install -> if successful installed; saveddata -> a table saved inside details db, used to save small amount of data like configs
				local install, saveddata = Details:InstallPlugin("RAID", "Compare 2.0", "Interface\\Icons\\Ability_Warrior_BattleShout", compareTwo, "DETAILS_PLUGIN_COMPARETWO_WINDOW", MINIMAL_DETAILS_VERSION_REQUIRED, "Terciob", COMPARETWO_VERSION)
				if (type(install) == "table" and install.error) then
					print(install.error)
				end

				--> registering details events we need
				Details:RegisterEvent(compareTwo, "COMBAT_PLAYER_ENTER") --when details creates a new segment, not necessary the player entering in combat.
				Details:RegisterEvent(compareTwo, "COMBAT_PLAYER_LEAVE") --when details finishs a segment, not necessary the player leaving the combat.
				Details:RegisterEvent(compareTwo, "DETAILS_DATA_RESET") --details combat data has been wiped

				compareTwo.InstallAdvancedCompareWindow()

				--this plugin does not show in lists of plugins
				compareTwo.NoMenu = true
			end
		end
	end
end
