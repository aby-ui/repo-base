
local major = "LibOpenRaid-1.0"
local CONST_LIB_VERSION = 20
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

    --print failures (when the function return an error) results to chat
    local CONST_DIAGNOSTIC_ERRORS = false
    --print the data to be sent and data received from comm
    local CONST_DIAGNOSTIC_COMM = false

    local CONST_COMM_PREFIX = "LRS"
    local CONST_COMM_FULLINFO_PREFIX = "F"
    local CONST_COMM_COOLDOWNUPDATE_PREFIX = "U"
    local CONST_COMM_COOLDOWNFULLLIST_PREFIX = "C"
    local CONST_COMM_GEARINFO_FULL_PREFIX = "G"
    local CONST_COMM_GEARINFO_DURABILITY_PREFIX = "R"
    local CONST_COMM_PLAYER_DEAD_PREFIX = "D"
    local CONST_COMM_PLAYER_ALIVE_PREFIX = "A"
    local CONST_COMM_PLAYERINFO_PREFIX = "P"
    local CONST_COMM_PLAYERINFO_TALENTS_PREFIX = "T"

    local CONST_ONE_SECOND = 1.0
    local CONST_TWO_SECONDS = 2.0
    local CONST_THREE_SECONDS = 3.0
    local CONST_FRACTION_OF_A_SECOND = 0.01

    local CONST_COOLDOWN_CHECK_INTERVAL = CONST_THREE_SECONDS
    local CONST_COOLDOWN_TIMELEFT_HAS_CHANGED = CONST_THREE_SECONDS

    local diagnosticError = function(msg, ...)
        if (CONST_DIAGNOSTIC_ERRORS) then
            print("|cFFFF9922OpenRaidLib|r:", msg, ...)
        end
    end

    local diagnosticComm = function(msg, ...)
        if (CONST_DIAGNOSTIC_COMM) then
            print("|cFFFF9922OpenRaidLib|r:", msg, ...)
        end
    end

    local isTimewalkWoW = function()
        local gameVersion = GetBuildInfo()
        if (gameVersion:match("%d") == "1" or gameVersion:match("%d") == "2") then
            return true
        end
    end

    --return the current specId of the player
    function openRaidLib.GetPlayerSpecId()
        if (isTimewalkWoW()) then
            return 0
        end

        local spec = GetSpecialization()
        if (spec) then
            local specId = GetSpecializationInfo(spec)
            if (specId and specId > 0) then
                return specId
            end
        end
    end

    function openRaidLib.UpdatePlayerAliveStatus(onLogin)
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

    --creates two tables, one with indexed talents and another with pairs values ([talentId] = true)
    function openRaidLib.GetPlayerTalents()
		local talentsPairs = {}
		local talentsIndex = {}
		for i = 1, 7 do
			for o = 1, 3 do
				local talentId, _, _, selected = GetTalentInfo(i, o, 1)
				if (selected) then
                    talentsPairs[talentId] = true
                    talentsIndex[#talentsIndex+1] = talentId
					break
				end
			end
        end
        return talentsPairs, talentsIndex
    end

    --simple non recursive table copy
    function openRaidLib.TCopy(tableToReceive, tableToCopy)
        for key, value in pairs(tableToCopy) do
            tableToReceive[key] = value
        end
    end

    --transform a table index into a string dividing values with a comma
    --@table: an indexed table with unknown size
    function openRaidLib.PackTable(table)
        local tableSize = #table
        local newString = "" .. tableSize .. ","
        for i = 1, tableSize do
            newString = newString .. table[i] .. ","
        end

        newString = newString:gsub(",$", "")
        return newString
    end

    --return is a number is almost equal to another within a tolerance range
    function openRaidLib.isNearlyEqual(value1, value2, tolerance)
        tolerance = tolerance or CONST_FRACTION_OF_A_SECOND
        return abs(value1 - value2) <= tolerance
    end

    --return true if the lib is allowed to receive comms from other players
    function openRaidLib.IsCommAllowed()
        return IsInGroup() or IsInRaid()
    end

    --stract some indexes of a table
    local selectIndexes = function(table, startIndex, amountIndexes)
        local values = {}
        for i = startIndex, startIndex+amountIndexes do
            values[#values+1] = tonumber(table[i]) or 0
        end
        return values
    end

    --transform a string table into a regular table
    --@table: a table with unknown values
    --@index: where in the table is the information we want
    --@isPair: if true treat the table as pairs(), ipairs() otherwise
    --@valueAsTable: return {value1, value2, value3}
    --@amountOfValues: for the parameter above
    function openRaidLib.UnpackTable(table, index, isPair, valueIsTable, amountOfValues)
        local result = {}
        local reservedIndexes = table[index]
        if (not reservedIndexes) then
            return result
        end
        local indexStart = index+1
        local indexEnd = reservedIndexes+index

        if (isPair) then
            amountOfValues = amountOfValues or 2
            for i = indexStart, indexEnd, amountOfValues do
                if (valueIsTable) then
                    local key = tonumber(table[i])
                    local values = selectIndexes(table, i+1, max(amountOfValues-2, 1))
                    result[key] = values
                else
                    local key = tonumber(table[i])
                    local value = tonumber(table[i+1])
                    result[key] = value
                end
            end
        else
            for i = indexStart, indexEnd do
                local value = tonumber(table[i])
                result[#result+1] = value
            end
        end
        
        return result
    end

    --returns if the player is in group
    function openRaidLib.IsInGroup()
        local inParty = IsInGroup()
        local inRaid = IsInRaid()
        return inParty or inRaid
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~comms
    openRaidLib.commHandler = {}

    function openRaidLib.commHandler.OnReceiveComm(self, event, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
        --check if the data belong to us
        if (prefix == CONST_COMM_PREFIX) then
            --check if the lib can receive comms
            if (not openRaidLib.IsCommAllowed()) then
                return
            end

            sender = Ambiguate(sender, "none")

            --don't receive comms from the player it self
            local playerName = UnitName("player")
            if (playerName == sender) then
                --return --commented for debug
            end
            
            local data = text
            local LibDeflate = LibStub:GetLibrary("LibDeflate")
            local dataCompressed = LibDeflate:DecodeForWoWAddonChannel(data)
            data = LibDeflate:DecompressDeflate(dataCompressed)

            --get the first byte of the data, it indicates what type of data was transmited
            local dataTypePrefix = data:match("^.")
            --get the table with functions regitered for this type of data
            local callbackTable = openRaidLib.commHandler.commCallback[dataTypePrefix]
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
        [CONST_COMM_GEARINFO_FULL_PREFIX] = {}, --an update of gear information
        [CONST_COMM_GEARINFO_DURABILITY_PREFIX] = {}, --an update of the player gear durability
        [CONST_COMM_PLAYER_DEAD_PREFIX] = {}, --player is dead
        [CONST_COMM_PLAYER_ALIVE_PREFIX] = {}, --player is alive
        [CONST_COMM_PLAYERINFO_PREFIX] = {}, --info about the player
        [CONST_COMM_PLAYERINFO_TALENTS_PREFIX] = {}, --cooldown info
    }

    function openRaidLib.commHandler.RegisterComm(prefix, func)
        --the table for the prefix need to be declared at the 'openRaidLib.commHandler.commCallback' table
        tinsert(openRaidLib.commHandler.commCallback[prefix], func)
    end

    function openRaidLib.commHandler.SendCommData(data)
        local LibDeflate = LibStub:GetLibrary("LibDeflate")
        local dataCompressed = LibDeflate:CompressDeflate(data, {level = 9})
        local dataEncoded = LibDeflate:EncodeForWoWAddonChannel(dataCompressed)

        if (IsInGroup() and not IsInRaid()) then --in party only
            C_ChatInfo.SendAddonMessage(CONST_COMM_PREFIX, dataEncoded, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")

        elseif (IsInRaid()) then
            C_ChatInfo.SendAddonMessage(CONST_COMM_PREFIX, dataEncoded, IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID")
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
            print("openRaidLib: error on scheduler:", tickerObject.scheduleName, tickerObject.stack, errortext)
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
        "CooldownListWiped",
        "CooldownUpdate",
        "OnPlayerDeath",
        "OnPlayerRess",
        "GearListWiped",
        "GearUpdate",
        "GearDurabilityUpdate",
        "PlayerUpdate",
        "TalentUpdate",
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
                    print("error:", errorMessage)
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
        ["playerCast"] = {},
        ["onEnterWorld"] = {},
        ["talentUpdate"] = {},
        ["onPlayerDeath"] = {},
        ["onPlayerRess"] = {},
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
        end,

        ["UNIT_SPELLCAST_SUCCEEDED"] = function(...)
            local unitId, castGUID, spellId = ...
            C_Timer.After(0.1, function()
                openRaidLib.internalCallback.TriggerEvent("playerCast", spellId)
            end)
        end,

        ["PLAYER_ENTERING_WORLD"] = function(...)
            openRaidLib.internalCallback.TriggerEvent("onEnterWorld")
        end,

        --["PLAYER_SPECIALIZATION_CHANGED"] = function(...) end, --on changing spec, the talent_update event is also triggered
        ["PLAYER_TALENT_UPDATE"] = function(...)
            openRaidLib.internalCallback.TriggerEvent("talentUpdate")
        end,

        ["PLAYER_DEAD"] = function(...)
            openRaidLib.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_ALIVE"] = function(...)
            openRaidLib.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_UNGHOST"] = function(...)
            openRaidLib.UpdatePlayerAliveStatus()
        end,

        ["PLAYER_REGEN_DISABLED"] = function(...)
            --entered in combat
        end,

        ["PLAYER_REGEN_ENABLED"] = function(...)
            --left combat
            --when left encounter, share everything
            --small hack, pretend to have just entered in the group, hence send all data
            openRaidLib.internalCallback.TriggerEvent("onEnterGroup")
        end,

        ["UPDATE_INVENTORY_DURABILITY"] = function(...)
            --an item has changed its durability
            --do not trigger this event  while in combat
            if (not InCombatLockdown()) then
                openRaidLib.Schedules.NewUniqueTimer(5 + math.random(0, 4), openRaidLib.gearManager.SendDurability, "gearManager", "sendDurability_Schedule")
            end
        end,

        ["PLAYER_EQUIPMENT_CHANGED"] = function(...)
            --player changed an equipment
            openRaidLib.Schedules.NewUniqueTimer(4 + math.random(0, 5), openRaidLib.gearManager.SendAllGearInfo, "gearManager", "sendAllGearInfo_Schedule")
        end,

        ["ENCOUNTER_END"] = function()

        end,
    }

    eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    eventFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
    eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

    --eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    if (not isTimewalkWoW()) then
        eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
        eventFrame:RegisterEvent("ENCOUNTER_END")
    end

    eventFrame:RegisterEvent("PLAYER_DEAD")
    eventFrame:RegisterEvent("PLAYER_ALIVE")
    eventFrame:RegisterEvent("PLAYER_UNGHOST")

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

        --send cooldown data
        openRaidLib.cooldownManager.SendAllCooldowns()

        --send gear data
        openRaidLib.gearManager.SendAllGearInfo()

        --send player data
        openRaidLib.playerInfoManager.SendAllPlayerInfo()
    end

    openRaidLib.mainControl.onEnterWorld = function()
        --update the alive status of the player
        openRaidLib.UpdatePlayerAliveStatus(true)

        --the game client is fully loadded and all information is available
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0, openRaidLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
        end
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

        openRaidLib.publicCallback.TriggerCallback("OnPlayerDeath", playerName)
    end

    openRaidLib.mainControl.OnPlayerRess = function()
        local playerName = UnitName("player")
        openRaidLib.mainControl.playerAliveStatus[playerName] = true

        local dataToSend = CONST_COMM_PLAYER_ALIVE_PREFIX
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("OnPlayerRess| " .. dataToSend) --debug

        openRaidLib.publicCallback.TriggerCallback("OnPlayerRess", playerName)
    end

    openRaidLib.internalCallback.RegisterCallback("onEnterWorld", openRaidLib.mainControl.onEnterWorld)
    openRaidLib.internalCallback.RegisterCallback("onEnterGroup", openRaidLib.mainControl.OnEnterGroup)
    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.mainControl.OnLeftGroup)
    openRaidLib.internalCallback.RegisterCallback("onPlayerDeath", openRaidLib.mainControl.OnPlayerDeath)
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.mainControl.OnPlayerRess)

    --a player in the group died
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYER_DEAD_PREFIX, function(data, sourceName)
        openRaidLib.mainControl.playerAliveStatus[sourceName] = false
        openRaidLib.publicCallback.TriggerCallback("OnPlayerDeath", sourceName)
    end)

    --a player in the group is now alive
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYER_ALIVE_PREFIX, function(data, sourceName)
        openRaidLib.mainControl.playerAliveStatus[sourceName] = true
        openRaidLib.publicCallback.TriggerCallback("OnPlayerRess", sourceName)
    end)


