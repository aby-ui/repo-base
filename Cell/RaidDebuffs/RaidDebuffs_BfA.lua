local _, Cell = ...
local L = Cell.L
local F = Cell.funcs

-- taken from Grid2
local debuffs = {
    [1028] = { -- 艾泽拉斯
        [2378] = { -- 大女皇夏柯扎拉
        },
        [2381] = { -- 碎地者弗克拉兹
        },
        [2363] = { -- 维科玛拉
        },
        [2362] = { -- 奥玛斯，缚魂者
        },
        [2329] = { -- 森林之王伊弗斯
        },
        [2212] = { -- 雄狮之吼
        },
        [2213] = { -- 末日之嚎
        },
        [2139] = { -- 提赞
            261605, -- Consuming Spirits
            261552, -- Terror Wail
        },
        [2141] = { -- 基阿拉克
            260989, -- Storm Wing
            261509, -- Clutch
        },
        [2197] = { -- 冰雹构造体
            274895, -- Freezing Tempest
            274891, -- Glacial Breath
        },
        [2198] = { -- 战争使者耶纳基兹
            274932, -- Endless Abyss
            274904, -- Reality Tear
        },
        [2199] = { -- 蔚索斯，飞翼台风
            274839, -- Azurethos' Fury
        },
        [2210] = { -- 食沙者克劳洛克
            275175, -- Sonic Bellow
        },
    },

    [1031] = { -- 奥迪尔
        [2168] = { -- 塔罗克
            271222, -- Plasma Discharge
            270290, -- Blood Storm
            275270, -- Fixate
            275189, -- Hardened Arteries
            275205, -- Enlarged Heart
        },
        [2167] = { -- 纯净圣母
            267821, -- Defense Grid
            267787, -- Sanitizing Strike
            268095, -- Cleansing Purge
            268198, -- Clinging Corruption
            268253, -- Surgical Beam
            268277, -- Purifying Flame
        },
        [2146] = { -- 腐臭吞噬者
            262313, -- Malodorous Miasma
            262314, -- Putrid Paroxysm
            262292, -- Rotting Regurgitation
        },
        [2169] = { -- 泽克沃兹，恩佐斯的传令官
            265360, -- Roiling Deceit
            265662, -- Corruptor's Pact
            265237, -- Shatter
            265264, -- Void Lash
            265646, -- Will of the Corruptor
            264210, -- Jagged Mandible
            270589, -- Void Wail
            270620, -- Psionic Blast
        },
        [2166] = { -- 维克提斯
            265129, -- Omega Vector
            265178, -- Evolving Affliction
            265212, -- Gestate
            265127, -- Lingering Infection
            265206, -- Immunosuppression
        },
        [2195] = { -- 重生者祖尔
            273365, -- Dark Revelation
            274358, -- Rupturing Blood
            273434, -- Pit of Despair
            274195, -- Corrupted Blood
            274271, -- Deathwish
            272018, -- Absorbed in Darkness
            276020, -- Fixate
            276299, -- Engorged Burst
        },
        [2194] = { -- 拆解者米斯拉克斯
            272336, -- Annihilation
            272536, -- Imminent Ruin
            274693, -- Essence Shear
            272407, -- Oblivion Sphere
            272146, -- Annihilation
            274019, -- Mind Flay
            274113, -- Obliteration Beam
            274761, -- Oblivion Veil
            279013, -- Essence Shatter
        },
        [2147] = { -- 戈霍恩
            263334, -- Putrid Blood
            263372, -- Power Matrix
            263436, -- Imperfect Physiology
            272506, -- Explosive Corruption
            267409, -- Dark Bargain
            267430, -- Torment
            263235, -- Blood Feast
            270287, -- Blighted Ground
            263321, -- Undulating Mass
            267659, -- Unclean Contagion
            267700, -- Gaze of G'huun
            267813, -- Blood Host
            269691, -- Mind Thrall
            277007, -- Bursting Boil
            279575, -- Choking Miasma
        },
    },

    [1176] = { -- 达萨罗之战
        [2333] = { -- 圣光勇士
            283572, -- Sacred Blade
            283651, -- Blinding Faith
            283579, -- Consecration
        },
        [2325] = { -- 丛林之王格洛恩
            285875, -- Rending Bite
            283069, -- Megatomic Fire (Horde)
            286373, -- Chill of Death (Alliance)
            282215, -- Megatomic Seeker Missile
            282471, -- Voodoo Blast
            285659, -- Apetagonizer Core
            286434, -- Necrotic Core
            285671, -- Crushed
            282010, -- Shattered
        },
        [2341] = { -- 玉火大师
            286988, -- Searing Embers
            282037, -- Rising Flames
            288151, -- Tested
            285632, -- Stalking
        },
        [2342] = { -- 丰灵
            283063, -- Flames of Punishment
            283507, -- Volatile Charge
            286501, -- Creeping Blaze
            287072, -- Liquid Gold
            284470, -- Hex of Lethargy
        },
        [2330] = { -- 神选者教团
            284663, -- Bwonsamdi's Wrath
            282135, -- Crawling Hex
            285878, -- Mind Wipe
            282592, -- Bleeding Wounds
            286060, -- Cry of the Fallen
            282444, -- Lacerating Claws
            286811, -- Akunda's Wrath
            282209, -- Mark of Prey
        },
        [2335] = { -- 拉斯塔哈大王
            285195, -- Deadly Withering
            285044, -- Toad Toxin
            284831, -- Scorching Detonation
            284781, -- Grevious Axe
            285213, -- Caress of Death
            288449, -- Death's Door
            284662, -- Seal of Purification
            285349, -- Plague of Fire
        },
        [2334] = { -- 大工匠梅卡托克
            287167, -- Discombobulation
            283411, -- Gigavolt Blast
            286480, -- Anti Tampering Shock
            287757, -- Gigavolt Charge
            282182, -- Buster Cannon
            284168, -- Shrunk
            284214, -- Trample
            287891, -- Sheep Shrapnel
            289023, -- Enormous
        },
        [2337] = { -- 风暴之墙阻击战
            285000, -- Kelp Wrapping
            284405, -- Tempting Song
            285350, -- Storms Wail
            285075, -- Freezing Tidepool
            285382, -- Kelp Wrapping
        },
        [2343] = { -- 吉安娜·普罗德摩尔
            287626, -- Grasp of Frost
            287490, -- Frozen Solid
            287365, -- Searing Pitch
            285212, -- Chilling Touch
            285253, -- Ice Shard
            287199, -- Ring of Ice
            288218, -- Broadside
            289220, -- Heart of Frost
            288038, -- Marked Target
            287565, -- Avalanche
        },
    },

    [1177] = { -- 风暴熔炉
        [2328] = { -- 无眠秘党
            282540, -- Agent of demise
            282432, -- Crushing Doubt
            282384, -- Shear Mind
            283524, -- Aphotic Blast
            282517, -- Terrifying Echo
            282562, -- Promises of Power
            282738, -- Embrace of the void
            293300, -- Storm essence
            293488, -- Oceanic Essence
        },
        [2332] = { -- 乌纳特，虚空先驱
            285345, -- Maddening eyes of N'zoth
            285652, -- Insatiable torment
            284733, -- Embrace of the void
            285367  -- Piercing gaze
        },
    },

    [1179] = { -- 永恒王宫
        [2352] = { -- 深渊指挥官西瓦拉
            300882, -- Inversion Sickness
            295421, -- Over flowing Venom
            295348, -- Over flowing Chill
            294715, -- Toxic Brand
            294711, -- Frost Mark
            300705, -- Septic Taint
            300701, -- Rimefrost
            294847, -- Unstable Mixture
            300961, -- Frozen Ground
            300962, -- Septic Ground
        },
        [2347] = { -- 黑水巨鳗
            292127, -- Darkest Depths
            292307, -- Gaze from Below
            292167, -- Toxic Spine
            301494, -- Piercing Barb
            298595, -- Glowing Stinger
            292138, -- Radiant Biomass
            292133, -- Bioluminescence
        },
        [2353] = { -- 艾萨拉之辉
            296737, -- Arcane Bomb
            296566, -- Tide Fist
        },
        [2354] = { -- 艾什凡女勋爵
            296693, -- Waterlogged
            297333, -- Briny Bubble
            296725, -- Barnacle Bash
            296752, -- Cutting Coral
        },
        [2351] = { -- 奥戈佐亚
            298306, -- Incubation Fluid
            295779, -- Aqua Lance
            298156, -- Desensitizing Sting
        },
        [2359] = { -- 女王法庭
            297586, -- Suffering
            299914, -- Frenetic Charge
            296851, -- Fanatical Verdict
            300545, -- Mighty Rupture
        },
        [2349] = { -- 扎库尔，尼奥罗萨先驱
            292971, -- Hysteria
            292963, -- Dread
            293509, -- Manifest Nightmares
            298192, -- Dark Beyond
        },
        [2361] = { -- 艾萨拉女王
            303825, -- Crushing Depths
            303657, -- Arcane Burst
            300492, -- Static Shock
            297907, -- Cursed Heart
        },
    },

    [1180] = { -- 尼奥罗萨，觉醒之城
        [2368] = { -- 黑龙帝王拉希奥
            306163, -- Incineration
            314347, -- Noxxious Choke
            307013, -- Burning Madness
            313250, -- Creeping Madness (mythic)
        },
        [2365] = { -- 玛乌特
            307806, -- Devour Magic
            306301, -- Forbidden Mana
            307399, -- Shadow Wounds
            314992, -- Drain Essence
            314337, -- Ancient Curse (mythic)
        },
        [2369] = { -- 先知斯基特拉
            308059, -- Shadow Shock Applied
            307950, -- Shred Psyche
        },
        [2377] = { -- 黑暗审判官夏奈什
            313198, -- Void Touched
            312406, -- Voidwoken
        },
        [2372] = { -- 主脑
            313461, -- Corrosion
            313129, -- Mindless
            313460, -- Nullification
        },
        [2367] = { -- 无厌者夏德哈
            307358, -- Debilitating Spit
            307945, -- Umbral Eruption
            306929, -- Bubbling Breath
            307260, -- Fixate
            312332, -- Slimy Residue
            306930, -- Entropic Breath
        },
        [2373] = { -- 德雷阿佳丝
            310552, -- Mind Flay
            310358, -- Muttering Insanity
        },
        [2374] = { -- 伊格诺斯，重生之蚀
            275269, -- Fixate
            311159, -- Cursed Blood
        },
        [2370] = { -- 维克修娜
            307314, -- Encroaching Shadows
            307359, -- Despair
            310323, -- Desolation
        },
        [2364] = { -- 虚无者莱登
            306819, -- Nullifying Strike
            306273, -- Unstable Vita
            306279, -- Instability Exposure
            309777, -- Void Defilement
            313227, -- Decaying Wound
            310019, -- Charged Bonds
            313077, -- Unstable Nightmare
            315252, -- Dread Inferno Fixate
            316065, -- Corrupted Existence
        },
        [2366] = { -- 恩佐斯的外壳
            307008, -- Breed Madness
            306973, -- Madness Bomb
            306984, -- Insanity Bomb
            307008, -- Breed Madness
        },
        [2375] = { -- 腐蚀者恩佐斯
            308885, -- Mind Flay
            317112, -- Evoke Anguish
            309980, -- Paranoia
        },
    },

    [1023] = { -- 围攻伯拉勒斯
        [2133] = { -- 拜恩比吉中士
            257459, -- On the Hook
            257288, -- Heavy Slash
        },
        [2173] = { -- 恐怖船长洛克伍德
            256076, -- Gut Shot
        },
        [2134] = { -- 哈达尔·黑渊
            257882, -- Break Water
            257862, -- Crashing Tide
        },
        [2140] = { -- 维克戈斯
            274991, -- Putrid Waters
        },
    },

    [1022] = { -- 地渊孢林
        ["general"] = {
            265533, -- Fauce sangrienta
            265019, -- Tajo salvaje
            265377, -- Trampa con gancho
            265568, -- Presagio oscuro
            266107, -- Sed de sangre
            266265, -- Asalto malvado
            272180, -- Descarga mortal
            265468, -- Maldici�n fulminante
            272609, -- Mirada enloquecedora
            265511, -- Drenaje de esp�ritu
            278961, -- Mente putrefacta
            273599, -- Aliento podrido
        },
        [2157] = { -- 长者莉娅克萨
            260685, -- Taint of G'huun
        },
        [2131] = { -- 被感染的岩喉
            260333, -- Tantrum
            260455, -- Colmillos serrados
        },
        [2130] = { -- 孢子召唤师赞查
            259714, -- Decaying Spores
            259718, -- Agitaci�n
            273226, -- Esporas putrefactas
        },
        [2158] = { -- 不羁畸变怪
            269301, -- Putrid Blood
        },
    },

    [1030] = { -- 塞塔里斯神庙
        ["general"] = {
            273563, -- Neurotoxina
            272657, -- Aliento nocivo
            272655, -- Arena asoladora
            272696, -- Rel�mpagos embotellados
            272699, -- Flema venenosa
            268013, -- Choque de llamas
            268007, -- Ataque al coraz�n
            268008, -- Amuleto de serpiente
        },
        [2142] = { -- 阿德里斯和阿斯匹克斯
            263371, -- Conduction
            263234, -- Arcing Blade
            268993, -- Golpe bajo
            263778, -- Fuerza de vendaval
            225080, -- reincarnation
        },
        [2143] = { -- 米利克萨
            267027, -- Cytotoxin
            263958, -- A Knot of Snakes
            261732, -- Blinding Sand
            263927, -- Charco t�xico
        },
        [2144] = { -- 加瓦兹特
            266512, -- Consume Charge
            266923, -- Galvanizar
        },
        [2145] = { -- 塞塔里斯的化身
            269686, -- Plague
            269670, -- Potenciaci�n
            268024, -- Pulso
        },
    },

    [1002] = { -- 托尔达戈
        ["general"] = {
            258864, -- Fuego de supresi�n
            258313, -- Esposar
            258079, -- Dentellada enorme
            258075, -- Mordedura irritante
            258058, -- Exprimir
            265889, -- Golpe de antorcha
            258128, -- Grito debilitante
            225080, -- Reencarnaci�n
        },
        [2097] = { -- 泥沙女王
            257092, -- Sand Trap
            260016, -- Mordedura irritante
        },
        [2098] = { -- 杰斯·豪里斯
            257791, -- Howling Fear
            257777, -- Chafarote entorpecedor
            257793, -- Polvo de humo
            260067, -- Vapuleo sa�oso
        },
        [2099] = { -- 骑士队长瓦莱莉
            257028, -- Fuselighter
            259711, -- A cal y canto
        },
        [2096] = { -- 科古斯狱长
            256198, -- Azerite Rounds: Incendiary
            256038, -- Deadeye
            256044, -- Deadeye
            256200, -- Veneno Muerte Diestra
            256105, -- R�faga explosiva
            256201, -- Cartuchos incendiarios
        },
    },

    [1012] = { -- 暴富矿区！！
        ["general"] = {
            280604, -- Chorro helado
            280605, -- Congelaci�n cerebral
            263637, -- Tendedero
            269298, -- Toxina de creaviudas
            263202, -- Lanza de roca
            268704, -- Temblor furioso
            268846, -- Hoja de eco
            263074, -- Mordedura degenerativa
            262270, -- Compuesto c�ustico
            262794, -- Latigazo de energ�a
            262811, -- Gl�bulo parasitario
            268797, -- Transmutar: enemigo en baba
            269429, -- Disparo cargado
            262377, -- Buscar y destruir
            262348, -- Deflagraci�n de mina
            269092, -- Tromba de artiller�a
            262515, -- Buscacorazones de azerita
            262513, -- Buscacorazones de azerita
        },
        [2109] = { -- 投币式群体打击者
            256137, -- Timed Detonation
            257333, -- Shocking Claw
            262347, -- Pulso est�tico
            270882, -- Azerita llameante
        },
        [2114] = { -- 艾泽洛克
            257582, -- Raging Gaze
            258627, -- Resonant Quake
            257544, -- Corte dentado
            275907, -- Machaque tect�nico
        },
        [2115] = { -- 瑞克莎·流火
            258971, -- Azerite Catalyst
            259940, -- Propellant Blast
            259853, -- Quemadura qu�mica
        },
        [2116] = { -- 商业大亨拉兹敦克
            260811, -- Homing Missile
            260829, -- Misil buscador
            260838, -- Misil buscador
            270277, -- Cohete rojo grande
        },
    },

    [1021] = { -- 维克雷斯庄园
        ["general"] = {
            263905, -- Tajo marcador
            265352, -- A�ublo de sapo
            266036, -- Drenar esencia
            264105, -- Se�al r�nica
            264390, -- Hechizo de vinculaci�n
            265346, -- Mirada p�lida
            264050, -- Espina infectada
            265761, -- Tromba espinosa
            264153, -- Flema
            265407, -- Campanilla para la cena
            271178, -- Salto devastador
            263943, -- Grabar
            264520, -- Serpiente mutiladora
            265881, -- Toque putrefacto
            264378, -- Fragmentar alma
            264407, -- Rostro horripilante
            265880, -- Marca p�rfida
            265882, -- Pavor persistente
            266035, -- Astilla de hueso
            263891, -- Espinas enredadoras
            264556, -- Golpe desgarrador
            278456, -- Infestar
        },
        [2125] = { -- 毒心三姝
            260741, -- Jagged Nettles
            260926, -- Soul Manipulation
            260703, -- Unstable Runic Mark
        },
        [2126] = { -- 魂缚巨像
            260551, -- Soul Thorns
        },
        [2127] = { -- 贪食的拉尔
            268231, -- Rotten Expulsion
        },
        [2128] = { -- 维克雷斯勋爵和夫人
            261439, -- Virulent Pathogen
            261438, -- Golpe extenuante
            261440, -- Patogeno virulento
        },
        [2129] = { -- 高莱克·图尔
            268203, -- Death Lens
        },
    },

    [1001] = { -- 自由镇
        ["general"] = {
            257908, -- Hoja aceitada
            257478, -- Mordedura entorpecedora
            274384, -- Trampas para ratas
        },
        [2102] = { -- 天空上尉库拉格
            278993, -- Vile Bombardment
        },
        [2093] = { -- 海盗议会
            258874, -- Blackout Barrel
            267523, -- Oleada cortante
            1604,   -- Atontado
        },
        [2094] = { -- 藏宝竞技场
            256553, -- Flailing Shark
            256363, -- Pu�etazo desgarrador
        },
        [2095] = { -- 哈兰·斯威提
            281591, -- Cannon Barrage
            257460, -- Escombros igneos
            257314, -- Bomba de polvora negra
        },
    },

    [1041] = { -- 诸王之眠
        [2165] = { -- 黄金风蛇
            265773, -- Spit Gold
            265914, -- Molten Gold
        },
        [2171] = { -- 殓尸者姆沁巴
            267626, -- Dessication
            267702, -- Entomb
            267764, -- Struggle
            267639, -- Burn Corruption
        },
        [2170] = { -- 部族议会
            267273, -- Poison Nova
            266238, -- Shattered Defenses
            266231, -- Severing Axe
            267257, -- Thundering Crash
        },
        [2172] = { -- 始皇达萨
            268932, -- Quaking Leap
            268586, -- Blade Combo
        },
    },

    [968] = { -- 阿塔达萨
        ["general"] = {
            253562, -- Fuego salvaje
            254959, -- Quemar alma
            260668, -- Transfusion
            255567, -- Carga fren�tica
            279118, -- Maleficio inestable
            252692, -- Golpe embotador
            252687, -- Golpe de Venolmillo
            255041, -- Chirrido aterrorizador
            255814, -- Acometida desgarradora
        },
        [2082] = { -- 女祭司阿伦扎
            274195, -- Corrupted Blood
            277072, -- Corrupted Gold
            265914, -- Molten Gold
            255835, -- Transfusion
            255836, -- Transfusion
        },
        [2036] = { -- 沃卡尔
            263927, -- Toxic Pool
            250372, -- Lingering Nausea
            255620, -- Erupci�n purulenta
        },
        [2083] = { -- 莱赞
            255434, -- Serrated Teeth
            255371, -- Terrifying Visage
            257407, -- Pursuit
            255421, -- Devour
        },
        [2030] = { -- 亚兹玛
            250096, -- Dolor atroz
            259145, -- Soulrend
            249919, -- Skewer
        },
    },

    [1036] = { -- 风暴神殿
        ["general"] = {
            268233, -- Choque electrizante
            274633, -- Arremetida hendiente
            268309, -- Oscuridad infinita
            268315, -- Latigazo
            268317, -- Desgarrar mente
            268322, -- Toque de los ahogados
            268391, -- Ataque mental
            274720, -- Golpe abisal
            276268, -- Golpe tumultuoso
            268059, -- Ancla de vinculaci�n
            268027, -- Mareas crecientes
            268214, -- Grabar carne
        },
        [2153] = { -- 阿库希尔
            264560, -- Choking Brine
            264477, -- Grasp from the Depths
        },
        [2154] = { -- 海贤议会
            267899, -- Hindering Cleave
            267818, -- Viento cortante
        },
        [2155] = { -- 斯托颂勋爵
            268896, -- Mind Rend
            269104, -- Vac�o explosivo
            269131, -- Dominamentes ancestral
        },
        [2156] = { -- 低语者沃尔兹斯
            267034, -- Whispers of Power
        },
    },

    [1178] = { -- 麦卡贡行动
        ["general"] = {
            299572, -- 缩小
            300764, -- 粘液箭
            300659, -- 吞噬软泥
            294180, -- 反抗烈焰
            299438, -- 无情铁锤
            300207, -- 震击线圈
            299475, -- 音速咆哮
            301712, -- 突袭
            299502, -- 纳米切割者
            294290, -- 处理废料
            294195, -- 电弧波动炮
            293986, -- 声波脉冲
        },
        [2357] = { -- 戈巴马克国王
            297257, -- 电荷充能
            297283, -- 落石
        },
        [2358] = { -- 冈克
            298124, -- 束缚粘液
        },
        [2360] = { -- 崔克茜和耐诺
            298669, -- 跳电
            298718, -- 超能跳电
            298602, -- 烟云
        },
        [2355] = { -- HK-8型空中压制单位
            302274, -- 爆裂冲击
            295939, -- 歼灭射线
            296150, -- 喷涌冲击
            295445, -- 毁灭
            296560, -- 附着静电
        },
        [2336] = { -- 坦克大战
            282943, -- 液压碾锤
            285388, -- 烈焰喷射
        },
        [2339] = { -- 狂犬K.U.-J.0.
            291972, -- 爆燃之跃
            294929, -- 烈焰撕咬
            291946, -- 喷射烈焰
        },
        [2348] = { -- 机械师的花园
            285460, -- 脉冲榴弹
            285443, -- “隐秘”烈焰火炮
            294860, -- 电荷绽放
        },
        [2331] = { -- 麦卡贡国王
            291928, -- 超荷电磁炮
            291914, -- 切割光线
        },
    },
}

F:LoadBuiltInDebuffs(debuffs)