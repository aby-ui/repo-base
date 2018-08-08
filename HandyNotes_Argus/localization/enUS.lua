local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_Argus", "enUS", true, true)

if not _L then return end

if _L then

--
-- DATA
--

--
--	READ THIS BEFORE YOU TRANSLATE !!!
-- 
--	DO NOT TRANSLATE THE RARE NAMES HERE UNLESS YOU HAVE A GOOD REASON!!!
--	FOR EU KEEP THE RARE PART AS IT IS. CHINA & CO MAY NEED TO ADJUST!!!
--
--	_L["Rarename_search"] must have at least 2 Elements! First is the hardfilter, >=2nd are softfilters
--	Keep the hardfilter as general as possible. If you must, set it to "".
--	These Names are only used for the Group finder!
--	Tooltip names are already localized!
--

_L["Watcher Aival"] = "Watcher Aival";
_L["Watcher Aival_search"] = { "aival", "aival" };
_L["Watcher Aival_note"] = "";
_L["Puscilla"] = "Puscilla";
_L["Puscilla_search"] = { "pus", "puscilla" };
_L["Puscilla_note"] = "Entrance to the cave is south east - use the eastern bridge to get there.";
_L["Vrax'thul"] = "Vrax'thul";
_L["Vrax'thul_search"] = { "vrax", "vrax'thul", "vraxthul", "vrax thul" };
_L["Vrax'thul_note"] = "";
_L["Ven'orn"] = "Ven'orn";
_L["Ven'orn_search"] = { "ven", "ven'orn", "venorn", "ven orn" };
_L["Ven'orn_note"] = "The entrance to the cave is north east from here in the spider area at 66, 54.1";
_L["Varga"] = "Varga";
_L["Varga_search"] = { "var", "varga" };
_L["Varga_note"] = "";
_L["Lieutenant Xakaar"] = "Lieutenant Xakaar";
_L["Lieutenant Xakaar_search"] = { "xa", "xakaar" };
_L["Lieutenant Xakaar_note"] = "";
_L["Wrath-Lord Yarez"] = "Wrath-Lord Yarez";
_L["Wrath-Lord Yarez_search"] = { "ya", "yarez" };
_L["Wrath-Lord Yarez_note"] = "";
_L["Inquisitor Vethroz"] = "Inquisitor Vethroz";
_L["Inquisitor Vethroz_search"] = { "vet", "vethroz", "vetroz" };
_L["Inquisitor Vethroz_note"] = "";
_L["Portal to Commander Texlaz"] = "Portal to Commander Texlaz";
_L["Portal to Commander Texlaz_note"] = "";
_L["Commander Texlaz"] = "Commander Texlaz";
_L["Commander Texlaz_search"] = { "tex", "texlaz" };
_L["Commander Texlaz_note"] = "Use the portal at 80.2, 62.3 to get on the ship";
_L["Admiral Rel'var"] = "Admiral Rel'var";
_L["Admiral Rel'var_search"] = { "rel", "rel.?var" };
_L["Admiral Rel'var_note"] = "";
_L["All-Seer Xanarian"] = "All-Seer Xanarian";
_L["All-Seer Xanarian_search"] = { "xa", "xanar" };
_L["All-Seer Xanarian_note"] = "";
_L["Worldsplitter Skuul"] = "Worldsplitter Skuul";
_L["Worldsplitter Skuul_search"] = { "sku", "skuul", "skul" };
_L["Worldsplitter Skuul_note"] = "May be flying around in circles. Will be near ground sometimes. Not on every round though.";
_L["Houndmaster Kerrax"] = "Houndmaster Kerrax";
_L["Houndmaster Kerrax_search"] = { "ker", "kerrax", "kerax" };
_L["Houndmaster Kerrax_note"] = "";
_L["Void Warden Valsuran"] = "Void Warden Valsuran";
_L["Void Warden Valsuran_search"] = { "val", "valsuran" };
_L["Void Warden Valsuran_note"] = "";
_L["Chief Alchemist Munculus"] = "Chief Alchemist Munculus";
_L["Chief Alchemist Munculus_search"] = { "mun", "munculus", "muculus" };
_L["Chief Alchemist Munculus_note"] = "";
_L["The Many-Faced Devourer"] = "The Many-Faced Devourer";
_L["The Many-Faced Devourer_search"] = { "face", "many.*face", "face.*devourer" };
_L["The Many-Faced Devourer_note"] = "Can always be summoned. However you need to find 'Call of the Devourer' from the enemies around there and then collect 3 more things and return to the pile of bones to summon him.";
_L["Portal to Squadron Commander Vishax"] = "Portal to Squadron Commander Vishax";
_L["Portal to Squadron Commander Vishax_note"] = "First find a Smashed Portal Generator from Immortal Netherwalker. Then collect Conductive Sheath, Arc Circuit and Power Cell from Eredar War-Mind and Felsworn Myrmidon. Use the Smashed Portal Generator to unlock the portal to Vishax.";
_L["Squadron Commander Vishax"] = "Squadron Commander Vishax";
_L["Squadron Commander Vishax_search"] = { "vis", "vishax", "visax" };
_L["Squadron Commander Vishax_note"] = "Use portal at 77.2, 73.2 to get up on the ship";
_L["Doomcaster Suprax"] = "Doomcaster Suprax";
_L["Doomcaster Suprax_search"] = { "sup", "suprax" };
_L["Doomcaster Suprax_note"] = "Stand on all 3 runes to summon him. 5 minute respawn timer if you fail!";
_L["Mother Rosula"] = "Mother Rosula";
_L["Mother Rosula_search"] = { "ros", "rosula" };
_L["Mother Rosula_note"] = "Inside cave. Use the eastern bridge. Collect 100 Imp Meat which drop from the imps inside the cave. Use it and place the Disgusting Feast into the green soup at the marked spot.";
_L["Rezira the Seer"] = "Rezira the Seer";
_L["Rezira the Seer_search"] = { "rez", "rezira" };
_L["Rezira the Seer_note"] = "Use Observer's Locus Resonator to open a portal to him. Orix the All-Seer (60.2, 45.4) sells it for 500 Intact Demon Eyes.";
_L["Blistermaw"] = "Blistermaw";
_L["Blistermaw_search"] = { "blis", "blister" };
_L["Blistermaw_note"] = "";
_L["Mistress Il'thendra"] = "Mistress Il'thendra";
_L["Mistress Il'thendra_search"] = { "then", "thendra" };
_L["Mistress Il'thendra_note"] = "";
_L["Gar'zoth"] = "Gar'zoth";
_L["Gar'zoth_search"] = { "gar", "gar.?zot" };
_L["Gar'zoth_note"] = "";

