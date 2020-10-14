-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Group = ns.Group
local IsInstance = ns.IsInstance
local Requirement = ns.requirement.Requirement

-------------------------------------------------------------------------------
------------------------------------ NODE -------------------------------------
-------------------------------------------------------------------------------

--[[

Base class for all displayed nodes.

    label (string): Tooltip title for this node
    sublabel (string): Oneline string to display under label
    group (Group): Options group for this node (display, scale, alpha)
    icon (string|table): The icon texture to display
    alpha (float): The default alpha value for this type
    scale (float): The default scale value for this type
    minimap (bool): Should the node be displayed on the minimap
    quest (int|int[]): Quest IDs that cause this node to disappear
    questAny (boolean): Hide node if *any* quests are true (default *all*)
    questCount (boolean): Display completed quest count as rlabel
    questDeps (int|int[]): Quest IDs that must be true to appear
    requires (str): Requirement to interact or unlock (sets sublabel)
    rewards (Reward[]): Array of rewards for this node

--]]

local Node = Class('Node')

Node.label = UNKNOWN
Node.minimap = true
Node.alpha = 1
Node.scale = 1
Node.icon = "default"
Node.group = ns.groups.OTHER

function Node:Initialize(attrs)
    -- assign all attributes
    if attrs then
        for k, v in pairs(attrs) do self[k] = v end
    end

    -- normalize quest ids as tables instead of single values
    for i, key in ipairs{'quest', 'questDeps'} do
        if type(self[key]) == 'number' then self[key] = {self[key]} end
    end

    -- normalize requirements as a table
    if type(self.requires) == 'string' or IsInstance(self.requires, Requirement) then
        self.requires = {self.requires}
    end

    -- materialize group if given as a name
    if not IsInstance(self.group, Group) then
        error('group attribute must be a Group class instance: '..self.group)
    end

    -- display nodes on minimap by default
    self.minimap = self.minimap ~= false
end

--[[
Return the associated texture, scale and alpha value to pass to HandyNotes
for this node.
--]]

function Node:GetDisplayInfo(map)
    local scale = self.scale * self.group:GetScale()
    local alpha = self.alpha * self.group:GetAlpha()
    return self.icon, scale, alpha
end

--[[
Return the glow POI for this node. If the node is hovered or focused, a green
glow is applyed to help highlight the node.
--]]

function Node:GetGlow(map)
    if self._glow and (self._focus or self._hover) then
        local _, scale, alpha = self:GetDisplayInfo(map)
        self._glow.alpha = alpha
        self._glow.scale = scale
        if self._focus then
            self._glow.r, self._glow.g, self._glow.b = 0, 1, 0
        else
            self._glow.r, self._glow.g, self._glow.b = 1, 1, 0
            self._glow.a = 0.5
        end
        return self._glow
    end
end

--[[
Return the "collected" status of this node. A node is collected if all
associated rewards have been obtained (achievements, toys, pets, mounts).
--]]

function Node:IsCollected()
    if not self.rewards then return true end
    for i, reward in ipairs(self.rewards) do
        if not reward:IsObtained() then return false end
    end
    return true
end

--[[
Return true if this node should be displayed.
--]]

function Node:IsEnabled()
    -- Check prerequisites
    if not self:PrerequisiteCompleted() then return false end

    -- Check completed state
    if not ns:GetOpt('show_completed_nodes') then
        if self:IsCompleted() then return false end
    end

    return true
end

--[[
Return the prerequisite state of this node. A node has its prerequisites met if
all quests defined in the `questDeps` attribute are completed. This method can
be overridden to check for other prerequisite criteria.
--]]

function Node:PrerequisiteCompleted()
    -- Prerequisite not met if any dependent quest ids are false
    if not self.questDeps then return true end
    for i, quest in ipairs(self.questDeps) do
        if not C_QuestLog.IsQuestFlaggedCompleted(quest) then return false end
    end
    return true
end

--[[
Return the "completed" state of this node. A node is completed if any or all
associated quests have been completed. The behavior of any vs all is switched
with the `questAny` attribute. This method can also be overridden to check for
some other form of completion, such as an achievement criteria.

This method is *not* called if the "Show completed" setting is enabled.
--]]

