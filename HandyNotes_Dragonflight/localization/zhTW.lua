local ADDON_NAME, ns = ...
local L = ns.NewLocale('zhTW')
if not L then return end

-------------------------------------------------------------------------------
-------------------------------- DRAGON ISLES ---------------------------------
-------------------------------------------------------------------------------

L['elite_loot_385'] = ns.color.Orange('這個稀有有機會掉落高裝等的拾取!')
L['gem_cluster_note'] = '需要的物品可以在龍鱗遠征隊名望21後, 在遠征隊斥侯包和挖過的土找到'

L['options_icons_bonus_boss'] = '獎勵精英'
L['options_icons_bonus_boss_desc'] = '顯示獎勵精英位置.'

L['options_icons_profession_treasures'] = '專業技能寶藏'
L['options_icons_profession_treasures_desc'] = '顯示會給予專業技能知識的寶藏位置'

L['dragon_glyph'] = '龍之雕紋'
L['options_icons_dragon_glyph'] = '龍之雕紋'
L['options_icons_dragon_glyph_desc'] = '顯示全部48個龍之雕紋的位置'

L['dragonscale_expedition_flag'] = '龍鱗遠征隊'
L['flags_placed'] = '旗幟已插上'
L['options_icons_flag'] = '{achievement:15890}'
L['options_icons_flag_desc'] = '顯示 {achievement:15890} 成就中全部20個旗幟的位置.'

L['broken_banding_note'] = '在雕像的右腳踝上'
L['chunk_of_sculpture_note'] = '在地上, 在龍雕像的左邊'
L['dislodged_dragoneye_note'] = '在龍雕像胸部底下的石頭上'
L['finely_carved_wing_note'] = '在龍雕像右膝底下'
L['fragment_requirement_note'] = ns.color.Red('在你能夠收集碎塊前, 你需要詢問在 |cFFFFFD00翼息大使館|r 龍之雕像的 {npc:193915} 他在這裡幹嘛.')
L['golden_claw_note'] = '在龍雕像的右後爪'
L['precious_stone_fragment_note'] = '在雕像的右腳下'
L['stone_dragontooth_note'] = '在龍雕像台座旁的地上'
L['tail_fragment_note'] = '在龍雕像尾巴上'
L['wrapped_gold_band_note'] = '在龍雕像的左後爪下'
L['options_icons_fragment'] = '{achievement:16323}'
L['options_icons_fragment_desc'] = '顯示成就 {achievement:16323} 所需的碎塊位置'

L['options_icons_kite'] = '{achievement:16584}'
L['options_icons_kite_desc'] = '顯示成就 {achievement:16584} 所需的 {npc:198118} 位置.'

L['disturbed_dirt'] = '挖過的土'
L['options_icons_disturbed_dirt'] = '挖過的土'
L['options_icons_disturbed_dirt_desc'] = '顯示挖過的土的位置'

L['scout_pack'] = '遠征隊斥侯包'
L['options_icons_scout_pack'] = '遠征隊斥侯包'
L['options_icons_scout_pack_desc'] = '顯示遠征隊斥侯包的位置'

L['magicbound_chest'] = nil
L['options_icons_magicbound_chest'] = nil
L['options_icons_magicbound_chest_desc'] = nil

L['dr_best'] = '你的最快時間:\n - 普通: %.3fs\n - 進階: %.3fs'
L['dr_best_dash'] = '你的最佳時間:\n - %.3fs'
L['dr_note'] = '目標時間:\n - 普通: %ss / %ss\n - 進階: %ss / %ss'
L['dr_note_dash'] = '目標時間:\n - %ss / %ss'
L['dr_bronze'] = '\n\n完成賽事來取得 ' .. ns.color.Bronze('銅牌') .. '.'
L['options_icons_dragonrace'] = '飛龍競速'
L['options_icons_dragonrace_desc'] = '顯示飛龍競速的位置.'

L['squirrels_note'] = '你必須對小動物而不是戰寵使用表情 /love'
L['options_icons_squirrels'] = '{achievement:16729}'
L['options_icons_squirrels_desc'] = '顯示 {achievement:16729} 成就中小動物的位置.'

L['hnj_sublabel'] = '需要當地的席卡氏族大狩獵'
L['hnj_western_azure_span_hunt'] = '在死掉樹的頂端'
L['hnj_northern_thaldraszus_hunt'] = ns.color.Orange('注意: 當大狩獵事件開始時, 你需要快點找到他. 如果太晚的話, 他可能會被野怪殺死.')
L['options_icons_hemet_nesingwary_jr'] = '{achievement:16542}'
L['options_icons_hemet_nesingwary_jr_desc'] = '顯示成就 {achievement:16542} 所需的 {npc:194590} 位置.'

