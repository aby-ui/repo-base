local _,L = ...
local rematch = Rematch
local collection = RematchDialog.CollectionReport
local report, settings

collection.chartNames = { L["Total Collected Pets"], L["Unique Collected Pets"], L["Pets Not Collected"], L["Percent Collected"], L["Max Level Pets"], L["Rare Quality Pets"], L["Unique Pets In the Journal"] }
collection.chartColors = { -- first is pet types colors, second is sources colors
	{ {0.03125,0.56640625,0.88671875}, {0.07421875,0.4375,0.07421875}, {0.78125,0.765625,0.30078125}, {0.40625,0.28125,0.3125}, {0.46875,0.328125,0.25}, {0.65625,0.4375,0.96875}, {0.96875,0.640625,0}, {0.73828125,0.140625,0.11328125}, {0.03125,0.66796875,0.69921875}, {0.625,0.625,0.5625} },
	{ {0.29296875,0.4921875,0.33984375}, {0.81640625,0.796875,0.55859375}, {0.89453125,0.61328125,0.03125}, {0.73046875,0.72265625,0.6875}, {0.90625,0.421875,0.09375}, {0.40234375,0.49609375,0.62109375}, {0.3828125,0.1484375,0.6796875}, {0.48046875,0.66015625,0.67578125}, {0.56640625,0.05859375,0.171875}, {0.19140625,0.65625,0.66796875} }
}
-- texcoords for source icons
collection.chartSourceCoords = { {0,0.25,0,0.25},{0.25,0.5,0,0.25},{0.5,0.75,0,0.25},{0.75,1,0,0.25}, {0,0.25,0.25,0.5},{0.25,0.5,0.25,0.5},{0.5,0.75,0.25,0.5},{0.75,1,0.25,0.5}, {0,0.25,0.5,0.75},{0.25,0.5,0.5,0.75} }

rematch:InitModule(function()
	settings = RematchSettings
	collection.report = {petIDs={},speciesIDs={},rarities={},chart={}}
	report = collection.report -- data for the reports are kept here
end)


