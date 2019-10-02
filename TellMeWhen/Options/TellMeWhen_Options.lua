-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local clientVersion = select(4, GetBuildInfo())

---------- Libraries ----------
local LSM = LibStub("LibSharedMedia-3.0")
local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))
local AceDB = LibStub("AceDB-3.0")

-- GLOBALS: LibStub
-- GLOBALS: TMWOptDB
-- GLOBALS: TELLMEWHEN_VERSION_FULL, TELLMEWHEN_VERSIONNUMBER, TELLMEWHEN_MAXROWS
-- GLOBALS: NORMAL_FONT_COLOR, HIGHLIGHT_FONT_COLOR, INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED, SPELL_RECAST_TIME_MIN, SPELL_RECAST_TIME_SEC, NONE, SPELL_CAST_CHANNELED, NUM_BAG_SLOTS, CANCEL
-- GLOBALS: GameTooltip
-- GLOBALS: UIParent, WorldFrame, TellMeWhen_IconEditor, GameFontDisable, GameFontHighlight, CreateFrame, collectgarbage 
-- GLOBALS: PanelTemplates_TabResize, PanelTemplates_Tab_OnClick

---------- Upvalues ----------
local TMW = TMW
local L = TMW.L
local GetSpellInfo =
	  GetSpellInfo
local tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, wipe, next, getmetatable, setmetatable, pcall, assert, rawget, rawset, unpack, select =
	  tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, wipe, next, getmetatable, setmetatable, pcall, assert, rawget, rawset, unpack, select
local strfind, strmatch, format, gsub, strsub, strtrim, strlen, strsplit, strlower, max, min, floor, ceil, log10 =
	  strfind, strmatch, format, gsub, strsub, strtrim, strlen, strsplit, strlower, max, min, floor, ceil, log10
local GetCursorPosition, GetCursorInfo, CursorHasSpell, CursorHasItem, ClearCursor =
	  GetCursorPosition, GetCursorInfo, CursorHasSpell, CursorHasItem, ClearCursor
local _G, bit, CopyTable, hooksecurefunc, IsAddOnLoaded, IsControlKeyDown, PlaySound =
	  _G, bit, CopyTable, hooksecurefunc, IsAddOnLoaded, IsControlKeyDown, PlaySound

local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture
local print = TMW.print
local Types = TMW.Types
local IE


---------- Locals ----------
local _, pclass = UnitClass("Player")
local tiptemp = {}
local get = TMW.get

---------- Globals ----------
--GLOBALS: BINDING_HEADER_TELLMEWHEN, BINDING_NAME_TELLMEWHEN_ICONEDITOR_UNDO, BINDING_NAME_TELLMEWHEN_ICONEDITOR_REDO
BINDING_HEADER_TELLMEWHEN = "TellMeWhen"
BINDING_NAME_TELLMEWHEN_ICONEDITOR_UNDO = L["UNDO"]
BINDING_NAME_TELLMEWHEN_ICONEDITOR_REDO = L["REDO"]


---------- Data ----------
local points = {
	TOPLEFT = L["TOPLEFT"],
	TOP = L["TOP"],
	TOPRIGHT = L["TOPRIGHT"],
	LEFT = L["LEFT"],
	CENTER = L["CENTER"],
	RIGHT = L["RIGHT"],
	BOTTOMLEFT = L["BOTTOMLEFT"],
	BOTTOM = L["BOTTOM"],
	BOTTOMRIGHT = L["BOTTOMRIGHT"],
} TMW.points = points

TMW.justifyPoints = {
	LEFT = L["LEFT"],
	CENTER = L["CENTER"],
	RIGHT = L["RIGHT"],
}
TMW.justifyVPoints = {
	TOP = L["TOP"],
	MIDDLE = L["CENTER"],
	BOTTOM = L["BOTTOM"],
}

TMW.operators = {
	{ tooltipText = L["CONDITIONPANEL_EQUALS"], 		value = "==", 	text = "==" },
	{ tooltipText = L["CONDITIONPANEL_NOTEQUAL"], 	 	value = "~=", 	text = "~=" },
	{ tooltipText = L["CONDITIONPANEL_LESS"], 			value = "<", 	text = "<" 	},
	{ tooltipText = L["CONDITIONPANEL_LESSEQUAL"], 		value = "<=", 	text = "<=" },
	{ tooltipText = L["CONDITIONPANEL_GREATER"], 		value = ">", 	text = ">" 	},
	{ tooltipText = L["CONDITIONPANEL_GREATEREQUAL"], 	value = ">=", 	text = ">=" },
}




---------- Miscellaneous ----------

TMW.CI = setmetatable({}, {__index = function(tbl, k)
	if k == "ics" then
		return tbl.icon and tbl.icon:GetSettings()
	elseif k == "gs" then
		return tbl.group and tbl.group:GetSettings()
	end
end}) local CI = TMW.CI		--current icon





---------- Misc Utilities ----------
local ScrollContainerHook_Hide = function(c) c.ScrollFrame:Hide() end
local ScrollContainerHook_Show = function(c) c.ScrollFrame:Show() end
local ScrollContainerHook_OnSizeChanged = function(c) c.ScrollFrame:Show() end
function TMW:ConvertContainerToScrollFrame(container, exteriorScrollBarPosition, scrollBarXOffs, scrollBarSizeX, leftSide)
	local name = container:GetName() and container:GetName() .. "ScrollFrame"
	local ScrollFrame = TMW.C.Config_ScrollFrame:New("ScrollFrame", name, container:GetParent(), "TellMeWhen_ScrollFrameTemplate")
	
	-- Make the ScrollFrame clone the container's position and size
	local x, y = container:GetSize()
	ScrollFrame:SetSize(x, y)
	for i = 1, container:GetNumPoints() do
		ScrollFrame:SetPoint(container:GetPoint(i))
	end
	

	-- Make the container be the ScrollFrame's ScrollChild.
	-- Fix its size to take the full width.
	container:ClearAllPoints()
	ScrollFrame:SetScrollChild(container)
	container:SetSize(1, 1)
	
	local relPoint = leftSide and "LEFT" or "RIGHT"
	if exteriorScrollBarPosition then
		ScrollFrame.ScrollBar:SetPoint("LEFT", ScrollFrame, relPoint, scrollBarXOffs or 0, 0)
	else
		ScrollFrame.ScrollBar:SetPoint("RIGHT", ScrollFrame, relPoint, scrollBarXOffs or 0, 0)
	end
	
	if scrollBarSizeX then
		ScrollFrame.ScrollBar:SetWidth(scrollBarSizeX)
	end
	
	container.ScrollFrame = ScrollFrame
	ScrollFrame.container = container

	hooksecurefunc(container, "Hide", ScrollContainerHook_Hide)
	hooksecurefunc(container, "Show", ScrollContainerHook_Show)
	
	return ScrollFrame
end






-- ----------------------
-- WOW API HOOKS
-- ----------------------

