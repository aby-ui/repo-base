
BuildEnv(...)

ADDON_TITLE = '集合石插件'

local L = LibStub('AceLocale-3.0'):NewLocale('MeetingStone', 'zhCN', true, true)
if not L then return end

L.CreateHelpRefresh = '点击刷新下方的申请列表'
L.CreateHelpList = '在此列出所有申请信息，团长或团队助理可以进行邀请等操作'
L.CreateHelpOptions = '创建活动时必选项，设置活动所属的类别、形式和拾取方式'
L.CreateHelpSummary = '创建活动时选填项，设置活动的最低装等、语音聊天、角色等级、PVP 等级和活动说明'
L.CreateHelpButtons = '团长可在此进行创建、更新或解散活动等操作'
L.ViewboardHelpOptions = '团员可以在此看到活动的类别、形式和拾取方式等信息'
L.ViewboardHelpSummary = '团员可以在此看到活动的队伍配置和队伍需求等信息'

L.RewardSummary = [[
<html>
<body>
<p>1.本平台供您兑换暴雪游戏虚拟物品。</p>
<p>2.虚拟物品奖励一经兑换即不可退换。</p>
<p>3.兑换角色默认为您当前服务器和角色（即您当前使用兑换的角色）。</p>
<p>4.兑换后，会以邮件的形式通知您。如果没有马上收到，还请耐心等待。</p>
<p>5.如果您在24小时之内没收到相应的物品，请您联系客服。</p>
</body>
</html>
]]

L.MallSummary = [[
<html>
<body>
<p>　　兑换成功系统会在1个工作日内将虚拟物品发送到您当前角色的游戏邮箱内，请注意查收。如果出现积分扣除，但未收到物品，可以|Hurl:http://bnet.163.com/dj/exchange/query/wow|h|cff00ffff[点击这里]|r|h查询兑换码后，手动进行兑换。</p>
<p>　　查看详细积分变更信息及兑换记录请|Hurl:http://reward.battlenet.com.cn|h|cff00ffff[访问这里]|r|h</p>
<p>|cff00ffff*每月限量物品，当月库存兑完后将再下个月的1号更新，敬请留意。|r</p>
</body>
</html>
]]

L.MallPurchaseSummary = [[
<html>
<body>
<h3>购买中，请稍候 ...</h3>
<br/>
<p>您购买的物品为：|cff00ff00%s|r</p>
<p>所需积分：|cff00ff00%d|r</p>
<br />
<h2>购买成功后会通过游戏内邮件发送给您当前的角色，请您留意。</h2>
<p>如果您在24小时之内没有收到相应的物品，请您联系客服。</p>
</body>
</html>
]]

L.RewardPurchaseSummary = [[
<html>
<body>
<h3>兑换中，请稍候 ...</h3>
<br/>
<h2>兑换成功后会通过游戏内邮件发送给您当前的角色，请您留意。</h2>
<p>如果您在24小时之内没有收到相应的物品，请您联系客服。</p>
</body>
</html>
]]

L.HowToGetPoints = [[
当您购买任意战网产品（包括游戏时间、战网点数、虚拟宠物坐骑、角色增值服务）时使用|cffffd100战网在线支付（网易宝）|r功能进行付款，即可按照1:1比例获得积分！

|cff00ffff详情请复制以下网址查看：
]]

L.GoodsLoadingSummary = [[
<html>
<body>
<h3>商品数据读取中，请稍候 ...</h3>
<br/>
<p>如果您刚上线，将在十五分钟内读取到商品数据。</p>
<br/>
<p>如果长时间无法收到商品数据，请检查插件版本或者联系集合石官方QQ群|Hurl:317548615|h|cff00ffff[317548615]|r|h。</p>
</body>
</html>
]]

L.BrowseHelpFilter = [[
活动类型：下拉菜单选择你需要参与活动的类型

活动形式：下拉菜单选择你需要参与的活动形式

拾取方式：下拉菜单选择你需要参与活动的拾取方式
]]