function rematch:ShowCollectionReport()
	if rematch:IsDialogOpen("CollectionReport") then
		rematch:HideDialog()
		return
	end
	collection:GenerateReportData()
	local dialog = rematch:ShowDialog("CollectionReport",300,480,L["Collection Statistics"],nil,nil,nil,OKAY)
	dialog.CollectionReport:SetPoint("TOP",0,-40)
	dialog.CollectionReport:Show()

	local frame = dialog.CollectionReport -- the frame that contains the report 

	frame.InGame:SetText(format(L["There are %s%d\124r unique pets in the journal"],rematch.hexWhite,report.ingame))
	frame.OwnedLabel:SetText(L["Pets Collected"])
	frame.MaxLevelLabel:SetText(L["Pets At Max Level"])
	frame.RaresLabel:SetText(L["Rare Quality Pets"])
	frame.TotalLabel:SetText(L["Total"])
	frame.UniqueLabel:SetText(L["Unique"])
	frame.OwnedTotal:SetText(report.owned)
	frame.OwnedUnique:SetText(report.unique)
	frame.MaxLevelTotal:SetText(report.lev25total)
	frame.MaxLevelUnique:SetText(report.lev25unique)
	frame.RaresTotal:SetText(report.rarestotal)
	frame.RaresUnique:SetText(report.raresunique)

	frame.DuplicatesLabel:SetText(L["Duplicate Collected Pets"])
	frame.AvgLevelLabel:SetText(L["Average Battle Pet Level"])
	frame.MissingLabel:SetText(L["Pets Not Collected"])
	frame.Duplicates:SetText(report.duplicates)
	frame.AvgLevel:SetText(format("%.1f",report.avglevel))
	frame.Missing:SetText(report.missing)

	frame.Complete:SetText(format(L["You have %s%.1f%%\124r of those unique pets"],rematch.hexWhite,report.complete))
	for i=4,1,-1 do
		frame.RarityBar[i]:SetVertexColor(ITEM_QUALITY_COLORS[i-1].r,ITEM_QUALITY_COLORS[i-1].g,ITEM_QUALITY_COLORS[i-1].b)
		frame.RarityBar[i]:ClearAllPoints()
		if i==4 then
			frame.RarityBar[i]:SetPoint("LEFT",frame.RarityBarBorder,"LEFT",7,0)
		else
			frame.RarityBar[i]:SetPoint("LEFT",frame.RarityBar[i+1],"RIGHT")
		end
		frame.RarityBar[i]:SetWidth(max(1,210*report.rarities[i]))
	end

	-- one-time initialization of stuff first time a report/chart is shown
	if not rematch:GetMenu("CollectionReportMenu") then
		rematch:RegisterMenu("CollectionReportMenu", {
			{ text=collection.CollectionChartMenuText, index=7, func=collection.CollectionChartMenuFunc, tooltipBody=L["All unique pets in the journal. This is all obtainable unique pets."] },
			{ text=collection.CollectionChartMenuText, index=1, func=collection.CollectionChartMenuFunc, tooltipBody=L["All pets you've collected, including duplicates."] },
			{ text=collection.CollectionChartMenuText, index=2, func=collection.CollectionChartMenuFunc, tooltipBody=L["The unique pets you've collected, not including duplicates."] },
			{ text=collection.CollectionChartMenuText, index=3, func=collection.CollectionChartMenuFunc, tooltipBody=L["The unique pets you're missing."] },
			{ text=collection.CollectionChartMenuText, index=4, func=collection.CollectionChartMenuFunc, tooltipBody=L["How much of each category's unique pets you've collected as a percent."] },
			{ text=collection.CollectionChartMenuText, index=5, func=collection.CollectionChartMenuFunc, tooltipBody=L["All of your level 25 pets, including duplicates."] },
			{ text=collection.CollectionChartMenuText, index=6, func=collection.CollectionChartMenuFunc, tooltipBody=L["All of your rare quality pets, including duplicates."] },
		})
		frame.ChartTypeComboBox.OnClick = function(self)
			rematch:ToggleMenu("CollectionReportMenu","TOPRIGHT",self,"BOTTOMRIGHT",0,2)
		end
		frame.ChartTypeComboBox.Text:SetJustifyH("CENTER")
		frame.ChartTypeComboBox.Text:SetPoint("BOTTOMRIGHT",-5,3)
		frame.ChartTypeComboBox.Text:SetFontObject(GameFontNormal)
		frame.ChartTypesRadioButton.Text:SetText(L["Pet Types"])
		frame.ChartSourcesRadioButton.Text:SetText(L["Sources"])
		
		frame.Chart.Columns = {}
		for i=1,10 do
			frame.Chart.Columns[i] = CreateFrame("Button",nil,frame.Chart,"RematchChartColumnTemplate")
			frame.Chart.Columns[i]:SetPoint("BOTTOMLEFT",8+(i-1)*25,8)
			frame.Chart.Columns[i]:SetID(i)
			frame.Chart.Columns[i]:SetScript("OnEnter",collection.ChartColumnOnEnter)
			frame.Chart.Columns[i]:SetScript("OnLeave",rematch.HideTooltip)
		end
	end

	collection:UpdateChart()
end

