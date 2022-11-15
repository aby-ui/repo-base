local _, Cell = ...
local L = Cell.L
local F = Cell.funcs

Cell.vars.playerFaction = UnitFactionGroup("player")

local classToID = {
    WARRIOR = 1,
    PALADIN = 2,
    HUNTER = 3,
    ROGUE = 4,
    PRIEST = 5,
    DEATHKNIGHT = 6,
    SHAMAN = 7,
    MAGE = 8,
    WARLOCK = 9,
    MONK = 10,
    DRUID = 11,
    DEMONHUNTER = 12,
    EVOKER = 13,
}

function F:GetClassID(class)
    return classToID[class]
end

-------------------------------------------------
-- game version
-------------------------------------------------
Cell.isAsian = LOCALE_zhCN or LOCALE_zhTW or LOCALE_koKR

Cell.isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Cell.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
-- Cell.isBCC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_BURNING_CRUSADE
-- Cell.isWrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC and LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_WRATH_OF_THE_LICH_KING
Cell.isWrath = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

-------------------------------------------------
-- WotLK
-------------------------------------------------
function F:GetActiveTalentInfo()
    local which = GetActiveTalentGroup() == 1 and L["Primary Talents"] or L["Secondary Talents"]

    local maxPoints = 0
    local specName, specIcon, specFileName

    for i = 1, GetNumTalentTabs() do
        local name, texture, pointsSpent, fileName = GetTalentTabInfo(i)
        if pointsSpent > maxPoints then
            maxPoints = pointsSpent
            specIcon = texture
            specFileName = fileName
        elseif pointsSpent == maxPoints then
            specIcon = 132148
        end
    end

    return which, specIcon, specFileName
end

-- local specRoles = {
--     ["DeathKnightBlood"] = "DAMAGER",
--     ["DeathKnightFrost"] = "TANK",
--     ["DeathKnightUnholy"] = "DAMAGER",

--     ["DruidRestoration"] = "HEALER",
--     ["DruidBalance"] = "DAMAGER",
--     -- ["DruidFeralCombat"] = nil,

--     ["HunterBeastMastery"] = "DAMAGER",
--     ["HunterSurvival"] = "DAMAGER",
--     ["HunterMarksmanship"] = "DAMAGER",
    
--     ["MageFrost"] = "DAMAGER",
--     ["MageArcane"] = "DAMAGER",
--     ["MageFire"] = "DAMAGER",

--     ["PaladinHoly"] = "HEALER",
--     ["PaladinCombat"] = "DAMAGER",
--     ["PaladinProtection"] = "TANK",

--     ["PriestShadow"] = "DAMAGER",
--     ["PriestHoly"] = "HEALER",
--     ["PriestDiscipline"] = "HEALER",

--     ["RogueCombat"] = "DAMAGER",
--     ["RogueSubtlety"] = "DAMAGER",
--     ["RogueAssassination"] = "DAMAGER",

--     ["ShamanElementalCombat"] = "DAMAGER",
--     ["ShamanEnhancement"] = "DAMAGER",
--     ["ShamanRestoration"] = "HEALER",

--     ["WarlockSummoning"] = "DAMAGER",
--     ["WarlockDestruction"] = "DAMAGER",
--     ["WarlockCurses"] = "DAMAGER",

--     ["WarriorArms"] = "DAMAGER",
--     ["WarriorFury"] = "DAMAGER",
--     ["WarriorProtection"] = "TANK",
-- }

-- function F:GetPlayerRole()

-- end

-------------------------------------------------
-- color
-------------------------------------------------
function F:ConvertRGB(r, g, b, desaturation)
    if not desaturation then desaturation = 1 end
    r = r / 255 * desaturation
    g = g / 255 * desaturation
    b = b / 255 * desaturation
    return r, g, b
end

function F:ConvertRGB_256(r, g, b)
    return r * 255, g * 255, b * 255
end

function F:ConvertRGBToHEX(r, g, b)
    local result = ""

    for key, value in pairs({r, g, b}) do
        local hex = ""

        while(value > 0)do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub("0123456789ABCDEF", index, index) .. hex			
        end

        if(string.len(hex) == 0)then
            hex = "00"

        elseif(string.len(hex) == 1)then
            hex = "0" .. hex
        end

        result = result .. hex
    end

    return result
end

function F:ConvertHEXToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

-- https://wowpedia.fandom.com/wiki/ColorGradient
function F:ColorGradient(perc, r1,g1,b1, r2,g2,b2, r3,g3,b3)
    perc = perc or 1
    if perc >= 1 then
        return r3, g3, b3
    elseif perc <= 0 then
        return r1, g1, b1
    end
 
    local segment, relperc = math.modf(perc * 2)
    local rr1, rg1, rb1, rr2, rg2, rb2 = select((segment * 3) + 1, r1,g1,b1, r2,g2,b2, r3,g3,b3)
 
    return rr1 + (rr2 - rr1) * relperc, rg1 + (rg2 - rg1) * relperc, rb1 + (rb2 - rb1) * relperc
end

