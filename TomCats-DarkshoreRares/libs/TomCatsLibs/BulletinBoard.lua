local addon = select(2,...)
local RequestTicket, BNConnected, string = C_Club.RequestTicket, BNConnected, string
local TCL, lib = addon.TomCatsLibs, addon.TomCatsLibs.BulletinBoard

function lib.getMessage(...)
    local tickets, callback = ...
    local function bnConnected(self, event)
        if (event) then
            TCL.Events.UnregisterEvent("BN_CONNECTED", self)
        end
        for i = 1, #tickets do
            TCL.Events.RegisterEvent("CLUB_TICKET_RECEIVED", function(self, _, ...)
                local _, ticketId, clubInfo = ...
                if (ticketId == tickets[i]) then
                    if (clubInfo) then
                        callback(clubInfo.description)
                    end
                    TCL.Events.UnregisterEvent("CLUB_TICKET_RECEIVED", self)
                end
            end)
            RequestTicket(tickets[i])
        end
    end
    if (BNConnected()) then
        bnConnected()
    else
        TCL.Events.RegisterEvent("BN_CONNECTED", bnConnected)
    end
end

local function split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local function versionStringAsComparable(str)
    local vnum = 0
    for i in string.gmatch(str, "[0-9]+") do
        vnum = vnum * 100 + i
    end
    vnum = vnum * 100
    return vnum
end

function lib.checkForUpdates(currentVersion, messageId, bulletinBoards, callback)
    lib.getMessage(bulletinBoards, function(message)
        if (message) then
            local latestVersion = split(message, "|")[messageId] or currentVersion
            if (versionStringAsComparable(latestVersion) > versionStringAsComparable(currentVersion)) then
                callback(true, latestVersion)
            else
                callback(false)
            end
        end
    end)
end