function Node:IsCompleted()
    if self.quest and self.questAny then
        -- Completed if *any* attached quest ids are true
        for i, quest in ipairs(self.quest) do
            if C_QuestLog.IsQuestFlaggedCompleted(quest) then return true end
        end
    elseif self.quest then
        -- Completed only if *all* attached quest ids are true
        for i, quest in ipairs(self.quest) do
            if not C_QuestLog.IsQuestFlaggedCompleted(quest) then return false end
        end
        return true
    end
    return false
end

--[[
Prepare this node for display by fetching localization information for anything
referenced in the text attributes of this node. This method is called when a
world map containing this node is opened.
--]]

function Node:Prepare()
    -- initialize icon from string name
    if type(self.icon) == 'string' then
        self.icon = ns.icons[self.icon] or ns.icons.default
    end

    -- initialize glow POI (if glow icon available)
    if type(self.icon) == 'table' and self.icon.glow and ns.glows[self.icon.glow] then
        local Glow = self.GlowClass or ns.poi.Glow
        self._glow = Glow({ icon=ns.glows[self.icon.glow] })
    end

    ns.NameResolver:Prepare(self.label)
    ns.PrepareLinks(self.sublabel)
    ns.PrepareLinks(self.note)
end

--[[
Render this node onto the given tooltip. Many features are optional depending
on the attributes set on this specific node, such as setting an `rlabel` or
`sublabel` value.
--]]

