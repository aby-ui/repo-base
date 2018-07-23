local _, AddonDB = ...

--<<IMPORTANT STUFF>>-------------------------------------------------------------------------------<<>>

	local Localizations = {}

--<<DEFAULT LOCALIZATION>>--------------------------------------------------------------------------<<>>

	-- This will be used for enGB, enUS and any empty Localization function
	
	local function Default()
		local L = {}

		L.General 		= "General"
		L.Indicator 	= "Indicator"
		L.Tasks 		= "Tasks"
		L.TabTip 		= "Settings that alter the look and functionality of quest indicators that display over your enemys head"

		L.DisableInInstance 			= {"Disable In Any Instance", "Quest indicators will not display while in any instance"}
		L.DisableInCombat 				= {"Disable In Combat", "When in combat with a mob, its quest indicator will be disabled"}

		L.TextureVariant 				= {"Texture Variant", "Change the image used for the quest indicator."}
		L.Alpha 						= {"Opacity", "How visible the indicator will be."}
		L.NormalQuestcolor 				= {"Normal Quest Colour", "Change the colour of the normal quest indicator."}
		L.GroupQuestcolor				= {"Group Quest Colour", "Change the colour of the Group quest indicator."}
		L.AreaQuestcolor 				= {"Bonus Area Quest Colour", "Change the colour of the bonus area quest indicator."}
		L.Scale 						= {"Scale", "Change the scale of the quest indicator."}
		L.IconXOffset 					= {"Horizontal Offset", "Moves the icon either to the left or the right."}
		L.IconYOffset 					= {"Vertical Offset", "Moves the icon either up or down."}

		L.ShowQuestTask 				= {"Show Tasks", "Each task will be displayed in plain text."}
		L.ShowQuestTaskOnMouseOver 		= {"Mouse Over Only", "Quest tasks will only display if your mouse is over the quest indicator."}
		L.TasksXOffset 					= {"Horizontal Offset", "Moves the quest tasks either to the left or the right."}
		L.TasksYOffset 					= {"Vertical Offset", "Moves the quest tasks either up or down."}
		L.TextSize 						= {"Text Size", "The size of the text which displays the quests task."}

		return L
	end

--<<itIT>>------------------------------------------------------------------------------------------<<>>

	function Localizations.itIT()
		return Default()
	end

--<<koKR>>------------------------------------------------------------------------------------------<<>>

	function Localizations.koKR()
		return Default()
	end

--<<ptBR>>------------------------------------------------------------------------------------------<<>>

	function Localizations.ptBR()
		return Default()
	end

--<<ruRU>>------------------------------------------------------------------------------------------<<>>

	function Localizations.ruRU()
		return Default()
	end

--<<zhCN>>------------------------------------------------------------------------------------------<<>>

	function Localizations.zhCN()
		local L = {}

		L.QuestMobs = "任务怪标记"
		
		L.General 		= "General"
		L.Indicator 	= "Indicator"
		L.Tasks 		= "Tasks"
		L.TabTip 		= "Settings that alter the look and functionality of quest indicators that display over your enemys head"

		L.DisableInInstance 			= {"副本状态禁用", "任务指示不会在副本显示"}
		L.DisableInCombat 				= {"战斗状态禁用", "怪物战斗中,不会显示任务标记"}

		L.TextureVariant 				= {"材质", "更换任务标记材质."}
		L.Alpha 						= {"透明度", "更改任务标记的透明度."}
		L.NormalQuestcolor 				= {"普通任务颜色", "改变普通任务标记的颜色."}
		L.GroupQuestcolor				= {"Group Quest Colour", "Change the colour of the Group quest indicator."}
		L.AreaQuestcolor 				= {"区域任务颜色", "改变区域任务标记的颜色."}
		L.Scale 						= {"缩放", "更改任务标记的大小."}
		L.IconXOffset 					= {"图标水平位置", "左右移动任务标记位置."}
		L.IconYOffset 					= {"图标垂直位置", "上下移动任务标记位置."}

		L.ShowQuestTask 				= {"显示任务追踪", "显示任务追踪."}
		L.ShowQuestTaskOnMouseOver 		= {"只在鼠标移过显示", "任务标记只在你鼠标移过时候显示."}
		L.TasksXOffset 					= {"任务追踪水平位置", "左右移动任务追踪位置."}
		L.TasksYOffset 					= {"任务追踪垂直位置", "上下移动任务追踪位置."}
		L.TextSize 						= {"任务追踪文字大小", "更改任务追踪文字大小."}

		return L
	end

--<<zhTW>>------------------------------------------------------------------------------------------<<>>

	function Localizations.zhTW()
		return Default()
	end

--<<deDE>>------------------------------------------------------------------------------------------<<>>

	function Localizations.deDE()
		return Default()
	end

--<<enGB>>------------------------------------------------------------------------------------------<<>>

	function Localizations.enGB() -- Leave as Default
		return Default()
	end

--<<enUS>>------------------------------------------------------------------------------------------<<>>

	function Localizations.enUS() -- Leave as Default
		return Default()
	end

--<<esES>>------------------------------------------------------------------------------------------<<>>

	function Localizations.esES()
		return Default()
	end

--<<esMX>>------------------------------------------------------------------------------------------<<>>

	function Localizations.esMX()
		return Default()
	end

--<<frFR>>------------------------------------------------------------------------------------------<<>>

	function Localizations.frFR()
		return Default()
	end

--<<GET LOCALIZED TEXT>>----------------------------------------------------------------------------<<>>

	function AddonDB.GetLocalizedText(SelectedLanguage)
		return Localizations[SelectedLanguage]()
	end

----------------------------------------------------------------------------------------------------<<END>>
