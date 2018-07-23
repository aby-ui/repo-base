-- local zone = "Terrace of Endless Spring"
local zoneid = 456

-- Check Compatibility
if GridStatusRD_MoP.rd_version < 502 then
	return
end

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Trash

-- Protectors trash
-- Apparition of Terror
GridStatusRaidDebuff:DebuffId(zoneid, 130115, 1, 6, 6) --Grip of Fear (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 125758, 1, 6, 6) --Overwhelming Fear (dispellable/interruptable)
-- Night Terror
GridStatusRaidDebuff:DebuffId(zoneid, 125760, 1, 5, 5, true, true) --Enveloping Darkness  (dispellable)

--Protector Kaolan
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Protector Kaolan")
GridStatusRaidDebuff:DebuffId(zoneid, 117519, 11, 2, 2) --Touch of Sha (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 111850, 12, 6, 6) --Lightning Prison: Targeted
GridStatusRaidDebuff:DebuffId(zoneid, 117436, 13, 6, 6) --Lightning Prison: Stunned
GridStatusRaidDebuff:DebuffId(zoneid, 118191, 14, 5, 5, true, true) --Corrupted Essence
GridStatusRaidDebuff:DebuffId(zoneid, 118091, 15, 4, 4, true, true) --Defiled Ground: Stacks
GridStatusRaidDebuff:DebuffId(zoneid, 117235, 16, 1, 1) --Purified (buff from Corrupted Waters)
GridStatusRaidDebuff:DebuffId(zoneid, 117283, 17, 1, 1) --Cleansing Waters (buff from Cleansing Waters, don't dispell off players, dispel off enemy targets)
GridStatusRaidDebuff:DebuffId(zoneid, 117353, 18, 3, 3, true, true) -- Overwhelming Corruption (stacking dot) - if an Elder is killed last

--Tsulong
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Tsulong")
GridStatusRaidDebuff:DebuffId(zoneid, 122768, 21, 2, 2, true, true) --Dread Shadows
GridStatusRaidDebuff:DebuffId(zoneid, 122777, 22, 6, 6) --Nightmares (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 122752, 23, 3, 3, true, true) --Shadow Breath
GridStatusRaidDebuff:DebuffId(zoneid, 122789, 24, 1, 1) --Sunbeam
GridStatusRaidDebuff:DebuffId(zoneid, 123012, 25, 6, 6) --Terrorize: 5% (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 123011, 26, 6, 6) --Terrorize: 10% (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 123036, 27, 5, 5) --Fright (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 122858, 28, 2, 2) --Bathed in Light

--Lei Shi
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Lei Shi")
GridStatusRaidDebuff:DebuffId(zoneid, 123121, 31, 4, 4, true, true) --Spray (tank stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 123705, 32, 3, 3, true, true) --Scary Fog ?

--Sha of Fear
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Sha of Fear")
GridStatusRaidDebuff:DebuffId(zoneid, 119414, 41, 6, 6) --Breath of Fear
GridStatusRaidDebuff:DebuffId(zoneid, 129147, 42, 3, 3) --Onimous Cackle
GridStatusRaidDebuff:DebuffId(zoneid, 119983, 43, 6, 6, true, true) --Dread Spray
GridStatusRaidDebuff:DebuffId(zoneid, 120669, 44, 3, 3) --Naked and Afraid
GridStatusRaidDebuff:DebuffId(zoneid, 75683, 45, 6, 6) --Waterspout
GridStatusRaidDebuff:DebuffId(zoneid, 120629, 46, 3, 3) --Huddle in Terror
GridStatusRaidDebuff:DebuffId(zoneid, 120394, 47, 6, 6) --Eternal Darkness
GridStatusRaidDebuff:DebuffId(zoneid, 129189, 48, 3, 4) --Sha Globe
GridStatusRaidDebuff:DebuffId(zoneid, 119086, 49, 4, 4) --Penetrating Bolt
GridStatusRaidDebuff:DebuffId(zoneid, 119775, 50, 6, 6) --Reaching Attack

