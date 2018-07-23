
local GUI = LibStub('NetEaseGUI-2.0')

GUI._SpecialFrames = GUI._SpecialFrames or {}
GUI.SpecialHandler = GUI.SpecialHandler or {}

local _SpecialFrames = GUI._SpecialFrames
local SpecialHandler = GUI.SpecialHandler

_G['NetEaseSpecialWindowsHandler'] = SpecialHandler

if not tContains(UISpecialFrames, 'NetEaseSpecialWindowsHandler') then
    tinsert(UISpecialFrames, 'NetEaseSpecialWindowsHandler')
end

local Class = LibStub('LibClass-2.0')

function GUI:RegisterUIPanel(frame)
    if not Class:IsWidget(frame) then
        return
    end
    _SpecialFrames[frame] = true
end

function GUI:UnregisterUIPanel(frame)
    if not Class:IsWidget(frame) then
        return
    end
    _SpecialFrames[frame] = nil
end

function SpecialHandler:IsShown()
    local found
    for frame in pairs(_SpecialFrames) do
        if frame:IsShown() then
            frame:Hide()
            found = true
        end
    end
    return found
end

SpecialHandler.Hide = nop
