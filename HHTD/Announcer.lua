--[=[
H.H.T.D. World of Warcraft Add-on
Copyright (c) 2009-2018 by John Wellesz (hhtd@2072productions.com)
All rights reserved

Version 2.4.9.10

In World of Warcraft healers have to die. This is a cruel truth that you're
taught very early in the game. This add-on helps you influence this unfortunate
destiny in a way or another depending on the healer's side...

More information: https://www.wowace.com/projects/h-h-t-d

-----
    Announcer.lua
-----

This component plays alert sounds and display messages.


--]=]

local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;


local ADDON_NAME, T = ...;
local HHTD = T.HHTD;
local L = HHTD.Localized_Text;

-- Create module
HHTD.Announcer = HHTD:NewModule("Announcer", "AceConsole-3.0");
local Announcer = HHTD.Announcer;

-- Up Values
local UnitGUID      = _G.UnitGUID;
local UnitName      = _G.UnitName;
local UnitClass     = _G.UnitClass;
local UnitSex       = _G.UnitSex;
local PlaySoundFile = _G.PlaySoundFile;
local select        = _G.select;

function Announcer:OnInitialize() -- {{{

    -- if core failed to load...
    if T._DiagStatus == 2 then
        return;
    end

    self:Debug(INFO, "OnInitialize called!");
    self.db = HHTD.db:RegisterNamespace('Announcer', {
        global = {
            ChatMessages = false,
            Sounds = true,

            PostToChat = false,
            PostToChatThrottle = 2 * 60,
            PostHealersNumber = 4,
            PostHumansOnly = true,
            ProtectMessage = false,
            KillMessage = false,
            AnnounceChannel = 'AUTO',
            HUDWarning = true,
            ChatWarning = false,
        },
    });



end -- }}}

