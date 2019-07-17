local addonName, privateTable = ...
if (GetLocale() == "zhCN") then
privateTable.L = setmetatable({
	["reset"]="设置已重置",
	["usage1"]="'on'/'off' 命令用来启用或禁用自动交接（启用后按住SHIFT可禁用）",
	["usage2"]="'all'/'list' 是全部任务还是仅列表中的人物",
	["usage3"]="'loot' do not complete quests with a list of rewards or complete it and choose most expensive one of rewards",
	["enabled"]="启用",
	["disabled"]="禁用",
	["all"]="ready to handle every quest",
	["list"]="only daily quests will be handled",
	["dontlootfalse"]="loot most expensive reward",
	["dontloottrue"]="do not complete quests with rewards",
	["resetbutton"]="默认设置",
	
	["questTypeLabel"] = "自动交接的任务",
	["questTypeAll"] = "全部",
    ["questTypeList"] = "日常",
    ["questTypeExceptDaily"] = "除日常外的全部",
    ["TrivialQuests"]="接受低等级任务",
	["ShareQuestsLabel"] = "自动与队友分享任务",
    ["AcceptSharedQuestsLabel"] = "自动接受队友分享的任务",
    ["CompleteOnly"] = "只自动交任务(不自动接)",

	["lootTypeLabel"]="有奖励的任务",
	["lootTypeFalse"]="不自动交",
	["lootTypeGreed"]="选择最贵的奖励",
	["lootTypeNeed"]="根据规则选择",
	
	["tournamentLabel"]="银色锦标赛(WLK)",
	["tournamentWrit"]="冠军的文书", -- 46114
	["tournamentPurse"]="冠军的钱包",  -- 45724
	
	["DarkmoonTeleLabel"]="暗月：传送到大炮",
	["ToDarkmoonLabel"]="暗月：传送到岛",
	["DarkmoonFaireTeleport"]="传送技师弗兹尔巴布",
	["DarkmoonAutoLabel"]="暗月：开始游戏",
	["Darkmoon Island"]="Darkmoon Island",
	["Darkmoon Faire Mystic Mage"]="Darkmoon Faire Mystic Mage",

    ["ReviveBattlePetLabel"]="宠物训练师自动治疗（暂不支持）", --todo abyui
   	["ReviveBattlePetQ"]="I'd like to heal and revive my battle pets.",
   	["ReviveBattlePetA"]="A small fee for supplies is required.",
	
	["The Jade Forest"]="The Jade Forest",
    ["Scared Pandaren Cub"]="Scared Pandaren Cub",
	
	["rewardtext"]="显示任务完成的聊天文本",
	["questlevel"]="显示任务等级",
	["watchlevel"]="任务追踪列表中显示任务等级",
	["autoequip"]="自动装备任务奖励",
	["togglekey"]="暂时启用/停用热键",
	
	['Jewelry']="珠宝",
	["rewardlootoptions"]="奖励选择规则",
	['greedifnothing']='如果没有符合规则的奖励，则选择最贵的',
	["multiplefound"]="存在多个符合规则的奖励. "..ERR_QUEST_MUST_CHOOSE,
	["nosuitablefound"]="没有符合规则的奖励. "..ERR_QUEST_MUST_CHOOSE,
	["gogreedy"]="没有符合规则的奖励, 自动选择了价值最高的一个.",
	["rewardlag"]=BUTTON_LAG_LOOT_TOOLTIP.. '. '..ERR_QUEST_MUST_CHOOSE,
	["stopitemfound"]="There is %s in rewards. Choose and equip an item yourself.",
	["relictoggle"]="禁用神器奖励",
	["artifactpowertoggle"]="禁用神器能量奖励的自动完成.",
	},
	{__index = function(table, index) return index end})
	
