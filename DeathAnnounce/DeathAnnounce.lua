--测试: /run ChatFrame1:AddMessage("\124Hu1_deathann:10:45:33 Warbaby 挂了。(环境伤害:溺水/$$$cffff0000460$$$r)\124h\124cff7fff7f[发送]\124r\124h")

function DEATH_ANNOUNCE_GetBossHealth()
    for i=1,5 do
        local unit = "boss"..i
        if UnitHealth(unit) > 1 then
            return format("%.1f", UnitHealth(unit)*100/UnitHealthMax(unit)).."%", UnitName(unit)
        end
    end
    --[[
    for i=-1,10 do
        local unit = i==-1 and "target" or (i==0 and "focus" or "raid"..i.."target")
        if UnitLevel(unit)==-1 and (UnitHealth(unit) or 0)>1 then
            return format("%.1f", UnitHealth(unit)*100/UnitHealthMax(unit)).."%", UnitName(unit)
        end
    end
    --]]
end

-- Death announcer by wingus <reported>

local DEATH_ANNOUNCE_REVISION = 'r21';

DEATH_ANNOUNCE_OFF = true --如果为假,则/da切换只是临时的, 每次进战斗就会重新启用. 这是为了已经确定灭团时不再发送烦人的信息

local DEATH_ANNOUNCE_initial = {
    ["ENABLED"] = 0,
};

local DEATH_ANNOUNCE_loaded = false;
local DEATH_ANNOUNCE_pref = "|cff7fff7f阵亡通知:|r ";
DEATH_ANNOUNCE_OVER_KILL = {}
local DEATH_ANNOUNCE_OVK = DEATH_ANNOUNCE_OVER_KILL;

function DEATH_ANNOUNCE_OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED");
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");
end

function DEATH_ANNOUNCE_Init()
    local originSetHyperlink_Origin = ItemRefTooltip.SetHyperlink;
    ItemRefTooltip.SetHyperlink = function(self,link)
        if(strsub(link, 1, 11)=="u1_deathann") then
            HideUIPanel(self);
            return;
        end
        return originSetHyperlink_Origin(self,link);
    end
    hooksecurefunc("SetItemRef", function(link, text, button)
        if ( strsub(link, 1, 11) == "u1_deathann" ) then
            local msg = strsub(link,13)
            if msg then
                DEATH_ANNOUNCE_Print(msg:gsub("%$%$%$", "\124"), "FORCE")
            end
        end
    end);

    SLASH_DAInfo1 = "/da";
    SlashCmdList["DAInfo"] = DEATH_ANNOUNCE_Opts;

    if ( DEATH_ANNOUNCE == nil ) then
        DEATH_ANNOUNCE = DEATH_ANNOUNCE_initial;
    end

    if( DEFAULT_CHAT_FRAME ) then
        local DEATH_ANNOUNCE_status = "|c000fff00"..DEATH_ANNOUNCE_LOCALE_ENABLE.."|r.";
        if not DEATH_ANNOUNCE_IsEnabled() then
            DEATH_ANNOUNCE_status = "|cfff00000"..DEATH_ANNOUNCE_LOCALE_DISABLE.."|r.";
        end

        if not DEATH_ANNOUNCE_OFF then
            DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref .. "|c000fff00目前设置为'自动开启发送', 如需关闭请使用/da off命令");
        else
            DEATH_ANNOUNCE_Opts("dis")
        end

        --DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref ..DEATH_ANNOUNCE_REVISION .. " 加載成功, /da 切換通告模式.");
        --DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref .. DEATH_ANNOUNCE_status);
    end
end

