-- local zone = "Ruby Life Pools"
local zoneid = 2095

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--"Trash"
GridStatusRaidDebuff:DebuffId(zoneid, 372697, 1, 5, 5, true) -- Jagged Earth
GridStatusRaidDebuff:DebuffId(zoneid, 372047, 1, 5, 5, true) -- Steel Barrage
GridStatusRaidDebuff:DebuffId(zoneid, 373869, 1, 5, 5, true) -- Burning Touch
GridStatusRaidDebuff:DebuffId(zoneid, 392641, 1, 5, 5, true) -- Rolling Thunder
GridStatusRaidDebuff:DebuffId(zoneid, 373693, 1, 5, 5, true) -- Living Bomb
GridStatusRaidDebuff:DebuffId(zoneid, 373692, 1, 5, 5, true) -- Inferno
GridStatusRaidDebuff:DebuffId(zoneid, 395292, 1, 5, 5, true) -- Fire Maw
GridStatusRaidDebuff:DebuffId(zoneid, 372796, 1, 5, 5, true) -- Blazing Rush
GridStatusRaidDebuff:DebuffId(zoneid, 392406, 1, 5, 5, true) -- Thunderclap
GridStatusRaidDebuff:DebuffId(zoneid, 392451, 1, 5, 5, true) -- Flashfire
GridStatusRaidDebuff:DebuffId(zoneid, 392924, 1, 5, 5, true) -- Shock Blast
GridStatusRaidDebuff:DebuffId(zoneid, 373589, 1, 7, 7, true, true) -- Primal Chill

GridStatusRaidDebuff:BossNameId(zoneid, 100, "Melidrussa Chillworn")
GridStatusRaidDebuff:DebuffId(zoneid, 385518, 101, 5, 5, true) -- Chillstorm
GridStatusRaidDebuff:DebuffId(zoneid, 372963, 102, 5, 5, true) -- Chillstorm
GridStatusRaidDebuff:DebuffId(zoneid, 372682, 103, 7, 7, true, true) -- Primal Chill
GridStatusRaidDebuff:DebuffId(zoneid, 378968, 104, 5, 5, true) -- Flame Patch
GridStatusRaidDebuff:DebuffId(zoneid, 373022, 105, 5, 5, true) -- Frozen Solid

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Kokia Blazehoof")
GridStatusRaidDebuff:DebuffId(zoneid, 372860, 201, 5, 5, true) -- Searing Wounds
GridStatusRaidDebuff:DebuffId(zoneid, 372820, 202, 5, 5, true) -- Scorched Earth
GridStatusRaidDebuff:DebuffId(zoneid, 372811, 203, 5, 5, true) -- Molten Boulder
GridStatusRaidDebuff:DebuffId(zoneid, 384823, 204, 5, 5, true) -- Inferno

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Kyrakka and Erkhart Stormvein")
GridStatusRaidDebuff:DebuffId(zoneid, 381526, 301, 5, 5, true) -- Roaring Firebreath
GridStatusRaidDebuff:DebuffId(zoneid, 381862, 302, 5, 5, true) -- Infernocore
GridStatusRaidDebuff:DebuffId(zoneid, 381515, 303, 5, 5, true) -- Stormslam
GridStatusRaidDebuff:DebuffId(zoneid, 381518, 304, 5, 5, true) -- Winds of Change
GridStatusRaidDebuff:DebuffId(zoneid, 384773, 305, 5, 5, true) -- Flaming Embers
