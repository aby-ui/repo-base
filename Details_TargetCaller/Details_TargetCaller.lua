 
do

	local L = LibStub ("AceLocale-3.0"):GetLocale ("DetailsTargetCaller")

	local Details = Details
	if (not Details) then
		print (L["STRING_INSTALL_ERROR1"])
		return
	end
	
	local _
	
	--> minimal details version required to run this plugin
	local MINIMAL_DETAILS_VERSION_REQUIRED = 75
	local DETAILS_ATTRIBUTE_DAMAGE = DETAILS_ATTRIBUTE_DAMAGE
	local TCALLER_VERSION = "v1.2.3"
	
	--> keeps the information which details window the plugin is being shown
	local attachedInstance
	
	--> create a plugin object
	local targetCaller = Details:NewPluginObject ("Details_TargetCaller")
	--> just localizing here the plugin's main frame
	local frame = targetCaller.Frame
	--> set the description
	targetCaller:SetPluginDescription (L ["STRING_PLUGIN_DESC"])
	--> get the framework object
	local framework = targetCaller:GetFramework()
	
	local rosterTable = {} --> indexed table with players in the raid
	local rosterHashTable = {} --> a hash table with [playername] = true, just to know we already added the player inside the indexed table
	local barsTable = {} --> holds the bars we created
	
	local currentTarget = "" --> who we are targeting now
	local currentCombat = targetCaller:GetCurrentCombat() --> the reference of the current combat on Details!
	local textformat = targetCaller:GetCurrentToKFunction() --> the current number format function used by Details!
	
	targetCaller.Bars = barsTable --> adding this as a member, so we can call UpdatePluginBarsConfig()
	
	--> simple sort function
	local sort_by_total = function (actor1, actor2)
		return actor1.total > actor2.total
	end
	local sort_by_overall = function (actor1, actor2)
		return actor1.overall > actor2.overall
	end

	function targetCaller.UpdateWindowBars()
		--> create more bars if needed
		local totalbars = attachedInstance.rows_fit_in_window
		if (totalbars > #barsTable) then
			for i  = #barsTable+1, totalbars, 1 do
				barsTable [i] = framework:CreateBar (frame)
			end
		end

		--> update SetPoint() and import row_info from the attached instance into our addon object
		--> row_info holds all config used by the bars
		targetCaller:UpdatePluginBarsConfig()
		--> set our .Frame width and height to be the same as the instance
		targetCaller:AttachToInstance()
		
		--> with row_info copied, we update the bars here
		local row_info = targetCaller.row_info
		for _, bar in ipairs (barsTable) do
			bar.height = row_info.height
			bar.texture = row_info.texture
			bar.fontsize = row_info.font_size
			bar.fontface = row_info.font_face
			bar.fontcolor = row_info.fixed_text_color
			bar.shadow = row_info.textL_outline
		end
		
		--> and also update our ToK (text format number function)
		textformat = targetCaller:GetCurrentToKFunction()
	end
	
	--> hide all bars
	function targetCaller.ClearBars()
		for _, bar in ipairs (barsTable) do
			if (bar:IsShown()) then
				bar:Hide()
			end
		end
	end
	
	--> update how much damage players dealt to our current target
	function targetCaller.UpdateTotal (actor)
		local damage_actor = currentCombat (DETAILS_ATTRIBUTE_DAMAGE, actor.name)
		if (damage_actor) then
			local total = damage_actor.targets [currentTarget]
			actor.total = (total or 0) - actor.breakpoint
		end
	end
	
	--> when we changed the target, iterate amoung all players and save which are the current damage dealt to the target
	function targetCaller.SetBreakPoints (actor)
		if (actor) then
			--> this part runs when there is an update on the group roster
			actor.total = 0
			local damage_actor = currentCombat (DETAILS_ATTRIBUTE_DAMAGE, actor.name)
			if (damage_actor) then
				actor.breakpoint = damage_actor.targets [currentTarget] or 0
			end
		else
			--> this runs when we change our target
			for _, actor in ipairs (rosterTable) do
				actor.overall = actor.overall + actor.total
				actor.total = 0
				local damage_actor = currentCombat (DETAILS_ATTRIBUTE_DAMAGE, actor.name)
				if (damage_actor) then
					--> gets the current damage by this player done to our main target
					actor.breakpoint = damage_actor.targets [currentTarget] or 0
				end
			end
		end
	end
	
	function targetCaller.UpdateRoster()
		local unitType = IsInRaid() and "raid" or "party"
		
		--> update the hash table (this is in case if we need to get a single actor, so we do rosterTable [rosterHashTable [name]])
		for index, actor in ipairs (rosterTable) do
			rosterHashTable [actor.name] = index
		end
		
		--> update raid members
		for i = 1, GetNumGroupMembers() do
			local unit = "" .. unitType .. i
			local name = GetUnitName (unit, true)
			if (not rosterHashTable [name] and not UnitIsUnit (unit, "player")) then
				local actor = {}
				actor.name = name
				actor.displayName = targetCaller:GetOnlyName (name) or name or ""
				actor.class = select (2, UnitClass (unit)) or "PRIEST"
				actor.total = 0
				actor.overall = 0
				actor.breakpoint = 0
				
				tinsert (rosterTable, actor)
				
				rosterHashTable [name] = #rosterTable
				targetCaller.SetBreakPoints (actor)
			end
		end
	end
	
	--> start loop with basic stuff, reset roster, register needed events, start ticker.
	function targetCaller.StartLoop()
		--> clear the delay var
		targetCaller.StartDelay = nil
	
		--> start a new combat
		wipe (rosterTable)
		wipe (rosterHashTable)
		targetCaller.UpdateWindowBars()
		currentTarget = GetUnitName ("target", true)
		currentCombat = targetCaller:GetCurrentCombat()
		targetCaller:RegisterEvent ("GROUP_ROSTER_UPDATE")
		targetCaller:RegisterEvent ("PLAYER_TARGET_CHANGED")
		targetCaller.UpdateRoster()
		
		--targetCaller.ticker = C_Timer.NewTicker (0.2, targetCaller.LoopTicker)
		
		--use details! update speed
		targetCaller.ticker = C_Timer.NewTicker (Details.update_speed, targetCaller.LoopTicker)
	end
	
	--> target changed, time to save new breakpoints, also update the title on the instance
	function targetCaller.TargetChanged()
		currentTarget = GetUnitName ("target", true) or ""
		
		targetCaller.ClearBars()
		targetCaller.SetBreakPoints()
		
		if (currentTarget ~= "") then
			attachedInstance:SetTitleBarText (L ["STRING_PLUGIN_NAME"] .. ": " .. targetCaller:GetOnlyName (currentTarget))
		else
			attachedInstance:SetTitleBarText (L ["STRING_PLUGIN_NAME"] .. ": |cFFFFAA00" .. L["STRING_OVERALL"] .. "|r")
		end
	end
	
	--> we are using member method .icon to set the icon and the texcoord, so we need to pass a table with the texture and the coords
	--> here we have the texture, the coords table we just import from details
	local iconTable = {[[Interface\AddOns\Details\images\classes_small]]}
	
	function targetCaller.UpdateOverall()
		local top = 0
		for _, actor in ipairs (rosterTable) do
			if (actor.overall > top) then
				top = actor.overall
			end
		end
		
		table.sort (rosterTable, sort_by_overall)
		local classCoords = targetCaller.class_coords --> importing the coords table from Details!
		
		for i = 1, min (#rosterTable, #barsTable) do
			local bar, actor = barsTable [i], rosterTable [i]
			
			if (actor.overall >= 1) then
				bar.lefttext = actor.displayName
				bar.righttext = textformat (_, actor.overall)
				
				--> the framework handles color strings such as non-localized class names and HTML color names.
				--> for example bar.color = "HUNTER" or bar.color = "purple" works perfectly fine
				--bar.color = actor.class 
				bar.color = "silver"

				iconTable [2] = classCoords [actor.class] --> placing the class coords into index [2]
				bar.icon = iconTable
				
				local percent = actor.overall / top * 100
				bar.value = percent

				bar:Show()
			else
				bar:Hide()
			end
		end
	end
	
	function targetCaller.LoopTicker()
	
		--> when no target, show overall
		if (currentTarget == "") then
			return targetCaller.UpdateOverall()
		end
		
		--> update to our current target
		local top = 0
		for _, actor in ipairs (rosterTable) do
			targetCaller.UpdateTotal (actor)
			if (actor.total > top) then
				top = actor.total
			end
		end
		
		table.sort (rosterTable, sort_by_total)
		local classCoords = targetCaller.class_coords --> importing the coords table from Details!
		
		for i = 1, min (#rosterTable, #barsTable) do
			local bar, actor = barsTable [i], rosterTable [i]
			
			if (actor.total >= 1) then
				bar.lefttext = actor.displayName
				bar.righttext = textformat (_, actor.total)
				
				--> the framework handles color strings such as non-localized class names and HTML color names.
				--> for example bar.color = "HUNTER" or bar.color = "purple" works perfectly fine
				bar.color = actor.class 

				iconTable [2] = classCoords [actor.class] --> placing the class coords into index [2]
				bar.icon = iconTable
				
				--no need to create a new local
				--local percent = actor.total / top * 100
				bar.value = actor.total / top * 100

				bar:Show()
			else
				bar:Hide()
			end
		end
	end
	
	--> finish the ticker, unregister events, hide bars, wipe roster tables
	function targetCaller.EndLoop (isFromDataReset)
		if (targetCaller.ticker and not targetCaller.ticker._cancelled) then
			targetCaller.ticker:Cancel()
		end
		if (targetCaller.StartDelay and not targetCaller.StartDelay._cancelled) then
			targetCaller.StartDelay:Cancel()
		end
		
		targetCaller.ClearBars()

		--> update the overall counter
		if (currentTarget ~= "" and not isFromDataReset) then
			targetCaller.SetBreakPoints()
		end
		
		currentTarget = ""
		targetCaller:UnregisterEvent ("GROUP_ROSTER_UPDATE")
		targetCaller:UnregisterEvent ("PLAYER_TARGET_CHANGED")
		
		--> show the overall when the update is done
		if (not isFromDataReset) then
			targetCaller.UpdateOverall()
		else
			--> wipe all if details! got a wipe too
			wipe (rosterTable)
			wipe (rosterHashTable)
		end
	end
	
	--> if we start checking the damage on the target
	function targetCaller.CheckFor_CanStartRunning()
		if (targetCaller:IsInCombat() and targetCaller:InGroup()) then
			if (targetCaller.StartDelay) then
				return
			end
			--> delay startloop, sometimes we get a roster event update after the enter combat event
			local timer = C_Timer.NewTimer (5, targetCaller.StartLoop)
			targetCaller.StartDelay = timer
		end
	end
	
	--> when receiving an event from details, handle it here
	local handle_details_event = function (event, ...)
			
		if (event == "HIDE") then
			--> the user closed the window or selected other plugin / mode
		 	targetCaller.EndLoop()
			
		elseif (event == "SHOW") then
			--> the plugin beign shown on a window
			targetCaller:AttachToInstance()
			attachedInstance = targetCaller:GetPluginInstance()
			currentCombat = targetCaller:GetCurrentCombat()
			targetCaller.UpdateWindowBars()
			targetCaller.CheckFor_CanStartRunning()
			
		elseif (event == "COMBAT_PLAYER_ENTER") then
			--> details create a new segment
			currentCombat = targetCaller:GetCurrentCombat()
			targetCaller.CheckFor_CanStartRunning()
			
		elseif (event == "COMBAT_PLAYER_LEAVE") then
			--> details finished a segment
			targetCaller.EndLoop()
			
		elseif (event == "DETAILS_INSTANCE_ENDRESIZE" or event == "DETAILS_INSTANCE_SIZECHANGED") then
			--> size of the window has changed
			targetCaller.UpdateWindowBars()
			
		elseif (event == "DETAILS_INSTANCE_STARTSTRETCH" or event == "DETAILS_INSTANCE_ENDSTRETCH") then
			--> the window started to be stretched
			targetCaller.UpdateWindowBars()
			
		elseif (event == "DETAILS_OPTIONS_MODIFIED") then
			--> an option has changed at details options panel
			targetCaller.UpdateWindowBars()
			
		elseif (event == "PLUGIN_DISABLED") then
			--> plugin has been disabled at the details options panel
			targetCaller.EndLoop()
		
		elseif (event == "PLUGIN_ENABLED") then
			--> plugin has been enabled at the details options panel
			attachedInstance = targetCaller:GetPluginInstance()
			currentCombat = targetCaller:GetCurrentCombat()
			targetCaller.CheckFor_CanStartRunning()
		
		elseif (event == "GROUP_ONENTER") then
			--> the player is now in a group
			targetCaller.CheckFor_CanStartRunning()
			
		elseif (event == "GROUP_ONLEAVE") then
			--> the player left the group
			if (targetCaller.ticker and not targetCaller.ticker._cancelled) then
				targetCaller.EndLoop()
			end
		
		elseif (event == "DETAILS_DATA_SEGMENTREMOVED") then
			--> old segment got deleted by the segment limit
			if (targetCaller.ticker and not targetCaller.ticker._cancelled) then
				--> there is an update going on, we need to stop
				targetCaller.EndLoop (true)
			end
		
		elseif (event == "DETAILS_DATA_RESET") then
			--> combat data got wiped
			if (targetCaller.ticker and not targetCaller.ticker._cancelled) then
				--> there is an update going on, we need to stop
				targetCaller.EndLoop (true)
				
			end
			
		end
		
	end
	
	function targetCaller:OnEvent (_, event, ...)
	
		if (event == "GROUP_ROSTER_UPDATE") then
			targetCaller.UpdateRoster()
			
		elseif (event == "PLAYER_TARGET_CHANGED") then
			targetCaller.TargetChanged()
		
		elseif (event == "ADDON_LOADED") then
			local AddonName = select (1, ...)
			if (AddonName == "Details_TargetCaller") then
				
				--> every plugin must have a OnDetailsEvent function
				function targetCaller:OnDetailsEvent (event, ...)
					return handle_details_event (event, ...)
				end
				
				--> Install: install -> if successful installed; saveddata -> a table saved inside details db, used to save small amount of data like configs
				local install, saveddata = Details:InstallPlugin ("RAID", L ["STRING_PLUGIN_NAME"], "Interface\\Icons\\Ability_Warrior_BattleShout", targetCaller, "DETAILS_PLUGIN_TARGET_CALLER", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", TCALLER_VERSION)
				if (type (install) == "table" and install.error) then
					print (install.error)
				end
				
				--> registering details events we need
				Details:RegisterEvent (targetCaller, "COMBAT_PLAYER_ENTER") --when details creates a new segment, not necessary the player entering in combat.
				Details:RegisterEvent (targetCaller, "COMBAT_PLAYER_LEAVE") --when details finishs a segment, not necessary the player leaving the combat.
				Details:RegisterEvent (targetCaller, "DETAILS_INSTANCE_ENDRESIZE") --when the player releases the grab after resize.
				Details:RegisterEvent (targetCaller, "DETAILS_INSTANCE_SIZECHANGED") --when a details window got its size changed.
				Details:RegisterEvent (targetCaller, "DETAILS_INSTANCE_STARTSTRETCH") --when the player start to stretch a window.
				Details:RegisterEvent (targetCaller, "DETAILS_INSTANCE_ENDSTRETCH") --stretch ends
				Details:RegisterEvent (targetCaller, "DETAILS_OPTIONS_MODIFIED") --fired when any options at details options panel is changed by the user.
				Details:RegisterEvent (targetCaller, "GROUP_ONENTER") --when the player enters in a group
				Details:RegisterEvent (targetCaller, "GROUP_ONLEAVE") --player left a group endd
				Details:RegisterEvent (targetCaller, "DETAILS_DATA_RESET") --details combat data has been wiped
				
				
			end
		end

	end

end