--如果运行 /da off 则
function DEATH_ANNOUNCE_Opts(msg)
    local show = true
    if not msg or msg =="" then
        if DEATH_ANNOUNCE_IsEnabled() then msg = "dis" else msg = "ena" end
    elseif strlower(msg) == "off" then
        msg = "dis"
        show = false
        DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |cfff00000".."不自动开启发送".."|r.");
        DEATH_ANNOUNCE_OFF = true
    elseif strlower(msg) == "on" then
        msg = "ena"
        show = false
        DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |c000fff00".."自动开启发送".."|r.");
        DEATH_ANNOUNCE_OFF = false
    end

    if ( string.find(msg,"ena") ) then
        if DEATH_ANNOUNCE_IsEnabled() then return end
        DEATH_ANNOUNCE["ENABLED"] = 1 
        if show then DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |c000fff00"..DEATH_ANNOUNCE_LOCALE_ENABLE.."|r."); end
    elseif ( string.find(msg,"dis") ) then
        if not DEATH_ANNOUNCE_IsEnabled() then return end
        DEATH_ANNOUNCE["ENABLED"] = 0 
        if show then DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |cfff00000"..DEATH_ANNOUNCE_LOCALE_DISABLE.."|r."); end
    elseif ( string.find(msg,"cur") ) then
        if DEATH_ANNOUNCE_OFF then
            DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |cfff00000".."不自动开启发送".."|r.");
        else
            DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |cfff00000".."自动开启发送".."|r.");
        end
        if DEATH_ANNOUNCE_IsEnabled() then
            DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |c000fff00"..DEATH_ANNOUNCE_LOCALE_ENABLE.."|r.");
        else
            DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.." |cfff00000"..DEATH_ANNOUNCE_LOCALE_DISABLE.."|r.");
        end
    else
        DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.."|cff7fff7f 命令:|r /da - 切换发送通告/不发送通告.|r")
        DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.."|cff7fff7f 命令:|r /da on, /da off - 每次进战斗时是否自动开启发送.|r")
        DEATH_ANNOUNCE_Print(DEATH_ANNOUNCE_pref.."|cff7fff7f 命令:|r /da cur - 显示当前状态")
    end

end

