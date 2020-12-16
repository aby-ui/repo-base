--------------------------------------------------------------------------------
-- Drag Frame
--
-- Allows users to move arounds bars in configuration mode and access bar
-- specific settings
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(Addon:GetParent():GetName())

local DragFrame = {}

DragFrame.__index = DragFrame

-- yay bitflags
local function HasFlag(state, flag)
    return bit.band(state, flag) == flag
end

local DRAG_FRAME_STATE = {
    -- default state
    DEFAULT = 0,
    -- a bar that's hidden
    HIDDEN = 1,
    -- a bar that's currently in focus
    FOCUSED = 2,
    -- a bar docked to another bar
    ANCHORED = 4,
    -- a bar in preview mode, so we want to see what the bar will look like
    PREVIEW = 8,
    -- a bar we've started moving via the keyboard
    KEYBOARD_MOVEMENT = 16
}

DragFrame.state = DRAG_FRAME_STATE.DEFAULT

-- drag frame levels
local DRAG_FRAME_LEVELS = {
    LOW = 10,
    MEDIUM = 20,
    HIGH = 30,
    FOCUSED = 100
}

-- drag frame background settings
local BACKGROUND_OPACITY = 0.5

local BACKGROUND_COLORS = {
    -- #114079
    [DRAG_FRAME_STATE.DEFAULT] = CreateColor(0.067, 0.251, 0.475, BACKGROUND_OPACITY),

    -- #071c34
    [DRAG_FRAME_STATE.ANCHORED] = CreateColor(0.027, 0.11, 0.204, BACKGROUND_OPACITY),

    -- #292f31
    [DRAG_FRAME_STATE.HIDDEN] = CreateColor(0.161, 0.184, 0.192, BACKGROUND_OPACITY),

    -- #121415
    [DRAG_FRAME_STATE.HIDDEN + DRAG_FRAME_STATE.ANCHORED] = CreateColor(0.071, 0.078, 0.082, BACKGROUND_OPACITY),

    -- transparent
    [DRAG_FRAME_STATE.PREVIEW] = CreateColor(0, 0, 0, 0),
}

-- apply fallback background colors
setmetatable(BACKGROUND_COLORS, {
    __index = function(t, k)
        -- previewing
        if HasFlag(k, DRAG_FRAME_STATE.PREVIEW) then
            return t[DRAG_FRAME_STATE.PREVIEW]
        end

        -- hidden + anchored
        if HasFlag(k, DRAG_FRAME_STATE.HIDDEN + DRAG_FRAME_STATE.ANCHORED) then
            return t[DRAG_FRAME_STATE.HIDDEN + DRAG_FRAME_STATE.ANCHORED]
        end

        -- hidden
        if HasFlag(k, DRAG_FRAME_STATE.HIDDEN) then
            return t[DRAG_FRAME_STATE.HIDDEN]
        end

        -- anchored
        if HasFlag(k, DRAG_FRAME_STATE.ANCHORED) then
            return t[DRAG_FRAME_STATE.ANCHORED]
        end

        -- otherwise use the default color
        return t[DRAG_FRAME_STATE.DEFAULT]
    end
})

-- drag frame border settings
local BORDER_THICKNESS = 2

local BORDER_OPACITY = 0.8

local BORDER_COLORS = {
    -- #117479
    [DRAG_FRAME_STATE.DEFAULT] = CreateColor(0.067, 0.455, 0.475, BACKGROUND_OPACITY),

    -- #1ab4bc
    [DRAG_FRAME_STATE.FOCUSED] = CreateColor(0.102, 0.706, 0.737, BORDER_OPACITY)
}

-- apply fallback border colors
setmetatable(BORDER_COLORS, {
    __index = function(t, k)
        -- use the focused color if we have it
        if HasFlag(k, DRAG_FRAME_STATE.FOCUSED) then
            return t[DRAG_FRAME_STATE.FOCUSED]
        end

        -- otherwise use the default color
        return t[DRAG_FRAME_STATE.DEFAULT]
    end
})

-- other settings
local KEYBOARD_MOVEMENT_INCREMENT = 1
local OPACITY_INCREMENT = 0.05

