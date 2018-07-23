------------------------------------------------------------
-- ThroneOfTheFourWinds.lua
--
-- Abin
-- 2011/1/07
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 74 -- Throne of The Four Winds

-- Conclave of Wind (154)

module:RegisterDebuff(TIER, INSTANCE, 154, 84645) --Wind Chill
module:RegisterDebuff(TIER, INSTANCE, 154, 86111) --Ice Patch
module:RegisterDebuff(TIER, INSTANCE, 154, 86082) --Permafrost
module:RegisterDebuff(TIER, INSTANCE, 154, 86481) --Hurricane
module:RegisterDebuff(TIER, INSTANCE, 154, 86282) --Toxic Spores
module:RegisterDebuff(TIER, INSTANCE, 154, 85573) --Deafening Winds
module:RegisterDebuff(TIER, INSTANCE, 154, 85576) --Withering Winds

-- Al'Akir (155)

module:RegisterDebuff(TIER, INSTANCE, 155, 88301) --Acid Rain
module:RegisterDebuff(TIER, INSTANCE, 155, 87873) --Static Shock
module:RegisterDebuff(TIER, INSTANCE, 155, 88427) --Electrocute
module:RegisterDebuff(TIER, INSTANCE, 155, 89666) --Lightning Rod
