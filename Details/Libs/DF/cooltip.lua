
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
local _

--lua locals
local ipairs = ipairs
local wipe = table.wipe
local insert = table.insert
local max = math.max

--api locals
local PixelUtil = PixelUtil or DFPixelUtil
local version = 9

local CONST_MENU_TYPE_MAINMENU = "main"
local CONST_MENU_TYPE_SUBMENU = "sub"
local CONST_COOLTIP_TYPE_MENU = "menu"
local CONST_COOLTIP_TYPE_TOOLTIP = "tooltip"

function DF:CreateCoolTip()
	--if a cooltip is already created with a higher version
	if (_G.GameCooltip2 and _G.GameCooltip2.version >= version) then
		return
	end

	local maxStatusBarValue = 100000000

	local defaultBackdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
	tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	local defaultBackdropColor = {0.1215, 0.1176, 0.1294, 0.8000}
	local defaultBackdropBorderColor = {0.05, 0.05, 0.05, 1}

	--initialize
	local gameCooltip = {
		version = version,
		debug = false,
	}
	_G.GameCooltip2 = gameCooltip
	_G.GameCooltip = gameCooltip --back compatibility

	function gameCooltip:PrintDebug(...)
		if (gameCooltip.debug) then
			print("|cFFFFFF00Cooltip|r:", ...)
			print(debugstack())
		end
	end

	function gameCooltip:SetDebug(bDebugState)
		gameCooltip.debug = bDebugState
	end

	function gameCooltip:ParseMenuType(menuType)
		if ((type(menuType) == "number" and menuType == 1) or (type(menuType) == "string" and menuType == CONST_MENU_TYPE_MAINMENU)) then
			return CONST_MENU_TYPE_MAINMENU
		end

		if ((type(menuType) == "number" and menuType == 2) or (type(menuType) == "string" and menuType == CONST_MENU_TYPE_SUBMENU)) then
			return CONST_MENU_TYPE_SUBMENU
		end

		return CONST_MENU_TYPE_MAINMENU
	end

	gameCooltip.LanguageEditBox = gameCooltip.LanguageEditBox or CreateFrame("editbox")
	gameCooltip.LanguageEditBox:SetFontObject("GameFontNormal")
	gameCooltip.LanguageEditBox:ClearFocus()
	gameCooltip.LanguageEditBox:SetAutoFocus(false)

	function gameCooltip.CheckNeedNewFont(text)
		--local file = gameCooltip.LanguageEditBox:GetFont()
		--print("1", file, text)
		--gameCooltip.LanguageEditBox:SetText("Цены аукциона")
		--local file2 = gameCooltip.LanguageEditBox:GetFont()
		--print("2", file2)
		--gameCooltip.LanguageEditBox:ClearFocus()

		--if (file ~= file2) then
		--	gameCooltip:SetOption("TextFont", file2)
		--end
	end

	--containers
	gameCooltip.LeftTextTable = {}
	gameCooltip.LeftTextTableSub = {}
	gameCooltip.RightTextTable = {}
	gameCooltip.RightTextTableSub = {}
	gameCooltip.LeftIconTable = {}
	gameCooltip.LeftIconTableSub = {}
	gameCooltip.RightIconTable = {}
	gameCooltip.RightIconTableSub = {}
	gameCooltip.Banner = {false, false, false}
	gameCooltip.TopIconTableSub = {}
	gameCooltip.StatusBarTable = {}
	gameCooltip.StatusBarTableSub = {}
	gameCooltip.WallpaperTable = {}
	gameCooltip.WallpaperTableSub = {}
	gameCooltip.PopupFrameTable = {}

	--menus
	gameCooltip.FunctionsTableMain = {}
	gameCooltip.FunctionsTableSub = {}
	gameCooltip.ParametersTableMain = {}
	gameCooltip.ParametersTableSub = {}
	gameCooltip.FixedValue = nil
	gameCooltip.SelectedIndexMain = nil
	gameCooltip.SelectedIndexSec = {}

	--options table
	gameCooltip.OptionsList = {
		["RightTextMargin"] = true,
		["IconSize"] = true,
		["HeightAnchorMod"] = true,
		["WidthAnchorMod"] = true,
		["MinWidth"] = true,
		["FixedWidth"] = true,
		["FixedHeight"] = true,
		["FixedWidthSub"] = true,
		["FixedHeightSub"] = true,
		["AlignAsBlizzTooltip"] = true,
		["AlignAsBlizzTooltipFrameHeightOffset"] = true,
		["IgnoreSubMenu"] = true,
		["IgnoreButtonAutoHeight"] = true,
		["TextHeightMod"] = true,
		["ButtonHeightMod"] = true,
		["ButtonHeightModSub"] = true,
		["YSpacingMod"] = true,
		["YSpacingModSub"] = true,
		["ButtonsYMod"] = true,
		["ButtonsYModSub"] = true,
		["IconHeightMod"] = true,
		["StatusBarHeightMod"] = true,
		["StatusBarTexture"] = true,
		["TextSize"] = true,
		["TextFont"] = true,
		["TextColor"] = true,
		["TextColorRight"] = true,
		["TextShadow"] = true,
		["LeftTextWidth"] = true,
		["RightTextWidth"] = true,
		["LeftTextHeight"] = true,
		["RightTextHeight"] = true,
		["NoFade"] = true,
		["MyAnchor"] = true,
		["Anchor"] = true,
		["RelativeAnchor"] = true,
		["NoLastSelectedBar"] = true,
		["SubMenuIsTooltip"] = true,
		["LeftBorderSize"] = true,
		["RightBorderSize"] = true,
		["HeighMod"] = true,
		["HeighModSub"] = true,
		["IconBlendMode"] = true,
		["IconBlendModeHover"] = true,
		["SubFollowButton"] = true,
		["IgnoreArrows"] = true,
		["SelectedTopAnchorMod"] = true,
		["SelectedBottomAnchorMod"] = true,
		["SelectedLeftAnchorMod"] = true,
		["SelectedRightAnchorMod"] = true,

		["SparkTexture"] = true,
		["SparkHeightOffset"] = true,
		["SparkWidthOffset"] = true,
		["SparkHeight"] = true,
		["SparkWidth"] = true,
		["SparkAlpha"] = true,
		["SparkColor"] = true,
		["SparkPositionXOffset"] = true,
		["SparkPositionYOffset"] = true,
	}

	gameCooltip.AliasList = {
		--set the height of each line, options 'IgnoreButtonAutoHeight' and 'AlignAsBlizzTooltip' must be false
		["LineHeightSizeOffset"] = "ButtonHeightMod",
		["LineHeightSizeOffsetSub"] = "ButtonHeightModSub",

		["FrameHeightSizeOffset"] = "HeighMod",
		["FrameHeightSizeOffsetSub"] = "HeighModSub",

		--space between the tooltip's left side and the start of the line
		["LeftPadding"] = "LeftBorderSize",

		--space between the tooltip's right side and the end of the line
		["RightPadding"] = "RightBorderSize",

		--space between each line, positive values make the lines be closer
		["LinePadding"] = "YSpacingMod",
		["VerticalPadding"] = "YSpacingMod",
		["LinePaddingSub"] = "YSpacingModSub",
		["VerticalPaddingSub"] = "YSpacingModSub",

		--move each line in the Y axis (vertical offsett)
		["LineYOffset"] = "ButtonsYMod",
		["VerticalOffset"] = "ButtonsYMod",
		["LineYOffsetSub"] = "ButtonsYModSub",
		["VerticalOffsetSub"] = "ButtonsYModSub",
	}

	gameCooltip.OptionsTable = {}

	--amount of lines current on shown
	gameCooltip.Indexes = 0
	--amount of lines current on shown
	gameCooltip.IndexesSub = {}
	--amount of lines current on shown
	gameCooltip.HaveSubMenu = false
	--amount of lines current on shown on sub menu
	gameCooltip.SubIndexes = 0
	--1 tooltip 2 tooltip with bars 3 menu 4 menu + submenus
	gameCooltip.Type = 1
	--frame to anchor
	gameCooltip.Host = nil
	--last size
	gameCooltip.LastSize = 0
	gameCooltip.LastIndex = 0
	gameCooltip.internalYMod = 0
	gameCooltip.internalYMod = 0
	gameCooltip.overlapChecked = false

	--defaults
	gameCooltip.default_height = 20
	gameCooltip.default_text_size = 10.5
	gameCooltip.default_text_font = "GameFontHighlight"
	gameCooltip.selectedAnchor = {}
	gameCooltip.selectedAnchor.left = 2
	gameCooltip.selectedAnchor.right = 0
	gameCooltip.selectedAnchor.top = 0
	gameCooltip.selectedAnchor.bottom = 0

	gameCooltip.defaultFont = DF:GetBestFontForLanguage()

	--create frames, self is frame1 or frame2
	local createTooltipFrames = function(self)
		self:SetSize(500, 500)
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		self:SetBackdrop(defaultBackdrop)
		self:SetBackdropColor(DF:ParseColors(defaultBackdropColor))
		self:SetBackdropBorderColor(DF:ParseColors(defaultBackdropBorderColor))

		--this texture get the color from gameCooltip:SetColor()
		if (not self.frameBackgroundTexture) then
			self.frameBackgroundTexture = self:CreateTexture("$parent_FrameBackgroundTexture", "BACKGROUND", nil, 2)
			self.frameBackgroundTexture:SetColorTexture(0, 0, 0, 0)
			self.frameBackgroundTexture:SetAllPoints()
		end

		--this get the texture from gameCooltip:SetWallpaper(index, texture, texcoord, color, desaturate)
		if (not self.frameWallpaper) then
			self.frameWallpaper = self:CreateTexture("$parent_FrameWallPaper", "BACKGROUND", nil, 4)
			self.frameWallpaper:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			self.frameWallpaper:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		end

		if (not self.selectedTop) then
			self.selectedTop = self:CreateTexture("$parent_SelectedTop", "ARTWORK")
			self.selectedTop:SetColorTexture(.5, .5, .5, .75)
			self.selectedTop:SetHeight(3)
		end

		if (not self.gradientTexture) then
			self.gradientTexture = DetailsFramework:CreateTexture(self, {gradient = "vertical", fromColor = {0, 0, 0, .2}, toColor = {0, 0, 0, 0}}, 1, 1, "overlay", {0, 1, 0, 1})
			self.gradientTexture.sublevel = -7
			self.gradientTexture:SetAllPoints()
		end

		if (not self.selectedBottom) then
			self.selectedBottom = self:CreateTexture("$parent_SelectedBottom", "ARTWORK")
			self.selectedBottom:SetColorTexture(.5, .5, .5, .75)
			self.selectedBottom:SetHeight(3)
		end

		if (not self.selectedMiddle) then
			self.selectedMiddle = self:CreateTexture("$parent_Selected", "ARTWORK")
			self.selectedMiddle:SetColorTexture(.5, .5, .5, .75)
			self.selectedMiddle:SetPoint("TOPLEFT", self.selectedTop, "BOTTOMLEFT")
			self.selectedMiddle:SetPoint("BOTTOMRIGHT", self.selectedBottom, "TOPRIGHT")
		end

		if (not self.upperImage) then
			self.upperImage = self:CreateTexture("$parent_UpperImage", "OVERLAY")
			self.upperImage:SetPoint("CENTER", self, "CENTER", 0, -3)
			self.upperImage:SetPoint("BOTTOM", self, "TOP", 0, -3)
			self.upperImage:Hide()
		end

		if (not self.upperImage2) then
			self.upperImage2 = self:CreateTexture("$parent_UpperImage2", "ARTWORK")
			self.upperImage2:SetPoint("CENTER", self, "CENTER", 0, -3)
			self.upperImage2:SetPoint("BOTTOM", self, "TOP", 0, -3)
			self.upperImage2:Hide()
		end

		if (not self.upperImageText) then
			self.upperImageText = self:CreateFontString("$parent_UpperImageText", "OVERLAY", "GameTooltipHeaderText")
			self.upperImageText:SetJustifyH("LEFT")
			self.upperImageText:SetPoint("LEFT", self.upperImage, "RIGHT", 5, 0)
			DF:SetFontSize(self.upperImageText, 13)
		end

		if (not self.upperImageText2) then
			self.upperImageText2 = self:CreateFontString("$parent_UpperImageText2", "OVERLAY", "GameTooltipHeaderText")
			self.upperImageText2:SetJustifyH("LEFT")
			self.upperImageText2:SetPoint("BOTTOMRIGHT", self, "LEFT", 0, 3)
			DF:SetFontSize(self.upperImageText2, 13)
		end

		if (not self.titleIcon) then
			self.titleIcon = self:CreateTexture("$parent_TitleIcon", "OVERLAY")
			self.titleIcon:SetTexture("Interface\\Challenges\\challenges-main")
			self.titleIcon:SetTexCoord(0.1521484375, 0.563671875, 0.160859375, 0.234375)
			self.titleIcon:SetPoint("CENTER", self, "CENTER")
			self.titleIcon:SetPoint("BOTTOM", self, "TOP", 0, -22)
			self.titleIcon:Hide()
		end

		if (not self.titleText) then
			self.titleText = self:CreateFontString("$parent_TitleText", "OVERLAY", "GameFontHighlightSmall")
			self.titleText:SetJustifyH("LEFT")
			DF:SetFontSize(self.titleText, 10)
			self.titleText:SetPoint("CENTER", self.titleIcon, "CENTER", 0, 6)
		end
	end

	--main frame
		local frame1 = GameCooltipFrame1
		if (not GameCooltipFrame1) then
			frame1 = CreateFrame("Frame", "GameCooltipFrame1", UIParent, "BackdropTemplate")
		end

		DF.table.addunique(UISpecialFrames, "GameCooltipFrame1")

		if (not frame1.FlashAnimation) then
			DF:CreateFlashAnimation(frame1)
		end

		createTooltipFrames(frame1)

	--secondary frame
		local frame2 = GameCooltipFrame2
		if (not GameCooltipFrame2) then
			frame2 = CreateFrame("Frame", "GameCooltipFrame2", UIParent, "BackdropTemplate")
		end

		frame2:SetClampedToScreen(true)
		DF.table.addunique(UISpecialFrames, "GameCooltipFrame2")
		createTooltipFrames(frame2)
		frame2:SetPoint("bottomleft", frame1, "bottomright", 4, 0)

		if (not frame2.FlashAnimation) then
			DF:CreateFlashAnimation(frame2)
		end

	gameCooltip.frame1 = frame1
	gameCooltip.frame2 = frame2
	DF:FadeFrame(frame1, 0)
	DF:FadeFrame(frame2, 0)
	frame1.Lines = {}
	frame2.Lines = {}

----------------------------------------------------------------------
	--Title Function 
----------------------------------------------------------------------

	function gameCooltip:SetTitle(frameId, text)
		if (frameId == 1) then
			gameCooltip.title1 = true
			gameCooltip.title_text = text
		end
	end

	function gameCooltip:SetTitleAnchor(frameId, anchorPoint, ...)
		anchorPoint = string.lower(anchorPoint)
		if (frameId == 1) then
			self.frame1.titleIcon:ClearAllPoints()
			self.frame1.titleText:ClearAllPoints()

			if (anchorPoint == "left") then
				self.frame1.titleIcon:SetPoint("left", frame1, "left", ...)
				self.frame1.titleText:SetPoint("left", frame1.titleIcon, "right")

			elseif (anchorPoint == "center") then
				self.frame1.titleIcon:SetPoint("center", frame1, "center")
				self.frame1.titleIcon:SetPoint("bottom", frame1, "top")
				self.frame1.titleText:SetPoint("left", frame1.titleIcon, "right")
				self.frame1.titleText:SetText("TESTE")

				self.frame1.titleText:Show()
				self.frame1.titleIcon:Show()

			elseif (anchorPoint == "right") then
				self.frame1.titleIcon:SetPoint("right", frame1, "right", ...)
				self.frame1.titleText:SetPoint("right", frame1.titleIcon, "left")

			end

		elseif (frameId == 2) then
			self.frame2.titleIcon:ClearAllPoints()
			self.frame2.titleText:ClearAllPoints()

			if (anchorPoint == "left") then
				self.frame2.titleIcon:SetPoint("left", frame2, "left", ...)
				self.frame2.titleText:SetPoint("left", frame2.titleIcon, "right")

			elseif (anchorPoint == "center") then
				self.frame2.titleIcon:SetPoint("center", frame2, "center", ...)
				self.frame2.titleText:SetPoint("left", frame2.titleIcon, "right")

			elseif (anchorPoint == "right") then
				self.frame2.titleIcon:SetPoint("right", frame2, "right", ...)
				self.frame2.titleText:SetPoint("right", frame2.titleIcon, "left")
			end
		end
	end

