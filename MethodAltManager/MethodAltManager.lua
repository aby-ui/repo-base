
local addon, AltManager = ...;

_G["AltManager"] = AltManager;

-- Made by: Qooning - Tarren Mill <Method>, 2017-2019
-- updates for Bfa by: Kabootzey - Tarren Mill <Ended Careers>, 2018
-- Last edit: 07/09/2019

local Dialog = LibStub("LibDialog-1.0")

--local sizey = 200;
local sizey = 315;
local instances_y_add = 85;
local xoffset = 0;
local yoffset = 150;
local alpha = 1;
--local addon = "MethodAltManager";
local numel = table.getn;

local per_alt_x = 120;
local ilvl_text_size = 8;
local remove_button_size = 12;

local min_x_size = 300;

local min_level = 120;
local name_label = "" -- Name
local mythic_done_label = "大米层数"
local mythic_keystone_label = "大米钥匙"
local seals_owned_label = "持有Roll币"
local seals_bought_label = "本周Roll币"
local vessels_of_horrific_visions_label = "大幻象法器"
local artifact_reaserch_label = "AK level"
local coalescing_visions_label = "凝结幻象"
local mementos_label = "腐化纪念品"
local artifact_research_time_label = "Next level in"
local depleted_label = "Depleted"
local nightbane_label = "Nightbane"
local resources_label = "战争物资"
local worldboss_label = "Worldboss"
local conquest_label = "征服点数"
local islands_label = "海岛探险"
local pearls_label = "Manapearls"
local neck_label = "Neck level"
local residuum_label = "泰坦残血精华"

local VERSION = "1.6.0"

-- if Blizzard keeps supporting old api, get the IDs from
-- C_ChallengeMode.GetMapTable() and names from C_ChallengeMode.GetMapUIInfo(id)
local dungeons = {
	-- BFA
	[244] = "阿塔",
	[245] = "自由",
	[246] = "监狱",
	[247] = "暴富",
	[248] = "庄园",
	[249] = "诸王",
	[250] = "神庙",
	[251] = "孢林",
	[252] = "风暴",
	[353] = "围攻",
	[369] = "麦上",
	[370] = "麦下",
 };


SLASH_METHODALTMANAGER1 = "/mam";
SLASH_METHODALTMANAGER2 = "/alts";

local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function true_numel(t)
	local c = 0
	for k, v in pairs(t) do c = c + 1 end
	return c
end

function SlashCmdList.METHODALTMANAGER(cmd, editbox)
	local rqst, arg = strsplit(' ', cmd)
	if rqst == "help" then
		print("Method Alt Manager help:")
		print("   \"/alts purge\" to remove all stored data.")
		print("   \"/alts remove name\" to remove characters by name.")
	elseif rqst == "purge" then
		AltManager:Purge();
	elseif rqst == "remove" then
		AltManager:RemoveCharactersByName(arg)
	else
		AltManager:ShowInterface();
	end
end

function list_items()
	a = {}
	for i = 1,200000 do
		local n = GetItemInfo(i)
		if n ~= nil  then
			print(n)
			table.insert(a, n)
		end
	end
end

do
	local main_frame = CreateFrame("frame", "AltManagerFrame", UIParent);
	AltManager.main_frame = main_frame;
	main_frame:SetFrameStrata("MEDIUM");
	main_frame.background = main_frame:CreateTexture(nil, "BACKGROUND");
	main_frame.background:SetAllPoints();
	main_frame.background:SetDrawLayer("ARTWORK", 1);
	main_frame.background:SetColorTexture(0, 0, 0, 0.5);
	
	-- main_frame.scan_tooltip = CreateFrame('GameTooltip', 'DepletedTooltipScan', UIParent, 'GameTooltipTemplate');
	

	-- Set frame position
	main_frame:ClearAllPoints();
	main_frame:SetPoint("CENTER", UIParent, "CENTER", xoffset, yoffset);
	
	main_frame:RegisterEvent("ADDON_LOADED");
	main_frame:RegisterEvent("PLAYER_LOGIN");
	main_frame:RegisterEvent("PLAYER_LOGOUT");
	main_frame:RegisterEvent("QUEST_TURNED_IN");
	main_frame:RegisterEvent("BAG_UPDATE_DELAYED");
	main_frame:RegisterEvent("ARTIFACT_XP_UPDATE");
	main_frame:RegisterEvent("CHAT_MSG_CURRENCY");
	main_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
  	main_frame:RegisterEvent("PLAYER_LEAVING_WORLD");
	

	main_frame:SetScript("OnEvent", function(self, ...)
		local event, loaded = ...;
		if event == "ADDON_LOADED" then
			if addon == loaded then
      			AltManager:OnLoad();
			end
		end
		if event == "PLAYER_LOGIN" then
        	AltManager:OnLogin();
		end
		if event == "PLAYER_LEAVING_WORLD" or event == "ARTIFACT_XP_UPDATE" then
			local data = AltManager:CollectData(false);
			AltManager:StoreData(data);
		end
		if (event == "BAG_UPDATE_DELAYED" or event == "QUEST_TURNED_IN" or event == "CHAT_MSG_CURRENCY" or event == "CURRENCY_DISPLAY_UPDATE") and AltManager.addon_loaded then
			local data = AltManager:CollectData(false);
			AltManager:StoreData(data);
		end
		
	end)
	
	-- Show Frame
	main_frame:Hide();
end

function AltManager:InitDB()
	local t = {};
	t.alts = 0;
	t.data = {};
	return t;
end

function AltManager:CalculateXSizeNoGuidCheck()
	local alts = MethodAltManagerDB.alts;
	return max((alts + 1) * per_alt_x, min_x_size)
end

function AltManager:CalculateXSize()
	-- local alts = MethodAltManagerDB.alts;
	-- -- HACK: DUE TO THE LOGIN DATA GLITCH, I HAVE TO CHECK IF CURRENT ALT IS NEW
	-- local guid = UnitGUID('player');
	-- if MethodAltManagerDB.data[guid] == nil then alts = alts + 1 end
	-- return max((alts + 1) * per_alt_x, min_x_size)
	return self:CalculateXSizeNoGuidCheck()
