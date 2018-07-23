local SwingBar

local SwingBar_Enabled = false;
local lastSpeedMain, lastSpeedOff = UnitAttackSpeed("player");

----------------------------------------------------------------------------------------------------
-- 闪烁
----------------------------------------------------------------------------------------------------
function SwingBar_Flash()
    if SwingBar:IsVisible() then
        SwingBar.main:SetValue(select(2, SwingBar.main:GetMinMaxValues()));
        SwingBar.main:SetStatusBarColor(0.0, 1.0, 0.0);
        --SwingBar.main.spark:Hide();
        SwingBar.main.casting = nil;
        SwingBar.flash:SetAlpha(0.0);
        SwingBar.flash:Show();
        SwingBar.flashing = 1;
        SwingBar.fadeOut = 1;
    end
end
---------------------------------------------------------------------------------------------
-- 攻击
----------------------------------------------------------------------------------------------
local function SwingBar_OnAttack(parry, offhand, range)
    local min, max = GetTime();
    local curTime, mainS, offS = min, UnitAttackSpeed("player");
    if range then
        offS = nil
        mainS = UnitRangedDamage("player")
    end
    SwingBar.left:SetText(range and RANGED or MELEE)
    CoreUIShowOrHide(SwingBar.off, offS)
    local bar = offhand and SwingBar.off or SwingBar.main
    if bar:GetHeight()<0.5 then bar:Hide() elseif not bar:IsVisible() then bar:Show() end

    if (parry and bar.start and bar.stop) then
        if (not bar:IsVisible()) then return; end

        min = bar.start;
        max = bar.stop;
        if ((curTime - min) < 0.6*mainS) then
            max = max - 0.4*mainS;
        end
    else
        max = min + (offhand and offS or mainS) ;
    end

    bar:SetStatusBarColor(bar.r, bar.g, bar.b);
    bar.spark:Show();
    bar:SetMinMaxValues(min, max);
    bar:SetValue(curTime);
    bar:SetAlpha(1.0);
    bar.start = min;
    bar.stop = max;
    bar.casting = 1;
    if not SwingBar:IsVisible() then SwingBar:Show() SwingBar:SetAlpha(1) end
    bar:Show();
end

local function SwingBar_OnRange()
    SwingBar_OnAttack(nil, nil, 1)
end

---------------------------------------------------------------------------------------------
-- OnEvent
---------------------------------------------------------------------------------------------
---暂时无用
local function isAttackSpell(spellId)
    if spellId == 19434 then return true, true end --瞄准射击
    return false;
end

local function checkBars(bar)
    if bar.casting then
        local minv, maxv = bar:GetMinMaxValues();
        local status = GetTime();
        if status > maxv then
            status = maxv;
        end
        bar:SetValue(status);
        if bar == SwingBar.main then
            SwingBar.right:SetText(format("%0.1f", maxv -status));
        end
        bar.spark:SetPoint("CENTER", bar, "LEFT", max(0, (status- minv)/(maxv-minv))*bar:GetWidth(), 0)
        SwingBar.flash:Hide();
    end
end

local function OnUpdate(self, elapsed)
    if (not SwingBar_Enabled) then
        return;
    end

    checkBars(self.main)
    checkBars(self.off)
    if self.flashing then
        local alpha = self.flash:GetAlpha() + CASTING_BAR_FLASH_STEP;
        if alpha < 1 then
            self.flash:SetAlpha(alpha);
        else
            self.flash:SetAlpha(1.0);
            self.flashing = nil;
        end
    elseif self.fadeOut then
        local alpha =self:GetAlpha() - CASTING_BAR_ALPHA_STEP;
        if alpha > 0 then
            self:SetAlpha(alpha);
        else
            self.fadeOut = nil;
            self:Hide();
        end
    end
end

function SwingBar_Toggle(switch)
    if (switch) then
        SwingBar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        SwingBar:RegisterEvent("PLAYER_LEAVE_COMBAT");
        SwingBar:RegisterEvent("STOP_AUTOREPEAT_SPELL");
        SwingBar:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
        SwingBar:RegisterEvent("UNIT_ATTACK_SPEED");
        SwingBar_Enabled = true;
    else
        SwingBar:UnregisterAllEvents();
        SwingBar_Flash();

        SwingBar_Enabled = false;
    end
end

local function barOnShow(self)
    self:SetFrameLevel(self:GetParent():GetFrameLevel())
    self.spark:SetSize(self:GetHeight()*2, self:GetHeight()*3)
    checkBars(self);
end

local function createBar(parent, key, r, g, b)
    local bar = WW(parent):StatusBar():Key(key)
    :Texture(nil, "OVERLAY", [[Interface\CastingBar\UI-CastingBar-Spark]]):Key("spark"):SetBlendMode("ADD"):Size(32):up()
    :SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    :SetScript("OnShow", barOnShow)
    :SetAlpha(1):SetMinMaxValues(0, 1):SetValue(1)
    bar.r, bar.g, bar.b = r, g, b;
    bar:SetStatusBarColor(r, g, b);
    bar:GetStatusBarTexture():SetDrawLayer("BORDER", key=="main" and -8 or -7)
    local LSM = LibStub and LibStub('LibSharedMedia-3.0', true)
    if LSM then
        bar:SetStatusBarTexture(LSM:Fetch("statusbar", "Minimalist"))
    end
    return bar;
