--local zone = "Hellfire Citadel"
local zoneid = 661

--zoneid, debuffID, order, icon_priority, colorpriority, timer, stackable, color, defaultdisable, noicon
--true, true is for stackable

-- Check Compatibility
if GridStatusRD_WoD.rd_version < 600 then
	return
end

--Trash

-- Hellfire Assault trash
-- Gorebound Felcaster
-- Gorebound Terror
-- Hulking Berserker is listed under Hellfire Assault
-- Contracted Engineer
GridStatusRaidDebuff:DebuffId(zoneid, 185806, 1, 5, 5, true) -- Conducted Shock Pulse (stun, dispellable)
-- Iron Dragoon
-- Felfire Flamebelcher
-- Felfire Demolisher
-- Gorebound Fanatic
-- Gorebound Cauterizer
-- Felfire Brazier
GridStatusRaidDebuff:DebuffId(zoneid, 187459, 1, 4, 4, true) -- Fel Shock (dot, dispellable)
-- Gorebound Corruptor - same abilities as Grand Corruptor U'rogg
-- Siegeworks Technician

-- Grand Corruptor U'rogg (mini-boss)
GridStatusRaidDebuff:DebuffId(zoneid, 190735, 1, 6, 6, true) -- Corruption Siphon

-- Grute (mini-boss) - same abilities as Hulking Berserker

-- Iron Reaver - no trash

-- Kormrok trash
-- Hellfire Guardian
-- Fel Hellweaver
GridStatusRaidDebuff:DebuffId(zoneid, 188087, 1, 6, 6) -- Hellweaving (dot, dispellable)
-- Fel Touched Seer
GridStatusRaidDebuff:DebuffId(zoneid, 188216, 1, 5, 5, true) -- Blaze (dot)
-- Shambling Hulk
-- Iron Peon
-- Gorebound Assassin
GridStatusRaidDebuff:DebuffId(zoneid, 188148, 1, 1, 1, true) -- Cheap Shot (stun)
GridStatusRaidDebuff:DebuffId(zoneid, 188189, 1, 4, 4, true) -- Fel Poison (dot, dispellable)
-- Fel Extractor
GridStatusRaidDebuff:DebuffId(zoneid, 187122, 1, 5, 5, true) -- Primal Energies (AoE dot)
GridStatusRaidDebuff:DebuffId(zoneid, 188482, 1, 3, 3, true) -- Fel Infection (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 188484, 1, 1, 1, true) -- Fel Sickness (prevents passing Fel Infection)

-- Shadow Infuser

-- Insanity is also the name of the debuff from hunter pet's Ancient Hysteria
-- This causes that Insanity to show up with GridSTatusRaidDebuff prior to r33 (6.22)
if GridStatusRD_WoD.rd_version < 622 then
   -- Disable the trash Insanity debuff
   GridStatusRaidDebuff:DebuffId(zoneid, 188541, 1, 1, 1, true, false, 0, true) -- Insanity (disabled)
else 
   -- GridStatusRaidDebuff versions over 6.22 can handle displaying this debuff
   GridStatusRaidDebuff:DebuffId(zoneid, 188541, 1, 6, 6, true) -- Insanity (mind control)
end

GridStatusRaidDebuff:DebuffId(zoneid, 187099, 1, 5, 5) -- Residual Shadows (standing in puddle)
-- Shadow Infuser also does Fel Infection/Sickness
-- Fiery Enkindler
GridStatusRaidDebuff:DebuffId(zoneid, 187110, 1, 6, 6, true) -- Focused Fire (dot, heavy damage split by nearby)
GridStatusRaidDebuff:DebuffId(zoneid, 188474, 1, 6, 6, true) -- Living Bomb (player explodes)
-- Fiery Enkindler also does Fel Infection/Sickness
-- Keen-Eyed Gronnstalker
-- Armored Skullsmasher
-- Grim Ambusher
GridStatusRaidDebuff:DebuffId(zoneid, 188282, 1, 1, 1, true) -- Ambush (stun)
GridStatusRaidDebuff:DebuffId(zoneid, 188287, 1, 2, 2, true) -- Rupture (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 188283, 1, 2, 2, true) -- Hemorrhage (dot)
-- Togdrov -- some of Kormrok's abilities
-- Sovokk -- some of Kormrok's abilities
-- Morkronn -- some of Kormrok's abilities, plus
GridStatusRaidDebuff:DebuffId(zoneid, 188104, 1, 6, 6, true) -- Explosive Burst (tank root, explosion)