function collection:UpdateChart()
	local frame = rematch.Dialog.CollectionReport -- the frame that contains the report 

	frame.ChartTypeComboBox.Text:SetText(collection.chartNames[settings.CollectionChartType])
	frame.ChartTypesRadioButton:SetChecked(not settings.CollectionChartSources)
	frame.ChartSourcesRadioButton:SetChecked(settings.CollectionChartSources)

	local forSources = settings.CollectionChartSources
	local colors = forSources and collection.chartColors[2] or collection.chartColors[1]
	local maxHeight = 0
	for i=1,10 do
		frame.Chart.Columns[i].Bar:SetVertexColor(unpack(colors[i]))
		if forSources then
			frame.Chart.Columns[i].Icon:SetTexture("Interface\\AddOns\\Rematch\\Textures\\sources")
			frame.Chart.Columns[i].Icon:SetTexCoord(unpack(collection.chartSourceCoords[i]))
		else
			rematch:FillPetTypeIcon(frame.Chart.Columns[i].Icon,i,"Interface\\Icons\\Icon_PetFamily_")
			frame.Chart.Columns[i].Icon:SetTexCoord(0.075,0.925,0.075,0.925)
		end
		frame.Chart.Columns[i].Value:SetText(report.chart[i])
		maxHeight = max(maxHeight,report.chart[i])
	end
	for i=1,10 do
		if report.chart[i]==0 then
			frame.Chart.Columns[i].Bar:SetHeight(1)
		else
			frame.Chart.Columns[i].Bar:SetHeight((report.chart[i]/maxHeight)*100)
		end
	end
end

function collection:CollectionChartMenuText()
	return collection.chartNames[self.index]
end

-- when new chart type chosen from dropdown
function collection:CollectionChartMenuFunc()
	settings.CollectionChartType = self.index
	collection:GenerateReportData()
	collection:UpdateChart()
end

-- when radio button clicked to choose types vs sources
function collection:ChartRadioOnClick()
	settings.CollectionChartSources = self:GetID()==2
	collection:GenerateReportData()
	collection:UpdateChart()
end

function collection:ChartColumnOnEnter()
	local name = _G[(settings.CollectionChartSources and "BATTLE_PET_SOURCE_" or "BATTLE_PET_NAME_")..self:GetID()]
	if name then
		rematch.ShowTooltip(self,name)
	end
end

-- gathers all petIDs and speciesIDs in their report tables and assigns them a hash
-- of level*1000+rarity*100+chart if forRarity is false
-- of rarity*10000+level*100+chart if forRarity is true
function collection:GatherReportHash(forRarity)
	local roster = Rematch.Roster
	local showSources = settings.CollectionChartSources
	wipe(report.petIDs)
	wipe(report.speciesIDs)
	if showSources then
		roster:GetSpeciesSource() -- gather all species' sources if charting sources
	end
	-- gather owned pets into report.petIDs and missing pets
	-- all pets (owned or not) go into report.speciesIDs, indexed by speciesID (highest level of species)
	for petID in roster:AllPets() do
		if type(petID)=="string" then
			local speciesID,_,level,_,_,_,_,_,_,petType = C_PetJournal.GetPetInfoByPetID(petID)
			local _,_,_,_,rarity = C_PetJournal.GetPetStats(petID)
			local chart = showSources and roster:GetSpeciesSource(speciesID) or petType
			if showSources and chart>10 then
				chart = 1 -- chart 11 is "Discovery" sources; adding them to Drop category
			end
			local hash
			if forRarity then
				hash = rarity*10000 + level*100 + chart
			else
				hash = level*1000 + rarity*100 + chart
			end
			report.petIDs[petID] = hash
			local old = report.speciesIDs[speciesID]
			if not old or hash>old then
				report.speciesIDs[speciesID] = hash
			end
		elseif type(petID)=="number" then
			report.speciesIDs[petID] = showSources and roster:GetSpeciesSource(petID) or select(3,C_PetJournal.GetPetInfoBySpeciesID(petID))
		end
	end
end