--------------------------------------------------------------------------------
-- Fonts
--------------------------------------------------------------------------------

local DragFrameLabelFont = CreateFont(AddonName .. 'DragFrameFont')

DragFrameLabelFont:CopyFontObject('GameFontNormal')
DragFrameLabelFont:SetJustifyH('CENTER')
DragFrameLabelFont:SetJustifyV('CENTER')

local DragFrameLabelHighlightFont = CreateFont(AddonName .. 'DragFrameHighlightFont')

DragFrameLabelHighlightFont:CopyFontObject(DragFrameLabelFont)
DragFrameLabelHighlightFont:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGBA())

local DragFrameTextFont = CreateFont(AddonName .. 'DragFrameContentFont')
DragFrameTextFont:CopyFontObject('GameFontNormal')
DragFrameTextFont:SetJustifyH('CENTER')
DragFrameTextFont:SetJustifyV('CENTER')

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

function DragFrame:Create(parent)
    local frame = setmetatable({ }, DragFrame)

    frame:OnLoad(parent)

    return frame
end

function DragFrame:OnLoad(parent)
    -- create the frame
    self.frame  = CreateFrame('Button', nil, parent)
    self.frame:EnableKeyboard(false)
    self.frame:Hide()
    self.frame:RegisterForClicks('AnyUp')
    self.frame:RegisterForDrag('LeftButton')
    self.frame:SetFrameStrata('DIALOG')
    self.frame:SetHighlightFontObject(DragFrameLabelHighlightFont)
    self.frame:SetNormalFontObject(DragFrameLabelFont)
    self.frame:SetText("LABEL")
    self.frame:SetScript('OnKeyDown', function(_, key) self:OnKeyDown(key) end)
    self.frame:SetScript("OnClick", function(_, button) self:OnClick(button) end)
    self.frame:SetScript("OnEnter", function() self:OnEnter() end)
    self.frame:SetScript("OnLeave", function() self:OnLeave() end)
    self.frame:SetScript("OnMouseDown", function(_, button) self:OnMouseDown(button) end)
    self.frame:SetScript("OnMouseUp", function() self:OnMouseUp() end)
    self.frame:SetScript("OnMouseWheel", function(_, delta) self:OnMouseWheel(delta) end)
    self.frame.UpdateTooltip = function() self:UpdateTooltip() end

    -- add a label
    self.label = self.frame:GetFontString()
    --self.label:SetPoint('TOPLEFT', BORDER_THICKNESS * 2, -BORDER_THICKNESS * 2)
    --self.label:SetPoint('BOTTOMRIGHT', -BORDER_THICKNESS * 2, BORDER_THICKNESS * 2)
    self.label:SetPoint("CENTER") --abyui

    -- contextual text
    self.text = self.frame:CreateFontString(nil, 'OVERLAY', 2)
    self.text:SetFontObject(DragFrameTextFont)
    self.text:SetPoint('CENTER')
    self.text:Hide()

    -- contextual text background (to make it easier to see)
    self.textBg = self.frame:CreateTexture(nil, 'OVERLAY', 1)
    self.textBg:SetPoint('TOPLEFT', self.text, 'TOPLEFT', -BORDER_THICKNESS * 2, BORDER_THICKNESS * 2)
    self.textBg:SetPoint('BOTTOMRIGHT', self.text, 'BOTTOMRIGHT', BORDER_THICKNESS * 2, -BORDER_THICKNESS * 2)
    self.textBg:SetColorTexture(0, 0, 0, 0.6)
    self.textBg:Hide()

    -- add a background
    self.bg = self.frame:CreateTexture(nil, 'BACKGROUND', 1)
    self.bg:SetPoint('TOPLEFT', BORDER_THICKNESS, -BORDER_THICKNESS)
    self.bg:SetPoint('BOTTOMRIGHT', -BORDER_THICKNESS, BORDER_THICKNESS)
    self.bg:SetColorTexture(BACKGROUND_COLORS[self.state]:GetRGBA())

    -- add a border
    self.borderTop = self.frame:CreateTexture(nil, 'BACKGROUND', 2)
    self.borderTop:SetColorTexture(BORDER_COLORS[self.state]:GetRGBA())
    self.borderTop:SetPoint("TOPLEFT")
    self.borderTop:SetPoint("TOPRIGHT")
    self.borderTop:SetHeight(BORDER_THICKNESS)

    self.borderLeft = self.frame:CreateTexture(nil, 'BACKGROUND', 2)
    self.borderLeft:SetColorTexture(BORDER_COLORS[self.state]:GetRGBA())
    self.borderLeft:SetPoint("TOPLEFT", 0, -BORDER_THICKNESS)
    self.borderLeft:SetPoint("BOTTOMLEFT", 0, BORDER_THICKNESS)
    self.borderLeft:SetWidth(BORDER_THICKNESS)

    self.borderBottom = self.frame:CreateTexture(nil, 'BACKGROUND', 2)
    self.borderBottom:SetColorTexture(BORDER_COLORS[self.state]:GetRGBA())
    self.borderBottom:SetPoint("BOTTOMLEFT")
    self.borderBottom:SetPoint("BOTTOMRIGHT")
    self.borderBottom:SetHeight(BORDER_THICKNESS)

    self.borderRight = self.frame:CreateTexture(nil, 'BACKGROUND', 2)
    self.borderRight:SetColorTexture(BORDER_COLORS[self.state]:GetRGBA())
    self.borderRight:SetPoint("TOPRIGHT", 0, -BORDER_THICKNESS)
    self.borderRight:SetPoint("BOTTOMRIGHT", 0, BORDER_THICKNESS)
    self.borderRight:SetWidth(BORDER_THICKNESS)