--! From ColorPickerAdvanced by Feyawen-Llane
--[[ Convert RGB to HSV	---------------------------------------------------
    Inputs:
        r = Red [0, 1]
        g = Green [0, 1]
        b = Blue [0, 1]
    Outputs:
        H = Hue [0, 360]
        S = Saturation [0, 1]
        B = Brightness [0, 1]
]]--
function F:ConvertRGBToHSB(r, g, b)
    local colorMax = max(max(r, g), b)
    local colorMin = min(min(r, g), b)
    local delta = colorMax - colorMin
    local H, S, B
    
    -- WoW's LUA doesn't handle floating point numbers very well (Somehow 1.000000 != 1.000000   WTF?)
    -- So we do this weird conversion of, Number to String back to Number, to make the IF..THEN work correctly!
    colorMax = tonumber(format("%f", colorMax))
    r = tonumber(format("%f", r))
    g = tonumber(format("%f", g))
    b = tonumber(format("%f", b))
    
    if (delta > 0) then
        if (colorMax == r) then
            H = 60 * (((g - b) / delta) % 6)
        elseif (colorMax == g) then
            H = 60 * (((b - r) / delta) + 2)
        elseif (colorMax == b) then
            H = 60 * (((r - g) / delta) + 4)
        end
        
        if (colorMax > 0) then
            S = delta / colorMax
        else
            S = 0
        end
        
        B = colorMax
    else
        H = 0
        S = 0
        B = colorMax
    end
    
    if (H < 0) then
        H = H + 360
    end
    
    return H, S, B
end

--[[ Convert HSB to RGB	---------------------------------------------------
    Inputs:
        h = Hue [0, 360]
        s = Saturation [0, 1]
        b = Brightness [0, 1]
    Outputs:
        R = Red [0,1]
        G = Green [0,1]
        B = Blue [0,1]
]]--
function F:ConvertHSBToRGB(h, s, b)
    local chroma = b * s
    local prime = (h / 60) % 6
    local X = chroma * (1 - abs((prime % 2) - 1))
    local M = b - chroma
    local R, G, B

    if (0 <= prime) and (prime < 1) then
        R = chroma
        G = X
        B = 0
    elseif (1 <= prime) and (prime < 2) then
        R = X
        G = chroma
        B = 0
    elseif (2 <= prime) and (prime < 3) then
        R = 0
        G = chroma
        B = X
    elseif (3 <= prime) and (prime < 4) then
        R = 0
        G = X
        B = chroma
    elseif (4 <= prime) and (prime < 5) then
        R = X
        G = 0
        B = chroma
    elseif (5 <= prime) and (prime < 6) then
        R = chroma
        G = 0
        B = X
    else
        R = 0
        G = 0
        B = 0
    end
    
    R = R + M
    G = G + M
    B =  B + M
    
    return R, G, B
end

-------------------------------------------------
-- number
-------------------------------------------------
local symbol_1K, symbol_10K, symbol_1B
if LOCALE_zhCN then
    symbol_1K, symbol_10K, symbol_1B = "千", "万", "亿"
elseif LOCALE_zhTW then
    symbol_1K, symbol_10K, symbol_1B = "千", "萬", "億"
elseif LOCALE_koKR then
    symbol_1K, symbol_10K, symbol_1B = "천", "만", "억"
end

if Cell.isAsian then
    function F:FormatNumber(n)
        if abs(n) >= 100000000 then
            return string.format("%.3f"..symbol_1B, n/100000000)
        elseif abs(n) >= 10000 then
            return string.format("%.2f"..symbol_10K, n/10000)
        elseif abs(n) >= 1000 then
            return string.format("%.1f"..symbol_1K, n/1000)
        else
            return n
        end
    end
else
    function F:FormatNumber(n)
        if abs(n) >= 1000000000 then
            return string.format("%.3fB", n/1000000000)
        elseif abs(n) >= 1000000 then
            return string.format("%.2fM", n/1000000)
        elseif abs(n) >= 1000 then
            return string.format("%.1fK", n/1000)
        else
            return n
        end
    end
end

function F:KeepDecimals(num, n)
    if num < 0 then
        return -(abs(num) - abs(num) % 0.1 ^ n)
    else
        return num - num % 0.1 ^ n
    end
end

-------------------------------------------------
-- string
-------------------------------------------------
function F:UpperFirst(str)
    return (str:gsub("^%l", string.upper))
end

function F:SplitToNumber(sep, str)
    if not str then return end
    
    local ret = {strsplit(sep, str)}
    for i, v in ipairs(ret) do
        ret[i] = tonumber(v) or ret[i] -- keep non number
    end
    return unpack(ret)
end

local function Chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

function F:Utf8sub(str, startChar, numChars)
    if not str then return "" end
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + Chsize(char)
        startChar = startChar - 1
    end
    
    local currentIndex = startIndex
    
    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + Chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

