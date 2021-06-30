local GlobalAddonName, ExRT = ...

ExRT.F.FUNC_FILE_LOADED = true

local UnitName, GetTime, GetCursorPosition, UnitIsUnit = UnitName, GetTime, GetCursorPosition, UnitIsUnit
local select, floor, tonumber, tostring, string_sub, string_find, string_len, bit_band, type, unpack, pairs, format, strsplit = select, floor, tonumber, tostring, string.sub, string.find, string.len, bit.band, type, unpack, pairs, format, strsplit
local string_gsub, string_match = string.gsub, string.match
local RAID_CLASS_COLORS, COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_SPECIAL_MASK = RAID_CLASS_COLORS, COMBATLOG_OBJECT_TYPE_MASK, COMBATLOG_OBJECT_CONTROL_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_SPECIAL_MASK
local UnitGroupRolesAssigned = UnitGroupRolesAssigned or ExRT.NULLfunc
local GetRaidRosterInfo = GetRaidRosterInfo

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
if ExRT.isDev then	--debug or debug ultra
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

function ExRT.F.table_keys(arr)
	local r = {}
	for key,val in pairs(arr) do
		r[#r+1] = key
	end
	return r
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

do
	local printDiff = false
	local printTable = nil
	local function cmp(t1,t2,r,p)
		local c,t = 0,0
		p = p or "."
		for k,v in pairs(t1) do
			if type(v) == "table" then
				if type(t2[k]) == "table" then
					local c2,t2 = cmp(v,t2[k],false,p..k..".")
					c = c + c2
					t = t + t2
				else
					t = t + 1
					if printTable then
						printTable[p..k] = true
					elseif printDiff then
						print(p..k)
					end
				end
			else
				t = t + 1
				if t1[k] == t2[k] then
					c = c + 1
				elseif type(v) == "number" and type(t2[k]) == "number" and tostring(v) == tostring(t2[k]) then
					c = c + 1
				elseif printTable then
					printTable[p..k] = true
				elseif printDiff then
					print(p..k)
				end
			end
		end
		if not r then
			local c2,t2 = cmp(t2,t1,true,p)
			c = c + c2
			t = t + t2
		end
		return c, t
	end
	function ExRT.F.table_compare(t1,t2,showDiff)
		printDiff = showDiff
		if type(printDiff) == "table" then
			printTable = printDiff
			printDiff = nil
		else
			printTable = nil
		end
		local c, t = cmp(t1,t2)
	
		return c / max(1,t), c, t
	end
end

function ExRT.F.table_rewrite(t1,t2)
	local toRemove = {}
	for k,v in pairs(t1) do
		if not t2[k] then
			toRemove[k] = true
		elseif type(v) == "table" and type(t2[k]) == "table" then
			ExRT.F.table_rewrite(v,t2[k])
		else
			t1[k] = t2[k]
		end
	end
	for k,v in pairs(toRemove) do
		t1[k] = nil
	end
	for k,v in pairs(t2) do
		if not t1[k] then
			t1[k] = v
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
--/dump GMRT.F.GetItemBonuses(select(2,GameTooltip:GetItem()))

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
		if UnitIsUnit(name,unitName) then
			return subgroup
		end
	end
	return 0
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

function ExRT.F.TextureToText(textureName,widthInText,heightInText,textureWidth,textureHeight,leftTexCoord,rightTexCoord,topTexCoord,bottomTexCoord)
	return "|T"..textureName..":"..(widthInText or 0)..":"..(heightInText or 0)..":0:0:"..textureWidth..":"..textureHeight..":"..
		format("%d",leftTexCoord*textureWidth)..":"..format("%d",rightTexCoord*textureWidth)..":"..format("%d",topTexCoord*textureHeight)..":"..format("%d",bottomTexCoord*textureHeight).."|t"
end
function ExRT.F.GetRaidTargetText(icon,size)
	size = size or 0
	return ExRT.F.TextureToText([[Interface\TargetingFrame\UI-RaidTargetingIcons]],size,size,256,256,((icon-1)%4)/4,((icon-1)%4+1)/4,floor((icon-1)/4)/4,(floor((icon-1)/4)+1)/4)
end

function ExRT.F.IterateMediaData(mediaType)
	local list
	if LibStub then
		local loaded,media = pcall(LibStub,"LibSharedMedia-3.0")
		if loaded and media then
			list = media:HashTable(mediaType)
		end
	end
	return next, list or {}
end

--[[
	for index, name, subgroup, class, guid, rank, level, online, isDead, combatRole in ExRT.F.IterateRoster do
		<...>
	end
]]
function ExRT.F.IterateRoster(maxGroup,index)
	index = (index or 0) + 1
	maxGroup = maxGroup or 8

	if IsInRaid() then
		if index > GetNumGroupMembers() then
			return
		end
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(index)
		if subgroup > maxGroup then
			return ExRT.F.IterateRoster(maxGroup,index)
		end
		local guid = UnitGUID(name or "raid"..index)
		name = name or ""
		return index, name, subgroup, fileName, guid, rank, level, online, isDead, combatRole
	else
		local name, rank, subgroup, level, class, fileName, online, isDead, combatRole, _

		local unit = index == 1 and "player" or "party"..(index-1)

		local guid = UnitGUID(unit)
		if not guid then
			return
		end

		subgroup = 1
		name, _ = UnitName(unit)
		name = name or ""
		if _ then
			name = name .. "-" .. _
		end
		class, fileName = UnitClass(unit)

		if UnitIsGroupLeader(unit) then
			rank = 2
		else
			rank = 1
		end

		level = UnitLevel(unit)

		if UnitIsConnected(unit) then
			online = true
		end

		if UnitIsDeadOrGhost(unit) then
			isDead = true
		end

		combatRole = UnitGroupRolesAssigned(unit)

		return index, name, subgroup, fileName, guid, rank, level, online, isDead, combatRole
	end
end

function ExRT.F.vpairs(t)
	local prev
	local function it()
		local k,v = next(t,prev)
		prev = k
		return v
	end
	return it
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

	function ExRT.F.utf8len(s)
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
	function ExRT.F.utf8sub(s, i, j)
		-- argument defaults
		j = j or -1

		local pos = 1
		local bytes = strlen(s)
		local len = 0

		-- only set l if i or j is negative
		local l = (i >= 0 and j >= 0) or ExRT.F.utf8len(s)
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

function ExRT.F.GetFirstTableInText(str)
	local strlen = str:len()
	local i = 1
	local deep = 0
	local start
	local inStr
	local inWideStr
	local wideStrEqCount = 0
	while i <= strlen do
		local b = str:byte(i)
		if not start and not inStr and b == 123 then
			start = i
		elseif start and not inStr and b == 123 then
			deep = deep + 1
		elseif start and not inStr and b == 125 then
			if deep <= 0 then
				return str:sub(start,i)
			else
				deep = deep - 1
			end
		elseif not inStr and b == 34 then	--"
			inStr = i
		elseif inStr and not inWideStr and b == 92 then	--\
			i = i + 1
		elseif inStr and not inWideStr and b == 34 then	--"
			inStr = false
		elseif not inStr and b == 91 then	-- [ = [
			local k = i + 1
			local eqc = 0
			while k <= strlen do
				local c1 = str:byte(k)
				if c1 == 61 then
					eqc = eqc + 1
				elseif c1 == b then
					inStr = i
					inWideStr = i
					wideStrEqCount = eqc
					break
				else
					break
				end
				k = k + 1
			end
		elseif inStr and inWideStr and b == 93 then	-- ] = ]
			local k = i + 1
			local eqc = 0
			while k <= strlen do
				local c1 = str:byte(k)
				if c1 == 61 then
					eqc = eqc + 1
				elseif c1 == b then
					if eqc == wideStrEqCount then
						i = k
						inStr = false
						inWideStr = false
					end
					break
				else
					break
				end
				k = k + 1
			end
		end
		i = i + 1
	end
end

do
	local chatWindow = nil
	local activeChat = "RAID"
	local activeName = ""
	local UpdateLines = nil
	local function CreateChatWindow()
		chatWindow = ELib:Template("ExRTDialogModernTemplate",UIParent)
		_G["MRTToChatWindow"] = chatWindow
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
		alertWindow:SetFrameStrata("FULLSCREEN_DIALOG")

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
	function ExRT.F.ShowInput(text,func,arg1,onlyNum,defText,funcOnEdit)
		if not alertWindow then
			CreateWindow()
		end
		alertWindow.OK:Enable()
		alertWindow.title:SetText(text)
		alertWindow.EditBox:SetScript("OnTextChanged",funcOnEdit)
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
	function ExRT.F.ShowText(text)
		if not alertWindow then
			CreateWindow()
		end
		alertWindow.title:SetText("")
		alertWindow:ClearAllPoints()
		alertWindow:SetPoint("CENTER",UIParent,0,0)
		alertWindow.EditBox:SetNumeric(false)
		alertWindow.EditBox:SetText(text)
		alertWindow:Show()
		alertWindow.EditBox:SetFocus()
		alertFunc = ExRT.NULLfunc
	end
end

---------------> Chat links hook <---------------
do
	local chatLinkFormat = "|HMRT:%s:0|h|cffffff00[MRT: %s]|r|h"
	local funcTable = {}
	local function createChatHook()
		local SetHyperlink = ItemRefTooltip.SetHyperlink
		function ItemRefTooltip:SetHyperlink(link, ...)
			local funcName = link:match("^MRT:([^:]+):")
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
	function ExRT.F:Export(stringData,hideTextInfo,windowName,onChangeFunc)
		if not exportWindow then
			exportWindow = ELib:Popup(ExRT.L.Export):Size(650,615)
			exportWindow.Edit = ELib:MultiEdit(exportWindow):Point("TOP",0,-20):Size(640,575)
			exportWindow.TextInfo = ELib:Text(exportWindow,ExRT.L.ExportInfo,11):Color():Point("BOTTOM",0,3):Size(640,15):Bottom():Left()
			exportWindow:SetScript("OnHide",function(self)
				self.Edit:SetText("")
			end)
			exportWindow.Next = ExRT.lib:Button(exportWindow,">>>"):Size(100,16):Point("BOTTOMRIGHT",0,0):OnClick(function (self)
				self.now = self.now + 1
				self:SetText(">>> "..self.now.."/"..#exportWindow.hugeText)
				exportWindow.Edit:SetText(exportWindow.hugeText[self.now])
				exportWindow.Edit.EditBox:HighlightText()
				exportWindow.Edit.EditBox:SetFocus()
				if self.now == #exportWindow.hugeText then
					self:Hide()
				end
			end)
		end
		exportWindow.title:SetText(windowName or ExRT.L.Export)
		exportWindow.Edit.OnTextChanged = onChangeFunc
		exportWindow:NewPoint("CENTER",UIParent,0,0)
		exportWindow.TextInfo:SetShown(not hideTextInfo)
		exportWindow:Show()
		if #stringData > 200000 then
			exportWindow.hugeText = {}
			while stringData and stringData ~= "" do
				local newText = stringData:sub(1,200000)..strsplit("\n",stringData:sub(200001))
				exportWindow.hugeText[#exportWindow.hugeText+1] = newText
				stringData = select(2,strsplit("\n",stringData:sub(200001),2))
			end
			exportWindow.Next.now = 0
			exportWindow.Next:Show()
			exportWindow.Next:Click()
		else
			exportWindow.hugeText = nil
			exportWindow.Next:Hide()
			exportWindow.Edit:SetText(stringData)
			exportWindow.Edit.EditBox:HighlightText()
			exportWindow.Edit.EditBox:SetFocus()
		end
	end

end

---------------> Import/Export data <---------------
do
	local function StringToText(str)
		if str:find("\n") then
			local n = 0
			if str:find("%]$") then
				n = n + 1
			end
			while str:find("%["..string.rep("=",n).."%[") or str:find("%]"..string.rep("=",n).."%]") do
				n = n + 1
			end
			return "["..string.rep("=",n).."["..str.."]"..string.rep("=",n).."]", true
		else
			return "\""..str:gsub("\\","\\\\"):gsub("\"","\\\"").."\""
		end
	end
	
	local function IterateTable(t)
		local prev
		local index = 1
		local indexMax
		local isIndexDone
		local function it()
			if not indexMax then
				local v = t[index]
				if v then
					index = index + 1
					return index-1, v, true
				else
					indexMax = index - 1
				end
			end
			local k,v = next(t,prev)
			prev = k
			while k and type(k)=="number" and k >= 1 and k <= indexMax do
				k,v = next(t,prev)
				prev = k
			end
			return k, v, false
		end
		return it
	end
	
	function ExRT.F.TableToText(t,e,b)
		b = b or {}
		b[t] = true
		e = e or {"{"}
		local ignoreIndex = false
		for k,v,isIndex in IterateTable(t) do
			local newline = ""
			local ignore = true
			if type(v) == "boolean" or type(v) == "number" or type(v) == "string" or type(v) == "table" then
				ignore = false
			end
			if type(v) == "table" and b[v] then
				ignore = true
			end
			if ignore then
				ignoreIndex = true
			elseif isIndex and not ignoreIndex then
			elseif type(k)=="number" then
				newline = newline .. "["..k.."]="
			elseif type(k)=="string" then
				if k:match("[A-Za-z_][A-Za-z_0-9]*") == k then
					newline = newline .. k .. "="
				else
					local kstr, ismultiline = StringToText(k)
					newline = newline .. "["..(ismultiline and " " or "")..kstr..(ismultiline and " " or "").."]="
				end
			elseif type(k)=="boolean" then
				newline = newline .. "["..(k and "true" or "false").."]="
			else
				ignore = true
			end
			if not ignore then
				local tableToExplore
				if type(v)=="number" then
					newline = newline .. v .. ","
				elseif type(v)=="string" then
					newline = newline .. StringToText(v)..","
				elseif type(v)=="boolean" then
					newline = newline ..(v and "true" or "false")..","
				elseif type(v)=="table" then
					newline = newline .."{"
					tableToExplore = v
				end
				e[#e+1] = newline
				if tableToExplore then
					ExRT.F.TableToText(tableToExplore,e,b)
					e[#e] = e[#e] .. ","
				end
			end
		end
		e[#e] = e[#e]:gsub(",$","")
		e[#e+1] = "}"
		return e
	end

	local string_byte = string.byte
	function ExRT.F.TextToTable(str,map,offset)
		if not map and string_byte(str, 1) == 123 then
			str = str:sub(2,-2)	--Expect valid table here
		end
		local strlen = str:len()
		local i = 1
		local prev = 1
		map = map or {}
		offset = offset or 0
	
		local inTable, inString, inWideString
		local startTable, wideStringEqCount = 1, 0
	
		while i <= strlen do
			local b1 = string_byte(str, i)
			if not inString and not inTable and b1 == 123 then
				inTable = 0
				startTable = i
			elseif not inString and inTable and b1 == 123 then
				inTable = inTable + 1
			elseif not inString and inTable and b1 == 125 then
				if inTable == 0 then
					map[startTable+offset] = i + offset
					map[startTable+0.5+offset] = 1
					inTable = false
				else
					inTable = inTable - 1
				end
			elseif not inString and b1 == 34 then	--"
				if map[i+offset+0.5] == 2 then
					i = map[i+offset] - offset
				else
					inString = i
				end
			elseif inString and not inWideString and b1 == 92 then	--\
				i = i + 1
			elseif inString and not inWideString and b1 == 34 then	--"
				map[inString+offset] = i + offset
				map[inString+0.5+offset] = 2
				inString = false
			elseif not inString and b1 == 91 then	-- [ = [
				if map[i+offset+0.5] == 3 then
					i = map[i+offset] - offset
				else
					local k = i + 1
					local eqc = 0
					while k <= strlen do
						local c1 = string_byte(str, k)
						if c1 == 61 then
							eqc = eqc + 1
						elseif c1 == b1 then
							inString = i
							inWideString = i
							i = k
							wideStringEqCount = eqc
							break
						else
							break
						end
						k = k + 1
					end
				end
			elseif inString and inWideString and b1 == 93 then	-- ] = ]
				local k = i + 1
				local eqc = 0
				while k <= strlen do
					local c1 = string_byte(str, k)
					if c1 == 61 then
						eqc = eqc + 1
					elseif c1 == b1 then
						if eqc == wideStringEqCount then
							i = k
							map[inWideString+offset] = i + offset
							map[inWideString+0.5+offset] = 3
							inString = false
							inWideString = false
						end
						break
					else
						break
					end
					k = k + 1
				end
			end
			if not inString and not inTable and (b1 == 44 or i == strlen) then	--,
				map[-prev-offset] = i - (b1 == 44 and 1 or 0) + offset
				prev = i + 1
			end
			i = i + 1
		end
	
		local res = {}
		local numKey = 1
		i = 1
		while i <= strlen do
			if map[-i-offset] then
				local s, e = i, map[-i-offset] - offset
				local k = s
				local key, value
				local isError
				prev = k
				while k <= e do
					if map[k+offset] then
						if map[k+0.5+offset] == 1 then
							value = ExRT.F.TextToTable( str:sub(k+1,map[k+offset]-offset-1) ,map,k+offset)
						elseif map[k+0.5+offset] == 2 then
							value = str:sub(k + 1,map[k+offset]-offset-1):gsub("\\\"","\""):gsub("\\\\","\\")
						elseif map[k+0.5+offset] == 3 then
							value = str:sub(k,map[k+offset]-offset):gsub("^%[=*%[",""):gsub("%]=*%]$","")
						end
						k = map[k+offset] + 1 - offset
					else
						local b1 = string_byte(str, k)
						if b1 == 61 then	--=
							if value then
								key = value
								value = nil
							else
								key = str:sub(prev, k-1):trim()
								if key:find("^%[") and key:find("%]$") then
									key = key:gsub("^%[",""):gsub("%]$","")
									if tonumber(key) then
										key = tonumber(key)
									end
								elseif key == "true" then
									key = true
								elseif key == "false" then
									key = false
								elseif tonumber(key) then
									key = tonumber(key)
								else
									key = key:match("[A-Za-z_][A-Za-z_0-9]*")
								end
								if not key then
									isError = true
									break
								end
							end
							prev = k + 1
						elseif k == e and not value then
							value = str:sub(prev, k):trim()
							if value == "true" then
								value = true
							elseif value == "false" then
								value = false
							else
								value = tonumber(value)
							end
						end
						k = k + 1
					end
				end
				if not isError then
					if not key then
						key = numKey
						numKey = numKey + 1
					end
					res[key] = value
				end
				i = map[-i-offset] - offset
			end
			i = i + 1
		end
		return res
	end

	function ExRT.F.CreateImportExportWindows()
		local function ImportOnUpdate(self, elapsed)
			self.tmr = self.tmr + elapsed
			if self.tmr >= 0.1 then
				self.tmr = 0
				self:SetScript("OnUpdate",nil)
				local str = table.concat(self.buff):trim()
				self.parent:Hide()

				self.buff = {}
				self.buffPos = 0
		
				if self.parent.ImportFunc then
					self.parent:ImportFunc(str)
				end
			end
		end
		
		local importWindow = ELib:Popup(ExRT.L.Import.." "..ExRT.L.ImportHelp):Size(650,100)
		importWindow.Edit = ELib:MultiEdit(importWindow):Point("TOP",0,-20):Size(640,75)
		importWindow:SetScript("OnHide",function(self)
			self.Edit:SetText("")	
		end)
		importWindow:SetScript("OnShow",function(self)
			self.Edit.EditBox.buffPos = 0
			self.Edit.EditBox.tmr = 0
			self.Edit.EditBox.buff = {}
			self.Edit.EditBox:SetFocus()
		end)
		importWindow.Edit.EditBox:SetMaxBytes(1)
		importWindow.Edit.EditBox:SetScript("OnChar", function(self, c)
			self.buffPos = self.buffPos + 1
			self.buff[self.buffPos] = c
			self:SetScript("OnUpdate",ImportOnUpdate)
		end)
		importWindow.Edit.EditBox.parent = importWindow
		
		
		local exportWindow = ELib:Popup(ExRT.L.Export):Size(650,50)
		exportWindow.Edit = ELib:Edit(exportWindow):Point("TOP",0,-20):Size(640,25)
		exportWindow:SetScript("OnHide",function(self)
			self.Edit:SetText("")	
		end)
		exportWindow.Edit:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
		end)
		exportWindow.Edit:SetScript("OnMouseUp", function(self, button)
			self:HighlightText()
			if button == "RightButton" then
				self:GetParent():Hide()
			end
		end)
		exportWindow.Edit:SetScript("OnKeyUp", function(self, c)
			if (c == "c" or c == "C") and IsControlKeyDown() then
				self:GetParent():Hide()
			end
		end)
		function exportWindow:OnShow()
			self.Edit:SetFocus()
		end

		return importWindow, exportWindow
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


if ExRT.isClassic then
	--GetClassInfo
	local classLocalizateEngine = {}
	FillLocalizedClassList(classLocalizateEngine)

	ExRT.Classic.GetClassInfo = function(id) 
		return classLocalizateEngine[ ExRT.GDB.ClassList[id] ] or "unk" 
	end

	--GetSpecializationInfoByID
	local specializationData = {
		[62] = {name="Arcane",class=8,role="DAMAGER",desc="Manipulates raw Arcane magic, destroying enemies with overwhelming power.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=135932},
		[63] = {name="Fire",class=8,role="DAMAGER",desc="Focuses the pure essence of Fire magic, assaulting enemies with combustive flames.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=135810},
		[64] = {name="Frost",class=8,role="DAMAGER",desc="Freezes enemies in their tracks and shatters them with Frost magic.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=135846},
		[65] = {name="Holy",class=2,role="HEALER",desc="Invokes the power of the Light to heal and protect allies and vanquish evil from the darkest corners of the world.|n|nPreferred Weapon: Sword, Mace, and Shield",icon=135920},
		[66] = {name="Protection",class=2,role="TANK",desc="Uses Holy magic to shield $Ghimself:herself; and defend allies from attackers.|n|nPreferred Weapon: Sword, Mace, Axe, and Shield",icon=236264},
		[70] = {name="Retribution",class=2,role="DAMAGER",desc="A righteous crusader who judges and punishes opponents with weapons and Holy magic.|n|nPreferred Weapon: Two-Handed Sword, Mace, Axe",icon=135873},
		[71] = {name="Arms",class=1,role="DAMAGER",desc="A battle-hardened master of weapons, using mobility and overpowering attacks to strike $Ghis:her; opponents down.|n|nPreferred Weapon: Two-Handed Axe, Mace, Sword",icon=132355},
		[72] = {name="Fury",class=1,role="DAMAGER",desc="A furious berserker unleashing a flurry of attacks to carve $Ghis:her; opponents to pieces.|n|nPreferred Weapons: Dual Two-Handed Axes, Maces, Swords",icon=132347},
		[73] = {name="Protection",class=1,role="TANK",desc="A stalwart protector who uses a shield to safeguard $Ghimself:herself; and $Ghis:her; allies.|n|nPreferred Weapon: Axe, Mace, Sword, and Shield",icon=132341},
		[74] = {name="Ferocity",class=0,role="DAMAGER",desc="Driven by a frenzied persistence to pursue prey, these beasts stop at nothing to achieve victory; even death is temporary for these predators.",icon=236159},
		[79] = {name="Cunning",class=0,role="DAMAGER",desc="",icon=132150},
		[81] = {name="Tenacity",class=0,role="TANK",desc="",icon=132121},
		[102] = {name="Balance",class=11,role="DAMAGER",desc="Can shapeshift into a powerful Moonkin, balancing the power of Arcane and Nature magic to destroy enemies.|n|nPreferred Weapon: Staff, Dagger, Mace",icon=136096},
		[103] = {name="Feral",class=11,role="DAMAGER",desc="Takes on the form of a great cat to deal damage with bleeds and bites.|n|nPreferred Weapon: Staff, Polearm",icon=132115},
		[104] = {name="Guardian",class=11,role="TANK",desc="Takes on the form of a mighty bear to absorb damage and protect allies.|n|nPreferred Weapon: Staff, Polearm",icon=132276},
		[105] = {name="Restoration",class=11,role="HEALER",desc="Channels powerful Nature magic to regenerate and revitalize allies.|n|nPreferred Weapon: Staff, Dagger, Mace",icon=136041},
		[250] = {name="Blood",class=6,role="TANK",desc="A dark guardian who manipulates and corrupts life energy to sustain $Ghimself:herself; in the face of an enemy onslaught.|n|nPreferred Weapon: Two-Handed Axe, Mace, Sword",icon=135770},
		[251] = {name="Frost",class=6,role="DAMAGER",desc="An icy harbinger of doom, channeling runic power and delivering vicious weapon strikes.|n|nPreferred Weapons: Dual Axes, Maces, Swords",icon=135773},
		[252] = {name="Unholy",class=6,role="DAMAGER",desc="A master of death and decay, spreading infection and controlling undead minions to do $Ghis:her; bidding.|n|nPreferred Weapon: Two-Handed Axe, Mace, Sword",icon=135775},
		[253] = {name="Beast Mastery",class=3,role="DAMAGER",desc="A master of the wild who can tame a wide variety of beasts to assist $Ghim:her; in combat.|n|nPreferred Weapon: Bow, Crossbow, Gun",icon=461112},
		[254] = {name="Marksmanship",class=3,role="DAMAGER",desc="A master sharpshooter who excels in bringing down enemies from afar.|n|nPreferred Weapon: Bow, Crossbow, Gun",icon=236179},
		[255] = {name="Survival",class=3,role="DAMAGER",desc="An adaptive ranger who favors using explosives, animal venom, and coordinated attacks with their bonded beast.|n|nPreferred Weapon: Polearm, Staff",icon=461113},
		[256] = {name="Discipline",class=5,role="HEALER",desc="Uses magic to shield allies from taking damage as well as heal their wounds.|n|nPreferred Weapon: Staff, Wand, Dagger, Mace",icon=135940},
		[257] = {name="Holy",class=5,role="HEALER",desc="A versatile healer who can reverse damage on individuals or groups and even heal from beyond the grave.|n|nPreferred Weapon: Staff, Wand, Dagger, Mace",icon=237542},
		[258] = {name="Shadow",class=5,role="DAMAGER",desc="Uses sinister Shadow magic and terrifying Void magic to eradicate enemies.|n|nPreferred Weapon: Staff, Wand, Dagger, Mace",icon=136207},
		[259] = {name="Assassination",class=4,role="DAMAGER",desc="A deadly master of poisons who dispatches victims with vicious dagger strikes.|n|nPreferred Weapons: Daggers",icon=236270},
		[260] = {name="Outlaw",class=4,role="DAMAGER",desc="A ruthless fugitive who uses agility and guile to stand toe-to-toe with enemies.|n|nPreferred Weapons: Axes, Maces, Swords, Fist Weapons",icon=236286},
		[261] = {name="Subtlety",class=4,role="DAMAGER",desc="A dark stalker who leaps from the shadows to ambush $Ghis:her; unsuspecting prey.|n|nPreferred Weapons: Daggers",icon=132320},
		[262] = {name="Elemental",class=7,role="DAMAGER",desc="A spellcaster who harnesses the destructive forces of nature and the elements.|n|nPreferred Weapon: Mace, Dagger, and Shield",icon=136048},
		[263] = {name="Enhancement",class=7,role="DAMAGER",desc="A totemic warrior who strikes foes with weapons imbued with elemental power.|n|nPreferred Weapons: Dual Axes, Maces, Fist Weapons",icon=237581},
		[264] = {name="Restoration",class=7,role="HEALER",desc="A healer who calls upon ancestral spirits and the cleansing power of water to mend allies' wounds.|n|nPreferred Weapon: Mace, Dagger, and Shield",icon=136052},
		[265] = {name="Affliction",class=9,role="DAMAGER",desc="A master of shadow magic who specializes in drains and damage-over-time spells.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=136145},
		[266] = {name="Demonology",class=9,role="DAMAGER",desc="A commander of demons who twists the souls of $Ghis:her; army into devastating power.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=136172},
		[267] = {name="Destruction",class=9,role="DAMAGER",desc="A master of chaos who calls down fire to burn and demolish enemies.|n|nPreferred Weapon: Staff, Wand, Dagger, Sword",icon=136186},
		[268] = {name="Brewmaster",class=10,role="TANK",desc="A sturdy brawler who uses unpredictable movement and mystical brews to avoid damage and protect allies.|n|nPreferred Weapon: Staff, Polearm",icon=608951},
		[269] = {name="Windwalker",class=10,role="DAMAGER",desc="A martial artist without peer who pummels foes with hands and fists.|n|nPreferred Weapons: Fist Weapons, Axes, Maces, Swords",icon=608953},
		[270] = {name="Mistweaver",class=10,role="HEALER",desc="A healer who masters the mysterious art of manipulating life energies aided by the wisdom of the Jade Serpent.|n|nPreferred Weapon: Staff, Mace, Sword",icon=608952},
		[535] = {name="Ferocity",class=0,role="DAMAGER",desc="Driven by a rabid persistence to pursue prey, these carnivorous beasts stop at nothing to achieve victory; even death is temporary for these predators.",icon=236159},
		[536] = {name="Cunning",class=0,role="DAMAGER",desc="",icon=132150},
		[537] = {name="Tenacity",class=0,role="TANK",desc="",icon=132121},
		[577] = {name="Havoc",class=12,role="DAMAGER",desc="A brooding master of warglaives and the destructive power of Fel magic.|n|nPreferred Weapons: Warglaives, Swords, Axes, Fist Weapons",icon=1247264},
		[581] = {name="Vengeance",class=12,role="TANK",desc="Embraces the demon within to incinerate enemies and protect their allies.|n|nPreferred Weapons: Warglaives, Swords, Axes, Fist Weapons",icon=1247265},
	}

	ExRT.Classic.GetSpecializationInfoByID = function(id) 
		local data = specializationData[id] or ExRT.NULL
		return id, data.name, data.desc, data.icon, data.role, ExRT.GDB.ClassList[data.class]
	end
end

ExRT.GDB.EncountersList = {
	{350,652,653,654,655,656,657,658,659,660,661,662},
	{331,651},
	{330,649,650},
	{332,623,624,625,626,627,628},
	{334,730,731,732,733},
	{329,618,619,620,621,622},
	{335,724,725,726,727,728,729},
	{129,519,520,2009,522,521,2010,2011,524,523,525,526,2012,527},
	{130,2002,2003,2004,2005},
	{132,1969,1966,1967,1989,1968},
	{133,2026,2024,2025},
	{136,2030,2027,2029,2028},
	{138,1987,1985,1984,1986},
	{140,1994,1996,1995,1998},
	{141,1094},
	{142,528,2013,530,529,2014,2015,532,531,533,534,2016,535},
	{162,1107,1110,1116,1117,1112,1115,1113,1109,1121,1118,1111,1108,1120,1119,1114},
	{155,1093,1092,1091,1090},
	{147,1132,1136,1139,1142,1140,1137,1131,1135,1141,1164,1165,1166,1133,1138,1134,1143,1130},
	{153,1978,1983,1980,1988,1981},
	{156,1126,1127,1128,1129},
	{157,1971,1972,1973},
	{160,1974,1976,1977,1975},
	{168,2018,2019,2020},
	{171,2022,2023,2021},
	{172,1088,1087,1086,1089,1085},
	{183,2006,2007},
	{184,1999,2001,2000},
	{185,1992,1993,1990},
	{186,1101,1100,1099,1096,1104,1097,1102,1095,1103,1098,1105,1106},
	{200,1147,1149,1148,1150},
	{213,1443,1444,1445,1446},
	{219,593,594,595,596,597,598,599,600},
	{220,492,488,486,487,490,491,493},
	{221,1667,1668,1669,1675,1676,1670,1671,1672},
	{225,1144,1145,1146},
	{226,379,378,380,381,382},
	{230,547,548,549,551,552,553,554,1887},
	{232,663,664,665,666,667,668,669,670,671,672},
	{233,785,784,786,787,788,789,790,791,792,793},
	{234,343,344,345,346,350,347,348,349,361,362,363,364,365,366,367,368},
	{242,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245},
	{246,1935,1936,1937,1938},
	{247,718,719,720,721,722,723},
	{248,1084},
	{250,267,268,269,270,271,272,274,273,275},
	{256,1889,1890},
	{258,1902,1903,1904},
	{260,1908,1909,1910,1911},
	{261,1922,1923,1924},
	{262,1945,1946,1947,1948},
	{263,1942,1943,1944},
	{265,1939,1940,1941},
	{266,1925,1926,1927,1928,1929},
	{267,1930,1931,1932,1933,1934},
	{269,1913,1914,1915,1916},
	{272,1899,1900,250,1901},
	{273,1919,1920,1921},
	{274,1905,1906,1907},
	{277,1052,1053,1054,1055},
	{279,585,586,587,588,589,590,591,592},
	{280,422,423,427,424,425,426,428,429},
	{282,1033,1250,1332},
	{283,1040,1038,1039,1037,1036},
	{285,1027,1024,1022,1023,1025,1026},
	{287,610,611,612,613,614,615,616,617},
	{291,1064,1065,1063,1062,1060,1081},
	{293,1051,1050,1048,1049},
	{294,1030,1032,1028,1029,1082,1083},
	{297,1080,1076,1075,1077,1074,1079,1078},
	{300,1662,1663,1664,1665,1666},
	{301,1656,438,1659,1660,1661},
	{302,444,446,447,448,449,450},
	{306,451,452,453,454,455,456,457,458,459,460,461,462,463},
	{310,1069,1070,1071,1073,1072},
	{317,473,474,476,475,477,478,472,479,480,481,482,483,484,1885},
	{319,709,710,711,712,713,714,715,716,717},
	{322,1045,1044,1046,1047},
	{324,1056,1059,1058,1057},
	{325,1043,1041,1042},
	{328,1035,1034},
	{333,1189,1190,1191,1192,1193,1194},
	{337,1178,1179,1188,1180,1181,1182},
	{339,601,602,603,604,605,606,607,608,609},
	{347,1891,1892,1893},
	{348,1894,1895,1897,1898},
	{367,1197,1204,1205,1206,1200,1185,1203},
	{398,1272,1273,1274},
	{399,1337,1340,1339},
	{401,1881,1882,1883,1884,1271},
	{409,1292,1294,1295,1296,1297,1298,1291,1299},
	{429,1418,1417,1416,1439},
	{431,1422,1421,1420},
	{435,1423,1424,1425},
	{437,1397,1405,1406,1419},
	{439,1412,1413,1414},
	{443,1303,1304,1305,1306},
	{453,1442,1509,1510,1441},
	{456,1409,1505,1506,1431},
	{457,1465,1502,1447,1464},
	{471,1395,1390,1434,1436,1500,1407},
	{474,1507,1504,1463,1498,1499,1501},
	{476,1426,1427,1428,1429,1430},
	{508,1577,1575,1570,1565,1578,1573,1572,1574,1576,1559,1560,1579,1580,1581},
	{554,1563,1564,1571,1587},
	{556,1602,1598,1624,1604,1622,1600,1606,1603,1595,1594,1599,1601,1593,1623,1605},
	{573,1655,1653,1652,1654},
	{574,1677,1688,1679,1682},
	{593,1686,1685,1678,1714},
	{595,1749,1748,1750,1754},
	{601,1698,1699,1700,1701},
	{606,1715,1732,1736},

	{616,1761,1758,1759,1760,1762},
	{620,1746,1757,1751,1752,1756},
	{624,1755,1770,1801},

	{703,1805,1806,1807,1808,1809},
	{708,1822,1823,1824},
	{710,1815,1850,1816,1817,1818},
	{713,1810,1811,1812,1813,1814},
	{731,1790,1791,1792,1793},
	{732,1845,1846,1847,1848,1851,1852,1855,1856},
	{733,1836,1837,1838,1839},
	{749,1825,1826,1827,1828,1829},
	{751,1832,1833,1834,1835},
	{761,1868,1869,1870},

	{790,1879,1880,1888,1917,1950,1951,1952,1953,1949},

	{809,1957,1954,1961,1960,1964,1965,1959,2017,2031},

	{845,2055,2057,2039,2053},		

	{903,2065,2066,2067,2068},	

	{934,2084,2085,2086,2087},
	{936,2093,2094,2095,2096},
	{974,2101,2102,2103,2104},
	{1010,2105,2106,2107,2108},
	{1015,2113,2114,2115,2116,2117},
	{1041,2111,2118,2112,2123},
	{1162,2098,2097,2109,2099,2100},
	{1038,2124,2125,2126,2127},
	{1039,2130,2131,2132,2133},
	{1004,2139,2142,2140,2143},
	{1490,2290,2292,2312,2291,2257,2258,2259,2260},

	{1666,2387,2388,2389,2390},
	{1674,2382,2384,2385,2386},
	{1669,2397,2392,2393},	
	{1663,2401,2380,2403,2381},
	{1693,2357,2356,2358,2359},
	{1683,2391,2365,2366,2364,2404},
	{1679,2395,2394,2400,2396},
	{1675,2360,2361,2362,2363},

        {610,1721,1706,1720,1722,1719,1723,1705},--HM
	{596,1696,1691,1693,1694,1689,1692,1690,1713,1695,1704},--BF
	{661,1778,1785,1787,1798,1786,1783,1788,1794,1777,1800,1784,1795,1799},--HFC
	{777,1853,1841,1873,1854,1876,1877,1864},--EN
	{806,1958,1962,2008},--tov
	{764,1849,1865,1867,1871,1862,1886,1842,1863,1872,1866},--nighthold
	{850,2032,2048,2036,2037,2050,2054,2052,2038,2051},--tos
	{909,2076,2074,2064,2070,2075,2082,2069,2088,2073,2063,2092},--antorus
	{1148,2144,2141,2136,2128,2134,2145,2135,2122},--uldir
	{1358,2265,2263,2284,2266,2285,2271,2268,2272,2276,2280,2281},	--bfd
	{1345,2269,2273},	--storms
	{1512,2298,2305,2289,2304,2303,2311,2293,2299},	--ethernal place
	{1582,2329,2327,2334,2328,2336,2333,2331,2335,2343,2345,2337,2344}, --nyalotha
	{1735,2398,2418,2402,2383,2405,2406,2412,2399,2417,2407},	--castle Nathria
	{1998,2423,2433,2429,2432,2434,2430,2436,2431,2422,2435},	--sod
}

function ExRT.F.GetEncountersList(onlyRaid,onlySL,reverse)
	local new = {}

	local isSL,isRaid
	for _,v in ipairs(ExRT.GDB.EncountersList) do
		if v[1] == 610 then
			isRaid = true
			isSL = false
		elseif v[1] == 1666 then
			isSL = true
		elseif v[1] == 1735 then
			isSL = true
		end
		if (not onlySL or isSL) and (not onlyRaid or isRaid) then
			new[#new+1] = v
		end
	end
	if reverse then
		local len = #new
		for i=1,floor(len/2) do
			new[i], new[len+1-i] = new[len+1-i], new[i]
		end
	end
	return new
end