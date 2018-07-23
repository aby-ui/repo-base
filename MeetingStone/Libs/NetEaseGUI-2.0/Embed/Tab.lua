
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('Tab', 1)
if not View then
    return
end

View._Objects = View._Objects or {}
View._Owners = View._Owners or {}

local _Objects = View._Objects
local _Owners = View._Owners

local function GetNextInputBox(target, inputBox)
    local index = inputBox:GetID()
    if index then
        local count = #_Objects[target]
        local i = index
        local object
        repeat
            i = i % count + 1
            object = _Objects[target][i]
            if object:IsVisible() and object:IsEnabled() then
                return object
            end
        until i == index
    end
    return inputBox
end

local function GetPrevInputBox(target, inputBox)
    local index = inputBox:GetID()
    if index then
        local count = #_Objects[target]
        local i = index
        local object
        repeat
            i = i == 1 and count or i - 1
            object = _Objects[target][i]
            if object:IsVisible() and object:IsEnabled() then
                return object
            end
        until i == index
    end
end

local function OnTabPressed(self)
    local owner = _Owners[self]
    if owner then
        if IsShiftKeyDown() then
            GetPrevInputBox(owner, self):SetFocus()
        else
            GetNextInputBox(owner, self):SetFocus()
        end
    end
end

function View:RegisterInputBox(inputBox)
    tinsert(_Objects[self], inputBox)

    _Owners[inputBox] = self

    inputBox:SetID(#_Objects[self])
    inputBox:SetScript('OnTabPressed', OnTabPressed)
end

function View:IterateInputBoxes()
    return ipairs(_Objects[self])
end

function View:ClearInputBoxFocus()
    for _, inputBox in self:IterateInputBoxes() do
        inputBox:ClearFocus()
    end
end

function View:OnEmbed(target)
    _Objects[target] = _Objects[target] or {}
end
