--[[
	OmniCC configuration localization - Chinese Simplified
--]]

if GetLocale() ~= 'zhCN' then return end

local L = OMNICC_LOCALS

L.GeneralSettings = "显示"
L.FontSettings = "文字风格"
L.RuleSettings = "规则"
L.PositionSettings = "文字位置"

L.Font = "字体"
L.FontSize = "默认字体大小"
L.FontOutline = "字体轮廓"

L.Outline_NONE = NONE
L.Outline_OUTLINE = "细线"
L.Outline_THICKOUTLINE = "粗线"

L.MinDuration = "显示文字的最少时间"
L.MinSize = "显示文字的最小字号"
L.ScaleText = "使用自动缩放令文字保持在框架之内"
L.EnableText = "启用冷却文字"

L.Add = "新增"
L.Remove = "移除"

L.FinishEffect = "完成效果"
L.MinEffectDuration = "完成效果的最少时间"

L.MMSSDuration = "最少时间的文字以 MM:SS 格式来显示"
L.TenthsDuration = "以十分之一秒为单位显示"

L.ColorAndScale = "颜色 & 缩放"
L.Color_soon = "即将到期"
L.Color_seconds = "少于1分钟"
L.Color_minutes = "少于1小时"
L.Color_hours = "1小时或以上"

-- 文字定位
L.XOffset = "X 偏移"
L.YOffset = "Y 偏移"

L.Anchor = '锚点'
L.Anchor_LEFT = '左'
L.Anchor_CENTER = '中'
L.Anchor_RIGHT = '右'
L.Anchor_TOPLEFT = '左上'
L.Anchor_TOP = '上'
L.Anchor_TOPRIGHT = '右上'
L.Anchor_BOTTOMLEFT = '左下'
L.Anchor_BOTTOM = '下'
L.Anchor_BOTTOMRIGHT = '右下'

--分组
L.Groups = '分组'
L.Group_base = '默认'
L.Group_action = '动作'
L.Group_aura = '光环'
L.Group_pet = '宠物动作'
L.AddGroup = '新增分组...'

--[[ 提示 ]]--

L.ScaleTextTip =
[[当启用时，此设置 
会令文字缩小来适应
太小的框架]]

L.MinDurationTip =
[[确定多长的冷却时间才显示文字
此设置主要用于筛选出GCD]]

L.MinSizeTip =
[[确定多大的框架能显示文字。
该值越小，可以展示的东西越小。
该值越大，可以展示的东西越大。

一些基准:
100 - 动作按钮的大小
80  - 职业或宠物动作按钮的大小
55  - 暴雪目标增益框架的大小]]

L.MinEffectDurationTip =
[[确定需要多长的冷却
时间来显示一个完成的效果
（例如，脉冲/闪亮）]]

L.MMSSDurationTip =
[[确定用于显示冷却时间的阈值
 以 MM:SS 格式来显示]]

L.TenthsDurationTip =
[[确定用于显示冷却时间的阈值
以十分之一秒格式来显示]]

L.FontSizeTip =
[[控制文字的大小]]

L.FontOutlineTip =
[[控制文字周围的轮廓厚度]]

L.UseBlacklistTip =
[[点击切换使用黑名单。
当启用时，任何框架的名称
与黑名单上的项目相同时
将不会显示冷却时间。]]

L.FrameStackTip =
[[切换当鼠标悬停
在框架时显示的名称]]

L.XOffsetTip =
[[控制文字的水平偏移]]

L.YOffsetTip =
[[控制文字的垂直偏移]]