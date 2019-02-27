------------------------------------------------------------ 
-- BattleofDazaralor.lua 
-- 
-- Rowan 
-- 2019/01/30 
------------------------------------------------------------ 

local module = CompactRaid:GetModule("RaidDebuff") 
if not module then return end 

local TIER = 8 -- BFA 
local INSTANCE = 1176 -- Battle of Dazar'alor 
local BOSS 


if UnitFactionGroup("player") == "Horde" then 
 
-- Horde 
BOSS = 2333 -- Champion of the Light (H) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283617, 5) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283573, 4) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283582) 

BOSS = 2325 -- Grong the Jungle Lord (H) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285671) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285875) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289292) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289307, 5) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282010, 5) -- Horde only 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285659, 5) -- Horde only 
 
BOSS = 2341 -- Jadefire Masters (H) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282037) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285632) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284374, 1) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286987) 
 
end 

if UnitFactionGroup("player") == "Alliance" then 
 
-- Alliance 
BOSS = 2344 -- Champion of the Light (A) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283617, 5) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283573, 4) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283582) 

BOSS = 2323 -- Jadefire Masters (A) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282037) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285632) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284374, 1) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286987) 
 
BOSS = 2340 -- Grong the Revenant (A) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285671) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285875) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289292) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289307, 5) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282415, 5) -- Alliance only 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286433, 5) -- Alliance only 
 
end 

BOSS = 2342 -- Opulence 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285014) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 287072) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289383) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283507) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284470) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 283063) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284493) 


BOSS = 2330 -- Conclave 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282444) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282135) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286811) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282834) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284663) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 282209) 

BOSS = 2335 -- Rastakhan 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286779) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 290450) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288449) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285195) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285346) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285044) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 272868) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289858) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284781) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285213) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286742) 

BOSS = 2334 -- Mekkatorque 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286646) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284168) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 286105) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288806) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288939) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 287891) 

BOSS = 2337 -- Blockade 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285000) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284405, 4) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 284361) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285350) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288192) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288195) 

BOSS = 2343 -- Jaina 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 285254) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288212) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288374) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289220) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288394) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 289387) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 287993, 1) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 288038) 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 287365) 

BOSS = 0 -- Trash