function collection:GenerateReportData()

	collection:GatherReportHash(false) -- gather hash values for all pets with priority for level

	-- tally the bananas (and all other pets too) for stats at top of dialog
	report.owned, report.unique, report.ingame = 0,0,0
	report.lev25total, report.lev25unique = 0,0
	for k,v in pairs(report.petIDs) do
		report.owned = report.owned + 1
		report.lev25total = report.lev25total + (floor(v/1000)==25 and 1 or 0)
	end
	for k,v in pairs(report.speciesIDs) do
		if v>100 then -- if hash is > 100 then it has stats (and is owned)
			report.unique = report.unique + 1
			report.lev25unique = report.lev25unique + (floor(v/1000)==25 and 1 or 0)
		end
		report.ingame = report.ingame + 1
	end
	report.missing = report.ingame - report.unique
	report.duplicates = report.owned - report.unique
	report.complete = (1-(report.missing/report.ingame))*100

	-- average battle pet level excludes non-battle pets, so it's added up separately
	report.avglevel=0
	local avglevelcount = 0
	for petID in rematch.Roster:AllOwnedPets() do
		local _,_,level,_,_,_,_,_,_,_,_,_,_,_,canBattle = C_PetJournal.GetPetInfoByPetID(petID)
		if canBattle then
			avglevelcount = avglevelcount + 1
			report.avglevel = report.avglevel + level
		end
	end
	report.avglevel = avglevelcount>0 and (report.avglevel / avglevelcount) or 0

	-- gather rarity bar data
	collection:GatherReportHash(true) -- gather hash values for all pets with priority for rarity
	for k,v in pairs(report.speciesIDs) do
		if v>100 then
			local rarity = floor(v/10000)
			report.rarities[rarity] = (report.rarities[rarity] or 0) + 1
		end
	end
	-- rarities: 1=poor, 2=common, 3=uncommon, 4=rare
	for i=1,4 do
		report.rarities[i] = (report.rarities[i] or 0)/report.ingame
	end
	-- while hash sorted for rarity, get total and unique rarity counts
	report.rarestotal, report.raresunique = 0,0
	for k,v in pairs(report.petIDs) do
		if floor(v/10000)==4 then
			report.rarestotal = report.rarestotal + 1
		end
	end
	for k,v in pairs(report.speciesIDs) do
		if v>100 and floor(v/10000)==4 then
			report.raresunique = report.raresunique + 1
		end
	end

	-- gather chart data (settings.CollectionChartType)
	-- 1 = Total Collected Pets (petIDs)
	-- 2 = Unique Collected Pets (speciesIDs)
	-- 3 = Pets Not Collected (speciesIDs)
	-- 4 = Percent Completed (speciesIDs) -- this is unique/ingame for each type/source
	-- 5 = Max Level Pets (petIDs)
	-- 6 = Rare Quality Pets (petIDs)
	-- 7 = All Pets In The Game (speciesIDs)
	settings.CollectionChartType = settings.CollectionChartType or 1
	local chartType = settings.CollectionChartType
	for i=1,10 do
		report.chart[i] = 0
	end
	local data -- data set is either petIDs or speciesIDs depending on what's being charted (see above)
	if chartType==1 or chartType==5 or chartType==6 then
		data = report.petIDs
	else
		data = report.speciesIDs
	end
	for id,hash in pairs(data) do
		local column = hash%100
		if chartType==1 or chartType==7 then
			report.chart[column] = report.chart[column] + 1
		elseif chartType==3 then
			if hash<100 then
				report.chart[column] = report.chart[column] + 1
			end
		elseif chartType==4 or chartType==2 then
			if hash>=100 then
				report.chart[column] = report.chart[column] + 1
			end
		elseif chartType==5 then
			local level = floor((hash%10000)/100)
			if level==25 then
				report.chart[column] = report.chart[column] + 1
			end
		elseif chartType==6 then
			local rarity = floor(hash/10000)
			if rarity==4 then
				report.chart[column] = report.chart[column] + 1
			end
		end
	end
	-- for percent completed (chartType 4), add up each possible chart type
	if chartType==4 then
		for i=1,10 do
			local total = 0
			for _,hash in pairs(report.speciesIDs) do
				if hash%100==i then
					total = total + 1
				end
			end
			report.chart[i] = floor(report.chart[i]*100/total+0.5) -- and divide it into count of unique pets
		end
	end
end
