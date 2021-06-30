local GlobalAddonName, ExRT = ...

local module = ExRT:New("LootLink",ExRT.L.LootLink,not ExRT.isClassic)
local ELib,L = ExRT.lib,ExRT.L

local VMRT = nil

module.db.cache = {}

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.LootLink = VMRT.LootLink or {}

	if VMRT.LootLink.enabled then
		module:Enable()
	end
	module:RegisterSlash()
end

local bannedItems = {
	["124442"] = true,	--Chaos Crystal
}

if ExRT.isClassic then
	function module.options:Load()
		self:CreateTilte()
	
		self.enableChk = ELib:Check(self,L.LootLinkEnable,VMRT.LootLink.enabled):Point(10,-30):AddColorState():OnClick(function(self) 
			if self:GetChecked() then
				VMRT.LootLink.enabled = true
				module:Enable()
			else
				VMRT.LootLink.enabled = nil
				module:Disable()
			end
		end)
		
		self.ilvlChk = ELib:Check(self,SHOW_ITEM_LEVEL,VMRT.LootLink.ilvl):Point(10,-55):OnClick(function(self) 
			if self:GetChecked() then
				VMRT.LootLink.ilvl = true
			else
				VMRT.LootLink.ilvl = nil
			end
		end)
		
		self.shtml1 = ELib:Text(self,L.LootLinkSlashHelp,12):Size(650,0):Point("TOP",0,-95):Top()
	end
end

function module:Enable()
	if ExRT.isClassic then
		module:RegisterEvents('LOOT_OPENED')
	end
end
function module:Disable()
	module:UnregisterEvents('LOOT_OPENED')
end

local function LootLink(linkAnyway)
	local lootMethod = GetLootMethod()
	local _,zoneType,difficulty,_,_,_,_,mapID = GetInstanceInfo()
	if (lootMethod == "personalloot" or difficulty == 7 or difficulty == 17) and not linkAnyway then
		return
	end
	local isFutureRaid = zoneType == 'raid' and (mapID or 0) > 1450
	if ExRT.isClassic and zoneType == "raid" then
		isFutureRaid = true
	end
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
				local _,_,_,_,quality = GetLootSlotInfo(i)
				if itemLink and (not isFutureRaid or (quality and quality >= 4)) then
					local itemID = itemLink:match("item:(%d+)")
					if not itemID or not bannedItems[itemID] then
						numLink = numLink + 1
						local _, _, _, iLevel = GetItemInfo(itemLink)
						iLevel = VMRT.LootLink.ilvl and iLevel or nil 
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

function module.main:LOOT_OPENED()
	LootLink()
end
function module:slash(arg)
	if arg == "loot" then
		LootLink(true)
	elseif arg == "help" then
		print("|cff00ff00/rt loot|r - link items from lootwindow to chat")
	end
end
