-- 因为TMW和WA都用了非常多的MasqueGroupAPI,所以实时加载太困难,基本等于重写一个了,所以此代码已经从!!!163UI!!!引用里去掉了
do
    if select(5, GetAddOnInfo("Masque"))=="MISSING" then return end
    if GetAddOnEnableState(U1PlayerName,"TellMeWhen")>=2 then return end
    if GetAddOnEnableState(U1PlayerName,"WeakAuras")>=2 then return end
end

local Masque = LibStub:NewLibrary("Masque", 80199);
if not Masque then return end

--local function AddButton(self, Button, ButtonData)
--    self[3] = self[3] or {};
--    table.insert(self[3], {Button, ButtonData});
--end
local dummy_group_meta = {
    __index = {
        AddButton = function(self, Button, ButtonData)
            self[Button] = (ButtonData == nil) and true
        end,
        RemoveButton = function(self, Button)
            self[Button] = nil
        end,
    }
}

do
    -- add all api as dummy funcs
    local dummy_func = function() end
    local dummies = {
        'Disable',
        'ReSkin',
        'GetLayer',
        'GetColor',
        'Enable',
        'SetOption',
        'SetColor',
        'Reset',
        'Update',
        'GetOptions',
        'GetLayerColor',
        'AddSubGroup',
        'RemoveSubGroup',
        'SetLayerColor',
        'Skin',
        'ResetColors',
    }

    for _, k in next, dummies do
        dummy_group_meta.__index[k] = dummy_func
    end
end

local btngrps = {}
local skins = {}

local get_id = function(addon, group)
    local id
    if(type(addon) == 'string') then
        id = addon
        if(type(group) == 'string') then
            id = addon .. '_' .. group
        end
    end
    return id
end

function Masque:Group(addon, group)
    local id = get_id(addon, group)
    if(id) then
        local g = btngrps[id]
        if(not g) then
            g = setmetatable({}, dummy_group_meta)
            btngrps[id] = g
        end
        return g
    end
end

function Masque:AddSkin(id, data, replace)
    if(skins[id] and not replace) then
        return
    end
    skins[id] = data
end

local registerCache = {}
function Masque:Register(addon, func, arg)
    table.insert(registerCache, {addon, func, arg});
end

Masque.GetBackdrop = noop
Masque.GetNormal = noop
Masque.GetGloss = noop
Masque.AddSpellAlert = noop

CoreDependCall("Masque", function()
    local Masque = LibStub'Masque'
    if DEBUG_MODE then print("!!!163UI!!!/plugin/MasqueDummy: register skins to [Masque]") end

    for id, btns in next, btngrps do
        local addon, group = string.split('_', id, 2)
        local g = Masque:Group(addon, group)
        for btn, btndata in next, btns do
            g:AddButton(btn, (btndata~=true and btndata))
        end
        wipe(btns)
    end
    wipe(btngrps)

    for skinid, skindata in next, skins do
        Masque:AddSkin(skinid, skindata, true --[[ force replace ]])
    end

    for _, args in ipairs(registerCache) do
        Masque:Register(args[1], args[2], args[3])
    end
end)
