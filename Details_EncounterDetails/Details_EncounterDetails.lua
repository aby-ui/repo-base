local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ("Details_EncounterDetails")
local Graphics = LibStub:GetLibrary("LibGraph-2.0")
local _ 

local isDebug = false
local function DebugMessage (...)
	if (isDebug) then
		print ("|cFFFFFF00EBreakDown|r:", ...)
	end
end

--> Needed locals
local _GetTime = GetTime --> wow api local
local _UFC = UnitAffectingCombat --> wow api local
local _IsInRaid = IsInRaid --> wow api local
local _IsInGroup = IsInGroup --> wow api local
local _UnitAura = UnitAura --> wow api local
local _GetSpellInfo = _detalhes.getspellinfo --> wow api local
local _CreateFrame = CreateFrame --> wow api local
local _GetTime = GetTime --> wow api local
local _GetCursorPosition = GetCursorPosition --> wow api local
local _GameTooltip = GameTooltip --> wow api local

local GameCooltip = GameCooltip2

local _math_floor = math.floor --> lua library local
local _cstr = string.format --> lua library local
local _ipairs = ipairs --> lua library local
local _pairs = pairs --> lua library local
local _table_sort = table.sort --> lua library local
local _table_insert = table.insert --> lua library local
local _unpack = unpack --> lua library local
local _bit_band = bit.band

local CONST_FONT_SIZE = 10

--> Create the plugin Object
local EncounterDetails = _detalhes:NewPluginObject ("Details_EncounterDetails", DETAILSPLUGIN_ALWAYSENABLED)
tinsert (UISpecialFrames, "Details_EncounterDetails")
--> Main Frame
local EncounterDetailsFrame = EncounterDetails.Frame
EncounterDetailsFrame.DefaultBarHeight = 20
EncounterDetailsFrame.CooltipStatusbarAlpha = .65
EncounterDetailsFrame.DefaultBarTexture = "Interface\\AddOns\\Details\\images\\bar_serenity"

EncounterDetails:SetPluginDescription ("Raid encounters summary, show basic stuff like dispels, interrupts and also graphic charts, boss emotes and the Weakaura Creation Tool.")

--> container types
local class_type_damage = _detalhes.atributos.dano --> damage
local class_type_misc = _detalhes.atributos.misc --> misc
--> main combat object
local _combat_object

local sort_by_name = function (t1, t2) return t1.nome < t2.nome end

local CLASS_ICON_TCOORDS = _G.CLASS_ICON_TCOORDS

EncounterDetails.name = "Encounter Breakdown"
EncounterDetails.debugmode = false

function EncounterDetails:FormatCooltipSettings()
	GameCooltip:SetType ("tooltip")
	GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\bar_serenity]])
	GameCooltip:SetOption ("StatusBarHeightMod", 0)
	GameCooltip:SetOption ("FixedWidth", 280)
	GameCooltip:SetOption ("TextSize", 11)
	GameCooltip:SetOption ("LeftBorderSize", -4)
	GameCooltip:SetOption ("RightBorderSize", 5)
	GameCooltip:SetOption ("ButtonsYMod", 0)
	GameCooltip:SetOption ("YSpacingMod", -1)
end

EncounterDetails.CooltipLineHeight = 18

local ability_type_table = {
	[0x1] = "|cFF00FF00"..Loc ["STRING_HEAL"].."|r", 
	[0x2] = "|cFF710000"..Loc ["STRING_LOWDPS"].."|r", 
	[0x4] = "|cFF057100"..Loc ["STRING_LOWHEAL"].."|r", 
	[0x8] = "|cFFd3acff"..Loc ["STRING_VOIDZONE"].."|r", 
	[0x10] = "|cFFbce3ff"..Loc ["STRING_DISPELL"].."|r", 
	[0x20] = "|cFFffdc72"..Loc ["STRING_INTERRUPT"].."|r", 
	[0x40] = "|cFFd9b77c"..Loc ["STRING_POSITIONING"].."|r", 
	[0x80] = "|cFFd7ff36"..Loc ["STRING_RUNAWAY"].."|r", 
	[0x100] = "|cFF9a7540"..Loc ["STRING_TANKSWITCH"] .."|r", 
	[0x200] = "|cFFff7800"..Loc ["STRING_MECHANIC"].."|r", 
	[0x400] = "|cFFbebebe"..Loc ["STRING_CROWDCONTROL"].."|r", 
	[0x800] = "|cFF6e4d13"..Loc ["STRING_TANKCOOLDOWN"].."|r", 
	[0x1000] = "|cFFffff00"..Loc ["STRING_KILLADD"].."|r", 
	[0x2000] = "|cFFff9999"..Loc ["STRING_SPREADOUT"].."|r", 
	[0x4000] = "|cFFffff99"..Loc ["STRING_STOPCAST"].."|r",
	[0x8000] = "|cFFffff99"..Loc ["STRING_FACING"].."|r",
	[0x10000] = "|cFFffff99"..Loc ["STRING_STACK"].."|r",
	
}