function DEATH_ANNOUNCE_OnEvent(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        if not DEATH_ANNOUNCE_OFF then
            DEATH_ANNOUNCE_Opts("ena")
        end

    elseif event == "PLAYER_REGEN_ENABLED" then
        table.wipe(DEATH_ANNOUNCE_OVK)

    elseif event == "VARIABLES_LOADED" then
        if (DEATH_ANNOUNCE_loaded == false) then
            DEATH_ANNOUNCE_loaded = true;
            DEATH_ANNOUNCE_Init();
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        DEATH_ANNOUNCE_CLEU(CombatLogGetCurrentEventInfo())
    end
end

-- http://www.wowwiki.com/UnitFlag
local function IsRaidMemberFlag(flag)
    local last3Byte = bit.band(flag or 0, 0xFFF)
    return last3Byte==0x511 or last3Byte==0x512 or last3Byte==0x514
end

local function saveInfoBeforeDeath(destName, sourceName, skill, amount, overkill, resisted, blocked, absorbed)
    overkill = overkill or -1
    -- 击杀log之后又出现非击杀log，忽略
    if overkill <= 0 and DEATH_ANNOUNCE_OVK[destName] and DEATH_ANNOUNCE_OVK[destName]:sub(1,1)=="-" then return end
    resisted = resisted or 0
    blocked = blocked or 0
    absorbed = absorbed or 0
    --(金加洛斯:[恶魔炸弹]/2411414)(含123456吸收,1241515过量)
    local avoid = resisted + blocked + absorbed
    local more
    if avoid > 0 then
        amount = amount + avoid
        more = "(含吸收|cffffff00" .. AbbreviateNumbers163(avoid) .. "|r"
    end
    if overkill > 0 then
        amount = amount --+ overkill 好像不应该算
        more = (more and more .. "," or "(含") .. "过量|cffff0000" .. AbbreviateNumbers163(overkill) .. "|r"
    end
    more = more and more .. ")" or ""
    DEATH_ANNOUNCE_OVK[destName] = (overkill > 0 and "-" or " ").."("..(sourceName and sourceName..":" or "")..(skill and skill.."/" or "").."|cffff0000"..(type(amount)=="number" and AbbreviateNumbers163(amount) or amount).."|r)"..more;
end

local playerGUID = UnitGUID("player")

--http://www.wowwiki.com/CLEU
function DEATH_ANNOUNCE_CLEU(...)
    local isInstance, instanceType = IsInInstance()
    if isInstance and ( instanceType == "pvp" or instanceType == "arena" ) then return end
    
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, param1, param2, param3, param4, param5, param6, param7, param8, param9 = ...

    if ( subevent == "SPELL_INTERRUPT" ) then
        if not IsRaidMemberFlag(sourceFlags) then return end
        if sourceGUID == playerGUID and U1GetCfgValue and U1GetCfgValue("deathannounce/yell") then
            SendChatMessage(string.format("我已打断%s的%s", destName, GetSpellLink(param4)), "YELL")
        else
            if RaidAlerter_SET and RaidAlerter_SET.Break_Magic then return end
            --太刷屏了，加了个开关
            if sourceGUID == playerGUID or (U1GetCfgValue and U1GetCfgValue("deathannounce/othersir")) then
                DEATH_ANNOUNCE_Print(string.format("%s 打断了%s的%s", sourceName, destName, GetSpellLink(param4)), false, true)
            end
        end
        return
    elseif subevent == "SPELL_CAST_SUCCESS" then
        if not IsRaidMemberFlag(sourceFlags) then return end
        local spellId = param1
        DEATH_ANNOUNCE_IMPORTANT_SPELLS = DEATH_ANNOUNCE_IMPORTANT_SPELLS or {
            [633] = true, --圣疗
            [47788] = true, --守护之魂
            [29166] = true, --激活
            [116849] = true, --作茧缚命2
            [6940] = true, --牺牲祝福
        }
        if DEATH_ANNOUNCE_IMPORTANT_SPELLS[spellId] then
            if sourceGUID == playerGUID and U1GetCfgValue and U1GetCfgValue("deathannounce/yell_spell") then
                if destGUID ~= playerGUID then
                    SendChatMessage(string.format("%s -> %s", GetSpellLink(spellId), destName), "YELL")
                end
            else
                if RaidAlerter_SET and RaidAlerter_SET.Paladin_Intervention then return end
                DEATH_ANNOUNCE_Print(string.format("%s 的 %s -> %s", sourceName, GetSpellLink(spellId), destName), false, true)
            end
        end
        return
    end


    -- Damage and death only about RAID, PARTY, SELF. 
    if not IsRaidMemberFlag(destFlags) then return end

    if ( subevent == "UNIT_DIED" ) then
        if not UnitIsFeignDeath(destName) then
            local h,n = DEATH_ANNOUNCE_GetBossHealth()
            DEATH_ANNOUNCE_OVK[destName] = (DEATH_ANNOUNCE_OVK[destName] or " "):sub(2)..(h and "@"..h or "")
            DEATH_ANNOUNCE_Print(destName ..DEATH_ANNOUNCE_LOCALE_DIE .. DEATH_ANNOUNCE_OVK[destName], "DEFAULT", true, destName);
            DEATH_ANNOUNCE_OVK[destName] = nil;
        end
    end

    if ( subevent == "SPELL_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "RANGE_DAMAGE" or subevent == "DAMAGE_SPLIT" or subevent == "DAMAGE_SHIELD" ) then
        local spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed = param1, param2, param3, param4, param5, param6, param7, param8, param9
--        for i=1, 4 do
--            local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(destName, i, "HARMFUL")
--            if not spellID then break end
--            print( GetSpellLink(spellID)..(count>1 and "x"..count or "") )
--        end
        saveInfoBeforeDeath(destName, sourceName, GetSpellLink(spellId), amount, overkill, resisted, blocked, absorbed);

    elseif ( subevent == "SWING_DAMAGE" ) then
        local amount, overkill, school, resisted, blocked, absorbed = param1, param2, param3, param4, param5, param6
        saveInfoBeforeDeath(destName, sourceName, "近战", amount, overkill, resisted, blocked, absorbed);

    elseif ( subevent == "ENVIRONMENTAL_DAMAGE"  ) then
        if ( param2 > 0 ) then
            saveInfoBeforeDeath(destName, sourceName, _G["DEATH_ANNOUNCE_LOCALE_"..param1] or param1, param2);
        end

    elseif ( subevent == "SPELL_INSTAKILL" ) then
        saveInfoBeforeDeath(destName, sourceName, GetSpellLink(param1), "立即");

    elseif subevent == "PARTY_KILL" then
        print("DA_PARTY_KILL", ...)

    elseif subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH" then
        --6/13 23:41:03.835  SPELL_AURA_APPLIED,0xF1310A7C0000007E,"巨型蜗牛",0xa48,0x0,0x0A00000002E2E999,"追风逐影丶-安苏",0x512,0x0,134415,"被吞噬",0x1,DEBUFF
        --6/13 23:41:03.835  SPELL_AURA_REFRESH,0xF1310A7C0000007E,"巨型蜗牛",0xa48,0x0,0x0A00000002E2E999,"追风逐影丶-安苏",0x512,0x0,134415,"被吞噬",0x1,DEBUFF
        --6/13 23:41:04.622  UNIT_DIED,0x0000000000000000,nil,0x80000000,0x80000000,0x0A00000002E2E999,"追风逐影丶-安苏",0x512,0x0,0
    end
end

--80354
--启用则发送到RAID频道,否则显示在自己屏幕
function DEATH_ANNOUNCE_IsEnabled()
    if ( DEATH_ANNOUNCE["ENABLED"] == 0 ) then return false; else return true; end
end

local advised
function DEATH_ANNOUNCE_Print(msg, announce, link, deadName)
    local printMsg = link and msg.." |Hu1_deathann:"..date("%X").." "..msg:gsub("\124", "$$$").."|h|cff7fff7f[发送]|r|h" or msg
    if not announce then
        DEFAULT_CHAT_FRAME:AddMessage(printMsg, .6, .6, .6);
    else
        --死亡比例超过40%就不再自动通报
        if announce~="FORCE" and IsInRaid() then
            local members = GetNumGroupMembers()
            local dead = 0
            for i=1, members do
                if UnitIsDeadOrGhost("raid"..i) then dead = dead + 1 end
            end
            if dead / members > 0.5 then return end
            if dead / members > 0.3 then
                DEFAULT_CHAT_FRAME:AddMessage(printMsg, .6, .6, .6);
                return
            end
        end

        if (announce=="FORCE" or DEATH_ANNOUNCE_IsEnabled()) and IsInGroup() then
            local channel = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or "PARTY"
            msg = msg:gsub("\124cffff0000(.-)\124r", "%1");
            SendChatMessage(advised and msg or ("【爱不易】"..msg), channel);
            advised = true
            if(ChatFrame2) then
                ChatFrame2:AddMessage(printMsg, .6, .6, .6);
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage(printMsg, .6, .6, .6);
        end
    end

    --- 队员死亡过多的情况已经return了
    if announce and announce~="FORCE" and IsInGroup() and deadName then
        local sound = U1GetCfgValue("DeathAnnounce", "sound")
        if sound then
            if GetTime() - (DEATH_ANNOUNCE_LAST_SOUND_TIME or 0) > 0.5 then
                if sound == "death_someone" then
                    sound = select(2, UnitClass(deadName)) or "someone"
                    sound = "death_"..string.lower(sound)
                end
                PlaySoundFile("Interface\\AddOns\\DeathAnnounce\\sound\\"..sound..".ogg")
                DEATH_ANNOUNCE_LAST_SOUND_TIME = GetTime()
            end
        end
    end
end