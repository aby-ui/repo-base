--[[
	Operating under the following assumptions about how recipes are discovered:
	1) You must know the base rank of a recipe to receive higher ranked versions of it
	2) You must already know all recipes which are reagents for the recipe (No longer true in 7.1)
--]]
NomiCakesGossipButtonName = 'GossipTitleButton' -- Allow other addons to override the buttons we hook, if needed

local HookedButtons = {} -- [button] = true
local Undiscoverable = { -- List of rank 1 recipes that can't be obtained from nomi
	-- [recipeID] = recipeName,
	-- Quests
	[201513] = '掉落自|Hunit:Creature-0-0-0-0-93371-0|h[莫多维乔]|h (风暴峡湾 72.6, 50.0)', -- Bear Tartare
	[201496] = '任务：|cffffff00|Hquest:39117|h[猎隼止声]|h|r, |Hunit:Creature-0-0-0-0-94117-0|h[塞西莉·雷德克里夫]|h (瓦尔莎拉 36.0, 57.0)', -- Deep-Fried Mossgill
	[201512] = '任务：|cffffff00|Hquest:40988|h[厨师太多]|h|r, |Hunit:Creature-0-0-0-0-101846-0|h[诺米]|h (达拉然)', -- Dried Mackerel Strips
	[201498] = '任务：|cffffff00|Hquest:37727|h[调酒魔导师]|h|r, |Hunit:Creature-0-0-0-0-89341-0|h[魔导师加鲁霍德]|h (47.0, 41.4)', -- Faronaar Fizz
	[201514] = '任务：|cffffff00|Hquest:37536|h[鼓舞士气]|h|r, |Hunit:Creature-0-0-0-0-88923-0|h[尾锚]|h (阿苏纳 48.0, 48.6)', -- Fighter Chow
	[201497] = '任务：|cffffff00|Hquest:40078|h[重任]|h|r, |Hunit:Creature-0-0-0-0-92539-0|h[哈维]|h (风暴峡湾 60.2, 50.8)', -- Pickled Stormray
	[201413] = '任务：|cffffff00|Hquest:39867|h[我没说谎!]|h|r, |Hunit:Creature-0-0-0-0-95438-0|h[艾利亚斯]|h (至高岭 40.0, 52.2)', -- Salt and Pepper Shank
	[201499] = '系列任务：|cffffff00|Hquest:39789|h[过度掠食]|h|r, |Hunit:Creature-0-0-0-0-97258-0|h[欧塔萨·风蹄]|h (风暴峡湾 51.2, 57.0)', -- Spiced Rib Roast
	[201503] = '购买自|Hunit:Creature-0-0-0-0-112226-0|h[马库斯·约布克]|h(苏拉玛 71.6, 48.8)', -- Koi-Scented Stormray
	
	-- Other stuff
	[201501] = '|cff1eff00|Hitem:141011|h[食谱:海]|h|r 掉落自|Hunit:Creature-0-0-0-0-99720-0|h[海滩刺壳蟹]|h (苏拉玛 76,50) |cff1eff00|Hitem:141012|h[食谱：陆]|h|r 掉落自 |Hunit:Creature-0-0-0-0-110042-0|h[心木雄鹿]|h (苏拉玛 65,45)', -- Suramar Surf and Turf
	[201502] = '任务：|cffffff00|Hquest:40102|h[鱼人:下一代]|h|r, |Hunit:Creature-0-0-0-0-98067-0|h[国王姆嘎姆嘎]|h (至高岭 42.6, 10.8)', -- 'Barracuda Mrglgagh',
	[201500] = '掉落自|Hunit:Creature-0-0-0-0-110340-0|h[米奥妮克丝]|h (苏拉玛 40.8, 32.8)', -- Leybeque Ribs
	[201504] = '掉落自(极少)卓格巴尔 (至高岭 53.3, 62.4)', -- Drogbar-Style Salmon
}

