local ADDON_NAME, ns = ...

-------------------------------------------------------------------------------
------------------------------ DATAMINE TOOLTIP -------------------------------
-------------------------------------------------------------------------------

local NameResolver = CreateFrame("GameTooltip", ADDON_NAME.."_NameResolver",
    UIParent, "GameTooltipTemplate")

NameResolver.cache = {}
NameResolver.prepared = {}

NameResolver:SetOwner(UIParent, "ANCHOR_NONE")
NameResolver:HookScript("OnTooltipSetUnit", function(self)
    local callback = self.callback
    if callback then
        local name = _G[self:GetName().."TextLeft1"]:GetText()
        self.cache[self.link] = name
        self.callback = nil
        self.link = nil
        callback(name)
    end
end)

function NameResolver:GetCachedName (link)
    if self:IsLink(link) then
        return self.cache[link] or UNKNOWN
    end
    return link
end

function NameResolver:IsLink (link)
    if link == nil then return link end
    return strsub(link, 1, 5) == 'unit:'
end

function NameResolver:Prepare (link)
    if self:IsLink(link) and not (self.cache[link] or self.prepared[link]) then
        self:SetHyperlink(link)
        self.prepared[link] = true
    end
end

function NameResolver:Resolve (link, callback)
    -- may be passed a raw name or a hyperlink to be resolved
    if self:IsLink(link) then
        local name = self.cache[link]
        if name and name ~= '' then
            callback(name)
        else
            self.link = link
            self.callback = callback
            self:SetHyperlink(link)
        end
    else
        callback(link)
    end
end

-------------------------------------------------------------------------------

ns.NameResolver = NameResolver
