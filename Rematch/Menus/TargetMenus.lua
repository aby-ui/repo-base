local _,L = ...
local rematch = Rematch

--[[

	The following tables describe all of the notable NPCs and their pets, in the
	order to be displayed, in this format:
	{ npcID, group, speciesID1,speciesID2,speciesID3 },

	group is the index into the notableGroups table.

	TODO: arrange speciesIDs in the order they're fought

	npcID 1 is a special npcID to note an imported team loaded with the Load button on the import dialog

]]

local npcCacheTimeout = 5 -- number of times cache will be attempted before giving up

rematch.targetNames = {[1]=L["Imported Team"]} -- name of NPCs, indexed by NPC IDs
rematch.targetsCached = nil

rematch:InitModule(function()
	if not RematchSettings.DebugNoCache then
		rematch:CacheNpcIDs()
	end
	rematch:CreateTargetMenus()
end)

local parentMenu = {} -- space to store the parent menu with a submenu of expansions named "TargetMenu"
local expMenus = {} -- space to store to expansions menus with submenus of maps named "TargetMenu:<expansionID>"
local mapMenus = {} -- space to store the map menus of NPCs named "TargetMenu:<expansionID>:<mapID>"

-- takes an index into rematch.targetData and returns the name of the expansion it's from
function rematch:GetExpansionNameFromTarget(index)
	local info = index and rematch.targetData[index]
	if info then
		local expansionID = info[1]
		if type(expansionID)=="number" then
			return _G["EXPANSION_NAME"..expansionID] or UNKNOWN
		else
			return expansionID or UNKNOWN
		end
	end
end

-- takes an index into rematch.targetData and returns the name of the map it's from
function rematch:GetMapNameFromTarget(index)
	local info = index and rematch.targetData[index]
	if info then
		local mapID = info[2]
		if type(mapID)=="number" then
			local mapInfo = C_Map.GetMapInfo(mapID)
			return mapInfo and mapInfo.name or UNKNOWN
		else
			return mapID or UNKNOWN
		end
	end
end

-- takes an index into rematch.targetData and returns the name of the target
function rematch:GetNpcNameFromTarget(index)
	local info = index and rematch.targetData[index]
	if info then
		return rematch:GetNameFromNpcID(info[3])
	end
end

function rematch:GetQuestNameFromTarget(index)
	local info = index and rematch.targetData[index]
	local questID = info and info[4]
	if questID then
		return C_TaskQuest.GetQuestInfoByQuestID(questID) or C_QuestLog.GetTitleForQuestID(questID)
	end
end

-- if the info of the given menu has only one submenu, then return that submenu name; false otherwise.
-- this is used to remove the expansion submenu when the expansion has only one submenu:
-- parent->Burning Crusade->(4 targets) instead of parent->Burning Crusade->Outland->(4 targets)
local function getSingleMenuName(info)
	local lastSubMenuName
	for k,v in pairs(info) do
		if lastSubMenuName then
			return false -- been here before so there's more than one subMenu
		end
		lastSubMenuName = v.subMenu
	end
	return lastSubMenuName -- if reached here, there was only one subMenu
end