_L["One-of-Many"] = "One-of-Many";
_L["One-of-Many_note"] = "";
_L["Minixis"] = "Minixis";
_L["Minixis_note"] = "";
_L["Watcher"] = "Watcher";
_L["Watcher_note"] = "";
_L["Bloat"] = "Bloat";
_L["Bloat_note"] = "";
_L["Earseeker"] = "Earseeker";
_L["Earseeker_note"] = "";
_L["Pilfer"] = "Pilfer";
_L["Pilfer_note"] = "";

_L["Orix the All-Seer"] = "Orix the All-Seer";
_L["Orix the All-Seer_note"] = "Find green demonic eyes. Click them. Lose 90% hp and start farming eyes from all demons in this zone.";

_L["Forgotten Legion Supplies"] = "Forgotten Legion Supplies";
_L["Forgotten Legion Supplies_note"] = "Rocks block the way. Use Lightforged Warframe Jump to crush the boulders.";
_L["Ancient Legion War Cache"] = "Ancient Legion War Cache";
_L["Ancient Legion War Cache_note"] = "Carefully jump down to reach the little cave. Glider helps a lot. Remove rocks with Lights's Judgment.";
_L["Fel-Bound Chest"] = "Fel-Bound Chest";
_L["Fel-Bound Chest_note"] = "Start a little south east, at 53.7, 30.9. Jump over the rocks to reach the cave. Rocks block the way into the cave. Remove them with Lights's Judgment.";
_L["Legion Treasure Hoard"] = "Legion Treasure Hoard";
_L["Legion Treasure Hoard_note"] = "Behind Fel Fall. Just pick it up.";
_L["Timeworn Fel Chest"] = "Timeworn Fel Chest";
_L["Timeworn Fel Chest_note"] = "Start at All-Seer Xanarian. Run past his building on the left side. Hop down a few rocks to reach the chest surrounded by green ooze.";
_L["Missing Augari Chest"] = "Missing Augari Chest";
_L["Missing Augari Chest_note"] = "Chest is down by the green ooze. Use Shroud of Arcane Echoes and then open the chest.";

-- 48382
_L["48382_67546980_note"] = "Inside building";
_L["48382_67466226_note"] = "";
_L["48382_71326946_note"] = "Next to Hadrox";
_L["48382_58066806_note"] = "";
_L["48382_68026624_note"] = "Inside legion structure";
_L["48382_64506868_note"] = "Outside";
_L["48382_62666823_note"] = "Inside Building";
_L["48382_60096945_note"] = "Outside, behind building";
_L["48382_62146938_note"] = "";
_L["48382_69496785_note"] = "";
_L["48382_58806467_note"] = "Inside Building";
_L["48382_57796495_note"] = "";
-- 48383
_L["48383_56903570_note"] = "";
_L["48383_57633179_note"] = "";
_L["48383_52182918_note"] = "";
_L["48383_58174021_note"] = "";
_L["48383_51863409_note"] = "";
_L["48383_55133930_note"] = "";
_L["48383_58413097_note"] = "Inside building, floor level";
_L["48383_53753556_note"] = "";
_L["48383_51703529_note"] = "High up on the cliffs";
_L["48383_59853583_note"] = "";
_L["48383_58273570_note"] = "Inside building, entrance from Il'thendra platform";
-- 48384
_L["48384_60872900_note"] = "";
_L["48384_61332054_note"] = "Inside Munculus building";
_L["48384_59081942_note"] = "Inside building";
_L["48384_64152305_note"] = "Inside Houndmaster Kerrax cave";
_L["48384_66621709_note"] = "Inside Imp cave, next to Mother Rosula";
_L["48384_63682571_note"] = "In front of Houndmaster Kerrax cave";
_L["48384_61862236_note"] = "Outside, next to Chief Alchemist Munculus";
_L["48384_64132738_note"] = "";
_L["48384_63522090_note"] = "Back end of Kerrax cave";
-- 48385
_L["48385_50605720_note"] = "";
_L["48385_55544743_note"] = "";
_L["48385_57135124_note"] = "";
_L["48385_55915425_note"] = "";
_L["48385_48195451_note"] = "";
_L["48385_57825901_note"] = "";
-- 48387
_L["48387_69403965_note"] = "";
_L["48387_66643654_note"] = "";
_L["48387_68983342_note"] = "";
_L["48387_65522831_note"] = "Under the bridge";
_L["48387_73404669_note"] = "Jump over the ooze";
_L["48387_67954006_note"] = "";
_L["48387_63603642_note"] = "";
_L["48387_72404207_note"] = "";
-- 48388
_L["48388_51502610_note"] = "";
_L["48388_59261743_note"] = "";
_L["48388_55921387_note"] = "";
_L["48388_55841722_note"] = "";
_L["48388_55622042_note"] = "Near Valsuran, jump up the rocky slope";
_L["48388_59661398_note"] = "";
_L["48388_54102803_note"] = "Near Aivals plattform";
_L["48388_55922675_note"] = "";
-- 48389
_L["48389_64305040_note"] = "In Vargas cave";
_L["48389_60254351_note"] = "";
_L["48389_65514081_note"] = "";
_L["48389_60304675_note"] = "";
_L["48389_65345192_note"] = "In cave behind Varga";
_L["48389_64114242_note"] = "Under rocks";
_L["48389_58734323_note"] = "On small piece of land within ooze";
_L["48389_62955007_note"] = "On green ooze shore";
_L["48389_64254720_note"] = "";
-- 48390
_L["48390_81306860_note"] = "On ship";
_L["48390_80406152_note"] = "";
_L["48390_82566503_note"] = "On ship";
_L["48390_73316858_note"] = "Top level next to Admiral Rel'var";
_L["48390_77127529_note"] = "Next to Vishax Portal";
_L["48390_72527293_note"] = "Behind Rel'var";
_L["48390_77255876_note"] = "Down the slope";
_L["48390_72215680_note"] = "Inside building";
_L["48390_73277299_note"] = "Behind Rel'var";
_L["48390_77975620_note"] = "Down the slope and further over the cliffs";
_L["48390_77246412_note"] = "Be careful on the way back. Don't jump down the cliffs!";
_L["48390_76595659_note"] = "Inside Xanarian's building";
-- 48391
_L["48391_64135867_note"] = "In Ven'orn spider cave";
_L["48391_67404790_note"] = "Spider area, in a small cave next to the northern exit";
_L["48391_63615622_note"] = "In Ven'orn spider cave";
_L["48391_65005049_note"] = "Outside in spider area";
_L["48391_63035762_note"] = "In Ven'orn spider cave";
_L["48391_65185507_note"] = "Upper entrance to spider area";
_L["48391_68095075_note"] = "Inside small cave in spider area";
_L["48391_69815522_note"] = "Outside in spider area";
_L["48391_71205441_note"] = "Outside in spider area";
_L["48391_66544668_note"] = "Exit the spider area north where the green zone is on the ground. Jump up the rocks.";
_L["48391_65164951_note"] = "Inside small cave in spider area";