L['pretty_neat_note'] = '使用任何自拍相機拍一張照'
L['pretty_neat_note_blazewing'] = '可以在地城 ' .. ns.color.Yellow('奈薩魯斯堡') .. ' 中和首領 {npc:189901} 的戰鬥中發現.'
L['options_icons_pretty_neat'] = '{achievement:16446}'
L['options_icons_pretty_neat_desc'] = '顯示成就 {achievement:16446} 所需的 NPC 位置'

L['large_lunker_sighting'] = '大傢伙目擊地點'
L['large_lunker_sighting_note'] = '使用5個 {item:194701} 來召喚 {npc:192919} 或是稀有'

L['options_icons_legendary_album'] = '{achievement:16570}'
L['options_icons_legendary_album_desc'] = '顯示成就 {achievement:16570} 所需的傳奇角色所在位置.'

-------------------------------------------------------------------------------
------------------------------- THE AZURE SPAN --------------------------------
-------------------------------------------------------------------------------

L['brackenhide_rare_note'] = '如果你在 |cFFFFFD00蕨皮谷|r 區域的話, 稀有重生時會在對話欄公告'
L['fisherman_tinnak_note'] = '收集|cFFFFFD00破損的釣魚竿|r, |cFFFFFD00破損的捕漁網|r 和 |cFFFFFD00舊魚叉|r來召喚稀有.'
L['spellwrought_snowman_note'] = '收集 10個 {npc:193424} 並且把他們帶到 {npc:193242}.'
L['trilvarus_loreweaver_note'] = '收集一個|cFFFFFD00歌唱碎片|r以取得 {spell:382076} 接著使用 |cFFFFFD00未充能法器|r 來召喚稀有.'

L['breezebiter_note'] = '飛上天空來把他拉下來, 飛靠近他一點'

L['forgotten_jewel_box_note'] = '從雍亞拉平原的嶺水靜地 (49.4 67.3) 上的 氏族寶箱 拾取{item:199065} 並使用它.'
L['gnoll_fiend_flail_note'] = '{item:199066} 可以在遠征隊斥侯包和挖過的土中找到.'
L['pepper_hammer_note'] = '收集 |cFFFFFD00樹液|r 然後點選 |cFFFFFD00棍子|r 來引誘 {npc:195373}.\n\n|cFFFF0000(BUG: 要點選棍子可能需要你重載UI)|r'
L['snow_covered_scroll'] = '覆滿雪的卷軸'

L['pm_engi_frizz_buzzcrank'] = '站在祭壇邊'
L['pm_jewel_pluutar'] = '在建築內'
L['pm_script_lydiara_whisperfeather'] = '坐在長椅上.'
L['pt_alch_experimental_decay_sample_note'] = '在一個綠色的大鍋內'
L['pt_alch_firewater_powder_sample_note'] = '在木頭房子外面的花瓶附近'
L['pt_ench_enriched_earthen_shard_note'] = '在一堆石頭上'
L['pt_ench_faintly_enchanted_remains_note'] = '點選 |cFFFFFD00Mana-Starved Crystal Cluster|r 來召喚並殺掉怪物. 然後拾取出現的水晶'
L['pt_ench_forgotten_arcane_tome_note'] = '在墓地入口右邊的地上.'
L['pt_jewel_crystalline_overgrowth_note'] = '在小池塘邊.'
L['pt_jewel_harmonic_crystal_harmonizer_note'] = '點選箱子來獲得增益, 然後點選3個水晶.'
L['pt_leath_decay_infused_tanning_oil_note'] = '在桶子裡.'
L['pt_leath_treated_hides_note'] = '在 |cFFFFFD00雪革營地|r.'
L['pt_leath_well_danced_drum_note'] = '和 {npc:186446} 跟 {npc:186448} 在一個地下建築物內. 修好 {npc:194862} 附近的鼓. 當他開始在上面跳舞時你就可以拾取物品.'
L['pt_script_dusty_darkmoon_card_note'] = '在一個上層建築物內.'
L['pt_script_frosted_parchment_note'] = '在 {npc:190776} 後面.'
L['pt_smith_spelltouched_tongs_note'] = '在一個被堵住的小山洞裡.'
L['pt_tailor_decaying_brackenhide_blanket_note'] = '掛在一個臨時帳篷內的樹上.'
L['pt_tailor_intriguing_bolt_of_blue_cloth_note'] = '沿者階梯的左方.'