function F:FitWidth(fs, text, alignment)
    fs:SetText(text)

    if fs:IsTruncated() then
        for i = 1, string.utf8len(text) do
            if strlower(alignment) == "right" then
                fs:SetText("..."..string.utf8sub(text, i))
            else
                fs:SetText(string.utf8sub(text, i).."...")
            end
            
            if not fs:IsTruncated() then
                break
            end
        end
    end
end

-------------------------------------------------
-- table
-------------------------------------------------
function F:Getn(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function F:GetIndex(t, e)
    for i, v in pairs(t) do
        if e == v then
            return i
        end
    end
    return nil
end

function F:Copy(t)
    local newTbl = {}
    for k, v in pairs(t) do
        if type(v) == "table" then  
            newTbl[k] = F:Copy(v)
        else  
            newTbl[k] = v  
        end  
    end
    return newTbl
end

function F:TContains(t, v)
    for _, value in pairs(t) do
        if value == v then return true end
    end
    return false
end

function F:TInsert(t, v)
    local i, done = 1
    repeat
        if not t[i] then
            t[i] = v
            done = true
        end
        i = i + 1
    until done
end

function F:TRemove(t, v)
    for i = #t, 1, -1 do
        if t[i] == v then
            table.remove(t, i)
        end
    end
end

function F:TMergeOverwrite(...)
    local tbls = {...}
    if #tbls == 0 then return {} end

    local temp = F:Copy(tbls[1])
    for i = 2, #tbls do
        for k, v in pairs(tbls[i]) do
            temp[k] = v
        end
    end
    return temp
end

function F:RemoveElementsExceptKeys(tbl, ...)
    local keys = {}
    for _, v in ipairs({...}) do
        keys[v] = true
    end

    for k in pairs(tbl) do
        if not keys[k] then
            tbl[k] = nil
        end
    end
end

function F:RemoveElementsByKeys(tbl, ...)
    local keys = {}
    for _, v in ipairs({...}) do
        keys[v] = true
    end

    for k in pairs(tbl) do
        if keys[k] then
            tbl[k] = nil
        end
    end
end

function F:Sort(t, k1, order1, k2, order2, k3, order3)
    table.sort(t, function(a, b)
        if a[k1] ~= b[k1] then
            if order1 == "ascending" then
                return a[k1] < b[k1]
            else -- "descending"
                return a[k1] > b[k1]
            end
        elseif k2 and order2 and a[k2] ~= b[k2] then
            if order2 == "ascending" then
                return a[k2] < b[k2]
            else -- "descending"
                return a[k2] > b[k2]
            end
        elseif k3 and order3 and a[k3] ~= b[k3] then
            if order3 == "ascending" then
                return a[k3] < b[k3]
            else -- "descending"
                return a[k3] > b[k3]
            end
        end
    end)
end

function F:StringToTable(s, sep, convertToNum)
    local t = {}
    for i, v in pairs({string.split(sep, s)}) do
        v = strtrim(v)
        if v ~= "" then
            if convertToNum then
                v = tonumber(v)
                if v then tinsert(t, v) end
            else
                tinsert(t, v)
            end
        end
    end
    return t
end

function F:TableToString(t, sep)
    return table.concat(t, sep)
end

function F:ConvertTable(t)
    local temp = {}
    for k, v in ipairs(t) do
        temp[v] = k
    end
    return temp
end

local GetSpellInfo = GetSpellInfo
function F:ConvertAurasTable(t, convertIdToName)
    if not convertIdToName then
        return F:ConvertTable(t)
    end

    local temp = {}
    for k, v in ipairs(t) do
        local name = GetSpellInfo(v)
        if name then
            temp[name] = k
        end
    end
    return temp
end

function F:CheckTableRemoved(previous, after)
    local aa = {}
    local ret = {}

    for k,v in pairs(previous) do aa[v] = true end
    for k,v in pairs(after) do aa[v] = nil end

    for k,v in pairs(previous) do
        if aa[v] then
            tinsert(ret, v)
        end
    end
    return ret
end

function F:FilterInvalidSpells(t)
    if not t then return end
    for i = #t, 1, -1 do
        local spellId
        if type(t[i]) == "number" then
            spellId = t[i]
        else -- consumables
            spellId = t[i][1]
        end
        if not GetSpellInfo(spellId) then
            tremove(t, i)
        end
    end
end

-------------------------------------------------
-- general
-------------------------------------------------
-- function F:GetRealmName()
--     return string.gsub(GetRealmName(), " ", "")
-- end

function F:UnitFullName(unit)
    if not unit or not UnitIsPlayer(unit) then return end

    local name = GetUnitName(unit, true)
    
    --? name might be nil in some cases?
    if name and not string.find(name, "-") then
        local server = GetNormalizedRealmName()
        --? server might be nil in some cases?
        if server then
            name = name.."-"..server
        end
    end
    
    return name
end

function F:ToShortName(fullName)
    if not fullName then return "" end
    local shortName = strsplit("-", fullName)
    return shortName
end

function F:FormatTime(s)
    if s >= 3600 then
        return "%dh", ceil(s / 3600)
    elseif s >= 60 then
        return "%dm", ceil(s / 60)
    end
    return "%ds", floor(s)
end

-- function F:SecondsToTime(seconds)
--     local m = seconds / 60
--     local s = seconds % 60
--     return format("%d:%02d", m, s)
-- end

local SEC = _G.SPELL_DURATION_SEC
local MIN = _G.SPELL_DURATION_MIN

local PATTERN_SEC
local PATTERN_MIN
if strfind(SEC, "1f") then
    PATTERN_SEC = "%.0"
elseif strfind(SEC, "2f") then
    PATTERN_SEC = "%.00"
end
if strfind(MIN, "1f") then
    PATTERN_MIN = "%.0"
elseif strfind(MIN, "2f") then
    PATTERN_MIN = "%.00"
end

function F:SecondsToTime(seconds)
    if seconds > 60 then
        return gsub(format(MIN, seconds / 60), PATTERN_MIN, "")
    else
        return gsub(format(SEC, seconds), PATTERN_SEC, "")
    end
end

-------------------------------------------------
-- unit buttons
-------------------------------------------------
function F:IterateAllUnitButtons(func, updateCurrentGroupOnly)
    -- solo
    if not updateCurrentGroupOnly or (updateCurrentGroupOnly and Cell.vars.groupType == "solo") then
        for _, b in pairs(Cell.unitButtons.solo) do
            func(b)
        end
    end

    -- party
    if not updateCurrentGroupOnly or (updateCurrentGroupOnly and Cell.vars.groupType == "party") then
        for index, b in pairs(Cell.unitButtons.party) do
            if index ~= "units" then
                func(b)
            end
        end
    end

    -- raid
    if not updateCurrentGroupOnly or (updateCurrentGroupOnly and Cell.vars.groupType == "raid") then
        for index, header in pairs(Cell.unitButtons.raid) do
            if index ~= "units" then
                for _, b in ipairs(header) do
                    func(b)
                end
            end
        end
        
        -- arena pet
        for _, b in pairs(Cell.unitButtons.arena) do
            func(b)
        end

        -- raid pet
        for index, b in pairs(Cell.unitButtons.raidpet) do
            if index ~= "units" then
                func(b)
            end
        end
    end

    -- npc
    for _, b in ipairs(Cell.unitButtons.npc) do
        func(b)
    end

    -- spotlight
    for _, b in pairs(Cell.unitButtons.spotlight) do
        func(b)
    end
end

function F:GetUnitButtonByUnit(unit)
    if not unit then return end

    local normal, spotlight
    for _, b in pairs(Cell.unitButtons.spotlight) do
        if b.state.unit and UnitIsUnit(b.state.unit, unit) then
            spotlight = b
            break
        end
    end

    if Cell.vars.groupType == "raid" then
        if Cell.vars.inBattleground == 5 then
            normal = Cell.unitButtons.raid.units[unit] or Cell.unitButtons.npc.units[unit] or Cell.unitButtons.arena[unit]
        else
            normal = Cell.unitButtons.raid.units[unit] or Cell.unitButtons.npc.units[unit] or Cell.unitButtons.raidpet.units[unit]
        end
    elseif Cell.vars.groupType == "party" then
        normal = Cell.unitButtons.party.units[unit] or Cell.unitButtons.npc.units[unit]
    else -- solo
        normal = Cell.unitButtons.solo[unit] or Cell.unitButtons.npc.units[unit]
    end

    return normal, spotlight
end

function F:GetUnitButtonByGUID(guid)
    return F:GetUnitButtonByUnit(Cell.vars.guids[guid])
end

function F:GetUnitButtonByName(name)
    return F:GetUnitButtonByUnit(Cell.vars.names[name])
end

function F:UpdateTextWidth(fs, text, width, relativeTo)
    if not text or not width then return end

    if width == "unlimited" then
        fs:SetText(text)
    elseif width[1] == "percentage" then
        local percent = width[2] or 0.75
        local width = relativeTo:GetWidth() - 2
        for i = string.utf8len(text), 0, -1 do
            fs:SetText(string.utf8sub(text, 1, i))
            if fs:GetWidth() / width <= percent then
                break
            end
        end
    elseif width[1] == "length" then
        if Cell.isAsian then
            if string.len(text) == string.utf8len(text) then -- en
                fs:SetText(string.utf8sub(text, 1, width[3] or width[2]))
            else
                fs:SetText(string.utf8sub(text, 1, width[2]))
            end
        else
            fs:SetText(string.utf8sub(text, 1, width[2]))
        end
    end
end

function F:GetMarkEscapeSequence(index)
    index = index - 1
    local left, right, top, bottom
    local coordIncrement = 64 / 256
    left = mod(index , 4) * coordIncrement
    right = left + coordIncrement
    top = floor(index / 4) * coordIncrement
    bottom = top + coordIncrement
    return string.format("|TInterface\\TargetingFrame\\UI-RaidTargetingIcons:0:0:0:0:64:64:%d:%d:%d:%d|t", left*64, right*64, top*64, bottom*64)
end

-- local scriptObjects = {}
-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- frame:RegisterEvent("PLAYER_REGEN_ENABLED")
-- frame:SetScript("OnEvent", function(self, event)
--     if event == "PLAYER_REGEN_ENABLED" then
--         for _, obj in pairs(scriptObjects) do
--             obj:Show()
--         end
--     else
--         for _, obj in pairs(scriptObjects) do
--             obj:Hide()
--         end
--     end
-- end)
-- function F:SetHideInCombat(obj)
--     tinsert(scriptObjects, obj)
-- end

-------------------------------------------------
-- frame colors
-------------------------------------------------
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
function F:GetClassColor(class)
    if class and class ~= "" then
        if CUSTOM_CLASS_COLORS then
            return CUSTOM_CLASS_COLORS[class].r, CUSTOM_CLASS_COLORS[class].g, CUSTOM_CLASS_COLORS[class].b
        else
            return RAID_CLASS_COLORS[class]:GetRGB()
        end
    else
        return 1, 1, 1
    end
end

function F:GetClassColorStr(class)
    if class and class ~= "" then
        return "|c"..RAID_CLASS_COLORS[class].colorStr
    else
        return "|cffffffff"
    end
end

local function GetPowerColor(unit)
    local r, g, b, t
    -- https://wow.gamepedia.com/API_UnitPowerType
    local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
    t = powerType

    local info = PowerBarColor[powerToken]
    if powerType == 0 then -- MANA
        info = {r=0, g=.5, b=1} -- default mana color is too dark!
    elseif powerType == 13 then -- INSANITY
        info = {r=.6, g=.2, b=1}
    end

    if info then
        --The PowerBarColor takes priority
        r, g, b = info.r, info.g, info.b
    else
        if not altR then
            -- Couldn't find a power token entry. Default to indexing by power type or just mana if  we don't have that either.
            info = PowerBarColor[powerType] or PowerBarColor["MANA"]
            r, g, b = info.r, info.g, info.b
        else
            r, g, b = altR, altG, altB
        end
    end
    return r, g, b, t
end

function F:GetPowerColor(unit, class)
    local r, g, b, lossR, lossG, lossB, t
    r, g, b, t = GetPowerColor(unit)

    if not Cell.loaded then
        return r, g, b, r*0.2, g*0.2, b*0.2, t
    end
    
    if CellDB["appearance"]["powerColor"][1] == "power_color_dark" then
        lossR, lossG, lossB = r, g, b
        r, g, b = r*0.2, g*0.2, b*0.2
    elseif CellDB["appearance"]["powerColor"][1] == "class_color" then
        r, g, b = F:GetClassColor(class)
        lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
    elseif CellDB["appearance"]["powerColor"][1] == "custom" then
        r, g, b = unpack(CellDB["appearance"]["powerColor"][2])
        lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
    else
        lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
    end
    return r, g, b, lossR, lossG, lossB, t
end

function F:GetHealthColor(percent, isDeadOrGhost, r, g, b)
    if not Cell.loaded then
        return r, g, b, r*0.2, g*0.2, b*0.2      
    end

    local barR, barG, barB, lossR, lossG, lossB
    
    -- bar
    if CellDB["appearance"]["barColor"][1] == "class_color" then
        barR, barG, barB = r, g, b
    elseif CellDB["appearance"]["barColor"][1] == "class_color_dark" then
        barR, barG, barB = r*0.2, g*0.2, b*0.2
    elseif CellDB["appearance"]["barColor"][1] == "gradient" then
        barR, barG, barB = F:ColorGradient(percent, 1,0,0, 1,0.7,0, 0.7,1,0)
    elseif CellDB["appearance"]["barColor"][1] == "gradient2" then
        if percent == 1 then
            barR, barG, barB = r, g, b
        else
            barR, barG, barB = F:ColorGradient(percent, 1,0,0, 1,0.7,0, 0.7,1,0)
        end
    else
        barR, barG, barB = unpack(CellDB["appearance"]["barColor"][2])
    end
    
    -- loss
    if isDeadOrGhost and Cell.vars.useDeathColor then
        lossR, lossG, lossB = unpack(CellDB["appearance"]["deathColor"][2])
    else
        if CellDB["appearance"]["lossColor"][1] == "class_color" then
            lossR, lossG, lossB = r, g, b
        elseif CellDB["appearance"]["lossColor"][1] == "class_color_dark" then
            lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
        elseif CellDB["appearance"]["lossColor"][1] == "gradient" then
            lossR, lossG, lossB = F:ColorGradient(percent, 1,0,0, 1,0.7,0, 0.7,1,0)
        elseif CellDB["appearance"]["lossColor"][1] == "gradient2" then
            if isDeadOrGhost then
                lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
            else
                lossR, lossG, lossB = F:ColorGradient(percent, 1,0,0, 1,0.7,0, 0.7,1,0)
            end
        else
            lossR, lossG, lossB = unpack(CellDB["appearance"]["lossColor"][2])
        end
    end

    return barR, barG, barB, lossR, lossG, lossB
end

-------------------------------------------------
-- units
-------------------------------------------------
function F:GetUnitsInSubGroup(group)
    local units = {}
    for i = 1, GetNumGroupMembers() do
        -- name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(raidIndex)
        local name, _, subgroup = GetRaidRosterInfo(i)
        if subgroup == group then
            tinsert(units, "raid"..i)
        end
    end
    return units
end

function F:GetPetUnit(playerUnit)
    if Cell.vars.groupType == "party" then
        if playerUnit == "player" then
            return "pet"
        else
            return "partypet"..select(3, strfind(playerUnit, "^party(%d+)$"))
        end
    elseif Cell.vars.groupType == "raid" then
        return "raidpet"..select(3, strfind(playerUnit, "^raid(%d+)$"))
    else
        return "pet"
    end
end

function F:IterateGroupMembers()
    local groupType = IsInRaid() and "raid" or "party"
    local numGroupMembers = GetNumGroupMembers()
    local i = groupType == "party" and 0 or 1

    return function()
        local ret
        if i == 0 and groupType == "party" then
            ret = "player"
        elseif i <= numGroupMembers and i > 0 then
            ret = groupType .. i
        end
        i = i + 1
        return ret
    end
end

function F:IterateGroupPets()
    local groupType = IsInRaid() and "raid" or "party"
    local numGroupMembers = GetNumGroupMembers()
    local i = groupType == "party" and 0 or 1

    return function()
        local ret
        if i == 0 and groupType == "party" then
            ret = "pet"
        elseif i <= numGroupMembers and i > 0 then
            ret = groupType .. "pet" .. i
        end
        i = i + 1
        return ret
    end
end

function F:GetGroupType()
    if IsInRaid() then
        return "raid"
    elseif IsInGroup() then
        return "party"
    else
        return "solo"
    end
end

function F:UnitInGroup(unit, ignorePets)
    if ignorePets then
        return UnitInParty(unit) or UnitInRaid(unit)
    else
        return UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit)
    end
