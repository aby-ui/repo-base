if GetLocale() ~= "zhTW" then return end
GridBuffIconsLocale = {
    ["Buff Icons"] = "增益減益圖示",

    ["Show Buff instead of Debuff"] = "顯示增益狀態",
    ["If selected, the icons will present unit buffs instead of debuffs."] = "默認顯示減益,選中此項則顯示增益",
    ["Only Mine"] = "僅限我施放的",

    ["Only castable/removable"] = "僅顯示可施放增益",
    ["If selected, only shows the buffs you can cast or the debuffs you can remove."] = "勾選此項則顯示Debuff時僅顯示你可以驅散的, 顯示Buff時僅顯示你可以施加的",

    ["Buffs/Debuffs Never Shown"] = "始終隱藏的狀態",
    ["Buff or Debuff names never to show, seperated by ','"] = "輸入要隱藏的增益或減益名稱, 用','分隔多個, 例如'精疲力竭,英勇風采'",
    ["Buffs/Debuffs Always Shown"] = "始終顯示的狀態",
    ["Buff or Debuff names which will always be shown if applied, seperated by ','"] = "輸入強制顯示的增益或減益名稱, 無論當前是顯示增益還是減益",


    ["Icons Size"] = "圖示大小",
    ["Size for each buff icon"] = "每個圖示的大小",

    ["Offset X"] = "X軸偏移",
    ["X-axis offset from the selected anchor point, minus value to move inside."] = "第一個圖示的偏移量, 負數表示向內移動, 正數表示向外",

    ["Offset Y"] = "Y軸偏移",
    ["Y-axis offset from the selected anchor point, minus value to move inside."] = "第一個圖示的偏移量, 負數表示向內移動, 正數表示向外",

    ["Alpha"] = "圖示透明度",
    ["Alpha value for each buff icon"] = "每個圖示的透明度",

    ["Icon Numbers"] = "圖示個數",
    ["Max icons to show."] = "最多顯示的buff/debuff個數",
    ["Icons Per Row"] = "一列的圖示數",
    ["Sperate icons in several rows."] = "通過限制一列的圖示數, 可以將圖示分為若干列",

    ["Orientation of Icon"] = "圖示排列方向",
    ["Set icons list orientation."] = "選擇圖示是水準排列還是垂直排列",

    ["VERTICAL"] = "垂直",
    ["HORIZONTAL"] = "水準",

    ["Anchor Point"] = "圖示位置",
    ["Anchor point of the first icon."] = "第一個圖示相對Grid框架的位置",
    ["TOPRIGHT"] = "右上角",
    ["TOPLEFT"] = "左上角",
    ["BOTTOMLEFT"] = "左下角",
    ["BOTTOMRIGHT"] = "右下角",

    ["Show cooldown on icon"] = "顯示圖示冷卻效果",
    ["Show Cooldown text"] = "顯示冷卻計時文字",
    ["If disabled, OmniCC will not add texts on the icons."] = "顯示計時文字需要OmniCC支援. 如果禁用此項, OmniCC就不會給圖示添加倒計時文字.",
}
