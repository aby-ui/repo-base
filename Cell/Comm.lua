local _, Cell = ...
local L = Cell.L
local F = Cell.funcs

local LibDeflate = LibStub:GetLibrary("LibDeflate")
local deflateConfig = {level = 9}
local Serializer = LibStub:GetLibrary("LibSerialize")
local Comm = LibStub:GetLibrary("AceComm-3.0")

local function Serialize(data)
    local serialized = Serializer:Serialize(data) -- serialize
    local compressed = LibDeflate:CompressDeflate(serialized, deflateConfig) -- compress
    return LibDeflate:EncodeForWoWAddonChannel(compressed) -- encode
end

local function Deserialize(encoded)
    local decoded = LibDeflate:DecodeForWoWAddonChannel(encoded) -- decode
    local decompressed = LibDeflate:DecompressDeflate(decoded) -- decompress
    if not decompressed then
        F:Debug("Error decompressing: " .. errorMsg)
        return
    end
    local success, data = Serializer:Deserialize(decompressed) -- deserialize
    if not success then
        F:Debug("Error deserializing: " .. data)
        return
    end
    return data
end

-----------------------------------------
-- for WA
-----------------------------------------
function F:Notify(type, ...)
    if WeakAuras then
        WeakAuras.ScanEvents("CELL_NOTIFY", type, ...)
    end
end

-----------------------------------------
-- shared
-----------------------------------------
local sendChannel
local function UpdateSendChannel()
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        sendChannel = "INSTANCE_CHAT"
    elseif IsInRaid() then
        sendChannel = "RAID"
    else
        sendChannel = "PARTY"
    end
end

-----------------------------------------
-- Check Version
-----------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
function eventFrame:GROUP_ROSTER_UPDATE()
    if IsInGroup() then
        eventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
        UpdateSendChannel()
        Comm:SendCommMessage("CELL_VERSION", Cell.version, sendChannel, nil, "NORMAL")
    end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
function eventFrame:PLAYER_LOGIN()
    if IsInGuild() then
        Comm:SendCommMessage("CELL_VERSION", Cell.version, "GUILD", nil, "NORMAL")
    end
end

Comm:RegisterComm("CELL_VERSION", function(prefix, message, channel, sender)
    if sender == UnitName("player") then return end
    local version = tonumber(string.match(message, "%d+"))
    local myVersion = tonumber(string.match(Cell.version, "%d+"))
    if (not CellDB["lastVersionCheck"] or time()-CellDB["lastVersionCheck"]>=25200) and version and myVersion and myVersion < version then
        CellDB["lastVersionCheck"] = time()
        F:Print(L["New version found (%s). Please visit %s to get the latest version."]:format(message, "|cFF00CCFFhttps://www.curseforge.com/wow/addons/cell|r"))
    end
end)

-----------------------------------------
-- Notify Marks
-----------------------------------------
Comm:RegisterComm("CELL_MARKS", function(prefix, message, channel, sender)
    if sender == UnitName("player") then return end
    local data = Deserialize(message)
    if Cell.vars.hasPartyMarkPermission and CellDB["tools"]["marks"][1] and (strfind(CellDB["tools"]["marks"][2], "^target") or strfind(CellDB["tools"]["marks"][2], "^both")) and data then
        sender = F:GetClassColorStr(select(2, UnitClass(sender)))..sender.."|r"

        if data[1] then -- lock
            F:Print(L["%s lock %s on %s."]:format(sender, F:GetMarkEscapeSequence(data[2]), data[3]))
        else
            F:Print(L["%s unlock %s from %s."]:format(sender, F:GetMarkEscapeSequence(data[2]), data[3]))
        end
    end
end)

function F:NotifyMarkLock(mark, name, class)
    name = F:GetClassColorStr(class)..name.."|r"
    F:Print(L["%s lock %s on %s."]:format(L["You"], F:GetMarkEscapeSequence(mark), name))
    
    UpdateSendChannel()
    Comm:SendCommMessage("CELL_MARKS", Serialize({true, mark, name}), sendChannel, nil, "ALERT")
end