-- Krokuun
_L["Khazaduum"] = "Khazaduum";
_L["Khazaduum_search"] = { "aza", "khazadum", "khazaduum", "kazadum", "kazaduum" };
_L["Khazaduum_note"] = "Entrance is south east at 50.3, 17.3";
_L["Commander Sathrenael"] = "Commander Sathrenael";
_L["Commander Sathrenael_search"] = { "sat", "sathrenael" };
_L["Commander Sathrenael_note"] = "";
_L["Commander Endaxis"] = "Commander Endaxis";
_L["Commander Endaxis_search"] = { "end", "endaxis" };
_L["Commander Endaxis_note"] = "";
_L["Sister Subversia"] = "Sister Subversia";
_L["Sister Subversia_search"] = { "sub", "subversia" };
_L["Sister Subversia_note"] = "";
_L["Siegemaster Voraan"] = "Siegemaster Voraan";
_L["Siegemaster Voraan_search"] = { "vor", "voran", "voraan" };
_L["Siegemaster Voraan_note"] = "";
_L["Talestra the Vile"] = "Talestra the Vile";
_L["Talestra the Vile_search"] = { "tal", "talestra" };
_L["Talestra the Vile_note"] = "";
_L["Commander Vecaya"] = "Commander Vecaya";
_L["Commander Vecaya_search"] = { "vec", "veca[yj]a" };
_L["Commander Vecaya_note"] = "The path up to her starts east at 42, 57.1";
_L["Vagath the Betrayed"] = "Vagath the Betrayed";
_L["Vagath the Betrayed_search"] = { "vag", "vagat" };
_L["Vagath the Betrayed_note"] = "";
_L["Tereck the Selector"] = "Tereck the Selector";
_L["Tereck the Selector_search"] = { "ter", "tereck", "terek" };
_L["Tereck the Selector_note"] = "";
_L["Tar Spitter"] = "Tar Spitter";
_L["Tar Spitter_search"] = { "tar", "tar.*spitter" };
_L["Tar Spitter_note"] = "";
_L["Imp Mother Laglath"] = "Imp Mother Laglath";
_L["Imp Mother Laglath_search"] = { "lag", "laglat" };
_L["Imp Mother Laglath_note"] = "";
_L["Naroua"] = "Naroua";
_L["Naroua_search"] = { "nar", "naroua" };
_L["Naroua_note"] = "";

_L["Baneglow"] = "Baneglow";
_L["Baneglow_note"] = "";
_L["Foulclaw"] = "Foulclaw";
_L["Foulclaw_note"] = "";
_L["Ruinhoof"] = "Ruinhoof";
_L["Ruinhoof_note"] = "";
_L["Deathscreech"] = "Deathscreech";
_L["Deathscreech_note"] = "";
_L["Gnasher"] = "Gnasher";
_L["Gnasher_note"] = "";
_L["Retch"] = "Retch";
_L["Retch_note"] = "";

-- Shoot First, Loot Later
_L["Krokul Emergency Cache"] = "Krokul Emergency Cache";
_L["Krokul Emergency Cache_note"] = "Cave is up on the cliffs. Rocks block the way. Use Lightforged Warframe's jump ability to shatter the rocks.";
_L["Legion Tower Chest"] = "Legion Tower Chest";
_L["Legion Tower Chest_note"] = "On the path to Naroua there are boulders blocking the way to this chest. Remove them with Light's Judgement.";
_L["Lost Krokul Chest"] = "Lost Krokul Chest";
_L["Lost Krokul Chest_note"] = "In little cave along the path. Use Light's Judgment to remove the boulders.";
_L["Long-Lost Augari Treasure"] = "Long-Lost Augari Treasure";
_L["Long-Lost Augari Treasure_note"] = "Use Shroud of Arcane Echoes and then open the chest.";
_L["Precious Augari Keepsakes"] = "Precious Augari Keepsakes";
_L["Precious Augari Keepsakes_note"] = "Use Shroud of Arcane Echoes and then open the chest.";