privateTable.L.quests = {
-- Steamwheedle Cartel
['Making Amends']={item="Runecloth", amount=40, currency=false},
['War at Sea']={item="Mageweave Cloth", amount=40, currency=false},
['Traitor to the Bloodsail']={item="Silk Cloth", amount=40, currency=false},
['Mending Old Wounds']={item="Linen Cloth", amount=40, currency=false},
-- AV both fractions
['补充坐骑']={donotaccept=true}, --7001, 7027
-- Alliance AV Quests
['水晶簇']={donotaccept=true}, --7386
['森林之王伊弗斯']={donotaccept=true}, --6881
["天空的召唤 - 艾克曼的空军"]={donotaccept=true}, --6943
["天空的召唤 - 斯里多尔的空军"]={donotaccept=true}, --6942
["天空的召唤 - 维波里的空军"]={donotaccept=true}, --6941
['护甲碎片']={donotaccept=true}, --7223
['护甲碎片']={donotaccept=true}, --6781
['Ram Riding Harnesses']={donotaccept=true}, --7026
-- Horde AV Quests
['联盟之血']={donotaccept=true}, --7385
['冰雪之王洛克霍拉']={donotaccept=true}, --6801
["天空的召唤 - 古斯的部队"]={donotaccept=true}, --6825
["天空的召唤 - 杰斯托的部队"]={donotaccept=true}, --6826
["天空的召唤 - 穆维里克的部队"]={donotaccept=true}, --6827
['敌人的物资']={donotaccept=true}, --7224
['取之于敌']={donotaccept=true}, --6741
['羊皮坐具']={donotaccept=true}, --7002
-- Timbermaw Quests
['Feathers for Grazle']={item="Deadwood Headdress Feather", amount=5, currency=false},
['Feathers for Nafien']={item="Deadwood Headdress Feather", amount=5, currency=false},
['More Beads for Salfa']={item="Winterfall Spirit Beads", amount=5, currency=false},
-- Cenarion
['Encrypted Twilight Texts']={item="Encrypted Twilight Text", amount=10, currency=false},
['Still Believing']={item="Encrypted Twilight Text", amount=10, currency=false},
-- Thorium Brotherhood
['Favor Amongst the Brotherhood, Blood of the Mountain']={item="Blood of the Mountain", amount=1, currency=false},
['Favor Amongst the Brotherhood, Core Leather']={item="Core Leather", amount=2, currency=false},
['Favor Amongst the Brotherhood, Dark Iron Ore']={item="Dark Iron Ore", amount=10, currency=false},
['Favor Amongst the Brotherhood, Fiery Core']={item="Fiery Core", amount=1, currency=false},
['Favor Amongst the Brotherhood, Lava Core']={item="Lava Core", amount=1, currency=false},
['Gaining Acceptance']={item="Dark Iron Residue", amount=4, currency=false},
['Gaining Even More Acceptance']={item="Dark Iron Residue", amount=100, currency=false},

-- Fiona's Caravan http://www.wowhead.com/npc=45400
["阿古斯的日记"]={donotaccept=true}, --27560
["Beezil's Cog"]={donotaccept=true}, --27562
["菲奥拉的好运符"]={donotaccept=true}, --27555
["吉德文的武器油"]={donotaccept=true}, --27556
["帕米拉的洋娃娃"]={donotaccept=true}, --27558
["雷布拉特的石块"]={donotaccept=true}, --27561
["塔伦纳的护符"]={donotaccept=true}, --27557
["维克斯图的臂章"]={donotaccept=true}, --27559

--[[Burning Crusade]]--
--Lower City
["More Feathers"]={item="Arakkoa Feather", amount=30, currency=false},
--Aldor
["More Marks of Kil'jaeden"]={item="Mark of Kil'jaeden", amount=10, currency=false},
["More Marks of Sargeras"]={item="Mark of Sargeras", amount=10, currency=false},
["Fel Armaments"]={item="Fel Armaments", amount=10, currency=false},
["Single Mark of Kil'jaeden"]={item="Mark of Kil'jaeden", amount=1, currency=false},
["Single Mark of Sargeras"]={item="Mark of Sargeras", amount=1, currency=false},
["More Venom Sacs"]={item="Dreadfang Venom Sac", amount=8, currency=false},
--Scryer
["More Firewing Signets"]={item="Firewing Signet", amount=10, currency=false},
["More Sunfury Signets"]={item="Sunfury Signet", amount=10, currency=false},
["Arcane Tomes"]={item="Arcane Tome", amount=1, currency=false},
["Single Firewing Signet"]={item="Firewing Signet", amount=1, currency=false},
["Single Sunfury Signet"]={item="Sunfury Signet", amount=1, currency=false},
["More Basilisk Eyes"]={item="Dampscale Basilisk Eye", amount=8, currency=false},
--Skettis
["More Shadow Dust"]={item="Shadow Dust", amount=6, currency=false},
--SporeGar
["Bring Me Another Shrubbery!"]={item="Sanguine Hibiscus", amount=5, currency=false},
["More Fertile Spores"]={item="Fertile Spores", amount=6, currency=false},
["More Glowcaps"]={item="Glowcap", amount=10, currency=false},
["More Spore Sacs"]={item="Mature Spore Sac", amount=10, currency=false},
["More Tendrils!"]={item="Bog Lord Tendril", amount=6, currency=false},
-- Halaa
["Oshu'gun Crystal Powder"]={item="Oshu'gun Crystal Powder Sample", amount=10, currency=false},

["Hodir's Tribute"]={item="Relic of Ulduar", amount=10, currency=false},
["Remember Everfrost!"]={item="Everfrost Chip", amount=1, currency=false},
["Additional Armaments"]={item=416, amount=125, currency=true},
["Calling the Ancients"]={item=416, amount=125, currency=true},
["Filling the Moonwell"]={item=416, amount=125, currency=true},
["进入火焰之中"]={donotaccept=true}, --29206
["The Forlorn Spire"]={donotaccept=true}, --20205
["Fun for the Little Ones"] = {item=393, amount=15, currency=true},
--MoP
["Seeds of Fear"]={item="Dread Amber Shards", amount=5, currency=false},
["A Dish for Jogu"]={item="Sauteed Carrots", amount=5, currency=false},

["A Dish for Ella"]={item="Shrimp Dumplings", amount=5, currency=false},
["Valley Stir Fry"]={item="Valley Stir Fry", amount=5, currency=false},
["A Dish for Farmer Fung"]={item="Wildfowl Roast", amount=5, currency=false},
["A Dish for Fish"]={item="Twin Fish Platter", amount=5, currency=false},
["Swirling Mist Soup"]={item="Swirling Mist Soup", amount=5, currency=false},
["A Dish for Haohan"]={item="Charbroiled Tiger Steak", amount=5, currency=false},
["A Dish for Old Hillpaw"]={item="Braised Turtle", amount=5, currency=false},
["A Dish for Sho"]={item="Eternal Blossom Fish", amount=5, currency=false},
["A Dish for Tina"]={item="Fire Spirit Salmon", amount=5, currency=false},
["Replenishing the Pantry"]={item="Bundle of Groceries", amount=1, currency=false},
--MOP timeless Island
['Great Turtle Meat']={item="Great Turtle Meat", amount=1, currency=false},
['Heavy Yak Flank']={item="Heavy Yak Flank", amount=1, currency=false},
['Meaty Crane Leg']={item="Meaty Crane Leg", amount=1, currency=false},
['Pristine Firestorm Egg']={item="Pristine Firestorm Egg", amount=1, currency=false},
['Thick Tiger Haunch']={item="Thick Tiger Haunch", amount=1, currency=false},

}

privateTable.L.ignoreList = {
--MOP Tillers http://db.178.com/wow/cn/faction/1277.html http://www.wowhead.com/faction=1277
["的泽地百合"]="", --30401
["的可爱的苹果"]="",
["的玉猫"]="",
["的蓝色羽毛"]="",
["的红宝石碎片"]="",
["补给需求：星光玫瑰"]="", --41303
["圣光之城"]="", --10211
}
end