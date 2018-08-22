--local zone = "Siege of Orgrimmar"
local zoneid = 557

-- Check Compatibility
if GridStatusRD_MoP.rd_version < 502 then
	return
end

--zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--[[示例
GridStatusRaidDebuff:DebuffId(zoneid, 法术ID, 序号, 优先级1, 优先级2, 剩余时间, 堆叠层数) --中文名称
序号第1个Boss是1开头，第二个是2开头，如果某个Boss技能过多，自动顺延
优先级1和2设置成一样的即可，由于Grid只能显示一个中心图标，所以高优先级会覆盖掉低优先级的法术
]]

--小怪
GridStatusRaidDebuff:DebuffId(zoneid, 147554, 1, 1, 1, true, true) --亚煞极之血

-- Gates of Orgrimmar
-- Dragonmaw Bonecrusher
GridStatusRaidDebuff:DebuffId(zoneid, 147200, 1, 2, 2) -- Fracture (DoT/Stun)
-- Kor'kron Demolisher
GridStatusRaidDebuff:DebuffId(zoneid, 148311, 1, 2, 2) -- Bombard (Knocked down)
-- Lieutenant Krugruk
GridStatusRaidDebuff:DebuffId(zoneid, 147683, 1, 2, 2) -- Thunder Clap (Magic)

-- Valley of Strength
-- Mokvar the Treasurer
GridStatusRaidDebuff:DebuffId(zoneid, 145553, 1, 2, 2) --贿赂
-- Kor'kron Overseer
GridStatusRaidDebuff:DebuffId(zoneid, 15708, 1, 2, 2) -- Mortal Strike
-- Kor'kron Shadowmage
GridStatusRaidDebuff:DebuffId(zoneid, 145551, 1, 2, 2) -- Shadowflame (Magic)

-- Vault of Y'Shaar
-- Lingering Corruption
GridStatusRaidDebuff:DebuffId(zoneid, 149207, 1, 2, 2) --腐蚀之触

-- Scarred Vale
-- Rook Stonetoe
GridStatusRaidDebuff:DebuffId(zoneid, 144396, 1, 2, 2) -- Vengeful Strikes (DoT/Stun)

-- The Menagerie
--  Enraged Mushan Beast
GridStatusRaidDebuff:DebuffId(zoneid, 148136, 1, 2, 2) -- Lacerating Bite

-- 伊墨苏斯
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Immerseus")
GridStatusRaidDebuff:DebuffId(zoneid, 143297, 11, 5, 5) --煞能喷溅
GridStatusRaidDebuff:DebuffId(zoneid, 143459, 12, 4, 4, true, true) --煞能残渣
GridStatusRaidDebuff:DebuffId(zoneid, 143524, 13, 4, 4, true, true) --净化残渣
GridStatusRaidDebuff:DebuffId(zoneid, 143286, 14, 4, 4) --渗透煞能
GridStatusRaidDebuff:DebuffId(zoneid, 143413, 15, 3, 3) --漩涡
GridStatusRaidDebuff:DebuffId(zoneid, 143411, 16, 3, 3) --增速
GridStatusRaidDebuff:DebuffId(zoneid, 143436, 17, 2, 2, true, true) --腐蚀冲击 (坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143579, 18, 3, 3, true, true) --煞能腐蚀 (仅困难模式)

-- 堕落的守护者
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Fallen Protectors")
GridStatusRaidDebuff:DebuffId(zoneid, 143239, 21, 4, 4) --致命剧毒
GridStatusRaidDebuff:DebuffId(zoneid, 144176, 22, 2, 2, true, true) --Lingering Anguish
--GridStatusRaidDebuff:DebuffId(zoneid, 143023, 23, 3, 3) --蚀骨酒，个人认为不需要
GridStatusRaidDebuff:DebuffId(zoneid, 143301, 24, 2, 2) --凿击
--GridStatusRaidDebuff:DebuffId(zoneid, 143564, 25, 3, 3) --冥想领域，个人认为不需要
GridStatusRaidDebuff:DebuffId(zoneid, 143010, 26, 3, 3) --Corruptive Kick
GridStatusRaidDebuff:DebuffId(zoneid, 143434, 27, 6, 6) --暗言术：蛊 (驱散)
GridStatusRaidDebuff:DebuffId(zoneid, 143840, 28, 6, 6) --苦痛印记
GridStatusRaidDebuff:DebuffId(zoneid, 143959, 29, 4, 4) --亵渎大地
GridStatusRaidDebuff:DebuffId(zoneid, 143423, 30, 6, 6) --煞能灼烧
GridStatusRaidDebuff:DebuffId(zoneid, 143292, 31, 5, 5) --锁定
--GridStatusRaidDebuff:DebuffId(zoneid, 144176, 32, 5, 5, true, true) ---暗影虚弱，个人认为不需要
GridStatusRaidDebuff:DebuffId(zoneid, 147383, 33, 4, 4) --衰竭 (Heroic Only)
GridStatusRaidDebuff:DebuffId(zoneid, 143198, 34, 2, 2) --锁喉


