--------------------------------------------------------------------------------
-- frame.lua
-- a custom window like object
--------------------------------------------------------------------------------
local AddonName, Addon = ...
local Frame = Addon:CreateClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)
local FlyPaper = LibStub('LibFlyPaper-2.0')

local function fireBarCallback(bar, callback, ...)
    Addon.callbacks:Fire(callback, bar, bar.id, ...)
end

local active = {}
local unused = {}

local function frame_OnSetAlpha(frame, alpha)
    frame:OnSetAlpha(alpha)
end

local function frame_OnSetScale(frame, scale)
    frame:OnSetScale(scale)
end

local frame_UpdateShown = [[
    if self:GetAttribute("state-hidden") then
        self:Hide()
        return
    end

    local isPetBattleUIShown = self:GetAttribute('state-petbattleui') and true
    if isPetBattleUIShown and not self:GetAttribute('state-showinpetbattleui') then
        self:Hide()
        return
    end

    local isOverrideUIShown = self:GetAttribute('state-overrideui') and true
    if isOverrideUIShown and not self:GetAttribute('state-showinoverrideui') then
        self:Hide()
        return
    end

    local requiredState = self:GetAttribute('state-display')
    if requiredState == 'hide' then
        self:Hide()
        return
    end

    local userState = self:GetAttribute('state-userDisplay')
    if userState == 'hide' then
        if self:GetAttribute('state-alpha') then
            self:SetAttribute('state-alpha', nil)
        end

        self:Hide()
        return
    end

    local userAlpha = tonumber(userState)
    if self:GetAttribute('state-alpha') ~= userAlpha then
        self:SetAttribute('state-alpha', userAlpha)
    end

    self:Show()
]]

local frame_CallUpdateShown = 'self:RunAttribute("UpdateShown")'

--------------------------------------------------------------------------------
-- Constructor / Destructor
--------------------------------------------------------------------------------

-- constructor
function Frame:New(id)
    id = tonumber(id) or id

    local frame = self:Restore(id) or self:Create(id)

    frame:LoadSettings()

    if Addon.OverrideController then
        Addon.OverrideController:Add(frame)
    end

    frame:OnAcquire(id)
    FlyPaper.AddFrame(AddonName, id, frame)
    active[id] = frame

    return frame
end