end

function F:GetTargetUnitID()
    if UnitIsUnit("target", "player") then
        return "player"
    elseif UnitIsUnit("target", "pet") then
        return "pet"
    end

    if not F:UnitInGroup("target") then return end

    if UnitIsPlayer("target") then
        for unit in F:IterateGroupMembers() do
            if UnitIsUnit("target", unit) then
                return unit
            end
        end
    else
        for unit in F:IterateGroupPets() do
            if UnitIsUnit("target", unit) then
                return unit
            end
        end
    end
end

function F:GetTargetPetID()
    if UnitIsUnit("target", "player") then
        return "pet"
    end

    if not F:UnitInGroup("target") then return end

    if UnitIsPlayer("target") then
        for unit in F:IterateGroupMembers() do
            if UnitIsUnit("target", unit) then
                return F:GetPetUnit(unit)
            end
        end
    end
end

-- https://wowpedia.fandom.com/wiki/UnitFlag
local OBJECT_AFFILIATION_MINE = 0x00000001
local OBJECT_AFFILIATION_PARTY = 0x00000002
local OBJECT_AFFILIATION_RAID = 0x00000004

function F:IsFriend(unitFlags)
    if not unitFlags then return false end
    return (bit.band(unitFlags, OBJECT_AFFILIATION_MINE) ~= 0) or (bit.band(unitFlags, OBJECT_AFFILIATION_RAID) ~= 0) or (bit.band(unitFlags, OBJECT_AFFILIATION_PARTY) ~= 0)