-- 诺鲁什
GridStatusRaidDebuff:BossNameId(zoneid, 35, "Norushen")
GridStatusRaidDebuff:DebuffId(zoneid, 146124, 36, 2, 2, true, true) --自惑 (坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 146324, 37, 4, 4, true, true) --妒忌
--GridStatusRaidDebuff:DebuffId(zoneid, 144639, 38, 6, 6) --腐化，个人认为不需要
GridStatusRaidDebuff:DebuffId(zoneid, 144850, 39, 5, 5) --信赖的试炼
GridStatusRaidDebuff:DebuffId(zoneid, 145861, 40, 6, 6) --自恋 (驱散)
GridStatusRaidDebuff:DebuffId(zoneid, 144851, 41, 2, 2) --自信的试炼 (坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 146703, 42, 3, 3) --无底深渊
GridStatusRaidDebuff:DebuffId(zoneid, 144514, 43, 6, 6) --纠缠腐蚀
GridStatusRaidDebuff:DebuffId(zoneid, 144849, 44, 4, 4) --冷静的试炼
GridStatusRaidDebuff:DebuffId(zoneid, 145725, 45, 3, 3) --Despair

-- Sha of Pride
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Sha of Pride")
GridStatusRaidDebuff:DebuffId(zoneid, 144358, 51, 2, 2) --受损自尊 (坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 144843, 52, 3, 3) --压制
GridStatusRaidDebuff:DebuffId(zoneid, 146594, 53, 4, 4, true, false) --泰坦之赐
GridStatusRaidDebuff:DebuffId(zoneid, 144351, 54, 6, 6, true, true) --傲慢标记
GridStatusRaidDebuff:DebuffId(zoneid, 144364, 55, 4, 4, true, false) --泰坦之力
GridStatusRaidDebuff:DebuffId(zoneid, 146822, 56, 6, 6) --投影
GridStatusRaidDebuff:DebuffId(zoneid, 146817, 57, 5, 5, true, false) --傲气光环
GridStatusRaidDebuff:DebuffId(zoneid, 144774, 58, 2, 2) --伸展打击 (坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 144636, 59, 5, 5) --腐化囚笼??????  下次打看看到底是哪个id
GridStatusRaidDebuff:DebuffId(zoneid, 144574, 60, 6, 6) --腐化囚笼，随机
GridStatusRaidDebuff:DebuffId(zoneid, 145215, 61, 4, 4) --放逐 (仅困难模式)
GridStatusRaidDebuff:DebuffId(zoneid, 147207, 62, 4, 4) --动摇的决心 (仅困难模式)
GridStatusRaidDebuff:DebuffId(zoneid, 144574, 60, 6, 6) --Corrupted Prison
GridStatusRaidDebuff:DebuffId(zoneid, 144574, 60, 6, 6) --Corrupted Prison


-- 迦拉卡斯
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Galakras")
GridStatusRaidDebuff:DebuffId(zoneid, 146765, 71, 5, 5) --烈焰之箭
GridStatusRaidDebuff:DebuffId(zoneid, 147705, 72, 5, 5) --毒性云雾
GridStatusRaidDebuff:DebuffId(zoneid, 146902, 73, 2, 2, true, false) --剧毒利刃
GridStatusRaidDebuff:DebuffId(zoneid, 147068, 74, 2, 2) --Flames of Galakrond