--> main object frame functions
local function CreatePluginFrames (data)
	
	--> catch Details! main object
	local _detalhes = _G._detalhes
	local DetailsFrameWork = _detalhes.gump

	--> saved data if any
	EncounterDetails.data = data or {}
	--> record if button is shown
	EncounterDetails.showing = false
	--> record if boss window is open or not
	EncounterDetails.window_open = false
	EncounterDetails.combat_boss_found = false
	
	--> OnEvent Table
	function EncounterDetails:OnDetailsEvent (event, ...)
	
		--> when main frame became hide
		if (event == "HIDE") then --> plugin hidded, disabled
			self.open = false
		
		--> when main frame is shown on screen
		elseif (event == "SHOW") then --> plugin hidded, disabled
			self.open = true
			EncounterDetails:RefreshScale()
		
		--> when details finish his startup and are ready to work
		elseif (event == "DETAILS_STARTED") then

			--> check if details are in combat, if not check if the last fight was a boss fight
			if (not EncounterDetails:IsInCombat()) then
				--> get the current combat table
				_combat_object = EncounterDetails:GetCombat()
				--> check if was a boss fight
				EncounterDetails:WasEncounter()
			end
			
			local damage_done_func = function (support_table, time_table, tick_second)
				local current_total_damage = _detalhes.tabela_vigente.totals_grupo[1]
				local current_damage = current_total_damage - support_table.last_damage
				time_table [tick_second] = current_damage
				if (current_damage > support_table.max_damage) then
					support_table.max_damage = current_damage
					time_table.max_damage = current_damage
				end
				support_table.last_damage = current_total_damage
			end
			
			local string_damage_done_func = [[
			
				-- this script takes the current combat and request the total of damage done by the group.
			
				-- first lets take the current combat and name it "current_combat".
				local current_combat = _detalhes:GetCombat ("current") --> getting the current combat
				
				-- now lets ask the combat for the total damage done by the raide group.
				local total_damage = current_combat:GetTotal ( DETAILS_ATTRIBUTE_DAMAGE, nil, DETAILS_TOTALS_ONLYGROUP )
			
				-- checks if the result is valid
				if (not total_damage) then
					return 0
				end
			
				-- with the  number in hands, lets finish the code returning the amount
				return total_damage
			]]
			
			--_detalhes:TimeDataRegister ("Raid Damage Done", damage_done_func, {last_damage = 0, max_damage = 0}, "Encounter Details", "v1.0", [[Interface\ICONS\Ability_DualWield]], true)
			_detalhes:TimeDataRegister ("Raid Damage Done", string_damage_done_func, nil, "Encounter Details", "v1.0", [[Interface\ICONS\Ability_DualWield]], true, true)

			if (EncounterDetails.db.show_icon == 4) then
				EncounterDetails:ShowIcon()
			elseif (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end
			
			--EncounterDetails:CreateCallbackListeners()
		
		elseif (event == "COMBAT_PLAYER_ENTER") then --> combat started
			if (EncounterDetails.showing and EncounterDetails.db.hide_on_combat) then
				--EncounterDetails:HideIcon()
				EncounterDetails:CloseWindow()
			end
			
			EncounterDetails.current_whisper_table = {}
		
		elseif (event == "COMBAT_PLAYER_LEAVE") then
			--> combat leave and enter always send current combat table
			_combat_object = select (1, ...)
			--> check if was a boss fight
			EncounterDetails:WasEncounter()
			if (EncounterDetails.combat_boss_found) then
				EncounterDetails.combat_boss_found = false
			end
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end

			local whisper_table = EncounterDetails.current_whisper_table
			if (whisper_table and _combat_object.is_boss and _combat_object.is_boss.name) then
				whisper_table.boss = _combat_object.is_boss.name
				tinsert (EncounterDetails.boss_emotes_table, 1, whisper_table)
				
				if (#EncounterDetails.boss_emotes_table > EncounterDetails.db.max_emote_segments) then
					table.remove (EncounterDetails.boss_emotes_table, EncounterDetails.db.max_emote_segments+1)
				end
			end
			
		elseif (event == "COMBAT_BOSS_FOUND") then
			EncounterDetails.combat_boss_found = true
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end

		elseif (event == "DETAILS_DATA_RESET") then
			if (_G.DetailsRaidDpsGraph) then
				_G.DetailsRaidDpsGraph:ResetData()
			end
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			end
			--EncounterDetails:HideIcon()
			EncounterDetails:CloseWindow()
			
			--drop last combat table
			EncounterDetails.LastSegmentShown = nil
			
			if (DetailsRaidDpsGraph) then
				DetailsRaidDpsGraph.combat = nil
			end
			
			--wipe emotes
			table.wipe (EncounterDetails.boss_emotes_table)
	
		elseif (event == "GROUP_ONENTER") then
			if (EncounterDetails.db.show_icon == 2) then
				EncounterDetails:ShowIcon()
			end
			
		elseif (event == "GROUP_ONLEAVE") then
			if (EncounterDetails.db.show_icon == 2) then
				EncounterDetails:HideIcon()
			end
			
		elseif (event == "ZONE_TYPE_CHANGED") then
			if (EncounterDetails.db.show_icon == 1) then
				if (select (1, ...) == "raid") then
					EncounterDetails:ShowIcon()
				else
					EncounterDetails:HideIcon()
				end
			end
		
		elseif (event == "PLUGIN_DISABLED") then
			EncounterDetails:HideIcon()
			EncounterDetails:CloseWindow()
			
		elseif (event == "PLUGIN_ENABLED") then
			if (EncounterDetails.db.show_icon == 5) then
				EncounterDetails:AutoShowIcon()
			elseif (EncounterDetails.db.show_icon == 4) then
				EncounterDetails:ShowIcon()
			end
		end
	end
	
	
	--desativado, agora ele � gerenciado dentro do proprio details!
	function EncounterDetails:CreateCallbackListeners()
	
		EncounterDetails.DBM_timers = {}
		
		local current_encounter = false
		
		local current_table_dbm = {}
		local current_table_bigwigs = {}
	
		local event_frame = CreateFrame ("frame", nil, UIParent)
		event_frame:SetScript ("OnEvent", function (self, event, ...)
			if (event == "ENCOUNTER_START") then
				local encounterID, encounterName, difficultyID, raidSize = select (1, ...)
				current_encounter = encounterID
				
			elseif (event == "ENCOUNTER_END" or event == "PLAYER_REGEN_ENABLED") then
				if (current_encounter) then
				
					if (_G.DBM) then
						local db = _detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"]
						for spell, timer_table in pairs (current_table_dbm) do
							if (not db.encounter_timers_dbm [timer_table[1]]) then
								timer_table.id = current_encounter
								db.encounter_timers_dbm [timer_table[1]] = timer_table
							end
						end
					end
					if (BigWigs) then
						local db = _detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"]
						for timer_id, timer_table in pairs (current_table_bigwigs) do
							if (not db.encounter_timers_bw [timer_id]) then
								timer_table.id = current_encounter
								db.encounter_timers_bw [timer_id] = timer_table
							end
						end
					end
					
				end	
				
				current_encounter = false
				wipe (current_table_dbm)
				wipe (current_table_bigwigs)
			end
		end)
		event_frame:RegisterEvent ("ENCOUNTER_START")
		event_frame:RegisterEvent ("ENCOUNTER_END")
		event_frame:RegisterEvent ("PLAYER_REGEN_ENABLED")
		
--DBM_TimerStart Timer183828cdcount	2 Death Brand CD (2) 42.5 Interface\Icons\warlock_summon_doomguard cdcount 183828 1 1438		
--DBM_TimerStart Timer183828cdcount	3 Death Brand CD (3) 42.5 Interface\Icons\warlock_summon_doomguard cdcount 183828 1 1438
		
		--EncounterDetails.DBM_timers
		if (_G.DBM) then
			local dbm_timer_callback = function (bar_type, id, msg, timer, icon, bartype, spellId, colorId, modid)
				--print (bar_type, id, msg, timer, icon, bartype, spellId, colorId, modid)
				local spell = tostring (spellId)
				if (spell and not current_table_dbm [spell]) then
					current_table_dbm [spell] = {spell, id, msg, timer, icon, bartype, spellId, colorId, modid}
				end
			end
			DBM:RegisterCallback ("DBM_TimerStart", dbm_timer_callback)
		end
		function EncounterDetails:RegisterBigWigsCallBack()
			if (BigWigsLoader) then
				function EncounterDetails:BigWigs_StartBar (event, module, spellid, bar_text, time, icon, ...)
					--print (event, module, spellid, bar_text, time, icon, ...)
					spellid = tostring (spellid)
					if (not current_table_bigwigs [spellid]) then
						current_table_bigwigs [spellid] = {(type (module) == "string" and module) or (module and module.moduleName) or "", spellid or "", bar_text or "", time or 0, icon or ""}
					end
				end
				if (BigWigsLoader.RegisterMessage) then
					BigWigsLoader.RegisterMessage (EncounterDetails, "BigWigs_StartBar")
				end
			end
		end
		EncounterDetails:ScheduleTimer ("RegisterBigWigsCallBack", 5)
	
--BigWigs_StartBar BigWigs_Bosses_Brackenspore mind_fungus Mind Fungus 51 Interface\Icons\inv_mushroom_10 true
--bigwigs startbar mind_fungus	

--BigWigs_StartBar BigWigs_Bosses_Brackenspore 159996 Infesting Spores (2) 58 Interface\Icons\Ability_Creature_Disease_01
--bigwigs startbar 160013
	
	end
	
	function EncounterDetails:WasEncounter()

		--> check if last combat was a boss encounter fight
		if (not EncounterDetails.debugmode) then
		
			if (not _combat_object.is_boss) then
				return
			elseif (_combat_object.is_boss.encounter == "pvp") then 
				return
			end
			
			if (_combat_object.instance_type ~= "raid") then
				return
			end
			
		end

		--> boss found, we need to show the icon
		EncounterDetails:ShowIcon()
	end
	
	--> show icon on toolbar
	
	local re_ShowIconBallonTutorial = function()
		EncounterDetails:ShowIconBallonTutorial()
	end
	
	function EncounterDetails:ShowIconBallonTutorial()
		if (InCombatLockdown()) then
			C_Timer.After (5, function()
				--print ("in combat")
				re_ShowIconBallonTutorial()
			end)
			return
		end
	
		local hook_AlertButtonCloseButton = function()
			--print ("done tutorial")
			EncounterDetails:SetTutorialCVar ("ENCOUNTER_DETAILS_BALLON_TUTORIAL1", true)
		end
		
		if (EncounterDetailsTutorialAlertButton1 or not EncounterDetails.ToolbarButton or not EncounterDetails.ToolbarButton:IsShown()) then
			--print (EncounterDetailsTutorialAlertButton1, not EncounterDetails.ToolbarButton, not EncounterDetails.ToolbarButton:IsShown())
			return
		end
		
		local alert = CreateFrame ("frame", "EncounterDetailsTutorialAlertButton1", EncounterDetails.ToolbarButton, "MicroButtonAlertTemplate")
		alert:SetFrameLevel (302)
		alert.label = "Click here (on the skull icon) to bring the Encounter Breakdown panel"
		alert.Text:SetSpacing (4)
		alert:SetClampedToScreen (true)
		MicroButtonAlert_SetText (alert, alert.label)
		alert:SetPoint ("bottom", EncounterDetails.ToolbarButton, "top", 0, 22)
		alert.CloseButton:HookScript ("OnClick", hook_AlertButtonCloseButton)
		alert:Show()
		
		--print ("showing ballon")
	end
	
	function EncounterDetails:ShowIcon()
		EncounterDetails.showing = true
		--> [1] button to show [2] button animation: "star", "blink" or true (blink)
		EncounterDetails:ShowToolbarIcon (EncounterDetails.ToolbarButton, "star")

		--EncounterDetails:SetTutorialCVar ("ENCOUNTER_DETAILS_BALLON_TUTORIAL1", false) --debug
		if (not EncounterDetails:GetTutorialCVar ("ENCOUNTER_DETAILS_BALLON_TUTORIAL1")) then
			--print ("nao viu o tutorial ainda")
			C_Timer.After (2, EncounterDetails.ShowIconBallonTutorial)
		end
		
	end
	
	-->  hide icon on toolbar
	function EncounterDetails:HideIcon()
		EncounterDetails.showing = false
		EncounterDetails:HideToolbarIcon (EncounterDetails.ToolbarButton)
	end
	
	local re_ShowTutorialAlert = function()
		EncounterDetails:ShowTutorial()
	end
	local hook_AlertCloseButton = function()
		re_ShowTutorialAlert()
	end
	
	function EncounterDetails:ShowTutorial()
	--EncounterDetails.db.AlertTutorialStep = 1
		if (not EncounterDetails.Frame:IsShown()) then
			return
		end
		
		local antTable = {
			Throttle = 0.050,
			AmountParts = 15,
			TexturePartsWidth = 167.4,
			TexturePartsHeight = 83.6,
			TextureWidth = 512,
			TextureHeight = 512,
			BlendMode = "ADD",
			Color = color,
			Texture = [[Interface\AddOns\Plater\images\ants_rectangle]],
		}
		
		local left, right, top, bottom = 0, 0, 4, -6
		local DF = DetailsFrameWork
		
		if (not Details:GetTutorialCVar ("ENCOUNTER_BREAKDOWN_CHART")) then
			local f = DF:CreateAnts (EncounterDetails.Frame.buttonSwitchGraphic.widget, antTable, -27 + (left or 0), 25 + (right or 0), 5 + (top or 0), -7 + (bottom or 0))
			f:SetFrameLevel (EncounterDetails.Frame:GetFrameLevel() + 1)
			f:SetAlpha (ALPHA_BLEND_AMOUNT - 0.549845)
			EncounterDetails.Frame.buttonSwitchGraphic.AntsFrame = f
		end
		
		if (not Details:GetTutorialCVar ("ENCOUNTER_BREAKDOWN_PHASES")) then
			local f = DF:CreateAnts (EncounterDetails.Frame.buttonSwitchPhases.widget, antTable, -27 + (left or 0), 25 + (right or 0), 5 + (top or 0), -7 + (bottom or 0))
			f:SetFrameLevel (EncounterDetails.Frame:GetFrameLevel() + 1)
			f:SetAlpha (ALPHA_BLEND_AMOUNT - 0.549845)
			EncounterDetails.Frame.buttonSwitchPhases.AntsFrame = f
		end
		
		if (not Details:GetTutorialCVar ("ENCOUNTER_BREAKDOWN_EMOTES")) then
			local f = DF:CreateAnts (EncounterDetails.Frame.buttonSwitchBossEmotes.widget, antTable, -27 + (left or 0), 25 + (right or 0), 5 + (top or 0), -7 + (bottom or 0))
			f:SetFrameLevel (EncounterDetails.Frame:GetFrameLevel() + 1)
			f:SetAlpha (ALPHA_BLEND_AMOUNT - 0.549845)
			EncounterDetails.Frame.buttonSwitchBossEmotes.AntsFrame = f
		end
		
		if (not Details:GetTutorialCVar ("ENCOUNTER_BREAKDOWN_SPELLAURAS")) then
			local f = DF:CreateAnts (EncounterDetails.Frame.buttonSwitchSpellsAuras.widget, antTable, -27 + (left or 0), 25 + (right or 0), 5 + (top or 0), -7 + (bottom or 0))
			f:SetFrameLevel (EncounterDetails.Frame:GetFrameLevel() + 1)
			f:SetAlpha (ALPHA_BLEND_AMOUNT - 0.549845)
			EncounterDetails.Frame.buttonSwitchSpellsAuras.AntsFrame = f
		end

	end
	
	EncounterDetailsFrame:HookScript ("OnShow", function()
		C_Timer.After (0.1, function()
			if (not EncounterDetails.LastOpenedTime or EncounterDetails.LastOpenedTime + 2 < GetTime()) then
				if (_detalhes.AddOnStartTime and _detalhes.AddOnStartTime + 30 < GetTime()) then
					EncounterDetails:OpenAndRefresh()
				end
			end
		end)
	end)
	
	--> user clicked on button, need open or close window
	function EncounterDetails:OpenWindow()
		
		if (EncounterDetails.Frame:IsShown()) then
			return EncounterDetails:CloseWindow()
		end
		
		--> build all window data
		EncounterDetails.db.opened = EncounterDetails.db.opened + 1
		EncounterDetails:OpenAndRefresh()
		--> show
		EncounterDetailsFrame:Show()
		EncounterDetails.open = true
		
		if (EncounterDetailsFrame.ShowType == "graph") then
			EncounterDetails:BuildDpsGraphic()
		end
		
		--select latest emote segment
		Details_EncounterDetailsEmotesSegmentDropdown.MyObject:Select (1)
		Details_EncounterDetailsEmotesSegmentDropdown.MyObject:Refresh()
		FauxScrollFrame_SetOffset (EncounterDetails_EmoteScroll, 0)
		EncounterDetails:SetEmoteSegment (1)
		EncounterDetails_EmoteScroll:Update()
		
		if (EncounterDetailsFrame.ShowType ~= "emotes") then
			--hide emote frames
			for _, widget in pairs (EncounterDetails.Frame.EmoteWidgets) do
				widget:Hide()
			end
		end

		C_Timer.After (3, function() EncounterDetails:ShowTutorial() end)

		DetailsPluginContainerWindow.OpenPlugin (EncounterDetails)
		
		return true
	end
	
	function EncounterDetails:CloseWindow()
		EncounterDetails.open = false
		EncounterDetailsFrame:Hide()
		return true
	end
	
	local cooltip_menu = function()
		
		local CoolTip = GameCooltip2
		
		CoolTip:Reset()
		CoolTip:SetType ("menu")
		
		CoolTip:SetOption ("TextSize", Details.font_sizes.menus)
		CoolTip:SetOption ("TextFont", Details.font_faces.menus)		
		
		CoolTip:SetOption ("ButtonHeightModSub", -2)
		CoolTip:SetOption ("ButtonHeightMod", -5)
		
		CoolTip:SetOption ("ButtonsYModSub", -3)
		CoolTip:SetOption ("ButtonsYMod", -6)
		
		CoolTip:SetOption ("YSpacingModSub", -3)
		CoolTip:SetOption ("YSpacingMod", 1)
		
		CoolTip:SetOption ("HeighMod", 3)
		CoolTip:SetOption ("SubFollowButton", true)
		
		Details:SetTooltipMinWidth()
		
		--build the header
		
--		CoolTip:AddLine (Loc ["STRING_PLUGIN_NAME"])
--		CoolTip:AddIcon (ENCOUNTERDETAILS_BUTTON.__icon, 1, 1, 20, 20)
--		CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "main")
		
--		GameCooltip:AddLine ("$div")
		
		--build the menu options
			
			--summary
			CoolTip:AddLine ("Encounter Summary")
			CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "main")
			CoolTip:AddIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 1, 1, 20, 22, 0, 0.1015625, 0, 0.505625)
		
			--chart
			CoolTip:AddLine ("Damage Graphic")
			CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "graph")
			CoolTip:AddIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 1, 1, 20, 22, 0.1271875, 0.21875, 0, 0.505625)
			
			--emotes
			CoolTip:AddLine ("Boss Emotes")
			CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "emotes")
			CoolTip:AddIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 1, 1, 20, 22, 91/256, 116/256, 0, 0.505625)
			
			--weakauras
			CoolTip:AddLine ("Create Encounter Weakauras")
			CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "spellsauras")
			
			if (_G.WeakAuras) then
				CoolTip:AddIcon ([[Interface\AddOns\WeakAuras\Media\Textures\icon]], 1, 1, 20, 20)
			else
				CoolTip:AddIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 1, 1, 20, 22, 121/256, 146/256, 0, 0.505625)
			end

			--phases
			CoolTip:AddLine ("Damage by Boss Phase")
			CoolTip:AddMenu (1, EncounterDetails.Frame.switch, "phases")
			CoolTip:AddIcon ("Interface\\AddOns\\Details_EncounterDetails\\images\\boss_frame_buttons", 1, 1, 20, 22, 151/256, 176/256, 0, 0.505625)
			
			--
			
			local textPoint = {"left", "left", 4, 0}
			
			local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
			
			--CoolTip:SetBannerImage (1, [[]], 200, 22, avatarPoint, avatarTexCoord, nil) --> overlay [2] avatar path
			--CoolTip:SetBannerText (1, Loc ["STRING_PLUGIN_NAME"], textPoint, {1, 1, 1}, 14, SharedMedia:Fetch ("font", _detalhes.tooltip.fontface)) --> text [1] nickname
		
		--apply the backdrop settings to the menu
		Details:FormatCooltipBackdrop()
		CoolTip:SetOwner (ENCOUNTERDETAILS_BUTTON, "bottom", "top", 0, 0)
		CoolTip:ShowCooltip()
		
	end
	
	EncounterDetails.ToolbarButton = _detalhes.ToolBar:NewPluginToolbarButton (EncounterDetails.OpenWindow, "Interface\\AddOns\\Details_EncounterDetails\\images\\icon", Loc ["STRING_PLUGIN_NAME"], Loc ["STRING_TOOLTIP"], 16, 16, "ENCOUNTERDETAILS_BUTTON", cooltip_menu) --"Interface\\COMMON\\help-i"
	EncounterDetails.ToolbarButton.shadow = true --> loads icon_shadow.tga when the instance is showing icons with shadows
	
	--> setpoint anchors mod if needed
	EncounterDetails.ToolbarButton.y = 0.5
	EncounterDetails.ToolbarButton.x = 0
	
	--> build all frames ans widgets
	_detalhes.EncounterDetailsTempWindow (EncounterDetails)
	_detalhes.EncounterDetailsTempWindow = nil
	
	--> ~remover ~autoabrir �brir ~abrir ~auto
	--C_Timer.After (.5, EncounterDetails.OpenWindow)
	
	