end

function F:GetTargetUnitInfo()
    if UnitIsUnit("target", "player") then
        return "player", UnitName("player"), select(2, UnitClass("player"))
    elseif UnitIsUnit("target", "pet") then
        return "pet", UnitName("pet")
    end
    if not F:UnitInGroup("target") then return end

    if IsInRaid() then
        for i = 1, GetNumGroupMembers() do
            if UnitIsUnit("target", "raid"..i) then
                return "raid"..i, UnitName("raid"..i), select(2, UnitClass("raid"..i))
            end
            if UnitIsUnit("target", "raidpet"..i) then
                return "raidpet"..i, UnitName("raidpet"..i)
            end
        end
    elseif IsInGroup() then
        for i = 1, GetNumGroupMembers()-1 do
            if UnitIsUnit("target", "party"..i) then
                return "party"..i, UnitName("party"..i), select(2, UnitClass("party"..i))
            end
            if UnitIsUnit("target", "partypet"..i) then
                return "partypet"..i, UnitName("partypet"..i)
            end
        end
    end
end

function F:HasPermission(isPartyMarkPermission)
    if isPartyMarkPermission and IsInGroup() and not IsInRaid() then return true end
    return UnitIsGroupLeader("player") or (IsInRaid() and UnitIsGroupAssistant("player"))
