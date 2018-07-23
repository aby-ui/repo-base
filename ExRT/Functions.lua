local GlobalAddonName, ExRT = ...

ExRT.F.FUNC_FILE_LOADED = true

local UnitName, GetTime, GetCursorPosition, UnitIsUnit = UnitName, GetTime, GetCursorPosition, UnitIsUnit
local select, floor, tonumber, tostring, string_sub, string_find, string_len, bit_band, type, unpack, pairs, format, strsplit = select, floor, tonumber, tostring, string.sub, string.find, string.len, bit.band, type, unpack, pairs, format, strsplit
local string_gsub, string_match = string.gsub, string.match
local RAID_CLASS_COLORS, COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_SPECIAL_MASK = RAID_CLASS_COLORS, COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_SPECIAL_MASK

do
	local antiSpamArr = {}
	function ExRT.F.AntiSpam(numantispam,addtime)
		local t = GetTime()
		if not antiSpamArr[numantispam] or antiSpamArr[numantispam] < t then
			antiSpamArr[numantispam] = t + addtime
			return true
		else
			return false
		end
	end
	function ExRT.F.ResetAntiSpam(numantispam)
		antiSpamArr[numantispam] = nil
	end
end

do
	--Used GLOBALS: CUSTOM_CLASS_COLORS

	local classColorArray = nil
	function ExRT.F.classColor(class)
		classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		if classColorArray and classColorArray.colorStr then
			return classColorArray.colorStr
		else
			return "ffbbbbbb"
		end
	end

	function ExRT.F.classColorNum(class)
		classColorArray = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		if classColorArray then
			return classColorArray.r,classColorArray.g,classColorArray.b
		else
			return 0.8,0.8,0.8
		end
	end
	
	function ExRT.F.classColorByGUID(guid)
		local class,_ = ""
		if guid and guid ~= "" and guid ~= "0000000000000000" then
			_,class = GetPlayerInfoByGUID(guid)
		end
		return ExRT.F.classColor(class)
	end
end

function ExRT.F.clearTextTag(text,SpellLinksEnabled)
	if text then
		text = string_gsub(text,"|c........","")
		text = string_gsub(text,"|r","")
		text = string_gsub(text,"|T.-:0|t ","")
		text = string_gsub(text,"|HExRT:.-|h(.-)|h","%1")
		if SpellLinksEnabled then
			text = string_gsub(text,"|H(spell:.-)|h(.-)|h","|cff71d5ff|H%1|h[%2]|h|r")
		else
			text = string_gsub(text,"|H(spell:.-)|h(.-)|h","%2")
		end
		return text
	end
end

