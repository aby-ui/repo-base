local type, pairs = type, pairs

hsf = hooksecurefunc

function noop() end

local function colorStack(ret)
    ret = tostring(ret) or "" -- Yes, it gets called with nonstring from somewhere /mikk
    ret = ret:gsub('%[string "@Interface/AddOns/', '["A/') --前缀都去掉 [string "@Interface/FrameXML/
    ret = ret:gsub('%[string "@Interface/', '["') --前缀都去掉 [string "@Interface/FrameXML/
    ret = ret:gsub('%[string "', '["') --前缀都去掉 [string "=[C]"]: ?
    ret = ret:gsub('"%]:(%d+):', ':%1"]:') --abyui 方便复制代码位置 UIParent.lua:2552"]: in function
    ret = ret:gsub('<[^>]+:(%d+)>', '<@%1>') --abyui 方便复制代码位置 <...ace/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua:28>

    ret = ret:gsub("[%.I][%.n][%.t][%.e][%.r]face\\", "")
    ret = ret:gsub("|([^chHr])", "||%1"):gsub("|$", "||") -- Pipes
    ret = ret:gsub("<(.-)>", "|cffffd200<%1>|r") -- Things wrapped in <>
    ret = ret:gsub("([`])(.-)(['])", "|cff82c5ff%1%2%3|r") -- Quotes
    ret = ret:gsub("(\"[^\n]-):(%d+)([%S\n])", "|cff7fff7f%1:%2|r%3") -- Line numbers
    return ret
end

function pdebug(...) print("params", ...);
    local str = colorStack(debugstack(2))
    str:gsub("(.-)\n", function(line) print(line) end)
    print('-------- pdebug', date("%H:%M:%S")..format(".%03d", GetTime()*1000%1000))
end

local start_old, last_reset = debugprofilestart, 0
debugprofilestart = function() last_reset = last_reset + debugprofilestop() return start_old() end
u1debugprofilestop = function() return debugprofilestop() + last_reset end

function u1bench(f, ...)
    local b=debugprofilestop()
    for i=1,1e6 do
        f(...)
    end
    print(debugprofilestop()-b)
end

function find_global(pattern)
    for k,v in pairs(_G) do
        if type(v) == "string" and v:find(pattern) then
            print(k,v)
        end
    end
    print("=========================")
end

function find_global_key(patternOrObject)
    for k,v in pairs(_G) do
        if type(k) == "string" and v == patternOrObject or (type(patternOrObject)=="string" and k:find(patternOrObject)) then
            print(k,v)
        end
    end
    print("=========================")
end

local searched = {}
local function getTableKey(k)
    if type(k) == "string" then
        if k:match("[A-Za-z_][A-Za-z_0-9]*") then
            return "." .. k
        else
            return format("[%q]", k)
        end
    else
        return format("[%s]", k)
    end
end
local function travelParentObject(parent, target)
    searched[parent] = true
    for k, v in pairs(parent) do
        if v == target then
            return getTableKey(k)
        end
    end
    for k, v in pairs(parent) do
        if type(v) == "table" and not searched[v] then
            if k ~= "Delegate" then
                local childKey = travelParentObject(v, target)
                if childKey then
                    return getTableKey(k) .. childKey
                end
            end
        end
    end
end
function FindObjectPath(frame, justReturn)
    wipe(searched)
    local name = travelParentObject(_G, frame) or tostring(frame)
    if name:sub(1,1) == "." then name = name:sub(2) end
    wipe(searched)
    if justReturn then
        return name
    end
    if CoreUIChatEdit_Insert then
        RunOnNextFrame(CoreUIChatEdit_Insert, "/dumppn " .. name)
    else
        print(name)
    end
end

--[[
function FindParentKey(frame)
    if frame then
        local name
        if frame.GetName and frame:GetName() then
            name = frame:GetName()
        else
            local parent = frame:GetParent();
            local path, found
            while parent do
                found = false
                for k, v in pairs(parent) do
                    if v==frame then
                        found = true
                        path = k..(path and "."..path or "")
                        break
                    end
                end
                if not found or parent:GetName() then
                    path = (parent:GetName() or "[UNKNOWN]").."."..(path or "nil")
                    break;
                else
                    frame = parent
                    parent = frame:GetParent()
                end
            end
            name = path
        end
        if CoreUIChatEdit_Insert then
            RunOnNextFrame(CoreUIChatEdit_Insert, "/dumppn " .. name)
        else
            print(name)
        end
    end
end
--]]

function GetMouseFocusGlobalName()
    local mf = GetMouseFocus()
    _G.mf = nil
    local result = FindObjectPath(mf)
    _G.mf = mf
    return result
end

SLASH_MOUSEFOCUSNAME1 = "/getmn"
SLASH_MOUSEFOCUSNAME2 = "/getmousefocusname"
SLASH_MOUSEFOCUSNAME3 = "/gmn"
SlashCmdList["MOUSEFOCUSNAME"] = GetMouseFocusGlobalName

---直接调用Blizzard的dump
function dump(...)
    if not IsAddOnLoaded("Blizzard_DebugTools") then LoadAddOn("Blizzard_DebugTools") end
    DevTools_Dump(...);
end

function dump2(value, depth)
    if not IsAddOnLoaded("Blizzard_DebugTools") then LoadAddOn("Blizzard_DebugTools") end
    local old_DEVTOOLS_DEPTH_CUTOFF = DEVTOOLS_DEPTH_CUTOFF
    local old_DEVTOOLS_MAX_ENTRY_CUTOFF = DEVTOOLS_MAX_ENTRY_CUTOFF
    DEVTOOLS_DEPTH_CUTOFF = (depth or 1)
    DEVTOOLS_MAX_ENTRY_CUTOFF = 100
    DevTools_Dump(value)
    DEVTOOLS_DEPTH_CUTOFF = old_DEVTOOLS_DEPTH_CUTOFF
    DEVTOOLS_MAX_ENTRY_CUTOFF = old_DEVTOOLS_MAX_ENTRY_CUTOFF
end

SlashCmdList["DUMPB"] = function(cmd)
    local var, depth = cmd:match("^(.*)[ ]+([0-9]+)$")
    print("dump2 " .. cmd .. " ---------------")
    dump2(loadstring("return "..(var or cmd))(), tonumber(depth or 1))
end
SLASH_DUMPB1 = "/dump2"

local function dumpt_tostring(v)
    if type(v) == "table" and v.GetObjectType then
        local ok, objectType = pcall(v.GetObjectType, v)
        return "|cffffcc00[" .. (ok and objectType or "ERROR") .. "]|r " .. tostring(v)
    elseif type(v) == "function" then
        return "|cff88ff88<function>|r"
    else
        return tostring(v)
    end
end
U1_DUMPP_FUNCTION = nil --只显示func或不显示func
function dumpp(tbl, curr_depth, expect_depth)
    if(type(tbl)~="table") then return print(dumpt_tostring(tbl)) end
    curr_depth = curr_depth or 1
    expect_depth = max(expect_depth or 1, curr_depth)
    if(expect_depth == curr_depth) then print(dumpt_tostring(tbl)) end
    local keys = {}
    for k, v in pairs(tbl) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
    for _, k in ipairs(keys) do
        local v = tbl[k]
        if k == 0 and tostring(v):sub(1,9) == "userdata:" then
            --continue
        else
            if U1_DUMPP_FUNCTION == nil or U1_DUMPP_FUNCTION == (type(v) == "function") then
                print(strrep(" │", expect_depth - curr_depth) .. " ├|cff88ccff" .. tostring(k) .. "|r = " .. dumpt_tostring(v))
            end
            if curr_depth > 1 and type(v)=="table" then dumpp(v, curr_depth -1, expect_depth) end
        end
    end
end
SlashCmdList["DUMPP"] = function(cmd)
    local var, depth = cmd:match("^(.*)[ ]+([0-9]+)$")
    dumpp(loadstring("return "..(var or cmd))(), tonumber(depth or 1))
end
SLASH_DUMPP1 = "/dumpp"

function dumppf(...)
    U1_DUMPP_FUNCTION = true
    dumpp(...)
    U1_DUMPP_FUNCTION = nil
end
SlashCmdList["DUMPPF"] = function(cmd)
    local var, depth = cmd:match("^(.*)[ ]+([0-9]+)$")
    dumppf(loadstring("return "..(var or cmd))(), tonumber(depth or 1))
end
SLASH_DUMPPF1 = "/dumppf"

function dumppn(...)
    U1_DUMPP_FUNCTION = false
    dumpp(...)
    U1_DUMPP_FUNCTION = nil
end
SlashCmdList["DUMPPN"] = function(cmd)
    local var, depth = cmd:match("^(.*)[ ]+([0-9]+)$")
    dumppn(loadstring("return "..(var or cmd))(), tonumber(depth or 1))
end
SLASH_DUMPPN1 = "/dumppn"
function dumppt(frame)
    for i = 1, 4 do
        local point, rel, relpoint, x, y = frame:GetPoint(i)
        if not point then break end
        local relName = rel and FindObjectPath(rel, true) or tostring(rel)
        print("anchor"..i, point, relName, relpoint, floor(x), floor(y))
    end
end
SlashCmdList["DUMPPOINT"] = function(cmd)
    local frame = loadstring("return "..(cmd))()
    if frame and frame.GetPoint then
        dumppt(frame)
    else
        print("No frame for", cmd)
    end
end
SLASH_DUMPPOINT1 = "/dumppt"

---可以输出代码位置的调试方法
function CoreDebug(...)
    local stack = debugstack(2, 1, 0);
    local pos = stack:find("\n")
    stack = pos and stack:sub(1, pos-1) or stack;
    --Interface\AddOns\163SettingPack\Main.lua:37: in function <Interface\AddOns\163SettingPack\Main.lua:30>
    --[string "@Interface\AddOns\163UI_Plugins\8.0\ChallengesGuildBest.lua"]:143: in function <...ace\AddOns\163UI_Plugins\8.0\ChallengesGuildBest.lua:123>
    --[string "CoreDebug("aaa")"]:1: in main chunk
    local parts = {strsplit(":", stack)};
    local params = {...}
    for i=1,#params do params[i] = tostring(params[i]) end
    if #parts >= 3 then
        parts[1] = parts[1]:gsub('^%[string "@(.*)"%]$', '%1')
        local _,_,addon = strfind(parts[1], "^Interface\\AddOns\\(.-)\\.*");
        local _,_,file = strfind(parts[1], ".*\\(.-%.[%a]-)$");
        local line = tonumber(parts[2]);
        print(format("%s |cff7f7f7f%s/%s:%d|r", table.concat(params, ", "), addon or "macro", file or "string", line));
        --local _,_,func = strfind(parts[3], " in function `(.-)'");
        --if not func then func = "?" end
        --print(format("|cff3f3f3f[%s]|r %s |cff3f3f3f@%s:%s():%d|r", addon or "macro", table.concat(params, ", "), file or "string", func, line));
    else
        print(stack);
        print(format("|cff7f7f7f[%s]|r %s", core:GetName(), table.concat(params, ", ")));
    end
end

u1log = CoreDebug

C_Timer.After(0, function()
    CoreDependCall("Blizzard_DebugTools", function()
        if TableAttributeDisplay then
            local function hookButtonClick(self)
                CoreUIChatEdit_Insert((self.Text:GetText() or ""):gsub("Frame Attributes %- ", "/dumppn "), true)
            end
            TableAttributeDisplay.TitleButton:SetScript("OnClick", hookButtonClick)
            hooksecurefunc(TableInspectorMixin, "OnLoad", function(self)
                self.TitleButton:SetScript("OnClick", hookButtonClick)
            end)
        end
    end)
end)