function Node:Render(tooltip)
    -- render the label text with NPC names resolved
    tooltip:SetText(ns.NameResolver:Resolve(self.label))

    local color, text
    local rlabel = self.rlabel or ''

    if self.questCount and self.quest and #self.quest then
        -- set rlabel to a (completed / total) display for quest ids
        local count = 0
        for i, quest in ipairs(self.quest) do
            if C_QuestLog.IsQuestFlaggedCompleted(quest) then
                count = count + 1
            end
        end
        color = (count == #self.quest) and ns.status.Green or ns.status.Gray
        rlabel = rlabel..' '..color(tostring(count)..'/'..#self.quest)
    end

    if self.pois then
        -- add an rlabel hint to use left-mouse to focus the node
        local focus = ns.icons.left_mouse:link(12)..ns.status.Gray(L["focus"])
        rlabel = (#rlabel > 0) and focus..' '..rlabel or focus
    end

    -- render top-right label text
    if #rlabel > 0 then
        local rtext = _G[tooltip:GetName()..'TextRight1']
        rtext:SetTextColor(1, 1, 1)
        rtext:SetText(rlabel)
        rtext:Show()
    end

    -- optional text directly under label
    if self.sublabel then
        tooltip:AddLine(ns.RenderLinks(self.sublabel, true), 1, 1, 1)
    end

    -- display item, spell or other requirements
    if self.requires then
        for i, req in ipairs(self.requires) do
            if IsInstance(req, Requirement) then
                color = req:IsMet() and ns.color.White or ns.color.Red
                text = color(L["Requires"]..' '..req:GetText())
            else
                text = ns.color.Red(L["Requires"]..' '..req)
            end
            tooltip:AddLine(ns.RenderLinks(text, true))
        end
    end

    -- additional text for the node to describe how to interact with the
    -- object or summon the rare
    if self.note and ns:GetOpt('show_notes') then
        if self.requires or self.sublabel then tooltip:AddLine(" ") end
        tooltip:AddLine(ns.RenderLinks(self.note), 1, 1, 1, true)
    end

    -- all rewards (achievements, pets, mounts, toys, quests) that can be
    -- collected or completed from this node
    if self.rewards and ns:GetOpt('show_loot') then
        local firstAchieve, firstOther = true, true
        for i, reward in ipairs(self.rewards) do

            -- Add a blank line between achievements and other rewards
            local isAchieve = IsInstance(reward, ns.reward.Achievement)
            local isSpacer = IsInstance(reward, ns.reward.Spacer)
            if isAchieve and firstAchieve then
                tooltip:AddLine(" ")
                firstAchieve = false
            elseif not (isAchieve or isSpacer) and firstOther then
                tooltip:AddLine(" ")
                firstOther = false
            end

            reward:Render(tooltip)
        end
    end
end

-------------------------------------------------------------------------------
------------------------------------ CAVE -------------------------------------
-------------------------------------------------------------------------------

local Cave = Class('Cave', Node, {
    icon = 'door_down',
    scale = 1.2,
    group = ns.groups.CAVE
})

function Cave:Initialize(attrs)
    Node.Initialize(self, attrs)

    if self.parent == nil then
        error('One or more parent nodes are required for Cave nodes')
    elseif IsInstance(self.parent, Node) then
        -- normalize parent nodes as tables instead of single values
        self.parent = {self.parent}
    end
end

function Cave:IsEnabled()
    local function HasEnabledParent()
        for i, parent in ipairs(self.parent) do
            if parent:IsEnabled() then
                return true
            end
        end
        return false
    end

    -- Check if all our parents are hidden
    if not HasEnabledParent() then return false end

    return Node.IsEnabled(self)
end

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local Intro = Class('Intro', Node, {
    icon = 'quest_yellow',
    scale = 3,
    group = ns.groups.INTRO,
})

-------------------------------------------------------------------------------
------------------------------------- NPC -------------------------------------
-------------------------------------------------------------------------------

local NPC = Class('NPC', Node)

function NPC:Initialize(attrs)
    Node.Initialize(self, attrs)
    if not self.id then error('id required for NPC nodes') end
end

function NPC.getters:label()
    return ("unit:Creature-0-0-0-0-%d"):format(self.id)
end

-------------------------------------------------------------------------------
---------------------------------- PETBATTLE ----------------------------------
-------------------------------------------------------------------------------

local PetBattle = Class('PetBattle', NPC, {
    icon = 'paw_yellow',
    scale = 1.2,
    group = ns.groups.PETBATTLE
})

-------------------------------------------------------------------------------
------------------------------------ QUEST ------------------------------------
-------------------------------------------------------------------------------

local Quest = Class('Quest', Node, {
    note = AVAILABLE_QUEST,
    group = ns.groups.QUEST
})

function Quest:Initialize(attrs)
    Node.Initialize(self, attrs)
    C_QuestLog.GetTitleForQuestID(self.quest[1]) -- fetch info from server
end

function Quest.getters:icon()
    return self.daily and 'quest_blue' or 'quest_yellow'
end

function Quest.getters:label()
    return C_QuestLog.GetTitleForQuestID(self.quest[1])
end

-------------------------------------------------------------------------------
------------------------------------ RARE -------------------------------------
-------------------------------------------------------------------------------

local Rare = Class('Rare', NPC, {
    scale = 1.2,
    group = ns.groups.RARE
})

function Rare.getters:icon()
    return self:IsCollected() and 'skull_white' or 'skull_blue'
end

function Rare:IsEnabled()
    if ns:GetOpt('hide_done_rares') and self:IsCollected() then return false end
    return NPC.IsEnabled(self)
end

function Rare:GetGlow(map)
    local glow = NPC.GetGlow(self, map)
    if glow then return glow end

    if ns:GetOpt('development') and not self.quest then
        local _, scale, alpha = self:GetDisplayInfo(map)
        self._glow.alpha = alpha
        self._glow.scale = scale
        self._glow.r, self._glow.g, self._glow.b = 1, 0, 0
        return self._glow
    end
end

-------------------------------------------------------------------------------
---------------------------------- TREASURE -----------------------------------
-------------------------------------------------------------------------------

local Treasure = Class('Treasure', Node, {
    icon = 'chest_gray',
    scale = 1.3,
    group = ns.groups.TREASURE
})

function Treasure.getters:label()
    if not self.rewards then return UNKNOWN end
    for i, reward in ipairs(self.rewards) do
        if IsInstance(reward, ns.reward.Achievement) then
            return GetAchievementCriteriaInfoByID(reward.id, reward.criteria[1].id)
        end
    end
    return UNKNOWN
end

function Treasure:GetGlow(map)
    local glow = Node.GetGlow(self, map)
    if glow then return glow end

    if ns:GetOpt('development') and not self.quest then
        local _, scale, alpha = self:GetDisplayInfo(map)
        self._glow.alpha = alpha
        self._glow.scale = scale
        self._glow.r, self._glow.g, self._glow.b = 1, 0, 0
        return self._glow
    end
end

-------------------------------------------------------------------------------
----------------------------------- SUPPLY ------------------------------------
-------------------------------------------------------------------------------

local Supply = Class('Supply', Treasure, {
    icon = 'star_chest',
    scale = 2,
    group = ns.groups.SUPPLY
})

-------------------------------------------------------------------------------

ns.node = {
    Node=Node,
    Cave=Cave,
    Intro=Intro,
    NPC=NPC,
    PetBattle=PetBattle,
    Quest=Quest,
    Rare=Rare,
    Supply=Supply,
    Treasure=Treasure
}
