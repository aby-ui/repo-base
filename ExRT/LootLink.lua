local GlobalAddonName, ExRT = ...

local module = ExRT:New("LootLink",ExRT.L.LootLink,true)
local ELib,L = ExRT.lib,ExRT.L

local VExRT = nil

module.db.cache = {}

function module.main:ADDON_LOADED()
	module:RegisterSlash()
end

local bannedItems = {
	["124442"] = true,	--Chaos Crystal
}

local function LootLink(linkAnyway)
	local lootMethod = GetLootMethod()
	local _,zoneType,difficulty,_,_,_,_,mapID = GetInstanceInfo()
	if (lootMethod == "personalloot" or difficulty == 7 or difficulty == 17) and not linkAnyway then
		return
	end
	local isFutureRaid = zoneType == 'raid' and (mapID or 0) > 1450
	if linkAnyway then
		isFutureRaid = false
	end
	local count = GetNumLootItems()
	local cache = {}
	local numLink = 0
	local chat_type, playerName = ExRT.F.chatType()
	for i=1,count do
		local sourceGUID = GetLootSourceInfo(i)
		if sourceGUID and (not module.db.cache[sourceGUID] or linkAnyway) then
			local mobID = ExRT.F.GUIDtoID(sourceGUID)
			if (linkAnyway or isFutureRaid) then
				local itemLink =  GetLootSlotLink(i)
				local _,_,_,quality = GetLootSlotInfo(i)
				if itemLink and (not isFutureRaid or (quality and quality >= 4)) then
					local itemID = itemLink:match("item:(%d+)")
					if not itemID or not bannedItems[itemID] then
						numLink = numLink + 1
						local _, _, _, iLevel = GetItemInfo(itemLink)
						iLevel = VExRT.LootLink.ilvl and iLevel or nil 
						SendChatMessage(numLink..": "..itemLink..(iLevel and (" ("..iLevel..")") or ""),chat_type,nil,playerName)
					end
				end
			end
 			cache[sourceGUID] = true
 		end
	end
	for GUID,_ in pairs(cache) do
		module.db.cache[GUID] = true
	end
end

function module:slash(arg)
	if arg == "loot" then
		LootLink(true)
	end
end