-- 钢铁战蝎
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Iron Juggernaut")
GridStatusRaidDebuff:DebuffId(zoneid, 144467, 81, 2, 2, true, true) --燃烧护甲
GridStatusRaidDebuff:DebuffId(zoneid, 144459, 82, 5, 5, true, true) --激光灼烧
GridStatusRaidDebuff:DebuffId(zoneid, 144498, 83, 5, 5) --爆裂焦油
GridStatusRaidDebuff:DebuffId(zoneid, 144918, 84, 5, 5) --切割激光
GridStatusRaidDebuff:DebuffId(zoneid, 146325, 84, 6, 6) --切割激光瞄准（重点监控）

-- 库卡隆黑暗萨满
GridStatusRaidDebuff:BossNameId(zoneid, 90, "Kor'kron Dark Shaman")
GridStatusRaidDebuff:DebuffId(zoneid, 144089, 91, 6, 6, true, true) --剧毒之雾
GridStatusRaidDebuff:DebuffId(zoneid, 144215, 92, 2, 2, true, true) --冰霜风暴打击(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143990, 93, 2, 2) --污水喷涌(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 144304, 94, 2, 2, true, true) --撕裂
GridStatusRaidDebuff:DebuffId(zoneid, 144330, 95, 6, 6, true, false) --钢铁囚笼(仅英雄模式)

-- 纳兹戈林将军
GridStatusRaidDebuff:BossNameId(zoneid, 100, "General Nazgrim")
GridStatusRaidDebuff:DebuffId(zoneid, 143638, 101, 6, 6, true, true) --碎骨重锤
GridStatusRaidDebuff:DebuffId(zoneid, 143480, 102, 5, 5) --刺客印记
GridStatusRaidDebuff:DebuffId(zoneid, 143431, 103, 6, 6, true, false) --魔法打击(驱散)
GridStatusRaidDebuff:DebuffId(zoneid, 143494, 104, 2, 2, true, true) --碎甲重击(坦克) 
GridStatusRaidDebuff:DebuffId(zoneid, 143882, 105, 5, 5) --猎人印记

-- Malkorok
GridStatusRaidDebuff:BossNameId(zoneid, 110, "Malkorok")
GridStatusRaidDebuff:DebuffId(zoneid, 142990, 111, 6, 6, true, true) --致命打击(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 142913, 112, 5, 5) --散逸能量 (驱散)
GridStatusRaidDebuff:DebuffId(zoneid, 143919, 113, 3, 3) --受难 (仅英雄模式)
GridStatusRaidDebuff:DebuffId(zoneid, 142861, 114, 2, 2) --Ancient Miasma
GridStatusRaidDebuff:DebuffId(zoneid, 142863, 115, 4, 4) --虚弱的上古屏障 - Red
GridStatusRaidDebuff:DebuffId(zoneid, 142864, 116, 4, 4) --上古屏障 - Orange
GridStatusRaidDebuff:DebuffId(zoneid, 142865, 117, 4, 4) --强大的上古屏障 - Green


-- 潘达利亚战利品
GridStatusRaidDebuff:BossNameId(zoneid, 120, "Spoils of Pandaria")
-- GridStatusRaidDebuff:DebuffId(zoneid, 145685, 121, 2, 2) --不稳定的防御系统
GridStatusRaidDebuff:DebuffId(zoneid, 144853, 122, 3, 3, true, true) --血肉撕咬
GridStatusRaidDebuff:DebuffId(zoneid, 145987, 123, 5, 5) --设置炸弹
GridStatusRaidDebuff:DebuffId(zoneid, 145218, 124, 4, 4, true, true) --硬化血肉
GridStatusRaidDebuff:DebuffId(zoneid, 145230, 125, 1, 1) --禁忌魔法
GridStatusRaidDebuff:DebuffId(zoneid, 146217, 126, 4, 4) --投掷酒桶
GridStatusRaidDebuff:DebuffId(zoneid, 146235, 127, 4, 4) --火焰之息
GridStatusRaidDebuff:DebuffId(zoneid, 145523, 128, 4, 4) --活化打击
GridStatusRaidDebuff:DebuffId(zoneid, 142983, 129, 6, 6, true, true) --折磨
GridStatusRaidDebuff:DebuffId(zoneid, 145715, 130, 3, 3) --疾风炸弹
GridStatusRaidDebuff:DebuffId(zoneid, 145747, 131, 5, 5) --浓缩信息素
GridStatusRaidDebuff:DebuffId(zoneid, 146289, 132, 4, 4) --严重瘫痪

