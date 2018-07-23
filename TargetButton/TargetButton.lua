function TargetButton_Redraw(self)
    TargetButtonsFrame_InspectButton:SetPoint("CENTER", "TargetFrame", "TOPLEFT", 113, -13);  -- euf 113, -16 other 103, -15
    TargetButtonsFrame_FollowButton:SetPoint("RIGHT", "$parent_InspectButton", "LEFT", 1, 0);
    TargetButtonsFrame_TradeButton:SetPoint("RIGHT", "$parent_FollowButton", "LEFT", 1, 0);
    TargetButtonsFrame_WhisperButton:SetPoint("RIGHT", "$parent_TradeButton", "LEFT", 1, 0);
    if(UnitIsPlayer("target") and not UnitIsUnit("player","target")) then
        if UnitIsFriend("player","target") then
            TargetButtonsFrame_WhisperButton:Show();
            TargetButtonsFrame_TradeButton:Show();
            TargetButtonsFrame_FollowButton:Show();
        else
            TargetButtonsFrame_WhisperButton:Hide();
            TargetButtonsFrame_TradeButton:Hide();
            TargetButtonsFrame_FollowButton:Hide();
        end
        TargetButtonsFrame_InspectButton:Show();
    else
        TargetButtonsFrame_WhisperButton:Hide();
        TargetButtonsFrame_FollowButton:Hide();
        TargetButtonsFrame_TradeButton:Hide();
        TargetButtonsFrame_InspectButton:Hide();
    end
end

local timer = 0
function TargetButton_CheckRange(self, elapsed)
    timer = timer + elapsed
    if timer >= 0.2 then
        timer = 0
        if CheckInteractDistance("target",1) then
            TargetButtonsFrame_InspectButton:Enable();
            TargetButtonsFrame_FollowButton:Enable();
        else
            TargetButtonsFrame_InspectButton:Disable();
            --TargetButtonsFrame_FollowButton:Disable();
        end
        if CheckInteractDistance("target",2) then
            TargetButtonsFrame_TradeButton:Enable();
            if ( UnitIsDeadOrGhost("player") or UnitIsDeadOrGhost("target") ) then
                TargetButtonsFrame_TradeButton:Disable();
            end
        else
            TargetButtonsFrame_TradeButton:Disable();
        end
    end
end