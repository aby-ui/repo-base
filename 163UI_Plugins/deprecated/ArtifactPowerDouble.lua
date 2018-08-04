local debug = function() end
--"将116 万点神器能量注入到你当前装备的神器之中。" "Use: Grants 9 million Artifact Power to your currently equipped Artifact."
local AP_TOOLTIP = "Grants (.+) Artifact Power to your currently equipped Artifact."
if GetLocale() == "zhCN" then AP_TOOLTIP = "将(.+)点神器能量注入到你当前装备的神器之中。" end

local units = { [""] = 1, ["万"] = 1e4, ["亿"] = 1e8, ["M"] = 1e6, ["million"] = 1e6 }
local function parse_number(str)
    str = str:gsub(",", ""):gsub(" ", "")
    local _, _, num, unit = str:find(("([0-9%.]+)(.*)"))
    if not units[unit] then U1Message("unknown number unit: " .. unit) end
    unit = unit and units[unit] or 1
    return tonumber(num) * unit
end

local tip, tipname = CoreGetTooltipForScan()
local cast_time, cast_gain, cast_id
local function read_spell_ap(spellid)
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    tip:SetSpellByID(spellid)
    for i = tip:NumLines(), 1, -1 do
        local txt = _G[tipname .. "TextLeft"..i]:GetText()
        if txt then
            local _, _, value = txt:find(AP_TOOLTIP)
            debug(spellid, txt, value)
            if value then
                return parse_number(value)
            end
        end
    end
end

local ap_enhance_spell_name = GetSpellInfo(228647)
CoreOnEvent("UNIT_SPELLCAST_SUCCEEDED", function(event, unit, spellname, arg3, arg4, spellid)
    if unit == "player" and spellname == ap_enhance_spell_name then
        local ap = read_spell_ap(spellid)
        if ap then
            cast_gain = ap
            cast_time = GetTime()
            cast_id = spellid
        end
    end
end)

local pattern_msg = ARTIFACT_XP_GAIN:gsub("%%s", "(.+)")
CoreOnEvent("CHAT_MSG_SYSTEM", function(event, msg)
    local _, _, weapon, gained = msg:find(pattern_msg)
    if gained then
        debug(gained, parse_number(gained), cast_time, cast_gain)
        if cast_time and GetTime() <= cast_time + 0.5 then
            local actual_gain = parse_number(gained)
            local sum = U1DB.ap_double_sum
            if actual_gain > cast_gain * 1.5 then
                local more_info
                if not sum then
                    U1DB.ap_double_sum = { 1, 1, actual_gain / 2 } sum = U1DB.ap_double_sum
                    more_info = "开始统计本角色翻倍次数"
                else
                    sum[1] = sum[1] + 1
                    sum[2] = sum[2] + 1
                    sum[3] = sum[3] + actual_gain / 2
                    more_info = string.format("累计：%d/%d (%.1f%%) +%s", sum[2], sum[1], sum[2]*100/sum[1], AbbreviateLargeNumbers163(sum[3]))
                end
                U1DBG.ap_spell = U1DBG.ap_spell or {}
                U1DBG.ap_spell[cast_id] = 1
                U1Message("恭喜！本次能量翻倍，" .. more_info)
                PlaySound(73277)
                PlaySoundFile("Sound\\character\\Human\\HumanVocalFemale\\HumanFemaleCheer02.ogg")
                --PlaySound(33338)
                --PlaySoundFile("Sound\\Event Sounds\\OgreEventCheerUnique.ogg")
            else
                if sum then sum[1] = sum[1] + 1 end
            end
        end
    end
end)

CoreUIRegisterSlash('ARTIFACTPOWERDOUBLE', '/apdouble', '/apd', function()
    local sum = U1DB.ap_double_sum
    if not sum then
        U1Message("尚未有翻倍记录")
    else
        U1Message("神器能量翻倍统计：" .. string.format("累计：%d/%d (%.1f%%) +%s", sum[2], sum[1], sum[2]*100/sum[1], AbbreviateLargeNumbers163(sum[3])))
    end
end)
