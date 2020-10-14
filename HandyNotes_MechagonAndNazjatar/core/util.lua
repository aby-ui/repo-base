local ADDON_NAME, ns = ...

-------------------------------------------------------------------------------
------------------------------ DATAMINE TOOLTIP -------------------------------
-------------------------------------------------------------------------------

local function CreateDatamineTooltip (name)
    local f = CreateFrame("GameTooltip", name, UIParent, "GameTooltipTemplate")
    f:SetOwner(UIParent, "ANCHOR_NONE")
    return f
end

local NameResolver = {
    cache = {},
    prepared = {},
    preparer = CreateDatamineTooltip(ADDON_NAME.."_NamePreparer"),
    resolver = CreateDatamineTooltip(ADDON_NAME.."_NameResolver")
}

function NameResolver:IsLink (link)
    if link == nil then return link end
    return strsub(link, 1, 5) == 'unit:'
end

function NameResolver:Prepare (link)
    if self:IsLink(link) and not (self.cache[link] or self.prepared[link]) then
        -- use a separate tooltip to spam load NPC names, doing this with the
        -- main tooltip can sometimes cause it to become unresponsive and never
        -- update its text until a reload
        self.preparer:SetHyperlink(link)
        self.prepared[link] = true
    end
end

function NameResolver:Resolve (link)
    -- may be passed a raw name or a hyperlink to be resolved
    if not self:IsLink(link) then return link or UNKNOWN end

    -- all npcs must be prepared ahead of time to avoid breaking the resolver
    if not self.prepared[link] then
        ns.Debug('ERROR: npc link not prepared:', link)
    end

    local name = self.cache[link]
    if name == nil then
        self.resolver:SetHyperlink(link)
        name = _G[self.resolver:GetName().."TextLeft1"]:GetText() or UNKNOWN
        if name == UNKNOWN then
            ns.Debug('NameResolver returned UNKNOWN, recreating tooltip ...')
            self.resolver = CreateDatamineTooltip(ADDON_NAME.."_NameResolver")
        else
            self.cache[link] = name
        end
    end
    return name
end

-------------------------------------------------------------------------------
-------------------------------- LINK RENDERER --------------------------------
-------------------------------------------------------------------------------

local function PrepareLinks(str)
    if not str then return end
    for type, id in str:gmatch('{(%l+):(%w+)}') do
        -- NOTE: no prep apprears to be necessary for currencies
        if type == 'npc' then
            NameResolver:Prepare(("unit:Creature-0-0-0-0-%d"):format(id))
        elseif type == 'item' then
            GetItemInfo(tonumber(id)) -- prime item info
        elseif type == 'quest' then
            C_QuestLog.GetTitleForQuestID(tonumber(id)) -- prime quest title
        elseif type == 'spell' then
            GetSpellInfo(tonumber(id)) -- prime spell info
        end
    end
end

local function RenderLinks(str, nameOnly)
    return str:gsub('{(%l+):([^}]+)}', function (type, id)
        if type == 'npc' then
            local name = NameResolver:Resolve(("unit:Creature-0-0-0-0-%d"):format(id))
            if nameOnly then return name end
            return ns.color.NPC(name)
        elseif type == 'achievement' then
            if nameOnly then
                local _, name = GetAchievementInfo(tonumber(id))
                if name then return name end
            else
                local link = GetAchievementLink(tonumber(id))
                if link then return link end
            end
        elseif type == 'currency' then
            local info = C_CurrencyInfo.GetCurrencyInfo(tonumber(id))
            if info then
                if nameOnly then return info.name end
                local link = C_CurrencyInfo.GetCurrencyLink(tonumber(id), 0)
                if link then
                    return '|T'..info.iconFileID..':0:0:1:-1|t '..link
                end
            end
        elseif type == 'item' then
            local name, link, _, _, _, _, _, _, _, icon = GetItemInfo(tonumber(id))
            if link and icon then
                if nameOnly then return name end
                return '|T'..icon..':0:0:1:-1|t '..link
            end
        elseif type == 'quest' then
            local name = C_QuestLog.GetTitleForQuestID(tonumber(id))
            if name then
                return ns.icons.quest_yellow:link(12)..ns.color.Yellow(name)
            end
        elseif type == 'spell' then
            local name, _, icon = GetSpellInfo(tonumber(id))
            if name and icon then
                if nameOnly then return name end
                local spell = ns.color.Spell('|Hspell:'..id..'|h['..name..']|h')
                return '|T'..icon..':0:0:1:-1|t '..spell
            end
        elseif type == 'wq' then
            return ns.icons.world_quest:link(16)..ns.color.Yellow(id)
        end
        return type..'+'..id
    end)
end

-------------------------------------------------------------------------------

ns.NameResolver = NameResolver
ns.PrepareLinks = PrepareLinks
ns.RenderLinks = RenderLinks