function F:NotifyMarkUnlock(mark, name, class)
    name = F:GetClassColorStr(class)..name.."|r"
    F:Print(L["%s unlock %s from %s."]:format(L["You"], F:GetMarkEscapeSequence(mark), name))

    UpdateSendChannel()
    Comm:SendCommMessage("CELL_MARKS", Serialize({false, mark, name}), sendChannel, nil, "ALERT")
end

-----------------------------------------
-- Priority Check
-----------------------------------------
local myPriority
local highestPriority = 99
Cell.hasHighestPriority = false

local function UpdatePriority()
    myPriority = 99
    if UnitIsGroupLeader("player") then
        myPriority = 0
    else
        if IsInRaid() then
            for i = 1, GetNumGroupMembers() do
                if UnitIsUnit("player", "raid"..i) then
                    myPriority = i
                    break
                end
            end
        elseif IsInGroup() then -- party
            local players = {}
            local pName, pRealm = UnitFullName("player")
            pRealm = pRealm or GetRealmName()
            pName = pName.."-"..pRealm
            tinsert(players, pName)
            
            for i = 1, GetNumGroupMembers()-1 do
                local name, realm = UnitFullName("party"..i)
                tinsert(players, name.."-"..(realm or pRealm))
            end
            table.sort(players)
            
            for i, p in pairs(players) do
                if p == pName then
                    myPriority = i
                    break
                end
            end
        end
    end

end

local t_check, t_send, t_update
function F:CheckPriority()
    UpdatePriority()
    -- NOTE: needs time to calc myPriority
    C_Timer.After(1, function()
        UpdateSendChannel()
        Comm:SendCommMessage("CELL_CPRIO", "chk", sendChannel, nil, "ALERT")
    end)
    -- if t_check then t_check:Cancel() end
    -- t_check = C_Timer.NewTimer(2, function()
    --     UpdateSendChannel()
    --     Comm:SendCommMessage("CELL_CPRIO", "chk", sendChannel, nil, "BULK")
    -- end)
end

Comm:RegisterComm("CELL_CPRIO", function(prefix, message, channel, sender)
    if not myPriority then return end -- receive CELL_CPRIO just after GOURP_JOINED 
    highestPriority = 99
    
    -- NOTE: wait for check requests
    if t_send then t_send:Cancel() end
    t_send = C_Timer.NewTimer(2, function()
        UpdateSendChannel()
        Comm:SendCommMessage("CELL_PRIO", tostring(myPriority), sendChannel, nil, "ALERT")
    end)
end)

Comm:RegisterComm("CELL_PRIO", function(prefix, message, channel, sender)
    if not myPriority then return end -- receive CELL_PRIO just after GOURP_JOINED

    local p = tonumber(message)
    if p then
        highestPriority = highestPriority < p and highestPriority or p

        if t_update then t_update:Cancel() end
        t_update = C_Timer.NewTimer(2, function()
            Cell.hasHighestPriority = myPriority <= highestPriority
            Cell:Fire("UpdatePriority", Cell.hasHighestPriority)
            F:Debug("|cff00ff00UpdatePriority:|r", Cell.hasHighestPriority)
        end)
    end
end)

-----------------------------------------
-- nickname
-----------------------------------------
Cell.vars.nicknames = {}
Cell.vars.nicknameCustoms = {}

local nic_check, nic_send

local function UpdateName(who)
    F:Debug("|cFF69A000UpdateName:|r|cFF696969", who, Cell.vars.nicknames[who], Cell.vars.nicknameCustoms[who])
    -- update name
    local b1, b2 = F:GetUnitButtonByName(who)
    if b1 then
        b1.indicators.nameText:UpdateName()
        if b2 then b2.indicators.nameText:UpdateName() end
    else
        if strfind(who, "-") then
            who = F:ToShortName(who)
        else
            who = who.."-"..GetNormalizedRealmName()
        end
        b1, b2 = F:GetUnitButtonByName(who)
        if b1 then b1.indicators.nameText:UpdateName() end
        if b2 then b2.indicators.nameText:UpdateName() end
    end
end

local function CheckNicknames()
    if IsInGroup() then
        if CellDB["nicknames"]["sync"] then
            if nic_check then nic_check:Cancel() end
            nic_check = C_Timer.NewTimer(random(3), function()
                UpdateSendChannel()
                Comm:SendCommMessage("CELL_CNIC", "chk", sendChannel, nil, "ALERT")
            end)
        end
    end
