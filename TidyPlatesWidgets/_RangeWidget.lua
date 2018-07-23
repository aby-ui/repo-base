--[[
		UnitInRange: 40
		2: ~9
		3: 7.5-8
		4: 28
		Item6450:15
		Dismiss Pet: 10 yds
		Melee Range: 4
--]]

local GetGroupInfo = TidyPlatesUtility.GetGroupInfo
local RangesCache = {}
local Ranges = {}
local RangeWatcher = CreateFrame("Frame")
local nextRangeCheckup = 0
local currentTime = 0
local updateFreq = .5

local function GetRange(unitid)
	local estRange = nil
	if UnitInRange(unitid) then estRange = 40 end
	if CheckInteractDistance(unitid, 4) then estRange = 28
		if IsItemInRange(6450, unitid) == 1 then estRange = 15
			if CheckInteractDistance(unitid, 2) then estRange = 9 end end
	end
	return estRange
end

local function CheckRanges(self)
	currentTime = GetTime()
	if currentTime < nextRangeCheckup then return end
	nextRangeCheckup = currentTime + updateFreq
	local group, size, index, unitid, inRange
	local estRange = nil
	-- Check Group Type
	
	local groupType, groupSize = GetGroupInfo()
	
	if groupType == 'party' then groupSize = groupSize - 1 end 
	
	-- Cycle through Group
	if groupType then
		for index = 1, groupSize do
			unitid = groupType..index	
			Ranges[UnitName(unitid)] = GetRange(unitid)
		end
	end
	
	--Ranges[UnitName("pet")] = GetRange("pet")		-- For testing
	
	-- Check Cache
	for name, range in pairs(Ranges) do 
		if range ~= RangesCache[name] then
			--print("Range Change")
			RangesCache[name] = range
			TidyPlates:Update()
		end
	end	
end

local usingRangeWidget = false
local function ActivateRangeWidget()
	if usingRangeWidget then 
		wipe(Ranges)
		if (UnitInRaid("player") or UnitInParty("player")) then 
			RangeWatcher:SetScript("OnUpdate", CheckRanges)
		else RangeWatcher:SetScript("OnUpdate", nil) end	
	end
end

RangeWatcher:SetScript("OnEvent", ActivateRangeWidget)
RangeWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
RangeWatcher:RegisterEvent("GROUP_ROSTER_UPDATE")
--RangeWatcher:RegisterEvent("PARTY_CONVERTED_TO_RAID") --TODO aby8

---------------------------------------------------------------------------

-- Widget
local art = "Interface\\Addons\\TidyPlatesWidgets\\RangeWidget\\RangeWidget"

local function UpdateRangeWidget(self, unit, range)
		local unitrange, saferange
		saferange = range or self.Range
		if unit.reaction == "FRIENDLY" then --and unit.type == "PLAYER" then 
			unitrange = Ranges[unit.name] or 100
			--self.String:SetText(range) 
			if unitrange <= saferange then 
				self.Texture:Show()
				self.Texture:SetVertexColor(1,.25,0,.50)  -- Red
				--self.Texture:SetVertexColor(1,.1,0,.55)  -- Red
			--elseif unitrange == self.unitrange then 
			--	self.Texture:Show()
			--	self.Texture:SetVertexColor(1,.5,0,.25)
				--self.String:SetTextColor(1,.5,0)
			else self.Texture:Hide() end
			self:Show()
		else self:Hide() end
end

local function CreateRangeWidget(parent)
	if not usingRangeWidget then usingRangeWidget = true; ActivateRangeWidget() end
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(16); frame:SetHeight(16)
	-- Image
	frame.Texture = frame:CreateTexture(nil, "OVERLAY")
	frame.Texture:SetTexture(art)
	frame.Texture:SetPoint("CENTER")
	frame.Texture:SetWidth(128)
	frame.Texture:SetHeight(128)
	-- Vars and Mech
	frame.Range = 15
	frame:Hide()
	frame.Update = UpdateRangeWidget
	return frame
end

TidyPlatesWidgets.CreateRangeWidget = CreateRangeWidget




			