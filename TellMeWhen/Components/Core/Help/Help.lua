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

local TMW = TMW
local L = TMW.L
local print = TMW.print


local HELP = TMW:NewModule("Help", "AceTimer-3.0")
TMW.HELP = HELP

HELP.Codes = {
	"ICON_POCKETWATCH_FIRSTSEE",

	"ICON_DURS_FIRSTSEE",
	"ICON_DURS_MISSING",

	"ICON_IMPORT_CURRENTPROFILE",

	"ICON_UNIT_MISSING",

	"CNDT_PARENTHESES_ERROR",
}

HELP.OnlyOnce = {
	ICON_DURS_FIRSTSEE = true,
	ICON_POCKETWATCH_FIRSTSEE = true,
	ICON_IMPORT_CURRENTPROFILE = true,
	ICON_EXPORT_DOCOPY = true,
}

HELP.Queued = {}

function HELP:OnInitialize()
	self.Arrow = TellMeWhen_HelpFrame
	self.Frame = TellMeWhen_HelpFrame.body

	-- try to show any helps that got queued before OnInitialize() was called.
	HELP:ShowNext()
end


---------- External Usage ----------
function HELP:Show(help)
	-- handle the code, determine the ID of the code.
	TMW:ValidateType(1, 					"TMW.HELP:Show(help)", help, "table")
	TMW:ValidateType("help.code", 			"TMW.HELP:Show(help)", help.code, "string")
	TMW:ValidateType("help.icon", 			"TMW.HELP:Show(help)", help.icon, "frame;nil")
	TMW:ValidateType("help.text", 			"TMW.HELP:Show(help)", help.text, "string")

	TMW:ValidateType("help.parent", 		"TMW.HELP:Show(help)", help.parent, "frame;nil")
	TMW:ValidateType("help.relativeTo", 	"TMW.HELP:Show(help)", help.relativeTo, "frame")
	TMW:ValidateType("help.relativePoint", 	"TMW.HELP:Show(help)", help.relativePoint, "string;nil")
	TMW:ValidateType("help.x", 				"TMW.HELP:Show(help)", help.x, "number;nil")
	TMW:ValidateType("help.y", 				"TMW.HELP:Show(help)", help.y, "number;nil")
	
	local code = help.code

	if not HELP:IsCodeRegistered(code) then
		if not help.codeOrder then
			TMW:Error("Code %q was not defined before calling HELP:Show(), and help.codeOrder was not set for auto-registration.", help.code)
			return
		else
			TMW:ValidateType("help.codeOrder", "TMW.HELP:Show(help)", help.codeOrder, "number")
			TMW:ValidateType("help.codeOnlyOnce", "TMW.HELP:Show(help)", help.codeOnlyOnce, "boolean;nil")
			HELP:NewCode(code, help.codeOrder, help.codeOnlyOnce)
		end
	end

	-- retrieve or create the data table
	self.Queued[code] = nil

	-- if the frame has the CreateTexture method, then it can be made the parent.
	-- Otherwise, the frame is actually a texture/font/etc object, so set its parent as the parent.
	help.parent = help.parent or TMW.IE

	-- determine if the code has a setting associated to only show it once.
	help.onlyOnceSetting = self.OnlyOnce[code] and code

	-- if it does and it has already been set true, then we dont need to show anything, so quit.
	if help.onlyOnceSetting and TMW.db.global.HelpSettings[help.onlyOnceSetting] then
		self.Queued[code] = nil
		help = nil
		return
	end

	-- if the code is the same as what is currently shown, then replace what is currently being shown.
	if self.showingHelp and self.showingHelp.code == code then
		self.showingHelp = nil
	end

	-- everything should be in order, so add the help to the queue.
	self:Queue(help)

	-- notify that this help will eventually be shown
	return 1
end

function HELP:Hide(code, userDidntAcknowledge)
	if self.Queued[code] then
		self.Queued[code] = nil
	elseif self:GetShown() == code then

		-- If it had an OnlyOnce setting, and the user might not have noticed the help,
		-- then give it a chance to show again.
		if self.showingHelp.onlyOnceSetting and userDidntAcknowledge then
			TMW.db.global.HelpSettings[self.showingHelp.onlyOnceSetting] = false
		end

		self.showingHelp = nil
		self:ShowNext()
	end
end

