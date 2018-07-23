--------------------------------------------------------------------------
-- GTFO_Skada.lua 
--------------------------------------------------------------------------
--[[
GTFO & Skada Integration
Author: Zensunim of Malygos

Change Log:
	v4.6
		- Added Skada Integration
	v4.8.5
		- Fixed bug
	v4.8.6
		- Fixed bug (better fix!)
	v4.9.1
		- Fixed bug
	v4.9.2
		- Fixed the root cause bug (which actually fixes all the previous "bugs")
	v4.12.2
		- Fixed bug

]]--

function GTFO_Skada()
	local L = LibStub("AceLocale-3.0"):GetLocale("Skada");
	local mod = Skada:NewModule(GTFOLocal.Recount_Name);
	local playermod = Skada:NewModule(GTFOLocal.Skada_AlertList);
	local alertmod = Skada:NewModule(GTFOLocal.Skada_SpellList);
	
	L["Alerts"] = GTFOLocal.Skada_Category;
	
	local function log_alert(set, alert)
		-- Get the player.
		local player = Skada:get_player(set, alert.playerID, alert.playerName);
		if player then
			set.alertCount = (set.alertCount or 0) + 1;
			player.alertCount = (player.alertCount or 0) + 1;
			
			if not player.alert then
				player.alert = { };
			end
			
			if not player.alert[alert.alertID] then
				player.alert[alert.alertID] = {
					name = alert.alertID,
					alertCount = 0,
					alertDamage = 0,
					spell = { }
				};
			end
			
			player.alert[alert.alertID].alertCount = player.alert[alert.alertID].alertCount + 1;
			player.alert[alert.alertID].alertDamage = player.alert[alert.alertID].alertDamage + alert.damage;
			
			-- Also add to set total damage.
			set.alertDamage = (set.alertDamage or 0) + alert.damage;
			player.alertDamage = (player.alertDamage or 0) + alert.damage;
			
			-- Add spell to player if it does not exist.
			if not player.alert[alert.alertID].spell[alert.spellName] then
				player.alert[alert.alertID].spell[alert.spellName] = {
						id = alert.spellID, 
						alertID = alert.alertID,
						alertCount = 0, 
						alertDamage = 0,
				};
			end
   		
			-- Get the spell from player.
			local spell = player.alert[alert.alertID].spell[alert.spellName];
			spell.alertCount = spell.alertCount + 1;
			spell.alertDamage = spell.alertDamage + alert.damage;
			if spell.max == nil or alert.damage > spell.max then
				spell.max = alert.damage;
			end
			if (spell.min == nil or alert.damage < spell.min) then
				spell.min = alert.damage;
			end
		end
	end
	
	-- Alert overview.
	function mod:Update(win, set)
		-- Max value.
		local max = 0
		
		local nr = 1
		for i, player in ipairs(set.players) do
			if player.alertCount and player.alertCount > 0 then
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d
				d.label = player.name
				d.valuetext = Skada:FormatValueText(
												Skada:FormatNumber(player.alertDamage), self.metadata.columns.Damage, 
												player.alertCount, self.metadata.columns.Alerts
											)
				d.value = player.alertDamage
				d.id = player.id
				d.class = player.class
				if player.alertDamage > max then
					max = player.alertDamage
				end
				nr = nr + 1
			end
		end
		win.metadata.maxvalue = max
	end
	
	function playermod:Enter(win, id, label)
		local player = Skada:find_player(win:get_selected_set(), id)
		playermod.playerid = id
		playermod.title = player.name..L["'s "].." "..GTFOLocal.Recount_Name
	end
	
	-- Detail view of a player.
	function playermod:Update(win, set)
		-- View spells for this player.
			
		local player = Skada:find_player(set, self.playerid)
		local max = 0
		
		-- If we reset we have no data.
		if player then
			
			local nr = 1
			if player then
				for alertID, alert in pairs(player.alert) do
					if (alert.alertCount > 0) then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d
						d.label = alert.name
						d.id = alertID
						d.icon = GTFO_GetAlertIcon(GTFO_GetAlertByID(alertID))
						d.value = alert.alertDamage
						d.valuetext = Skada:FormatValueText(
														Skada:FormatNumber(alert.alertDamage), self.metadata.columns.Damage,
														alert.alertCount, self.metadata.columns.Alerts,
														string.format("%02.1f%%", alert.alertDamage / player.alertDamage * 100), self.metadata.columns.Percent
													)
						if alert.alertDamage > max then
							max = alert.alertDamage
						end
						nr = nr + 1
					end
				end
			end
		end
		
		win.metadata.maxvalue = max
	end
	
	
	function alertmod:Enter(win, id, label)
		local player = Skada:find_player(win:get_selected_set(), playermod.playerid)
		alertmod.playerid = playermod.playerid;
		alertmod.alertType = label;
		alertmod.title = player.name..L["'s "]..alertmod.alertType.." "..GTFOLocal.Recount_Name;
	end
	
	function alertmod:Update(win, set)
		local player = Skada:find_player(set,alertmod.playerid)
		local max = 0;

		if player then
			local alert = player.alert[alertmod.alertType];
			if alert then
				local nr = 1
				for spellName, spell in pairs(alert.spell) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d
					d.label = spellName
					d.id = spellName
					if (spell.id and spell.id > 0) then
						d.icon = select(3, GetSpellInfo(spell.id))
					else
						d.icon = "Interface\\Icons\\Spell_Fire_Fire";
					end
					d.value = spell.alertDamage
					d.valuetext = Skada:FormatValueText(
													Skada:FormatNumber(spell.alertDamage), self.metadata.columns.Damage,
													spell.alertCount, self.metadata.columns.Alerts,
													string.format("%02.1f%%", spell.alertDamage / player.alertDamage * 100), self.metadata.columns.Percent
												)
					if spell.alertDamage > max then
						max = spell.alertDamage
					end
					nr = nr + 1
				end
			end
		end

		win.metadata.maxvalue = max
	end

	local function spell_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), alertmod.playerid)
		if player then
			local spell = player.alert[alertmod.alertType].spell[label];
			if spell then
				tooltip:AddLine(player.name.." - "..label)
				if spell.max and spell.min then
					tooltip:AddDoubleLine(L["Minimum hit:"], Skada:FormatNumber(spell.min), 255,255,255,255,255,255)
					tooltip:AddDoubleLine(L["Maximum hit:"], Skada:FormatNumber(spell.max), 255,255,255,255,255,255)
				end
				tooltip:AddDoubleLine(L["Average hit:"], Skada:FormatNumber(spell.alertDamage / spell.alertCount), 255,255,255,255,255,255)
			end
		end
	end
	
	function mod:OnEnable()
		mod.metadata = {
			showspots = true, 
			click1 = playermod,
			columns = {Damage = true, Alerts = true}
		};
		playermod.metadata = {
			showspots = true, 
			click1 = alertmod, 
			columns = {Damage = true, Alerts = true, Percent = true}
		};
		alertmod.metadata = {
			tooltip = spell_tooltip, 
			columns = {Damage = true, Alerts = true, Percent = true}
		};
		
		Skada:AddMode(self)
	end
	
	function mod:OnDisable()
		Skada:RemoveMode(self)
	end
	
	function mod:AddToTooltip(set, tooltip)
	 	GameTooltip:AddDoubleLine(GTFOLocal.Recount_Name, set.alertCount, 1,1,1)
	end
	
	function mod:GetSetSummary(set)
		return Skada:FormatNumber(set.alertDamage).." ("..set.alertCount..")";
	end
	
	-- Called by Skada when a new player is added to a set.
	function mod:AddPlayerAttributes(player)
		if not player.alertCount then
			player.alertCount = 0;
			player.alert = { };
			player.alertDamage = 0;
		end
	end
	
	-- Called by Skada when a new set is created.
	function mod:AddSetAttributes(set)
		if not set.alertCount then
			set.alertCount = 0;
			set.alertDamage = 0;
		end
	end

	function GTFO_RecordSkada(sourceName, sourceID, alertID, spellID, spellName, damage)
	  local alert = {
	  	alertID = GTFO_GetAlertType(alertID),
	  	damage = damage,
	  	spellID = spellID,
	  	spellName = spellName,
	  	playerID = sourceID,
	  	playerName = sourceName
	  };
	
		if (alert.alertID) then
			if (Skada.current) then
				log_alert(Skada.current, alert);
			end
			if (Skada.total) then
				log_alert(Skada.total, alert);
			end
		end
	end

	GTFO_DebugPrint("Skada integration loaded.");
	
	return true;	
end

