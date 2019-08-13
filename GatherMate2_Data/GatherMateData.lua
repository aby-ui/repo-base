-- nearby check yes/no? slowdown may be an isue if someone leaves the mod enabled and always replace node
local GatherMateData = LibStub("AceAddon-3.0"):NewAddon("GatherMate2_Data")
local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
GatherMateData.generatedVersion = "469"
local bcZones = {
	[94] = true,
	[95] = true,
	[97] = true,
	[100] = true,
	[102] = true,
	[103] = true,
	[104] = true,
	[105] = true,
	[106] = true,
	[107] = true,
	[108] = true,
	[109] = true,
	[110] = true,
	[111] = true,
	[122] = true,
}

local wrathZones = {
	[114] = true,
	[115] = true,
	[116] = true,
	[117] = true,
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[123] = true,
	[125] = true,
	[126] = true,
	[127] = true,
	[170] = true,
}

local cataZones = {
	[174] = true,
	[175] = true,
	[176] = true,
	[177] = true,
	[178] = true,
	[194] = true,
	[198] = true,
	[203] = true,
	[204] = true,
	[205] = true,
	[207] = true,
	[208] = true,
	[209] = true,
	[217] = true,
	[218] = true,
	[241] = true,
	[244] = true,
	[245] = true,
	[276] = true,
}

local mistsZones = {
	[371] = true,
	[376] = true,
	[379] = true,
	[388] = true,
	[390] = true,
	[418] = true,
	[422] = true,
	[433] = true,
	[504] = true,
	[507] = true,
	[516] = true,
	[554] = true,
}

local wodZones = {
	[525] = true,
	[534] = true,
	[535] = true,
	[539] = true,
	[542] = true,
	[543] = true,
	[550] = true,
	[572] = true,
	[577] = true,
	[582] = true,
	[588] = true,
	[589] = true,
	[590] = true,
	[622] = true,
	[624] = true,
}

local legionZones = {
	[627] = true,
	[628] = true,
	[630] = true,
	[634] = true,
	[641] = true,
	[646] = true,
	[650] = true,
	[680] = true,
	[790] = true,
	[830] = true,
	[882] = true,
	[885] = true,
}

local bfaZones = {
	[862] = true,
	[863] = true,
	[864] = true,
	[895] = true,
	[896] = true,
	[942] = true,
	[1161] = true,
	[1165] = true,
	[1355] = true,
	[1462] = true,
}

function GatherMateData:PerformMerge(dbs,style, zoneFilter)
	local filter = nil
	if zoneFilter and type(zoneFilter) == "string" then
		if zoneFilter == "TBC" then
			filter = bcZones
		elseif zoneFilter == "WRATH" then
			filter = wrathZones
		elseif zoneFilter == "CATACLYSM" then
			filter = cataZones
		elseif zoneFilter == "MISTS" then
			filter = mistsZones
		elseif zoneFilter == "WOD" then
			filter = wodZones
		elseif zoneFilter == "LEGION" then
			filter = legionZones
		elseif zoneFilter == "BFA" then
			filter = bfaZones
		end
	end
	if dbs["Mines"]    then self:MergeMines(style ~= "Merge",filter) end
	if dbs["Herbs"]    then self:MergeHerbs(style ~= "Merge",filter) end
	if dbs["Gases"]    then self:MergeGases(style ~= "Merge",filter) end
	if dbs["Fish"]     then self:MergeFish(style ~= "Merge",filter) end
	if dbs["Treasure"] then self:MergeTreasure(style ~= "Merge",filter) end
	if dbs["Archaeology"] then self:MergeArchaelogy(style ~= "Merge",filter) end
	self:CleanupImportData()
	GatherMate:SendMessage("GatherMateData2Import")
	--GatherMate:CleanupDB()
end
-- Insert mining data
function GatherMateData:MergeMines(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Mining") end
	for zoneID, node_table in pairs(GatherMateData2MineDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Mining", nodeID)
			end
		end
	end
end

-- herbs
function GatherMateData:MergeHerbs(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Herb Gathering") end
	for zoneID, node_table in pairs(GatherMateData2HerbDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Herb Gathering", nodeID)
			end
		end
	end
end

-- gases
function GatherMateData:MergeGases(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Extract Gas") end
	for zoneID, node_table in pairs(GatherMateData2GasDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Extract Gas", nodeID)
			end
		end
	end
end

-- fish
function GatherMateData:MergeFish(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Fishing") end
	for zoneID, node_table in pairs(GatherMateData2FishDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Fishing", nodeID)
			end
		end
	end
end
function GatherMateData:MergeTreasure(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Treasure") end
	for zoneID, node_table in pairs(GatherMateData2TreasureDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Treasure", nodeID)
			end
		end
	end
end
function GatherMateData:MergeArchaelogy(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Archaeology") end
	for zoneID, node_table in pairs(GatherMateData2ArchaeologyDB) do
		if not zoneFilter or zoneFilter[zoneID] then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode2(zoneID,coord,"Archaeology", nodeID)
			end
		end
	end
end


function GatherMateData:CleanupImportData()
	GatherMateData2HerbDB = nil
	GatherMateData2MineDB = nil
	GatherMateData2GasDB = nil
	GatherMateData2FishDB = nil
	GatherMateData2TreasureDB = nil
	GatherMateData2ArchaeologyDB = nil
end