function GameTooltip:TMW_SetEquiv(equiv)
	GameTooltip:AddLine(L[equiv], HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
	GameTooltip:AddLine(IE:Equiv_GenerateTips(equiv), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
end


-- GLOBALS: ChatEdit_InsertLink
TMW:NewClass("ChatEdit_InsertLink_Hook"){
	OnNewInstance = function(self, editbox, func)		
		TMW:ValidateType(2, "ChatEdit_InsertLink_Hook:New()", editbox, "frame")
		TMW:ValidateType(3, "ChatEdit_InsertLink_Hook:New()", func, "function")
		
		self.func = func
		self.editbox = editbox
	end,
	
	Call = function(self, text, linkType, linkData)
		if self.editbox:HasFocus() then
			return TMW.safecall(self.func, self, text, linkType, linkData)
		end
	end,
}

local old_ChatEdit_InsertLink = ChatEdit_InsertLink
local function hook_ChatEdit_InsertLink(text)	
	if type(text) ~= "string" then
		return false
	end
	
	local Type, data = strmatch(text, "|H(.-):(.-)|h")
	
	for _, instance in pairs(TMW.Classes.ChatEdit_InsertLink_Hook.instances) do
		local executionSuccess, insertResult = instance:Call(text, Type, data)
		if executionSuccess and insertResult then
			return insertResult
		end
	end
	
	return false
end

function ChatEdit_InsertLink(...)
	local executionSuccess, insertSuccess = TMW.safecall(hook_ChatEdit_InsertLink, ...)
	if executionSuccess and insertSuccess then
		return insertSuccess
	else
		return old_ChatEdit_InsertLink(...)
	end
end







-- ----------------------
-- ICON EDITOR
-- ----------------------

IE = TMW:NewClass("IE", "Frame", "Core_Upgrades"):New("Frame")
IE = TMW:NewModule("IconEditor", IE, "AceEvent-3.0", "AceTimer-3.0") TMW.IE = IE
IE.Tabs = {}

IE.CONST = {
	IE_HEIGHT_MIN = 400,
	IE_HEIGHT_MAX = 1200,
}

function IE:OnInitialize()
	-- if the file IS required for gross functionality
	if not IE.TabGroups.ICON or not TMW.indentLib then
		-- GLOBALS: StaticPopupDialogs, StaticPopup_Show, EXIT_GAME, CANCEL, ForceQuit
		StaticPopupDialogs["TMWOPT_RESTARTNEEDED"] = {
			text = L["ERROR_MISSINGFILE_OPT"], 
			button1 = OKAY,
			timeout = 0,
			showAlert = true,
			whileDead = true,
			preferredIndex = 3, -- http://forums.wowace.com/showthread.php?p=320956
		}
		StaticPopup_Show("TMWOPT_RESTARTNEEDED", TELLMEWHEN_VERSION_FULL, L["ERROR_MISSINGFILE_REQFILE"]) -- arg3 could also be "TellMeWhen_Options/IconConfig.lua"
		return

	-- if the file is NOT required for gross functionality
	elseif not TMW.DOGTAG then
		StaticPopupDialogs["TMWOPT_RESTARTNEEDED"] = {
			text = L["ERROR_MISSINGFILE_OPT_NOREQ"], 
			button1 = OKAY,
			timeout = 0,
			showAlert = true,
			whileDead = true,
			preferredIndex = 3, -- http://forums.wowace.com/showthread.php?p=320956
		}
		StaticPopup_Show("TMWOPT_RESTARTNEEDED", TELLMEWHEN_VERSION_FULL, "TellMeWhen/Components/Core/Common/DogTags/config.lua") -- arg3 could also be L["ERROR_MISSINGFILE_REQFILE"]
	end

	if TMW.db.global.CreateImportBackup then
		TMW.Backupdb = CopyTable(TellMeWhenDB)
		TMW.BackupDate = date("%I:%M:%S %p")
	end

	TMW:Fire("TMW_OPTIONS_LOADING")
	TMW:UnregisterAllCallbacks("TMW_OPTIONS_LOADING")

	-- Make TMW.IE be the same as IE.
	-- IE[0] = TellMeWhen_IconEditor[0] (already done in .xml)
	-- local meta = CopyTable(getmetatable(IE))
	-- meta.__index = getmetatable(TellMeWhen_IconEditor).__index
	-- setmetatable(IE, meta)


	hooksecurefunc("PickupSpellBookItem", function(...) IE.DraggingInfo = {...} end)
	WorldFrame:HookScript("OnMouseDown", function()
		IE.DraggingInfo = nil
	end)
	hooksecurefunc("ClearCursor", IE.BAR_HIDEGRID)
	IE:RegisterEvent("PET_BAR_HIDEGRID", "BAR_HIDEGRID")
	IE:RegisterEvent("ACTIONBAR_HIDEGRID", "BAR_HIDEGRID")


	IE:InitializeDatabase()


	IE:SetScript("OnUpdate", IE.OnUpdate)


	IE.history = {}
	IE.historyState = 0
	--IE.CurrentTabGroup = IE.TabGroups.ICON

	

	-- Create resizer
	self.resizer = TMW.Classes.Resizer_Generic:New(self)

	TMW:TT(self.resizer.resizeButton, self.resizer.tooltipTitle, function()
		return L["RESIZE_TOOLTIP"] .. (not TMW.IE.db.global.ScaleIE and "\r\n\r\n" .. L["RESIZE_TOOLTIP_IEEXTRA"] or "")
	end, 1, 1)
	self.resizer.tooltipText = L["RESIZE_TOOLTIP"] .. ("\r\n\r\n" .. L["RESIZE_TOOLTIP_IEEXTRA"])
	self.resizer:Show()
	self.resizer.scale_min = 0.4
	self.resizer.y_min = 400
	self.resizer.y_max = 1200
	function self.resizer:SizeUpdated()
		TMW.IE.db.global.EditorHeight = IE:GetHeight()
		TMW.IE.db.global.EditorScale = IE:GetScale()
	end

	IE.Initialized = true

	TMW:Fire("TMW_OPTIONS_LOADED")
	TMW:UnregisterAllCallbacks("TMW_OPTIONS_LOADED")
	IE.OnInitialize = nil
end




---------------------------------
-- Database Management
---------------------------------

IE.Defaults = {
	global = {
		LastChangelogVersion = 0,
		TellMeWhenDBBackupDate = 0,
		ScaleIE			= false,
		EditorScale		= 1,
		EditorHeight	= 600,
		ConfigWarning	= true,
		ConfigWarningN	= 0,

		RecentColors = {},
	},
}

function IE:RegisterDatabaseDefaults(defaults)
	assert(type(defaults) == "table", "arg1 to RegisterProfileDefaults must be a table")
	
	if IE.InitializedDatabase then
		error("Defaults are being registered too late. They need to be registered before the database is initialized.", 2)
	end
	
	-- Copy the defaults into the main defaults table.
	TMW:MergeDefaultsTables(defaults, IE.Defaults)
end

function IE:GetBaseUpgrades()			-- upgrade functions
	return {
		[80035] = {
			global = function(self)
				IE.db.global.EditorScale = 1
				IE.db.global.ScaleIE = false
			end,
		},
		[62218] = {
			global = function(self)
				IE.db.global.EditorScale = TMW.db.global.EditorScale or 0.9
				TMW.db.global.EditorScale = nil
				
				IE.db.global.EditorHeight = TMW.db.global.EditorHeight or 600
				TMW.db.global.EditorHeight = nil
				
				IE.db.global.ConfigWarning = TMW.db.global.ConfigWarning or true
				TMW.db.global.ConfigWarning = nil
				
			end,
			profile = function(self)
				-- Do Stuff
			end,
		},
	}
end


IE:SetUpgradePerformedEvent("TMW_IE_UPGRADE_PERFORMED")

TMW:RegisterCallback("TMW_IE_UPGRADE_PERFORMED", function(event, type, upgradeData, ...)
	if type == "global" then
		-- delegate to locale
		if IE.db.sv.locale then
			local currentLocale = GetLocale():lower()

			for locale, ls in pairs(IE.db.sv.locale) do
				-- Delete non-current locale data. It doesn't contain anything useful.
				if locale ~= currentLocale then
					TMW.IE.db.sv.locale[locale] = nil
					TMW:Printf("Deleted cache for locale %s", locale)
				else
					IE:Upgrade("locale", upgradeData, ls, locale)
				end
			end
		end
	end
end)


function IE:RawUpgrade()

	IE.RawUpgrade = nil
	

	-- Begin DB upgrades that need to be done before defaults are added.
	-- Upgrades here should always do everything needed to every single profile,
	-- and remember to check if a table exists before iterating/indexing it.

	if TMWOptDB and TMWOptDB.profiles then
		--[[
		if TMWOptDB.Version < 41402 then
			...

			for _, p in pairs(TMWOptDB.profiles) do
				...
			end
		end
		]]
		
	end
	
	TMW:Fire("TMW_IE_DB_PRE_DEFAULT_UPGRADES")
	TMW:UnregisterAllCallbacks("TMW_IE_DB_PRE_DEFAULT_UPGRADES")
end

function IE:UpgradeGlobal()
	if TMWOptDB.Version < TELLMEWHEN_VERSIONNUMBER then
		IE:StartUpgrade("global", TMWOptDB.Version, IE.db.global)

		TMWOptDB.Version = TELLMEWHEN_VERSIONNUMBER
	end

	-- This function isn't needed anymore
	IE.UpgradeGlobal = nil
end

function IE:UpgradeProfile()
	-- Set the version for the current profile to the current version if it is a new profile.
	IE.db.profile.Version = IE.db.profile.Version or TELLMEWHEN_VERSIONNUMBER
	
	if IE.db.profile.Version < TELLMEWHEN_VERSIONNUMBER then
		IE:StartUpgrade("profile", IE.db.profile.Version, IE.db.profile)

		IE.db.profile.Version = TELLMEWHEN_VERSIONNUMBER
	end
end



function IE:InitializeDatabase()
	
	IE.InitializeDatabase = nil
	
	IE.InitializedDatabase = true
	
	TMW:Fire("TMW_IE_DB_INITIALIZING")
	TMW:UnregisterAllCallbacks("TMW_IE_DB_INITIALIZING")
	
	--------------- Database ---------------
	local TMWOptDB_alias
	if TMWOptDB and TMWOptDB.Version == nil then
		-- if TMWOptDB.Version is nil then we are upgrading from a version from before
		-- AceDB-3.0 was used for the options settings.

		TMWOptDB_alias = TMWOptDB

		-- Overwrite the old database (we will restore from the alias in a second)
		-- 62216 was the first version to use AceDB-3.0
		_G.TMWOptDB = {Version = 62216}

	elseif type(TMWOptDB) ~= "table" then
		-- TMWOptDB might not exist if this is a fresh install
		-- or if the user is upgrading from a really old version that doesn't use TMWOptDB.
		_G.TMWOptDB = {Version = TELLMEWHEN_VERSIONNUMBER}
	end
	
	
	-- Handle upgrades that need to be done before defaults are added to the database.
	-- Primary purpose of this is to properly upgrade settings if a default has changed.
	IE:RawUpgrade()
	
	-- Initialize the database
	IE.db = AceDB:New("TMWOptDB", IE.Defaults)
	
	if TMWOptDB_alias then
		for k, v in pairs(TMWOptDB_alias) do
			IE.db.global[k] = v
		end
		
		IE.db = AceDB:New("TMWOptDB", IE.Defaults)
	end
	
	IE.db.RegisterCallback(IE, "OnProfileChanged",	"OnProfile")
	IE.db.RegisterCallback(IE, "OnProfileCopied",	"OnProfile")
	IE.db.RegisterCallback(IE, "OnProfileReset",	"OnProfile")
	IE.db.RegisterCallback(IE, "OnNewProfile",		"OnProfile")
	
	-- Handle normal upgrades after the database has been initialized.
	IE:UpgradeGlobal()
	IE:UpgradeProfile()

	if TMW.DBWasEmpty and IE.db.global.TellMeWhenDBBackup then
		-- TellMeWhenDB was corrupted. Restore from the backup and notify user.
		TellMeWhenDB = IE.db.global.TellMeWhenDBBackup

		TMW:InitializeDatabase()
		TMW.db.profile.Locked = false

		TMW:ScheduleUpdate(1)

		TellMeWhen_DBRestoredNofication:SetTime(IE.db.global.TellMeWhenDBBackupDate)
		TellMeWhen_DBRestoredNofication:Show()

	elseif not TMW.db.global.BackupDbInOptions then
		-- User has disabled storing of DB backups in the options. Get rid of it.
		IE.db.global.TellMeWhenDBBackupDate = nil
		if IE.db.global.TellMeWhenDBBackup then
			collectgarbage()
			IE.db.global.TellMeWhenDBBackup = nil
		end
	elseif not TMW.DBWasEmpty then
		-- TellMeWhenDB was not corrupt, so back it up.
		IE.db.global.TellMeWhenDBBackupDate = time()
		IE.db.global.TellMeWhenDBBackup = TellMeWhenDB
	end

	TMW:Fire("TMW_IE_DB_INITIALIZED")
	TMW:UnregisterAllCallbacks("TMW_IE_DB_INITIALIZED")
end

function IE:OnProfile(event, arg2, arg3)

	if IE.Initialized then

		-- Reload the icon editor.
		IE:LoadIcon(1, false)
		IE:LoadGroup(1, false)

	
		TMW:Fire("TMW_IE_ON_PROFILE", event, arg2, arg3)
	end
end

TMW:RegisterCallback("TMW_ON_PROFILE", function(event, arg2, arg3)
	IE.db:SetProfile(TMW.db:GetCurrentProfile())
end)








function IE:OnUpdate()
	local icon = CI.icon

	-- update the top of the icon editor with the information of the current tab.
	-- this is done in an OnUpdate because it is just too hard to track when the texture changes sometimes.
	-- I don't want to fill up the main addon with configuration code to notify the IE of texture changes	
	local tabGroup = IE.CurrentTabGroup
	if tabGroup then

		IE.icontexture:SetTexture(nil)

		IE.Header:SetText(nil)
		IE.Header:SetPoint("LEFT", IE.icontexture, "RIGHT", 4, 0)
		IE.Header:SetFontObject(GameFontNormal)

		tabGroup:SetupHeader()

		if not IE.Header:GetText() then
			IE.Header:SetText("TellMeWhen v" .. TELLMEWHEN_VERSION_FULL)
		end
	end
	
	
	if IE.isMoving then
		local cursorCurrentX, cursorCurrentY = GetCursorPosition()
		local deltaX, deltaY = IE.cursorStartX - cursorCurrentX, IE.cursorStartY - cursorCurrentY
		
		local scale = IE:GetEffectiveScale()
		deltaX, deltaY = deltaX/scale, deltaY/scale
		
		local a, b, c = IE:GetPoint()
		IE:ClearAllPoints()
		IE:SetPoint(a, b, c, IE.startX - deltaX, IE.startY - deltaY)
	end
end


function IE:BAR_HIDEGRID()
	IE.DraggingInfo = nil
end

TMW:RegisterCallback("TMW_CONFIG_TAB_CLICKED", function(event, tab)
	if IE.CurrentTabGroup.identifier == "ICON" then
		IE.ResetButton:Enable()
	else
		IE.ResetButton:Disable()
	end
end)

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	-- GLOBALS: TellMeWhen_ConfigWarning
	if not TMW.Locked then
		if IE.db.global.ConfigWarning then
			TellMeWhen_ConfigWarning:Show()
		else
			TellMeWhen_ConfigWarning:Hide()
		end
	else
		TellMeWhen_ConfigWarning:Hide()
	end

	IE:SaveSettings()
end)

IE:RegisterEvent("PLAYER_REGEN_DISABLED", function()
	if not TMW.ALLOW_LOCKDOWN_CONFIG then
		IE:Hide()
	end
end)

TMW:RegisterCallback("TMW_LOCK_TOGGLED", function(event, Locked)
	if Locked and not CI.icon then
		IE:Hide()
	end
end)

function IE:StartMoving()
	IE.startX, IE.startY = select(4, IE:GetPoint())
	IE.cursorStartX, IE.cursorStartY = GetCursorPosition()
	IE.isMoving = true
end

function IE:StopMovingOrSizing()
	IE.isMoving = false
end





---------- Interface ----------

function IE:PositionPanels(parentPageName, panelList)
	TMW:SortOrderedTables(panelList)
	

	local panelColumns = TellMeWhen_IconEditor.Pages[parentPageName].panelColumns
	for _, panelColumn in ipairs(panelColumns) do
		for _, panel in TMW:Vararg(panelColumn:GetChildren()) do
			panel:Hide()
		end
		wipe(panelColumn.currentPanels)
	end
	
	local IE_FL = IE:GetFrameLevel()

	for i, panelInfo in ipairs(panelList) do

		if not panelInfo.columnIndex or panelInfo.columnIndex < 1 or panelInfo.columnIndex > #panelColumns then	
			local frameName = panelInfo:GetFrameName()
			error("columnIndex out of bounds for panel " .. frameName)
		end
		
		local panelColumn = panelColumns[panelInfo.columnIndex]
		local panel = panelInfo:GetPanel(panelColumn)

		if panel then
			local last = panelColumn.currentPanels[#panelColumn.currentPanels]

			if type(last) == "table" then
				panel:SetPoint("TOP", last, "BOTTOM", 0, -20)
			else
				panel:SetPoint("TOP", 0, -14)
			end
			
			panel:Show()
			panel:SetFrameLevel(IE_FL + 3)

			-- Panel may be hidden by calling :Setup(), so we check after calling
			-- to see if the panel is still shown.
			panel:Setup(panelInfo)

			if panel:IsShown() then
				panelColumn.currentPanels[#panelColumn.currentPanels + 1] = panel
			end
		end	
	end	
end

function IE:DistributeFrameAnchorsLaterally(parent, numPerRow, ...)
	local numChildFrames = select("#", ...)
	
	local parentWidth = parent:GetWidth()

	local paddingPerSide = 5 -- constant
	local parentWidth_padded = parentWidth - paddingPerSide*2
	
	local widthPerFrame = parentWidth_padded/numPerRow
	
	local lastChild
	for i = 1, numChildFrames do
		local child = select(i, ...)
		
		local yOffset = 0
		for i = 1, child:GetNumPoints() do
			local point, relativeTo, relativePoint, x, y = child:GetPoint(i)
			if point == "LEFT" then
				yOffset = y or 0
				break
			end
		end
		
		if lastChild then
			child:SetPoint("LEFT", lastChild, "RIGHT", widthPerFrame - lastChild:GetWidth(), yOffset)
		else
			child:SetPoint("LEFT", paddingPerSide, yOffset)
		end
		lastChild = child
	end
end

function IE:DistributeCheckAnchorsEvenly(parent, ...)
	local numChildFrames = select("#", ...)
	
	local widthPerFrame = parent:GetWidth()/(numChildFrames + 1)
	local leftClickArea = 25

	local lastChild
	for i = 1, numChildFrames do
		local child = select(i, ...)

		TMW:ValidateType("...", "DistributeCheckAnchorsEvenly(parent, ...)", child, "Config_CheckButton")
		
		local xOffs = widthPerFrame - (child:GetWidth() / 1)

		child:ConstrainLabel(child, "RIGHT", min(widthPerFrame - child:GetWidth() - leftClickArea, 200), 0)
		if lastChild then
			child:SetPoint("LEFT", lastChild, "LEFT", widthPerFrame, 0)
		else
			-- Offset the first one by half of its width so that things stay nice and centered.
			child:SetPoint("LEFT", xOffs, 0)
		end

		-- Reposition the click interceptor so that users can click on either side of the check.
		-- Normally, it is only on the right side, but this feels really strange.
		child.ClickInterceptor:ClearAllPoints()
		child.ClickInterceptor:SetPoint("TOP")
		child.ClickInterceptor:SetPoint("BOTTOM")
		child.ClickInterceptor:SetPoint("RIGHT", child.text)
		child.ClickInterceptor:SetPoint("LEFT", child, "LEFT", -leftClickArea, 0)

		lastChild = child
	end
end



function IE:Load(isRefresh)
	if not isRefresh then
		-- Finish caching really quickly when the icon editor is opened.
		-- Users aren't going to care about their FPS so much when it gets opened.
		-- It doesn't do much good to increase this too far - the more cached per frame,
		-- the slower each frame will be.
		TMW:GetModule("SpellCache"):SetNumCachePerFrame(3000)

		IE:Show()
	end
	
	if IE:GetBottom() <= 0 then
		IE.db.global.EditorScale = IE.Defaults.global.EditorScale
		IE.db.global.EditorHeight = IE.Defaults.global.EditorHeight
	end

	IE:RefreshTabs()
	

	IE.resizer:SetModes(
		IE.db.global.ScaleIE and IE.resizer.MODE_SCALE or IE.resizer.MODE_STATIC,
		IE.resizer.MODE_SIZE)

	IE:SetScale(IE.db.global.ScaleIE and IE.db.global.EditorScale or 1)
	IE:SetHeight(IE.db.global.EditorHeight)

	TMW:Fire("TMW_CONFIG_LOADED")

	IE:ResizeTabs()
end


-- TODO: integrate this with history sets
function IE:Reset()	
	IE:SaveSettings() -- this is here just to clear the focus of editboxes, not to actually save things
	
	CI.icon:DisableIcon()
	
	TMW.CI.icon.group:GetSettings().Icons[CI.icon.ID] = nil
	
	TMW:Fire("TMW_ICON_SETTINGS_RESET", CI.icon)
	
	CI.icon:Setup()
	
	IE:LoadIcon(1)
end

function IE:ShowConfirmation(confirmText, desc, action)
	local Description = IE.Pages.Confirm.MiddleBand.Description
	Description:SetText(desc)

	local AcceptButton = IE.Pages.Confirm.MiddleBand.AcceptButton
	AcceptButton:SetText(confirmText)
	AcceptButton:SetWidth(AcceptButton:GetTextWidth() + 20)
	AcceptButton.Action = action

	IE:DisplayPage("Confirm")
end

function IE:SaveSettings()
	IE:CScriptTunnel("ClearFocus")
end


---------- Equivalancies ----------
function IE:Equiv_GenerateTips(equiv)
	local IDs = TMW:SplitNames(TMW.EquivFullIDLookup[equiv])
	local original = TMW.EquivOriginalLookup[equiv]

	for k, v in pairs(IDs) do
		local name, _, texture = GetSpellInfo(v)
		if not name then
			if TMW.debug then
				TMW:Error("INVALID ID FOUND: %s:%s", equiv, v)
				name = "INVALID " .. v
			else
				name = v
			end
			texture = "Interface\\Icons\\INV_Misc_QuestionMark"
		end

		-- If this spell is tracked only by ID, add the ID in parenthesis
		local originalSpell = original[k]
		if originalSpell > 0 then
			name = format("%s |cff7f6600(%d)|r", name, originalSpell)
		end

		tiptemp[name] = tiptemp[name] or "|T" .. texture .. ":0|t" .. name
	end

	local r = ""
	for name, line in TMW:OrderedPairs(tiptemp) do
		r = r .. line .. "\r\n"
	end

	r = strtrim(r, "\r\n ;")
	wipe(tiptemp)
	return r
end
TMW:MakeSingleArgFunctionCached(IE, "Equiv_GenerateTips")







---------------------------------
-- Config Classes
---------------------------------


-- These classes are declared in TellMeWhen.lua. This extends them.
TMW.C.ConfigPanelInfo {
	GetPanel = function(self, panelColumn)
		if not self.panel and _G[self:GetFrameName()] then
			self.panel = _G[self:GetFrameName()]
		end
		if self.panel then
			self.panel:SetParent(panelColumn)

			return self.panel
		end

		local success
		success, self.panel = TMW.safecall(self.MakePanel, self, panelColumn)

		if self.panel then
			self.panel.panelInfo = self
		end

		return self.panel
	end,
}

TMW.C.XmlConfigPanelInfo {
	GetFrameName = function(self)
		return self.xmlTemplateName
	end,

	MakePanel = function(self, panelColumn)
		local panel = CreateFrame("Frame", self:GetFrameName(), panelColumn, self.xmlTemplateName)

		if not panel.isLibOOInstance then
			TMW:CInit(panel)
		end

		return panel
	end,
}

TMW.C.LuaConfigPanelInfo {
	GetFrameName = function(self)
		return self.frameName
	end,

	MakePanel = function(self, panelColumn)
		local panel = TMW.C.Config_Panel:New("Frame", self:GetFrameName(), panelColumn, "TellMeWhen_OptionsModuleContainer")

		TMW.safecall(self.constructor, panel)
		
		-- no longer needed. Off to the GC!
		self.constructor = nil

		return panel
	end,
}

TMW:NewClass("StaticConfigPanelInfo", "ConfigPanelInfo"){
	OnNewInstance_Static = function(self, order, frameKey)
		TMW:ValidateType(2, "LuaConfigPanelInfo:New()", order, "number")
		TMW:ValidateType(3, "StaticConfigPanelInfo:New()", frameKey, "string")

		self.order = order
		self.frameKey = frameKey
	end,

	GetFrameName = function(self)
		error("don't try to get the frame name of static config panels")
	end,

	GetPanel = function(self, panelColumn)
		if not self.panel then
			self.panel = panelColumn[self.frameKey]
		end

		if not self.panel then
			error("Couldnt find static config panel with key " .. self.frameKey)
		end

		return self.panel
	end,
}




local CScriptProvider
local CS_SDepth = 0
local CS_Root = "";
local function bubble(frame, get, script, ...)
	if not frame then
		return
	end

	if frame.isLibOOInstance and frame.class.inherits[CScriptProvider] then
		if get then
			local ret = frame:CScriptCallGet(script, ...)
			if ret ~= nil then
				return ret
			end
		else
			frame:CScriptCall(script, ...)
		end
	end

	return bubble(frame:GetParent(), get, script, ...)
end

local function tunnel(frame, get, script, ...)
	if frame.isLibOOInstance and frame.class.inherits[CScriptProvider] then
		if get then
			local ret = frame:CScriptCallGet(script, ...)
			if ret ~= nil then
				return ret
			end
		else
			frame:CScriptCall(script, ...)
		end
	end

	for _, child in TMW:Vararg(frame:GetChildren()) do
		local ret = tunnel(child, get, script, ...)
		if get and ret ~= nil then
			return ret
		end
	end
end


CScriptProvider = TMW:NewClass("CScriptProvider"){
	DEBUG_MaxDepth = 25,

	CScriptTunnelGet = function(self, script, ...)
		for _, child in TMW:Vararg(frame:GetChildren()) do
			local ret = tunnel(child, true, script, ...)
			if ret then
				return ret
			end
		end
	end,
	CScriptBubbleGet = function(self, script, ...)
		return bubble(self:GetParent(), true, script, ...)
	end,
	CScriptTunnel = function(self, script, ...)
		if CS_SDepth == 0 then
			CS_Root = script .. ":" .. (self:GetDebugName() or self.setting or "?")
		end
		CS_SDepth = CS_SDepth + 1

		for _, child in TMW:Vararg(self:GetChildren()) do
			tunnel(child, false, script, ...)
		end

		CS_SDepth = CS_SDepth - 1
	end,
	CScriptBubble = function(self, script, ...)
		if CS_SDepth == 0 then
			CS_Root = script .. ":" .. (self:GetDebugName() or self.setting or "?")
		end
		CS_SDepth = CS_SDepth + 1

		bubble(self:GetParent(), false, script, ...)

		CS_SDepth = CS_SDepth - 1
	end,

	CScriptAdd = function(self, script, func)
		TMW:ValidateType("script", "CScriptAdd(script, func)", script, "string")
		TMW:ValidateType("func", "CScriptAdd(script, func)", func, "function")

		self.__CScripts = self.__CScripts or {}
		local existing = self.__CScripts[script]

		if existing == nil then
			self.__CScripts[script] = func
		elseif type(existing) == "function" then
			self.__CScripts[script] = {existing, func}
		else
			tinsert(existing, func)
		end
	end,

	CScriptAddPre = function(self, script, func)
		TMW:ValidateType("script", "CScriptAddPre(script, func)", script, "string")
		TMW:ValidateType("func", "CScriptAddPre(script, func)", func, "function")

		self.__CScripts = self.__CScripts or {}
		local existing = self.__CScripts[script]

		if existing == nil then
			self.__CScripts[script] = func
		elseif type(existing) == "function" then
			self.__CScripts[script] = {func, existing}
		else
			tinsert(existing, 1, func)
		end
	end,

	CScriptRemove = function(self, script, func)
		TMW:ValidateType("script", "CScriptRemove(script, func)", script, "string")
		TMW:ValidateType("func", "CScriptRemove(script, func)", func, "function;nil")

		if not self.__CScripts then
			return
		end

		if func == nil then
			self.__CScripts[script] = nil
			return
		end

		local existing = self.__CScripts[script]
		if not existing then
			return
		end

		if type(existing) == "function" then
			if existing == func then
				self.__CScripts[script] = nil
			end
		else
			TMW.tDeleteItem(existing, func, 1)
		end
	end,

	CScriptRemoveAll = function(self)
		self.__CScripts = nil
	end,

	CScriptCall = function(self, script, ...)
		if not self.__CScripts then
			return
		end

		local cscript = self.__CScripts[script]
		if not cscript then
			return
		end
		
		if CS_SDepth == 0 then
			CS_Root = script .. ":" .. (self:GetDebugName() or self.setting or "?")
		end
		CS_SDepth = CS_SDepth + 1
		-- If we enter 10 deep cscripts, go into emergency mode
		-- and start recording data about what is being called.
		if CS_SDepth > 10 and not self.DEBUG_Started then
			self:DEBUG_Start()
		end

		if type(cscript) == "function" then
			TMW.safecall(cscript, self, ...)
		else
			for i = 1, #cscript do
				TMW.safecall(cscript[i], self, ...)
			end
		end
		CS_SDepth = CS_SDepth - 1
	end,

	CScriptCallGet = function(self, script, ...)
		if not self.__CScripts then
			return
		end

		local existing = self.__CScripts[script]
		if not existing then
			return
		end

		if type(existing) == "function" then
			return existing(self, ...)
		else
			for i = 1, #existing do
				local ret = existing[i](self, ...)
				if ret then
					return ret
				end
			end
		end
	end,

	DEBUG_Start = function(self)
		if not CScriptProvider.DEBUG_Started then
			print("entering cscript debug mode")

			CScriptProvider.DEBUG_Stack = {{"ROOT", CS_Root}}
			CScriptProvider.DEBUG_PrevDepth = CS_SDepth - 1

			CScriptProvider.CScriptCall_ORIGINAL = CScriptProvider.CScriptCall
			CScriptProvider.CScriptBubble_ORIGINAL = CScriptProvider.CScriptBubble
			CScriptProvider.CScriptTunnel_ORIGINAL = CScriptProvider.CScriptTunnel

			CScriptProvider:PreHookMethod("CScriptCall", self.DEBUG_CScriptCallBase)
			CScriptProvider:PreHookMethod("CScriptBubble", self.DEBUG_CScriptCallBase)
			CScriptProvider:PreHookMethod("CScriptTunnel", self.DEBUG_CScriptCallBase)

			CScriptProvider.DEBUG_Started = true
		end
	end,

	DEBUG_Stop = function(self)
		if CScriptProvider.DEBUG_Started then
			print("leaving cscript debug mode")

			CScriptProvider.DEBUG_PrevDepth = nil
			CScriptProvider.DEBUG_PrevStackFrame = nil
			CScriptProvider.DEBUG_Stack = nil

			CScriptProvider.CScriptCall = CScriptProvider.CScriptCall_ORIGINAL
			CScriptProvider.CScriptBubble = CScriptProvider.CScriptBubble_ORIGINAL
			CScriptProvider.CScriptTunnel = CScriptProvider.CScriptTunnel_ORIGINAL

			CScriptProvider.DEBUG_Started = false
		end
	end,

	DEBUG_CScriptCallBase = function(self, script, ...)
		if not CScriptProvider.DEBUG_Started then
			return
		end

		-- Only record calls that change the stack depth.
		local name = tostring(self:GetDebugName() or self.setting or self.class)
			:gsub("^TellMeWhen_?", "")
			:gsub("_IconEditorPages", "P*")
			:gsub("_IconEditor", "IE")
			:gsub("[%x]*.container", "S*")
		local stackFrame = {CS_SDepth, script, name}
		if CScriptProvider.DEBUG_PrevDepth ~= CS_SDepth then
			tinsert(CScriptProvider.DEBUG_Stack, CScriptProvider.DEBUG_PrevStackFrame)
			tinsert(CScriptProvider.DEBUG_Stack, stackFrame)

			CScriptProvider.DEBUG_PrevStackFrame = nil
			CScriptProvider.DEBUG_PrevDepth = CS_SDepth
		else
			-- We do this so we can get calls right before the stack depth changes,
			-- which are usually what cause it.
			CScriptProvider.DEBUG_PrevStackFrame = stackFrame
		end

		if CS_SDepth < 2 then
			print("fell out of cscript debug mode")
			-- If it fell back down below ~2, then it recovered somehow.

			CScriptProvider:DEBUG_Stop()

		elseif CS_SDepth > self.DEBUG_MaxDepth then
			-- Its gone on long enough. Report the data we got about what's going on.
			local str = ""
			for i, data in pairs(CScriptProvider.DEBUG_Stack) do
				str = str .. table.concat(data, ":") .. "\n"
			end

			-- We fire this off in a delayed timer as well since there is a
			-- good chance that the stack depth will end up going negative as the stack unwinds through some safecalls.
			CS_SDepth = 0
			C_Timer.After(0, function() CS_SDepth = 0 end)

			CScriptProvider:DEBUG_Stop()

			error("TellMeWhen: CScript Overflow: " .. str)
		end
	end,
}


TMW:NewClass("Config_Frame", "Frame", "CScriptProvider"){

	-- Constructor
	OnNewInstance_Frame = function(self)

		-- Setup callbacks that will load the settings when needed.
		if self.ReloadSetting ~= TMW.NULLFUNC then
			self:CScriptAdd("ReloadRequested", self.ReloadSetting)
		end
	end,

	SetSetting = function(self, key)
		self.setting = key
	end,

	SetTexts = function(self, title, tooltip)
		self:SetTooltip(title, tooltip)
	end,
	

	-- Script Handlers
	OnEnable = function(self)
		self:SetAlpha(1)
	end,
	
	OnDisable = function(self)
		self:SetAlpha(0.2)
	end,
	

	-- Methods
	Enabled = true,
	IsEnabled = function(self)
		return self.Enabled
	end,
	SetEnabled = function(self, enabled)
		if self.Enabled ~= enabled then
			self.Enabled = enabled
			if enabled then
				self:OnEnable()
			else
				self:OnDisable()
			end
		end
	end,
	Enable = function(self)
		self:SetEnabled(true)
	end,
	Disable = function(self)
		self:SetEnabled(false)
	end,
	
	SetTooltip = function(self, title, text)
		if self.SetMotionScriptsWhileDisabled then
			TMW:TT(self, title, text, 1, 1, nil)
		else
			TMW:TT(self, title, text, 1, 1, "IsEnabled")
		end
	end,
	
	ConstrainLabel = function(self, anchorTo, anchorPoint, x, y)
		assert(self.text, "frame does not have a self.text object to constrain.")

		if not x then
			x = -3
		end

		self.text:SetPoint("RIGHT", anchorTo, anchorPoint or "LEFT", x, y)

		self.text:SetHeight(30)
		self.text:SetMaxLines(3)
	end,

	SetAnimateHeightAdjustments = function(self, animateHeightAdjusts)
		self.animateHeightAdjusts = animateHeightAdjusts
	end,

	SetMinAdjustHeight = function(self, minAdjustHeight)
		self.minAdjustHeight = minAdjustHeight
	end,

	SetAdjustHeightExclusion = function(self, frame, exclude)
		if not frame then
			return
		end

		self.adjustHeightExclusions = self.adjustHeightExclusions or {}

		TMW.tDeleteItem(self.adjustHeightExclusions, frame)

		if exclude then
			tinsert(self.adjustHeightExclusions, frame)
		end
	end,


	__AdjustHeightCheckBottom = function(self, child)
		for i = 1, child:GetNumPoints() do
			local point, relTo, relPoint = child:GetPoint(i)
			if relTo == self and relPoint:find("BOTTOM") then
				error("Attempted to adjust height of a frame with a child anchored to the bottom of the frame: " 
					.. (TMW.tContains(self, child) or child:GetName() or "???"), 3)
			end
		end
	end,

	CalculateAutoHeight = function(self, bottomPadding)
		if not self:GetTop() then
			return -1
		end

		local top = self:GetTop() * self:GetEffectiveScale()
		local lowest = top

		if not lowest or lowest < 0 then
			return -1
		end

		local highest = -math.huge
		local exclusions = self.adjustHeightExclusions

		-- Find child frames.
		for _, child in TMW:Vararg(self:GetChildren()) do
			if not child:GetBottom() then
				-- If there are children that we can't get the edges of,
				-- don't try to resize anything, because it will almost certainly be wrong.
				return -1
			end

			if child:IsShown()
			and (not exclusions or not TMW.tContains(exclusions, child))
			then
				self:__AdjustHeightCheckBottom(child)

				local _, _, topInset, bottomInset = child:GetHitRectInsets()

				local childTop = (child:GetTop() - topInset) * child:GetEffectiveScale()

				-- Only look at children that have their top below the parent.
				-- Otherwise, we'll get weird things for the highest value because
				-- of things like header font strings.
				if childTop <= top then
					lowest = min(lowest, (child:GetBottom() + bottomInset) * child:GetEffectiveScale())
					highest = max(highest, childTop)
				end
			end
		end

		-- Find child fontstrings.
		-- Don't look for textures - we almost always don't need them to fit within the frame.
		-- Usually, there is a background texture that will screw everything up if it is included.
		for _, child in TMW:Vararg(self:GetRegions()) do
			if child:IsShown()
			and child:GetBottom()
			and child:GetObjectType() == "FontString"
			and (not exclusions or not TMW.tContains(exclusions, child))
			and child:GetText()
			and child:GetText() ~= ""
			then
				self:__AdjustHeightCheckBottom(child)

				local childTop = child:GetTop() * self:GetEffectiveScale()

				-- Only look at children that have their top below the parent.
				-- Otherwise, we'll get weird things for the highest value because
				-- of things like header font strings.
				if childTop < top then
					lowest = min(lowest, child:GetBottom() * self:GetEffectiveScale())
					highest = max(highest, childTop)
				end
			end
		end

		-- If we didn't find any children at all, stop.
		if highest == -math.huge then
			return -1
		end

		-- If a bottom padding isn't specified, calculate it using the same gap
		-- that exists between the highest child and the top of the frame.
		bottomPadding = bottomPadding or (top - highest)
		bottomPadding = max(bottomPadding, 0)

		local height = (top - lowest + bottomPadding) / self:GetEffectiveScale()
		return max(self.minAdjustHeight or 1, height)
	end,

	AdjustHeight = function(self, bottomPadding, duration)
		if self.animateHeightAdjusts then
			self:AdjustHeightAnimated(bottomPadding, duration)
		else
			self:AdjustHeightUnanimated(bottomPadding)
		end
	end,

	AdjustHeightUnanimated = function(self, bottomPadding)
		local height = self:CalculateAutoHeight(bottomPadding)

		if height == -1 then return end

		self:SetHeight(height)
	end,

	AdjustHeightAnimated = function(self, bottomPadding, duration)
		local height = self:CalculateAutoHeight(bottomPadding)

		if height == -1 then return end

		TMW:AnimateHeightChange(self, height, duration or 0.1)
	end,


	GetParentKey = function(self)
		return TMW.tContains(self:GetParent(), self)
	end,

	GetSettingTable = function(self)
		return self:CScriptCallGet("SettingTableRequested") or self:CScriptBubbleGet("SettingTableRequested")
	end,

	OnSettingSaved = function(self)
		IE:SaveSettings()

		self:CScriptCall("SettingSaved")
		self:CScriptBubble("DescendantSettingSaved", self)
	end,

	RequestReload = function(self)
		self:CScriptCall("ReloadRequested")
		self:RequestReloadChildren()
	end,

	RequestReloadChildren = function(self)
		self:CScriptTunnel("ReloadRequested")
	end,

	ReloadSetting = TMW.NULLFUNC
}

TMW:NewClass("Config_Panel", "Config_Frame"){
	SetHeight_base = TMW.C.Config_Panel.SetHeight,
}{
	OnNewInstance_Panel = function(self)
		if self:GetHeight() <= 0 then
			self:SetHeight_base(1)
		end

		self.Background:SetColorTexture(.66, .66, .66, 0.09)
	end,

	Flash = function(self, dur)
		local start = GetTime()
		local duration = 0
		local period = 0.2

		while duration < dur do
			duration = duration + (period * 2)
		end
		local ticker
		ticker = C_Timer.NewTicker(0.01, function() 
			local bg = TellMeWhen_DotwatchSettings.Background

			local timePassed = GetTime() - start
			local fadingIn = FlashPeriod == 0 or floor(timePassed/period) % 2 == 1

			if FlashPeriod ~= 0 then
				local remainingFlash = timePassed % period
				local offs
				if fadingIn then
					offs = (period-remainingFlash)/period
				else
					offs = (remainingFlash/period)
				end
				offs = offs*0.3
				bg:SetColorTexture(.66, .66, .66, 0.08 + offs)
			end

			if timePassed > duration then
				bg:SetColorTexture(.66, .66, .66, 0.08)
				ticker:Cancel()
			end	
		end)
	end,

	SetTitle = function(self, text)
		self.Header:SetText(text)

		local font, size, flags = self.Header:GetFont()
		size = 12
		self.Header:SetFont(font, size, flags)

		while size > 6 and self.Header:GetStringWidth() > self:GetWidth() - 10 do
			size = size - 1
			self.Header:SetFont(font, size, flags)
		end
	end,

	Setup = function(self, panelInfo)
		self.panelInfo = panelInfo

		if type(panelInfo.supplementalData) == "table" then
			local OnSetup = panelInfo.supplementalData.OnSetup

			if OnSetup then
				OnSetup(self, panelInfo, panelInfo.supplementalData)
			end
		end

		self:CScriptCall("PanelSetup", self, panelInfo)
		self:CScriptTunnel("PanelSetup", self, panelInfo)

		self:RequestReload()

		if self.autoAdjustHeight then
			self:AdjustHeight(tonumber(self.autoAdjustHeight))
		end
	end,

	SetAutoAdjustHeight = function(self, enabled)
		-- If enabled is a number, it will be used as the bottom padding passed to AdjustHeight(bottomPadding)
		self.autoAdjustHeight = enabled
	end,


	BuildSimpleCheckSettingFrame = function(self, arg2, arg3)
		local className, allData, objectType
		if arg3 ~= nil then
			allData = arg3
			className = arg2
		else
			allData = arg2
			className = "Config_CheckButton"
		end

		local sig = "Config_Panel:BuildSimpleCheckSettingFrame([className,] allData)"
		TMW:ValidateType("panel",     sig, self,     "Config_Panel")
		TMW:ValidateType("className", sig, className, "string")
		TMW:ValidateType("allData",   sig, allData,   "table")

		local class = TMW.Classes[className]
		local objectType = class.isFrameObject
		
		assert(class, "Couldn't find class named " .. className .. ".")
		assert(type(objectType) == "string", "Couldn't find a WoW frame object type for class named " .. className .. ".")
		
		
		local lastCheckButton
		local numFrames = 0
		local numPerRow = allData.numPerRow or min(#allData, 2)
		self.checks = {}
		for i, data in ipairs(allData) do
			if data then -- skip over falses (dont freak out about them, they are probably intentional)

				local f = class:New(objectType, nil, self, "TellMeWhen_CheckTemplate", i)
				data(f)

				-- An human-friendly-ish unique (hopefully) identifier for the frame
				if f.setting then
					self[f.setting .. (f.value ~= nil and tostring(f.value) or "")] = f
				end

				-- I would store these directly on self,
				-- but framestack breaks catastrophically when you store frames on their parent with integer keys.
				self.checks[i] = f
				
				if lastCheckButton then
					-- Anchor it to the previous check if it isn't the first one.
					if numFrames%numPerRow == 0 then
						f:SetPoint("TOP", self.checks[i-numPerRow], "BOTTOM", 0, 2)
					else
						-- This will get overwritten soon.
						--f:SetPoint("LEFT", "RIGHT", 5, 0)
					end
				else
					-- Anchor the first check to the self. The left anchor will be handled by DistributeFrameAnchorsLaterally.
					f:SetPoint("TOP", 0, -1)
				end
				lastCheckButton = f
				
				f.row = ceil(i/numPerRow)
				
				numFrames = numFrames + 1
			end
		end
		
		-- Set the bounds of the label text on all the checkboxes to prevent overlapping.
		for i = 1, #self.checks do
			local f0 = self.checks[i]
			local f1 = self.checks[i+1]
			
			if not f1 or f1.row ~= f0.row then
				f0:ConstrainLabel(self, "RIGHT")
			else
				f0:ConstrainLabel(f1)
			end
		end
		
		for i = 1, #self.checks, numPerRow do
			IE:DistributeFrameAnchorsLaterally(self, numPerRow, unpack(self.checks, i))
		end
		
		self:AdjustHeight()
		
		return self
	end,

	OnSizeChanged = function(self)
		-- This method does resizing of the header to make it fit without truncation.
		self:SetTitle(self.Header:GetText())
	end,
}

TMW:NewClass("Config_Page", "Config_Frame"){
	OnNewInstance_Page = function(self)
		-- This one is admittedly pretty pointless - pages shouldn't have settings themselves,
		-- but we'll do it anyway to avoid unexpected behavior.
		self:CScriptAdd("SettingSaved", self.RequestReload)

		-- Whenever a setting on a page has been saved, reload the whole page.
		-- (RequestReload tunnels a ReloadRequested to all children.)
		self:CScriptAdd("DescendantSettingSaved", self.RequestReload)

		-- Whenever a page is reloaded, notify the page's tab that its page was reloaded.
		self:CScriptAdd("ReloadRequested", self.ReloadRequested)
	end,

	ReloadRequested = function(self)

		if IE.CurrentTab and IE.CurrentTab.pageKey == self:GetParentKey() then
			IE.CurrentTab:CScriptCall("PageReloadRequested", self)
		elseif not IE.CurrentTab then
			IE.UndoButton:Disable()
			IE.RedoButton:Disable()
		end
	end,
}

TMW:NewClass("Config_ScrollFrame", "ScrollFrame", "Config_Frame"){
	edgeScrollEnabled = false,
	edgeScrollMouseCursorRange = 20,
	edgeScrollScrollDistancePerSecond = 150,

	scrollPercentage = 1/2,
	scrollStep = nil,

	OnNewInstance_ScrollFrame = function(self)
		self:EnableMouseWheel(true)
		self:CScriptAdd("BeforeMouseWheelHandled", self.BeforeMouseWheelHandled)
	end,

	SetEdgeScrollEnabled = function(self, enabled, range, dps)
		self.edgeScrollEnabled = enabled
		self.edgeScrollMouseCursorRange = range or self.edgeScrollMouseCursorRange
		self.edgeScrollScrollDistancePerSecond = dps or self.edgeScrollScrollDistancePerSecond
	end,

	SetWheelStepPercentage = function(self, percent)
		self.scrollPercentage = percent
		self.scrollStep = nil
	end,

	SetWheelStepAmount = function(self, amount)
		self.scrollStep = amount
		self.scrollPercentage = nil
	end,



	ScrollToFrame = function(self, targetFrame)
		if not targetFrame then return end

		if not targetFrame:GetBottom() or not self:GetBottom() then
			return
		end

		local targetBottom = targetFrame:GetBottom()
		local targetTop = targetFrame:GetTop()

		local scrollBottom = self:GetBottom()
		local scrollTop = self:GetTop()

		-- This is added/subtracted so the thing that we scroll to ends
		-- up in the middle of the scrollframe instead of on the edge.
		local halfHeight = (scrollTop - scrollBottom)/2

		local scroll 
		if targetBottom < scrollBottom then
			-- It's too low. Scroll down.
			scroll = self:GetVerticalScroll() + (scrollBottom - targetBottom) + halfHeight

		elseif targetTop > scrollTop then
			-- It's too high. Scroll up.
			scroll = self:GetVerticalScroll() - (targetTop - scrollTop) - halfHeight
		end


		if scroll then
			local yrange = self:GetVerticalScrollRange()
			scroll = max(scroll, 0)
			scroll = min(scroll, self:GetVerticalScrollRange())

			self:SetVerticalScroll(scroll)
		end
	end,



	OnScrollRangeChanged = function(self)
		local yrange = self:GetVerticalScrollRange()

		if floor(yrange) == 0 then
			self.ScrollBar:Hide()
		else
			self.ScrollBar:Show()
		end

		if 0 >= self:GetVerticalScroll() then
			self:SetVerticalScroll(0)
		elseif self:GetVerticalScroll() > yrange then
			self:SetVerticalScroll(yrange)
		end

		local height = self:GetHeight()
		self.percentage = height / (yrange + height)

		self.ScrollBar.Thumb:SetHeight(max(height*self.percentage, 20))

		self.ScrollBar.Thumb:SetPoint("TOP", self, "TOP", 0, -(self:GetVerticalScroll() * self.percentage))


	end,

	OnVerticalScroll = function(self, offset)
		self.ScrollBar.Thumb:SetPoint("TOP", self, "TOP", 0, -(offset * self.percentage))
	end,

	OnMouseWheel = function(self, delta)
		local scrollStep = self.scrollStep or self:GetHeight() * self.scrollPercentage
		local newScroll

		if delta > 0 then
			newScroll = self:GetVerticalScroll() - scrollStep
		else
			newScroll = self:GetVerticalScroll() + scrollStep
		end

		if newScroll < 0 then
			newScroll = 0
		elseif newScroll > self:GetVerticalScrollRange() then
			newScroll = self:GetVerticalScrollRange()
		end

		self.LastWheelScrollX, self.LastWheelScrollY = GetCursorPosition()

		self:SetVerticalScroll(newScroll)
	end,

	BeforeMouseWheelHandled = function(self, delta)
		local x, y = GetCursorPosition()
		if self.LastWheelScrollX == x and self.LastWheelScrollY == y then
			-- Mouse is in the same position as it was the last time the user
			-- scrolled with their mouse wheel. It could be a total coincidence,
			-- but most likely, the user is trying to scroll down and some other
			-- mouse-wheel handling frame has landed under their cursor.
			-- They probably wanted to keep scrolling
			-- and not adjust the slider, so lets not adjust the slider.

			self:OnMouseWheel(delta)
			return 1
		end
	end,

	OnUpdate = function(self, elapsed)
		local range = self.edgeScrollMouseCursorRange

		if  self.edgeScrollEnabled
		and not self.ScrollBar.Thumb:IsDragging()
		and self:IsMouseOver(range, 0, -range, 0) -- allow the cursor to be above/below the frame, but not to the sides
		then
			local scale = self:GetEffectiveScale()
			local self_top, self_bottom = self:GetTop()*scale, self:GetBottom()*scale

			local _, cursorY = GetCursorPosition()

			local absDistance_top = abs(self_top - cursorY)
			local absDistance_bottom = abs(self_bottom - cursorY)

			local scrollStep
			if absDistance_top > absDistance_bottom then
				-- We are closer to the bottom of the frame
				if range > absDistance_bottom then
					scrollStep = -self.edgeScrollScrollDistancePerSecond*elapsed
				end
			else
				-- We are closer to the top of the frame
				if range > absDistance_top then
					scrollStep = self.edgeScrollScrollDistancePerSecond*elapsed
				end
			end

			if scrollStep then
				local newScroll = self:GetVerticalScroll() - scrollStep

				if 0 > newScroll then
					newScroll = 0
				elseif newScroll > self:GetVerticalScrollRange() then
					newScroll = self:GetVerticalScrollRange()
				end
				self:SetVerticalScroll(newScroll)
			end
		end
	end,

	OnSizeChanged = function(self)
		-- container's width doesn't get adjusted as we resize. Fix this.
		self.container:SetWidth(self:GetWidth())
	end,
}

TMW:NewClass("Config_Button", "Button", "Config_Frame"){
	SetTexts = function(self, title, tooltip)
		self:SetText(title)
		self:SetTooltip(title, tooltip)
	end,

	OnClick = function(self)
		TMW:ClickSound()
	end,
}

TMW:NewClass("Config_CheckButton", "CheckButton", "Config_Frame"){
	-- Constructor
	OnNewInstance_CheckButton = function(self)
		self:SetMotionScriptsWhileDisabled(true)

		if self.text then
			self.text:SetHeight(30)
			self.text:SetMaxLines(3)
		end
	end,

	SetTexts = function(self, title, tooltip)
		if not self.label then
			self:SetLabel(title)
		end
		self:SetTooltip(title, tooltip)
	end,

	SetLabel = function(self, label)
		self.label = label
		self.text:SetText(label)
	end,


	SetSetting = function(self, key, value)
		self.setting = key
		self.value = value
	end,

	-- Script Handlers
	OnClick = function(self, button)
		TMW:ClickSound()
		local settings = self:GetSettingTable()

		local checked = not not self:GetChecked()

		if settings and self.setting then
			if self.value == nil then
				settings[self.setting] = checked
			else
				settings[self.setting] = self.value
				self:SetChecked(true)
			end

			self:OnSettingSaved()
		end
	end,
	
	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			if self.value ~= nil then
				self:SetChecked(settings[self.setting] == self.value)
			else
				self:SetChecked(settings[self.setting])
			end
		end
	end,
}

TMW:NewClass("Config_EditBox", "EditBox", "Config_Frame"){
	
	-- Constructor
	OnNewInstance_EditBox = function(self)
	  	-- Cursor location displays incorrectly with non-zero spacing in WoW 8.0.
	  	-- We used to use a value of 2 here, but can't anymore.
		self:SetSpacing(0)

		self.BackgroundText:SetWidth(self:GetWidth())

		self:CScriptAdd("ClearFocus", self.ClearFocus)
	end,

	SetTexts = function(self, title, tooltip)
		if not self.label then
			self:SetLabel(title)
		end
		self:SetTooltip(title, tooltip)
	end,

	SetLabel = function(self, label)
		self.label = label
		self:GetScript("OnTextChanged")(self)
	end,
	
	UpdateLabel = function(self, label)
		local text = self:GetText()
		if text and text:trim(" \t\r\n") == "" then
			self.BackgroundText:SetText(self.label)
		else
			self.BackgroundText:SetText(nil)
		end
	end,

	SetNewlineOnEnter = function(self, enable)
		self.newlineOnEnter = enable
	end,

	MakeScrollable = function(self, ...)
		local ScrollFrame = TMW:ConvertContainerToScrollFrame(self, ...)

		ScrollFrame:SetWheelStepAmount(30)

		self.border:SetParent(ScrollFrame)
		self.border:ClearAllPoints()
		self.border:SetAllPoints(ScrollFrame)
		self.border:SetBorderSize(1)

		self.background:SetParent(ScrollFrame)
		self.background:ClearAllPoints()
		self.background:SetAllPoints(ScrollFrame)

		self.BackgroundText:SetPoint("LEFT", ScrollFrame)
		self.BackgroundText:SetPoint("RIGHT", ScrollFrame)

		self.clickInterceptor = CreateFrame("Button", nil, ScrollFrame)
		self.clickInterceptor:SetAllPoints(ScrollFrame)
		self.clickInterceptor:SetScript("OnClick", function()
			self:SetFocus()
		end)
	end,


	-- Scripts
	OnCursorChanged = function(self)
		if self.ScrollFrame and self:HasFocus() then
			local cursor = select(5, self:GetRegions())

			self.ScrollFrame:ScrollToFrame(cursor)
		end
	end,

	OnEscapePressed = function(self)
		self:ClearFocus()
	end,

	OnEnterPressed = function(self)
		if self:IsMultiLine() and self.newlineOnEnter then
			self:Insert("\n")
		elseif self:IsMultiLine() and IsModifierKeyDown() then
			self:Insert("\n")
		else
			self:ClearFocus()
		end
	end,

	OnTextChanged = function(self)
		self:UpdateLabel()
	end,

	OnEditFocusLost = function(self, button)
		self:HighlightText(0, 0)
		self:UpdateLabel()
		self:SaveSetting()
	end,

	METHOD_EXTENSIONS = {
		OnEnable = function(self)
			self:EnableMouse(true)
			self:EnableKeyboard(true)
		end,

		OnDisable = function(self)
			self:ClearFocus()
			self:EnableMouse(false)
			self:EnableKeyboard(false)
		end,
	},
	

	-- Methods
	SaveSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			local value = self:GetText() or ""
			
			value = self:CScriptCallGet("ModifyValueForSave", value) or value

			if settings[self.setting] ~= value then
				settings[self.setting] = value
				self:OnSettingSaved()
			else
				self:RequestReload()
			end
		end
	end,

	ReloadSetting = function(self, eventMaybe)
		local settings = self:GetSettingTable()

		if settings then
			if self.setting then
				local value = settings[self.setting]

				value = self:CScriptCallGet("ModifyValueForLoad", value) or value

				self:SetText(value)
			end

			self:ClearFocus()
		end
	end,

	SetAcceptsTMWLinks = function(self, accepts, linkDesc)
		self.acceptsTMWLinks = accepts
		self.acceptsTMWLinksDesc = accepts and linkDesc or nil
	end,

	GetAcceptsTMWLinks = function(self, accepts, linkDesc)
		return self.acceptsTMWLinks, self.acceptsTMWLinksDesc
	end,
}

TMW:NewClass("Config_EditBox_Lua", "Config_EditBox") {
	GetText_original = TMW.C.Config_EditBox_Lua.GetText,
	SetText_original = TMW.C.Config_EditBox_Lua.SetText,
	padNewlines = true,

	ColorTable = (function()
		local colorTable = {}
		local tokens = TMW.indentLib.tokens
		local function set(color, ...)
			for i, v in TMW:Vararg(...) do
				colorTable[v] = "|c00" .. color
			end
		end
		set('208CD6', tokens.TOKEN_KEYWORD)
		set('208CD6', tokens.TOKEN_SPECIAL)
		set('888888', tokens.TOKEN_STRING)
		set('FF8040', tokens.TOKEN_NUMBER)
		set('207128', tokens.TOKEN_COMMENT_SHORT, tokens.TOKEN_COMMENT_LONG)
		set('208CD6', "+","-","/","*","%","==","<","<=",">",">=","~=","and","or","not","..","=")
		set('ffffff', "(",")","{","}","[","]",",",".",":")
		set('f95f53', "function")
		set('93C763', "...","true","false","nil")

		return colorTable
	end)(),

	OnNewInstance_EditBox_Lua = function(self)
		TMW.indentLib.enable(self, self.ColorTable, 4)

		self:SetFont("Interface/Addons/TellMeWhen/Fonts/VeraMono.ttf", 11)

		self:SetNewlineOnEnter(true)

		local old = TMW.indentLib.padWithLinebreaks
		TMW.indentLib.padWithLinebreaks = function(code)
			if self:HasFocus() and not self.padNewlines then
				return code, false
			end
			return old(code)
		end

		self:SetAcceptsTMWLinks(true, TMW.L["LUA_INSERTGUID_TOOLTIP"])
		TMW.Classes.ChatEdit_InsertLink_Hook:New(self, self.InsertLinkHook)
	end,

	OnTabPressed = function(self)
		self:Insert("    ")
	end,

	SetPadNewlines = function(self, value)
		self.padNewlines = value;
	end,

	GetCursorLineNumber = function(self)
		local text = self:GetText_original()
		local curPos = self:GetCursorPosition()

		if curPos == 0 then
			return 1
		end

		local pos = 0
		for lineNum, line in TMW:Vararg(strsplit("\n", text)) do
			pos = pos + #line
			if pos >= curPos then
				return lineNum
			end
			pos = pos + 1
		end
	end,

	InsertLinkHook = function(self, text, linkType, linkData)
		-- if this editbox is active,
		-- attempt to insert a reference to the linked icon by GUID

		if linkType == "TMW" then
			-- Reconstruct the GUID
			local GUID = linkType .. ":" .. linkData

			self.editbox:Insert(("TMW:GetDataOwner(%q)"):format(GUID))

			-- notify success
			return true
		end
	end,
}


TMW:NewClass("Config_TimeEditBox", "Config_EditBox"){
	OnNewInstance_TimeEditBox = function(self)
		self:CScriptAdd("ModifyValueForSave", self.ModifyValueForSave)
		self:CScriptAdd("ModifyValueForLoad", self.ModifyValueForLoad)
	end,

	ModifyValueForSave = function(self, value)
		local t = TMW:CleanString(self)
		if strfind(t, ":") then
			t = TMW.toSeconds(t)
		end
		return tonumber(t) or 0
	end,

	ModifyValueForLoad = function(self, value)
		if value < 0 then
			return value
		end
		return TMW.C.Formatter.TIME_COLONS_FORCEMINS:Format(value)
	end,
}

TMW:NewClass("Config_EditBoxWithCheck", "Config_Frame"){
	OnNewInstance_TimeEditBoxWithCheck = function(self)
		self.EnableCheck:CScriptAdd("ReloadRequested", self.ReloadRequested)
	end,

	ReloadRequested = function(enableCheck)
		local self = enableCheck:GetParent()
		self.Duration:SetEnabled(enableCheck:GetChecked())
	end,

	SetTexts = function(self, title, tooltip)
		self.text:SetText(title)

		self.Duration:SetLabel("")
		self.Duration:SetTexts(title, tooltip)

		self.EnableCheck:SetLabel("")
		self.EnableCheck:SetTexts(ENABLE, TMW.L["GENERIC_NUMREQ_CHECK_DESC"]:format(tooltip:gsub("^%u", strlower)))
	end,

	SetSettings = function(self, enableSetting, durationSetting)
		self.EnableCheck:SetSetting(enableSetting)
		self.Duration:SetSetting(durationSetting)
	end,
}

TMW:NewClass("Config_Slider", "Slider", "Config_Frame")
{
	-- Saving base methods.
	-- This is done in a separate call to make sure it happens before 
	-- new ones overwrite the base methods.

	Show_base = TMW.C.Config_Slider.Show,
	Hide_base = TMW.C.Config_Slider.Hide,

	SetValue_base = TMW.C.Config_Slider.SetValue,
	GetValue_base = TMW.C.Config_Slider.GetValue,

	GetValueStep_base = TMW.C.Config_Slider.GetValueStep,

	GetMinMaxValues_base = TMW.C.Config_Slider.GetMinMaxValues,
	SetMinMaxValues_base = TMW.C.Config_Slider.SetMinMaxValues,
}{

	Config_EditBox_Slider = TMW:NewClass("Config_EditBox_Slider", "Config_EditBox"){
		
		-- Constructor
		OnNewInstance_EditBox_Slider = function(self)
			self:EnableMouseWheel(true)
		end,
		

		-- Scripts
		OnEditFocusLost = function(self, button)
			local text = tonumber(self:GetText()) or 0
			if text then
				self.Slider:SetValue(text)
				self.Slider:SaveSetting()
			end

			self:SetText(self.Slider:GetValue())
		end,


		OnMouseDown = function(self, button)
			if button == "RightButton" and not self.Slider:ShouldForceEditBox() then
				self.Slider:UseSlider()
			end
		end,

		OnMouseWheel = function(self, ...)
			self.Slider:GetScript("OnMouseWheel")(self.Slider, ...)
		end,

		METHOD_EXTENSIONS = {
			OnEnable = function(self)
				self:EnableMouse(true)
				self:EnableKeyboard(true)
			end,

			OnDisable = function(self)
				self:ClearFocus()
				self:EnableMouse(false)
				self:EnableKeyboard(false)
			end,
		},
		

		-- Methods
		ReloadSetting = function(self)
			self:SetText(self.Slider:GetValue())
		end,
	},

	EditBoxShowing = false,

	MODE_STATIC = 1,
	MODE_ADJUSTING = 2,

	TEXT_MODE_TITLEVAL = 1,
	TEXT_MODE_MINMAX = 2,
	TEXT_MODE_MINMIDMAX = 3,

	FORCE_EDITBOX_THRESHOLD = 10e5,

	range = 10,

	formatter = TMW.C.Formatter.PASS,
	extremesFormatter = TMW.C.Formatter.PASS,

	-- Constructor
	OnNewInstance_Slider = function(self)
		self.min, self.max = self:GetMinMaxValues()

		self:SetMode(self.MODE_STATIC)
		self:SetTextMode(self.TEXT_MODE_TITLEVAL)

		self.ThumbTexture:SetPoint("BOTTOM", self.thumb, 0, -2)
		
		self:EnableMouseWheel(true)
		self:SetExtremesColor(0.25)
	end,


	SetTexts = function(self, title, tooltip)
		self.title = title
		self:UpdateTexts()
		self:SetTooltip(title, tooltip)
	end,

	SetExtremesColor = function(self, color)
		self.extremesColor = color
		self:UpdateTexts()
	end,

	UseLightColor = function(self)
		local c = 0.13
		self.Background:SetColorTexture(c, c, c, 0.95)
	end,

	-- Blizzard Overrides
	GetValue = function(self)
		if self.EditBoxShowing then
			local text = self.EditBox:GetText()
			if text == "" then
				text = 0
			end

			text = tonumber(text)
			if text then
				return self:CalculateValueRoundedToStep(text)
			end
		end

		return self:CalculateValueRoundedToStep(self:GetValue_base())
	end,
	SetValue = function(self, value)
		TMW:ValidateType("value", "SetValue(value)", value, "number")

		self.__scriptFiredOnValueChanged = nil

		if value < self.min then
			value = self.min
		elseif value > self.max then
			value = self.max
		end
		value = self:CalculateValueRoundedToStep(value)

		self:UpdateRange(value)
		self:SetValue_base(value)
		if self.EditBoxShowing then
			self.EditBox:SetText(value)
		end

		if not self.__scriptFiredOnValueChanged and value ~= self:GetValue_base() then
			self:GetScript("OnValueChanged")(self, value)
		end
	end,

	GetMinMaxValues = function(self)
		local min, max = self:GetMinMaxValues_base()

		min = self:CalculateValueRoundedToStep(min)
		max = self:CalculateValueRoundedToStep(max)

		return min, max
	end,
	SetMinMaxValues = function(self, min, max)
		min = min or -math.huge
		max = max or math.huge

		if min > max then
			error("min can't be bigger than max")
		end

		self.min = min
		self.max = max

		if self.mode == self.MODE_STATIC then
			self:SetMinMaxValues_base(min, max)
		elseif not self.EditBoxShowing then
			self:UpdateRange()
		end
	end,

	GetValueStep = function(self)
		local step = self:GetValueStep_base()
		return floor((step*10^5) + .5) / 10^5
	end,

	SetWheelStep = function(self, wheelStep)
		self.wheelStep = wheelStep
	end,
	GetWheelStep = function(self)
		return self.wheelStep or self:GetValueStep()
	end,


	Show = function(self)
		if self.EditBoxShowing then
			self.EditBox:Show()
		else
			self:Show_base()
		end
	end,
	Hide = function(self)
		self:Hide_base()
		if self.EditBoxShowing then
			self.EditBox:Hide()
		end
	end,

	-- Script Handlers
	OnMinMaxChanged = function(self)
		self:UpdateTexts()
	end,

	OnValueChanged = function(self)
		if not self.__fixingValueStep then
			self.__fixingValueStep = true
			self:SetValue_base(self:GetValue())
			self.__fixingValueStep = nil
		else
			return
		end

		self.__scriptFiredOnValueChanged = true

		if self.EditBox then
			self.EditBox:SetText(self:GetValue())
		end

		if self:ShouldForceEditBox() and not self.EditBoxShowing then
			self:SaveSetting()
			self:UseEditBox()
		end

		self:UpdateTexts()
	end,

	OnMouseDown = function(self, button)
		if not self:IsEnabled() then
			return
		end

		if button == "RightButton" then
			self:UseEditBox()

			self:RequestReload()
		end
	end,

	OnMouseUp = function(self)
		if not self:IsEnabled() then
			return
		end

		if self.mode == self.MODE_ADJUSTING then
			self:UpdateRange()
		end
		
		self:SaveSetting()
	end,
	
	OnMouseWheel = function(self, delta)
		if not self:IsEnabled() then return end

		if self:CScriptBubbleGet("BeforeMouseWheelHandled", delta) then
			return
		end
		
		if IsShiftKeyDown() then
			delta = delta*10
		end
		if IsControlKeyDown() then
			delta = delta*60
		end
		if delta == 1 or delta == -1 then
			delta = delta*(self:GetWheelStep() or 1)
		end

		local level = self:GetValue() + delta

		self:SetValue(level)

		self:SaveSetting()
	end,

	-- Methods
	SetRange = function(self, range)
		self.range = range
		self:UpdateRange()
	end,
	GetRange = function(self)
		return self.range
	end,

	CalculateValueRoundedToStep = function(self, value)
		if value == math.huge or value == -math.huge then
			return value
		end
		
		local step = self:GetValueStep()

		return floor(value * (1/step) + 0.5) / (1/step)
	end,

	SetMode = function(self, mode)
		self.mode = mode

		if mode == self.MODE_STATIC then
			self:UseSlider()
		end

		self:UpdateRange()
	end,
	GetMode = function(self)
		return self.mode
	end,


	ShouldForceEditBox = function(self)
		if self:GetMode() == self.MODE_STATIC then
			return false
		elseif self:GetValue() > self.FORCE_EDITBOX_THRESHOLD then
			return true
		end
	end,

	UseEditBox = function(self)
		if self:GetMode() == self.MODE_STATIC then
			return
		end

		if not self.EditBox then
			local name = self:GetName() and self:GetName() .. "Box" or nil
			self.EditBox = self.Config_EditBox_Slider:New("EditBox", name, self:GetParent(), "TellMeWhen_InputBoxTemplate", nil, {})
			self.EditBox.Slider = self

			self.EditBox.title = self.EditBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			self.EditBox.title:SetPoint("LEFT", self.EditBox)
			self.EditBox.title:SetPoint("RIGHT", self.EditBox)
			self.EditBox.title:SetPoint("BOTTOM", self.EditBox, "TOP")

			self.EditBox:SetPoint("BOTTOMLEFT", self, 0, -2)
			self.EditBox:SetPoint("BOTTOMRIGHT", self, 0, -2)

			self.EditBox:SetText(self:GetValue())

			if self.ttData then
				self:SetTooltip(unpack(self.ttData))
			end
		end

		self.EditBox.title:SetText(self.title)

		if not self.EditBoxShowing then
			TMW:ClickSound()
			
			self.EditBoxShowing = true
			
			--if self.text:GetParent() == self then
			--	self.text:SetParent(self.EditBox)
			--end

			self.EditBox:Show()
			self:Hide_base()

			self:RequestReload()
		end
	end,
	UseSlider = function(self)
		if self.EditBoxShowing then
			TMW:ClickSound()

			self.EditBoxShowing = false

			--if self.text:GetParent() == self.EditBox then
			--	self.text:SetParent(self)
			--end

			if self.EditBox:IsShown() then
				self:Show_base()
			end
			self.EditBox:Hide()
			self:UpdateRange()

			self:RequestReload()
		end
	end,


	SetTextFormatter = function(self, formatter, extremesFormatter)
		TMW:ValidateType("2 (formatter)", (self:GetName() or "<unnamed>") .. ":SetTextFormatter(formatter)", formatter, "Formatter;nil")
		TMW:ValidateType("3 (extremesFormatter)", (self:GetName() or "<unnamed>") .. ":SetTextFormatter(formatter [,extremesFormatter])", extremesFormatter, "Formatter;nil")

		self.formatter = formatter or TMW.C.Formatter.PASS
		self.extremesFormatter = extremesFormatter or formatter or TMW.C.Formatter.PASS

		self:UpdateTexts()
	end,

	TT_textFunc = function(self)
		local text = self.ttData[2]

		if not text then
			text = ""
		else
			text = text .. "\r\n\r\n"
		end

		if self:GetObjectType() == "Slider" then
			if self:GetMode() == self.MODE_ADJUSTING then
				text = text .. L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"]
			else
				return self.ttData[2]
			end
		else -- EditBox
			if self.Slider:ShouldForceEditBox() then
				text = text .. L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"]:format(TMW.C.Formatter.COMMANUMBER:Format(self.Slider.FORCE_EDITBOX_THRESHOLD))
			else
				text = text .. L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"]
			end
		end

		return text
	end,

	SetTooltip = function(self, title, text)
		self.ttData = {title, text}

		TMW:TT(self, title, self.TT_textFunc, 1, 1)

		if self.EditBox then
			TMW:TT(self.EditBox, title, self.TT_textFunc, 1, 1)
			self.EditBox.ttData = self.ttData
		end
	end,

	UpdateTexts = function(self)

		self.Center:SetText("")
		if self.textMode == self.TEXT_MODE_TITLEVAL then
			if self.title then
				self.Left:SetText(self.title .. ":")
			else
				self.Left:SetText("")
			end

			self.formatter:SetFormattedText(self.Right, self:GetValue())

			local color = 1
			self.Left:SetTextColor(color, color, color, 1)
			self.Right:SetTextColor(color, color, color, 1)
		else
			local minValue, maxValue = self:GetMinMaxValues()

			self.extremesFormatter:SetFormattedText(self.Left, minValue)
			self.extremesFormatter:SetFormattedText(self.Right, maxValue)

			local color = self.extremesColor or 1
			self.Left:SetTextColor(color, color, color, 1)
			self.Center:SetTextColor(color, color, color, 1)
			self.Right:SetTextColor(color, color, color, 1)

			if self.textMode == self.TEXT_MODE_MINMIDMAX then
				self.formatter:SetFormattedText(self.Center, self:GetValue())
			end
		end
	end,

	SetTextMode = function(self, mode)
		self.textMode = mode

		self:UpdateTexts()
	end,

	UpdateRange = function(self, value)
		if self.mode == self.MODE_ADJUSTING then
			local deviation = ceil(self.range/2)
			local val = value or self:GetValue()

			local newmin = min(max(self.min, val - deviation), self.max)
			local newmax = max(min(self.max, val + deviation), self.min)
			--newmax = min(newmax, self.max)

			self:SetMinMaxValues_base(newmin, newmax)
		else
			self:SetMinMaxValues_base(self.min, self.max)
		end
	end,


	SaveSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then
		
			if self.ttData then
				TMW:TT_Update(self.EditBoxShowing and self.EditBox or self)
			end

			local value = self:GetValue()
			value = self:CScriptCallGet("ModifyValueForSave", value) or value

			if settings[self.setting] ~= value then
				settings[self.setting] = value
				self:OnSettingSaved()
			else
				self:RequestReload()
			end
		end
	end,

	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then

			local value = settings[self.setting]
			value = self:CScriptCallGet("ModifyValueForLoad", value) or value

			self:SetValue(value)
		end
	end,
}

TMW:NewClass("Config_Slider_Alpha", "Config_Slider"){
	-- Constructor
	OnNewInstance_Slider_Alpha = function(self)
		self:SetMinMaxValues(0, 1)
		self:SetValueStep(0.01)
		-- self:SetWheelStep(0.1)

		self:SetTextFormatter(self.Formatter)

		self:UpdateTexts()
	end,

	METHOD_EXTENSIONS = {
		OnDisable = function(self)
			self:SetValue(0)
			self:UpdateTexts()
		end,
	},
	
	Formatter = TMW.C.Formatter:New(function(value)
		if value == 0 then
			return L["CONDITIONPANEL_ICON_HIDDEN"]
		else
			return TMW.C.Formatter.PERCENT100:Format(value)
		end
	end),
	
	OrangeAt100Formatter = TMW.C.Formatter:New(function(value)
		if value == 0 then
			return L["CONDITIONPANEL_ICON_HIDDEN"]
		else
			if value == 1 then
				return "|cffff7400" .. TMW.C.Formatter.PERCENT100:Format(value)
			end
			return TMW.C.Formatter.PERCENT100:Format(value)
		end
	end),
}

TMW:NewClass("Config_BitflagBase"){
	-- Constructor
	OnNewInstance_BitflagBase = function(self)
		if self:GetID() and not self:GetSettingBit() then
			self:SetSettingBitID(self:GetID())
		end
	end,

	SetSettingBit = function(self, bit)
		self.bit = bit
	end,

	GetSettingBit = function(self)
		return self.bit
	end,

	SetSettingBitID = function(self, bitID)
		self:SetSettingBit(bit.lshift(1, bitID - 1))
	end,


	-- Script Handlers
	OnClick = function(self, button)	
		local settings = self:GetSettingTable()

		if settings and self.setting and self.bit then
			settings[self.setting] = bit.bxor(settings[self.setting], self.bit)
			
			self:OnSettingSaved()
		end
	end,
	

	-- Methods
	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings then
			self:SetChecked(bit.band(settings[self.setting], self.bit) == self.bit)
		end
	end,
}

TMW:NewClass("Config_CheckButton_BitToggle", "Config_BitflagBase", "Config_CheckButton")

TMW:NewClass("Config_Frame_IconStateSet", "Config_Frame"){
	-- Constructor


	OnNewInstance_Frame_IconStateSet = function(self)
		self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)
	end,

	SettingTableRequested = function(self)
		return TMW.CI.ics and TMW.CI.ics.States[self.setting] or false
	end,

	-- Script Handlers
	OnEnable = function(self)
		self:RequestReloadChildren()
	end,
	
	OnDisable = function(self)
		self.Alpha:Disable()
	end,
	

	-- Methods

	SetConfigData = function(self, configData)
		self.Alpha:SetTexts(configData.text)
		self.Alpha:SetTooltip(
			L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"]:format(configData.text),
			configData.tooltipText or L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"]
		)
	end,

	ReloadSetting = function(self)
		self:GetParent():AdjustHeight()
	end,
}

TMW:NewClass("Config_ColorButton", "Button", "Config_Frame"){
	hasOpacity = false,
	hasDesaturate = false,

	OnNewInstance_ColorButton = function(self)
		assert(self.background1 and self.text and self.swatch, 
			"This setting frame doesn't inherit from TellMeWhen_ColorButtonTemplate")

		self.text:SetHeight(30)
		self.text:SetMaxLines(3)

		self.swatch:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end,

	SetTexts = function(self, title, tooltip)
		self:SetTooltip(title, tooltip)
		self.text:SetText(title)
	end,
	
	OnClick = function(self, button)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			IE:RegisterRapidSetting(self.setting)
			
			TellMeWhen_ColorPicker:Load(
				self,
				"PickerCallback",
				settings[self.setting],
				self.swatchTexture,
				self.hasOpacity,
				self.hasDesaturate,
				self.hasTexture and settings[self.textureSetting] or nil)
		end
	end,

	SetHasOpacity = function(self, hasOpacity)
		self.hasOpacity = hasOpacity

		self.background1:SetShown(hasOpacity)
		self.background2:SetShown(hasOpacity)
		self.background3:SetShown(hasOpacity)
		self.background4:SetShown(hasOpacity)
	end,

	SetHasDesaturate = function(self, hasDesaturate)
		self.hasDesaturate = hasDesaturate
	end,

	SetHasTextureConfig = function(self, hasTexture, textureSetting)
		self.hasTexture = hasTexture
		self.textureSetting = textureSetting
	end,

	SetSwatchTexture = function(self, baseTexture, overrideTexture)
		self.swatchTexture = baseTexture
		self.swatchOverrideTexture = overrideTexture
		self:UpdateSwatchTexture()
	end,

	UpdateSwatchTexture = function(self)
		local r, g, b, a, flags = self:GetRGBA()

		local texture
		if self.swatchOverrideTexture then
			texture = self.swatchOverrideTexture
		elseif self.swatchTexture then
			texture = self.swatchTexture
		end

		if texture then
			-- We have to set the texture to nil first in case the (texture == "").
			-- In Legion, calling SetTexture("") seems to have no effect, so if the swatch was previously
			-- set to a color texture, it will stay that way unless we explicitly nil it out.
			self.swatch:SetTexture(nil)
			self.swatch:SetTexture(texture)
			self.swatch:SetVertexColor(r, g, b)
			self.swatch:SetAlpha(a)
			self.swatch:SetDesaturated(flags and flags.desaturate)
		else
			self.swatch:SetColorTexture(r, g, b, a)
			self.swatch:SetDesaturated(false)
		end
	end,

	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings then
			self:UpdateSwatchTexture()
		end
	end,

	PickerCallback = function(self, colorString, texture)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			settings[self.setting] = colorString
			if self.hasTexture then
				settings[self.textureSetting] = texture
			end
			self:OnSettingSaved()
		end
	end,

	GetRGBA = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			IE:RegisterRapidSetting(self.setting)
			
			local c = TMW:StringToCachedRGBATable(settings[self.setting])
			local a = self.hasOpacity and c.a or 1

			return c.r, c.g, c.b, a, c.flags
		else
			return 0, 0, 0, 0, nil
		end		
	end,
}

TMW:NewClass("Config_Button_Rune", "Button", "Config_BitflagBase", "Config_Frame"){
	-- Constructor

	OnNewInstance_Button_Rune = function(self)
		if not self:GetRuneNumber() then
			self:SetRuneNumber(self:GetID())
		end
	end,

	GetRuneNumber = function(self)
		return self.runeNumber
	end,

	SetRuneNumber = function(self, runeNumber)
		self.runeNumber = runeNumber

		self.texture:SetTexture("Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-SingleRune")

		self:SetSettingBitID(self.runeNumber)
	end,


	-- Methods
	checked = false,
	GetChecked = function(self)
		return self.checked
	end,

	SetChecked = function(self, checked)
		self.checked = checked
		if checked then
			self.Check:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
		else
			self.Check:SetTexture(nil)
		end
	end,
}

TMW:NewClass("Config_PointSelect", "Config_Frame"){

	SetTexts = function(self, title, tooltip)
		self.Header:SetText(title)
		self:SetTooltipBody(tooltip)
	end,

	SetTooltipBody = function(self, body)
		TMW:ValidateType("2 (body)", "SetTooltipBody", body, "string")

		assert(body:find("%%s"), "tooltip body should contain a %s that will be formatted to the point.")

		for k, v in pairs(self) do
			if type(v) == "table" and v.GetObjectType and v:GetObjectType() == "CheckButton" then
				TMW:TT(v, TMW.L[k], body:format(TMW.L[k]), 1, 1)
			end
		end
	end,

	SetSelectedPoint = function(self, point)
		TMW:ValidateType("2 (point)", "SetSelectedPoint", point, "string")

		point = tostring(point):upper()

		if not self[point] then
			error("Invalid point " .. point .. " to Config_PointSelect:SetSelected(point)")
		end

		for k, v in TMW:Vararg(self:GetChildren()) do
			if v.SetChecked then
				v:SetChecked(false)
			end
		end

		self[point]:SetChecked(true)
	end,

	SelectChild = function(self, child)
		TMW:ValidateType("2 (child)", "SelectChild", child, "frame")

		for k, v in pairs(self) do
			if v == child then

				local settings = self:GetSettingTable()

				TMW:ClickSound()
				self:SetSelectedPoint(k)

				if settings and self.setting then
					settings[self.setting] = k

					self:OnSettingSaved()
				end

				return
			end
		end

		error("child wasn't valid")
	end,

	GetSelectedPoint = function(self)
		for k, v in pairs(self) do
			if type(v) == "table" and v.GetObjectType and v:GetObjectType() == "Button" then
				if v:GetChecked() then
					return k
				end
			end
		end
	end,
	
	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings then
			self:SetSelectedPoint(settings[self.setting])
		end
	end,

	OnSizeChanged = function(self)
		self.CENTER:SetSize(self:GetWidth() / 3, self:GetHeight() / 3)
	end,
}

TMW:NewClass("Config_ColorPicker", "Config_Frame"){

	h = 0,
	s = 1,
	v = 0.5,
	a = 0.5,
	textureValue = "",
	desaturate = false,
	
	OnNewInstance = function(self)
		self.RecentColorFrame.frames = {}

		self.swatchLabel:SetText(L["COLORPICKER_SWATCH"])
		self.iconLabel:SetText(L["COLORPICKER_ICON"])
		self.recentHeader:SetText(L["COLORPICKER_RECENT"])

		self:CScriptAdd("SettingTableRequested", function() return self end)

		for i, slider in TMW:Vararg(self.HueSlider, self.SaturationSlider, self.ValueSlider, self.AlphaSlider) do
			-- Set the setting to h, s, v, or a
			slider:SetSetting(slider:GetParentKey():sub(1, 1):lower())

			slider:PostHookMethod("UpdateTexts", self.Slider_UpdateTextsHook)
		end

		self:RequestReload()

		self:CScriptAdd("DescendantSettingSaved", self.LiveUpdate)
	end,

	Slider_UpdateTextsHook = function(slider)
		local self = slider:GetParent()
		self:LiveUpdate()
	end,

	RECENT_COLOR_COLUMNS = 3,
	RECENT_COLOR_ROWS = 7,
	RecentColor_OnClick = function(recentColorButton, button)
		local self = recentColorButton:GetParent().ScrollFrame:GetParent()

		-- This must be upvalued because it is about to get overwritten when we
		-- add the current color as a recent color.
		local string = recentColorButton.string

		if button == "RightButton" then
			local RecentColors = IE.db.global.RecentColors

			for i, v in ipairs(RecentColors) do
				if v == string then
					tremove(RecentColors, i)
					break
				end
			end

			self:UpdateRecentColors()
		else
			self:AddRecentColor(self:GetColorString())
			self:AddRecentColor(string)

			self:SetColorString(string, false)
		end
	end,

	AddRecentColor = function(self, colorString)
		-- Don't include flags with recent colors.
		colorString = colorString:sub(1, 8)

		local RecentColors = IE.db.global.RecentColors

		for i, v in ipairs(RecentColors) do
			if v == colorString then
				tremove(RecentColors, i)
				break
			end
		end

		tinsert(RecentColors, 1, colorString)
		while #RecentColors > self.RECENT_COLOR_COLUMNS * self.RECENT_COLOR_ROWS do
			tremove(RecentColors, #RecentColors)
		end

		self:UpdateRecentColors()
	end,

	UpdateRecentColors = function(self)
		local padding = 5
		for i, color in ipairs(IE.db.global.RecentColors) do
			local f = self.RecentColorFrame.frames[i]
			if not f then
				f = CreateFrame("Button", nil, self.RecentColorFrame, "TellMeWhen_ColorButtonTemplate")
				f:SetScript("OnClick", self.RecentColor_OnClick)
				f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				local dim = (self.RecentColorFrame:GetWidth() - padding*(1+self.RECENT_COLOR_COLUMNS)) / self.RECENT_COLOR_COLUMNS
				f:SetSize(dim, dim)
				self.RecentColorFrame.frames[i] = f
				if i == 1 then
					f:SetPoint("TOPLEFT")
				elseif (i-1) % self.RECENT_COLOR_COLUMNS == 0 then
					f:SetPoint("TOPLEFT", self.RecentColorFrame.frames[i-self.RECENT_COLOR_COLUMNS], "BOTTOMLEFT", 0, -padding)
				else
					f:SetPoint("LEFT", self.RecentColorFrame.frames[i-1], "RIGHT", padding, 0)
				end
			end
			f:Show()
			TMW:TT(f, color, "COLORPICKER_RECENT_DESC", 1, nil)
			f.string = color
			f.swatch:SetColorTexture(TMW:StringToRGBA(color))
		end

		for i = #IE.db.global.RecentColors, #self.RecentColorFrame.frames do
			self.RecentColorFrame.frames[i]:Hide()
		end
	end,

	LiveUpdate = function(self)
		if not self.HueSlider.textures then
			return
		end

		-- TODO: HANDLE ALPHA
		local h = self.HueSlider:GetValue()
		local s = self.SaturationSlider:GetValue()
		local v = self.ValueSlider:GetValue()
		local a = self.AlphaSlider:GetValue()

		self.StringEditbox:SetText(TMW:HSVAToColorString(h, s, v, a))

		local r,g,b=TMW:HSVToRGB(h, 0, v)
		self.SaturationSlider.Background:SetGradient("HORIZONTAL", r,g,b, TMW:HSVToRGB(h, 1, v))

		local r,g,b=TMW:HSVToRGB(h, s, 0)
		self.ValueSlider.Background:SetGradient("HORIZONTAL", r,g,b, TMW:HSVToRGB(h, s, 1))

		for i = 1, self.HueSlider.NUM_SEGMENTS do
			local r,g,b=TMW:HSVToRGB((i-1)/self.HueSlider.NUM_SEGMENTS, s, v)
			self.HueSlider.textures[i]:SetGradient("HORIZONTAL", r,g,b, TMW:HSVToRGB(i/self.HueSlider.NUM_SEGMENTS, s, v))
		end

		local r,g,b=TMW:HSVToRGB(h, s, v)
		self.AlphaSlider.Background:SetGradientAlpha("HORIZONTAL", r, g, b, 0, r, g, b, 1)

		self.swatch.swatch:SetColorTexture(r,g,b)
		self.swatch.swatch:SetAlpha(a)


		self.iconTexture:SetTexture(self.originalTexture)
		if self.hasTexture then
			local textureValue = self.textureValue
			if textureValue and textureValue ~= "" then
				textureValue = TMW.COMMON.Textures:EvaluateTexturePath(textureValue, TMW.NULLFUNC)

				self.iconTexture:SetTexture(textureValue)
			end
		end		
		self.iconTexture:SetVertexColor(TMW:HSVToRGB(h, s, v))
		self.iconTexture:SetDesaturated(self.desaturate)
	end,

	SaveSetting = function(self)
		self:AddRecentColor(self:GetColorString())

		if self.callbackObj and self.callback then
			self.callbackObj[self.callback](self.callbackObj, self:GetColorString(), self.textureValue)
		end

		self:Hide()
	end,

	SetColorString = function(self, value, loadFlags)
		if #value == 6 then
			value = "ff" .. value
		end

		local c = TMW:ColorStringToCachedHSVATable(value)

		self.h, self.s, self.v = c.h, c.s, c.v

		self.a = self.hasOpacity and c.a or 1
		if loadFlags then
			self.desaturate = self.hasDesaturate and c.flags and c.flags.desaturate or false
		end

		self:RequestReloadChildren()
		self:LiveUpdate()
	end,

	GetColorString = function(self, value)
		return TMW:HSVAToColorString(self.h, self.s, self.v, self.a, {desaturate=self.desaturate})
	end,

	Load = function(self, callbackObj, callback, value, texture, hasOpacity, hasDesaturate, textureValue)
		self.hasOpacity = hasOpacity
		self.hasDesaturate = hasDesaturate
		self.hasTexture = not not textureValue
		self.originalTexture = texture
		self.callbackObj = callbackObj
		self.callback = callback

		self.AlphaSlider:SetShown(hasOpacity)
		self.Desaturate:SetShown(hasDesaturate)

		self.Texture:SetShown(self.hasTexture)
		TMW.SUG:EnableEditBox(self.Texture, "texture_withVarTex", true, true, self)

		self.iconTexture:SetTexture(texture)
		self.iconLabel:SetShown(not not texture)

		self.textureValue = textureValue or ""
		self:SetColorString(value, true)

		self:AddRecentColor(value)
		self:UpdateRecentColors()

		self:Show()
		self:Raise()

		local c = TMW:StringToCachedRGBATable(value)
		self.swatchPrevious.swatch:SetColorTexture(c.r, c.g, c.b, c.a)
	end,
}



TMW.C.IE:Inherit("Config_Frame")

---------------------------------
-- Icon Editor Tabs
---------------------------------

TMW:NewClass("IconEditorTabBase", "Config_Button"){

	SetTexts = function(self, title, tooltip)
		self:SetText(title)
		TMW:TT(self, title, tooltip, 1, 1)
	end,

	AdjustWidth = function(self)
		self:SetWidth(self.text:GetStringWidth() + 10)
	end,

	METHOD_EXTENSIONS = {
		SetText = function(self, text)
			if self:IsVisible() then
				IE:ResizeTabs()
			end
		end,
	},
}

TMW:NewClass("IconEditorTabGroup", "IconEditorTabBase"){
	childrenEnabled = true,

	OnNewInstance = function(self)
		self.Tabs = {}
	end,

	OnClick = function(self)
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)

		IE.CurrentTabGroup = self

		TMW.IE.Tabs.art.pSelectedHorizontal:ClearAllPoints()
		TMW.IE.Tabs.art.pSelectedHorizontal:SetPoint("TOPLEFT", self)
		TMW.IE.Tabs.art.pSelectedHorizontal:SetPoint("TOPRIGHT", self)

		for i, tab in TMW:Vararg(TMW.IE.Tabs.secondary:GetChildren()) do
			tab:Hide()
		end
		
		local lastTab
		local firstShown
		for i = 1, #self.Tabs do
			local tab = self.Tabs[i]

			if tab:ShouldShowTab() then
				lastTab = tab

				tab:Show()
				tab:SetFrameLevel(tab:GetParent():GetFrameLevel() + 3)
				tab:SetEnabled(self.childrenEnabled)

				firstShown = firstShown or tab
			end
		end

		if not self.childrenEnabled then
			IE.CurrentTab = nil
			local page = IE:DisplayPage(self.disabledPageKey)
			page:RequestReload()

		elseif self.currentTab and self.currentTab:IsShown() then
			self.currentTab:Click()

		elseif firstShown then
			firstShown:Click()
		else
			error("No tabs shown to click for tab group " .. self.identifier)
		end

		if not IE.CurrentTab then
			TMW.IE.Tabs.art.sSelectedHorizontal:ClearAllPoints()
			TMW.IE.Tabs.art.sSelectedHorizontal:SetPoint("TOP")
		end

		IE:ResizeTabs()
	end,

	SetChildrenEnabled = function(self, enabled)
		self.childrenEnabled = enabled

		if IE.CurrentTabGroup == self then
			self:Click()
		end
	end,

	SetDisabledPageKey = function(self, pageKey)
		self.disabledPageKey = pageKey
	end,
}

TMW:NewClass("IconEditorTab", "IconEditorTabBase"){
	endPadding = 6,
	interPadding = 5,

	OnNewInstance_Tab = function(self)
		self:CScriptAdd("PageReloadRequested", self.PageReloadRequested)
	end,

	PageReloadRequested = function(self, page)
		-- Also notify the tab group one of its pages was reloaded
		-- so that generic actions that apply to a whole tab group (like re-setting up an icon) can happen.
		self.parent:CScriptCall("PageReloadRequested")

		if self.historySet then

			-- Because some settings can get changed when we're reloading,
			-- we need to delay this until all reloading is done.
			C_Timer.After(0, function()
				self.historySet:AttemptAutoBackup()
				self.historySet:UpdateButtons()
			end)
		else
			IE.UndoButton:Disable()
			IE.RedoButton:Disable()
		end
	end,

	SetHistorySet = function(self, historySet)
		TMW:ValidateType("historySet", "SetHistorySet(historySet)", historySet, "HistorySet")

		self.historySet = historySet
	end,

	GetHistorySet = function(self)
		return self.historySet
	end,

	OnClick = function(self)
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)

		if IE.CurrentTabGroup ~= self.parent then
			self.parent:Click()
		end

		local oldTab = IE.CurrentTab

		IE.CurrentTab = self
		self.parent.currentTab = self

		IE.Tabs.art.sSelectedHorizontal:ClearAllPoints()
		IE.Tabs.art.sSelectedHorizontal:SetPoint("BOTTOMLEFT", self)
		IE.Tabs.art.sSelectedHorizontal:SetPoint("BOTTOMRIGHT", self)


		local page = IE:DisplayPage(self.pageKey)
		
		TMW:Fire("TMW_CONFIG_TAB_CLICKED", self, oldTab)

		page:RequestReload()

		IE:ResizeTabs()
	end,

	GetPage = function(self)
		return TMW.IE.Pages[self.pageKey]
	end,

	ShouldShowTab = function(self)
		return true
	end,
}

IE.TabGroups = {}
function IE:RegisterTabGroup(identifier, text, order, setupHeaderFunc)
	local sig = "IE:RegisterTabGroup(identifier, text, order, setupHeaderFunc)"
	TMW:ValidateType("identifier",      sig, identifier,      "string")
	TMW:ValidateType("text",            sig, text,            "string")
	TMW:ValidateType("order",           sig, order,           "number")
	TMW:ValidateType("setupHeaderFunc", sig, setupHeaderFunc, "function")

	assert(identifier == identifier:upper(), "Tab identifiers should be all uppercase")

	if IE.TabGroups[identifier] then
		error("A tab group with the identifier " .. identifier .. " is already registered.")
	end
	
	local tab = TMW.C.IconEditorTabGroup:New("Button", nil, TMW.IE.Tabs.primary, "TellMeWhen_IE_Tab")
	TMW.IE.Tabs.primary[identifier] = tab

	tab.identifier = identifier
	tab.order = order
	tab.SetupHeader = setupHeaderFunc

	tab:SetText(text)

	IE.TabGroups[identifier] = tab

	for i, tab in ipairs(TMW.IE.Tabs.primary) do
		tab:Hide()
	end
	


	return tab
end

function IE:RegisterTab(groupIdentifier, identifier, pageKey, order)
	local sig = "IE:RegisterTab(groupIdentifier, identifier, pageKey, order)"
	TMW:ValidateType("groupIdentifier", sig, groupIdentifier, "string")
	TMW:ValidateType("identifier",      sig, identifier,      "string")
	TMW:ValidateType("pageKey",         sig, pageKey,         "string")
	TMW:ValidateType("order",           sig, order,           "number")

	assert(identifier == identifier:upper(), "Tab identifiers should be all uppercase")

	local tabGroup = IE.TabGroups[groupIdentifier]

	if not tabGroup then
		error("Could not find tab group registered with identifier " .. groupIdentifier)
	end

	if tabGroup[identifier] then
		error("A tab with the identifier " .. identifier .. " is already registered to tab group " .. groupIdentifier)
	end

	local tab = TMW.C.IconEditorTab:New("Button", nil, TMW.IE.Tabs.secondary, "TellMeWhen_IE_Tab")
	TMW.IE.Tabs.secondary[identifier] = tab

	tab.identifier = identifier
	tab.pageKey = pageKey
	tab.order = order
	tab.parent = tabGroup

	tabGroup[identifier] = tab

	tabGroup.Tabs[#tabGroup.Tabs + 1] = tab

	TMW:SortOrderedTables(tabGroup.Tabs)

	return tab
end

function IE:ResizeTabs()
	local endPadding = TMW.C.IconEditorTab.endPadding
	local interPadding = TMW.C.IconEditorTab.interPadding

	-- First, resize the primary tabs (the tab groups) so that we can figure out their exact width
	local primaryWidth = -interPadding
	local prevTabGroup
	for identifier, tabGroup in TMW:OrderedPairs(IE.TabGroups, TMW.OrderSort, true) do
		tabGroup:AdjustWidth()
		if prevTabGroup then
			prevTabGroup:SetPoint("RIGHT", tabGroup, "LEFT", -interPadding, 0)
		end
		primaryWidth = primaryWidth + tabGroup:GetWidth() + interPadding

		prevTabGroup = tabGroup
	end
	prevTabGroup:SetPoint("RIGHT", -interPadding)
	-- Adjust the conatiner width to fit the tabs exactly so calculations are easy.
	TMW.IE.Tabs.primary:SetWidth(primaryWidth)


	-- Next, figure out how much room we we will have for the secondary tabs.
	-- Subtract an additional 10 here because it just isn't quite right without it. Not sure why it ends up off like that.
	if not TMW.IE.Tabs.primary:GetLeft() then return end
	local availableWidth = TMW.IE.Tabs.primary:GetLeft() - TMW.IE.Tabs.secondary:GetLeft() - 20

	-- Now, divide the tabs up into rows so that no rows are overflowing.
	-- As we gather them into rows, position the tabs within that row.
	-- We will determine the positioning of the rows once we're all done.
	-- We don't do any fancy packing of them - just place them in the order that they're defined in.
	local rows = {}
	local currentRow = 1
	rows[currentRow] = {width = endPadding - interPadding }
	for i, tab in TMW:OrderedPairs({TMW.IE.Tabs.secondary:GetChildren()}, TMW.OrderSort, true) do
		tab:AdjustWidth()
		if tab:IsShown() then
			local newWidth = rows[currentRow].width + tab:GetWidth() + interPadding

			tab:ClearAllPoints()
			if newWidth > availableWidth and rows[currentRow][1] then
				-- No more room in the current row. Start a new row.
				-- We check that there is at least one tab in the row already so the first row doesn't end up empty
				-- when we're stress testing the text widths with massive strings.
				-- Anchor the tab to the far left.
				currentRow = currentRow + 1
				rows[currentRow] = {width = endPadding + tab:GetWidth(), [1] = tab }
				tab:SetPoint("LEFT", tab.endPadding, 0, 0)
			else
				-- There's room in an existing row. Put this tab in it.
				rows[currentRow].width = newWidth

				local numTabs = #rows[currentRow]
				if numTabs == 0 then
					-- This is the very first tab that we've looked at. It also goes on the left.
					tab:SetPoint("LEFT", tab.endPadding, 0, 0)
				else
					-- There are other tabs in this row. Place the tab next to the last one.
					tab:SetPoint("LEFT", rows[currentRow][numTabs], "RIGHT", tab.interPadding, 0)
				end
				rows[currentRow][numTabs + 1] = tab
			end
		end
	end

	-- Figure out the width of the widest row, 
	-- and figure out which row the current tab is in (if there is a current tab).
	local width = 0
	local selectedRow = nil
	for k, row in ipairs(rows) do
		width = max(width, row.width)

		for i, tab in ipairs(row) do
			if IE.CurrentTab == tab then
				selectedRow = row
				break
			end
		end
	end

	-- Position the rows amongst themselves.
	-- The row with the currently selected tab gets popped to the top.
	-- The rest of the rows are placed in their natural order from bottom to top.
	if #rows == 1 then
		rows[1][1]:SetPoint("BOTTOM")
	else

		local previousRow = nil
		for k, row in ipairs(rows) do
			if row == selectedRow then
				-- do nothing. The selected row gets placed last.
			else
				if previousRow then
					row[1]:SetPoint("BOTTOM", previousRow[1], "TOP")
				else
					row[1]:SetPoint("BOTTOM")
				end
				previousRow = row
			end
		end

		if selectedRow then
			-- If there wasn't actually a selected tab,
			-- don't do this. The row will have been positioned normally above.
			selectedRow[1]:SetPoint("BOTTOM", previousRow[1], "TOP")
		end
	end

	-- All done!
	TMW.IE.Tabs:SetHeight(8 + (25 * #rows))
	TMW.IE.Tabs.secondary:SetWidth(width + endPadding)
end

function IE:RefreshTabs()
	local tabGroup = IE.CurrentTabGroup

	if not tabGroup then
		for _, tabGroup in TMW:OrderedPairs(IE.TabGroups, TMW.OrderSort, true) do
			tabGroup:Click()
			return
		end
	else
		tabGroup:Click()
	end
end

function IE:DisplayPage(pageKey)
	for _, otherPage in TMW:Vararg(TMW.IE.Pages:GetChildren()) do
		otherPage:Hide()
	end

	-- If no key is specified, the function was probably just being called to hide all pages.
	if not pageKey then
		return
	end

	local page = TellMeWhen_IconEditor.Pages[pageKey]
	if not page then
		TMW:Error(("Couldn't find child of TellMeWhen_IconEditor.Pages with key %q"):format(pageKey))
	end

	page:Show()

	return page
end







-- -----------------------
-- IMPORT/EXPORT
-- -----------------------

---------- High-level Functions ----------
function TMW:Import(SettingsItem, ...)
	local settings = SettingsItem.Settings
	local version = SettingsItem.Version
	local type = SettingsItem.Type

	assert(settings, "Missing settings to import")
	assert(version, "Missing version of settings")
	assert(type, "No settings type specified!")

	TMW.DD:CloseDropDownMenus()

	TMW:Fire("TMW_IMPORT_PRE", SettingsItem, ...)
	
	local SharableDataType = TMW.approachTable(TMW, "Classes", "SharableDataType", "types", SettingsItem.Type)
	if SharableDataType and SharableDataType.Import_ImportData then
		SharableDataType:Import_ImportData(SettingsItem, ...)

		TMW:Update()
		IE:RefreshTabs()
		
		TMW:Print(L["IMPORT_SUCCESSFUL"])
	else
		TMW:Print(L["IMPORTERROR_INVALIDTYPE"])
	end

	TMW:Fire("TMW_IMPORT_POST", SettingsItem, ...)
end

function TMW:ImportPendingConfirmation(SettingsItem, luaDetections, callArgsAfterSuccess)
	TellMeWhen_ConfirmImportedLuaDialog:StartConfirmations(SettingsItem, luaDetections, callArgsAfterSuccess)
end

---------- Serialization ----------
function TMW:SerializeData(data, type, ...)
	-- nothing more than a wrapper for AceSerializer-3.0
	assert(data, "No data to serialize!")
	assert(type, "No data type specified!")
	return TMW:Serialize(data, TELLMEWHEN_VERSIONNUMBER, " ~", type, ...)
end

function TMW:MakeSerializedDataPretty(string)
	return string:
	gsub("(^[^tT%d][^^]*^[^^]*)", "%1 "): -- add spaces between tables to clean it up a little
	gsub("~J", "~J "): -- ~J is the escape for a newline
	gsub("%^ ^", "^^") -- remove double space at the end
end

function TMW:DeserializeDatum(string, silent)
	local success, data, version, spaceControl, type = TMW:Deserialize(string)
	if not success or not data then
		if not silent then
			TMW:Warn(data)
			TMW:Error(data)
		end
		-- corrupt/incomplete string
		return nil
	end

	if spaceControl then
		if spaceControl:find("`|") then
			-- EVERYTHING is broken. try really hard to salvage it. It probably won't be completely successful
			return TMW:DeserializeDatum(string:gsub("`", "~`"):gsub("~`|", "~`~|"), silent)
		elseif spaceControl:find("`") then
			-- if spaces have become corrupt, then reformat them and... re-deserialize
			return TMW:DeserializeDatum(string:gsub("`", "~`"), silent)
		elseif spaceControl:find("~|") then
			-- if pipe characters have been screwed up by blizzard's method of escaping things combined with AS-3.0's way of escaping things, try to fix them.
			return TMW:DeserializeDatum(string:gsub("~||", "~|"), silent)
		end
	end

	if not version then
		-- if the version is not included in the data,
		-- then it must have been before the first version that included versions in export strings/comm,
		-- so just take a guess that it was the first version that had version checks with it.
		version = 41403
	end

	if version <= 45809 and not type and data.Type then
		-- 45809 was the last version to contain untyped data messages.
		-- It only supported icon imports/exports, so the type has to be an icon.
		type = "icon"
	end

	if version <= 60032 and type == "global" then
		-- 60032 was the last version that used "global" as the identifier for "profile"
		type = "profile"
	end

	if not TMW.Classes.SharableDataType.types[type] then
		-- unknown data type
		return nil
	end


	-- finally, we have everything we need. create a result object and return it.
	local result = {
		data = data,
		type = type,
		version = version,
		select(6, TMW:Deserialize(string)), -- capture all extra args
	}

	return result
end

function TMW:DeserializeData(str, silent)
	if not str then 
		return
	end

	local results

	str = gsub(str, "[%c ]", "")

	for string in gmatch(str, "(^%d+.-^^)") do
		results = results or {}

		local result = TMW:DeserializeDatum(string, silent)

		tinsert(results, result)
	end

	return results
end


---------- Settings Manipulation ----------
function TMW:GetSettingsString(type, settings, defaults, ...)
	assert(settings, "No data to serialize!")
	assert(type, "No data type specified!")
	assert(defaults, "No defaults specified!")

	-- ... contains additional data that may or may not be used/needed
	settings = CopyTable(settings)
	settings = TMW:CleanSettings(type, settings, defaults)
	return TMW:SerializeData(settings, type, ...)
end

function TMW:GetSettingsStrings(strings, type, settings, defaults, ...)
	assert(settings, "No data to serialize!")
	assert(type, "No data type specified!")
	assert(defaults, "No defaults specified!")

	IE:SaveSettings()
	local strings = strings or {}

	local string = TMW:GetSettingsString(type, settings, defaults, ...)
	if not TMW.tContains(strings, string) then
		tinsert(strings, string)

		TMW:Fire("TMW_EXPORT_SETTINGS_REQUESTED", strings, type, settings)
	end

	TMW.tRemoveDuplicates(strings)

	return strings
end

function TMW:CleanDefaults(settings, defaults, blocker)
	-- make sure and pass in a COPY of the settings, not the original settings
	-- the following function is a slightly modified version of the one that AceDB uses to strip defaults.

	-- remove all metatables from the db, so we don't accidentally create new sub-tables through them
	setmetatable(settings, nil)
	-- loop through the defaults and remove their content
	for k,v in pairs(defaults) do
		if k == "*" or k == "**" then
			if type(v) == "table" then
				-- Loop through all the actual k,v pairs and remove
				for key, value in pairs(settings) do
					if type(value) == "table" then
						-- if the key was not explicitly specified in the defaults table, just strip everything from * and ** tables
						if defaults[key] == nil and (not blocker or blocker[key] == nil) then
							TMW:CleanDefaults(value, v)
							-- if the table is empty afterwards, remove it
							if next(value) == nil then
								settings[key] = nil
							end
						-- if it was specified, only strip ** content, but block values which were set in the key table
						elseif k == "**" then
							TMW:CleanDefaults(value, v, defaults[key])
                            -- if the table is empty afterwards, remove it
                            if next(value) == nil then
                                settings[key] = nil
                            end
						end
					end
				end
			elseif k == "*" then
				-- check for non-table default
				for key, value in pairs(settings) do
					if defaults[key] == nil and v == value then
						settings[key] = nil
					end
				end
			end
		elseif type(v) == "table" and type(settings[k]) == "table" then
			-- if a blocker was set, dive into it, to allow multi-level defaults
			TMW:CleanDefaults(settings[k], v, blocker and blocker[k])
			if next(settings[k]) == nil then
				settings[k] = nil
			end
		else
			-- check if the current value matches the default, and that its not blocked by another defaults table
			if settings[k] == defaults[k] and (not blocker or blocker[k] == nil) then
				settings[k] = nil
			end
		end
	end
	return settings
end

function TMW:CleanSettings(type, settings, defaults)
	return TMW:CleanDefaults(settings, defaults)
end


---------- Dropdown ----------
TMW:RegisterCallback("TMW_CONFIG_REQUEST_AVAILABLE_IMPORT_EXPORT_TYPES", function(event, editbox, import, export)
	if editbox == TMW.IE.ExportBox then
		if IE.CurrentTabGroup.identifier == "ICON" and CI.icon then
			import.icon = CI.icon
			export.icon = CI.icon

			import.group_overwrite = CI.icon.group
			export.group = CI.icon.group

		elseif IE.CurrentTabGroup.identifier == "GROUP" and CI.group then	
			import.group_overwrite = CI.group
			export.group = CI.group
		end
	end
end)







-- ----------------------
-- UNDO/REDO
-- ----------------------


IE.RapidSettings = {
	-- settings that can be changed very rapidly, i.e. via mouse wheel or in a color picker
	-- consecutive changes of these settings will be ignored by the undo/redo module

	-- TODO: auto register these when they are used by a slider, and kill this table.
	Size = true,
	Level = true,
	Alpha = true,
	GUID = true,
	Color = true,
}

function IE:RegisterRapidSetting(setting)
	IE.RapidSettings[setting] = true
end

function IE:GetCompareResultsPath(match, ...)
	if match then
		return true
	end
	local path = ""
	local setting
	for i, v in TMW:Vararg(...) do
		if i == 1 then
			setting = v
		end
		path = path .. v .. "."
	end
	return path, setting
end

local function DeepCompareWithBlocker(table1, table2, blocker, ...)
	-- heavily modified version of http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3

	-- attempt direct comparison
	if table1 == table2 then
		return true, ...
	end

	-- if the values are not the same (they made it through the check above) AND they are not both tables, then they cannot be the same, so exit.
	local type1 = type(table1)
	if type1 ~= "table" or type1 ~= type(table2) then
		return false, ...
	end

	-- compare table values

	-- We need to two two full comparsions:
	-- table1 to table2, and table2 to table1.
	-- To do this easily without code duplication, we just do this part in a loop,
	-- and swap the two tables after the first iteration.
	for i = 1, 2 do

		for key, value1 in pairs(table1) do
			local value2 = table2[key]

			-- The blocker for this specific key.
			-- If the value is true, we won't do a comparison here.
			-- If the value is anything else (nil if it doesnt exist, or a table that holds deeper blockers),
			-- then the comparison will happen and the blocker will get passed down to the next level.
			local keyBlocker = blocker and blocker[key]

			-- don't bother calling DeepCompareWithBlocker on the values if they are the same - it will just return true.
			-- Only call it if the values are different (they are either 2 tables, or they actually are different non-table values)
			-- by adding the (v1 ~= v2) check, efficiency is increased by about 300%.

			if keyBlocker ~= true and value1 ~= value2 and not DeepCompareWithBlocker(value1, value2, keyBlocker, key, ...) then

				-- it only reaches this point if there is a difference between the 2 tables somewhere
				-- so i dont feel bad about calling DeepCompareWithBlocker with the same args again
				-- i need to because the key of the setting that changed is in there
				return DeepCompareWithBlocker(value1, value2, keyBlocker, key, ...)
			end
		end

		table1, table2 = table2, table1
	end

	return true, ...
end

local function WipeWithBlocker(table, blocker)
	for k, v in pairs(table) do
		local keyBlocker = blocker and blocker[k]

		if keyBlocker ~= true then
			if type(v) == "table" then
				WipeWithBlocker(v, keyBlocker)
				if not next(v) then
					table[k] = nil
				end
			else
				table[k] = nil
			end
		end
	end
end

function IE:DoUndoRedo(direction)
	if not IE.CurrentTab then
		return
	end

	local historySet = IE.CurrentTab:GetHistorySet()

	if not historySet then
		return
	end

	historySet:DoUndoRedo(direction)
end

TMW:NewClass("HistorySet") {
	HistorySets = {},

	OnNewInstance = function(self, identifier)
		TMW:ValidateType("identifier", "HistorySet:New(identifier)", identifier, "string")

		if self.HistorySets[identifier] then
			error("Identifier " .. identifier .. " is already used for a history set")
		end

		self.HistorySets[identifier] = self
		self.blocker = {}
	end,

	GetHistorySet = function(self, identifier)
		return self.HistorySets[identifier]
	end,

	AddBlocker = function(self, blocker)
		TMW:CopyInPlaceWithMetatable(blocker, self.blocker)
	end,

	AttemptBackup = function(self, location, settings)

		if not location or not settings then
			return
		end

		if not location.history then
			-- Create the needed infrastructure for storing history if it does not exist.
			-- This includes creating the first history point
			location.history = {TMW:CopyWithMetatable(settings, self.blocker)}
			location.historyState = #location.history

		else
			-- The needed stuff for undo and redo already exists, so lets delve into the meat of the process.

			-- Compare the current settings with what we have in the currently used history point.
			-- The currently used history point may or may not be the most recent settings, but we want to check ics against what is being used.
			-- Result is either (true) if there were no changes in the settings, or a string representing the key path to the first setting change that was detected.
			-- (it was likely only one setting that changed, but not always)
			local result, changedSetting = IE:GetCompareResultsPath(DeepCompareWithBlocker(location.history[location.historyState], settings, self.blocker))
			if type(result) == "string" then

				-- If we are using an old history point (i.e. we hit undo a few times and then made a change),
				-- delete all history points from the current one forward so that we dont jump around wildly when undoing and redoing
				for i = location.historyState + 1, #location.history do
					location.history[i] = nil
				end

				-- If the last setting that was changed is the same as the most recent setting that was changed,
				-- and if the setting is one that can be changed very rapidly, delete the previous history point.
				-- This improves memory usage and user experience.
				if location.lastChangePath == result and IE.RapidSettings[changedSetting] and location.historyState > 1 then
					location.history[#location.history] = nil
					location.historyState = #location.history
				end
				location.lastChangePath = result

				-- Finally, create the newest history point.
				-- We copy with with the metatable so that when doing comparisons against the current settings, we can invoke metamethods.
				-- This is needed because otherwise an empty event table will not match a fleshed out one that has no non-default data in it.
				location.history[#location.history + 1] = TMW:CopyWithMetatable(settings, self.blocker)

				-- Set the history state to the latest point
				location.historyState = #location.history

			end
		end
	end,

	UpdateButtons = function(self)
		if not IE.CurrentTab then
			IE.UndoButton:Disable()
			IE.RedoButton:Disable()

			return
		end

		local location = self:GetCurrentLocation()

		if location then
			if not location.historyState or location.historyState - 1 < 1 then
				IE.UndoButton:Disable()
			else
				IE.UndoButton:Enable()
			end

			if not location.historyState or location.historyState + 1 > #location.history then
				IE.RedoButton:Disable()
			else
				IE.RedoButton:Enable()
			end
		end
	end,


	GetCurrentLocation = function(self)
		error("This function must be overridden to use AttemptAutoBackup")
	end,

	GetCurrentSettings = function(self)
		error("This function must be overridden to use AttemptAutoBackup")
	end,

	AttemptAutoBackup = function(self)
		local location = self:GetCurrentLocation()
		local settings = self:GetCurrentSettings()

		if location and settings then
			self:AttemptBackup(location, settings)
		end
	end,

	DoUndoRedo = function(self, direction)
		IE:SaveSettings()

		local location = self:GetCurrentLocation()
		local settings = self:GetCurrentSettings()

		local icon = CI.icon

		if not location.history[location.historyState + direction] then return end -- not valid, so don't try

		location.historyState = location.historyState + direction


		-- From the current settings, wipe out anything that isn't being blocked.
		WipeWithBlocker(settings, self.blocker)

		-- Copy everything in the backup that isn't blocked into the original settings.
		TMW:CopyInPlaceWithMetatable(location.history[location.historyState], settings, self.blocker)

		IE:RefreshTabs()
	end
}








-- ----------------------
-- CPU PROFILING
-- ----------------------

local function leftPad(text, len)
	text = tostring(text)
	if #text >= len then return text end
	return strrep(" ", len - #text) .. text
end

local function makeColorFunc(greenBelow, redAbove)
	--local completeColor = TMW:StringToCachedRGBATable("ff00ff00")
	--local halfColor = TMW:StringToCachedRGBATable("ffff8000")
	--local startColor = TMW:StringToCachedRGBATable("ffff0000")
	local completeColor = TMW:StringToCachedRGBATable("ff00ff47")
	local halfColor = TMW:StringToCachedRGBATable("ff00f9ff")
	local startColor = TMW:StringToCachedRGBATable("ff0078ff")

	return function(value)
		local completeColor, startColor, halfColor = completeColor, startColor, halfColor

		if value ~= 0 then
			value = value - greenBelow
			local percent = value / (redAbove - greenBelow)
			percent = min(max(percent, 0), 1)

			if Invert then
				completeColor, startColor = startColor, completeColor
			end
			
			-- This is multiplied by 2 because we subtract 100% if it ends up being past
			-- the point where halfColor will be used.
			-- If we don't multiply by 2, we would check if (percent > 0.5), but then
			-- we would have to multiply that percentage by 2 later anyway in order to use the
			-- full range of colors available (we would only get half the range of colors otherwise, which looks like shit)
			local doublePercent = percent * 2

			if doublePercent > 1 then
				completeColor = halfColor
				doublePercent = doublePercent - 1
			else
				startColor = halfColor
			end

			local inv = 1-doublePercent

			return TMW:RGBAToString(
				(startColor.r * doublePercent) + (completeColor.r * inv),
				(startColor.g * doublePercent) + (completeColor.g * inv),
				(startColor.b * doublePercent) + (completeColor.b * inv),
				(startColor.a * doublePercent) + (completeColor.a * inv)
			)
		end
		return "ff00ff00"
	end
end

TMW.IE.CpuReportParameters = {
	Columns = {
		{
			selected = true,
			title = "Update Method",
			label = "Update Via",
			desc = "Whether icon updates are triggered by events, or checked continually on an interval.",
			value = function(icon) return icon.Update_Method == "auto" and "Interval" or "Event" end,
			format = "%s"
		},


		{
			title = "Updates: Total CPU",
			label = "Update Total",
			desc = "Total CPU time spent on icon updates.",
			value = function(icon) return icon.cpu_updateTotal end,
			format = "%.2f ms"
		},
		{
			selected = true,
			title = "Updates: Count",
			label = "# Updates",
			desc = "Total number of icon updates.",
			value = function(icon) return icon.cpu_updateCount end,
			format = "%8d"
		},
		{
			title = "Updates: CPU Per Update",
			label = "Per Update",
			width = 11,
			desc = "Average CPU time per icon update.",
			value = function(icon) return icon.cpu_updateCount == 0 
				and 0
				or icon.cpu_updateTotal / icon.cpu_updateCount end,
			format = "%.2f ms"
		},
		{
			selected = true,
			title = "Updates: Average",
			label = "Updates Avg",
			desc = "Milliseconds of CPU time spent on icon updates, per second of wall clock time.",
			value = function(icon) return icon.cpu_updateTotal / (TMW.time - icon.cpu_startTime) end,
			format = "%.2f ms/s",
			color = makeColorFunc(0.05, 2)
		},
		{
			title = "Updates: Peak",
			label = "Peak Update",
			desc = "Highest CPU time spent on any single update.",
			value = function(icon) return icon.cpu_updatePeak end,
			format = "%.2f ms"
		},


		{
			title = "Events: Total CPU",
			label = "Events Total",
			desc = "Total CPU time spent on event handling.",
			value = function(icon) return icon.cpu_eventTotal end,
			format = "%.2f ms"
		},
		{
			selected = true,
			title = "Events: Count",
			label = "# Events",
			desc = "Total number of events handled.",
			value = function(icon) return icon.cpu_eventCount end,
			format = "%8d"
		},
		{
			title = "Events: CPU Per Event",
			label = "Per Event",
			desc = "Average CPU time per event handled.",
			width = 11,
			value = function(icon) return icon.cpu_eventCount == 0 
					and 0
					or icon.cpu_eventTotal / icon.cpu_eventCount end,
			format = "%.2f ms"
		},
		{
			selected = true,
			title = "Events: Average",
			label = "Events avg",
			desc = "Average CPU time spent on event handling per second of wall clock time.",
			value = function(icon) return icon.cpu_eventTotal / (TMW.time - icon.cpu_startTime) end,
			format = "%.2f ms/s",
			color = makeColorFunc(0.03, 1)
		},
		{
			title = "Events: Peak",
			label = "Peak Event",
			desc = "Highest CPU time spent on any single event.",
			value = function(icon) return icon.cpu_eventPeak end,
			format = "%.2f ms"
		},


		{
			selected = true,
			title = "Conditions: Update Method",
			label = "Cndtn Method",
			desc = "Whether condition updates are triggered by events, or checked continually on an interval.",
			value = function(icon) 
				if not icon.ConditionObject then return "" end
				local method = icon.ConditionObject.UpdateMethod
				return method == "OnUpdate" and "Interval" or "Event" end,
			format = "%s"
		},
		{
			title = "Conditions: Total CPU",
			label = "Cndtn Total",
			desc = "Total CPU time spent on condition checking.",
			value = function(icon) return icon.cpu_cndtTotal end,
			format = "%.2f ms"
		},
		{
			title = "Conditions: Count",
			label = "# Cndtn",
			desc = "Number of times that conditions were checked for this icon.",
			value = function(icon) return icon.cpu_cndtCount end,
			format = "%8d"
		},
		{
			title = "Conditions: CPU Per Check",
			label = "Per Cndtn",
			desc = "Average CPU time per condition check.",
			width = 11,
			value = function(icon) return icon.cpu_cndtCount == 0 
					and 0
					or icon.cpu_cndtTotal / icon.cpu_cndtCount end,
			format = "%.2f ms"
		},
		{
			selected = true,
			title = "Conditions: Average",
			label = "Cndtn avg",
			desc = "Average CPU time spent on condition checking per second of wall clock time.",
			value = function(icon) return icon.cpu_cndtTotal / (TMW.time - icon.cpu_startTime) end,
			format = "%.2f ms/s",
			color = makeColorFunc(0.02, 0.6)
		},
	}
}
function TMW.IE:GetCpuProfileReport()

	local update_avg = 0
	local event_avg = 0

	local r = {}
	for group in TMW:InGroups() do
		local printedGroup = false
		for icon in group:InIcons() do 
			if icon.cpu_updateTotal > 0 or icon.cpu_eventTotal > 0 or icon.cpu_cndtTotal > 0 then

				local time = TMW.time - icon.cpu_startTime
				local update = icon.cpu_updateTotal / time
				local event = icon.cpu_eventTotal == 0 and 0 or (icon.cpu_eventTotal / time)
				update_avg = update_avg + update
				event_avg = event_avg + event

				if not printedGroup then
					printedGroup = true
					-- local groupName = group:GetFullName()

					r[#r+1] = "\n"

					r[#r+1] = ("\n%-30s || "):format((group.Name or ""):sub(1, 30))
					for i, column in pairs(TMW.IE.CpuReportParameters.Columns) do
						if column.selected then
							local text = column.label
							text = leftPad(text, column.width or #text)

							r[#r+1] = text .. "  "
						end
					end
				end
				
				local name = L["GROUPICON"]:format(
					leftPad(group.ID, 2),
					leftPad(icon.ID, 2)
				)
				if group.Domain == "global" then
					name = L["DOMAIN_GLOBAL_NC"] .. " " .. name
				end

				r[#r+1] = ("\n%30s || "):format(name)
				for i, column in pairs(TMW.IE.CpuReportParameters.Columns) do
					if column.selected then
						local value = column.value(icon)
						local text = 
							value == 0 and "" or 
							column.format and format(column.format, value) or
							column.text(value)
						text = leftPad(text, column.width or #column.label)
						if column.color then
							text = "|c" .. column.color(value) .. text .. "|r"
						end

						r[#r+1] = text .. "  "
					end
				end

				-- r = r .. "\n" .. ("%20s || %sms %8d %s ms/s || %sms %8d %s ms/s"):format(
				-- 		icon.ID, 
				-- 		floatPad(icon.cpu_updateTotal, 9), 
				-- 		floatPad(icon.cpu_updateCount), 
				-- 		--floatPad(icon.cpu_updatePeak, 6), 
				-- 		floatPad(update, 8),
				-- 		floatPad(icon.cpu_eventTotal, 9),
				-- 		floatPad(icon.cpu_eventCount), 
				-- 		--floatPad(icon.cpu_eventPeak, 6)
				-- 		floatPad(event, 8)
				-- )
			end
		end
	end

	return table.concat(r)
	
	-- wlp(update_avg, event_avg, "\n\n\n")
end


