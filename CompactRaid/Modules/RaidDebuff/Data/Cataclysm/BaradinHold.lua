------------------------------------------------------------
-- BaradinHold.lua
--
-- Abin
-- 2011/1/07
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 75 -- Baradin Hold

-- Argaloth (139)

module:RegisterDebuff(TIER, INSTANCE, 139, 88942) --Meteor Slash
module:RegisterDebuff(TIER, INSTANCE, 139, 88954, 5) --Consuming Darkness

-- Occu'thar (140)

module:RegisterDebuff(TIER, INSTANCE, 140, 96884) --Focused Fire
module:RegisterDebuff(TIER, INSTANCE, 140, 96913, 5) --Searing Shadows

-- Alizabal (339)

module:RegisterDebuff(TIER, INSTANCE, 339, 104936, 5)
module:RegisterDebuff(TIER, INSTANCE, 339, 108094)
