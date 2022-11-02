local addon, private = ...
_G[addon] = private

local LARGE_AURA_SIZE = 21; --MUST be the same as FrameXML/TargetFrame.lua
local SMALL_AURA_SIZE = 17;
hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local largeDebuffSize = U1GetCfgValue(addon, "largeDebuffSize")
    local smallDebuffSize = U1GetCfgValue(addon, "smallDebuffSize")
    if size == LARGE_AURA_SIZE then
        size = largeDebuffSize
    else
        size = smallDebuffSize
    end
    buff:SetWidth(size);
    buff:SetHeight(size);
    local debuffFrame = buff.Border;
    debuffFrame:SetWidth(size+2);
    debuffFrame:SetHeight(size+2);
end)

hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local largeBuffSize = U1GetCfgValue(addon, "largeBuffSize")
    local smallBuffSize = U1GetCfgValue(addon, "smallBuffSize")
    if size == LARGE_AURA_SIZE then
        size = largeBuffSize
    else
        size = smallBuffSize
    end
    buff:SetWidth(size);
    buff:SetHeight(size);
end)

function private:UpdateTargetAuraCooldown()
    if OmniCC and OmniCC.Cooldown and OmniCC.Cooldown.SetNoCooldownCount then
        for frame in TargetFrame.auraPools:GetPool("TargetDebuffFrameTemplate"):EnumerateActive() do
            OmniCC.Cooldown.SetNoCooldownCount(frame.Cooldown, not U1GetCfgValue(addon, "targetDebuffCooldownCount"))
        end
        for frame in TargetFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
            OmniCC.Cooldown.SetNoCooldownCount(frame.Cooldown, not U1GetCfgValue(addon, "targetBuffCooldownCount"))
        end
    end
end

hooksecurefunc(TargetFrame, "UpdateAuraFrames", private.UpdateTargetAuraCooldown)

--[[------------------------------------------------------------
--隐藏姓名版上的Debuff图标
local hookNamePlates = function(frame)
    if(frame and frame.UnitFrame and not frame.UnitFrame.UpdateBuffs_o) then
        frame.UnitFrame.BuffFrame.UpdateBuffs_o = frame.UnitFrame.BuffFrame.UpdateBuffs
        frame.UnitFrame.BuffFrame.UpdateBuffs = function(self, unit, filter)
            if U1GetCfgValue(name, "hideNameplateDebuff") then
                return self:UpdateBuffs_o(unit, "NONE")
            else
                return self:UpdateBuffs_o(unit, filter)
            end
        end
    end
end

function Buff163_StartHookNamePlates()
    CoreOnEvent("NAME_PLATE_CREATED", function(event, ...)
        local frame = ...;
        hookNamePlates(...)
    end)
    for i = 1, 40 do
        hookNamePlates(_G["NamePlate"..(i)])
    end
end
---------------------------------------------------------------]]