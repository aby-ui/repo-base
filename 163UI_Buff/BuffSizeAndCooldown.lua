local name, private = ...
_G[name] = private

hooksecurefunc("TargetFrame_UpdateAuraPositions", function(self, auraName, numAuras, numOppositeAuras, largeAuraList, func)
    if func == TargetFrame_UpdateDebuffAnchor then
        local largeDebuffSize = U1GetCfgValue(name, "largeDebuffSize")
        local smallDebuffSize = U1GetCfgValue(name, "smallDebuffSize")
        for i = 1, numAuras do
            local size = largeAuraList[i] and largeDebuffSize or smallDebuffSize;
            local buff = _G[auraName..i];
            buff:SetWidth(size);
            buff:SetHeight(size);
            local debuffFrame =_G[auraName..i.."Border"];
            debuffFrame:SetWidth(size+2);
            debuffFrame:SetHeight(size+2);
        end
    elseif func == TargetFrame_UpdateBuffAnchor then
        local largetBuffSize = U1GetCfgValue(name, "largeBuffSize")
        local smallBuffSize = U1GetCfgValue(name, "smallBuffSize")
        for i = 1, numAuras do
            local size = largeAuraList[i] and largetBuffSize or smallBuffSize;
            local buff = _G[auraName..i];
            buff:SetWidth(size);
            buff:SetHeight(size);
            local buffFrame =_G[auraName..i.."Stealable"];
            buffFrame:SetWidth(size+2);
            buffFrame:SetHeight(size+2);
        end
    end
end)

--TargetFrame & FocusFrame
hooksecurefunc("TargetFrame_UpdateAuras", function(self)
    local selfName = self:GetName();
    for i = self._163buffFrames or 1, MAX_TARGET_BUFFS do
        local frameName = selfName.."Buff"..(i);
        local frame = _G[frameName];
        if not frame then
            for j = self._163buffFrames or 1, i - 1 do
                _G[selfName.."Buff"..(j).."Cooldown"].noCooldownCount = not U1GetCfgValue(name, "targetBuffCooldownCount");
            end
            self._163buffFrames = max(1, i - 1)
            break
        end
    end

    for i = self._163debuffFrames or 1, MAX_TARGET_DEBUFFS do
        local frameName = selfName.."Debuff"..i;
        local frame = _G[frameName];
        if not frame then
            for j = self._163debuffFrames or 1, i - 1 do
                _G[selfName.."Debuff"..(j).."Cooldown"].noCooldownCount = not U1GetCfgValue(name, "targetDebuffCooldownCount");
            end
            self._163debuffFrames = max(1, i - 1)
            break
        end
    end
end)

--[[------------------------------------------------------------
--隐藏姓名版上的Debuff图标
---------------------------------------------------------------]]
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