-- Court of Blood Trash (Hellfire High Council, Kilrogg)
-- Hellfire High Council trash
-- (shares some trash mobs with Kormrok)
-- Fel-Starved Trainee

-- Graggra (mini-boss, skipable)
GridStatusRaidDebuff:DebuffId(zoneid, 188476, 1, 4, 4, true, true) -- Bad Breath (tank swap debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 188448, 1, 2, 2, true) -- Blazing Fel Touch (all players explode)
GridStatusRaidDebuff:DebuffId(zoneid, 188510, 1, 5, 5, true) -- Graggra Smash (stun, AoE on player)

-- Kilrogg trash
-- Salivating Bloodthirster (become Hulking Terrors)
-- Hulking Terror (listed under Kilrogg)
-- Bleeding Grunt
-- Bleeding Darkcaster
GridStatusRaidDebuff:DebuffId(zoneid, 182644, 1, 6, 6, true) -- Dark Fate (root, damage split)

-- Halls of the Sargerei trash (Socrethar and Tyrant)
-- Eredar Faithbreaker
GridStatusRaidDebuff:DebuffId(zoneid, 184587, 1, 5, 5) -- Touch of Mortality

-- Hellfire Antechamber trash
-- Gorefiend trash (Maw of Souls)
-- Gorebound Berserker
GridStatusRaidDebuff:DebuffId(zoneid, 184300, 1, 2, 2, true) -- Fel Blaze (dot)
-- Gorebound Brute
-- Fel Fury is listed under Enraged Spirit for Gorefiend, same spell id
-- Gorebound Bloodletter
GridStatusRaidDebuff:DebuffId(zoneid, 184102, 1, 2, 2, true, true) -- Corrupted Blood (dot, stacks, dispellable but jumps)
-- Gorebound Crone (mini-boss)

-- Grommash's Torment trash (Shadow-Lord Iskar and Fel Lord Zakuun)
-- Delusional Zealot
GridStatusRaidDebuff:DebuffId(zoneid, 186046, 1, 5, 5, true) -- Solar Chakram (disorient, dispellable)
-- Fel Raven (listed under Iskar)
-- Corrupted Talonpriest (listed under Iskar)
-- Shadowfel Warden