----------------------------------------------------------------------
	--Button Hide and Show Functions
----------------------------------------------------------------------
	local elapsedTime = 0
	gameCooltip.mouseOver = false
	gameCooltip.buttonClicked = false

	frame1:SetScript("OnEnter", function(self)
		--is cooltip a menu?
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2) then
			gameCooltip.active = true
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true

			self:SetScript("OnUpdate", nil)
			DF:FadeFrame(self, 0)

			if (gameCooltip.sub_menus) then
				DF:FadeFrame(frame2, 0)
			end
		end
	end)

	frame2:SetScript("OnEnter", function(self)
		if (gameCooltip.OptionsTable.SubMenuIsTooltip) then
			return gameCooltip:Close()
		end

		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2) then
			gameCooltip.active = true
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true

			self:SetScript("OnUpdate", nil)
			DF:FadeFrame(self, 0)
			DF:FadeFrame(frame1, 0)
		end
	end)

	local OnLeaveUpdateFrame1 = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > 0.7) then
			if (not gameCooltip.active and not gameCooltip.buttonClicked and self == gameCooltip.Host) then
				DF:FadeFrame(self, 1)
				DF:FadeFrame(frame2, 1)

			elseif (not gameCooltip.active) then
				DF:FadeFrame(self, 1)
				DF:FadeFrame(frame2, 1)
			end

			self:SetScript("OnUpdate", nil)
			frame2:SetScript("OnUpdate", nil)
		end
	end

	frame1:SetScript("OnLeave", function(self)
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2) then
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			elapsedTime = 0
			self:SetScript("OnUpdate", OnLeaveUpdateFrame1)
		else
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			elapsedTime = 0
			self:SetScript("OnUpdate", OnLeaveUpdateFrame1)
		end
	end)

	local OnLeaveUpdateFrame2 = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > 0.7) then
			if (not gameCooltip.active and not gameCooltip.buttonClicked and self == gameCooltip.Host) then
				DF:FadeFrame(self, 1)
				DF:FadeFrame(frame2, 1)

			elseif (not gameCooltip.active) then
				DF:FadeFrame(self, 1)
				DF:FadeFrame(frame2, 1)
			end

			self:SetScript("OnUpdate", nil)
			frame1:SetScript("OnUpdate", nil)
		end
	end

	frame2:SetScript("OnLeave", function(self)
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2) then
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			elapsedTime = 0
			self:SetScript("OnUpdate", OnLeaveUpdateFrame2)
		else
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			elapsedTime = 0
			self:SetScript("OnUpdate", OnLeaveUpdateFrame2)
		end
	end)

	frame1:SetScript("OnHide", function(self)
		gameCooltip.active = false
		gameCooltip.buttonClicked = false
		gameCooltip.mouseOver = false
		--reset parent and  strata
		frame1:SetParent(UIParent)
		frame2:SetParent(UIParent)
		frame1:SetFrameStrata("TOOLTIP")
		frame2:SetFrameStrata("TOOLTIP")
	end)

----------------------------------------------------------------------
	--Button Creation Functions
----------------------------------------------------------------------
	--self is the new button created
	local createButtonWidgets = function(self)
		self:SetSize(1, 20)

		--status bar
		self.statusbar = CreateFrame("StatusBar", "$Parent_StatusBar", self)
		self.statusbar:SetPoint("LEFT", self, "LEFT", 10, 0)
		self.statusbar:SetPoint("RIGHT", self, "RIGHT", -10, 0)
		self.statusbar:SetPoint("TOP", self, "TOP", 0, 0)
		self.statusbar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
		self.statusbar:SetHeight(20)

		local statusbar = self.statusbar

		statusbar.texture = statusbar:CreateTexture("$parent_Texture", "BACKGROUND")
		statusbar.texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		statusbar.texture:SetSize(300, 14)
		statusbar:SetStatusBarTexture(statusbar.texture)
		statusbar:SetMinMaxValues(0, 100)

		statusbar.spark = statusbar:CreateTexture("$parent_Spark", "BACKGROUND")
		statusbar.spark:Hide()
		statusbar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		statusbar.spark:SetBlendMode("ADD")
		statusbar.spark:SetSize(12, 24)
		statusbar.spark:SetPoint("LEFT", statusbar, "RIGHT", -20, -1)
		statusbar.spark.originalWidth = 12
		statusbar.spark.originalHeight = 24
		statusbar.spark.originalTexture = "Interface\\CastingBar\\UI-CastingBar-Spark"

		statusbar.background = statusbar:CreateTexture("$parent_Background", "ARTWORK")
		statusbar.background:Hide()
		statusbar.background:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
		statusbar.background:SetPoint("LEFT", statusbar, "LEFT", -6, 0)
		statusbar.background:SetPoint("RIGHT", statusbar, "RIGHT", 6, 0)
		statusbar.background:SetPoint("TOP", statusbar, "TOP", 0, 0)
		statusbar.background:SetPoint("BOTTOM", statusbar, "BOTTOM", 0, 0)

		self.background = statusbar.background

		statusbar.leftIcon = statusbar:CreateTexture("$parent_LeftIcon", "OVERLAY")
		statusbar.leftIcon:SetSize(16, 16)
		statusbar.leftIcon:SetPoint("LEFT", statusbar, "LEFT", 0, 0)

		statusbar.rightIcon = statusbar:CreateTexture("$parent_RightIcon", "OVERLAY")
		statusbar.rightIcon:SetSize(16, 16)
		statusbar.rightIcon:SetPoint("RIGHT", statusbar, "RIGHT", 0, 0)

		statusbar.spark2 = statusbar:CreateTexture("$parent_Spark2", "OVERLAY")
		statusbar.spark2:SetSize(32, 32)
		statusbar.spark2:SetPoint("LEFT", statusbar, "RIGHT", -17, -1)
		statusbar.spark2:SetBlendMode("ADD")
		statusbar.spark2:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		statusbar.spark2:Hide()

		statusbar.subMenuArrow = statusbar:CreateTexture("$parent_SubMenuArrow", "OVERLAY")
		statusbar.subMenuArrow:SetSize(12, 12)
		statusbar.subMenuArrow:SetPoint("RIGHT", statusbar, "RIGHT", 3, 0)
		statusbar.subMenuArrow:SetBlendMode("ADD")
		statusbar.subMenuArrow:SetTexture("Interface\\CHATFRAME\\ChatFrameExpandArrow")
		statusbar.subMenuArrow:Hide()

		statusbar.leftText = statusbar:CreateFontString("$parent_LeftText", "OVERLAY", "GameTooltipHeaderText")
		statusbar.leftText:SetJustifyH("LEFT")
		statusbar.leftText:SetPoint("LEFT", statusbar.leftIcon, "RIGHT", 3, 0)
		DF:SetFontSize(statusbar.leftText, 10)

		statusbar.rightText = statusbar:CreateFontString("$parent_TextRight", "OVERLAY", "GameTooltipHeaderText")
		statusbar.rightText:SetJustifyH("RIGHT")
		statusbar.rightText:SetPoint("RIGHT", statusbar.rightIcon, "LEFT", -3, 0)
		DF:SetFontSize(statusbar.leftText, 10)

		--background status bar
		self.statusbar2 = CreateFrame("StatusBar", "$Parent_StatusBarBackground", self)
		self.statusbar2:SetPoint("LEFT", self.statusbar, "LEFT")
		self.statusbar2:SetPoint("RIGHT", self.statusbar, "RIGHT")
		self.statusbar2:SetPoint("TOP", self.statusbar, "TOP")
		self.statusbar2:SetPoint("BOTTOM", self.statusbar, "BOTTOM")

		local statusbar2 = self.statusbar2
		statusbar2.texture = statusbar2:CreateTexture("$parent_Texture", "BACKGROUND")
		statusbar2.texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		statusbar2.texture:SetSize(300, 14)
		statusbar2:SetStatusBarTexture(statusbar2.texture)
		statusbar2:SetMinMaxValues(0, 100)

		--on load
		self:RegisterForClicks("LeftButtonDown")
		self.leftIcon = self.statusbar.leftIcon
		self.rightIcon = self.statusbar.rightIcon
		self.texture = self.statusbar.texture
		self.spark = self.statusbar.spark
		self.spark2 = self.statusbar.spark2
		self.leftText = self.statusbar.leftText
		self.rightText = self.statusbar.rightText
		self.statusbar:SetFrameLevel(self:GetFrameLevel()+2)
		self.statusbar2:SetFrameLevel(self.statusbar:GetFrameLevel()-1)
		self.statusbar2:SetValue(0)

		--scripts
		self:SetScript("OnMouseDown", GameCooltipButtonMouseDown)
		self:SetScript("OnMouseUp", GameCooltipButtonMouseUp)
	end

	function GameCooltipButtonMouseDown(button)
		local heightMod = gameCooltip.OptionsTable.TextHeightMod or 0
		button.leftText:SetPoint("center", button.leftIcon, "center", 0, 0 + heightMod)
		button.leftText:SetPoint("left", button.leftIcon, "right", 4, -1 + heightMod)
	end

	function GameCooltipButtonMouseUp(button)
		local heightMod = gameCooltip.OptionsTable.TextHeightMod or 0
		button.leftText:SetPoint("center", button.leftIcon, "center", 0, 0 + heightMod)
		button.leftText:SetPoint("left", button.leftIcon, "right", 3, 0 + heightMod)
	end

	function gameCooltip:CreateButton(index, frame, name)
		local newNutton = CreateFrame("Button", name, frame)
		createButtonWidgets (newNutton)
		frame.Lines[index] = newNutton
		return newNutton
	end

	local OnEnterUpdateButton = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > 0.001) then
			--search key: ~onenterupdatemain
			gameCooltip:ShowSub(self.index)
			gameCooltip.lastButtonInteracted = self.index
			self:SetScript("OnUpdate", nil)
		end
	end

	local OnLeaveUpdateButton = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > 0.7) then
			if (not gameCooltip.active and not gameCooltip.buttonClicked) then
				DF:FadeFrame(frame1, 1)
				DF:FadeFrame(frame2, 1)
			elseif (not gameCooltip.active) then
				DF:FadeFrame(frame1, 1)
				DF:FadeFrame(frame2, 1)
			end
			frame1:SetScript("OnUpdate", nil)
		end
	end

	local OnEnterMainButton = function(self)
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2 and not self.isDiv) then
			gameCooltip.active = true
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true

			frame1:SetScript("OnUpdate", nil)
			frame2:SetScript("OnUpdate", nil)

			self.background:Show()

			if (gameCooltip.OptionsTable.IconBlendModeHover) then
				self.leftIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendModeHover)
			else
				self.leftIcon:SetBlendMode("BLEND")
			end

			if (gameCooltip.PopupFrameTable[self.index]) then
				local onEnter, onLeave, param1, param2 = unpack(gameCooltip.PopupFrameTable[self.index])
				if (onEnter) then
					xpcall(onEnter, geterrorhandler(), frame1, param1, param2)
				end

			elseif (gameCooltip.IndexesSub[self.index] and gameCooltip.IndexesSub[self.index] > 0) then
				if (gameCooltip.OptionsTable.SubMenuIsTooltip) then
					gameCooltip:ShowSub(self.index)
					self.index = self.ID
				else
					if (gameCooltip.lastButtonInteracted) then
						gameCooltip:ShowSub(gameCooltip.lastButtonInteracted)
					else
						gameCooltip:ShowSub(self.index)
					end
					elapsedTime = 0
					self.index = self.ID
					self:SetScript("OnUpdate", OnEnterUpdateButton)
				end
			else
				--hide second frame
				DF:FadeFrame(frame2, 1)
				gameCooltip.lastButtonInteracted = nil
			end
		else
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true
		end
	end

	local OnLeaveMainButton = function(self)
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2 and not self.isDiv) then
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			self:SetScript("OnUpdate", nil)

			self.background:Hide()

			if (gameCooltip.OptionsTable.IconBlendMode) then
				self.leftIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
				self.rightIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
			else
				self.leftIcon:SetBlendMode("BLEND")
				self.rightIcon:SetBlendMode("BLEND")
			end

			if (gameCooltip.PopupFrameTable[self.index]) then
				local onEnter, onLeave, param1, param2 = unpack(gameCooltip.PopupFrameTable[self.index])
				if (onLeave) then
					xpcall(onLeave, geterrorhandler(), frame1, param1, param2)
				end
			end

			elapsedTime = 0
			frame1:SetScript("OnUpdate", OnLeaveUpdateButton)
		else
			gameCooltip.active = false
			elapsedTime = 0
			frame1:SetScript("OnUpdate", OnLeaveUpdateButton)
			gameCooltip.mouseOver = false
		end
	end

	--serach key: ~onenter
	function gameCooltip:CreateMainFrameButton(i)
		local newButton = gameCooltip:CreateButton(i, frame1, "GameCooltipMainButton" .. i)
		newButton.ID = i
		newButton:SetScript("OnEnter", OnEnterMainButton)
		newButton:SetScript("OnLeave", OnLeaveMainButton)
		return newButton
	end

	--buttons for the secondary frame
	local OnLeaveUpdateButtonSec = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > 0.7) then
			if (not gameCooltip.active and not gameCooltip.buttonClicked) then
				DF:FadeFrame(frame1, 1)
				DF:FadeFrame(frame2, 1)
			elseif (not gameCooltip.active) then
				DF:FadeFrame(frame1, 1)
				DF:FadeFrame(frame2, 1)
			end
			frame2:SetScript("OnUpdate", nil)
		end
	end

	local OnEnterSecondaryButton = function(self)
		if (gameCooltip.OptionsTable.SubMenuIsTooltip) then
			return gameCooltip:Close()
		end

		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2 and not self.isDiv) then
			gameCooltip.active = true
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true

			self.background:Show()

			if (gameCooltip.OptionsTable.IconBlendModeHover) then
				self.leftIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendModeHover)
			else
				self.leftIcon:SetBlendMode("BLEND")
			end

			frame1:SetScript("OnUpdate", nil)
			frame2:SetScript("OnUpdate", nil)

			DF:FadeFrame(frame1, 0)
			DF:FadeFrame(frame2, 0)
		else
			gameCooltip.mouseOver = true
			gameCooltip.hadInteractions = true
		end
	end

	local OnLeaveSecondaryButton = function(self)
		if (gameCooltip.Type ~= 1 and gameCooltip.Type ~= 2) then
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			self.background:Hide()

			if (gameCooltip.OptionsTable.IconBlendMode) then
				self.leftIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
				self.rightIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
			else
				self.leftIcon:SetBlendMode("BLEND")
				self.rightIcon:SetBlendMode("BLEND")
			end

			elapsedTime = 0
			frame2:SetScript("OnUpdate", OnLeaveUpdateButtonSec)
		else
			gameCooltip.active = false
			gameCooltip.mouseOver = false
			elapsedTime = 0
			frame2:SetScript("OnUpdate", OnLeaveUpdateButtonSec)
		end
	end

	function gameCooltip:CreateButtonOnSecondFrame(i)
		local newButton = gameCooltip:CreateButton(i, frame2, "GameCooltipSecButton" .. i)
		newButton.ID = i
		newButton:SetScript("OnEnter", OnEnterSecondaryButton)
		newButton:SetScript("OnLeave", OnLeaveSecondaryButton)
		return newButton
	end

----------------------------------------------------------------------
	--Button Click Functions