-- 47752
_L["47752_55555863_note"] = "Jump on the rocks, start slightly west";
_L["47752_52185431_note"] = "Run the path up to the top where you've first seen Alleria";
_L["47752_50405122_note"] = "Run the path up to the top where you've first seen Alleria";
_L["47752_53265096_note"] = "Run the path up to the top where you've first seen Alleria. On the other side of the green ooze. Fel hurts!";
_L["47752_57005472_note"] = "Under the rock outcropping, on the tiny lip of land";
_L["47752_59695196_note"] = "Near to Xeth'tal, behind the rocks.";
_L["47752_51425958_note"] = "";
_L["47752_55525237_note"] = "Lower level in the area. Need to jump through green shit. Annoying chest. Start at Xeth'tal.";
_L["47752_58375051_note"] = "";
-- 47753
_L["47753_53167308_note"] = "";
_L["47753_55228114_note"] = "";
_L["47753_59267341_note"] = "";
_L["47753_56118037_note"] = "Outside Talestra building";
_L["47753_58597958_note"] = "Behind demon spike";
_L["47753_58197157_note"] = "";
_L["47753_52737591_note"] = "Behind rocks";
_L["47753_58048036_note"] = "";
_L["47753_60297610_note"] = "";
_L["47753_56827212_note"] = "";
-- 47997
_L["47997_45876777_note"] = "Under rock, next to bridge";
_L["47997_45797753_note"] = "";
_L["47997_43858139_note"] = "Path starts at 49.1, 69.3. Follow the ridge southwards till you reach the chest.";
_L["47997_43816689_note"] = "Under rocks. Jump down from path near bridge.";
_L["47997_40687531_note"] = "";
_L["47997_46996831_note"] = "On top of serpent skull";
_L["47997_41438003_note"] = "Climb up the rocks to the crashed legion ship";
_L["47997_41548379_note"] = "";
_L["47997_46458665_note"] = "Jump over the rocks to reach this chest.";
_L["47997_40357414_note"] = "";
_L["47997_44198653_note"] = "";
_L["47997_46787984_note"] = "";
_L["47997_42737546_note"] = "";
-- 47999
_L["47999_62592581_note"] = "";
_L["47999_59763951_note"] = "";
_L["47999_59071884_note"] = "Up, behind rocks";
_L["47999_61643520_note"] = "";
_L["47999_61463580_note"] = "Inside building";
_L["47999_59603052_note"] = "Bridge level";
_L["47999_60891852_note"] = "Inside hut behind Vagath";
_L["47999_49063350_note"] = "";
_L["47999_65992286_note"] = "";
_L["47999_64632319_note"] = "Inside building";
_L["47999_51533583_note"] = "Outside building, over the litte ooze lake";
_L["47999_60422354_note"] = "";
_L["47999_62763812_note"] = "Inside building";
_L["47999_60492781_note"] = "";
_L["47999_46768337_note"] = "";
_L["47999_59433273_note"] = "Up on the cliff";
_L["47999_58442866_note"] = "Inside building";
_L["47999_48613092_note"] = "";
_L["47999_57642617_note"] = "Up on the cliff";
-- 48000
_L["48000_70907370_note"] = "";
_L["48000_74136790_note"] = "";
_L["48000_75166435_note"] = "Back end of cave";
_L["48000_69605772_note"] = "";
_L["48000_69787836_note"] = "Jump up the slope next to it";
_L["48000_68566054_note"] = "In front of Tereck the Selector's cave";
_L["48000_72896482_note"] = "";
_L["48000_71827536_note"] = "";
_L["48000_73577146_note"] = "";
_L["48000_71846166_note"] = "Climb up the tipped pillar";
_L["48000_67886231_note"] = "Behind pillar";
_L["48000_74996922_note"] = "";
_L["48000_62946824_note"] = "In the upper cave. Ride up the rocks east from here to reach the upper cave.";
_L["48000_69386278_note"] = "";
_L["48000_67656999_note"] = "Ride up the slope and over the tipped pillars to reach this chest.";
_L["48000_69218397_note"] = "";
-- 48336
_L["48336_33575511_note"] = "Xenadar upper level, outside";
_L["48336_32047441_note"] = "";
_L["48336_27196668_note"] = "";
_L["48336_31936750_note"] = "";
_L["48336_35415637_note"] = "Ground level, in front of bottom entrance to the Xenedar";
_L["48336_29645761_note"] = "Inside cave";
_L["48336_40526067_note"] = "Inside yellow hut";
_L["48336_36205543_note"] = "Inside the Xenadar, upper level";
_L["48336_25996814_note"] = "";
_L["48336_37176401_note"] = "Under debris";
_L["48336_28247134_note"] = "";
_L["48336_30276403_note"] = "Inside escape pod";
_L["48336_34566305_note"] = "";
_L["48336_36605881_note"] = "Xenadar upper level, outside";
-- 48339
_L["48339_68533891_note"] = "";
_L["48339_63054240_note"] = "";
_L["48339_64964156_note"] = "";
_L["48339_73393438_note"] = "";
_L["48339_72213234_note"] = "Behind the giant skull";
_L["48339_65983499_note"] = "";
_L["48339_64934217_note"] = "Inside tree trunk";
_L["48339_67713454_note"] = "";
_L["48339_72493605_note"] = "";
_L["48339_44864342_note"] = "";
_L["48339_46094082_note"] = "";
_L["48339_70503063_note"] = "";
_L["48339_61876413_note"] = "";

-- Mac'Aree
_L["Shadowcaster Voruun"] = "Shadowcaster Voruun";
_L["Shadowcaster Voruun_search"] = { "vor", "voruun", "vorun" };
_L["Shadowcaster Voruun_note"] = "";
_L["Soultwisted Monstrosity"] = "Soultwisted Monstrosity";
_L["Soultwisted Monstrosity_search"] = { "mon", "monstro" };
_L["Soultwisted Monstrosity_note"] = "";
_L["Wrangler Kravos"] = "Wrangler Kravos";
_L["Wrangler Kravos_search"] = { "kra", "kravos" };
_L["Wrangler Kravos_note"] = "";
_L["Kaara the Pale"] = "Kaara the Pale";
_L["Kaara the Pale_search"] = { "ka", "ka?ara" };
_L["Kaara the Pale_note"] = "";
_L["Feasel the Muffin Thief"] = "Feasel the Muffin Thief";
_L["Feasel the Muffin Thief_search"] = { "f", "feasel", "muffin" };
_L["Feasel the Muffin Thief_note"] = "Interrupt burrow";
_L["Vigilant Thanos"] = "Vigilant Thanos";
_L["Vigilant Thanos_search"] = { "ano", "th?anos" };
_L["Vigilant Thanos_note"] = "";
_L["Vigilant Kuro"] = "Vigilant Kuro";
_L["Vigilant Kuro_search"] = { "kuro", "kuro" };
_L["Vigilant Kuro_note"] = "";
_L["Venomtail Skyfin"] = "Venomtail Skyfin";
_L["Venomtail Skyfin_search"] = { "i", "venomtail", "skyfin" };
_L["Venomtail Skyfin_note"] = "";
_L["Turek the Lucid"] = "Turek the Lucid";
_L["Turek the Lucid_search"] = { "tur", "turek" };
_L["Turek the Lucid_note"] = "Down the stairs into the building";
_L["Captain Faruq"] = "Captain Faruq";
_L["Captain Faruq_search"] = { "far", "faruq" };
_L["Captain Faruq_note"] = "";
_L["Umbraliss"] = "Umbraliss";
_L["Umbraliss_search"] = { "umb", "umbralis" };
_L["Umbraliss_note"] = "";
_L["Sorolis the Ill-Fated"] = "Sorolis the Ill-Fated";
_L["Sorolis the Ill-Fated_search"] = { "sor", "sorolis" };
_L["Sorolis the Ill-Fated_note"] = "";
_L["Herald of Chaos"] = "Herald of Chaos";
_L["Herald of Chaos_search"] = { "a", "herald", "harald" };
_L["Herald of Chaos_note"] = "He's on the 2nd floor.";
_L["Sabuul"] = "Sabuul";
_L["Sabuul_search"] = { "sab", "sabuul", "sabul" };
_L["Sabuul_note"] = "";
_L["Jed'hin Champion Vorusk"] = "Jed'hin Champion Vorusk";
_L["Jed'hin Champion Vorusk_search"] = { "", "vorusk", "jed.?hin" };
_L["Jed'hin Champion Vorusk_note"] = "";
_L["Overseer Y'Beda"] = "Overseer Y'Beda";
_L["Overseer Y'Beda_search"] = { "beda", "beda" };
_L["Overseer Y'Beda_note"] = "";
_L["Overseer Y'Sorna"] = "Overseer Y'Sorna";
_L["Overseer Y'Sorna_search"] = { "sor", "sorna" };
_L["Overseer Y'Sorna_note"] = "";
_L["Overseer Y'Morna"] = "Overseer Y'Morna";
_L["Overseer Y'Morna_search"] = { "mor", "morna" };
_L["Overseer Y'Morna_note"] = "";
_L["Instructor Tarahna"] = "Instructor Tarahna";
_L["Instructor Tarahna_search"] = { "tara", "tarahna", "tarana" };
_L["Instructor Tarahna_note"] = "";
_L["Zul'tan the Numerous"] = "Zul'tan the Numerous";
_L["Zul'tan the Numerous_search"] = { "zul", "zul.?tan" };
_L["Zul'tan the Numerous_note"] = "Inside building";
_L["Commander Xethgar"] = "Commander Xethgar";
_L["Commander Xethgar_search"] = { "xet", "xethgar" };
_L["Commander Xethgar_note"] = "";
_L["Skreeg the Devourer"] = "Skreeg the Devourer";
_L["Skreeg the Devourer_search"] = { "skr", "skreeg", "skreg" };
_L["Skreeg the Devourer_note"] = "";
_L["Baruut the Bloodthirsty"] = "Baruut the Bloodthirsty";
_L["Baruut the Bloodthirsty_search"] = { "ba", "baruut", "barut" };
_L["Baruut the Bloodthirsty_note"] = "";
_L["Ataxon"] = "Ataxon";
_L["Ataxon_search"] = { "ata", "ataxon" };
_L["Ataxon_note"] = "";
_L["Slithon the Last"] = "Slithon the Last";
_L["Slithon the Last_search"] = { "sli", "slithon" };
_L["Slithon the Last_note"] = "";