L['leyline_note'] = '重新校正地脈'
L['options_icons_leyline'] = '{achievement:16638}'
L['options_icons_leyline_desc'] = '顯示成就 {achievement:16638} 中所有地脈的位置.'

L['river_rapids_wrangler_note'] = '和 {npc:186157} 對話並選擇 "我想要再搭一次你的激流泛舟". 你有60秒來收集40層的 {spell:373490}.'
L['seeing_blue_note'] = '從蒼藍文庫上空不著陸的飛行直到鈷藍集會.'
L['snowman_note'] = '這裡有3個 {npc:197599} 躺在這個區域 (可能被其他玩家移動位置), 滾動他們到兩個小孩 {npc:197838} 和 {npc:197839}.\n當雪球有正確大小時你會獲得成就.'

L['snowclaw_cub_note_start'] = '你必須完成在 |cFFFFFD00沃卓肯|r 的 {npc:192522} 給予的 {quest:67094} 故事線來取得 |cFFFFFD00『榮譽林精』|r 稱號.'
L['snowclaw_cub_note_item1'] = '從 |cFFFFFD00甦醒海岸|r 的各種 {npc:182559} 拾取3個 {item:197744}.'
L['snowclaw_cub_note_item2'] = '從 |cFFFFFD00甦醒海岸|r 的 {npc:193310} 購買1個 {item:198356}'
L['snowclaw_cub_note_end'] = ns.color.Orange('所有的物品都可以在拍賣場買到. 如果你沒有剛好擁有用來和 {npc:193310} 購買東西所需的 {item:199215} 時, 這會特別有幫助') .. '\n\n當你裝備上稱號後, 提供所需的4個物品給 {npc:196768} 來取得寵物.' .. ns.color.Red('\n\nBUG: 稱號可能會消失需等待修正.')

L['tome_of_polymoph_duck'] = '使用 {spell:1953} 來進入洞窟並和 |cFFFFFD00初學者的法力風暴|r 書互動來完成任務'

L['temperamental_skyclaw_note'] = [[
收集 (或從拍賣場購買):

20x {item:201420}
20x {item:201421}
20x {item:201422}

詢問上鞍蠍尾飛狐的事並且將收集的餐點交給 {npc:190892}.
]]

L['elder_poa_note'] = '用 {item:200071} 交換 |cFFFFFD00伊斯凱拉巨牙海民|r 聲望'

-------------------------------------------------------------------------------
------------------------------- FORBIDDEN REACH -------------------------------
-------------------------------------------------------------------------------

L['bag_of_enchanted_wind'] = '一袋祕法之風'
L['bag_of_enchanted_wind_note'] = '位於塔頂內.'
L['hessethiash_treasure'] = '赫瑟西亞許的不隱密寶箱'
L['lost_draconic_hourglass'] = '失落的龍沙漏'
L['suspicious_bottle_treasure'] = '可疑的瓶子'
L['mysterious_wand'] = '神秘魔杖'
L['mysterious_wand_note'] = '撿起 |cFFFFFD00水晶鑰匙|r 並把它放進 |cFFFFFD00水晶法器|r內.'

-------------------------------------------------------------------------------
------------------------------ OHN'AHRAN PLAINS -------------------------------
-------------------------------------------------------------------------------

L['hunter_of_the_deep_note'] = '點選武器架然後射魚直到稀有刷新'
L['scaleseeker_mezeri_note'] = '把{item:194681} 提供給 {npc:193224}後, 他會接露稀有.'
L['shade_of_grief_note'] = '點選 {npc:193166} 來召喚稀有.'
L['windscale_the_stormborn_note'] = '殺死對 {npc:192357} 引導法術的 {npc:192367}.'
L['zarizz_note'] = '點選並對著4個 {npc:193169} 使用' .. ns.color.Orange('/hiss') .. '來召喚稀有.'

L['gold_swong_coin_note'] = '和 {npc:191608} 一起在山洞內, 且在她的右側.'
L['nokhud_warspear_note'] = '{item:194540} 可以在遠征隊斥侯包和挖過的土中找到.'
L['slightly_chewed_duck_egg_note'] = '找到並撫摸 {npc:192997} 來取得 {item:195453} 後再使用它. {item:199171} 將在3天後孵化成 {item:199172}.'
L['yennus_boat'] = '巨牙海民玩具船'
L['yennus_boat_note'] = '拾取巨牙海民玩具船來取得 {item:200876}, 其可以開始任務 {quest:72063}, 可以向 {npc:195252} 回報.'

