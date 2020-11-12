-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

local Class = ns.Class
local L = ns.locale

local Green = ns.status.Green
local Orange = ns.status.Orange
local Red = ns.status.Red

-------------------------------------------------------------------------------
----------------------------------- REWARD ------------------------------------
-------------------------------------------------------------------------------

local Reward = Class('Reward')

function Reward:Initialize(attrs)
    if attrs then
        for k, v in pairs(attrs) do self[k] = v end
    end
end

function Reward:IsEnabled()
    if self.class and self.class ~= ns.class then return false end
    if self.faction and self.faction ~= ns.faction then return false end
    return true
end

function Reward:IsObtained()
    return true
end

function Reward:Render(tooltip)
    tooltip:AddLine('Render not implemented: '..tostring(self))
end

-------------------------------------------------------------------------------
----------------------------------- SECTION -----------------------------------
-------------------------------------------------------------------------------

local Section = Class('Section', Reward)

function Section:Initialize(title)
    self.title = title
end

function Section:Render(tooltip)
    tooltip:AddLine(self.title..':')
    tooltip:AddLine(' ')
end

-------------------------------------------------------------------------------
----------------------------------- SPACER ------------------------------------
-------------------------------------------------------------------------------

local Spacer = Class('Spacer', Reward)

function Spacer:Render(tooltip)
    tooltip:AddLine(' ')
end

-------------------------------------------------------------------------------
--------------------------------- ACHIEVEMENT ---------------------------------
-------------------------------------------------------------------------------

-- /run print(GetAchievementCriteriaInfo(ID, NUM))

local Achievement = Class('Achievement', Reward)
local GetCriteriaInfo = function (id, criteria)
    local results = {GetAchievementCriteriaInfoByID(id, criteria)}
    if not results[1] then
        if criteria <= GetAchievementNumCriteria(id) then
            results = {GetAchievementCriteriaInfo(id, criteria)}
        else
            ns.Error('unknown achievement criteria ('..id..', '..criteria..')')
            return UNKNOWN
        end
    end
    return unpack(results)
end

function Achievement:Initialize(attrs)
    Reward.Initialize(self, attrs)
    self.criteria = ns.AsIDTable(self.criteria)
end

function Achievement:IsObtained()
    local _,_,_,completed,_,_,_,_,_,_,_,_,earnedByMe = GetAchievementInfo(self.id)
    completed = completed and (not ns:GetOpt('use_char_achieves') or earnedByMe)
    if completed then return true end
    if self.criteria then
        for i, c in ipairs(self.criteria) do
            local _, _, completed = GetCriteriaInfo(self.id, c.id)
            if not completed then return false end
        end
        return true
    end
    return false
end

function Achievement:Render(tooltip)
    local _,name,_,_,_,_,_,_,_,icon = GetAchievementInfo(self.id)
    local completed = self:IsObtained()
    if self.criteria and not self.oneline then
        tooltip:AddLine(ACHIEVEMENT_COLOR_CODE..'['..name..']|r')
        tooltip:AddTexture(icon, {margin={right=2}})
        for i, c in ipairs(self.criteria) do
            local cname,_,ccomp,qty,req = GetCriteriaInfo(self.id, c.id)
            if (cname == '' or c.qty) then
                cname = c.suffix or cname
                cname = (completed and req..'/'..req or qty..'/'..req)..' '..cname
            end

            local r, g, b = .6, .6, .6
            local ctext = "   • "..cname
            if (completed or ccomp) then
                r, g, b = 0, 1, 0
            end

            local note, status = c.note
            if c.quest then
                if C_QuestLog.IsQuestFlaggedCompleted(c.quest) then
                    status = ns.status.Green(L['defeated'])
                else
                    status = ns.status.Red(L['undefeated'])
                end
                note = note and (note..'  '..status) or status
            end

            if note then
                tooltip:AddDoubleLine(ctext, note, r, g, b)
            else
                tooltip:AddLine(ctext, r, g, b)
            end
        end
    else
        local status = completed and Green(L['completed']) or Red(L['incomplete'])
        tooltip:AddDoubleLine(ACHIEVEMENT_COLOR_CODE..'['..name..']|r', status)
        tooltip:AddTexture(icon, {margin={right=2}})
    end
