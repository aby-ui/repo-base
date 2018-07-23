
local tdPack = tdCore(...)

local L = tdPack:GetLocale()

local Weapons       = GetItemClassInfo(LE_ITEM_CLASS_WEAPON)
local Armor         = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)
local Containers    = GetItemClassInfo(LE_ITEM_CLASS_CONTAINER)
local Consumables   = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
local Glyphs        = GetItemClassInfo(LE_ITEM_CLASS_GLYPH)
local TradeGoods    = GetItemClassInfo(LE_ITEM_CLASS_TRADEGOODS)
local Recipes       = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
local Gems          = GetItemClassInfo(LE_ITEM_CLASS_GEM)
local ItemEnhances  = GetItemClassInfo(LE_ITEM_CLASS_ITEM_ENHANCEMENT)
local Miscellaneous = GetItemClassInfo(LE_ITEM_CLASS_MISCELLANEOUS)
local Quest         = GetItemClassInfo(LE_ITEM_CLASS_QUESTITEM)
local BattlePet     = GetItemClassInfo(LE_ITEM_CLASS_BATTLEPET)

local FishingPoles = GetItemSubClassInfo(LE_ITEM_CLASS_WEAPON, LE_ITEM_WEAPON_FISHINGPOLE)
local Devices = GetItemSubClassInfo(0, 0)
local Devices = GetItemSubClassInfo(0, 0)

tdPack.DefaultCustomOrder = {
    HEARTHSTONE_ITEM_ID,                    -- 炉石
    140192,                                 -- 达拉然炉石
    141605,                                 -- 飞行管理员的哨子
    110560,                                 -- 要塞炉石
    64488,                                  -- 旅店老板的女儿
    79104,                                  -- 水壶
    2901,                                   -- 矿工锄
    5956,                                   -- 铁匠锤
    7005,                                   -- 剥皮刀
    20815,                                  -- 珠宝制作工具
    39505,                                  -- 学者的书写工具
    118922,                                 -- 疯狂低语水晶
    147717,                                 -- 改装的邪能焦镜
    141652,                                 -- 苏拉玛侦测
    138111,                                 -- 钩爪
    '##' .. Devices,                        -- ##爆炸物与装置(#消耗品)
    '##' .. FishingPoles,                   -- ##鱼竿
    '#'  .. BattlePet,                      -- #战斗宠物
    '#'  .. Weapons,                        -- #武器
    '#'  .. Armor,                          -- #护甲
    '#'  .. Containers,                     -- #容器
    '#'  .. Gems,                           -- #珠宝
    '#'  .. Glyphs,                         -- #雕文
    '#'  .. Recipes,                        -- #配方
    '#'  .. TradeGoods,                     -- #商品
    '#'  .. Miscellaneous,                  -- #其它
    '#'  .. ItemEnhances,                   -- #物品强化
    '#'  .. Consumables,                    -- #消耗品
    '#'  .. Quest,                          -- #任务
}

tdPack.DefaultEquipLocOrder = {
    'INVTYPE_2HWEAPON',         --双手
    'INVTYPE_WEAPON',           --单手
    'INVTYPE_WEAPONMAINHAND',   --主手
    'INVTYPE_WEAPONOFFHAND',    --副手
    'INVTYPE_SHIELD',           --副手
    'INVTYPE_HOLDABLE',         --副手物品
    'INVTYPE_RANGED',           --远程
    'INVTYPE_RANGEDRIGHT',      --远程
    'INVTYPE_THROWN',           --投掷
    
    'INVTYPE_HEAD',             --头部
    'INVTYPE_SHOULDER',         --肩部
    'INVTYPE_CHEST',            --胸部
    'INVTYPE_ROBE',             --胸部
    'INVTYPE_HAND',             --手
    'INVTYPE_LEGS',             --腿部
    
    'INVTYPE_WRIST',            --手腕
    'INVTYPE_WAIST',            --腰部
    'INVTYPE_FEET',             --脚
    'INVTYPE_CLOAK',            --背部
    
    'INVTYPE_NECK',             --颈部
    'INVTYPE_FINGER',           --手指
    'INVTYPE_TRINKET',          --饰品
    
    'INVTYPE_BODY',             --衬衣
    'INVTYPE_TABARD',           --战袍
    
    --  这些应该不需要了
    --  'INVTYPE_RELIC',                --圣物
    --  'INVTYPE_WEAPONMAINHAND_PET',   --主要攻击
    --  'INVTYPE_AMMO',                 --弹药
    --  'INVTYPE_BAG',                  --背包
    --  'INVTYPE_QUIVER',               --箭袋
}