--------------------------------------------------------------------------------------------------------------------------------
--> ~all, request data from all players

    --send a request to all player to send their data
    function openRaidLib.RequestAllPlayersInfo()
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
--> ~cooldowns
    openRaidLib.cooldownManager = {
        playerData = {}, --stores the list of cooldowns each player has sent
        playerCurrentCooldowns = {},
        cooldownTickers = {}, --store C_Timer.NewTicker
    }

    --check if a cooldown has changed or done
    local cooldownTimeLeftCheck = function(tickerObject)
        local spellId = tickerObject.spellId
        tickerObject.cooldownTimeLeft = tickerObject.cooldownTimeLeft - CONST_COOLDOWN_CHECK_INTERVAL
        local timeLeft, charges, startTime, duration = openRaidLib.cooldownManager.GetCooldownStatus(spellId)

        --is the spell ready to use?
        if (timeLeft == 0) then
            --it's ready
            openRaidLib.cooldownManager.SendCooldownUpdate(spellId, 0, charges, 0, 0)
            openRaidLib.cooldownManager.cooldownTickers[spellId] = nil
            tickerObject:Cancel()
        else
            --check if the time left has changed
            if (not openRaidLib.isNearlyEqual(tickerObject.cooldownTimeLeft, timeLeft, CONST_COOLDOWN_TIMELEFT_HAS_CHANGED)) then
                --there's a deviation, send a comm to communicate the change in the time left
                openRaidLib.cooldownManager.SendCooldownUpdate(spellId, timeLeft, charges, startTime, duration)
                tickerObject.cooldownTimeLeft = timeLeft
            end
        end
    end

    --after a spell is casted by the player, start a ticker to check its cooldown
    local cooldownStartTicker = function(spellId, cooldownTimeLeft)
        local existingTicker = openRaidLib.cooldownManager.cooldownTickers[spellId]
        if (existingTicker) then
            --is a ticker already exists, might be the cooldown of a charge
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
        local newTicker = C_Timer.NewTicker(CONST_COOLDOWN_CHECK_INTERVAL, cooldownTimeLeftCheck, maxTicks)

        --store the ticker
        openRaidLib.cooldownManager.cooldownTickers[spellId] = newTicker
        newTicker.spellId = spellId
        newTicker.cooldownTimeLeft = cooldownTimeLeft
        newTicker.startTime = GetTime()
        newTicker.endTime = GetTime() + cooldownTimeLeft
    end

    local cooldownGetUnitTable = function(unitName, shouldWipe)
        local unitCooldownTable = openRaidLib.cooldownManager.playerData[unitName]
        --check if the unit has a cooldownTable
        if (not unitCooldownTable) then
            unitCooldownTable = {}
            openRaidLib.cooldownManager.playerData[unitName] = unitCooldownTable
        else
            --as the unit could have changed a talent or spec, wipe the table before using it
            if (shouldWipe) then
                table.wipe(unitCooldownTable)
            end
        end

        return unitCooldownTable
    end

    --update a single spell time and charges
    --called when the player casted a cooldown and when received a cooldown update from another player
    --only update the db, no other action is taken
    local singleCooldownUpdate = function(unitName, spellId, newTimeLeft, newCharges, startTime, duration)
        local unitCooldownTable = cooldownGetUnitTable(unitName)
        local spellIdTable = unitCooldownTable[spellId] or {}
        spellIdTable[1] = newTimeLeft
        spellIdTable[2] = newCharges
        spellIdTable[3] = startTime
        spellIdTable[4] = duration
        unitCooldownTable[spellId] = spellIdTable
    end

    function openRaidLib.cooldownManager.GetAllPlayersCooldown()
        return openRaidLib.cooldownManager.playerData
    end

    --@playerName: name of the player
    function openRaidLib.cooldownManager.GetPlayerCooldowns(playerName)
        return openRaidLib.cooldownManager.playerData[playerName]
    end

    function openRaidLib.cooldownManager.OnPlayerCast(event, spellId)
        --player casted a spell, check if the spell is registered as cooldown
        local playerSpec = openRaidLib.GetPlayerSpecId()
        if (playerSpec) then
            if (LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[playerSpec] and LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[playerSpec][spellId]) then
                --get the cooldown time for this spell
                local timeLeft, charges, startTime, duration = openRaidLib.cooldownManager.GetCooldownStatus(spellId)
                local playerName = UnitName("player")
                local playerCooldownTable = openRaidLib.cooldownManager.GetPlayerCooldowns(playerName)

                --update the time left
                singleCooldownUpdate(playerName, spellId, timeLeft, charges, startTime, duration)

                --trigger a public callback
                openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", playerName, spellId, timeLeft, charges, startTime, duration, playerCooldownTable, openRaidLib.cooldownManager.playerData)

                --send to comm
                openRaidLib.cooldownManager.SendCooldownUpdate(spellId, timeLeft, charges, startTime, duration)

                --create a timer to monitor the time of this cooldown
                --as there's just a few of them to monitor, there's no issue on creating one timer per spell
                cooldownStartTicker(spellId, timeLeft)
            end
        end
    end
    openRaidLib.internalCallback.RegisterCallback("playerCast",  openRaidLib.cooldownManager.OnPlayerCast)

    --received a cooldown update from another unit (sent by the function above)
    openRaidLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNUPDATE_PREFIX, function(data, sourceName)
        --get data
        local dataAsArray = data
        local spellId = tonumber(dataAsArray[1])
        local cooldownTimer = tonumber(dataAsArray[2])
        local charges = tonumber(dataAsArray[3])
        local startTime = tonumber(dataAsArray[4])
        local duration = tonumber(dataAsArray[5])

        --check integraty
        if (not spellId or spellId == 0) then
            return diagnosticError("cooldownManager|comm received|spellId is invalid")

        elseif (not cooldownTimer) then
            return diagnosticError("cooldownManager|comm received|cooldownTimer is invalid")

        elseif (not charges) then
            return diagnosticError("cooldownManager|comm received|charges is invalid")
        
        elseif (not startTime) then
            return diagnosticError("cooldownManager|comm received|startTime is invalid")

        elseif (not duration) then
            return diagnosticError("cooldownManager|comm received|duration is invalid")
        end

        --update
        singleCooldownUpdate(sourceName, spellId, cooldownTimer, charges, startTime, duration)

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", sourceName, spellId, cooldownTimer, charges, startTime, duration, openRaidLib.cooldownManager.playerData)
    end)

    --when the player is ressed while in a group, send the cooldown list
    function openRaidLib.cooldownManager.OnPlayerRess()
        --check if is in group
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), openRaidLib.cooldownManager.SendAllCooldowns, "cooldownManager", "sendAllCooldowns_Schedule")
        end
    end
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.cooldownManager.OnPlayerRess)

    --clear data stored
    function openRaidLib.cooldownManager.EraseData()
        table.wipe(openRaidLib.cooldownManager.playerData)
    end

    function openRaidLib.cooldownManager.OnLeaveGroup()
        --clear the data
        openRaidLib.cooldownManager.EraseData()

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("CooldownListWiped", openRaidLib.cooldownManager.playerData)
    end
    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.cooldownManager.OnLeaveGroup)

    --adds a list of cooldowns for another player in the group
    --this is called from the received cooldown list from comm
    function openRaidLib.cooldownManager.AddUnitCooldownsList(unitName, cooldownsTable)
        local unitCooldownTable = cooldownGetUnitTable(unitName, true)
        openRaidLib.TCopy(unitCooldownTable, cooldownsTable)

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("CooldownListUpdate", unitName, unitCooldownTable, openRaidLib.cooldownManager.playerData)
    end

    --check if a player cooldown is ready or if is in cooldown
    --@spellId: the spellId to check for cooldown
    function openRaidLib.cooldownManager.GetCooldownStatus(spellId)
        --check if is a charge spell
        local cooldownInfo = LIB_OPEN_RAID_COOLDOWNS_INFO[spellId]
        if (cooldownInfo) then
            if (cooldownInfo.charges and cooldownInfo.charges > 1) then
                local chargesAvailable, chargesTotal, start, duration = GetSpellCharges(spellId)

                if (chargesAvailable == chargesTotal) then
                    return 0, chargesTotal, 0, 0 --all charges are ready to use
                else
                    --return the time to the next charge
                    local timeLeft = start + duration - GetTime()
                    local startTimeOffset = start - GetTime()
                    return ceil(timeLeft), chargesAvailable, startTimeOffset, duration --time left, charges, startTime
                end

            else
                local start, duration = GetSpellCooldown(spellId)
                if (start == 0) then --cooldown is ready
                    return 0, 1, 0, 0 --time left, charges, startTime
                else
                    local timeLeft = start + duration - GetTime()
                    local startTimeOffset = start - GetTime()
                    return ceil(timeLeft), 0, ceil(startTimeOffset), duration --time left, charges, startTime, duration
                end
            end
        else
            return diagnosticError("cooldownManager|GetCooldownStatus()|cooldownInfo not found|", spellId)
        end
    end

    --send to comm all cooldowns available for the player
    function openRaidLib.cooldownManager.SendAllCooldowns()
        --get the full cooldown list
        local playerCooldownList = openRaidLib.cooldownManager.GetPlayerCooldownList()
        local dataToSend = CONST_COMM_COOLDOWNFULLLIST_PREFIX .. ","

        --pack
        local playerCooldownString = openRaidLib.PackTable(playerCooldownList)
        dataToSend = dataToSend .. playerCooldownString

        --send the data
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendAllCooldowns| " .. dataToSend) --debug
    end

    --send to comm a specific cooldown that was just used, a charge got available or its cooldown is over (ready to use)
    function openRaidLib.cooldownManager.SendCooldownUpdate(spellId, cooldownTimeLeft, charges, startTime, duration)
        local dataToSend = CONST_COMM_COOLDOWNUPDATE_PREFIX .. "," .. spellId .. "," .. cooldownTimeLeft .. "," .. charges .. "," .. startTime .. "," .. duration
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendCooldownUpdate| " .. dataToSend) --debug
    end

    --triggered when the lib receives a full list of cooldowns from another player in the raid
    --@data: table received from comm
    --@source: player name
    function openRaidLib.cooldownManager.OnReceiveCooldowns(data, source)
        --unpack the table as a pairs table | the cooldown info uses 5 indexes
        local unpackedTable = openRaidLib.UnpackTable(data, 1, true, true, 5)
        --add the list of cooldowns
        openRaidLib.cooldownManager.AddUnitCooldownsList(source, unpackedTable)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNFULLLIST_PREFIX, openRaidLib.cooldownManager.OnReceiveCooldowns)


    --build a list with the local player cooldowns
    function openRaidLib.cooldownManager.GetPlayerCooldownList()
        --get the player specId
        local specId = openRaidLib.GetPlayerSpecId()
        if (specId) then
            --get the cooldowns for the specialization
            local playerCooldowns = LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[specId]
            if (not playerCooldowns) then
                diagnosticError("cooldownManager|GetPlayerCooldownList|can't find player cooldowns for specId:", specId)
                return {}
            end

            local cooldowns = {}
            local talentsHash, talentsIndex = openRaidLib.GetPlayerTalents()

            for cooldownSpellId, cooldownType in pairs(playerCooldowns) do
                --get all the information about this cooldow
                local cooldownInfo = LIB_OPEN_RAID_COOLDOWNS_INFO[cooldownSpellId]
                if (cooldownInfo) then
                    --does this cooldown is based on a talent?
                    local talentId = cooldownInfo.talent
                    if (talentId) then
                        --check if the player has the talent selected
                        if (talentsHash[talentId]) then
                            cooldowns[#cooldowns+1] = cooldownSpellId
                            local timeLeft, charges, startTime, duration = openRaidLib.cooldownManager.GetCooldownStatus(cooldownSpellId)
                            cooldowns[#cooldowns+1] = timeLeft
                            cooldowns[#cooldowns+1] = charges
                            cooldowns[#cooldowns+1] = startTime
                            cooldowns[#cooldowns+1] = duration
                        end
                    else
                        cooldowns[#cooldowns+1] = cooldownSpellId
                        local timeLeft, charges, startTime, duration = openRaidLib.cooldownManager.GetCooldownStatus(cooldownSpellId)
                        cooldowns[#cooldowns+1] = timeLeft
                        cooldowns[#cooldowns+1] = charges
                        cooldowns[#cooldowns+1] = startTime
                        cooldowns[#cooldowns+1] = duration
                    end
                end
            end
            return cooldowns
        else
            return {}
        end
    end

--> vintage cooldown tracker
C_Timer.After(0.1, function()
    local vintageCDTrackerFrame = CreateFrame("frame")
    vintageCDTrackerFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    local allCooldownsFromLib = LIB_OPEN_RAID_COOLDOWNS_INFO
    local recentCastedSpells =  {}

    vintageCDTrackerFrame:SetScript("OnEvent", function(self, event, ...)
        if (event == "UNIT_SPELLCAST_SUCCEEDED") then
            local unit, castGUID, spellId = ...
            if (UnitInParty(unit) or UnitInRaid(unit)) then
                local unitName = UnitName(unit)
                local cooldownInfo = allCooldownsFromLib[spellId]
                if (cooldownInfo and unitName and not openRaidLib.cooldownManager.GetPlayerCooldowns(unitName)) then
                    --check for cast_success spam from channel spells
                    local unitCastCooldown = recentCastedSpells[UnitGUID(unit)]
                    if (not unitCastCooldown) then
                        unitCastCooldown = {}
                        recentCastedSpells[UnitGUID(unit)] = unitCastCooldown
                    end

                    if (not unitCastCooldown[spellId] or unitCastCooldown[spellId]+5 < GetTime()) then
                        unitCastCooldown[spellId] = GetTime()
                        --trigger a cooldown usage

                        local duration = cooldownInfo.duration
                        --time left, charges, startTimeDeviation, duration
                        singleCooldownUpdate(unitName, spellId, duration, 0, 0, duration)

                        --trigger a public callback
                        openRaidLib.publicCallback.TriggerCallback("CooldownUpdate", unitName, spellId, duration, 0, 0, duration, openRaidLib.cooldownManager.playerData)
                    end
                end
            end
        end
    end)
end)




--------------------------------------------------------------------------------------------------------------------------------
--> ~equipment

    openRaidLib.gearManager = {
        --structure:
        --[playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
        playerData = {},
    }

    function openRaidLib.gearManager.GetAllPlayersGear()
        return openRaidLib.gearManager.playerData
    end

    function openRaidLib.gearManager.GetPlayerGear(playerName, createNew)
        local playerGearInfo = openRaidLib.gearManager.playerData[playerName]
        if (not playerGearInfo and createNew) then
            playerGearInfo = {
                ilevel = 0,
                durability = 0,
                weaponEnchant = 0,
                noGems = {},
                noEnchants = {},
            }
            openRaidLib.gearManager.playerData[playerName] = playerGearInfo
        end
        return playerGearInfo
    end

    --return an integer between zero and one hundret indicating the player gear durability
    function openRaidLib.gearManager.GetGearDurability()
        local durabilityTotalPercent, totalItems = 0, 0
        for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
            local durability, maxDurability = GetInventoryItemDurability(i)
            if (durability and maxDurability) then
                local itemDurability = durability / maxDurability * 100
                durabilityTotalPercent = durabilityTotalPercent + itemDurability
                totalItems = totalItems + 1
            end
        end
    
        if (totalItems == 0) then
            return 100
        end
    
        return floor(durabilityTotalPercent / totalItems)
    end

    --clear data stored
    function openRaidLib.gearManager.EraseData()
        table.wipe(openRaidLib.gearManager.playerData)
    end

    function openRaidLib.gearManager.OnLeaveGroup()
        --clear the data
        openRaidLib.gearManager.EraseData()

        --trigger a public callback
        openRaidLib.publicCallback.TriggerCallback("GearListWiped", openRaidLib.gearManager.playerData)
    end
    openRaidLib.internalCallback.RegisterCallback("onLeaveGroup", openRaidLib.gearManager.OnLeaveGroup)

    --when the player is ressed while in a group, send the cooldown list
    function openRaidLib.gearManager.OnPlayerRess()
        --check if is in group
        if (openRaidLib.IsInGroup()) then
            openRaidLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), openRaidLib.gearManager.SendDurability, "gearManager", "sendDurability_Schedule")
        end
    end
    openRaidLib.internalCallback.RegisterCallback("onPlayerRess", openRaidLib.gearManager.OnPlayerRess)

    --send only the gear durability
    function openRaidLib.gearManager.SendDurability()
        local dataToSend = CONST_COMM_GEARINFO_DURABILITY_PREFIX .. ","
        local playerGearDurability = openRaidLib.gearManager.GetGearDurability()

        dataToSend = dataToSend .. playerGearDurability

        --send the data
        openRaidLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendGearDurabilityData| " .. dataToSend) --debug
    end

    function openRaidLib.gearManager.OnReceiveGearDurability(data, source)
        local durability = tonumber(data[1])
        openRaidLib.gearManager.UpdateUnitGearDurability(source, durability)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_DURABILITY_PREFIX, openRaidLib.gearManager.OnReceiveGearDurability)

    --on receive the durability (sent when the player get a ress)
    function openRaidLib.gearManager.UpdateUnitGearDurability(playerName, durability)
        local playerGearInfo = openRaidLib.gearManager.GetPlayerGear(playerName)
        if (playerGearInfo) then
            playerGearInfo.durability = durability
            openRaidLib.publicCallback.TriggerCallback("GearDurabilityUpdate", playerName, durability, playerGearInfo, openRaidLib.gearManager.GetAllPlayersGear())
        end
    end

    --get gear information from what the player has equipped at the moment
    function openRaidLib.gearManager.GetPlayerGearInfo()

        --get the player class and specId
        local _, playerClass = UnitClass("player")
        local specId = openRaidLib.GetPlayerSpecId()
        --get which attribute the spec uses
        local specMainAttribute = openRaidLib.specAttribute[playerClass][specId] --1 int, 2 dex, 3 str

        if (not specId or not specMainAttribute) then
            return {0, 0, 0, {}, {}}
        end

        --item level
            local itemLevel
            if (_G.GetAverageItemLevel) then
                local _, _itemLevel = GetAverageItemLevel()
                itemLevel = floor(_itemLevel)
            else
                itemLevel = 0
            end

        --repair status
            local gearDurability = openRaidLib.gearManager.GetGearDurability()

        --get weapon enchant
            local weaponEnchant = 0
            local _, _, _, mainHandEnchantId, _, _, _, offHandEnchantId = GetWeaponEnchantInfo()
            if (LIB_OPEN_RAID_WEAPON_ENCHANT_IDS[mainHandEnchantId]) then
                weaponEnchant = 1

            elseif(LIB_OPEN_RAID_WEAPON_ENCHANT_IDS[offHandEnchantId]) then
                weaponEnchant = 1
            end

        --enchants and gems
            --hold equipmentSlotId of equipment with a gem socket but it's empty
            local slotsWithoutGems = {}
            --hold equipmentSlotId of equipments without an enchant
            local slotsWithoutEnchant = {}

            for equipmentSlotId = 1, 17 do

                local itemLink = GetInventoryItemLink("player", equipmentSlotId)

                if (itemLink) then
                    --get the information from the item
                    local _, itemId, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, levelOfTheItem, specId, upgradeInfo, instanceDifficultyId, numBonusIds, restLink = strsplit(":", itemLink)
                    local gemsIds = {gemId1, gemId2, gemId3, gemId4}

                    --enchant
                        --check if the slot can receive enchat and if the equipment has an enchant
                        local enchantAttribute = LIB_OPEN_RAID_ENCHANT_SLOTS[equipmentSlotId]
                        if (enchantAttribute) then --this slot can receive an enchat

                            --check if this slot is relevant for the class, some slots can have enchants only for Agility which won't matter for Priests as an example
                            --if the value is an integer it points to an attribute (int, dex, str), otherwise it's true (boolean)
                            local slotIsRelevant = true
                            if (type (enchantAttribute) == "number") then
                                if (specMainAttribute ~= enchantAttribute) then
                                    slotIsRelevant = false
                                end
                            end

                            if (slotIsRelevant) then
                                --does the slot has any enchant?
                                if (not enchantId or enchantId == "0" or enchantId == "") then
                                    slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId

                                else
                                    --convert to integer
                                    local enchantIdInt = tonumber(enchantId)
                                    if (enchantIdInt) then
                                        --does the enchant is relevent for the character?
                                        if (not LIB_OPEN_RAID_ENCHANT_IDS[enchantIdInt]) then
                                            slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                                        end

                                    else
                                        --the enchat has an invalid id
                                        slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                                    end
                                end
                            end
                        end

                    --gems
                        local itemStatsTable = {}
                        --fill the table above with information about the item
                        GetItemStats(itemLink, itemStatsTable)

                        --check if the item has a socket
                        if (itemStatsTable.EMPTY_SOCKET_PRISMATIC) then
                            --check if the socket is empty
                            for i = 1, itemStatsTable.EMPTY_SOCKET_PRISMATIC do
                                local gemId = tonumber(gemsIds[i])
                                if (not gemId or gemId == 0) then
                                    slotsWithoutGems[#slotsWithoutGems+1] = equipmentSlotId

                                --check if the gem is not a valid gem (deprecated gem)
                                elseif (not LIB_OPEN_RAID_GEM_IDS[gemId]) then
                                    slotsWithoutGems[#slotsWithoutGems+1] = equipmentSlotId

                                end
                            end
                        end
                end
            end --end of enchants and gems

        --build the table with the gear information
        local playerGearInfo = {}
        playerGearInfo[#playerGearInfo+1] = itemLevel           --[1]
        playerGearInfo[#playerGearInfo+1] = gearDurability      --[2]
        playerGearInfo[#playerGearInfo+1] = weaponEnchant       --[3]
        playerGearInfo[#playerGearInfo+1] = slotsWithoutEnchant --[4]
        playerGearInfo[#playerGearInfo+1] = slotsWithoutGems    --[5]

        --update the player table
        openRaidLib.gearManager.AddUnitGearInfoList(UnitName("player"), itemLevel, gearDurability, weaponEnchant, slotsWithoutEnchant, slotsWithoutGems)

        return playerGearInfo
    end

    --when received the gear update from another player, store it and trigger a callback
    function openRaidLib.gearManager.AddUnitGearInfoList(playerName, itemLevel, durability, weaponEnchant, noEnchantTable, noGemsTable)
        local playerGearInfo = openRaidLib.gearManager.GetPlayerGear(playerName, true)

        playerGearInfo.ilevel = itemLevel
        playerGearInfo.durability = durability
        playerGearInfo.weaponEnchant = weaponEnchant
        playerGearInfo.noGems = noGemsTable
        playerGearInfo.noEnchants = noEnchantTable

        openRaidLib.publicCallback.TriggerCallback("GearUpdate", playerName, playerGearInfo, openRaidLib.gearManager.GetAllPlayersGear())
    end

    --triggered when the lib receives a gear information from another player in the raid
    --@data: table received from comm
    --@source: player name
    function openRaidLib.gearManager.OnReceiveGearFullInfo(data, source)
        local itemLevel = tonumber(data[1])
        local durability = tonumber(data[2])
        local weaponEnchant = tonumber(data[3])

        local noEnchantTableSize = tonumber(data[4])
        local noGemsTableIndex = tonumber(noEnchantTableSize + 5)
        local noGemsTableSize = data[noGemsTableIndex]

        --openRaidLib.UnpackTable(table, index, isPair, valueIsTable, amountOfValues)

        --unpack the enchant data as a ipairs table
        local noEnchantTableUnpacked = openRaidLib.UnpackTable(data, 4, false, false, noEnchantTableSize)
        --unpack the enchant data as a ipairs table
        local noGemsTableUnpacked = openRaidLib.UnpackTable(data, noGemsTableIndex, false, false, noGemsTableSize)

        --add to the list of gear information
        openRaidLib.gearManager.AddUnitGearInfoList(source, itemLevel, durability, weaponEnchant, noEnchantTableUnpacked, noGemsTableUnpacked)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_FULL_PREFIX, openRaidLib.gearManager.OnReceiveGearFullInfo)

    function openRaidLib.gearManager.SendAllGearInfo()
        --get gear information, gear info has 4 indexes:
        --[1] int item level
        --[2] int durability
        --[3] int weapon enchant
        --[3] table with integers of equipSlot without enchant
        --[4] table with integers of equipSlot which has a gem slot but the slot is empty            

        local dataToSend = CONST_COMM_GEARINFO_FULL_PREFIX .. ","
        local playerGearInfo = openRaidLib.gearManager.GetPlayerGearInfo()

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
--> ~player general ~info

    openRaidLib.playerInfoManager = {
        --structure:
        --[playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
        playerData = {},
    }

    function openRaidLib.playerInfoManager.GetAllPlayersInfo()
        return openRaidLib.playerInfoManager.playerData
    end

    function openRaidLib.playerInfoManager.GetPlayerInfo(playerName, createNew)
        local playerInfo = openRaidLib.playerInfoManager.playerData[playerName]
        if (not playerInfo and createNew) then
            playerInfo = {
                specId = 0,
                renown = 1,
                covenantId = 0,
                talents = {},
                conduits = {},
            }
            openRaidLib.playerInfoManager.playerData[playerName] = playerInfo
        end
        return playerInfo
    end

    function openRaidLib.playerInfoManager.AddPlayerInfo(playerName, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked)
        local playerInfo = openRaidLib.playerInfoManager.GetPlayerInfo(playerName, true)

        playerInfo.specId = specId
        playerInfo.renown = renown
        playerInfo.covenantId = covenantId
        playerInfo.talents = talentsTableUnpacked
        playerInfo.conduits = conduitsTableUnpacked

        openRaidLib.publicCallback.TriggerCallback("PlayerUpdate", playerName, openRaidLib.playerInfoManager.playerData[playerName], openRaidLib.playerInfoManager.GetAllPlayersInfo())
    end

    --triggered when the lib receives a gear information from another player in the raid
    --@data: table received from comm
    --@source: player name
    function openRaidLib.playerInfoManager.OnReceivePlayerFullInfo(data, source)
        local specId = tonumber(data[1])
        local renown = tonumber(data[2])
        local covenantId = tonumber(data[3])
        local talentsSize = tonumber(data[4])
        local conduitsTableIndex = tonumber((talentsSize + 1) + 3) + 1 -- +3 = specIndex renowIndex covenantIdIndex | talentSizeIndex + talentSize | +1
        local conduitsSize = data[conduitsTableIndex]

        --unpack the talents data as a ipairs table
        local talentsTableUnpacked = openRaidLib.UnpackTable(data, 4, false, false, talentsSize)

        --unpack the conduits data as a ipairs table
        local conduitsTableUnpacked = openRaidLib.UnpackTable(data, conduitsTableIndex, false, false, conduitsSize)

        --add to the list of players information and also trigger a public callback
        openRaidLib.playerInfoManager.AddPlayerInfo(source, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked)
    end
    openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_PREFIX, openRaidLib.playerInfoManager.OnReceivePlayerFullInfo)

function openRaidLib.playerInfoManager.SendAllPlayerInfo()
    local playerInfo = openRaidLib.playerInfoManager.GetPlayerFullInfo()

    local dataToSend = CONST_COMM_PLAYERINFO_PREFIX .. ","
    dataToSend = dataToSend .. playerInfo[1] .. "," --spec id
    dataToSend = dataToSend .. playerInfo[2] .. "," --renown
    dataToSend = dataToSend .. playerInfo[3] .. "," --covenantId
    dataToSend = dataToSend .. openRaidLib.PackTable(playerInfo[4]) .. "," --talents
    dataToSend = dataToSend .. openRaidLib.PackTable(playerInfo[5]) .. "," --conduits

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendGetPlayerInfoFullData| " .. dataToSend) --debug
end

function openRaidLib.playerInfoManager.GetPlayerFullInfo()
    local playerInfo = {}

    if (isTimewalkWoW()) then
        --indexes: specId, renown, covenant, talent, conduits
        --return a placeholder table
        return {0, 0, 0, {0, 0, 0, 0, 0, 0, 0}, {0, 0}}
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
    local talents = {0, 0, 0, 0, 0, 0, 0}
    for talentTier = 1, 7 do
        for talentColumn = 1, 3 do
            local talentId, name, texture, selected, available = GetTalentInfo(talentTier, talentColumn, 1)
            if (selected) then
                talents[talentTier] = talentId
                break
            end
        end
    end

    playerInfo[4] = talents

    --conduits
    local conduits = {}
    local soulbindID = C_Soulbinds.GetActiveSoulbindID()
    if (soulbindID ~= 0) then
        local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID)
        if (soulbindData ~= 0) then
            local tree = soulbindData.tree
            local nodes = tree.nodes

            table.sort(nodes, function(t1, t2) return t1.row < t2.row end)

            for nodeId, nodeInfo in ipairs(nodes) do
                --check if the node is a conduit placed by the player
                
                if (nodeInfo.state == Enum.SoulbindNodeState.Selected)  then
                    local conduitId = nodeInfo.conduitID
                    local conduitRank = nodeInfo.conduitRank
                    
                    if (conduitId and conduitRank) then
                        --have spell id when it's a default conduit from the game
                        local spellId = nodeInfo.spellID
                        --have conduit id when is a conduid placed by the player
                        local conduitId  = nodeInfo.conduitID
                        
                        if (spellId == 0) then
                            --is player conduit
                            spellId = C_Soulbinds.GetConduitSpellID(nodeInfo.conduitID, nodeInfo.conduitRank)
                            local conduitItemLevel = C_Soulbinds.GetConduitItemLevel(conduitId,  conduitRank)
                            conduits[#conduits+1] = spellId
                            conduits[#conduits+1] = conduitItemLevel
                        else
                            --is default conduit
                            conduits[#conduits+1] = spellId
                            conduits[#conduits+1] = 0
                        end

                        --local link = C_Soulbinds.GetConduitHyperlink( conduitId,  conduitRank )
                    end
                end
            end
        end
    end

    playerInfo[5] = conduits

    return playerInfo

    --/run Details:Dump (Enum.SoulbindNodeState)
    --/run Details:Dump ( nodes )
    
    --[=[
        ["Selectable"] = 2
        ["Unavailable"] = 0
        ["Unselected"] = 1
        ["Selected"] = 3
    --]=]
            
    --[=[
        [1] = table {
        ["conduitID"] = 195
        ["conduitType"] = 1
        ["state"] = 3
        ["icon"] = 463891
        ["parentNodeIDs"] = table {
            ["1"] = 1316
        }
        ["column"] = 0
        ["ID"] = 1305
        ["conduitRank"] = 4
        ["row"] = 1
        ["spellID"] = 0
        }
    --]=]
end

function openRaidLib.playerInfoManager.onEnterWorld()
    openRaidLib.playerInfoManager.GetPlayerFullInfo()
end
openRaidLib.internalCallback.RegisterCallback("onEnterWorld", openRaidLib.playerInfoManager.onEnterWorld)

--talent update
function openRaidLib.playerInfoManager.sendTalentUpdate()
    --talents
    local talentsToSend = {0, 0, 0, 0, 0, 0, 0}
    for talentTier = 1, 7 do
        for talentColumn = 1, 3 do
            local talentId, name, texture, selected, available = GetTalentInfo(talentTier, talentColumn, 1)
            if (selected) then
                talentsToSend[talentTier] = talentId
                break
            end
        end
    end

    local dataToSend = CONST_COMM_PLAYERINFO_TALENTS_PREFIX .. ","
    local talentsString = openRaidLib.PackTable(talentsToSend)
    dataToSend = dataToSend .. talentsString

    --send the data
    openRaidLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendTalentUpdateData| " .. dataToSend) --debug
end

function openRaidLib.playerInfoManager.scheduleTalentUpdate()
    openRaidLib.Schedules.NewUniqueTimer(1 + math.random(0, 1), openRaidLib.playerInfoManager.sendTalentUpdate, "playerInfoManager", "sendTalent_Schedule")
end
openRaidLib.internalCallback.RegisterCallback("talentUpdate", openRaidLib.playerInfoManager.scheduleTalentUpdate)

function openRaidLib.playerInfoManager.OnReceiveTalentsUpdate(data, source)
    local talentsTableUnpacked = openRaidLib.UnpackTable(data, 1, false, false, 7)

    local playerInfo = openRaidLib.playerInfoManager.GetPlayerInfo(source)
    if (playerInfo) then
        playerInfo.talents = talentsTableUnpacked

        --trigger public callback event
        openRaidLib.publicCallback.TriggerCallback("TalentUpdate", source, playerInfo, openRaidLib.playerInfoManager.GetAllPlayersInfo())
    end
end
openRaidLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_TALENTS_PREFIX, openRaidLib.playerInfoManager.OnReceiveTalentsUpdate)



--------------------------------------------------------------------------------------------------------------------------------
--> data

--which is the main attribute of each spec
--1 Intellect
--2 Agility
--3 Strenth
openRaidLib.specAttribute = {
	["DEMONHUNTER"] = {
		[577] = 2,
		[581] = 2,
	},
	["DEATHKNIGHT"] = {
		[250] = 3,
		[251] = 3,
		[252] = 3,
	},
	["WARRIOR"] = {
		[71] = 3,
		[72] = 3,
		[73] = 3,
	},
	["MAGE"] = {
		[62] = 1,
		[63] = 1,
		[64] = 1,
	},
	["ROGUE"] = {
		[259] = 2,
		[260] = 2,
		[261] = 2,
	},
	["DRUID"] = {
		[102] = 1,
		[103] = 2,
		[104] = 2,
		[105] = 1,
	},
	["HUNTER"] = {
		[253] = 2,
		[254] = 2,
		[255] = 2,
	},
	["SHAMAN"] = {
		[262] = 1,
		[263] = 2,
		[264] = 1,
	},
	["PRIEST"] = {
		[256] = 1,
		[257] = 1,
		[258] = 1,
	},
	["WARLOCK"] = {
		[265] = 1,
		[266] = 1,
		[267] =1 ,
	},
	["PALADIN"] = {
		[65] = 1,
		[66] = 3,
		[70] = 3,
	},
	["MONK"] = {
		[268] = 2,
		[269] = 2,
		[270] = 1,
    }
}