function rematch:CreateTargetMenus()
	for index,info in ipairs(rematch.targetData) do
		local expansionID = info[1]
		local mapID = info[2]
		local expMenuName = format("TargetMenu:%s",expansionID)
		local mapMenuName = format("TargetMenu:%s:%s",expansionID,mapID)
		-- add expansion to parent menu
		if not expMenus[expMenuName] then -- this expansion does not have a menu yet
			-- create an expansion-level menu
			tinsert(parentMenu,{text=rematch:GetExpansionNameFromTarget(index),subMenu=expMenuName})
			expMenus[expMenuName] = {}
		end
		-- add mapmenu to expansion menu
		if not mapMenus[mapMenuName] then
			tinsert(expMenus[expMenuName],{text=rematch:GetMapNameFromTarget(index),subMenu=mapMenuName})
			mapMenus[mapMenuName] = {}
		end
		-- add npc to the map menu
		local name = rematch:GetNameFromNpcID(info[3])
		tinsert(mapMenus[mapMenuName],{text=name,npcID=info[3],icon=rematch.NpcHasTeamSaved,iconCoords={0,1,0,1},tooltipBody=rematch.NotableTooltipBody,func=rematch.PickNpcID})
	end
	-- add help to end of parent menu
	tinsert(parentMenu,{text=L["Help"], hidden=function() return RematchSettings.HideMenuHelp or rematch:GetMenuParent()~=RematchLoadoutPanel.Target.TargetButton end, stay=true, icon="Interface\\Common\\help-i", iconCoords={0.15,0.85,0.15,0.85}, tooltipTitle=L["Noteworthy Targets"], tooltipBody=L["These are noteworthy targets such as tamers and legendary pets.\n\nChoose one to view the pets you would battle.\n\nTargets with a \124TInterface\\RaidFrame\\ReadyCheck-Ready:14\124t have a team saved."]})

	-- look to see if any expansion menu only has one map menu; if so skip the map menu
	-- (disabling this for now so the menu is consistent with the panel list)
	-- for expMenuName,info in pairs(expMenus) do
	-- 	lastSubMenuName = getSingleMenuName(info)
	-- 	if lastSubMenuName then -- expansion menu had only one map menu
	-- 		for k,v in pairs(parentMenu) do -- find parent menu entry and assigned submenu to skip map menu
	-- 			if v.subMenu==expMenuName then
	-- 				v.subMenu = lastSubMenuName
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- register the parent menu
	rematch:RegisterMenu("TargetMenu",parentMenu)
	-- register the expansion menus
	for expMenuName,info in pairs(expMenus) do
		rematch:RegisterMenu(expMenuName,info)
	end
	-- register the map menus
	for mapMenuName,info in pairs(mapMenus) do
		rematch:RegisterMenu(mapMenuName,info)
	end

end

-- returns name of an npcID from a lookup table, or a tooltip scan if it's not in the table yet
function rematch:GetNameFromNpcID(npcID)
	if type(npcID)~="number" then
		return L["No Target"]
	elseif rematch.targetNames[npcID] then
		return rematch.targetNames[npcID]
	end
	return rematch:GetNameFromNpcTooltip(npcID)
end

