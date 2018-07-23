-- Utils.lua: common lua used across multiple modules

local _,L = ...
local rematch = Rematch

-- takes an petid and returns what type of id it is ("pet" "species" "leveling" or "table")
-- pet: this is an owned petID (BattlePet-0-000etc)
-- species: this is a speciesID (42 268 etc)
-- leveling: this is a leveling pet (0)
-- table: this is a table of stats (for pet links and enemy battle unit pets)
function rematch:GetIDType(id)
	if type(id)=="string" then
		if id:match("^BattlePet%-%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
			return "pet"
		elseif id:match("battlepet:%d+:%d+:%d+:%d+:%d+:%d+:.+") then
			return "link"
		elseif id:match("battle:%d:%d") then
			return "battle"
		end
	elseif id==0 then
		return "leveling"
	elseif type(id)=="number" then
		return "species"
--	elseif type(id)=="table" then
--		return "table"
	end
end


-- returns the name of the team for display purposes
-- if color is true, prefixes white color code if it's a team with an npcID
function rematch:GetTeamTitle(key,color)
	local forNpc = type(key)=="number"
	local saved = RematchSaved
	if saved[key] and forNpc then
		local teamName = saved[key].teamName or format("NPC:%s",tostring(key))
		if color then
			return format("\124cffffffff%s\124r",teamName)
		else
			return teamName
		end
	else
		return key
	end
end

-- returns name of the given unit and npcID if it's an npc, or nil if unit doesn't exist
function rematch:GetUnitNameandID(unit)
	if UnitExists(unit) then
		local name = UnitName(unit)
		local npcID = tonumber((UnitGUID(unit) or ""):match(".-%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
		if npcID and npcID~=0 then
			if rematch.notableRedirects[npcID] and not RematchSaved[npcID] then -- if this is a challenge post pet then return npcID of its post
				npcID = rematch.notableRedirects[npcID]
				return (rematch:GetNameFromNpcID(npcID)),npcID
			else
				return name,npcID -- this is an npc, return its name and npcID
			end
		else
			return name -- this is a player, return its name
		end
	end
end

local utilsInfo -- GetPetIcon is used in so many places, using a unique petInfo for it
function rematch:GetPetIcon(petID)
   if not utilsInfo then
      utilsInfo = rematch:CreatePetInfo()
   end
   utilsInfo:Fetch(petID)
   return utilsInfo.icon or "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
end

function rematch:GetPetName(petID)
	local idType = rematch:GetIDType(petID)
	if idType=="pet" then
		local _,customName,_,_,_,_,_,name = C_PetJournal.GetPetInfoByPetID(petID)
		return customName or name
	elseif idType=="species" then
		return (C_PetJournal.GetPetInfoBySpeciesID(petID))
	elseif idType=="leveling" then
		return L["Leveling Pet"]
	else
		return UNKNOWN
	end
end

function rematch:GetPetSpeciesID(petID)
	local idType = rematch:GetIDType(petID)
	local speciesID
	if idType=="pet" then
		return (C_PetJournal.GetPetInfoByPetID(petID))
	elseif idType=="species" then
		return petID
	end
end

-- DesensitizedText doesn't work for Russian or German clients; use the less efficient string:lower() compare
local locale = GetLocale()
local useAltSensitivity = locale=="ruRU" or locale=="deDE"

-- DesensitizeText returns text in a literal (magic characters escaped) and case-insensitive format
local function literal(c) return "%"..c end
local function caseinsensitive(c) return format("[%s%s]",c:lower(),c:upper()) end
function rematch:DesensitizeText(text)
	if type(text)=="string" then
		if useAltSensitivity then -- for ruRU/deDE clients use the lower case text
			return text:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]",literal):lower()
		else
			return text:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]",literal):gsub("%a",caseinsensitive)
		end
	end
end

-- when doing a case-insensitive match, use this instead of a direct match; so it can handle ruRU/deDE matches
function rematch:match(candidate,pattern)
	if candidate and pattern then
		if type(candidate)~="string" then
			candidate=tostring(candidate)
		end
		if useAltSensitivity then -- match the lower case candidate to the pattern (which is also lower case)
			return candidate:lower():match(pattern)
		else
			return candidate:match(pattern)
		end
	end
end

-- use this instead of SetPetLoadOutInfo directly in case first slot changes (to resummon pet back)
function rematch:SlotPet(slot,petID)
	-- if KeepSummoned enabled, we want to resummon summoned pet after swap finishes
	if RematchSettings.KeepSummoned and not IsFlying() then
		-- if KeepCompanion timer already running, we've already begun a pet swap, restart timer
		if rematch:IsTimerRunning("KeepCompanion") then
			rematch:StartTimer("KeepCompanion",0.5,rematch.CheckKeepCompanion)
		else -- if timer wasn't running, we're initiating a swap now
			rematch.preLoadCompanion = C_PetJournal.GetSummonedPetGUID()
			rematch:StartTimer("KeepCompanion",0.5,rematch.CheckKeepCompanion)
			-- it's possible that slotting a slot other than 1 will auto summon a pet (loading pet from slot 1 to 3
		end
	end
	C_PetJournal.SetPetLoadOutInfo(slot,petID)
end

function rematch:CheckKeepCompanion()
	local GCDPetID = rematch:FindGCDPetID()
	if (GCDPetID and C_PetJournal.GetPetCooldownByGUID(GCDPetID)~=0) or InCombatLockdown() then
		rematch:StartTimer("KeepCompanion",0.5,rematch.CheckKeepCompanion)
	else
		local summonedPetID = C_PetJournal.GetSummonedPetGUID()
		if rematch.preLoadCompanion ~= summonedPetID then
			if not rematch.preLoadCompanion then
				C_PetJournal.SummonPetByGUID(summonedPetID)
			else
				C_PetJournal.SummonPetByGUID(rematch.preLoadCompanion)
			end
			rematch:StartTimer("KeepCompanion",0.5,rematch.CheckKeepCompanion)
		end
	end
end

-- hides all the pop-up and flyout widgets when doing any major event
-- can pass name of function "HideMenu" or "HideFlyout" to hide everything but that
-- if a menu item just clicked, it's automatically excluded from hiding (menu will take care of hiding itself)
-- if completely is true, everything is hidden with no exceptions
local hideWidgetFuncs = {"HideMenu","HideFlyout","HidePetCard","HideTooltip","HideWinRecord"}
function rematch:HideWidgets(except,completely)
	for _,funcName in pairs(hideWidgetFuncs) do
		if rematch[funcName] and (completely or (funcName~=except and (funcName~="HideMenu" or not rematch:UIJustChanged()))) then
--		if funcName~=except and rematch[funcName] and (funcName~="HideMenu" or not rematch:UIJustChanged()) then
			rematch[funcName]()
		end
	end
end

-- returns the pet on the cursor if there is one
function rematch:GetCursorPet()
	local hasPet,petID = GetCursorInfo()
	if hasPet=="battlepet" then
		return petID
	end
end

-- anchors frame to relativeTo depending on the quarter of the screen the reference frame
-- exists (will go up parents of relativeTo to find reference parent)
-- if no relativeTo given, it will choose RematchFrame or RematchJournal
-- if center is true it will anchor to reference frame's center
-- yfromtop is the y offset when frame is anchoring to top (hidden title area of pet card)
-- yfrombottom is the y offset when frame is anchoring to the bottom (hidden controls of winrecord)
local references = { ["RematchFrame"]=true, ["UIParent"]=true }
function rematch:SmartAnchor(frame,relativeTo,center,yfromtop,yfrombottom)
	if not relativeTo then
		relativeTo = RematchFrame -- will check if journal visible and change to it
	end

	local reference = relativeTo
	while not references[reference:GetName() or ""] do
		local parent = reference:GetParent()
		if not parent or parent==UIParent then
			break -- stop when we've run out of parents or reached UIParent
		else
			reference = parent
		end
	end
	if not reference then return end -- failed catastrophically

	-- the pet card and 
	-- pet card has a (usually) invisible titlebar; yspecial will nudge yoffset up 22 if anchoring to top
--	local yfromtop = (frame==RematchPetCard or frame==RematchWinRecordCard) and 22 or 0
--	local yfrombottom = frame==RematchWinRecordCard and -22 or 0

	frame:ClearAllPoints()
	if center then -- simply center it to reference
		frame:SetPoint("CENTER",reference,"CENTER")
	else
		local corner = rematch:GetCorner(reference,UIParent)
		if corner=="BOTTOMLEFT" or reference==CollectionsJournal then
			frame:SetPoint("BOTTOMLEFT",relativeTo,"TOPRIGHT",0,yfrombottom or 0)
		elseif corner=="TOPLEFT" then
			frame:SetPoint("TOPLEFT",relativeTo,"BOTTOMRIGHT",0,yfromtop or 0)
		elseif corner=="TOPRIGHT" then
			frame:SetPoint("TOPRIGHT",relativeTo.Pet or relativeTo,"BOTTOMLEFT",0,yfromtop or 0)
		else 
			frame:SetPoint("BOTTOMRIGHT",relativeTo.Pet or relativeTo,"TOPLEFT",0,yfrombottom or 0)
		end
	end
end

-- To prevent tooltips and pet cards appearing when menus/pet cards/etc hide over an element,
-- any major event will mark the time it happened with timeUIChanged. Then this function
-- can be called to know whether an OnEnter should be run.
function rematch:UIJustChanged()
	return GetTime()==rematch.timeUIChanged
end

-- returns the corner of reference that frame is closest to
-- (if frame is closest to TOPRIGHT corner of reference, returns "TOPRIGHT")
-- used in SmartAnchor and anchoring RematchFrame to UIParent
-- if coords is true, the x,y offset from UIParent's BOTTOMLEFT is returned
function rematch:GetCorner(frame,reference,coords)
	local fx,fy = frame:GetCenter()
	local rx,ry = reference:GetCenter()
	local left, right, top, bottom
	if coords then
		left = frame:GetLeft()
		right = frame:GetRight()
		top = frame:GetTop()
		bottom = frame:GetBottom()
	end
	if not coords then
		ry=ry*1.2 -- raise y threshold up 20% of reference if not returning coords (to favor anchoring upwards)
	end
	if fx<rx and fy<ry then -- bottomleft
		return "BOTTOMLEFT",left,bottom
	elseif fx<rx and fy>ry then -- topleft
		return "TOPLEFT",left,top
	elseif fx>rx and fy>ry then -- topright
		return "TOPRIGHT",right,top
	else -- bottomright (or dead center)
		return "BOTTOMRIGHT",right,bottom
	end
end

-- adds a leveling border to a button (only 3 main loadouts and queue leveling slot uses this)
function rematch:AddSpecialBorder(button)
	button.SpecialBorder = button:CreateTexture(nil,"BACKGROUND")
	local cx,cy = button:GetSize()
	button.SpecialBorder:SetSize(cx+10,cy+10)
	button.SpecialBorder:SetPoint("CENTER")
	button.SpecialBorder:SetTexture("Interface\\PetBattles\\PetBattle-GoldSpeedFrame")
	button.SpecialBorder:SetTexCoord(0.1171875,0.7421875,0.1171875,0.734375)
   button.SpecialFootnote = CreateFrame("Button",nil,button,"RematchFootnoteButtonTemplate,RematchTooltipScripts")
   button.SpecialFootnote:SetPoint("TOPRIGHT",4,4)
   button.SpecialFootnote:SetScript("OnClick",rematch.SpecialFootnoteOnClick)
   button.SpecialFootnote:RegisterForClicks("AnyUp")
end

-- adds frameName to UISpecialFrames if value is true, removes it if value is false
function rematch:SetESCable(frameName,value)
	if value and not tContains(UISpecialFrames,frameName) then
		tinsert(UISpecialFrames,frameName)
	elseif not value then
		for i=#UISpecialFrames,1,-1 do
			if UISpecialFrames[i]==frameName then
				tremove(UISpecialFrames,i)
			end
		end
	end
end

function rematch:print(...)
	print(format("%s%s:\124r",rematch.hexGold,L["Rematch"]),...)
end

-- these two functions find the highest framelevel of a frame and its children
-- highestLevel = rematch:FindHighestFrameLevel(startingFrame)
-- RematchJournal is excluded
local function findHigherFrameLevel(...)
	local numFrames = select("#",...)
	for i=1,numFrames do
		local frame = select(i,...)
		if not RematchJournal or frame~=RematchJournal then
			local level = frame:GetFrameLevel()
			if frame:GetName() or frame:IsVisible() then -- if something badly wants to be higher framelevel (like PBT) let it
				rematch.highestFrameLevel = max(rematch.highestFrameLevel,level)
			end
			findHigherFrameLevel(frame:GetChildren())
		end
	end
end
-- PBT's TeamFrame.lua creates a teamMovementFrame with 10k framelevel lol
function rematch:FindHighestFrameLevel(frame)
	rematch.highestFrameLevel = 0
	findHigherFrameLevel(frame)
	return rematch.highestFrameLevel
end

--[[ List scrolling ]]

function rematch:ListScrollToTop(scrollFrame)
	scrollFrame.scrollBar:SetValue(0)
	PlaySound(1115)
end

function rematch:ListScrollToBottom(scrollFrame)
	scrollFrame.scrollBar:SetValue(scrollFrame.range)
	PlaySound(1115)
end

function rematch:ListScrollToIndex(scrollFrame,index)
	if index then
		if scrollFrame.scrollBar:IsEnabled() then
			local buttons = scrollFrame.buttons
			local height = math.max(0,floor(scrollFrame.buttonHeight*(index-((scrollFrame:GetHeight()/scrollFrame.buttonHeight))/2)))
			HybridScrollFrame_SetOffset(scrollFrame,height)
			scrollFrame.scrollBar:SetValue(height)
		else
			rematch:ListScrollToTop(scrollFrame)
		end
	end
end

-- does a flashing glow in a listbutton (after 0.05 seconds to let it update)
function rematch:ListBling(scrollFrame,var,value)
	rematch.blingScrollFrame = scrollFrame
	rematch.blingVar = var
	rematch.blingValue = value
	C_Timer.After(0.05,rematch.ListDoBling)
end

-- does the actual glow effect after 0.05 seconds
function rematch:ListDoBling()
	local scrollFrame = rematch.blingScrollFrame
	local foundButton
	if scrollFrame then
		for _,button in ipairs(scrollFrame.buttons) do
			if button[rematch.blingVar]==rematch.blingValue then
				foundButton = button
				local bling = RematchPetListBling
				bling:SetParent(button)
				bling:SetFrameLevel(button:GetFrameLevel()+5)
				bling:SetAllPoints(true)
				bling:Show()
				break
			end
		end
	end
	rematch.blingScrollFrame = nil
	rematch.blingVar = nil
	rematch.blingValue = nil
end

-- takes a petType (1-10) and returns a text string for the icon (20x20) with the thin circle border
function rematch:PetTypeAsText(petType,size)
	size = size or 16
	local suffix = PET_TYPE_SUFFIX[petType]
	return suffix and format("\124TInterface\\PetBattles\\PetIcon-%s:%d:%d:0:0:128:256:102:63:129:168\124t",suffix,size,size) or "?"
end

function rematch:SetTopToggleButton(button,up)
	button.up = up
	rematch.TopToggleButtonOnMouseUp(button)
	if up then
--		button.Icon:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
--		button.Icon:SetTexCoord(0,1,1,0)
--		button.Icon:SetTexCoord(1,0,0,0,1,1,0,1) -- 90 degrees (up)
	else
--		button.Icon:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
--		button.Icon:SetTexCoord(0,1,0,1)
--		button.Icon:SetTexCoord(0,1,1,1,0,0,1,0) -- -90 degrees (down)
	end
end

function rematch:TopToggleButtonOnMouseDown(button)
	if self:IsEnabled() then
		self.TopLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		self.TopRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		self.BottomLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		self.BottomRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		self.MiddleLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		self.MiddleRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Down")
		if self.up then
			self.Icon:SetPoint("CENTER",-1,0)
		else
			self.Icon:SetPoint("CENTER",-1,-2)
		end
	end
end

function rematch:TopToggleButtonOnMouseUp(button)
	self.TopLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	self.TopRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	self.BottomLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	self.BottomRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	self.MiddleLeft:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	self.MiddleRight:SetTexture("Interface\\Buttons\\UI-Silver-Button-Up")
	if self.up then
		self.Icon:SetPoint("CENTER",0,1)
		self.Icon:SetTexCoord(1,0,0,0,1,1,0,1) -- 90 degrees (up)
	else
		self.Icon:SetPoint("CENTER",0,-1)
		self.Icon:SetTexCoord(0,1,1,1,0,0,1,0) -- -90 degrees (down)
	end
end

-- adjusts the scale of a frame depending on settings.SmallerWindow and if
-- the regular frame is up; if force is true then adjusts regardless if frame
-- is visible or not.
function rematch:AdjustScale(frame,force)
	local settings = RematchSettings
	if settings.CustomScale and settings.CustomScaleValue and (rematch.Frame:IsVisible() or force) then
		frame:SetScale(settings.CustomScaleValue/100)
	else
		frame:SetScale(1)
	end
end

-- to be called when some action (prompt to load->with window; auto load->show etc)
-- wants to show the window. if neither standalone or journal are up, it shows
-- the PreferredMode (1=minimized, 2=maximized, 3=journal)
function rematch:AutoShow()
	local frame = rematch.Frame
	local journal = rematch.Journal
	local settings = RematchSettings
	local mode = settings.PreferredMode
	if not frame:IsVisible() and not journal:IsVisible() then
		if mode==1 then
			settings.Minimized = true
			rematch.Frame.Toggle()
		elseif mode==2 then
			settings.Minimized = nil
			rematch.Frame.Toggle()
		elseif mode==3 then
			settings.UseDefaultJournal = nil
			ToggleCollectionsJournal(2)
		end
	end
end

-- reparents (and positions if anchor given) a child to parent and shows it
function rematch:Reparent(child,parent,anchorPoint,...)
	child:SetParent(parent)
	if anchorPoint then
		child:ClearAllPoints()
		child:SetPoint(anchorPoint,...)
	end
	child:Show()
end


-- sets the passed texture to the petType using the prefix or the PetIcons if no prefix
-- prefixes used:
-- "Interface\\PetBattles\\PetIcon-" (Loadouts)
function rematch:FillPetTypeIcon(texture,petType,prefix)
	if not petType then
		texture:SetTexture(nil)
	elseif prefix then
		texture:SetTexture(prefix..PET_TYPE_SUFFIX[petType])
	else -- if no prefix then we're grabbing icon from Rematch\Textures\PetIcons
		local x = ((petType-1)%4)*0.25
		local y = floor((petType-1)/4)*0.25
		texture:SetTexCoord(x,x+0.25,y,y+0.171875)
	end		
end

-- returns true if any loaded pets are under 25
function rematch:IsLowLevelPetLoaded()
	for i=1,3 do
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		if petID then
			local level = select(3,C_PetJournal.GetPetInfoByPetID(petID))
			if level and level<25 then
				return true
			end
		end
	end
end

-- when an ability on the pet card is double clicked, search for the ability in the pet panel
function rematch:SearchAbility(abilityID)
	if abilityID then
		local _,name = C_PetBattles.GetAbilityInfoByID(abilityID)
		if name then
			rematch.Roster:ClearAllFilters()
			rematch:ShowPets()
			rematch.PetPanel.Top.SearchBox:SetFocus(true)
			rematch.PetPanel.Top.SearchBox:SetText("\""..name.."\"")
			rematch.PetPanel.Top.SearchBox:ClearFocus()
		end
	end
end

--[[ Temporary Tables

	Occasionally there's a need for a table of data that doesn't need to be kept,
	such as movesets during filters or speciesAt25 while filling queue, etc.

	To use:
	1) In the module's init, register name of table and function to populate its data:
				rematch:RegisterTempTable("nameoftable"[,func])
	2) Everytime you need to get the table:
				local data = rematch:GetTempTable("nameoftable")
	3) When done with all tables:
				rematch:WipeTempTables()
]]

