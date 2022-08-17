local _, addon = ...
local L = TomTomLocals

-- Credit to p3lim for the basic paste widget used here, adapted from
-- https://github.com/p3lim-wow/Inomena/blob/master/modules/widgets/paste.lua

addon.TEXTURE = [[Interface\ChatFrame\ChatFrameBackground]]

local BACKDROP = {
	bgFile = addon.TEXTURE,
	edgeFile = addon.TEXTURE,
	edgeSize = 1,
}

local backdropMixin = {}
function backdropMixin:CreateBackdrop(backdropAlpha, borderAlpha)
	if not self.SetBackdrop then
		Mixin(self, BackdropTemplateMixin)
	end

	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0, backdropAlpha or 0.5)
	self:SetBackdropBorderColor(0, 0, 0, borderAlpha or 1)
end

local paste = Mixin(CreateFrame("Frame", "TomTomPaste", UIParent), backdropMixin)
paste:SetPoint("CENTER")
paste:SetSize(600, 400)
paste:Hide()
paste:CreateBackdrop()

local editbox = Mixin(CreateFrame("EditBox", nil, paste), backdropMixin)
editbox:SetPoint("TOPLEFT", 5, -5)
editbox:SetPoint("BOTTOMRIGHT", -5, 30)
editbox:SetFontObject(ChatFontNormal)
editbox:SetMultiLine(true)
editbox:SetAutoFocus(false)
editbox:CreateBackdrop()
editbox:SetScript("OnEscapePressed", function()
    editbox:ClearFocus()
end)
editbox:SetScript("OnShow", function()
    editbox:SetFocus(true)
end)

local submit = CreateFrame("Button", nil, paste, "UIPanelButtonTemplate")
submit:SetPoint("BOTTOM", -25, 5)
submit:SetSize(50, 20)
submit:SetText("Paste")
submit:SetScript("OnClick", function()
	for _, line in ipairs({string.split("\n", editbox:GetText())}) do
		ChatFrame_OpenChat("")
		local editBox = ChatEdit_GetActiveWindow()
		editBox:SetText(line)
		ChatEdit_SendText(editBox, 1)
		ChatEdit_DeactivateChat(editBox)
	end

	editbox:SetText("")
	paste:Hide()
end)

editbox:SetScript('OnEnterPressed', function()
	if IsControlKeyDown() then
		submit:Click()
	end
end)

local close = CreateFrame("Button", nil, paste, "UIPanelButtonTemplate")
close:SetPoint("BOTTOM", 25, 5)
close:SetSize(50, 20)
close:SetText("Close")
close:SetScript("OnClick", function()
	paste:Hide()
end)

SLASH_TOMTOM_PASTE1 = "/ttpaste"
SLASH_TOMTOM_PASTE2 = "/tomtompaste"

local function slashToggle()
    paste:SetShown(not paste:IsShown())
end

local function initPageDB()
	if not addon.db.profile.pastePages then
		addon.db.profile.pastePages = {}
	end
end

local function getPage(title)
	initPageDB()
	return addon.db.profile.pastePages[title]
end

local function setPage(title, contents)
	initPageDB()
	addon.db.profile.pastePages[title] = contents
end

local function removePage(title)
	initPageDB()
	addon.db.profile.pastePages[title] = nil
end

local function slashList()
    local titles = {}
    for k,v in pairs(addon.db.profile.pastePages or {}) do
        table.insert(titles, k)
    end

    if #titles > 0 then
        addon:Printf(L["Saved pages: %s"], table.concat(titles, ", "))
    else
        addon:Printf(L["No pages saved"])
    end
end

local function slashSave(title)
    local contents = editbox:GetText()
    if not contents or #contents <= 0 then
        addon:Printf(L["No contents to save"])
        return
    end

    if not title then
        addon:Printf(L["Must specify page name"])
        return
    end

	setPage(title, contents)
    addon:Printf(L["Saved %d characters to page '%s'"], #contents, title)
end

local function slashLoad(title)
    if not title then
        addon:Printf(L["Must specify a page title to load"])
        return
    end

	local contents = getPage(title)
    if not contents then
        addon:Printf(L["No page found with title '%s'"], title)
        return
    end

    editbox:SetText(contents)
    addon:Printf(L["Loaded %d characters from page '%s'"], #contents, title)
    paste:SetShown(true)
end

local function slashRemove(title)
    if not title then
        addon:Printf(L["Must specify a page title to remove"])
        return
    end

    local contents = addon.db.profile.pastePages[title]
    if not contents then
        addon:Printf(L["No page found with title '%s'"], title)
        return
    end

	removePage(title)
    addon:Printf(L["Removed %d characters from page '%s'"], #contents, title)
end

SlashCmdList["TOMTOM_PASTE"] = function(msg)
    local subCommand, remainder
    if not msg then
        subCommand = L["toggle"]
    else
        subCommand, remainder = msg:match("(%S+)%s*(.*)$")
        subCommand = subCommand and subCommand:lower()
    end

    if not subCommand then
        slashToggle()
    elseif subCommand == L["toggle"] then
        slashToggle()
    elseif subCommand == L["list"] then
        slashList()
    elseif subCommand == L["save"] then
        slashSave(remainder)
    elseif subCommand == L["load"] then
        slashLoad(remainder)
    elseif subCommand == L["remove"] then
        slashRemove(remainder)
    else
        addon:Printf(L["Usage: /ttpaste [command]"])
        addon:Printf(L["  /ttpaste toggle - Show/hide the paste window"])
        addon:Printf(L["  /ttpaste list - List the titles of pages that have been saved"])
        addon:Printf(L["  /ttpaste save [title] - Save the current contents of the window with the given name"])
        addon:Printf(L["  /ttpaste load [title] - Load a saved page to the paste window"])
        addon:Printf(L["  /ttpaste remove [title] - Remove a saved page"])
        addon:Printf(L["  /ttpaste help - This help message"])
    end
end