local Requisites = { -- List of recipes you must (probably) already know in order to discover a recipe from nomi
	-- While technically you need to know the previous rank of a spell to receive the next one,
	-- we'll use the base rank as the requirement for all ranks because it's more intuitive
	-- I only want to grey-out recipes that we can't learn because we don't know the base rank
	--[[
	-- 7.1 patch notes imply that recipes no longer require knowing other recipes to learn
	[201506] = {201501}, -- Azshari Salad: Suramar Surf and Turf
	[201508] = {201503}, -- Seed-Battered Fish Plate: Kio-Scented Stormray
	[201507] = {201502}, -- Nightborne Delicacy Platter: Barracuda Mrglgagh
	[201505] = {201500}, -- The Hungry Magister: Leybeque Ribs
	[201511] = {201504}, -- Fishbrul Special: Drogbar-Style Salmon
	
	[201538] = {201511}, -- Fishbrul Special
	[201558] = {201511}, -- Fishbrul Special
	[201534] = {201505}, -- The Hungry Magister
	[201554] = {201505}, -- The Hungry Magister
	[201535] = {201506}, -- Azshari Salad
	[201555] = {201506}, -- Azshari Salad
	[201536] = {201507}, -- Nightborne Delicacy Platter
	[201556] = {201507}, -- Nightborne Delicacy Platter
	[201537] = {201508}, -- Seed-Battered Fish Plate
	[201557] = {201508}, -- Seed-Battered Fish Plate
	--]]
	
	[201515] = {201413, 201496, 201497, 201498, 201499}, -- Hearty Feast
	[201542] = {201515}, -- Hearty Feast
	[201562] = {201515}, -- Hearty Feast
	[201516] = {201500, 201501, 201502, 201503, 201504}, -- Lavish Suramar Feast
	[201543] = {201516}, -- Lavish Suramar Feast
	[201563] = {201516}, -- Lavish Suramar Feast
	
	[201531] = {201502}, -- Barracuda Mrglgagh
	[201551] = {201502}, -- Barracuda Mrglgagh
	[201533] = {201504}, -- Drogbar-Style Salmon
	[201553] = {201504}, -- Drogbar-Style Salmon
	[201539] = {201512}, -- Dried Mackerel Strips
	[201559] = {201512}, -- Dried Mackerel Strips
	[201541] = {201514}, -- Fighter Chow
	[201561] = {201514}, -- Fighter Chow
	[201530] = {201501}, -- Suramar Surf and Turf
	[201550] = {201501}, -- Suramar Surf and Turf
	[201524] = {201413}, -- Salt and Pepper Shank
	[201544] = {201413}, -- Salt and Pepper Shank
	[201526] = {201497}, -- Pickled Stormray
	[201546] = {201497}, -- Pickled Stormray
	[201532] = {201503}, -- Koi-Scented Stormray
	[201552] = {201503}, -- Koi-Scented Stormray
	[201528] = {201499}, -- Spiced Rib Roast
	[201548] = {201499}, -- Spiced Rib Roast
	[201525] = {201496}, -- Deep-Fried Mossgill
	[201545] = {201496}, -- Deep-Fried Mossgill
	[201540] = {201513}, -- Bear Tartare
	[201560] = {201513}, -- Bear Tartare
	[201529] = {201500}, -- Leybeque Ribs
	[201549] = {201500}, -- Leybeque Ribs
	[201527] = {201498}, -- Faronaar Fizz
	[201547] = {201498}, -- Faronaar Fizz
}

