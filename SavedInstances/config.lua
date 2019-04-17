local addonName, addon = ...
local core = addon.core
local L = addon.L
addon.config = core:NewModule("Config")
local Config = addon.config

-- Lua functions
local pairs, ipairs, tonumber, tostring, wipe = pairs, ipairs, tonumber, tostring, wipe
local unpack, date, type, tinsert, sort = unpack, date, type, tinsert, sort
local _G = _G

-- WoW API / Variables
local GetBindingKey = GetBindingKey
local GetCurrencyInfo = GetCurrencyInfo
local GetCurrentBindingSet = GetCurrentBindingSet
local GetRealmName = GetRealmName
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local SaveBindings = SaveBindings
local SetBinding = SetBinding
local StaticPopup_Show = StaticPopup_Show
local ALL = ALL
local COLOR = COLOR
local CURRENCY = CURRENCY
local DELETE = DELETE
local EMBLEM_SYMBOL = EMBLEM_SYMBOL
local GREEN_FONT_COLOR_CODE = GREEN_FONT_COLOR_CODE
local LEVEL = LEVEL
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE

-- GLOBALS: LibStub, BINDING_NAME_SAVEDINSTANCES, BINDING_HEADER_SAVEDINSTANCES

addon.diff_strings = {
  D1 = DUNGEON_DIFFICULTY1, -- 5 man
  D2 = DUNGEON_DIFFICULTY2, -- 5 man (Heroic)
  D3 = DUNGEON_DIFFICULTY1.." ("..GetDifficultyInfo(23)..")", -- 5 man (Mythic)
  R0 = EXPANSION_NAME0 .. " " .. LFG_TYPE_RAID,
  R1 = RAID_DIFFICULTY1, -- "10 man"
  R2 = RAID_DIFFICULTY2, -- "25 man"
  R3 = RAID_DIFFICULTY3, -- "10 man (Heroic)"
  R4 = RAID_DIFFICULTY4, -- "25 man (Heroic)"
  R5 = GetDifficultyInfo(7), -- "Looking for Raid"
  R6 = GetDifficultyInfo(14), -- "Normal raid"
  R7 = GetDifficultyInfo(15), -- "Heroic raid"
  R8 = GetDifficultyInfo(16), -- "Mythic raid"
}

local FONTEND = FONT_COLOR_CODE_CLOSE
local GOLDFONT = NORMAL_FONT_COLOR_CODE

-- config global functions

function Config:OnInitialize()
  Config:SetupOptions()
end

BINDING_NAME_SAVEDINSTANCES = L["Show/Hide the SavedInstances tooltip"]
BINDING_HEADER_SAVEDINSTANCES = "SavedInstances"

-- general helper functions

function addon:idtext(instance,diff,info)
  if instance.WorldBoss then
    return L["World Boss"]
  elseif info.ID < 0 then
    return "" -- ticket 144: could be RAID_FINDER or FLEX_RAID, but this is already shown in the instance name so it's redundant anyhow
  elseif not instance.Raid then
    if diff == 23 then
      return addon.diff_strings["D3"]
    else
      return addon.diff_strings["D"..diff]
    end
  elseif instance.Expansion == 0 then -- classic Raid
    return addon.diff_strings.R0
  elseif instance.Raid and diff >= 3 and diff <= 7 then -- pre-WoD raids
    return addon.diff_strings["R"..(diff-2)]
  elseif diff >= 14 and diff <= 16 then -- WoD raids
    return addon.diff_strings["R"..(diff-8)]
  else
    return ""
  end
end

local function TableLen(table)
  local i = 0
  for _, _ in pairs(table) do
    i = i + 1
  end
  return i
end