rematch.tempTables = { Data={}, Populate={}, Active={} }

function rematch:RegisterTempTable(name,func)
	rematch.tempTables.Populate[name] = func
	rematch.tempTables.Data[name] = {}
end

function rematch:GetTempTable(name)
	local tempTable = rematch.tempTables
	local data = tempTable.Data[name]

	-- if table already active, just return data
	if tempTable.Active[name] then
		return data
	end

	-- if data is empty, then run its Populate function
	if not next(data) then
		local func = tempTable.Populate[name]
		if func then
			func(rematch,data)
		end
	end

	tempTable.Active[name] = true -- flag table as active
	return data -- and return data
end

function rematch:WipeTempTables()
	local tempTable = rematch.tempTables
	for _,data in pairs(tempTable.Data) do
		wipe(data)
	end
	wipe(tempTable.Active)
end

-- returns the abilityList,levelList of a speciesID from a reusable table
local rAbilityList,rAbilityLevels,rAbilitySpecies = {},{}
function rematch:GetAbilities(speciesID)
	if not speciesID then return {},{} end -- if no species given, return empty ability tables
	if speciesID and speciesID~=rAbilitySpecies then
		C_PetJournal.GetPetAbilityList(speciesID,rAbilityList,rAbilityLevels)
		rAbilitySpecies = speciesID
	end
	return rAbilityList,rAbilityLevels
