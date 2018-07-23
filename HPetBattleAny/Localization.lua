local addonname,addon = ...
local bcolor = "|cff00ffff%s|r";
if GetLocale() == "zhCN" then
	addon.L = {
			----------Options
			["HPet Options"]				= "HPet 设置",
			["Pet All Info"]				= "宠物信息",
			["Config"]						= "设置",
			["GrowInfo"]					= "成长值",
			["Loading"]						= "已开启，输入%s进入设置界面",
			["Battle Stone"]				= "升级石",
			["AbilityIcon"]					= "技能图标",

			["Message"]						= "文字提示",	--ShowMsg
			["MessageTooltip"]				= "进入对战后，聊天窗口列出敌对宠物信息以及收集情况",

			["Sound"]						= "声音提示",		--Sound
			["SoundTooltip"]				= "蓝色/蓝色以上可捕捉宠物发出声音提示。",

			["OnlyInPetInfo"]				= "文字提示位置",
			["OnlyInPetInfoTooltip"]		= "勾选后，文字提示将只跟随宠物对战信息",

			["HighGlow"]					= "宠物头像着色",
			["HighGlowTooltip"]				= "战斗中用品质颜色对宠物头像着色",

			["ShowBandageButton"]			= "绷带按钮",
			["ShowBandageButtonTooltip"]	= "在宠物界面显示一个宠物绷带的按钮",

			["EnemyAbility"]				= "敌对技能图标",
			["EnemyAbilityTooltip"]			= "宠物对战中显示敌对技能(技能CD),该图标可以移动。",

			["OtherAbility"]				= "后排技能",
			["OtherAbilityTooltip"]			= "显示后排未出场宠物的技能(敌方及己方)",

			["ShowAbilitysName"]			= "宠物名字",
			["ShowAbilitysNameTooltip"]		= "在技能上方显示宠物的名字",

			["AllyAbility"] 				= "己方技能图标",
			["AllyAbilityTooltip"] 			= "显示己方宠物技能",

			["LockAbilitys"]				= "锁定技能图标",
			["LockAbilitysTooltip"]			= "解锁或者移动技能图标(左键拖拽/中键还原)",

			["AbilitysScale"]				= "技能图标缩放", --EnemyAbScale
			["AbilitysScaleTooltip"]		= "缩放技能图标敌对技能",

			["PetGrowInfo"]					= "显示成长值",	--ShowGrowInfo
			["PetGrowInfoTooltip"]			= "显示成长值",

			["PetGreedInfo"]				= "显示新成长值",
			["PetGreedInfoTooltip"]			= "新成长值需要x基数得到准确成长值|n品质基数:劣质x1.0 普通1.1 优秀1.2 精良1.3 |n跨越品质比较(用于5.1的战斗石)",

			["PetBreedInfo"]				= "显示Breed",
			["PetBreedInfoTooltip"]			= "显示Breed具体加值",

			["ShowBreedID"]					= "显示BreedID",
			["ShowBreedIDTooltip"]			= "在宠物日志的宠物类别旁边显示BreedID",

			["BreedIDStyle"]				= "更换BreedID的样式",
			["BreedIDStyleTooltip"]			= "将显示的BreedID样式在数字/BHPS之间切换",

			["FastForfeit"]					= "快速放弃",
			["FastForfeitTooltip"]			= format(bcolor,"勾选后，放弃键将直接放弃战斗，无需确认"),

			["OtherTooltip"]				= "额外鼠标提示",
			["OtherTooltipTooltip"]			= "鼠标提示中加入宠物信息(收集/来源)",

			["AutoSaveAbility"]				= "保存技能",
			["AutoSaveAbilityTooltip"]		= "自动保存每个宠物的技能(无法跨账号保存,[/hpq cc]清除保存)|n通过点击宠物卡片上的技能，也能达到切换的效果",
			["AutoSaveAbilityConfig"]		= "已清除所有宠物技能保存记录",

			["AutoShowHide"]				= "其他Ui显示/隐藏",
			["AutoShowHideTooltip"]			= "自动显示和隐藏其他UI，例如小地图，recount.",

			["ShowHideID"]					= "显示ID",
			["ShowHideIDTooltip"]			= "显示宠物以及技能ID,技能名后面以及宠物类别前面的数字",

			["bottom title"]				= "作者：上官晓雾|nID:上官晓雾#5190/zhCN",

			["lock enemy info"]				= "观察敌方宠物当前等级品质下的详细信息",
			["lock rarity"]					= "锁定品质",
			["Grow Point"]					= "成长值:",
			["Greed Point"]					= "品值:",
			["Breed Point"]					= "Breed:",
			["Breed"]						= "品种",
			["Switch"]						= "切换",
			["Base Points"]					= "基础值",

			----------other
			["Only collected"]				= "只收集了",
			["this is"]						= "第%s只",
--- 			["Loading info"]				= "寵物辨別開啟,輸入%s用以設置信息提示",
			["Search Help"]					= "搜索帮助",
			["searchhelp1"]					= "[/hpq s xxx]xxx为宠物任意来源信息",
			["searchhelp2"]					= "[/hpq ss XXX]xxx宠物任意技能信息(可以是技能内的文本)",
			["search key"]					= "搜索关键字为:",
			["search remove key"]			= "排除关键字为:",
		}