end

function DragFrame:OnClick(button)
    if button == 'RightButton' then
        if IsModifierKeyDown() then
            self:SetOwnerShown(not self:IsOwnerShown())
        else
            self:ShowOwnerContextMenu()
        end
    elseif button == 'MiddleButton' then
        self:SetOwnerShown(not self:IsOwnerShown())
    end

    self:UpdateState()
end

function DragFrame:OnEnter()
    self:AddState(DRAG_FRAME_STATE.FOCUSED)

    GameTooltip:SetOwner(self.frame, 'ANCHOR_LEFT')

    self:UpdateTooltip()
end

function DragFrame:OnLeave()
    self:RemoveState(DRAG_FRAME_STATE.FOCUSED)

    if GameTooltip:GetOwner() == self.frame then
        GameTooltip:Hide()
    end
end

local function IsKeyInSet(key, ...)
    for i = 1, select('#', ...) do
        if key == (select(i, ...)) then
            return true
        end
    end
end

function DragFrame:OnKeyDown(key)
    local handled = false

    if self:HasState(DRAG_FRAME_STATE.FOCUSED) then
        if IsKeyInSet(key, GetBindingKey('MOVEFORWARD')) then
            self:NudgeFrame(0, KEYBOARD_MOVEMENT_INCREMENT)
            handled = true
        elseif IsKeyInSet(key, GetBindingKey('MOVEBACKWARD')) then
            self:NudgeFrame(0, -KEYBOARD_MOVEMENT_INCREMENT)
            handled = true
        elseif IsKeyInSet(key, GetBindingKey('TURNLEFT')) then
            self:NudgeFrame(-KEYBOARD_MOVEMENT_INCREMENT, 0)
            handled = true
        elseif IsKeyInSet(key, GetBindingKey('TURNRIGHT')) then
            self:NudgeFrame(KEYBOARD_MOVEMENT_INCREMENT, 0)
            handled = true
        end
    end

    self.frame:SetPropagateKeyboardInput(not handled)
end

function DragFrame:OnMouseDown(button)
    if button == 'LeftButton' then
        self:SetMoving(true)
    end
end

function DragFrame:OnMouseUp()
    self:SetMoving(false)
end

