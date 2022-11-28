--[[
Copyright 2022-2022 João Cardoso
C_Everywhere is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

This file is part of C_Everywhere.
--]]

local C = LibStub:NewLibrary('C_Everywhere', 2)
if C then
  wipe(C)
else
  return
end

setmetatable(C, {__index = function(C, space)
  local target = _G['C_' .. space]
  local container = {}

  setmetatable(container, {__index = function(container, k)
    local f = container.rawfind(k)
    container[k] = f
    return f
  end})

  container.rawfind = function(k) return target and target[k] or _G[k] end
  container.locate = function(k) return target and target[k] and target or _G end
  container.hooksecurefunc = function(k, f) hooksecurefunc(container.locate(k), k, f) end
  C[space] = container
  return container
end})

local function pack(space, k, args)
  local f = space.rawfind(k)
  if f then
    space[k] = function(...)
      local data = f(...)
      if data ~= nil then
        if type(data) == 'table' then
          space[k] = f
          return data
        else
          local first = args:match('^%s*([^,]+)')
          local assignment = {}
          for _, arg in ipairs{strsplit(',', args)} do
            tinsert(assignment, arg .. '=' .. arg)
          end

          local packer = loadstring(format([[
            return function(...)
              local %s = f(...)
              if %s ~= nil then
                return {%s}
              end
            end
          ]], args, first, strjoin(',', unpack(assignment)), first))

          setfenv(packer, {f = f})
          space[k] = packer()
          return space[k](...)
        end
      end
    end
  end
end

pack(C.Container, 'GetContainerItemInfo', 'iconFileID, stackCount, isLocked, quality, isReadable, hasLoot, hyperlink, isFiltered, hasNoValue, itemID, isBound')
pack(C.Container, 'GetContainerItemPurchaseInfo', 'money, itemCount, refundSeconds, currencyCount, hasEnchants')
pack(C.Container, 'GetContainerItemQuestInfo', 'isQuestItem, questID, isActive')
pack(C.CurrencyInfo, 'GetBackpackCurrencyInfo', 'name, quantity, iconFileID, currencyTypesID')
pack(C.CurrencyInfo, 'GetCurrencyInfo', 'name, quantity, iconFileID, quantityEarnedThisWeek, maxWeeklyQuantity, maxQuantity, discovered, quality')
pack(C.CurrencyInfo, 'GetCurrencyListInfo', 'name, isHeader, isHeaderExpanded, isTypeUnused, isShowInBackpack, quantity, iconFileID, maxQuantity, canEarnPerWeek, quantityEarnedThisWeek, discovered')
