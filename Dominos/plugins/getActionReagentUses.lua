-- GetActionReagentUses
-- An API to figure out how many times you can cast a spell that requires reagents
local _, Addon = ...
if not Addon:IsBuild('classic') then
    return
end

-- a map of spells to necessary reagents
-- spells that use a single reagent are specified like this:
-- [spellID] = itemID
-- spells that use more than one reagent are specified like this:
-- [spellID] = {itemID1, quantity1, itemID2, quantity2, ...}
local SPELL_REAGENTS = {
    -- Druid
    -- Gift of the Wild
    [21849] = 17021,
    [21850] = 17026,
    -- Rebirth
    [20484] = 17034,
    [20739] = 17035,
    [20742] = 17036,
    [20747] = 17037,
    [20748] = 17038,
    -- Mage
    -- Arcane Brilliance
    [23028] = 17020,
    -- Portal: Darnassus
    [11419] = 17032,
    -- Portal: Ironforge
    [11416] = 17032,
    -- Portal: Orgrimmar
    [11417] = 17032,
    -- Portal: Stormwind
    [10059] = 17032,
    -- Portal: Thunder Bluff
    [11420] = 17032,
    -- Portal: Undercity
    [11418] = 17032,
    -- Slow Fall
    [130] = 17056,
    -- Teleport: Darnassus
    [3565] = 17031,
    -- Teleport: Ironforge
    [3562] = 17031,
    -- Teleport: Orgrimmar
    [3567] = 17031,
    -- Teleport: Stormwind
    [3561] = 17031,
    -- Teleport: Thunder Bluff
    [3566] = 17031,
    -- Teleport: Undercity
    [3563] = 17031,
    -- Paladin
    -- Divine Intervention
    [19752] = 17033,
    -- Greater Blessing of Kings
    [25898] = 21177,
    -- Greater Blessing of Light
    [25890] = 21177,
    -- Greater Blessing of Might
    [25782] = 21177,
    [25916] = 21177,
    -- Greater Blessing of Salvation
    [25895] = 21177,
    -- Greater Blessing of Sanctuary
    [25899] = 21177,
    -- Greater Blessing of Wisdom
    [25894] = 21177,
    [25918] = 21177,
    -- Priest Abilities
    -- Levitate
    [1706] = 17056,
    -- Prayer of Fortitude
    [21562] = 17028,
    [21564] = 17029,
    -- Prayer of Shadow Protection
    [27683] = 17029,
    -- Prayer of Spirit
    [27681] = 17029,
    -- Rogue Abilities
    -- Blind
    [2094] = 5530,
    -- Blinding Powder
    [6510] = 3818,
    -- Crippling Poison
    [3420] = {2930, 1, 3371, 1},
    [3421] = {8923, 3, 8925, 1},
    -- Deadly Poison
    [2835] = {5173, 1, 3372, 1},
    [2837] = {5173, 2, 3372, 1},
    [11357] = {5173, 3, 8925, 1},
    [11358] = {11358, 5, 8925, 1},
    [25347] = {11358, 7, 8925, 1},
    -- Instant Poison
    [8681] = {2928, 1, 3371, 1},
    [8687] = {2928, 3, 3372, 1},
    [8691] = {8924, 1, 3372, 1},
    [11341] = {8924, 2, 8925, 1},
    [11342] = {8924, 3, 8925, 1},
    [11343] = {8924, 4, 8925, 1},
    -- Mind-numbing Poison
    [5763] = {2928, 1, 2930, 1, 3371, 1},
    [8694] = {2928, 4, 2930, 4, 3372, 1},
    [11400] = {8924, 2, 8923, 2, 8925, 1},
    -- Vanish
    [1856] = 5140,
    [1857] = 5140,
    -- Wound Poison
    [13220] = {2930, 1, 5173, 1, 3372, 1},
    [13228] = {2930, 1, 5173, 2, 3372, 1},
    [13229] = {8923, 1, 5173, 2, 8925, 1},
    [13230] = {8923, 2, 5173, 2, 8925, 1},
    -- Shaman
    -- Reincarnation
    [20608] = 17030,
    -- Water Breathing
    [131] = 17057,
    -- Water Walking
    [546] = 17058,
    -- Warlock
    -- Create Firestone
    [17951] = 6265,
    [6366] = 6265,
    [17952] = 6265,
    [17953] = 6265,
    -- Create Healthstone
    [5699] = 6265,
    [6201] = 6265,
    [6202] = 6265,
    [11729] = 6265,
    [11730] = 6265,
    -- Create Soulstone
    [693] = 6265,
    [20752] = 6265,
    [20755] = 6265,
    [20756] = 6265,
    [20757] = 6265,
    -- Create Spellstone
    [2362] = 6265,
    [17727] = 6265,
    [17728] = 6265,
    -- Enslave Demon
    [1098] = 6265,
    [11725] = 6265,
    [11726] = 6265,
    -- Inferno
    [1122] = 5565,
    -- Ritual of Doom
    [18540] = 16583,
    -- Ritual of Summoning
    [698] = 6265,
    -- Soul Fire
    [6353] = 6265,
    [17924] = 6265,
    -- Summon Felhunter
    [691] = 6265,
    -- Summon Succubus
    [712] = 6265,
    -- Summon Voidwalker
    [697] = 6265,
    -- Shadowburn
    [17877] = 6265,
    [18867] = 6265,
    [18868] = 6265,
    [18869] = 6265,
    [18870] = 6265,
    [18871] = 6265,
    -- Other stuff
    -- Cultivate Packet of Seeds
    [13399] = {11018, 2, 11022, 1}
}

-- Usage: requiresReagents, usesRemaining = getActionReagentUses(action)
local function getActionReagentUses(action)
    local actionType, actionID = GetActionInfo(action)

    if actionType == 'macro' then
        actionID = GetMacroSpell(actionID)
        if not actionID then
            return false, 0
        end
        actionType = 'spell'
    end

    if actionType == 'spell' then
        local reagents = SPELL_REAGENTS[actionID]
        -- single reagent, just return the count
        if type(reagents) == 'number' then
            -- multiple reagents, pick the one we have least of
            return true, GetItemCount(reagents)
        elseif type(reagents) == 'table' then
            local count = math.huge

            for i = 1, #reagents - 1, 2 do
                local reagentID, reagentQuantity = reagents[i], reagents[i + 1]

                count = min(count, floor(GetItemCount(reagentID) / reagentQuantity))
                if count == 0 then
                    break
                end
            end

            return true, count
        end
    end

    return false, 0
end

hooksecurefunc(
    'ActionButton_UpdateCount',
    function(button)
        local action = button.action

        -- check reagent counts
        local requiresReagents, usesRemaining = getActionReagentUses(action)
        if requiresReagents then
            button.Count:SetText(usesRemaining)
            return
        end

        -- standard inventory counts
        if IsConsumableAction(action) or IsStackableAction(action) then
            local count = GetActionCount(action)
            if count > (button.maxDisplayCount or 9999) then
                button.Count:SetText('*')
            elseif count > 0 then
                button.Count:SetText(count)
            else
                button.Count:SetText('')
            end
        end
    end
)