end

-------------------------------------------------
-- LibSharedMedia
-------------------------------------------------
Cell.vars.texture = "Interface\\AddOns\\Cell\\Media\\statusbar.tga"
local LSM = LibStub("LibSharedMedia-3.0", true)
LSM:Register("statusbar", "Cell ".._G.DEFAULT, Cell.vars.texture)
function F:GetBarTexture()
    --! update Cell.vars.texture for further use in UnitButton_OnLoad
    if LSM:IsValid("statusbar", CellDB["appearance"]["texture"]) then
        Cell.vars.texture = LSM:Fetch("statusbar", CellDB["appearance"]["texture"])
    else
        Cell.vars.texture = "Interface\\AddOns\\Cell\\Media\\statusbar.tga"
    end
    return Cell.vars.texture
end

function F:GetFont(font)
    if font and LSM:IsValid("font", font) then
        return LSM:Fetch("font", font)
    else
        if CellDB["appearance"]["useGameFont"] then
            return GameFontNormal:GetFont()
        else
            return "Interface\\AddOns\\Cell\\Media\\Accidental_Presidency.ttf"
        end
    end
end

local defaultFontName = "Cell ".._G.DEFAULT
local defaultFont
function F:GetFontItems()
    if CellDB["appearance"]["useGameFont"] then
        defaultFont = GameFontNormal:GetFont()
    else
        defaultFont = "Interface\\AddOns\\Cell\\Media\\Accidental_Presidency.ttf"
    end

    local items = {}
    local fonts, fontNames
    
    -- if LSM then
        fonts, fontNames = F:Copy(LSM:HashTable("font")), F:Copy(LSM:List("font"))
        -- insert default font
        tinsert(fontNames, 1, defaultFontName)
        fonts[defaultFontName] = defaultFont

        for _, name in pairs(fontNames) do
            tinsert(items, {
                ["text"] = name,
                ["font"] = fonts[name],
                -- ["onClick"] = function()
                --     CellDB["appearance"]["font"] = name
                --     Cell:Fire("UpdateAppearance", "font")
                -- end,
            })
        end
    -- else
    --     fontNames = {defaultFontName}
    --     fonts = {[defaultFontName] = defaultFont}

    --     tinsert(items, {
    --         ["text"] = defaultFontName,
    --         ["font"] = defaultFont,
    --         -- ["onClick"] = function()
    --         --     CellDB["appearance"]["font"] = defaultFontName
    --         --     Cell:Fire("UpdateAppearance", "font")
    --         -- end,
    --     })
    -- end
    return items, fonts, defaultFontName, defaultFont 
