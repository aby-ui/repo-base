
local major = "LibRaidStatus-1.0"
local CONST_LIB_VERSION = 17
LIB_RAID_STATUS_CAN_LOAD = false

--declae the library within the LibStub
    local libStub = _G.LibStub
    local raidStatusLib = libStub:NewLibrary(major, CONST_LIB_VERSION)
    if (not raidStatusLib) then
        return
    end

    LIB_RAID_STATUS_CAN_LOAD = true

--default values
    raidStatusLib.inGroup = false

    --print failures (when the function return an error) results to chat
    local CONST_DIAGNOSTIC_ERRORS = false
    --print the data to be sent and data received from comm
    local CONST_DIAGNOSTIC_COMM = false

    local CONST_COMM_PREFIX = "LRS"
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
            print("|cFFFF9922raidStatusLib|r:", msg, ...)
        end
    end

    local diagnosticComm = function(msg, ...)
        if (CONST_DIAGNOSTIC_COMM) then
            print("|cFFFF9922raidStatusLib|r:", msg, ...)
        end
    end

    local isTimewalkWoW = function()
        local gameVersion = GetBuildInfo()
        if (gameVersion:match("%d") == "1" or gameVersion:match("%d") == "2") then
            return true
        end
    end

    --return the current specId of the player
    function raidStatusLib.GetPlayerSpecId()
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

    function raidStatusLib.UpdatePlayerAliveStatus(onLogin)
        if (UnitIsDeadOrGhost("player")) then
            if (raidStatusLib.playerAlive) then
                raidStatusLib.playerAlive = false

                --trigger event if this isn't from login
                if (not onLogin) then
                    raidStatusLib.internalCallback.TriggerEvent("onPlayerDeath")
                end
            end
        else
            if (not raidStatusLib.playerAlive) then
                raidStatusLib.playerAlive = true

                --trigger event if this isn't from login
                if (not onLogin) then
                    raidStatusLib.internalCallback.TriggerEvent("onPlayerRess")
                end
            end
        end
    end

    --creates two tables, one with indexed talents and another with pairs values ([talentId] = true)
    function raidStatusLib.GetPlayerTalents()
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
    function raidStatusLib.TCopy(tableToReceive, tableToCopy)
        for key, value in pairs(tableToCopy) do
            tableToReceive[key] = value
        end
    end

    --transform a table index into a string dividing values with a comma
    --@table: an indexed table with unknown size
    function raidStatusLib.PackTable(table)
        local tableSize = #table
        local newString = "" .. tableSize .. ","
        for i = 1, tableSize do
            newString = newString .. table[i] .. ","
        end

        newString = newString:gsub(",$", "")
        return newString
    end

    --return is a number is almost equal to another within a tolerance range
    function raidStatusLib.isNearlyEqual(value1, value2, tolerance)
        tolerance = tolerance or CONST_FRACTION_OF_A_SECOND
        return abs(value1 - value2) <= tolerance
    end

    --return true if the lib is allowed to receive comms from other players
    function raidStatusLib.IsCommAllowed()
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
    function raidStatusLib.UnpackTable(table, index, isPair, valueIsTable, amountOfValues)
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
    function raidStatusLib.IsInGroup()
        local inParty = IsInGroup()
        local inRaid = IsInRaid()
        return inParty or inRaid
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~comms
    raidStatusLib.commHandler = {}

    function raidStatusLib.commHandler.OnReceiveComm(self, event, prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
        --check if the data belong to us
        if (prefix == CONST_COMM_PREFIX) then
            --check if the lib can receive comms
            if (not raidStatusLib.IsCommAllowed()) then
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
            local callbackTable = raidStatusLib.commHandler.commCallback[dataTypePrefix]
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
    raidStatusLib.commHandler.eventFrame = CreateFrame("frame")
    raidStatusLib.commHandler.eventFrame:RegisterEvent("CHAT_MSG_ADDON")
    raidStatusLib.commHandler.eventFrame:SetScript("OnEvent", raidStatusLib.commHandler.OnReceiveComm)

    raidStatusLib.commHandler.commCallback = {
                                            --when transmiting
        [CONST_COMM_COOLDOWNFULLLIST_PREFIX] = {}, --all cooldowns of a player
        [CONST_COMM_COOLDOWNUPDATE_PREFIX] = {}, --an update of a single cooldown
        [CONST_COMM_GEARINFO_FULL_PREFIX] = {}, --an update of gear information
        [CONST_COMM_GEARINFO_DURABILITY_PREFIX] = {}, --an update of the player gear durability
        [CONST_COMM_PLAYER_DEAD_PREFIX] = {}, --player is dead
        [CONST_COMM_PLAYER_ALIVE_PREFIX] = {}, --player is alive
        [CONST_COMM_PLAYERINFO_PREFIX] = {}, --info about the player
        [CONST_COMM_PLAYERINFO_TALENTS_PREFIX] = {}, --cooldown info
    }

    function raidStatusLib.commHandler.RegisterComm(prefix, func)
        --the table for the prefix need to be declared at the 'raidStatusLib.commHandler.commCallback' table
        tinsert(raidStatusLib.commHandler.commCallback[prefix], func)
    end

    function raidStatusLib.commHandler.SendCommData(data)
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

    raidStatusLib.Schedules = {
        registeredUniqueTimers = {}
    }
    
    --run a scheduled function with its payload
    local triggerScheduledTick = function(tickerObject)
        local payload = tickerObject.payload
        local callback = tickerObject.callback
    
        local result, errortext = pcall(callback, _G.unpack(payload))
        if (not result) then
            print("raidStatusLib: error on scheduler:", tickerObject.scheduleName, tickerObject.stack, errortext)
        end

        if (tickerObject.isUnique) then
            local namespace = tickerObject.namespace
            local scheduleName = tickerObject.scheduleName
            raidStatusLib.Schedules.CancelUniqueTimer(namespace, scheduleName)
        end

        return result
    end

    --create a new schedule
    function raidStatusLib.Schedules.NewTimer(time, callback, ...)
        local payload = {...}
        local newTimer = C_Timer.NewTimer(time, triggerScheduledTick)
        newTimer.payload = payload
        newTimer.callback = callback
        newTimer.stack = debugstack()
        return newTimer
    end

    --create an unique schedule
    --if a schedule already exists, cancels it and make a new
    function raidStatusLib.Schedules.NewUniqueTimer(time, callback, namespace, scheduleName, ...)
        raidStatusLib.Schedules.CancelUniqueTimer(namespace, scheduleName)

        local newTimer = raidStatusLib.Schedules.NewTimer(time, callback, ...)
        newTimer.namespace = namespace
        newTimer.scheduleName = scheduleName
        newTimer.stack = debugstack()
        newTimer.isUnique = true

        local registeredUniqueTimers = raidStatusLib.Schedules.registeredUniqueTimers
        registeredUniqueTimers[namespace] = registeredUniqueTimers[namespace] or {}
        registeredUniqueTimers[namespace][scheduleName] = newTimer
    end

    --cancel an unique schedule
    function raidStatusLib.Schedules.CancelUniqueTimer(namespace, scheduleName)
        local registeredUniqueTimers = raidStatusLib.Schedules.registeredUniqueTimers
        local currentSchedule = registeredUniqueTimers[namespace] and registeredUniqueTimers[namespace][scheduleName]

        if (currentSchedule) then
            if (not currentSchedule._cancelled) then
                currentSchedule:Cancel()
            end
            registeredUniqueTimers[namespace][scheduleName] = nil
        end
    end

    --cancel all unique timers
    function raidStatusLib.Schedules.CancelAllUniqueTimers()
        local registeredUniqueTimers = raidStatusLib.Schedules.registeredUniqueTimers
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
    raidStatusLib.publicCallback = raidStatusLib.publicCallback or {}
    raidStatusLib.publicCallback.events = raidStatusLib.publicCallback.events or {}
    for _, callbackName in ipairs(allPublicCallbacks) do
        raidStatusLib.publicCallback.events[callbackName] = raidStatusLib.publicCallback.events[callbackName] or {}
    end

    local checkRegisterDataIntegrity = function(addonObject, event, callbackMemberName)
        --check of integrity
        if (type(addonObject) == "string") then
            addonObject = _G[addonObject]
        end

        if (type(addonObject) ~= "table") then
            return 1
        end

        if (not raidStatusLib.publicCallback.events[event]) then
            return 2

        elseif (not addonObject[callbackMemberName]) then
            return 3
        end

        return true
    end

    --call the registered function within the addon namespace
    --payload is sent together within the call
    function raidStatusLib.publicCallback.TriggerCallback(event, ...)
        local callbacks = raidStatusLib.publicCallback.events[event]

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
    
    function raidStatusLib.RegisterCallback(addonObject, event, callbackMemberName)
        --check of integrity
        local integrity = checkRegisterDataIntegrity(addonObject, event, callbackMemberName)
        if (integrity and type(integrity) ~= "boolean") then
            return integrity
        end

        --register
        tinsert(raidStatusLib.publicCallback.events[event], {addonObject, callbackMemberName})
        return true
    end

    function raidStatusLib.UnregisterCallback(addonObject, event, callbackMemberName)
        --check of integrity
        local integrity = checkRegisterDataIntegrity(addonObject, event, callbackMemberName)
        if (integrity and type(integrity) ~= "boolean") then
            return integrity
        end

        for i = 1, #raidStatusLib.publicCallback.events[event] do
            local registeredCallback = raidStatusLib.publicCallback.events[event][i]
            if (registeredCallback[1] == addonObject and registeredCallback[2] == callbackMemberName) then
                tremove(raidStatusLib.publicCallback.events[event], i)
                break
            end
        end
    end

--------------------------------------------------------------------------------------------------------------------------------
--> ~internal ~callbacks
--internally, each module can register events through the internal callback to be notified when something happens in the game

    raidStatusLib.internalCallback = {}
    raidStatusLib.internalCallback.events = {
        ["onEnterGroup"] = {},
        ["onLeaveGroup"] = {},
        ["playerCast"] = {},
        ["onEnterWorld"] = {},
        ["talentUpdate"] = {},
        ["onPlayerDeath"] = {},
        ["onPlayerRess"] = {},
    }

    raidStatusLib.internalCallback.RegisterCallback = function(event, func)
        tinsert(raidStatusLib.internalCallback.events[event], func)
    end

    raidStatusLib.internalCallback.UnRegisterCallback = function(event, func)
        local container = raidStatusLib.internalCallback.events[event]
        for i = 1, #container do
            if (container[i] == func) then
                tremove(container, i)
                break
            end
        end
    end

    function raidStatusLib.internalCallback.TriggerEvent(event, ...)
        local container = raidStatusLib.internalCallback.events[event]
        for i = 1, #container do
            container[i](event, ...)
        end
    end

    --create the frame for receiving game events
    local eventFrame = _G.RaidStatusLibFrame
    if (not eventFrame) then
        eventFrame = CreateFrame("frame", "RaidStatusLibFrame", UIParent)
    end

    local eventFunctions = {
        --check if the player joined a group
        ["GROUP_ROSTER_UPDATE"] = function()
            local eventTriggered = false
            if (raidStatusLib.IsInGroup()) then
                if (not raidStatusLib.inGroup) then
                    raidStatusLib.inGroup = true
                    raidStatusLib.internalCallback.TriggerEvent("onEnterGroup")
                    eventTriggered = true
                end
            else
                if (raidStatusLib.inGroup) then
                    raidStatusLib.inGroup = false
                    raidStatusLib.internalCallback.TriggerEvent("onLeaveGroup")
                    eventTriggered = true
                end
            end

            if (not eventTriggered and raidStatusLib.IsInGroup()) then --the player didn't left or enter a group
                --the group has changed, trigger a long timer to send full data
                --as the timer is unique, a new change to the group will replace and refresh the time
                --using random time, players won't trigger all at the same time
                local randomTime = 1.0 + math.random(1.0, 5.5)
                raidStatusLib.Schedules.NewUniqueTimer(randomTime, raidStatusLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
            end
        end,

        ["UNIT_SPELLCAST_SUCCEEDED"] = function(...)
            local unitId, castGUID, spellId = ...
            C_Timer.After(0.1, function()
                raidStatusLib.internalCallback.TriggerEvent("playerCast", spellId)
            end)
        end,

        ["PLAYER_ENTERING_WORLD"] = function(...)
            raidStatusLib.internalCallback.TriggerEvent("onEnterWorld")
        end,

        --["PLAYER_SPECIALIZATION_CHANGED"] = function(...) end, --on changing spec, the talent_update event is also triggered
        ["PLAYER_TALENT_UPDATE"] = function(...)
            raidStatusLib.internalCallback.TriggerEvent("talentUpdate")
        end,

        ["PLAYER_DEAD"] = function(...)
            raidStatusLib.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_ALIVE"] = function(...)
            raidStatusLib.UpdatePlayerAliveStatus()
        end,
        ["PLAYER_UNGHOST"] = function(...)
            raidStatusLib.UpdatePlayerAliveStatus()
        end,

        ["PLAYER_REGEN_DISABLED"] = function(...)
            --entered in combat
        end,

        ["PLAYER_REGEN_ENABLED"] = function(...)
            --left combat
            raidStatusLib.Schedules.NewUniqueTimer(10 + math.random(0, 4), raidStatusLib.gearManager.SendDurability, "gearManager", "sendDurability_Schedule")
        end,

        ["UPDATE_INVENTORY_DURABILITY"] = function(...)
            --an item has changed its durability
            --do not trigger this event  while in combat
            if (not InCombatLockdown()) then
                raidStatusLib.Schedules.NewUniqueTimer(5 + math.random(0, 4), raidStatusLib.gearManager.SendDurability, "gearManager", "sendDurability_Schedule")
            end
        end,

        ["PLAYER_EQUIPMENT_CHANGED"] = function(...)
            --player changed an equipment
            raidStatusLib.Schedules.NewUniqueTimer(4 + math.random(0, 5), raidStatusLib.gearManager.SendAllGearInfo, "gearManager", "sendAllGearInfo_Schedule")
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
    end
    
    eventFrame:RegisterEvent("PLAYER_DEAD")
    eventFrame:RegisterEvent("PLAYER_ALIVE")
    eventFrame:RegisterEvent("PLAYER_UNGHOST")

    eventFrame:SetScript("OnEvent", function(self, event, ...)
        eventFunctions[event](...)
    end)

--------------------------------------------------------------------------------------------------------------------------------
--> ~main ~control

    raidStatusLib.mainControl = {
        playerAliveStatus = {},
    }

    --send full data (all data available)
    function raidStatusLib.mainControl.SendFullData()

        --send cooldown data
        raidStatusLib.cooldownManager.SendAllCooldowns()

        --send gear data
        raidStatusLib.gearManager.SendAllGearInfo()

        --send player data
        raidStatusLib.playerInfoManager.SendAllPlayerInfo()
    end

    raidStatusLib.mainControl.onEnterWorld = function()
        --update the alive status of the player
        raidStatusLib.UpdatePlayerAliveStatus(true)

        --the game client is fully loadded and all information is available
        if (raidStatusLib.IsInGroup()) then
            raidStatusLib.Schedules.NewUniqueTimer(1.0, raidStatusLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
        end
    end

    raidStatusLib.mainControl.OnEnterGroup = function()
        --the player entered in a group
        --schedule to send data
        raidStatusLib.Schedules.NewUniqueTimer(1.0, raidStatusLib.mainControl.SendFullData, "mainControl", "sendFullData_Schedule")
    end

    raidStatusLib.mainControl.OnLeftGroup = function()
        --the player left a group
        --wipe group data (each module registers the OnLeftGroup)

        --cancel all schedules
        raidStatusLib.Schedules.CancelAllUniqueTimers()

        --wipe alive status
        table.wipe(raidStatusLib.mainControl.playerAliveStatus)

        --toggle off comms
    end

    raidStatusLib.mainControl.OnPlayerDeath = function()
        local playerName = UnitName("player")
        raidStatusLib.mainControl.playerAliveStatus[playerName] = false

        local dataToSend = CONST_COMM_PLAYER_DEAD_PREFIX
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("OnPlayerDeath| " .. dataToSend) --debug

        raidStatusLib.publicCallback.TriggerCallback("OnPlayerDeath", playerName)
    end

    raidStatusLib.mainControl.OnPlayerRess = function()
        local playerName = UnitName("player")
        raidStatusLib.mainControl.playerAliveStatus[playerName] = true

        local dataToSend = CONST_COMM_PLAYER_ALIVE_PREFIX
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("OnPlayerRess| " .. dataToSend) --debug

        raidStatusLib.publicCallback.TriggerCallback("OnPlayerRess", playerName)
    end

    raidStatusLib.internalCallback.RegisterCallback("onEnterWorld", raidStatusLib.mainControl.onEnterWorld)
    raidStatusLib.internalCallback.RegisterCallback("onEnterGroup", raidStatusLib.mainControl.OnEnterGroup)
    raidStatusLib.internalCallback.RegisterCallback("onLeaveGroup", raidStatusLib.mainControl.OnLeftGroup)
    raidStatusLib.internalCallback.RegisterCallback("onPlayerDeath", raidStatusLib.mainControl.OnPlayerDeath)
    raidStatusLib.internalCallback.RegisterCallback("onPlayerRess", raidStatusLib.mainControl.OnPlayerRess)

    --a player in the group died
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_PLAYER_DEAD_PREFIX, function(data, sourceName)
        raidStatusLib.mainControl.playerAliveStatus[sourceName] = false
        raidStatusLib.publicCallback.TriggerCallback("OnPlayerDeath", sourceName)
    end)

    --a player in the group is now alive
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_PLAYER_ALIVE_PREFIX, function(data, sourceName)
        raidStatusLib.mainControl.playerAliveStatus[sourceName] = true
        raidStatusLib.publicCallback.TriggerCallback("OnPlayerRess", sourceName)
    end)

--------------------------------------------------------------------------------------------------------------------------------
--> ~cooldowns
    raidStatusLib.cooldownManager = {
        playerData = {}, --stores the list of cooldowns each player has sent
        playerCurrentCooldowns = {},
        cooldownTickers = {}, --store C_Timer.NewTicker
    }

    --check if a cooldown has changed or done
    local cooldownTimeLeftCheck = function(tickerObject)
        local spellId = tickerObject.spellId
        tickerObject.cooldownTimeLeft = tickerObject.cooldownTimeLeft - CONST_COOLDOWN_CHECK_INTERVAL
        local timeLeft, charges, startTime, duration = raidStatusLib.cooldownManager.GetCooldownStatus(spellId)

        --is the spell ready to use?
        if (timeLeft == 0) then
            --it's ready
            raidStatusLib.cooldownManager.SendCooldownUpdate(spellId, 0, charges, 0, 0)
            raidStatusLib.cooldownManager.cooldownTickers[spellId] = nil
            tickerObject:Cancel()
        else
            --check if the time left has changed
            if (not raidStatusLib.isNearlyEqual(tickerObject.cooldownTimeLeft, timeLeft, CONST_COOLDOWN_TIMELEFT_HAS_CHANGED)) then
                --there's a deviation, send a comm to communicate the change in the time left
                raidStatusLib.cooldownManager.SendCooldownUpdate(spellId, timeLeft, charges, startTime, duration)
                tickerObject.cooldownTimeLeft = timeLeft
            end
        end
    end

    --after a spell is casted by the player, start a ticker to check its cooldown
    local cooldownStartTicker = function(spellId, cooldownTimeLeft)
        local existingTicker = raidStatusLib.cooldownManager.cooldownTickers[spellId]
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
        raidStatusLib.cooldownManager.cooldownTickers[spellId] = newTicker
        newTicker.spellId = spellId
        newTicker.cooldownTimeLeft = cooldownTimeLeft
        newTicker.startTime = GetTime()
        newTicker.endTime = GetTime() + cooldownTimeLeft
    end

    local cooldownGetUnitTable = function(unitName, shouldWipe)
        local unitCooldownTable = raidStatusLib.cooldownManager.playerData[unitName]
        --check if the unit has a cooldownTable
        if (not unitCooldownTable) then
            unitCooldownTable = {}
            raidStatusLib.cooldownManager.playerData[unitName] = unitCooldownTable
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

    function raidStatusLib.cooldownManager.GetAllPlayersCooldown()
        return raidStatusLib.cooldownManager.playerData
    end

    --@playerName: name of the player
    function raidStatusLib.cooldownManager.GetPlayerCooldowns(playerName)
        return raidStatusLib.cooldownManager.playerData[playerName]
    end

    function raidStatusLib.cooldownManager.OnPlayerCast(event, spellId)
        --player casted a spell, check if the spell is registered as cooldown
        local playerSpec = raidStatusLib.GetPlayerSpecId()
        if (playerSpec) then
            if (LIB_RAID_STATUS_COOLDOWNS_BY_SPEC[playerSpec] and LIB_RAID_STATUS_COOLDOWNS_BY_SPEC[playerSpec][spellId]) then
                --get the cooldown time for this spell
                local timeLeft, charges, startTime, duration = raidStatusLib.cooldownManager.GetCooldownStatus(spellId)
                local playerName = UnitName("player")
                local playerCooldownTable = raidStatusLib.cooldownManager.GetPlayerCooldowns(playerName)

                --update the time left
                singleCooldownUpdate(playerName, spellId, timeLeft, charges, startTime, duration)

                --trigger a public callback
                raidStatusLib.publicCallback.TriggerCallback("CooldownUpdate", playerName, spellId, timeLeft, charges, startTime, duration, playerCooldownTable, raidStatusLib.cooldownManager.playerData)

                --send to comm
                raidStatusLib.cooldownManager.SendCooldownUpdate(spellId, timeLeft, charges, startTime, duration)

                --create a timer to monitor the time of this cooldown
                --as there's just a few of them to monitor, there's no issue on creating one timer per spell
                cooldownStartTicker(spellId, timeLeft)
            end
        end
    end
    raidStatusLib.internalCallback.RegisterCallback("playerCast",  raidStatusLib.cooldownManager.OnPlayerCast)

    --received a cooldown update from another unit (sent by the function above)
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNUPDATE_PREFIX, function(data, sourceName)
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
        raidStatusLib.publicCallback.TriggerCallback("CooldownUpdate", sourceName, spellId, cooldownTimer, charges, startTime, duration, raidStatusLib.cooldownManager.playerData)
    end)

    --when the player is ressed while in a group, send the cooldown list
    function raidStatusLib.cooldownManager.OnPlayerRess()
        --check if is in group
        if (raidStatusLib.IsInGroup()) then
            raidStatusLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), raidStatusLib.cooldownManager.SendAllCooldowns, "cooldownManager", "sendAllCooldowns_Schedule")
        end
    end
    raidStatusLib.internalCallback.RegisterCallback("onPlayerRess", raidStatusLib.cooldownManager.OnPlayerRess)

    --clear data stored
    function raidStatusLib.cooldownManager.EraseData()
        table.wipe(raidStatusLib.cooldownManager.playerData)
    end

    function raidStatusLib.cooldownManager.OnLeaveGroup()
        --clear the data
        raidStatusLib.cooldownManager.EraseData()

        --trigger a public callback
        raidStatusLib.publicCallback.TriggerCallback("CooldownListWiped", raidStatusLib.cooldownManager.playerData)
    end
    raidStatusLib.internalCallback.RegisterCallback("onLeaveGroup", raidStatusLib.cooldownManager.OnLeaveGroup)

    --adds a list of cooldowns for another player in the group
    --this is called from the received cooldown list from comm
    function raidStatusLib.cooldownManager.AddUnitCooldownsList(unitName, cooldownsTable)
        local unitCooldownTable = cooldownGetUnitTable(unitName, true)
        raidStatusLib.TCopy(unitCooldownTable, cooldownsTable)

        --trigger a public callback
        raidStatusLib.publicCallback.TriggerCallback("CooldownListUpdate", unitName, unitCooldownTable, raidStatusLib.cooldownManager.playerData)
    end

    --check if a player cooldown is ready or if is in cooldown
    --@spellId: the spellId to check for cooldown
    function raidStatusLib.cooldownManager.GetCooldownStatus(spellId)
        --check if is a charge spell
        local cooldownInfo = LIB_RAID_STATUS_COOLDOWNS_INFO[spellId]
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
    function raidStatusLib.cooldownManager.SendAllCooldowns()
        --get the full cooldown list
        local playerCooldownList = raidStatusLib.cooldownManager.GetPlayerCooldownList()
        local dataToSend = CONST_COMM_COOLDOWNFULLLIST_PREFIX .. ","

        --pack
        local playerCooldownString = raidStatusLib.PackTable(playerCooldownList)
        dataToSend = dataToSend .. playerCooldownString

        --send the data
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendAllCooldowns| " .. dataToSend) --debug
    end

    --send to comm a specific cooldown that was just used, a charge got available or its cooldown is over (ready to use)
    function raidStatusLib.cooldownManager.SendCooldownUpdate(spellId, cooldownTimeLeft, charges, startTime, duration)
        local dataToSend = CONST_COMM_COOLDOWNUPDATE_PREFIX .. "," .. spellId .. "," .. cooldownTimeLeft .. "," .. charges .. "," .. startTime .. "," .. duration
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendCooldownUpdate| " .. dataToSend) --debug
    end

    --triggered when the lib receives a full list of cooldowns from another player in the raid
    --@data: table received from comm
    --@source: player name
    function raidStatusLib.cooldownManager.OnReceiveCooldowns(data, source)
        --unpack the table as a pairs table | the cooldown info uses 5 indexes
        local unpackedTable = raidStatusLib.UnpackTable(data, 1, true, true, 5)
        --add the list of cooldowns
        raidStatusLib.cooldownManager.AddUnitCooldownsList(source, unpackedTable)
    end
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_COOLDOWNFULLLIST_PREFIX, raidStatusLib.cooldownManager.OnReceiveCooldowns)


    --build a list with the local player cooldowns
    function raidStatusLib.cooldownManager.GetPlayerCooldownList()
        --get the player specId
        local specId = raidStatusLib.GetPlayerSpecId()
        if (specId) then
            --get the cooldowns for the specialization
            local playerCooldowns = LIB_RAID_STATUS_COOLDOWNS_BY_SPEC[specId]
            if (not playerCooldowns) then
                diagnosticError("cooldownManager|GetPlayerCooldownList|can't find player cooldowns for specId:", specId)
                return {}
            end

            local cooldowns = {}
            local talentsHash, talentsIndex = raidStatusLib.GetPlayerTalents()

            for cooldownSpellId, cooldownType in pairs(playerCooldowns) do
                --get all the information about this cooldow
                local cooldownInfo = LIB_RAID_STATUS_COOLDOWNS_INFO[cooldownSpellId]
                if (cooldownInfo) then
                    --does this cooldown is based on a talent?
                    local talentId = cooldownInfo.talent
                    if (talentId) then
                        --check if the player has the talent selected
                        if (talentsHash[talentId]) then
                            cooldowns[#cooldowns+1] = cooldownSpellId
                            local timeLeft, charges, startTime, duration = raidStatusLib.cooldownManager.GetCooldownStatus(cooldownSpellId)
                            cooldowns[#cooldowns+1] = timeLeft
                            cooldowns[#cooldowns+1] = charges
                            cooldowns[#cooldowns+1] = startTime
                            cooldowns[#cooldowns+1] = duration
                        end
                    else
                        cooldowns[#cooldowns+1] = cooldownSpellId
                        local timeLeft, charges, startTime, duration = raidStatusLib.cooldownManager.GetCooldownStatus(cooldownSpellId)
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
    local allCooldownsFromLib = LIB_RAID_STATUS_COOLDOWNS_INFO
    local recentCastedSpells =  {}

    vintageCDTrackerFrame:SetScript("OnEvent", function(self, event, ...)
        if (event == "UNIT_SPELLCAST_SUCCEEDED") then
            local unit, castGUID, spellId = ...
            if (UnitInParty(unit) or UnitInRaid(unit)) then
                local unitName = UnitName(unit)
                local cooldownInfo = allCooldownsFromLib[spellId]
                if (cooldownInfo and unitName and not raidStatusLib.cooldownManager.GetPlayerCooldowns(unitName)) then
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
                        raidStatusLib.publicCallback.TriggerCallback("CooldownUpdate", unitName, spellId, duration, 0, 0, duration, raidStatusLib.cooldownManager.playerData)
                    end
                end
            end
        end
    end)
end)




--------------------------------------------------------------------------------------------------------------------------------
--> ~equipment

    raidStatusLib.gearManager = {
        --structure:
        --[playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
        playerData = {},
    }

    function raidStatusLib.gearManager.GetAllPlayersGear()
        return raidStatusLib.gearManager.playerData
    end

    function raidStatusLib.gearManager.GetPlayerGear(playerName, createNew)
        local playerGearInfo = raidStatusLib.gearManager.playerData[playerName]
        if (not playerGearInfo and createNew) then
            playerGearInfo = {
                ilevel = 0,
                durability = 0,
                weaponEnchant = 0,
                noGems = {},
                noEnchants = {},
            }
            raidStatusLib.gearManager.playerData[playerName] = playerGearInfo
        end
        return playerGearInfo
    end

    --return an integer between zero and one hundret indicating the player gear durability
    function raidStatusLib.gearManager.GetGearDurability()
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
    function raidStatusLib.gearManager.EraseData()
        table.wipe(raidStatusLib.gearManager.playerData)
    end

    function raidStatusLib.gearManager.OnLeaveGroup()
        --clear the data
        raidStatusLib.gearManager.EraseData()

        --trigger a public callback
        raidStatusLib.publicCallback.TriggerCallback("GearListWiped", raidStatusLib.gearManager.playerData)
    end
    raidStatusLib.internalCallback.RegisterCallback("onLeaveGroup", raidStatusLib.gearManager.OnLeaveGroup)

    --when the player is ressed while in a group, send the cooldown list
    function raidStatusLib.gearManager.OnPlayerRess()
        --check if is in group
        if (raidStatusLib.IsInGroup()) then
            raidStatusLib.Schedules.NewUniqueTimer(1.0 + math.random(0.0, 6.0), raidStatusLib.gearManager.SendDurability, "gearManager", "sendDurability_Schedule")
        end
    end
    raidStatusLib.internalCallback.RegisterCallback("onPlayerRess", raidStatusLib.gearManager.OnPlayerRess)

    --send only the gear durability
    function raidStatusLib.gearManager.SendDurability()
        local dataToSend = CONST_COMM_GEARINFO_DURABILITY_PREFIX .. ","
        local playerGearDurability = raidStatusLib.gearManager.GetGearDurability()

        dataToSend = dataToSend .. playerGearDurability

        --send the data
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendGearDurabilityData| " .. dataToSend) --debug
    end

    function raidStatusLib.gearManager.OnReceiveGearDurability(data, source)
        local durability = tonumber(data[1])
        raidStatusLib.gearManager.UpdateUnitGearDurability(source, durability)
    end
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_DURABILITY_PREFIX, raidStatusLib.gearManager.OnReceiveGearDurability)

    --on receive the durability (sent when the player get a ress)
    function raidStatusLib.gearManager.UpdateUnitGearDurability(playerName, durability)
        local playerGearInfo = raidStatusLib.gearManager.GetPlayerGear(playerName)
        if (playerGearInfo) then
            playerGearInfo.durability = durability
            raidStatusLib.publicCallback.TriggerCallback("GearDurabilityUpdate", playerName, durability, playerGearInfo, raidStatusLib.gearManager.GetAllPlayersGear())
        end
    end

    --get gear information from what the player has equipped at the moment
    function raidStatusLib.gearManager.GetPlayerGearInfo()

        --get the player class and specId
        local _, playerClass = UnitClass("player")
        local specId = raidStatusLib.GetPlayerSpecId()
        --get which attribute the spec uses
        local specMainAttribute = raidStatusLib.specAttribute[playerClass][specId] --1 int, 2 dex, 3 str

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
            local gearDurability = raidStatusLib.gearManager.GetGearDurability()

        --get weapon enchant
            local weaponEnchant = 0
            local _, _, _, mainHandEnchantId, _, _, _, offHandEnchantId = GetWeaponEnchantInfo()
            if (LIB_RAID_STATUS_WEAPON_ENCHANT_IDS[mainHandEnchantId]) then
                weaponEnchant = 1

            elseif(LIB_RAID_STATUS_WEAPON_ENCHANT_IDS[offHandEnchantId]) then
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
                        local enchantAttribute = LIB_RAID_STATUS_ENCHANT_SLOTS[equipmentSlotId]
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
                                        if (not LIB_RAID_STATUS_ENCHANT_IDS[enchantIdInt]) then
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
                                elseif (not LIB_RAID_STATUS_GEM_IDS[gemId]) then
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
        raidStatusLib.gearManager.AddUnitGearInfoList(UnitName("player"), itemLevel, gearDurability, weaponEnchant, slotsWithoutEnchant, slotsWithoutGems)

        return playerGearInfo
    end

    --when received the gear update from another player, store it and trigger a callback
    function raidStatusLib.gearManager.AddUnitGearInfoList(playerName, itemLevel, durability, weaponEnchant, noEnchantTable, noGemsTable)
        local playerGearInfo = raidStatusLib.gearManager.GetPlayerGear(playerName, true)

        playerGearInfo.ilevel = itemLevel
        playerGearInfo.durability = durability
        playerGearInfo.weaponEnchant = weaponEnchant
        playerGearInfo.noGems = noGemsTable
        playerGearInfo.noEnchants = noEnchantTable

        raidStatusLib.publicCallback.TriggerCallback("GearUpdate", playerName, playerGearInfo, raidStatusLib.gearManager.GetAllPlayersGear())
    end

    --triggered when the lib receives a gear information from another player in the raid
    --@data: table received from comm
    --@source: player name
    function raidStatusLib.gearManager.OnReceiveGearFullInfo(data, source)
        local itemLevel = tonumber(data[1])
        local durability = tonumber(data[2])
        local weaponEnchant = tonumber(data[3])

        local noEnchantTableSize = tonumber(data[4])
        local noGemsTableIndex = tonumber(noEnchantTableSize + 5)
        local noGemsTableSize = data[noGemsTableIndex]

        --raidStatusLib.UnpackTable(table, index, isPair, valueIsTable, amountOfValues)

        --unpack the enchant data as a ipairs table
        local noEnchantTableUnpacked = raidStatusLib.UnpackTable(data, 4, false, false, noEnchantTableSize)
        --unpack the enchant data as a ipairs table
        local noGemsTableUnpacked = raidStatusLib.UnpackTable(data, noGemsTableIndex, false, false, noGemsTableSize)

        --add to the list of gear information
        raidStatusLib.gearManager.AddUnitGearInfoList(source, itemLevel, durability, weaponEnchant, noEnchantTableUnpacked, noGemsTableUnpacked)
    end
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_GEARINFO_FULL_PREFIX, raidStatusLib.gearManager.OnReceiveGearFullInfo)

    function raidStatusLib.gearManager.SendAllGearInfo()
        --get gear information, gear info has 4 indexes:
        --[1] int item level
        --[2] int durability
        --[3] int weapon enchant
        --[3] table with integers of equipSlot without enchant
        --[4] table with integers of equipSlot which has a gem slot but the slot is empty            

        local dataToSend = CONST_COMM_GEARINFO_FULL_PREFIX .. ","
        local playerGearInfo = raidStatusLib.gearManager.GetPlayerGearInfo()

        dataToSend = dataToSend .. playerGearInfo[1] .. "," --item level
        dataToSend = dataToSend .. playerGearInfo[2] .. "," --durability
        dataToSend = dataToSend .. playerGearInfo[3] .. "," --weapon enchant
        dataToSend = dataToSend .. raidStatusLib.PackTable(playerGearInfo[4]) .. "," --slots without enchant
        dataToSend = dataToSend .. raidStatusLib.PackTable(playerGearInfo[5]) -- slots with empty gem sockets

        --send the data
        raidStatusLib.commHandler.SendCommData(dataToSend)
        diagnosticComm("SendGearFullData| " .. dataToSend) --debug
    end


--------------------------------------------------------------------------------------------------------------------------------
--> ~player general ~info

    raidStatusLib.playerInfoManager = {
        --structure:
        --[playerName] = {ilevel = 100, durability = 100, weaponEnchant = 0, noGems = {}, noEnchants = {}}
        playerData = {},
    }

    function raidStatusLib.playerInfoManager.GetAllPlayersInfo()
        return raidStatusLib.playerInfoManager.playerData
    end

    function raidStatusLib.playerInfoManager.GetPlayerInfo(playerName, createNew)
        local playerInfo = raidStatusLib.playerInfoManager.playerData[playerName]
        if (not playerInfo and createNew) then
            playerInfo = {
                specId = 0,
                renown = 1,
                covenantId = 0,
                talents = {},
                conduits = {},
            }
            raidStatusLib.playerInfoManager.playerData[playerName] = playerInfo
        end
        return playerInfo
    end

    function raidStatusLib.playerInfoManager.AddPlayerInfo(playerName, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked)
        local playerInfo = raidStatusLib.playerInfoManager.GetPlayerInfo(playerName, true)

        playerInfo.specId = specId
        playerInfo.renown = renown
        playerInfo.covenantId = covenantId
        playerInfo.talents = talentsTableUnpacked
        playerInfo.conduits = conduitsTableUnpacked

        raidStatusLib.publicCallback.TriggerCallback("PlayerUpdate", playerName, raidStatusLib.playerInfoManager.playerData[playerName], raidStatusLib.playerInfoManager.GetAllPlayersInfo())
    end

    --triggered when the lib receives a gear information from another player in the raid
    --@data: table received from comm
    --@source: player name
    function raidStatusLib.playerInfoManager.OnReceivePlayerFullInfo(data, source)
        --Details:Dump(data)
        local specId = tonumber(data[1])
        local renown = tonumber(data[2])
        local covenantId = tonumber(data[3])
        local talentsSize = tonumber(data[4])
        local conduitsTableIndex = tonumber((talentsSize + 1) + 3) + 1 -- +3 = specIndex renowIndex covenantIdIndex | talentSizeIndex + talentSize | +1
        local conduitsSize = data[conduitsTableIndex]

        --unpack the talents data as a ipairs table
        local talentsTableUnpacked = raidStatusLib.UnpackTable(data, 3, false, false, talentsSize)

        --unpack the conduits data as a ipairs table
        local conduitsTableUnpacked = raidStatusLib.UnpackTable(data, conduitsTableIndex, false, false, conduitsSize)

        --add to the list of players information and also trigger a public callback
        raidStatusLib.playerInfoManager.AddPlayerInfo(source, specId, renown, covenantId, talentsTableUnpacked, conduitsTableUnpacked)
    end
    raidStatusLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_PREFIX, raidStatusLib.playerInfoManager.OnReceivePlayerFullInfo)

function raidStatusLib.playerInfoManager.SendAllPlayerInfo()
    local playerInfo = raidStatusLib.playerInfoManager.GetPlayerFullInfo()

    local dataToSend = CONST_COMM_PLAYERINFO_PREFIX .. ","
    dataToSend = dataToSend .. playerInfo[1] .. "," --spec id
    dataToSend = dataToSend .. playerInfo[2] .. "," --renown
    dataToSend = dataToSend .. playerInfo[3] .. "," --covenantId
    dataToSend = dataToSend .. raidStatusLib.PackTable(playerInfo[4]) .. "," --talents
    dataToSend = dataToSend .. raidStatusLib.PackTable(playerInfo[5]) .. "," --conduits

    --send the data
    raidStatusLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendGetPlayerInfoFullData| " .. dataToSend) --debug
end

function raidStatusLib.playerInfoManager.GetPlayerFullInfo()
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
                        --print(link)
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

function raidStatusLib.playerInfoManager.onEnterWorld()
    raidStatusLib.playerInfoManager.GetPlayerFullInfo()
end
raidStatusLib.internalCallback.RegisterCallback("onEnterWorld", raidStatusLib.playerInfoManager.onEnterWorld)

--talent update
function raidStatusLib.playerInfoManager.sendTalentUpdate()
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
    local talentsString = raidStatusLib.PackTable(talentsToSend)
    dataToSend = dataToSend .. talentsString

    --send the data
    raidStatusLib.commHandler.SendCommData(dataToSend)
    diagnosticComm("SendTalentUpdateData| " .. dataToSend) --debug
end

function raidStatusLib.playerInfoManager.scheduleTalentUpdate()
    raidStatusLib.Schedules.NewUniqueTimer(1 + math.random(0, 1), raidStatusLib.playerInfoManager.sendTalentUpdate, "playerInfoManager", "sendTalent_Schedule")
end
raidStatusLib.internalCallback.RegisterCallback("talentUpdate", raidStatusLib.playerInfoManager.scheduleTalentUpdate)

function raidStatusLib.playerInfoManager.OnReceiveTalentsUpdate(data, source)
    local talentsTableUnpacked = raidStatusLib.UnpackTable(data, 1, false, false, 7)

    local playerInfo = raidStatusLib.playerInfoManager.GetPlayerInfo(source)
    if (playerInfo) then
        playerInfo.talents = talentsTableUnpacked

        --trigger public callback event
        raidStatusLib.publicCallback.TriggerCallback("TalentUpdate", source, playerInfo, raidStatusLib.playerInfoManager.GetAllPlayersInfo())
    end
end
raidStatusLib.commHandler.RegisterComm(CONST_COMM_PLAYERINFO_TALENTS_PREFIX, raidStatusLib.playerInfoManager.OnReceiveTalentsUpdate)



--------------------------------------------------------------------------------------------------------------------------------
--> data

--which is the main attribute of each spec
--1 Intellect
--2 Agility
--3 Strenth
raidStatusLib.specAttribute = {
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