elseif GetLocale() == "zhTW" then
		addon.L = {
		----------Options
		["HPet Options"] = "HPet 設置",
		["Pet All Info"] = "寵物信息",
		["Config"] = "設置",
		["GrowInfo"] = "成長值",
		["Loading"] = "已開啟，輸入%s進入設置界面",
		["Battle Stone"] = "升級石",
		["AbilityIcon"] = "技能圖標",

		["Message"] = "文字提示", --ShowMsg
		["MessageTooltip"] = "進入對戰後，聊天窗口列出敵對寵物信息以及收集情況",

		["Sound"] = "聲音提示", --Sound
		["SoundTooltip"] = "藍色/藍色以上可捕捉寵物發出聲音提示。",

		["OnlyInPetInfo"] = "文字提示位置",
		["OnlyInPetInfoTooltip"] = "勾選後，文字提示將只跟隨寵物對戰信息",

		["HighGlow"] = "寵物頭像著色",
		["HighGlowTooltip"] = "戰鬥中用品質顏色對寵物頭像著色",

		["ShowBandageButton"] = "繃帶按鈕",
		["ShowBandageButtonTooltip"] = "在寵物界面顯示一個寵物繃帶的按鈕",

		["EnemyAbility"] = "敵對技能圖標",
		["EnemyAbilityTooltip"] = "寵物對戰中顯示敵對技能(技能CD),該圖標可以移動。",

		["OtherAbility"] = "後排技能",
		["OtherAbilityTooltip"] = "顯示後排未出場寵物的技能(敵方及己方)",

		["ShowAbilitysName"] = "寵物名字",
		["ShowAbilitysNameTooltip"] = "在技能上方顯示寵物的名字",

		["AllyAbility"] = "己方技能圖標",
		["AllyAbilityTooltip"] = "顯示己方寵物技能",

		["LockAbilitys"] = "鎖定技能圖標",
		["LockAbilitysTooltip"] = "解鎖或者移動技能圖標",

		["AbilitysScale"] = "技能圖標縮放", --EnemyAbScale
		["AbilitysScaleTooltip"] = "縮放技能圖標敵對技能",

		["PetGrowInfo"] = "顯示成長值", --ShowGrowInfo
		["PetGrowInfoTooltip"] = "顯示成長值",

		["PetGreedInfo"] = "顯示新成長值",
		["PetGreedInfoTooltip"] = "新成長值需要x基數得到準確成長值|n品質基數:劣質x1.0 普通1.1 優秀1.2 精良1.3 |n跨越品質比較(用於5.1的戰鬥石)",

		["PetBreedInfo"] = "顯示Breed",
		["PetBreedInfoTooltip"] = "顯示Breed具體加值",

		["ShowBreedID"] = "顯示BreedID",
		["ShowBreedIDTooltip"] = "在寵物日誌的寵物類別旁邊顯示BreedID",

		["BreedIDStyle"] = "更換BreedID的樣式",
		["BreedIDStyleTooltip"] = "將顯示的BreedID樣式在數字/BHPS之間切換",

		["FastForfeit"] = "快速放棄",
		["FastForfeitTooltip"] = format(bcolor,"勾選後，放棄鍵將直接放棄戰鬥，無需確認"),

		["OtherTooltip"] = "額外鼠標提示",
		["OtherTooltipTooltip"] = "鼠標提示中加入寵物信息(收集/來源)",

		["AutoSaveAbility"] = "保存技能",
		["AutoSaveAbilityTooltip"] = "自動保存每個寵物的技能(無法跨賬號保存,[/hpq cc]清除保存)|n通過點擊寵物卡片上的技能，也能達到切換的效果",
		["AutoSaveAbilityConfig"] = "已清除所有寵物技能保存記錄",

		["AutoShowHide"] = "其他Ui顯示/隱藏",
		["AutoShowHideTooltip"] = "自動顯示和隱藏其他UI，例如小地圖，recount.",

		["ShowHideID"] = "顯示ID",
		["ShowHideIDTooltip"] = "顯示寵物以及技能ID,技能名後面以及寵物類別前面的數字",

		["bottom title"] = "作者：上官曉霧|nID:上官曉霧#5190/zhCN",

		["lock enemy info"] = "觀察敵方寵物當前等級品質下的詳細信息",
		["lock rarity"] = "鎖定品質",
		["Grow Point"] = "成長值:",
		["Greed Point"] = "品值:",
		["Breed Point"] = "Breed:",
		["Breed"] = "品種",
		["Switch"] = "切換",
		["Base Points"] = "基礎值",

		----------other
		["Only collected"] = "只收集了",
		["this is"] = "第%s只",
		["Search Help"] = "搜索幫助",
		["searchhelp1"] = "[/hpq s xxx]xxx為寵物任意來源信息",
		["searchhelp2"] = "[/hpq ss XXX]xxx寵物任意技能信息(可以是技能內的文本)",
		["search key"] = "搜索關鍵字為:",
		["search remove key"] = "排除關鍵字為:",
		}