end

-- returns cached pet stats
local rStatsHealth, rStatsMaxHealth, rStatsPower, rStatsSpeed, rStatsRarity, rStatsPetID
function rematch:GetPetStats(petID)
	local health, maxHealth, power, speed, rarity
	if petID ~= rStatsPetID then
		rStatsHealth, rStatsMaxHealth, rStatsPower, rStatsSpeed, rStatsRarity = C_PetJournal.GetPetStats(petID)
		rStatsPetID = petID
	end
	return rStatsHealth, rStatsMaxHealth, rStatsPower, rStatsSpeed, rStatsRarity
end

function rematch:DebugStack()
	local callers = {}
	local stack = debugstack()
	for caller in string.gmatch(stack,"Interface\\AddOns\\.-\\(.-%.lua:%d+)") do
		tinsert(callers,(caller:gsub(".-\\","")))
	end
	tremove(callers,1) -- remove the call to this function
	tremove(callers,1) -- and the print that called the call
	return "\124cffc0c0c0"..table.concat(callers,", ")
end

-- Summoning/dismissing all pets are on GCD, but not all petIDs think so!
-- For the toolbar cooldown display and Keep Companion option, we need to be aware
-- of the GCD. If a GCD petID isn't already discovered, it will go through the
-- first 8 owned pets to find one that's participating in the GCD.
function rematch:FindGCDPetID()
	if not rematch.GCDPetID then
		local limit = 1
		for petID in rematch.Roster:AllOwnedPets() do
			if limit<8 then
				local start,duration = C_PetJournal.GetPetCooldownByGUID(petID)
				if start and start~=0 then
					rematch.GCDPetID = petID
					return petID
				end
			else
				break -- only checking first 5 pets
			end
			limit = limit + 1
		end
	end
	return rematch.GCDPetID