end

-- because of guid...
function AltManager:OnLogin()
	self:ValidateReset();
	self:StoreData(self:CollectData());
  
	self.main_frame:SetSize(self:CalculateXSize(), sizey);
	self.main_frame.background:SetAllPoints();
	
	-- Create menus
	AltManager:CreateContent();
	AltManager:MakeTopBottomTextures(self.main_frame);
	AltManager:MakeBorder(self.main_frame, 5);
end

function AltManager:OnLoad()
	self.main_frame:UnregisterEvent("ADDON_LOADED");
	
	MethodAltManagerDB = MethodAltManagerDB or self:InitDB();

	if MethodAltManagerDB.alts ~= true_numel(MethodAltManagerDB.data) then
		print("Altcount inconsistent, using", true_numel(MethodAltManagerDB.data))
		MethodAltManagerDB.alts = true_numel(MethodAltManagerDB.data)
	end

	self.addon_loaded = true
	C_MythicPlus.RequestRewards();
	C_MythicPlus.RequestCurrentAffixes();
	C_MythicPlus.RequestMapInfo();
	for k,v in pairs(dungeons) do
		-- request info in advance
		C_MythicPlus.RequestMapInfo(k);
	end
end

function AltManager:CreateFontFrame(parent, x_size, height, relative_to, y_offset, label, justify)
	local f = CreateFrame("Button", nil, parent);
	f:SetSize(x_size, height);
	f:SetNormalFontObject(GameFontHighlightSmall)
	f:SetText(label)
	f:SetPoint("TOPLEFT", relative_to, "TOPLEFT", 0, y_offset);
	f:GetFontString():SetJustifyH(justify);
	f:GetFontString():SetJustifyV("CENTER");
	f:SetPushedTextOffset(0, 0);
	f:GetFontString():SetWidth(120)
	f:GetFontString():SetHeight(20)
	
	return f;
end

function AltManager:Keyset()
	local keyset = {}
	if MethodAltManagerDB and MethodAltManagerDB.data then
		for k in pairs(MethodAltManagerDB.data) do
			table.insert(keyset, k)
		end
	end
	return keyset
end

function AltManager:ValidateReset()
	local db = MethodAltManagerDB
	if not db then return end;
	if not db.data then return end;
	
	local keyset = {}
	for k in pairs(db.data) do
		table.insert(keyset, k)
	end
	
	for alt = 1, db.alts do
		local expiry = db.data[keyset[alt]].expires or 0;
		local char_table = db.data[keyset[alt]];
		if time() > expiry then
			-- reset this alt
			char_table.seals_bought = 0;
			char_table.dungeon = "Unknown";
			char_table.level = "?";
			char_table.highest_mplus = 0;
			char_table.is_depleted = false;
			char_table.expires = self:GetNextWeeklyResetTime();
			char_table.worldboss = "-";
			
			char_table.islands = 0;
			char_table.islands_finished = false;
			
			char_table.conquest = 0;
			char_table.uldir_normal = 0;
			char_table.uldir_heroic = 0;
			char_table.uldir_mythic = 0;

			char_table.bod_normal = 0;
			char_table.bod_heroic = 0;
			char_table.bod_mythic = 0;

			char_table.ep_normal = 0;
			char_table.ep_heroic = 0;
			char_table.ep_mythic = 0;

			char_table.nyalotha_normal = 0;
			char_table.nyalotha_heroic = 0;
			char_table.nyalotha_mythic = 0;

		end
	end
end

function AltManager:Purge()
	MethodAltManagerDB = self:InitDB();
end