else
	addon.L = {
		---------- Options
		["HPet Options"] 					= "HPet Options",
		["Pet All Info"]					= "Pet All Info",
		["Config"]							= "Config",
		["GrowInfo"]						= "Grow",
		["Loading"]							= " is Loaded，type %s to configure",
		["Battle Stone"]					= "Battle Stone",
		["AbilityIcon"]						= "Ability Icon",

		["Message"] 						= "Text prompt",
		["MessageTooltip"] 					= "Enter the PetBattle, the chat window lists hostile pet information and the collection of",

		["Sound"] 							= "Sound",
		["SoundTooltip"] 					= "Rare pet may capture of Sound Alarm.",

		["OnlyInPetInfo"]					= "Text position",

		["HighGlow"]						= "Color pet unit",
		["HighGlowTooltip"]					= "Color pet unit in Pet Battle",

		["ShowBandageButton"]				= "Bandage Button",
		["ShowBandageButtonTooltip"]		= "PetJournal display in a Bandage Button",

		["EnemyAbility"] 					= "Enemy skill",
		["EnemyAbilityTooltip"] 			= "In PetBattle,display skills(skills CD) of emeny,Drag the icons can be moved.",

		["OtherAbility"]					= "Other Skill",
		["OtherAbilityTooltip"]				= "Display back row skills",

		["ShowAbilitysName"]				= "Pet Name",
		["ShowAbilitysNameTooltip"]			= "Display Pet Name by Skill Icon",

		["AllyAbility"] 					= "Ally skill",
		["AllyAbilityTooltip"] 				= "Display Ally skill",

		["LockAbilitys"] 					= "lock enemy/ally skill",
		["LockAbilitysTooltip"] 			= "unlock or move enemy/ally skill icons",

		["AbilitysScale"] 					= "Enemy/ally skill icon scaling",
		["AbilitysScaleTooltip"] 			= "Zoom enemy/ally skill icons",

		["PetGrowInfo"] 					= "Growth value",
		["PetGrowInfoTooltip"] 				= "display growth value",

		["PetGreedInfo"] 					= "Greed value",

		["PetBreedInfo"]					= "Breed value",

		["ShowBreedID"]						= "BreedID",

		["BreedIDStyle"]					= "Change BreedID's style",

		["FastForfeit"]						= "Fast Forfeit",
		["FastForfeitTooltip"]				= format(bcolor,"Down Forfeit's button without confirm"),

		["OtherTooltip"]					= "OtherTooltip",
		["OtherTooltipTooltip"]				= "Add something to GameTooltip(Collected/sourceText[/hpq cc]clear date)|nClick the PetCard's ability can achieve the effect of switching",

		["AutoSaveAbility"]					= "Auto Save Ability",
		["AutoSaveAbilityTooltip"]			= "Auto Save/Laod All Pet Ability",
		["AutoSaveAbilityConfig"]			= "Has been cleared of all pet skills",

		["AutoShowHide"]					= "Other UI Show/Hide",
		["AutoShowHideTooltip"] 			= "Auto display skills and hide the UI, such as a Minimap, recount.",

		["ShowHideID"]						= "Display ID",
		["ShowHideIDTooltip"]				= "Display ID of pet speciesID and abilityID",

		["bottom title"] 					= "作者：上官曉霧|nID:上官晓雾#5190/zhCN",

		["lock enemy info"]					= "Observe the current level of quality under enemy PetInfo",
		["lock rarity"]						= "Lock rarity",
		["Grow Point"]						= "Grow::",
		["Greed Point"]						= "Greed:",
		["Breed Point"]						= "Breed:",
		["Breed"]							= "Breed",
		["Switch"]							= "Switch",
		["Base Points"]						= "Base Points",

		---------- other
		["Only collected"] 					= "Collect only",
		["this is"]							= "The %s is ",
--~ 		["Loading info"] 					= "the pet identify open input% s to set the message alert",
		["Search Help"] 					= "Search Help",
		["searchhelp1"] 					= "[/ hpq s xxx] xxx as a the pet any source of information",
		["searchhelp2"] 					= "[/ hpq ss XXX] xxx pet any skills (can be skills within the text),",
		["search key"]						= "Search for the key word:",
		["search remove key"] 				= "Negative keyword:",
	}
end

setmetatable(addon.L,{__index=function(self,index) 
	if index:find("Tooltip") then
		return format(bcolor,index)
	else
		return index
	end
end})