
local tdPack = tdCore(...)
local L = tdPack:GetLocale()

local PackButton = tdPack:NewModule('PackButton', CreateFrame('Button'))
tdCore('GUI'):Embed(PackButton, 'UIObject')

local staticPopupData = {}
StaticPopupDialogs["TDPACK_CONFIRM_BANK"] = {preferredIndex = 3,
    text = "是否同时整理背包和银行？",
    button1 = "全部整理",
    button2 = "仅整理背包",
    OnAccept = function (self)
        TDPACK_IGNORE_BAGS_NO_BANK = nil
        tdPack:Pack()
    end,
    OnCancel = function(self)
        TDPACK_IGNORE_BAGS_NO_BANK = true
        tdPack:Pack()
    end,
    timeout = 0,
    exclusive = 1,
    hideOnEscape = 1,
    noCancelOnEscape = 1,
}

function PackButton:New(parent)
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    obj:RegisterForClicks('anyUp')
	
	obj:RegisterEvent'BANKFRAME_CLOSED'
    obj:RegisterEvent'BANKFRAME_OPENED'
	obj:SetScript('OnEvent', function(self, event)
        if(event == 'BANKFRAME_CLOSED') then
            self.bankFrameOpened = false
        elseif event == 'BANKFRAME_OPENED' then
            self.bankFrameOpened = true
        end
    end)

    obj:SetScript('OnClick', function(self, button)
		local frameID = self:GetParent().frameID
        _G.TDPACK_IGNORE_BAGS_NO_BANK = nil

        if button == "RightButton" and not IsModifierKeyDown() then
            self:OnClick(button)
        elseif(tdPack:GetModule("Pack").isBankOpened) then
            if(frameID == 'bank') then
                if button == "MiddleButton" then
                    TDPACK_ONLY_REAGENT = true
                    return tdPack:Pack(IsShiftKeyDown() and 'asc' or IsControlKeyDown() and 'desc' or nil)
                end
                TDPACK_IGNORE_BAGS = true
                return tdPack:Pack(button == "RightButton" and IsShiftKeyDown() and 'asc' or button == "RightButton" and IsControlKeyDown() and 'desc' or nil)
            else
                return StaticPopup_Show("TDPACK_CONFIRM_BANK", nil, nil, staticPopupData)
            end
        else
            self:OnClick(button)
        end
	end)

	obj:SetScript('OnEnter', function(self)
		local tooltip = GameTooltip
		if not tooltip or not tooltip.AddLine then return end
		GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
		
		tooltip:AddLine('|cff32cd32tdPack|r')
		tooltip:AddDoubleLine(L['Sequence'], tdPack:IsReversePack() and L['desc'] or L['asc'], 1, 1, 0, 1, 1, 1)
		
		tooltip:AddLine(' ')
		tooltip:AddDoubleLine(L['<Left Click> '], L['Pack bags'], 0, 1, 0, 0, 1, 0)
		tooltip:AddDoubleLine(L['Shift + Left-Click'], L['Save to bank'], 0, 1, 0, 0, 1, 0)
		tooltip:AddDoubleLine(L['Ctrl + Left-Click'], L['Load from bank'], 0, 1, 0, 0, 1, 0)
		tooltip:AddDoubleLine(L['Shift + Right-Click'], L['Pack asc'], 0, 1, 0, 0, 1, 0)
		tooltip:AddDoubleLine(L['Ctrl + Right-Click'], L['Pack desc'], 0, 1, 0, 0, 1, 0)
        if self:GetParent().frameID == 'bank' then
            tooltip:AddDoubleLine(L['<Middle Click> '], L['Pack reagent bag'], 0, 1, 1, 0, 1, 1)
        end
		tooltip:AddDoubleLine(L['<Right Click> '], L['Open tdPack config frame'], 0, 1, 1, 0, 1, 1)
        if tdPack_BAGS then
            local ignore = -(#tdPack_BAGS.bag - 5 + #tdPack_BAGS.bank - 8)
            if ignore > 0 then
                tooltip:AddLine("注意：你已选择忽略了"..ignore.."个背包", 1, 0, 0)
            end
        end

		GameTooltip:Show()
	end)

    obj:SetScript('OnLeave', function(self) if(GameTooltip:GetOwner() == self) then GameTooltip:Hide() end end)

    obj:SetScript('OnHide', function(self) if(GameTooltip:GetOwner() == self) then GameTooltip:Hide() end end)

    return obj
end

function PackButton:OnClick(button)
    if button == 'LeftButton' then
		if IsShiftKeyDown() then
			tdPack:Pack('save')
		elseif IsControlKeyDown() then
			tdPack:Pack('load')
		else
			tdPack:Pack()
		end
    elseif button == 'RightButton' then
		if IsShiftKeyDown() then
			tdPack:Pack('asc')
		elseif IsControlKeyDown() then
			tdPack:Pack('desc')
        else
            if UUI then
                UUI.OpenToAddon("tdpack")
                UUI.Raise()
            else
                tdPack:ToggleOption()
            end
		end
    end
end

function PackButton:GetPackButton(parent)
    if not parent.tdPackButton then
        parent.tdPackButton = self:New(parent)
        parent.tdPackButton:Init()
    end
    return parent.tdPackButton
end

function PackButton:Init()
end