function AltManager:RemoveCharactersByName(name)
	local db = MethodAltManagerDB;

	local indices = {};
	for guid, data in pairs(db.data) do
		if db.data[guid].name == name then
			indices[#indices+1] = guid
		end
	end

	db.alts = db.alts - #indices;
	for i = 1,#indices do
		db.data[indices[i]] = nil
	end

	print("Found " .. (#indices) .. " characters by the name of " .. name)
	print("Please reload ui to update the displayed info.")

	-- things wont be redrawn
end

function AltManager:RemoveCharacterByGuid(index)
	local db = MethodAltManagerDB;

	if db.data[index] == nil then return end

	local name = db.data[index].name
	Dialog:Register("AltManagerRemoveCharacterDialog", {
		text = "Are you sure you want to remove " .. name .. " from the list?",
		width = 500,
		on_show = function(self, data) 
		end,
		buttons = {
			{ text = "Delete", 
			  on_click = function()
					if db.data[index] == nil then return end
					db.alts = db.alts - 1;
					db.data[index] = nil
					-- print("Deleting character guid", index)
					self.main_frame:SetSize(self:CalculateXSizeNoGuidCheck(), sizey);
					if self.main_frame.alt_columns ~= nil then
						-- Hide the last col
						-- find the correct frame to hide
						local count = #self.main_frame.alt_columns
						for j = 0,count-1 do
							if self.main_frame.alt_columns[count-j]:IsShown() then
								self.main_frame.alt_columns[count-j]:Hide()
								-- also for instances
								if self.instances_unroll ~= nil and self.instances_unroll.alt_columns ~= nil and self.instances_unroll.alt_columns[count-j] ~= nil then
									self.instances_unroll.alt_columns[count-j]:Hide()
								end
								break
							end
						end
						
						-- and hide the remove button
						if self.main_frame.remove_buttons ~= nil and self.main_frame.remove_buttons[index] ~= nil then
							self.main_frame.remove_buttons[index]:Hide()
						end
					end
					self:UpdateStrings()
					-- it's not simple to update the instances text with current design, so hide it and let the click do update
					if self.instances_unroll ~= nil and self.instances_unroll.state == "open" then
						self:CloseInstancesUnroll()
						self.instances_unroll.state = "closed";
					end
				end},
			{ text = "Cancel", }
		},	
		show_while_dead = true,
		hide_on_escape = true,
	})
	if Dialog:ActiveDialog("AltManagerRemoveCharacterDialog") then
		Dialog:Dismiss("AltManagerRemoveCharacterDialog")
	end
	Dialog:Spawn("AltManagerRemoveCharacterDialog", {string = string})

end

local get_current_questline_quest = QuestUtils_GetCurrentQuestLineQuest

-- function QuestUtils_GetCurrentQuestLineQuest(questLineID)
-- 	local quests = C_QuestLine.GetQuestLineQuests(questLineID);
-- 	local currentQuestID = 0;
-- 	for i, questID in ipairs(quests) do
-- 		if C_QuestLog.IsOnQuest(questID) then
-- 			currentQuestID = questID;
-- 			break;
-- 		end
-- 	end
-- 	return currentQuestID;
-- end

function getConquestCap()
    local CONQUEST_QUESTLINE_ID = 782;
    local currentQuestID = get_current_questline_quest(CONQUEST_QUESTLINE_ID);

    -- if not on a current quest that means all caught up for this week
    if currentQuestID == 0 then
        return 0, 0, 0;
    end

    if not HaveQuestData(currentQuestID) then
        return 0, 0, nil;
    end

    local objectives = C_QuestLog.GetQuestObjectives(currentQuestID);
    if not objectives or not objectives[1] then
        return 0, 0, nil;
    end

    return objectives[1].numFulfilled, objectives[1].numRequired, currentQuestID;
end

function AltManager:StoreData(data)

	if not self.addon_loaded then
		return
	end

	-- This can happen shortly after logging in, the game doesn't know the characters guid yet
	if not data or not data.guid then
		return
	end

	if UnitLevel('player') < min_level then return end;
	
	local db = MethodAltManagerDB;
	local guid = data.guid;
	
	db.data = db.data or {};
	
	local update = false;
	for k, v in pairs(db.data) do
		if k == guid then
			update = true;
		end
	end
	
	if not update then
		db.data[guid] = data;
		db.alts = db.alts + 1;
	else
		local lvl = db.data[guid].artifact_level;
		data.artifact_level = data.artifact_level or lvl;
		db.data[guid] = data;
	end
end

function AltManager:CollectData(do_artifact)
	
	if UnitLevel('player') < min_level then return end;
	-- this is an awful hack that will probably have some unforeseen consequences,
	-- but Blizzard fucked something up with systems on logout, so let's see how it
	-- goes.
	_, i = GetAverageItemLevel()
	if i == 0 then return end;

	-- fix this when i'm not on a laptop at work
	do_artifact = false
	
	local name = UnitName('player')
	local _, class = UnitClass('player')
	local dungeon = nil;
	local expire = nil;
	local level = nil;
	local seals = nil;
	local coalescing_visions = 0;
	local seals_bought = nil;
	local artifact_level = nil;
	local next_research = nil;
	local highest_mplus = 0;
	local depleted = false;
	local vessels = 0

	local guid = UnitGUID('player');

	local mine_old = nil
	if MethodAltManagerDB and MethodAltManagerDB.data then
		mine_old = MethodAltManagerDB.data[guid];
	end
	
	C_MythicPlus.RequestRewards();
	-- try the new api
	highest_mplus = C_MythicPlus.GetWeeklyChestRewardLevel()
	
	--[[for k,v in pairs(dungeons) do
		C_MythicPlus.RequestMapInfo(k);
		-- there is a problem with relogging and retaining old value :(
		local _, l = C_MythicPlus.GetWeeklyBestForMap(k);
		if l and l > highest_mplus then
			highest_mplus = l;
		end
	end ]]--
	
	-- find keystone
	local keystone_found = false;
	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do
			local _, _, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
			-- print(slotLink)
			--if slotItemID then print(slotItemID, GetItemInfo(slotItemID)) end
			
			--	might as well check if the item is a vessel of horrific vision
			if slotItemID == 173363 then
				vessels = vessels + 1
			end
			if slotItemID == 158923 then
				local itemString = slotLink:match("|Hkeystone:([0-9:]+)|h(%b[])|h")
				local info = { strsplit(":", itemString) }
				dungeon = tonumber(info[2])
				if not dungeon then dungeon = nil end
				level = tonumber(info[3])
				if not level then level = nil end
				expire = tonumber(info[4])
				keystone_found = true;
			end
		end
	end
  
  -- nice idea, but these functions return weird values on login and logout
  --dungeon = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
  --level = C_MythicPlus.GetOwnedKeystoneLevel()
  
  --if dungeon then keystone_found = true end
  
	if not keystone_found then
		dungeon = "Unknown";
		level = "?"
	end
	
	if do_artifact and HasArtifactEquipped() then
		if not ArtifactFrame then
			LoadAddOn("Blizzard_ArtifactUI");
		end
		-- open artifact
		local is_open = ArtifactFrame:IsShown();
		if (not ArtifactFrame or not ArtifactFrame:IsShown()) then
			SocketInventoryItem(INVSLOT_MAINHAND);
		end
		artifact_level = C_ArtifactUI.GetArtifactKnowledgeLevel()
		-- close artifact
		if not is_open and ArtifactFrame and ArtifactFrame:IsShown() and C_ArtifactUI.IsViewedArtifactEquipped() then
			C_ArtifactUI.Clear();
		end
	end

	-- order resources
	local _, order_resources = GetCurrencyInfo(1560);

	
	local shipments = C_Garrison.GetLooseShipments(LE_GARRISON_TYPE_7_0)
	local creation_time = nil
	local duration = nil
	local num_ready = nil
	local num_total = nil
	local found_research = false
	
	--[[for i = 1, #shipments do
		local name, _, _, numReady, numTotal, creationTime, duration_l = C_Garrison.GetLandingPageShipmentInfoByContainerID(shipments[i])
		
		if name == GetItemInfo(139390) then		-- the name must be "Artifact Research Notes"
			found_research = true;
			creation_time = creationTime
			duration = duration_l
			num_ready = numReady
			num_total = numTotal
		end
	end ]]--
	
	
	if found_research and num_ready == 0 then
		local remaining = (creation_time + duration) - time();
			if (remaining < 0) then		-- next shipment is ready
			num_ready = num_ready + 1
			if num_ready > num_total then	-- prevent overflow
				num_ready = num_total
			end
			remaining = 0
		end
		next_research = creation_time + duration
	else
		next_research = 0;
	end
	
	_, seals = GetCurrencyInfo(1580);
	_, coalescing_visions = GetCurrencyInfo(1755);
	
	seals_bought = 0
	local gold_1 = IsQuestFlaggedCompleted(52834)
	if gold_1 then seals_bought = seals_bought + 1 end
	local gold_2 = IsQuestFlaggedCompleted(52838)
	if gold_2 then seals_bought = seals_bought + 1 end
	local resources_1 = IsQuestFlaggedCompleted(52837)
	if resources_1 then seals_bought = seals_bought + 1 end
	local resources_2 = IsQuestFlaggedCompleted(52840)
	if resources_2 then seals_bought = seals_bought + 1 end
	local marks_1 = IsQuestFlaggedCompleted(52835)
	if marks_1 then seals_bought = seals_bought + 1 end
	local marks_2 = IsQuestFlaggedCompleted(52839)
	if marks_2 then seals_bought = seals_bought + 1 end
	
	
	local class_hall_seal = IsQuestFlaggedCompleted(43510)
	if class_hall_seal then seals_bought = seals_bought + 1 end
	
	local uldir_lfr, uldir_normal, uldir_heroic, uldir_mythic = 0;

	local saves = GetNumSavedInstances();
	local normal_difficulty = 14
	local heroic_difficulty = 15
	local mythic_difficulty = 16
	for i = 1, saves do
		local name, _, reset, difficulty, _, _, _, _, _, _, bosses, killed_bosses = GetSavedInstanceInfo(i);

		-- check for raids
		if name == C_Map.GetMapInfo(1148).name and reset > 0 then
			if difficulty == normal_difficulty then uldir_normal = killed_bosses end
			if difficulty == heroic_difficulty then uldir_heroic = killed_bosses end
			if difficulty == mythic_difficulty then uldir_mythic = killed_bosses end
		end
		if name == C_Map.GetMapInfo(1352).name and reset > 0 then
			if difficulty == normal_difficulty then bod_normal = killed_bosses end
			if difficulty == heroic_difficulty then bod_heroic = killed_bosses end
			if difficulty == mythic_difficulty then bod_mythic = killed_bosses end
		end
		if name == C_Map.GetMapInfo(1512).name and reset > 0 then
			if difficulty == normal_difficulty then ep_normal = killed_bosses end
			if difficulty == heroic_difficulty then ep_heroic = killed_bosses end
			if difficulty == mythic_difficulty then ep_mythic = killed_bosses end
		end
		-- hack that may not work for other localizations
		-- I can't find any reference to the full name in the API, but the saved info returns the full name
		local nyalotha_lfg_name = GetLFGDungeonInfo(2033)
		if name == nyalotha_lfg_name and reset > 0 then -- is it okay to use any Nyalotha id? 2217
			if difficulty == normal_difficulty then nyalotha_normal = killed_bosses end
			if difficulty == heroic_difficulty then nyalotha_heroic = killed_bosses end
			if difficulty == mythic_difficulty then nyalotha_mythic = killed_bosses end
		end
	end
	
	-- Can find map info quickly like this
	-- /run for i=1,GetNumSavedInstances() do print(GetSavedInstanceInfo(i)) end
	-- /run for i=0,20000 do if C_Map.GetMapInfo(i) then if C_Map.GetMapInfo(i).name == "Ny'alotha, the Waking City" then print(i) end end end
	-- /run for i=2000,2400 do if GetLFGDungeonInfo(i) then print(i, GetLFGDungeonInfo(i)) end end 

	local worldbossquests = {
		[52181] = "T'zane", 
		[52169] = "Dunegorger Kraulok",
		[52166] = "Warbringer Yenajz",
		[52163] = "Azurethos",
		[52157] = "Hailstone Construct",
		[52196]  = "Ji'arak"
	}
	local worldboss = "-"
	for k,v in pairs(worldbossquests)do
		if IsQuestFlaggedCompleted(k) then
			
			worldboss = v 
		end
	end
	
	local conquest = getConquestCap()
	
	local _, _, _, islands, _ = GetQuestObjectiveInfo(C_IslandsQueue.GetIslandsWeeklyQuestID(), 1, false);
	local islands_finished = IsQuestFlaggedCompleted(C_IslandsQueue.GetIslandsWeeklyQuestID())

	
	local _, ilevel = GetAverageItemLevel();

	local _, pearls = GetCurrencyInfo(1721);
	local _, residuum = GetCurrencyInfo(1718);
	local _, corrupted_mementos = GetCurrencyInfo(1719); -- jebaited with 1744 id, which is probably the "in vision" currency

	-- /run for i=0,20000 do n,a = GetCurrencyInfo(i); if a == 1365 then print(i) end end

	local location = C_AzeriteItem.FindActiveAzeriteItem()
	local neck_level
	if not location then neck_level = 0
	else neck_level = C_AzeriteItem.GetPowerLevel(location)
	end

	-- store data into a table

	local char_table = {}
	
	char_table.guid = UnitGUID('player');
	char_table.name = name;
	char_table.class = class;
	char_table.ilevel = ilevel;
	char_table.seals = seals;
	char_table.seals_bought = seals_bought;
	char_table.vessels = vessels;
	char_table.coalescing_visions = coalescing_visions;
	char_table.dungeon = dungeon;
	char_table.level = level;
	char_table.highest_mplus = highest_mplus;
	char_table.worldboss = worldboss;
	char_table.conquest = conquest;
	char_table.islands =  islands; 
	char_table.islands_finished = islands_finished;
	char_table.pearls = pearls
	char_table.residuum = residuum
	char_table.corrupted_mementos = corrupted_mementos
	char_table.neck_level = neck_level
	

	char_table.uldir_normal = uldir_normal;
	char_table.uldir_heroic = uldir_heroic;
	char_table.uldir_mythic = uldir_mythic;

	char_table.bod_normal = bod_normal;
	char_table.bod_heroic = bod_heroic;
	char_table.bod_mythic = bod_mythic;

	char_table.ep_normal = ep_normal;
	char_table.ep_heroic = ep_heroic;
	char_table.ep_mythic = ep_mythic;

	char_table.nyalotha_normal = nyalotha_normal;
	char_table.nyalotha_heroic = nyalotha_heroic;
	char_table.nyalotha_mythic = nyalotha_mythic;

	char_table.order_resources = order_resources;
	char_table.veiled_argunite = veiled_argunite;
	char_table.wakening_essence = wakening_essence;
	char_table.is_depleted = depleted;
	char_table.expires = self:GetNextWeeklyResetTime();
	
	
	return char_table;
end

function AltManager:UpdateStrings()
	local font_height = 20;
	local db = MethodAltManagerDB;
	
	local keyset = {}
	for k in pairs(db.data) do
		table.insert(keyset, k)
	end
	
	self.main_frame.alt_columns = self.main_frame.alt_columns or {};
	
	local alt = 0
	for alt_guid, alt_data in spairs(db.data, function(t, a, b) return t[a].ilevel > t[b].ilevel end) do
		alt = alt + 1
		-- create the frame to which all the fontstrings anchor
		local anchor_frame = self.main_frame.alt_columns[alt] or CreateFrame("Button", nil, self.main_frame);
		if not self.main_frame.alt_columns[alt] then
			self.main_frame.alt_columns[alt] = anchor_frame;
			self.main_frame.alt_columns[alt].guid = alt_guid
			anchor_frame:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", per_alt_x * alt, -1);
		end
		anchor_frame:SetSize(per_alt_x, sizey);
		-- init table for fontstring storage
		self.main_frame.alt_columns[alt].label_columns = self.main_frame.alt_columns[alt].label_columns or {};
		local label_columns = self.main_frame.alt_columns[alt].label_columns;
		-- create / fill fontstrings
		local i = 1;
		for column_iden, column in spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
			-- only display data with values
			if type(column.data) == "function" then
				local current_row = label_columns[i] or self:CreateFontFrame(anchor_frame, per_alt_x, column.font_height or font_height, anchor_frame, -(i - 1) * font_height, column.data(alt_data), "CENTER");
				-- insert it into storage if just created
				if not self.main_frame.alt_columns[alt].label_columns[i] then
					self.main_frame.alt_columns[alt].label_columns[i] = current_row;
				end
				if column.color then
					local color = column.color(alt_data)
					current_row:GetFontString():SetTextColor(color.r, color.g, color.b, 1);
				end
				current_row:SetText(column.data(alt_data))
				if column.font then
					current_row:GetFontString():SetFont(column.font, ilvl_text_size)
				else
					--current_row:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 14)
				end
				if column.justify then
					current_row:GetFontString():SetJustifyV(column.justify);
				end
				if column.remove_button ~= nil then
					self.main_frame.remove_buttons = self.main_frame.remove_buttons or {}
					local extra = self.main_frame.remove_buttons[alt_data.guid] or column.remove_button(alt_data)
					if self.main_frame.remove_buttons[alt_data.guid] == nil then 
						self.main_frame.remove_buttons[alt_data.guid] = extra
					end
					extra:SetParent(current_row)
					extra:SetPoint("TOPRIGHT", current_row, "TOPRIGHT", -18, 2 );
					extra:SetPoint("BOTTOMRIGHT", current_row, "TOPRIGHT", -18, -remove_button_size + 2);
					extra:SetFrameLevel(current_row:GetFrameLevel() + 1)
					extra:Show();
				end
			end
			i = i + 1
		end
		
	end
	
end

function AltManager:UpdateInstanceStrings(my_rows, font_height)
	self.instances_unroll.alt_columns = self.instances_unroll.alt_columns or {};
	local alt = 0
	local db = MethodAltManagerDB;
	for alt_guid, alt_data in spairs(db.data, function(t, a, b) return t[a].ilevel > t[b].ilevel end) do
		alt = alt + 1
		-- create the frame to which all the fontstrings anchor
		local anchor_frame = self.instances_unroll.alt_columns[alt] or CreateFrame("Button", nil, self.main_frame.alt_columns[alt]);
		if not self.instances_unroll.alt_columns[alt] then
			self.instances_unroll.alt_columns[alt] = anchor_frame;
		end
		anchor_frame:SetPoint("TOPLEFT", self.instances_unroll.unroll_frame, "TOPLEFT", per_alt_x * alt, -1);
		anchor_frame:SetSize(per_alt_x, instances_y_add);
		-- init table for fontstring storage
		self.instances_unroll.alt_columns[alt].label_columns = self.instances_unroll.alt_columns[alt].label_columns or {};
		local label_columns = self.instances_unroll.alt_columns[alt].label_columns;
		-- create / fill fontstrings
		local i = 1;
		for column_iden, column in spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
			local current_row = label_columns[i] or self:CreateFontFrame(anchor_frame, per_alt_x, column.font_height or font_height, anchor_frame, -(i - 1) * font_height, column.data(alt_data), "CENTER");
			-- insert it into storage if just created
			if not self.instances_unroll.alt_columns[alt].label_columns[i] then
				self.instances_unroll.alt_columns[alt].label_columns[i] = current_row;
			end
			current_row:SetText(column.data(alt_data)) -- fills data
			i = i + 1
		end
		-- hotfix visibility
		if anchor_frame:GetParent():IsShown() then anchor_frame:Show() else anchor_frame:Hide() end
	end
end

function AltManager:OpenInstancesUnroll(my_rows, button) 
	-- do unroll
	self.instances_unroll.unroll_frame = self.instances_unroll.unroll_frame or CreateFrame("Button", nil, self.main_frame);
	self.instances_unroll.unroll_frame:SetSize(per_alt_x, instances_y_add);
	self.instances_unroll.unroll_frame:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 4, self.main_frame.lowest_point - 10);
	self.instances_unroll.unroll_frame:Show();

	local font_height = 20;
	-- create the rows for the unroll
	if not self.instances_unroll.labels then
		self.instances_unroll.labels = {};
		local i = 1
		for row_iden, row in spairs(my_rows, function(t, a, b) return t[a].order < t[b].order end) do
			if row.label then
				local label_row = self:CreateFontFrame(self.instances_unroll.unroll_frame, per_alt_x, font_height, self.instances_unroll.unroll_frame, -(i-1)*font_height, row.label..":", "RIGHT");
				table.insert(self.instances_unroll.labels, label_row)
			end
			i = i + 1
		end
	end

	-- populate it for alts
	self:UpdateInstanceStrings(my_rows, font_height)

	-- fixup the background
	self.main_frame:SetSize(self:CalculateXSizeNoGuidCheck(), sizey + instances_y_add);
	self.main_frame.background:SetAllPoints();

end

function AltManager:CloseInstancesUnroll()
	-- do rollup
	self.main_frame:SetSize(self:CalculateXSizeNoGuidCheck(), sizey);
	self.main_frame.background:SetAllPoints();
	self.instances_unroll.unroll_frame:Hide();
	for k, v in pairs(self.instances_unroll.alt_columns) do
		v:Hide()
	end
end

function AltManager:CreateContent()

	-- Close button
	self.main_frame.closeButton = CreateFrame("Button", "CloseButton", self.main_frame, "UIPanelCloseButton");
	self.main_frame.closeButton:ClearAllPoints()
	self.main_frame.closeButton:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPRIGHT", -10, -2);
	self.main_frame.closeButton:SetScript("OnClick", function() AltManager:HideInterface(); end);
	--self.main_frame.closeButton:SetSize(32, h);

	local column_table = {
		name = {
			order = 1,
			label = name_label,
			data = function(alt_data) return alt_data.name end,
			color = function(alt_data) return RAID_CLASS_COLORS[alt_data.class] end,
		},
		ilevel = {
			order = 2,
			data = function(alt_data) return string.format("%.2f (%d)", alt_data.ilevel or 0, alt_data.neck_level or 0) end,
			justify = "TOP",
			font = "Fonts\\FRIZQT__.TTF",
			remove_button = function(alt_data) return self:CreateRemoveButton(function() AltManager:RemoveCharacterByGuid(alt_data.guid) end) end
		},
		mplus = {
			order = 3,
			label = mythic_done_label,
			data = function(alt_data) return tostring(alt_data.highest_mplus) end, 
		},
		keystone = {
			order = 4,
			label = mythic_keystone_label,
			data = function(alt_data) local depleted_string = alt_data.is_depleted and " (D)" or ""; return (dungeons[alt_data.dungeon] or alt_data.dungeon) .. " +" .. tostring(alt_data.level) .. depleted_string; end,
		},
		seals_owned = {
			order = 5,
			label = seals_owned_label,
			data = function(alt_data) return tostring(alt_data.seals) end,
		},
		seals_bought = {
			order = 6,
			label = seals_bought_label,
			data = function(alt_data) return tostring(alt_data.seals_bought) end,
		},
		fake_just_for_offset = {
			order = 6.1,
			label = "",
			data = function(alt_data) return " " end,
		},
		vessels = {
			order = 6.5,
			label = vessels_of_horrific_visions_label,
			data = function(alt_data) return tostring(alt_data.vessels or "0") end,
		},
		coalascing_visions = {
			order = 6.6,
			label = coalescing_visions_label,
			data = function(alt_data) return tostring(alt_data.coalescing_visions or "0") end,
		},
		corrupted_mementos = {
			order = 6.7,
			label = mementos_label,
			data = function(alt_data) return tostring(alt_data.corrupted_mementos or "0") end,
		},
		residuum = {
			order = 7,
			 label = residuum_label,
			data = function(alt_data) return alt_data.residuum and tostring(alt_data.residuum) or "0" end,
		},
		conquest_cap = {
			order = 8,
			label = conquest_label,
			data = function(alt_data) return (alt_data.conquest and tostring(alt_data.conquest) or "?")  .. "/" .. "500"  end,
		},
		order_resources = {
			order = 9,
			label = resources_label,
			data = function(alt_data) return alt_data.order_resources and tostring(alt_data.order_resources) or "0" end,
		},
		-- sort of became irrelevant for now
		-- pearls = {
		-- 	order = 9.5,
		-- 	label = pearls_label,
		-- 	data = function(alt_data) return alt_data.pearls and tostring(alt_data.pearls) or "0" end,
		-- },

		-- worldbosses = {
		-- 	order = 10,
		-- 	label = worldboss_label,
		-- 	data = function(alt_data) return alt_data.worldboss or "?" end,
		-- },
		islands = {
			order = 11,
			label = islands_label,
			data = function(alt_data) return (alt_data.islands_finished and "Capped") or ((alt_data.islands and tostring(alt_data.islands)) or "?") .. "/ 36K"  end,
		},
		dummy_line = {
			order = 12,
			label = " ",
			data = function(alt_data) return " " end,
		},
		raid_unroll = {
			order = 13,
			data = "unroll",
			name = "副本进度 >>",
			unroll_function = function(button, my_rows)
				self.instances_unroll = self.instances_unroll or {};
				self.instances_unroll.state = self.instances_unroll.state or "closed";
				if self.instances_unroll.state == "closed" then
					self:OpenInstancesUnroll(my_rows)
					-- update ui
					button:SetText("副本进度 <<");
					self.instances_unroll.state = "open";
				else
					self:CloseInstancesUnroll()
					-- update ui
					button:SetText("副本进度 >>");
					self.instances_unroll.state = "closed";
				end
			end,
			rows = {
				uldir = {
					order = 4,
					label = "奥迪尔",
					data = function(alt_data) return self:MakeRaidString(alt_data.uldir_normal, alt_data.uldir_heroic, alt_data.uldir_mythic) end
				},
				dazaralor = {
					order = 3,
					label = "达萨罗",
					data = function(alt_data) return self:MakeRaidString(alt_data.bod_normal, alt_data.bod_heroic, alt_data.bod_mythic) end
				},
				eternal_palace = {
					order = 2,
					label = "永恒王宫",
					data = function(alt_data) return self:MakeRaidString(alt_data.ep_normal, alt_data.ep_heroic, alt_data.ep_mythic) end
				},
				nyalotha = {
					order = 1,
					label = "尼奥罗萨",
					data = function(alt_data) return self:MakeRaidString(alt_data.nyalotha_normal, alt_data.nyalotha_heroic, alt_data.nyalotha_mythic) end
				}
			}
		}
	}
	self.columns_table = column_table;

	-- create labels and unrolls
	local font_height = 20;
	local label_column = self.main_frame.label_column or CreateFrame("Button", nil, self.main_frame);
	if not self.main_frame.label_column then self.main_frame.label_column = label_column; end
	label_column:SetSize(per_alt_x, sizey);
	label_column:SetPoint("TOPLEFT", self.main_frame, "TOPLEFT", 4, -1);

	local i = 1;
	for row_iden, row in spairs(self.columns_table, function(t, a, b) return t[a].order < t[b].order end) do
		if row.label then
			local label_row = self:CreateFontFrame(self.main_frame, per_alt_x, font_height, label_column, -(i-1)*font_height, row.label~="" and row.label..":" or " ", "RIGHT");
			self.main_frame.lowest_point = -(i-1)*font_height;
		end
		if row.data == "unroll" then
			-- create a button that will unroll it
			local unroll_button = CreateFrame("Button", "UnrollButton", self.main_frame, "UIPanelButtonTemplate");
			unroll_button:SetText(row.name);
			--unroll_button:SetFrameStrata("HIGH");
			unroll_button:SetFrameLevel(self.main_frame:GetFrameLevel() + 2)
			unroll_button:SetSize(unroll_button:GetTextWidth() + 20, 25);
			unroll_button:SetPoint("BOTTOMRIGHT", self.main_frame, "TOPLEFT", 4 + per_alt_x, -(i-1)*font_height-10);
			unroll_button:SetScript("OnClick", function() row.unroll_function(unroll_button, row.rows) end);
			self.main_frame.lowest_point = -(i-1)*font_height-10;
		end
		i = i + 1
	end

end

function AltManager:MakeRaidString(normal, heroic, mythic)
	if not normal then normal = 0 end
	if not heroic then heroic = 0 end
	if not mythic then mythic = 0 end

	local string = ""
	if mythic > 0 then string = string .. tostring(mythic) .. "M" end
	if heroic > 0 and mythic > 0 then string = string .. "-" end
	if heroic > 0 then string = string .. tostring(heroic) .. "H" end
	if normal > 0 and (mythic > 0 or heroic > 0) then string = string .. "-" end
	if normal > 0 then string = string .. tostring(normal) .. "N" end
	return string == "" and "-" or string
end

function AltManager:HideInterface()
	self.main_frame:Hide();
end

function AltManager:ShowInterface()
	self.main_frame:Show();
	self:StoreData(self:CollectData())
	self:UpdateStrings();
end

function AltManager:CreateRemoveButton(func)
	local frame = CreateFrame("Button", nil, nil)
	frame:ClearAllPoints()
	frame:SetScript("OnClick", function() func() end);
	self:MakeRemoveTexture(frame)
	frame:SetWidth(remove_button_size)
	return frame
end

function AltManager:MakeRemoveTexture(frame)
	if frame.remove_tex == nil then
		frame.remove_tex = frame:CreateTexture(nil, "BACKGROUND")
		frame.remove_tex:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
		frame.remove_tex:SetAllPoints()
		frame.remove_tex:Show();
	end
	return frame
end

function AltManager:MakeTopBottomTextures(frame)
	if frame.bottomPanel == nil then
		frame.bottomPanel = frame:CreateTexture(nil);
	end
	if frame.topPanel == nil then
		frame.topPanel = CreateFrame("Frame", "AltManagerTopPanel", frame);
		frame.topPanelTex = frame.topPanel:CreateTexture(nil, "BACKGROUND");
		--frame.topPanelTex:ClearAllPoints();
		frame.topPanelTex:SetAllPoints();
		--frame.topPanelTex:SetSize(frame:GetWidth(), 30);
		frame.topPanelTex:SetDrawLayer("ARTWORK", -5);
		frame.topPanelTex:SetColorTexture(0, 0, 0, 0.7);
		
		frame.topPanelString = frame.topPanel:CreateFontString("Method name");
		frame.topPanelString:SetFont(GameFontNormal:GetFont(), 20)
		frame.topPanelString:SetTextColor(1, 1, 1, 1);
		frame.topPanelString:SetJustifyH("CENTER")
		frame.topPanelString:SetJustifyV("CENTER")
		frame.topPanelString:SetWidth(260)
		frame.topPanelString:SetHeight(20)
		frame.topPanelString:SetText("Method小号管理");
		frame.topPanelString:ClearAllPoints();
		frame.topPanelString:SetPoint("CENTER", frame.topPanel, "CENTER", 0, 0);
		frame.topPanelString:Show();
		
	end
	frame.bottomPanel:SetColorTexture(0, 0, 0, 0.7);
	frame.bottomPanel:ClearAllPoints();
	frame.bottomPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 0);
	frame.bottomPanel:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 0);
	frame.bottomPanel:SetSize(frame:GetWidth(), 30);
	frame.bottomPanel:SetDrawLayer("ARTWORK", 7);

	frame.topPanel:ClearAllPoints();
	frame.topPanel:SetSize(frame:GetWidth(), 30);
	frame.topPanel:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 0);
	frame.topPanel:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, 0);

	frame:SetMovable(true);
	frame.topPanel:EnableMouse(true);
	frame.topPanel:RegisterForDrag("LeftButton");
	frame.topPanel:SetScript("OnDragStart", function(self,button)
		frame:SetMovable(true);
        frame:StartMoving();
    end);
	frame.topPanel:SetScript("OnDragStop", function(self,button)
        frame:StopMovingOrSizing();
		frame:SetMovable(false);
    end);
