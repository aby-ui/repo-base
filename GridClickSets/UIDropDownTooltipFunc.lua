--[[------------------------------------------------------------
DropdownLists Buttons support tooltipFunc tooltipFuncArg1 tooltipFuncArg2
---------------------------------------------------------------]]
local function dropDownButtonOnEnter(self)
    if self.tooltipFunc then
        if self.tooltipOnButton then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        else
            GameTooltip_SetDefaultAnchor(GameTooltip, self);
        end
        self.tooltipFunc(self, GameTooltip, self.tooltipFuncArg1, self.tooltipFuncArg2)
        GameTooltip:Show();
    end
end
local function dropDownButtonInvisibleOnEnter(self)
    local parent = self:GetParent()
    if ( parent.tooltipFunc and parent.tooltipWhileDisabled) then
        if ( parent.tooltipOnButton ) then
            GameTooltip:SetOwner(parent, "ANCHOR_RIGHT");
        else
            GameTooltip_SetDefaultAnchor(GameTooltip, parent);
        end
        GameTooltip:Show();
    end
end
local hookDropDownOnEnter = function()
    for i = 1, UIDROPDOWNMENU_MAXLEVELS do
        for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
            local btn = _G["DropDownList" .. i .. "Button" .. j]
            if btn and btn.invisibleButton and not btn.invisibleButton._163ui_tip_done then
                btn:HookScript("OnEnter", dropDownButtonOnEnter)
                btn.invisibleButton:HookScript("OnEnter", dropDownButtonInvisibleOnEnter);
                btn.invisibleButton._163ui_tip_done = true
            end
        end
    end
end
hooksecurefunc("UIDropDownMenu_CreateFrames", hookDropDownOnEnter)
hookDropDownOnEnter()
hooksecurefunc("UIDropDownMenu_AddButton", function(info, level)
    level = level or 1;
    local button = _G["DropDownList"..level.."Button".._G["DropDownList"..level].numButtons];
    button.tooltipFunc = info.tooltipFunc
    button.tooltipFuncArg1 = info.tooltipFuncArg1
    button.tooltipFuncArg2 = info.tooltipFuncArg2
end)