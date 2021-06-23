--[[
	sorting.lua
		Client side bag sorting algorithm
--]]

local ADDON, Addon = ...
local Search = LibStub('LibItemSearch-1.2')
local Sort = Addon:NewModule('Sorting', 'MutexDelay-1.0')

Sort.Proprieties = {
  'set',
  'class', 'subclass', 'equip',
  'quality',
  'icon',
  'level', 'name', 'id',
  'count'
}


--[[ Process ]]--

function Sort:Start(owner, bags)
  if not self:CanRun() then
    return
  end

  self.owner, self.bags = owner, bags
  self:SendSignal('SORTING_STATUS', owner, bags)
  self:Run()
end

function Sort:Run()
  if self:CanRun() then
    ClearCursor()
    self:Iterate()
  else
    self:Stop()
  end
end

function Sort:Iterate()
  local spaces = self:GetSpaces()
  local families = self:GetFamilies(spaces)

  local stackable = function(item)
    return (item.count or 1) < (item.stack or 1)
  end

  for k, target in pairs(spaces) do
    local item = target.item
    if item.id and stackable(item) then
      for j = k+1, #spaces do
        local from = spaces[j]
        local other = from.item

        if item.id == other.id and stackable(other) then
          self:Move(from, target)
          self:Delay(0.05, 'Run')
        end
      end
    end
  end

  local moveDistance = function(item, goal)
    return math.abs(item.space.index - goal.index)
  end

  for _, family in pairs(families) do
    local order, spaces = self:GetOrder(spaces, family)
    local n = min(#order, #spaces)

    for index = 1, n do
      local item, goal = order[index], spaces[index]
      if item.space ~= goal then
        local distance = moveDistance(item, goal)

        for j = index, n do
          local other = order[j]
          if other.id == item.id and other.count == item.count then
            local d = moveDistance(other, spaces[j])
            if d > distance then
              item = other
              distance = d
            end
          end
        end

        self:Move(item.space, goal)
        self:Delay(0.05, 'Run')
      else
        item.placed = true
      end
    end
  end

  if not self:Delaying('Run') then
    self:Stop()
  end
end

function Sort:Stop()
  self:SendSignal('SORTING_STATUS')
end


--[[ Data Structures ]]--

function Sort:GetSpaces()
  local spaces = {}

  for _, bag in pairs(self.bags) do
    local container = Addon:GetBagInfo(self.owner, bag)
    for slot = 1, (container.count or 0) do
      local item = Addon:GetItemInfo(self.owner, bag, slot)
      tinsert(spaces, {index = #spaces, bag = bag, slot = slot, family = container.family, item = item})

      item.class = item.link and Search:ForQuest(item.link) and LE_ITEM_CLASS_QUESTITEM or item.class
      item.set = item.link and Search:InSet(item.link) and 0 or 1
      item.space = spaces[#spaces]
    end
  end

  return spaces
end

function Sort:GetFamilies(spaces)
  local families = {}
  for _, space in pairs(spaces) do
    families[space.family] = true
  end

  local sorted = {}
  for family in pairs(families) do
    tinsert(sorted, family)
  end

  sort(sorted, function(a, b) return a > b end)
  return sorted
end

function Sort:GetOrder(spaces, family)
  local order, slots = {}, {}

  for _, space in ipairs(spaces) do
    local item = space.item
    if item.id and not item.placed and self:FitsIn(item.id, family) then
      tinsert(order, space.item)
    end

    if space.family == family then
      tinsert(slots, space)
    end
  end

  sort(order, self.Rule)
  return order, slots
end


--[[ API ]]--

function Sort:CanRun()
  return not InCombatLockdown() and not UnitIsDead('player')
end

function Sort:FitsIn(id, family)
  return
    family == 0 or
    (family == 9 and GetItemFamily(id) == 256) or
    (Addon.IsRetail and bit.band(GetItemFamily(id), family) > 0 or GetItemFamily(id) == family) and select(9, GetItemInfo(id)) ~= 'INVTYPE_BAG'
end

function Sort.Rule(a, b)
  for _,prop in pairs(Sort.Proprieties) do
    if a[prop] ~= b[prop] then
      return a[prop] > b[prop]
    end
  end

  if a.space.family ~= b.space.family then
    return a.space.family > b.space.family
  end
  return a.space.index < b.space.index
end

function Sort:Move(from, to)
  if from.locked or to.locked then
    return
  end

  Addon:PickupItem(self.owner, from.bag, from.slot)
  Addon:PickupItem(self.owner, to.bag, to.slot)

  from.locked = true
  to.locked = true
  return true
end