end

-- searches for the name of the speciesID in the pet panel
function rematch:SearchForSpecies(speciesID)
	local roster = rematch.Roster
	roster:UpdateOwned()
	roster:ClearAllFilters()
	local searchBox = rematch.PetPanel.Top.SearchBox
	local speciesName = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	if speciesName then
		speciesName = format("\"%s\"",speciesName)
		searchBox:SetText(speciesName)
		roster:SetSearch(speciesName)
		searchBox:ClearFocus()
	end
end


function rematch:SetRoundTexture(texture,filepath)
	texture:SetMask("Textures\\MinimapMask")
	texture:SetTexture(filepath)
end

-- for PetTags and and TeamStrings to store base-32 numbers in strings
local digitsOut = {} -- to avoid garbage creation, this is reused to build a 32-base number
local digitsIn = "0123456789ABCDEFGHIJKLMNOPQRSTUV"
-- convert number to base 32: VV = 1023
function rematch:ToBase32(number)
	number = tonumber(number)
	if number then
		wipe(digitsOut)
		number = math.abs(floor(number))
		repeat
			local digit = (number%32) + 1
			number = floor(number/32)
			tinsert(digitsOut, 1, digitsIn:sub(digit,digit))
		until number==0
		return table.concat(digitsOut,"")
	end
end


-- in BfA, UnitBuff no longer accepts a spell name as an argument grr
local timeBuffsChecked = nil
local activeBuffs = {} -- indexed by name of buff, the index of the buff
function rematch:UnitBuff(buffName)

   -- if this isn't the same execution thread when buffs last checked, gather buffs
   local now = GetTime()
   if now~=timeBuffsChecked then
      timeBuffsChecked = now
      wipe(activeBuffs)
      local i = 1
      local buff
      repeat
         buff = UnitBuff("player",i)
         if buff then
            activeBuffs[buff] = i
         end
         i = i + 1
      until not buff
   end

   -- return UnitBuff of the named buff
   if activeBuffs[buffName] then
      return UnitBuff("player",activeBuffs[buffName])
   end
end