function ExRT.F.splitLongLine(text,maxLetters,SpellLinksEnabled)
	maxLetters = maxLetters or 250
	local result = {}
	repeat
		local lettersNow = maxLetters
		if SpellLinksEnabled then
			local lastC = 0
			local lastR = 0
			for i=1,(maxLetters-1) do
				local word = string.sub(text,i,i+1)
				if word == "|c" then
					lastC = i
				elseif word == "|r" then
					lastR = i
				end
			end
			if lastC > 0 and lastC > lastR then
				lettersNow = lastC - 1
			end
		end
		
		local utf8pos = 1
		local textLen = string.len(text)
		while true do
			local char = string.sub(text,utf8pos,utf8pos)
			local c = char:byte()
			
			local lastPos = utf8pos
			
			if c > 0 and c <= 127 then
				utf8pos = utf8pos + 1
			elseif c >= 194 and c <= 223 then
				utf8pos = utf8pos + 2
			elseif c >= 224 and c <= 239 then
				utf8pos = utf8pos + 3
			elseif c >= 240 and c <= 244 then
				utf8pos = utf8pos + 4
			else
				utf8pos = utf8pos + 1
			end
			
			if utf8pos > lettersNow then
				lettersNow = lastPos - 1
				break
			elseif utf8pos >= textLen then
				break
			end		
		end		
		result[#result + 1] = string.sub(text,1,lettersNow)
		text = string.sub(text,lettersNow+1)
	until string.len(text) < maxLetters
	if string.len(text) > 0 then
		result[#result + 1] = text
	end
	return unpack(result)
end

function ExRT.F:SetScaleFix(scale)
	local l = self:GetLeft()
	local t = self:GetTop()
	local s = self:GetScale()
	if not l or not t or not s then return end

	s = scale / s

	self:SetScale(scale)
	local f = self:GetScript("OnDragStop")

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",l / s,t / s)

	if f then f(self) end
end

function ExRT.F:SetScaleFixTR(scale)
	--local l = self:GetLeft() + self:GetWidth() * self:GetEffectiveScale()
	local l = self:GetRight()
	local t = self:GetTop()
	local s = self:GetScale()
	if not l or not t or not s then return end

	s = scale / s

	self:SetScale(scale)
	local f = self:GetScript("OnDragStop")

	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT",UIParent,"BOTTOMLEFT",l / s,t / s)

	if f then f(self) end
end

function ExRT.F:GetCursorPos()
	local x_f,y_f = GetCursorPosition()
	local s = self.GetEffectiveScale and self:GetEffectiveScale() or self:GetParent():GetEffectiveScale()
	x_f, y_f = x_f/s, y_f/s
	local x,y = self:GetLeft(),self:GetTop()
	x = x_f-x
	y = (y_f-y)*(-1)
	return x,y
end

do
	local function FindAllParents(self,obj)
		while obj do
			if obj == self then
				return true
			end
			obj = obj:GetParent()
		end
	end
	function ExRT.F:IsInFocus(x,y,childs)
		if not x then
			x,y = ExRT.F.GetCursorPos(self)
		end
		local obj = GetMouseFocus()
		if x > 0 and y > 0 and x < self:GetWidth() and y < self:GetHeight() and (obj == self or (childs and FindAllParents(self,obj))) then
			return true
		end
	end
end

function ExRT.F:LockMove(isLocked,touchTexture,dontTouchMouse)
	if isLocked then
		if touchTexture then touchTexture:SetColorTexture(0,0,0,0.3) end
		self:SetMovable(true)
		if not dontTouchMouse then self:EnableMouse(true) end
	else
		if touchTexture then touchTexture:SetColorTexture(0,0,0,0) end
		self:SetMovable(false)
		if not dontTouchMouse then self:EnableMouse(false) end
	end
end

function ExRT.F.GetRaidDiffMaxGroup()
	local _,instance_type,difficulty = GetInstanceInfo()
	if (instance_type == "party" or instance_type == "scenario") and not IsInRaid() then
		return 1
	elseif instance_type ~= "raid" then
		return 8
	elseif difficulty == 8 or difficulty == 1 or difficulty == 2 then
		return 1
	elseif difficulty == 14 or difficulty == 15 then
		return 6
	elseif difficulty == 16 then
		return 4
	elseif difficulty == 3 or difficulty == 5 then
		return 2
	elseif difficulty == 9 then
		return 8
	else
		return 5
	end	
end

function ExRT.F.GetDifficultyForCooldownReset()
	local _,_,difficulty = GetInstanceInfo()
	if difficulty == 3 or difficulty == 4 or difficulty == 5 or difficulty == 6 or difficulty == 7 or difficulty == 14 or difficulty == 15 or difficulty == 16 or difficulty == 17 then
		return true
	end
	return false
end

function ExRT.F.Round(i)
	return floor(i+0.5)
end

function ExRT.F.NumberInRange(i,mi,mx,incMi,incMx)
	if i and ((incMi and i >= mi) or (not incMi and i > mi)) and ((incMx and i <= mx) or (not incMx and i < mx)) then
		return true
	end
end

function ExRT.F.delUnitNameServer(unitName)
	unitName = strsplit("-",unitName)
	return unitName
end

function ExRT.F.UnitCombatlogname(unit)
	local name,server = UnitName(unit or "?")
	if name and server and server~="" then
		name = name .. "-" .. server
	end
	return name
end

do
	local old_types = {
		Player = 0,
		Creature = 3,
		Pet = 4,
		Vehicle = 5,
		GameObject = 6,		--NEW
		Vignette = 7,		--NEW
		Item = 8,		--NEW Item:976:0:4000000003A91C1A
		Uniq = 9,		--NEW
	}
	function ExRT.F.GetUnitTypeByGUID(guid)
		if guid then
			local _type = string_match(guid,"^([A-z]+)%-")
			if _type then
				return old_types[_type]
			end
		end
	end
end

function ExRT.F.UnitIsPlayerOrPet(guid)
	local id = ExRT.F.GetUnitTypeByGUID(guid)
	if id == 0 or id == 4 then
		return true
	end
end

function ExRT.F.GetUnitInfoByUnitFlag(unitFlag,infoType)
	--> TYPE
	if infoType == 1 then
		return bit_band(unitFlag,COMBATLOG_OBJECT_TYPE_MASK)
		--[1024]="player", [2048]="NPC", [4096]="pet", [8192]="GUARDIAN", [16384]="OBJECT"
		
	--> CONTROL
	elseif infoType == 2 then
		return bit_band(unitFlag,COMBATLOG_OBJECT_CONTROL_MASK)
		--[256]="by players", [512]="by NPC",
		
	--> REACTION
	elseif infoType == 3 then
		return bit_band(unitFlag,COMBATLOG_OBJECT_REACTION_MASK)
		--[16]="FRIENDLY", [32]="NEUTRAL", [64]="HOSTILE"
		
	--> Controller affiliation
	elseif infoType == 4 then
		return bit_band(unitFlag,COMBATLOG_OBJECT_AFFILIATION_MASK)
		--[1]="player", [2]="PARTY", [4]="RAID", [8]="OUTSIDER"
		
	--> Special
	elseif infoType == 5 then
		return bit_band(unitFlag,COMBATLOG_OBJECT_SPECIAL_MASK)
		--Not all !  [65536]="TARGET", [131072]="FOCUS", [262144]="MAINTANK", [524288]="MAINASSIST"
	end
end

function ExRT.F.UnitIsFriendlyByUnitFlag(unitFlag)
	if ExRT.F.GetUnitInfoByUnitFlag(unitFlag,2) == 256 then
		return true
	end
end

function ExRT.F.UnitIsFriendlyByUnitFlag2(unitFlag)
	local reaction = ExRT.F.GetUnitInfoByUnitFlag(unitFlag or 0,3)
	if reaction == 16 then
		return true
	elseif reaction == 32 then
		if ExRT.F.GetUnitInfoByUnitFlag(unitFlag,2) == 256 then
			return true
		end
	end
end

function ExRT.F.dprint(...)
	return nil
end
function ExRT.F.dtime(...)
	return nil
end
if ExRT.T == "D" or ExRT.T == "DU" then	--debug or debug ultra
	ExRT.F.dprint = function(...)
		print(...)
	end
	local debugprofilestop = debugprofilestop
	local lastTime = nil
	ExRT.F.dtime = function(arg,...)
		if arg and lastTime then
			arg[#arg+1] = {debugprofilestop() - lastTime,...}
		else
			lastTime = debugprofilestop()
		end
	end
end

function ExRT.F.LinkSpell(SpellID,SpellLink)
	if not SpellLink then
		SpellLink = GetSpellLink(SpellID)
	end
	if SpellLink then
		if ChatEdit_GetActiveWindow() then
			ChatEdit_InsertLink(SpellLink)
		else
			ChatFrame_OpenChat(SpellLink)
		end
	end
end

function ExRT.F.LinkItem(itemID, itemLink)
	if not itemLink then
		if not itemID then 
			return 
		end
		itemLink = select(2,GetItemInfo(itemID))
	end
	if not itemLink then
		return
	end
	if IsModifiedClick("DRESSUP") then
		return DressUpItemLink(itemLink)
	else
		if ChatEdit_GetActiveWindow() then
			ChatEdit_InsertLink(itemLink)
		else
			ChatFrame_OpenChat(itemLink)
		end
	end
end

function ExRT.F.shortNumber(num)
	if num < 1000 then
		return tostring(num)
	elseif num < 1000000 then
		return format("%.1fk",num/1000)
	elseif num < 1000000000 then
		return format("%.2fm",num/1000000)
	else
		return format("%.3fM",num/1000000000)
	end
end

function ExRT.F.classIconInText(class,size)
	if CLASS_ICON_TCOORDS[class] then
		size = size or 0
		return "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:"..size..":"..size..":0:0:256:256:".. floor(CLASS_ICON_TCOORDS[class][1]*256) ..":"..floor(CLASS_ICON_TCOORDS[class][2]*256) ..":"..floor(CLASS_ICON_TCOORDS[class][3]*256) ..":"..floor(CLASS_ICON_TCOORDS[class][4]*256) .."|t"
	end
end

function ExRT.F.GUIDtoID(guid)
	local type,_,serverID,instanceID,zoneUID,id,spawnID = strsplit("-", guid or "")
	return tonumber(id or 0)
end

function ExRT.F.table_copy(table1,table2)
	table.wipe(table2)
	for key,val in pairs(table1) do
		table2[key] = val
	end
end

function ExRT.F.table_copy2(table1)
	local table2 = {}
	for key,val in pairs(table1) do
		if type(val) == 'table' then
			table2[key] = ExRT.F.table_copy2(val)
		else
			table2[key] = val
		end
	end
	return table2
end

function ExRT.F.table_wipe(arr)
	if not arr or type(arr) ~= "table" then
		return
	end
	for key,val in pairs(arr) do
		if type(val) == "table" then
			ExRT.F.table_wipe(val)
		end
		arr[key] = nil
	end
end

function ExRT.F.table_find(arr,subj,pos)
	if pos then
		for j=1,#arr do
			if arr[j][pos] == subj then
				return j
			end
		end
	else
		for j=1,#arr do
			if arr[j] == subj then
				return j
			end
		end
	end
end

function ExRT.F.table_find2(arr,subj)
	for key,val in pairs(arr) do
		if val == subj then
			return key
		end
	end
end

function ExRT.F.table_find3(arr,subj,pos)
	for j=1,#arr do
		if arr[j][pos] == subj then
			return arr[j]
		end
	end
end

function ExRT.F.table_len(arr)
	local len = 0
	for _ in pairs(arr) do
		len = len + 1
	end
	return len
end

function ExRT.F.table_add(arr,add)
	for i=1,#add do
		arr[#arr+1] = add[i]
	end
end

function ExRT.F.table_add2(arr,add)
	for key,val in pairs(add) do
		arr[key] = val
	end
end

do
	local function swap(array, index1, index2)
		array[index1], array[index2] = array[index2], array[index1]
	end
	local math_random = math.random
	function ExRT.F.table_shuffle(array)
		local counter = #array
		while counter > 1 do
			local index = math_random(counter)
			swap(array, index, counter)
			counter = counter - 1
		end
	end
end

function ExRT.F.tohex(num,size)
	return format("%0"..(size or "1").."X",num)
end

function ExRT.F.UnitInGuild(unit)
	unit = ExRT.F.delUnitNameServer(unit)
	local gplayers = GetNumGuildMembers() or 0
	for i=1,gplayers do
		local name = GetGuildRosterInfo(i)
		if name and ExRT.F.delUnitNameServer(name) == unit then
			return true
		end
	end
	return false
end

function ExRT.F.chatType(toSay)
	local isInInstance = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	local isInParty = IsInGroup()
	local isInRaid = IsInRaid()
	local playerName = nil
	local chat_type = (isInInstance and "INSTANCE_CHAT") or (isInRaid and "RAID") or (isInParty and "PARTY")
	if not chat_type and not toSay then
		chat_type = "WHISPER"
		playerName = UnitName("player") 
	elseif not chat_type then
		chat_type = "SAY"
	end
	return chat_type, playerName
end

function ExRT.F.IsBonusOnItem(link,bonus)
	if link then 
		local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",link,15)
		if restLink then
			local bonuses = {strsplit(":",strsplit("|h",restLink),nil)}
			numBonusIDs = tonumber(numBonusIDs) or 0
			local isTable = type(bonus) == "table"
			for i = 1, numBonusIDs do
				local bonusID = tonumber(bonuses[i]) or -999
				if (isTable and bonus[bonusID]) or (not isTable and bonusID == bonus) then
					return true
				end
			end
		end
	end
end

function ExRT.F.GetItemBonuses(link)
	if link then 
		local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",link,15)
		numBonusIDs = tonumber(numBonusIDs or "?") or 0
		local bonusStr = ""
		for i=1,numBonusIDs do
			local bonus = select(i,strsplit(":",restLink))
			if bonus then
				bonusStr = bonusStr .. bonus .. ":"
			end
		end
		bonusStr = strtrim(bonusStr,":")
		return bonusStr,numBonusIDs
	end
	return "",0
end
--/dump GExRT.F.GetItemBonuses(select(2,GameTooltip:GetItem()))

function ExRT.F.IsPlayerRLorOfficer(unitName)
	local shortName = ExRT.F.delUnitNameServer(unitName)
	for i=1,GetNumGroupMembers() do
		--if name and (name == unitName or ExRT.F.delUnitNameServer(name) == shortName) then
		if UnitIsUnit(unitName,"raid"..i) or UnitIsUnit(shortName,"raid"..i) then
			local name,rank = GetRaidRosterInfo(i)
			if rank > 0 then
				return rank
			else
				return false
			end
		end
	end
	
	-- nil: not in party or raid
	-- false: no rl, no officer
	-- 1: officer
	-- 2: rl
end

function ExRT.F.GetPlayerParty(unitName)
	for i=1,GetNumGroupMembers() do
		local name,_,subgroup = GetRaidRosterInfo(i)
		if name == unitName then
			return subgroup
		end
	end
	return 9
end

function ExRT.F._unp(str)
	if not str or #str < 4 then
		return 0
	end
	local c = strbyte(str, 1) + strbyte(str, 2)
	local d = 0
	for i=3,#str do
		d = d + strbyte(str, 1)
	end
	return d * 1000 + c
end

function ExRT.F.CreateAddonMsg(...)
	local result = ""
	for i=1,select('#',...) do
		local a = select(i,...)
		result = result..(result ~= "" and "\t" or "")..tostring(a)
	end
	return result
end

function ExRT.F.GetPlayerRole()
	local role = UnitGroupRolesAssigned('player')
	if role == "HEALER" then
		local _,class = UnitClass('player')
		return role, (class == "PALADIN" or class == "MONK") and "MHEALER" or "RHEALER"
	elseif role ~= "DAMAGER" then
		--TANK, NONE
		return role
	else
		local _,class = UnitClass('player')
		local isMelee = (class == "WARRIOR" or class == "PALADIN" or class == "ROGUE" or class == "DEATHKNIGHT" or class == "MONK" or class == "DEMONHUNTER")
		if class == "DRUID" then
			isMelee = GetSpecialization() ~= 1
		elseif class == "SHAMAN" then
			isMelee = GetSpecialization() == 2
		elseif class == "HUNTER" then
			isMelee = GetSpecialization() == 3
		end
		if isMelee then
			return role, "MDD"
		else
			return role, "RDD"
		end
	end
end

function ExRT.F.GetUnitRole(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "HEALER" then
		local _,class = UnitClass(unit)
		return role, (class == "PALADIN" or class == "MONK") and "MHEALER" or "RHEALER"
	elseif role ~= "DAMAGER" then
		--TANK, NONE
		return role
	else
		local _,class = UnitClass(unit)
		local isMelee = (class == "WARRIOR" or class == "PALADIN" or class == "ROGUE" or class == "DEATHKNIGHT" or class == "MONK" or class == "DEMONHUNTER")
		if class == "DRUID" then
			isMelee = not (UnitPowerType(unit) == 8)	--astral power
		elseif class == "SHAMAN" then
			isMelee = UnitPowerMax(unit) >= 150
		elseif class == "HUNTER" then
			isMelee = (ExRT.A.Inspect and UnitName(unit) and ExRT.A.Inspect.db.inspectDB[UnitName(unit)] and ExRT.A.Inspect.db.inspectDB[UnitName(unit)].spec) == 255
		end
		if isMelee then
			return role, "MDD"
		else
			return role, "RDD"
		end
	end
end

do
	-- UTF8
	
	-- returns the number of bytes used by the UTF-8 character at byte i in s
	-- also doubles as a UTF-8 character validator
	local function utf8charbytes(s, i)
		-- argument defaults
		i = i or 1
	
		-- argument checking
		if type(s) ~= "string" then
			error("bad argument #1 to 'utf8charbytes' (string expected, got ".. type(s).. ")")
		end
		if type(i) ~= "number" then
			error("bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")")
		end
	
		local c = strbyte(s, i)
	
		-- determine bytes needed for character, based on RFC 3629
		-- validate byte 1
		if c > 0 and c <= 127 then
			-- UTF8-1
			return 1
	
		elseif c >= 194 and c <= 223 then
			-- UTF8-2
			local c2 = strbyte(s, i + 1)
	
			if not c2 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 2
	
		elseif c >= 224 and c <= 239 then
			-- UTF8-3
			local c2 = strbyte(s, i + 1)
			local c3 = strbyte(s, i + 2)
	
			if not c2 or not c3 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c == 224 and (c2 < 160 or c2 > 191) then
				error("Invalid UTF-8 character")
			elseif c == 237 and (c2 < 128 or c2 > 159) then
				error("Invalid UTF-8 character")
			elseif c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
	
			-- validate byte 3
			if c3 < 128 or c3 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 3
	
		elseif c >= 240 and c <= 244 then
			-- UTF8-4
			local c2 = strbyte(s, i + 1)
			local c3 = strbyte(s, i + 2)
			local c4 = strbyte(s, i + 3)
	
			if not c2 or not c3 or not c4 then
				error("UTF-8 string terminated early")
			end
	
			-- validate byte 2
			if c == 240 and (c2 < 144 or c2 > 191) then
				error("Invalid UTF-8 character")
			elseif c == 244 and (c2 < 128 or c2 > 143) then
				error("Invalid UTF-8 character")
			elseif c2 < 128 or c2 > 191 then
				error("Invalid UTF-8 character")
			end
	
			-- validate byte 3
			if c3 < 128 or c3 > 191 then
				error("Invalid UTF-8 character")
			end
	
			-- validate byte 4
			if c4 < 128 or c4 > 191 then
				error("Invalid UTF-8 character")
			end
	
			return 4
	
		else
			error("Invalid UTF-8 character")
		end
	end
	
	function ExRT.F:utf8len(s)
		local pos = 1
		local bytes = strlen(s)
		local len = 0
	
		while pos <= bytes do
			len = len + 1
			pos = pos + utf8charbytes(s, pos)
		end
	
		return len
	end
	
	-- functions identically to string.sub except that i and j are UTF-8 characters
	-- instead of bytes
	function ExRT.F:utf8sub(s, i, j)
		-- argument defaults
		j = j or -1
	
		local pos = 1
		local bytes = strlen(s)
		local len = 0
	
		-- only set l if i or j is negative
		local l = (i >= 0 and j >= 0) or ExRT.F:utf8len(s)
		local startChar = (i >= 0) and i or l + i + 1
		local endChar   = (j >= 0) and j or l + j + 1
	
		-- can't have start before end!
		if startChar > endChar then
			return ""
		end
	
		-- byte offsets to pass to string.sub
		local startByte, endByte = 1, bytes
	
		while pos <= bytes do
			len = len + 1
	
			if len == startChar then
				startByte = pos
			end
	
			pos = pos + utf8charbytes(s, pos)
	
			if len == endChar then
				endByte = pos - 1
				break
			end
		end
	
		return strsub(s, startByte, endByte)
	end
end

do
	local chatWindow = nil
	local activeChat = "RAID"
	local activeName = ""
	local UpdateLines = nil
	local function CreateChatWindow()
		chatWindow = ELib:Template("ExRTDialogModernTemplate",UIParent)
		_G["ExRTToChatWindow"] = chatWindow
		chatWindow:SetSize(400,300)
		chatWindow:SetPoint("CENTER")
		chatWindow:SetFrameStrata("DIALOG")
		chatWindow:SetClampedToScreen(true)
		chatWindow:EnableMouse(true)
		chatWindow:SetMovable(true)
		chatWindow:RegisterForDrag("LeftButton")
		chatWindow:SetDontSavePosition(true)
		chatWindow:SetScript("OnDragStart", function(self) 
			self:StartMoving() 
		end)
		chatWindow:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing() 
		end)
		
		chatWindow.border = ExRT.lib:Shadow(chatWindow,20)
		
		chatWindow.title:SetText(ExRT.L.ChatwindowName)
		
		chatWindow.box = ExRT.lib:MultiEdit(chatWindow):Size(230,265):Point(10,-23):Font('x',11)
		
		local chats = {
			{"ME",ExRT.L.ChatwindowChatSelf},
			{"SAY",ExRT.L.ChatwindowChatSay},
			{"PARTY",ExRT.L.ChatwindowChatParty},
			{"INSTANCE_CHAT",ExRT.L.ChatwindowChatInstance},
			{"RAID",ExRT.L.ChatwindowChatRaid},
			{"WHISPER",ExRT.L.ChatwindowChatWhisper},
			{"TARGET",ExRT.L.ChatwindowChatWhisperTarget},
			{"GUILD",ExRT.L.ChatwindowChatGuild},
			{"OFFICER",ExRT.L.ChatwindowChatOfficer},
		}

		chatWindow.dropDown = ExRT.lib:DropDown(chatWindow,130,#chats):Size(130):Point(255,-60):SetText(ExRT.L.ChatwindowChatRaid)
		chatWindow.dropDownText = ExRT.lib:Text(chatWindow,ExRT.L.ChatwindowChannel,10):Size(350,14):Point("BOTTOMLEFT",chatWindow.dropDown,"TOPLEFT",5,2):Color():Shadow()
		for i=1,#chats do
			local chatData = chats[i]
			chatWindow.dropDown.List[i] = {
				text = chatData[2],
				notCheckable = true,
				justifyH = "CENTER",
				arg1 = chatData[1],
				arg2 = chatData[2],
				func = function (this,arg1,arg2)
					chatWindow.dropDown:SetText(arg2)
					ExRT.lib:DropDownClose()
					activeChat = arg1
				end
			}
		end
		
		chatWindow.target = ExRT.lib:Edit(chatWindow):Size(130,20):Point(255,-115):OnChange(function (self)
			activeName = self:GetText()
		end)
		chatWindow.targetText = ExRT.lib:Text(chatWindow,ExRT.L.ChatwindowNameEB,10):Size(350,14):Point("BOTTOMLEFT",chatWindow.target,"TOPLEFT",5,2):Bottom():Color():Shadow()
		
		chatWindow.button = ExRT.lib:Button(chatWindow,ExRT.L.ChatwindowSend):Size(130,22):Point(255,-150):OnClick(function (self)
			local lines = {strsplit("\n", chatWindow.box.EditBox:GetText())}
			local channel = activeChat
			local whisper = activeName
			if channel == "TARGET" then
				channel = "WHISPER"
				whisper = ExRT.F.UnitCombatlogname("target")
				if not whisper then
					return
				end
			end
			if channel == "ME" then
				for i=1,#lines do
					if lines[i] ~= "" then
						print(lines[i])
					end
				end
				chatWindow:Hide()
				return
			end
			if whisper == "" then
				whisper = nil
			end
			for i=1,#lines do
				if lines[i] ~= "" then
					SendChatMessage(lines[i],channel,nil,whisper)
				end
			end
			chatWindow:Hide()
		end)
		
		chatWindow.helpText = ExRT.lib:Text(chatWindow,ExRT.L.ChatwindowHelp,10):Size(130,100):Point("TOP",chatWindow.button,"BOTTOM",0,-10):Top():Color():Shadow()
		
		chatWindow.chk1 = ExRT.lib:Check(chatWindow,"Option 1"):Point(255,-260):OnClick(function()
			UpdateLines()
		end)
	end
	function UpdateLines()
		local lines = chatWindow.lines
		if not lines or type(lines)~="table" then
			return
		end
		local editData = ""
		local linesCount = #lines
		local clearTags = chatWindow.clearTags
		local option1 = chatWindow.option1enabled and chatWindow.chk1:GetChecked() and "%1" or ""
		for i=1,linesCount do
			local thisLine = lines[i]
			if thisLine ~= "" then
				thisLine = thisLine:gsub("@1@(.-)@1#",option1)
				if clearTags then
					thisLine = ExRT.F.clearTextTag(thisLine)
				end
				if strlen(thisLine) > 254 then
					thisLine = strjoin("\n",ExRT.F.splitLongLine(thisLine,254))
				end
				editData = editData .. thisLine
				if i ~= linesCount then
					editData = editData .. "\n"
				end
			end
		end
		chatWindow.box.EditBox:SetText(editData)
	end
	function ExRT.F:ToChatWindow(lines,clearTags,option1Name)
		if not lines or type(lines)~="table" then
			return
		end
		if not chatWindow then
			CreateChatWindow()
		end
		chatWindow.lines = lines
		chatWindow.clearTags = clearTags
		chatWindow.option1enabled = option1Name
		if option1Name then
			chatWindow.chk1.text:SetText(option1Name)
			chatWindow.chk1:SetChecked(false)
			chatWindow.chk1:Show()
		else
			chatWindow.chk1:Hide()
		end
		UpdateLines()
		chatWindow:Show()
	end
end

do
	local alertWindow = nil
	local alertFunc = nil
	local alertArg1 = nil
	local function CreateWindow()
		alertWindow = ExRT.lib:Popup():Size(500,65)
		
		alertWindow.EditBox = ExRT.lib:Edit(alertWindow):Size(480,16):Point("TOP",0,-20)
		
		alertWindow.OK = ExRT.lib:Button(alertWindow,ACCEPT):Size(130,20):Point("TOP",0,-40):OnClick(function (self)
			alertWindow:Hide()
			local input = alertWindow.EditBox:GetText()
			alertFunc(alertArg1,input)
		end)

		alertWindow.EditBox:SetScript("OnEnterPressed",function (self)
			self:GetParent().OK:Click("LeftButton")
		end)
	end
	function ExRT.F.ShowInput(text,func,arg1,onlyNum,defText)
		if not alertWindow then
			CreateWindow()
		end
		alertWindow.title:SetText(text)
		alertWindow.EditBox:SetText(defText or "")
		alertWindow:ClearAllPoints()
		alertWindow:SetPoint("CENTER",UIParent,0,0)
		alertFunc = func
		alertArg1 = arg1
		if onlyNum then
			alertWindow.EditBox:SetNumeric(true)
		else
			alertWindow.EditBox:SetNumeric(false)
		end
		alertWindow:Show()
		alertWindow.EditBox:SetFocus()
	end
end

---------------> Chat links hook <---------------
do
	local chatLinkFormat = "|HExRT:%s:0|h|cffffff00[ExRT: %s]|r|h"
	local funcTable = {}
	local function createChatHook()
		local SetHyperlink = ItemRefTooltip.SetHyperlink
		function ItemRefTooltip:SetHyperlink(link, ...)
			local funcName = link:match("^ExRT:([^:]+):")
			if funcName then
				local func = funcTable[funcName]
				if not func then
					return
				end
				func()
			else
				SetHyperlink(self, link, ...)
			end
		end
	end

	function ExRT.F.CreateChatLink(funcName,func,stringName)
		if createChatHook then createChatHook() createChatHook = nil end
		if not funcName or not stringName or type(func) ~= "function" then
			return ""
		end
		funcTable[funcName] = func
		return chatLinkFormat:format(funcName,stringName)
	end
end
---------------> Export Window <---------------
do
	local exportWindow
	function ExRT.F:Export(stringData)
		if not exportWindow then
			exportWindow = ELib:Popup(ExRT.L.Export):Size(650,615)
			exportWindow.Edit = ELib:MultiEdit(exportWindow):Point("TOP",0,-20):Size(640,575)
			exportWindow.TextInfo = ELib:Text(exportWindow,ExRT.L.ExportInfo,11):Color():Point("BOTTOM",0,3):Size(640,15):Bottom():Left()
			exportWindow:SetScript("OnHide",function(self)
				self.Edit:SetText("")
			end)
		end
		exportWindow.Edit:SetText(stringData)
		exportWindow:NewPoint("CENTER",UIParent,0,0)
		exportWindow:Show()
		exportWindow.Edit.EditBox:HighlightText()
		exportWindow.Edit.EditBox:SetFocus()
	end

end
-------------------> Data <--------------------

ExRT.GDB.ClassSpecializationIcons = {
	[62] = "Interface\\Icons\\Spell_Holy_MagicalSentry",
	[63] = "Interface\\Icons\\Spell_Fire_FireBolt02",
	[64] = "Interface\\Icons\\Spell_Frost_FrostBolt02",
	[65] = "Interface\\Icons\\Spell_Holy_HolyBolt",
	[66] = "Interface\\Icons\\Ability_Paladin_ShieldoftheTemplar",
	[70] = "Interface\\Icons\\Spell_Holy_AuraOfLight",
	[71] = "Interface\\Icons\\Ability_Warrior_SavageBlow",
	[72] = "Interface\\Icons\\Ability_Warrior_InnerRage",
	[73] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
	[102] = "Interface\\Icons\\Spell_Nature_StarFall",
	[103] = "Interface\\Icons\\Ability_Druid_CatForm",
	[104] = "Interface\\Icons\\Ability_Racial_BearForm",
	[105] = "Interface\\Icons\\Spell_Nature_HealingTouch",
	[250] = "Interface\\Icons\\Spell_Deathknight_BloodPresence",
	[251] = "Interface\\Icons\\Spell_Deathknight_FrostPresence",
	[252] = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
	[253] = "INTERFACE\\ICONS\\ability_hunter_bestialdiscipline",
	[254] = "Interface\\Icons\\Ability_Hunter_FocusedAim",
	[255] = "INTERFACE\\ICONS\\ability_hunter_camouflage",
	[256] = "Interface\\Icons\\Spell_Holy_PowerWordShield",
	[257] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
	[258] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
	[259] = "Interface\\Icons\\Ability_Rogue_DeadlyBrew",
	[260] = "Interface\\Icons\\INV_Sword_30",
	[261] = "Interface\\Icons\\Ability_Stealth",
	[262] = "Interface\\Icons\\Spell_Nature_Lightning",
	[263] = "Interface\\Icons\\Spell_Shaman_ImprovedStormstrike",
	[264] = "Interface\\Icons\\Spell_Nature_MagicImmunity",
	[265] = "Interface\\Icons\\Spell_Shadow_DeathCoil",
	[266] = "Interface\\Icons\\Spell_Shadow_Metamorphosis",
	[267] = "Interface\\Icons\\Spell_Shadow_RainOfFire",
	[268] = "Interface\\Icons\\spell_monk_brewmaster_spec",
	[269] = "Interface\\Icons\\spell_monk_windwalker_spec",
	[270] = "Interface\\Icons\\spell_monk_mistweaver_spec",
	[577] = "Interface\\Icons\\ability_demonhunter_specdps",
	[581] = "Interface\\Icons\\ability_demonhunter_spectank",
}

ExRT.GDB.ClassList = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"DEATHKNIGHT",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"MONK",
	"DRUID",
	"DEMONHUNTER",
}

ExRT.GDB.ClassSpecializationList = {
	["WARRIOR"] = {71, 72, 73},
	["PALADIN"] = {65, 66, 70},
	["HUNTER"] = {253, 254, 255},
	["ROGUE"] = {259, 260, 261},
	["PRIEST"] = {256, 257, 258},
	["DEATHKNIGHT"] = {250, 251, 252},
	["SHAMAN"] = {262, 263, 264},
	["MAGE"] = {62, 63, 64},
	["WARLOCK"] = {265, 266, 267},
	["MONK"] = {268, 269, 270},
	["DRUID"] = {102, 103, 104, 105},
	["DEMONHUNTER"] = {577, 581},
}

ExRT.GDB.ClassArmorType = {
	WARRIOR="PLATE",
	PALADIN="PLATE",
	HUNTER="MAIL",
	ROGUE="LEATHER",
	PRIEST="CLOTH",
	DEATHKNIGHT="PLATE",
	SHAMAN="MAIL",
	MAGE="CLOTH",
	WARLOCK="CLOTH",
	MONK="LEATHER",
	DRUID="LEATHER",
	DEMONHUNTER="LEATHER",
}

ExRT.GDB.ClassSpecializationRole = {
	[62] = 'RANGE',
	[63] = 'RANGE',
	[64] = 'RANGE',
	[65] = 'HEAL',
	[66] = 'TANK',
	[70] = 'MELEE',
	[71] = 'MELEE',
	[72] = 'MELEE',
	[73] = 'TANK',
	[102] = 'RANGE',
	[103] = 'MELEE',
	[104] = 'TANK',
	[105] = 'HEAL',
	[250] = 'TANK',
	[251] = 'MELEE',
	[252] = 'MELEE',
	[253] = 'RANGE',
	[254] = 'RANGE',
	[255] = 'MELEE',
	[256] = 'HEAL',
	[257] = 'HEAL',
	[258] = 'RANGE',
	[259] = 'MELEE',
	[260] = 'MELEE',
	[261] = 'MELEE',
	[262] = 'RANGE',
	[263] = 'MELEE',
	[264] = 'HEAL',
	[265] = 'RANGE',
	[266] = 'RANGE',
	[267] = 'RANGE',
	[268] = 'TANK',
	[269] = 'MELEE',
	[270] = 'HEAL',
	[577] = 'MELEE',
	[581] = 'TANK',
}

ExRT.GDB.ClassID = {
	WARRIOR=1,
	PALADIN=2,
	HUNTER=3,
	ROGUE=4,
	PRIEST=5,
	DEATHKNIGHT=6,
	SHAMAN=7,
	MAGE=8,
	WARLOCK=9,
	MONK=10,
	DRUID=11,
	DEMONHUNTER=12,
}