L['pm_ench_shalasar_glimmerdusk'] = '在壞掉的塔2樓'
L['pm_herb_hua_greenpaw'] = '在一棵樹邊跪著'
L['pm_leath_erden'] = '在河邊一個死掉的 {npc:193092} 旁邊站著'
L['pt_alch_canteen_of_suspicious_water_note'] = '在洞穴深處, 靠近一個死掉的 {npc:194887}.'
L['pt_ench_stormbound_horn_note'] = '在 |cFFFFFD00風頌高地|r.'
L['pt_jewel_fragmented_key_note'] = '在一個崩塌建築裡的樹根下.'
L['pt_jewel_lofty_malygite_note'] = '漂浮在一個洞穴的空中.'
L['pt_leath_wind_blessed_hide_note'] = '在 |cFFFFFD00席卡高地|r 內的半人馬營地.'
L['pt_script_sign_language_reference_sheet_note'] = '掛在帳篷的入口.'
L['pt_smith_ancient_spear_shards_note'] = '在|cFFFFFD00拉札薩爾之境|r.'
L['pt_smith_falconer_gauntlet_drawings_note'] = '海上的小島, 在一個小屋內.'
L['pt_tailor_noteworthy_scrap_of_carpet_note'] = '坐落於一個小屋. ' .. ns.color.Orange('小屋內有三支菁英.')
L['pt_tailor_silky_surprise_note'] = '找到並拾取一個 |cFFFFFD00貓草嫩葉|r.'

L['lizi_note'] = '完成從 {quest:65901} 開始的 學徒的休假日 故事線. 每天完成任務來修補莉茲並取得你的坐騎.\n\n除了任務需要的物品外, 所有任務都需要150個 {currency:2003}, 總共需要750個 {currency:2003}.'
L['lizi_note_day1'] = '從 |cFFFFFD00巨龍群島|r 的昆蟲怪物收集20個 {item:192615}.'
L['lizi_note_day2'] = '從 |cFFFFFD00巨龍群島|r 的植物怪物收集20個 {item:192658}.'
L['lizi_note_day3'] = '從 |cFFFFFD00巨龍群島|r 的任意水域釣到10個 {item:194966}. 常見於 |cFFFFFD00雍亞拉平原|r 的內陸.'
L['lizi_note_day4'] = '從 |cFFFFFD00雍亞拉平原|r 的猛瑪象收集20個 {item:192636}.'
L['lizi_note_day5'] = '從 {npc:190014} 接受任務 {quest:71195}, 並且從 |cFFFFFD00雍伊爾溫泉|r 南邊帳篷內的 {npc:190015} 取得1個 {item:200598}.'

L['ohnahra_note_start'] = '完成從 {quest:65901} 開始的 學徒的休假日 故事線後 {npc:190022} 會出現在 |cFFFFFD00雍伊爾溫泉|r 的風之賢者的帳篷之下.\n\n收集以下的材料:'
L['ohnahra_note_item1'] = '從|cFFFFFD00諾庫德進攻據點|r地城 (英雄難度)的最後首領 {npc:186151} 收集3個 {item:201929}, 不是100%掉落.'
L['ohnahra_note_item2'] = '從 {npc:196707} 使用50個 {currency:2003} 和1個 {item:194562} 來購買1個 {item:201323} .\n{item:194562} 可以從 |cFFFFFD00薩爪祖斯|r 的時佚系列怪物的掉落物取得.'
L['ohnahra_note_item3'] = '從拍賣場購買1個 {item:191507}. (煉金師名望22後可以從 {npc:196707} 購買 {item:191588}'
L['ohnahra_note_end'] = '當你取得所有材料後, 回到 {npc:190022} 並接受任務 {quest:72512}. 到 {npc:194796} 處來回報任務並取得你的坐騎.'

L['bakar_note'] = '撫摸那隻狗!'
L['bakar_ellam_note'] = '如果足夠的人撫摸了這隻狗, 她會帶你去她的寶藏.'
L['bakar_hugo_note'] = '和艾拉格營地一起旅行.'
L['options_icons_bakar'] = '{achievement:16424}'
L['options_icons_bakar_desc'] = '顯示成就 {achievement:16424} 所需的所有巴卡犬的位置.'

