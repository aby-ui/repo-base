
local DropMenu = LibStub:NewLibrary('NetEaseGUI-2.0.DropMenu', 1)
if not DropMenu then
    return
end

local GUI = LibStub('NetEaseGUI-2.0')

if DropMenu.PublicDropMenu then
    DropMenu.PublicDropMenu:Hide()
end

DropMenu.PublicDropMenu = GUI:GetClass('DropMenu'):New(nil, 'MENU')

function GUI:OpenMenu(owner, menuTable, ...)
    DropMenu.PublicDropMenu:Open(1, menuTable, owner, ...)
end

function GUI:ToggleMenu(owner, menuTable, ...)
    DropMenu.PublicDropMenu:Toggle(1, menuTable, owner, ...)
end

function GUI:CloseMenu()
    DropMenu.PublicDropMenu:Close(1)
end

function GUI:RefreshMenu(level)
    DropMenu.PublicDropMenu:RefreshMenu(level)
end