function DragFrame:OnClick(button)
    if button == 'RightButton' then
        if IsModifierKeyDown() then
            self:SetOwnerShown(not self:IsOwnerShown())
        else
            self:ShowOwnerContextMenu()
        end
    elseif button == 'MiddleButton' then
        self:SetOwnerShown(not self:IsOwnerShown())
    end

    self:UpdateState()
end

function DragFrame:OnMouseWheel(delta)
    self:IncrementOpacity(delta)
end

function DragFrame:OnMovingChanged(isMoving)
    local owner = self.owner
    if not owner then
        return
    end

    if isMoving then
        owner:StartMoving()
    else
        owner:StopMovingOrSizing()
        owner:Stick()
    end
end

function DragFrame:OnOwnerChanged(owner)
    if not owner then
        self.frame:Hide()
        return
    end

    self:UpdateState()

    -- attach to frame
    self.frame:ClearAllPoints()
    self.frame:SetAllPoints(owner)

    -- update label
    self.label:SetText(owner:GetDisplayName())

    -- show
    self.frame:Show()

    self.frame:SetFrameLevel(DRAG_FRAME_LEVELS[owner:GetDisplayLevel() or 'LOW'])
end

function DragFrame:OnStateChanged(state)
    self.bg:SetColorTexture(BACKGROUND_COLORS[state]:GetRGBA())
    self.borderBottom:SetColorTexture(BORDER_COLORS[state]:GetRGBA())
    self.borderLeft:SetColorTexture(BORDER_COLORS[state]:GetRGBA())
    self.borderRight:SetColorTexture(BORDER_COLORS[state]:GetRGBA())
    self.borderTop:SetColorTexture(BORDER_COLORS[state]:GetRGBA())
end

function DragFrame:OnContextMenuShown()
    self:ShowPreview()
end

function DragFrame:OnContextMenuHidden()
    self:HidePreview()
end

--------------------------------------------------------------------------------
-- Methods
--------------------------------------------------------------------------------

function DragFrame:SetOwner(owner)
    local oldOwner = self.owner
    if oldOwner ~= owner then
        self.owner = owner
        self:OnOwnerChanged(owner)
    end
end

function DragFrame:SetMoving(isMoving)
    isMoving = isMoving and true or false

    local wasMoving = self.isMoving and true or false

    if wasMoving ~= isMoving then
        self.isMoving = isMoving
        self:OnMovingChanged(isMoving)
    end
end

function DragFrame:AddState(value)
    local oldState = self.state
    local newState = bit.bor(self.state, value)

    if oldState ~= newState then
        self.state = newState
        self:OnStateChanged(newState)
    end
end

function DragFrame:RemoveState(value)
    local oldState = self.state
    local newState = bit.band(self.state, bit.bnot(value))

    if oldState ~= newState then
        self.state = newState
        self:OnStateChanged(newState)
    end
end

function DragFrame:ClearState()
    local oldState = self.state
    local newState = 0

    if oldState ~= newState then
        self.state = newState
        self:OnStateChanged(newState)
    end
end

function DragFrame:HasState(value)
    return HasFlag(self.state, value)
end

function DragFrame:UpdateState()
    if not self.owner then
        self:ClearState()
        return
    end

    if self.owner:IsAnchored() then
        self:AddState(DRAG_FRAME_STATE.ANCHORED)
    else
        self:RemoveState(DRAG_FRAME_STATE.ANCHORED)
    end

    if not self:IsOwnerShown() then
        self:AddState(DRAG_FRAME_STATE.HIDDEN)
    else
        self:RemoveState(DRAG_FRAME_STATE.HIDDEN)
    end
end

function DragFrame:UpdateTooltip()
    local tooltip = _G.GameTooltip

    GameTooltip_SetTitle(tooltip, ('%s %s(%s)%s'):format(self.owner:GetDisplayName():gsub("\n", ""), NORMAL_FONT_COLOR_CODE, self.owner.id, FONT_COLOR_CODE_CLOSE))

    local description = self.owner:GetDescription()
    if description then
        GameTooltip_AddNormalLine(tooltip, description)
    end

    GameTooltip_AddBlankLinesToTooltip(tooltip, 1)

    GameTooltip_AddInstructionLine(tooltip, L.ShowConfig)

    if self:IsOwnerShown() then
        GameTooltip_AddInstructionLine(tooltip, L.HideBar)
    else
        GameTooltip_AddInstructionLine(tooltip, L.ShowBar)
    end

    GameTooltip_AddInstructionLine(tooltip, L.SetAlpha:format(Round(self.owner:GetFrameAlpha() * 100)))

    GameTooltip_AddInstructionLine(tooltip, L.KeyboardMovementTip)

    tooltip:Show()
