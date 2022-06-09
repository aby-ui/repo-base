
--[=[

Please refer to the docs.txt within this file folder for a guide on how to use this library.
If you get lost on implementing the lib, be free to contact Tercio on Details! discord: https://discord.gg/AGSzAZX or email to terciob@gmail.com

UnitID:
    UnitID use: "player", "target", "raid18", "party3", etc...
    If passing the unit name, use GetUnitName(unitId, true) or Ambiguate(playerName, 'none')

Code Rules:
    - When a function or variable name refers to 'Player', it indicates the local player.
    - When 'Unit' is use instead, it indicates any entity.
    - Internal callbacks are the internal communication of the library, e.g. when an event triggers it send to all modules that registered that event.
    - Public callbacks are callbacks registered by an external addon.

Change Log:
    - if Ace Comm is installed, use it
    - added "KeystoneWipe" callback
    - finished keystone info, see docs
    - added interrupts to cooldown tracker, new filter: "interrupt"
    - after encounter_end cooldowns now check for cooldowns reset.
    - each module now controls what to do with regen_enabled.
    - filter cooldowns done.
    - move portions of the code to other files to make this one smaller.
    - major function and variables rename.
    - implemented pvp talents.
    - player information is always available even when not in a group.
    - added cooldown check to se which cooldown has removed or added into the list.
    - added two new callbacks: "CooldownAdded" and "CooldownRemoved", see documents.

TODO:
    - make talents changes also send only cooldowns added or changed
    - add into gear info how many tier set parts the player has
    - raid lockouts normal-heroic-mythic
    - soulbind character (covenant choise) - probably not used in 10.0
    
BUGS:
    - after a /reload, it is not starting new tickers for spells under cooldown
    
--]=]


--don't load if it's not retail, emergencial patch due to classic and bcc stuff not transposed yet
if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
    return
end

local major = "LibOpenRaid-1.0"
local CONST_LIB_VERSION = 43
LIB_OPEN_RAID_CAN_LOAD = false

--declae the library within the LibStub
    local libStub = _G.LibStub
    local openRaidLib = libStub:NewLibrary(major, CONST_LIB_VERSION)
    if (not openRaidLib) then
        return
    end

    LIB_OPEN_RAID_CAN_LOAD = true
    
