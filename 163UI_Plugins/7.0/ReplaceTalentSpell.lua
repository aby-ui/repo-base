--[[------------------------------------------------------------
当同一层天赋是不能并存的主动技能时，替换原有的技能，而不是自动拖一个下来
2016.08.16
---------------------------------------------------------------]]
local debug = noop

local REPLACE_PATTEN = "^"..REPLACES_SPELL:gsub("%%s", ".+").."$"
--是否是某个技能的升级技能，鼠标提示里第二行是“代替XXXX”
local function IsReplaceSpell(talent_id)
    local tooltip = GameTooltipReplaceTalentSpell
    if not tooltip then
        tooltip = CreateFrame( "GameTooltip", "GameTooltipReplaceTalentSpell")
        tooltip:AddFontStrings(
            tooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
            tooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
        )
        tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    end
    if not talent_id then return false end
    tooltip:SetTalent(talent_id)
    local text = GameTooltipReplaceTalentSpellTextLeft2:GetText()
    if text and text:match(REPLACE_PATTEN) then
        return text
    end
end

local old_2_new, old_spells = {}, {}
local hookLearnTalent = function(new_id)
    local _, _, _, _, _, new_spell_id, _, row, col = GetTalentInfoByID(new_id)
    debug(new_id, new_spell_id, row, col)
    if IsPassiveSpell(new_spell_id) or IsReplaceSpell(new_id) then return end

    wipe(old_spells)
    local maybe_need_replace
    for i = 1, 3 do
        if i ~= col then
            local talent_id, _, _, _, _, spell_id = GetTalentInfo(row, i, 1)
            if not IsPassiveSpell(spell_id) and not IsReplaceSpell(talent_id) then
                old_2_new[talent_id] = new_id
                old_spells[spell_id] = talent_id
                maybe_need_replace = true
            end
        end
    end

    if maybe_need_replace then
        for i = 1, 120 do
            local type, spell_id = GetActionInfo(i)
            if type == "spell" then
                if spell_id == new_spell_id then
                    debug('already exists new_spell, no need to replace', i, GetSpellLink(new_spell_id))
                    for _, v in pairs(old_spells) do
                        old_2_new[abs(v)] = nil
                    end
                    return
                elseif old_spells[spell_id] then
                    old_spells[spell_id] = -1 * abs(old_spells[spell_id]) --负数表示确实需要替换
                end
            end
        end

        local has_old
        for k, v in pairs(old_spells) do
            if v > 0 then
                old_2_new[v] = nil
                old_spells[k] = nil
            else
                old_spells[k] = -old_spells[k]
                has_old = true
            end
        end

        if has_old then
            for _, v in pairs(old_spells) do debug(GetTalentLink(v), "==>", GetTalentLink(new_id)) end
            IconIntroTracker:UnregisterEvent("SPELL_PUSHED_TO_ACTIONBAR")
            CoreOnEvent("SPELL_PUSHED_TO_ACTIONBAR", function(self, spellID, slotIndex, slotPos)
                SetBarSlotFromIntro(slotIndex)
                PickupAction(slotIndex)
                ClearCursor()
                return "REMOVE"
            end)
        else
            debug('not exists old spells, nothing to replace')
        end
    end
end
local addonName = ...
hooksecurefunc("LearnTalent", function(...)
    if U1GetCfgValue(addonName, "replaceTalent") then
        hookLearnTalent(...)
    end
end)

local buttons = {}
for i = 1, 12 do
    buttons[_G["ActionButton"..i]] = true
    buttons[_G["MultiBarBottomLeftButton"..i]] = true
    buttons[_G["MultiBarBottomRightButton"..i]] = true
    buttons[_G["MultiBarLeftButton"..i]] = true
    buttons[_G["MultiBarRightButton"..i]]  = true
end

hooksecurefunc("ActionButton_OnLoad", function(self) buttons[self] = true end)