-- Fel Lord Zakuun trash
-- Dag'gorath (mini-boss)
GridStatusRaidDebuff:DebuffId(zoneid, 186197, 1, 5, 5) -- Demonic Sacrifice (stun, dot)
GridStatusRaidDebuff:DebuffId(zoneid, 186384, 1, 2, 2) -- Noxious Cloud (smoke bomb, dot)
-- Dark Devourer
-- Shadow Burster
-- Mek'barash (mini-boss)
-- Fel Scorcher
-- Succubus (Glynevere, Cattwen, Bryanda)
-- Felguards (Zerik'shekor, Shao'ghun, Vazeel'fazag)
GridStatusRaidDebuff:DebuffId(zoneid, 184388, 1, 2, 2) -- Whirling (spin AoE)

-- The Felborne Breach trash (Xhul'horac)
-- Weaponlord Mehlkhior
GridStatusRaidDebuff:DebuffId(zoneid, 190043, 1, 2, 2, true, true) -- Felblood Strike (dam buff until 10 stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 190044, 1, 6, 6, true) -- Felblood Corruption (player is bomb)
GridStatusRaidDebuff:DebuffId(zoneid, 190012, 1, 1, 1, true) -- Demonic Leap (stun)
-- Voidscribe Aathalos

-- Halls of the Sargerei trash (Socrethar)
-- Sargerei Enforcer
GridStatusRaidDebuff:DebuffId(zoneid, 189556, 1, 4, 4, true, true) -- Sunder Armor (tank debuff stack)
-- Sargerei Soul Cleaver
GridStatusRaidDebuff:DebuffId(zoneid, 189551, 1, 5, 5, true) -- Devouring Spirit (dot, magic dispellable)
-- Sargerei Adjutant
GridStatusRaidDebuff:DebuffId(zoneid, 189554, 1, 6, 6, true, true) -- Consuming Pain (dot, stacks, magic dispellable)
-- Sargerei Bannerman
GridStatusRaidDebuff:DebuffId(zoneid, 189539, 1, 1, 1, true) -- Shockwave (stun)
-- Construct Peacekeeper
GridStatusRaidDebuff:DebuffId(zoneid, 189596, 1, 3, 3, true) -- Protocol: Crowd Control (short disorient, dispellable)
-- Korvos
GridStatusRaidDebuff:DebuffId(zoneid, 189564, 1, 5, 5, true) -- Torpor (sleep, dispellable, spreads to nearby players on dispel)
-- Carrion Swarm (cast on players by Korvos)
GridStatusRaidDebuff:DebuffId(zoneid, 189560, 1, 2, 2, true) -- Carrion Swarm (dot)
-- Binder Eloah
GridStatusRaidDebuff:DebuffId(zoneid, 189533, 1, 4, 4, true) -- Sever Soul (tank swap debuff)
-- Binder Hallaani
GridStatusRaidDebuff:DebuffId(zoneid, 189532, 1, 5, 5, true) -- Soulsear (AoE dot)
-- Mystic Aaran
GridStatusRaidDebuff:DebuffId(zoneid, 189531, 1, 2, 2, false, true) -- Soulbane (dot, stacks, magic dispellable)
-- Mystic Velrrun

-- Amphitheater of the Eternal (Tyrant Velhari)
-- Portal Guardian
GridStatusRaidDebuff:DebuffId(zoneid, 184734, 1, 5, 5, true) -- Hellfire Slash (cone dot, magic dispellable
-- Somber Guardian
-- Darkcaster Adept
-- Grim Collaborator
GridStatusRaidDebuff:DebuffId(zoneid, 181962, 1, 1, 1, true) -- Corrupting Slash (buff/debuff, dispellable)
-- Umbral Supplicant
-- Shadowheart Fiend
GridStatusRaidDebuff:DebuffId(zoneid, 184725, 1, 4, 4, true) -- Shadowflame Blast (healing absorb, dispellable)
-- Slavering Hound
GridStatusRaidDebuff:DebuffId(zoneid, 184730, 1, 3, 3, true) -- Terrifying Howl (short fear, dispellable)
-- Lord Aram'el (mini-boss)
GridStatusRaidDebuff:DebuffId(zoneid, 184721, 1, 1, 1, true, true) -- Shadow Bolt Volley (debuff, stacks, not dispellable)
-- Eredar Faithbreaker
GridStatusRaidDebuff:DebuffId(zoneid, 184621, 1, 1, 1, true) -- Hellfire Blast (debuff, not dispellable)
-- Vindicator Bramu
-- Seal of Decay is also used by Tyrant Velhari
-- GridStatusRaidDebuff:DebuffId(zoneid, 184986, 1, 2, 2, true, true) -- Seal of Decay (tank debuff stack, healing reduction)
-- Protector Bajunt
-- Seal of Decay is also used by Tyrant Velhari
-- Adjunct Kuroh
-- Seal of Decay is also used by Tyrant Velhari

-- Destructor's Rise trash (Mannoroth)

-- Archimonde trash
-- Anetheron
GridStatusRaidDebuff:DebuffId(zoneid, 189470, 1, 3, 3, true) -- Sleep (sleep)
-- Carrion Swarm is duplicate name
-- GridStatusRaidDebuff:DebuffId(zoneid, 189464, 1, 2, 2, true) -- Carrion Swarm (healing debuff)
-- Towering Infernal
GridStatusRaidDebuff:DebuffId(zoneid, 189488, 1, 1, 1, true) -- Impact (stun)
-- Kaz'rogal
GridStatusRaidDebuff:DebuffId(zoneid, 189504, 1, 1, 1, true) -- Warm Stomp (stun)
GridStatusRaidDebuff:DebuffId(zoneid, 189512, 1, 4, 4, true) -- Mark of Kaz'rogal (debuff, not dispellable, mana drain/AoE)
-- Azgalor
GridStatusRaidDebuff:DebuffId(zoneid, 189538, 1, 1, 1, true) -- Doom (debuff, not dispellable, summons mob)
GridStatusRaidDebuff:DebuffId(zoneid, 189550, 1, 5, 5) -- Rain of Fire (standing in)
-- Lesser Doomguard
GridStatusRaidDebuff:DebuffId(zoneid, 189544, 1, 1, 1, true) -- Cripple (debuff, not dispellable)

-- Bosses

-- Hellfire Assault
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Hellfire Assault")
--GridStatusRaidDebuff:DebuffId(zoneid, 156096, 11, 4, 4) --MARKEDFORDEATH
-- Siegemaster Mar'tak
GridStatusRaidDebuff:DebuffId(zoneid, 184369, 11, 6, 6, true) -- Howling Axe (targetted)
-- Hulking Berserker
GridStatusRaidDebuff:DebuffId(zoneid, 184243, 12, 4, 4, true, true) -- Slam (stackable tank debuff, nondispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 184238, 13, 1, 1, true) -- Cower (movement)
-- Felfire Crusher
GridStatusRaidDebuff:DebuffId(zoneid, 180022, 14, 2, 2) -- Bore (frontal cone damage)
-- Gorebound Siegeriders (riding on Felfire Crusher)
GridStatusRaidDebuff:DebuffId(zoneid, 185157, 15, 6, 6) -- Burn (cone dot)
-- Felfire Munitions
GridStatusRaidDebuff:DebuffId(zoneid, 180079, 16, 6, 6) -- Felfire Munitions (carrying, dot)


-- Iron Reaver
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Iron Reaver")
GridStatusRaidDebuff:DebuffId(zoneid, 182280, 21, 6, 6) -- Artillery (targetted)
GridStatusRaidDebuff:DebuffId(zoneid, 185242, 22, 5, 5, true, true) -- Blitz (carry, silence, dispellable, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 182003, 23, 1, 1) -- Fuel Streak (movement)
GridStatusRaidDebuff:DebuffId(zoneid, 182074, 24, 3, 3, true, true) -- Immolation (stacking dot)
GridStatusRaidDebuff:DebuffId(zoneid, 182001, 25, 4, 4, true, true) -- Unstable Orb (stacking dot)
-- Volatile Firebomb
GridStatusRaidDebuff:DebuffId(zoneid, 185978, 26, 2, 2, true, true) -- Firebomb Vulnerability (stacking debuff)

-- Kormrok
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Kormrok")
GridStatusRaidDebuff:DebuffId(zoneid, 181306, 31, 6, 6, true) -- Explosive Burst (tank stun, explosion)
GridStatusRaidDebuff:DebuffId(zoneid, 181321, 32, 1, 1, true) -- Fel Touch (debuff, not dispellable)
-- Grasping Hand
GridStatusRaidDebuff:DebuffId(zoneid, 188081, 33, 2, 2) -- Crush (dot)
-- Crushing Hand (grabs tank until it is killed)
GridStatusRaidDebuff:DebuffId(zoneid, 181345, 34, 5, 5) -- Foul Crush (tank dot)
-- Fiery Pool
GridStatusRaidDebuff:DebuffId(zoneid, 186559, 35, 6, 6) -- Fiery Pool (standing in pool)
-- Fiery Globule
GridStatusRaidDebuff:DebuffId(zoneid, 185519, 36, 2, 2, true) -- Fiery Globule (dot)
-- Shadowy Pool
GridStatusRaidDebuff:DebuffId(zoneid, 181082, 37, 6, 6) -- Shadowy Pool (standing in pool)
-- Shadow Globule
GridStatusRaidDebuff:DebuffId(zoneid, 180270, 38, 2, 2, true) -- Shadow Globule (dot)
-- Foul Pool
GridStatusRaidDebuff:DebuffId(zoneid, 186560, 39, 6, 6) -- Foul Pool (standing in pool)
-- Foul Globule
GridStatusRaidDebuff:DebuffId(zoneid, 185521, 40, 2, 2, true) -- Foul Globule (dot)


-- Hellfire High Council
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Hellfire High Council")
-- Dia Darkwhisper
-- Mark of the Necromancer changes colors and increases damage over time
-- This may be a canditate for priority by spell id when that code is added
GridStatusRaidDebuff:DebuffId(zoneid, 184450, 51, 5, 5) -- Mark of the Necromancer (dot, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 184652, 52, 6, 6) -- Reap (standing in puddle?)
-- Blademaster Jubei'thos
-- Gurtogg Bloodboil
GridStatusRaidDebuff:DebuffId(zoneid, 184847, 53, 4, 4, true, true) -- Acidic Wound (tank dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 184358, 54, 5, 5) -- Fel Rage (aggro target)
GridStatusRaidDebuff:DebuffId(zoneid, 184357, 55, 1, 1, false, true) -- Tainted Blood (debuff, stacks)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 184355, 56, 4, 4, true, true) -- Bloodboil (dot, stacks)


-- Kilrogg Deadeye
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Kilrogg Deadeye")
GridStatusRaidDebuff:DebuffId(zoneid, 188929, 61, 6, 6, true) -- Heart Seeker (targetted)
GridStatusRaidDebuff:DebuffId(zoneid, 188852, 62, 5, 5) -- Blood Splatter (standing in Heart Seeker pool)
GridStatusRaidDebuff:DebuffId(zoneid, 182159, 63, 2, 2) -- Fel Corruption (dot) (on everyone?)
GridStatusRaidDebuff:DebuffId(zoneid, 180200, 64, 4, 4, true, true) -- Shredded Armor (tank debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 181488, 65, 3, 3, true) -- Vision of Death (zoned, dot)
-- Debuffs that are buffs, ignore
GridStatusRaidDebuff:DebuffId(zoneid, 185563, 66, 1, 1, true, false, 0, true) -- Undying Salvation (healer buff, disabled)
GridStatusRaidDebuff:DebuffId(zoneid, 180718, 67, 1, 1, true, false, 0, true) -- Undying Resolve (dps buff, disabled)
GridStatusRaidDebuff:DebuffId(zoneid, 187089, 68, 1, 1, true, false, 0, true) -- Cleansing Aura (disabled)
-- Hulking Terror
GridStatusRaidDebuff:DebuffId(zoneid, 189612, 69, 3, 3, true) -- Rending Howl (dot)
-- Hellblaze Imp
-- Hellblaze Fiend
-- GridStatusRaidDebuff:DebuffId(zoneid, 180575, 62, 5, 5) -- Fel Flames (standing in)
-- make sure stacks and duration are shown for the other spell with the same name
GridStatusRaidDebuff:DebuffId(zoneid, 180575, 70, 5, 5, true, true) -- Fel Flames (standing in)
-- Hellblaze Mistress
GridStatusRaidDebuff:DebuffId(zoneid, 180033, 71, 3, 3, true) -- Cinder Breath (dot)
-- Mythic
-- Fel Puddle
GridStatusRaidDebuff:DebuffId(zoneid, 184067, 72, 5, 5) -- Fel Puddle (standing in)


-- Gorefiend
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Gorefiend")
GridStatusRaidDebuff:DebuffId(zoneid, 179864, 81, 5, 5, true) -- Shadow of Death (sent to stomach after 5 sec)
GridStatusRaidDebuff:DebuffId(zoneid, 181295, 82, 3, 3, true) -- Digest (dot, in stomach)
GridStatusRaidDebuff:DebuffId(zoneid, 179867, 83, 2, 2, true) -- Gorefiend's Corruption (stomach debuff, death is permanent)
GridStatusRaidDebuff:DebuffId(zoneid, 179978, 84, 6, 6, true) -- Touch of Doom  (player spawns void zone)
GridStatusRaidDebuff:DebuffId(zoneid, 179995, 86, 5, 5) -- Doom Well (standing in puddle)
GridStatusRaidDebuff:DebuffId(zoneid, 179909, 85, 6, 6, true) -- Shared Fate (dot) (179908 non-rooted, 179909 rooted)
-- Enraged Spirit (tank add in stomach)
GridStatusRaidDebuff:DebuffId(zoneid, 182601, 86, 5, 5, true, true) -- Fel Fury (standing in puddle, stacks)
-- Shadowy Construct (dps add in stomach)
-- Tortured Essence (healer add in stomach)
-- Gorebound Spirit (Enraged Spirit that made it to center of stomach and spawn outside)
GridStatusRaidDebuff:DebuffId(zoneid, 185189, 87, 5, 5, true, true) -- Fel Flames (tank dot, stacks) (duplicate name)
-- Gorebound Construct (Shadowy Construct spawn)
GridStatusRaidDebuff:DebuffId(zoneid, 180148, 88, 6, 6, true) -- Hunger for Life (fixate)
-- Gorebound Essence (Tortured Essence spawn)
GridStatusRaidDebuff:DebuffId(zoneid, 180093, 89, 1, 1, true) -- Spirit Volley (movement debuff)
-- Pool of Souls (surrounding boss)
GridStatusRaidDebuff:DebuffId(zoneid, 186770, 90, 5, 5) -- Pool of Souls (standing in pool)


-- Shadow-Lord Iskar
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Shadow-Lord Iskar")
-- If second debuff is added, might be nice to mark Eye of Anzu for this fight
GridStatusRaidDebuff:DebuffId(zoneid, 179202, 101, 5, 5) -- Eye Of Anzu (holding)
GridStatusRaidDebuff:DebuffId(zoneid, 185239, 102, 6, 6, false, true) -- Radiance of Anzu (Eye of Anzu stacks)
-- It is important to see who has Phantasmal Winds for passing the Eye of Anzu
GridStatusRaidDebuff:DebuffId(zoneid, 181957, 103, 5, 5, true) -- Phantasmal Winds (player pushed)
GridStatusRaidDebuff:DebuffId(zoneid, 182325, 104, 2, 2, true) -- Phantasmal Wounds (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 182200, 105, 3, 3, true) -- Fel Chakram (targetted)
GridStatusRaidDebuff:DebuffId(zoneid, 185747, 106, 3, 3, true) -- Fel Beam Fixate (fixate)
GridStatusRaidDebuff:DebuffId(zoneid, 182600, 107, 2, 2) -- Fel Fire (standing in puddle)
-- Corrupted Talonpriest
GridStatusRaidDebuff:DebuffId(zoneid, 179219, 108, 4, 4, true) -- Phantasmal Fel Bomb (player is bomb)
GridStatusRaidDebuff:DebuffId(zoneid, 181753, 109, 7, 7, true) -- Fel Bomb (player is bomb, dispellable with eye)
-- GridStatusRaidDebuff:DebuffId(zoneid, 179218, 110, 5, 5) --Phantasmal Obliteration -- not a debuff
-- Illusionary Outcast
-- Fel Raven
GridStatusRaidDebuff:DebuffId(zoneid, 187990, 111, 4, 4, true) -- Phantasmal Corruption (AoE dot)
GridStatusRaidDebuff:DebuffId(zoneid, 187344, 112, 1, 1, true, true) -- Phantasmal Cremation (dam taken increase)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 185510, 113, 2, 2, true) -- Dark Bindings (chained with another player)


-- Socrethar the Eternal
GridStatusRaidDebuff:BossNameId(zoneid, 120, "Socrethar the Eternal")
-- GridStatusRaidDebuff:DebuffId(zoneid, 182635, 121, 5, 5) --Reverberating Blow not a debuff
-- Soulbound Construct
GridStatusRaidDebuff:DebuffId(zoneid, 182038, 122, 3, 3, true, true) -- Shattered Defenses (cone debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 189627, 123, 5, 5, true) -- Volatile Fel Orb (targetted for explosive orb)
GridStatusRaidDebuff:DebuffId(zoneid, 189540, 124, 2, 2, true) -- Overwhelming Power (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 182218, 125, 5, 5) -- Felblaze Residue (standing in fire)
GridStatusRaidDebuff:DebuffId(zoneid, 180415, 126, 1, 1, true) -- Fel Prison (stun, 99% reduction damage taken)
-- Haunting Soul
GridStatusRaidDebuff:DebuffId(zoneid, 182769, 127, 6, 6) -- Ghastly Fixation (targetted)
GridStatusRaidDebuff:DebuffId(zoneid, 182900, 128, 4, 4, true) -- Virulent Haunt (dot, horrify)
-- Sargerei Dominator
GridStatusRaidDebuff:DebuffId(zoneid, 184124, 129, 3, 3, true) -- Gift Of The Man'ari (dot)
-- Sargerei Shadowcaller
GridStatusRaidDebuff:DebuffId(zoneid, 184239, 130, 4, 4, true, true) -- Shadow Word: Agony (dot, stacks, magic dispellable)
-- Enrage (Soulbound Construct)
GridStatusRaidDebuff:DebuffId(zoneid, 190922, 131, 2, 2, true, true) -- Unbounded Power (dot, stacks)

-- Fel Lord Zakuun
GridStatusRaidDebuff:BossNameId(zoneid, 140, "Fel Lord Zakuun")
GridStatusRaidDebuff:DebuffId(zoneid, 181508, 141, 6, 6, true) --Seed Of Destruction (player emits waves)
GridStatusRaidDebuff:DebuffId(zoneid, 179428, 142, 5, 5) -- Rumbling Fissure (standing in fire)
GridStatusRaidDebuff:DebuffId(zoneid, 182008, 143, 2, 2, true) -- Latent Energy (debuff, explodes if hit)
GridStatusRaidDebuff:DebuffId(zoneid, 189260, 144, 3, 3, true) -- Cloven Soul (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 179407, 145, 1, 1, true) -- Disembodied (Shadow Realm)
-- Befouled starts red (189030) switches to orange (189031) then to green (189032)
-- GridStatusRaidDebuff:DebuffId(zoneid, 179711, 136, 6, 6) --Befouled -- not the debuff
GridStatusRaidDebuff:DebuffId(zoneid, 189030, 146, 6, 6) -- Befouled (healing absorb)
-- GridStatusRaidDebuff:DebuffId(zoneid, 189031, 136, 6, 6) --Befouled Orange
-- GridStatusRaidDebuff:DebuffId(zoneid, 189032, 136, 6, 6) --Befouled Green
-- Fel Crystal
GridStatusRaidDebuff:DebuffId(zoneid, 181653, 147, 5, 5) -- Fel Crystals (standing near)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 188998, 148, 2, 2, true) -- Exhausted Soul (debuff, rumbling fissure)