L['ancestor_note'] = '在 |cFFFFFD00木階哨站|r 的帳篷從 |cFFFFFD00甦醒精華|r 取得 {spell:369277} 增益(1小時)來看到先祖並且提供他們需要的物品.'
L['options_icons_ancestor'] = '{achievement:16423}'
L['options_icons_ancestor_desc'] = '顯示成就 {achievement:16423} 中先祖的位置.'

L['dreamguard_note'] = '點選夢境守衛並且使用表情符號 ' .. ns.color.Orange('/sleep')
L['options_icons_dreamguard'] = '{achievement:16574}'
L['options_icons_dreamguard_desc'] = '顯示 {achievement:16574} 成就所需的夢境守衛位置.'

L['khadin_note'] = '使用 {item:191784} 交換專業知識'
L['the_great_swog_note'] = '使用 {item:199338}, {item:199339} 和 {item:199340} 來交換 {item:202102}.'
L['hunt_instructor_basku_note'] = '用 {item:200093} 交換 |cFFFFFD00莫魯克半人馬|r 聲望'

-------------------------------------------------------------------------------
--------------------------------- THALDRASZUS ---------------------------------
-------------------------------------------------------------------------------

L['ancient_protector_note'] = '殺調附近的 {npc:193244} 來取得 {item:197708}. 組合5個 {item:197708} 來產生 {item:197733}. 並且使用它來啟動附近的泰坦反應爐'
L['blightpaw_note'] = '和附近的 {npc:193222} 交談並同意幫助他.'
L['corrupted_proto_dragon_note'] = '和 |cFFFFFD00腐化的龍蛋|r 互動來召喚稀有'
L['weeping_vilomah_note'] = '和 {npc:193206} 對話來召喚稀有'
L['woofang_note'] = '撫摸 {npc:193156} 來召喚稀有.'

L['acorn_harvester_note'] = '在附近的地上收集一個 |cFFFFFD00橡實|r 來取得 {spell:388485} 之後再和 {npc:196172} 互動.\n\n|cFFFF0000(BUG: 要點選 {npc:196172} 可能需要重新載入)|r.'
L['cracked_hourglass_note'] = '{item:199068} 可以在遠征隊斥侯包和挖過的土中找到.'
L['sandy_wooden_duck_note'] = '收集 {item:199069} 並使用它.'

L['tasty_hatchling_treat_note'] = '在書架後的一個桶子內'

L['pm_mining_bridgette_holdug'] = '在一個長草的石柱頂端'
L['pm_tailor_elysa_raywinder'] = '在塔中間的平台上'
L['pt_alch_contraband_concoction_note'] = '藏在樹叢內' .. ns.color.Orange('很難看到.')
L['pt_alch_furry_gloop_note'] = '各丟一個在附近的 {npc:194855} 到每個大鍋, 然後殺掉刷新出來的怪物'
L['pt_ench_fractured_titanic_sphere_note'] = '|cFFFFFD00提爾堡|r 南邊.'
L['pt_jewel_alexstraszite_cluster_note'] = '|cFFFFFD00提爾堡|r 內.'
L['pt_jewel_painters_pretty_jewel_note'] = '在燈籠內'
L['pt_leath_decayed_scales_note'] = '在籃子內'
L['pt_script_counterfeit_darkmoon_deck_note'] = '和 {npc:194856} 講話並幫助她整理散落在他腳邊的 |cFFFFFD00暗月套卡|r. 依照順序點選卡片 (A到8) 之後和她交談來取得套卡.'
L['pt_script_forgetful_apprentices_tome_note'] = '在桌上一個大望遠鏡旁'
L['pt_script_how_to_train_your_whelpling_note'] = '躺在沙盒內的一本小棕書'
L['pt_smith_draconic_flux_note'] = '在一棟建築內'
L['pt_tailor_ancient_dragonweave_bolt_note'] = '點選 |cFFFFFD00古老的龍紡織布機|r 來完成一個小遊戲把線捲連到中間的寶石.'
L['pt_tailor_miniature_bronze_dragonflight_banner_note'] = '在一堆沙中的小旗幟'

