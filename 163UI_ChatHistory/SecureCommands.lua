local _, addon = ...
addon = addon or {}
addon.secure = {
	"STARTATTACK",
	"STOPATTACK",
	"CAST",
	"USE",
	"CASTRANDOM",
	"USERANDOM",
	"CASTSEQUENCE",
	"STOPCASTING",
	"CANCELAURA",
	"CANCELFORM",
	"CASTGLYPH",
	"EQUIP",
	"EQUIP_TO_SLOT",
	"CHANGEACTIONBAR",
	"SWAPACTIONBAR",
	"TARGET",
	"TARGET_EXACT",
	"TARGET_NEAREST_ENEMY",
	"TARGET_NEAREST_ENEMY_PLAYER",
	"TARGET_NEAREST_FRIEND",
	"TARGET_NEAREST_FRIEND_PLAYER",
	"TARGET_NEAREST_PARTY",
	"TARGET_NEAREST_RAID",
	"CLEARTARGET",
	"TARGET_LAST_TARGET",
	"TARGET_LAST_ENEMY",
	"TARGET_LAST_FRIEND",
	"ASSIST",
	"FOCUS",
	"CLEARFOCUS",
	"CLEARMAINTANK",
	"MAINTANKON",
	"MAINTANKOFF",
	"CLEARMAINASSIST",
	"MAINASSISTON",
	"MAINASSISTOFF",
	"DUEL",
	"DUEL_CANCEL",
	"PET_ATTACK",
	"PET_FOLLOW",
	"PET_MOVE_TO",
	"PET_STAY",
	"PET_PASSIVE",
	"PET_DEFENSIVE",
	"PET_AGGRESSIVE",
	"PET_ASSIST",
	"PET_AUTOCASTON",
	"PET_AUTOCASTOFF",
	"PET_AUTOCASTTOGGLE",
	"STOPMACRO",
	"CANCELQUEUEDSPELL",
	"CLICK",
	"EQUIP_SET",
	"WORLD_MARKER",
	"CLEAR_WORLD_MARKER",
	"SUMMON_BATTLE_PET",
	"RANDOMPET",
	"RANDOMFAVORITEPET",
	"DISMISSBATTLEPET",
}

local SecureCmdList = {}
local hash_SecureCmdList = {}
for i=1,#addon.secure do SecureCmdList[addon.secure[i]]=true end

for index, value in pairs(SecureCmdList) do
	local i = 1;
	local cmdString = _G["SLASH_"..index..i];
	while ( cmdString ) do
		cmdString = strupper(cmdString);
		hash_SecureCmdList[cmdString] = value;	-- add to hash
		i = i + 1;
		cmdString = _G["SLASH_"..index..i];
	end
end

--copied from ChatFrame
--function ChatEdit_ParseText(editBox, send, parseIfNoSpaces)
function addon:IsSecureCmd(text)

	if ( strlen(text) <= 0 ) then
		return;
	end

	if ( strsub(text, 1, 1) ~= "/" ) then
		return;
	end

	-- If the string is in the format "/cmd blah", command will be "/cmd"
	local command = strmatch(text, "^(/[^%s]+)") or "";
	local msg = "";


	if ( command ~= text ) then
		msg = strsub(text, strlen(command) + 2);
	end

	command = strupper(command);

	-- Check and see if we've got secure commands to run before we look for chat types or slash commands.	
	-- This hash table is prepopulated, unlike the other ones, since nobody can add secure commands. (See line 1205 or thereabouts)
	-- We don't want this code to run unless send is 1, but we need ChatEdit_HandleChatType to run when send is 1 as well, which is why we
	-- didn't just move ChatEdit_HandleChatType inside the send == 0 conditional, which could have also solved the problem with insecure
	-- code having the ability to affect secure commands.
	
	if ( hash_SecureCmdList[command] ) then
		return true;
	end

	return false;
end