end

local function CheckSelf()
    Cell.vars.nicknames[Cell.vars.playerNameShort] = Cell.vars.playerNickname
    UpdateName(Cell.vars.playerNameShort)

    -- update preview buttons
    if CellLayoutsPreviewButton then
        CellLayoutsPreviewButton.indicators.nameText:UpdateName()
    end
    if CellIndicatorsPreviewButton then
        CellIndicatorsPreviewButton.indicators.nameText:UpdateName()
    end
    if CellRaidDebuffsPreviewButton then
        CellRaidDebuffsPreviewButton.indicators.nameText:UpdateName()
    end
    if CellGlowsPreviewButton then
        CellGlowsPreviewButton.indicators.nameText:UpdateName()
    end
end

-- events -----------------------------
local nickname = CreateFrame("Frame")
nickname:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

nickname:RegisterEvent("PLAYER_ENTERING_WORLD")

function nickname:PLAYER_ENTERING_WORLD()
    nickname:UnregisterEvent("PLAYER_ENTERING_WORLD")
    Cell:Fire("UpdateNicknames")
end

function nickname:GROUP_ROSTER_UPDATE()
    CheckNicknames()
end
---------------------------------------

local function UpdateNicknames(which, value1, value2)
    F:Debug("|cFF80FF00UpdateNicknames:|r", which, value1, value2)
    -- init
    if not which then
        Cell.vars.playerNickname = CellDB["nicknames"]["mine"] ~= "" and CellDB["nicknames"]["mine"] or nil
        Cell.vars.nicknameCustomEnabled = CellDB["nicknames"]["custom"]
        CheckSelf()
        
        if CellDB["nicknames"]["sync"] then
            CheckNicknames()
            nickname:RegisterEvent("GROUP_ROSTER_UPDATE")
        end

        -- customs
        for _, v in ipairs(CellDB["nicknames"]["list"]) do
            local playerName, nickname = strsplit(":", v, 2)
            if playerName and nickname then
                Cell.vars.nicknameCustoms[playerName] = nickname
                if CellDB["nicknames"]["custom"] then
                    UpdateName(playerName)
                end
            end
        end
    end

    -- enable/disable sync
    if which == "sync" then
        if CellDB["nicknames"]["sync"] then
            CheckNicknames()
            nickname:RegisterEvent("GROUP_ROSTER_UPDATE")
        else
            -- clear all except mine
            F:RemoveElementsExceptKeys(Cell.vars.nicknames, Cell.vars.playerNameShort)
            nickname:UnregisterEvent("GROUP_ROSTER_UPDATE")

            if nic_check then nic_check:Cancel() end
            -- disabled, notify others
            UpdateSendChannel()
            Comm:SendCommMessage("CELL_NIC", "CELL_NONE", sendChannel)

            -- update all
            F:IterateAllUnitButtons(function(b)
                b.indicators.nameText:UpdateName()
            end, true)
        end
    end

    -- player changed nickname
    if which == "mine" then
        Cell.vars.playerNickname = CellDB["nicknames"]["mine"] ~= "" and CellDB["nicknames"]["mine"] or nil
        
        -- update self
        CheckSelf()
        
        -- notify others
        if IsInGroup() and CellDB["nicknames"]["sync"] then
            UpdateSendChannel()
            Comm:SendCommMessage("CELL_NIC", Cell.vars.playerNickname or "CELL_NONE", sendChannel)
        end
    end

    -- customs
    if which == "custom" then
        Cell.vars.nicknameCustomEnabled = CellDB["nicknames"]["custom"]
        -- update now
        for playerName in pairs(Cell.vars.nicknameCustoms) do
            UpdateName(playerName)
        end
    end
    
    -- list
    if which == "list-add" then
        Cell.vars.nicknameCustoms[value1] = value2
        UpdateName(value1)
    end
    if which == "list-delete" then
        Cell.vars.nicknameCustoms[value1] = nil
        UpdateName(value1)
    end
end
Cell:RegisterCallback("UpdateNicknames", "UpdateNicknames", UpdateNicknames)