end

function AltManager:MakeBorderPart(frame, x, y, xoff, yoff, part)
	if part == nil then
		part = frame:CreateTexture(nil);
	end
	part:SetTexture(0, 0, 0, 1);
	part:ClearAllPoints();
	part:SetPoint("TOPLEFT", frame, "TOPLEFT", xoff, yoff);
	part:SetSize(x, y);
	part:SetDrawLayer("ARTWORK", 7);
	return part;
end

function AltManager:MakeBorder(frame, size)
	if size == 0 then
		return;
	end
	frame.borderTop = self:MakeBorderPart(frame, frame:GetWidth(), size, 0, 0, frame.borderTop); -- top
	frame.borderLeft = self:MakeBorderPart(frame, size, frame:GetHeight(), 0, 0, frame.borderLeft); -- left
	frame.borderBottom = self:MakeBorderPart(frame, frame:GetWidth(), size, 0, -frame:GetHeight() + size, frame.borderBottom); -- bottom
	frame.borderRight = self:MakeBorderPart(frame, size, frame:GetHeight(), frame:GetWidth() - size, 0, frame.borderRight); -- right
end

-- shamelessly stolen from saved instances
function AltManager:GetNextWeeklyResetTime()
	if not self.resetDays then
		local region = self:GetRegion()
		if not region then return nil end
		self.resetDays = {}
		self.resetDays.DLHoffset = 0
		if region == "US" then
			self.resetDays["2"] = true -- tuesday
			-- ensure oceanic servers over the dateline still reset on tues UTC (wed 1/2 AM server)
			self.resetDays.DLHoffset = -3 
		elseif region == "EU" then
			self.resetDays["3"] = true -- wednesday
		elseif region == "CN" or region == "KR" or region == "TW" then -- XXX: codes unconfirmed
			self.resetDays["4"] = true -- thursday
		else
			self.resetDays["2"] = true -- tuesday?
		end
	end
	local offset = (self:GetServerOffset() + self.resetDays.DLHoffset) * 3600
	local nightlyReset = self:GetNextDailyResetTime()
	if not nightlyReset then return nil end
	while not self.resetDays[date("%w",nightlyReset+offset)] do
		nightlyReset = nightlyReset + 24 * 3600
	end
	return nightlyReset