end

-------------------------------------------------------------------------------
------------------------------------ ITEM -------------------------------------
-------------------------------------------------------------------------------

local Item = Class('Item', Reward)

function Item:Initialize(attrs)
    Reward.Initialize(self, attrs)

    if not self.item then
        error('Item() reward requires an item id to be set')
    end
    self.itemLink = L["retrieving"]
    self.itemIcon = 'Interface\\Icons\\Inv_misc_questionmark'
    local item = _G.Item:CreateFromItemID(self.item)
    if not item:IsItemEmpty() then
        item:ContinueOnItemLoad(function()
            self.itemLink = item:GetItemLink()
            self.itemIcon = item:GetItemIcon()
        end)
    end
end

function Item:IsObtained()
    if self.quest then return C_QuestLog.IsQuestFlaggedCompleted(self.quest) end
    return true
end

function Item:Render(tooltip)
    local text = self.itemLink
    local status = ''
    if self.quest then
        local completed = C_QuestLog.IsQuestFlaggedCompleted(self.quest)
        status = completed and Green(L['completed']) or Red(L['incomplete'])
    elseif self.weekly then
        local completed = C_QuestLog.IsQuestFlaggedCompleted(self.weekly)
        status = completed and Green(L['weekly']) or Red(L['weekly'])
    end

    if self.note then
        text = text..' ('..self.note..')'
    end
    tooltip:AddDoubleLine(text, status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------
------------------------------------ MOUNT ------------------------------------
-------------------------------------------------------------------------------

-- /run for i,m in ipairs(C_MountJournal.GetMountIDs()) do if (C_MountJournal.GetMountInfoByID(m) == "NAME") then print(m) end end

local Mount = Class('Mount', Item)

function Mount:IsObtained()
    return select(11, C_MountJournal.GetMountInfoByID(self.id))
end

function Mount:Render(tooltip)
    local collected = select(11, C_MountJournal.GetMountInfoByID(self.id))
    local status = collected and Green(L["known"]) or Red(L["missing"])
    local text = self.itemLink..' ('..L["mount"]..')'

    if self.note then
        text = text..' ('..self.note..')'
    end

    tooltip:AddDoubleLine(text, status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------
------------------------------------- PET -------------------------------------
-------------------------------------------------------------------------------

-- /run print(C_PetJournal.FindPetIDByName("NAME"))

local Pet = Class('Pet', Item)

function Pet:Initialize(attrs)
    if attrs.item then
        Item.Initialize(self, attrs)
    else
        Reward.Initialize(self, attrs)
        local name, icon = C_PetJournal.GetPetInfoBySpeciesID(self.id)
        self.itemIcon = icon
        self.itemLink = '|cff1eff00['..name..']|r'
    end
end

function Pet:IsObtained()
    return C_PetJournal.GetNumCollectedInfo(self.id) > 0
end

function Pet:Render(tooltip)
    local n, m = C_PetJournal.GetNumCollectedInfo(self.id)
    local text = self.itemLink..' ('..L["pet"]..')'
    local status = (n > 0) and Green(n..'/'..m) or Red(n..'/'..m)

    if self.note then
        text = text..' ('..self.note..')'
    end

    tooltip:AddDoubleLine(text, status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------
------------------------------------ QUEST ------------------------------------
-------------------------------------------------------------------------------

local Quest = Class('Quest', Reward)

function Quest:Initialize(attrs)
    Reward.Initialize(self, attrs)
    if type(self.id) == 'number' then
        self.id = {self.id}
    end
    C_QuestLog.GetTitleForQuestID(self.id[1]) -- fetch info from server
end

function Quest:IsObtained()
    for i, id in ipairs(self.id) do
        if not C_QuestLog.IsQuestFlaggedCompleted(id) then return false end
    end
    return true
end

function Quest:Render(tooltip)
    local name = C_QuestLog.GetTitleForQuestID(self.id[1])

    local status
    if #self.id == 1 then
        local completed = C_QuestLog.IsQuestFlaggedCompleted(self.id[1])
        status = completed and Green(L['completed']) or Red(L['incomplete'])
    else
        local count = 0
        for i, id in ipairs(self.id) do
            if C_QuestLog.IsQuestFlaggedCompleted(id) then count = count + 1 end
        end
        status = count..'/'..#self.id
        status = (count == #self.id) and Green(status) or Red(status)
    end

    local line = ns.GetIconLink('quest_ay', 13)..' '..(name or UNKNOWN)
    tooltip:AddDoubleLine(line, status)
end

-------------------------------------------------------------------------------
------------------------------------ SPELL ------------------------------------
-------------------------------------------------------------------------------

local Spell = Class('Spell', Item)

function Spell:IsObtained()
    return IsSpellKnown(self.spell)
end

function Spell:Render(tooltip)
    local collected = IsSpellKnown(self.spell)
    local status = collected and Green(L["known"]) or Red(L["missing"])
    tooltip:AddDoubleLine(self.itemLink..' ('..L["spell"]..')', status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------
------------------------------------- TOY -------------------------------------
-------------------------------------------------------------------------------

local Toy = Class('Toy', Item)

function Toy:IsObtained()
    return PlayerHasToy(self.item)
end

function Toy:Render(tooltip)
    local collected = PlayerHasToy(self.item)
    local status = collected and Green(L["known"]) or Red(L["missing"])
    tooltip:AddDoubleLine(self.itemLink..' ('..L["toy"]..')', status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------
---------------------------------- TRANSMOG -----------------------------------
-------------------------------------------------------------------------------

local Transmog = Class('Transmog', Item)
local CTC = C_TransmogCollection

function Transmog:IsObtained()
    -- Check if the player knows the appearance
    if CTC.PlayerHasTransmog(self.item) then return true end

    -- Verify the item drops for any of the players specs
    local specs = GetItemSpecInfo(self.item)
    if type(specs) == 'table' and #specs == 0 then return true end

    -- Verify the player can learn the item's appearance
    local sourceID = select(2, CTC.GetItemInfo(self.item))
    if sourceID then
        local infoReady, canCollect = CTC.PlayerCanCollectSource(sourceID)
        if infoReady and not canCollect then return true end
    end

    return false
end

function Transmog:Render(tooltip)
    local collected = CTC.PlayerHasTransmog(self.item)
    local status = collected and Green(L["known"]) or Red(L["missing"])

    if not collected then
        -- check if we can't learn this item
        local sourceID = select(2, CTC.GetItemInfo(self.item))
        if not (sourceID and select(2, CTC.PlayerCanCollectSource(sourceID))) then
            status = Orange(L["unlearnable"])
        else
            -- check if the item doesn't drop
            local specs = GetItemSpecInfo(self.item)
            if type(specs) == 'table' and #specs == 0 then
                status = Orange(L["unobtainable"])
            end
        end
    end

    local suffix = ' ('..L[self.slot]..')'
    if self.note then
        suffix = suffix..' ('..self.note..')'
    end

    tooltip:AddDoubleLine(self.itemLink..suffix, status)
    tooltip:AddTexture(self.itemIcon, {margin={right=2}})
end

-------------------------------------------------------------------------------

ns.reward = {
    Reward=Reward,
    Section=Section,
    Spacer=Spacer,
    Achievement=Achievement,
    Item=Item,
    Mount=Mount,
    Pet=Pet,
    Quest=Quest,
    Spell=Spell,
    Toy=Toy,
    Transmog=Transmog
}
