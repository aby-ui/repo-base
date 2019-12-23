-- **********************************************************
-- **             Deadly Boss Mods - SpellsUsed            **
-- **             http://www.deadlybossmods.com            **
-- **********************************************************
--
-- This addon is written and copyrighted by:
--    * Martin Verges (Nitram @ EU-Azshara)
--    * Paul Emmerich (Tandanu @ EU-Aegwynn)
--
-- The localizations are written by:
--    * enGB/enUS: Nitram/Tandanu        http://www.deadlybossmods.com
--    * deDE: Nitram/Tandanu             http://www.deadlybossmods.com
--    * zhCN: yleaf(yaroot@gmail.com)
--    * zhTW: yleaf(yaroot@gmail.com)/Juha
--    * koKR: BlueNyx(bluenyx@gmail.com)/nBlueWiz(everfinale@gmail.com)
--    * esES: Interplay/1nn7erpLaY       http://www.1nn7erpLaY.com
--
-- This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
--
--  You are free:
--    * to Share - to copy, distribute, display, and perform the work
--    * to Remix - to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--

local Revision = "20191210204503"

local IsInRaid = IsInRaid
local IsInInstance = IsInInstance
local select = select

local default_bartext = "%spell: %player"
local default_bartextwtarget = "%spell: %player on %target"	-- Added by Florin Patan
local default_settings = {
	enabled = true,
	showlocal = true,
	only_from_raid = true,
	active_in_pvp = true,
	own_bargroup = false,
	show_portal = true,
	spells = {
		{ spell = 22700, bartext = default_bartext, cooldown = 600 }, 	-- Field Repair Bot 74A
		{ spell = 44389, bartext = default_bartext, cooldown = 600 }, 	-- Field Repair Bot 110G
		{ spell = 54711, bartext = default_bartext, cooldown = 300 }, 	-- Scrapbot Construction Kit
		{ spell = 67826, bartext = default_bartext, cooldown = 600 }, 	-- Jeeves

	},
	portal_alliance = {
		{ spell = 10059, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Stormwind
		{ spell = 11416, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Ironforge
		{ spell = 11419, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Darnassus
		{ spell = 32266, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Exodar
		{ spell = 33691, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Shattrath
		{ spell = 49360, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Theramore
		{ spell = 53142, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Dalaran (Northrend)
		{ spell = 88345, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Tol Barad
		{ spell = 132620, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Vale of eternal Blossoms
		{ spell = 120146, bartext = default_bartext, cooldown = 60 }, 	-- Ancient Portal: Dalaran
		{ spell = 176246, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Stormshield
		{ spell = 224873, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Dalaran - Broken Isles
		{ spell = 281400, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Boralus
	},
	portal_horde = {
		{ spell = 11417, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Orgrimmar
		{ spell = 11418, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Undercity
		{ spell = 11420, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Thunder Bluff
		{ spell = 32667, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Silvermoon
		{ spell = 35717, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Shattrath
		{ spell = 49361, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Stonard
		{ spell = 53142, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Dalaran (Northrend)
		{ spell = 88346, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Tol Barad
		{ spell = 132626, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Vale of eternal Blossoms
		{ spell = 120146, bartext = default_bartext, cooldown = 60 }, 	-- Ancient Portal: Dalaran
		{ spell = 176244, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Warspear
		{ spell = 224873, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Dalaran - Broken Isles
		{ spell = 281402, bartext = default_bartext, cooldown = 60 }, 	-- Portal: Dazar'alor
	}
}
DBM_SpellTimers_Settings = {}
local settings = default_settings

local L = DBM_SpellsUsed_Translations

local SpellBars
local SpellBarIndex = {}
local SpellIDIndex = {}
local function rebuildSpellIDIndex()
  SpellIDIndex = {}
	for k,v in pairs(settings.spells) do
	  if v.spell then
	    SpellIDIndex[v.spell] = k
	  end
	end
end

-- functions
local addDefaultOptions
do
	local function creategui()
		local createnewentry
		local CurCount = 0
		local panel = DBM_GUI:CreateNewPanel(L.TabCategory_SpellsUsed, "option")
		local generalarea = panel:CreateArea(L.AreaGeneral, nil, 150, true)
		local auraarea = panel:CreateArea(L.AreaAuras, nil, 20, true)

		local function regenerate()
			-- FIXME here we can reuse the frames to save some memory (if the player deletes entries)
			for i=select("#", auraarea.frame:GetChildren()), 1, -1 do
				local v = select(i, auraarea.frame:GetChildren())
				v:Hide()
				v:SetParent(UIParent)
				v:ClearAllPoints()
			end
			auraarea.frame:SetHeight(20)
			CurCount = 0

			if #settings.spells == 0 then
				createnewentry()
			else
				for i=1, #settings.spells, 1 do
					createnewentry()
				end
			end
		end


		do
			local area = generalarea
			local enabled = area:CreateCheckButton(L.Enable, true)
			enabled:SetScript("OnShow", function(self) self:SetChecked(settings.enabled) end)
			enabled:SetScript("OnClick", function(self) settings.enabled = not not self:GetChecked() end)

			local showlocal = area:CreateCheckButton(L.Show_LocalMessage, true)
			showlocal:SetScript("OnShow", function(self) self:SetChecked(settings.showlocal) end)
			showlocal:SetScript("OnClick", function(self) settings.showlocal = not not self:GetChecked() end)

			local showinraid = area:CreateCheckButton(L.Enable_inRaid, true)
			showinraid:SetScript("OnShow", function(self) self:SetChecked(settings.only_from_raid) end)
			showinraid:SetScript("OnClick", function(self) settings.only_from_raid = not not self:GetChecked() end)

			local showinpvp = area:CreateCheckButton(L.Enable_inBattleground, true)
			showinpvp:SetScript("OnShow", function(self) self:SetChecked(settings.active_in_pvp) end)
			showinpvp:SetScript("OnClick", function(self) settings.active_in_pvp = not not self:GetChecked() end)

			local show_portal = area:CreateCheckButton(L.Enable_Portals, true)
			show_portal:SetScript("OnShow", function(self) self:SetChecked(settings.show_portal) end)
			show_portal:SetScript("OnClick", function(self) settings.show_portal = not not self:GetChecked() end)

			local resetbttn = area:CreateButton(L.Reset, 140, 20)
			resetbttn:SetPoint("TOPRIGHT", area.frame, "TOPRIGHT", -15, -15)
			resetbttn:SetScript("OnClick", function(self)
				table.wipe(DBM_SpellTimers_Settings)
				addDefaultOptions(settings, default_settings)
				for k,v in pairs(settings.spells) do
					if v.enabled == nil then
						v.enabled = true
					end
				end
				regenerate()
				DBM_GUI_OptionsFrame:DisplayFrame(panel.frame)
			end)

			local version = area:CreateText("r"..Revision, nil, nil, GameFontDisableSmall, "RIGHT")
			version:SetPoint("BOTTOMRIGHT", area.frame, "BOTTOMRIGHT", -5, 5)
		end
		do
			local function onchange_spell(field)
				return function(self)
					settings.spells[self.guikey] = settings.spells[self.guikey] or {}
					if field == "spell" then
						settings.spells[self.guikey][field] = self:GetNumber()
						rebuildSpellIDIndex()
					elseif field == "cooldown" then
						settings.spells[self.guikey][field] = self:GetNumber()
					elseif field == "enabled" then
						settings.spells[self.guikey].enabled = not not self:GetChecked()
					else
						settings.spells[self.guikey][field] = self:GetText()
					end
				end
			end
			local function onshow_spell(field)
				return function(self)
					settings.spells[self.guikey] = settings.spells[self.guikey] or {}
					if field == "bartext" and settings.spells[self.guikey].spell and settings.spells[self.guikey].spell > 0 then
						local text = settings.spells[self.guikey][field] or ""
						local spellinfo = DBM:GetSpellInfo(settings.spells[self.guikey].spell)
						if spellinfo == nil then
							DBM:AddMsg("Illegal SpellID found. Please remove the Spell "..settings.spells[self.guikey].spell.." from your DBM Options GUI (spelltimers)");
						else
							self:SetText( string.gsub(text, "%%spell", spellinfo) )
						end
					elseif field == "enabled" then
						self:SetChecked( settings.spells[self.guikey].enabled )
					else
						self:SetText( settings.spells[self.guikey][field] or "" )
					end
				end
			end

			local area = auraarea

			local getadditionalid = CreateFrame("Button", "GetAdditionalID_Pull", area.frame)
			getadditionalid:SetNormalTexture(130838);--"Interface\\Buttons\\UI-PlusButton-UP"
			getadditionalid:SetPushedTexture(130836);--"Interface\\Buttons\\UI-PlusButton-DOWN"
			getadditionalid:SetWidth(15)
			getadditionalid:SetHeight(15)

			function createnewentry()
				CurCount = CurCount + 1
				local spellid = area:CreateEditBox(L.SpellID, "", 65)
				spellid.guikey = CurCount
				spellid:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 40, 15-(CurCount*35))
				spellid:SetScript("OnTextChanged", onchange_spell("spell"))
				spellid:SetScript("OnShow", onshow_spell("spell"))
				spellid:SetNumeric(true)

				local bartext = area:CreateEditBox(L.BarText, "", 190)
				bartext.guikey = CurCount
				bartext:SetPoint('TOPLEFT', spellid, "TOPRIGHT", 20, 0)
				bartext:SetScript("OnTextChanged", onchange_spell("bartext"))
				bartext:SetScript("OnShow", onshow_spell("bartext"))

				local cooldown = area:CreateEditBox(L.Cooldown, "", 45)
				cooldown.guikey = CurCount
				cooldown:SetPoint("TOPLEFT", bartext, "TOPRIGHT", 20, 0)
				cooldown:SetScript("OnTextChanged", onchange_spell("cooldown"))
				cooldown:SetScript("OnShow", onshow_spell("cooldown"))
				cooldown:SetNumeric(true)

				local enableit = area:CreateCheckButton("")
				enableit.guikey = CurCount
				enableit:SetScript("OnShow", onshow_spell("enabled"))
				enableit:SetScript("OnClick", onchange_spell("enabled"))
				enableit:SetPoint("LEFT", cooldown, "RIGHT", 5, 0)

				getadditionalid:ClearAllPoints()
				getadditionalid:SetPoint("RIGHT", spellid, "LEFT", -15, 0)
				area.frame:SetHeight( area.frame:GetHeight() + 35 )
				area.frame:GetParent():SetHeight( area.frame:GetParent():GetHeight() + 35 )

				panel:SetMyOwnHeight()
				if DBM_GUI_OptionsFramePanelContainer.displayedFrame and CurCount > 1 then
					DBM_GUI_OptionsFrame:DisplayFrame(panel.frame)
				end

				getadditionalid:SetScript("OnClick", function()
					if spellid:GetNumber() > 0 and bartext:GetText():len() > 0 and cooldown:GetNumber() > 0 then
						createnewentry()
					else
						DBM:AddMsg(L.Error_FillUp)
					end
				end)
			end

			if #settings.spells == 0 then
				createnewentry()
			else
				for i=1, #settings.spells, 1 do
					createnewentry()
				end
			end
		end
		panel:SetMyOwnHeight()
	end
	DBM:RegisterOnGuiLoadCallback(creategui, 19)
end


do
	function addDefaultOptions(t1, t2)
		for i, v in pairs(t2) do
			if t1[i] == nil then
				t1[i] = v
			elseif type(v) == "table" and type(t1[i]) == "table" then
				addDefaultOptions(t1[i], v)
			end
		end
	end

	function clearAllSpellBars()
		for k,v in pairs(SpellBarIndex) do
		   SpellBars:CancelBar(k)
		   SpellBarIndex[k] = nil
		end
	end

	local myportals = {}
	local lastmsg = "";
	local encounterStarted = false
	local mainframe = CreateFrame("frame", "DBM_SpellTimers", UIParent)
	local spellEvents = {
	  ["SPELL_CAST_SUCCESS"] = true,
	  ["SPELL_RESURRECT"] = true,
	  ["SPELL_HEAL"] = true,
	  ["SPELL_AURA_APPLIED"] = true,
	  ["SPELL_AURA_REFRESH"] = true,
	}
	mainframe:SetScript("OnEvent", function(self, event, ...)
		if event == "ADDON_LOADED" and select(1, ...) == "DBM-SpellTimers" then
			self:UnregisterEvent("ADDON_LOADED")
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
			self:RegisterEvent("ENCOUNTER_START")
			self:RegisterEvent("ENCOUNTER_END")

			-- Update settings of this Addon
			settings = DBM_SpellTimers_Settings
			addDefaultOptions(settings, default_settings)

			-- CreateBarObject
			--[[ hmm, damm mass options. this sucks!
			if settings.own_bargroup then
				SpellBars = DBT:New()
				print_t(SpellBars.options)
				addDefaultOptions(SpellBars.options, DBM.Bars.options)
			else
				SpellBars = DBM.Bars
			end --]]
			SpellBars = DBM.Bars


			if UnitFactionGroup("player") == "Alliance" then
				myportals = settings.portal_alliance
			else
				myportals = settings.portal_horde
			end

			for k,v in pairs(settings.spells) do
				if v.enabled == nil then
					v.enabled = true
				end
				if v.spell == 48477 then -- upgrade legacy spellIds
					v.spell = 20484
				end
			end

			rebuildSpellIDIndex()
		elseif settings.enabled and event == "ENCOUNTER_START" then--Encounter Started
			clearAllSpellBars()
			--Reset all CDs that are >= 3 minutes EXCEPT shaman reincarnate (20608)
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif settings.enabled and event == "ENCOUNTER_END" then--Encounter Ended
			--Reset all CDs that are > 3 minutes EXCEPT shaman reincarnate (20608)
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		elseif settings.enabled and event == "PLAYER_ENTERING_BATTLEGROUND" then
		  -- spell cooldowns all reset on entering an arena or bg
		  clearAllSpellBars()
		elseif settings.enabled and event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local _, event, _, _, sourceName, _, _, _, destName, _, _, extraArg1, extraArg2 = CombatLogGetCurrentEventInfo()
			if spellEvents[event] then
				-- first some exeptions (we don't want to see any skill around the world)
				if settings.only_from_raid and not IsInRaid() then return end
				if not settings.active_in_pvp and (select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "arena") then return end

				local fromplayer = sourceName
				local toplayer = destName		-- Added by Florin Patan
				local spellid = extraArg1

				-- now we filter if cast is from outside raidgrp (we don't want to see mass spam in Dalaran/...)
				if settings.only_from_raid and not DBM:GetRaidUnitId(fromplayer) then return end

				guikey = SpellIDIndex[spellid]
				v = (guikey and settings.spells[guikey])
				if v and v.enabled == true then
					if v.spell ~= spellid then
						print("DBM-SpellTimers Index mismatch error! "..guikey.." "..spellid)
					end
					local spellinfo = extraArg2
					local icon = GetSpellTexture(spellid)
					spellinfo = spellinfo or "UNKNOWN SPELL"
					fromplayer = fromplayer or "UNKNOWN SOURCE"
					toplayer = toplayer or "UNKNOWN TARGET"
					local bartext = v.bartext:gsub("%%spell", spellinfo):gsub("%%player", fromplayer):gsub("%%target", toplayer)	-- Changed by Florin Patan
					SpellBarIndex[bartext] = SpellBars:CreateBar(v.cooldown, bartext, icon, nil, true)

					if settings.showlocal then
						local msg =  L.Local_CastMessage:format(bartext)
						if not lastmsg or lastmsg ~= msg then
							DBM:AddMsg(msg)
							lastmsg = msg
						end
					end
				end
			elseif settings.show_portal and event == "SPELL_CREATE" then
				if settings.only_from_raid and not IsInRaid() then return end

				local fromplayer = sourceName
				local toplayer = destName		-- Added by Florin Patan
				local spellid = extraArg1

				if settings.only_from_raid and DBM:GetRaidUnitId(fromplayer) == "none" then return end

				for k,v in pairs(myportals) do
					if v.spell == spellid then
						local spellinfo = extraArg2
						local icon = GetSpellTexture(spellid)
						local bartext = v.bartext:gsub("%%spell", spellinfo):gsub("%%player", fromplayer):gsub("%%target", toplayer)	-- Changed by Florin Patan
						SpellBarIndex[bartext] = SpellBars:CreateBar(v.cooldown, bartext, icon, nil, true)

						if settings.showlocal then
							local msg =  L.Local_CastMessage:format(bartext)
							if not lastmsg or lastmsg ~= msg then
								DBM:AddMsg(msg)
								lastmsg = msg
							end
						end
					end
				end
			end
		end
	end)
	mainframe:RegisterEvent("ADDON_LOADED")
end