-- Xhul'horac
GridStatusRaidDebuff:BossNameId(zoneid, 150, "Xhul'horac")
GridStatusRaidDebuff:DebuffId(zoneid, 186134, 151, 2, 2, true) -- Feltouched (debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 186135, 152, 2, 2, true) -- Voidtouched (debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 186407, 153, 7, 7, true) -- Fel Surge (dot, drops fire)
GridStatusRaidDebuff:DebuffId(zoneid, 186333, 154, 7, 7, true) -- Void Surge (dot, drops fire)
GridStatusRaidDebuff:DebuffId(zoneid, 185656, 155, 1, 1, true, true) -- Shadowfel Annihilation (debuff)
-- Vanguard Akkelion
GridStatusRaidDebuff:DebuffId(zoneid, 186500, 156, 6, 6, false, true) --Chains Of Fel
GridStatusRaidDebuff:DebuffId(zoneid, 186448, 157, 4, 4, true, true) -- Felblaze Flurry (tank debuff stack)
-- Wild Pyromaniac
GridStatusRaidDebuff:DebuffId(zoneid, 188208, 158, 3, 3, true, true) -- Ablaze (stacking dot)
-- Omnus
GridStatusRaidDebuff:DebuffId(zoneid, 186547, 159, 5, 5) -- Black Hole (sucking in, dot)
GridStatusRaidDebuff:DebuffId(zoneid, 186785, 160, 4, 4, true, true) -- Withering Gaze (tank debuff stack)
-- Unstable Voidfiend
-- Chaotic Felblaze
GridStatusRaidDebuff:DebuffId(zoneid, 186073, 161, 3, 3, true, true) -- Felsinged (stacking dot, standing in fire)
-- Creeping Void
GridStatusRaidDebuff:DebuffId(zoneid, 186063, 162, 3, 3, true, true) -- Wasting Void (stacking dot, standing in fire)