_L["Gloamwing"] = "Gloamwing";
_L["Gloamwing_note"] = "";
_L["Bucky"] = "Bucky";
_L["Bucky_note"] = "";
_L["Mar'cuus"] = "Mar'cuus";
_L["Mar'cuus_note"] = "";
_L["Snozz"] = "Snozz";
_L["Snozz_note"] = "";
_L["Corrupted Blood of Argus"] = "Corrupted Blood of Argus";
_L["Corrupted Blood of Argus_note"] = "";
_L["Shadeflicker"] = "Shadeflicker";
_L["Shadeflicker_note"] = "";

_L["Nabiru"] = "Nabiru";
_L["Nabiru_note"] = "He is in a cave. Turn in 900 resources for an Order Hall follower.";

-- Shoot First, Loot Later
_L["Eredar Treasure Cache"] = "Eredar Treasure Cache";
_L["Eredar Treasure Cache_note"] = "In a litte cave. Use Lightforged Warframe's jump to remove the blocking boulders.";
_L["Chest of Ill-Gotten Gains"] = "Chest of Ill-Gotten Gains";
_L["Chest of Ill-Gotten Gains_note"] = "Use Light's Judgment to shatter the rocks.";
_L["Student's Surprising Surplus"] = "Student's Surprising Surplus";
_L["Student's Surprising Surplus_note"] = "Chest is inside a cave. Entrance is at 62.2, 72.2. Use Light's Judgment to shatter the rocks.";
_L["Void-Tinged Chest"] = "Void-Tinged Chest";
_L["Void-Tinged Chest_note"] = "In underground area. Use Lightforged Warframe's jump to remove the blocking boulders.";
_L["Augari Secret Stash"] = "Augari Secret Stash";
_L["Augari Secret Stash_note"] = "Go to 68.0, 56.9. From here you can see the stash. Mount up and jump towards the chest. Then immediately use a glider to reach the chest safely.";
_L["Desperate Eredar's Cache"] = "Desperate Eredar's Cache";
_L["Desperate Eredar's Cache_note"] = "Start at 57.1, 74.3 and jump up around that tower to the back side.";
_L["Shattered House Chest"] = "Shattered House Chest";
_L["Shattered House Chest_note"] = "Go to 31.2, 44.9, a little south-east from here. Jump into the abyss and use a glider to reach the chest.";
_L["Doomseeker's Treasure"] = "Doomseeker's Treasure";
_L["Doomseeker's Treasure_note"] = "Treasure is underground. East of here is a deep hole where the water from the lake falls down. Jump into the hole and hope you hit it right. It is possible to make the jump just with a mount, but a goblin glider helps a lot to reach the small housing with the chest.";
_L["Augari-Runed Chest"] = "Augari-Runed Chest";
_L["Augari-Runed Chest_note"] = "Chest sits under a tree. Use Shroud of Arcane Echoes and then open the chest.";
_L["Secret Augari Chest"] = "Secret Augari Chest";
_L["Secret Augari Chest_note"] = "Inside small hut. Use Shroud of Arcane Echoes and then open the chest.";
_L["Augari Goods"] = "Augari Goods";
_L["Augari Goods_note"] = "Chest is inside small house. Use Shroud of Arcane Echoes and then open the chest.";
-- Ancient Eredar Cache
-- 48346
_L["48346_55167766_note"] = "";
_L["48346_59386372_note"] = "Inside transparent red tent";
_L["48346_57486159_note"] = "Inside building next to Kravos";
_L["48346_50836729_note"] = "";
_L["48346_52868241_note"] = "";
_L["48346_47186234_note"] = "";
_L["48346_50107580_note"] = "";
_L["48346_53328001_note"] = "In cellar";
_L["48346_55297347_note"] = "";
_L["48346_52696161_note"] = "";
_L["48346_54806710_note"] = "";
_L["48346_51677163_note"] = "";
_L["48346_57397517_note"] = "";
_L["48346_61047074_note"] = "Under tree";
-- 48350
_L["48350_59622088_note"] = "Inside building under staircase";
_L["48350_60493338_note"] = "Inside building";
_L["48350_53912335_note"] = "Inside building";
_L["48350_55063508_note"] = "";
_L["48350_62202636_note"] = "On the balcony. Go into the building and up the stairs to the right.";
_L["48350_53332740_note"] = "Under tree";
_L["48350_58574078_note"] = "";
_L["48350_63262000_note"] = "Inside building";
_L["48350_54952484_note"] = "";
_L["48350_63332255_note"] = "Inside red hut";
-- 48351
_L["48351_43637134_note"] = "";
_L["48351_34205929_note"] = "On 2nd floor, where Herald of Chaos resides.";
_L["48351_43955630_note"] = "Under tree";
_L["48351_46917346_note"] = "Hidden under tree";
_L["48351_36296646_note"] = "";
_L["48351_42645361_note"] = "In a cave. Entrance is southwest from here.";
_L["48351_38126342_note"] = "Inside Tureks cellar";
_L["48351_42395752_note"] = "Inside building";
_L["48351_39175934_note"] = "Inside building ruin";
_L["48351_43555993_note"] = "In Naribu's cave";
_L["48351_35535717_note"] = "On 2nd floor";
_L["48351_43666847_note"] = "Inside building ruin";
_L["48351_38386704_note"] = "";
_L["48351_35635604_note"] = "On 2nd floor";
_L["48351_33795558_note"] = "";
-- 48357
_L["48357_49412387_note"] = "";
_L["48357_47672180_note"] = "";
_L["48357_48482115_note"] = "";
_L["48357_57881053_note"] = "";
_L["48357_52871676_note"] = "";
_L["48357_47841956_note"] = "";
_L["48357_51802871_note"] = "In the area up the northern stairs";
_L["48357_49912946_note"] = "";
_L["48357_54951750_note"] = "";
_L["48357_46381509_note"] = "";
_L["48357_50021442_note"] = "";
_L["48357_52631644_note"] = "";
_L["48357_45981325_note"] = "";
_L["48357_44571860_note"] = "";
_L["48357_53491281_note"] = "";
_L["48357_45241327_note"] = "";
_L["48357_48251289_note"] = "Bottom level, near Skreeg";
_L["48357_44952483_note"] = "";
-- 48371
_L["48371_48604971_note"] = "";
_L["48371_49865494_note"] = "";
_L["48371_47023655_note"] = "Up the stairs";
_L["48371_49623585_note"] = "Up the stairs";
_L["48371_51094790_note"] = "Under tree";
_L["48371_35535718_note"] = "On 2nd floor, next to Herald of Chaos";
_L["48371_25383016_note"] = "";
_L["48371_53594211_note"] = "";
_L["48371_59405863_note"] = "";
_L["48371_19694227_note"] = "Inside building";
_L["48371_24763858_note"] = "Inside building ruins";
_L["48371_50575594_note"] = "";
_L["48371_28913361_note"] = "";
_L["48371_32644686_note"] = "";
-- 48362
_L["48362_66682786_note"] = "Inside building, next to Zul'tan the Numerous";
_L["48362_62134077_note"] = "Inside building";
_L["48362_67254608_note"] = "Inside building";
_L["48362_68355322_note"] = "Inside building";
_L["48362_65966017_note"] = "";
_L["48362_62053268_note"] = "Upper terrain level";
_L["48362_60964354_note"] = "Inside building";
_L["48362_64445956_note"] = "Inside building";
_L["48362_65354194_note"] = "";
_L["48362_63924532_note"] = "";
_L["48362_67893170_note"] = "";
_L["48362_65974679_note"] = "Inside building";
_L["48362_68404122_note"] = "";
_L["48362_61924258_note"] = "Inside building";
_L["48362_67235673_note"] = "Inside building";
_L["48362_70243379_note"] = "";
_L["48362_69304993_note"] = "Inside building, on middle floor";
_L["48362_61395555_note"] = "Inside building";
-- Void-Seeped Cache / Treasure Chest
-- 49264
_L["49264_38143985_note"] = "";
_L["49264_37613608_note"] = "";
_L["49264_37812344_note"] = "";
_L["49264_33972078_note"] = "";
_L["49264_33312952_note"] = "";
_L["49264_37102005_note"] = "";
_L["49264_33592361_note"] = "Hidden under tree";
_L["49264_31582553_note"] = "";
_L["49264_32332131_note"] = "Kind of hidden in a corner";
_L["49264_35293848_note"] = "";
-- 48361
_L["48361_37664221_note"] = "Behind pillar in cave thingy";
_L["48361_25824471_note"] = "";
_L["48361_20674033_note"] = "";
_L["48361_29503999_note"] = "";
_L["48361_29455043_note"] = "Under tree";
_L["48361_18794171_note"] = "Outside, behind building";
_L["48361_25293498_note"] = "";
_L["48361_35283586_note"] = "Behind Umbraliss";
_L["48361_24654126_note"] = "";
_L["48361_37754868_note"] = "Down in the cave area";
_L["48361_39174733_note"] = "Down in the cave area";
_L["48361_28784425_note"] = "";
_L["48361_32583679_note"] = "";
_L["48361_19804660_note"] = "";