end

-------------------------------------------------
-- texture
-------------------------------------------------
function F:GetTexCoord(width, height)
    -- ULx,ULy, LLx,LLy, URx,URy, LRx,LRy
    local texCoord = {0.12, 0.12, 0.12, 0.88, 0.88, 0.12, 0.88, 0.88}
    local aspectRatio = width / height

    local xRatio = aspectRatio < 1 and aspectRatio or 1
    local yRatio = aspectRatio > 1 and 1 / aspectRatio or 1

    for i, coord in ipairs(texCoord) do
        local aspectRatio = (i % 2 == 1) and xRatio or yRatio
        texCoord[i] = (coord - 0.5) * aspectRatio + 0.5
    end
    
    return texCoord
end

-- function F:RotateTexture(tex, degrees)
--     local angle = math.rad(degrees)
--     local cos, sin = math.cos(angle), math.sin(angle)
--     tex:SetTexCoord((sin - cos), -(cos + sin), -cos, -sin, sin, -cos, 0, 0)
-- end

-- https://wowpedia.fandom.com/wiki/Applying_affine_transformations_using_SetTexCoord
local s2 = sqrt(2)
local function CalculateCorner(degrees)
    local r = math.rad(degrees)
    return 0.5 + math.cos(r) / s2, 0.5 + math.sin(r) / s2
end
function F:RotateTexture(texture, degrees)
    local LRx, LRy = CalculateCorner(degrees + 45)
    local LLx, LLy = CalculateCorner(degrees + 135)
    local ULx, ULy = CalculateCorner(degrees + 225)
    local URx, URy = CalculateCorner(degrees - 45)
    
    texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end

-- wow atlases
local wowAtlases = {
    "playerpartyblip",
    "Artifacts-PerkRing-WhiteGlow",
    "AftLevelup-WhiteIconGlow",
    "LootBanner-IconGlow",
    "AftLevelup-WhiteStarBurst",
    "ChallengeMode-WhiteSpikeyGlow",
    "UI-QuestPoiCampaign-OuterGlow",
    "vignettekill",
    "PetJournal-FavoritesIcon",
    "dungeonskull",
    "questnormal",
    "questturnin",
    "bags-icon-addslots",
    "communities-chat-icon-plus",
    "communities-chat-icon-minus",
}

-- wow textures
local wowTextures = {

}

-- shapes
local shapes = {
    "circle_blurred",
    "circle_filled",
    "circle_thin",
    "circle",
    "heart_filled",
    "heart",
    "square_filled",
    "square",
    "star_filled",
    "star",
    "starburst_filled",
    "starburst",
    "triangle_filled",
    "triangle"
}