----------------------------------------------------------------------
	gameCooltip.selectedAnchor.left = 4
	gameCooltip.selectedAnchor.right = -4
	gameCooltip.selectedAnchor.top = 0
	gameCooltip.selectedAnchor.bottom = 0

	function gameCooltip:HideSelectedTexture(frame)
		frame.selectedTop:Hide()
		frame.selectedBottom:Hide()
		frame.selectedMiddle:Hide()
	end

	function gameCooltip:ShowSelectedTexture(frame)
		frame.selectedTop:Show()
		frame.selectedBottom:Show()
		frame.selectedMiddle:Show()
	end

	function gameCooltip:SetSelectedAnchor(frame, button)
		local left = gameCooltip.selectedAnchor.left + (gameCooltip.OptionsTable.SelectedLeftAnchorMod or 0)
		local right = gameCooltip.selectedAnchor.right + (gameCooltip.OptionsTable.SelectedRightAnchorMod or 0)

		local top = gameCooltip.selectedAnchor.top + (gameCooltip.OptionsTable.SelectedTopAnchorMod or 0)
		local bottom = gameCooltip.selectedAnchor.bottom + (gameCooltip.OptionsTable.SelectedBottomAnchorMod or 0)

		frame.selectedTop:ClearAllPoints()
		frame.selectedBottom:ClearAllPoints()

		frame.selectedTop:SetPoint("topleft", button, "topleft", left+1, top)
		frame.selectedTop:SetPoint("topright", button, "topright", right-1, top)
		frame.selectedBottom:SetPoint("bottomleft", button, "bottomleft", left+1, bottom)
		frame.selectedBottom:SetPoint("bottomright", button, "bottomright", right-1, bottom)

		gameCooltip:ShowSelectedTexture(frame)
	end

	local OnClickFunctionMainButton = function(self, button)
		if (gameCooltip.IndexesSub[self.index] and gameCooltip.IndexesSub[self.index] > 0) then
			gameCooltip:ShowSub(self.index)
			gameCooltip.lastButtonInteracted = self.index
		end

		gameCooltip.buttonClicked = true
		gameCooltip:SetSelectedAnchor(frame1, self)

		if (not gameCooltip.OptionsTable.NoLastSelectedBar) then
			gameCooltip:ShowSelectedTexture(frame1)
		end
		gameCooltip.SelectedIndexMain = self.index

		if (gameCooltip.FunctionsTableMain[self.index]) then
			local parameterTable = gameCooltip.ParametersTableMain[self.index]
			local func = gameCooltip.FunctionsTableMain[self.index]
			local okay, errortext = pcall(func, gameCooltip.Host, gameCooltip.FixedValue, parameterTable[1], parameterTable[2], parameterTable[3], button)
			if (not okay) then
				print("Cooltip OnClick Error:", errortext)
			end
		end
	end

	local OnClickFunctionSecondaryButton = function(self, button)
		gameCooltip.buttonClicked = true
		gameCooltip:SetSelectedAnchor(frame2, self)

		if (gameCooltip.FunctionsTableSub[self.mainIndex] and gameCooltip.FunctionsTableSub[self.mainIndex][self.index]) then
			local parameterTable = gameCooltip.ParametersTableSub[self.mainIndex][self.index]
			local func = gameCooltip.FunctionsTableSub[self.mainIndex][self.index]
			local okay, errortext = pcall(func, gameCooltip.Host, gameCooltip.FixedValue, parameterTable[1], parameterTable[2], parameterTable[3], button)
			if (not okay) then
				print("Cooltip OnClick Error:", errortext)
			end
		end

		gameCooltip:SetSelectedAnchor(frame1, frame1.Lines[self.mainIndex])

		if (not gameCooltip.OptionsTable.NoLastSelectedBar) then
			gameCooltip:ShowSelectedTexture(frame1)
		end

		gameCooltip.SelectedIndexMain = self.mainIndex
		gameCooltip.SelectedIndexSec[self.mainIndex] = self.index
	end

	function gameCooltip:TextAndIcon(index, frame, menuButton, leftTextSettings, rightTextSettings, leftIconSettings, rightIconSettings, isSecondFrame)
		--reset width
		menuButton.leftText:SetWidth(0)
		menuButton.leftText:SetHeight(0)
		menuButton.rightText:SetWidth(0)
		menuButton.rightText:SetHeight(0)
		menuButton.rightText:SetPoint("right", menuButton.rightIcon, "left", gameCooltip.OptionsTable.RightTextMargin or -3, 0)

		--set text
		if (leftTextSettings) then
			menuButton.leftText:SetText(leftTextSettings[1])
			local r, g, b, a = leftTextSettings[2], leftTextSettings[3], leftTextSettings[4], leftTextSettings[5]

			if (r == 0 and g == 0 and b == 0 and a == 0) then
				if (gameCooltip.OptionsTable.TextColor) then
					r, g, b, a = DF:ParseColors(gameCooltip.OptionsTable.TextColor)
					DF:SetFontColor(menuButton.leftText, r, g, b, a)
				else
					menuButton.leftText:SetTextColor(1, 1, 1, 1)
				end
			else
				DF:SetFontColor(menuButton.leftText, r, g, b, a)
			end

			if (gameCooltip.OptionsTable.TextSize and not leftTextSettings[6]) then
				DF:SetFontSize(menuButton.leftText, gameCooltip.OptionsTable.TextSize)
			end

			if (gameCooltip.OptionsTable.LeftTextWidth) then
				menuButton.leftText:SetWidth(gameCooltip.OptionsTable.LeftTextWidth)
			else
				menuButton.leftText:SetWidth(0)
			end

			if (gameCooltip.OptionsTable.LeftTextHeight) then
				menuButton.leftText:SetHeight(gameCooltip.OptionsTable.LeftTextHeight)
			else
				menuButton.leftText:SetHeight(0)
			end

			if (gameCooltip.OptionsTable.TextFont and not leftTextSettings[7]) then --font
				if (_G[gameCooltip.OptionsTable.TextFont]) then
					menuButton.leftText:SetFontObject(_G.GameFontRed or gameCooltip.OptionsTable.TextFont)
				else
					local font = SharedMedia:Fetch("font", gameCooltip.OptionsTable.TextFont)
					local _, size, flags = menuButton.leftText:GetFont()
					flags = leftTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					size = leftTextSettings[6] or gameCooltip.OptionsTable.TextSize or size
					menuButton.leftText:SetFont(font, size, flags)
				end

			elseif (leftTextSettings[7]) then
				if (_G[leftTextSettings[7]]) then
					menuButton.leftText:SetFontObject(leftTextSettings[7])
					local fontFace, fontSize, fontFlags = menuButton.leftText:GetFont()
					fontFlags = leftTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					fontSize = leftTextSettings[6] or gameCooltip.OptionsTable.TextSize or fontSize
					menuButton.leftText:SetFont(fontFace, fontSize, fontFlags)
				else
					local font = SharedMedia:Fetch("font", leftTextSettings[7])
					local fontFace, fontSize, fontFlags = menuButton.leftText:GetFont()
					--fontFace = font or fontFace
					fontFlags = leftTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					fontSize = leftTextSettings[6] or gameCooltip.OptionsTable.TextSize or fontSize
					menuButton.leftText:SetFont(fontFace, fontSize, fontFlags)
				end
			else
				menuButton.leftText:SetFont(gameCooltip.defaultFont, leftTextSettings[6] or gameCooltip.OptionsTable.TextSize or 10, leftTextSettings[8] or gameCooltip.OptionsTable.TextShadow)
			end

			local heightMod = gameCooltip.OptionsTable.TextHeightMod or 0				
			menuButton.leftText:SetPoint("center", menuButton.leftIcon, "center", 0, 0 + heightMod)
			menuButton.leftText:SetPoint("left", menuButton.leftIcon, "right", 3, 0 + heightMod)
		else
			menuButton.leftText:SetText("")
		end

		if (rightTextSettings) then
			menuButton.rightText:SetText(rightTextSettings[1])
			local r, g, b, a = rightTextSettings[2], rightTextSettings[3], rightTextSettings[4], rightTextSettings[5]

			if (r == 0 and g == 0 and b == 0 and a == 0) then
				if (gameCooltip.OptionsTable.TextColorRight) then
					r, g, b, a = DF:ParseColors(gameCooltip.OptionsTable.TextColorRight)
					DF:SetFontColor(menuButton.rightText, r, g, b, a)
				elseif (gameCooltip.OptionsTable.TextColor) then
					r, g, b, a = DF:ParseColors(gameCooltip.OptionsTable.TextColor)
					DF:SetFontColor(menuButton.rightText, r, g, b, a)
				else
					menuButton.rightText:SetTextColor(1, 1, 1, 1)
				end
			else
				DF:SetFontColor(menuButton.rightText, r, g, b, a)
			end

			if (gameCooltip.OptionsTable.TextSize and not rightTextSettings[6]) then
				DF:SetFontSize(menuButton.rightText, gameCooltip.OptionsTable.TextSize)
			end

			if (gameCooltip.OptionsTable.RightTextWidth) then
				menuButton.rightText:SetWidth(gameCooltip.OptionsTable.RightTextWidth)
			else
				menuButton.rightText:SetWidth(0)
			end

			if (gameCooltip.OptionsTable.TextFont and not rightTextSettings[7]) then
				if (_G[gameCooltip.OptionsTable.TextFont]) then
					menuButton.rightText:SetFontObject(gameCooltip.OptionsTable.TextFont)
				else
					local fontFace = SharedMedia:Fetch("font", gameCooltip.OptionsTable.TextFont)
					local _, fontSize, fontFlags = menuButton.rightText:GetFont()
					fontFlags = rightTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					fontSize = rightTextSettings[6] or gameCooltip.OptionsTable.TextSize or fontSize
					menuButton.rightText:SetFont(fontFace, fontSize, fontFlags)
				end

			elseif (rightTextSettings[7]) then
				if (_G[rightTextSettings[7]]) then
					menuButton.rightText:SetFontObject(rightTextSettings[7])
					local fontFace, fontSize, fontFlags = menuButton.rightText:GetFont()
					fontFlags = rightTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					fontSize = rightTextSettings[6] or gameCooltip.OptionsTable.TextSize or fontSize
					menuButton.rightText:SetFont(fontFace, fontSize, fontFlags)
				else
					local font = SharedMedia:Fetch("font", rightTextSettings[7])
					local fontFace, fontSize, fontFlags = menuButton.rightText:GetFont()
					fontFlags = rightTextSettings[8] or gameCooltip.OptionsTable.TextShadow or nil
					fontSize = rightTextSettings[6] or gameCooltip.OptionsTable.TextSize or fontSize
					menuButton.rightText:SetFont(fontFace, fontSize, fontFlags)
				end
			else
				menuButton.rightText:SetFont(gameCooltip.defaultFont, rightTextSettings[6] or gameCooltip.OptionsTable.TextSize or 10, rightTextSettings[8] or gameCooltip.OptionsTable.TextShadow)
			end
		else
			menuButton.rightText:SetText("")
		end

		--left icon
		if (leftIconSettings and leftIconSettings[1]) then
			local textureObject = menuButton.leftIcon

			--check if the texture passed is a texture object
			if (type(leftIconSettings[1]) == "table" and leftIconSettings[1].GetObjectType and leftIconSettings[1]:GetObjectType() == "Texture") then
				menuButton.leftIcon:SetSize(leftIconSettings[2], leftIconSettings[3])
				menuButton.leftIcon:SetColorTexture(0.0156, 0.047, 0.1215, 1)
				textureObject = leftIconSettings[1]
				textureObject:SetParent(menuButton.leftIcon:GetParent())
				textureObject:ClearAllPoints()
				textureObject:SetDrawLayer("overlay", 7)
				textureObject:Show()

				for i = 1, menuButton.leftIcon:GetNumPoints() do
					local anchor1, anchorFrame, anchor2, x, y = menuButton.leftIcon:GetPoint(i)
					textureObject:SetPoint(anchor1, anchorFrame, anchor2, x, y)
				end

				menuButton.customLeftTexture = textureObject
			else
				if (menuButton.customLeftTexture) then
					menuButton.customLeftTexture:Hide()
					menuButton.customLeftTexture = nil
				end

				menuButton.leftIcon:Show()
				menuButton.leftIcon:SetTexture(leftIconSettings[1])
			end

			textureObject:SetWidth(leftIconSettings[2])
			textureObject:SetHeight(leftIconSettings[3])
			textureObject:SetTexCoord(leftIconSettings[4], leftIconSettings[5], leftIconSettings[6], leftIconSettings[7])

			local colorRed, colorGreen, colorBlue, colorAlpha = DF:ParseColors(leftIconSettings[8])
			textureObject:SetVertexColor(colorRed, colorGreen, colorBlue, colorAlpha)

			if (gameCooltip.OptionsTable.IconBlendMode) then
				textureObject:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
			else
				textureObject:SetBlendMode("BLEND")
			end

			textureObject:SetDesaturated(leftIconSettings[9])
		else
			local textureObject = menuButton.leftIcon
			textureObject:SetTexture("")
			textureObject:SetWidth(1)
			textureObject:SetHeight(1)

			if (menuButton.customLeftTexture) then
				menuButton.customLeftTexture:Hide()
				menuButton.customLeftTexture = nil
			end
		end

		--right icon
		if (rightIconSettings and rightIconSettings[1]) then
			local textureObject = menuButton.rightIcon

			--check if the texture passed is a texture object
			if (type(rightIconSettings[1]) == "table" and rightIconSettings[1].GetObjectType and rightIconSettings[1]:GetObjectType() == "Texture") then
				menuButton.rightIcon:SetSize(leftIconSettings[2], leftIconSettings[3])
				menuButton.rightIcon:SetColorTexture(0.0156, 0.047, 0.1215, 1)

				textureObject = rightIconSettings[1]
				textureObject:SetParent(menuButton)
				textureObject:ClearAllPoints()
				textureObject:SetDrawLayer("overlay", 7)
				textureObject:Show()

				for i = 1, menuButton.rightIcon:GetNumPoints() do
					local anchor1, anchorFrame, anchor2, x, y = menuButton.rightIcon:GetPoint(i)
					textureObject:SetPoint(anchor1, anchorFrame, anchor2, x, y)
				end

				menuButton.customRightTexture = textureObject
			else
				if (menuButton.customRightTexture) then
					menuButton.customRightTexture:Hide()
					menuButton.customRightTexture = nil
				end

				menuButton.rightIcon:Show()
				menuButton.rightIcon:SetTexture(rightIconSettings[1])
			end

			menuButton.rightIcon:SetWidth(rightIconSettings[2])
			menuButton.rightIcon:SetHeight(rightIconSettings[3])
			menuButton.rightIcon:SetTexCoord(rightIconSettings[4], rightIconSettings[5], rightIconSettings[6], rightIconSettings[7])

			local colorRed, colorGreen, colorBlue, colorAlpha = DF:ParseColors(rightIconSettings[8])
			menuButton.rightIcon:SetVertexColor(colorRed, colorGreen, colorBlue, colorAlpha)

			if (gameCooltip.OptionsTable.IconBlendMode) then
				menuButton.rightIcon:SetBlendMode(gameCooltip.OptionsTable.IconBlendMode)
			else
				menuButton.rightIcon:SetBlendMode("BLEND")
			end

			menuButton.rightIcon:SetDesaturated(rightIconSettings[9])
		else
			menuButton.rightIcon:SetTexture("")
			menuButton.rightIcon:SetWidth(1)
			menuButton.rightIcon:SetHeight(1)

			if (menuButton.customRightTexture) then
				menuButton.customRightTexture:Hide()
				menuButton.customRightTexture = nil
			end
		end

		--overwrite icon size
		if (gameCooltip.OptionsTable.IconSize) then
			menuButton.leftIcon:SetWidth(gameCooltip.OptionsTable.IconSize)
			menuButton.leftIcon:SetHeight(gameCooltip.OptionsTable.IconSize)
			menuButton.rightIcon:SetWidth(gameCooltip.OptionsTable.IconSize)
			menuButton.rightIcon:SetHeight(gameCooltip.OptionsTable.IconSize)
		end

		menuButton.leftText:SetHeight(0)
		menuButton.rightText:SetHeight(0)

		if (gameCooltip.Type == 2) then
			gameCooltip:LeftTextSpace(menuButton)
		end
		if (gameCooltip.OptionsTable.LeftTextHeight) then
			menuButton.leftText:SetHeight(gameCooltip.OptionsTable.LeftTextHeight)
		end
		if (gameCooltip.OptionsTable.RightTextHeight) then
			menuButton.rightText:SetHeight(gameCooltip.OptionsTable.RightTextHeight)
		end

		--string length
		if (not isSecondFrame) then --main frame
			if (not gameCooltip.OptionsTable.FixedWidth) then
				if (gameCooltip.Type == 1 or gameCooltip.Type == 2) then
					local stringWidth = menuButton.leftText:GetStringWidth() + menuButton.rightText:GetStringWidth() + menuButton.leftIcon:GetWidth() + menuButton.rightIcon:GetWidth() + 10
					if (stringWidth > frame.w) then
						frame.w = stringWidth
					end
				end
			else
				menuButton.leftText:SetWidth(gameCooltip.OptionsTable.FixedWidth - menuButton.leftIcon:GetWidth() - menuButton.rightText:GetStringWidth() - menuButton.rightIcon:GetWidth() - 22)
			end
		else
			if (not gameCooltip.OptionsTable.FixedWidthSub) then
				if (gameCooltip.Type == 1 or gameCooltip.Type == 2) then
					local stringWidth = menuButton.leftText:GetStringWidth() + menuButton.rightText:GetStringWidth() + menuButton.leftIcon:GetWidth() + menuButton.rightIcon:GetWidth()
					if (stringWidth > frame.w) then
						frame.w = stringWidth
					end
				end
			else
				menuButton.leftText:SetWidth(gameCooltip.OptionsTable.FixedWidthSub - menuButton.leftIcon:GetWidth() - 12)
			end
		end

		local height = max(menuButton.leftIcon:GetHeight(), menuButton.rightIcon:GetHeight(), menuButton.leftText:GetStringHeight(), menuButton.rightText:GetStringHeight())
		if (height > frame.hHeight) then
			frame.hHeight = height
		end
	end

	function gameCooltip:RefreshSpark(menuButton)
		local sparkTexture = gameCooltip.OptionsTable.SparkTexture or menuButton.spark.originalTexture
		local sparkAlpha = gameCooltip.OptionsTable.SparkAlpha or 1
		local sparkColor = gameCooltip.OptionsTable.SparkColor or "white"

		local sparkWidth = gameCooltip.OptionsTable.SparkWidth or menuButton.spark.originalWidth
		local sparkHeight = gameCooltip.OptionsTable.SparkHeight or menuButton.spark.originalHeight
		local sparkWidthOffset = gameCooltip.OptionsTable.SparkWidthOffset or 0
		local sparkHeightOffset = gameCooltip.OptionsTable.SparkHeightOffset or  0
		local positionXOffset = gameCooltip.OptionsTable.SparkPositionXOffset or 0
		local positionYOffset = gameCooltip.OptionsTable.SparkPositionYOffset or 0

		menuButton.spark:SetSize(sparkWidth + sparkWidthOffset, sparkHeight + sparkHeightOffset)
		menuButton.spark:SetTexture(sparkTexture)
		menuButton.spark:SetVertexColor(DF:ParseColors(sparkColor))
		menuButton.spark:SetAlpha(sparkAlpha)

		menuButton.spark:ClearAllPoints()
		menuButton.spark:SetPoint("left", menuButton.statusbar, "left", (menuButton.statusbar:GetValue() * (menuButton.statusbar:GetWidth() / 100)) - 5 + positionXOffset, 0 + positionYOffset)
		menuButton.spark2:ClearAllPoints()
		menuButton.spark2:SetPoint("left", menuButton.statusbar, "left", menuButton.statusbar:GetValue() * (menuButton.statusbar:GetWidth()/100) - 16 + positionXOffset, 0 + positionYOffset)
	end

	function gameCooltip:StatusBar(menuButton, statusBarSettings)
		if (statusBarSettings) then
			menuButton.statusbar:SetValue(Clamp(statusBarSettings[1], 0, maxStatusBarValue))
			menuButton.statusbar:SetStatusBarColor(statusBarSettings[2], statusBarSettings[3], statusBarSettings[4], statusBarSettings[5])
			menuButton.statusbar:SetHeight(20 + (gameCooltip.OptionsTable.StatusBarHeightMod or 0))

			menuButton.spark2:Hide()
			if (statusBarSettings[6]) then
				menuButton.spark:Show()
			else
				menuButton.spark:Hide()
			end

			if (statusBarSettings[7]) then
				menuButton.statusbar2:SetValue(Clamp(statusBarSettings[7].value, 0, maxStatusBarValue))
				menuButton.statusbar2.texture:SetTexture(statusBarSettings[7].texture or [[Interface\RaidFrame\Raid-Bar-Hp-Fill]])
				if (statusBarSettings[7].specialSpark) then
					menuButton.spark2:Show()
				end
				if (statusBarSettings[7].color) then
					local colorRed, colorGreen, colorBlue, colorAlpha = DF:ParseColors(statusBarSettings[7].color)
					menuButton.statusbar2:SetStatusBarColor(colorRed, colorGreen, colorBlue, colorAlpha)
				else
					menuButton.statusbar2:SetStatusBarColor(1, 1, 1, 1)
				end
			else
				menuButton.statusbar2:SetValue(0)
				menuButton.spark2:Hide()
			end

			if (statusBarSettings[8]) then
				local texture = SharedMedia:Fetch("statusbar", statusBarSettings[8], true)
				if (texture) then
					menuButton.statusbar.texture:SetTexture(texture)
				else
					menuButton.statusbar.texture:SetTexture(statusBarSettings[8])
				end
			elseif (gameCooltip.OptionsTable.StatusBarTexture) then
				local texture = SharedMedia:Fetch("statusbar", gameCooltip.OptionsTable.StatusBarTexture, true)
				if (texture) then
					menuButton.statusbar.texture:SetTexture(texture)
				else
					menuButton.statusbar.texture:SetTexture(gameCooltip.OptionsTable.StatusBarTexture)
				end
			else
				menuButton.statusbar.texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
			end
		else
			menuButton.statusbar:SetValue(0)
			menuButton.statusbar2:SetValue(0)
			menuButton.spark:Hide()
			menuButton.spark2:Hide()
		end

		if (gameCooltip.OptionsTable.LeftBorderSize) then
			menuButton.statusbar:SetPoint("left", menuButton, "left", 10 + gameCooltip.OptionsTable.LeftBorderSize, 0)
		else
			menuButton.statusbar:SetPoint("left", menuButton, "left", 10, 0)
		end

		if (gameCooltip.OptionsTable.RightBorderSize) then
			menuButton.statusbar:SetPoint("right", menuButton, "right", gameCooltip.OptionsTable.RightBorderSize + (- 10), 0)
		else
			menuButton.statusbar:SetPoint("right", menuButton, "right", -10, 0)
		end
	end

	function gameCooltip:SetupMainButton(menuButton, index)
		menuButton.index = index
		--setup texts and icons
		gameCooltip:TextAndIcon(index, frame1, menuButton, gameCooltip.LeftTextTable[index], gameCooltip.RightTextTable[index], gameCooltip.LeftIconTable[index], gameCooltip.RightIconTable[index])
		--setup statusbar
		gameCooltip:StatusBar(menuButton, gameCooltip.StatusBarTable[index])
		--click
		menuButton:RegisterForClicks("LeftButtonDown")

		--string length
		if (not gameCooltip.OptionsTable.FixedWidth) then
			local stringWidth = menuButton.leftText:GetStringWidth() + menuButton.rightText:GetStringWidth() + menuButton.leftIcon:GetWidth() + menuButton.rightIcon:GetWidth()
			if (stringWidth > frame1.w) then
				frame1.w = stringWidth
			end
		end

		--register click function
		menuButton:SetScript("OnClick", OnClickFunctionMainButton)
		menuButton:Show()
	end

	function gameCooltip:SetupButtonOnSecondFrame(menuButton, index, mainMenuIndex)
		menuButton.index = index
		menuButton.mainIndex = mainMenuIndex

		--setup texts and icons
		gameCooltip:TextAndIcon(index, frame2, menuButton, gameCooltip.LeftTextTableSub[mainMenuIndex] and gameCooltip.LeftTextTableSub[mainMenuIndex][index],
		gameCooltip.RightTextTableSub[mainMenuIndex] and gameCooltip.RightTextTableSub[mainMenuIndex][index],
		gameCooltip.LeftIconTableSub[mainMenuIndex] and gameCooltip.LeftIconTableSub[mainMenuIndex][index],
		gameCooltip.RightIconTableSub[mainMenuIndex] and gameCooltip.RightIconTableSub[mainMenuIndex][index], true)

		--setup statusbar
		gameCooltip:StatusBar(menuButton, gameCooltip.StatusBarTableSub[mainMenuIndex] and gameCooltip.StatusBarTableSub[mainMenuIndex][index])

		--click
		menuButton:RegisterForClicks("LeftButtonDown")

		menuButton:ClearAllPoints()
		menuButton:SetPoint("center", frame2, "center")
		menuButton:SetPoint("top", frame2, "top", 0, (((index-1) * 20) * -1) -3)
		menuButton:SetPoint("left", frame2, "left", -4, 0)
		menuButton:SetPoint("right", frame2, "right", 4, 0)

		DF:FadeFrame(menuButton, 0)

		--string length
		local stringWidth = menuButton.leftText:GetStringWidth() + menuButton.rightText:GetStringWidth() + menuButton.leftIcon:GetWidth() + menuButton.rightIcon:GetWidth()
		if (stringWidth > frame2.w) then
			frame2.w = stringWidth
		end

		menuButton:SetScript("OnClick", OnClickFunctionSecondaryButton)
		menuButton:Show()
		return true
	end

	------------------------------------------------------------------------------------------------------------------

	function gameCooltip:SetupWallpaper(wallpaperTable, wallpaper)
		local texture = wallpaperTable[1]
		if (DF:IsHtmlColor(texture) or type(texture) == "table") then
			local color = texture
			local r, g, b, a = DF:ParseColors(color)
			wallpaper:SetColorTexture(r, g, b, a)
		else
			wallpaper:SetTexture(texture)
		end

		wallpaper:SetTexCoord(wallpaperTable[2], wallpaperTable[3], wallpaperTable[4], wallpaperTable[5])

		local color = wallpaperTable[6]
		if (color) then
			local r, g, b, a = DF:ParseColors(color)
			wallpaper:SetVertexColor(r, g, b, a)
		else
			wallpaper:SetVertexColor(1, 1, 1, 1)
		end

		if (wallpaperTable[7]) then
			wallpaper:SetDesaturated(true)
		else
			wallpaper:SetDesaturated(false)
		end

		wallpaper:Show()
	end

	------------------------------------------------------------------------------------------------------------------

	function gameCooltip:ShowSub(index)
		if (gameCooltip.OptionsTable.IgnoreSubMenu) then
			DF:FadeFrame(frame2, 1)
			return
		end

		frame2:SetHeight(6)
		local amountIndexes = gameCooltip.IndexesSub[index]
		if (not amountIndexes) then
			--sub menu called but sub menu indexes is nil
			return
		end

		if (gameCooltip.OptionsTable.FixedWidthSub) then
			frame2:SetWidth(gameCooltip.OptionsTable.FixedWidthSub)
		end

		frame2.h = gameCooltip.IndexesSub[index] * 20
		frame2.hHeight = 0
		frame2.w = 0

		local isTooltip = gameCooltip.OptionsTable.SubMenuIsTooltip
		if (isTooltip) then
			frame2:EnableMouse(false)
		else
			frame2:EnableMouse(true)
		end

		for i = 1, gameCooltip.IndexesSub[index] do
			local button = frame2.Lines[i]
			if (not button) then
				button = gameCooltip:CreateButtonOnSecondFrame(i)
			end
			gameCooltip:SetupButtonOnSecondFrame(button, i, index)

			if (isTooltip) then
				button:EnableMouse(false)
			else
				button:EnableMouse(true)
			end
		end

		local selected = gameCooltip.SelectedIndexSec[index]
		if (selected) then
			gameCooltip:SetSelectedAnchor(frame2, frame2.Lines[selected])
			if (not gameCooltip.OptionsTable.NoLastSelectedBar) then
				gameCooltip:ShowSelectedTexture(frame2)
			end
		else
			gameCooltip:HideSelectedTexture(frame2)
		end

		for i = gameCooltip.IndexesSub[index] + 1, #frame2.Lines do
			DF:FadeFrame(frame2.Lines[i], 1)
		end

		local spacing = 0
		if (gameCooltip.OptionsTable.YSpacingModSub) then
			spacing = gameCooltip.OptionsTable.YSpacingModSub
		end

		--normalize height of all rows
		for i = 1, gameCooltip.IndexesSub[index] do
			local menuButton = frame2.Lines[i]

			if (menuButton.leftText:GetText() == "$div") then
				menuButton:SetHeight(4)

				--points
				menuButton:ClearAllPoints()
				menuButton:SetPoint("center", frame2, "center")
				menuButton:SetPoint("left", frame2, "left", -4, 0)
				menuButton:SetPoint("right", frame2, "right", 4, 0)

				menuButton.rightText:SetText("")

				local divisorOffsetTop = tonumber(gameCooltip.RightTextTableSub[index][i][2])
				if (not divisorOffsetTop) then
					divisorOffsetTop = 0
				end
				local divisorOffsetBottom = tonumber(gameCooltip.RightTextTableSub[index][i][3])
				if (not divisorOffsetBottom) then
					divisorOffsetBottom = 0
				end

				menuButton:SetPoint("top", frame2, "top", 0, ( ( (i-1) * frame2.hHeight) * -1) - 4 + (gameCooltip.OptionsTable.ButtonsYModSub or 0) + spacing + (2 + (divisorOffsetTop or 0)))

				if (gameCooltip.OptionsTable.YSpacingModSub) then
					spacing = spacing + gameCooltip.OptionsTable.YSpacingModSub
				end

				spacing = spacing + 17 + (divisorOffsetBottom or 0)

				menuButton.leftText:SetText("")
				menuButton.isDiv = true

				if (not menuButton.divbar) then
					gameCooltip:CreateDivBar(menuButton)
				else
					menuButton.divbar:Show()
				end

				menuButton.divbar:SetPoint("left", menuButton, "left", frame1:GetWidth() * 0.10, 0)
				menuButton.divbar:SetPoint("right", menuButton, "right", -frame1:GetWidth() * 0.10, 0)

			else
				menuButton:SetHeight(frame2.hHeight + (gameCooltip.OptionsTable.ButtonHeightModSub or 0))

				--points
				menuButton:ClearAllPoints()
				menuButton:SetPoint("center", frame2, "center")
				menuButton:SetPoint("top", frame2, "top", 0, ( ( (i-1) * frame2.hHeight) * -1) - 4 + (gameCooltip.OptionsTable.ButtonsYModSub or 0) + spacing)

				if (gameCooltip.OptionsTable.YSpacingModSub) then
					spacing = spacing + gameCooltip.OptionsTable.YSpacingModSub
				end

				menuButton:SetPoint("left", frame2, "left", -4, 0)
				menuButton:SetPoint("right", frame2, "right", 4, 0)

				if (menuButton.divbar) then
					menuButton.divbar:Hide()
					menuButton.isDiv = false
				end
			end
		end

		local mod = gameCooltip.OptionsTable.HeighModSub or 0
		frame2:SetHeight((frame2.hHeight * gameCooltip.IndexesSub[index]) + 12 + (-spacing) + mod)

		if (gameCooltip.TopIconTableSub[index]) then
			local upperImageTable = gameCooltip.TopIconTableSub[index]
			frame2.upperImage:SetTexture(upperImageTable[1])
			frame2.upperImage:SetWidth(upperImageTable[2])
			frame2.upperImage:SetHeight(upperImageTable[3])
			frame2.upperImage:SetTexCoord(upperImageTable[4], upperImageTable[5], upperImageTable[6], upperImageTable[7])
			frame2.upperImage:Show()
		else
			frame2.upperImage:Hide()
		end

		if (gameCooltip.WallpaperTableSub[index]) then
			gameCooltip:SetupWallpaper(gameCooltip.WallpaperTableSub[index], frame2.frameWallpaper)
		else
			frame2.frameWallpaper:Hide()
		end

		if (not gameCooltip.OptionsTable.FixedWidthSub) then
			frame2:SetWidth(frame2.w + 44)
		end

		DF:FadeFrame(frame2, 0)
		gameCooltip:CheckOverlap()

		if (gameCooltip.OptionsTable.SubFollowButton and not gameCooltip.frame2_IsOnLeftside) then
			local button = frame1.Lines[index]
			frame2:ClearAllPoints()
			frame2:SetPoint("left", button, "right", 4, 0)

		elseif (gameCooltip.OptionsTable.SubFollowButton and gameCooltip.frame2_IsOnLeftside) then
			local button = frame1.Lines[index]
			frame2:ClearAllPoints()
			frame2:SetPoint("right", button, "left", -4, 0)

		elseif (gameCooltip.frame2_IsOnLeftside) then
			frame2:ClearAllPoints()
			frame2:SetPoint("bottomright", frame1, "bottomleft", -4, 0)
		else
			frame2:ClearAllPoints()
			frame2:SetPoint("bottomleft", frame1, "bottomright", 4, 0)
		end
	end

	function gameCooltip:HideSub()
		DF:FadeFrame(frame2, 1)
	end

	function gameCooltip:LeftTextSpace(row)
		row.leftText:SetWidth(row:GetWidth() - 30 - row.leftIcon:GetWidth() - row.rightIcon:GetWidth() - row.rightText:GetStringWidth())
		row.leftText:SetHeight(10)
	end

	--~inicio ~start ~tooltip
	function gameCooltip:BuildTooltip()
		--hide sub frame
		DF:FadeFrame(frame2, 1)
		--hide select bar
		gameCooltip:HideSelectedTexture(frame1)

		frame1:EnableMouse(false)

		--width
		if (gameCooltip.OptionsTable.FixedWidth) then
			frame1:SetWidth(gameCooltip.OptionsTable.FixedWidth)
		end

		frame1.w = gameCooltip.OptionsTable.FixedWidth or 0
		frame1.hHeight = 0
		frame2.hHeight = 0
		gameCooltip.active = true

		for i = 1, gameCooltip.Indexes do
			local button = frame1.Lines[i]
			if (not button) then
				button = gameCooltip:CreateMainFrameButton(i)
			end

			button.index = i

			button:Show()
			button.background:Hide()
			button:SetHeight(gameCooltip.OptionsTable.ButtonHeightMod or gameCooltip.default_height)

			--clear registered click buttons
			button:RegisterForClicks()

			--setup texts and icons
			gameCooltip:TextAndIcon(i, frame1, button, gameCooltip.LeftTextTable[i], gameCooltip.RightTextTable[i], gameCooltip.LeftIconTable[i], gameCooltip.RightIconTable[i])
			--setup statusbar
			gameCooltip:StatusBar(button, gameCooltip.StatusBarTable[i])
		end

		--hide unused lines
		for i = gameCooltip.Indexes+1, #frame1.Lines do
			frame1.Lines[i]:Hide()
		end
		gameCooltip.NumLines = gameCooltip.Indexes

		local spacing = 0
		if (gameCooltip.OptionsTable.YSpacingMod) then
			spacing = gameCooltip.OptionsTable.YSpacingMod
		end

		--normalize height of all rows
		local heightValue = -6 + spacing + (gameCooltip.OptionsTable.ButtonsYMod or 0)
		for i = 1, gameCooltip.Indexes do
			local menuButton = frame1.Lines[i]

			menuButton:ClearAllPoints()
			menuButton:SetPoint("center", frame1, "center")
			menuButton:SetPoint("left", frame1, "left", -4, 0)
			menuButton:SetPoint("right", frame1, "right", 4, 0)

			if (menuButton.divbar) then
				menuButton.divbar:Hide()
				menuButton.isDiv = false
			end

			--height
			if (gameCooltip.OptionsTable.AlignAsBlizzTooltip) then
				local height = max(2, menuButton.leftText:GetStringHeight(), menuButton.rightText:GetStringHeight(), menuButton.leftIcon:GetHeight(), menuButton.rightIcon:GetHeight(), gameCooltip.OptionsTable.AlignAsBlizzTooltipForceHeight or 2)
				menuButton:SetHeight(height)
				menuButton:SetPoint("top", frame1, "top", 0, heightValue)
				heightValue = heightValue + (height * -1)

			elseif (gameCooltip.OptionsTable.IgnoreButtonAutoHeight) then
				local height = max(menuButton.leftText:GetStringHeight(), menuButton.rightText:GetStringHeight(), menuButton.leftIcon:GetHeight(), menuButton.rightIcon:GetHeight())
				menuButton:SetHeight(height)
				menuButton:SetPoint("top", frame1, "top", 0, heightValue)
				heightValue = heightValue + (height * -1) + spacing + (gameCooltip.OptionsTable.ButtonsYMod or 0)

			else
				menuButton:SetHeight(frame1.hHeight + (gameCooltip.OptionsTable.ButtonHeightMod or 0))
				menuButton:SetPoint("top", frame1, "top", 0, (((i-1) * frame1.hHeight) * -1) - 6 + (gameCooltip.OptionsTable.ButtonsYMod or 0) + spacing)
			end

			if (gameCooltip.OptionsTable.YSpacingMod and not gameCooltip.OptionsTable.IgnoreButtonAutoHeight) then
				spacing = spacing + gameCooltip.OptionsTable.YSpacingMod
			end

			menuButton:EnableMouse(false)
		end

		if (not gameCooltip.OptionsTable.FixedWidth) then
			if (gameCooltip.Type == 2) then --with bars
				if (gameCooltip.OptionsTable.MinWidth) then
					local width = frame1.w + 34
					PixelUtil.SetWidth(frame1, math.max(width, gameCooltip.OptionsTable.MinWidth))
				else
					PixelUtil.SetWidth(frame1, frame1.w + 34)
				end
			else
				--width stability check
				local width = frame1.w + 24
				if (width > gameCooltip.LastSize - 5 and width < gameCooltip.LastSize + 5) then
					width = gameCooltip.LastSize
				else
					gameCooltip.LastSize = width
				end

				if (gameCooltip.OptionsTable.MinWidth) then
					PixelUtil.SetWidth(frame1, math.max(width, gameCooltip.OptionsTable.MinWidth))
				else
					PixelUtil.SetWidth(frame1, width)
				end
			end
		end

		if (gameCooltip.OptionsTable.FixedHeight) then
			PixelUtil.SetHeight(frame1, gameCooltip.OptionsTable.FixedHeight)
		else
			if (gameCooltip.OptionsTable.AlignAsBlizzTooltip) then
				PixelUtil.SetHeight(frame1, ((heightValue - 10) * -1) + (gameCooltip.OptionsTable.AlignAsBlizzTooltipFrameHeightOffset or 0))

			elseif (gameCooltip.OptionsTable.IgnoreButtonAutoHeight) then
				PixelUtil.SetHeight(frame1, (heightValue + spacing) * -1)

			else
				PixelUtil.SetHeight(frame1, max((frame1.hHeight * gameCooltip.Indexes) + 8 + ((gameCooltip.OptionsTable.ButtonsYMod or 0) * -1), 22))
			end
		end

		if (gameCooltip.WallpaperTable[1]) then
			gameCooltip:SetupWallpaper(gameCooltip.WallpaperTable, frame1.frameWallpaper)
		else
			frame1.frameWallpaper:Hide()
		end

		--unhide frame
		DF:FadeFrame(frame1, 0)
		gameCooltip:SetMyPoint()

		--fix sparks
		for i = 1, gameCooltip.Indexes do
			local menuButton = frame1.Lines[i]
			if (menuButton.spark:IsShown() or menuButton.spark2:IsShown()) then
				gameCooltip:RefreshSpark(menuButton)
			end
		end
	end

	function gameCooltip:CreateDivBar(button)
		button.divbar = button:CreateTexture(nil, "overlay")
		button.divbar:SetTexture([[Interface\QUESTFRAME\AutoQuest-Parts]])
		button.divbar:SetTexCoord(238/512, 445/512, 0/64, 4/64)
		button.divbar:SetHeight(3)
		button.divbar:SetAlpha(0.1)
		button.divbar:SetDesaturated(true)
	end

	--~inicio ~start ~menu
	function gameCooltip:BuildCooltip(host)
		if (gameCooltip.Indexes == 0) then
			gameCooltip:Reset()
			gameCooltip:SetType(CONST_COOLTIP_TYPE_TOOLTIP)
			gameCooltip:AddLine("There is no options.")
			gameCooltip:ShowCooltip()
			return
		end

		if (gameCooltip.OptionsTable.FixedWidth) then
			frame1:SetWidth(gameCooltip.OptionsTable.FixedWidth)
		end

		frame1.w = gameCooltip.OptionsTable.FixedWidth or 0
		frame1.hHeight = 0
		frame2.hHeight = 0

		frame1:EnableMouse(true)

		if (gameCooltip.HaveSubMenu) then
			frame2.w = 0
			frame2:SetHeight(6)
			if (gameCooltip.SelectedIndexMain and gameCooltip.IndexesSub[gameCooltip.SelectedIndexMain] and gameCooltip.IndexesSub[gameCooltip.SelectedIndexMain] > 0) then
				DF:FadeFrame(frame2, 0)
			else
				DF:FadeFrame(frame2, 1)
			end
		else
			DF:FadeFrame(frame2, 1)
		end

		gameCooltip.active = true

		for i = 1, gameCooltip.Indexes do
			local menuButton = frame1.Lines[i]
			if (not menuButton) then
				menuButton = gameCooltip:CreateMainFrameButton(i)
			end
			gameCooltip:SetupMainButton(menuButton, i)
			menuButton.background:Hide()
		end

		--selected texture
		if (gameCooltip.SelectedIndexMain) then
			gameCooltip:SetSelectedAnchor(frame1, frame1.Lines[gameCooltip.SelectedIndexMain])

			if (gameCooltip.OptionsTable.NoLastSelectedBar) then
				gameCooltip:HideSelectedTexture(frame1)
			else
				gameCooltip:ShowSelectedTexture(frame1)
			end
		else
			gameCooltip:HideSelectedTexture(frame1)
		end

		if (gameCooltip.Indexes < #frame1.Lines) then
			for i = gameCooltip.Indexes+1, #frame1.Lines do
				frame1.Lines[i]:Hide()
			end
		end

		gameCooltip.NumLines = gameCooltip.Indexes

		local spacing = 0
		if (gameCooltip.OptionsTable.YSpacingMod) then
			spacing = gameCooltip.OptionsTable.YSpacingMod
		end

		if (not gameCooltip.OptionsTable.FixedWidth) then
			if (gameCooltip.OptionsTable.MinWidth) then
				local w = frame1.w + 24
				frame1:SetWidth(math.max(w, gameCooltip.OptionsTable.MinWidth))
			else
				frame1:SetWidth(frame1.w + 24)
			end
		end

		--normalize height of all rows
		for i = 1, gameCooltip.Indexes do
			local menuButton = frame1.Lines[i]
			menuButton:EnableMouse(true)

			if (menuButton.leftText:GetText() == "$div") then
				--height
				menuButton:SetHeight(4)
				--points
				menuButton:ClearAllPoints()
				menuButton:SetPoint("left", frame1, "left", -4, 0)
				menuButton:SetPoint("right", frame1, "right", 4, 0)
				menuButton:SetPoint("center", frame1, "center")

				local divisorOffsetTop = tonumber(gameCooltip.LeftTextTable[i][2])
				if (not divisorOffsetTop) then
					divisorOffsetTop = 0
				end
				local divisorOffsetBottom = tonumber(gameCooltip.LeftTextTable[i][3])
				if (not divisorOffsetBottom) then
					divisorOffsetBottom = 0
				end

				menuButton:SetPoint("top", frame1, "top", 0, ( ( (i-1) * frame1.hHeight) * -1) - 4 + (gameCooltip.OptionsTable.ButtonsYMod or 0) + spacing - 4 + divisorOffsetTop)
				if (gameCooltip.OptionsTable.YSpacingMod) then
					spacing = spacing + gameCooltip.OptionsTable.YSpacingMod
				end

				spacing = spacing + 4 + divisorOffsetBottom

				menuButton.leftText:SetText("")
				menuButton.isDiv = true

				if (not menuButton.divbar) then
					gameCooltip:CreateDivBar(menuButton)
				else
					menuButton.divbar:Show()
				end

				menuButton.divbar:SetPoint("left", menuButton, "left", frame1:GetWidth() * 0.10, 0)
				menuButton.divbar:SetPoint("right", menuButton, "right", -frame1:GetWidth() * 0.10, 0)
			else
				--height
				menuButton:SetHeight(frame1.hHeight + (gameCooltip.OptionsTable.ButtonHeightMod or 0))
				--points
				menuButton:ClearAllPoints()
				menuButton:SetPoint("center", frame1, "center")
				menuButton:SetPoint("top", frame1, "top", 0, ( ( (i-1) * frame1.hHeight) * -1) - 4 + (gameCooltip.OptionsTable.ButtonsYMod or 0) + spacing)
				if (gameCooltip.OptionsTable.YSpacingMod) then
					spacing = spacing + gameCooltip.OptionsTable.YSpacingMod
				end
				menuButton:SetPoint("left", frame1, "left", -4, 0)
				menuButton:SetPoint("right", frame1, "right", 4, 0)

				if (menuButton.divbar) then
					menuButton.divbar:Hide()
					menuButton.isDiv = false
				end
			end
		end

		if (gameCooltip.OptionsTable.FixedHeight) then
			frame1:SetHeight(gameCooltip.OptionsTable.FixedHeight)
		else
			local mod = gameCooltip.OptionsTable.HeighMod or 0
			frame1:SetHeight(max((frame1.hHeight * gameCooltip.Indexes) + 12 + (-spacing) + mod, 22))
		end

		--sub menu arrows
		if (gameCooltip.HaveSubMenu and not gameCooltip.OptionsTable.IgnoreArrows and not gameCooltip.OptionsTable.SubMenuIsTooltip) then
			for i = 1, gameCooltip.Indexes do
				if (gameCooltip.IndexesSub[i] and gameCooltip.IndexesSub[i] > 0) then
					frame1.Lines[i].statusbar.subMenuArrow:Show()
				else
					frame1.Lines[i].statusbar.subMenuArrow:Hide()
				end
			end
			frame1:SetWidth(frame1:GetWidth() + 16)
		end

		frame1:ClearAllPoints()
		gameCooltip:SetMyPoint(host)

		if (gameCooltip.title1) then
			gameCooltip.frame1.titleText:Show()
			gameCooltip.frame1.titleIcon:Show()
			gameCooltip.frame1.titleText:SetText(gameCooltip.title_text)
			gameCooltip.frame1.titleIcon:SetWidth(frame1:GetWidth())
			gameCooltip.frame1.titleIcon:SetHeight(40)
		end

		if (gameCooltip.WallpaperTable[1]) then
			gameCooltip:SetupWallpaper(gameCooltip.WallpaperTable, frame1.frameWallpaper)
		else
			frame1.frameWallpaper:Hide()
		end

		DF:FadeFrame(frame1, 0)

		for i = 1, gameCooltip.Indexes do
			if (gameCooltip.SelectedIndexMain and gameCooltip.SelectedIndexMain == i) then
				if (gameCooltip.HaveSubMenu and gameCooltip.IndexesSub[i] and gameCooltip.IndexesSub[i] > 0) then
					gameCooltip:ShowSub(i)
				end
			end
		end

		return true
	end

	function gameCooltip:SetMyPoint(host, xOffset, yOffset)
		local moveX = xOffset or 0
		local moveY = yOffset or 0
		local anchor = gameCooltip.OptionsTable.Anchor or gameCooltip.Host

		frame1:ClearAllPoints()
		PixelUtil.SetPoint(frame1, gameCooltip.OptionsTable.MyAnchor, anchor, gameCooltip.OptionsTable.RelativeAnchor, 0 + moveX + gameCooltip.OptionsTable.WidthAnchorMod, 10 + gameCooltip.OptionsTable.HeightAnchorMod + moveY)

		if (not xOffset) then
			--check if cooltip is out of screen bounds
			local centerX = frame1:GetCenter()

			if (centerX) then
				local screenWidth = GetScreenWidth()
				local halfScreenWidth = frame1:GetWidth() / 2

				if (centerX + halfScreenWidth > screenWidth) then
					--out of right side
					local moveLeftOffset = (centerX + halfScreenWidth) - screenWidth
					gameCooltip.internal_x_mod = -moveLeftOffset
					return gameCooltip:SetMyPoint(host, -moveLeftOffset, 0)

				elseif (centerX - halfScreenWidth < 0) then
					--out of left side
					local moveRightOffset = centerX - halfScreenWidth
					gameCooltip.internal_x_mod = moveRightOffset * -1
					return gameCooltip:SetMyPoint(host, moveRightOffset * -1, 0)
				end
			end
		end

		if (not yOffset) then
			--check if cooltip is out of screen bounds
			local _, centerY = frame1:GetCenter()
			local screenHeight = GetScreenHeight()
			local helpScreenHeight = frame1:GetHeight() / 2

			if (centerY) then
				if (centerY + helpScreenHeight > screenHeight) then
					--out of top side
					local moveDownOffset = (centerY + helpScreenHeight) - screenHeight
					gameCooltip.internal_y_mod = -moveDownOffset
					return gameCooltip:SetMyPoint(host, 0, -moveDownOffset)

				elseif (centerY - helpScreenHeight < 0) then
					--out of bottom side
					local moveUpOffset = centerY - helpScreenHeight
					gameCooltip.internal_y_mod = moveUpOffset * -1
					return gameCooltip:SetMyPoint(host, 0, moveUpOffset * -1)
				end
			end
		end

		if (frame2:IsShown() and not gameCooltip.overlap_checked) then
			local frame2CenterX = frame2:GetCenter()
			if (frame2CenterX) then
				local frame2HalfWidth = frame2:GetWidth() / 2
				local frame1CenterX = frame1:GetCenter()
				if (frame1CenterX) then
					local frame1HalfWidth = frame1:GetWidth() / 2
					local frame1EndPoint = frame1CenterX + frame1HalfWidth - 3
					local frame2StartPoint = frame2CenterX - frame2HalfWidth

					if (frame2StartPoint < frame1EndPoint) then
						gameCooltip.overlap_checked = true
						frame2:ClearAllPoints()
						frame2:SetPoint("bottomright", frame1, "bottomleft", 4, 0)
						gameCooltip.frame2_leftside = true
						return gameCooltip:SetMyPoint(host, gameCooltip.internal_x_mod , gameCooltip.internal_y_mod)
					end
				end
			end
		end
	end

	function gameCooltip:CheckOverlap()
		if (frame2:IsShown()) then
			local xCenter = frame2:GetCenter()
			if (xCenter) then
				local frame2WidthHalf = frame2:GetWidth() / 2
				local frame1XCenter = frame1:GetCenter()
				if (frame1XCenter) then
					local frame1WidthHalf = frame1:GetWidth() / 2
					local frame1EndPoint = frame1XCenter + frame1WidthHalf - 3
					local frame2StartPoint = xCenter - frame2WidthHalf
					if (frame2StartPoint < frame1EndPoint) then
						frame2:ClearAllPoints()
						frame2:SetPoint("bottomright", frame1, "bottomleft", 4, 0)
						gameCooltip.frame2_IsOnLeftside = true
					end
				end
			end
		end
	end

	--retrive the left and right text shown on a line
	function gameCooltip:GetText(buttonIndex)
		local button1 = frame1.Lines[buttonIndex]
		if (not button1) then
			return "", ""
		else
			return button1.leftText:GetText() or "", button1.rightText:GetText() or ""
		end
	end

	--get the number of lines current shown on cooltip
	function gameCooltip:GetNumLines()
		return gameCooltip.NumLines or 0
	end

	--remove all options actived, set a option on current cooltip
	function gameCooltip:ClearAllOptions()
		for option in pairs(gameCooltip.OptionsTable) do
			gameCooltip.OptionsTable[option] = nil
		end
		gameCooltip:SetOption("MyAnchor", "bottom")
		gameCooltip:SetOption("RelativeAnchor", "top")
		gameCooltip:SetOption("WidthAnchorMod", 0)
		gameCooltip:SetOption("HeightAnchorMod", 0)
	end

	function gameCooltip:SetOption(optionName, value)
		--check for name alias
		optionName = gameCooltip.AliasList[optionName] or optionName
		--check if this options exists
		if (not gameCooltip.OptionsList[optionName]) then
			return gameCooltip:PrintDebug("SetOption() option not found:", optionName)
		end
		--set options
		gameCooltip.OptionsTable[optionName] = value
	end

	--return the current frame using cooltip
	function gameCooltip:GetOwner()
		return gameCooltip.Host
	end

	function gameCooltip:IsOwner(frame)
		local currentOwner = gameCooltip:GetOwner()
		return currentOwner == frame
	end

	--set the anchor of cooltip, parameters: frame [, cooltip anchor point, frame anchor point[, x mod, y mod]]
	function gameCooltip:SetOwner(frame, myPoint, hisPoint, x, y)
		return gameCooltip:SetHost(frame, myPoint, hisPoint, x, y)
	end

	function gameCooltip:SetHost(frame, myPoint, hisPoint, x, y)
		--check data integrity
		if (type(frame) ~= "table" or not frame.GetObjectType) then
			return gameCooltip:PrintDebug("SetHost() need a WOWObject.")
		end

		gameCooltip.Host = frame
		gameCooltip.frame1:SetFrameLevel(frame:GetFrameLevel() + 1)

		--defaults
		myPoint = myPoint or gameCooltip.OptionsTable.MyAnchor or "bottom"
		hisPoint = hisPoint or gameCooltip.OptionsTable.hisPoint or "top"

		x = x or gameCooltip.OptionsTable.WidthAnchorMod or 0
		y = y or gameCooltip.OptionsTable.HeightAnchorMod or 0

		--set options
		if (type(myPoint) == "string") then
			gameCooltip:SetOption("MyAnchor", myPoint)
			gameCooltip:SetOption("WidthAnchorMod", x)
		elseif (type(myPoint) == "number") then
			gameCooltip:SetOption("HeightAnchorMod", myPoint)
		end

		if (type(hisPoint) == "string") then
			gameCooltip:SetOption("RelativeAnchor", hisPoint)
			gameCooltip:SetOption("HeightAnchorMod", y)
		elseif (type(hisPoint) == "number") then
			gameCooltip:SetOption("WidthAnchorMod", hisPoint)
		end
	end

----------------------------------------------------------------------
	--set cooltip type
	--parameters: type(1 = tooltip | 2 = tooltip with bars | 3 = menu)

	--return if the current shown cooltip is a menu
	function gameCooltip:IsMenu()
		return gameCooltip.frame1:IsShown() and gameCooltip.Type == 3
	end

	--return if the current shown cooltip is a tooltip
	function gameCooltip:IsTooltip()
		return gameCooltip.frame1:IsShown() and (gameCooltip.Type == 1 or gameCooltip.Type == 2)
	end

	function gameCooltip:GetType()
		if (gameCooltip.Type == 1 or gameCooltip.Type == 2) then
			return CONST_COOLTIP_TYPE_TOOLTIP
		elseif (gameCooltip.Type == 3) then
			return CONST_COOLTIP_TYPE_MENU
		else
			return "none"
		end
	end

	function gameCooltip:SetType(newType)
		if (type(newType) == "string") then
			if (newType == CONST_COOLTIP_TYPE_TOOLTIP) then
				gameCooltip.Type = 1
			elseif (newType == "tooltipbar") then
				gameCooltip.Type = 2
			elseif (newType == CONST_COOLTIP_TYPE_MENU) then
				gameCooltip.Type = 3
			else
				return gameCooltip:PrintDebug("SetType() unknown type.", newType)
			end

		elseif (type(newType) == "number") then
			if (newType == 1) then
				gameCooltip.Type = 1
			elseif (newType == 2) then
				gameCooltip.Type = 2
			elseif (newType == 3) then
				gameCooltip.Type = 3
			else
				return gameCooltip:PrintDebug("SetType() unknown type.", newType)
			end
		else
			return gameCooltip:PrintDebug("SetType() unknown type.", newType)
		end
	end

	--set a fixed value for menu, the fixedValue is sent with the menu callback function
	function gameCooltip:SetFixedParameter(value, injected)
		if (injected ~= nil) then
			local frame = value
			if (frame.dframework) then
				frame = frame.widget
			end
			if (frame.CoolTip) then
				frame.CoolTip.FixedValue = injected
			end
		end
		gameCooltip.FixedValue = value
	end

	--set tooltip color
	function gameCooltip:SetColor(menuType, ...)
		local colorRed, colorGreen, colorBlue, colorAlpha = DF:ParseColors(...)
		menuType = gameCooltip:ParseMenuType(menuType)

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			frame1.frameBackgroundTexture:SetColorTexture(colorRed, colorGreen, colorBlue, colorAlpha)

			--hide textures from older versions if exists
			if (frame1.frameBackgroundLeft) then
				frame1.frameBackgroundLeft:Hide()
				frame1.frameBackgroundRight:Hide()
				frame1.frameBackgroundCenter:Hide()
			end

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			frame2.frameBackgroundTexture:SetColorTexture(colorRed, colorGreen, colorBlue, colorAlpha)

			--hide textures from older versions if exists
			if (frame2.frameBackgroundLeft) then
				frame2.frameBackgroundLeft:Hide()
				frame2.frameBackgroundRight:Hide()
				frame2.frameBackgroundCenter:Hide()
			end
		else
			return gameCooltip:PrintDebug("SetColor() unknown menuType.", menuType)
		end
	end

	--set last selected option
	function gameCooltip:SetLastSelected(menuType, index, index2)
		if (gameCooltip.Type == 3) then
			menuType = gameCooltip:ParseMenuType(menuType)

			if (menuType == CONST_MENU_TYPE_MAINMENU) then
				gameCooltip.SelectedIndexMain = index

			elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
				gameCooltip.SelectedIndexSec[index] = index2

			else
				return gameCooltip:PrintDebug("SetLastSelected() unknown menuType.", menuType)
			end
		else
			return gameCooltip:PrintDebug("SetLastSelected() current cooltip isn't a menu.")
		end
	end

	--serack key: ~select
	function gameCooltip:Select(menuType, option, mainIndex)
		if (menuType == 1) then --main menu
			local botao = frame1.Lines[option]
			gameCooltip.buttonClicked = true
			gameCooltip:SetSelectedAnchor(frame1, botao)

		elseif (menuType == 2) then --sub menu
			gameCooltip:ShowSub(mainIndex)
			local botao = frame2.Lines[option]
			gameCooltip.buttonClicked = true
			gameCooltip:SetSelectedAnchor(frame2, botao)
		end
	end

----------------------------------------------------------------------
	--wipe all data ~reset
	function gameCooltip:Reset(fromPreset)
		frame2:ClearAllPoints()
		frame2:SetPoint("bottomleft", frame1, "bottomright", 4, 0)
		frame1:SetWidth(170)
		frame2:SetWidth(170)

		frame1:SetParent(UIParent)
		frame2:SetParent(UIParent)
		frame1:SetFrameStrata("TOOLTIP")
		frame2:SetFrameStrata("TOOLTIP")

		gameCooltip:HideSelectedTexture(frame1)
		gameCooltip:HideSelectedTexture(frame2)

		gameCooltip.FixedValue = nil
		gameCooltip.HaveSubMenu = false
		gameCooltip.SelectedIndexMain = nil
		gameCooltip.Indexes =  0
		gameCooltip.SubIndexes = 0
		gameCooltip.internalYMod = 0
		gameCooltip.internalYMod = 0
		gameCooltip.current_anchor = nil
		gameCooltip.overlapChecked = false
		gameCooltip.frame2_IsOnLeftside = nil

		wipe(gameCooltip.SelectedIndexSec)
		wipe(gameCooltip.IndexesSub)
		wipe(gameCooltip.PopupFrameTable)

		wipe(gameCooltip.LeftTextTable)
		wipe(gameCooltip.LeftTextTableSub)
		wipe(gameCooltip.RightTextTable)
		wipe(gameCooltip.RightTextTableSub)

		wipe(gameCooltip.LeftIconTable)
		wipe(gameCooltip.LeftIconTableSub)
		wipe(gameCooltip.RightIconTable)
		wipe(gameCooltip.RightIconTableSub)

		wipe(gameCooltip.StatusBarTable)
		wipe(gameCooltip.StatusBarTableSub)

		wipe(gameCooltip.FunctionsTableMain)
		wipe(gameCooltip.FunctionsTableSub)

		wipe(gameCooltip.ParametersTableMain)
		wipe(gameCooltip.ParametersTableSub)

		wipe(gameCooltip.WallpaperTable)
		wipe(gameCooltip.WallpaperTableSub)

		wipe(gameCooltip.TopIconTableSub)
		gameCooltip.Banner[1] = false
		gameCooltip.Banner[2] = false
		gameCooltip.Banner[3] = false

		frame1.upperImage:Hide()
		frame1.upperImage2:Hide()
		frame1.upperImageText:Hide()
		frame1.upperImageText2:Hide()
		frame1.frameWallpaper:Hide()
		frame2.frameWallpaper:Hide()
		frame2.upperImage:Hide()

		gameCooltip.title1 = nil
		gameCooltip.title_text = nil
		gameCooltip.frame1.titleText:Hide()
		gameCooltip.frame1.titleIcon:Hide()

		gameCooltip:ClearAllOptions()
		gameCooltip:SetColor(1, "transparent")
		gameCooltip:SetColor(2, "transparent")

		for i = 1, #frame1.Lines do
			frame1.Lines[i].statusbar.subMenuArrow:Hide()
		end

		--older versions has these three textures
		if (frame1.frameBackgroundLeft) then
			frame1.frameBackgroundLeft:Hide()
			frame1.frameBackgroundRight:Hide()
			frame1.frameBackgroundCenter:Hide()
		end

		frame1.frameBackgroundTexture:SetColorTexture(0, 0, 0, 0)
		frame2.frameBackgroundTexture:SetColorTexture(0, 0, 0, 0)

		if (not fromPreset) then
			gameCooltip:Preset(3, true)
		end
	end

----------------------------------------------------------------------
	--menu functions
	local defaultWhiteColor = {1, 1, 1}
	function gameCooltip:AddMenu(menuType, func, param1, param2, param3, leftText, leftIcon, indexUp)
		menuType = gameCooltip:ParseMenuType(menuType)

		if (leftText and indexUp and (menuType == CONST_MENU_TYPE_MAINMENU)) then
			gameCooltip.Indexes = gameCooltip.Indexes + 1
			if (not gameCooltip.IndexesSub[gameCooltip.Indexes]) then
				gameCooltip.IndexesSub[gameCooltip.Indexes] = 0
			end
			gameCooltip.SubIndexes = 0
		end

		--need a previous line
		if (gameCooltip.Indexes == 0) then
			return gameCooltip:PrintDebug("AddMenu() requires an already added line (Cooltip:AddLine()).")
		end

		--check data integrity
		if (type(func) ~= "function") then
			return gameCooltip:PrintDebug("AddMenu() no function passed.")
		end

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			local parameterTable
			if (gameCooltip.isSpecial) then
				parameterTable = {}
				insert(gameCooltip.FunctionsTableMain, gameCooltip.Indexes, func)
				insert(gameCooltip.ParametersTableMain, gameCooltip.Indexes, parameterTable)
			else
				gameCooltip.FunctionsTableMain[gameCooltip.Indexes] = func
				parameterTable = gameCooltip.ParametersTableMain[gameCooltip.Indexes]
				if (not parameterTable) then
					parameterTable = {}
					gameCooltip.ParametersTableMain[gameCooltip.Indexes] = parameterTable
				end
			end

			parameterTable[1] = param1
			parameterTable[2] = param2
			parameterTable[3] = param3

			if (leftIcon) then
				local iconTable = gameCooltip.LeftIconTable[gameCooltip.Indexes]
				if (not iconTable or gameCooltip.isSpecial) then
					iconTable = {}
					gameCooltip.LeftIconTable[gameCooltip.Indexes] = iconTable
				end
				iconTable[1] = leftIcon
				iconTable[2] = 16 --default 16
				iconTable[3] = 16 --default 16
				iconTable[4] = 0 --default 0
				iconTable[5] = 1 --default 1
				iconTable[6] = 0 --default 0
				iconTable[7] = 1 --default 1
				iconTable[8] = defaultWhiteColor
			end

			if (leftText) then
				local lineTable_Left = gameCooltip.LeftTextTable[gameCooltip.Indexes]
				if (not lineTable_Left or gameCooltip.isSpecial) then
					lineTable_Left = {}
					gameCooltip.LeftTextTable[gameCooltip.Indexes] = lineTable_Left
				end
				lineTable_Left[1] = leftText
				lineTable_Left[2] = 0
				lineTable_Left[3] = 0
				lineTable_Left[4] = 0
				lineTable_Left[5] = 0
				lineTable_Left[6] = false
				lineTable_Left[7] = false
				lineTable_Left[8] = false
			end

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			if (gameCooltip.SubIndexes == 0) then
				if (not indexUp or not leftText) then
					return gameCooltip:PrintDebug("AddMenu() attempt to add a submenu with a parent.")
				end
			end

			if (indexUp and leftText) then
				gameCooltip.SubIndexes = gameCooltip.SubIndexes + 1
				gameCooltip.IndexesSub[gameCooltip.Indexes] = gameCooltip.IndexesSub[gameCooltip.Indexes] + 1

			elseif (indexUp and not leftText) then
				return gameCooltip:PrintDebug("AddMenu() attempt to add a submenu with a parent.")
			end

			--menu container
			local subMenuContainerParameters = gameCooltip.ParametersTableSub[gameCooltip.Indexes]
			if (not subMenuContainerParameters) then
				subMenuContainerParameters = {}
				gameCooltip.ParametersTableSub[gameCooltip.Indexes] = subMenuContainerParameters
			end

			local subMenuContainerFunctions = gameCooltip.FunctionsTableSub[gameCooltip.Indexes]
			if (not subMenuContainerFunctions or gameCooltip.isSpecial) then
				subMenuContainerFunctions = {}
				gameCooltip.FunctionsTableSub[gameCooltip.Indexes] = subMenuContainerFunctions
			end

			--menu table
			local subMenuTablesParameters = subMenuContainerParameters[gameCooltip.SubIndexes]
			if (not subMenuTablesParameters or gameCooltip.isSpecial) then
				subMenuTablesParameters = {}
				subMenuContainerParameters[gameCooltip.SubIndexes] = subMenuTablesParameters
			end

			--add
			subMenuContainerFunctions[gameCooltip.SubIndexes] = func
			subMenuTablesParameters[1] = param1
			subMenuTablesParameters[2] = param2
			subMenuTablesParameters[3] = param3

			--text and icon
			if (leftIcon) then
				local subMenuContainerIcons = gameCooltip.LeftIconTableSub[gameCooltip.Indexes]
				if (not subMenuContainerIcons) then
					subMenuContainerIcons = {}
					gameCooltip.LeftIconTableSub[gameCooltip.Indexes] = subMenuContainerIcons
				end
				local subMenuTablesIcons = subMenuContainerIcons[gameCooltip.SubIndexes]
				if (not subMenuTablesIcons or gameCooltip.isSpecial) then
					subMenuTablesIcons = {}
					subMenuContainerIcons[gameCooltip.SubIndexes] = subMenuTablesIcons
				end

				subMenuTablesIcons[1] = leftIcon
				subMenuTablesIcons[2] = 16 --default 16
				subMenuTablesIcons[3] = 16 --default 16
				subMenuTablesIcons[4] = 0 --default 0
				subMenuTablesIcons[5] = 1 --default 1
				subMenuTablesIcons[6] = 0 --default 0
				subMenuTablesIcons[7] = 1 --default 1
				subMenuTablesIcons[8] = defaultWhiteColor
			end

			if (leftText) then
				local subMenuContainerTexts = gameCooltip.LeftTextTableSub[gameCooltip.Indexes]
				if (not subMenuContainerTexts) then
					subMenuContainerTexts = {}
					gameCooltip.LeftTextTableSub[gameCooltip.Indexes] = subMenuContainerTexts
				end
				local subMenuTablesTexts = subMenuContainerTexts[gameCooltip.SubIndexes]
				if (not subMenuTablesTexts or gameCooltip.isSpecial) then
					subMenuTablesTexts = {}
					subMenuContainerTexts[gameCooltip.SubIndexes] = subMenuTablesTexts
				end

				subMenuTablesTexts[1] = leftText
				subMenuTablesTexts[2] = 0
				subMenuTablesTexts[3] = 0
				subMenuTablesTexts[4] = 0
				subMenuTablesTexts[5] = 0
				subMenuTablesTexts[6] = false
				subMenuTablesTexts[7] = false
				subMenuTablesTexts[8] = false
			end

			gameCooltip.HaveSubMenu = true
		else
			return gameCooltip:PrintDebug("AddMenu() unknown menuType.", menuType)
		end
	end

----------------------------------------------------------------------
	--adds a statusbar to the last line added.
	--only works with cooltip type2 (tooltip with bars)
	--parameters: value [, color red, color green, color blue, color alpha [, glow]]
	--can also use a table or html color name in color red and send glow in color green
	function gameCooltip:AddStatusBar(statusbarValue, menuType, colorRed, colorGreen, colorBlue, colorAlpha, statusbarGlow, backgroundBar, barTexture)
		--need a previous line
		if (gameCooltip.Indexes == 0) then
			return gameCooltip:PrintDebug("AddStatusBar() requires an already added line (Cooltip:AddLine()).")
		end

		--check data integrity
		if (type(statusbarValue) ~= "number") then
			return
		end

		menuType = gameCooltip:ParseMenuType(menuType)

		if (type(colorRed) == "table" or type(colorRed) == "string") then
			statusbarGlow, backgroundBar, colorRed, colorGreen, colorBlue, colorAlpha = colorGreen, colorBlue, DF:ParseColors(colorRed)

		elseif (type(colorRed) == "boolean") then
			backgroundBar = colorGreen
			statusbarGlow = colorRed
			colorRed, colorGreen, colorBlue, colorAlpha = 1, 1, 1, 1
		end

		local frameTable
		local statusbarTable

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			frameTable = gameCooltip.StatusBarTable
			if (gameCooltip.isSpecial) then
				statusbarTable = {}
				insert(frameTable, gameCooltip.Indexes, statusbarTable)
			else
				statusbarTable = frameTable[gameCooltip.Indexes]
				if (not statusbarTable) then
					statusbarTable = {}
					insert(frameTable, gameCooltip.Indexes, statusbarTable)
				end
			end

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			frameTable = gameCooltip.StatusBarTableSub
			local subMenuContainerStatusBar = frameTable[gameCooltip.Indexes]
			if (not subMenuContainerStatusBar) then
				subMenuContainerStatusBar = {}
				frameTable[gameCooltip.Indexes] = subMenuContainerStatusBar
			end

			if (gameCooltip.isSpecial) then
				statusbarTable = {}
				insert(subMenuContainerStatusBar, gameCooltip.SubIndexes, statusbarTable)
			else
				statusbarTable = subMenuContainerStatusBar[gameCooltip.SubIndexes]
				if (not statusbarTable) then
					statusbarTable = {}
					insert(subMenuContainerStatusBar, gameCooltip.SubIndexes, statusbarTable)
				end
			end
		else
			return gameCooltip:PrintDebug("AddStatusBar() unknown menuType.", menuType)
		end

		statusbarTable[1] = statusbarValue
		statusbarTable[2] = colorRed
		statusbarTable[3] = colorGreen
		statusbarTable[4] = colorBlue
		statusbarTable[5] = colorAlpha
		statusbarTable[6] = statusbarGlow
		statusbarTable[7] = backgroundBar
		statusbarTable[8] = barTexture
	end

	frame1.frameWallpaper:Hide()
	frame2.frameWallpaper:Hide()
	function gameCooltip:SetWallpaper(menuType, texture, texcoord, color, desaturate)
		if (gameCooltip.Indexes == 0) then
			return gameCooltip:PrintDebug("SetWallpaper() requires an already added line (Cooltip:AddLine()).")
		end

		menuType = gameCooltip:ParseMenuType(menuType)

		local frameTable
		local wallpaperTable

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			wallpaperTable = gameCooltip.WallpaperTable

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			frameTable = gameCooltip.WallpaperTableSub
			local subMenuContainerWallpapers = frameTable[gameCooltip.Indexes]
			if (not subMenuContainerWallpapers) then
				subMenuContainerWallpapers = {}
				frameTable[gameCooltip.Indexes] = subMenuContainerWallpapers
			end
			wallpaperTable = subMenuContainerWallpapers
		end

		wallpaperTable[1] = texture
		if (texcoord) then
			wallpaperTable[2] = texcoord[1]
			wallpaperTable[3] = texcoord[2]
			wallpaperTable[4] = texcoord[3]
			wallpaperTable[5] = texcoord[4]
		else
			wallpaperTable[2] = 0
			wallpaperTable[3] = 1
			wallpaperTable[4] = 0
			wallpaperTable[5] = 1
		end
		wallpaperTable[6] = color
		wallpaperTable[7] = desaturate
	end

	function gameCooltip:SetBannerText(index, text, anchor, color, fontSize, fontFace, fontFlag)
		local fontstring
		if (index == 1) then
			fontstring = frame1.upperImageText
		elseif (index == 2) then
			fontstring = frame1.upperImageText2
		end

		fontstring:SetText(text or "")

		if (anchor and index == 1) then
			local myAnchor, hisAnchor, x, y = unpack(anchor)
			fontstring:SetPoint(myAnchor, frame1.upperImage, hisAnchor or myAnchor, x or 0, y or 0)

		elseif (anchor and index == 2) then
			local myAnchor, hisAnchor, x, y = unpack(anchor)
			fontstring:SetPoint(myAnchor, frame1, hisAnchor or myAnchor, x or 0, y or 0)
		end

		if (color) then
			local r, g, b, a = DF:ParseColors(color)
			fontstring:SetTextColor(r, g, b, a)
		end

		local face, size, flags = fontstring:GetFont()
		face = fontFace or DF:GetBestFontForLanguage()
		size = fontSize or 13
		flags = fontFlag or nil
		fontstring:SetFont(face, size, flags)
		fontstring:Show()
	end

	function gameCooltip:SetBackdrop(menuType, backdrop, backdropcolor, bordercolor)
		local frame

		menuType = gameCooltip:ParseMenuType(menuType)

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			frame = frame1

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			frame = frame2
		end

		if (backdrop) then
			frame:SetBackdrop(backdrop)
		end
		if (backdropcolor) then
			local r, g, b, a = DF:ParseColors(backdropcolor)
			frame:SetBackdropColor(r, g, b, a)
		end
		if (bordercolor) then
			local r, g, b, a = DF:ParseColors(bordercolor)
			frame:SetBackdropBorderColor(r, g, b, a)
		end
	end

	function gameCooltip:SetBannerImage(index, texturePath, width, height, anchor, texCoord, overlay)
		local texture
		if (index == 1) then
			texture = frame1.upperImage
		elseif (index == 2) then
			texture = frame1.upperImage2
		end

		if (texturePath) then
			texture:SetTexture(texturePath)
		end

		if (width) then
			texture:SetWidth(width)
		end
		if (height) then
			texture:SetHeight(height)
		end

		if (anchor) then
			if (type(anchor[1]) == "table") then
				for anchorIndex, anchorPoints in ipairs(anchor) do
					local myAnchor, hisAnchor, x, y = unpack(anchorPoints)
					texture:SetPoint(myAnchor, frame1, hisAnchor or myAnchor, x or 0, y or 0)
				end
			else
				local myAnchor, hisAnchor, x, y = unpack(anchor)
				texture:SetPoint(myAnchor, frame1, hisAnchor or myAnchor, x or 0, y or 0)
			end
		end

		if (texCoord) then
			local leftCoord, rightCoord, topCoord, bottomCoord = unpack(texCoord)
			texture:SetTexCoord(leftCoord, rightCoord, topCoord, bottomCoord)
		end
		if (overlay) then
			texture:SetVertexColor(unpack(overlay))
		end

		gameCooltip.Banner[index] = true
		texture:Show()
	end

----------------------------------------------------------------------
	--adds a icon to the last line added.
	--only works with cooltip type1 and 2 (tooltip and tooltip with bars)
	--parameters: icon [, width [, height [, TexCoords L R T B ]]]
	--texture support string path or texture object

	function gameCooltip:AddTexture(iconTexture, menuType, side, iconWidth, iconHeight, leftCoord, rightCoord, topCoord, bottomCoord, overlayColor, point, desaturated)
		return gameCooltip:AddIcon(iconTexture, menuType, side, iconWidth, iconHeight, leftCoord, rightCoord, topCoord, bottomCoord, overlayColor, point, desaturated)
	end

	function gameCooltip:AddIcon(iconTexture, menuType, side, iconWidth, iconHeight, leftCoord, rightCoord, topCoord, bottomCoord, overlayColor, point, desaturated)
		--need a previous line
		if (gameCooltip.Indexes == 0) then
			return gameCooltip:PrintDebug("AddIcon() requires an already added line (Cooltip:AddLine()).")
		end
		--check data integrity
		if ((type(iconTexture) ~= "string" and type(iconTexture) ~= "number") and (type(iconTexture) ~= "table" or not iconTexture.GetObjectType or iconTexture:GetObjectType() ~= "Texture")) then
			return gameCooltip:PrintDebug("AddIcon() invalid parameters.")
		end

		side = side or 1
		local frameTable
		local iconTable
		menuType = gameCooltip:ParseMenuType(menuType)

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			if (not side or (type(side) == "string" and side == "left") or (type(side) == "number" and side == 1)) then
				frameTable = gameCooltip.LeftIconTable

			elseif ((type(side) == "string" and side == "right") or (type(side) == "number" and side == 2)) then
				frameTable = gameCooltip.RightIconTable
			end

			if (gameCooltip.isSpecial) then
				iconTable = {}
				insert(frameTable, gameCooltip.Indexes, iconTable)
			else
				iconTable = frameTable[gameCooltip.Indexes]
				if (not iconTable) then
					iconTable = {}
					insert(frameTable, gameCooltip.Indexes, iconTable)
				end
			end

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			if ((type(side) == "string" and side == "left") or (type(side) == "number" and side == 1)) then
				frameTable = gameCooltip.LeftIconTableSub

			elseif ((type(side) == "string" and side == "right") or (type(side) == "number" and side == 2)) then
				frameTable = gameCooltip.RightIconTableSub

			elseif ((type(side) == "string" and side == "top") or (type(side) == "number" and side == 3)) then
				gameCooltip.TopIconTableSub[gameCooltip.Indexes] = gameCooltip.TopIconTableSub[gameCooltip.Indexes] or {}
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][1] = iconTexture
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][2] = iconWidth or 16
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][3] = iconHeight or 16
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][4] = leftCoord or 0
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][5] = rightCoord or 1
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][6] = topCoord or 0
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][7] = bottomCoord or 1
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][8] = overlayColor or defaultWhiteColor
				gameCooltip.TopIconTableSub[gameCooltip.Indexes][9] = desaturated
				return
			end

			local subMenuContainerIcons = frameTable[gameCooltip.Indexes]
			if (not subMenuContainerIcons) then
				subMenuContainerIcons = {}
				frameTable[gameCooltip.Indexes] = subMenuContainerIcons
			end

			if (gameCooltip.isSpecial) then
				iconTable = {}
				subMenuContainerIcons[gameCooltip.SubIndexes] = iconTable
			else
				iconTable = subMenuContainerIcons[gameCooltip.SubIndexes]
				if (not iconTable) then
					iconTable = {}
					subMenuContainerIcons[gameCooltip.SubIndexes] = iconTable
				end
			end
		else
			return --error
		end

		iconTable[1] = iconTexture
		iconTable[2] = iconWidth or 16 --default 16
		iconTable[3] = iconHeight or 16 --default 16
		iconTable[4] = leftCoord or 0 --default 0
		iconTable[5] = rightCoord or 1 --default 1
		iconTable[6] = topCoord or 0 --default 0
		iconTable[7] = bottomCoord or 1 --default 1
		iconTable[8] = overlayColor or defaultWhiteColor --default 1, 1, 1
		iconTable[9] = desaturated

		return true
	end