-- check nickname received
Comm:RegisterComm("CELL_CNIC", function(prefix, message, channel, sender)
    -- others send chk before you, no need to send chk again
    if nic_check then nic_check:Cancel() end

    if nic_send then nic_send:Cancel() end
    nic_send = C_Timer.NewTimer(3, function()
        UpdateSendChannel()
        if CellDB["nicknames"]["sync"] then
            Comm:SendCommMessage("CELL_NIC", Cell.vars.playerNickname or "CELL_NONE", sendChannel)
        else
            Comm:SendCommMessage("CELL_NIC", "CELL_NONE", sendChannel)
        end
    end)
end)

-- nickname received
Comm:RegisterComm("CELL_NIC", function(prefix, message, channel, sender)
    if sender == Cell.vars.playerNameShort then return end

    if CellDB["nicknames"]["sync"] then
        if message == "CELL_NONE" then
            Cell.vars.nicknames[sender] = nil
        else
            Cell.vars.nicknames[sender] = message
        end
        UpdateName(sender)
    end
end)

-----------------------------------------
-- cross realm send
-----------------------------------------
local function CrossRealmSendCommMessage(prefix, message, playerName, priority, callbackFn)
    -- NOTE: unit needs to be in your group, or it will always return true
    if UnitIsSameServer(playerName) then
        Comm:SendCommMessage(prefix, message, "WHISPER", playerName, priority, callbackFn)
    else
        if UnitInParty(playerName) then
            Comm:SendCommMessage(prefix, playerName..":"..message, "PARTY", nil, priority, callbackFn)
        elseif UnitInRaid(playerName) then
            Comm:SendCommMessage(prefix, playerName..":"..message, "RAID", nil, priority, callbackFn)
        end
    end
end

-----------------------------------------
-- Send / Receive Raid Debuffs
-----------------------------------------
local function filterFunc(self, event, msg, player, arg1, arg2, arg3, flag, channelId, ...)
    local newMsg = ""

    local type = msg:match("%[Cell:(.+): .+]")
    if type == "Debuffs" then
        local bossName, instanceName, playerName = msg:match("%[Cell:Debuffs: (.+) %((.+)%) %- ([^%s]+%-[^%s]+)%]")
        if bossName and instanceName and playerName then
            newMsg = "|Hgarrmission:cell-debuffs|h|cFFFF0066["..L[type]..": "..bossName.." ("..instanceName..") - "..playerName.."]|h|r"
        else
            instanceName, playerName = msg:match("%[Cell:Debuffs: (.+) %- ([^%s]+%-[^%s]+)%]")
            if instanceName and playerName then
                newMsg = "|Hgarrmission:cell-debuffs|h|cFFFF0066["..L[type]..": "..instanceName.." - "..playerName.."]|h|r"
            end
        end
    elseif type == "Layout" then
        local layoutName, playerName = msg:match("%[Cell:Layout: (.+) %- ([^%s]+%-[^%s]+)%]")
        if layoutName and playerName then
            if layoutName == "default" then
                -- NOTE: convert "default"
                layoutName = _G.DEFAULT
            end
            newMsg = "|Hgarrmission:cell-layout|h|cFFFF0066["..L[type]..": "..layoutName.." - "..playerName.."]|h|r"
        end
    end

    if newMsg ~= "" then
        return false, newMsg, player, arg1, arg2, arg3, flag, channelId, ...
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filterFunc)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filterFunc)

local isRequesting

-- NOTE: received
Comm:RegisterComm("CELL_SEND", function(prefix, message, channel, sender)
    if not isRequesting then return end
    if channel ~= "WHISPER" then
        local target
        target, message = strsplit(":", message, 2)
        if target ~= Cell.vars.playerNameFull then
            return
        end
    end

    local receivedData = Deserialize(message)

    if Cell.frames.receivingFrame then
        if receivedData then
            Cell.frames.receivingFrame:ShowImport(true, receivedData, function()
                isRequesting = false
            end)
        else
            Cell.frames.receivingFrame:ShowImport(false, nil, function()
                isRequesting = false
            end)
        end
    end
end)