-- Tyrant Velhari
GridStatusRaidDebuff:BossNameId(zoneid, 170, "Tyrant Velhari")
GridStatusRaidDebuff:DebuffId(zoneid, 180166, 171, 5, 5) -- Touch Of Harm (healing absorb, dispellable, jumps on dispel)
GridStatusRaidDebuff:DebuffId(zoneid, 180128, 172, 6, 6, true) -- Edict Of Condemnation (targetted, split damage)
GridStatusRaidDebuff:DebuffId(zoneid, 180526, 173, 6, 6, true) -- Font of Corruption (targetted by Tainted Shadows)
GridStatusRaidDebuff:DebuffId(zoneid, 180000, 174, 4, 4, true, true) -- Seal of Decay (tank debuff stack, healing reduction)
GridStatusRaidDebuff:DebuffId(zoneid, 181683, 175, 1, 1) -- Aura of Oppression (phase 1 movement causes damage)
GridStatusRaidDebuff:DebuffId(zoneid, 179987, 176, 1, 1) -- Aura of Contempt (phase 2 healing debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 179993, 177, 1, 1) -- Aura of Malice (phase 3 buff/debuff)
-- Ancient Enforcer
-- Ancient Harbinger
-- Despoiled Ground
GridStatusRaidDebuff:DebuffId(zoneid, 180604, 178, 3, 3) -- Despoiled Ground (standing in void zone)
-- Ancient Sovereign