----------------------------------------------------------------------
	--popup frame
	function gameCooltip:AddPopUpFrame(onShowFunc, onHideFunc, param1, param2)
		--act like a sub menu
		if (gameCooltip.Indexes > 0) then
			gameCooltip.PopupFrameTable[gameCooltip.Indexes] = {onShowFunc or false, onHideFunc or false, param1, param2}
		end
	end

----------------------------------------------------------------------
	--adds a line.
	--only works with cooltip type1 and 2 (tooltip and tooltip with bars)
	--parameters: left text, right text[, L color R, L color G, L color B, L color A[, R color R, R color G, R color B, R color A[, wrap]]] 
	function gameCooltip:AddDoubleLine (leftText, rightText, menuType, ColorR1, ColorG1, ColorB1, ColorA1, ColorR2, ColorG2, ColorB2, ColorA2, fontSize, fontFace, fontFlag)
		return gameCooltip:AddLine(leftText, rightText, menuType, ColorR1, ColorG1, ColorB1, ColorA1, ColorR2, ColorG2, ColorB2, ColorA2, fontSize, fontFace, fontFlag)
	end

	--adds a line for tooltips
	function gameCooltip:AddLine(leftText, rightText, menuType, ColorR1, ColorG1, ColorB1, ColorA1, ColorR2, ColorG2, ColorB2, ColorA2, fontSize, fontFace, fontFlag)
		--check data integrity
		local leftTextType = type(leftText)
		if (leftTextType ~= "string") then
			if (leftTextType == "number") then
				leftText = tostring(leftText)
			else
				leftText = ""
			end
		end

		gameCooltip.CheckNeedNewFont(leftText)

		local rightTextType = type(rightText)
		if (rightTextType ~= "string") then
			if (rightTextType == "number") then
				rightText = tostring(rightText)
			else
				rightText = ""
			end
		end

		gameCooltip.CheckNeedNewFont(rightText)

		if (type(ColorR1) ~= "number") then
			ColorR2, ColorG2, ColorB2, ColorA2, fontSize, fontFace, fontFlag = ColorG1, ColorB1, ColorA1, ColorR2, ColorG2, ColorB2, ColorA2
			if (type(ColorR1) == "boolean" or not ColorR1) then
				ColorR1, ColorG1, ColorB1, ColorA1 = 0, 0, 0, 0
			else
				ColorR1, ColorG1, ColorB1, ColorA1 = DF:ParseColors(ColorR1)
			end
		end

		if (type(ColorR2) ~= "number") then
			fontSize, fontFace, fontFlag = ColorG2, ColorB2, ColorA2
			if (type(ColorR2) == "boolean" or not ColorR2) then
				ColorR2, ColorG2, ColorB2, ColorA2 = 0, 0, 0, 0
			else
				ColorR2, ColorG2, ColorB2, ColorA2 = DF:ParseColors(ColorR2)
			end
		end

		local frameTableLeft
		local frameTableRight
		local lineTable_Left
		local lineTable_Right

		menuType = gameCooltip:ParseMenuType(menuType)

		if (menuType == CONST_MENU_TYPE_MAINMENU) then
			gameCooltip.Indexes = gameCooltip.Indexes + 1
			if (not gameCooltip.IndexesSub[gameCooltip.Indexes]) then
				gameCooltip.IndexesSub[gameCooltip.Indexes] = 0
			end

			gameCooltip.SubIndexes = 0

			frameTableLeft = gameCooltip.LeftTextTable
			frameTableRight = gameCooltip.RightTextTable

			if (gameCooltip.isSpecial) then
				lineTable_Left = {}
				insert(frameTableLeft, gameCooltip.Indexes, lineTable_Left)
				lineTable_Right = {}
				insert(frameTableRight, gameCooltip.Indexes, lineTable_Right)
			else
				lineTable_Left = frameTableLeft[gameCooltip.Indexes]
				lineTable_Right = frameTableRight[gameCooltip.Indexes]
				if (not lineTable_Left) then
					lineTable_Left = {}
					insert(frameTableLeft, gameCooltip.Indexes, lineTable_Left)
				end
				if (not lineTable_Right) then
					lineTable_Right = {}
					insert(frameTableRight, gameCooltip.Indexes, lineTable_Right)
				end
			end

		elseif (menuType == CONST_MENU_TYPE_SUBMENU) then
			gameCooltip.SubIndexes = gameCooltip.SubIndexes + 1
			gameCooltip.IndexesSub[gameCooltip.Indexes] = gameCooltip.IndexesSub[gameCooltip.Indexes] + 1
			gameCooltip.HaveSubMenu = true

			frameTableLeft = gameCooltip.LeftTextTableSub
			frameTableRight = gameCooltip.RightTextTableSub

			local subMenuContainerTexts = frameTableLeft[gameCooltip.Indexes]
			if (not subMenuContainerTexts) then
				subMenuContainerTexts = {}
				insert(frameTableLeft, gameCooltip.Indexes, subMenuContainerTexts)
			end

			if (gameCooltip.isSpecial) then
				lineTable_Left = {}
				insert(subMenuContainerTexts, gameCooltip.SubIndexes, lineTable_Left)
			else
				lineTable_Left = subMenuContainerTexts[gameCooltip.SubIndexes]
				if (not lineTable_Left) then
					lineTable_Left = {}
					insert(subMenuContainerTexts, gameCooltip.SubIndexes, lineTable_Left)
				end
			end

			local subMenuContainerTexts = frameTableRight[gameCooltip.Indexes]
			if (not subMenuContainerTexts) then
				subMenuContainerTexts = {}
				insert(frameTableRight, gameCooltip.Indexes, subMenuContainerTexts)
			end

			if (gameCooltip.isSpecial) then
				lineTable_Right = {}
				insert(subMenuContainerTexts, gameCooltip.SubIndexes, lineTable_Right)
			else
				lineTable_Right = subMenuContainerTexts[gameCooltip.SubIndexes]
				if (not lineTable_Right) then
					lineTable_Right = {}
					insert(subMenuContainerTexts, gameCooltip.SubIndexes, lineTable_Right)
				end
			end
		else
			return gameCooltip:PrintDebug("AddLine() unknown menuType.", menuType)
		end

		lineTable_Left[1] = leftText
		lineTable_Left[2] = ColorR1
		lineTable_Left[3] = ColorG1
		lineTable_Left[4] = ColorB1
		lineTable_Left[5] = ColorA1
		lineTable_Left[6] = fontSize
		lineTable_Left[7] = fontFace
		lineTable_Left[8] = fontFlag

		lineTable_Right[1] = rightText
		lineTable_Right[2] = ColorR2
		lineTable_Right[3] = ColorG2
		lineTable_Right[4] = ColorB2
		lineTable_Right[5] = ColorA2
		lineTable_Right[6] = fontSize
		lineTable_Right[7] = fontFace
		lineTable_Right[8] = fontFlag
	end

	function gameCooltip:AddSpecial(widgetType, index, subIndex, ...)
		local currentIndex = gameCooltip.Indexes
		local currentSubIndex = gameCooltip.SubIndexes
		gameCooltip.isSpecial = true

		widgetType = string.lower(widgetType)

		if (widgetType == "line") then
			if (subIndex) then
				gameCooltip.Indexes = index
				gameCooltip.SubIndexes = subIndex-1
			else
				gameCooltip.Indexes = index-1
			end

			gameCooltip:AddLine(...)

			if (subIndex) then
				gameCooltip.Indexes = currentIndex
				gameCooltip.SubIndexes = currentSubIndex + 1
			else
				gameCooltip.Indexes = currentIndex + 1
			end

		elseif (widgetType == "icon") then
			gameCooltip.Indexes = index
			if (subIndex) then
				gameCooltip.SubIndexes = subIndex
			end

			gameCooltip:AddIcon(...)

			gameCooltip.Indexes = currentIndex
			if (subIndex) then
				gameCooltip.SubIndexes = currentSubIndex
			end

		elseif (widgetType == "statusbar") then
			gameCooltip.Indexes = index
			if (subIndex) then
				gameCooltip.SubIndexes = subIndex
			end

			gameCooltip:AddStatusBar(...)
			gameCooltip.Indexes = currentIndex
			if (subIndex) then
				gameCooltip.SubIndexes = currentSubIndex
			end

		elseif (widgetType == "menu") then
			gameCooltip.Indexes = index
			if (subIndex) then
				gameCooltip.SubIndexes = subIndex
			end

			gameCooltip:AddMenu(...)

			gameCooltip.Indexes = currentIndex
			if (subIndex) then
				gameCooltip.SubIndexes = currentSubIndex
			end
		end

		gameCooltip.isSpecial = false
	end

	--search key: ~fromline
	function gameCooltip:AddFromTable(thisTable)
		for tableIndex, menu in ipairs(thisTable) do
			if (menu.func) then
				gameCooltip:AddMenu(menu.type or 1, menu.func, menu.param1, menu.param2, menu.param3, nil, menu.icon)

			elseif (menu.statusbar) then
				gameCooltip:AddStatusBar(menu.value, menu.type or 1, menu.color, true)

			elseif (menu.icon) then
				gameCooltip:AddIcon(menu.icon, menu.type or 1, menu.side or 1, menu.width, menu.height, menu.l, menu.r, menu.t, menu.b, menu.color)

			elseif (menu.textleft or menu.textright or menu.text) then
				gameCooltip:AddLine(menu.text, "", menu.type, menu.color, menu.color)
			end
		end
	end

