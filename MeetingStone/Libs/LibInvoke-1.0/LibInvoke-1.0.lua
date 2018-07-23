--[[
@Date    : 2016-06-15 16:42:46
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : 2
]]

local MAJOR, MINOR = 'LibInvoke-1.0', 2
local Invoke, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not Invoke then return end

Invoke.embeds = Invoke.embeds or {}

function Invoke:Embed(target)
    target.Invoke = setmetatable({}, {__newindex = function(t, k, v)
        if type(v) ~= 'function' then
            error('You can only Invoke function', 2)
        end

        target[k] = function(self, ...)
            local args = {...}
            local argCount = select('#', ...)

            C_Timer.After(0, function()
                v(self, unpack(args, 1, argCount))
            end)
        end
    end})

    target.InvokeOnce = setmetatable({}, {__newindex = function(t, k, v)
        if type(v) ~= 'function' then
            error('You can only InvokeOnce function', 2)
        end

        local timer = nil

        target[k] = function(self, ...)
            local args = {...}
            local argCount = select('#', ...)

            if timer then
                return
            end

            timer = C_Timer.NewTimer(0.01, function()
                timer = nil
                v(self, unpack(args, 1, argCount))
            end)
        end
    end})

    self.embeds[target] = true
end

for target in pairs(Invoke.embeds) do
    Invoke:Embed(target)
end
