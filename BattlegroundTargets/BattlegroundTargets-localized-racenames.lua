-- -------------------------------------------------------------------------- --
-- BattlegroundTargets - bg race names                                        --
-- -------------------------------------------------------------------------- --

local RNA, _, prg = {}, ...
prg.RNA = RNA

local HORDE = 0
local ALLIANCE = 1
local locale = GetLocale()

if locale == "deDE" then -- 15 | Patch 4.3.0.15050 (LIVE)

	RNA["Nachtelf"] = ALLIANCE
	RNA["Nachtelfe"] = ALLIANCE
	RNA["Zwerg"] = ALLIANCE
	RNA["Worgen"] = ALLIANCE
	RNA["Gnom"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Mensch"] = ALLIANCE
	RNA["Blutelf"] = HORDE
	RNA["Blutelfe"] = HORDE
	RNA["Goblin"] = HORDE
	RNA["Orc"] = HORDE
	RNA["Troll"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["Untoter"] = HORDE
	RNA["Untote"] = HORDE

elseif locale == "esES" then -- 18 | Patch 5.1.0.16208 (PTR)

	RNA["Elfa de la noche"] = ALLIANCE
	RNA["Elfo de la noche"] = ALLIANCE
	RNA["Humano"] = ALLIANCE
	RNA["Humana"] = ALLIANCE
	RNA["Gnoma"] = ALLIANCE
	RNA["Gnomo"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Huargen"] = ALLIANCE
	RNA["Enano"] = ALLIANCE
	RNA["Enana"] = ALLIANCE
	RNA["Elfo de sangre"] = HORDE
	RNA["Elfa de sangre"] = HORDE
	RNA["Goblin"] = HORDE
	RNA["Trol"] = HORDE
	RNA["Orco"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["No-muerto"] = HORDE
	RNA["No-muerta"] = HORDE

elseif locale == "esMX" then -- 18 | Patch 5.1.0.16208 (PTR)

	RNA["Elfa de la noche"] = ALLIANCE
	RNA["Elfo de la noche"] = ALLIANCE
	RNA["Humano"] = ALLIANCE
	RNA["Humana"] = ALLIANCE
	RNA["Gnoma"] = ALLIANCE
	RNA["Gnomo"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Huargen"] = ALLIANCE
	RNA["Enano"] = ALLIANCE
	RNA["Enana"] = ALLIANCE
	RNA["Elfo de sangre"] = HORDE
	RNA["Elfa de sangre"] = HORDE
	RNA["Goblin"] = HORDE
	RNA["Trol"] = HORDE
	RNA["Orco"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["No-muerto"] = HORDE
	RNA["No-muerta"] = HORDE

elseif locale == "frFR" then -- 19 | Patch 6.0.3.19342 (LIVE)

	RNA["Elfe de la nuit"] = ALLIANCE
	RNA["Humain"] = ALLIANCE
	RNA["Humaine"] = ALLIANCE
	RNA["Draeneï"] = ALLIANCE
	RNA["Worgen"] = ALLIANCE
	RNA["Gnome"] = ALLIANCE
	RNA["Nain"] = ALLIANCE
	RNA["Naine"] = ALLIANCE
	RNA["Elfe de sang"] = HORDE
	RNA["Mort-vivant"] = HORDE
	RNA["Morte-vivante"] = HORDE
	RNA["Orc"] = HORDE
	RNA["Orque"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["Taurène"] = HORDE
	RNA["Troll"] = HORDE
	RNA["Trollesse"] = HORDE
	RNA["Gobelin"] = HORDE
	RNA["Gobeline"] = HORDE

elseif locale == "itIT" then -- 19 | Patch 5.0.4.16016 (LIVE)

	RNA["Elfa della Notte"] = ALLIANCE
	RNA["Elfo della Notte"] = ALLIANCE
	RNA["Umana"] = ALLIANCE
	RNA["Umano"] = ALLIANCE
	RNA["Gnoma"] = ALLIANCE
	RNA["Gnomo"] = ALLIANCE
	RNA["Nano"] = ALLIANCE
	RNA["Nana"] = ALLIANCE
	RNA["Worgen"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Elfa del Sangue"] = HORDE
	RNA["Elfo del Sangue"] = HORDE
	RNA["Non Morto"] = HORDE
	RNA["Non Morta"] = HORDE
	RNA["Orchessa"] = HORDE
	RNA["Orco"] = HORDE
	RNA["Troll"] = HORDE
	RNA["Goblin"] = HORDE
	RNA["Tauren"] = HORDE

elseif locale == "koKR" then -- 12 | Patch 4.3.2.15201 (PTR)

	RNA["나이트 엘프"] = ALLIANCE
	RNA["늑대인간"] = ALLIANCE
	RNA["드레나이"] = ALLIANCE
	RNA["드워프"] = ALLIANCE
	RNA["노움"] = ALLIANCE
	RNA["인간"] = ALLIANCE
	RNA["블러드 엘프"] = HORDE
	RNA["트롤"] = HORDE
	RNA["고블린"] = HORDE
	RNA["언데드"] = HORDE
	RNA["타우렌"] = HORDE
	RNA["오크"] = HORDE

elseif locale == "ptBR" then -- 24 | Patch 4.3.0.15050 (LIVE)

	RNA["Elfo Noturno"] = ALLIANCE
	RNA["Elfa Noturna"] = ALLIANCE
	RNA["Humano"] = ALLIANCE
	RNA["Humana"] = ALLIANCE
	RNA["Gnomo"] = ALLIANCE
	RNA["Gnomida"] = ALLIANCE
	RNA["Anã"] = ALLIANCE
	RNA["Anão"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Draenaia"] = ALLIANCE
	RNA["Worgen"] = ALLIANCE
	RNA["Worgenin"] = ALLIANCE
	RNA["Elfo Sangrento"] = HORDE
	RNA["Elfa Sangrenta"] = HORDE
	RNA["Morto-vivo"] = HORDE
	RNA["Morta-viva"] = HORDE
	RNA["Orc"] = HORDE
	RNA["Orquisa"] = HORDE
	RNA["Troll"] = HORDE
	RNA["Trolesa"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["Taurena"] = HORDE
	RNA["Goblin"] = HORDE
	RNA["Goblina"] = HORDE

elseif locale == "ruRU" then -- 14 | Patch 5.1.0.16208 (PTR)

	RNA["Ночной эльф"] = ALLIANCE
	RNA["Ночная эльфийка"] = ALLIANCE
	RNA["Человек"] = ALLIANCE
	RNA["Дворф"] = ALLIANCE
	RNA["Гном"] = ALLIANCE
	RNA["Ворген"] = ALLIANCE
	RNA["Дреней"] = ALLIANCE
	RNA["Эльф крови"] = HORDE
	RNA["Эльфийка крови"] = HORDE
	RNA["Нежить"] = HORDE
	RNA["Орк"] = HORDE
	RNA["Таурен"] = HORDE
	RNA["Тролль"] = HORDE
	RNA["Гоблин"] = HORDE

elseif locale == "zhCN" then -- 12 | Patch 4.3.2.15201 (PTR)

	RNA["人类"] = ALLIANCE
	RNA["矮人"] = ALLIANCE
	RNA["暗夜精灵"] = ALLIANCE
	RNA["侏儒"] = ALLIANCE
	RNA["德莱尼"] = ALLIANCE
	RNA["狼人"] = ALLIANCE
	RNA["亡灵"] = HORDE
	RNA["兽人"] = HORDE
	RNA["牛头人"] = HORDE
	RNA["血精灵"] = HORDE
	RNA["地精"] = HORDE
	RNA["巨魔"] = HORDE

elseif locale == "zhTW" then -- 12 | Patch 4.3.2.15201 (PTR)

	RNA["德萊尼"] = ALLIANCE
	RNA["人類"] = ALLIANCE
	RNA["矮人"] = ALLIANCE
	RNA["地精"] = ALLIANCE
	RNA["夜精靈"] = ALLIANCE
	RNA["狼人"] = ALLIANCE
	RNA["哥布林"] = HORDE
	RNA["血精靈"] = HORDE
	RNA["不死族"] = HORDE
	RNA["獸人"] = HORDE
	RNA["食人妖"] = HORDE
	RNA["牛頭人"] = HORDE

else--if locale == "enUS" then -- 12 | Patch 4.3.0.15050 (LIVE)

	RNA["Night Elf"] = ALLIANCE
	RNA["Draenei"] = ALLIANCE
	RNA["Worgen"] = ALLIANCE
	RNA["Human"] = ALLIANCE
	RNA["Gnome"] = ALLIANCE
	RNA["Dwarf"] = ALLIANCE
	RNA["Blood Elf"] = HORDE
	RNA["Orc"] = HORDE
	RNA["Troll"] = HORDE
	RNA["Tauren"] = HORDE
	RNA["Undead"] = HORDE
	RNA["Goblin"] = HORDE

end