-- 嗜血的索克
GridStatusRaidDebuff:BossNameId(zoneid, 140, "Thok the Bloodthirsty")
GridStatusRaidDebuff:DebuffId(zoneid, 143766, 141, 2, 2, true, true) --恐慌(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143773, 142, 2, 2, true, true) --冰冻吐息(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143452, 143, 1, 1) --鲜血淋漓
GridStatusRaidDebuff:DebuffId(zoneid, 146589, 144, 5, 5) --万能钥匙(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143445, 145, 6, 6, true, false) --锁定
GridStatusRaidDebuff:DebuffId(zoneid, 143791, 146, 5, 5, true, true) --腐蚀之血
GridStatusRaidDebuff:DebuffId(zoneid, 143777, 147, 3, 3) --冻结(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143780, 148, 4, 4, true, true) --酸性吐息
GridStatusRaidDebuff:DebuffId(zoneid, 143800, 149, 5, 5, true, true) --冰冻之血
GridStatusRaidDebuff:DebuffId(zoneid, 143428, 150, 4, 4) --龙尾扫击
GridStatusRaidDebuff:DebuffId(zoneid, 143784, 151, 2, 2) --Burning Blood
GridStatusRaidDebuff:DebuffId(zoneid, 143767, 152, 1, 1) --Scorching Breath
-- This is good, don't need to show it
GridStatusRaidDebuff:DebuffId(zoneid, 144115, 153, 1, 1, false, false, 0, true) --Flame Coating

-- 攻城匠师黑索
GridStatusRaidDebuff:BossNameId(zoneid, 160, "Siegecrafter Blackfuse")
GridStatusRaidDebuff:DebuffId(zoneid, 144236, 161, 4, 4) --图像识别
-- GridStatusRaidDebuff:DebuffId(zoneid, 144466, 162, 5, 5) --电磁振荡
GridStatusRaidDebuff:DebuffId(zoneid, 143385, 163, 2, 2, true, true) --电荷冲击(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143856, 164, 6, 6, true, true) --过热

-- 卡拉克西英杰
GridStatusRaidDebuff:BossNameId(zoneid, 170, "Paragons of the Klaxxi")
GridStatusRaidDebuff:DebuffId(zoneid, 143701, 172, 5, 5) --晕头转向
GridStatusRaidDebuff:DebuffId(zoneid, 143702, 173, 5, 5) --晕头转向 打一下副本看看有什么区别
GridStatusRaidDebuff:DebuffId(zoneid, 142808, 174, 6, 6) --炎界
GridStatusRaidDebuff:DebuffId(zoneid, 142931, 177, 2, 2, true, true) --血脉暴露
GridStatusRaidDebuff:DebuffId(zoneid, 143735, 179, 6, 6) --腐蚀琥珀
GridStatusRaidDebuff:DebuffId(zoneid, 146452, 180, 5, 5) --共鸣琥珀
GridStatusRaidDebuff:DebuffId(zoneid, 142929, 181, 2, 2, true, true) --脆弱打击
GridStatusRaidDebuff:DebuffId(zoneid, 142797, 182, 5, 5) --剧毒蒸汽
GridStatusRaidDebuff:DebuffId(zoneid, 143939, 183, 5, 5) --凿击
GridStatusRaidDebuff:DebuffId(zoneid, 143275, 184, 2, 2, true, true) --挥砍
GridStatusRaidDebuff:DebuffId(zoneid, 143768, 185, 2, 2) --音波发射
-- GridStatusRaidDebuff:DebuffId(zoneid, 142532, 186, 6, 6) --毒素：蓝色
GridStatusRaidDebuff:DebuffId(zoneid, 142803, 187, 6, 6) --橙色催化爆炸之环
GridStatusRaidDebuff:DebuffId(zoneid, 143279, 188, 2, 2, true, true) --基因变异
GridStatusRaidDebuff:DebuffId(zoneid, 143339, 189, 6, 6, true, true) --注射
GridStatusRaidDebuff:DebuffId(zoneid, 142649, 190, 4, 4) --吞噬
GridStatusRaidDebuff:DebuffId(zoneid, 146556, 191, 6, 6) --穿刺
GridStatusRaidDebuff:DebuffId(zoneid, 142671, 192, 6, 6) --催眠术
GridStatusRaidDebuff:DebuffId(zoneid, 143979, 193, 2, 2, true, true) --恶意突袭
GridStatusRaidDebuff:DebuffId(zoneid, 143974, 199, 2, 2) --盾击(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 143570, 197, 6, 6, true, true) --热罐燃料准备（3S）
GridStatusRaidDebuff:DebuffId(zoneid, 142547, 175, 6, 6) --毒素：橙色
GridStatusRaidDebuff:DebuffId(zoneid, 143572, 176, 6, 6, true, true) --紫色催化热罐燃料
GridStatusRaidDebuff:DebuffId(zoneid, 142549, 171, 6, 6) --毒素：绿色
GridStatusRaidDebuff:DebuffId(zoneid, 142550, 194, 6, 6) --毒素：白色
GridStatusRaidDebuff:DebuffId(zoneid, 142948, 195, 5, 5) -- 瞄准
GridStatusRaidDebuff:DebuffId(zoneid, 148589, 196, 6, 6) -- 变异缺陷
GridStatusRaidDebuff:DebuffId(zoneid, 142945, 198, 5, 5, true, true) --绿色催化诡异之雾
GridStatusRaidDebuff:DebuffId(zoneid, 143358, 200, 5, 5) -- 饥饿
GridStatusRaidDebuff:DebuffId(zoneid, 142315, 201, 5, 5, true, true) --酸性血液

