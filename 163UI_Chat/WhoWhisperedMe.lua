-- Author      : Nedlinin

local lastplayers = { };
local name;

WWM_totallastplayers = { };

WWM_entries = 0;
local newWhisp=true;
local toggled = "ON";

WWM_friendsWhisp = "OFF";
WWM_guildWhisp = "ON";

function WhoWhisperedMe_OnLoad(self)
    SLASH_WWM1 = "/wwm";
    SlashCmdList["WWM"] = WhoWhisperedMeCmds;

    self:RegisterEvent("ADDON_LOADED");
    self:RegisterEvent("CHAT_MSG_WHISPER");

    --DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00WhoWhisperedMe |r Loaded! Use /wwm for command list!");
    WhoWhisperedMe:Hide();
end

function WhoWhisperedMe_OnEvent(self, event, arg1, arg2 )

    if(event=="CHAT_MSG_WHISPER") then --if I get a whisper

        if WWM_totallastplayers["entries"] ~= nil then
            local total = 0;
            WWM_totallastplayers["entries"] = nil;
            for k, v in pairs(WWM_totallastplayers) do
                total = total+1;
            end
            WWM_entries = total;
        end
        name = arg2;
        --if name and name:find("%-") then return end

        if WWM_totallastplayers[name.."SentCount"] ~= nil then
            if WWM_totallastplayers[name] == nil then
                WWM_totallastplayers[name] = WWM_totallastplayers[name.."SentCount"];
            end
            WWM_totallastplayers[name.."SentCount"] = nil;
        end

        if(WWM_totallastplayers[name] == nil) then

            if(WWM_entries == nil) or WWM_entries == 0 then
                WWM_entries = 1;
            else
                WWM_entries = WWM_entries +1;
            end

            WWM_totallastplayers[name] = 1;

        else
            WWM_totallastplayers[name] = WWM_totallastplayers[name]+1;
        end

        --newWhisp=true; -- Its a 'new whisperer'
        if(WWM_friendsWhisp=="OFF") then -- if I want to not see friends whod
            for i = 1, GetNumFriends() do -- get friends names(friends 1-# of friends)
                if GetFriendInfo(i) == name then -- They are on friends list
                    newWhisp=false; -- Not a whisper I want to see
                else -- Not on friends list
                end --if GetFriendInfo
            end -- end for loop
        end --end if/else(if FriendsWhisper == OFF)

        if(WWM_guildWhisp=="OFF") then -- I dont want to see guild members whod
            for i = 1, GetNumGuildMembers(1) do
                if GetGuildRosterInfo(i) == name then
                    newWhisp=false;
                end -- end if on guild roster
            end --end for loop
        end --end if WWM_guildWhisp

        if(newWhisp==true) then
            if(toggled=="ON") then
                if(not lastplayers[name]) then
                    SendWho(name);
                    lastplayers[name] = true;
                end
            end --end if toggled
        end --new whisper
        newWhisp=true;
    end -- end if event
end


function WhoWhisperedMeCmds(command)
    command = string.lower(command);
    if(command=="on")then command="toggle"; toggled = "OFF"; end
    if(command=="off")then command="toggle"; toggled = "ON"; end
    if(command=="toggle") then
        if(toggled=="ON") then
            toggled = "OFF";
            --DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 停用");
        else
            toggled = "ON";
            --DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 启用");
        end


    elseif(command=="friends") then
        if(WWM_friendsWhisp=="ON") then
            WWM_friendsWhisp="OFF";
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 好友密语时不查询");
        else
            WWM_friendsWhisp="ON";
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 好友密语时查询");
        end


    elseif(command=="guild") then
        if(WWM_guildWhisp=="ON") then
            WWM_guildWhisp="OFF";
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 工会成员密语时不查询");
        else
            WWM_guildWhisp="ON";
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 工会成员密语时查询");
        end


    elseif(command =="stats") then
        if WWM_entries == 0 then
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 你从未被人密过（叹气）");
        else
            local names = "";
            for k, v in pairs(WWM_totallastplayers) do
                names = names.."|Hplayer:"..k.."|h|cff00d100["..k.."]|r|h ";
            end
            DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r: 最近有".. WWM_entries .."个人密过你："..names);
        end

    else
        DEFAULT_CHAT_FRAME:AddMessage("|c00ffff00密我的是谁|r command list:");
        DEFAULT_CHAT_FRAME:AddMessage("'/wwm toggle' to toggle addon ON or OFF - Currently toggled: " .. toggled);
        DEFAULT_CHAT_FRAME:AddMessage("'/wwm friends' to toggle the Whoing of Friends ON or OFF - Currently toggled: " .. WWM_friendsWhisp);
        DEFAULT_CHAT_FRAME:AddMessage("'/wwm guild' to toggle the Whoing of Guildmates ON or OFF - Currently toggled: " .. WWM_guildWhisp);
        DEFAULT_CHAT_FRAME:AddMessage("'/wwm stats' to see your whisper statistics");
    end

end