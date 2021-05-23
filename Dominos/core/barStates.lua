-- BarStates is a utility defining ids that map to certain macro conditions

local _, Addon = ...
local states = {}

local function getStateIterator(type, i)
    for j = i + 1, #states do
        local state = states[j]
        if state and ((not type) or state.type == type) then
            return j, state
        end
    end
end

local BarStates = {
    add = function(self, state, index)
        if index then
            return table.insert(states, index, state)
        end
        return table.insert(states, state)
    end,
    getAll = function(self, type)
        return getStateIterator, type, 0
    end,
    get = function(self, id)
        for _, v in pairs(states) do
            if v.id == id then
                return v
            end
        end
    end,
    map = function(self, f)
        local results = {}
        for _, v in ipairs(states) do
            if f(v) then
                table.insert(results, v)
            end
        end
        return results
    end
}

Addon.BarStates = BarStates

local addState = function(stateType, stateId, stateValue, stateText)
    return BarStates:add {
        type = stateType,
        id = stateId,
        value = stateValue,
        text = stateText
    }
end

-- keybindings
addState('modifier', 'selfcast', '[mod:SELFCAST]', AUTO_SELF_CAST_KEY_TEXT)
addState('modifier', 'ctrlAltShift', '[mod:alt,mod:ctrl,mod:shift]')
addState('modifier', 'ctrlAlt', '[mod:alt,mod:ctrl]')
addState('modifier', 'altShift', '[mod:alt,mod:shift]')
addState('modifier', 'ctrlShift', '[mod:ctrl,mod:shift]')
addState('modifier', 'alt', '[mod:alt]', ALT_KEY)
addState('modifier', 'ctrl', '[mod:ctrl]', CTRL_KEY)
addState('modifier', 'shift', '[mod:shift]', SHIFT_KEY)
addState('modifier', 'meta', '[mod:meta]')

-- paging
for i = 2, 6 do
    addState('page', ('page%d'):format(i), ('[bar:%d]'):format(i), _G['BINDING_NAME_ACTIONPAGE' .. i])
end

-- class
do
    local class = UnitClassBase('player')

    -- some class states are a bit dynamic
    -- druid forms, for instance, can vary based on how many different abilities
    -- are known
    local function newFormConditionLookup(spellID)
        return function()
            for i = 1, GetNumShapeshiftForms() do
                local _, _, _, formSpellID = GetShapeshiftFormInfo(i)

                if spellID == formSpellID then
                    return ('[form:%d]'):format(i)
                end
            end
        end
    end

    local function getEquippedConditional(classId, subclassId)
        local name = GetItemSubClassInfo(classId, subclassId)

        return ('[equipped:%s]'):format(name)
    end

    if class == 'DRUID' then
        addState('class', 'bear', '[bonusbar:3]', GetSpellInfo(5487))
        addState('class', 'prowl', '[bonusbar:1,stealth]', GetSpellInfo(5215))
        addState('class', 'cat', '[bonusbar:1]', GetSpellInfo(768))

        if Addon:IsBuild('bcc', 'classic') then
            addState('class', 'moonkin', newFormConditionLookup(24858), GetSpellInfo(24858))

            if Addon:IsBuild('bcc') then
                addState('class', 'tree', newFormConditionLookup(33891), GetSpellInfo(33891))
            end

            addState('class', 'travel', newFormConditionLookup(783), GetSpellInfo(783))
            addState('class', 'aquatic', newFormConditionLookup(1066), GetSpellInfo(1066))

            if Addon:IsBuild('bcc') then
                addState('class', 'flight', newFormConditionLookup(33943), GetSpellInfo(33943))
            end
        else
            addState('class', 'moonkin', '[bonusbar:4]', GetSpellInfo(24858))
            addState('class', 'tree', newFormConditionLookup(114282), GetSpellInfo(114282))
            addState('class', 'travel', newFormConditionLookup(783), GetSpellInfo(783))
            addState('class', 'stag', newFormConditionLookup(210053), GetSpellInfo(210053))
        end
    elseif class == 'ROGUE' then
        if GetSpellInfo(185313) then
            addState('class', 'shadowdance', '[bonusbar:1,form:2]', GetSpellInfo(185313))
        end

        addState('class', 'stealth', '[bonusbar:1]', GetSpellInfo(1784))
    elseif class == 'WARRIOR' then
        -- paladin auras
        if Addon:IsBuild('bcc', 'classic') then
            addState('class', 'battle', '[bonusbar:1]', GetSpellInfo(2457))
            addState('class', 'defensive', '[bonusbar:2]', GetSpellInfo(71))
            addState('class', 'berserker', '[bonusbar:3]', GetSpellInfo(2458))
        else
            addState('class', 'shield', getEquippedConditional(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SHIELD))
        end
    elseif class == 'PALADIN' then
        if Addon:IsBuild('retail') then
            addState('class', 'crusader', newFormConditionLookup(32223), GetSpellInfo(32223))
            addState('class', 'devotion', newFormConditionLookup(465), GetSpellInfo(465))
            addState('class', 'retribution', newFormConditionLookup(183435), GetSpellInfo(183435))
            addState('class', 'concentration', newFormConditionLookup(317920), GetSpellInfo(317920))

            addState('class', 'shield', getEquippedConditional(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_SHIELD))
        elseif Addon:IsBuild('bcc') then
            addState('class', 'crusader', newFormConditionLookup(32223), GetSpellInfo(32223))
            addState('class', 'devotion', newFormConditionLookup(10292), GetSpellInfo(10292))
            addState('class', 'retribution', newFormConditionLookup(10301), GetSpellInfo(10301))
            addState('class', 'concentration', newFormConditionLookup(19746), GetSpellInfo(19746))
            addState('class', 'shadow', newFormConditionLookup(19896), GetSpellInfo(19896))
            addState('class', 'frost', newFormConditionLookup(19898), GetSpellInfo(19898))
            addState('class', 'fire', newFormConditionLookup(19899), GetSpellInfo(19899))
        end
    elseif class == 'PRIEST' and Addon:IsBuild('bcc', 'classic') then
        addState('class', 'shadowform', '[form:1]', GetSpellInfo(16592))
    end
end

-- race
do
    local race = select(2, UnitRace('player'))
    if race == 'NightElf' then
        local name = (GetSpellInfo(58984) or GetSpellInfo(20580))
        addState('class', 'shadowmeld', '[stealth]', name)
    end
end

-- target reaction
addState('target', 'help', '[help]')
addState('target', 'harm', '[harm]')
addState('target', 'notarget', '[noexists]')
