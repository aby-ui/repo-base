local ADDON, Addon = ...
local Mod = Addon:NewModule('Keystone')

-- local poorColor = select(4, GetItemQualityColor(LE_ITEM_QUALITY_POOR))
-- local epicColor = select(4, GetItemQualityColor(LE_ITEM_QUALITY_EPIC))

-- local events = {
-- 	"CHAT_MSG_SAY",
-- 	"CHAT_MSG_YELL",
-- 	"CHAT_MSG_CHANNEL",
-- 	"CHAT_MSG_TEXT_EMOTE",
-- 	"CHAT_MSG_WHISPER",
-- 	"CHAT_MSG_WHISPER_INFORM",
-- 	"CHAT_MSG_BN_WHISPER",
-- 	"CHAT_MSG_BN_WHISPER_INFORM",
-- 	"CHAT_MSG_BN_CONVERSATION",
-- 	"CHAT_MSG_GUILD",
-- 	"CHAT_MSG_OFFICER",
-- 	"CHAT_MSG_PARTY",
-- 	"CHAT_MSG_PARTY_LEADER",
-- 	"CHAT_MSG_RAID",
-- 	"CHAT_MSG_RAID_LEADER",
-- 	"CHAT_MSG_INSTANCE_CHAT",
-- 	"CHAT_MSG_INSTANCE_CHAT_LEADER",
-- }

-- local function filter(self, event, msg, ...)
-- 	local msg2 = msg:gsub("(|Hkeystone:([0-9:]+)|h(%b[])|h)", function(msg, itemString, itemName)
-- 		local info = { strsplit(":", itemString) }
-- 		local mapID = tonumber(info[1])
-- 		local mapLevel = tonumber(info[2])

-- 		if mapID and mapLevel then
-- 			local mapName = C_ChallengeMode.GetMapInfo(mapID)
-- 			return msg:gsub(itemName:gsub("(%W)","%%%1"), format(Addon.Locale.keystoneFormat, mapName, mapLevel))
-- 		else
-- 			return msg
-- 		end
-- 	end)
-- 	if msg2 ~= msg then
-- 		return false, msg2, ...
-- 	end
-- end

-- for _, v in pairs(events) do
-- 	ChatFrame_AddMessageEventFilter(v, filter)
-- end

local function SlotKeystone()
	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do
			local _, _, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
			if slotLink and slotLink:match("|Hkeystone:") then
				PickupContainerItem(container, slot)
				if (CursorHasItem()) then
					C_ChallengeMode.SlotKeystone()
				end
			end
		end
	end
end

function Mod:Blizzard_ChallengesUI()
	ChallengesKeystoneFrame:HookScript("OnShow", SlotKeystone)
end

function Mod:Startup()
	self:RegisterAddOnLoaded("Blizzard_ChallengesUI")
end