end

function AltManager:GetNextDailyResetTime()
	local resettime = GetQuestResetTime()
	if not resettime or resettime <= 0 or -- ticket 43: can fail during startup
		-- also right after a daylight savings rollover, when it returns negative values >.<
		resettime > 24*3600+30 then -- can also be wrong near reset in an instance
		return nil
	end
	if false then -- this should no longer be a problem after the 7.0 reset time changes
		-- ticket 177/191: GetQuestResetTime() is wrong for Oceanic+Brazilian characters in PST instances
		local serverHour, serverMinute = GetGameTime()
		local serverResetTime = (serverHour*3600 + serverMinute*60 + resettime) % 86400 -- GetGameTime of the reported reset
		local diff = serverResetTime - 10800 -- how far from 3AM server
		if math.abs(diff) > 3.5*3600  -- more than 3.5 hours - ignore TZ differences of US continental servers
			and self:GetRegion() == "US" then
			local diffhours = math.floor((diff + 1800)/3600)
			resettime = resettime - diffhours*3600
			if resettime < -900 then -- reset already passed, next reset
				resettime = resettime + 86400
				elseif resettime > 86400+900 then
				resettime = resettime - 86400
			end
		end
	end
	return time() + resettime
end

function AltManager:GetServerOffset()
	local serverDay = C_Calendar.GetDate().weekday - 1 -- 1-based starts on Sun
	local localDay = tonumber(date("%w")) -- 0-based starts on Sun
	local serverHour, serverMinute = GetGameTime()
	local localHour, localMinute = tonumber(date("%H")), tonumber(date("%M"))
	if serverDay == (localDay + 1)%7 then -- server is a day ahead
		serverHour = serverHour + 24
	elseif localDay == (serverDay + 1)%7 then -- local is a day ahead
		localHour = localHour + 24
	end
	local server = serverHour + serverMinute / 60
	local localT = localHour + localMinute / 60
	local offset = floor((server - localT) * 2 + 0.5) / 2
	return offset
