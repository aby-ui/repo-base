local threshold = 1

local quality = function(...)
	local quality = -1

	for i=1, select('#', ...) do
		local itemLink = select(i, ...)

		if(itemLink) then
			local _, _, itemQuality = GetItemInfo(itemLink)

			if(itemQuality) then
				quality = math.max(quality, itemQuality)
			end
		end
	end

	if(quality > threshold) then
		return quality
	end
end

--oGlow:RegisterOptionCallback(function(db)
--	local filters = db.FilterSettings
--	if(filters and filters.quality) then
--		threshold = filters.quality
--	else
--		threshold = 1
--	end
--end)

oGlow:RegisterFilter('Quality border', 'Border', quality, [[Adds a border to the icons, indicating the quality the items have.]])
