U1PLUG["ExtraActionButton"] = function()

--/run ExtraActionBarFrame:Show() ExtraActionBarFrame:SetAlpha(1) ExtraActionButton1:Show() 106466 梦境
--ExtraBar.__f = f --/run HasExtraActionBar = function () return 1 end Dominos.ExtraBar.__f:UpdateButtonsShown()

function U1ExtraAction1Show(self)
    local _, spellID = GetActionInfo(121);
    if not spellID or not HasExtraActionBar() then
        self.icon:SetTexture("Interface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo");
        return;
    end
    local texture = spellID == 106466 and "SpellPush-Frame-Ysera" or "SpellPush-Frame"
    self.style:SetTexture("Interface\\UnitPowerBarAlt\\"..texture);
    self.icon:SetTexture(GetSpellTexture(spellID))
end

local btn = WW:CheckButton("U1ExtraAction1", UIParent, "ActionButtonTemplate, SecureActionButtonTemplate"):Hide():Size(52):CENTER(-300, -100)
:CreateTexture(nil, "OVERLAY"):Key("style"):SetTexture("Interface\\UnitPowerBarAlt\\SpellPush-Frame"):Size(256, 128):CENTER(-2, 0):up()
:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
:AddFrameLevel(2)
:SetAttribute("*type1", "macro")
:SetAttribute("macrotext", "/click ExtraActionButton1")
:RegisterForClicks("AnyUp")
:SetScript("OnShow", function(self) self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN") end)
:SetScript("OnHide", function(self) self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN") end)
:SetScript("OnEvent", function(self, event)
    if event=="ACTIONBAR_UPDATE_COOLDOWN" then
        if HasExtraActionBar() then
            local start, duration = GetActionCooldown(121)
            if start and duration then
                if start~=self._start or duration~=self._duration then
                    self.cooldown:SetCooldown(start, duration)
                    self._start = start
                    self._duration = duration
                end
            else
                self._start = nil
                self._duration = nil
            end
        end
    else
        U1ExtraAction1Show(self)
    end
end)
:SetScript("PostClick", function(self)
    self:SetChecked(0);
    if(IsControlKeyDown() and IsAltKeyDown()) then
        if(not InCombatLockdown()) then
            self:Hide()
        else
            U1Message("战斗中无法隐藏，请脱战后重试")
        end
    end
end)
:SetScale(0.75):un()

btn:GetNormalTexture():Hide()

CoreUIMakeMovable(btn)
btn:SetClampedToScreen(false);
CoreUIEnableTooltip(btn, nil, function(self, tip)
    if HasExtraActionBar() then
        tip:SetAction(121)
    else
        tip:SetText("爱不易替代额外按钮")
        tip:AddLine("右键拖动位置")
        tip:AddLine("Ctrl+Alt点击暂时隐藏")
    end
end)

U1ExtraAction1Show(btn);

end