end

function AltManager:GetRegion()
	if not self.region then
		local reg
		reg = GetCVar("portal")
		if reg == "public-test" then -- PTR uses US region resets, despite the misleading realm name suffix
			reg = "US"
		end
		if not reg or #reg ~= 2 then
			local gcr = GetCurrentRegion()
			reg = gcr and ({ "US", "KR", "EU", "TW", "CN" })[gcr]
		end
		if not reg or #reg ~= 2 then
			reg = (GetCVar("realmList") or ""):match("^(%a+)%.")
		end
		if not reg or #reg ~= 2 then -- other test realms?
			reg = (GetRealmName() or ""):match("%((%a%a)%)")
		end
		reg = reg and reg:upper()
		if reg and #reg == 2 then
			self.region = reg
		end
	end
	return self.region
end

function AltManager:GetWoWDate()
	local hour = tonumber(date("%H"));
	local day = C_Calendar.GetDate().weekday;
	return day, hour;
end

function AltManager:TimeString(length)
	if length == 0 then
		return "Now";
	end
	if length < 3600 then
		return string.format("%d mins", length / 60);
	end
	if length < 86400 then
		return string.format("%d hrs %d mins", length / 3600, (length % 3600) / 60);
	end
	return string.format("%d days %d hrs", length / 86400, (length % 86400) / 3600);
end