function Frame:Create(id)
    local frameName = ('%sFrame%s'):format(AddonName, id)

    local frame = self:Bind(CreateFrame('Frame', frameName, UIParent, 'SecureHandlerStateTemplate'))

    frame:SetClampedToScreen(true)
    frame:SetMovable(true)

    frame.id = id

    frame:SetAttribute('id', id)

    frame:SetAttribute('_onstate-alpha', "self:CallMethod('FadeOut')")
    frame:SetAttribute('_onstate-display', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-hidden', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-overrideui', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-petbattleui', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-showinoverrideui', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-showinpetbattleui', frame_CallUpdateShown)
    frame:SetAttribute('_onstate-userDisplay', frame_CallUpdateShown)

    frame:SetAttribute('UpdateShown', frame_UpdateShown)
    hooksecurefunc(frame, 'SetAlpha', frame_OnSetAlpha)
    hooksecurefunc(frame, 'SetScale', frame_OnSetScale)

    frame:OnCreate(id)

    return frame
end

function Frame:Restore(id)
    local frame = unused[id]

    if frame then
        unused[id] = nil

        frame:OnRestore(id)

        return frame
    end
end

-- destructor
function Frame:Free(deleteSettings)
    active[self.id] = nil

    UnregisterStateDriver(self, 'display', 'show')

    Addon.FadeManager:Remove(self)

    if Addon.OverrideController then
        Addon.OverrideController:Remove(self)
    end

    FlyPaper.RemoveFrame(AddonName, self.id, self)

    self:ClearAllPoints()
    self:SetUserPlaced(false)
    self:Hide()

    self:OnRelease(self.id, deleteSettings)

    unused[self.id] = self
end

--------------------------------------------------------------------------------
-- Lifecycle Hooks/Events
--------------------------------------------------------------------------------

-- called when a frame is acquired from the pool
function Frame:OnAcquire(id)
    if self.OnEnable then
        Addon:Printf('Bar %q called deprecated method OnEnable', id)
        self:OnEnable()
    end
end

-- called when a frame is first created
function Frame:OnCreate(id)
end

-- called when a frame is pulled in from the inactive pool
function Frame:OnRestore(id)
end

-- called when a frame is sent to the inactive pool
function Frame:OnRelease(id, deleteSettings)
    if self.OnFree then
        Addon:Printf('Bar %q called deprecated method OnFree', id)
        self:OnFree()
    end
end

function Frame:OnLoadSettings()
end

function Frame:OnSetAlpha(newAlpha)
end

function Frame:OnSetScale(newScale)
end

--------------------------------------------------------------------------------
-- Initialization
--------------------------------------------------------------------------------

function Frame:LoadSettings()
    -- get defaults must be provided by anything implementing the Frame type
    self.sets = Addon:GetFrameSets(self.id)
             or Addon:SetFrameSets(self.id, self:GetDefaults())

    self:UpdateDisplayLayer()
    self:UpdateDisplayLevel()
    self:RestorePosition()
    self:RestoreAnchor()

    if self.sets.hidden then
        self:HideFrame()
    else
        self:ShowFrame()
    end

    self:UpdateDisplayConditions()
    self:UpdateUserDisplayConditions()
    self:ShowInOverrideUI(self:ShowingInOverrideUI())
    self:ShowInPetBattleUI(self:ShowingInPetBattleUI())

    self:OnLoadSettings()
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

function Frame:Layout()
    local width, height = 32, 32
    local paddingW, paddingH = self:GetPadding()

    self:TrySetSize(width + paddingW * 2, height + paddingH * 2)
end

function Frame:TrySetSize(width, height)
    if not _G.InCombatLockdown() then
        self:SetSize(width, height)
        return true
    end

    return false
end

--------------------------------------------------------------------------------
-- Padding
--------------------------------------------------------------------------------

function Frame:SetPadding(width, height)
    width = tonumber(width) or 0
    height = tonumber(height) or width

    self.sets.padW = width ~= 0 and width or nil
    self.sets.padH = height ~= 0 and height or nil

    self:Layout()
end

function Frame:GetPadding()
    local width = self.sets.padW or 0
    local height = self.sets.padH or width

    return width, height
end

--------------------------------------------------------------------------------
-- Scaling
--------------------------------------------------------------------------------

function Frame:SetFrameScale(newScale, scaleAnchored)
    newScale = tonumber(newScale) or 1

    self.sets.scale = newScale

    FlyPaper.SetScale(self, newScale)
    self:SaveRelativePostiion()

    if scaleAnchored then
        self:ForAnchored('SetFrameScale', newScale, scaleAnchored)
    end
end

function Frame:GetFrameScale()
    return self.sets.scale or 1
end

--------------------------------------------------------------------------------
-- Opacity
--------------------------------------------------------------------------------

function Frame:SetFrameAlpha(alpha)
    if alpha == 1 then
        self.sets.alpha = nil
    else
        self.sets.alpha = alpha
    end

    self:UpdateAlpha()
end

function Frame:GetFrameAlpha()
    return self.sets.alpha or 1
end

--------------------------------------------------------------------------------
-- Faded Opacity
--------------------------------------------------------------------------------

-- faded opacity (mouse not over the frame)
function Frame:SetFadeMultiplier(alpha)
    alpha = tonumber(alpha) or 1

    if alpha == 1 then
        self.sets.fadeAlpha = nil
    else
        self.sets.fadeAlpha = alpha
    end

    self:UpdateWatched()
    self:UpdateAlpha()
end

function Frame:GetFadeMultiplier()
    return self.sets.fadeAlpha or 1
end

--------------------------------------------------------------------------------
-- Fade In Timing
--------------------------------------------------------------------------------

function Frame:SetFadeInDelay(delay)
    delay = tonumber(delay) or 0
    self.sets.fadeInDelay = delay ~= 0 and delay
    self:UpdateWatched()
end

function Frame:GetFadeInDelay()
    return self.sets.fadeInDelay or 0
end

function Frame:SetFadeInDuration(duration)
    duration = tonumber(duration) or 0.1
    self.sets.fadeInDuration = duration ~= 0.1 and duration
    self:UpdateWatched()
end

function Frame:GetFadeInDuration()
    return self.sets.fadeInDuration or 0.1
end

--------------------------------------------------------------------------------
-- Fade Out Timing
--------------------------------------------------------------------------------

function Frame:SetFadeOutDelay(delay)
    delay = tonumber(delay) or 0
    self.sets.fadeOutDelay = delay ~= 0 and delay
    self:UpdateWatched()
end

function Frame:GetFadeOutDelay()
    return self.sets.fadeOutDelay or 0
end

function Frame:SetFadeOutDuration(duration)
    duration = tonumber(duration) or 0.1
    self.sets.fadeOutDuration = duration ~= 0.1 and duration
    self:UpdateWatched()
end

function Frame:GetFadeOutDuration()
    return self.sets.fadeOutDuration or 0.1
end

--------------------------------------------------------------------------------
-- Fade Out Timing
--------------------------------------------------------------------------------

function Frame:UpdateAlpha()
    self:SetAlpha(self:GetExpectedAlpha())

    if Addon:IsLinkedOpacityEnabled() then
        self:ForAnchored('UpdateAlpha')
    end
end

-- returns the opacity value we expect the frame to be at in its current state
function Frame:GetExpectedAlpha()
    -- if this is a docked frame and linked opacity is enabled
    -- then return the expected opacity of the parent frame
    if Addon:IsLinkedOpacityEnabled() then
        local anchor = self:GetSavedAnchor()
        if anchor and type(anchor.GetExpectedAlpha) == "function" then
            return anchor:GetExpectedAlpha()
        end
    end

    -- if there's a statealpha value for the frame, then use it
    local alpha = self:GetAttribute('state-alpha')
    if alpha then
        return alpha / 100
    end

    -- if the frame is moused over, then return the frame's normal opacity
    if self:IsFocus() then
        return self:GetFrameAlpha()
    end

    return self:GetFrameAlpha() * self:GetFadeMultiplier()
end

--------------------------------------------------------------------------------
-- Focus Checking
--------------------------------------------------------------------------------

local function isDescendant(frame, ancestor)
    if frame == nil then
        return false
    end

    if frame == ancestor then
        return true
    end

    if frame:IsForbidden() then
        return false
    end

    return isDescendant(frame:GetParent(), ancestor)
end

local function isFlyoutFocus(flyout, owner)
    if flyout and flyout:IsVisible() and flyout:IsMouseOver(1, -1, -1, 1) then
        return isDescendant(flyout, owner)
    end

    return false
end

local function isFocus(frame)
    if frame:IsForbidden() then
        return false
    end

    local focus = GetMouseFocus()

    -- not focused on a particular frame, check to see if the mouse is over
    -- either the frame itself, or a flyout owned by the frame
    if focus == WorldFrame then
        if frame:IsMouseOver(1, -1, -1, 1) then
            return true
        end

        if isFlyoutFocus(_G.SpellFlyout, frame) then
            return true
        end

        if isFlyoutFocus(Addon.SpellFlyout, frame) then
            return true
        end
    end

    return focus and isDescendant(focus, frame)
end

-- returns all frames docked to the given frame
function Frame:IsFocus()
    return isFocus(self) or (Addon:IsLinkedOpacityEnabled() and self:IfAnchored('IsFocus'))
end

--------------------------------------------------------------------------------
-- Fading
--------------------------------------------------------------------------------

function Frame:FadeIn()
    self:Fade(self:GetExpectedAlpha(), self:GetFadeInDelay(), self:GetFadeInDuration())
end

function Frame:FadeOut()
    self:Fade(self:GetExpectedAlpha(), self:GetFadeOutDelay(), self:GetFadeOutDuration())
end

function Frame:Fade(targetAlpha, delay, duration)
    Addon:Fade(self, targetAlpha, delay, duration)

    if Addon:IsLinkedOpacityEnabled() then
        self:ForAnchored('Fade', targetAlpha, delay, duration)
    end
end

--------------------------------------------------------------------------------
-- Frame Visibility
--------------------------------------------------------------------------------

function Frame:ShowFrame()
    self.sets.hidden = nil

    self:SetAttribute('state-hidden', nil)
    self:UpdateWatched()
    self:UpdateAlpha()

    if Addon:IsLinkedOpacityEnabled() then
        self:ForAnchored('ShowFrame')
    end
end

function Frame:HideFrame()
    self.sets.hidden = true

    self:SetAttribute('state-hidden', true)
    self:UpdateWatched()
    self:UpdateAlpha()

    if Addon:IsLinkedOpacityEnabled() then
        self:ForAnchored('HideFrame')
    end
end

function Frame:ToggleFrame()
    if self:FrameIsShown() then
        self:HideFrame()
    else
        self:ShowFrame()
    end
end

function Frame:FrameIsShown()
    return not self.sets.hidden
end

--------------------------------------------------------------------------------
-- Click Through
--------------------------------------------------------------------------------

function Frame:SetClickThrough(enable)
    self.sets.clickThrough = enable and true
    self:UpdateClickThrough()
end

function Frame:GetClickThrough()
    return self.sets.clickThrough
end

function Frame:UpdateClickThrough()
end

--------------------------------------------------------------------------------
-- Display Conditions - Override UI
--------------------------------------------------------------------------------

function Frame:ShowInOverrideUI(enable)
    self.sets.showInOverrideUI = (enable or self.id == "extra") and true --TODO 暂时强制打开

    self:SetAttribute('state-showinoverrideui', enable)
end

function Frame:ShowingInOverrideUI()
    return self.sets.showInOverrideUI
end

--------------------------------------------------------------------------------
-- Display Conditions - Pet Battle UI
--------------------------------------------------------------------------------

function Frame:ShowInPetBattleUI(enable)
    self.sets.showInPetBattleUI = enable and true
    self:SetAttribute('state-showinpetbattleui', enable)
end

function Frame:ShowingInPetBattleUI()
    return self.sets.showInPetBattleUI
end

--------------------------------------------------------------------------------
-- Display Conditions
--------------------------------------------------------------------------------

function Frame:GetDisplayConditions() end

function Frame:UpdateDisplayConditions()
    local conditions = self:GetDisplayConditions()

    if conditions and conditions ~= '' then
        RegisterStateDriver(self, 'display', conditions)
    else
        UnregisterStateDriver(self, 'display')

        if self:GetAttribute('state-display') then
            self:SetAttribute('state-display', nil)
        end
    end
end

--------------------------------------------------------------------------------
-- Display Conditions - User Set
--------------------------------------------------------------------------------

function Frame:SetUserDisplayConditions(states)
    self.sets.showstates = states
    self:UpdateUserDisplayConditions()
end

function Frame:GetUserDisplayConditions()
    local states = self.sets.showstates

    -- hack to convert [combat] into [combat]show;hide in case a user is using
    -- the old style of showstates
    if states then
        if states:sub(#states) == ']' then
            states = states .. 'show;hide'
            self.sets.showstates = states
        end
    end

    return states
end

function Frame:UpdateUserDisplayConditions()
    local states = self:GetUserDisplayConditions()

    if states and states ~= '' then
        RegisterStateDriver(self, 'userDisplay', states)
    else
        UnregisterStateDriver(self, 'userDisplay')

        if self:GetAttribute('state-userDisplay') then
            self:SetAttribute('state-userDisplay', nil)
        end
    end
end

--------------------------------------------------------------------------------
-- Positioning
--------------------------------------------------------------------------------

function Frame:SavePosition(point, relPoint, x, y)
    if point == nil then
        error('Usage: Frame:SavePosition(point, [relPoint, x, y]', 2)
    end

    if relPoint == point then
        relPoint = nil
    end

    if point == 'CENTER' then
        point = nil
    end

    x = tonumber(x) or 0
    if x == 0 then
        x = nil
    end

    y = tonumber(y) or 0
    if y == 0 then
        y = nil
    end

    local sets = self.sets
    sets.point = point
    sets.relPoint = relPoint
    sets.x = x
    sets.y = y
end

function Frame:GetSavedPosition()
    local sets = self.sets
    local point = sets.point or 'CENTER'
    local relPoint = sets.relPoint or point
    local x = sets.x or 0
    local y = sets.y or 0

    return point, relPoint,x, y
end

function Frame:SaveRelativePostiion()
    local point, relPoint, x, y = self:GetRelativePosition()

    self:SavePosition(point, relPoint, x, y)
end

function Frame:GetRelativePosition()
    local point, relPoint, x, y = FlyPaper.GetBestAnchorForParent(self)
    return point, relPoint, x, y
end

function Frame:RestorePosition()
    local point, relPoint, x, y = self:GetSavedPosition()
    local scale = self:GetFrameScale()

    self:ClearAllPoints()
    self:SetScale(scale)
    self:SetPoint(point, self:GetParent() or _G.UIParent, relPoint, x, y)

    --adding this here, as it will be be called by all frames, and Tuller seems to be considering layering to be a form of position now. ~Goranaws
    self:UpdateDisplayLevel()

    return true
end

--------------------------------------------------------------------------------
-- Anchoring
--------------------------------------------------------------------------------

function Frame:SaveAnchor(relFrame, point, relPoint, x, y)
    if relFrame == nil or point == nil then
        error('Usage: Frame:SaveAnchor(relFrame, point, [relPoint, x, y]', 2)
    end

    if relFrame == self then
        error('Cannot anchor to self', 2)
    end

    local relFrameGroup, relFrameId = FlyPaper.GetFrameInfo(relFrame)
    if relFrame == nil then
        error('Frame is not registered with FlyPaper', 2)
    end

    local anchor = self.sets.anchor
    if not anchor or type(anchor) == "string" then
        anchor = {}
        self.sets.anchor = anchor
    end

    -- purge defaults
    if relFrameGroup == AddonName then
        relFrameGroup = nil
    end

    if relPoint == point then
        relPoint = nil
    end

    x = tonumber(x) or 0
    if x == 0 then
        x = nil
    end

    y = tonumber(y) or 0
    if y == 0 then
        y = nil
    end

    anchor.point = point
    anchor.relFrame = relFrameId
    anchor.relFrameGroup = relFrameGroup
    anchor.relPoint = relPoint
    anchor.x = x
    anchor.y = y

    if not next(anchor) then
        self.sets.anchor = nil
    end
end

function Frame:GetSavedAnchor()
    local anchor = self.sets and self.sets.anchor

    if type(anchor) == 'table' then
        local point = anchor.point
        local relFrameId = anchor.relFrame
        local relFrameGroup = anchor.relFrameGroup or AddonName
        local relFrame = FlyPaper.GetFrame(relFrameGroup, relFrameId)
        local relPoint = anchor.relPoint or point
        local x = anchor.x or 0
        local y = anchor.y or 0

        return relFrame, point, relPoint, x, y
    end

    -- legacy string based format
    if type(anchor) == 'string' then
        local relFrame = Frame:Get(anchor:sub(1, #anchor - 2))
        local point, relPoint = FlyPaper.ConvertAnchorId(anchor:sub(#anchor - 1))
        local x = 0
        local y = 0

        return relFrame, point, relPoint, x, y
    end
end

function Frame:ClearSavedAnchor()
    self.sets.anchor = nil
end

function Frame:RestoreAnchor()
    local relFrame, point, relPoint, x, y = self:GetSavedAnchor()
    local scale = self:GetFrameScale() or 1

    if relFrame then
        self:ClearAllPoints()
        self:SetScale(scale)
        self:SetPoint(point, relFrame, relPoint, x, y)
        self:UpdateAlpha()
        return true
    end
end

function Frame:ForAnchored(method, ...)
    for _, frame in pairs(active) do
        if frame:IsAnchoredToFrame(self) then
            frame:MaybeCallMethod(method, ...)
        end
    end
end

function Frame:IfAnchored(method, ...)
    for _, frame in pairs(active) do
        if frame:IsAnchoredToFrame(self) then
            if frame:MaybeCallMethod(method, ...) then
                return true
            end
        end
    end

    return false
end

function Frame:IsAnchored()
    if self:GetSavedAnchor() then
        return true
    end
    return false
end

function Frame:IsAnchoredToFrame(frame)
    if frame == nil or frame == self then
        return false
    end

    for i = 1, self:GetNumPoints() do
        local _, relFrame = self:GetPoint(i)
        if frame == relFrame then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- Sticking/Snapping
--------------------------------------------------------------------------------

-- how far away a frame can be from another frame/edge to trigger anchoring
Frame.stickyTolerance = 8

function Frame:Stick()
    -- only do sticky code if the alt key is not currently down
    if Addon:Sticky() and not IsModifiedClick("DOMINOS_IGNORE_STICKY_FRAMES") then
        if self:StickToFrame() or self:StickToGrid() or self:StickToEdge() then
            return true
        end
    end

    self:ClearSavedAnchor()
    self:SaveRelativePostiion()
    return false
end

-- bar anchoring
function Frame:StickToFrame()
    local point, relFrame, relPoint = FlyPaper.GetBestAnchor(self, self.stickyTolerance)

    if point then
        self:ClearAllPoints()
        self:SetPoint(point, relFrame, relPoint)
        self:SaveAnchor(relFrame, point, relPoint)
        self:SaveRelativePostiion()

        return true
    end

    self:ClearSavedAnchor()
    return false
end

-- grid anchoring
function Frame:StickToGrid()
    if not Addon:GetAlignmentGridEnabled() then
        return false
    end

    local xScale, yScale = Addon:GetAlignmentGridScale()

    local point, relPoint, x, y = FlyPaper.GetBestAnchorForParentGrid(
        self,
        xScale,
        yScale,
        self.stickyTolerance
    )

    if point then
        self:ClearAllPoints()
        self:SetPoint(point, self:GetParent(), relPoint, x, y)

        self:SaveRelativePostiion()
        return true
    end

    return false
end

-- screen edge and center point anchoring
function Frame:StickToEdge()
    local point, relPoint, x, y = FlyPaper.GetBestAnchorForParent(self)
    local scale = self:GetScale()

    if point then
        local stick = false

        if math.abs(x * scale) <= self.stickyTolerance then
            x = 0
            stick = true
        end

        if math.abs(y * scale) <= self.stickyTolerance then
            y = 0
            stick = true
        end

        if stick then
            self:ClearAllPoints()
            self:SetPoint(point, self:GetParent(), relPoint, x, y)

            self:SaveRelativePostiion()
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------
-- Context Menus
--------------------------------------------------------------------------------

function Frame:CreateMenu()
    local menu = Addon:NewMenu()

    if menu then
        self:OnCreateMenu(menu)
        return menu
    end
end

function Frame:OnCreateMenu(menu)
    menu:AddBasicLayoutPanel()
    menu:AddFadingPanel()
    menu:AddAdvancedPanel(true)
end

function Frame:ShowMenu()
    local menu = self.menu
    if not menu then
        menu = self:CreateMenu()
        self.menu = menu
    end

    if menu then
        menu:Hide()
        menu:SetOwner(self)
        menu:ShowPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)
        menu:Show()
    end
end

--------------------------------------------------------------------------------
-- Display Information
--------------------------------------------------------------------------------

function Frame:GetDisplayName()
    return L.BarDisplayName:format(tostring(self.id):gsub('^%l', string.upper))
end

function Frame:GetDescription()
    return
end

function Frame:GetDisplayLayer()
    return self.sets.displayLayer or 'MEDIUM'
end

function Frame:SetDisplayLayer(layer)
    self.sets.displayLayer = layer
	self:UpdateDisplayLayer()
end

function Frame:UpdateDisplayLayer()
    local layer = self:GetDisplayLayer()

	self:SetFrameStrata(layer)

    fireBarCallback(self, 'BAR_DISPLAY_LAYER_UPDATED', layer)
end

function Frame:GetDisplayLevel()
    return self.sets.displayLevel or 1
end

function Frame:SetDisplayLevel(level)
    self.sets.displayLevel = tonumber(level) or 0
	self:UpdateDisplayLevel()
end

function Frame:UpdateDisplayLevel()
    local level = self:GetDisplayLevel()

	self:SetFrameLevel(level)

    fireBarCallback(self, 'BAR_DISPLAY_LEVEL_UPDATED', level)
end

--------------------------------------------------------------------------------
-- Mouseover
--------------------------------------------------------------------------------

function Frame:UpdateWatched()
    local watch = self:FrameIsShown()
              and self:GetFadeMultiplier() < 1
              and not (Addon:IsLinkedOpacityEnabled() and self:IsAnchored())

    if watch then
        Addon.FadeManager:Add(self)
    else
        Addon.FadeManager:Remove(self)
    end
end

--------------------------------------------------------------------------------
-- Metamethods
--------------------------------------------------------------------------------

function Frame:Get(id)
    return active[tonumber(id) or id]
end

function Frame:GetAll()
    return pairs(active)
end

function Frame:CallMethod(method, ...)
    local func = self[method]

    if type(func) == 'function' then
        return func(self, ...)
    else
        error(('Frame %s does not have a method named %q'):format(self.id, method), 2)
    end
end

function Frame:MaybeCallMethod(method, ...)
    local func = self[method]

    if type(func) == 'function' then
        return func(self, ...)
    end
end

function Frame:ForEach(method, ...)
    for _, frame in self:GetAll() do
        frame:MaybeCallMethod(method, ...)
    end
end

function Frame:All(method, ...)
    for _, frame in self:GetAll() do
        local func = self[method]

        if type(func) == 'function' and not func(frame, ...) then
            return false
        end
    end

    return true
end

function Frame:Any(method, ...)
    for _, frame in self:GetAll() do
        local func = self[method]

        if type(func) == 'function' and func(frame, ...) then
            return true
        end
    end

    return false
end

-- takes a frameId, and performs the specified action on that frame
-- this adds two special ids: 'all' for all frames and '<number>-<number>' for
-- a range of IDs
function Frame:ForFrame(id, method, ...)
    if id == 'all' then
        self:ForEach(method, ...)
    else
        local startID, endID = tostring(id):match('(%d+)-(%d+)')

        startID = tonumber(startID)
        endID = tonumber(endID)

        if startID and endID then
            if startID > endID then
                local t = startID
                startID = endID
                endID = t
            end

            for i = startID, endID do
                local f = self:Get(i)
                if f then
                    f:MaybeCallMethod(method, ...)
                end
            end
        else
            local f = self:Get(id)
            if f then
                f:MaybeCallMethod(method, ...)
            end
        end
    end
end

-- exports
Addon.Frame = Frame