local replaced_actions = {}  --memory optimization. also we must highlight buttons after all replacement.
CoreOnEvent("PLAYER_SPECIALIZATION_CHANGED", function(event, unit)
    if unit ~= "player" then return end
    wipe(replaced_actions)
    for old_id, new_id in pairs(old_2_new) do
        local id, _, _, selected, _, new_spell_id, _, row, col = GetTalentInfoByID(new_id)
        selected = select(4, GetTalentInfo(row, col, 1)) --上面的selected是false
        if selected then
            old_2_new[old_id] = nil  --job will be done
            local _, _, _, _, _, old_spell_id = GetTalentInfoByID(old_id)
            U1Message("已自动将动作条上的"..GetSpellLink(old_spell_id).."替换为"..GetSpellLink(new_spell_id))
            for i = 1, 120 do
                local type, spell_id = GetActionInfo(i)
                if type == "spell" then
                    if spell_id == old_spell_id then
                        PickupSpell(new_spell_id)
                        PlaceAction(i)
                        ClearCursor()
                        replaced_actions[i] = true
                    end
                end
            end
        end
    end

    --show highlight texture
    for k, _ in pairs(buttons) do
        if replaced_actions[k.action or 0] and k:IsVisible() then
            if k.NewActionTexture then
                k.NewActionTexture:Show()
            end
        end
    end

    --check if still learning some talent
    for old_id, new_id in pairs(old_2_new) do
        if new_id ~= nil then
            return
        end
    end

    IconIntroTracker:RegisterEvent("SPELL_PUSHED_TO_ACTIONBAR")
    debug("register back IconIntroTracker")
end)


function U1ScanSpells()
    local curr_type
    local printed = {}
    local result = {}
    local getlink = function(spellId, should)
        if not should or IsPassiveSpell(spellId) then return "" end
        if not GetSpellInfo(spellId) then U1Message("Wrong spell " .. spellId) return "" end
        if printed[spellId] then
            for i = 1, #result do
                if result[i]:find("^[^#]+#"..spellId.."#") then
                    result[i] = curr_type..result[i]
                    return ""
                end
            end
        end
        local line = curr_type.."#"..spellId.."#"..(printed[spellId] and "XXXXXXX" or GetSpellInfo(spellId))
        printed[spellId] = true
        GameTooltip:SetSpellByID(spellId)
        local col = 3
        for i = 2, GameTooltip:NumLines() do
            local text = _G['GameTooltipTextLeft' .. i]:GetText()
            if text then if #text > 40 and col < 8 then line=line..strrep("#", 8-col) col=8 end col=col+1 line = line.."#"..text end
            local text = _G['GameTooltipTextRight' .. i]:GetText()
            if text then if #text > 40 and col < 8 then line=line..strrep("#", 8-col) col=8 end col=col+1 line = line.."#"..text end
        end
        line = line:gsub("#法术编号[^#]+$", "")
        tinsert(result, line)
        return GetSpellLink(spellId)
    end

    for i=2,GetNumSpellTabs() do
        local name, texture, offset, numSlots, isGuild, offSpecID = GetSpellTabInfo(i);
        local spec
        for j=1, GetNumSpecializations() do
            local id, specName = GetSpecializationInfo(j)
            if specName == name then
                spec = j
                break
            end
        end
        curr_type = spec..name
        local all = spec..name.."-"
        for j = offset + 1, offset + numSlots do
            local slotType, slotId = GetSpellBookItemInfo(j, BOOKTYPE_SPELL);
            if slotType == "SPELL" or slotType == "FUTURESPELL" then
                all = all..getlink(slotId, not IsTalentSpell(j, BOOKTYPE_SPELL));
            elseif slotType == "FLYOUT" then
                local name, description, numSlots, isKnown = GetFlyoutInfo(slotId)
                for k = 1, numSlots do
                    local spellId, isKnown = GetFlyoutSlotInfo(slotId, k)
                    all = all..getlink(spellId, true)
                end
            else
                U1Message("WrongType "..slotType)
            end
        end

        all = all.." 天赋-"
        for row = 1, MAX_TALENT_TIERS do
            curr_type = spec .. name .. "-天赋"..row
            for col = 1, 3 do
                local talentId, name, icon, bool1, bool2, spellId, _, r, c, bool3 = GetTalentInfoBySpecialization(spec, row, col)
                local replaceSpell = IsReplaceSpell(talentId)
                all = all..getlink(spellId, true)..(replaceSpell or "")
                if printed[spellId] and replaceSpell then
                    result[#result] = result[#result].."#"..replaceSpell
                end
            end
        end
        print(all)
    end
    return result
end
_G._SS=U1ScanSpells