----------------------------------------------------------------------
	--serach key: ~start
	function gameCooltip:Show(frame, menuType, color)
		gameCooltip.hadInteractions = false
		return gameCooltip:ShowCooltip(frame, menuType, color)
	end

	function gameCooltip:ShowCooltip(frame, menuType, color)
		frame1:SetFrameStrata("TOOLTIP")
		frame2:SetFrameStrata("TOOLTIP")
		frame1:SetParent(UIParent)
		frame2:SetParent(UIParent)

		gameCooltip.hadInteractions = false

		if (frame) then
			--check if is a details framework widget
			if (frame.dframework) then
				frame = frame.widget
			end
			gameCooltip:SetHost(frame)
		end

		if (menuType) then
			gameCooltip:SetType(menuType)
		end

		if (color) then
			gameCooltip:SetColor(1, color)
			gameCooltip:SetColor(2, color)
		end

		if (gameCooltip.Type == 1 or gameCooltip.Type == 2) then
			return gameCooltip:BuildTooltip()

		elseif (gameCooltip.Type == 3) then
			return gameCooltip:BuildCooltip()
		end
	end

	function gameCooltip:Hide()
		return gameCooltip:Close()
	end

	function gameCooltip:Close()
		gameCooltip.active = false
		gameCooltip.Host = nil
		DF:FadeFrame(frame1, 1)
		DF:FadeFrame(frame2, 1)

		--release custom icon texture objects, these are TextureObject passed with AddIcon() instead of a texture path or textureId
		for i = 1, #frame1.Lines do
			local menuButton = frame1.Lines[i]

			--relase custom icon texture if any
			if (menuButton.customLeftTexture) then
				menuButton.customLeftTexture:ClearAllPoints()
				menuButton.customLeftTexture = nil
			end

			if (menuButton.customRightTexture) then
				menuButton.customRightTexture:ClearAllPoints()
				menuButton.customRightTexture = nil
			end
		end

		for i = 1, #frame2.Lines do
			local menuButton = frame2.Lines[i]

			--relase custom icon texture if any
			if (menuButton.customLeftTexture) then
				menuButton.customLeftTexture:ClearAllPoints()
				menuButton.customLeftTexture = nil
			end

			if (menuButton.customRightTexture) then
				menuButton.customRightTexture:ClearAllPoints()
				menuButton.customRightTexture = nil
			end
		end
	end

	--old function call
	function gameCooltip:ShowMe(host, arg2) --drunk code
		--ignore if mouse is within the frame region
		if (gameCooltip.mouseOver) then
			return
		end
		if (not host or not arg2) then --hide the frame
			gameCooltip:Close()
		end
	end

	--search key: ~inject
	function gameCooltip:ExecFunc(host, fromClick)
		if (host.dframework) then
			if (not host.widget.CoolTip) then
				host.widget.CoolTip = host.CoolTip
			end
			host = host.widget
		end

		gameCooltip:Reset()
		gameCooltip:SetType(host.CoolTip.Type)
		gameCooltip:SetFixedParameter(host.CoolTip.FixedValue)
		gameCooltip:SetColor(CONST_MENU_TYPE_MAINMENU, host.CoolTip.MainColor or "transparent")
		gameCooltip:SetColor(CONST_MENU_TYPE_SUBMENU, host.CoolTip.SubColor or "transparent")

		local okay, errortext = pcall(host.CoolTip.BuildFunc, host, host.CoolTip and host.CoolTip.FixedValue)
		if (not okay) then
			gameCooltip:PrintDebug("ExecFunc() injected function error:", errortext)
		end

		gameCooltip:SetOwner(host, host.CoolTip.MyAnchor, host.CoolTip.HisAnchor, host.CoolTip.X, host.CoolTip.Y)

		local options = host.CoolTip.Options
		if (type(options) == "function") then
			local runCompleted, returnedOptions = pcall(options)
			if (not runCompleted) then
				errortext = returnedOptions
				gameCooltip:PrintDebug("ExecFunc() options function error:", errortext)
				options = nil
			else
				options = returnedOptions
			end
		end

		if (options) then
			if (type(options) == "table") then
				for optionName, optionValue in pairs(options) do
					gameCooltip:SetOption(optionName, optionValue)
				end
			else
				gameCooltip:PrintDebug("ExecFunc() options function did not returned a table.")
			end
		end

		if (gameCooltip.Indexes == 0) then
			if (host.CoolTip.Default) then
				gameCooltip:SetType(CONST_COOLTIP_TYPE_TOOLTIP)
				gameCooltip:AddLine(host.CoolTip.Default, nil, 1, "white")
			end
		end

		gameCooltip:ShowCooltip()

		if (fromClick) then
			frame1:Flash(0.05, 0.05, 0.2, true, 0, 0)
		end
	end

	local wait = 0.2
	local delayToHide = 0.11
	local delayToHideDefault = 0.11
	local InjectOnUpdateEnter = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > wait) then
			self:SetScript("OnUpdate", nil)
			gameCooltip:ExecFunc(self)
		end
	end

	local InjectOnUpdateLeave = function(self, deltaTime)
		elapsedTime = elapsedTime + deltaTime
		if (elapsedTime > delayToHide) then
			if (not gameCooltip.mouseOver and not gameCooltip.buttonOver and self == gameCooltip.Host) then
				gameCooltip:ShowMe(false)
			end
			self:SetScript("OnUpdate", nil)
		end
	end

	local InjectOnLeave = function(self)
		gameCooltip.buttonOver = false

		if (gameCooltip.active) then
			elapsedTime = 0
			delayToHide = self.CoolTip.HideSpeed or delayToHideDefault
			self:SetScript("OnUpdate", InjectOnUpdateLeave)
		else
			self:SetScript("OnUpdate", nil)
		end

		if (self.CoolTip.OnLeaveFunc) then
			self.CoolTip.OnLeaveFunc(self)
		end

		if (self.OldOnLeaveScript) then
			self:OldOnLeaveScript()
		end
	end

	local InjectOnEnter = function(self)
		gameCooltip.buttonOver = true
		if (gameCooltip.active) then
			gameCooltip:ExecFunc(self)
		else
			elapsedTime = 0
			wait = self.CoolTip.ShowSpeed or 0.2
			self:SetScript("OnUpdate", InjectOnUpdateEnter)
		end

		if (self.CoolTip.OnEnterFunc) then
			self.CoolTip.OnEnterFunc(self)
		end

		if (self.OldOnEnterScript) then
			self:OldOnEnterScript()
		end
	end

	function gameCooltip:CoolTipInject(host, openOnClick)
		if (host.dframework) then
			if (not host.widget.CoolTip) then
				host.widget.CoolTip = host.CoolTip
			end
			host = host.widget
		end

		local coolTable = host.CoolTip
		if (not coolTable) then
			gameCooltip:PrintDebug("CoolTipInject() host frame does not have a .CoolTip table.")
			return false
		end

		host.OldOnEnterScript = host:GetScript("OnEnter")
		host.OldOnLeaveScript = host:GetScript("OnLeave")

		host:SetScript("OnEnter", InjectOnEnter)
		host:SetScript("OnLeave", InjectOnLeave)

		if (openOnClick) then
			if (host:GetObjectType() == "Button") then
				host:SetScript("OnClick", function() gameCooltip:ExecFunc(host, true) end)
			end
		end

		return true
	end

	--all done
	gameCooltip:ClearAllOptions()

	function gameCooltip:Preset(presetId, fromReset)
		if (not fromReset) then
			self:Reset(true)
		end

		gameCooltip:SetOption("StatusBarTexture", [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])
		self:SetOption("TextFont", DF:GetBestFontForLanguage())
		self:SetOption("TextColor", "orange")
		self:SetOption("TextSize", 11)
		self:SetOption("ButtonsYMod", -4)
		self:SetOption("YSpacingMod", -4)
		self:SetOption("IgnoreButtonAutoHeight", true)

		if (presetId == 1) then
			self:SetColor(1, 0.5, 0.5, 0.5, 0.5)

		elseif (presetId == 2) then --used by most of the widgets
			self:SetOption("FixedWidth", 220)
			self:SetColor(1, defaultBackdropColor)
			self:SetColor(2, defaultBackdropColor)
			self:SetBackdrop(1, defaultBackdrop, defaultBackdropColor, defaultBackdropBorderColor)
			self:SetBackdrop(2, defaultBackdrop, defaultBackdropColor, defaultBackdropBorderColor)

		elseif (presetId == 3) then --default used when Cooltip:Reset() is called
			self:SetColor(1, defaultBackdropColor)
			self:SetColor(2, defaultBackdropColor)
			self:SetBackdrop(1, defaultBackdrop, defaultBackdropColor, defaultBackdropBorderColor)
			self:SetBackdrop(2, defaultBackdrop, defaultBackdropColor, defaultBackdropBorderColor)
		end
	end

	function gameCooltip:QuickTooltip(host, ...)
		gameCooltip:Preset(2)
		gameCooltip:SetHost(host)

		for i = 1, select("#", ...) do
			local line = select(i, ...)
			gameCooltip:AddLine(line)
		end

		gameCooltip:ShowCooltip()
	end

	function gameCooltip:InjectQuickTooltip(host, ...)
		host.CooltipQuickTooltip = {...}
		host:HookScript("OnEnter", function()
			gameCooltip:QuickTooltip(host, unpack(host.CooltipQuickTooltip))
		end)
		host:HookScript("OnLeave", function()
			gameCooltip:Hide()
		end)
	end

	local cyrillic = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯЁЂЃЄЅІЇЈЉЊЋЌЎЏҐабвгдежзийклмнопрстуфхцчшщъыьэюяёђѓєѕіїјљњћќўџґАаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"
	local latin = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local chinese = "ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟﾡﾢﾣﾤﾥﾦﾧﾨﾩﾪﾫﾬﾭﾮﾯﾰﾱﾲﾳﾴﾵﾶﾷﾸﾹﾺﾻﾼﾽﾾￂￃￄￅￆￇￊￋￌￍￎￏￒￓￔￕￖￗￚￛￜ"

	local alphabetTable = {}

	for letter in latin:gmatch(".") do
		alphabetTable[letter] = "enUS"
	end
	for letter in cyrillic:gmatch(".") do
		alphabetTable[letter] = "ruRU"
	end
	for letter in chinese:gmatch(".") do
		alphabetTable[letter] = "zhCN"
	end

	function gameCooltip:DetectLanguageId(text)
		for letter in text:gmatch(".") do
			if (alphabetTable[letter]) then
				return alphabetTable[letter]
			end
		end
	end

	return gameCooltip
end

DF:CreateCoolTip()
