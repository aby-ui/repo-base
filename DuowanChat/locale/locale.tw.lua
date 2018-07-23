local L = LibStub("AceLocale-3.0"):NewLocale("DuowanChat", "zhTW")
if not L then return end

L["DWChatTitle"]="魔盒聊天"
L["DWChat"]="魔盒聊天"
L["ChatFrame"]="聊天快捷欄"
L["IconFrame"]="聊天表情欄"
L["DWChat provides you convient tools like copy text, name highlight and timestamps"]="魔盒聊天增強為妳提供復制聊天文字，高亮姓名以及聊天時間顯示等各種功能。"
L["Enable DWChat"]="使用魔盒聊天增強"
L["Timestamp setting"]="聊天時間設置"
L["Enable timestamp"]="顯示聊天時間"
L["Enable second"]="顯示具體秒數"
L["Class setting"]="職業設置"
L["Enable Class Color"]="顯示職業顏色"
L["Enable Level"]="顯示級別"
L["Enable Group"]="團隊時顯示發言人的小隊"

L["Channel setting"]="頻道設置"
L["Use short channel names"]="使用短頻道名"
L["Enable copy text"]="復制聊天文字"
L["Use short channel names"]="使用短頻道名"
L["Enable emotion icons"]="使用聊天圖標"
L["Enable channel buttons"]="使用快捷頻道切換"
L["Enable channel buttons move"]="移動快捷頻道欄"
L["Fast chat channel provides you easy access to different channels"] = "提供快速切換至不同聊天頻道的按鈕，並可以自定義快捷鍵"
L["this function allows you to use emtion icons in your chat, and others who has this addon enabled can see your emtion icons"]="為使用者提供可在聊天中使用的表情圖標，並且其他有此插件的人可以看到這些圖標"
L["Press Ctrl-C to Copy the text"]="使用Ctrl+C來復制文字"
L["Chat Channel"] = "聊天通道"

--class names
L.Mage ="法師"
L.Druid ="德魯伊"
L.Hunter="獵人"
L.Paladin ="聖騎士"
L.Priest ="牧師"
L.Rogue ="潛行者"
L.Shaman ="薩滿祭司"
L.Warlock ="術士"
L.Warrior ="戰士"
L.DeathKnight="死亡騎士"

--channels
L["Guild"]="公會"
L["Raid"]="團隊"
L["Party"]="小隊"
L["General"]="綜合"
L["Trade"]="交易"
L["WorldDefense"]="世界防務"
L["LocalDefense"]="本地防務"
L["BattleGround"]="戰場"
L["Yell"]="喊道"
L["Say"]="說"
L["WhisperTo"]="發送給"
L["WhisperFrom"]="悄悄地說"
L["LFG"] = "尋求組隊"
L["GuildRecruit"]="公會招募"

L["GuildShort"]="會"
L["RaidShort"]="團"
L["PartyShort"]="隊"
L["YellShort"]="喊"
L["BattleGroundShort"]="戰"
L["OfficerShort"]="官"
L["WhisperToShort"]="密"
L["WhisperFromShort"]="密"
L["ShortLFG"] = "組"
L["GuildRecruit"]="招"
L["DWLFG"] = "轉"
L["GeneralShort"]="綜"
L["TradeShort"]="交"
L["LocalDefenseShort"]="本"
L["WorldDefenseShort"]="世"
L["InstanceShort"] = "副"

-- Capital Cities
L["Shattrath City"] = "撒塔斯城"
L["Exodar"] = "艾克索達"
L["Silvermoon City"] = "銀月城"
L["Dalaran"] = "達拉然"
L["Orgrimmar"] = "奧格瑪"
L["Stormwind City"] = "暴風城"
L["Ironforge"] = "鐵爐堡"
L["Darnassus"] = "達納蘇斯"
L["Undercity"] = "幽暗城"
L["Thunder Bluff"] = "雷霆崖"

-- 屬性
L["HEAD"] = "";
L["HP"] = "生命";
L["MP"] = "魔法";
L["LV"] = "等級";
L["CLASS"] = "職業";
L["MTALENT"] = "天賦:";
L["STALENT"] = "備用:";
L["STR"] = "力量";
L["AGI"] = "敏捷";
L["STA"] = "耐力";
L["INT"] = "智力";
L["SPI"] = "精神";
L["AP"] = "強度";
L["HIT"] = "命中";
L["CRIT"] = "爆擊";
L["EXPER"] = "精准";
L["SSP"] = "法傷";
L["SHP"] = "治療";
L["HASTE"] = "急速";
L["SMR"] = "5秒回藍";
L["ARMOR"] = "護甲";
L["DEF"] = "防禦";
L["DODGE"] = "躲閃";
L["PARRY"] = "招架";
L["BLOCK"] = "格擋";
L["CRDEF"] = "韌性";
L["NONE"] = "無";
L["ILV"] = "實裝";
L["MRPEN"] = "護甲穿透";
L["SPEN"] = "法術穿透";

--- emo icons
L.Angel="天使"
L.Angry="生氣"
L.Biglaugh="大笑"
L.Clap="鼓掌"
L.Cool="酷"
L.Cry="哭"
L.Cute="可愛"
L.Despise="鄙視"
L.Dreamsmile="美夢"
L.Embarras="尷尬"
L.Evil="邪惡"
L.Excited="興奮"
L.Faint="暈"
L.Fight="打架"
L.Flu="流感"
L.Freeze="呆"
L.Frown="皺眉"
L.Greet="致敬"
L.Grimace="鬼臉"
L.Growl="齜牙"
L.Happy="開心"
L.Heart="心"
L.Horror="恐懼"
L.Ill="生病"
L.Innocent="無辜"
L.Kongfu="功夫"
L.Love="花癡"
L.Mail="郵件"
L.Makeup="化妝"
L.Mario="馬裏奧"
L.Meditate="沉思"
L.Miserable="可憐"
L.Okay="好"
L.Pretty="漂亮"
L.Puke="吐"
L.Shake="握手"
L.Shout="喊"
L.Silent="閉嘴"
L.Shy="害羞"
L.Sleep="睡覺"
L.Smile="微笑"
L.Suprise="吃驚"
L.Surrender="失敗"
L.Sweat="流汗"
L.Tear="流淚"
L.Tears="悲劇"
L.Think="想"
L.Titter="偷笑"
L.Ugly="猥瑣"
L.Victory="勝利"
L.Volunteer="雷鋒"
L.Wronged="委屈"


if GetLocale()=="zhTW" then
	BINDING_HEADER_DWCTITLE="魔盒聊天增強"
	BINDING_NAME_DWCSAY="說話"
	BINDING_NAME_DWCPARTYCHANNEL="小隊頻道發言"
	BINDING_NAME_DWCRAIDCHANNEL="團隊頻道發言"
	BINDING_NAME_DWCBGCHANNEL="戰場頻道發言"
	BINDING_NAME_DWCGUILDCHANNEL="公會頻道發言"
	BINDING_NAME_DWCYELL="大喊"
	BINDING_NAME_DWCWHISPER="密聊"
	BINDING_NAME_DWCOFFICER="官員頻道發言"
end

