--[[
	rules.lua
		Rulesets settings menu
--]]

local CONFIG, Config = ...
if not Config.supportRules then return end

local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local Rules = Addon.GeneralOptions:New('RuleOptions', CreateAtlasMarkup('None'))
Rules.Expandable, Rules.Expanded = {}, {}

function Rules:Populate()
  self.sets = Addon.profile[self.frame]
  self:AddFrameChoice()

  local faux = self:Add('FauxScroll', 12, 26)
  faux.top = 10
  faux:SetWidth(605)
  faux:SetChildren(function(faux)
    local list = self:GetList()
    faux:SetNumEntries(#list)

    for i = faux:First(), faux:Last() do
      local rule = list[i]
      local b = faux:Add('ExpandCheck', rule.icon and format('|T%s:26|t %s', rule.icon, rule.name) or rule.name)
      b:SetExpanded(self.Expandable[rule.id], self.Expanded[rule.id])
      b:SetCall('OnExpand', function() self:Expand(rule.id) end)
      b:SetCall('OnClick', function() self:Toggle(rule.id) end)
      b:SetChecked(not self.sets.hiddenRules[rule.id])

      b.left = b.left + (select('#', strsplit('/', rule.id)) - 1) * 20
    end
  end)
end

function Rules:Toggle(id)
  local i = tIndexOf(self.sets.rules, id)
  if i then
    tremove(self.sets.rules, i)
  else
    tinsert(self.sets.rules, id)
  end

  self.sets.hiddenRules[id] = i and true or false
  Addon.Frames:Update()
end

function Rules:Expand(id)
  self.Expanded[id] = not self.Expanded[id]
end

function Rules:GetList()
  local list = {}
  local function add(rule)
    tinsert(list, rule)

    for i, subrule in pairs(rule.children) do
      if self.Expanded[rule.id] then
        add(subrule)
      else
        self.Expandable[rule.id] = true
      end
    end
  end

  for i, rule in Addon.Rules:IterateParents() do
    add(rule)
  end
  return list
end