L['picante_pomfruit_cake_note'] = '{item:200904} 不是每天都有, 請每天回來 |cFF00CCFF晶紅盛宴|r 檢查. 當你在這的時候, 記得試吃3種有的食物來同時完成 {achievement:16556}.'
L['icecrown_bleu_note'] = '從在 |cFF00CCFF工匠市場|r 的 {npc:196729} ' .. ns.color.NPC('<乳酪商>') .. ' 處購買.'
L['dreamwarding_dripbrew_note'] = '從在 |cFFFFFD00深夜實驗室|r 的 {npc:197872} ' .. ns.color.NPC('<咖啡法師>') .. ' 處購買.'
L['arcanostabilized_provisions_note'] = '從在 |cFF00CCFF時光合流|r 內的 |cFF00CCFF洪荒使者未來|r 的 {npc:198831} ' .. ns.color.NPC('<大廚>') .. ' 處購買.'
L['steamed_scarab_steak_note'] = '從在 |cFFFFFD00安詳夢境水療中心|r 的 {npc:197586} ' .. ns.color.NPC('<水療中心酒保>') .. ' 處購買.'
L['craft_creche_crowler_note'] = '從在每天地圖下列隨機位置 |cFFFFFD00晶紅生命聖殿|r, |cFFFFFD00綠鱗旅店|r, |cFFFFFD00穆斯提的大帳篷|r, |cFFFFFD00時光合流|r 的 {npc:187444} ' .. ns.color.NPC('<旅行龍釀商人>') .. ' 處購買.'
L['bivigosas_blood_sausages_note'] = '從在 |cFFFFFD00蓋利奇爾崗哨|r 的 {npc:188895} ' .. ns.color.NPC('<食物和飲料>') .. ' 處購買.'
L['options_icons_specialties'] = '{achievement:16621}'
L['options_icons_specialties_desc'] = '顯示成就 {achievement:16621} 所需的食物和飲料位置.'

L['new_perspective_note'] = '在遠景位置使用任何自拍相機拍張照. 當一進入拍攝模式拍攝位置會被一個紫色圈圈標記.\n\n如果你沒有取得成就進度, 請換一個視角.'
L['options_icons_new_perspective'] = '{achievement:16634}'
L['options_icons_new_perspective_desc'] = '顯示成就 {achievement:16634} 所需的遠景位置.'

L['ruby_feast_gourmand'] = '一個隨機的客座大廚會每天提供不同的食物和飲料'

L['sorotis_note'] = '用 {item:199906} 交換 |cFFFFFD00沃卓肯協調者|r 聲望'

-------------------------------------------------------------------------------
------------------------------ THE WAKING SHORE -------------------------------
-------------------------------------------------------------------------------

L['brundin_the_dragonbane_note'] = '喀拉希戰爭隊伍坐在他們的 {npc:192737} 往這座塔旅行.'
L['captain_lancer_note'] = '在完成 {spell:388945} 事件後會立即重生'
L['enkine_note'] = '殺掉沿著熔岩河的 {npc:193137}, {npc:193138} 或 {npc:193139} 取得 {item:201092}, 使用它並在 {npc:191866} 的附近熔岩中釣魚'
L['lepidoralia_note'] = '在 |cFFFFFD00振翅洞穴|r. 幫助 {npc:193342} 抓住 {npc:193274} 直到稀有刷新'
L['obsidian_citadel_rare_note'] = '你或其他玩家必須要繳交總共 %d個 {item:191264} 給 %s. 要鑄造鑰匙你需要結合30個 {item:191251} 和3個 {item:193201}, 你可以在|cFFFFFD00黑曜王座|r的怪物身上取得這些物品'
L['shadeslash_note'] = '點選 |cFFFFFD00Pilfered Focus|r 來召喚稀有'
L['obsidian_throne_rare_note'] = '在|cFFFFFD00黑曜王座|r內. '
L['skald_impaler_note'] = '使用5個 {item:194701} 來召喚稀有'
L['slurpo_snail_note'] = '在|cFFFFFD00蒼藍高原|r (11, 41) 的山洞拾取一個 item:201033}並在此山洞使用來召喚他'
L['worldcarver_atir_note'] = '從附近的 {npc:187366} 收集3個 {item:191211}, 並且將他們放置在 {npc:197395} 來召喚稀有'