function Announcer:GetOptions () -- {{{


    local validatePostChatMessage = function (info, v)

        local counterpartMessage = info[#info] == 'ProtectMessage' and 'KillMessage' or 'ProtectMessage';
        Announcer:Debug(INFO, 'counterpartMessage:', counterpartMessage);

        if not v:find('%[HEALERS%]') then
            return self:Error(L["OPT_POST_ANNOUNCE_MISSING_KEYWORD"]);
        end

        if v:len() < ("%[HEALERS%]"):len() + 10 then
            return self:Error(L["OPT_POST_ANNOUNCE_MESSAGE_TOO_SHORT"]);
        end

        if v == Announcer.db.global[counterpartMessage] then
            return self:Error(L["OPT_POST_ANNOUNCE_MESSAGES_EQUAL"]);
        end

        return 0, v;

    end

    return {
        [Announcer:GetName()] = {
            name = L[Announcer:GetName()],
            type = 'group',
            get = function (info) return Announcer.db.global[info[#info]]; end,
            set = function (info, value) HHTD:SetHandler(self, info, value) end,
            args = {
                ChatMessages = {
                    type = 'toggle',
                    name = L["OPT_ANNOUNCE"],
                    desc = L["OPT_ANNOUNCE_DESC"],
                    order = 1,
                },
                Sounds = {
                    type = 'toggle',
                    name = L["OPT_SOUNDS"],
                    desc = L["OPT_SOUNDS_DESC"],
                    order = 10,
                },
                -- enable
                PostToChat = {
                    type = 'toggle',
                    name = L["OPT_POST_ANNOUNCE_ENABLE"],
                    desc = L["OPT_POST_ANNOUNCE_ENABLE_DESC"],
                    set = function (info, v)
                        Announcer.db.global.PostToChat = v;
                    end,
                    order = 30,
                },
                Header100 = {
                    type = 'header',
                    name = L["OPT_A_HEALER_PROTECTION"],
                    order = 35,
                },
                HealerUnderAttackAlerts = {
                    type = 'toggle',
                    name = L["OPT_HEALER_UNDER_ATTACK_ALERTS"],
                    desc = function() HHTD:UpdateHealThresholds(); return (L["OPT_HEALER_UNDER_ATTACK_ALERTS_DESC"]):format(HHTD.ProtectDamageThreshold) end,
                    order = 35.1,
                    set = function (info, value)
                        HHTD:SetHandler(HHTD, info, value);
                    end,
                    get = function () return HHTD.db.global.HealerUnderAttackAlerts; end,
                },
                HUDWarning = {
                    type = 'toggle',
                    name = L["OPT_A_HUD_WARNING"],
                    desc = L["OPT_A_HUD_WARNING_DESC"],
                    disabled = function() return not HHTD.db.global.HealerUnderAttackAlerts; end,
                    order = 35.2,
                },
                ChatWarning = {
                    type = 'toggle',
                    name = L["OPT_A_CHAT_WARNING"],
                    desc = L["OPT_A_CHAT_WARNING_DESC"],
                    disabled = function() return not HHTD.db.global.HealerUnderAttackAlerts; end,
                    order = 35.3,
                },
                PostToChatOptions = {
                    type = 'group',
                    inline = true,
                    name = L['OPT_POST_ANNOUNCE_SETTINGS'],
                    hidden = function() return Announcer.db.global.PostToChat == false end,
                    order = 40,
                    args = {
                        Description = {
                            type = 'description',
                            order = 0,
                            name = L["OPT_POST_ANNOUNCE_DESCRIPTION"],
                        },
                        AnnounceChannel = {
                            type = 'select',
                            width = 'double',
                            name = L['OPT_POST_ANNOUNCE_CHANNEL'],
                            desc = L['OPT_POST_ANNOUNCE_CHANNEL_DESC'],
                            values = { ['AUTO'] = L['AUTO_RAID_PARTY_INSTANCE'], ['SAY'] = L['SAY'], ['YELL'] = L['YELL']},
                            order = 30,
                        },
                        -- throttle
                        PostToChatThrottle = {
                            type = 'range',
                            min = 60,
                            max = 10 * 60,
                            step = 1,
                            bigStep = 5,
                            name = L["OPT_POST_ANNOUNCE_THROTTLE"],
                            desc = L["OPT_POST_ANNOUNCE_THROTTLE_DESC"],
                            order = 40,
                        },
                        PostHealersNumber = {
                            type = 'range',
                            min = 2,
                            max = 10,
                            step = 1,
                            name = L["OPT_POST_ANNOUNCE_NUMBER"],
                            desc = L["OPT_POST_ANNOUNCE_NUMBER_DESC"],
                            order = 42,
                        },
                        PostHumansOnly = {
                            type = 'toggle',
                            order = 43,
                            name = L["OPT_POST_ANNOUNCE_HUMAMNS_ONLY"],
                            desc = L["OPT_POST_ANNOUNCE_HUMAMNS_ONLY_DESC"],

                        },
                        ValidityCheck = {
                            type = 'description',
                            order = 45,
                            name = HHTD:ColorText(L["OPT_POST_ANNOUNCE_POST_MESSAGE_ISSUE"],'FFFF4040'),
                            hidden = function ()
                                if Announcer.db.global.PostToChat == false
                                    or (Announcer.db.global.ProtectMessage and Announcer.db.global.KillMessage) then

                                    return true;
                                else
                                    return false;
                                end
                            end
                        },
                        ProtectMessage = {
                            type = 'input',
                            width = 'full',
                            name = L["OPT_POST_ANNOUNCE_PROTECT_MESSAGE"],
                            desc = L["OPT_POST_ANNOUNCE_PROTECT_MESSAGE_DESC"],
                            get = function (info)
                                return Announcer.db.global[info[#info]] or '[HEALERS]';
                            end,
                            validate = validatePostChatMessage,
                            order = 50,
                        },
                        KillMessage = {
                            type = 'input',
                            width = 'full',
                            name = L["OPT_POST_ANNOUNCE_KILL_MESSAGE"],
                            desc = L["OPT_POST_ANNOUNCE_KILL_MESSAGE_DESC"],
                            get = function (info)
                                return Announcer.db.global[info[#info]] or '[HEALERS]';
                            end,
                            validate = validatePostChatMessage,
                            order = 60,
                        },
                    },
                },
                -- auto raid mark friendly healers
            },
        },
    };
end -- }}}


function Announcer:OnEnable() -- {{{
    self:Debug(INFO, "OnEnable");

    -- Subscribe to HHTD callbacks
    self:RegisterMessage("HHTD_HEALER_MOUSE_OVER");
    self:RegisterMessage("HHTD_TARGET_LOCKED");
    self:RegisterMessage("HHTD_HEALER_UNDER_ATTACK");

    self:RegisterChatCommand("hhtdp", function() self:ChatPlacard() end);

end -- }}}

function Announcer:OnDisable() -- {{{
    self:Debug(INFO2, "OnDisable");
    self:UnregisterChatCommand("hhtdp");
end -- }}}


-- Internal CallBacks (HHTD_HEALER_MOUSE_OVER - HHTD_TARGET_LOCKED - HHTD_HEALER_UNDER_ATTACK) {{{
local previousUnitGuid;
function Announcer:HHTD_HEALER_MOUSE_OVER(selfevent, isFriend, healerProfile)

    if isFriend then
        return;
    end

    if previousUnitGuid ~= healerProfile.guid then
        self:Announce(
            "|cFFFF0000",
            (L["IS_A_HEALER"]):format(
                HHTD:ColorText(
                healerProfile.name,
                HHTD:GetClassHexColor(  select(2, UnitClass("mouseover")) )
                ),
            "|r"
            )
        );
        previousUnitGuid = healerProfile.guid;
    end

    self:PlaySoundFile(567458);
    -- self:Debug(INFO, "AlarmClockWarning3.ogg played");
end

function Announcer:HHTD_TARGET_LOCKED (selfevent, isFriend, healerProfile)

    if isFriend then
        return;
    end

    self:PlaySoundFile(567482);
    --self:Debug(INFO, "AuctionWindowOpen.ogg played");

    local sex = UnitSex("target");

    local what = (sex == 1 and L["YOU_GOT_IT"] or sex == 2 and L["YOU_GOT_HIM"] or L["YOU_GOT_HER"]);

    local localizedUnitClass, unitClass = UnitClass("target");

    local subjectColor = HHTD:GetClassHexColor(unitClass);

    self:Announce(what:format("|c" .. subjectColor));

end

function Announcer:HHTD_HEALER_UNDER_ATTACK (selfevent, sourceName, sourceGUID, destName, destGUID, isCurrentPlayer)

    local config = self.db.global;

        -- TODO: add an option to change the frequency of the alerts
        -- TODO: add an option to display alert only if the source is human
    if isCurrentPlayer then
        -- TODO: add a new feature to display a set of custom messages when we are under attack.
        --       We need to ignore AOEs.
        return;
    end

    local message = HHTD:ColorText("HHTD: ", '88555555') .. (L["HEALER_UNDER_ATTACK"]):format(HHTD:ColorText(HHTD:MakePlayerName(destName), 'FF00DD00'), HHTD:ColorText(HHTD:MakePlayerName(sourceName), 'FFDD0000'));

    if config.HUDWarning then
        RaidNotice_AddMessage( RaidWarningFrame, message, ChatTypeInfo["RAID_WARNING"] );
    end

    if config.ChatWarning then
        self:Print(message);
    end
end

-- }}}


function Announcer:Announce(...) -- {{{
    if self.db.global.ChatMessages then
        HHTD:Print(...);
    end
end -- }}}

do

    local table = _G.table;

    local function isRaidWarningAuthorized ()
        return IsInRaid() and (select(2, GetRaidRosterInfo(UnitInRaid("player") or 1))) > 0
    end

    local function GetDistributionChanel()
        local channel = Announcer.db.global.AnnounceChannel;

        if channel ~= 'AUTO' then
            return channel;
        end

        if IsInRaid() then
            if isRaidWarningAuthorized() then
                return "RAID_WARNING";
            elseif GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0 then
                return "INSTANCE_CHAT";
            else
                return "RAID";
            end
        elseif GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
            return "PARTY";
        elseif GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0 then
            -- if we are in a battle ground or a LFG/R instance
            return "INSTANCE_CHAT";
        end

        return "SAY";
    end

    local function Post(text)
        local channelType = GetDistributionChanel();

        --  SendChatMessage("msg" [,"type" [,"lang" [,"channel"] ] ]).
        SendChatMessage("HHTD: " .. text, channelType, nil, channelType == 'WHISPER' and (UnitName('player')) or nil);
    end

    local LastAnnounce = 0;
    local FriendsFoes = {
        [true] = {},
        [false] = {}
    };
    function Announcer:ChatPlacard()
        -- first check config
        if not (self.db.global.PostToChat and self.db.global.ProtectMessage and self.db.global.KillMessage) then
            self:Error(L["CHAT_POST_ANNOUNCE_FEATURE_NOT_CONFIGURED"]);
            return false;
        end
        local config = self.db.global;

        -- then check throttle
        if GetTime() - LastAnnounce < config.PostToChatThrottle then
            self:Error(L["CHAT_POST_ANNOUNCE_TOO_SOON_WAIT"]);
            return false;
        end

        for i, isFriend in ipairs({true, false}) do

            table.wipe(FriendsFoes[isFriend]);

            for guid, healer in HHTD:pairs_ordered(HHTD.Registry_by_GUID[isFriend], true, 'healDone') do

                if #FriendsFoes[isFriend] == config.PostHealersNumber then
                    break;
                end

                if not (config.PostHumansOnly and not healer.isHuman) then
                    table.insert(FriendsFoes[isFriend], ("(%d) %s"):format(#FriendsFoes[isFriend] + 1, healer.name));
                end
            end

            --self:Debug(INFO, "Found", #FriendsFoes[isFriend], isFriend and "friends" or "foes");

        end


        -- send to chat
        if #FriendsFoes[true] > 0 then
            local FriendsText = ( config.ProtectMessage:gsub('%[HEALERS%]', table.concat(FriendsFoes[true],  ' - ')) );
            self:Debug(INFO, "HHTD:", FriendsText);
            Post(FriendsText);
        end
        if #FriendsFoes[false] > 0 then
            local FoesText    = ( config.KillMessage:gsub('%[HEALERS%]', table.concat(FriendsFoes[false], ' - ')) );
            self:Debug(INFO, "HHTD:", FoesText);
            Post(FoesText);
        end

        if #FriendsFoes[true] > 0 or #FriendsFoes[false] > 0 then
            -- log the time to prevent spam
            LastAnnounce = GetTime();
        else
            self:Error(L["CHAT_POST_NO_HEALERS"]);
            --[==[@debug@
            Post(L["CHAT_POST_NO_HEALERS"]);
            --@end-debug@]==]
        end

        return true;
    end
end

function Announcer:PlaySoundFile(...) -- {{{
    if self.db.global.Sounds then
        PlaySoundFile(...);
    end
end -- }}}
