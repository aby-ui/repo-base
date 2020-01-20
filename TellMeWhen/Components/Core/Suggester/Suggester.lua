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

local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture

local _, pclass = UnitClass("Player")
local LSM = LibStub("LibSharedMedia-3.0")

local tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, wipe, next, getmetatable, setmetatable, assert, rawget, rawset, unpack, select =
	  tonumber, tostring, type, pairs, ipairs, tinsert, tremove, sort, wipe, next, getmetatable, setmetatable, assert, rawget, rawset, unpack, select
local strfind, strmatch, strbyte, format, gsub, strsub, strtrim, strlen, strsplit, strlower, max, min, floor, ceil, log10 =
	  strfind, strmatch, strbyte, format, gsub, strsub, strtrim, strlen, strsplit, strlower, max, min, floor, ceil, log10
local GetSpellInfo, GetItemInfo, GetItemIcon = 
      GetSpellInfo, GetItemInfo, GetItemIcon

-- GLOBALS: GameTooltip, GameTooltip_SetDefaultAnchor

local ClassSpellCache = TMW:GetModule("ClassSpellCache")
local AuraCache = TMW:GetModule("AuraCache")
local SpellCache = TMW:GetModule("SpellCache")
local ItemCache = TMW:GetModule("ItemCache")