--default values
    openRaidLib.inGroup = false
    openRaidLib.UnitIDCache = {}

    --show failures (when the function return an error) results to chat
    local CONST_DIAGNOSTIC_ERRORS = false
    --show the data to be sent and data received from comm
    local CONST_DIAGNOSTIC_COMM = false

    local CONST_COMM_PREFIX = "LRS"
    local CONST_COMM_FULLINFO_PREFIX = "F"

    local CONST_COMM_COOLDOWNUPDATE_PREFIX = "U"
    local CONST_COMM_COOLDOWNFULLLIST_PREFIX = "C"
    local CONST_COMM_COOLDOWNCHANGES_PREFIX = "S"

    local CONST_COMM_GEARINFO_FULL_PREFIX = "G"
    local CONST_COMM_GEARINFO_DURABILITY_PREFIX = "R"

    local CONST_COMM_PLAYER_DEAD_PREFIX = "D"
    local CONST_COMM_PLAYER_ALIVE_PREFIX = "A"
    local CONST_COMM_PLAYERINFO_PREFIX = "P"
    local CONST_COMM_PLAYERINFO_TALENTS_PREFIX = "T"
    local CONST_COMM_PLAYERINFO_PVPTALENTS_PREFIX = "V"

    local CONST_COMM_KEYSTONE_DATA_PREFIX = "K"
    local CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX = "J"

    local CONST_COMM_SENDTO_PARTY = "0x1"
    local CONST_COMM_SENDTO_RAID = "0x2"
    local CONST_COMM_SENDTO_GUILD = "0x4"

    local CONST_ONE_SECOND = 1.0
    local CONST_TWO_SECONDS = 2.0
    local CONST_THREE_SECONDS = 3.0

    local CONST_COOLDOWN_CHECK_INTERVAL = CONST_TWO_SECONDS
    local CONST_COOLDOWN_TIMELEFT_HAS_CHANGED = CONST_TWO_SECONDS

    local CONST_COOLDOWN_INDEX_TIMELEFT = 1
    local CONST_COOLDOWN_INDEX_CHARGES = 2
    local CONST_COOLDOWN_INDEX_TIMEOFFSET = 3
    local CONST_COOLDOWN_INDEX_DURATION = 4
    local CONST_COOLDOWN_INDEX_UPDATETIME = 5

    function openRaidLib.ShowDiagnosticErrors(value)
        CONST_DIAGNOSTIC_ERRORS = value
    end

    --make the 'pri-nt' word be only used once, this makes easier to find lost debug pri-nts in the code
    local sendChatMessage = function(...)
        print(...)
    end

    openRaidLib.DiagnosticError = function(msg, ...)
        if (CONST_DIAGNOSTIC_ERRORS) then
            sendChatMessage("|cFFFF9922OpenRaidLib|r:", msg, ...)
        end
    end

    local diagnosticComm = function(msg, ...)
        if (CONST_DIAGNOSTIC_COMM) then
            sendChatMessage("|cFFFF9922OpenRaidLib|r:", msg, ...)
        end
    end

    openRaidLib.DeprecatedMessage = function(msg)
        sendChatMessage("|cFFFF9922OpenRaidLib|r:", "|cFFFF5555" .. msg .. "|r")
    end

    local isTimewalkWoW = function()
        local gameVersion = GetBuildInfo()
        if (gameVersion:match("%d") == "1" or gameVersion:match("%d") == "2") then
            return true
        end
    end

    local checkClientVersion = function(...)
        for i = 1, select("#", ...) do
            local clientVersion = select(i, ...)

            if (clientVersion == "retail" and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then --retail
                return true

            elseif (clientVersion == "classic_era" and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then --classic era (vanila)
                return true

            elseif (clientVersion == "bcc" and WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then --the burning crusade classic
                return true
            end
        end
    end

--------------------------------------------------------------------------------------------------------------------------------
--> ~comms
    openRaidLib.commHandler = {}

    function openRaidLib.commHandler.OnReceiveComm(self, event, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
        --check if the data belong to us
        if (prefix == CONST_COMM_PREFIX) then

            sender = Ambiguate(sender, "none")

            --don't receive comms from the player it self
            local playerName = UnitName("player")
            if (playerName == sender) then
                return
            end

            local data = text
            local LibDeflate = LibStub:GetLibrary("LibDeflate")
            local dataCompressed = LibDeflate:DecodeForWoWAddonChannel(data)
            data = LibDeflate:DecompressDeflate(dataCompressed)

            --some users are reporting errors where 'data is nil'. Making some sanitization
            if (not data) then
                openRaidLib.DiagnosticError("Invalid data from player:", sender, "data:", text)
                return
            elseif (type(data) ~= "string") then
                openRaidLib.DiagnosticError("Invalid data from player:", sender, "data:", text, "data type is:", type(data))
                return
            end

            --get the first byte of the data, it indicates what type of data was transmited
            local dataTypePrefix = data:match("^.")
            if (not dataTypePrefix) then
                openRaidLib.DiagnosticError("Invalid dataTypePrefix from player:", sender, "data:", data, "dataTypePrefix:", dataTypePrefix)
                return
            elseif (openRaidLib.commPrefixDeprecated[dataTypePrefix]) then
                openRaidLib.DiagnosticError("Invalid dataTypePrefix from player:", sender, "data:", data, "dataTypePrefix:", dataTypePrefix)
                return
            end

            --if this is isn't a keystone data comm, check if the lib can receive comms
            if (dataTypePrefix ~= CONST_COMM_KEYSTONE_DATA_PREFIX and dataTypePrefix ~= CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX) then
                if (not openRaidLib.IsCommAllowed()) then
                    openRaidLib.DiagnosticError("comm not allowed.")
                    return
                end
            end

            --get the table with functions regitered for this type of data
            local callbackTable = openRaidLib.commHandler.commCallback[dataTypePrefix]
            if (not callbackTable) then
                openRaidLib.DiagnosticError("Not callbackTable for dataTypePrefix:", dataTypePrefix, "from player:", sender, "data:", data)
                return
            end

            --convert to table
            local dataAsTable = {strsplit(",", data)}

            --remove the first index (prefix)
            tremove(dataAsTable, 1)

            --trigger callbacks
            for i = 1, #callbackTable do
                callbackTable[i](dataAsTable, sender)
            end
        end
    end

    C_ChatInfo.RegisterAddonMessagePrefix(CONST_COMM_PREFIX)
    openRaidLib.commHandler.eventFrame = CreateFrame("frame")
    openRaidLib.commHandler.eventFrame:RegisterEvent("CHAT_MSG_ADDON")
    openRaidLib.commHandler.eventFrame:SetScript("OnEvent", openRaidLib.commHandler.OnReceiveComm)

    openRaidLib.commHandler.commCallback = {
                                            --when transmiting
        [CONST_COMM_FULLINFO_PREFIX] = {}, --update all
        [CONST_COMM_COOLDOWNFULLLIST_PREFIX] = {}, --all cooldowns of a player
        [CONST_COMM_COOLDOWNUPDATE_PREFIX] = {}, --an update of a single cooldown
        [CONST_COMM_COOLDOWNCHANGES_PREFIX] = {}, --cooldowns got added or removed
        [CONST_COMM_GEARINFO_FULL_PREFIX] = {}, --an update of gear information
        [CONST_COMM_GEARINFO_DURABILITY_PREFIX] = {}, --an update of the player gear durability
        [CONST_COMM_PLAYER_DEAD_PREFIX] = {}, --player is dead
        [CONST_COMM_PLAYER_ALIVE_PREFIX] = {}, --player is alive
        [CONST_COMM_PLAYERINFO_PREFIX] = {}, --info about the player
        [CONST_COMM_PLAYERINFO_TALENTS_PREFIX] = {}, --talents info
        [CONST_COMM_PLAYERINFO_PVPTALENTS_PREFIX] = {}, --pvp talents info
        [CONST_COMM_KEYSTONE_DATA_PREFIX] = {}, --received keystone data
        [CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX] = {}, --received a request to send keystone data
    }

    function openRaidLib.commHandler.RegisterComm(prefix, func)
        --the table for the prefix need to be declared at the 'openRaidLib.commHandler.commCallback' table
        tinsert(openRaidLib.commHandler.commCallback[prefix], func)
    end

    --@flags
    --0x1: to party
    --0x2: to raid
    --0x4: to guild
    local sendData = function(dataEncoded, channel)
        local aceComm = LibStub:GetLibrary("AceComm-3.0")
        if (aceComm) then
            aceComm:SendCommMessage(CONST_COMM_PREFIX, dataEncoded, channel, nil, "ALERT")
        else
            C_ChatInfo.SendAddonMessage(CONST_COMM_PREFIX, dataEncoded, channel)
        end
    end

    function openRaidLib.commHandler.SendCommData(data, flags)
        local LibDeflate = LibStub:GetLibrary("LibDeflate")
        local dataCompressed = LibDeflate:CompressDeflate(data, {level = 9})
        local dataEncoded = LibDeflate:EncodeForWoWAddonChannel(dataCompressed)

        if (flags) then
            if (bit.band(flags, CONST_COMM_SENDTO_PARTY)) then --send to party
                if (IsInGroup() and not IsInRaid()) then
                    sendData(dataEncoded, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
                end
            end

            if (bit.band(flags, CONST_COMM_SENDTO_RAID)) then --send to raid
                if (IsInRaid()) then
                    sendData(dataEncoded, IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID")
                end
            end

            if (bit.band(flags, CONST_COMM_SENDTO_GUILD)) then --send to guild
                if (IsInGuild()) then
                    sendData(dataEncoded, "GUILD")
                end
            end
        else
            if (IsInGroup() and not IsInRaid()) then --in party only
                sendData(dataEncoded, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")

            elseif (IsInRaid()) then
                sendData(dataEncoded, IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID")
            end
        end
	end


--------------------------------------------------------------------------------------------------------------------------------
--> ~schedule ~timers

    openRaidLib.Schedules = {
        registeredUniqueTimers = {}
    }
    
    --run a scheduled function with its payload
    local triggerScheduledTick = function(tickerObject)
        local payload = tickerObject.payload
        local callback = tickerObject.callback
    
        local result, errortext = pcall(callback, _G.unpack(payload))
        if (not result) then
            sendChatMessage("openRaidLib: error on scheduler:", tickerObject.scheduleName, tickerObject.stack, errortext)
        end

        if (tickerObject.isUnique) then
            local namespace = tickerObject.namespace
            local scheduleName = tickerObject.scheduleName
            openRaidLib.Schedules.CancelUniqueTimer(namespace, scheduleName)
        end

        return result
    end

    --create a new schedule
    function openRaidLib.Schedules.NewTimer(time, callback, ...)
        local payload = {...}
        local newTimer = C_Timer.NewTimer(time, triggerScheduledTick)
        newTimer.payload = payload
        newTimer.callback = callback
        newTimer.stack = debugstack()
        return newTimer
    end

    --create an unique schedule
    --if a schedule already exists, cancels it and make a new
    function openRaidLib.Schedules.NewUniqueTimer(time, callback, namespace, scheduleName, ...)
        openRaidLib.Schedules.CancelUniqueTimer(namespace, scheduleName)

        local newTimer = openRaidLib.Schedules.NewTimer(time, callback, ...)
        newTimer.namespace = namespace
        newTimer.scheduleName = scheduleName
        newTimer.stack = debugstack()
        newTimer.isUnique = true

        local registeredUniqueTimers = openRaidLib.Schedules.registeredUniqueTimers
        registeredUniqueTimers[namespace] = registeredUniqueTimers[namespace] or {}
        registeredUniqueTimers[namespace][scheduleName] = newTimer
    end

    --cancel an unique schedule
    function openRaidLib.Schedules.CancelUniqueTimer(namespace, scheduleName)
        local registeredUniqueTimers = openRaidLib.Schedules.registeredUniqueTimers
        local currentSchedule = registeredUniqueTimers[namespace] and registeredUniqueTimers[namespace][scheduleName]

        if (currentSchedule) then
            if (not currentSchedule._cancelled) then
                currentSchedule:Cancel()
            end
            registeredUniqueTimers[namespace][scheduleName] = nil
        end
    end

    --cancel all unique timers
    function openRaidLib.Schedules.CancelAllUniqueTimers()
        local registeredUniqueTimers = openRaidLib.Schedules.registeredUniqueTimers
        for namespace, schedulesTable in pairs(registeredUniqueTimers) do
            for scheduleName, timerObject in pairs (schedulesTable) do
                if (timerObject and not timerObject._cancelled) then
                    timerObject:Cancel()
                end
            end
        end
        table.wipe(registeredUniqueTimers)
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~public ~callbacks
--these are the events where other addons can register and receive calls
    local allPublicCallbacks = {
        "CooldownListUpdate",
        "CooldownListWipe",
        "CooldownUpdate",
        "CooldownAdded",
        "CooldownRemoved",
        "UnitDeath",
        "UnitAlive",
        "GearListWipe",
        "GearUpdate",
        "GearDurabilityUpdate",
        "UnitInfoUpdate",
        "UnitInfoWipe",
        "TalentUpdate",
        "PvPTalentUpdate",
        "KeystoneUpdate",
        "KeystoneWipe",
    }

    --save build the table to avoid lose registered events on older versions
    openRaidLib.publicCallback = openRaidLib.publicCallback or {}
    openRaidLib.publicCallback.events = openRaidLib.publicCallback.events or {}
    for _, callbackName in ipairs(allPublicCallbacks) do
        openRaidLib.publicCallback.events[callbackName] = openRaidLib.publicCallback.events[callbackName] or {}
    end

    local checkRegisterDataIntegrity = function(addonObject, event, callbackMemberName)
        --check of integrity
        if (type(addonObject) == "string") then
            addonObject = _G[addonObject]
        end

        if (type(addonObject) ~= "table") then
            return 1
        end

        if (not openRaidLib.publicCallback.events[event]) then
            return 2

        elseif (not addonObject[callbackMemberName]) then
            return 3
        end

        return true
    end

    --call the registered function within the addon namespace
    --payload is sent together within the call
    function openRaidLib.publicCallback.TriggerCallback(event, ...)
        local callbacks = openRaidLib.publicCallback.events[event]

        for i = 1, #callbacks do
            local addonObject = callbacks[i][1]
            local functionName = callbacks[i][2]
            local func = addonObject[functionName]

            if (func) then
                --using pcall at the moment, should get a better caller in the future
                local okay, errorMessage = pcall(func, ...)
                if (not okay) then
                    sendChatMessage("error:", errorMessage)
                end
            end
        end
    end
    
    function openRaidLib.RegisterCallback(addonObject, event, callbackMemberName)
        --check of integrity
        local integrity = checkRegisterDataIntegrity(addonObject, event, callbackMemberName)
        if (integrity and type(integrity) ~= "boolean") then
            return integrity
        end

        --register
        tinsert(openRaidLib.publicCallback.events[event], {addonObject, callbackMemberName})
        return true
    end

    function openRaidLib.UnregisterCallback(addonObject, event, callbackMemberName)
        --check of integrity
        local integrity = checkRegisterDataIntegrity(addonObject, event, callbackMemberName)
        if (integrity and type(integrity) ~= "boolean") then
            return integrity
        end

        for i = 1, #openRaidLib.publicCallback.events[event] do
            local registeredCallback = openRaidLib.publicCallback.events[event][i]
            if (registeredCallback[1] == addonObject and registeredCallback[2] == callbackMemberName) then
                tremove(openRaidLib.publicCallback.events[event], i)
                break
            end
        end
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~internal ~callbacks
--internally, each module can register events through the internal callback to be notified when something happens in the game

    openRaidLib.internalCallback = {}
    openRaidLib.internalCallback.events = {
        ["onEnterGroup"] = {},
        ["onLeaveGroup"] = {},
        ["onLeaveCombat"] = {},
        ["playerCast"] = {},
        ["onEnterWorld"] = {},
        ["talentUpdate"] = {},
        ["pvpTalentUpdate"] = {},
        ["onPlayerDeath"] = {},
        ["onPlayerRess"] = {},
        ["raidEncounterEnd"] = {},
        ["mythicDungeonStart"] = {},
        ["playerPetChange"] = {},
        ["mythicDungeonEnd"] = {},
    }

    openRaidLib.internalCallback.RegisterCallback = function(event, func)
        tinsert(openRaidLib.internalCallback.events[event], func)
    end

    openRaidLib.internalCallback.UnRegisterCallback = function(event, func)
        local container = openRaidLib.internalCallback.events[event]
        for i = 1, #container do
            if (container[i] == func) then
                tremove(container, i)
                break
            end
        end
    end

    function openRaidLib.internalCallback.TriggerEvent(event, ...)
        local container = openRaidLib.internalCallback.events[event]
        for i = 1, #container do
            container[i](event, ...)
        end
    end

    --create the frame for receiving game events
    local eventFrame = _G.OpenRaidLibFrame
    if (not eventFrame) then
        eventFrame = CreateFrame("frame", "OpenRaidLibFrame", UIParent)
    end

    local eventFunctions = {
        --check if the player joined a group
        ["GROUP_ROSTER_UPDATE"] = function()
            local eventTriggered = false
            if (openRaidLib.IsInGroup()) then
                if (not openRaidLib.inGroup) then
                    openRaidLib.inGroup = true
                    openRaidLib.internalCallback.TriggerEvent("onEnterGroup")
                    eventTriggered = true
                end
            else
                if (openRaidLib.inGroup) then
                    openRaidLib.inGroup = false
                    openRaidLib.internalCallback.TriggerEvent("onLeaveGroup")
                    eventTriggered = true
                end
            end

            if (not eventTriggered and openRaidLib.IsInGroup()) then --the player didn't left or enter a group
                --the group has changed, trigger a long timer to send full data
                --as the timer is unique, a new change to the group will replace and refresh the time
                --using random time, players won't trigger all at the same time
                local randomTime = 1.0 + math.random(1.0, 5.5)
                openRaidLib.Schedules.NewUniqueTimer(randomTime, openRaidLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
            end

            openRaidLib.UpdateUnitIDCache()
        end,

        ["UNIT_SPELLCAST_SUCCEEDED"] = function(...)
            local unitId, castGUID, spellId = ...
            C_Timer.After(0.1, function()
                --some spells has many different spellIds, get the default
                spellId = LIB_OPEN_RAID_SPELL_DEFAULT_IDS[spellId] or spellId
                --trigger internal callbacks
                openRaidLib.internalCallback.TriggerEvent("playerCast", spellId, UnitIsUnit(unitId, "pet"))
            end)
        end,

        ["PLAYER_ENTERING_WORLD"] = function(...)
            if (not openRaidLib.firstEnteringWorld) then
                --player logon
                if (IsInGroup()) then
                    openRaidLib.RequestAllData()
                end

                --> this part is under development
                    if (Details) then
                        local detailsEventListener = Details:CreateEventListener()

                        function detailsEventListener:UnitSpecFound(event, unitId, specId, unitGuid)
                            local unitName = GetUnitName(unitId, true) or unitId
                            if (not UnitInParty(unitName) and not UnitInRaid(unitName)) then
                                return
                            end

                            --check if there's unit information about this unit


                            --is still did not received a list of cooldowns from this player
                            if (not openRaidLib.CooldownManager.HasFullCooldownList[unitName]) then
                                --build a generic list from the spec

                            end
                        end

                        function detailsEventListener:UnitTalentsFound(event, unitId, talentTable, unitGuid)
                            local unitName = GetUnitName(unitId, true) or unitId
                            if (not UnitInParty(unitName) and not UnitInRaid(unitName)) then
                                return
                            end

                        end

                        detailsEventListener:RegisterEvent("UNIT_SPEC", "UnitSpecFound")
                        detailsEventListener:RegisterEvent("UNIT_TALENTS", "UnitTalentsFound")
                    end

                openRaidLib.firstEnteringWorld = true
            end
            
            openRaidLib.internalCallback.TriggerEvent("onEnterWorld")
        end,

        --["PLAYER_SPECIALIZATION_CHANGED"] = function(...) end, --on changing spec, the talent_update event is also triggered
        ["PLAYER_TALENT_UPDATE"] = function(...)
            openRaidLib.internalCallback.TriggerEvent("talentUpdate")
        end,

        ["PLAYER_PVP_TALENT_UPDATE"] = function(...)
            openRaidLib.internalCallback.TriggerEvent("pvpTalentUpdate")
        end,

        ["PLAYER_DEAD"] = function(...)
            openRaidLib.mainControl.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_ALIVE"] = function(...)
            openRaidLib.mainControl.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_UNGHOST"] = function(...)
            openRaidLib.mainControl.UpdatePlayerAliveStatus()
        end,

        ["PLAYER_REGEN_DISABLED"] = function(...)
            --entered in combat
        end,

        ["PLAYER_REGEN_ENABLED"] = function(...)
            openRaidLib.internalCallback.TriggerEvent("onLeaveCombat")
        end,

        ["UPDATE_INVENTORY_DURABILITY"] = function(...)
            --an item has changed its durability
            --do not trigger this event  while in combat
            if (not InCombatLockdown()) then
                openRaidLib.Schedules.NewUniqueTimer(5 + math.random(0, 4), openRaidLib.GearManager.SendDurability, "GearManager", "sendDurability_Schedule")
            end
        end,

        ["PLAYER_EQUIPMENT_CHANGED"] = function(...)
            --player changed an equipment
            openRaidLib.Schedules.NewUniqueTimer(4 + math.random(0, 5), openRaidLib.GearManager.SendAllGearInfo, "GearManager", "sendAllGearInfo_Schedule")
        end,

        ["ENCOUNTER_END"] = function()
            if (IsInRaid()) then
                openRaidLib.internalCallback.TriggerEvent("raidEncounterEnd")
            end
        end,

        ["CHALLENGE_MODE_START"] = function()
            openRaidLib.internalCallback.TriggerEvent("mythicDungeonStart")
        end,

        ["UNIT_PET"] = function(unitId)
            if (UnitIsUnit(unitId, "player")) then
                openRaidLib.Schedules.NewUniqueTimer(0.5, function() openRaidLib.internalCallback.TriggerEvent("playerPetChange") end, "mainControl", "petStatus_Schedule")
                --if the pet is alive, register to know when it dies
                if (UnitExists("pet") and UnitHealth("pet") >= 1) then
                    eventFrame:RegisterUnitEvent("UNIT_FLAGS", "pet")
                end
            end
        end,

        ["UNIT_FLAGS"] = function(unitId)
            local petHealth = UnitHealth(unitId)
            if (petHealth < 1) then
                eventFrame:UnregisterEvent("UNIT_FLAGS")
                openRaidLib.eventFunctions["UNIT_PET"]("player")
            end
        end,

        ["CHALLENGE_MODE_COMPLETED"] = function()
            openRaidLib.internalCallback.TriggerEvent("mythicDungeonEnd")
        end,
    }
    openRaidLib.eventFunctions = eventFunctions

    eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player", "pet")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    eventFrame:RegisterEvent("UNIT_PET")
    eventFrame:RegisterEvent("PLAYER_DEAD")
    eventFrame:RegisterEvent("PLAYER_ALIVE")
    eventFrame:RegisterEvent("PLAYER_UNGHOST")

    if (checkClientVersion("retail")) then
        eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
        eventFrame:RegisterEvent("PLAYER_PVP_TALENT_UPDATE")
        eventFrame:RegisterEvent("ENCOUNTER_END")
        eventFrame:RegisterEvent("CHALLENGE_MODE_START")
        eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
        --eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    end



    eventFrame:SetScript("OnEvent", function(self, event, ...)
        eventFunctions[event](...)
    end)

--------------------------------------------------------------------------------------------------------------------------------
--> ~main ~control

    openRaidLib.mainControl = {
        playerAliveStatus = {},
    }

    --send full data (all data available)
    function openRaidLib.mainControl.SendFullData()
        --send player data
        openRaidLib.UnitInfoManager.SendAllPlayerInfo()

        --send gear data
        openRaidLib.GearManager.SendAllGearInfo()

        --send cooldown data
        openRaidLib.CooldownManager.SendAllPlayerCooldowns()
    end

    openRaidLib.mainControl.onEnterWorld = function()
        --update the alive status of the player
        openRaidLib.mainControl.UpdatePlayerAliveStatus(true)

        --the game client is fully loadded and all information is available
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0, openRaidLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
        end
    end

    --update player data, even if not in group
    --called on every player_entering_world event
    openRaidLib.mainControl.UpdatePlayerData = function()
        local unitName = UnitName("player")
        --> player data
            local playerFullInfo = openRaidLib.UnitInfoManager.GetPlayerFullInfo()
            openRaidLib.UnitInfoManager.AddUnitInfo(unitName, unpack(playerFullInfo))

        --> gear info
            local playerGearInfo = openRaidLib.GearManager.GetPlayerFullGearInfo()
            openRaidLib.GearManager.AddUnitGearList(unitName, unpack(playerGearInfo))

        --> cooldowns
            openRaidLib.CooldownManager.UpdatePlayerCooldownsLocally()
    end

    --this function runs on all Player Entering World, it is delayed due to covenant data many times aren't available after a cold login
    function openRaidLib.mainControl.scheduleUpdatePlayerData()
        openRaidLib.Schedules.NewUniqueTimer(1.0, openRaidLib.mainControl.UpdatePlayerData, "mainControl", "updatePlayerData_Schedule")
    end

    function openRaidLib.UpdatePlayer()
        return openRaidLib.mainControl.UpdatePlayerData()
    end

    openRaidLib.mainControl.OnEnterGroup = function()
        --the player entered in a group
        --schedule to send data
        openRaidLib.Schedules.NewUniqueTimer(1.0, openRaidLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
    end

    openRaidLib.mainControl.OnLeftGroup = function()
        --the player left a group
        --wipe group data (each module registers the OnLeftGroup)

        --cancel all schedules
        openRaidLib.Schedules.CancelAllUniqueTimers()

        --wipe alive status
        table.wipe(openRaidLib.mainControl.playerAliveStatus)

        --toggle off comms
    end

    openRaidLib.mainControl.OnPlayerDeath = function()
        local playerName = UnitName("player")
        openRaidLib.mainControl.playerAliveStatus[playerName] = false

        local dataToSend = CONST_COMM_PLAYER_DEAD_PREFIX
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("OnPlayerDeath| " .. dataToSend) --debug

        openRaidLib.publicCallback.TriggerCallback("UnitDeath", "player")
    end

    openRaidLib.mainControl.OnPlayerRess = function()
        local playerName = UnitName("player")
        openRaidLib.mainControl.playerAliveStatus[playerName] = true

        local dataToSend = CONST_COMM_PLAYER_ALIVE_PREFIX
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("OnPlayerRess| " .. dataToSend) --debug

        openRaidLib.publicCallback.TriggerCallback("UnitAlive", "player")
    end

    openRaidLib.internalCallback.RegisterCallback("onEnterWorld", openRaidLib.mainControl.onEnterWorld)
    openRaidLib.internalCallback.RegisterCallback("onEnterWorld", openRaidLib.mainControl.scheduleUpdatePlayerData)
    openRaidLib.internalCallback.RegisterCallback("onEnterGroup", openRaidLib.mainControl.OnEnterGroup)
    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.mainControl.OnLeftGroup)
    openRaidLib.internalCallback.RegisterCallback("onPlayerDeath", openRaidLib.mainControl.OnPlayerDeath)
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.mainControl.OnPlayerRess)

    --a player in the group died
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYER_DEAD_PREFIX, function(data, unitName)
        openRaidLib.mainControl.playerAliveStatus[unitName] = false
        openRaidLib.publicCallback.TriggerCallback("UnitDeath", openRaidLib.GetUnitID(unitName))
    end)

    --a player in the group is now alive
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYER_ALIVE_PREFIX, function(data, unitName)
        openRaidLib.mainControl.playerAliveStatus[unitName] = true
        openRaidLib.publicCallback.TriggerCallback("UnitAlive", openRaidLib.GetUnitID(unitName))
    end)


    function openRaidLib.mainControl.UpdatePlayerAliveStatus(onLogin)
        if (UnitIsDeadOrGhost("player")) then
            if (openRaidLib.playerAlive) then
                openRaidLib.playerAlive = false

                --trigger event if this isn't from login
                if (not onLogin) then
                    openRaidLib.internalCallback.TriggerEvent("onPlayerDeath")
                end
            end
        else
            if (not openRaidLib.playerAlive) then
                openRaidLib.playerAlive = true

                --trigger event if this isn't from login
                if (not onLogin) then
                    openRaidLib.internalCallback.TriggerEvent("onPlayerRess")
                end
            end
        end
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~all, request data from all players

    --send a request to all players in the group to send their data
    function openRaidLib.RequestAllData()
		if (not IsInGroup()) then
			return
		end

        openRaidLib.requestAllInfoCooldown = openRaidLib.requestAllInfoCooldown or 0

        if (openRaidLib.requestAllInfoCooldown > GetTime()) then
            return
        end

        openRaidLib.commHandler.SendCommData(CONST_COMM_FULLINFO_PREFIX)
        diagnosticComm("RequestAllInfo| " .. CONST_COMM_FULLINFO_PREFIX) --debug

        openRaidLib.requestAllInfoCooldown = GetTime() + 5
        return true
    end

    openRaidLib.commHandler.RegisterComm(CONST_COMM_FULLINFO_PREFIX, function(data, sourceName)
        openRaidLib.sendRequestedAllInfoCooldown = openRaidLib.sendRequestedAllInfoCooldown or 0

        --some player in the group requested  all information from all players
        if (openRaidLib.sendRequestedAllInfoCooldown > GetTime()) then
            return
        end

        openRaidLib.Schedules.NewUniqueTimer(random() + math.random(0, 3), openRaidLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
        openRaidLib.sendRequestedAllInfoCooldown = GetTime() + 5
    end)


--------------------------------------------------------------------------------------------------------------------------------
--> ~player general ~info ~unit

    --> API calls
        --return a table containing all information of units
        --format: [playerName-realm] = {information}
        function openRaidLib.GetAllUnitsInfo()
            return openRaidLib.UnitInfoManager.GetAllUnitsInfo()
        end

        --return a table containing information of a single unit
        function openRaidLib.GetUnitInfo(unitId)
            local unitName = GetUnitName(unitId, true) or unitId
            return openRaidLib.UnitInfoManager.GetUnitInfo(unitName)
        end

    --> manager constructor
        openRaidLib.UnitInfoManager = {
            --structure:
            --[playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
            UnitData = {},
        }

        local unitTablePrototype = {
            specId = 0,
            specName = "",
            role = "",
            renown = 1,
            covenantId = 0,
            talents = {},
            conduits = {},
            pvpTalents = {},
            class = "",
            classId = 0,
            className = "",
            name = "",
            nameFull = "",
        }

    function openRaidLib.UnitInfoManager.GetAllUnitsInfo()
        return openRaidLib.UnitInfoManager.UnitData
    end

    --get the unit table or create a new one if 'createNew' is true
    function openRaidLib.UnitInfoManager.GetUnitInfo(unitName, createNew)
        local unitInfo = openRaidLib.UnitInfoManager.UnitData[unitName]
        if (not unitInfo and createNew) then
            unitInfo = {}
            openRaidLib.TCopy(unitInfo, unitTablePrototype)
            openRaidLib.UnitInfoManager.UnitData[unitName] = unitInfo
        end
        return unitInfo
    end

    function openRaidLib.UnitInfoManager.EraseData()
        table.wipe(openRaidLib.UnitInfoManager.UnitData)
    end

    function openRaidLib.UnitInfoManager.SetUnitInfo(unitName, unitInfo, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked, pvpTalentsTableUnpacked)
        if (not GetSpecializationInfoByID) then --tbc hot fix
            return
        end

        local specId, specName, specDescription, specIcon, role = GetSpecializationInfoByID(specId or 0)
        local className, classString, classId = UnitClass(unitName)

        unitInfo.specId = specId or unitInfo.specId
        unitInfo.specName = specName or unitInfo.specName
        unitInfo.role = role or "DAMAGER"
        unitInfo.renown = renown or unitInfo.renown
        unitInfo.covenantId = covenantId or unitInfo.covenantId
        unitInfo.talents = talentsTableUnpacked or unitInfo.talents
        unitInfo.conduits = conduitsTableUnpacked or unitInfo.conduits
        unitInfo.pvpTalents = pvpTalentsTableUnpacked or unitInfo.pvpTalents
        unitInfo.class = classString
        unitInfo.classId = classId
        unitInfo.className = className
        unitInfo.name = unitName:gsub(("%-.*"), "")
        unitInfo.nameFull = unitName
    end

    function openRaidLib.UnitInfoManager.AddUnitInfo(unitName, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked, pvpTalentsTableUnpacked)
        local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo(unitName, true)
        openRaidLib.UnitInfoManager.SetUnitInfo(unitName, unitInfo, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked, pvpTalentsTableUnpacked)
        openRaidLib.publicCallback.TriggerCallback("UnitInfoUpdate", openRaidLib.GetUnitID(unitName), openRaidLib.UnitInfoManager.UnitData[unitName], openRaidLib.UnitInfoManager.GetAllUnitsInfo())
    end

    --triggered when the lib receives a unit information from another player in the raid
    --@data: table received from comm
    --@unitName: player name
    function openRaidLib.UnitInfoManager.OnReceiveUnitFullInfo(data, unitName)
        local specId = tonumber(data[1])
        local renown = tonumber(data[2])

        local covenantId = tonumber(data[3])
        if (not covenantId or covenantId > 4) then --cleanup on 10.0
            --invalid covanentId
            return
        end

        local talentsSize = tonumber(data[4])
        if (not talentsSize or talentsSize > 7) then --talents rework on 10.0
            --invalid talents size
            return
        end

        local conduitsTableIndex = tonumber((talentsSize + 1) + 3) + 1 -- +3 for spec, renown and covenant data | talentSizeIndex + talentSize | +1 for talents size
        local conduitsSize = data[conduitsTableIndex]

        local pvpTalentsTableIndex = 3 + 3 + talentsSize + conduitsSize -- +3 for spec, renown and covenant data | +3 for talents, conduit and pvptalents index for size
        local pvpTalentsSize = data[pvpTalentsTableIndex]

        --unpack the talents data as a ipairs table
        local talentsTableUnpacked = openRaidLib.UnpackTable(data, 4, false, false, talentsSize)

        --unpack the conduits data as a ipairs table
        local conduitsTableUnpacked = openRaidLib.UnpackTable(data, conduitsTableIndex, false, false, conduitsSize)

        --back compatibility with versions without pvp talents
        if (type(data[pvpTalentsTableIndex]) == "string" or not data[pvpTalentsTableIndex]) then
            --add a dummy table as pvp talents
            openRaidLib.UnitInfoManager.AddUnitInfo(unitName, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked, {0, 0, 0})
            return
        end

        --unpack the pvp talents data as a ipairs table
        local pvpTalentsTableUnpacked = openRaidLib.UnpackTable(data, pvpTalentsTableIndex, false, false, pvpTalentsSize)

        --add to the list of players information and also trigger a public callback
        openRaidLib.UnitInfoManager.AddUnitInfo(unitName, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked, pvpTalentsTableUnpacked)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_PREFIX, openRaidLib.UnitInfoManager.OnReceiveUnitFullInfo)

function openRaidLib.UnitInfoManager.SendAllPlayerInfo()
    local playerInfo = openRaidLib.UnitInfoManager.GetPlayerFullInfo()

    local dataToSend = CONST_COMM_PLAYERINFO_PREFIX .. ","
    dataToSend = dataToSend .. playerInfo[1] .. "," --spec id
    dataToSend = dataToSend .. playerInfo[2] .. "," --renown
    dataToSend = dataToSend .. playerInfo[3] .. "," --covenantId
    dataToSend = dataToSend .. openRaidLib.PackTable(playerInfo[4]) .. "," --talents
    dataToSend = dataToSend .. openRaidLib.PackTable(playerInfo[5]) .. "," --conduits
    dataToSend = dataToSend .. openRaidLib.PackTable(playerInfo[6]) .. "," --pvp talents

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendGetUnitInfoFullData| " .. dataToSend) --debug
end

function openRaidLib.UnitInfoManager.GetPlayerFullInfo()
    local playerInfo = {}

    if (isTimewalkWoW()) then
        --indexes: specId, renown, covenant, talent, conduits, pvp talents
        --return a placeholder table
        return {0, 0, 0, {0, 0, 0, 0, 0, 0, 0}, {0, 0}, 0}
    end

    --spec
    local specId = 0
    local selectedSpecialization = GetSpecialization()
    if (selectedSpecialization) then
        specId = GetSpecializationInfo(selectedSpecialization) or 0
    end
    playerInfo[1] = specId

    --renown
    local renown = C_CovenantSanctumUI.GetRenownLevel() or 1
    playerInfo[2] = renown

    --covenant
    local covenant = C_Covenants.GetActiveCovenantID()
    playerInfo[3] = covenant

    --talents
    local talents = openRaidLib.UnitInfoManager.GetPlayerTalents()
    playerInfo[4] = talents

    --conduits
    local conduits = openRaidLib.UnitInfoManager.GetPlayerConduits()
    playerInfo[5] = conduits

    --pvp talents
    local pvpTalents = openRaidLib.UnitInfoManager.GetPlayerPvPTalents()
    playerInfo[6] = pvpTalents    

    return playerInfo
end

--talent update (when the player changes a talent and the lib needs to notify other players in the group)
function openRaidLib.UnitInfoManager.SendTalentUpdate()
    --talents
    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo("player", true)
    local talentsToSend = unitInfo.talents
    local dataToSend = CONST_COMM_PLAYERINFO_TALENTS_PREFIX .. ","
    local talentsString = openRaidLib.PackTable(talentsToSend)
    dataToSend = dataToSend .. talentsString

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendTalentUpdateData| " .. dataToSend) --debug
end

function openRaidLib.UnitInfoManager.OnPlayerTalentChanged()
    --update the local player
    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo("player", true)
    local unitName = UnitName("player")
    openRaidLib.UnitInfoManager.SetUnitInfo(unitName, unitInfo, nil, nil, nil, openRaidLib.UnitInfoManager.GetPlayerTalents())

    --schedule send to the group
    openRaidLib.Schedules.NewUniqueTimer(1 + math.random(0, 1), openRaidLib.UnitInfoManager.SendTalentUpdate, "UnitInfoManager", "sendTalent_Schedule")

    --trigger public callback event
    openRaidLib.publicCallback.TriggerCallback("TalentUpdate", "player", unitInfo.talents, unitInfo, openRaidLib.UnitInfoManager.GetAllUnitsInfo())
end
openRaidLib.internalCallback.RegisterCallback("talentUpdate", openRaidLib.UnitInfoManager.OnPlayerTalentChanged)

function openRaidLib.UnitInfoManager.OnReceiveTalentsUpdate(data, unitName)
    local talentsTableUnpacked = openRaidLib.UnpackTable(data, 1, false, false, 7)

    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo(unitName, true)
    if (unitInfo) then
        openRaidLib.UnitInfoManager.SetUnitInfo(unitName, unitInfo, nil, nil, nil, talentsTableUnpacked)
        --trigger public callback event
        openRaidLib.publicCallback.TriggerCallback("TalentUpdate", openRaidLib.GetUnitID(unitName), unitInfo.talents, unitInfo, openRaidLib.UnitInfoManager.GetAllUnitsInfo())
    end
end
openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_TALENTS_PREFIX, openRaidLib.UnitInfoManager.OnReceiveTalentsUpdate)

--pvp talent update (when the player changes a pvp talent and the lib needs to notify other players in the group)
function openRaidLib.UnitInfoManager.SendPvPTalentUpdate()
    --pvp talents
    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo("player", true)
    local pvpTalentsToSend = unitInfo.pvpTalents
    local dataToSend = CONST_COMM_PLAYERINFO_PVPTALENTS_PREFIX .. ","
    local pvpTalentsString = openRaidLib.PackTable(pvpTalentsToSend)
    dataToSend = dataToSend .. pvpTalentsString

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendPvPTalentUpdateData| " .. dataToSend) --debug
end

function openRaidLib.UnitInfoManager.OnPlayerPvPTalentChanged()
    --update the local player
    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo("player", true)
    local unitName = UnitName("player")
    openRaidLib.UnitInfoManager.SetUnitInfo(unitName, unitInfo, nil, nil, nil, nil, nil, openRaidLib.UnitInfoManager.GetPlayerPvPTalents())

    --schedule send to the group
    openRaidLib.Schedules.NewUniqueTimer(1 + math.random(0, 1), openRaidLib.UnitInfoManager.SendPvPTalentUpdate, "UnitInfoManager", "sendPvPTalent_Schedule")

    --trigger public callback event
    openRaidLib.publicCallback.TriggerCallback("PvPTalentUpdate", "player", unitInfo.pvpTalents, unitInfo, openRaidLib.UnitInfoManager.GetAllUnitsInfo())
end
openRaidLib.internalCallback.RegisterCallback("pvpTalentUpdate", openRaidLib.UnitInfoManager.OnPlayerPvPTalentChanged)

function openRaidLib.UnitInfoManager.OnReceivePvPTalentsUpdate(data, unitName)
    local pvpTalentsTableUnpacked = openRaidLib.UnpackTable(data, 1, false, false, 3)

    local unitInfo = openRaidLib.UnitInfoManager.GetUnitInfo(unitName, true)
    if (unitInfo) then
        unitInfo.pvpTalents = pvpTalentsTableUnpacked
        --trigger public callback event
        openRaidLib.publicCallback.TriggerCallback("PvPTalentUpdate", openRaidLib.GetUnitID(unitName), unitInfo.pvpTalents, unitInfo, openRaidLib.UnitInfoManager.GetAllUnitsInfo())
    end
end
openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_PVPTALENTS_PREFIX, openRaidLib.UnitInfoManager.OnReceivePvPTalentsUpdate)

function openRaidLib.UnitInfoManager.OnPlayerLeaveGroup()
    local unitName = UnitName("player")
    --clear the data
    openRaidLib.UnitInfoManager.EraseData()

    --trigger a public callback
    openRaidLib.publicCallback.TriggerCallback("UnitInfoWipe", openRaidLib.UnitInfoManager.UnitData)

    --need to build the player info again
    local playerFullInfo = openRaidLib.UnitInfoManager.GetPlayerFullInfo()
    openRaidLib.UnitInfoManager.AddUnitInfo(unitName, unpack(playerFullInfo))
end
openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.UnitInfoManager.OnPlayerLeaveGroup)

--send data when leaving combat
function openRaidLib.UnitInfoManager.SendPlayerInfoAfterCombat()
    openRaidLib.UnitInfoManager.SendAllPlayerInfo()
end
function openRaidLib.UnitInfoManager.OnLeaveCombat()
    openRaidLib.Schedules.NewUniqueTimer(1 + math.random(1, 4), openRaidLib.UnitInfoManager.SendPlayerInfoAfterCombat, "UnitInfoManager", "leaveCombat_Schedule")
end
openRaidLib.internalCallback.RegisterCallback("onLeaveCombat", openRaidLib.UnitInfoManager.OnLeaveCombat)


--------------------------------------------------------------------------------------------------------------------------------
--> ~equipment
    openRaidLib.GearManager = {
        --structure: [playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
        UnitData = {},
    }

    local gearTablePrototype = {
        ilevel = 0,
        durability = 0,
        weaponEnchant = 0,
        noGems = {},
        noEnchants = {},
    }    

    function openRaidLib.GetAllUnitsGear()
        return openRaidLib.GearManager.GetAllUnitsGear()
    end

    function openRaidLib.GetUnitGear(unitId, createNew)
        local unitName = GetUnitName(unitId, true) or unitId
        return openRaidLib.GearManager.GetUnitGear(unitName)
    end

    function openRaidLib.GearManager.GetAllUnitsGear()
        return openRaidLib.GearManager.UnitData
    end

    function openRaidLib.GearManager.GetUnitGear(unitName, createNew)
        local unitGearInfo = openRaidLib.GearManager.UnitData[unitName]
        if (not unitGearInfo and createNew) then
            unitGearInfo = {}
            openRaidLib.TCopy(unitGearInfo, gearTablePrototype)
            openRaidLib.GearManager.UnitData[unitName] = unitGearInfo
        end
        return unitGearInfo
    end

    --clear data stored
    function openRaidLib.GearManager.EraseData()
        table.wipe(openRaidLib.GearManager.UnitData)
    end

    function openRaidLib.GearManager.OnPlayerLeaveGroup()
        local unitName = GetUnitName("player")

        --clear the data
        openRaidLib.GearManager.EraseData()

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("GearListWipe", openRaidLib.GearManager.UnitData)

        --need to build the player gear again
        local playerGearInfo = openRaidLib.GearManager.GetPlayerFullGearInfo()
        openRaidLib.GearManager.AddUnitGearList(unitName, unpack(playerGearInfo))
    end
    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.GearManager.OnPlayerLeaveGroup)

    --when the player is ressed while in a group, send the cooldown list
    function openRaidLib.GearManager.OnPlayerRess()
        --check if is in group
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), openRaidLib.GearManager.SendDurability, "GearManager", "sendDurability_Schedule")
        end
    end
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.GearManager.OnPlayerRess)

    --send data when leaving combat
    function openRaidLib.GearManager.SendGearInfoAfterCombat()
        openRaidLib.GearManager.SendAllGearInfo()
    end
    function openRaidLib.GearManager.OnLeaveCombat()
        openRaidLib.Schedules.NewUniqueTimer(1 + math.random(1, 4), openRaidLib.GearManager.SendGearInfoAfterCombat, "GearManager", "leaveCombat_Schedule")
    end
    openRaidLib.internalCallback.RegisterCallback("onLeaveCombat", openRaidLib.GearManager.OnLeaveCombat)

    --send only the gear durability
    function openRaidLib.GearManager.SendDurability()
        local dataToSend = CONST_COMM_GEARINFO_DURABILITY_PREFIX .. ","
        local playerGearDurability = openRaidLib.GearManager.GetPlayerGearDurability()

        dataToSend = dataToSend .. playerGearDurability

        --send the data
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendGearDurabilityData| " .. dataToSend) --debug
    end

    function openRaidLib.GearManager.OnReceiveGearDurability(data, unitName)
        local durability = tonumber(data[1])
        openRaidLib.GearManager.UpdateUnitGearDurability(unitName, durability)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_DURABILITY_PREFIX, openRaidLib.GearManager.OnReceiveGearDurability)

    --on receive the durability (sent when the player get a ress)
    function openRaidLib.GearManager.UpdateUnitGearDurability(unitName, durability)
        local unitGearInfo = openRaidLib.GearManager.GetUnitGear(unitName)
        if (unitGearInfo) then
            unitGearInfo.durability = durability
            openRaidLib.publicCallback.TriggerCallback("GearDurabilityUpdate", openRaidLib.GetUnitID(unitName), durability, unitGearInfo, openRaidLib.GearManager.GetAllUnitsGear())
        end
    end

    --get gear information from what the player has equipped at the moment
    function openRaidLib.GearManager.GetPlayerFullGearInfo()
        --get the player class and specId
        local _, playerClass = UnitClass("player")
        local specId = openRaidLib.GetPlayerSpecId()
        --get which attribute the spec uses
        local specMainAttribute = openRaidLib.specAttribute[playerClass][specId] --1 int, 2 dex, 3 str

        if (not specId or not specMainAttribute) then
            return {0, 0, 0, {}, {}}
        end

        --item level
        local itemLevel = openRaidLib.GearManager.GetPlayerItemLevel()

        --repair status
        local gearDurability = openRaidLib.GearManager.GetPlayerGearDurability()

        --get weapon enchant
        local weaponEnchant = openRaidLib.GearManager.GetPlayerWeaponEnchant()

        --enchants and gems
        local slotsWithoutGems, slotsWithoutEnchant = openRaidLib.GearManager.GetPlayerGemsAndEnchantInfo()

        --build the table with the gear information
        local playerGearInfo = {}
        playerGearInfo[#playerGearInfo+1] = itemLevel           --[1]
        playerGearInfo[#playerGearInfo+1] = gearDurability      --[2]
        playerGearInfo[#playerGearInfo+1] = weaponEnchant       --[3]
        playerGearInfo[#playerGearInfo+1] = slotsWithoutEnchant --[4]
        playerGearInfo[#playerGearInfo+1] = slotsWithoutGems    --[5]

        return playerGearInfo
    end

    --when received the gear update from another player, store it and trigger a callback
    function openRaidLib.GearManager.AddUnitGearList(unitName, itemLevel, durability, weaponEnchant, noEnchantTable, noGemsTable)
        local unitGearInfo = openRaidLib.GearManager.GetUnitGear(unitName, true)

        unitGearInfo.ilevel = itemLevel
        unitGearInfo.durability = durability
        unitGearInfo.weaponEnchant = weaponEnchant
        unitGearInfo.noGems = noGemsTable
        unitGearInfo.noEnchants = noEnchantTable

        openRaidLib.publicCallback.TriggerCallback("GearUpdate", openRaidLib.GetUnitID(unitName), unitGearInfo, openRaidLib.GearManager.GetAllUnitsGear())
    end

    --triggered when the lib receives a gear information from another player in the raid
    --@data: table received from comm
    --@unitName: player name
    function openRaidLib.GearManager.OnReceiveGearFullInfo(data, unitName)
        local itemLevel = tonumber(data[1])
        local durability = tonumber(data[2])
        local weaponEnchant = tonumber(data[3])
        local noEnchantTableSize = tonumber(data[4])
        local noGemsTableIndex = tonumber(noEnchantTableSize + 5)
        local noGemsTableSize = data[noGemsTableIndex]

        --unpack the enchant data as a ipairs table
        local noEnchantTableUnpacked = openRaidLib.UnpackTable(data, 4, false, false, noEnchantTableSize)
        --unpack the enchant data as a ipairs table
        local noGemsTableUnpacked = openRaidLib.UnpackTable(data, noGemsTableIndex, false, false, noGemsTableSize)

        --add to the list of gear information
        openRaidLib.GearManager.AddUnitGearList(unitName, itemLevel, durability, weaponEnchant, noEnchantTableUnpacked, noGemsTableUnpacked)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_FULL_PREFIX, openRaidLib.GearManager.OnReceiveGearFullInfo)

    function openRaidLib.GearManager.SendAllGearInfo()
        --get gear information, gear info has 5 indexes:
        --[1] int item level
        --[2] int durability
        --[3] int weapon enchant
        --[4] table with integers of equipSlot without enchant
        --[5] table with integers of equipSlot which has a gem slot but the slot is empty            

        local dataToSend = CONST_COMM_GEARINFO_FULL_PREFIX .. ","
        local playerGearInfo = openRaidLib.GearManager.GetPlayerFullGearInfo()

        --update the player table
        openRaidLib.GearManager.AddUnitGearList(UnitName("player"), unpack(playerGearInfo))

        dataToSend = dataToSend .. playerGearInfo[1] .. "," --item level
        dataToSend = dataToSend .. playerGearInfo[2] .. "," --durability
        dataToSend = dataToSend .. playerGearInfo[3] .. "," --weapon enchant
        dataToSend = dataToSend .. openRaidLib.PackTable(playerGearInfo[4]) .. "," --slots without enchant
        dataToSend = dataToSend .. openRaidLib.PackTable(playerGearInfo[5]) -- slots with empty gem sockets

        --send the data
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendGearFullData| " .. dataToSend) --debug
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~cooldowns
openRaidLib.CooldownManager = {
    UnitData = {}, --stores the list of cooldowns each player has sent
    UnitDataFilterCache = {}, --same as the table above but cooldowns are separated has offensive, defensive, etc. FilterCooldowns in functions.lua
    NeedRebuildFilters = {}, --mark people that has invalid filter cache and need to rebuild it
    CooldownTickers = {}, --store C_Timer.NewTicker
    HasFullCooldownList = {}, --store player names with the library
}

--check if a cooldown time has changed or finished
--this function run within a ticker, the internal is CONST_COOLDOWN_CHECK_INTERVAL
local cooldownTimeLeftCheck_Ticker = function(tickerObject)
    local spellId = tickerObject.spellId

    --if the spell does not exists anymore in the player table, cancel the ticker
    local playerName = UnitName("player")
    if (not openRaidLib.CooldownManager.UnitData[playerName][spellId]) then
        tickerObject:Cancel()
        return
    end

    tickerObject.cooldownTimeLeft = tickerObject.cooldownTimeLeft - CONST_COOLDOWN_CHECK_INTERVAL
    local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)

    local updateLocally = false

    --is the spell ready to use?
    if (timeLeft == 0) then
        --it's ready
        openRaidLib.CooldownManager.SendPlayerCooldownUpdate(spellId, 0, charges, 0, 0)
        openRaidLib.CooldownManager.CooldownTickers[spellId] = nil
        tickerObject:Cancel()
        updateLocally = true
    else
        --check if the time left has changed, this check if the cooldown got its time reduced and if the cooldown time has been slow down by modRate
        if (not openRaidLib.isNearlyEqual(tickerObject.cooldownTimeLeft, timeLeft, CONST_COOLDOWN_TIMELEFT_HAS_CHANGED)) then
            --there's a deviation, send a comm to communicate the change in the time left
            openRaidLib.CooldownManager.SendPlayerCooldownUpdate(spellId, timeLeft, charges, startTimeOffset, duration)
            tickerObject.cooldownTimeLeft = timeLeft
            updateLocally = true
        end
    end

    if (updateLocally) then
        --get the cooldown time for this spell
        local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)
        --update the cooldown
        openRaidLib.CooldownManager.CooldownSpellUpdate(playerName, spellId, timeLeft, charges, startTimeOffset, duration)

        local playerCooldownTable = openRaidLib.GetUnitCooldowns(playerName)
        local cooldownInfo = openRaidLib.GetUnitCooldownInfo(playerName, spellId)
        openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", "player", spellId, cooldownInfo, playerCooldownTable, openRaidLib.CooldownManager.UnitData)
    end
end

--after a spell is casted by the player, start a ticker to check its cooldown
local cooldownStartTicker = function(spellId, cooldownTimeLeft)
    local existingTicker = openRaidLib.CooldownManager.CooldownTickers[spellId]
    if (existingTicker) then
        --if a ticker already exists, might be the cooldown of a charge
        --if the ticker isn't about to expire, just keep the timer
        --when the ticker finishes it'll check again for charges
        if (existingTicker.startTime + existingTicker.cooldownTimeLeft - GetTime() > 2) then
            return
        end

        --cancel the existing ticker
        if (not existingTicker._cancelled) then
            existingTicker:Cancel()
        end
    end

    --create a new ticker
    local maxTicks = ceil(cooldownTimeLeft / CONST_COOLDOWN_CHECK_INTERVAL)
    local newTicker = C_Timer.NewTicker(CONST_COOLDOWN_CHECK_INTERVAL, cooldownTimeLeftCheck_Ticker, maxTicks)

    --store the ticker
    openRaidLib.CooldownManager.CooldownTickers[spellId] = newTicker
    newTicker.spellId = spellId
    newTicker.cooldownTimeLeft = cooldownTimeLeft
    newTicker.startTime = GetTime()
    newTicker.endTime = GetTime() + cooldownTimeLeft
end

function openRaidLib.CooldownManager.CleanupCooldownTickers()
    for spellId, tickerObject in pairs(openRaidLib.CooldownManager.CooldownTickers) do
        local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)
        if (timeLeft == 0) then
            tickerObject:Cancel()
            openRaidLib.CooldownManager.CooldownTickers[spellId] = nil
        end
    end
end

local cooldownGetUnitTable = function(unitName, shouldWipe)
    local unitCooldownTable = openRaidLib.CooldownManager.UnitData[unitName]
    --check if the unit has a cooldownTable
    if (not unitCooldownTable) then
        unitCooldownTable = {}
        openRaidLib.CooldownManager.UnitData[unitName] = unitCooldownTable
    else
        --as the unit could have changed a talent or spec, wipe the table before using it
        if (shouldWipe) then
            table.wipe(unitCooldownTable)
        end
    end

    return unitCooldownTable
end

local cooldownGetSpellInfo = function(unitName, spellId)
    local unitCooldownTable = cooldownGetUnitTable(unitName)
    local spellIdTable = unitCooldownTable[spellId]
    return spellIdTable
end

--update a single cooldown timer
--called when the player casted a cooldown and when received a cooldown update from another player
--only update the db, no other action is taken
function openRaidLib.CooldownManager.CooldownSpellUpdate(unitName, spellId, newTimeLeft, newCharges, startTimeOffset, duration)
    local unitCooldownTable = cooldownGetUnitTable(unitName)
    local spellIdTable = unitCooldownTable[spellId] or {}
    spellIdTable[CONST_COOLDOWN_INDEX_TIMELEFT] = newTimeLeft
    spellIdTable[CONST_COOLDOWN_INDEX_CHARGES] = newCharges
    spellIdTable[CONST_COOLDOWN_INDEX_TIMEOFFSET] = startTimeOffset
    spellIdTable[CONST_COOLDOWN_INDEX_DURATION] = duration
    spellIdTable[CONST_COOLDOWN_INDEX_UPDATETIME] = GetTime()
    unitCooldownTable[spellId] = spellIdTable
end

--> API Calls
    --return a table with unit names as key and a table with unit cooldowns as the value
    --table format: [playerName] = {[spellId] = cooldownInfo}
    function openRaidLib.GetAllUnitsCooldown()
        return openRaidLib.CooldownManager.UnitData
    end

    --return a table with all the unit cooldowns
    --table format: [spellId] = cooldownInfo
    function openRaidLib.GetUnitCooldowns(unitId, filter)
        local unitName = GetUnitName(unitId, true) or unitId
        local allCooldowns = openRaidLib.CooldownManager.UnitData[unitName]

        --check if there's a filter and if there's at least one cooldown existing
        if (allCooldowns and next(allCooldowns)) then
            if (filter and filter ~= "") then
                if (type(filter) == "string") then
                    local filterCooldowns = openRaidLib.FilterCooldowns(unitName, allCooldowns, filter)
                    return filterCooldowns
                else
                    openRaidLib.DiagnosticError("CooldownManager|GetUnitCooldowns|filter isn't a string")
                end
            else
                return allCooldowns
            end
        else
            return {}
        end
    end

    function openRaidLib.DoesSpellPassFilters(spellId, filter)
        return openRaidLib.CooldownManager.DoesSpellPassFilters(spellId, filter)
    end

    --return values about the cooldown time
    --values returned: timeLeft, charges, timeOffset, duration, updateTime
    function openRaidLib.GetCooldownTimeFromUnitSpellID(unitId, spellId)
        local unitCooldownsTable = openRaidLib.GetUnitCooldowns(unitId)
        if (unitCooldownsTable) then
            local cooldownInfo = unitCooldownsTable[spellId]
            if (cooldownInfo) then
                return unpack(cooldownInfo)
            end
        end
    end

    --return values about the cooldown time from a cooldown info
    --values returned: timeLeft, charges, timeOffset, duration, updateTime
    function openRaidLib.GetCooldownTimeFromCooldownInfo(cooldownInfo)
        if (cooldownInfo) then
            return unpack(cooldownInfo)
        end
    end

    --return a table containing values about the cooldown time
    --values returned: {timeLeft, charges, timeOffset, duration, updateTime}
    function openRaidLib.GetUnitCooldownInfo(unitId, spellId)
        local unitCooldownsTable = openRaidLib.GetUnitCooldowns(unitId)
        if (unitCooldownsTable) then
            local cooldownInfo = unitCooldownsTable[spellId]
            return cooldownInfo
        end
    end

    local calculatePercent = function(timeOffset, duration, updateTime, charges)
        timeOffset = abs(timeOffset)
        local minValue = updateTime - timeOffset
        local maxValue = minValue + duration
        local currentValue = GetTime()
        local percent = openRaidLib.GetRangePercent(minValue, maxValue, currentValue)
        percent = min(percent, 1)
        local timeLeft = max(maxValue - currentValue, 0)

        --lag compensation
        if (timeLeft <= 2) then
            timeLeft = 0
            if (charges == 0) then
                charges = 1
            end
            minValue = currentValue
            maxValue = 1
            currentValue = 1
        end

        return timeLeft <= 2, percent, timeLeft, charges, minValue, maxValue, min(currentValue, maxValue), duration
    end

    --return the values to be use on a progress bar or cooldown frame
    --require a unitId and a spellId to query the values
    --values returned: isReady, timeLeft, charges, normalized percent, minValue, maxValue, currentValue
    --values are in the GetTime() format
    function openRaidLib.GetCooldownStatusFromUnitSpellID(unitId, spellId)
        local timeLeft, charges, timeOffset, duration, updateTime
        local unitCooldownsTable = openRaidLib.GetUnitCooldowns(unitId)
        if (unitCooldownsTable) then
            local cooldownInfo = unitCooldownsTable[spellId]
            if (cooldownInfo) then
                timeLeft, charges, timeOffset, duration, updateTime = unpack(cooldownInfo)
            end
        end

        return calculatePercent(timeOffset, duration, updateTime, charges)
    end

    --return the values to be use on a progress bar or cooldown frame
    --require the cooldownInfo table
    --values returned: isReady, timeLeft, charges, normalized percent, minValue, maxValue, currentValue
    --values are in the GetTime() format
    --GetPercentFromCooldownInfo
    function openRaidLib.GetCooldownStatusFromCooldownInfo(cooldownInfo)
        local timeLeft, charges, timeOffset, duration, updateTime = unpack(cooldownInfo)
        return calculatePercent(timeOffset, duration, updateTime, charges)
    end

--> internals
    function openRaidLib.CooldownManager.OnPlayerCast(event, spellId, isPlayerPet) --~cast
        --player casted a spell, check if the spell is registered as cooldown
        local playerSpec = openRaidLib.GetPlayerSpecId()
        if (playerSpec) then
            if (LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[playerSpec] and LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[playerSpec][spellId]) then
                local playerName = UnitName("player")

                --get the cooldown time for this spell
                local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)

                --update the cooldown
                openRaidLib.CooldownManager.CooldownSpellUpdate(playerName, spellId, timeLeft, charges, startTimeOffset, duration)
                local cooldownInfo = cooldownGetSpellInfo(playerName, spellId)

                --trigger a public callback
                local playerCooldownTable = openRaidLib.GetUnitCooldowns(playerName)
                openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", "player", spellId, cooldownInfo, playerCooldownTable, openRaidLib.CooldownManager.UnitData)

                --send to comm
                openRaidLib.CooldownManager.SendPlayerCooldownUpdate(spellId, timeLeft, charges, startTimeOffset, duration)

                --create a timer to monitor the time of this cooldown
                --as there's just a few of them to monitor, there's no issue on creating one timer per spell
                cooldownStartTicker(spellId, timeLeft)
            end
        end
    end

    --when the player is ressed while in a group, send the cooldown list
    function openRaidLib.CooldownManager.OnPlayerRess()
        --check if is in group
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), openRaidLib.CooldownManager.SendAllPlayerCooldowns, "CooldownManager", "sendAllPlayerCooldowns_Schedule")
        end
    end

    function openRaidLib.CooldownManager.OnPlayerLeaveGroup()
        --clear the data
        openRaidLib.CooldownManager.EraseData()

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("CooldownListWipe", openRaidLib.CooldownManager.UnitData)

        --recreate the player cooldowns
        openRaidLib.CooldownManager.UpdatePlayerCooldownsLocally()
    end

    --when a talent has changed, it might remove or add a cooldown
    function openRaidLib.CooldownManager.OnPlayerTalentChanged()
        --immediatelly update the player cooldowns locally
        openRaidLib.CooldownManager.UpdatePlayerCooldownsLocally()

        --schedule send to the group, using a large delay to send due to the player might change more talents at once
        openRaidLib.Schedules.NewUniqueTimer(4 + math.random(0, 1), openRaidLib.CooldownManager.SendAllPlayerCooldowns, "CooldownManager", "sendAllPlayerCooldowns_Schedule")
    end

    --check cooldown reset after a raid encounter ends finishing ongoing timeLeft tickers
    function openRaidLib.CooldownManager.CheckCooldownsAfterEncounterEnd()
        openRaidLib.CooldownManager.CleanupCooldownTickers()
        openRaidLib.Schedules.NewUniqueTimer(1 + math.random(1, 4), openRaidLib.CooldownManager.SendAllPlayerCooldowns, "CooldownManager", "sendAllPlayerCooldowns_Schedule")
    end
    function openRaidLib.CooldownManager.OnEncounterEnd()
        --run on next frame
        openRaidLib.Schedules.NewUniqueTimer(0.1, openRaidLib.CooldownManager.CheckCooldownsAfterEncounterEnd, "CooldownManager", "encounterEndCooldownsCheck_Schedule")
    end

    function openRaidLib.CooldownManager.OnMythicPlusStart()
        openRaidLib.Schedules.NewUniqueTimer(0.5, openRaidLib.CooldownManager.SendAllPlayerCooldowns, "CooldownManager", "sendAllPlayerCooldowns_Schedule")
    end

    function openRaidLib.CooldownManager.OnPlayerPetChanged()
        openRaidLib.CooldownManager.CheckCooldownChanges()
    end

    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.CooldownManager.OnPlayerLeaveGroup)
    openRaidLib.internalCallback.RegisterCallback("playerCast", openRaidLib.CooldownManager.OnPlayerCast)
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.CooldownManager.OnPlayerRess)
    openRaidLib.internalCallback.RegisterCallback("talentUpdate", openRaidLib.CooldownManager.OnPlayerTalentChanged)
    openRaidLib.internalCallback.RegisterCallback("raidEncounterEnd", openRaidLib.CooldownManager.OnEncounterEnd)
    openRaidLib.internalCallback.RegisterCallback("onLeaveCombat", openRaidLib.CooldownManager.OnEncounterEnd)
    openRaidLib.internalCallback.RegisterCallback("mythicDungeonStart", openRaidLib.CooldownManager.OnMythicPlusStart)
    openRaidLib.internalCallback.RegisterCallback("playerPetChange", openRaidLib.CooldownManager.OnPlayerPetChanged)