-- Mannoroth
GridStatusRaidDebuff:BossNameId(zoneid, 180, "Mannoroth")
-- Phase 1
-- Fel Iron Summoner
-- Demon Portal
GridStatusRaidDebuff:DebuffId(zoneid, 181099, 181, 6, 6) -- Mark Of Doom
GridStatusRaidDebuff:DebuffId(zoneid, 181275, 182, 3, 3, true) -- Curse of the Legion (curse, dispellable, summons demon lord)
-- Doom Lord
GridStatusRaidDebuff:DebuffId(zoneid, 181119, 183, 4, 4, true, true) -- Doom Spike (tank debuff stack)
-- Fel Imp
-- Dread Infernal
-- Blood of Mannoroth
GridStatusRaidDebuff:DebuffId(zoneid, 182171, 184, 2, 2) -- Blood of Mannoroth (standing in pool)
-- Phase 2
GridStatusRaidDebuff:DebuffId(zoneid, 181359, 185, 5, 5) -- Massive Blast (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 184252, 186, 3, 3) -- Puncture Wound (tank debuff if no active mitigation)
GridStatusRaidDebuff:DebuffId(zoneid, 181597, 187, 4, 4) -- Mannoroth's Gaze (fear, split AoE)
-- Phase 3
GridStatusRaidDebuff:DebuffId(zoneid, 181841, 188, 6, 6) -- Shadowforce (dot, pushback)
GridStatusRaidDebuff:DebuffId(zoneid, 182113, 189, 1, 1, true, false, 0, true) -- Lingering Forces (movement buff)
-- Phase 4
GridStatusRaidDebuff:DebuffId(zoneid, 182088, 190, 6, 6) -- Empowered Shadowforce (dot, pushback)
GridStatusRaidDebuff:DebuffId(zoneid, 182006, 191, 4, 4) -- Empowered Mannoroth's Gaze (fear, split AoE, leaves puddle)
-- Gazing Shadows
GridStatusRaidDebuff:DebuffId(zoneid, 182031, 192, 3, 3) -- Gazing Shadows (standing in void zone)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 186362, 193, 6, 6, false, true) -- Wrath of Gul'dan (stacked debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 190482, 194, 2, 2, true, true) -- Gripping Shadows (stacking debuff)