-- returns the name (if possible) from the given npcID by creating a fake tooltip of the npcID
-- if the creature isn't cached, it will return "NPC #"
-- if success passed, will return it if the name was valid
function rematch:GetNameFromNpcTooltip(npcID,success)
	local tooltip = RematchTooltipScan or CreateFrame("GameTooltip","RematchTooltipScan",nil,"GameTooltipTemplate")
	tooltip:SetOwner(rematch,"ANCHOR_NONE")
	tooltip:SetHyperlink(format("unit:Creature-0-0-0-0-%d-0000000000",npcID))
	if tooltip:NumLines()>0 then
		local name = RematchTooltipScanTextLeft1:GetText()
		if name and name:len()>0 then
			if success then
				return name,success -- if success parameter passed to function, send it back on success
			else
				return name -- otherwise just return the name (for parameter issues, can't have false for a second return)
			end
		end
	else
		return format("NPC %d",npcID)
	end
end

-- goes through and caches all notable NPCs; note that some NPCs will remain uncached until
-- the user interacts with a team (teams saved for wild pets or for pets around challenge posts)
function rematch:CacheNpcIDs()
	if not rematch.notablesCached then
		local failed
		-- cache notable NPCs
		for _,info in ipairs(rematch.targetData) do
			local npcID = info[3]
			if type(npcID)=="number" then
				local name,success = rematch:GetNameFromNpcTooltip(npcID,true)
				if success and not rematch.targetNames[npcID] then
					rematch.targetNames[npcID] = name
				elseif not success then
					failed = true
				end
			end
			-- while here, cache quest names from questIDs
			local questID = info[4]
			if questID then
				local name = C_TaskQuest.GetQuestInfoByQuestID(questID) or C_QuestLog.GetTitleForQuestID(questID)
			end
		end
		-- cache saved NPCs
		for key in pairs(RematchSaved) do
			if type(key)=="number" and not rematch.targetNames[key] then
				local name,success = rematch:GetNameFromNpcTooltip(key,true)
				if success then
					rematch.targetNames[key] = name
				else
					failed = true
				end
			end
		end
		if failed and npcCacheTimeout>0 then
			npcCacheTimeout = npcCacheTimeout - 1
			C_Timer.After(1.0,rematch.CacheNpcIDs) -- some weren't cached, try again later
		else
			rematch.notablesCached = true
		end
	end
end

-- this returns the passed speciesIDs (or links) as a string of type icons 
function rematch:NotablePetsAsText(...)
	local pets = ""
	for i=1,select("#",...) do
		local petID = select(i,...) -- can be a speciesID or link
		local petInfo = rematch.petInfo:Fetch(petID)
		if petInfo.speciesID and petInfo.petType then
			local petIcon = format("\124T%s:16:16:0:0:64:64:59:5:5:59\124t",petInfo.icon)
			local typeIcon = rematch:PetTypeAsText(petInfo.petType)
			pets = pets..format("%s %s %s\n",petIcon,typeIcon,petInfo.name)
		end
	end
	return (pets:gsub("\n$",""))
end

-- this is called from the npc menus when a npc is chosen (and from TargetPanel)
function rematch:PickNpcID()
	local npcID = type(self.npcID)=="function" and self.npcID(self) or self.npcID
	if npcID=="loaded" then
		npcID = RematchSettings.loadedTeam
	elseif npcID=="target" then
		npcID = rematch.recentTarget
	end
	if type(npcID)=="number" then
		rematch.recentTarget = npcID
		rematch.LoadoutPanel:UpdateTarget()
	else
		npcID = nil
	end
	if rematch:IsDialogOpen("SaveAs") then
		rematch:SetSaveAsTarget(npcID)
	elseif RematchSettings.LoadTeamsFromTarget and RematchSaved[npcID] then -- if Load Teams From TargetButton checked
		rematch:LoadTeam(npcID) -- then load the team that's being selected
	end
end

function rematch:NpcHasTeamSaved()
	local npcID = type(self.npcID)=="function" and self.npcID(self) or self.npcID
	return RematchSaved[self.npcID] and "Interface\\RaidFrame\\ReadyCheck-Ready" or ""
end

function rematch:NotableTooltipBody()
	local npcID = type(self.npcID)=="function" and self.npcID(self) or self.npcID
	for _,info in ipairs(rematch.targetData) do
		if info[3]==npcID then
			return rematch:NotablePetsAsText(info[7],info[8],info[9])
		end
	end
end

-- the following add /npcinfo to get the name of the targeted or mouesovered unit
-- and /speciesinfo to generate a line of notablenpc for the current battle
SLASH_REMATCHNPCINFO1 = "/rematchnpcinfo"
SlashCmdList["REMATCHNPCINFO"] = function()
	local name,npcID = Rematch:GetUnitNameandID(UnitExists("target") and "target" or "mouseover")
	print(name,npcID)
end

SLASH_REMATCHSPECIESINFO1 = "/rematchspeciesinfo"
SlashCmdList["REMATCHSPECIESINFO"] = function()
	local speciesIDs = {}
	local names = {}
	for i=1,3 do
		local name = C_PetBattles.GetName(2,i)
		tinsert(names,name)
		local speciesID = C_PetBattles.GetPetSpeciesID(2,i)
		tinsert(speciesIDs,speciesID)
	end
	local txt = format("{ , 26, %d, %d, %d }, -- %s, %s, %s", speciesIDs[1] or 0, speciesIDs[2] or 0, speciesIDs[3] or 0, names[1] or "", names[2] or "", names[3] or "")
	TinyPad.Insert(txt)
end

