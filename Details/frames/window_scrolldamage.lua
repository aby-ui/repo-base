

local Details = _G.Details
local DF = _G.DetailsFramework


function Details:ScrollDamage()
	if (not DetailsScrollDamage) then
		DetailsScrollDamage = DetailsFramework:CreateSimplePanel(UIParent)
		DetailsScrollDamage:SetSize (427 - 40 - 20 - 20, 505 - 150 + 20)
		DetailsScrollDamage:SetTitle ("Details! Scroll Damage (/details scroll)")
		DetailsScrollDamage.Data = {}
		DetailsScrollDamage:ClearAllPoints()
		DetailsScrollDamage:SetPoint ("left", UIParent, "left", 10, 0)
		DetailsScrollDamage:Hide()
		
		local scroll_width = 395 - 40 - 20 - 20
		local scroll_height = 300
		local scroll_lines = 14
		local scroll_line_height = 20
		
		local backdrop_color = {.2, .2, .2, 0.2}
		local backdrop_color_on_enter = {.8, .8, .8, 0.4}
		local backdrop_color_is_critical = {.4, .4, .2, 0.2}
		local backdrop_color_is_critical_on_enter = {1, 1, .8, 0.4}
		
		local y = -15
		local headerY = y - 15
		local scrollY = headerY - 20

		local LibWindow = _G.LibStub("LibWindow-1.1")
		DetailsScrollDamage:SetScript("OnMouseDown", nil)
		DetailsScrollDamage:SetScript("OnMouseUp", nil)
		LibWindow.RegisterConfig(DetailsScrollDamage, Details.damage_scroll_position)
		LibWindow.MakeDraggable(DetailsScrollDamage)
		LibWindow.RestorePosition(DetailsScrollDamage)
	
		--header
		local headerTable = {
			{text = "Icon", width = 32},
			{text = "Spell Name", width = 100},
			{text = "Amount", width = 60},
			
			{text = "Time", width = 60},
			--{text = "Token", width = 80},
			{text = "Spell ID", width = 80},
			--{text = "School", width = 80},
		}
		local headerOptions = {
			padding = 2,
		}
		
		DetailsScrollDamage.Header = DetailsFramework:CreateHeader(DetailsScrollDamage, headerTable, headerOptions)
		DetailsScrollDamage.Header:SetPoint("topleft", DetailsScrollDamage, "topleft", 5, headerY)
		
		local scroll_refresh = function (self, data, offset, total_lines)
			
			local ToK = _detalhes:GetCurrentToKFunction()
			
			for i = 1, total_lines do
				local index = i + offset
				local spellTable = data [index]
				
				if (spellTable) then
				
					local line = self:GetLine(i)
					local time, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = unpack (spellTable)
					
					local spellName, _, spellIcon
					
					if (token ~= "SWING_DAMAGE") then
						spellName, _, spellIcon = GetSpellInfo(spellID)
					else
						spellName, _, spellIcon = GetSpellInfo(1)
					end
					
					line.SpellID = spellID
					line.IsCritical = isCritical
					
					if (isCritical) then
						line:SetBackdropColor(unpack(backdrop_color_is_critical))
					else
						line:SetBackdropColor(unpack(backdrop_color))
					end
					
					if (spellName) then
						line.Icon:SetTexture(spellIcon)
						line.Icon:SetTexCoord(.1, .9, .1, .9)
						
						line.DamageText.text = isCritical and "|cFFFFFF00" .. ToK (_, amount) or ToK (_, amount)
						line.TimeText.text = format("%.2f", time - DetailsScrollDamage.Data.Started)
						--line.TokenText.text = token:gsub ("SPELL_", "")
						--line.SchoolText.text = _detalhes:GetSpellSchoolFormatedName (school)
						line.SpellIDText.text = spellID

						DF:TruncateText(line.SpellNameText, 90)
						line.SpellNameText.text = spellName
					else
						line:Hide()
					end
				end
			end
		end
		
		local lineOnEnter = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor(unpack(backdrop_color_is_critical_on_enter))
			else
				self:SetBackdropColor(unpack(backdrop_color_on_enter))
			end
			
			if (self.SpellID) then
				--spell tooltip removed, it's to much annoying
				--GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				--GameTooltip:SetSpellByID(self.SpellID)
				--GameTooltip:AddLine(" ")
				--GameTooltip:Show()
			end
		end
		
		local lineOnLeave = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor(unpack(backdrop_color_is_critical))
			else
				self:SetBackdropColor(unpack(backdrop_color))
			end
			
			GameTooltip:Hide()
		end
		
		local scroll_createline = function (self, index)
		
			local line = CreateFrame ("button", "$parentLine" .. index, self,"BackdropTemplate")
			line:SetPoint ("topleft", self, "topleft", 1, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize (scroll_width - 2, scroll_line_height)
			
			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor (unpack (backdrop_color))
			
			DF:Mixin (line, DF.HeaderFunctions)
			
			line:SetScript ("OnEnter", lineOnEnter)
			line:SetScript ("OnLeave", lineOnLeave)
			
			--icon
			local icon = line:CreateTexture ("$parentSpellIcon", "overlay")
			icon:SetSize (scroll_line_height - 2, scroll_line_height - 2)
			
			--spellname
			local spellNameText = DF:CreateLabel (line)
			
			--damage
			local damageText = DF:CreateLabel (line)
			
			--time
			local timeText = DF:CreateLabel (line)
			
			--token
			--local tokenText = DF:CreateLabel (line)
			
			--spell ID
			local spellIDText = DF:CreateLabel (line)
			
			--school
			--local schoolText = DF:CreateLabel (line)

			line:AddFrameToHeaderAlignment (icon)
			line:AddFrameToHeaderAlignment (spellNameText)
			line:AddFrameToHeaderAlignment (damageText)
			line:AddFrameToHeaderAlignment (timeText)
			--line:AddFrameToHeaderAlignment (tokenText)
			line:AddFrameToHeaderAlignment (spellIDText)
			--line:AddFrameToHeaderAlignment (schoolText)
			
			line:AlignWithHeader (DetailsScrollDamage.Header, "left")
			
			line.Icon = icon
			line.DamageText = damageText
			line.TimeText = timeText
			--line.TokenText = tokenText
			--line.SchoolText = schoolText
			line.SpellIDText = spellIDText
			line.SpellNameText = spellNameText

			return line
		end
		
		local damageScroll = DF:CreateScrollBox (DetailsScrollDamage, "$parentSpellScroll", scroll_refresh, DetailsScrollDamage.Data, scroll_width, scroll_height, scroll_lines, scroll_line_height)
		DF:ReskinSlider (damageScroll)
		damageScroll:SetPoint ("topleft", DetailsScrollDamage, "topleft", 5, scrollY)
		
		--create lines
		for i = 1, scroll_lines do 
			damageScroll:CreateLine (scroll_createline)
		end
		
		local combatLogReader = CreateFrame ("frame")
		local playerSerial = UnitGUID ("player")
		
		combatLogReader:SetScript ("OnEvent", function (self)
			local timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = CombatLogGetCurrentEventInfo()
			if (sourceSerial == playerSerial) then
				if (token == "SPELL_DAMAGE" or token == "SPELL_PERIODIC_DAMAGE" or token == "RANGE_DAMAGE" or token == "DAMAGE_SHIELD") then
					if (not DetailsScrollDamage.Data.Started) then
						DetailsScrollDamage.Data.Started = time()
					end
					tinsert (DetailsScrollDamage.Data, 1, {timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill or 0, school or 1, resisted or 0, blocked or 0, absorbed or 0, isCritical})
					damageScroll:Refresh()
					
				elseif (token == "SWING_DAMAGE") then
				--	amount, overkill, school, resisted, blocked, absorbed, critical, glacing, crushing, isoffhand = spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical
				--	tinsert (DetailsScrollDamage.Data, 1, {timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical})
				--	damageScroll:Refresh()
				end
			end
		end)

		DetailsScrollDamage:SetScript ("OnShow", function()
			wipe (DetailsScrollDamage.Data)
			damageScroll:Refresh()
			combatLogReader:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		end)

		DetailsScrollDamage:SetScript ("OnHide", function()
			combatLogReader:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		end)

		--statusbar and auto open checkbox
		local statusBar = CreateFrame("frame", nil, DetailsScrollDamage, "BackdropTemplate")
		statusBar:SetPoint("bottomleft", DetailsScrollDamage, "bottomleft")
		statusBar:SetPoint("bottomright", DetailsScrollDamage, "bottomright")
		statusBar:SetHeight(20)
		statusBar:SetAlpha (0.8)
		DF:ApplyStandardBackdrop(statusBar)

		local onToggleAutoOpen = function(_, _, state)
			Details.damage_scroll_auto_open = state
		end
		local autoOpenCheckbox = DetailsFramework:CreateSwitch(statusBar, onToggleAutoOpen, Details.auto_open_news_window, _, _, _, _, "AutoOpenCheckbox", _, _, _, _, _, DetailsFramework:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
		autoOpenCheckbox:SetAsCheckBox()
		autoOpenCheckbox:SetPoint("left", statusBar, "left", 5, 0)

		local autoOpenText = DetailsFramework:CreateLabel(statusBar, "Auto Open on Training Dummy")
		autoOpenText:SetPoint("left", autoOpenCheckbox, "right", 2, 0)
	end

	DetailsScrollDamage:Show()
end

local targetDummieHandle = CreateFrame("frame")
local targetDummiesIds = {
    [31146] = true, --raider's training dummie
}

targetDummieHandle:SetScript("OnEvent", function(_, _, unit)
	if (not Details.damage_scroll_auto_open) then
		return
	end
    if (UnitExists("target")) then
        local serial = UnitGUID("target")
        if (serial) then
            local npcId = DetailsFramework:GetNpcIdFromGuid(serial)
            if (npcId) then
                if (targetDummiesIds[npcId]) then
                    Details:ScrollDamage()
                end
            end
        end
    end
end)
targetDummieHandle:RegisterEvent("PLAYER_TARGET_CHANGED")