end

local sort_damage_from = function (a, b) 
	if (a[3] ~= "PET" and b[3] ~= "PET") then 
		return a[2] > b[2] 
	elseif (a[3] == "PET" and b[3] ~= "PET") then
		return false
	elseif (a[3] ~= "PET" and b[3] == "PET") then
		return true
	else
		return a[2] > b[2] 
	end
end

--> custom tooltip for dead details ---------------------------------------------------------------------------------------------------------
	
	--tooltip backdrop, color and border
	local bgColor, borderColor = {0.17, 0.17, 0.17, .9}, {.30, .30, .30, .3}
	
	local function KillInfo (deathTable, row)
	
		local iconSize = 19
		
		local eventos = deathTable [1]
		local hora_da_morte = deathTable [2]
		local hp_max = deathTable [5]
		
		local battleress = false
		local lastcooldown = false
		
		GameCooltip:Reset()
		GameCooltip:SetType ("tooltipbar")
		GameCooltip:SetOwner (row)
		
		GameCooltip:AddLine ("Click to Report", nil, 1, "orange")
		GameCooltip:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, 16, 0.015625, 0.13671875, 0.4375, 0.59765625)
		GameCooltip:AddStatusBar (0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, .5}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
		
		local statusBarBackground = {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]}
		
		--death parser
		for index, event in _ipairs (eventos) do 
		
			local hp = _math_floor (event[5]/hp_max*100)
			if (hp > 100) then 
				hp = 100
			end
			
			local evtype = event [1]
			local spellname, _, spellicon = _GetSpellInfo (event [2])
			local amount = event [3]
			local time = event [4]
			local source = event [6]

			if (type (evtype) == "boolean") then
				--> is damage or heal
				if (evtype) then
					--> damage
					
					local overkill = event [10] or 0
					if (overkill > 0) then
						amount = amount - overkill
						overkill = " (" .. _detalhes:ToK (overkill) .. " |cFFFF8800overkill|r)"
					else
						overkill = ""
					end
					
					if (source:find ("%[")) then
						source = source:gsub ("%[%*%] ", "")
					end
					
					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (" .. source .. ")", "-" .. _detalhes:ToK (amount) .. overkill .. " (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon, 1, 1, 16, 16, .1, .9, .1, .9)
					
					if (event [9]) then
						--> friendly fire
						GameCooltip:AddStatusBar (hp, 1, "darkorange", true, statusBarBackground)
					else
						--> from a enemy
						GameCooltip:AddStatusBar (hp, 1, "red", true, statusBarBackground)
					end
				else
					--> heal
					local class = Details:GetClass (source)
					local spec = Details:GetSpec (source)

					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (" .. Details:GetOnlyName (Details:AddClassOrSpecIcon (source, class, spec, 16, true)) .. ")", "+" .. _detalhes:ToK (amount) .. " (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon, 1, 1, 16, 16, .1, .9, .1, .9)
					GameCooltip:AddStatusBar (hp, 1, "green", true, statusBarBackground)
				end
				
			elseif (type (evtype) == "number") then
				if (evtype == 1) then
					--> cooldown
					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s " .. spellname .. " (" .. source .. ")", "cooldown (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon, 1, 1, 16, 16, .1, .9, .1, .9)
					GameCooltip:AddStatusBar (100, 1, "yellow", true, statusBarBackground)
					
				elseif (evtype == 2 and not battleress) then
					--> battle ress
					battleress = event
					
				elseif (evtype == 3) then
					--> last cooldown used
					lastcooldown = event
					
				elseif (evtype == 4) then
					--> debuff
					if (source:find ("%[")) then
						source = source:gsub ("%[%*%] ", "")
					end
					
					GameCooltip:AddLine ("" .. _cstr ("%.1f", time - hora_da_morte) .. "s [x" .. amount .. "] " .. spellname .. " (" .. source .. ")", "debuff (" .. hp .. "%)", 1, "white", "white")
					GameCooltip:AddIcon (spellicon, 1, 1, 16, 16, .1, .9, .1, .9)
					GameCooltip:AddStatusBar (100, 1, "purple", true, statusBarBackground)
					
				end
			end
		end

		GameCooltip:AddLine (deathTable [6] .. " " .. "died" , "-- -- -- ", 1, "white")
		GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\small_icons", 1, 1, iconSize, iconSize, .75, 1, 0, 1)
		GameCooltip:AddStatusBar (0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar4_vidro]]})
		
		if (battleress) then
			local nome_magia, _, icone_magia = _GetSpellInfo (battleress [2])
			GameCooltip:AddLine ("+" .. _cstr ("%.1f", battleress[4] - hora_da_morte) .. "s " .. nome_magia .. " (" .. battleress[6] .. ")", "", 1, "white")
			GameCooltip:AddIcon ("Interface\\Glues\\CharacterSelect\\Glues-AddOn-Icons", 1, 1, nil, nil, .75, 1, 0, 1)
			GameCooltip:AddStatusBar (0, 1, .5, .5, .5, .5, false, {value = 100, color = {.5, .5, .5, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar4_vidro]]})
		end
		
		if (lastcooldown) then
			if (lastcooldown[3] == 1) then 
				local nome_magia, _, icone_magia = _GetSpellInfo (lastcooldown [2])
				GameCooltip:AddLine (_cstr ("%.1f", lastcooldown[4] - hora_da_morte) .. "s " .. nome_magia .. " (" .. Loc ["STRING_LAST_COOLDOWN"] .. ")")
				GameCooltip:AddIcon (icone_magia)
			else
				GameCooltip:AddLine (Loc ["STRING_NOLAST_COOLDOWN"])
				GameCooltip:AddIcon ([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]], 1, 1, 18, 18)
			end
			GameCooltip:AddStatusBar (0, 1, 1, 1, 1, 1, false, {value = 100, color = {.3, .3, .3, 1}, specialSpark = false, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
		end

		--death log cooltip settings
		GameCooltip:SetOption ("StatusBarHeightMod", -6)
		GameCooltip:SetOption ("FixedWidth", 400)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("LeftBorderSize", -4)
		GameCooltip:SetOption ("RightBorderSize", 5)
		GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\bar_serenity]])
		GameCooltip:SetBackdrop (1, _detalhes.cooltip_preset2_backdrop, bgColor, borderColor)
		
		GameCooltip:SetOwner (row, "bottomright", "bottomleft", -2, -50)
		row.OverlayTexture:Show()
		GameCooltip:ShowCooltip()
	end

--> custom tooltip for dispells details ---------------------------------------------------------------------------------------------------------
local function DispellInfo (dispell, barra)
	
	local jogadores = dispell [1] --> [nome od jogador] = total
	local tabela_jogadores = {}
	
	for nome, tabela in _pairs (jogadores) do --> tabela = [1] total tomado [2] classe
		tabela_jogadores [#tabela_jogadores + 1] = {nome, tabela [1], tabela [2]}
	end
	
	_table_sort (tabela_jogadores, _detalhes.Sort2)
	
	for index, tabela in _ipairs (tabela_jogadores) do
		local coords = EncounterDetails.class_coords [tabela[3]]
		if (not coords) then
			GameCooltip:AddLine (EncounterDetails:GetOnlyName (tabela[1]), tabela[2], 1, "white", "orange")
			GameCooltip:AddIcon ("Interface\\GossipFrame\\DailyActiveQuestIcon")
		else
			GameCooltip:AddLine (EncounterDetails:GetOnlyName (tabela[1]), tabela[2], 1, "white", "orange")
			
			local specID = Details:GetSpec (tabela[1])
			if (specID) then
				local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
				GameCooltip:AddIcon (texture, 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, l, r, t, b)
			else
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, (coords[1]), (coords[2]), (coords[3]), (coords[4]))
			end
		end
	end
	
	local spellname = GetSpellInfo (barra.spellid)
	if (spellname) then
		GameTooltip:SetOwner (GameCooltipFrame1, "ANCHOR_NONE")
		GameTooltip:SetSpellByID (barra.spellid)
		GameTooltip:SetPoint ("topright", GameCooltipFrame1, "topleft", -2, 0)
		GameTooltip:Show()
	end