end

-- visibility
function DragFrame:SetOwnerShown(isShown)
    if not self.owner then
        return
    end

    if isShown then
        self.owner:ShowFrame()
        self:ShowTemporaryText(0.5, L.Shown)
    else
        self.owner:HideFrame()
        self:ShowTemporaryText(0.5, L.Hidden)
    end
end

function DragFrame:IsOwnerShown()
    return self.owner and self.owner:FrameIsShown()
end

-- opacity
function DragFrame:SetOwnerOpacity(opacity)
    if not self.owner then
        return
    end

    self.owner:SetFrameAlpha(opacity)
    self:ShowTemporaryText(0.5, "%s %s", FormatPercentage(opacity, true), OPACITY)
    self:ShowTemporaryPreview(0.5)
end

function DragFrame:GetOwnerOpacity()
    if self.owner then
        return self.owner:GetFrameAlpha()
    end
    return 1
end

function DragFrame:IncrementOpacity(direction)
    if not self.owner then
        return
    end

    local delta = OPACITY_INCREMENT * direction
    local newOpacity = Clamp(self:GetOwnerOpacity() + delta, 0, 1)

    self:SetOwnerOpacity(newOpacity)
end

-- position
function DragFrame:NudgeFrame(dx, dy)
    local ox, oy, ow, oh = self.owner:GetRect()
    local _, _, pw, ph = self.owner:GetParent():GetRect()
    local x = Clamp(Round(ox + dx), 0, pw - ow)
    local y = Clamp(Round(oy + dy), 0, ph - oh)

    self.owner:ClearSavedAnchor()
    self.owner:ClearAllPoints()
    self.owner:SetPoint("BOTTOMLEFT", x, y)
    self.owner:SaveRelativePostiion()
    self.owner:RestorePosition()

    self:ShowTemporaryText(0.5, "(%d, %d)", self.owner:GetRect())
end

-- preview
function DragFrame:ShowTemporaryText(duration, text, ...)
    if select("#", ...) > 0 then
        self.text:SetFormattedText(text, ...)
    else
        self.text:SetText(text)
    end

    self.label:Hide()
    self.text:Show()
    self.textBg:Show()

    self._tempTextEndTime = GetTime() + duration

    if not self._hideTempText then
        self._hideTempText = function()
            if self._tempTextEndTime and self._tempTextEndTime <= GetTime() then
                self.text:Hide()
                self.textBg:Hide()
                self.label:Show()
            end
        end
    end

    _G.C_Timer.After(duration, self._hideTempText)
end

function DragFrame:ShowTemporaryPreview(duration)
    self:AddState(DRAG_FRAME_STATE.PREVIEW)

    self._previewEndTime = GetTime() + duration

    if not self._hidePreview then
        self._hidePreview = function()
            if self._previewEndTime and self._previewEndTime <= GetTime() then
                self:RemoveState(DRAG_FRAME_STATE.PREVIEW)
            end
        end
    end

    _G.C_Timer.After(duration, self._hidePreview)
end

function DragFrame:ShowPreview()
    self:AddState(DRAG_FRAME_STATE.PREVIEW)
    self._previewEndTime = nil
end

function DragFrame:HidePreview()
    self:RemoveState(DRAG_FRAME_STATE.PREVIEW)
end

function DragFrame:ShowOwnerContextMenu()
    if not self.owner then
        return
    end

    self.owner:ShowMenu()
end

--------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------

Addon.DragFrameLabelFont = DragFrameLabelFont
Addon.DragFrameLabelHighlightFont = DragFrameLabelHighlightFont
Addon.DragFrame = DragFrame