--
--	Grail Bugged Quests
--	Written by scott@mithrandir.com
--
--	Version History
--		001	Initial version
--		002	Added 13913
--		003	Added 822, 30926, 30724 and 31074
--		004	Removed 24992.  Added 14395
--		005 Removed 31074.
--		006	Added 13981
--		007	Removed 822 and marked it unobtainable.
--		008	Switches to using separate table to hold bugged quests
--		009 Added 11216
--
--	UTF-8 file
--
local Grail_Bugged_Quests_File_Version = 009

if Grail.buggedQuestsVersionNumber < Grail_Bugged_Quests_File_Version then
	Grail.buggedQuestsVersionNumber = Grail_Bugged_Quests_File_Version
	local G = Grail.buggedQuests

-- 15050 is the 4.3.0 release
-- 15211 is the 4.3.2 release
-- 15882 is the 5.0.3 release dated 2012-07-16
-- 22248 is the 7.0.3 release dated 2016-07-15
local _, release = GetBuildInfo()
release = tonumber(release)

if release > 15050 then
	G[1]='This quest is bugged and cannot be completed.'
	G[13712]='This quest is bugged on many servers, so Blizzard seems to have added the ability to talk to Kadrak again to just fly over.'
	G[14481]='This quest is bugged as no one seems to be able to get it.'
end

if release > 22248 then
	G[11216]='This quest is bugged and cannot be completed as the NPC for turn in was removed.'
end

end

