local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ("Details_AltPowerBar")

local _GetNumSubgroupMembers = GetNumSubgroupMembers --> wow api
local _GetNumGroupMembers = GetNumGroupMembers --> wow api
local _UnitIsFriend = UnitIsFriend --> wow api
local _UnitName = UnitName --> wow api
local _UnitDetailedThreatSituation = UnitDetailedThreatSituation
local _IsInRaid = IsInRaid --> wow api
local _IsInGroup = IsInGroup --> wow api
local _UnitGroupRolesAssigned = UnitGroupRolesAssigned --> wow api

local _ipairs = ipairs --> lua api
local _table_sort = table.sort --> lua api
local _cstr = string.format --> lua api
local _unpack = unpack

local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitClass = UnitClass

local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

--> Create the plugin Object
local RaidPowerBars = _detalhes:NewPluginObject ("Details_RaidPowerBars")
--> Main Frame
local RaidPowerBarsFrame = RaidPowerBars.Frame

RaidPowerBars:SetPluginDescription (Loc ["STRING_PLUGIN_DESC"])

RaidPowerBars.version_string = "46"
local TrackingDebuff = false

local function CreatePluginFrames (data)
	
	--> catch Details! main object
	if (not _detalhes) then
		return
	end
	local _detalhes = _G._detalhes
	local DetailsFrameWork = _detalhes.gump
	local _
	
	--> data
	RaidPowerBars.data = data or {}
	
	--> defaults
	RaidPowerBars.RowWidth = 294
	RaidPowerBars.RowHeight = 14
	--> amount of row wich can be displayed
	RaidPowerBars.CanShow = 0
	--> all rows already created
	RaidPowerBars.Rows = {}
	--> current shown rows
	RaidPowerBars.ShownRows = {}
	-->
	RaidPowerBars.Actived = false
	
	--> window reference
	local instance
	
	--> OnEvent Table
	function RaidPowerBars:OnDetailsEvent (event)
	
		if (event == "HIDE") then --> plugin hidded, disabled
			RaidPowerBarsFrame:SetScript ("OnUpdate", nil) 
			RaidPowerBars.Actived = false
			RaidPowerBars:Cancel()
		
		elseif (event == "SHOW") then
			instance = RaidPowerBars:GetInstance (RaidPowerBars.instance_id)
			
			RaidPowerBars.RowWidth = instance.baseframe:GetWidth()-6
			
			RaidPowerBars:UpdateContainers()
			RaidPowerBars:UpdateRows()
			
			RaidPowerBars:SizeChanged()
			
			RaidPowerBars.Actived = false

			if (RaidPowerBars:IsInCombat()) then
				RaidPowerBars.Actived = true
				RaidPowerBars:Start()
			end
			
		elseif (event == "REFRESH") then --> requested a refresh window
			-->

		elseif (event == "COMBAT_PLAYER_ENTER") then --> combat started
			RaidPowerBars.Actived = true
			RaidPowerBars:Start()

		elseif (event == "COMBAT_PLAYER_LEAVE") then --> combat ended
			RaidPowerBars:End()
			RaidPowerBars.Actived = false
			
		elseif (event == "DETAILS_INSTANCE_ENDRESIZE" or event == "DETAILS_INSTANCE_SIZECHANGED") then
			RaidPowerBars:SizeChanged()
			
		elseif (event == "DETAILS_INSTANCE_STARTSTRETCH") then
			RaidPowerBarsFrame:SetFrameStrata ("TOOLTIP")
			RaidPowerBarsFrame:SetFrameLevel (instance.baseframe:GetFrameLevel()+1)
			
		elseif (event == "DETAILS_INSTANCE_ENDSTRETCH") then
			RaidPowerBarsFrame:SetFrameStrata ("MEDIUM")
			
		elseif (event == "PLUGIN_DISABLED") then
			RaidPowerBars:HideBars()
			
		elseif (event == "PLUGIN_ENABLED") then
			
			
		elseif (event == "DETAILS_OPTIONS_MODIFIED") then
			RaidPowerBars:UpdateRows()
			
		end
	end
	
	RaidPowerBarsFrame:SetWidth (300)
	RaidPowerBarsFrame:SetHeight (100)
	
	function RaidPowerBars:UpdateContainers()
		for _, row in _ipairs (RaidPowerBars.Rows) do 
			row:SetContainer (instance.baseframe)
		end
	end
	
	function RaidPowerBars:UpdateRows()
		for _, row in _ipairs (RaidPowerBars.Rows) do
			row.width = RaidPowerBars.RowWidth
			
			local instance = RaidPowerBars:GetPluginInstance()
			
			row.textsize = instance.row_info.font_size
			
			local font = SharedMedia:Fetch ("font", instance.row_info.font_face, true) or instance.row_info.font_face
			
			row.textfont = font
			row.texture = instance.row_info.texture
			row.shadow = instance.row_info.textL_outline			
		end
	end
	
	function RaidPowerBars:HideBars()
		for _, row in _ipairs (RaidPowerBars.Rows) do 
			row:Hide()
		end
	end
	
	local target = nil
	local timer = 0
	local interval = 0.3
	
	function RaidPowerBars:SizeChanged()

		local w, h = instance:GetSize()
		RaidPowerBarsFrame:SetWidth (w)
		RaidPowerBarsFrame:SetHeight (h)
		
		RaidPowerBars.CanShow = math.floor ( h / (RaidPowerBars.RowHeight+1))

		for i = #RaidPowerBars.Rows+1, RaidPowerBars.CanShow do
			RaidPowerBars:NewRow (i)
		end

		RaidPowerBars.ShownRows = {}
		
		for i = 1, RaidPowerBars.CanShow do
			RaidPowerBars.ShownRows [#RaidPowerBars.ShownRows+1] = RaidPowerBars.Rows[i]
			if (_detalhes.in_combat) then
				RaidPowerBars.Rows[i]:Show()
			end
			RaidPowerBars.Rows[i].width = w-5
		end
		
		for i = #RaidPowerBars.ShownRows+1, #RaidPowerBars.Rows do
			RaidPowerBars.Rows [i]:Hide()
		end
		
	end
	
	function RaidPowerBars:NewRow (i)
		local newrow = DetailsFrameWork:NewBar (RaidPowerBarsFrame, nil, "DetailsAltPowerBarsRow"..i, nil, 300, 14)
		newrow:SetPoint (3, -((i-1)*15))
		newrow.lefttext = "player " .. i
		newrow.color = "skyblue"
		newrow.fontsize = 10
		newrow.fontface = "GameFontHighlightSmall"
		RaidPowerBars.Rows [#RaidPowerBars.Rows+1] = newrow
		newrow:Hide()
		newrow:SetHook ("OnEnter", function()
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine (Loc ["STRING_SETDEBUFF"])
			GameCooltip2:Show (newrow, "tooltip")
			
		end)
		newrow:SetHook ("OnLeave", function()
			GameCooltip2:Hide()
		end)
		newrow:SetHook ("OnMouseUp", function()
			GameCooltip2:Hide()
			if (not RaidPowerBars.OptionsPanel) then
				RaidPowerBars.OptionsPanel = CreateFrame ("frame", nil, RaidPowerBarsFrame)
				RaidPowerBars.OptionsPanel:SetFrameStrata ("tooltip")
				RaidPowerBars.OptionsPanel:SetAllPoints()
				RaidPowerBars.OptionsPanel:SetBackdrop (_detalhes.PluginDefaults and _detalhes.PluginDefaults.Backdrop or {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
				edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
				insets = {left = 1, right = 1, top = 1, bottom = 1}})
				RaidPowerBars.OptionsPanel:SetBackdropColor (0, 0, 0, 1)
				RaidPowerBars.OptionsPanel:SetBackdropBorderColor (0, 0, 0, 0)
				
				local set_debuff = function (_, _, debuff)
					if (not debuff or debuff == "") then
						TrackingDebuff = false
						RaidPowerBars.OptionsPanel:Hide()
						print (Loc ["STRING_TRACKING_DEFAULT"])
						return
					end
					TrackingDebuff = debuff
					RaidPowerBars.OptionsPanel:Hide()
					print ("now tracking: |cFFFF8800" .. debuff .. "|r.")
				end
				local clear_debuff = function()
					TrackingDebuff = false
					RaidPowerBars.OptionsPanel:Hide()
					print ("now tracking: |cFFFF8800 [Power Bars]|r.")
				end
				
				DetailsFrameWork:InstallTemplate ("button", "BUTTON_WHITE_BORDER_TEMPLATE", {
					backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
					backdropcolor = {.3, .3, .3, .5},
					backdropbordercolor = {1, 1, 1, .8},
					onentercolor = {.5, .5, .5, .6},
					onenterbordercolor = {1, 1, 1, 1},
				})

				local UsePowerBars = DetailsFrameWork:CreateButton (RaidPowerBars.OptionsPanel, clear_debuff, 160, 16, "track alternative power", nil, nil, nil, nil, nil, nil, DetailsFrameWork:GetTemplate ("button", "BUTTON_WHITE_BORDER_TEMPLATE"), DetailsFrameWork:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
				local DebuffNameLabel = DetailsFrameWork:CreateLabel (RaidPowerBars.OptionsPanel, "track this debuff:", DetailsFrameWork:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))--label
				local DebuffName = DetailsFrameWork:CreateTextEntry (RaidPowerBars.OptionsPanel, set_debuff, 160, 16, "editbox_preset_name", _, _, DetailsFrameWork:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))--texentry
				DebuffName.tooltip = "enter a debuff name and press enter"
				
				local RightClickToClose = DetailsFrameWork:CreateLabel (RaidPowerBars.OptionsPanel, "right click to close this panel", DetailsFrameWork:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))--label
				
				UsePowerBars:SetPoint ("center", 0, 30)
				DebuffNameLabel:SetPoint ("center", 0, 0)
				DebuffName:SetPoint ("center", 0, -16)
				RightClickToClose:SetPoint ("center", 0, -45)

				RaidPowerBars.OptionsPanel:SetScript ("OnMouseDown", function (self, button)
					if (button == "RightButton") then
						DebuffName:ClearFocus()
						RaidPowerBars.OptionsPanel:Hide()
					end
				end)
			end
			
			RaidPowerBars.OptionsPanel:Show()
		end)
		
		return newrow
	end
	
	local sort = function (table1, table2)
		if (table1[2] > table2[2]) then
			return true
		else
			return false
		end
	end

	local UpdatePowerBars = function()
		
		local power_bar_table = {}
		
		if (_IsInRaid()) then
		
			if (TrackingDebuff) then
				for i = 1, _GetNumGroupMembers(), 1 do
					local name, rank, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitDebuff ("raid"..i, TrackingDebuff, nil, "HARMFUL")
					if (name) then
						if (not count or count == 0) then
							count = 1
						end
						local _, class = UnitClass ("raid"..i)
						power_bar_table [#power_bar_table+1] = {_UnitName ("raid"..i), count, 100, class}
						if (i > 25) then
							break
						end
					else
						local _, class = UnitClass ("raid"..i)
						power_bar_table [#power_bar_table+1] = {_UnitName ("raid"..i), 0, 100, class}
						if (i > 25) then
							break
						end
					end
				end
			else
				for i = 1, _GetNumGroupMembers(), 1 do
					local power = UnitPower ("raid"..i, ALTERNATE_POWER_INDEX)
					local mpower = UnitPowerMax ("raid"..i, ALTERNATE_POWER_INDEX)
					local _, class = UnitClass ("raid"..i)
					power_bar_table [#power_bar_table+1] = {_UnitName ("raid"..i), power, mpower, class}
					if (i > 25) then
						break
					end
				end
			end
			
		elseif (_IsInGroup()) then
		
			if (TrackingDebuff) then
				for i = 1, _GetNumGroupMembers(), 1 do
					local name, rank, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitDebuff ("party"..i, TrackingDebuff, nil, "HARMFUL")
					if (name) then
						if (not count or count == 0) then
							count = 1
						end
						local _, class = UnitClass ("party"..i)
						power_bar_table [#power_bar_table+1] = {_UnitName ("party"..i), count, 100, class}
						if (i > 25) then
							break
						end
					else
						local _, class = UnitClass ("party"..i)
						power_bar_table [#power_bar_table+1] = {_UnitName ("party"..i), 0, 100, class}
						if (i > 25) then
							break
						end
					end
				end
				
				--need to add the player it self
				local name, rank, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitDebuff ("player", TrackingDebuff, nil, "HARMFUL")
				local _, class = UnitClass ("player")
				if (name) then
					if (not count or count == 0) then
						count = 1
					end
					power_bar_table [#power_bar_table+1] = {_UnitName ("player"), count, 100, class}
				else
					power_bar_table [#power_bar_table+1] = {_UnitName ("player"), 0, 100, class}
				end
			else
				for i = 1, _GetNumGroupMembers()-1, 1 do
					local power = UnitPower ("party"..i, ALTERNATE_POWER_INDEX)
					local mpower = UnitPowerMax ("party"..i, ALTERNATE_POWER_INDEX)
					local _, class = UnitClass ("party"..i)
					if (power and mpower) then
						power_bar_table [#power_bar_table+1] = {_UnitName ("party"..i), power, mpower, class}
					end
				end
				
				--need to add the player it self
				local power = UnitPower ("player", ALTERNATE_POWER_INDEX)
				local mpower = UnitPowerMax ("player", ALTERNATE_POWER_INDEX)
				local _, class = UnitClass ("player")
				if (power and mpower) then
					power_bar_table [#power_bar_table+1] = {_UnitName ("player"), power, mpower, class}
				end
			end
		end
		
		_table_sort (power_bar_table, sort)
		
		if (TrackingDebuff) then
			local maximum = 0
			for i = 1, #power_bar_table do
				if (power_bar_table [i] [2] > maximum) then
					maximum = power_bar_table [i] [2]
				end
			end
			for i = 1, #power_bar_table do
				power_bar_table [i] [3] = maximum
			end
		end
		
		for index = 1, #power_bar_table do
		
			local thisRow = RaidPowerBars.ShownRows [index]
			if (not thisRow) then
				break
			end
			
			local power_actor = power_bar_table [index]
			
			if (power_actor) then
				
				thisRow:SetLeftText (power_actor [1])
				if (power_actor [2]) then
					thisRow:SetRightText (power_actor [2] .. "/" .. power_actor [3])
				end
				
				local p = power_actor [2] / power_actor [3] * 100
				thisRow:SetValue (p)

				if (power_actor [4]) then
					thisRow:SetColor (_unpack (RaidPowerBars.class_colors [power_actor [4]]))
					thisRow._icon:SetTexture ([[Interface\AddOns\Details\images\classes_small]])
					thisRow._icon:SetTexCoord (_unpack (RaidPowerBars.class_coords [power_actor [4]]))
				else
					thisRow:SetColor (1, 1, 1, 1)
					thisRow._icon:SetTexture (nil)
				end
				
				if (not thisRow.statusbar:IsShown()) then
					thisRow:Show()
				end
			else
				thisRow:Hide()
			end
		end
		
	end
	
	local OnUpdate = function (self, elapsed)
		timer = timer + elapsed
		if (timer > interval) then
			timer = 0
			UpdatePowerBars()
		end
	end

	function RaidPowerBars:Start()
		RaidPowerBars:HideBars()
		if (RaidPowerBars.Actived) then
			if (_IsInRaid() or _IsInGroup()) then	
				RaidPowerBarsFrame:SetScript ("OnUpdate", OnUpdate)
			end
		end
	end
	
	function RaidPowerBars:End()
		RaidPowerBars:HideBars()
		RaidPowerBarsFrame:SetScript ("OnEvent", nil)
	end
	
	function RaidPowerBars:Cancel()
		RaidPowerBars:HideBars()
	end
	
end

function RaidPowerBars:OnEvent (_, event, ...)

	if (event == "ADDON_LOADED") then --this event is overloaded inside the plugin object creation in Details!
		local AddonName = select (1, ...)

		if (AddonName == "Details_RaidPowerBars") then
			
			if (_G._detalhes) then
				
				--> create widgets
				CreatePluginFrames (data)

				local MINIMAL_DETAILS_VERSION_REQUIRED = 76
				
				--> Install
				local install = _G._detalhes:InstallPlugin ("RAID", Loc ["STRING_PLUGIN_NAME"], "Interface\\Icons\\Spell_Paladin_Inquisition", RaidPowerBars, "DETAILS_PLUGIN_RAID_POWER_BARS", MINIMAL_DETAILS_VERSION_REQUIRED, "Details! Team", RaidPowerBars.version_string)
				if (type (install) == "table" and install.error) then
					print (install.error)
				end
				
				--> Register needed events
				_G._detalhes:RegisterEvent (RaidPowerBars, "COMBAT_PLAYER_ENTER")
				_G._detalhes:RegisterEvent (RaidPowerBars, "COMBAT_PLAYER_LEAVE")
				_G._detalhes:RegisterEvent (RaidPowerBars, "DETAILS_INSTANCE_ENDRESIZE")
				_G._detalhes:RegisterEvent (RaidPowerBars, "DETAILS_INSTANCE_SIZECHANGED")
				_G._detalhes:RegisterEvent (RaidPowerBars, "DETAILS_INSTANCE_STARTSTRETCH")
				_G._detalhes:RegisterEvent (RaidPowerBars, "DETAILS_INSTANCE_ENDSTRETCH")
				_G._detalhes:RegisterEvent (RaidPowerBars, "DETAILS_OPTIONS_MODIFIED")

			end
		end

	elseif (event == "PLAYER_LOGOUT") then
		_detalhes_databaseThreat = RaidPowerBars.data

	end
end