--
--	KEEP THESE ENGLISH FOR THE GROUP BROWSER IN EU/US!! CHINA & CO ADJUST
--	SEARCH ARRAY AS BEFORE, MUST HAVE MINIMUM 2 ELEMENTS
--

_L["Invasion Point: Val"] = "Invasion Point: Val";
_L["Invasion Point: Aurinor"] = "Invasion Point: Aurinor";
_L["Invasion Point: Sangua"] = "Invasion Point: Sangua";
_L["Invasion Point: Naigtal"] = "Invasion Point: Naigtal";
_L["Invasion Point: Bonich"] = "Invasion Point: Bonich";
_L["Invasion Point: Cen'gar"] = "Invasion Point: Cen'gar";
_L["Greater Invasion Point: Mistress Alluradel"] = "Greater Invasion: Alluradel";
_L["Greater Invasion Point: Matron Folnuna"] = "Greater Invasion: Folnuna";
_L["Greater Invasion Point: Sotanathor"] = "Greater Invasion: Sotanathor";
_L["Greater Invasion Point: Inquisitor Meto"] = "Greater Invasion: Meto";
_L["Greater Invasion Point: Pit Lord Vilemus"] = "Greater Invasion: Vilemus";
_L["Greater Invasion Point: Occularus"] = "Greater Invasion: Occularus";

