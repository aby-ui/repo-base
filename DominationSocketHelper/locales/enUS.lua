local L = LibStub("AceLocale-3.0"):NewLocale("DominationSocketHelper", "enUS", true) 
if not L then return end

L["ERROR_TEXT"] = "Something went wrong. There is already a shard in this item."
L["DISENCHANT_MSG"] = "This item has a Domination Shard in it. Do not disenchant it!"
L["BAG_FULL_CHISEL"] = "Your bags are full DO NOT use the chisel!"
L["BAG_FULL_BUTTON"] = "Remove button hidden. Your bags are full. Clear up some bag space and re-open the socket interface."
L["DELETION_BLOCKED"] = "Item deletion blocked. That item either contains a Domination Shard or is a Domination Shard."
L["SHARD_BUYBACK"] = "Automatically bought %s back because it has a Domination Shard in it. You're welcome."
L["WHY"] = "Why would you even try that?" --When you try to replace a shard with another shard
L["NO"] = "No."
L["REMOVE"] = "Remove"
L["SAVE_SET"] = "Save Set"
L["UPDATE_SET"] = "Update Set"
L["SHARD_NOT_FOUND"] = "Error. A %s shard could not be found anywhere in your bags or equipment. This set can not be loaded."
L["ERROR_LOADING"] = "Failed to load the shard set. Make sure your currently equipped items have enough domination sockets."
L["EXTRA_SLOT"] = "Set successfully loaded, but you still have an empty domination socket. Fill the socket(s) and update the set."
L["DELETE_SET_CONFIRM"] = "Delete %s?"
L["NOT_SAVED"] = "Not Saved" --ldb text when your set is not saved

L["REPLACE"] = "Replace %s with %s in:"
L["REPLACE_TIP"] = "|cFFFC0316Shift|r: Replace All"
L["NOT_ENOUGH_GEMS"] = "|cFFFC0316Purchase %sx%s to also include:" --example: Missing [item Link]x3

--Below goes on shard buttons.
--ItemID of base item provided if translation is needed
L["Bek"] = "Bek" --187057
L["Jas"] = "Jas" --187059
L["Rev"] = "Rev" --187061
L["Dyz"] = "Dyz" --187073
L["Oth"] = "Oth" --187076
L["Zed"] = "Zed" --187079
L["Cor"] = "Cor" --187063
L["Kyr"] = "Kyr" --187065
L["Tel"] = "Tel" --187071

--Options
L["O_QUICK_SLOT"] = "Quick Slots"
L["ENABLE"] = "Enable"
L["ENABLE_DESC"] = "Enable the quick gem slots bar under the character frame."
L["ALWAYS_EMPTY"] = "Always Show Empty"
L["ALWAYS_EMPTY_DESC"] = "Always show empty gem slots in the quick slot bar."
L["STAY_OPEN"] = "Stay Open"
L["STAY_OPEN_DESC"] = "Keep the quick slot bar expanded after you close the character window."

L["SOCKET_WINDOW"] = "Socket Window"
L["AUTO_ACCEPT"] = "Auto Accept"
L["AUTO_ACCEPT_DESC"] = "Auto accept gems without requiring you to click apply."