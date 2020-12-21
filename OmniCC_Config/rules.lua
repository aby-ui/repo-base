local _, Addon = ...
local OmniCC = _G.OmniCC
local L = LibStub("AceLocale-3.0"):GetLocale("OmniCC")

local function getThemeOptions()
    local options = {}
    for id, theme in OmniCC:GetThemes() do
        options[id] = theme.name or id
    end
    return options
end

local function parsePatterns(text)
    local results = {strsplit("\n", text)}

    -- trim all values
    for k, v in pairs(results) do
        results[k] = strtrim(v)
    end

    for i = #results, 1, -1 do
        local v = results[i]

        -- remove blank values and duplicates
        if v == "" or tIndexOf(results, v) ~= i then
            tremove(results, i)
        end
    end

    return results
end

local function addRulesetOption(owner, rule)
    if not rule.id then return end

    local key = "rule_" .. rule.id

    owner.args[key] = {
        type = "group",
        name = rule.name or rule.id,
        order = function()
            return rule.priority
        end,
        args = {
            enable = {
                name = L.RuleEnable,
                desc = L.RuleEnableDesc,
                order = 1,
                type = "toggle",
                width = "full",
                get = function()
                    return rule.enabled
                end,
                set = function(_, val)
                    rule.enabled = val
                    OmniCC.Cooldown:ForAll("UpdateSettings")
                    OmniCC.Display:ForActive("UpdateCooldownText")
                end
            },
            theme = {
                name = L.RuleTheme,
                desc = L.RuleThemeDesc,
                order = 2,
                type = "select",
                get = function()
                    return rule.theme
                end,
                set = function(_, val)
                    rule.theme = val
                    OmniCC.Cooldown:ForAll("UpdateSettings")
                    OmniCC.Display:ForActive("UpdateCooldownText")
                end,
                values = getThemeOptions
            },
            patterns = {
                name = L.RulePatterns,
                desc = L.RulePatternsDesc,
                order = 3,
                type = "input",
                width = "full",
                multiline = true,
                get = function()
                    return table.concat(rule.patterns, "\n")
                end,
                set = function(_, val)
                    rule.patterns = parsePatterns(val)
                    OmniCC.Cooldown:ForAll("UpdateSettings")
                    OmniCC.Display:ForActive("UpdateCooldownText")
                end,
                validate = function(_, val)
                    return val and true
                end
            },
            priority = {
                name = L.RulePriority,
                desc = L.RulePriorityDesc,
                order = 10,
                type = "range",
                width = "full",
                min = 0,
                max = 100,
                step = 1,
                get = function()
                    return rule.priority
                end,
                set = function(_, val)
                    OmniCC:SetRulePriority(rule.id, val + 0.5)
                    OmniCC.Cooldown:ForAll("UpdateSettings")
                    OmniCC.Display:ForActive("UpdateCooldownText")
                end
            },
            remove = {
                name = L.RuleRemove,
                desc = L.RuleRemoveDesc,
                order = 200,
                type = "execute",
                func = function()
                    if OmniCC:RemoveRule(rule.id) then
                        owner.args[key] = nil
                        OmniCC.Cooldown:ForAll("UpdateSettings")
                        OmniCC.Display:ForActive("UpdateCooldownText")
                    end
                end
            }
        }
    }
end

local RuleOptions = {
    type = "group",
    name = L.Rules,
    args = {
        description = {
            type = "description",
            name = L.RulesDesc,
            order = 0
        }
    }
}

RuleOptions.args.add = {
    type = "input",
    order = 1000,
    name = L.RuleAdd,
    desc = L.RuleAddDesc,
    width = "double",
    set = function(_, val)
        val = strtrim(val)

        local rule = OmniCC:AddRule(val)
        if rule then
            addRulesetOption(RuleOptions, rule)
        end
    end,
    validate = function(_, val)
        return strtrim(val) and not OmniCC:HasRule(val)
    end
}

function Addon:RefreshRuleOptions()
    for key in pairs(RuleOptions.args) do
        if key:match("^rule_") then
            RuleOptions.args[key] = nil
        end
    end

    for _, rule in OmniCC:GetRulesets() do
        addRulesetOption(RuleOptions, rule)
    end
end

Addon:RefreshRuleOptions()
Addon.RuleOptions = RuleOptions
