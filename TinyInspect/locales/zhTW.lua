
local _, ns = ...

BINDING_HEADER_TinyInspect = "TinyInspect"

if (GetLocale() ~= "zhTW") then return end

ns.L = {
    ShowItemBorder              = "物品直角邊框",
    EnableItemLevel             = "物品等級顯示",
    ShowColoredItemLevelString  = "裝等文字隨物品品質",
    ShowItemSlotString          = "顯示物品部位文字",
    ShowInspectAngularBorder    = "觀察面板直角邊框",
    ShowInspectColoredLabel     = "觀察面板高亮橙裝武器標簽",
    ShowCharacterItemSheet      = "顯示玩家自己裝備列表",
    ShowOwnFrameWhenInspecting  = "觀察同時顯示自己裝備列表",
    ShowItemStats               = "顯示裝備屬性統計",
    DisplayPercentageStats      = "裝備屬性換算成百分比數值",
    EnablePartyItemLevel        = "小隊隊友裝等",
    SendPartyItemLevelToSelf    = "發送隊友裝等到自己面板",
    SendPartyItemLevelToParty   = "發送隊友裝等到隊伍頻道",
    ShowPartySpecialization     = "顯示隊友天賦文字",
    EnableRaidItemLevel         = "團隊成員裝等",
    EnableMouseItemLevel        = "鼠標目標裝等",
    EnableMouseSpecialization   = "顯示鼠標天賦",
    EnableMouseWeaponLevel      = "顯示武器等級",
    ShowPluginGreenState        = "顯示綠字屬性前綴 |cffcccc33(重載生效)|r",
    Bag                         = "背包",
    Bank                        = "銀行",
    Merchant                    = "商人",
    Trade                       = "交易",
    Auction                     = "拍賣行",
    AltEquipment                = "ALT換裝",
    GuildBank                   = "公會銀行",
    GuildNews                   = "公會新聞",
    PaperDoll                   = "人物面板",
    Chat                        = "聊天",
    Loot                        = "拾取",
}

BINDING_NAME_InspectRaidFrame = "顯示團隊觀察面板"