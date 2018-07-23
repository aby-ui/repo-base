local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("LootLink",ExRT.L.LootLink,nil,true)
local ELib,L = ExRT.lib,ExRT.L

local VExRT = nil

module.db.mobsIDs = {
	[78714]=true,	--Kargath
	[77404]=true,	--Butcher
	[78491]=true,	--Mushroom
	[78948]=true,	--Tectus
	[78237]=true,	--Fem
	[78238]=true,	--Pol
	[79015]=true,	--Koragh
	[77428]=true,	--Margok
	[78623]=true,	--Chogall
	
	[76877]=true,	--Gruul
	[77182]=true,	--Oregorger
	[76806]=true,	--Heart of the Mountain
	[76865]=true,	--Darmac
	[76906]=true,	--Thogar
	[77477]=true,	--Marak
	[77231]=true,	--Sorka
	[77557]=true,	--Garan
	[76974]=true,	--Franzok
	[76973]=true,	--Hansgar
	[76814]=true,	--Kagraz
	[77692]=true,	--Kromog
	[77325]=true,	--Blackhand
	
	[243290]=true,	--Hellfire Assault
	[90284]=true,	--Iron Reaver
	[90199]=true,	--Gorefiend
	[92144]=true,	--Hellfire High Council, Darkwhisper
	[92142]=true,	--Hellfire High Council, Jubei'thos
	[92146]=true,	--Hellfire High Council, Bloodboil
	[90435]=true,	--Kormrok
	[90378]=true,	--Kilrogg Deadeye
	[90316]=true,	--Shadow-Lord Iskar
	[89890]=true,	--Fel Lord Zakuun
	[93068]=true,	--Xhul'horac
	[92330]=true,	--Socrethar the Eternal
	[243567]=true,	--Socrethar the Eternal
	[90269]=true,	--Tyrant Velhari
	[91349]=true,	--Mannoroth
	[91331]=true,	--Archimonde
}

module.db.cache = {}

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.LootLinkEnable,VExRT.LootLink.enabled):Point(5,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.LootLink.enabled = true
			module:Enable()
		else
			VExRT.LootLink.enabled = nil
			module:Disable()
		end
	end)
	
	self.ilvlChk = ELib:Check(self,SHOW_ITEM_LEVEL,VExRT.LootLink.ilvl):Point(5,-55):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.LootLink.ilvl = true
		else
			VExRT.LootLink.ilvl = nil
		end
	end)
	
	self.shtml1 = ELib:Text(self,L.LootLinkSlashHelp,12):Size(650,0):Point("TOP",0,-95):Top()
end


function module:Enable()
	module:RegisterEvents('LOOT_OPENED')
end
function module:Disable()
	module:UnregisterEvents('LOOT_OPENED')
end


function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.LootLink = VExRT.LootLink or {}

	if VExRT.LootLink.enabled then
		module:Enable()
	end
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
			if (module.db.mobsIDs[mobID] or linkAnyway or isFutureRaid) then
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


function module.main:LOOT_OPENED()
	LootLink()
end

function module:slash(arg)
	if arg == "loot" then
		LootLink(true)
	end
end