local function IndicatorOptions()
  local args = {
    Instructions = {
      order = 1,
      type = "description",
      name = L["You can combine icons and text in a single indicator if you wish. Simply choose an icon, and insert the word ICON into the text field. Anywhere the word ICON is found, the icon you chose will be substituted in."].." "..L["Similarly, the words KILLED and TOTAL will be substituted with the number of bosses killed and total in the lockout."],
    },
  }
  for diffname, diffstr in pairs(addon.diff_strings) do
    local dorder = (tonumber(diffname:match("%d+")) or 0) + 10
    if diffname:find("^R") then dorder = dorder + 10 end
    args[diffname] = {
      type = "group",
      name = diffstr,
      order = dorder,
      args = {
        [diffname.."Indicator"] = {
          order = 1,
          type = "select",
          width = "half",
          name = EMBLEM_SYMBOL,
          values = addon.Indicators
        },
        [diffname.."Text"] = {
          order = 2,
          type = "input",
          name = L["Text"],
          multiline = false
        },
        [diffname.."Color"] = {
          order = 3,
          type = "color",
          width = "half",
          hasAlpha = false,
          name = COLOR,
          disabled = function()
            return addon.db.Indicators[diffname .. "ClassColor"]
          end,
          get = function(info)
            addon.db.Indicators[info[#info]] = addon.db.Indicators[info[#info]] or addon.defaultDB.Indicators[info[#info]]
            local r = addon.db.Indicators[info[#info]][1]
            local g = addon.db.Indicators[info[#info]][2]
            local b = addon.db.Indicators[info[#info]][3]
            return r, g, b, nil
          end,
          set = function(info, r, g, b, ...)
            addon.db.Indicators[info[#info]][1] = r
            addon.db.Indicators[info[#info]][2] = g
            addon.db.Indicators[info[#info]][3] = b
          end,
        },
        [diffname.."ClassColor"] = {
          order = 4,
          type = "toggle",
          name = L["Use class color"]
        },
      },
    }
  end
  return args
end

-- options table below
function Config:BuildOptions()
  local valueslist = { ["always"] = GREEN_FONT_COLOR_CODE..L["Always show"]..FONTEND,
    ["saved"] = L["Show when saved"],
    ["never"] = RED_FONT_COLOR_CODE..L["Never show"]..FONTEND,
  }
  local opts = {
    type = "group",
    name = "SavedInstances",
    handler = addon,
    get = function(info)
      return addon.db.Tooltip[info[#info]]
    end,
    set = function(info, value)
      addon.debug(info[#info].." set to: "..tostring(value))
      addon.db.Tooltip[info[#info]] = value
      wipe(addon.scaleCache)
      wipe(addon.oi_cache)
      addon.oc_cache = nil
    end,
    args = {
      config = {
        name = L["Open config"],
        guiHidden = true,
        type = "execute",
        func = function() Config:ShowConfig() end,
      },
      time = {
        name = L["Dump time debugging information"],
        guiHidden = true,
        type = "execute",
        func = function() addon:timedebug() end,
      },
      quest = {
        name = L["Dump quest debugging information"],
        guiHidden = true,
        type = "execute",
        func = function(...) addon:questdebug(...) end,
      },
      show = {
        name = L["Show/Hide the SavedInstances tooltip"],
        guiHidden = true,
        type = "execute",
        func = function() addon:ToggleDetached() end,
      },
      General = {
        order = 1,
        type = "group",
        name = L["General settings"],
        args = {
          ver = {
            order = 0.5,
            type = "description",
            name = function() return "Version: SavedInstances "..addon.version end,
          },
          GeneralHeader = {
            order = 2,
            type = "header",
            name = L["General settings"],
          },
          MinimapIcon = {
            type = "toggle",
            name = L["Show minimap button"],
            desc = L["Show the SavedInstances minimap button"],
            order = 3,
            hidden = function() return not addon.icon end,
            get = function(info) return not addon.db.MinimapIcon.hide end,
            set = function(info, value)
              addon.db.MinimapIcon.hide = not value
              addon.icon:Refresh(addonName)
            end,
          },
          DisableMouseover = {
            type = "toggle",
            name = L["Disable mouseover"],
            desc = L["Disable tooltip display on icon mouseover"],
            order = 3.5,
          },
          ShowHints = {
            type = "toggle",
            name = L["Show tooltip hints"],
            order = 4,
          },
          ReportResets = {
            type = "toggle",
            name = L["Report instance resets to group"],
            order = 4.5,
          },
          LimitWarn = {
            type = "toggle",
            name = L["Warn about instance limit"],
            order = 4.7,
          },
          HistoryText = {
            type = "toggle",
            name = L["Instance limit in Broker"],
            order = 4.8,
          },
          AbbreviateKeystone = {
            type = "toggle",
            name = L["Abbreviate keystones"],
            desc = L["Abbreviate Mythic keystone dungeon names"],
            order = 4.85
          },
          DebugMode = {
            type = "toggle",
            name = L["Debug Mode"],
            order = 4.9,
          },

          CategoriesHeader = {
            order = 11,
            type = "header",
            name = L["Categories"],
          },
          ShowCategories = {
            type = "toggle",
            name = L["Show category names"],
            desc = L["Show category names in the tooltip"],
            order = 12,
          },
          ShowSoloCategory = {
            type = "toggle",
            name = L["Single category name"],
            desc = L["Show name for a category when all displayed instances belong only to that category"],
            order = 13,
            disabled = function()
              return not addon.db.Tooltip.ShowCategories
            end,
          },
          CategorySpaces = {
            type = "toggle",
            name = L["Space between categories"],
            desc = L["Display instances with space inserted between categories"],
            order = 14,
          },
          CategorySort = {
            order = 15,
            type = "select",
            name = L["Sort categories by"],
            values = {
              ["EXPANSION"] = L["Expansion"],
              ["TYPE"] = L["Type"],
            },
          },
          NewFirst = {
            type = "toggle",
            name = L["Most recent first"],
            desc = L["List categories from the current expansion pack first"],
            order = 16,
          },
          RaidsFirst = {
            type = "toggle",
            name = L["Raids before dungeons"],
            desc = L["List raid categories before dungeon categories"],
            order = 17,
          },
          FitToScreen = {
            type = "toggle",
            name = L["Fit to screen"],
            desc = L["Automatically shrink the tooltip to fit on the screen"],
            order = 4.81,
          },
          Scale = {
            type = "range",
            name = L["Tooltip Scale"],
            order = 4.82,
            min = 0.1,
            max = 5,
            bigStep = 0.05,
          },
          RowHighlight = {
            type = "range",
            name = L["Row Highlight"],
            desc = L["Opacity of the tooltip row highlighting"],
            order = 4.83,
            min = 0,
            max = 0.5,
            bigStep = 0.1,
            isPercent = true,
          },
          InstancesHeader = {
            order = 20,
            type = "header",
            name = L["Instances"],
          },
          ReverseInstances = {
            type = "toggle",
            name = L["Reverse ordering"],
            desc = L["Display instances in order of recommended level from lowest to highest"],
            order = 23,
          },
          ShowExpired = {
            type = "toggle",
            name = L["Show Expired"],
            desc = L["Show expired instance lockouts"],
            order = 23.5,
          },
          ShowHoliday = {
            type = "toggle",
            name = L["Show Holiday"],
            desc = L["Show holiday boss rewards"],
            order = 23.65,
          },
          ShowRandom = {
            type = "toggle",
            name = L["Show Random"],
            desc = L["Show random dungeon bonus reward"],
            order = 23.75,
          },
          CombineWorldBosses = {
            type = "toggle",
            name = L["Combine World Bosses"],
            desc = L["Combine World Bosses"],
            order = 23.85,
          },
          CombineLFR = {
            type = "toggle",
            name = L["Combine LFR"],
            desc = L["Combine LFR"],
            order = 23.95,
          },
          ProgressHeader = {
            order = 31,
            type = "header",
            name = L["Quest progresses"],
          },
          WarfrontHeader = {
            order = 33,
            type = "header",
            name = L["Warfronts"],
          },
          EmissaryHeader = {
            order = 36,
            type = "header",
            name = L["Emissary quests"],
          },
          EmissaryFullName = {
            type = "toggle",
            order = 39.1,
            name = L["Show all emissary names"],
            desc = L["Show both factions' emissay name"],
          },
          EmissaryShowCompleted = {
            type = "toggle",
            order = 39.2,
            name = L["Show when completed"],
            desc = L["Show emissary line when all quests completed"],
          },
          CombineEmissary = {
            type = "toggle",
            order = 39.3,
            name = L["Combine Emissaries"],
            desc = L["Combine emissaries of same expansion"],
          },
          MiscHeader = {
            order = 40,
            type = "header",
            name = L["Miscellaneous Tracking"],
          },
          TrackDailyQuests = {
            type = "toggle",
            order = 43,
            name = L["Daily Quests"],
          },
          TrackWeeklyQuests = {
            type = "toggle",
            order = 43.5,
            name = L["Weekly Quests"],
          },
          TrackSkills = {
            type = "toggle",
            order = 43.7,
            name = L["Trade skills"],
          },
          TrackBonus = {
            type = "toggle",
            order = 43.8,
            name = L["Bonus rolls"],
          },
          AugmentBonus = {
            type = "toggle",
            order = 43.9,
            name = L["Bonus loot frame"],
          },
          TrackLFG = {
            type = "toggle",
            order = 44,
            name = L["LFG cooldown"],
            desc = L["Show cooldown for characters to use LFG dungeon system"],
          },
          TrackDeserter = {
            type = "toggle",
            order = 45,
            name = L["Battleground Deserter"],
            desc = L["Show cooldown for characters to use battleground system"],
          },
          TrackPlayed = {
            type = "toggle",
            order = 46,
            name = L["Time /played"],
          },
          MythicKey = {
            type = "toggle",
            order = 47,
            name = L["Mythic Keystone"],
            desc = L["Track Mythic keystone acquisition"],
          },
          MythicKeyBest = {
            type = "toggle",
            order = 47.5,
            name = L["Mythic Best"],
            desc = L["Track Mythic keystone best run"],
          },
          TrackParagon = {
            type = "toggle",
            order = 48,
            name = L["Paragon Chests"],
          },
          BindHeader = {
            order = -0.6,
            type = "header",
            name = "",
            cmdHidden = true,
          },
          ToggleBind = {
            desc = L["Bind a key to toggle the SavedInstances tooltip"],
            type = "keybinding",
            name = L["Show/Hide the SavedInstances tooltip"],
            width = "double",
            cmdHidden = true,
            order = -0.5,
            set = function(info,val)
              local b1, b2 = GetBindingKey("SAVEDINSTANCES")
              if b1 then SetBinding(b1) end
              if b2 then SetBinding(b2) end
              SetBinding(val, "SAVEDINSTANCES")
              SaveBindings(GetCurrentBindingSet())
            end,
            get = function(info) return GetBindingKey("SAVEDINSTANCES") end
          },
        },
      },
      Currency = {
        order = 2,
        type = "group",
        name = L["Currency settings"],
        get = function(info)
          return addon.db.Tooltip[info[#info]]
        end,
        set = function(info, value)
          addon.debug(info[#info].." set to: "..tostring(value))
          addon.db.Tooltip[info[#info]] = value
          wipe(addon.scaleCache)
          wipe(addon.oi_cache)
          addon.oc_cache = nil
        end,
        args = {
          CurrencyValueColor = {
            type = "toggle",
            order = 10,
            name = L["Color currency by cap"]
          },
          NumberFormat = {
            type = "toggle",
            order = 20,
            name = L["Format large numbers"]
          },
          CurrencyMax = {
            type = "toggle",
            order = 30,
            name = L["Show currency max"]
          },
          CurrencyEarned = {
            type = "toggle",
            order = 40,
            name = L["Show currency earned"]
          },
          CurrencyHeader = {
            order = 50,
            type = "header",
            name = CURRENCY,
          },
        },
      },
      Indicators = {
        order = 3,
        type = "group",
        name = L["Indicators"],
        get = function(info)
          if addon.db.Indicators[info[#info]] ~= nil then -- tri-state boolean logic
            return addon.db.Indicators[info[#info]]
          else
            return addon.defaultDB.Indicators[info[#info]]
          end
        end,
        set = function(info, value)
          addon.debug("Config set: "..info[#info].." = "..(value and "true" or "false"))
          addon.db.Indicators[info[#info]] = value
        end,
        args = IndicatorOptions(),
      },
      Instances = {
        order = 4,
        type = "group",
        name = L["Instances"],
        childGroups = "select",
        width = "double",
        args = (function()
          local ret = {}
          for i,cat in ipairs(addon.OrderedCategories()) do
            ret[cat] = {
              order = i,
              type = "group",
              name = addon.Categories[cat],
              childGroups = "tree",
              args = (function()
                local iret = {}
                local insts = addon:OrderedInstances(cat)
                for j, inst in ipairs(insts) do
                  iret[inst] = {
                    order = j,
                    name = inst,
                    type = "select",
                    -- style = "radio",
                    values = valueslist,
                    get = function(info)
                      local val = addon.db.Instances[inst].Show
                      return (val and valueslist[val] and val) or "saved"
                    end,
                    set = function(info, value)
                      addon.db.Instances[inst].Show = value
                    end,
                  }
                end
                iret[ALL] = {
                  order = 0,
                  name = L["Set All"],
                  type = "select",
                  values = valueslist,
                  get = function(info) return "" end,
                  set = function(info, value)
                    for j, inst in ipairs(insts) do
                      addon.db.Instances[inst].Show = value
                    end
                  end,
                }
                iret.spacer = {
                  order = 0.5,
                  name = "",
                  type = "description",
                  width = "full",
                  cmdHidden = true,
                }
                return iret
              end)(),
            }
          end
          return ret
        end)(),
      },
      Characters = {
        order = 5,
        type = "group",
        name = L["Characters"],
        args = {
          Sorting = {
            name = L["Sorting"],
            type = "group",
            guiInline = true,
            order = 1,
            args = {
              SelfAlways = {
                type = "toggle",
                name = L["Show self always"],
                order = 2,
              },
              SelfFirst = {
                type = "toggle",
                name = L["Show self first"],
                order = 3,
              },
              ShowServer = {
                type = "toggle",
                name = L["Show server name"],
                order = 5,
              },
              ServerSort = {
                type = "toggle",
                name = L["Sort by server"],
                order = 6,
              },
              ServerOnly = {
                type = "toggle",
                name = L["Show only current server"],
                order = 7,
              },
              ConnectedRealms = {
                type = "select",
                name = L["Connected Realms"],
                order = 10,
                disabled = function()
                  return not (addon.db.Tooltip.ServerSort or addon.db.Tooltip.ServerOnly)
                end,
                values = {
                  ["ignore"] = L["Ignore"],
                  ["group"] = L["Group"],
                  ["interleave"] = L["Interleave"],
                },
              },
            }
          },
          Manage = {
            name = L["Manage"],
            type = "group",
            guiInline = true,
            order = 2,
            childGroups = "select",
            width = "double",
            args = (function ()
              local toons = {}
              for toon, _ in pairs(addon.db.Toons) do
                local tn, ts = toon:match('^(.*) [-] (.*)$')
                toons[ts] = toons[ts] or {}
                tinsert(toons[ts],tn)
              end
              local ret = {}
              ret.reset = {
                order = 0.1,
                name = L["Reset Characters"],
                type = "execute",
                func = function()
                  StaticPopup_Show("SAVEDINSTANCES_RESET")
                end
              }
              ret.recover = {
                order = 0.2,
                name = L["Recover Dailies"],
                desc = L["Attempt to recover completed daily quests for this character. Note this may recover some additional, linked daily quests that were not actually completed today."],
                type = "execute",
                func = function()
                  core:Refresh(true)
                end
              }
              local deltoon = function(info)
                local toon, tinfo = unpack(info.arg)
                if not toon then return end
                local dialog = StaticPopup_Show("SAVEDINSTANCES_DELETE_CHARACTER", toon, tinfo, toon)
              end
              local toonfncache = {}
              local toonget = function(field, default)
                local key = field.."_get"
                local fn = toonfncache[key] or function(info)
                  return tostring(info.arg[field] or default)
                end
                toonfncache[key] = fn
                return fn
              end
              local toonset = function(field, isnum)
                local key = field.."_set"
                local fn = toonfncache[key] or function(info, value)
                  if isnum then
                    value = tonumber(value)
                  end
                  info.arg[field] = value
                end
                toonfncache[key] = fn
                return fn
              end
              local orderval = function(info, value)
                if value:find("^%s*[0-9]?[0-9]?[0-9]%s*$") then
                  return true
                else
                  local err = L["Order must be a number in [0 - 999]"]
                  addon.chatMsg(err)
                  return err
                end
              end
              -- label line
              ret.newline1 = {
                order = 0.40,
                cmdHidden = true,
                name = "",
                type = "description",
                width = "full",
              }
              ret.cname = {
                order = 0.41,
                cmdHidden = true,
                name = " ",
                type = "description",
                width = "half",
              }
              ret.cshow = {
                order = 0.42,
                cmdHidden = true,
                fontSize = "medium",
                name = "  "..L["Show When"],
                type = "description",
                width = "normal",
              }
              ret.csort = {
                order = 0.43,
                cmdHidden = true,
                fontSize = "medium",
                name = "  "..L["Sort Order"],
                type = "description",
                width = "half",
              }

              for server, stoons in pairs(toons) do
                ret[server] = {
                  order = (server == GetRealmName() and 0.5 or 100),
                  type = "group",
                  name = server,
                  guiInline = false,
                  --childGroups = "tree",
                  args = (function()
                    local tret = {}
                    sort(stoons)
                    for ord, tn in pairs(stoons) do
                      local toon = tn.." - "..server
                      local t = addon.db.Toons[toon]
                      local tinfo = ""
                      if t and t.Level and t.LClass then
                        tinfo = tinfo.."\n"..LEVEL.." "..t.Level.." "..t.LClass
                      end
                      if t and t.LastSeen then
                        tinfo = tinfo.."\n"..L["Last updated"]..": "..date("%c",t.LastSeen)
                      end
                      tret[tn.."_desc"] = {
                        order = function(info) return t.Order*1000 + ord*10 + 0 end,
                        name = addon.ColoredToon(toon),
                        desc = tn, -- unfortunately does nothing in dialog
                        descStyle = "tooltip",
                        type = "description",
                        width = "half",
                        cmdHidden = true,
                      }
                      tret[tn] = {
                        order = function(info) return t.Order*1000 + ord*10 + 1 end,
                        name = "",
                        type = "select",
                        width = "normal",
                        values = valueslist,
                        arg = t,
                        get = toonget("Show", "saved"),
                        set = toonset("Show"),
                      }
                      tret[tn.."_order"] = {
                        order = function(info) return t.Order*1000 + ord*10 + 4 end,
                        name = "",
                        type = "input",
                        width = "half",
                        desc = L["Sort Order"],
                        --descStyle = "tooltip",
                        arg = t,
                        get = toonget("Order", 50),
                        set = toonset("Order", true),
                        validate = orderval,
                      --pattern = "^%s*[0-9]?[0-9]?[0-9]%s*$",
                      --usage = L["Order must be a number in [0 - 999]"],
                      }
                      tret[tn.."_sp1"] = {
                        order = function(info) return t.Order*1000 + ord*10 + 6 end,
                        name = " ",
                        type = "description",
                        width = "half",
                        cmdHidden = true,
                      }
                      tret[tn.."_delete"] = {
                        order = function(info) return t.Order*1000 + ord*10 + 7 end,
                        name = DELETE,
                        desc = DELETE.." "..toon..tinfo,
                        type = "execute",
                        width = "half",
                        arg = { toon, tinfo },
                        func = deltoon,
                      }
                      tret[tn.."_nl"] = {
                        order = function(info) return t.Order*1000 + ord*10 + 9 end,
                        name = "",
                        type = "description",
                        width = "full",
                        cmdHidden = true,
                      }
                    end
                    return tret
                  end)(),
                }
              end
              return ret
            end)()
          },
        },
      },
    },
  }
  core.Options = core.Options or {} -- allow option table rebuild
  for k,v in pairs(opts) do
    core.Options[k] = v
  end
  local progress = core:GetModule("Progress"):BuildOptions(32)
  for k, v in pairs(progress) do
    core.Options.args.General.args[k] = v
  end
  local warfront = core:GetModule("Warfront"):BuildOptions(34)
  for k, v in pairs(warfront) do
    core.Options.args.General.args[k] = v
  end
  for expansion, _ in pairs(addon.Emissaries) do
    core.Options.args.General.args["Emissary" .. expansion] = {
      type = "toggle",
      order = 37 + expansion * 0.1,
      name = _G["EXPANSION_NAME" .. expansion],
    }
  end
  for i, curr in ipairs(addon.currency) do
    local name,_,tex = GetCurrencyInfo(curr)
    tex = "\124T"..tex..":0\124t "
    core.Options.args.Currency.args["Currency"..curr] = {
      type = "toggle",
      order = 50+i,
      name = tex..name,
    }
  end
end

-- global functions

function Config:table_clone(t)
  if not t then return nil end
  local r = {}
  for k,v in pairs(t) do
    local nk,nv = k,v
    if type(k) == "table" then
      nk = Config:table_clone(k)
    end
    if type(v) == "table" then
      nv = Config:table_clone(v)
    end
    r[nk] = nv
  end
  return r
end

local firstoptiongroup, lastoptiongroup
function Config:ReopenConfigDisplay(f)
  if _G.InterfaceOptionsFrame:IsShown() then
    _G.InterfaceOptionsFrame:Hide();
    InterfaceOptionsFrame_OpenToCategory(lastoptiongroup)
    InterfaceOptionsFrame_OpenToCategory(firstoptiongroup)
    InterfaceOptionsFrame_OpenToCategory(f)
  end
end

function Config:SetupOptions()
  local AceConfigDialog = LibStub("AceConfigDialog-3.0")
  local namespace = "SavedInstances"
  Config:BuildOptions()
  LibStub("AceConfig-3.0"):RegisterOptionsTable(namespace, core.Options, { "si", "savedinstances" })
  local fgen = AceConfigDialog:AddToBlizOptions(namespace, nil, nil, "General")
  firstoptiongroup = fgen
  fgen.default = function()
    addon.debug("RESET: General")
    addon.db.Tooltip = Config:table_clone(addon.defaultDB.Tooltip)
    addon.db.MinimapIcon = Config:table_clone(addon.defaultDB.MinimapIcon)
    Config:ReopenConfigDisplay(fgen)
  end
  local fcur = AceConfigDialog:AddToBlizOptions(namespace, CURRENCY, namespace, "Currency")
  fcur.default = fgen.default
  local find = AceConfigDialog:AddToBlizOptions(namespace, L["Indicators"], namespace, "Indicators")
  find.default = function()
    addon.debug("RESET: Indicators")
    addon.db.Indicators = Config:table_clone(addon.defaultDB.Indicators)
    Config:ReopenConfigDisplay(find)
  end
  local finst = AceConfigDialog:AddToBlizOptions(namespace, L["Instances"], namespace, "Instances")
  finst.default = function()
    addon.debug("RESET: Instances")
    for _,i in pairs(addon.db.Instances) do
      i.Show = "saved"
    end
    Config:ReopenConfigDisplay(finst)
  end
  local ftoon = AceConfigDialog:AddToBlizOptions(namespace, L["Characters"], namespace, "Characters")
  lastoptiongroup = ftoon
  Config.ftoon = ftoon
  ftoon.default = function()
    addon.debug("RESET: Toons")
    for _,i in pairs(addon.db.Toons) do
      i.Show = "saved"
    end
    Config:ReopenConfigDisplay(ftoon)
  end
end

function Config:ShowConfig()
  if _G.InterfaceOptionsFrame:IsShown() then
    _G.InterfaceOptionsFrame:Hide()
  else
    InterfaceOptionsFrame_OpenToCategory(lastoptiongroup)
    InterfaceOptionsFrame_OpenToCategory(firstoptiongroup)
  end
end