--[[
t = {}
for i=0,100 do
  local n=GetItemClassInfo(i)
  if(not n)then break end
  t[i] = n.."   "
  for j=0,10 do
    local n2 = GetItemSubClassInfo(i,j)
    if(not n2) then break end
    t[i] = t[i]..", "..j..":"..n2
  end
end
wowluacopy(t)

{
  [0] = "消耗品   , 0:爆炸物与装置, 1:药水, 2:药剂, 3:合剂, 4:卷轴, 5:餐饮供应商, 6:物品强化, 7:绷带, 8:其它, 9:凡图斯符文",
  [1] = "容器   , 0:容器, 1:灵魂袋, 2:草药袋, 3:附魔材料袋, 4:工程学材料袋, 5:宝石袋, 6:矿石袋, 7:制皮材料包, 8:铭文包, 9:工具箱, 10:烹饪包",
  [2] = "武器   , 0:单手斧, 1:双手斧, 2:弓, 3:枪械, 4:单手锤, 5:双手锤, 6:长柄武器, 7:单手剑, 8:双手剑, 9:战刃, 10:法杖",
  [3] = "宝石   , 0:智力, 1:敏捷, 2:力量, 3:耐力, 4:精神, 5:爆击, 6:精通, 7:急速, 8:全能, 9:其他, 10:复合属性",
  [4] = "护甲   , 0:其它, 1:布甲, 2:皮甲, 3:锁甲, 4:板甲, 5:装饰品, 6:盾牌, 7:圣契, 8:神像, 9:图腾, 10:魔印",
  [5] = "材料   , 0:材料, 1:钥石",
  [6] = "弹药   , 0:无(魔杖), 1:矢, 2:箭, 3:子弹, 4:投掷武器",
  [7] = "商业技能   , 0:商品, 1:零件, 2:爆炸物, 3:装置, 4:珠宝加工, 5:布料, 6:皮革, 7:金属和矿石, 8:烹饪, 9:草药, 10:元素",
  [8] = "物品强化   , 0:头部, 1:颈部, 2:肩部, 3:披风, 4:胸部, 5:手腕, 6:手部, 7:腰部, 8:腿部, 9:脚部, 10:手指",
  [9] = "配方   , 0:书籍, 1:制皮, 2:裁缝, 3:工程学, 4:锻造, 5:烹饪, 6:炼金术, 7:急救, 8:附魔, 9:钓鱼, 10:珠宝加工",
  [10] = "钱币   , 0:Money(OBSOLETE)",
  [11] = "箭袋   , 0:箭袋, 1:箭矢, 2:箭袋, 3:弹药袋",
  [12] = "任务   , 0:任务",
  [13] = "钥匙   , 0:钥匙, 1:开锁工具",
  [14] = "永久物品   , 0:永久",
  [15] = "杂项   , 0:垃圾, 1:材料, 2:宠物小伙伴, 3:节日, 4:其它, 5:坐骑",
  [16] = "雕文   ",
  [17] = "战斗宠物   , 0:人型, 1:龙类, 2:飞行, 3:亡灵, 4:小动物, 5:魔法, 6:元素, 7:野兽, 8:水栖, 9:机械, 10:",
  [18] = "魔兽世界时光徽章   , 0:魔兽世界时光徽章",
}
--]]