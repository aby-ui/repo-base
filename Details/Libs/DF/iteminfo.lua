
local detailsFramework = _G["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

--namespace
detailsFramework.Items = {}

local containerAPIVersion = 1
if (detailsFramework.IsDragonflightAndBeyond()) then
    containerAPIVersion = 2
end

function detailsFramework.Items.GetContainerItemInfo(containerIndex, slotIndex)
	if (containerAPIVersion == 2 and C_Container and C_Container.GetContainerItemInfo) then
		local itemInfo = C_Container.GetContainerItemInfo(containerIndex, slotIndex)
		return itemInfo.iconFileID, itemInfo.stackCount, itemInfo.isLocked, itemInfo.quality, itemInfo.isReadable, itemInfo.hasLoot, itemInfo.hyperlink, itemInfo.isFiltered, itemInfo.hasNoValue, itemInfo.itemID, itemInfo.isBound
	else
		return GetContainerItemInfo(containerIndex, slotIndex)
	end
end

function detailsFramework.Items.IsItemSoulbound(containerIndex, slotIndex)
    local bIsBound = select(11, detailsFramework.Items.GetContainerItemInfo(containerIndex, slotIndex))
    return bIsBound
end