_L["invasion_val_search"] = { "val", "invasion.*val", "val.*invasion" };
_L["invasion_aurinor_search"] = { "aurinor", "aurinor" };
_L["invasion_sangua_search"] = { "sangua", "sangua" };
_L["invasion_naigtal_search"] = { "naigtal", "naigtal" };
_L["invasion_bonich_search"] = { "bonich", "bonich" };
_L["invasion_cengar_search"] = { "cen", "cen.*gar" };
_L["invasion_alluradel_search"] = { "radel", "alluradel" };
_L["invasion_folnuna_search"] = { "fol", "folnuna" };
_L["invasion_sotanathor_search"] = { "sot", "sotana" };
_L["invasion_meto_search"] = { "meto", "meto" };
_L["invasion_vilemus_search"] = { "vil", "vilemus" };
_L["invasion_occularus_search"] = { "cul", "cularus" };

_L["Dreadblade Annihilator"] = "Dreadblade Annihilator";
_L["bsrare_dreadbladeannihilator_search"] = { "la", "dreadblade", "annihilator" };
_L["Salethan the Broodwalker"] = "Salethan the Broodwalker";
_L["bsrare_salethan_search"] = { "sal", "saleth?an" };
_L["Corrupted Bonebreaker"] = "Corrupted Bonebreaker";
_L["bsrare_corruptedbonebreaker_search"] = { "bone", "bonebreak" };
_L["Flllurlokkr"] = "Flllurlokkr";
_L["bsrare_flllurlokkr_search"] = { "lur", "lurlok" };
_L["Grossir"] = "Grossir";
_L["bsrare_grossir_search"] = { "gro", "gross?ir" };
_L["Eye of Gurgh"] = "Eye of Gurgh";
_L["bsrare_eyeofgurgh_search"] = { "gur", "gurg" };
_L["Somber Dawn"] = "Somber Dawn";
_L["bsrare_somberdawn_search"] = { "somb", "somber" };
_L["Felcaller Zelthae"] = "Felcaller Zelthae";
_L["bsrare_zelthae_search"] = { "zel", "zelth" };
_L["Duke Sithizi"] = "Duke Sithizi";
_L["bsrare_dukesithizi_search"] = { "sit", "sith?izi" };
_L["Lord Hel'Nurath"] = "Lord Hel'Nurath";
_L["bsrare_helnurath_search"] = { "nur", "nurat" };
_L["Imp Mother Bruva"] = "Imp Mother Bruva";
_L["bsrare_bruva_search"] = { "bru", "bruva" };
_L["Potionmaster Gloop"] = "Potionmaster Gloop";
_L["bsrare_gloop_search"] = { "gloop", "gloop" };
_L["Dreadeye"] = "Dreadeye";
_L["bsrare_dreadeye_search"] = { "dread", "dreadeye" };
_L["Malorus the Soulkeeper"] = "Malorus the Soulkeeper";
_L["bsrare_malorus_search"] = { "mal", "malorus" };
_L["Brother Badatin"] = "Brother Badatin";
_L["bsrare_badatin_search"] = { "tin", "badatin", "batadin" };
_L["Felbringer Xar'thok"] = "Felbringer Xar'thok";
_L["bsrare_xarthok_search"] = { "xar", "xar'?thok" };
_L["Malgrazoth"] = "Malgrazoth";
_L["bsrare_malgrazoth_search"] = { "mal", "malgra" };
_L["Emberfire"] = "Emberfire";
_L["bsrare_emberfire_search"] = { "ember", "emberfire" };
_L["Xorogun the Flamecarver"] = "Xorogun the Flamecarver";
_L["bsrare_xorogun_search"] = { "xor", "xorogun" };
_L["Lady Eldrathe"] = "Lady Eldrathe";
_L["bsrare_eldrathe_search"] = { "eld", "eldrat" };
_L["Aqueux"] = "Aqueux";
_L["bsrare_aqueux_search"] = { "aq", "aqueux" };
_L["Doombringer Zar'thoz"] = "Doombringer Zar'thoz";
_L["bsrare_zarthoz_search"] = { "zar", "zar'?th?oz" };
_L["Felmaw Emberfiend"] = "Felmaw Emberfiend";
_L["bsrare_felmawemberfiend_search"] = { "m", "felmaw", "emberfiend" };
_L["Inquisitor Chillbane"] = "Inquisitor Chillbane";
_L["bsrare_chillbane_search"] = { "chillbane", "chillbane" };
_L["Brood Mother Nix"] = "Brood Mother Nix";
_L["bsrare_broodmothernix_search"] = { "nix", "nix" };

_L["Lord Kazzak"] = "Lord Kazzak";
_L["kazzak_search"] = { "kaz", "kaz" };
_L["Azuregos"] = "Azuregos";
_L["azuregos_search"] = { "azu", "azu" };
_L["Dragons of Nightmare"] = "Dragons of Nightmare";
_L["dragonsofnightmare_search"] = { "e", "sondre", "leth?on", "emeris", "ta?erar", "nightmare" };
_L["Ysondre"] = "Ysondre";
_L["ysondre_search"] = { "sondre", "sondre" };
_L["Lethon"] = "Lethon";
_L["lethon_search"] = { "let", "leth?on" };
_L["Emeriss"] = "Emeriss";
_L["emeriss_search"] = { "eme", "emeris" };
_L["Taerar"] = "Taerar";
_L["taerar_search"] = { "tae", "taerar" };

--
--
-- INTERFACE
--
--

_L["Argus"] = "Argus";
_L["Antoran Wastes"] = "Antoran Wastes";
_L["Krokuun"] = "Krokuun";
_L["Mac'Aree"] = "Mac'Aree";

_L["Shield"] = "Shield";
_L["Cloth"] = "Cloth";
_L["Leather"] = "Leather";
_L["Mail"] = "Mail";
_L["Plate"] = "Plate";
_L["1h Mace"] = "1h Mace";
_L["1h Sword"] = "1h Sword";
_L["1h Axe"] = "1h Axe";
_L["2h Mace"] = "2h Mace";
_L["2h Axe"] = "2h Axe";
_L["2h Sword"] = "2h Sword";
_L["Dagger"] = "Dagger";
_L["Staff"] = "Staff";
_L["Fist"] = "Fist";
_L["Polearm"] = "Polearm";
_L["Bow"] = "Bow";
_L["Gun"] = "Gun";
_L["Wand"] = "Wand";
_L["Crossbow"] = "Crossbow";
_L["Ring"] = "Ring";
_L["Amulet"] = "Amulet";
_L["Cloak"] = "Cloak";
_L["Trinket"] = "Trinket";
_L["Off Hand"] = "Off Hand";

