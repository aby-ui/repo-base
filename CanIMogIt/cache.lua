CanIMogIt.cache = {}

function CanIMogIt.cache:Clear()
    self.data = {
        ["text"] = {},
        ["source"] = {},
        ["dressup_source"] = {},
        ["sets"] = {},
        ["setsSumRatio"] = {},
    }
end


local function GetSourceIDKey(sourceID)
    return "source:" .. sourceID
end


local function GetItemIDKey(itemID)
    return "item:" .. itemID
end


local function GetItemLinkKey(itemLink)
    return "itemlink:" .. itemLink
end


local function CalculateCacheKey(itemLink)
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    local itemID = CanIMogIt:GetItemID(itemLink)
    local key;
    if sourceID then
        key = GetSourceIDKey(sourceID)
    elseif itemID then
        key = GetItemIDKey(itemID)
    else
        key = GetItemLinkKey(itemLink)
    end
    return key
end


function CanIMogIt.cache:GetItemTextValue(itemLink)
    return self.data["text"][CalculateCacheKey(itemLink)]
end


function CanIMogIt.cache:SetItemTextValue(itemLink, value)
    self.data["text"][CalculateCacheKey(itemLink)] = value
end


function CanIMogIt.cache:RemoveItem(itemLink)
    self.data["text"][CalculateCacheKey(itemLink)] = nil
    self.data["source"][CalculateCacheKey(itemLink)] = nil
    -- Have to remove all of the set data, since other itemLinks may cache
    -- the same set information. Alternatively, we scan through and find
    -- the same set on other items, but they're loaded on mouseover anyway,
    -- so it shouldn't be slow. Also applies to RemoveItemBySourceID.
    self:ClearSetData()
end


function CanIMogIt.cache:RemoveItemBySourceID(sourceID)
    self.data["text"][GetSourceIDKey(sourceID)] = nil
    self.data["source"][GetSourceIDKey(sourceID)] = nil
    self:ClearSetData()
end


function CanIMogIt.cache:GetItemSourcesValue(itemLink)
    return self.data["source"][CalculateCacheKey(itemLink)]
end


function CanIMogIt.cache:SetItemSourcesValue(itemLink, value)
    self.data["source"][CalculateCacheKey(itemLink)] = value
end


function CanIMogIt.cache:GetSetsInfoTextValue(itemLink)
    return self.data["sets"][CalculateCacheKey(itemLink)]
end


function CanIMogIt.cache:SetSetsInfoTextValue(itemLink, value)
    self.data["sets"][CalculateCacheKey(itemLink)] = value
end


function CanIMogIt.cache:GetDressUpModelSource(itemLink)
    return self.data["dressup_source"][itemLink]
end

function CanIMogIt.cache:SetDressUpModelSource(itemLink, value)
    self.data["dressup_source"][itemLink] = value
end


function CanIMogIt.cache:ClearSetData()
    self.data["sets"] = {}
    self.data["setsSumRatio"] = {}
end


function CanIMogIt.cache:GetSetsSumRatioTextValue(key)
    return self.data["setsSumRatio"][key]
end


function CanIMogIt.cache:SetSetsSumRatioTextValue(key, value)
    self.data["setsSumRatio"][key] = value
end


CanIMogIt.cache:Clear()
