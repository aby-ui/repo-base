
local GUI = tdCore('GUI')
local L = tdCore:GetLocale('tdCore')

local ListWidgetButton = GUI:NewModule('ListWidgetButton', CreateFrame('Button'), 'UIObject')

local ListButtonTexture = {
    Add = [[Interface\AddOns\tdCore\gui\media\add.tga]],
    Delete = [[Interface\AddOns\tdCore\gui\media\delete.tga]],
    SelectAll = [[Interface\AddOns\tdCore\gui\media\all.tga]],
    SelectNone = [[Interface\AddOns\tdCore\gui\media\none.tga]],
}

local ListButtonNote = {
    Add = ADD,
    Delete = DELETE,
    SelectAll = L['Select all'],
    SelectNone = L['Select none']
}

function ListWidgetButton:New(parent, args)
    local handle, icon, note
    if type(args) == 'string' then
        assert(GUI.ListButton[args], 'Bad argument')
        handle = args
    elseif type(args) == 'table' then
        assert(args.handle, 'Bad argument')
        handle = args.handle
        icon = args.icon
        note = args.note
    end
    
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    
    obj.handle = 'On' .. handle
    
    obj:SetScript('OnClick', self.OnClick)
    obj:SetNote(note or ListButtonNote[handle])
    
    obj:SetNormalTexture(icon or ListButtonTexture[handle])
    obj:SetHighlightTexture(icon or ListButtonTexture[handle])
    
    return obj
end

function ListWidgetButton:OnClick()
    self:GetParent():RunHandle(self.handle)
end