end

--> custom tooltip for kick details ---------------------------------------------------------------------------------------------------------

local function KickBy (magia, barra)

	local jogadores = magia [1] --> [nome od jogador] = total
	local tabela_jogadores = {}
	
	for nome, tabela in _pairs (jogadores) do --> tabela = [1] total tomado [2] classe
		tabela_jogadores [#tabela_jogadores + 1] = {nome, tabela [1], tabela [2]}
	end
	
	_table_sort (tabela_jogadores, _detalhes.Sort2)
	
	local spellName, _, spellIcon = GetSpellInfo (barra.texto_esquerdo:GetText())
	GameCooltip:AddLine (barra.texto_esquerdo:GetText())
	if (spellIcon) then
		GameCooltip:AddIcon (spellIcon, nil, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, 5/64, 59/64, 5/64, 59/64)
	end
	
	for index, tabela in _ipairs (tabela_jogadores) do
		local coords = EncounterDetails.class_coords [tabela[3]]
		GameCooltip:AddLine (EncounterDetails:GetOnlyName (tabela[1]), tabela[2], 1, "white")
		
		local specID = Details:GetSpec (tabela[1])
		if (specID) then
			local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
			GameCooltip:AddIcon (texture, 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, l, r, t, b)
		else
			GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, (coords[1]), (coords[2]), (coords[3]), (coords[4]))
		end
		
		GameCooltip:AddStatusBar (100, 1, .3, .3, .3, .3, false, false, false)
	end
	
	local spellname = GetSpellInfo (barra.spellid)
	if (spellname) then
		GameTooltip:SetOwner (GameCooltipFrame1, "ANCHOR_NONE")
		GameTooltip:SetSpellByID (barra.spellid)
		GameTooltip:SetPoint ("topright", GameCooltipFrame1, "topleft", -2, 0)
		GameTooltip:Show()
	end

end

--> custom tooltip for enemy abilities details ---------------------------------------------------------------------------------------------------------

