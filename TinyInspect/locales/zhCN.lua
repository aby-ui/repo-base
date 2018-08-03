
local _, ns = ...

if (GetLocale() ~= "zhCN") then return end

ns.L = {
    ShowItemBorder              = "物品直角边框",
    EnableItemLevel             = "物品等级显示",
    ShowColoredItemLevelString  = "装等文字随物品品质",
    ShowItemSlotString          = "显示物品部位文字",
    ShowInspectAngularBorder    = "观察面板直角边框",
    ShowInspectColoredLabel     = "观察面板高亮橙装武器标签",
    ShowCharacterItemSheet      = "显示玩家自己装备列表",
    ShowOwnFrameWhenInspecting  = "观察同时显示自己装备列表",
    ShowItemStats               = "显示装备属性统计",
    DisplayPercentageStats      = "装备属性换算成百分比数值",
    EnablePartyItemLevel        = "开启小队队友装等",
    SendPartyItemLevelToSelf    = "发送队友装等到自己面板",
    SendPartyItemLevelToParty   = "发送队友装等到队伍频道",
    ShowPartySpecialization     = "显示队友天赋文字",
    EnableRaidItemLevel         = "开启团队装等",
    EnableMouseItemLevel        = "开启鼠标装等",
    EnableMouseSpecialization   = "显示鼠标天赋",
    EnableMouseWeaponLevel      = "显示武器等级",
    ShowPluginGreenState        = "显示绿字属性前缀 |cffcccc33(重载生效)|r",
    Bag                         = "背包",
    Bank                        = "银行",
    Merchant                    = "商人",
    Trade                       = "交易",
    Auction                     = "拍卖行",
    AltEquipment                = "ALT换装",
    GuildBank                   = "公会银行",
    GuildNews                   = "公会新闻",
    PaperDoll                   = "人物面板",
    Chat                        = "聊天",
    Loot                        = "拾取",
}

BINDING_NAME_InspectRaidFrame = "显示团队观察面板"
