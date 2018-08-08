local _, addon = ...
addon.L = addon.L or NewLocale();
local L = addon.L;

L["BtnRescanText"] = "重新获取";
L["BtnRescanTipTitle"] = "重新获取天赋和GS";
L["BtnRescanTip"] = "为了减少资源占用,插件并不会实时更新成员信息，请选中要更新的成员后点击此按钮";

L["BtnLinkText"] = "网页查询";
L["BtnLinkTipTitle"] = "外部网站链接";
L["BtnLinkTip"] = "插件受游戏功能限制只能获取可见范围内玩家的成就，天赋和GS更是要求在能观察的距离之内，但配套的外部网站可以不受此限制。";

L["BtnAnnText"] = "信息广播";
L["BtnAnnTipTitle"] = "信息广播";
L["BtnAnnTip"] = "将选中团员的信息发布到团队频道, 请谨慎选择, 防止刷屏和纠纷。";
L["BtnAnnPopupText"] = "确定广播|cffff7f00[%d]|r条信息到|cffff7f00[%s]|r频道吗?";
L["BtnAnnNoSelect"] = "请至少选择一个团员";

L["CopyDialogTitleText"] = "请按Ctrl+C复制到浏览器中打开";

L["TitleText"] = "爱不易团员信息统计";
L["HeaderClass"] = CLASS;
L["HeaderPlayerName"] = "成员名称";
L["HeaderGS"] = "装等";
L["HeaderHealth"] = "血量";

L["StatusGetting"] = "正在获取资料";
L["StatusCannotGet"] = "有玩家距离过远,无法获得";
L["StatusAllDone"] = "全部资料获取完毕";
L["StatusPaused"] = "战斗中暂停获取";

L["HUNTER"]="猎人";
L["WARLOCK"]="术士";
L["PRIEST"]="牧师";
L["PALADIN"]="圣骑";
L["MAGE"]="法师";
L["ROGUE"]="盗贼";
L["DRUID"]="德鲁伊";
L["SHAMAN"]="萨满";
L["WARRIOR"]="战士";
L["DEATHKNIGHT"]="死骑";

L["MiniTipTitle"] = "TeamStats - 团队信息统计";
L["MiniTip"] = "打开团队信息统计界面, 集中查看所有团员的天赋、装备GS和副本击杀经验. 图标闪烁表示有新获取的数据";

if L["zhTW"] then
end