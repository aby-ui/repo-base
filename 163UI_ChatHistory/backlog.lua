
if(GetAddOnInfo'tekDebug' and (not IsAddOnLoaded'tekDebug')) then
    LoadAddOn'tekDebug'
end

local debug
if(tekDebug) then
    local f = tekDebug:GetFrame'163chat_backlog'
    debug = function(...)
        f:AddMessage(string.join(', ', tostringall(...)))
    end
else
    debug = function() end
end

-- shouln't have done this, but what the hell
local NUM_CHAT_WINDOWS = 10

local _NAME, _NS = ...
local addon = CreateFrame('ScrollingMessageFrame', '_'.._NAME..'Backlog', UIParent)
local session = {}
local wlimit = 30
local wtime = 60*10 --sec
addon.session = session

addon:SetScript('OnEvent', function(self, event, ...)
    self[event](self, event, ...)
end)

function addon:Initiate()
    local DB, KEY = self.DB, self.DBKEY

    local lastsession = DB[KEY]
    if(lastsession and ChatHistoryDB.backlog) then
        for id, fsession in next, lastsession do
            local frame = _G['ChatFrame'..id]
            if(frame) then
                local has_log = false
                for _, w in ipairs(fsession) do
                    if(w) then
                        local tme, msg, r,g,b, a = w:match'([^\031]+)\031([^\031]*)\031([^\031]+)\031([^\031]+)\031([^\031]+)\031([^\031]+)'
                        if(time() - tonumber(tme) < wtime) then
                            -- r = tonumber(r)
                            -- g = tonumber(g)
                            -- b = tonumber(b)
                            -- a = tonumber(a)

                            msg = msg:gsub('|c%x%x%x%x%x%x%x%x', '|cff808080')

                            frame:AddMessage('|cff68ccef|HBACKLOG|h【历史信息】|h|r'..msg, 128/255, 128/255, 128/255)
                            --debug('output: frameid:', id, 'msg:', msg)
                            has_log = true
                        end
                    end
                end
                if(has_log) then
                    frame:AddMessage('|cff68ccef|HBACKLOG|h【历史信息】|h要关闭此功能，请设置[聊天历史 -> 上次游戏的历史信息]|r')
                end
            end

            wipe(fsession)
        end
    end

    DB[KEY] = session
end

function addon:VARIABLES_LOADED()
    debug'VARIABLES_LOADED'
    local KEY = ('%s-%s'):format(GetRealmName(), (UnitName'player'))

    local DBNAME = '_'.._NAME..'BacklogDB'
    if(not _G[DBNAME]) then
        _G[DBNAME] = {}
    end

    self.DB = _G[DBNAME]
    self.DBKEY = KEY

    --self:UnregisterEvent(event)
    self.VARIABLES_LOADED = nil
    if(not self.UPDATE_CHAT_WINDOWS) then
        self:Initiate()
    end
end

function addon:UPDATE_CHAT_WINDOWS(event)
    debug'UPDATE_CHAT_WINDOWS'
    self:UnregisterEvent(event)
    self.UPDATE_CHAT_WINDOWS = nil
    if(not self.VARIABLES_LOADED) then
        self:Initiate()
    end
end

local AddMessage = function(f, msg, r,g,b, a)
    if(msg:match'(|HBACKLOG|h)') then
        debug('AddMessage wont log', msg)
        return
    end
    local id = f:GetID()
    debug('AddMessage', id, msg)

    local fsession = session[id]
    if(#fsession >= wlimit) then
        table.remove(fsession, 1)
    end

    r = r or 1; g = g or 1; b = b or 1; a = a or 1;
    table.insert(fsession, string.format('%d\031%s\031%s\031%s\031%s\031%s', time(), msg, tostring(r), tostring(g), tostring(b), tostring(a)))
end

function addon:Hook(index)
    local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(index)
    local frame = _G['ChatFrame'..index]

    debug('hook frame:', index, frame)

    session[index] = session[index] or {}
    local fsession = session[index]
    if(#fsession < wlimit) then
        for i = #fsession + 1, wlimit do
            fsession[i] = false
        end
    end

    if(shown or docked) then
        hooksecurefunc(frame, 'AddMessage', AddMessage)
    end
end

--addon:RegisterEvent'VARIABLES_LOADED'
addon:RegisterEvent'UPDATE_CHAT_WINDOWS'
hooksecurefunc(_NS, 'VARIABLES_LOADED', function()
    addon:VARIABLES_LOADED()
end)

for i = 1, NUM_CHAT_WINDOWS do
    --addon:Hook(_G['ChatFrame'..i])
    if(i ~= 2) then addon:Hook(i) end
end

local SetHyperlink = ItemRefTooltip.SetHyperlink
ItemRefTooltip.SetHyperlink = function(self, link)
    if(link ~= 'BACKLOG') then
        return SetHyperlink(self, link)
    end
end