L['bubble_drifter_note'] = '{item:199061} 可以在遠征隊斥侯包和挖過的土中找到.'
L['dead_mans_chestplate_note'] = '在塔中間的樓層'
L['fullsails_supply_chest_note'] = '鑰匙由 |cFFFFFD00翼息大使館|r 南方的 {npc:187971} 和 {npc:187320} 掉落'
L['golden_dragon_goblet_note'] = '從|cFFFFFD00荒野海岸|r上的 {npc:190056} 拾取 {item:202081}並完成小任務線'
L['misty_treasure_chest_note'] = '站在突出瀑布的 {npc:185485} 來進入洞窟'
L['onyx_gem_cluster_note'] = '當龍鱗遠征隊的名望到達21時, 你可以完成任務 {quest:70833} 來取得報酬 {item:200738} (每個帳號一次) 或是從 {npc:189065} 處用3個 {item:192863} 和 500{currency:2003} 來購買地圖並使用它.'
L['torn_riding_pack_note'] = '在瀑布的頂端'
L['yennus_kite_note'] = '卡在樹頂的一根樹枝'

L['fullsails_supply_chest'] = '滿帆補給箱'
L['hidden_hornswog_hoard_note'] = [[
收集三個不同物品並且在靠近 {npc:192362} 附近的 |cFFFFFD00"觀察謎題: 田野指南"|r 來組合以取得 {item:200063} 並且餵給牠. 接著牠會讓開路讓你拾取牠的寶藏.

{item:200064}
{item:200065}
{item:200066}
]]

L['pm_alch_grigori_vialtry'] = '在一個平台上俯瞰 |cFFFFFD00閃霜進攻地|r.'
L['pm_skin_zenzi'] = '在河邊坐著'
L['pm_smith_grekka_anvilsmash'] = '在塔的廢墟旁邊的草地上.'
L['pt_alch_frostforged_potion_note'] = '在冰坑中間'
L['pt_alch_well_insulated_mug_note'] = '在 |cFFFFFD00龍禍要塞|r 內許多菁英怪之間'
L['pt_ench_enchanted_debris_note'] = '使用並跟著 {npc:194872} 到最後來拾取碎片'
L['pt_ench_flashfrozen_scroll_note'] = '在 |cFFFFFD00閃霜營地|r 的洞穴系統內'
L['pt_ench_lava_infused_seed_note'] = '在 |cFFFFFD00碎鱗者要塞|r 的一朵花內'
L['pt_engi_boomthyr_rocket_note'] = '收集列在 |cFFFFFD00轟希爾火箭筆記|r 內的物品:\n\n{item:198815}\n{item:198817}\n{item:198816}\n{item:198814}\n\n當你收集完後, 帶著它們回來到火箭以取得寶藏.'
L['pt_engi_intact_coil_capacitor_note'] = '和三個 |cFFFFFD00裸露電線|r 互動來修好並拾取 |cFFFFFD00超載的特斯拉線圈|r.'
L['pt_jewel_closely_guarded_shiny_note'] = '樹下巢邊的藍色寶石'
L['pt_jewel_igneous_gem_note'] = '快速點選在岩漿內的小島上的三個水晶'
L['pt_leath_poachers_pack_note'] = '在河床旁一個死掉的狐狸人旁邊'
L['pt_leath_spare_djaradin_tools_note'] = '在死掉的紅龍旁邊'
L['pt_script_pulsing_earth_rune_note'] = '在倒塌建築內的桌子後方'
L['pt_smith_ancient_monument_note'] = '擊敗在臺座上環繞著劍的4個 {npc:188648}.\n\n|cFFFF0000(BUG: 目前在點選劍後你不會取得物品, 取而代之的是它在過段時間後會寄到你的信箱.)|r'
L['pt_smith_curious_ingots_note'] = '在 |cFFFFFD00碎鱗者要塞|r 內地上的小金屬錠'
L['pt_smith_glimmer_of_blacksmithing_wisdom_note'] = '在 |cFFFFFD00黯淡的熔爐|r 旁製造1個 {item:189541}, 然後在 |cFFFFFD00淬火盆|r 裡的物品會變成可拾取的'
L['pt_smith_molten_ingot_note'] = '踢3個金屬錠到熔岩中來召喚怪物. 在擊敗怪物後拾取箱子.'
L['pt_smith_qalashi_weapon_diagram_note'] = '在一個鐵砧上方'
L['pt_tailor_itinerant_singed_fabric_note'] = '在最後首領刷新的山洞外面樹上掛著的一片織物.' .. ns.color.Orange('需要精準的御龍術或是術士傳送門.')
L['pt_tailor_mysterious_banner_note'] = '在建築物的頂端飄著'