-- GridStatusRaidDebuff:DebuffId(zoneid, 143615, 198, 5, 5, true, true) --红色炸弹
-- GridStatusRaidDebuff:DebuffId(zoneid, 143609, 175, 5, 5, true, true) --黄色长剑
-- GridStatusRaidDebuff:DebuffId(zoneid, 143610, 176, 5, 5, true, true) --红色战鼓
-- GridStatusRaidDebuff:DebuffId(zoneid, 143617, 171, 5, 5, true, true) --蓝色炸弹
-- GridStatusRaidDebuff:DebuffId(zoneid, 143607, 194, 5, 5, true, true) --蓝色长剑
-- GridStatusRaidDebuff:DebuffId(zoneid, 143614, 195, 5, 5, true, true) --黄色战鼓
-- GridStatusRaidDebuff:DebuffId(zoneid, 143612, 196, 5, 5, true, true) --蓝色战鼓
-- GridStatusRaidDebuff:DebuffId(zoneid, 143619, 178, 5, 5, true, true) --黄色炸弹

-- 加尔鲁什·地狱咆哮
GridStatusRaidDebuff:BossNameId(zoneid, 210, "Garrosh Hellscream")
GridStatusRaidDebuff:DebuffId(zoneid, 144582, 211, 4, 4, true, false) --断筋
GridStatusRaidDebuff:DebuffId(zoneid, 145183, 212, 2, 2, true, true) --绝望之握(坦克)
GridStatusRaidDebuff:DebuffId(zoneid, 144762, 213, 4, 4) --亵渎
GridStatusRaidDebuff:DebuffId(zoneid, 145071, 214, 5, 5) --亚煞极之触
GridStatusRaidDebuff:DebuffId(zoneid, 148718, 215, 4, 4) --火坑
GridStatusRaidDebuff:DebuffId(zoneid, 148983, 216, 4, 4) --勇气永春台
GridStatusRaidDebuff:DebuffId(zoneid, 147235, 217, 6, 6, true, true) -- 恶毒冲击
GridStatusRaidDebuff:DebuffId(zoneid, 148994, 218, 4, 4) -- 信念青龙寺
GridStatusRaidDebuff:DebuffId(zoneid, 149004, 218, 4, 4) -- 希望朱鹤寺
GridStatusRaidDebuff:DebuffId(zoneid, 147324, 219, 5, 5) -- 毁灭之惧
GridStatusRaidDebuff:DebuffId(zoneid, 145171, 220, 5, 5) -- 强化亚煞极之触（H）
GridStatusRaidDebuff:DebuffId(zoneid, 145175, 221, 5, 5) -- 强化亚煞极之触（N）
--GridStatusRaidDebuff:DebuffId(zoneid, 144954, 216, 4, 4) --亚煞极之境，个人认为无需显示