local IngredientList = { -- In the order they appear in Nomi's dialog options
	[124117] = {201506,201555,201544,201516,201563,201550,201524,201543,201530,201535,201515,201542,201562}, -- Lean Shank
	[124121] = {201536,201547,201562,201507,201515,201527,201542,201556}, -- Wildfowl Egg
	[124119] = {201562,201549,201542,201529,201516,201548,201505,201528,201554,201534,201543,201515,201563}, -- Big Gamy Ribs
	[124118] = {201560,201554,201534,201505,201540}, -- Fatty Bearsteak
	[124120] = {201534,201551,201536,201529,201531,201563,201505,201507,201554,201556,201543,201549,201516}, -- Leyblood
	[124107] = {201511,201561,201541,201558,201538}, -- Cursed Queenfish
	[124108] = {201525,201545,201562,201542,201515,201558,201538,201511}, -- Mossgill Perch
	[124109] = {201534,201538,201516,201533,201505,201558,201554,201511,201543,201553,201563}, -- Highmountain Salmon
	[124110] = {201532,201508,201542,201537,201516,201563,201557,201552,201546,201526,201543,201515,201562}, -- Stormray
	[124111] = {201532,201506,201508,201555,201557,201516,201563,201550,201552,201537,201543,201530,201535}, -- Runescale Koi
	[124112] = {201551,201538,201531,201563,201558,201507,201536,201556,201543,201511,201516}, -- Black Barracuda
	[133680] = {201562,201684,201542,201516,201683,201685,201543,201515,201563}, -- Slabs of Bacon
	[133607] = {201539,201557,201537,201559,201508}, -- Silver Mackerel
}

local IngredientOrder = {
	124117, -- Lean Shank
	124121, -- Wildfowl Egg
	124119, -- Big Gamy Ribs
	124118, -- Fatty Bearsteak
	124120, -- Leyblood
	124107, -- Cursed Queenfish
	124108, -- Mossgill Perch
	124109, -- Highmountain Salmon
	124110, -- Stormray
	124111, -- Runescale Koi
	124112, -- Black Barracuda
	133680, -- Slabs of Bacon
	133607, -- Silver Mackerel
}

local LocalizedIngredientList = {} -- [itemID] = {itemName, itemLink}
local TooltipInfo = {} -- [button] = {[i] = 'recipe name?'}

local function GetRank(info)
	return not info.nextRecipeID and 3 or info.previousRecipeID and 2 or 1
end

local RecipeCache = {} -- [recipeID] = info

local f = CreateFrame('frame')

local RegisteredFrames = {} -- Holds a list of frames that should be registered for TRADE_SKILL_SHOW after our addon is finished
local Callback
local function RequestCookingStuff(callback)
	Callback = callback
	if C_TradeSkillUI.GetTradeSkillLine() ~= 185 then
		RegisteredFrames = {GetFramesRegisteredForEvent('TRADE_SKILL_SHOW')}
		for _, frame in pairs(RegisteredFrames) do
			frame:UnregisterEvent('TRADE_SKILL_SHOW')
		end
		f:RegisterEvent('TRADE_SKILL_SHOW')
		-- There seems to be no other way to prevent the tradeskill ui from opening when we call this function,
		-- so we have to make SURE that the event always get re-registered or we'll break the other tradeskills
		local opened = C_TradeSkillUI.OpenTradeSkill(185)
		if not opened then
			f:UnregisterEvent('TRADE_SKILL_SHOW')
			for _, frame in pairs(RegisteredFrames) do
				frame:RegisterEvent('TRADE_SKILL_SHOW')
			end
		end
	else
		f:GetScript('OnEvent')(f, 'TRADE_SKILL_LIST_UPDATE')
	end
end

-- Cache relevent recipe info for lookups
local function CacheRecipes()
	wipe(RecipeCache)
	for ingredientItemID, recipes in pairs(IngredientList) do
		for _, recipeID in pairs(recipes) do
			RecipeCache[recipeID] = C_TradeSkillUI.GetRecipeInfo(recipeID)
		end
	end
	for _, recipes in pairs(Requisites) do
		for _, recipeID in pairs(recipes) do
			RecipeCache[recipeID] = C_TradeSkillUI.GetRecipeInfo(recipeID)
		end
	end
end