L['quack_week_1'] = '第1個星期'
L['quack_week_2'] = '第2個星期'
L['quack_week_3'] = '第3個星期'
L['quack_week_4'] = '第4個星期'
L['quack_week_5'] = '第5個星期'
L['lets_get_quacking'] = '你每個禮拜只能拯救一個 {npc:187863}'

L['complaint_to_scalepiercer_note'] = '點選小屋內的 |cFFFFFD00石板|r (在左側後方).'
L['grand_flames_journal_note'] = '點選小屋外面後方的 |cFFFFFD00石板|r.'
L['wyrmeaters_recipe_note'] = '點選小屋內的 |cFFFFFD00石板|r (在左側)'

L['options_icons_ducklings'] = '{achievement:16409}'
L['options_icons_ducklings_desc'] = '顯示成就 {achievement:16409} 所需的小鴨子位置.'
L['options_icons_chiseled_record'] = '{achievement:16412}'
L['options_icons_chiseled_record_desc'] = '顯示成就 {achievement:16412} 所需的石板位置.'

L['grand_theft_mammoth_note'] = '騎 {npc:194625} 到 {npc:198163}.\n\n|cFFFF0000(BUG: 如果你不能和 {npc:194625} 互動請使用 /reload.)|r'
L['options_icons_grand_theft_mammoth'] = '{achievement:16493}'
L['options_icons_grand_theft_mammoth_desc'] = '顯示成就 {achievement:16493} 所需 {npc:194625} 的位置.'

L['options_icons_stories'] = '{achievement:16406}'
L['options_icons_stories_desc'] = '成就 {achievement:16406} 所需的任務位置'
L['all_sides_of_the_story_garrick_and_shuja_note'] = '開始任務線並聆聽 {npc:184449} 和 {npc:184451} 的故事.'
L['all_sides_of_the_story_duroz_and_kolgar_note'] = '在平台下方的小房間.\n\n開始任務線並聆聽 {npc:194800} 和 {npc:194801} 的故事. 更多的任務會在接下來的兩個禮拜內解鎖.'
L['all_sides_of_the_story_tarjin_note'] = '從 {quest:70779} 開始的任務線.\n\n每個禮拜 {npc:196214} 會告訴你一個另外的故事.'
L['all_sides_of_the_story_veritistrasz_note'] = '開始任務 {quest:70132} 來了解所有有關 {npc:194076} 的故事.\n之後你會解鎖任務 {quest:70268} 和接著的任務 {quest:70134}.\n\n關於最後一個任務, 你會需要可以在 ' .. ns.color.Yellow('龍禍要塞') .. ' 內找到的 {item:198661}.'

L['slumbering_worldsnail_note1'] = [[
    1. 從 |cFFFFFD00黑曜龍堡|r 附近的怪物收集3個 {item:193201} 和30個 {item:191251} 來製造 {item:191264}.

    2. 和 {npc:187275} 用 {item:191264} 交換 {item:200069}.

    3. 箱子有30%的機率會含有 {item:199215}.

    4. 使用會員證會給你 {spell:386848} 減益, 讓你可以在 |cFFFFFD00黑曜龍堡|r 附近農 {item:202173}.

    5. 蒐集1000個 {item:202173} 來購買 {item:192786}.]]
L['slumbering_worldsnail_note2'] = ns.color.Orange('注意: 如果你死了你會失去你的會員減益. 要嘛是你在死前和 {npc:193310} 使用20個{item:202173}購買新的會員證或是你需要繳交更多的鑰匙來有機率從箱子裡取得新的會員證')

L['magmashell_note'] = '從 |cFFFFFD00黑曜龍堡|r 附近的 {npc:193138} 身上拾取 {item:201883} 並帶給 {npc:199010}.\n\n' .. ns.color.Orange('要取得坐騎需要在熔岩上引導1個20秒的法術, 推薦找個治療者或是帶著 {item:200116}.')

L['otto_note_start1'] = nil
L['otto_note_start2'] = nil
L['otto_note_start3'] = nil
L['otto_note_item1'] = nil
L['otto_note_item2'] = nil
L['otto_note_item3'] = nil
L['otto_note_end'] = nil

L['options_icons_safari'] = '{achievement:16519}'
L['options_icons_safari_desc'] = '顯示成就 {achievement:16519} 所需的戰寵位置'
L['shyfly_note'] = '你必須要正在做 {quest:70853} 任務才能看到 {npc:189102}.'

L['cataloger_jakes_note'] = '用 {item:192055} 交換 |cFFFFFD00龍鱗遠征隊|r 聲望'