local function EnemySkills (habilidade, barra)
	--> barra.jogador agora tem a tabela com --> [1] total dano causado [2] jogadores que foram alvos [3] jogadores que castaram essa magia [4] ID da magia
	
	local total = habilidade [1]
	local jogadores = habilidade [2] --> [nome od jogador] = total
	
	local tabela_jogadores = {}
	local total = 0
	
	for nome, tabela in _pairs (jogadores) do --> tabela = [1] total tomado [2] classe
		tabela_jogadores [#tabela_jogadores + 1] = {nome, tabela[1], tabela[2]}
		total = total + tabela[1]
	end
	
	_table_sort (tabela_jogadores, _detalhes.Sort2)
	
	GameCooltip:AddLine (barra.texto_esquerdo:GetText() .. " Damage Done")
	
	local ToK = _detalhes.ToKFunctions [_detalhes.ps_abbreviation]
	
	local topValue = tabela_jogadores [1] and tabela_jogadores [1][2]

	for index, tabela in _ipairs (tabela_jogadores) do
		local coords = EncounterDetails.class_coords [tabela[3]]
		
		GameCooltip:AddLine (EncounterDetails:GetOnlyName (tabela[1]), ToK (_, tabela[2]) .. " (" .. format ("%.1f", tabela[2] / total * 100) .. "%)", 1, "white")
		local r, g, b, a = unpack (_detalhes.tooltip.background)
		
		local actorClass = Details:GetClass (tabela[1])
		if (actorClass) then
			local r, g, b = Details:GetClassColor (actorClass)
			GameCooltip:AddStatusBar (tabela[2] / topValue * 100, 1, r, g, b, EncounterDetailsFrame.CooltipStatusbarAlpha, false, {value = 100, color = {.21, .21, .21, 0.5}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
		else
			GameCooltip:AddStatusBar (tabela[2] / topValue * 100, 1, r, g, b, a, false, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
		end		
		
		local specID = Details:GetSpec (tabela[1])
		if (specID) then
			local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
			GameCooltip:AddIcon (texture, 1, 1, EncounterDetails.CooltipLineHeight - 0, EncounterDetails.CooltipLineHeight - 0, l, r, t, b)
		else
			if (coords) then
				GameCooltip:AddIcon ("Interface\\AddOns\\Details\\images\\classes_small", nil, 1, EncounterDetails.CooltipLineHeight-2, EncounterDetails.CooltipLineHeight-2, (coords[1]), (coords[2]), (coords[3]), (coords[4]))
			end
		end
	end
	
	local spellname = GetSpellInfo (barra.spellid)
	if (spellname) then
		GameTooltip:SetOwner (GameCooltipFrame1, "ANCHOR_NONE")
		GameTooltip:SetSpellByID (barra.spellid)
		GameTooltip:SetPoint ("right", barra, "left", -2, 0)
		GameTooltip:Show()
	end
	
	GameCooltip:SetOwner (barra, "left", "right", 2, 0)
end

--> custom tooltip for damage taken details ---------------------------------------------------------------------------------------------------------

local function DamageTakenDetails (jogador, barra)

	local agressores = jogador.damage_from
	local damage_taken = jogador.damage_taken
	
	local showing = _combat_object [class_type_damage] --> o que esta sendo mostrado -> [1] - dano [2] - cura --> pega o container com ._NameIndexTable ._ActorTable
	
	local meus_agressores = {}
	
	for nome, _ in _pairs (agressores) do --> agressores seria a lista de nomes
		local este_agressor = showing._ActorTable[showing._NameIndexTable[nome]]
		if (este_agressor) then --> checagem por causa do total e do garbage collector que n�o limpa os nomes que deram dano
			local habilidades = este_agressor.spells._ActorTable
			for id, habilidade in _pairs (habilidades) do 
				local alvos = habilidade.targets
				for target_name, amount in _pairs (alvos) do 
					if (target_name == jogador.nome) then
						meus_agressores [#meus_agressores+1] = {id, amount, este_agressor.nome}
					end
				end
			end
		end
	end

	_table_sort (meus_agressores, _detalhes.Sort2)
	
	GameCooltip:AddLine (barra.texto_esquerdo:GetText() .. " Damage Taken")

	local max = #meus_agressores
	if (max > 20) then
		max = 20
	end

	local teve_melee = false
	
	local ToK = _detalhes.ToKFunctions [_detalhes.ps_abbreviation]
	local topDamage = meus_agressores[1] and meus_agressores[1][2]
	
	for i = 1, max do
		local nome_magia, _, icone_magia = _GetSpellInfo (meus_agressores[i][1])
		
		if (meus_agressores[i][1] == 1) then 
			nome_magia = "*"..meus_agressores[i][3]
			teve_melee = true
		end
		
		GameCooltip:AddLine (nome_magia, ToK (_, meus_agressores[i][2]) .. " (".._cstr("%.1f", (meus_agressores[i][2]/damage_taken) * 100).."%)", 1, "white")
		GameCooltip:AddStatusBar (meus_agressores[i][2] / topDamage * 100, 1, .55, .55, .55, .834, false, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
		
		GameCooltip:AddIcon (icone_magia, nil, 1, EncounterDetails.CooltipLineHeight - 0, EncounterDetails.CooltipLineHeight - 0, .1, .9, .1, .9)
	end
	
	if (teve_melee) then
		GameTooltip:AddLine ("* "..Loc ["STRING_MELEE_DAMAGE"], 0, 1, 0)
	end
	
	GameCooltip:SetOwner (barra, "left", "right", 2, 0)
end

--> custom tooltip clicks on any bar ---------------------------------------------------------------------------------------------------------
function _detalhes:BossInfoRowClick (barra, param1)
	
	if (type (self) == "table") then
		barra, param1 = self, barra
	end
	
	if (type (param1) == "table") then
		barra = param1
	end
	
	if (barra._no_report) then
		return
	end

	local reportar
	
	if (barra.TTT == "morte" or true) then --> deaths -- todos os boxes est�o usando cooltip, por isso o 'true'.
		
		reportar = {barra.report_text .. " " .. (barra.texto_esquerdo and barra.texto_esquerdo:GetText() or barra:GetParent() and barra:GetParent().texto_esquerdo and barra:GetParent().texto_esquerdo:GetText() or "")}
		local beginAt = 1
		if (barra.TTT == "damage_taken" or barra.TTT == "habilidades_inimigas" or barra.TTT == "total_interrupt" or barra.TTT == "add") then
			beginAt = 2
		end
		--"habilidades_inimigas"
		for i = beginAt, GameCooltip:GetNumLines(), 1 do 
			local texto_left, texto_right = GameCooltip:GetText (i)

			if (texto_left and texto_right) then 
				texto_left = texto_left:gsub (("|T(.*)|t "), "")
				reportar [#reportar+1] = ""..texto_left.." "..texto_right..""
			end
		end
	else
		
		barra.report_text = barra.report_text or ""
		reportar = {barra.report_text .. " " .. _G.GameTooltipTextLeft1:GetText()}
		local numLines = _GameTooltip:NumLines()
		
		for i = 1, numLines, 1 do 
			local nome_left = "GameTooltipTextLeft"..i
			local texto_left = _G[nome_left]
			texto_left = texto_left:GetText()
			
			local nome_right = "GameTooltipTextRight"..i
			local texto_right = _G[nome_right]
			texto_right = texto_right:GetText()
			
			if (texto_left and texto_right) then 
				texto_left = texto_left:gsub (("|T(.*)|t "), "")
				reportar [#reportar+1] = ""..texto_left.." "..texto_right..""
			end
		end		
	end

	return _detalhes:Reportar (reportar, {_no_current = true, _no_inverse = true, _custom = true})
	
end

--> custom tooltip that handle mouse enter and leave on customized rows ---------------------------------------------------------------------------------------------------------

local backdrop_bar_onenter = {bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 8, insets = {left = 1, right = 1, top = 0, bottom = 1}}
local backdrop_bar_onleave = {bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}}

function EncounterDetails:SetRowScripts (barra, index, container)

	barra:SetScript ("OnMouseDown", function (self)
		if (self.fading_in) then
			return
		end
	
		self.mouse_down = _GetTime()
		local x, y = _GetCursorPosition()
		self.x = _math_floor (x)
		self.y = _math_floor (y)

		--EncounterDetailsFrame:StartMoving()
		EncounterDetailsFrame.isMoving = true
		
	end)
	
	barra:SetScript ("OnMouseUp", function (self)

		if (self.fading_in) then
			return
		end
	
		if (EncounterDetailsFrame.isMoving) then
			--EncounterDetailsFrame:GetParent():StopMovingOrSizing()
			EncounterDetailsFrame.isMoving = false
			--instancia:SaveMainWindowPosition() --> precisa fazer algo pra salvar o trem
		end
	
		local x, y = _GetCursorPosition()
		x = _math_floor (x)
		y = _math_floor (y)
		
		if ((self.mouse_down+0.4 > _GetTime() and (x == self.x and y == self.y)) or (x == self.x and y == self.y)) then
			_detalhes:BossInfoRowClick (self)
		end
	end)
	
	barra:SetScript ("OnEnter", --> MOUSE OVER
		function (self) 
			--> aqui 1
			if (container.fading_in or container.faded) then
				return
			end
		
			self.mouse_over = true
			self:SetHeight (EncounterDetails.Frame.DefaultBarHeight + 1)
			self:SetAlpha (1)
			EncounterDetails.SetBarBackdrop_OnEnter (self)
			
			--GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
			GameCooltip:Preset (2)
			GameCooltip:SetOwner (self)
			EncounterDetails:FormatCooltipSettings()
			
			if (not self.TTT) then --> tool tip type
				return
			end
			
			if (self.TTT == "damage_taken") then --> damage taken
				DamageTakenDetails (self.jogador, barra)
			
			elseif (self.TTT == "habilidades_inimigas") then --> enemy abilytes
				self.spellid = self.jogador [4]
				EnemySkills (self.jogador, self)
				
			elseif (self.TTT == "total_interrupt") then
				self.spellid = self.jogador [3]
				KickBy (self.jogador, self)
				
			elseif (self.TTT == "dispell") then
				self.spellid = self.jogador [3]
				DispellInfo (self.jogador, self)
				
			elseif (self.TTT == "morte") then --> deaths
				KillInfo (self.jogador, self) --> aqui 2
			end
			
			GameCooltip:Show()
		end)
	
	barra:SetScript ("OnLeave", --> MOUSE OUT
		function (self) 
		
			self:SetScript ("OnUpdate", nil)
		
			if (self.fading_in or self.faded or not self:IsShown() or self.hidden) then
				return
			end
			
			self:SetHeight (EncounterDetails.Frame.DefaultBarHeight)
			self:SetAlpha (0.9)

			EncounterDetails.SetBarBackdrop_OnLeave (self)
			
			GameTooltip:Hide()
			GameCooltip:Hide()
			
			if (self.OverlayTexture) then
				self.OverlayTexture:Hide()
			end
		end)
end

--> Here start the data mine ---------------------------------------------------------------------------------------------------------
function EncounterDetails:OpenAndRefresh (_, segment)
	
	local frame = EncounterDetailsFrame --alias

	DebugMessage ("OpenAndRefresh() called")
	_G [frame:GetName().."SegmentsDropdown"].MyObject:Refresh()
	
	EncounterDetails.LastOpenedTime = GetTime()
	
	_G [frame:GetName().."SegmentsDropdown"].MyObject:Refresh()
	
	if (segment) then
		_combat_object = EncounterDetails:GetCombat (segment)
		EncounterDetails._segment = segment
		
		DebugMessage ("there's a segment to use:", segment, _combat_object, _combat_object and _combat_object.is_boss)
		
	else
		DebugMessage ("no segment has been passed, looping segments to find one.")
	
		local historico = _detalhes.tabela_historico.tabelas
		local foundABoss = false
		
		for index, combate in ipairs (historico) do 
			if (combate.is_boss and combate.is_boss.index) then
				EncounterDetails._segment = index
				_combat_object = combate
				
				DebugMessage ("segment found: ", index, combate:GetCombatName(), combate.is_trash)
				--the first segment found here will be the first segment the dropdown found, so it can use the index 1 of the dropdown list
				_G [frame:GetName().."SegmentsDropdown"].MyObject:Select (1, true)
				
				foundABoss = index
				break
			end
		end
		
		if (not foundABoss) then
			DebugMessage ("boss not found during the segment loop")
		end
	end
	
	if (not _combat_object) then
		--EncounterDetails:Msg ("no combat found.")
		DebugMessage ("_combat_object is nil, EXIT")
		return
	end
	
	local boss_id
	local map_id
	local boss_info
	
	local ToK = _detalhes.ToKFunctions [_detalhes.ps_abbreviation]
	
	if (EncounterDetails.debugmode and not _combat_object.is_boss) then
		_combat_object.is_boss = {
			index = 1, 
			name = "Immerseus",
			zone = "Siege of Orggrimar", 
			mapid = 1136, 
			encounter = "Immerseus"
		}
	end
	
	if (not _combat_object.is_boss) then
	
		DebugMessage ("_combat_object is not a boss, trying another loop in the segments")
		
		local foundSegment
		for index, combat in _ipairs (EncounterDetails:GetCombatSegments()) do 
			
			if (combat.is_boss and EncounterDetails:GetBossDetails (combat.is_boss.mapid, combat.is_boss.index)) then
				_combat_object = combat
				
				--the first segment found here will be the first segment the dropdown found, so it can use the index 1 of the dropdown list
				_G [frame:GetName().."SegmentsDropdown"].MyObject:Select (1, true)
				
				DebugMessage ("found another segment during another loop", index, combat:GetCombatName(), combat.is_trash)
				foundSegment = true
				break
			end
		end
		
		if (not foundSegment) then
			DebugMessage ("boss not found during the second loop segment")
		end
		
		if (not _combat_object.is_boss) then
			DebugMessage ("_combat_object still isn't a boss segment, trying to get the last segment shown.")
			if (EncounterDetails.LastSegmentShown) then
				_combat_object = EncounterDetails.LastSegmentShown
				DebugMessage ("found the last segment shown, using it.")
			else
				DebugMessage ("the segment isn't a boss, EXIT.")
				return
			end
		end
	end
	
	--> the segment is a boss
	
	DebugMessage ("segment are OKAY, updating the panel")
	
	boss_id = _combat_object.is_boss.index
	map_id = _combat_object.is_boss.mapid
	boss_info = _detalhes:GetBossDetails (_combat_object.is_boss.mapid, _combat_object.is_boss.index)
	
	if (EncounterDetailsFrame.ShowType == "phases") then
		EncounterDetailsPhaseFrame.OnSelectPhase (1)
	
	elseif (EncounterDetailsFrame.ShowType == "graph") then
		EncounterDetails:BuildDpsGraphic()
		
	elseif (EncounterDetailsFrame.ShowType == "spellsauras") then
		--refresh spells and auras
		local actor = EncounterDetails.build_actor_menu() [1]
		actor = actor and actor.value
		if (actor) then
			_G [EncounterDetailsFrame:GetName() .. "EnemyActorSpellsDropdown"].MyObject:Select (actor)
			EncounterDetails.update_enemy_spells (actor)
		end
		EncounterDetails.update_enemy_spells()
	end

	EncounterDetails.LastSegmentShown = _combat_object
	
-------------- set boss name and zone name --------------
	EncounterDetailsFrame.boss_name:SetText (_combat_object.is_boss.encounter)
	EncounterDetailsFrame.raid_name:SetText (_combat_object.is_boss.zone)

-------------- set portrait and background image --------------	

	local mapID = _combat_object.is_boss.mapid
	local L, R, T, B, Texture = EncounterDetails:GetBossIcon (mapID, _combat_object.is_boss.index)
	
	if (L) then
		EncounterDetailsFrame.boss_icone:SetTexture (Texture)
		EncounterDetailsFrame.boss_icone:SetTexCoord (L, R, T, B)
	else
		EncounterDetailsFrame.boss_icone:SetTexture ([[Interface\CHARACTERFRAME\TempPortrait]])
		EncounterDetailsFrame.boss_icone:SetTexCoord (0, 1, 0, 1)
	end
	
	--[=[
	local file, L, R, T, B = EncounterDetails:GetRaidBackground (_combat_object.is_boss.mapid)
	if (file) then
		EncounterDetailsFrame.raidbackground:SetTexture (file)
		EncounterDetailsFrame.raidbackground:SetTexCoord (L, R, T, B)
	else
		EncounterDetailsFrame.raidbackground:SetTexture ([[Interface\Glues\LOADINGSCREENS\LoadScreenDungeon]])
		EncounterDetailsFrame.raidbackground:SetTexCoord (0, 1, 120/512, 408/512)
	end
	--]=]
	
	EncounterDetailsFrame.raidbackground:SetTexture (.3, .3, .3, .5)
	
-------------- set totals on down frame --------------
--[[ data mine:
	_combat_object ["totals_grupo"] hold the total [1] damage // [2] heal // [3] [energy_name] energies // [4] [misc_name] miscs --]]

	--> Container Overall Damage Taken ~damagetaken ~damage taken
		--[[ data mine:
			combat tables have 4 containers [1] damage [2] heal [3] energy [4] misc each container have 2 tables: ._NameIndexTable and ._ActorTable --]]
		local DamageContainer = _combat_object [class_type_damage]
		
		local damage_taken = _detalhes.atributo_damage:RefreshWindow ({}, _combat_object, _, { key = "damage_taken", modo = _detalhes.modos.group })
		
		local container = frame.overall_damagetaken.gump
		
		local quantidade = 0
		local dano_do_primeiro = 0
		
		for index, jogador in _ipairs (DamageContainer._ActorTable) do
			--> ta em ordem de quem tomou mais dano.
			
			if (not jogador.grupo) then --> s� aparecer nego da raid
				break
			end
			
			if (jogador.classe and jogador.classe ~= "UNGROUPPLAYER" and jogador.classe ~= "UNKNOW") then
				local barra = container.barras [index]
				if (not barra) then
					barra = EncounterDetails:CreateRow (index, container, 1, 0, -1)
					_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
					_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
					barra.TTT = "damage_taken" -- tool tip type --> damage taken
					barra.report_text = Loc ["STRING_PLUGIN_NAME"].."! "..Loc ["STRING_DAMAGE_TAKEN_REPORT"] 
				end

				if (jogador.nome:find ("-")) then
					barra.texto_esquerdo:SetText (jogador.nome:gsub (("-.*"), ""))
				else
					barra.texto_esquerdo:SetText (jogador.nome)
				end
				
				barra.texto_direita:SetText (ToK (_, jogador.damage_taken))
				
				_detalhes:name_space (barra)
				
				barra.jogador = jogador
				
				barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [jogador.classe]))
				
				if (index == 1)  then
					barra.textura:SetValue (100)
					dano_do_primeiro = jogador.damage_taken
				else
					barra.textura:SetValue (jogador.damage_taken/dano_do_primeiro *100)
				end
				
				local specID = Details:GetSpec (jogador.nome)
				if (specID) then
					local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
					barra.icone:SetTexture (texture)
					barra.icone:SetTexCoord (l, r, t, b)
				else
					barra.icone:SetTexture ("Interface\\AddOns\\Details\\images\\classes_small")
					if (EncounterDetails.class_coords [jogador.classe]) then
						barra.icone:SetTexCoord (_unpack (EncounterDetails.class_coords [jogador.classe]))
					end
				end

				barra:Show()
				quantidade = quantidade + 1
			end
		end
		
		EncounterDetails:JB_AtualizaContainer (container, quantidade)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
			
				if (barra) then
					barra:Hide()
				end
			end
		end
		
	--> Fim do container Overall Damage Taken
	
	--> Container Overall Habilidades Inimigas ~damage taken by spell
		local habilidades_poll = {}
		
		--> pega as magias cont�nuas presentes em todas as fases
		--deprecated
		if (boss_info and boss_info.continuo) then
			for index, spellid in _ipairs (boss_info.continuo) do 
				habilidades_poll [spellid] = true
			end
		end

		--> pega as habilidades que pertence especificamente a cada fase
		--deprecated
		if (boss_info and boss_info.phases) then
			for fase_id, fase in _ipairs (boss_info.phases) do 
				if (fase.spells) then
					for index, spellid in _ipairs (fase.spells) do 
						habilidades_poll [spellid] = true
					end
				end
			end
		end
		
		local habilidades_usadas = {}
		local have_pool = false
		for spellid, _ in _pairs (habilidades_poll) do 
			have_pool = true
			break
		end
		
		for index, jogador in _ipairs (DamageContainer._ActorTable) do
		
			--> get all spells from neutral and hostile npcs
			if (	
				_bit_band (jogador.flag_original, 0x00000060) ~= 0 and --is neutral or hostile
				(not jogador.owner or (_bit_band (jogador.owner.flag_original, 0x00000060) ~= 0 and not jogador.owner.grupo and _bit_band (jogador.owner.flag_original, 0x00000400) == 0)) and --isn't a pet or the owner isn't a player
				not jogador.grupo and
				_bit_band (jogador.flag_original, 0x00000400) == 0
			) then
		
				local habilidades = jogador.spells._ActorTable
				
				for id, habilidade in _pairs (habilidades) do
					--if (habilidades_poll [id]) then
						--> esse jogador usou uma habilidade do boss
						local esta_habilidade = habilidades_usadas [id] --> tabela n�o numerica, pq diferentes monstros podem castar a mesma magia
						if (not esta_habilidade) then 
							esta_habilidade = {0, {}, {}, id} --> [1] total dano causado [2] jogadores que foram alvos [3] jogadores que castaram essa magia [4] ID da magia
							habilidades_usadas [id] = esta_habilidade
						end
						
						--> adiciona ao [1] total de dano que esta habilidade causou
						esta_habilidade[1] = esta_habilidade[1] + habilidade.total
						
						--> adiciona ao [3] total do jogador que castou
						if (not esta_habilidade[3][jogador.nome]) then
							esta_habilidade[3][jogador.nome] = 0
						end
						
						esta_habilidade[3][jogador.nome] = esta_habilidade[3][jogador.nome] + habilidade.total
						
						--> pega os alvos e adiciona ao [2]
						local alvos = habilidade.targets
						for target_name, amount in _pairs (alvos) do 
						
							--> ele tem o nome do jogador, vamos ver se este alvo � realmente um jogador verificando na tabela do combate
							local tabela_dano_do_jogador = DamageContainer._ActorTable [DamageContainer._NameIndexTable [target_name]]
							if (tabela_dano_do_jogador and tabela_dano_do_jogador.grupo) then
								if (not esta_habilidade[2] [target_name]) then 
									esta_habilidade[2] [target_name] = {0, tabela_dano_do_jogador.classe}
								end
								esta_habilidade[2] [target_name] [1] = esta_habilidade[2] [target_name] [1] + amount
							end
						end
					--end
				end
			
			elseif (have_pool) then
				--> check if the spell id is in the spell poll.
				local habilidades = jogador.spells._ActorTable
				
				for id, habilidade in _pairs (habilidades) do
					if (habilidades_poll [id]) then
						--> esse jogador usou uma habilidade do boss
						local esta_habilidade = habilidades_usadas [id] --> tabela n�o numerica, pq diferentes monstros podem castar a mesma magia
						if (not esta_habilidade) then 
							esta_habilidade = {0, {}, {}, id} --> [1] total dano causado [2] jogadores que foram alvos [3] jogadores que castaram essa magia [4] ID da magia
							habilidades_usadas [id] = esta_habilidade
						end
						
						--> adiciona ao [1] total de dano que esta habilidade causou
						esta_habilidade[1] = esta_habilidade[1] + habilidade.total
						
						 --> adiciona ao [3] total do jogador que castou
						if (not esta_habilidade[3][jogador.nome]) then
							esta_habilidade[3][jogador.nome] = 0
						end
						
						esta_habilidade[3][jogador.nome] = esta_habilidade[3][jogador.nome] + habilidade.total
						
						--> pega os alvos e adiciona ao [2]
						local alvos = habilidade.targets
						for target_name, amount in _pairs (alvos) do 
						
							--> ele tem o nome do jogador, vamos ver se este alvo � realmente um jogador verificando na tabela do combate
							local tabela_dano_do_jogador = DamageContainer._ActorTable [DamageContainer._NameIndexTable [target_name]]
							if (tabela_dano_do_jogador and tabela_dano_do_jogador.grupo) then
								if (not esta_habilidade[2] [target_name]) then 
									esta_habilidade[2] [target_name] = {0, tabela_dano_do_jogador.classe}
								end
								esta_habilidade[2] [target_name] [1] = esta_habilidade[2] [target_name] [1] + amount
							end
						end
					end
				end
			end
		end
		
		--> por em ordem
		local tabela_em_ordem = {}
		local jaFoi = {}
		
		for id, tabela in _pairs (habilidades_usadas) do 
			local spellname = GetSpellInfo (tabela [4])
			if (not jaFoi [spellname]) then
				tabela [5] = spellname
				tabela_em_ordem [#tabela_em_ordem+1] = tabela
				jaFoi [spellname] = #tabela_em_ordem
			else
				local index = jaFoi [spellname]
				tabela_em_ordem [index] [1] = tabela_em_ordem [index] [1] + tabela [1]
				
				local tt = tabela_em_ordem [index] [2] -- tabela com [PlayerName] = {amount, class}
				
				for playerName, t in pairs (tabela [2]) do
					local amount, class = unpack (t)
					if (tt [playerName]) then
						tt [playerName][1] = tt [playerName][1] + amount
					else
						tt [playerName] = {amount, class}
					end
				end
			end
		end
		
		_table_sort (tabela_em_ordem, _detalhes.Sort1)

		container = frame.overall_habilidades.gump
		quantidade = 0
		dano_do_primeiro = 0
		
		--> mostra o resultado nas barras
		for index, habilidade in _ipairs (tabela_em_ordem) do
			--> ta em ordem das habilidades que deram mais dano
			
			if (habilidade[1] > 0) then
			
				local barra = container.barras [index]
				if (not barra) then
					barra = EncounterDetails:CreateRow (index, container, 1, 0, -1)
					barra.TTT = "habilidades_inimigas" -- tool tip type --enemy abilities
					barra.report_text = Loc ["STRING_PLUGIN_NAME"].."! " .. Loc ["STRING_ABILITY_DAMAGE"]
					_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
					_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
					barra.t:SetVertexColor (1, .8, .8, .8)
				end
				
				local nome_magia, _, icone_magia = _GetSpellInfo (habilidade[4])

				barra.texto_esquerdo:SetText (nome_magia) --  .. " (|cFFa0a0a0" .. habilidade[4] .. "|r)
				barra.texto_direita:SetText (ToK (_, habilidade[1]))
				
				_detalhes:name_space (barra)
				
				barra.jogador = habilidade --> barra.jogador agora tem a tabela com --> [1] total dano causado [2] jogadores que foram alvos [3] jogadores que castaram essa magia [4] ID da magia
				
				local spellSchool = _detalhes.spell_school_cache [nome_magia] or 1
				local r, g, b = _detalhes:GetSpellSchoolColor (spellSchool)
				
				barra.t:SetVertexColor (r, g, b)

				if (index == 1)  then
					barra.textura:SetValue (100)
					dano_do_primeiro = habilidade[1]
				else
					barra.textura:SetValue (habilidade[1]/dano_do_primeiro *100)
				end
				
				barra.icone:SetTexture (icone_magia)
				barra.icone:SetTexCoord (.1, .9, .1, .9)
				
				barra:Show()
				quantidade = quantidade + 1
			
			end
		end

		EncounterDetails:JB_AtualizaContainer (container, quantidade)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
				container.barras [i]:Hide()
			end
		end
	
	--> Fim do container Over Habilidades Inimigas
	
	--> Identificar os ADDs da luta:
	
		--> declara a pool onde ser�o armazenados os adds existentas na luta
		local adds_pool = {}
	
		--> pega as habilidades que pertence especificamente a cada fase
		
		if (boss_info and boss_info.phases) then
			for fase_id, fase in _ipairs (boss_info.phases) do 
				if (fase.adds) then
					for index, addId in _ipairs (fase.adds) do 
						adds_pool [addId] = true
					end
				end
			end
		end
		
		--> agora ja tenho a lista de todos os adds da luta
		-- vasculhar o container de dano e achar os adds:
		-- ~add
		
		local adds = {}
		
		for index, jogador in _ipairs (DamageContainer._ActorTable) do
		
			--> s� estou interessado nos adds, conferir pelo nome
			if (adds_pool [_detalhes:GetNpcIdFromGuid (jogador.serial)] or (
				jogador.flag_original and
				bit.band (jogador.flag_original, 0x00000060) ~= 0 and
				(not jogador.owner or (_bit_band (jogador.owner.flag_original, 0x00000060) ~= 0 and not jogador.owner.grupo and _bit_band (jogador.owner.flag_original, 0x00000400) == 0)) and --isn't a pet or the owner isn't a player
				not jogador.grupo and
				_bit_band (jogador.flag_original, 0x00000400) == 0
			)) then --> � um inimigo ou neutro
			
				local nome = jogador.nome
				
				if (not nome:find ("%*")) then
					local tabela = {nome = nome, total = 0, dano_em = {}, dano_em_total = 0, damage_from = {}, damage_from_total = 0}
				
					--> total de dano que ele causou
					tabela.total = jogador.total
					
					--> em quem ele deu dano
					for target_name, amount in _pairs (jogador.targets) do
						local este_jogador = _combat_object (1, target_name)
						if (este_jogador) then
							if (este_jogador.classe ~= "PET" and este_jogador.classe ~= "UNGROUPPLAYER" and este_jogador.classe ~= "UNKNOW") then
								tabela.dano_em [#tabela.dano_em +1] = {target_name, amount, este_jogador.classe}
								tabela.dano_em_total = tabela.dano_em_total + amount
							end
						end
					end
					_table_sort (tabela.dano_em, _detalhes.Sort2)
					
					--> quem deu dano nele
					for agressor, _ in _pairs (jogador.damage_from) do 
						--local este_jogador = DamageContainer._ActorTable [DamageContainer._NameIndexTable [agressor]]
						local este_jogador = _combat_object (1, agressor)
						if (este_jogador and este_jogador:IsPlayer()) then 
							for target_name, amount in _pairs (este_jogador.targets) do
								if (target_name == nome) then 
									tabela.damage_from [#tabela.damage_from+1] = {agressor, amount, este_jogador.classe}
									tabela.damage_from_total = tabela.damage_from_total + amount
								end
							end
						end
					end
					
					_table_sort (tabela.damage_from, sort_damage_from)

					tabela [1] = tabela.damage_from_total
					tinsert (adds, tabela)
				end
			end
			
		end
		
		--> montou a tabela, agora precisa mostrar no painel

		local function _DanoFeito (self)
			self.textura:SetBlendMode ("ADD")
		
			local barra = self:GetParent()
			local tabela = barra.jogador
			local dano_em = tabela.dano_em
			
			GameCooltip:Preset (2)
			GameCooltip:SetOwner (self)
			
			EncounterDetails:FormatCooltipSettings()
			
			GameCooltip:AddLine (barra.texto_esquerdo:GetText().." ".. "Damage Done")
			
			local topDamage = dano_em[1] and dano_em[1][2]
			
			local dano_em_total = tabela.dano_em_total
			for _, esta_tabela in _pairs (dano_em) do 
				local coords = EncounterDetails.class_coords [esta_tabela[3]]
				GameCooltip:AddLine (EncounterDetails:GetOnlyName (esta_tabela[1]), _detalhes:ToK (esta_tabela[2]).." (".. _cstr ("%.1f", esta_tabela[2]/dano_em_total*100) .."%)", 1, "white", "orange")
				
				local specID = Details:GetSpec (esta_tabela[1])
				if (specID) then
					local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
					GameCooltip:AddIcon (texture, 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, l, r, t, b)
				else
					GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, (coords[1]), (coords[2]), (coords[3]), (coords[4]))
				end
				
				local actorClass = Details:GetClass (esta_tabela[1])
				if (actorClass) then
					local r, g, b = Details:GetClassColor (actorClass)
					GameCooltip:AddStatusBar (esta_tabela[2] / topDamage * 100, 1, r, g, b, EncounterDetailsFrame.CooltipStatusbarAlpha, false, {value = 100, color = {.21, .21, .21, 0.5}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
				else
					GameCooltip:AddStatusBar (esta_tabela[2] / topDamage * 100, 1, .3, .3, .3, .3, false, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
				end
			end
			
			self.textura:SetBlendMode ("ADD")
			self.textura:SetSize (18, 18)
			self.ArrowOnEnter = true
			GameCooltip:SetOwner (self, "right", "left", -10, 0)
			
			GameCooltip:AddLine (" ")
			GameCooltip:AddLine ("CLICK to Report")
			GameCooltip:Show()
		end

		local function _DanoRecebido (self)

			local barra = self
			local tabela = barra.jogador
			local damage_from = tabela.damage_from
			
			GameCooltip:Preset (2)
			GameCooltip:SetOwner (self)
			
			EncounterDetails:FormatCooltipSettings()
			
			GameCooltip:AddLine (barra.texto_esquerdo:GetText().." "..Loc ["STRING_DAMAGE_TAKEN"])
			
			local damage_from_total = tabela.damage_from_total
			local topDamage = damage_from[1] and damage_from[1][2]

			for _, esta_tabela in _pairs (damage_from) do 

				local coords = EncounterDetails.class_coords [esta_tabela[3]]
				if (coords) then
					GameCooltip:AddLine (EncounterDetails:GetOnlyName (esta_tabela[1]), _detalhes:ToK (esta_tabela[2]).." (".. _cstr ("%.1f", esta_tabela[2]/damage_from_total*100) .."%)", 1, "white", "orange", nil, nil, "MONOCHRONE")
					
					local specID = Details:GetSpec (esta_tabela[1])
					if (specID) then
						local texture, l, r, t, b = Details:GetSpecIcon (specID, false)
						GameCooltip:AddIcon (texture, 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, l, r, t, b)
					else					
						GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small]], 1, 1, EncounterDetails.CooltipLineHeight, EncounterDetails.CooltipLineHeight, (coords[1]), (coords[2]), (coords[3]), (coords[4]))
					end
					
					local actorClass = Details:GetClass (esta_tabela[1])
					if (actorClass) then
						local r, g, b = Details:GetClassColor (actorClass)
						GameCooltip:AddStatusBar (esta_tabela[2] / topDamage * 100, 1, r, g, b, EncounterDetailsFrame.CooltipStatusbarAlpha, false, {value = 100, color = {.21, .21, .21, 0.5}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
					else
						GameCooltip:AddStatusBar (esta_tabela[2] / topDamage * 100, 1, .3, .3, .3, .3, false, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
					end
				else
					GameCooltip:AddLine (esta_tabela[1], _detalhes:ToK (esta_tabela[2]).." (".. _cstr ("%.1f", esta_tabela[2]/damage_from_total*100) .."%)")
					GameCooltip:AddStatusBar (esta_tabela[2] / topDamage * 100, 1, .3, .3, .3, .3, false, {value = 100, color = {.21, .21, .21, 0.8}, texture = [[Interface\AddOns\Details\images\bar_serenity]]})
				end
			end
			
			self.mouse_over = true
			self:SetHeight (EncounterDetails.Frame.DefaultBarHeight + 1)
			self:SetAlpha (1)
			EncounterDetails.SetBarBackdrop_OnEnter (self)
			
			GameCooltip:AddLine (" ")
			GameCooltip:AddLine ("CLICK to Report")
			
			GameCooltip:SetOwner (self, "left", "right", -60, 0)
			GameCooltip:Show()
		end
		
		local function _OnHide (self)
			GameCooltip:Hide()

			if (self.ArrowOnEnter) then
				self.textura:SetBlendMode ("BLEND")
				self.textura:SetSize (16, 16)
			else
				self:SetAlpha (0.9)
				self:SetHeight (EncounterDetails.Frame.DefaultBarHeight)
				EncounterDetails.SetBarBackdrop_OnLeave (self)
			end
		end
		
		local y = 10
		local frame_adds = EncounterDetailsFrame.overall_adds
		container = frame_adds.gump
		local index = 1
		quantidade = 0
		
		--table.sort (adds, sort_by_name)
		table.sort (adds, _detalhes.Sort1)
		
		for index, esta_tabela in _ipairs (adds) do 
		
			local addName = esta_tabela.nome
			local barra = container.barras [index]
			
			if (not barra) then
				barra = EncounterDetails:CreateRow (index, container, -0)
				
				barra:SetWidth (155)
				
				barra:SetScript ("OnEnter", _DanoRecebido)
				barra:SetScript ("OnLeave", _OnHide)
				barra:HookScript ("OnMouseDown", EncounterDetails.BossInfoRowClick)
				
				local add_damage_done = _CreateFrame ("Button", nil, barra)
				barra.report_text = "Details! Tamage Taken of "
				add_damage_done.report_text = "Details! Damage Done of "
				add_damage_done.barra = barra
				add_damage_done:SetWidth (EncounterDetails.CooltipLineHeight)
				add_damage_done:SetHeight (EncounterDetails.CooltipLineHeight)
				add_damage_done:EnableMouse (true)
				add_damage_done:SetResizable (false)
				add_damage_done:SetPoint ("left", barra, "left", 0, 0)
				
				add_damage_done:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16})
				add_damage_done:SetBackdropColor (.5, .0, .0, 0.5)
				
				add_damage_done.textura = add_damage_done:CreateTexture (nil, "overlay")
				add_damage_done.textura:SetTexture ("Interface\\Buttons\\UI-MicroStream-Red")
				add_damage_done.textura:SetWidth (16)
				add_damage_done.textura:SetHeight (16)
				add_damage_done.textura:SetPoint ("topleft", add_damage_done, "topleft")
				
				add_damage_done:SetScript ("OnEnter", _DanoFeito)
				add_damage_done:SetScript ("OnLeave", _OnHide)
				add_damage_done:SetScript ("OnClick", EncounterDetails.BossInfoRowClick)
				
				barra.texto_esquerdo:SetPoint ("left", add_damage_done, "right", 2, 0)
				barra.textura:SetStatusBarTexture (nil)
				
				_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
				_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
				
				barra.TTT = "add"
				add_damage_done.TTT = "add"
			end

			barra.texto_esquerdo:SetText (addName)
			barra.texto_direita:SetText (_detalhes:ToK (esta_tabela.damage_from_total))
			barra.texto_esquerdo:SetSize (barra:GetWidth() - barra.texto_direita:GetStringWidth() - 34, 15)
			
			barra.jogador = esta_tabela --> barra.jogador agora tem a tabela com --> [1] total dano causado [2] jogadores que foram alvos [3] jogadores que castaram essa magia [4] ID da magia
			
			--barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [jogador.classe]))
			barra.textura:SetStatusBarColor (1, 1, 1, 1) --> a cor pode ser a spell school da magia
			barra.textura:SetValue (100)
			
			barra:Show()
			quantidade = quantidade + 1
			index = index +1
		end
		
		EncounterDetails:JB_AtualizaContainer (container, quantidade, 4)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
				container.barras [i]:Hide()
			end
		end
		
	--> Fim do container Over ADDS
	
	--> Inicio do Container de Interrupts:
	
		local misc = _combat_object [class_type_misc]
		
		local total_interrompido = _detalhes.atributo_misc:RefreshWindow ({}, _combat_object, _, { key = "interrupt", modo = _detalhes.modos.group })
		
		local frame_interrupts = EncounterDetailsFrame.overall_interrupt
		container = frame_interrupts.gump
		
		quantidade = 0
		local interrupt_do_primeiro = 0
		
		local habilidades_interrompidas = {}
		
		for index, jogador in _ipairs (misc._ActorTable) do
			if (not jogador.grupo) then --> s� aparecer nego da raid
				break
			end
			
			if (jogador.classe and jogador.classe ~= "UNGROUPPLAYER") then			
				local interrupts = jogador.interrupt				
				if (interrupts and interrupts > 0) then
					local oque_interrompi = jogador.interrompeu_oque
					--> vai ter [spellid] = quantidade
					
					for spellid, amt in _pairs (oque_interrompi) do 
						if (not habilidades_interrompidas [spellid]) then --> se a spell n�o tiver na pool, cria a tabela dela
							habilidades_interrompidas [spellid] = {{}, 0, spellid} --> tabela com quem interrompeu e o total de vezes que a habilidade foi interrompida
						end
						
						if (not habilidades_interrompidas [spellid] [1] [jogador.nome]) then --> se o jogador n�o tiver na pool dessa habilidade interrompida, cria um indice pra ele.
							habilidades_interrompidas [spellid] [1] [jogador.nome] = {0, jogador.classe}
						end
						
						habilidades_interrompidas [spellid] [2] = habilidades_interrompidas [spellid] [2] + amt
						habilidades_interrompidas [spellid] [1] [jogador.nome] [1] = habilidades_interrompidas [spellid] [1] [jogador.nome] [1] + amt
					end
				end
			end
		end
		
		--> por em ordem
		tabela_em_ordem = {}
		for spellid, tabela in _pairs (habilidades_interrompidas) do 
			tabela_em_ordem [#tabela_em_ordem+1] = tabela
		end
		_table_sort (tabela_em_ordem, _detalhes.Sort2)

		index = 1
		
		for _, tabela in _ipairs (tabela_em_ordem) do
		
			local barra = container.barras [index]
			if (not barra) then
				barra = EncounterDetails:CreateRow (index, container, 3, 0, -6)
				_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
				_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
				barra.TTT = "total_interrupt" -- tool tip type
				barra.report_text = "Details! ".. Loc ["STRING_INTERRUPTS_OF"]
				barra:SetWidth (155)
			end
			
			local spellid = tabela [3]
			
			local nome_magia, _, icone_magia = _GetSpellInfo (tabela [3])
			local successful = 0
			--> pegar quantas vezes a magia passou com sucesso.
			for _, enemy_actor in _ipairs (DamageContainer._ActorTable) do
				if (enemy_actor.spells._ActorTable [spellid]) then
					local spell = enemy_actor.spells._ActorTable [spellid]
					successful = spell.successful_casted
				end
			end
			
			barra.texto_esquerdo:SetText (nome_magia)
			local total = successful + tabela [2]
			barra.texto_direita:SetText (tabela [2] .. " / ".. total)
			
			_detalhes:name_space (barra)
			
			barra.jogador = tabela
			
			--barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [jogador.classe]))
			
			if (index == 1)  then
				barra.textura:SetValue (100)
				dano_do_primeiro = tabela [2]
			else
				barra.textura:SetValue (tabela [2]/dano_do_primeiro *100)
			end
			
			barra.icone:SetTexture (icone_magia)
			barra.icone:SetTexCoord (.1, .9, .1, .9)
			
			barra:Show()
			
			quantidade = quantidade + 1
			index = index + 1 
		end

		EncounterDetails:JB_AtualizaContainer (container, quantidade, 4)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
				container.barras[i]:Hide()
			end
		end
	
	--> Fim do container dos Interrupts
	
	--> Inicio do Container dos Dispells:
		
		--> force refresh window behavior
		local total_dispelado = _detalhes.atributo_misc:RefreshWindow ({}, _combat_object, _, { key = "dispell", modo = _detalhes.modos.group })
		
		local frame_dispell = EncounterDetailsFrame.overall_dispell
		container = frame_dispell.gump
		
		quantidade = 0
		local dispell_do_primeiro = 0
		
		local habilidades_dispeladas = {}
		
		for index, jogador in _ipairs (misc._ActorTable) do
			if (not jogador.grupo) then --> s� aparecer nego da raid
				break
			end

			if (jogador.classe and jogador.classe ~= "UNGROUPPLAYER") then

				local dispells = jogador.dispell
				if (dispells and dispells > 0) then
					local oque_dispelei = jogador.dispell_oque
					--> vai ter [spellid] = quantidade
					
					--print ("dispell: " .. jogador.classe .. " nome: " .. jogador.nome)
					
					for spellid, amt in _pairs (oque_dispelei) do 
						if (not habilidades_dispeladas [spellid]) then --> se a spell n�o tiver na pool, cria a tabela dela
							habilidades_dispeladas [spellid] = {{}, 0, spellid} --> tabela com quem dispolou e o total de vezes que a habilidade foi dispelada
						end
						
						if (not habilidades_dispeladas [spellid] [1] [jogador.nome]) then --> se o jogador n�o tiver na pool dessa habilidade interrompida, cria um indice pra ele.
							habilidades_dispeladas [spellid] [1] [jogador.nome] = {0, jogador.classe}
							--print (jogador.nome)
							--print (jogador.classe)
						end
						
						habilidades_dispeladas [spellid] [2] = habilidades_dispeladas [spellid] [2] + amt
						habilidades_dispeladas [spellid] [1] [jogador.nome] [1] = habilidades_dispeladas [spellid] [1] [jogador.nome] [1] + amt
					end
				end
			end
		end
		
		--> por em ordem
		tabela_em_ordem = {}
		for spellid, tabela in _pairs (habilidades_dispeladas) do 
			tabela_em_ordem [#tabela_em_ordem+1] = tabela
		end
		_table_sort (tabela_em_ordem, _detalhes.Sort2)

		index = 1
		
		for _, tabela in _ipairs (tabela_em_ordem) do
		
			local barra = container.barras [index]
			if (not barra) then
				barra = EncounterDetails:CreateRow (index, container, 3, 3, -6)
				_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
				_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
				barra.TTT = "dispell" -- tool tip type
				barra.report_text = "Details! ".. Loc ["STRING_DISPELLS_OF"]
				barra:SetWidth (160)
			end
			
			local nome_magia, _, icone_magia = _GetSpellInfo (tabela [3])
			
			barra.texto_esquerdo:SetText (nome_magia)
			barra.texto_direita:SetText (tabela [2])
			
			_detalhes:name_space (barra)
			
			barra.jogador = tabela
			
			--barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [jogador.classe]))
			
			if (index == 1)  then
				barra.textura:SetValue (100)
				dano_do_primeiro = tabela [2]
			else
				barra.textura:SetValue (tabela [2]/dano_do_primeiro *100)
			end
			
			barra.icone:SetTexture (icone_magia)
			barra.icone:SetTexCoord (.1, .9, .1, .9)
			
			barra:Show()
			
			quantidade = quantidade + 1
			index = index + 1 
		end
		
		EncounterDetails:JB_AtualizaContainer (container, quantidade, 4)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
				container.barras [i]:Hide()
			end
		end
	
	--> Fim do container dos Dispells
	
	--> Inicio do Container das Mortes:
		local frame_mortes = EncounterDetailsFrame.overall_dead
		container = frame_mortes.gump
		
		quantidade = 0
	
		-- boss_info.spells_info o erro de lua do boss � a habilidade dele que n�o foi declarada ainda
	
		local mortes = _combat_object.last_events_tables
		local habilidades_info = boss_info and boss_info.spell_mechanics or {} --barra.extra pega esse cara aqui --> ent�o esse erro � das habilidades que n�o tao
	
		for index, tabela in _ipairs (mortes) do
			--> {esta_morte, time, este_jogador.nome, este_jogador.classe, _UnitHealthMax (alvo_name), minutos.."m "..segundos.."s",  ["dead"] = true}
			local barra = container.barras [index]
			if (not barra) then
				barra = EncounterDetails:CreateRow (index, container, 3, 0, 1)
				barra.TTT = "morte" -- tool tip type
				barra.report_text = "Details! " .. Loc ["STRING_DEAD_LOG"]
				_detalhes:SetFontSize (barra.texto_esquerdo, CONST_FONT_SIZE)
				_detalhes:SetFontSize (barra.texto_direita, CONST_FONT_SIZE)
				barra:SetWidth (169)
				
				local overlayTexture = barra:CreateTexture (nil, "overlay")
				overlayTexture:SetAllPoints()
				overlayTexture:SetColorTexture (1, 1, 1)
				overlayTexture:SetAlpha (1)
				overlayTexture:Hide()
				barra.OverlayTexture = overlayTexture
			end

			if (tabela [3]:find ("-")) then
				barra.texto_esquerdo:SetText (index..". "..tabela [3]:gsub (("-.*"), ""))
			else
				barra.texto_esquerdo:SetText (index..". "..tabela [3])
			end

			barra.texto_direita:SetText (tabela [6])
			
			_detalhes:name_space (barra)
			
			barra.jogador = tabela
			barra.extra = habilidades_info
			
			barra.textura:SetStatusBarColor (_unpack (_detalhes.class_colors [tabela [4]]))
			barra.textura:SetValue (100)
			
			barra.icone:SetTexture ("Interface\\AddOns\\Details\\images\\classes_small")
			barra.icone:SetTexCoord (_unpack (EncounterDetails.class_coords [tabela [4]]))
			
			barra:Show()
			
			quantidade = quantidade + 1
		
		end
		
		EncounterDetails:JB_AtualizaContainer (container, quantidade, 10)
		
		if (quantidade < #container.barras) then
			for i = quantidade+1, #container.barras, 1 do 
				container.barras [i]:Hide()
			end
		end
end

local events_to_track = {
	["SPELL_CAST_START"] = true, --not instant cast
	["SPELL_CAST_SUCCESS"] = true, --not instant cast
	["SPELL_AURA_APPLIED"] = true, --if is a debuff
	["SPELL_DAMAGE"] = true, --damage
	["SPELL_PERIODIC_DAMAGE"] = true, --dot damage
	["SPELL_HEAL"] = true, --healing
	["SPELL_PERIODIC_HEAL"] = true, --dot healing
}

local enemy_spell_pool
local CLEvents = function (self, event)

	local time, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2, spellid, spellname, school, aura_type = CombatLogGetCurrentEventInfo()

	if (events_to_track [token] and _bit_band (who_flags or 0x0, 0x00000060) ~= 0) then
		local t = enemy_spell_pool [spellid]
		if (not t) then
			t = {["token"] = {[token] = true}, ["source"] = who_name, ["school"] = school}
			if (token == "SPELL_AURA_APPLIED") then
				t.type = aura_type
			end
			enemy_spell_pool [spellid] = t
			return
			
		elseif (t.token [token]) then
			return
		end
		
		t.token [token] = true
		if (token == "SPELL_AURA_APPLIED") then
			t.type = aura_type
		end
	end
end

function EncounterDetails:OnEvent (_, event, ...)

	if (event == "ENCOUNTER_START") then
		--> tracks if a enemy spell is instant cast.
		EncounterDetails.CLEvents:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
	elseif (event == "ENCOUNTER_END") then
		EncounterDetails.CLEvents:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	
	elseif (event == "ADDON_LOADED") then
		local AddonName = select (1, ...)
		if (AddonName == "Details_EncounterDetails") then
			
			if (_G._detalhes and _G._detalhes:InstallOkey()) then
				
				if (DetailsFramework.IsClassicWow()) then
					return
				end
				
				--> create widgets
				CreatePluginFrames (data)

				local PLUGIN_MINIMAL_DETAILS_VERSION_REQUIRED = 1
				local PLUGIN_TYPE = "TOOLBAR"
				local PLUGIN_LOCALIZED_NAME = Loc ["STRING_PLUGIN_NAME"]
				local PLUGIN_REAL_NAME = "DETAILS_PLUGIN_ENCOUNTER_DETAILS"
				local PLUGIN_ICON = [[Interface\Scenarios\ScenarioIcon-Boss]]
				local PLUGIN_AUTHOR = "Details! Team"
				local PLUGIN_VERSION = "v1.06"
				
				local default_settings = {
					show_icon = 5, --automatic
					hide_on_combat = false, --hide the window when a new combat start
					max_emote_segments = 3,
					opened = 0,
					encounter_timers_dbm = {},
					encounter_timers_bw = {},
					window_scale = 1,
				}

				--> Install
				local install, saveddata, is_enabled = _G._detalhes:InstallPlugin (
					PLUGIN_TYPE,
					PLUGIN_LOCALIZED_NAME,
					PLUGIN_ICON,
					EncounterDetails, 
					PLUGIN_REAL_NAME,
					PLUGIN_MINIMAL_DETAILS_VERSION_REQUIRED, 
					PLUGIN_AUTHOR, 
					PLUGIN_VERSION, 
					default_settings
				)
				
				if (type (install) == "table" and install.error) then
					print (install.error)
				end
--				table.wipe (EncounterDetailsDB.encounter_spells)
				EncounterDetails.charsaved = EncounterDetailsDB or {emotes = {}}
				EncounterDetailsDB = EncounterDetails.charsaved
				
				EncounterDetails.charsaved.encounter_spells = EncounterDetails.charsaved.encounter_spells or {}
				
				EncounterDetails.boss_emotes_table = EncounterDetails.charsaved.emotes
				
				--> build a table on global saved variables
				if (not _detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"]) then
					_detalhes.global_plugin_database ["DETAILS_PLUGIN_ENCOUNTER_DETAILS"] = {encounter_timers_dbm = {}, encounter_timers_bw= {}}
				end
				
				--> Register needed events
				_G._detalhes:RegisterEvent (EncounterDetails, "COMBAT_PLAYER_ENTER")
				_G._detalhes:RegisterEvent (EncounterDetails, "COMBAT_PLAYER_LEAVE")
				_G._detalhes:RegisterEvent (EncounterDetails, "COMBAT_BOSS_FOUND")
				_G._detalhes:RegisterEvent (EncounterDetails, "DETAILS_DATA_RESET")
				
				_G._detalhes:RegisterEvent (EncounterDetails, "GROUP_ONENTER")
				_G._detalhes:RegisterEvent (EncounterDetails, "GROUP_ONLEAVE")
				
				_G._detalhes:RegisterEvent (EncounterDetails, "ZONE_TYPE_CHANGED")
				
				EncounterDetailsFrame:RegisterEvent ("ENCOUNTER_START")
				EncounterDetailsFrame:RegisterEvent ("ENCOUNTER_END")
				EncounterDetails.EnemySpellPool = EncounterDetails.charsaved.encounter_spells
				enemy_spell_pool = EncounterDetails.EnemySpellPool
				EncounterDetails.CLEvents = CreateFrame ("frame", nil, UIParent)
				EncounterDetails.CLEvents:SetScript ("OnEvent", CLEvents)
				EncounterDetails.CLEvents:Hide()
				
				EncounterDetails.BossWhispColors = {
					[1] = "RAID_BOSS_EMOTE",
					[2] = "RAID_BOSS_WHISPER",
					[3] = "MONSTER_EMOTE",
					[4] = "MONSTER_SAY",
					[5] = "MONSTER_WHISPER",
					[6] = "MONSTER_PARTY",
					[7] = "MONSTER_YELL",
				}
				
				--> embed the plugin into the plugin window
				if (DetailsPluginContainerWindow) then
					DetailsPluginContainerWindow.EmbedPlugin (EncounterDetails, EncounterDetails.Frame)
				end
				
			end
		end
		
	end
end