local IsNomi = false -- Are we currently interacting with Nomi?
local function DecorateNomi()
	wipe(TooltipInfo)
	
	local WorkOrders = NomiCakesDatas and NomiCakesDatas.WorkOrders
	local activeWorkOrders = {}
	if WorkOrders then -- count number of pending work orders to display on their buttons
		local now = time()
		local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, _, _, _, _, followerID = C_Garrison.GetLandingPageShipmentInfoByContainerID(122) -- can return nil if no active shipments
		local startIndex = shipmentsTotal and (#WorkOrders - shipmentsTotal + 1) or 1
		--local startIndex = not shipmentsTotal and 1 or (#WorkOrders - shipmentsTotal + shipmentsReady + 1)
		if startIndex >= 1 and shipmentsTotal then -- this can be called before WorkOrders has been populated, so account for that
			local currentIndex = startIndex + shipmentsReady
			if WorkOrders[currentIndex] then
				local timeOffset = creationTime + duration - WorkOrders[currentIndex][3] - (GetServerTime() - time())
				for i = startIndex, #WorkOrders do
					local workOrder = WorkOrders[i]
					local ingredientItemID = workOrder[1]
					local endTime = workOrder[3]
					local timeLeft = endTime - now + timeOffset
					if timeLeft > 0 and i >= currentIndex then -- still active
						if not activeWorkOrders[ingredientItemID] then
							activeWorkOrders[ingredientItemID] = 1
						else
							activeWorkOrders[ingredientItemID] = activeWorkOrders[ingredientItemID] + 1
						end
					end
				end
			end
		end
	end
	
	local i = 0
	for j = 1, #IngredientOrder do
		local ingredientItemID = IngredientOrder[j]
		local count = GetItemCount(ingredientItemID, true) or 0
		local _, _, _, _, ingredientIcon = GetItemInfoInstant(ingredientItemID)
		if count >= 5 then -- we have enough of an ingredient for nomi to display it
			i = i + 1
			local buttonName = NomiCakesGossipButtonName .. i
			local button = _G[buttonName]
			local buttonIcon = _G[buttonName .. 'GossipIcon'] -- check that the icon is for a work order, otherwise we might overwrite a quest button or something
			if button and button:IsShown() and buttonIcon and buttonIcon:GetTexture():lower() == 'interface\\gossipframe\\workordergossipicon' then
				if not HookedButtons[button] then
					button:HookScript('OnEnter', function(self)
						if not IsNomi then return end
						if TooltipInfo[self] and #TooltipInfo[self] > 0 then
							GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
							GameTooltip:AddLine('可能学到的食谱：')
							table.sort(TooltipInfo[self])
							for _, name in pairs(TooltipInfo[self]) do
								GameTooltip:AddLine(name)
							end
							GameTooltip:Show()
						end
					end)
					button:HookScript('OnLeave', function(self)
						GameTooltip_Hide()
					end)
					HookedButtons[button] = i
				end
				
				local ingredient, recipeList = LocalizedIngredientList[ingredientItemID], IngredientList[ingredientItemID]
				if ingredient and recipeList then -- and recipes then
					local unlearned = 0
					local canLearn = 0
					local ingredientName, ingredientLink = ingredient[1], ingredient[2]
					for _, recipeID in pairs(recipeList) do
						local info = RecipeCache[recipeID]
						if info and not info.learned then
							unlearned = unlearned + 1
							local learnable = true
							if Requisites[recipeID] then
								for _, requisiteID in pairs(Requisites[recipeID]) do
									-- we must know all requisites to be able to receive this item
									local requisiteInfo = RecipeCache[requisiteID] -- C_TradeSkillUI.GetRecipeInfo(requisiteID)
									if requisiteInfo and not requisiteInfo.learned then
										-- we're missing one of the requisites, can't make this
										learnable = false
										if not TooltipInfo[button] then
											TooltipInfo[button] = {}
										end
										local rank = GetRank(info)
										local name = format('|T%d:16|t |cffcccccc%s %d', info.icon, info.name, rank)
										tinsert(TooltipInfo[button], name)
										break
									end
								end
							end
							if learnable then
								canLearn = canLearn + 1
								if not TooltipInfo[button] then
									TooltipInfo[button] = {}
								end
								local rank = GetRank(info)
								local name = format('|T%d:16|t %s %d', info.icon, info.name, rank)
								tinsert(TooltipInfo[button], name)
							end
						end
					end
					--buttonIcon:SetTexture(ingredientIcon)
					local text
					if unlearned ~= 0 then
						if canLearn ~= 0 then
							--button:SetFormattedText('|T%d:16|t %d [%s] x%d', ingredientIcon, canLearn, ingredientName, count)
							text = format('|T%d:16|t %d [%s] x%d', ingredientIcon, canLearn, ingredientName, count)
						else
							-- button:SetText('|cff660000' .. canLearn .. ' [' .. ingredientName .. ']')
							--button:SetFormattedText('|T%d:16|t |cff660000%d [%s] x%d|r', ingredientIcon, canLearn, ingredientName, count)
							text = format('|T%d:16|t |cff660000%d [%s] x%d|r', ingredientIcon, canLearn, ingredientName, count)
						end
					else
						--button:SetFormattedText('|cff660000No more |T%d:16|t [%s]', ingredientIcon, ingredientName)
						text = format('|cff660000No more |T%d:16|t [%s]', ingredientIcon, ingredientName)
					end
					if text then
						if activeWorkOrders[ingredientItemID] then
							-- spell_holy_borrowedtime
							text = text .. ' |Tinterface/icons/spell_holy_borrowedtime:16|t |cff660000' .. activeWorkOrders[ingredientItemID] .. '|r'
						end
						button:SetText(text)
					end
					GossipResize(button)
				end
			else
				break
			end
		end
	end
end

f:SetScript('OnEvent', function(self, event, ...)
	if event == 'GOSSIP_SHOW' then
		local guid = UnitGUID('npc')
		if guid then
			local _, _, _, _, _, npcID = strsplit('-', guid)
			if npcID == '101846' then -- Nomi
				IsNomi = true
				RequestCookingStuff(DecorateNomi)
			end
		end
	elseif event == 'GOSSIP_CLOSED' then
		IsNomi = false
	elseif event == 'TRADE_SKILL_SHOW' then
		self:UnregisterEvent('TRADE_SKILL_SHOW')
		self:RegisterEvent('TRADE_SKILL_LIST_UPDATE')
		for _, frame in pairs(RegisteredFrames) do
			frame:RegisterEvent('TRADE_SKILL_SHOW')
		end
	elseif event == 'TRADE_SKILL_LIST_UPDATE' then
		self:UnregisterEvent('TRADE_SKILL_LIST_UPDATE')
		if Callback then
			CacheRecipes()
			Callback()
		end
		C_TradeSkillUI.CloseTradeSkill()
	elseif event == 'GET_ITEM_INFO_RECEIVED' then
		local itemID = ...
		if IngredientList[itemID] then
			local itemName, itemLink = GetItemInfo(itemID)
			LocalizedIngredientList[itemID] = {itemName, itemLink}
		end
	elseif event == 'PLAYER_LOGIN' then
		C_Garrison.RequestLandingPageShipmentInfo()
		for itemID, recipes in pairs(IngredientList) do
			local itemName, itemLink = GetItemInfo(itemID)
			if itemName and itemLink then
				LocalizedIngredientList[itemID] = {itemName, itemLink}
			end
		end
	end
end)
f:RegisterEvent('GOSSIP_SHOW')
f:RegisterEvent('GOSSIP_CLOSED')
f:RegisterEvent('GET_ITEM_INFO_RECEIVED')
f:RegisterEvent('PLAYER_LOGIN')

local function OutputRecipes()
	local results = {}
	local unavailable = {}
	for j = 1, #IngredientOrder do
		local ingredientItemID = IngredientOrder[j]
		local ingredient, recipeList = LocalizedIngredientList[ingredientItemID], IngredientList[ingredientItemID]
		if ingredient and recipeList then
			local unlearned = 0
			local canLearn = 0
			local ingredientName, ingredientLink = ingredient[1], ingredient[2]
			for _, recipeID in pairs(recipeList) do
				local info = RecipeCache[recipeID]
				if info and not info.learned then
					unlearned = unlearned + 1
					local learnable = true
					if Requisites[recipeID] then
						-- todo: figure out why this isn't ignoring multiple ranks when we don't know its prerequisite
						for _, requisiteID in pairs(Requisites[recipeID]) do
							-- we must know all requisites to be able to receive this item
							local requisiteInfo = RecipeCache[requisiteID] --C_TradeSkillUI.GetRecipeInfo(requisiteID)
							if requisiteInfo and not requisiteInfo.learned then
								-- we're missing one of the requisites, can't make this
								learnable = false
								--break
								if not info.previousRecipeID then -- this is a rank 1 recipe and we can't learn it, so there is some other requirement
									if not unavailable[recipeID] then
										unavailable[recipeID] = {}
									end
									unavailable[recipeID][requisiteID] = true
								end
							end
						end
					end
					if learnable then
						if not results[ingredientLink] then
							results[ingredientLink] = {}
						end
						--if not info.previousRecipeID or not results[ingredientLink][info.previousRecipeID] then
							results[ingredientLink][recipeID] = true
						--end
						--tinsert(results[ingredientLink], recipeID)
					end
				end
			end
		end
	end
	
	for ingredientLink, recipes in pairs(results) do
		print('|cff66ff66已经学会的|r ' .. ingredientLink .. ' |cff66ff66食谱:|r')
		--table.sort(recipes)
		for recipeID in pairs(recipes) do
			local prevRecipe = RecipeCache[recipeID].previousRecipeID
			if not prevRecipe or not recipes[prevRecipe] then -- skip higher ranks of the same item
				local recipeLink = GetSpellLink(recipeID)
				print(' |cff66ff66-|r ' .. recipeLink)
			end
		end
	end
	
	for recipeID, requisites in pairs(unavailable) do
		print('|cffffff66缺少|r ' .. GetSpellLink(recipeID) .. ' |cffffff66的前置:|r')
		for requisite in pairs(requisites) do
			--local prevRecipe = RecipeCache[recipeID].previousRecipeID
			--if not prevRecipe or not recipes[prevRecipe] then -- skip higher ranks of the same item
				local recipeLink = GetSpellLink(requisite)
				print(' |cffffff66-|r ' .. recipeLink)
			--end
		end
	end
	
	print('|cffffff66缺失的食谱（无法跟诺米学到的）:|r')
	local i = 1
	for recipeID, description in pairs(Undiscoverable) do
		local info = RecipeCache[recipeID]
		if info and not info.learned then
			print(format('%d) %s %s', i, GetSpellLink(recipeID) or ('食谱 ' .. recipeID), description or '???'))
			i = i + 1
		end
	end
end

SLASH_NOMICAKES1, SLASH_NOMICAKES2 = '/nomicakes', '/nomi'

function SlashCmdList.NOMICAKES()
	RequestCookingStuff(OutputRecipes)
end

--------------------------------------
do -- Experimental work order stuff
	local WorkOrderItemIDs = { -- cross-reference item IDs from work orders with the actual ingredient item ID
		[133877] = 124117, -- Lean Shank
		[133886] = 124121, -- Wildfowl Egg
		[133915] = 124119, -- Big Gamy Ribs
		[133914] = 124118, -- Fatty Bearsteak
		[133916] = 124120, -- Leyblood
		[133917] = 124107, -- Cursed Queenfish
		[133918] = 124108, -- Mossgill Perch
		[133919] = 124109, -- Highmountain Salmon
		[133920] = 124110, -- Stormray
		[133921] = 124111, -- Runescale Koi
		[133922] = 124112, -- Black Barracuda
		[133923] = 133680, -- Slabs of Bacon
		[141700] = 133607, -- Silver Mackerel
	}
	
	NomiCakesDatas = { WorkOrders = {} }
	local WorkOrders = NomiCakesDatas.WorkOrders -- [i] = {itemID, placementTime, endTime}
	local addonName = ...
	local ShipmentOpenTime
	local NumWorkOrdersOrdered, WorkOrderType = 0
	local f = CreateFrame('frame')
	f:SetScript('OnEvent', function(self, event, ...)
		if event == 'SHIPMENT_CRAFTER_OPENED' then
			if ... == 122 then -- we're talking to nomi
				ShipmentOpenTime = time()
				NumWorkOrdersOrdered, WorkOrderType = 0, nil
				self:RegisterEvent('SHIPMENT_UPDATE')
				self:RegisterEvent('SHIPMENT_CRAFTER_CLOSED')
				self:RegisterEvent('SHIPMENT_CRAFTER_INFO')
			else -- these events shouldn't be registered, but make absolutely certain we don't respond to them when not talking to nomi
				self:UnregisterEvent('SHIPMENT_UPDATE')
				self:UnregisterEvent('SHIPMENT_CRAFTER_CLOSED')
				self:UnregisterEvent('SHIPMENT_CRAFTER_INFO')
			end
		elseif event == 'SHIPMENT_CRAFTER_INFO' and ... then
			-- shipment information should be available at this point, record it
			self:UnregisterEvent('SHIPMENT_CRAFTER_INFO')
			local success, pendingShipments, maxShipments, ownedShipments = ...
			if maxShipments == 0 then -- nomi is bugged (no work order window), we can't fetch work order data
				print('|cffffff66诺米出BUG了，请重试!|r') -- outputting a message might confuse people, but I think it's better than nothing
				C_Garrison.CloseTradeskillCrafter() -- end interaction so we don't have to walk away from him
			else
				local now = time()
				wipe(WorkOrders)
				for i = 1, C_Garrison.GetNumPendingShipments() do
					-- "name" is not guaranteed to exist, if the item info hasn't been cached yet it will return nil, so don't bother recording it
					-- we might need to manually cache the names for all of our items using GET_ITEM_INFO_UPDATE so we can add them to the tooltip later
					local name, texture, _, itemID, _, startDelta, timeRemaining = C_Garrison.GetPendingShipmentInfo(i)
					local ingredientItemID = itemID and WorkOrderItemIDs[itemID]
					if ingredientItemID then
						local orderPlaced = now - startDelta -- time the work order was placed, not when the work order will start
						local endTime = now + timeRemaining
						-- local startTime = endTime - 14400 -- start time is end time of previous recipe, or endTime - 14400, which makes recording it kind of pointless
						-- WorkOrders[i] = {ingredientItemID, orderPlaced, endTime}
						tinsert(WorkOrders, {ingredientItemID, orderPlaced, endTime})
					else
						-- we're missing information for whatever this is supposed to be?
					end
				end
			end
		elseif event == 'SHIPMENT_UPDATE' then
			if ... then -- this will fire for each separate shipment if you queue multiple work orders at once
				local name, texture, quality, itemID, followerID, duration = C_Garrison.GetShipmentItemInfo()
				local ingredientItemID = itemID and WorkOrderItemIDs[itemID]
				if ingredientItemID then
					-- if itemID and WorkOrderItemIDs[itemID] then -- todo: sanity check if all else fails, but I would prefer this error out if something isn't working as expected
					local numWorkOrders = #WorkOrders
					local orderPlaced = time()
					local startTime = numWorkOrders > 0 and WorkOrders[numWorkOrders][3] or orderPlaced
					local endTime = startTime + duration
					--WorkOrders[ #WorkOrders + 1 ] = {ingredientItemID, orderPlaced, endTime}
					tinsert(WorkOrders, {ingredientItemID, orderPlaced, endTime})
					WorkOrderType = ingredientItemID
					NumWorkOrdersOrdered = NumWorkOrdersOrdered + 1
					-- print(GetTime(), 'SHIPMENT_UPDATE', name, itemID, duration, 'started')
					C_Garrison.RequestLandingPageShipmentInfo() -- request update for shipment info
				else
					-- missing ingredient item information for this shipment somehow
					--print('NomiCakes missing ingredient information for itemID', itemID)
				end
			end
		elseif event == 'SHIPMENT_CRAFTER_CLOSED' then -- if this event doesn't fire for some reason, we won't unregister events properly and will bug the next time the player talks to a work order npc
			-- output what work orders were placed when the window is closed
			
			-- todo: figure out how this could possibly print twice, since the event is being unregistered
			self:UnregisterEvent('SHIPMENT_UPDATE')
			self:UnregisterEvent('SHIPMENT_CRAFTER_CLOSED')
			self:UnregisterEvent('SHIPMENT_CRAFTER_INFO') -- this shouldn't be necessary
			if WorkOrderType and NumWorkOrdersOrdered > 0 then
				local itemID = WorkOrderType
				local name = LocalizedIngredientList[itemID] and LocalizedIngredientList[itemID][2] or '???'
				local _, _, _, _, ingredientIcon = GetItemInfoInstant(itemID)
				if ingredientIcon then
					name = format('|T%d:16|t %s', ingredientIcon, name)
				end
				print(format('%d |4Work Order:份订单; 份订单，食谱：%s', NumWorkOrdersOrdered, name))
				NumWorkOrdersOrdered, WorkOrderType = 0, nil
			end
		elseif event == 'ADDON_LOADED' and ... == addonName then
			self:UnregisterEvent('ADDON_LOADED')
			WorkOrders = NomiCakesDatas.WorkOrders
			if NomiCakesDatas.Version ~= 2 then
				NomiCakesDatas.Version = 2
				wipe(NomiCakesDatas.WorkOrders)
			end
			self:RegisterEvent('SHIPMENT_CRAFTER_OPENED')
		end
	end)
	f:RegisterEvent('ADDON_LOADED')
	
	local READY_FOR_PICKUP = GARRISON_LANDING_RETURN:gsub('%s*%%d%s*', '')
	local IgnoreShow = false
	GameTooltip:HookScript('OnHide', function() IgnoreShow = false end)
	hooksecurefunc(GameTooltip, 'Show', function(self)
		if IgnoreShow then return end
		local owner = self:GetOwner()
		if owner and owner.containerID == 122 and WorkOrders then -- probably should add a better check for the tooltip owner than this
			local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, _, _, _, _, followerID = C_Garrison.GetLandingPageShipmentInfoByContainerID(122)
			if not shipmentsTotal then return end
			local numWorkOrders = #WorkOrders
			local startIndex = numWorkOrders - shipmentsTotal + 1
			if startIndex <= 0 then return end
			if numWorkOrders == 0 then return end
			-- Try and account for data being desynchronized from the cache
			-- (eg. if work orders are completed from Nomi Snacks or something)
			-- Get the time difference between what the api reports for the active work order
			-- and the cache and add it to every order's end time
			-- I think "creationTime" is based on server time, so subtract the difference between GetServerTime() and time()
			-- I don't know if creationTime is updated when someone uses something to instantly complete work orders, so this may all fail miserably
			local currentIndex = startIndex + shipmentsReady -- currentIndex will be greater than numWorkOrders if all of our shipments are ready
			local timeOffset = WorkOrders[currentIndex] and (creationTime + duration - WorkOrders[currentIndex][3] - (GetServerTime() - time())) or 0
			if numWorkOrders - startIndex > 0 then
				self:AddLine(' ')
			end
			for i = startIndex, numWorkOrders do
				local workOrder = WorkOrders[i]
				local itemID, orderPlaced, endTime = workOrder[1], workOrder[2], workOrder[3]
				local name = LocalizedIngredientList[itemID] and LocalizedIngredientList[itemID][1] or '???'
				local _, _, _, _, ingredientIcon = GetItemInfoInstant(itemID)
				if ingredientIcon then
					name = format('|T%d:16|t %s', ingredientIcon, name)
				end
				local timeLeft = endTime - time() + timeOffset
				if timeLeft > 0 and i >= currentIndex then
					self:AddDoubleLine(name, SecondsToTime(timeLeft), 1, 1, 0.4, 1, 1, 0.4)
				elseif shipmentsReady > 0 then
					self:AddDoubleLine(name, READY_FOR_PICKUP, 0.4, 1, 0.4, 0.4, 1, 0.4)
				end
			end
			IgnoreShow = true
			self:Show()
		end
	end)
end