function HELP:GetShown()
	return self.showingHelp and self.showingHelp.code
end

function HELP:NewCode(code, order, OnlyOnce)
	TMW:ValidateType(2, "HELP:NewCode(code, order, OnlyOnce)", code, "string")
	assert(not HELP:IsCodeRegistered(code), "HELP code " .. code .. " is already registered!")
	
	if order then
		order = min(order, #HELP.Codes + 1)
		tinsert(HELP.Codes, order, code)
	else
		tinsert(HELP.Codes, code)
	end
	
	if OnlyOnce then
		HELP.OnlyOnce[code] = true
	end
end

function HELP:IsCodeRegistered(code)
	return TMW.tContains(HELP.Codes, code)
end



---------- Queue Management ----------
function HELP:Queue(help)
	-- add the help to the queue
	HELP.Queued[help.code] = help

	-- notify the engine to start
	HELP:ShowNext()
end

function HELP:OnClose()
	HELP.showingHelp = nil
	HELP:ShowNext()
end

function HELP:ShouldShowHelp(help)
	if help.icon and not help.icon:IsBeingEdited() then
		return false
	elseif not (help.relativeTo.CreateTexture and help.relativeTo or help.relativeTo:GetParent()):IsVisible() then
		return false
	end
	return true
end

function HELP:ShowNext()
	if not HELP.Arrow then
		-- we haven't initialized yet
		return
	end

	-- if there nothing currently being displayed, hide the frame.
	if not HELP.showingHelp then
		HELP.Arrow:Hide()
	end

	-- if we are already showing something, then don't overwrite it.
	if HELP.showingHelp then
		-- but if the current help should not be shown, then stop showing it, but stick it back in the queue to try again later
		if not HELP:ShouldShowHelp(HELP.showingHelp) then
			local current = HELP.showingHelp
			HELP.showingHelp = nil
			HELP:Queue(current)
		end
		return
	end

	-- if there isn't a next help to show, then dont try.
	if not next(HELP.Queued) then
		return
	end

	-- calculate the next help in line based on the order of HELP.Codes
	local help
	for order, code in ipairs(HELP.Codes) do
		if HELP.Queued[code] and HELP:ShouldShowHelp(HELP.Queued[code]) then
			help = HELP.Queued[code]
			break
		end
	end

	if not help then
		return
	end


	HELP.Arrow:SetParent(help.parent)
	HELP.Arrow:ClearAllPoints()
	HELP.Arrow:SetPoint("RIGHT", help.relativeTo, help.relativePoint or "LEFT", (help.x or 0) - 0, (help.y or 0) + 0)
	HELP.Frame.text:SetText(help.text)
	HELP.Frame:SetHeight(HELP.Frame.text:GetHeight() + 38)
	HELP.Frame:SetWidth(min(280, HELP.Frame.text:GetStringWidth() + 30))

	HELP.Arrow:Show()

	-- Seems to help fix issues where the background won't show up initially.
	HELP.Frame:Hide()
	HELP.Frame:Show()


	-- if the help had a setting associated, set it now
	if help.onlyOnceSetting then
		TMW.db.global.HelpSettings[help.onlyOnceSetting] = true
	end

	-- remove the help from the queue and set it as the current help
	HELP.Queued[help.code] = nil
	HELP.showingHelp = help
end

function HELP:HideForIcon(icon)
	for code, help in pairs(HELP.Queued) do
		if help.icon == icon then
			HELP.Queued[code] = nil
		end
	end
	if HELP.showingHelp and HELP.showingHelp.icon == icon then
		HELP.showingHelp = nil
		HELP:ShowNext()
	end
end



TMW:RegisterCallback("TMW_CONFIG_ICON_TYPE_CHANGED", function(event, icon)
	if TMW.CI.icon then
		HELP:HideForIcon(TMW.CI.icon)
	end
end)

TMW:RegisterCallback("TMW_CONFIG_ICON_LOADED_CHANGED", function(event, icon, icon_old)
	HELP:HideForIcon(icon_old)
end)

TMW:RegisterCallback("TMW_ICON_SETTINGS_RESET", function(event, icon)
	HELP:HideForIcon(icon)
end)	

TMW:RegisterCallback("TMW_CONFIG_TAB_CLICKED", function(event, tab, oldTab)
	HELP:ShowNext()
end)