--send a list through comm with cooldowns added or removed
function openRaidLib.CooldownManager.CheckCooldownChanges()
    --important: CheckForSpellsAdeedOrRemoved() already change the cooldowns on the player locally
    local spellsAdded, spellsRemoved = openRaidLib.CooldownManager.CheckForSpellsAdeedOrRemoved()

    --add a prefix to make things easier during unpack
    if (#spellsAdded > 0) then
        tinsert(spellsAdded, 1, "A")
    end

    --insert the spells that has been removed at the end of the spells added table and pack the table
    if (#spellsRemoved > 0) then
        spellsAdded[#spellsAdded+1] = "R"
        for _, spellId in ipairs(spellsRemoved) do
            spellsAdded[#spellsAdded+1] = spellId
        end
    end

    --send a comm if has any changes
    if (#spellsAdded > 0) then
        --pack
        local playerCooldownChangesString = openRaidLib.PackTable(spellsAdded)
        local dataToSend = CONST_COMM_COOLDOWNCHANGES_PREFIX .. ","
        dataToSend = dataToSend .. playerCooldownChangesString

        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("CheckCooldownChanges| " .. dataToSend) --debug
    end
end

function openRaidLib.CooldownManager.OnReceiveUnitCooldownChanges(data, unitName)
    local currentCooldowns = openRaidLib.CooldownManager.UnitData[unitName]
    --if does not have the full list of cooldowns of this unit, ignore cooldown add/remove comms
    if (not currentCooldowns or not openRaidLib.CooldownManager.HasFullCooldownList[unitName]) then
        return
    end

    --create a table to be ready to unpack
    local addedCooldowns = {}
    local removedCooldowns = {}
    local isCooldownAdded = false
    local isCooldownRemoved = false

    --the letters A and R separate cooldowns added and cooldowns removed
    for i = 1, #data do
        local thisData = data[i]

        if (thisData == "A") then
            isCooldownAdded = true
        elseif (thisData == "R") then
            isCooldownAdded = false
            isCooldownRemoved = true
        end

        if (isCooldownAdded) then
            thisData = tonumber(thisData)
            if (thisData) then
                addedCooldowns[#addedCooldowns+1] = thisData
            end
        elseif(isCooldownRemoved) then
            local spellId = tonumber(thisData)
            if (spellId) then
                removedCooldowns[#removedCooldowns+1] = spellId
            end
        end
    end

    if (#addedCooldowns > 0) then
        tinsert(addedCooldowns, 1, #addedCooldowns) --amount of indexes for UnpackTable()
        local cooldownsAddedUnpacked = openRaidLib.UnpackTable(addedCooldowns, 1, true, true, 5)
        for spellId, cooldownInfo in pairs(cooldownsAddedUnpacked) do
            --add the spell into the list of cooldowns of this unit
            local timeLeft, charges, timeOffset, duration = unpack(cooldownInfo)
            openRaidLib.CooldownManager.CooldownSpellUpdate(unitName, spellId, timeLeft, charges, timeOffset, duration)
            --mark the filter cache of this unit as dirt
            openRaidLib.CooldownManager.NeedRebuildFilters[unitName] = true
            --trigger public callback
            openRaidLib.publicCallback.TriggerCallback("CooldownAdded", openRaidLib.GetUnitID(unitName), spellId, cooldownInfo, openRaidLib.GetUnitCooldowns(unitName), openRaidLib.CooldownManager.UnitData)
        end
    end

    if (#removedCooldowns > 0) then
        for _, spellId in ipairs(removedCooldowns) do
            --remove the spell from this unit cooldown list
            currentCooldowns[spellId] = nil
            --mark the filter cache of this unit as dirt
            openRaidLib.CooldownManager.NeedRebuildFilters[unitName] = true
            --trigger public callback
            openRaidLib.publicCallback.TriggerCallback("CooldownRemoved", openRaidLib.GetUnitID(unitName), spellId, openRaidLib.GetUnitCooldowns(unitName), openRaidLib.CooldownManager.UnitData)
        end
    end

end
openRaidLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNCHANGES_PREFIX, openRaidLib.CooldownManager.OnReceiveUnitCooldownChanges)

--compare the current list of spells of the player with a new spell list generated
--add or remove spells from the player cooldown list
--return two tables, the first has added spells and is a index table ready to pack and send to comm
--the second table is a index table with a list of spells that has been removed, also ready to pack
function openRaidLib.CooldownManager.CheckForSpellsAdeedOrRemoved()
    local playerName = UnitName("player")
    local currentCooldowns = openRaidLib.CooldownManager.UnitData[playerName]
    local _, newCooldownList = openRaidLib.CooldownManager.GetPlayerCooldownList()
    local spellsAdded, spellsRemoved = {}, {}

    for spellId, cooldownInfo in pairs(newCooldownList) do
        if (not currentCooldowns[spellId]) then
            --a spell has been added
            local timeLeft, charges, timeOffset, duration = unpack(cooldownInfo)
            openRaidLib.CooldownManager.CooldownSpellUpdate(playerName, spellId, timeLeft, charges, timeOffset, duration)

            local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)
            spellsAdded[#spellsAdded+1] = spellId
            spellsAdded[#spellsAdded+1] = timeLeft
            spellsAdded[#spellsAdded+1] = charges
            spellsAdded[#spellsAdded+1] = startTimeOffset
            spellsAdded[#spellsAdded+1] = duration

            --mark the filter cache of this unit as dirt
            openRaidLib.CooldownManager.NeedRebuildFilters[playerName] = true
            openRaidLib.publicCallback.TriggerCallback("CooldownAdded", "player", spellId, cooldownInfo, openRaidLib.GetUnitCooldowns("player"), openRaidLib.CooldownManager.UnitData)
        end
    end

    for spellId in pairs(currentCooldowns) do
        if (not newCooldownList[spellId]) then
            --a spell has been removed
            currentCooldowns[spellId] = nil
            spellsRemoved[#spellsRemoved+1] = spellId
            --mark the filter cache of this unit as dirt
            openRaidLib.CooldownManager.NeedRebuildFilters[playerName] = true
            openRaidLib.publicCallback.TriggerCallback("CooldownRemoved", "player", spellId, openRaidLib.GetUnitCooldowns("player"), openRaidLib.CooldownManager.UnitData)
        end
    end

    return spellsAdded, spellsRemoved
end

--update the list of cooldowns of the player it self locally
--this is called right after changes in the player cooldowns
function openRaidLib.CooldownManager.UpdatePlayerCooldownsLocally(playerCooldownHash)
    if (not playerCooldownHash) then
        playerCooldownHash = select(2, openRaidLib.CooldownManager.GetPlayerCooldownList())
    end
    local playerName = UnitName("player")
    openRaidLib.CooldownManager.AddUnitCooldownsList(playerName, playerCooldownHash)
end

--adds a list of cooldowns for another player in the group
--this is only called from the received cooldown list from comm
function openRaidLib.CooldownManager.AddUnitCooldownsList(unitName, cooldownsTable, noCallback)
    local unitCooldownTable = cooldownGetUnitTable(unitName, true) --sending true to wipe previous data
    openRaidLib.TCopy(unitCooldownTable, cooldownsTable)

    --add the unitName to the list of units detected with the lib
    openRaidLib.CooldownManager.HasFullCooldownList[unitName] = true
    --mark the filter cache of this unit as dirt
    openRaidLib.CooldownManager.NeedRebuildFilters[unitName] = true

    --get the time where the cooldown data was received, this is used with the timeleft and startTimeOffset
    local timeNow = GetTime()
    for spellId, cooldownTable in pairs(cooldownsTable) do
        cooldownTable[CONST_COOLDOWN_INDEX_UPDATETIME] = timeNow
    end

    --trigger a public callback
    if (not noCallback) then
        openRaidLib.publicCallback.TriggerCallback("CooldownListUpdate", openRaidLib.GetUnitID(unitName), unitCooldownTable, openRaidLib.CooldownManager.UnitData)
    end
end

--received a cooldown update from another unit (sent by the function above)
openRaidLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNUPDATE_PREFIX, function(data, unitName)
    --get data
    local dataAsArray = data
    local spellId = tonumber(dataAsArray[1])
    local cooldownTimer = tonumber(dataAsArray[2])
    local charges = tonumber(dataAsArray[3])
    local startTime = tonumber(dataAsArray[4])
    local duration = tonumber(dataAsArray[5])

    --check integrity
    if (not spellId or spellId == 0) then
        return openRaidLib.DiagnosticError("CooldownManager|comm received|spellId is invalid")

    elseif (not cooldownTimer) then
        return openRaidLib.DiagnosticError("CooldownManager|comm received|cooldownTimer is invalid")

    elseif (not charges) then
        return openRaidLib.DiagnosticError("CooldownManager|comm received|charges is invalid")

    elseif (not startTime) then
        return openRaidLib.DiagnosticError("CooldownManager|comm received|startTime is invalid")

    elseif (not duration) then
        return openRaidLib.DiagnosticError("CooldownManager|comm received|duration is invalid")
    end

    --update
    openRaidLib.CooldownManager.CooldownSpellUpdate(unitName, spellId, cooldownTimer, charges, startTime, duration)
    local cooldownInfo = cooldownGetSpellInfo(unitName, spellId)
    local unitCooldownTable = openRaidLib.GetUnitCooldowns(unitName)

    --trigger a public callback
    openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", openRaidLib.GetUnitID(unitName), spellId, cooldownInfo, unitCooldownTable, openRaidLib.CooldownManager.UnitData)
end)

--clear data stored, this is called after the player quit from a group
function openRaidLib.CooldownManager.EraseData()
    table.wipe(openRaidLib.CooldownManager.UnitDataFilterCache)
    table.wipe(openRaidLib.CooldownManager.HasFullCooldownList)
    table.wipe(openRaidLib.CooldownManager.NeedRebuildFilters)
    table.wipe(openRaidLib.CooldownManager.UnitData)
end

--send to comm all cooldowns available for the player
function openRaidLib.CooldownManager.SendAllPlayerCooldowns()
    --get the full cooldown list
    local playerCooldownList, playerCooldownHash = openRaidLib.CooldownManager.GetPlayerCooldownList()
    --update the player cooldowns locally
    openRaidLib.CooldownManager.UpdatePlayerCooldownsLocally(playerCooldownHash)

    local dataToSend = CONST_COMM_COOLDOWNFULLLIST_PREFIX .. ","

    --pack
    local playerCooldownString = openRaidLib.PackTable(playerCooldownList)
    dataToSend = dataToSend .. playerCooldownString

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendAllPlayerCooldowns| " .. dataToSend) --debug
end

--send to comm a specific cooldown that was just used, a charge got available or its cooldown is over (ready to use)
function openRaidLib.CooldownManager.SendPlayerCooldownUpdate(spellId, cooldownTimeLeft, charges, startTimeOffset, duration)
    local dataToSend = CONST_COMM_COOLDOWNUPDATE_PREFIX .. "," .. spellId .. "," .. cooldownTimeLeft .. "," .. charges .. "," .. startTimeOffset .. "," .. duration
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendPlayerCooldownUpdate| " .. dataToSend) --debug
end

--triggered when the lib receives a full list of cooldowns from another player in the raid
--@data: table received from comm
--@unitName: player name
function openRaidLib.CooldownManager.OnReceiveUnitCooldowns(data, unitName)
    --unpack the table as a pairs table | the cooldown info uses 5 indexes
    local unpackedTable = openRaidLib.UnpackTable(data, 1, true, true, 5)
    --add the list of cooldowns
    openRaidLib.CooldownManager.AddUnitCooldownsList(unitName, unpackedTable)
end
openRaidLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNFULLLIST_PREFIX, openRaidLib.CooldownManager.OnReceiveUnitCooldowns)


--------------------------------------------------------------------------------------------------------------------------------
--> ~keystones
    --public callback does not check if the keystone has changed from the previous callback

    --> API calls
        --return a table containing all information of units
        --format: [playerName-realm] = {information}
        function openRaidLib.GetAllKeystonesInfo()
            return openRaidLib.KeystoneInfoManager.GetAllKeystonesInfo()
        end

        --return a table containing information of a single unit
        function openRaidLib.GetKeystoneInfo(unitId)
            local unitName = GetUnitName(unitId, true) or unitId
            return openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName)
        end

        function openRaidLib.RequestKeystoneDataFromGuild()
            if (IsInGuild()) then
                local dataToSend = CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX
                openRaidLib.commHandler.SendCommData(dataToSend, 0x4)
                diagnosticComm("RequestKeystoneDataFromGuild| " .. dataToSend) --debug
                return true
            else
                return false
            end
        end

        function openRaidLib.RequestKeystoneDataFromParty()
            if (IsInGroup() and not IsInRaid()) then
                local dataToSend = CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX
                openRaidLib.commHandler.SendCommData(dataToSend, 0x1)
                diagnosticComm("RequestKeystoneDataFromParty| " .. dataToSend) --debug
                return true
            else
                return false
            end
        end

        function openRaidLib.RequestKeystoneDataFromRaid()
            if (IsInRaid()) then
                local dataToSend = CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX
                openRaidLib.commHandler.SendCommData(dataToSend, 0x2)
                diagnosticComm("RequestKeystoneDataFromRaid| " .. dataToSend) --debug
                return true
            else
                return false
            end
        end

        function openRaidLib.WipeKeystoneData()
            wipe(openRaidLib.KeystoneInfoManager.KeystoneData)
            --trigger public callback
            openRaidLib.publicCallback.TriggerCallback("KeystoneWipe", openRaidLib.KeystoneInfoManager.KeystoneData)

            --keystones are only available on retail
            if (not checkClientVersion("retail")) then
                return
            end

            --generate keystone info for the player
            local unitName = UnitName("player")
            local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName, true)
            openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

            openRaidLib.publicCallback.TriggerCallback("KeystoneUpdate", unitName, keystoneInfo, openRaidLib.KeystoneInfoManager.KeystoneData)
            return true
        end

    --> manager constructor
        openRaidLib.KeystoneInfoManager = {
            --structure:
            --[playerName] = {level = 2, mapID = 222}
            KeystoneData = {},
        }

        local keystoneTablePrototype = {
            level = 0,
            mapID = 0,
            challengeMapID = 0,
            classID = 0,
            rating = 0,
            mythicPlusMapID = 0,
        }

    --search the player backpack to find a mythic keystone
    --with the keystone object, it'll attempt to get the mythicPlusMapID to be used with C_ChallengeMode.GetMapUIInfo(mythicPlusMapID)
    --ATM we are obligated to do this due to C_MythicPlus.GetOwnedKeystoneMapID() return the same mapID for the two Tazavesh dungeons
    local getMythicPlusMapID = function()
        for backpackId = 0, 4 do
            for slotId = 1, GetContainerNumSlots(backpackId) do
                local itemId = GetContainerItemID(backpackId, slotId)
                if (itemId == LIB_OPEN_RAID_MYTHICKEYSTONE_ITEMID) then
                    local itemLink = GetContainerItemLink(backpackId, slotId)
                    local destroyedItemLink = itemLink:gsub("|", "")
                    local color, itemID, mythicPlusMapID = strsplit(":", destroyedItemLink)
                    return tonumber(mythicPlusMapID)
                end
            end
        end
    end

    function openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)
        keystoneInfo.level = C_MythicPlus.GetOwnedKeystoneLevel() or 0
        keystoneInfo.mapID = C_MythicPlus.GetOwnedKeystoneMapID() or 0
        keystoneInfo.mythicPlusMapID = getMythicPlusMapID() or 0
        keystoneInfo.challengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID() or 0

        local _, _, playerClassID = UnitClass("player")
        keystoneInfo.classID = playerClassID

        local ratingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
        keystoneInfo.rating = ratingSummary and ratingSummary.currentSeasonScore or 0
    end

    function openRaidLib.KeystoneInfoManager.GetAllKeystonesInfo()
        return openRaidLib.KeystoneInfoManager.KeystoneData
    end

    --get the keystone info table or create a new one if 'createNew' is true
    function openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName, createNew)
        local keystoneInfo = openRaidLib.KeystoneInfoManager.KeystoneData[unitName]
        if (not keystoneInfo and createNew) then
            keystoneInfo = {}
            openRaidLib.TCopy(keystoneInfo, keystoneTablePrototype)
            openRaidLib.KeystoneInfoManager.KeystoneData[unitName] = keystoneInfo
        end
        return keystoneInfo
    end

    local getKeystoneInfoToComm = function()
        local playerName = UnitName("player")
        local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(playerName, true)
        openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

        local dataToSend = CONST_COMM_KEYSTONE_DATA_PREFIX .. "," .. keystoneInfo.level .. "," .. keystoneInfo.mapID .. "," .. keystoneInfo.challengeMapID .. "," .. keystoneInfo.classID .. "," .. keystoneInfo.rating .. "," .. keystoneInfo.mythicPlusMapID
        return dataToSend
    end

    function openRaidLib.KeystoneInfoManager.SendPlayerKeystoneInfoToParty()
        local dataToSend = getKeystoneInfoToComm()
        openRaidLib.commHandler.SendCommData(dataToSend, CONST_COMM_SENDTO_PARTY)
        diagnosticComm("SendPlayerKeystoneInfoToParty| " .. dataToSend) --debug
    end

    function openRaidLib.KeystoneInfoManager.SendPlayerKeystoneInfoToGuild()
        local dataToSend = getKeystoneInfoToComm()
        openRaidLib.commHandler.SendCommData(dataToSend, CONST_COMM_SENDTO_GUILD)
        diagnosticComm("SendPlayerKeystoneInfoToGuild| " .. dataToSend) --debug
    end

    --when a request data is received, only send the data to party and guild
    --sending stuff to raid need to be called my the application with 'openRaidLib.RequestKeystoneDataFromRaid()'
    function openRaidLib.KeystoneInfoManager.OnReceiveRequestData()
        if (not checkClientVersion("retail")) then
            return
        end

        --update the information about the key stone the player has
        local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(UnitName("player"), true)
        openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

        if (IsInGroup() and not IsInRaid()) then
            openRaidLib.Schedules.NewUniqueTimer(0.1, openRaidLib.KeystoneInfoManager.SendPlayerKeystoneInfoToParty, "KeystoneInfoManager", "sendKeystoneInfoToParty_Schedule")
        end

        if (IsInGuild()) then
            openRaidLib.Schedules.NewUniqueTimer(math.random(0, 3) + math.random(), openRaidLib.KeystoneInfoManager.SendPlayerKeystoneInfoToGuild, "KeystoneInfoManager", "sendKeystoneInfoToGuild_Schedule")
        end
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_KEYSTONE_DATAREQUEST_PREFIX, openRaidLib.KeystoneInfoManager.OnReceiveRequestData)

    function openRaidLib.KeystoneInfoManager.OnReceiveKeystoneData(data, unitName)
        if (not checkClientVersion("retail")) then
            return
        end

        local level = tonumber(data[1])
        local mapID = tonumber(data[2])
        local challengeMapID = tonumber(data[3])
        local classID = tonumber(data[4])
        local rating = tonumber(data[5])
        local mythicPlusMapID = tonumber(data[6])

        if (level and mapID and challengeMapID and classID and rating and mythicPlusMapID) then
            local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName, true)
            keystoneInfo.level = level
            keystoneInfo.mapID = mapID
            keystoneInfo.mythicPlusMapID = mythicPlusMapID
            keystoneInfo.challengeMapID = challengeMapID
            keystoneInfo.classID = classID
            keystoneInfo.rating = rating

            --trigger public callback
            openRaidLib.publicCallback.TriggerCallback("KeystoneUpdate", unitName, keystoneInfo, openRaidLib.KeystoneInfoManager.KeystoneData)
        end
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_KEYSTONE_DATA_PREFIX, openRaidLib.KeystoneInfoManager.OnReceiveKeystoneData)

    --on entering a group, send keystone information for the party
    function openRaidLib.KeystoneInfoManager.OnPlayerEnterGroup()
        --keystones are only available on retail
        if (not checkClientVersion("retail")) then
            return
        end

        if (IsInGroup() and not IsInRaid()) then
            --update the information about the key stone the player has
            local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(UnitName("player"), true)
            openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

            --send to the group which keystone the player has
            openRaidLib.Schedules.NewUniqueTimer(1 + math.random(0, 2) + math.random(), openRaidLib.KeystoneInfoManager.SendPlayerKeystoneInfoToParty, "KeystoneInfoManager", "sendKeystoneInfoToParty_Schedule")
        end
    end

    function openRaidLib.KeystoneInfoManager.OnPlayerEnterWorld()
        --keystones are only available on retail
        if (not checkClientVersion("retail")) then
            return
        end
        --hack: on received data send data to party and guild
        openRaidLib.KeystoneInfoManager.OnReceiveRequestData()

        --trigger public callback
        local unitName = UnitName("player")
        local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName, true)
        openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

        openRaidLib.publicCallback.TriggerCallback("KeystoneUpdate", unitName, keystoneInfo, openRaidLib.KeystoneInfoManager.KeystoneData)
    end

    function openRaidLib.KeystoneInfoManager.OnMythicDungeonFinished()
        --keystones are only available on retail
        if (not checkClientVersion("retail")) then
            return
        end
        --hack: on received data send data to party and guild
        openRaidLib.KeystoneInfoManager.OnReceiveRequestData()

        --trigger public callback
        local unitName = UnitName("player")
        local keystoneInfo = openRaidLib.KeystoneInfoManager.GetKeystoneInfo(unitName, true)
        openRaidLib.KeystoneInfoManager.UpdatePlayerKeystoneInfo(keystoneInfo)

        openRaidLib.publicCallback.TriggerCallback("KeystoneUpdate", unitName, keystoneInfo, openRaidLib.KeystoneInfoManager.KeystoneData)
    end

    openRaidLib.internalCallback.RegisterCallback("onEnterWorld", openRaidLib.KeystoneInfoManager.OnPlayerEnterWorld)
    openRaidLib.internalCallback.RegisterCallback("onEnterGroup", openRaidLib.KeystoneInfoManager.OnPlayerEnterGroup)
    openRaidLib.internalCallback.RegisterCallback("mythicDungeonEnd", openRaidLib.KeystoneInfoManager.OnMythicDungeonFinished)


--DEBUG TEST
--[=[
local ff = {}
function ff.OnKSUpdate(unitId, keystoneInfo, allKeystonesInfo)
    print(unitId, keystoneInfo, allKeystonesInfo)
    print(keystoneInfo.level, keystoneInfo.mapID, keystoneInfo.challengeMapID)
end
openRaidLib.RegisterCallback(ff, "KeystoneUpdate", "OnKSUpdate")

C_Timer.After(7, function()
    openRaidLib.GetAllKeystonesInfo()
    print("> ", openRaidLib.GetKeystoneInfo("player"))

    openRaidLib.RequestKeystoneDataFromGuild()
    openRaidLib.RequestKeystoneDataFromParty()
    openRaidLib.RequestKeystoneDataFromRaid()
end)
--]=]


--------------------------------------------------------------------------------------------------------------------------------
--> data

--vintage cooldown tracker and interrupt tracker
C_Timer.After(0.1, function()
    local vintageCDTrackerFrame = CreateFrame("frame")
    vintageCDTrackerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    local allCooldownsFromLib = LIB_OPEN_RAID_COOLDOWNS_INFO
    local recentCastedSpells =  {}

    vintageCDTrackerFrame:SetScript("OnEvent", function(self, event, ...)
        if (event == "UNIT_SPELLCAST_SUCCEEDED") then
            local unit, castGUID, spellId = ...

            local unitIsThePlayer = UnitIsUnit(unit, "player")
            if (not unitIsThePlayer) then
                local unitName = GetUnitName(unit, true)
                local hasLib = openRaidLib.CooldownManager.HasFullCooldownList[unitName]
                if (unitName and not hasLib) then
                    local unitInGroup = UnitInParty(unit) or UnitInRaid(unit)
                    if (unitInGroup) then
                        local cooldownInfo = allCooldownsFromLib[spellId]
                        if (cooldownInfo) then -- and not openRaidLib.GetUnitCooldown(unitName)
                            --check for cast_success spam from channel spells
                            local unitCastCooldown = recentCastedSpells[unitName]
                            if (not unitCastCooldown) then
                                unitCastCooldown = {}
                                recentCastedSpells[unitName] = unitCastCooldown
                            end

                            if (not unitCastCooldown[spellId] or unitCastCooldown[spellId]+5 < GetTime()) then
                                unitCastCooldown[spellId] = GetTime()

                                --trigger a cooldown usage
                                local duration = cooldownInfo.duration
                                --time left, charges, startTimeOffset, duration
                                openRaidLib.CooldownManager.CooldownSpellUpdate(unitName, spellId, duration, 0, 0, duration)
                                local cooldownInfo = cooldownGetSpellInfo(unitName, spellId)
                                local unitCooldownsTable = openRaidLib.GetUnitCooldowns(unitName)

                                --trigger a public callback
                                openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", openRaidLib.GetUnitID(unitName), spellId, cooldownInfo, unitCooldownsTable, openRaidLib.CooldownManager.UnitData)
                            end
                        end
                    end
                end
            end
        end
    end)
end)