-- Archimonde
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Archimonde")
-- GridStatusRaidDebuff:DebuffId(zoneid, 185590, 200, 6, 6) -- Desecrate (not a debuff)
-- Phase 1
GridStatusRaidDebuff:DebuffId(zoneid, 183634, 201, 6, 6, true) -- Shadowfel Burst (target, thrown in air)
GridStatusRaidDebuff:DebuffId(zoneid, 183828, 202, 4, 4) -- Death Brand (tank dot)
GridStatusRaidDebuff:DebuffId(zoneid, 183963, 203, 1, 1, true, false, 0, true) -- Light of the Naaru (movement buff, immune to shadow damage)
-- Doomfire Spirit
GridStatusRaidDebuff:DebuffId(zoneid, 182879, 204, 6, 6, true) -- Doomfire Fixate (target)
GridStatusRaidDebuff:DebuffId(zoneid, 182878, 205, 2, 2, true, true) -- Doomfire (stacking dot, from stepping in)
-- Hellfire Deathcaller
GridStatusRaidDebuff:DebuffId(zoneid, 183864, 206, 3, 3, true, true) -- Shadow Blast (stacking debuff)
-- Phase 2
GridStatusRaidDebuff:DebuffId(zoneid, 184964, 207, 6, 6) -- Shackled Torment (debuff, raid damage when removed)
GridStatusRaidDebuff:DebuffId(zoneid, 186123, 208, 5, 5, true, true) -- Wrought Chaos (player explodes towards Focused Chaos target)
GridStatusRaidDebuff:DebuffId(zoneid, 185014, 209, 5, 5, true) -- Focused Chaos (target)
-- Felborne Overfiend
-- Dreadstalker
-- Phase 3
GridStatusRaidDebuff:DebuffId(zoneid, 186961, 210, 6, 6, true) -- Nether Banish (tank banish)
-- Nether Tear
GridStatusRaidDebuff:DebuffId(zoneid, 189891, 211, 3, 3) -- Nether Tear (standing in void zone)
-- Living Shadows
GridStatusRaidDebuff:DebuffId(zoneid, 187047, 212, 2, 2, true) -- Devour Life (healing debuff)
-- Twisting Nether
GridStatusRaidDebuff:DebuffId(zoneid, 190341, 213, 2, 2, true, true) -- Nether Corruption (stacking debuff)
-- Shadowed Netherwalker
GridStatusRaidDebuff:DebuffId(zoneid, 187255, 214, 3, 3) -- Nether Storm (standing in)
-- Void Star
GridStatusRaidDebuff:DebuffId(zoneid, 189895, 215, 5, 5) -- Void Star Fixate (fixate)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 190400, 216, 3, 3, true, true) -- Touch of the Legion (debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 187050, 217, 6, 6, true) -- Mark of the Legion (split damage)
-- Source of Chaos
GridStatusRaidDebuff:DebuffId(zoneid, 190706, 218, 2, 2, true, true) -- Source of Chaos (stacking debuff)