_L["groupBrowserOptionOne"] = "%s - %s Member (%s)";
_L["groupBrowserOptionMore"] = "%s - %s Members (%s)";
_L["chatmsg_no_group_priv"] = "|cFFFF0000Insufficient rights. You are not the group leader.";
_L["chatmsg_group_created"] = "|cFF6CF70FCreated group for %s.";
_L["chatmsg_search_failed"] = "|cFFFF0000Too many search requests, please try again in a few seconds.";
_L["hour_short"] = "h";
_L["minute_short"] = "m";
_L["second_short"] = "s";

-- KEEP THESE 2 ENGLISH IN EU/US
_L["listing_desc_rare"] = "Doing rare encounter against %s on Argus.";
_L["listing_desc_invasion"] = "Doing %s on Argus.";

_L["Pet"] = "Pet";
_L["(Mount known)"] = "(|cFF00FF00Mount known|r)";
_L["(Mount missing)"] = "(|cFFFF0000Mount missing|r)";
_L["(Toy known)"] = "(|cFF00FF00Toy known|r)";
_L["(Toy missing)"] = " (|cFFFF0000Toy missing|r)";
_L["(itemLinkGreen)"] = "(|cFF00FF00%s|r)";
_L["(itemLinkRed)"] = "(|cFFFF0000%s|r)";
_L["Retrieving data ..."] = "Retrieving data ...";
_L["Sorry, no groups found!"] = "Sorry, no groups found!";
_L["Search in Quests"] = "Search in Quests";
_L["Groups found:"] = "Groups found:";
_L["Create new group"] = "Create new group";
_L["Close"] = "Close";

_L["context_menu_title"] = "Handynotes Argus";
_L["context_menu_check_group_finder"] = "Check group availability";
_L["context_menu_reset_rare_counters"] = "Reset group counters";
_L["context_menu_add_tomtom"] = "Add to TomTom";
_L["context_menu_hide_node"] = "Hide this node";
_L["context_menu_restore_hidden_nodes"] = "Restore all hidden nodes";

_L["options_title"] = "Argus";

_L["options_icon_settings"] = "Icon Settings";
_L["options_icon_settings_desc"] = "Icon Settings";
_L["options_icons_treasures"] = "Treasure Chest Icons";
_L["options_icons_treasures_desc"] = "Treasure Chest Icons";
_L["options_icons_rares"] = "Rares Icons";
_L["options_icons_rares_desc"] = "Rares Icons";
_L["options_icons_pet_battles"] = "Pet Battle Icons";
_L["options_icons_pet_battles_desc"] = "Pet Battle Icons";
_L["options_icons_sfll"] = "Shoot First, Loot Later Icons";
_L["options_icons_sfll_desc"] = "Shoot First, Loot Later Icons";
_L["options_scale"] = "Scale";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "Opacity";
_L["options_opacity_desc"] = "0 = transparent, 1 = opaque";
_L["options_visibility_settings"] = "Visibility";
_L["options_visibility_settings_desc"] = "Visibility";
_L["options_toggle_treasures"] = "Treasures";
_L["options_toggle_rares"] = "Rares";
_L["options_toggle_battle_pets"] = "Battle Pets";
_L["options_toggle_sfll"] = "Shoot First, Loot Later";
_L["options_toggle_npcs"] = "NPCs";
_L["options_toggle_portals"] = "Portals";
_L["options_general_settings"] = "General";
_L["options_general_settings_desc"] = "General";
_L["options_toggle_alreadylooted_rares"] = "Already looted Rares";
_L["options_toggle_alreadylooted_rares_desc"] = "Show every rare regardless of looted status";
_L["options_toggle_alreadylooted_treasures"] = "Already looted Treasures";
_L["options_toggle_alreadylooted_treasures_desc"] = "Show every treasure regardless of looted status";
_L["options_toggle_alreadylooted_sfll"] = "Already looted 'Shoot First, Loot Later' Treasures";
_L["options_toggle_alreadylooted_sfll_desc"] = "Show every achievement treasure regardless of looted status";
_L["options_toggle_nodeRareGlow"] = "Rares Icons glow";
_L["options_toggle_nodeRareGlow_desc"] = "Adds a glow to Rares Icons depending on group availability. No glow = no groups, red glow = low availability, green glow = high availability.";
_L["options_tooltip_settings"] = "Tooltip";
_L["options_tooltip_settings_desc"] = "Tooltip";
_L["options_toggle_show_loot"] = "Show Loot";
_L["options_toggle_show_loot_desc"] = "Add loot information to the tooltip";
_L["options_toggle_show_notes"] = "Show Notes";
_L["options_toggle_show_notes_desc"] = "Add helpful notes to the tooltip where available";

_L["options_general_settings"] = "General";
_L["options_general_settings_desc"] = "General settings";
_L["options_toggle_leave_group_on_search"] = "Leave groups";
_L["options_toggle_leave_group_on_search_desc"] = "Leave groups when trying to search while grouped. Use with care!";
_L["chatmsg_old_group_delisted_create"] = "|cFFF7C92AOld group delisted. Please click again to create a new group for %s.";
_L["chatmsg_left_group_create"] = "|cFFF7C92ALeft group. Please click again to create a new group for %s.";
_L["chatmsg_old_group_delisted_search"] = "|cFFF7C92AOld group delisted. Please click again to search groups for %s.";
_L["chatmsg_left_group_search"] = "|cFFF7C92ALeft group. Please click again to search groups for %s.";

_L["options_toggle_include_player_seen"] = "Include player seen rares";
_L["options_toggle_include_player_seen_desc"] = "Don't use this yet.";
_L["options_toggle_show_debug"] = "Debug";
_L["options_toggle_show_debug_desc"] = "Show debug stuff";

_L["options_toggle_hideKnowLoot"] = "Hide rare, if all loot known";
_L["options_toggle_hideKnowLoot_desc"] = "Hide all rares for which all loot is known.";

_L["options_toggle_alwaysTrackCoA"] = "Always track Commander of Argus";
_L["options_toggle_alwaysTrackCoA_desc"] = "Always track Commander of Argus, even if the achievement is complete on the account, but not on the character.";
_L["Missing for CoALink"] = "Missing for %s";

_L["options_toggle_birthday13"] = "WoW's 13th Anniversary World Bosses";
_L["options_toggle_birthday13_desc"] = "Toggle Azuregos, Lord Kazzak and the Nightmare Dragons";
_L["options_toggle_alwaysShowBirthday13"] = "- even if already looted today";
_L["options_toggle_alwaysShowBirthday13_desc"] = "";
_L["Shared"] = "Shared";
_L["Somewhere"] = "Somewhere";

end
