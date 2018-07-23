
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('Owner', 1)
if not View then
    return
end

function View:GetOwner()
    return self.owner
end

function View:SetOwner(owner)
    self.owner = owner
end