-- weakauras
local powaTextures = {
    9, 10, 12, 13, 14, 15, 21, 22, 25, 27, 29,
    37, 38, 39, 40, 41, 42, 43, 44,
    49, 51, 52, 53, 58, 78, 118, 84,
    96, 97, 98, 99, 100, 114, 115, 116, 132, 138, 143
}

function F:GetTextures()
    local builtIns = #wowAtlases + #wowTextures + #shapes

    local t = {}
    
    -- wow atlases
    for _, wa in pairs(wowAtlases) do
        tinsert(t, wa)
    end
    
    -- wow textures
    for _, wt in pairs(wowTextures) do
        tinsert(t, wt)
    end

    -- built-ins
    for _, s in pairs(shapes) do
        tinsert(t, "Interface\\AddOns\\Cell\\Media\\Shapes\\"..s..".tga")
    end
    
    -- add weakauras textures
    if WeakAuras then
        builtIns = builtIns + #powaTextures
        for _, powa in pairs(powaTextures) do
            tinsert(t, "Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Auras\\Aura"..powa..".tga")
        end
    end

    -- customs
    for _, path in pairs(CellDB["customTextures"]) do
        tinsert(t, path)
    end

    return builtIns, t
end

-------------------------------------------------
-- frame position
-------------------------------------------------
-- function F:SavePosition(frame, pTable)
--     local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
--     pTable[1], pTable[2], pTable[3], pTable[4] = point, relativePoint, xOfs, yOfs
-- end

-- function F:RestorePosition(frame, pTable)
--     frame:ClearAllPoints()
--     frame:SetPoint(pTable[1], UIParent, pTable[2], pTable[3], pTable[4])
-- end

-------------------------------------------------
-- instance
-------------------------------------------------
function F:GetInstanceName()
    if IsInInstance() then
        local name = GetInstanceInfo()
        if not name then name = GetRealZoneText() end
        return name
    else
        local mapID = C_Map.GetBestMapForUnit("player")
        if type(mapID) ~= "number" or mapID < 1 then
            return ""
        end

        local info = MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true)
        if info then
            return info.name, info.mapID
        end

        return ""
    end
end

-------------------------------------------------
-- spell description
-------------------------------------------------
-- https://wow.gamepedia.com/UIOBJECT_GameTooltip
-- local function EnumerateTooltipLines_helper(...)
--     for i = 1, select("#", ...) do
--        local region = select(i, ...)
--        if region and region:GetObjectType() == "FontString" then
--           local text = region:GetText() -- string or nil
--           print(region:GetName(), text)
--        end
--     end
-- end

local lines = {}
function F:GetSpellInfo(spellId)
    wipe(lines)

    local name, _, icon = GetSpellInfo(spellId)
    if not name then return end
    
    CellScanningTooltip:ClearLines()
    CellScanningTooltip:SetHyperlink("spell:"..spellId)
    for i = 2, min(5, CellScanningTooltip:NumLines()) do
        tinsert(lines, _G["CellScanningTooltipTextLeft"..i]:GetText())
    end
    -- CellScanningTooltip:SetOwner(CellOptionsFrame_RaidDebuffsTab, "ANCHOR_RIGHT")
    -- CellScanningTooltip:Show()
    return name, icon, table.concat(lines, "\n")
end

-------------------------------------------------
-- auras
-------------------------------------------------
-- name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura
-- NOTE: FrameXML/AuraUtil.lua
-- AuraUtil.FindAura(predicate, unit, filter, predicateArg1, predicateArg2, predicateArg3)
-- predicate(predicateArg1, predicateArg2, predicateArg3, ...)
local function predicate(...)
    local idToFind = ...
    local id = select(13, ...)
    return idToFind == id
end

function F:FindAuraById(unit, type, spellId)
    if type == "BUFF" then
        return AuraUtil.FindAura(predicate, unit, "HELPFUL", spellId)
    else
        return AuraUtil.FindAura(predicate, unit, "HARMFUL", spellId)
    end
end

if Cell.isRetail then
    function F:FindDebuffByIds(unit, spellIds)
        local debuffs = {}
        AuraUtil.ForEachAura(unit, "HARMFUL", nil, function(name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId)
            if spellIds[spellId] then
                debuffs[spellId] = debuffType
            end
        end)
        return debuffs
    end

    function F:FindAuraByDebuffTypes(unit, types)
        local debuffs = {}
        AuraUtil.ForEachAura(unit, "HARMFUL", nil, function(name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId)
            if types == "all" or types[debuffType] then
                debuffs[spellId] = debuffType
            end
        end)
        return debuffs
    end
else
    function F:FindDebuffByIds(unit, spellIds)
        local debuffs = {}
        for i = 1, 40 do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitDebuff(unit, i)
            if not name then
                break
            end

            if spellIds[spellId] then
                debuffs[spellId] = debuffType
            end
        end
        return debuffs
    end

    function F:FindAuraByDebuffTypes(unit, types)
        local debuffs = {}
        for i = 1, 40 do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitDebuff(unit, i)
            if not name then
                break
            end

            if types == "all" or types[debuffType] then
                debuffs[spellId] = debuffType
            end
        end
        return debuffs
    end
end