local SUG = TMW:NewModule("Suggester", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceTimer-3.0")
TMW.SUG = SUG


local DEBOUNCE_TIMER = 0.05

TMW.IE:RegisterUpgrade(62217, {
	global = function(self)
		-- These are both old and unused. Kill them.
		TMW.IE.db.global.CastCache = nil
		TMW.IE.db.global.ClassSpellCache = nil
	end,
})

---------- Locals/Data ----------
local SUGIsNumberInput
local SUGpreTable = {}

local ClassSpellLookup = ClassSpellCache:GetSpellLookup()

---------- Initialization/Spell Caching ----------
TMW:RegisterCallback("TMW_CONFIG_ICON_TYPE_CHANGED", function(event, icon)
	if icon == TMW.CI.icon then
		SUG.redoIfSame = 1
		SUG.SuggestionList:Hide()
	end
end)

function SUG:TMW_SPELLCACHE_STARTED()
	SUG.SuggestionList.Caching:Show()
end
TMW:RegisterCallback("TMW_SPELLCACHE_STARTED", SUG)

function SUG:TMW_SPELLCACHE_COMPLETED()
	SUG.SuggestionList.Caching:Hide()
	
	if SUG.onCompleteCache and SUG.SuggestionList:IsVisible() then
		SUG.redoIfSame = 1
		SUG:NameOnCursor()
	end
end
TMW:RegisterCallback("TMW_SPELLCACHE_COMPLETED", SUG)

---------- Suggesting ----------
local suggestedForModule
function SUG:DoSuggest()
	if not SUG.SuggestionList:IsVisible() then
		return
	end

	wipe(SUGpreTable)

	local tbl = SUG.CurrentModule:Table_Get() or {}

	local start = debugprofilestop()
	SUG.CurrentModule:Table_GetNormalSuggestions(SUGpreTable, tbl)
	SUG.CurrentModule:Table_GetEquivSuggestions(SUGpreTable, SUG.CurrentModule:Table_Get())

	for specFunc = 1, math.huge do
		local Table_GetSpecialSuggestions = SUG.CurrentModule["Table_GetSpecialSuggestions_" .. specFunc]
		if not Table_GetSpecialSuggestions then
			break
		end

		Table_GetSpecialSuggestions(SUG.CurrentModule, SUGpreTable)
	end

	print("SUG: Got Suggestions in " .. (debugprofilestop() - start))

	suggestedForModule = SUG.CurrentModule
	SUG.tabIndex = 1
	SUG:SuggestingComplete(1)
end

local function progressCallback(countdown)
	-- This is called for each step of TMW.shellSortDeferred.
	SUG:SuggestingComplete()

	SUG.SuggestionList.blocker:Show()
	SUG.SuggestionList.Header:SetText(L["SUGGESTIONS_SORTING"] .. " " .. countdown)
end

local buckets_meta = {__index = function(t, k)
	t[k] = {}
	return t[k]
end}
local buckets = setmetatable({}, buckets_meta)

function SUG:SuggestingComplete(doSort)
	SUG.SuggestionList.blocker:Hide()
	SUG.SuggestionList.Header:SetText(SUG.CurrentModule.headerText)
	if doSort and not SUG.CurrentModule.dontSort then
		local start = debugprofilestop()

		local sorter, sorterBucket = SUG.CurrentModule:Table_GetSorter()

		if sorterBucket then

			-- Don't GC the buckets while we're using them
			-- (idk if this would ever happen, but better safe than sorry)
			buckets_meta.__mode = nil

			-- Fill the bukkits.
			sorterBucket(SUG.CurrentModule, SUGpreTable, buckets)

			-- All this data is in the buckets now, so wipe SUGpreTable
			-- so we can fill it after we sort the buckets.
			wipe(SUGpreTable)
			local len = 0

			for k, bucket in TMW:OrderedPairs(buckets) do
				if next(bucket) then
					-- Sort the bucket.
					local bucketSorter = bucket.__sorter or sorter

					sort(bucket, bucketSorter)

					-- Add the sorted bucket's contents to the main table.
					for i = 1, #bucket do
						len = len + 1
						SUGpreTable[len] = bucket[i]
					end

					-- We're done with this bucket. Prepare it for next use.
					-- It might get reused, or it might get GC'd.
					wipe(bucket)
				end
			end

			-- Resume GC on the buckets.
			buckets_meta.__mode = 'kv'

		else
			SUG.SuggestionList.blocker:Show()
			SUG.SuggestionList.Header:SetText(L["SUGGESTIONS_SORTING"])

			TMW.shellsortDeferred(SUGpreTable, sorter, nil, SUG.SuggestingComplete, SUG, progressCallback)
			return
		end
		print("SUG: Sorted in " .. debugprofilestop() - start)
	end

	if suggestedForModule ~= SUG.CurrentModule then
		TMW:Debug("SUG module changed mid-suggestion")
		return
	end

	-- Each module should maintain a cached list of invalid entries
	-- We rawget here beccause we don't want to get a parent module's
	-- list of invalid entries - we wan't to get the module's own list.
	local InvalidEntries = rawget(SUG.CurrentModule, "InvalidEntries")
	if not InvalidEntries then
		SUG.CurrentModule.InvalidEntries = {}
		InvalidEntries = SUG.CurrentModule.InvalidEntries
	end

	-- SUG:GetFrame() creates a frame if it doesn't exist.
	local numFramesNeeded = TMW.SUG:GetNumFramesNeeded()
	for id = 1, numFramesNeeded do
		SUG:GetFrame(id)
	end
	
	for frameID = 1, #SUG do
		local id, key
		while true do
		
			-- Here is how this horrifying line of code works:
			-- This makes sure that the offset can't be more than the number of suggestions plus 1
			-- The plus 1 is so that there will be one blank frame at the end to show the user that they're at the end.
			SUG.offset = min(SUG.offset, max(0, #SUGpreTable-numFramesNeeded+1))
			
			key = frameID + SUG.offset
			id = SUGpreTable[key]
			
			if not id then
				break
			end
			if InvalidEntries[id] == nil then
				InvalidEntries[id] = not SUG.CurrentModule:Entry_IsValid(id)
			end
			if InvalidEntries[id] then
				tremove(SUGpreTable, key)
			else
				break
			end
		end

		local f = SUG:GetFrame(frameID)

		-- Reset everything about the frame.
		f.Name:SetText(nil)
		f.ID:SetText(nil)
		f.insert = nil
		f.insert2 = nil
		f.tooltipmethod = nil
		f.tooltiparg = nil
		f.tooltiptitlewrap = 1
		f.tooltiptitle = nil
		f.tooltiptext = nil
		f.overrideInsertID = nil
		f.overrideInsertName = nil
		f.Background:SetVertexColor(0, 0, 0, 0)
		f.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		f:UnlockHighlight()

		if SUG.CurrentModule.noTexture then
			f.Icon:SetWidth(0.00001)
		else
			f.Icon:SetWidth(f.Icon:GetHeight())
		end

		if id and frameID <= numFramesNeeded then
			-- Call Entry_AddToList_# methods until there aren't anymore.
			for addFunc = 1, math.huge do
				local Entry_AddToList = SUG.CurrentModule["Entry_AddToList_" .. addFunc]
				if not Entry_AddToList then
					break
				end

				Entry_AddToList(SUG.CurrentModule, f, id)

				if f.insert then
					break
				end
			end

			-- Call Entry_Colorize_# methods until there aren't anymore.
			for colorizeFunc = 1, math.huge do
				local Entry_Colorize = SUG.CurrentModule["Entry_Colorize_" .. colorizeFunc]
				if not Entry_Colorize then
					break
				end

				Entry_Colorize(SUG.CurrentModule, f, id)
			end

			if frameID == SUG.tabIndex then
				f:LockHighlight()
			end

			f:Show()
		else
			f:Hide()
		end
	end

	if self.inline then
		if #SUGpreTable >= numFramesNeeded then
			SUG.SuggestionList:SetHeight(SUG:GetHeightForFrames(numFramesNeeded))
		else
			SUG.SuggestionList:SetHeight(SUG:GetHeightForFrames(#SUGpreTable))
		end
	end

	-- If there is a frame that we are mousing over, update its tooltip
	if SUG.mousedOver then
		TMW:TT_Update(SUG.mousedOver)
	else
		-- Otherwise, show the tooltip of the current tab index
		local f = SUG[SUG.tabIndex]
		if f and f:IsVisible() then
			f:GetScript("OnEnter")(f)
			TMW.SUG.mousedOver = nil -- this gets set on the OnEnter, but it isn't correct.
		end
	end
end

local letterMatch, shouldLetterMatch, shouldWordMatch, wordMatch, wordMatch2
local strfindsugMatches = {}

function SUG:NameOnCursor(isClick)
	if SpellCache:IsCaching() then
		-- Wait for the spell cache to complete.
		-- SUG.onCompleteCache will cause this method to be called when the cache completes.
		SUG.onCompleteCache = 1
		SUG.SuggestionList:Show()
		return
	end

	-- This method gets a whole shitload of info about the words around the cursor in the editbox.
	-- Here are what's currently published by this method:
	--	SUG.oldLastName 		-- SUG.lastName from the previous time this method was called
	--	SUG.startpos 			-- starting position in the editbox of what we're suggestion. Provided by SUG.CurrentModule:GetStartEndPositions()
	--	SUG.endpos 				-- ending position in the editbox of what we're suggestion. Provided by SUG.CurrentModule:GetStartEndPositions()
	--	SUG.lastName_unmodified	-- the text between SUG.startpos and SUG.endpos, cleaned and strlowered.
	--	SUG.lastName 			-- SUG.lastName_unmodified with any duration syntax stripped out, and any special chars for strmatch() escaped.
	--	SUG.duration 			-- the duration if the duration syntax (Spell: duration) was used.
	-- 	SUG.atBeginning 		-- "^" .. SUG.lastName; for ease of use with strmatch.
	-- 	SUG.inputType 			-- "number" or "string", depending on what is being suggested.

	SUG.oldLastName = SUG.lastName
	local text = SUG.Box:GetText()

	SUG.CurrentModule:GetStartEndPositions(isClick)


	SUG.lastName = strlower(TMW:CleanString(strsub(text, SUG.startpos, SUG.endpos)))
	SUG.lastName_unmodified = SUG.lastName

	if strfind(SUG.lastName, ":[%d:%s%.]*$") then
		SUG.lastName, SUG.duration = strmatch(SUG.lastName, "(.-):([%d:%s%.]*)$")
		SUG.duration = strtrim(SUG.duration, " :;.")
		if SUG.duration == "" then
			SUG.duration = nil
		end
	else
		SUG.duration = nil
	end

	-- always escape parentheses, brackets, percent signs, minus signs, plus signs
	-- but don't escape wildcards (* and .)
	SUG.lastName = gsub(SUG.lastName, "([%(%)%%%[%]%-%+])", "%%%1")
	
	if TMW.debug then
		-- Makes building equivalencies easier - I can copy the equiv string straight into the IE
		-- to easily see what spellIDs are still valid.
		SUG.lastName = SUG.lastName:trim("_")
	end

	SUG.atBeginning = "^" .. SUG.lastName
	shouldWordMatch = strfind(SUG.lastName, " ")
	shouldLetterMatch = not shouldWordMatch and #SUG.lastName > 1 and #SUG.lastName < 5
	letterMatch = "^" .. gsub(SUG.lastName, "(.)", " %1.-"):trim()
	wordMatch = "^" .. gsub(SUG.lastName, " ", ".- "):trim()
	wipe(strfindsugMatches)

	local asNumber = tonumber(SUG.lastName)
	if asNumber and asNumber ~= math.huge then
		-- We check against math.huge so that "Inf" isn't treated as a number.
		SUG.inputType = "number"
	else
		SUG.inputType = "string"
	end
	SUGIsNumberInput = SUG.inputType == "number"
	
	if (not SUG.CurrentModule:GetShouldSuggest()) or (not SUG.CurrentModule.noMin and (SUG.lastName == "" or not strfind(SUG.lastName, "[^%.]"))) then
		SUG.SuggestionList:Hide()
		return
	else
		SUG.SuggestionList:Show()
	end
	
	if SUG.CurrentModule.OnSuggest then
		SUG.CurrentModule:OnSuggest()
	end

	if SUG.oldLastName ~= SUG.lastName or SUG.redoIfSame then
		SUG.redoIfSame = nil

		SUG.offset = 0
		SUG:DoSuggest()
	else
		SUG:SuggestingComplete()
	end

	-- Create a new table so that old one, which is now nearly 2MB in size, can be GC'd.
	-- Lua doesn't reduce the size of hash tables when they are emptied, apparently.
	strfindsugMatches = {}
end

function SUG.strfindsug(str)
	local matched = strfindsugMatches[str]
	if matched ~= nil then
		return matched
	end

	matched = strfind(str, SUG.atBeginning) 
	or (shouldLetterMatch and strfind(str, letterMatch)) 
	or (shouldWordMatch and strfind(str, wordMatch))

	strfindsugMatches[str] = not not matched
	return matched
end
local strfindsug = SUG.strfindsug


do	-- KeyManger
	local KeyManager = CreateFrame("Frame", nil, UIParent)
	KeyManager:SetFrameStrata("FULLSCREEN")
	KeyManager:EnableKeyboard(true)
	KeyManager:Show()
	function KeyManager:HandlePress(key)
		if key == "UP" then
			if SUG.tabIndex > 1 then
				SUG.tabIndex = SUG.tabIndex - 1
			elseif SUG.offset > 0 then
				SUG.offset = SUG.offset - 1
			end

		elseif key == "DOWN" then
			if TMW.SUG[SUG.tabIndex + 1] and TMW.SUG[SUG.tabIndex + 1]:IsVisible() then
				SUG.tabIndex = SUG.tabIndex + 1
			else
				SUG.offset = SUG.offset + 1
			end
		
		else
			return
		end

		SUG:SuggestingComplete()
	end

	KeyManager:SetScript("OnKeyDown", function(self, key)
		if SUG.SuggestionList:IsVisible() and (key == "UP" or key == "DOWN") then
			KeyManager:SetPropagateKeyboardInput(false)
			self.down = {key = key, start = TMW.time}

			self:HandlePress(key)
		else
			KeyManager:SetPropagateKeyboardInput(true)
		end
	end)
	KeyManager:SetScript("OnKeyUp", function(self, key)
		KeyManager:SetPropagateKeyboardInput(true)

		self.down = nil
	end)
	KeyManager:SetScript("OnUpdate", function(self, key)
		if not self.down then
			return
		end
		local data = self.down

		local repeatRate = 0.05
		if (not data.last and data.start + 0.5 < TMW.time) or (data.last and data.last + repeatRate < TMW.time) then
			self:HandlePress(data.key)
			data.last = (data.last or TMW.time) + repeatRate
		end
	end)
end
  

---------- EditBox Hooking ----------
local EditBoxHooks = {
	OnEditFocusLost = function(self)
		--if self.SUG_Enabled then
			SUG.SuggestionList:Hide()
		--end
	end,
	OnEditFocusGained = function(self)
		if self.SUG_Enabled then
			local newModule = SUG:GetModule(self.SUG_type, true)
			
			
			if not newModule then
				SUG:DisableEditBox(self)
				error(
					("EditBox %q is supposed to implement SUG module %q, but the module doesn't seem to exist..."):
					format(tostring(self:GetName() or self), tostring(self.SUG_type or "<??>"))
				)
			end
			
			SUG.redoIfSame = SUG.CurrentModule ~= newModule
			SUG.Box = self
			SUG.CurrentModule = newModule
			SUG.SuggestionList.Header:SetText(SUG.CurrentModule.headerText)
			SUG:SetInline(self.SUG_inline)
			SUG.SuggestionList:SetParent(self.SUG_parent or TellMeWhen_IconEditor)
			SUG:NameOnCursor()
		end
	end,
	OnTextChanged = function(self, userInput)
		if self.SUGTimer then
			self.SUGTimer:Cancel()
		end
		self.SUGTimer = C_Timer.NewTimer(DEBOUNCE_TIMER, function()
			if userInput and self.SUG_Enabled then
				SUG.redoIfSame = nil
				SUG:NameOnCursor()
			end
		end)
	end,
	OnMouseUp = function(self)
		if self.SUG_Enabled then
			SUG:NameOnCursor(1)
		end
	end,

	OnTabPressed = function(self)
		local i = SUG.tabIndex

		if self.SUG_Enabled and SUG[i] and SUG[i].insert and SUG[i]:IsVisible()
			and not SUG.CurrentModule.noTab and not SUG.SuggestionList.blocker:IsShown() then
			SUG[i]:Click("LeftButton")
			TMW.HELP:Hide("SUG_FIRSTHELP")
		end
	end,
}

--- Enable the suggestion list on an editbox.
-- @param editbox [EditBox] The editbox to enable the suggestion list on.
-- @param inputType [string] The name of the suggestion list module to use.
-- @param onlyOneEntry [boolean|nil] True to have the suggestion list hide after inserting an entry.
-- @param inline [boolean|nil] True to cause the suggestion list to display underneath the editbox. Otherwise, will be attached to the IconEditor.
-- @param parent [Frame|nil] A frame to reparent the suggestion list to when active. Defaults to TellMeWhen_IconEditor
function SUG:EnableEditBox(editbox, inputType, onlyOneEntry, inline, parent)
	editbox.SUG_Enabled = 1

	inputType = TMW.get(inputType)
	inputType = (inputType == true and "spell") or inputType
	if not inputType then
		return SUG:DisableEditBox(editbox)
	end
	editbox.SUG_type = inputType
	editbox.SUG_inline = inline
	editbox.SUG_onlyOneEntry = onlyOneEntry
	editbox.SUG_parent = parent

	if not editbox.SUG_hooked then
		for k, v in pairs(EditBoxHooks) do
			editbox:HookScript(k, v)
		end

		function editbox:HasStickyFocus()
			if SUG.Box == self and IsMouseButtonDown("LeftButton") then
				return true
			end
		end

		editbox.SUG_hooked = 1
	end

	if editbox:HasFocus() then
		EditBoxHooks.OnEditFocusGained(editbox) -- force this to rerun becase we may be calling from within the editbox's script
	end
end

--- Disable the suggestion list on an editbox.
function SUG:DisableEditBox(editbox)
	editbox.SUG_Enabled = nil

	if SUG.Box == editbox then
		SUG.SuggestionList:Hide()
	end
end


---------- Miscellaneous ----------
function SUG:ColorHelp(frame)
	TMW:TT_Anchor(frame)
	GameTooltip:AddLine(SUG.CurrentModule.headerText, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
	GameTooltip:AddLine(SUG.CurrentModule.helpText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
	
	if SUG.CurrentModule.showColorHelp then
		GameTooltip:AddLine(L["SUG_DISPELTYPES"], 1, .49, .04, 1)
		GameTooltip:AddLine(L["SUG_BUFFEQUIVS"], .2, .9, .2, 1)
		GameTooltip:AddLine(L["SUG_DEBUFFEQUIVS"], .77, .12, .23, 1)
		GameTooltip:AddLine(L["SUG_OTHEREQUIVS"], 1, .96, .41, 1)
		GameTooltip:AddLine(L["SUG_PLAYERSPELLS"], .41, .8, .94, 1)
		GameTooltip:AddLine(L["SUG_CLASSSPELLS"], .96, .55, .73, 1)
		GameTooltip:AddLine(L["SUG_PLAYERAURAS"], .79, .30, 1, 1)
		GameTooltip:AddLine(L["SUG_NPCAURAS"], .78, .61, .43, 1)
		GameTooltip:AddLine(L["SUG_MISC"], .58, .51, .79, 1)
	end

	GameTooltip:Show()
end

local INLINE_MAX_FRAMES = 10
function SUG:GetNumFramesNeeded()
	if self.inline then
		return INLINE_MAX_FRAMES
	end

	return floor((TMW.SUG.SuggestionList:GetHeight() + 5)/TMW.SUG[1]:GetHeight()) - (self.inline and 1 or 2)
end

function SUG:GetHeightForFrames(numFrames)
	return (numFrames * TMW.SUG[1]:GetHeight()) + 6
end

function SUG:SetInline(inline)
	local firstItem = TMW.SUG:GetFrame(1)
	self.inline = inline

	local List = SUG.SuggestionList

	if List.fixLevelTimer then
		List.fixLevelTimer:Cancel()
	end

	if inline then

		firstItem:SetPoint("TOP", 0, -3)
		List.Header:Hide()
		List.Help:Hide()

		List:SetScale(0.95)
		List:ClearAllPoints()
		List:SetPoint("TOPLEFT", SUG.Box, "BOTTOMLEFT", 0, -2)
		--List:SetPoint("TOPRIGHT", SUG.Box, "BOTTOMRIGHT", 0, -2)
		--List:SetParent(SUG.Box)
		List:SetHeight(SUG:GetHeightForFrames(INLINE_MAX_FRAMES))
		List.Background:SetColorTexture(0.02, 0.02, 0.02, 0.970)

		List.fixLevelTimer = C_Timer.NewTicker(0.01, function() 
			List:SetFrameLevel(SUG.Box:GetFrameLevel() + 5)
		end)
	else
		firstItem:SetPoint("TOP", 0, -6 - TMW.SUG[1]:GetHeight())

		List:SetScale(1)
		List:ClearAllPoints()
		List:SetPoint("TOPLEFT", TMW.IE, "TOPRIGHT", 1, 0)
		List:SetPoint("BOTTOMLEFT", TMW.IE, "BOTTOMRIGHT", 1, 0)
		--List:SetParent(TMW.IE)

		List.Header:Show()
		List.Help:Show()
		List.Background:SetColorTexture(0.05, 0.05, 0.05, 0.970)
	end
end

function SUG:GetFrame(id)
	local Suggest = TMW.SUG.SuggestionList
	local f = TMW.SUG[id]
	
	if not f then
		f = CreateFrame("Button", Suggest:GetName().."Item"..id, Suggest, "TellMeWhen_SpellSuggestTemplate", id)
		TMW.SUG[id] = f
		
		if TMW.SUG[id-1] then
			f:SetPoint("TOPRIGHT", TMW.SUG[id-1], "BOTTOMRIGHT", 0, 0)
			f:SetPoint("TOPLEFT", TMW.SUG[id-1], "BOTTOMLEFT", 0, 0)
		end
	end
	
	f:SetFrameLevel(f:GetParent():GetFrameLevel() + 5)
	
	return f
end


---------- Suggester Modules ----------
local Module = SUG:NewModule("default")
Module.headerText = L["SUGGESTIONS"]
Module.helpText = L["SUG_TOOLTIPTITLE"]
Module.showColorHelp = true
function Module:GetShouldSuggest()
	return true
end
function Module:GetStartEndPositions(isClick)
	local text = SUG.Box:GetText()
	
	SUG.startpos = 0
	for i = SUG.Box:GetCursorPosition(), 0, -1 do
		if strsub(text, i, i) == ";" then
			SUG.startpos = i+1
			break
		end
	end

	if isClick then
		SUG.endpos = #text
		for i = SUG.startpos, #text do
			if strsub(text, i, i) == ";" then
				SUG.endpos = i-1
				break
			end
		end
	else
		SUG.endpos = SUG.Box:GetCursorPosition()
	end
end
function Module:Table_Get()
	return SpellCache:GetCache()
end
function Module.Sorter_ByName(a, b)
	local nameA, nameB = SUG.SortTable[a], SUG.SortTable[b]
	if nameA == nameB then
		--sort identical names by ID
		return a < b
	else
		--sort by name
		return nameA < nameB
	end
end
function Module:Table_GetSorter()
	if SUG.inputType == "number" then
		return nil -- use the default sort func
	else
		SUG.SortTable = self:Table_Get()
		return self.Sorter_ByName
	end
end

local StartsWithCache = TMW:NewClass("StartsWithCache") {
	OnNewInstance = function(self, source)
		self.Source = source
		self.Lookups = setmetatable({}, { __mode = "kv" })
	end,

	GetLookup = function(self, fragment)
		if self.Lookups[fragment] then 
			return self.Lookups[fragment] 
		end

		local sourceData = self.Source
		local oneLetterShorter = fragment
		while #oneLetterShorter > 1 do
			oneLetterShorter = oneLetterShorter:sub(1, -2)
			if self.Lookups[oneLetterShorter] then
				sourceData = self.Lookups[oneLetterShorter]
				break
			end
		end

		local pattern = "^" .. fragment
		local newData = {}
		for id, name in pairs(sourceData) do
			if strfind(name, pattern) then
				newData[id] = name
			end
		end
		self.Lookups[fragment] = newData
		return newData
	end,
}

local InitialismCache = TMW:NewClass("InitialismCache") {
	OnNewInstance = function(self)
		self.Lookups = setmetatable({}, { __mode = "kv" })
	end,

	GetLookup = function(self, firstLetterLookup, initialism)
		if self.Lookups[initialism] then
			return self.Lookups[initialism]
		end

		local sourceData = firstLetterLookup
		local oneLetterShorter = initialism
		while #oneLetterShorter > 1 do
			oneLetterShorter = oneLetterShorter:sub(1, -2)
			if self.Lookups[oneLetterShorter] then
				sourceData = self.Lookups[oneLetterShorter]
				break
			end
		end

		-- To form the pattern, put ".- " after each letter except the last. Also, match string starts only.
		local pattern = "^" .. initialism
			-- Escape pattern special characters
			:gsub("([%(%)%%%[%]%-%+%.%*])", "%%%1")
			-- put ".- " after each letter
			:gsub("(.)", "%1.- ")
			-- except the last
			:trim("-. ")

		local newData = {}
		for id, name in pairs(sourceData) do
			if strfind(name, pattern) then
				newData[id] = name
			end
		end
		self.Lookups[initialism] = newData
		return newData
	end,
}

local startsWithCaches = setmetatable({}, {
	__index = function(self, k) 
		self[k] = StartsWithCache:New(k)
		return self[k]
	end,
})
local spellCacheInitialismCache = InitialismCache:New()

function Module:Table_GetNormalSuggestions(suggestions, tbl)
	local atBeginning = SUG.atBeginning
	local lastName = SUG.lastName

	if SUG.inputType == "number" then
		local match = tonumber(SUG.lastName)
		if match <= 0 then
			-- Can only match positive numbers.
			-- Zero will cause an infinite loop below (because of our log10(match) call)
			return
		end

		-- Optimizations galore!

		-- Checking each number against all the ranges of valid search results 
		-- is WAY faster then trying to do any kind of exact matching based on 
		-- the length of the input and the length of the candidate.

		-- We start with the 6 digit numbers because they'll have the most results for 1-digit inputs.
		-- Longer inputs will have less results total, so we're OK if they're slightly slower,
		-- becuse they'll take much less time to sort, so the difference comes out in the wash.

		-- We check the less than case first so that after any one less than check fails,
		-- we can short circuit out of the entire statement.

		-- Compiling this into a function allows for 10% performance 
		-- increase over referencing variables that have the limit numbers.

		-- This compiles into a function that looks like:
		--[[
			local tbl, match, suggestions = ...; 
	        local len = #suggestions
	        for id in pairs(tbl) do 
		        if 
		        	(id <200000 and (id >99999 or 
			        (id <20000 and (id >9999 or 
			        (id <2000 and (id >999 or 
			        (id <200 and (id >99 or 
			        (id <20 and (id >9 or 
			        id == match 
		        	)))))))))) 
	        	then 
		        	len = len + 1 
		        	suggestions[len] = id 
	        	end 
	        end
		]]

		-- The old way that we checked this was with the following:
		-- local len = #SUG.lastName - 1
		-- min(id, floor(id / 10^(floor(log10(id)) - len))) == match
		-- This was quite good - approx 3x faster than strfind.
		-- However, our massive if statement is approx 1.5x faster still,
		-- putting us at about 4.5x the speed of strfind.
		-- Then, compiling this function dynamically with the numbers we compare 
		-- against as constants gave us another 20% still.

		local f = [[
		local tbl, match, suggestions = ...; 
		local len = #suggestions
		for id in pairs(tbl) do if ]]

		-- If WoW ever get spellIDs in the millions, this will break.
		-- Just need to increment this number here to 6.
		-- At current rates, that will be sometime in the 2040s.
		local maxTrailingZeroes = 5

		local endParens = ""
		for i = maxTrailingZeroes - floor(log10(match)), 1, -1 do
			local lower = match*(10^i)-1
			local upper = (match+1)*(10^i)
			-- Using only > and < here is faster than >= or <=
			f = f .. "(id <" .. upper .. " and (id >" .. lower .. " or "
			endParens = endParens .. "))"
		end
		f = f .. " id == match " .. endParens .. " then len = len + 1 suggestions[len] = id end end"
		assert(loadstring(f))(tbl, match, suggestions)

	elseif tbl == SpellCache:GetCache() then
		-- We know that the spell cache is unchanging.
		-- So, we can safely build lookup tables around its contents.
		-- For other tables, we can't be so sure.
		-- However, there's basically nothing else that uses this function that 
		-- either isn't the spell cache, or is large enough for this to matter.
		local lookup = startsWithCaches[tbl]:GetLookup(SUG.lastName)
		local len = #suggestions

		-- Always do this. Just copy straight out of the lookup.
		for id, name in pairs(lookup) do
			len = len + 1
			suggestions[len] = id
		end

		if shouldLetterMatch or shouldWordMatch then
			-- Special Rules in place. Need to check every spell against our patterns.

			local initialism
			if shouldWordMatch then
				-- Convert "foo bar test" to "fbt" so we can get a reduced-size
				-- lookup of things that might also look like "foo* bar* test*"
				initialism = SUG.lastName:gsub("(%f[%a].).-%f[%A].?", "%1"):gsub(" ", "")
			elseif shouldLetterMatch then
				-- Input already is the initialism to look for (it doesn't contain spaces and is just a few characters.)
				initialism = SUG.lastName
			end

			-- For letter/word matching, check against the lookup for the first letter of the name.
			-- These matches always must match the first word in the spell name.
			local firstLetterLookup = startsWithCaches[tbl]:GetLookup(SUG.lastName:sub(1, 1))

			local initialismLookup = spellCacheInitialismCache:GetLookup(firstLetterLookup, initialism)

			for id, name in pairs(initialismLookup) do
				-- For any spell that seems like an initialism match that isn't in the
				-- starts with lookup (if it IS in there, we already added it),
				-- check to be sure that its a correct match, and throw it in if it is.
				if not lookup[id] and (
					 -- For letter matching, no need to strfind to verify here - 
					 -- we can be certain that for letter matching, anything in the lookup is valid.
					(shouldLetterMatch)
					-- For word matching, we need to validate. The initialism lookup gets us pretty far,
					-- but we need to make sure all characters after the first character of each word matches as well.
					or (shouldWordMatch and strfind(name, wordMatch))
				)
				then
					len = len + 1
					suggestions[len] = id
				end
			end
		end
	else
		local len = #suggestions
		for id, name in pairs(tbl) do
			if strfindsug(name) then
				len = len + 1
				suggestions[len] = id
			end
		end
	end
end
function Module:Table_GetEquivSuggestions(suggestions, tbl, ...)
	local lastName = SUG.lastName
	local semiLN = ";" .. lastName
	local long = #lastName > 2
	
	local len = #SUG.lastName - 1
	local match = tonumber(SUG.lastName)
	
	for _, tbl in TMW:Vararg(...) do
		for equiv in pairs(tbl) do
			if 
				(strfindsug(strlowerCache[equiv])) or
				(strfindsug(strlowerCache[L[equiv]]))
			then
				suggestions[#suggestions + 1] = equiv

			elseif long then
				if SUGIsNumberInput then
					for _, id in pairs(TMW:SplitNamesCached(TMW.EquivFullIDLookup[equiv])) do
						-- Check for a match by ID to one of the spells in the equiv
						if min(id, floor(id / 10^(floor(log10(id)) - len))) == match then
							suggestions[#suggestions + 1] = equiv
							break
						end
					end
				else
					for _, name in pairs(TMW:SplitNamesCached(TMW.EquivFullNameLookup[equiv])) do
						if strfindsug(strlowerCache[name]) then
							suggestions[#suggestions + 1] = equiv
							break
						end
					end
				end
			end
		end
	end
end
function Module:Table_GetSpecialSuggestions_1(suggestions)

end
function Module:Entry_OnClick(frame, button)
	local insert
	if button == "RightButton" and frame.insert2 then
		insert = frame.insert2
	else
		insert = frame.insert
	end
	self:Entry_Insert(insert)
end
function Module:Entry_Insert(insert)
	if insert then
		insert = tostring(insert)
		if SUG.Box.SUG_onlyOneEntry then
			SUG.Box:SetText(TMW:CleanString(insert))
			SUG.Box:ClearFocus()
			return
		end

		-- determine the text before an after where we will be inserting to
		local currenttext = SUG.Box:GetText()
		local start = SUG.startpos-1
		local firsthalf = start > 0 and strsub(currenttext, 0, start) or ""
		local lasthalf = strsub(currenttext, SUG.endpos+1)


		-- DURATION STUFF:
		-- determine if we should add a colon to the inserted text. a colon should be added if:
			-- one existed before (the user clicked on a spell with a duration defined or already typed it in)
			-- the module requests (requires) one
		local doAddColon = SUG.duration or SUG.CurrentModule.doAddColon

		-- determine if there is an actual duration to be added to the inserted spell
		local hasDurationData = SUG.duration

		if doAddColon then
		-- the entire text to be inserted in
			insert = insert .. ": " .. (hasDurationData or "")
		end


		-- the entire text with the insertion added in
		local newtext = firsthalf .. "; " .. insert .. "; " .. lasthalf
		-- clean it up
		SUG.Box:SetText(TMW:CleanString(newtext))

		-- put the cursor after the newly inserted text
		local _, newPos = SUG.Box:GetText():find(insert:gsub("([%(%)%%%[%]%-%+%.%*])", "%%%1"), max(0, SUG.startpos-1))
		if newPos then
			SUG.Box:SetCursorPosition(newPos + 2)
		end

		-- if we are at the end of the editbox then put a semicolon in anyway for convenience
		if SUG.Box:GetCursorPosition() == #SUG.Box:GetText() then
			local append = "; "
			if doAddColon then
				append = (not hasDurationData and " " or "") .. append
			end
			SUG.Box:SetText(SUG.Box:GetText() .. append)
		end

		-- if we added a colon but there was no duration information inserted, move the cursor back 2 characters so the user can type it in quickly
		if doAddColon and not hasDurationData then
			SUG.Box:SetCursorPosition(SUG.Box:GetCursorPosition() - 2)
		end

		-- attempt another suggestion (it will either be hidden or it will do another)
		SUG:NameOnCursor(1)
	end
end
function Module:Entry_IsValid(id)
	return true
end



local Module = SUG:NewModule("item", SUG:GetModule("default"), "AceEvent-3.0")
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]
function Module:GET_ITEM_INFO_RECEIVED()
	if SUG.CurrentModule and SUG.CurrentModule.moduleName:find("item") then
		SUG:CancelTimer(SUG.itemDoSuggestTimer, 1)
		SUG.itemDoSuggestTimer = SUG:ScheduleTimer("DoSuggest", 0.1)
	end
end
Module:RegisterEvent("GET_ITEM_INFO_RECEIVED")
function Module:Table_Get()
	return TMW:GetModule("ItemCache"):GetCache()
end
function Module:Table_GetSpecialSuggestions_1(suggestions)
	local id = tonumber(SUG.lastName)

	if id and GetItemInfo(id) and not TMW.tContains(suggestions, id) then
		suggestions[#suggestions + 1] = id
	end
end
function Module:Entry_AddToList_1(f, id)
	if id > INVSLOT_LAST_EQUIPPED then
		local name, link = GetItemInfo(id)

		f.Name:SetText(link and link:gsub("[%[%]]", ""))
		f.ID:SetText(id)

		f.insert = SUG.inputType == "number" and id or name
		f.insert2 = SUG.inputType ~= "number" and id or name

		f.tooltipmethod = "SetHyperlink"
		f.tooltiparg = link

		f.Icon:SetTexture(GetItemIcon(id))
	end
end


local Module = SUG:NewModule("spell", SUG:GetModule("default"))
local PlayerSpells, AuraCache_Cache, SpellCache_Cache, EquivFirstIDLookup
function Module:OnSuggest()
	AuraCache_Cache = AuraCache:GetCache()
	SpellCache_Cache = SpellCache:GetCache()
	PlayerSpells = ClassSpellCache:GetPlayerSpells()
	EquivFirstIDLookup = TMW.EquivFirstIDLookup
end
function Module:Table_Get()
	return SpellCache_Cache
end

local function spellSort(a, b)
	local nameA, nameB = SpellCache_Cache[a], SpellCache_Cache[b]

	if nameA == nameB then
		-- Sort identical names by ID.

		-- This also handles equivalency names (which won't be in the spell cache)
		-- without an extra table lookup.
		-- Since these are a relatively unlikely case, this is optimal.
		-- Because of the way bucket sort works, if "a" is an equiv, then "b" is also an equiv.
		return a < b
	else
		-- Sort by name
		return nameA < nameB
	end
end
function Module:Sorter_Bucket(suggestions, buckets)
	for i = 1, #suggestions do
		local id = suggestions[i]

		if id == "GCD" then
			-- Used by the spell suggestions for the spell CD condition.
			-- We put it here so that we can still use bucket sort.
			tinsert(buckets[0.5], id)
		elseif EquivFirstIDLookup[id] then
			tinsert(buckets[1], id)
		elseif PlayerSpells[id] then
			tinsert(buckets[2], id)
		elseif ClassSpellLookup[id] then
			tinsert(buckets[3], id)
		else
			local auraSoruce = AuraCache_Cache[id]
			if auraSoruce == 2 then
				tinsert(buckets[4], id)
			elseif auraSoruce == 1 then
				tinsert(buckets[5], id)
			else
				if SUGIsNumberInput then
					tinsert(buckets[6 + floor(id/1000)], id)
				else
					local name = SpellCache_Cache[id]
					-- Bucket by the first two chars. Most of the time,
					-- almost all the results will start with the same char.
					local offset = name and ((strbyte(name) or 0) * 2^8 + (strbyte(name:sub(2)) or 0)) or 0
					local bucket = buckets[6 + offset]
					--bucket.__sorter = spellSort
					tinsert(bucket, id)
				end
			end
		end
	end
end

function Module.Sorter_Spells(a, b)
	local nameA, nameB = SpellCache_Cache[a], SpellCache_Cache[b]

	if nameA == nameB or not nameA or not nameB then
		-- Sort identical names by ID.

		-- This also handles equivalency names (which won't be in the spell cache)
		-- without an extra table lookup.
		-- Since these are a relatively unlikely case, this is optimal.
		-- Because of the way bucket sort works, if "a" is an equiv, then "b" is also an equiv.
		return a < b
	else
		-- Sort by name
		return nameA < nameB
	end
end
function Module:Table_GetSorter()
	if SUGIsNumberInput then
		-- Use the default sort function in Lua if input is numeric.
		-- Our sort buckets will take care of sorting the different categories correctly.
		return nil, self.Sorter_Bucket
	else
		return self.Sorter_Spells, self.Sorter_Bucket
	end
end
function Module:Entry_AddToList_1(f, id)
	if tonumber(id) then --sanity check
		local name = GetSpellInfo(id)

		f.Name:SetText(name)
		f.ID:SetText(id)

		f.tooltipmethod = "TMW_SetSpellByIDWithClassIcon"
		f.tooltiparg = id

		if TMW.EquivFirstIDLookup[name] then
			-- Things that conflict with equivalencies should only be inserted as IDs
			f.insert = id
			f.insert2 = name
			f.overrideInsertName = TMW.L["SUG_INSERTNAME_INTERFERE"]
		else
			f.insert = SUG.inputType == "number" and id or name
			f.insert2 = SUG.inputType ~= "number" and id or name
		end

		f.Icon:SetTexture(GetSpellTexture(id))
	end
end
function Module:Entry_Colorize_1(f, id)
	if PlayerSpells[id] then
		f.Background:SetVertexColor(.41, .8, .94, 1) --color all other spells that you have in your/your pet's spellbook mage blue
		return
	elseif ClassSpellLookup[id] then
		f.Background:SetVertexColor(.96, .55, .73, 1) --color all other known class spells paladin pink
		return
	end

	local whoCasted = AuraCache_Cache[id]
	if whoCasted == AuraCache.CONST.AURA_TYPE_NONPLAYER then
		 -- Color known NPC auras warrior brown.
		f.Background:SetVertexColor(.78, .61, .43, 1)
	elseif whoCasted == AuraCache.CONST.AURA_TYPE_PLAYER then
		-- Color known PLAYER auras a bright pink-ish/pruple-ish color that is similar to paladin pink,
		-- but has sufficient contrast for distinguishing.
		f.Background:SetVertexColor(.79, .30, 1, 1)
	end
end


local Module = SUG:NewModule("texture", SUG:GetModule("spell"))
function Module:Entry_AddToList_1(f, id)
	if tonumber(id) then --sanity check
		local name = GetSpellInfo(id)

		f.Name:SetText(name)
		f.ID:SetText(id)

		f.tooltipmethod = "TMW_SetSpellByIDWithClassIcon"
		f.tooltiparg = id

		f.insert = id
		if ClassSpellCache:GetCache()[pclass][id] and name and GetSpellTexture(name) then
			f.insert2 = name
		end

		f.Icon:SetTexture(GetSpellTexture(id))
	end
end



local Module = SUG:NewModule("spellwithduration", SUG:GetModule("spell"))
Module.doAddColon = true
local MATCH_RECAST_TIME_MIN, MATCH_RECAST_TIME_SEC
function Module:OnInitialize()
	MATCH_RECAST_TIME_MIN = SPELL_RECAST_TIME_MIN:gsub("%%%.%dg", "([%%d%%.]+)")
	MATCH_RECAST_TIME_SEC = SPELL_RECAST_TIME_SEC:gsub("%%%.%dg", "([%%d%%.]+)")
end
function Module:Entry_OnClick(f, button)
	local insert

	local spellID = f.tooltiparg
	local Parser, LT1, LT2, LT3, RT1, RT2, RT3 = TMW:GetParser()
	Parser:SetOwner(UIParent, "ANCHOR_NONE")
	Parser:SetSpellByID(spellID)

	local dur

	for _, text in TMW:Vararg(RT2:GetText(), RT3:GetText()) do
		if text then

			local mins = text:match(MATCH_RECAST_TIME_MIN)
			local secs = text:match(MATCH_RECAST_TIME_SEC)
			if mins then
				dur = mins .. ":00"
			elseif secs then
				dur = secs
			end

			if dur then
				break
			end
		end
	end
	if spellID == 42292 then -- pvp trinket override
		dur = "2:00"
	end

	if button == "RightButton" and f.insert2 then
		insert = f.insert2
	else
		insert = f.insert
	end

	self:Entry_Insert(insert, dur)
end
function Module:Entry_Insert(insert, duration)
	if insert then
		insert = tostring(insert)
		if SUG.Box.SUG_onlyOneEntry then
			SUG.Box:SetText(TMW:CleanString(insert))
			SUG.Box:ClearFocus()
			return
		end

		-- determine the text before an after where we will be inserting to
		local currenttext = SUG.Box:GetText()
		local start = SUG.startpos-1
		local firsthalf = start > 0 and strsub(currenttext, 0, start) or ""
		local lasthalf = strsub(currenttext, SUG.endpos+1)

		-- determine if we should add a colon to the inserted text. a colon should be added if:
			-- one existed before (the user clicked on a spell with a duration defined or already typed it in)
			-- the module requests (requires) one
		local doAddColon = SUG.duration or SUG.CurrentModule.doAddColon

		-- determine if there is an actual duration to be added to the inserted spell
		local hasDurationData = duration or SUG.duration

		-- the entire text to be inserted in
		local insert = (doAddColon and insert .. ": " .. (hasDurationData or "")) or insert

		-- the entire text with the insertion added in
		local newtext = firsthalf .. "; " .. insert .. "; " .. lasthalf


		SUG.Box:SetText(TMW:CleanString(newtext))

		-- put the cursor after the newly inserted text
		local _, newPos = SUG.Box:GetText():find(insert:gsub("([%(%)%%%[%]%-%+%.%*])", "%%%1"), max(0, SUG.startpos-1))
		newPos = newPos or #SUG.Box:GetText()
		SUG.Box:SetCursorPosition(newPos + 2)

		-- if we are at the end of the editbox then put a semicolon in anyway for convenience
		if SUG.Box:GetCursorPosition() == #SUG.Box:GetText() then
			SUG.Box:SetText(SUG.Box:GetText() .. (doAddColon and not hasDurationData and " " or "") .. "; ")
		end

		-- if we added a colon but there was no duration information inserted, move the cursor back 2 characters so the user can type it in quickly
		if doAddColon and not hasDurationData then
			SUG.Box:SetCursorPosition(SUG.Box:GetCursorPosition() - 2)
		end

		-- attempt another suggestion (it will either be hidden or it will do another)
		SUG:NameOnCursor(1)
	end
end


local Module = SUG:NewModule("cast", SUG:GetModule("spell"))
function Module:Table_Get()
	return SpellCache:GetCache(), TMW.BE.casts
end
function Module:Entry_AddToList_2(f, id)
	if TMW.BE.casts[id] then
		-- the entry is an equivalacy
		-- id is the equivalency name (e.g. Stunned)
		local equiv = id
		id = TMW.EquivFirstIDLookup[equiv]

		f.Name:SetText(equiv)
		f.ID:SetText(nil)

		f.insert = equiv
		f.overrideInsertName = L["SUG_INSERTEQUIV"]

		f.tooltipmethod = "TMW_SetEquiv"
		f.tooltiparg = equiv

		f.Icon:SetTexture(GetSpellTexture(id))
	end
end
function Module:Entry_Colorize_2(f, id)
	if TMW.BE.casts[id] then
		f.Background:SetVertexColor(1, .96, .41, 1) -- rogue yellow
	end
end
function Module:Entry_IsValid(id)
	if TMW.BE.casts[id] then
		return true
	end

	local _, _, _, castTime = GetSpellInfo(id)
	if not castTime then
		return false
	elseif castTime > 0 then
		return true
	end

	local Parser, LT1, LT2, LT3 = TMW:GetParser()

	Parser:SetOwner(UIParent, "ANCHOR_NONE") -- must set the owner before text can be obtained.
	Parser:SetSpellByID(id)

	if LT2:GetText() == SPELL_CAST_CHANNELED or LT3:GetText() == SPELL_CAST_CHANNELED then
		return true
	end
end


local Module = SUG:NewModule("buff", SUG:GetModule("spell"))
function Module:Table_Get()
	return SpellCache:GetCache(), TMW.BE.buffs, TMW.BE.debuffs
end
function Module:Entry_Colorize_2(f, id)
	if TMW.DS[id] then
		f.Background:SetVertexColor(1, .49, .04, 1) -- druid orange
	elseif TMW.BE.buffs[id] then
		f.Background:SetVertexColor(.2, .9, .2, 1) -- lightish green
	elseif TMW.BE.debuffs[id] then
		f.Background:SetVertexColor(.77, .12, .23, 1) -- deathknight red
	end
end
function Module:Entry_AddToList_2(f, id)
	if TMW.DS[id] then -- if the entry is a dispel type (magic, poison, etc)
		local dispeltype = id

		f.Name:SetText(dispeltype)
		f.ID:SetText(nil)

		f.insert = dispeltype

		f.tooltiptitle = L[dispeltype]
		f.tooltiptext = L["ICONMENU_DISPEL"]

		f.Icon:SetTexture(TMW.DS[id])

	elseif TMW.EquivFirstIDLookup[id] then -- if the entry is an equivalacy (buff, cast, or whatever)
		--NOTE: dispel types are put in TMW.EquivFirstIDLookup too for efficiency in the sorter func, but as long as dispel types are checked first, it wont matter
		local equiv = id
		local firstid = TMW.EquivFirstIDLookup[id]

		f.Name:SetText(equiv)
		f.ID:SetText(nil)

		f.insert = equiv
		f.overrideInsertName = L["SUG_INSERTEQUIV"]

		f.tooltipmethod = "TMW_SetEquiv"
		f.tooltiparg = equiv

		f.Icon:SetTexture(GetSpellTexture(firstid))
	end
end
function Module:Table_GetSpecialSuggestions_1(suggestions)
	local atBeginning = SUG.atBeginning

	for dispeltype in pairs(TMW.DS) do
		if strfind(strlowerCache[dispeltype], atBeginning) or strfind(strlowerCache[L[dispeltype]], atBeginning)  then
			suggestions[#suggestions + 1] = dispeltype
		end
	end
end

local Module = SUG:NewModule("buffNoDS", SUG:GetModule("buff"))
Module.Table_GetSpecialSuggestions_1 = TMW.NULLFUNC