-- NOTE: progress received
Comm:RegisterComm("CELL_SEND_PROG", function(prefix, message, channel, sender)
    if not isRequesting then return end
    if channel ~= "WHISPER" then
        local target
        target, message = strsplit(":", message, 2)
        if target ~= Cell.vars.playerNameFull then
            return
        end
    end
    
    local done, total = strsplit("|", message)
    done, total = tonumber(done), tonumber(total)

    if Cell.frames.receivingFrame then
        Cell.frames.receivingFrame:ShowProgress(done, total)
    end
end)

-- NOTE: request received
Comm:RegisterComm("CELL_REQ", function(prefix, message, channel, requester)
    if channel ~= "WHISPER" then
        local target
        target, message = strsplit(":", message, 2)
        if target ~= Cell.vars.playerNameFull then
            return
        end
    end

    -- check request
    local type, name1, name2 = strsplit(":", message)
    local requestData

    -- print(type, name1, name2)
    if type == "Debuffs" then
        local instanceId, bossId = F:GetInstanceAndBossId(name1, name2)
        if not instanceId then return end -- invalid instanceName

        requestData = {
            ["type"] = "Debuffs",
            ["instanceId"] = instanceId,
            ["bossId"] = bossId,
            ["version"] = Cell.versionNum
        }

        -- check db
        if not bossId then -- all bosses
            if CellDB["raidDebuffs"][instanceId] then
                requestData["data"] = CellDB["raidDebuffs"][instanceId]
            end
        else
            if CellDB["raidDebuffs"][instanceId] and CellDB["raidDebuffs"][instanceId][bossId] then
                requestData["data"] = CellDB["raidDebuffs"][instanceId][bossId]
            end
        end
    elseif type == "Layout" then
        if name1 == _G.DEFAULT then
            -- NOTE: convert "DEFAULT"
            name1 = "default"
        end
        if name1 and CellDB["layouts"][name1] then
            requestData = {
                ["type"] = "Layout",
                ["name"] = name1,
                ["version"] = Cell.versionNum,
                ["data"] = CellDB["layouts"][name1]
            }
        end
    end

    -- texplore(requestData)

    if not requestData then return end
    CrossRealmSendCommMessage("CELL_SEND", Serialize(requestData), requester, "BULK", function(arg, done, total)
        -- send progress
        CrossRealmSendCommMessage("CELL_SEND_PROG", done.."|"..total, requester, "ALERT")
    end)
end)

local function ShowReceivingFrame(type, playerName, name1, name2)
    if not Cell.frames.receivingFrame then
        Cell.frames.receivingFrame = Cell:CreateReceivingFrame(Cell.frames.mainFrame)
        Cell.frames.receivingFrame:SetOnCancel(function(b)
            isRequesting = false
        end)
    end
    
    Cell.frames.receivingFrame:SetOnRequest(function(b)
        isRequesting = true
        --! send request
        CrossRealmSendCommMessage("CELL_REQ", type..":"..name1..":"..(name2 or ""), playerName, "ALERT")
    end)
    
    Cell.frames.receivingFrame:ShowFrame(type, playerName, name1, name2)
end

hooksecurefunc("SetItemRef", function(link, text)
    if isRequesting then return end
    if link == "garrmission:cell-debuffs" then
        local bossName, instanceName, playerName = text:match("|Hgarrmission:cell%-debuffs|h|cFFFF0066%[.+: (.+) %((.+)%) %- ([^%s]+%-[^%s]+)%]|h|r")
        if bossName and instanceName and playerName then
            ShowReceivingFrame("Debuffs", playerName, instanceName, bossName)
        else
            instanceName, playerName = text:match("|Hgarrmission:cell%-debuffs|h|cFFFF0066%[.+: (.+) %- ([^%s]+%-[^%s]+)%]|h|r")
            ShowReceivingFrame("Debuffs", playerName, instanceName)
        end
    elseif link == "garrmission:cell-layout" then
        local layoutName, playerName = text:match("|Hgarrmission:cell%-layout|h|cFFFF0066%[.+: (.+) %- ([^%s]+%-[^%s]+)%]|h|r")
        ShowReceivingFrame("Layout", playerName, layoutName)
    end
end)