end

local function CreateUI()
    local f = WW:Frame("SwingBar", UIParent):Size(180,18):BOTTOM("CastingBarFrame","TOP",0,"20"):Backdrop([[Interface\GLUES\COMMON\Glue-Tooltip-Background]], [[Interface\GLUES\COMMON\TextPanel-Border]], 12, 2)

    createBar(f, "main", 1, .7, 0):TL(3,-1):BR(-2,3):un()
    createBar(f, "off", 0, .7, 0):BL(3, 3):BR(-2,3):SetHeight(8):un()

    local font = "GameFontHighlight" --"ChatFontSmall"
    f:CreateFontString(nil, "ARTWORK", font)
    :Key("right"):SetText("99.9"):Size(32, 0):RIGHT(-5, 1):un()

    f:CreateFontString(nil, "ARTWORK", font)
    :Key("left"):SetText(MELEE):Size(100, 0):CENTER(0, 1):un()

    f:Texture(nil, "OVERLAY", [[Interface\CastingBar\UI-CastingBar-Flash-Small]])
    :Key("flash"):SetBlendMode("ADD"):TL(-30,25):BR(30,-25):un();

    f:Hide()
    CoreUIMakeMovable(f)
    SwingBar = f:un();
end

CreateUI()
createBar = nil
CreateUI = nil

function SwingBar:COMBAT_LOG_EVENT_UNFILTERED(event)
    local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcRF, dstGUID, dstName, dstFlags, dstRF, extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10 = CombatLogGetCurrentEventInfo()
    if (event == "SWING_DAMAGE") then
        local isOffHand = extraArg10
        --if srcGUID==UnitGUID("player") then print("SWING_DAMAGE", isOffHand) end
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            SwingBar_OnAttack(nil, isOffHand);
        end
    elseif (event == "SWING_MISSED") then
        --if srcGUID==UnitGUID("player") then print("SWING_MISSED", ...) end
        local missType, isOffHand = extraArg1, extraArg2
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            SwingBar_OnAttack(nil, isOffHand);
        elseif (CombatLog_Object_IsA(dstFlags,  COMBATLOG_FILTER_ME) and missType == "PARRY") then
            SwingBar_OnAttack(true);
        end
    --[[
    --用SPELL_DAMAGE和RANGEDAMAGE有延迟，改用SPELL_CAST_SUCCEEDED
    elseif (event == "SPELL_DAMAGE") then
        local spellID, spell = ...
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            local res, range = isAttackSpell(spellID)
            if res then if range then SwingBar_OnRange() else SwingBar_OnAttack() end end
        end
    elseif (event == "SPELL_MISSED") then
        local spellID, spell = ...
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            local res, range = isAttackSpell(spellID)
            if res then if range then SwingBar_OnRange() else SwingBar_OnAttack() end end
        end
    elseif (event == "RANGE_DAMAGE") then
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            SwingBar_OnRange();
        end
    elseif (event == "RANGE_MISSED") then
        if (CombatLog_Object_IsA(srcFlags,  COMBATLOG_FILTER_ME)) then
            SwingBar_OnRange();
        end
    --]]
    end
end

function SwingBar:PLAYER_LEAVE_COMBAT()
    SwingBar_Flash();
end

function SwingBar:STOP_AUTOREPEAT_SPELL()
    SwingBar_Flash();
end

function SwingBar:UNIT_SPELLCAST_SUCCEEDED(event, unitID, spell, rank, unknown, spellID)
    if (spellID == 75 or spellID == 19434) and unitID == "player" then
        SwingBar_OnRange()
    end
end

function SwingBar:UNIT_ATTACK_SPEED()
    local mainSpeed, offSpeed = UnitAttackSpeed("player");
    if (mainSpeed ~= lastSpeedMain and SwingBar.main.start) then
        lastSpeedMain = mainSpeed;
        SwingBar.main.stop = SwingBar.main.start + mainSpeed;
        SwingBar.main:SetMinMaxValues(SwingBar.main.start, SwingBar.main.stop);
        SwingBar.main:SetValue(GetTime());
    end
    if (offSpeed ~= lastSpeedOff and SwingBar.off.start) then
        lastSpeedOff = offSpeed;
        if not offSpeed then
            SwingBar.off:Hide();
            SwingBar.off.casting = nil;
        else
            SwingBar.off:Show();
            SwingBar.off.stop = SwingBar.off.start + offSpeed;
            SwingBar.off:SetMinMaxValues(SwingBar.off.start, SwingBar.off.stop);
            SwingBar.off:SetValue(GetTime());
        end
    end
end
CoreDispatchEvent(SwingBar);
SwingBar:SetScript("OnUpdate", OnUpdate)

--CoreOnEvent("PLAYER_LOGIN", function() SwingBar_Toggle(true); SwingBar:Show(); return 1; end)