L.BrowseHelpRefresh = [[
刷新按钮：刷新当前的活动信息

高级过滤：打开首领击杀状态过滤与过滤配置面板
]]

L.BrowseHelpList = [[
活动展示页：你可以在这里挑选你自己喜欢的活动。

鼠标悬停后会出现活动及队长的具体信息
]]

L.BrowseHelpMisc = [[
图示：活动当前的状态图示
]]

L.BrowseHelpApply = [[
申请加入：选择你要加入的活动，点击该按钮申请加入
]]

L.BrowseHelpStatus = [[
当前活动的总数以及你申请的活动总数
]]

L.BrowseHelpSpamWord = [[
启用活动说明关键字过滤功能，关键字列表可以在设置界面修改
]]

L.BrowseHelpBossFilter = [[
首领过滤：Boss击杀状态过滤器
]]

L.BrowseHelpSearchProfile = [[
过滤配置：保存当前搜索条件，下次快速搜索
]]

L.NotSupportVersionWithChangeLog = [[
|cffff1919发现集合石新版本，你当前的版本不兼容。|r

更新日志：%s

请按<|cff00ff00Ctrl+C|r>复制下载链接更新新版本以继续使用
]]

L.NotSupportVersion = [[
|cffff1919发现集合石新版本，你当前的版本不兼容。|r

请按<|cff00ff00Ctrl+C|r>复制下载链接更新新版本以继续使用
]]

L.FoundRaidBuilder = [[
发现你正在使用老版本集合石插件，

请尽快删除 |cff00ffffInterface\AddOns\RaidBuilder|r 文件夹，

点击“确定”|cffff0000重载插件|r以禁用老版本集合石。
]]

L.NewVersionWithChangeLog = [[
发现新版本：%s，请及时下载更新
下载链接：%s
更新内容：%s
更多更新内容请浏览论坛
]]

L.NewVersion = [[
发现新版本：%s，请及时下载更新
下载链接：%s
]]

L.ActivitiesBuyingSummary = [[
<html>
<body>
<h3>购买中，请稍候 ...</h3>
<br/>
<p>您购买的物品为：|cff00ff00%s|r</p>
<p>所需点数：|cff00ff00%d|r</p>
</body>
</html>
]]

L.ActivitiesMallSummary = [[
<html>
<body>
<p>　　每日奖品数量将自动刷新。消耗相应积分即可抢购指定奖品，先到先得，抢完为止！奖品会在活动结束后统一发放。战网点数奖励将自动充入您所填写的战网账号。详情：{URL}</p>
<p>　　|cffff1919特别提醒：|r工作人员不会向您索要密码等安全信息, 获奖玩家也无需再缴纳任何费用。</p>
</body>
</html>
]]

L.ActivitiesLotterySummary = [[
<html>
<body>
<p>　　消耗积分即可参与一次抽奖。奖品会在活动结束后统一发放。战网点数奖励将自动充入您所填写的战网账号。详情：{URL}</p>
<p>　　|cffff1919特别提醒：|r工作人员不会向您索要密码等安全信息, 获奖玩家也无需再缴纳任何费用。</p>
</body>
</html>
]]

L.ActivitiesMallWarning = [[
|cffff1919请注意：|r

    抢购成功后，请认真填写收货人信息。我们的工作人员会在活动结束后通过您填写的电话与您取得联系。届时，客服人员将与您核对确认奖品的邮寄地址。

    如截止至活动结束，我们仍无法通过您所提供的联系方式与您取得联系并确认奖品的邮寄地址，则视为您已放弃领奖资格，该奖品将被收回。
]]

L.ActivitiesLotteryWaring = [[
|cffff1919请注意：|r

    中奖后，请认真填写收货人信息。我们的工作人员会在活动结束后通过您填写的电话与您取得联系。届时，客服人员将与您核对确认奖品的邮寄地址。

    如截止至活动结束，我们仍无法通过您所提供的联系方式与您取得联系并确认奖品的邮寄地址，则视为您已放弃领奖资格，该奖品将被收回。
]]

L.MallOtherGameTip = [[你需要前往战网积分网站上进行兑换。]]
