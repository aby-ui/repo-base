
-- BigDebuffs by Jordon

local addonName, addon = ...

BigDebuffs = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceHook-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local LibClassicDurations = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and LibStub("LibClassicDurations")
if LibClassicDurations then LibClassicDurations:Register(addonName) end

-- Defaults
local defaults = {
    profile = {
        raidFrames = {
            maxDebuffs = 2,
            anchor = "INNER",
            enabled = true,
            cooldownCount = false,
            cooldownFontSize = 10,
            cooldownFontEffect = "OUTLINE",
            cooldownFont = "Friz Quadrata TT",
            showAllClassBuffs = true,
            hideBliz = true,
            redirectBliz = true,
            increaseBuffs = true,
            cc = 60,
            dispellable = {
                cc = 60,
                roots = 50,
            },
            interrupts = 55,
            roots = 40,
            warning = 30,
            debuffs_offensive = 30,
            default = 30,
            special = 30,
            pve = 50,
            warningList = {
                [212183] = true, -- Smoke Bomb
                [81261] = true, -- Solar Beam
                [316099] = true, -- Unstable Affliction
                [342938] = true, -- Unstable Affliction
                [34914] = true, -- Vampiric Touch
            },
            inRaid = {
                hide = false,
                size = 5
            }
        },
        unitFrames = {
            enabled = true,
            cooldownCount = true,
            cooldownFontSize = 16,
            cooldownFontEffect = "OUTLINE",
            cooldownFont = "Friz Quadrata TT",
            tooltips = true,
            player = {
                enabled = true,
                anchor = "auto",
                anchorPoint = "auto",
                relativePoint = "auto",
                x = 0,
                y = 0,
                matchFrameHeight = true,
                size = 50,
            },
            target = {
                enabled = true,
                anchor = "auto",
                anchorPoint = "auto",
                relativePoint = "auto",
                x = 0,
                y = 0,
                matchFrameHeight = true,
                size = 50,
            },
            pet = {
                enabled = true,
                anchor = "auto",
                anchorPoint = "auto",
                relativePoint = "auto",
                x = 0,
                y = 0,
                matchFrameHeight = true,
                size = 50,
            },
            party = {
                enabled = true,
                anchor = "auto",
                anchorPoint = "auto",
                relativePoint = "auto",
                x = 0,
                y = 0,
                matchFrameHeight = true,
                size = 50,
            },
            cc = true,
            interrupts = true,
            immunities = true,
            immunities_spells = true,
            buffs_defensive = true,
            buffs_offensive = true,
            buffs_other = true,
            debuffs_offensive = true,
            roots = true,
            buffs_speed_boost = true,
        },
        nameplates = {
            enabled = true,
            cooldownCount = true,
            cooldownFontSize = 16,
            cooldownFontEffect = "OUTLINE",
            cooldownFont = "Friz Quadrata TT",
            tooltips = true,
            enemy = true,
            friendly = true,
            npc = true,
            enemyAnchor = {
                anchor = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and "RIGHT" or "TOP",
                size = 24,
                x = 0,
                y = 0,
            },
            friendlyAnchor = {
                friendlyAnchorEnabled = false,
                anchor = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and "RIGHT" or "TOP",
                size = 24,
                x = 0,
                y = 0,
            },
            cc = true,
            interrupts = true,
            immunities = true,
            immunities_spells = true,
            buffs_defensive = true,
            buffs_offensive = true,
            buffs_other = true,
            debuffs_offensive = true,
            roots = true,
            buffs_speed_boost = true,
        },
        priority = {
            immunities = 80,
            immunities_spells = 70,
            cc = 60,
            interrupts = 55,
            buffs_defensive = 50,
            buffs_offensive = 40,
            debuffs_offensive = 35,
            buffs_other = 30,
            roots = 51,
            special = 19,
            buffs_speed_boost = 10,
        },
        spells = {},
    }
}

BigDebuffs.WarningDebuffs = addon.WarningDebuffs or {}
BigDebuffs.Spells = addon.Spells

-- create a lookup table since CombatLogGetCurrentEventInfo() returns 0 for spellId
local spellIdByName
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    spellIdByName = {}
    for id, value in pairs(BigDebuffs.Spells) do
        if not value.parent then spellIdByName[GetSpellInfo(id)] = id end
    end
else
    defaults.profile.unitFrames.focus = {
        enabled = true,
        anchor = "auto",
        anchorPoint = "auto",
        relativePoint = "auto",
        x = 0,
        y = 0,
        matchFrameHeight = true,
        size = 50,
    }

    defaults.profile.unitFrames.arena = {
        enabled = true,
        anchor = "auto",
        anchorPoint = "auto",
        relativePoint = "auto",
        x = 0,
        y = 0,
        matchFrameHeight = true,
        size = 50,
    }
end

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    BigDebuffs.specDispelTypes = {
            [62] = { -- Arcane Mage
                Curse = true,
            },
            [63] = { -- Fire Mage
                Curse = true,
            },
            [64] = { -- Frost Mage
                Curse = true,
            },
            [65] = { -- Holy Paladin
                Magic = true,
                Poison = true,
                Disease = true,
            },
            [66] = { -- Protection Paladin
                Poison = true,
                Disease = true,
            },
            [70] = { -- Retribution Paladin
                Poison = true,
                Disease = true,
            },
            [102] = { -- Balance Druid
                Curse = true,
                Poison = true,
            },
            [103] = { -- Feral Druid
                Curse = true,
                Poison = true,
            },
            [104] = { -- Guardian Druid
                Curse = true,
                Poison = true,
            },
            [105] = { -- Restoration Druid
                Magic = true,
                Curse = true,
                Poison = true,
            },
            [256] = { -- Discipline Priest
                Magic = true,
                Disease = true,
            },
            [257] = { -- Holy Priest
                Magic = true,
                Disease = true,
            },
            [258] = { -- Shadow Priest
                Magic = true,
                Disease = true,
            },
            [262] = { -- Elemental Shaman
                Curse = true,
            },
            [263] = { -- Enhancement Shaman
                Curse = true,
            },
            [264] = { -- Restoration Shaman
                Magic = true,
                Curse = true,
            },
            [268] = { -- Brewmaster Monk
                Poison = true,
                Disease = true,
            },
            [269] = { -- Windwalker Monk
                Poison = true,
                Disease = true,
            },
            [270] = { -- Mistweaver Monk
                Magic = true,
                Poison = true,
                Disease = true,
            },
            [577] = {
                Magic = function() return GetSpellInfo(205604) end, -- Reverse Magic
            },
            [581] = {
                Magic = function() return GetSpellInfo(205604) end, -- Reverse Magic
            },
        }
else
    local classDispel = {
        PRIEST = {
            Magic = true,
            Disease = true,
        },
        MAGE = {
            Curse = true,
        },
        PALADIN = {
            Magic = true,
            Poison = true,
            Disease = true,
        },
        DRUID = {
            Curse = true,
            Poison = true,
        },
        SHAMAN = {
            Disease = true,
            Poison = true,
            -- Shamans 'Cleanse Spirit' restoration talent
            Curse = function () return IsUsableSpell(GetSpellInfo(51886)) end
        },
        WARLOCK = {
            -- Felhunter's Devour Magic or Doomguard's Dispel Magic
            Magic = function() return IsUsableSpell(GetSpellInfo(19736)) or IsUsableSpell(GetSpellInfo(19476)) end,
        },
    }
    local _, class = UnitClass("player")
    BigDebuffs.dispelTypes = classDispel[class]
end

BigDebuffs.PriorityDebuffs = addon.PriorityDebuffs

-- Store interrupt spellId and start time
BigDebuffs.units = {}

local units = addon.Units

local unitsWithRaid = {}

for i = 1, #units do
    table.insert(unitsWithRaid, units[i])
end

for i = 1, 40 do
    table.insert(unitsWithRaid, "raid" .. i)
end

local UnitDebuff, UnitBuff = UnitDebuff, UnitBuff

local GetAnchor = {
    ElvUIFrames = function(anchor)
        local anchors, unit = BigDebuffs.anchors

        for u,configAnchor in pairs(anchors.ElvUI.units) do
            if anchor == configAnchor then
                unit = u
                break
            end
        end

        if unit and ( unit:match("party") or unit:match("player") ) then
            local unitGUID = UnitGUID(unit)
            for i = 1,5,1 do
                local elvUIFrame = _G["ElvUF_PartyGroup1UnitButton"..i]
                if elvUIFrame and elvUIFrame:IsVisible() and elvUIFrame.unit then
                    if unitGUID == UnitGUID(elvUIFrame.unit) then
                        return elvUIFrame
                    end
                end
            end
            return
        end

        if unit and ( unit:match("arena") or unit:match("arena") ) then
            local unitGUID = UnitGUID(unit)
            for i = 1,5,1 do
                local elvUIFrame = _G["ElvUF_Arena"..i]
                if elvUIFrame and elvUIFrame:IsVisible() and elvUIFrame.unit then
                    if unitGUID == UnitGUID(elvUIFrame.unit) then
                        return elvUIFrame
                    end
                end
            end
            return
        end

        return _G[anchor]
    end,
    NDuiFrames = function(anchor)
        local anchors, unit = BigDebuffs.anchors

        for u,configAnchor in pairs(anchors.NDui.units) do
            if anchor == configAnchor then
                unit = u
                break
            end
        end

        if unit and ( unit:match("party") or unit:match("player") ) then
            local unitGUID = UnitGUID(unit)
            for i = 1,5,1 do
                local oUFFrame = _G["oUF_PartyGroup1UnitButton"..i]
                if oUFFrame and oUFFrame:IsVisible() and oUFFrame.unit then
                    if unitGUID == UnitGUID(oUFFrame.unit) then
                        return oUFFrame
                    end
                end
            end
            return
        end

        if unit and ( unit:match("arena") or unit:match("arena") ) then
            local unitGUID = UnitGUID(unit)
            for i = 1,5,1 do
                local oUFFrame = _G["oUF_Arena"..i]
                if oUFFrame and oUFFrame:IsVisible() and oUFFrame.unit then
                    if unitGUID == UnitGUID(oUFFrame.unit) then
                        return oUFFrame
                    end
                end
            end
            return
        end

        return _G[anchor]
    end,
    ShadowedUnitFrames = function(anchor)
        local frame = _G[anchor]
        if not frame then return end
        if frame.portrait and frame.portrait:IsShown() then
            return frame.portrait, frame
        else
            return frame, frame, true
        end
    end,
    ZPerl = function(anchor)
        local frame = _G[anchor]
        if not frame then return end
        if frame:IsShown() then
            return frame, frame
        else
            frame = frame:GetParent()
            return frame, frame, true
        end
    end,
    sArena = function(anchor)
        local frame = _G[anchor]
        if not frame then return end
        if frame.ClassIcon then
            return frame.ClassIcon, frame
        else
            return frame, frame, true
        end
    end,
}

local GetNameplateAnchor = {
    ElvUINameplates = function(frame)
        if frame.unitFrame and frame.unitFrame.Health and frame.unitFrame.Health:IsShown() then
            return frame.unitFrame.Health, frame.unitFrame
        elseif frame.unitFrame then
            return frame.unitFrame, frame.unitFrame
        end
    end,
    KuiNameplate = function(frame)
        if frame.kui and frame.kui.HealthBar and frame.kui.HealthBar:IsShown() then
            return frame.kui.HealthBar, frame.kui
        elseif frame.kui and frame.kui.NameText and frame.kui.NameText:IsShown() then
            return frame.kui.NameText, frame.kui
        elseif frame.kui then
            return frame.kui, frame.kui
        end
    end,
    Plater = function(frame)
        if frame.unitFrame and frame.unitFrame.healthBar and frame.unitFrame.healthBar:IsShown() then
            return frame.unitFrame.healthBar, frame.unitFrame
        elseif frame.unitFrame and frame.unitFrame.ActorNameSpecial and frame.unitFrame.ActorNameSpecial:IsShown() then
            return frame.unitFrame.ActorNameSpecial, frame.unitFrame
        elseif frame.unitFrame then
            return frame.unitFrame, frame.unitFrame
        end
    end,
    NeatPlates = function(frame)
        if frame.carrier and frame.extended and frame.extended.bars and frame.carrier:IsShown() then
            return frame.extended.bars.healthbar, frame.extended
        end
    end,
    ThreatPlates = function(frame)
        local tp_frame = frame.TPFrame
        if tp_frame then
            local visual = tp_frame.visual
            -- healthbar and name are always defined, so checks are not really needed here.
            if visual.healthbar and visual.healthbar:IsShown() then
                return visual.healthbar, tp_frame
            elseif visual.name and visual.name:IsShown() then
                return visual.name, tp_frame
            else
                return tp_frame, tp_frame
            end
        end
    end,
    TidyPlates = function(frame)
        if frame.carrier and frame.extended and frame.extended.bars and frame.carrier:IsShown() then
            return frame.extended.bars.healthbar, frame.extended
        end
    end,
	oUF = function(frame)
        return frame.unitFrame.Health, frame.unitFrame
    end,
    Blizzard = function(frame)
        if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
            return frame.UnitFrame, frame.UnitFrame
        end
        if frame.UnitFrame and frame.UnitFrame.healthBar and frame.UnitFrame.healthBar:IsShown() then
            return frame.UnitFrame.healthBar, frame.UnitFrame
        elseif frame.UnitFrame and frame.UnitFrame.name and frame.UnitFrame.name:IsShown() then
            return frame.UnitFrame.name, frame.UnitFrame
        elseif frame.UnitFrame then
            return frame.UnitFrame, frame.UnitFrame
        end
    end,
}

local nameplatesAnchors = {
    [1] = {
        used = function()
            return ElvUI and ElvUI[1].NamePlates and ElvUI[1].NamePlates.Initialized
        end,
        func = GetNameplateAnchor.ElvUINameplates,
    },
    [2] = {
        used = function()
            return NDui and NDui[2].db.Nameplate.Enable
        end,
        func = GetNameplateAnchor.ElvUINameplates, -- all by oUF
    },
    [3] = {
        used = function()
            return KuiNameplates ~= nil
        end,
        func = GetNameplateAnchor.KuiNameplate,
    },
    [4] = {
        used = function()
            return Plater ~= nil
        end,
        func = GetNameplateAnchor.Plater,
    },
    [5] = {
        used = function()
            return NeatPlates ~= nil
        end,
        func = GetNameplateAnchor.NeatPlates,
    },
    [6] = {
        used = function()
            -- IsAddOnLoaded("TidyPlates_ThreatPlates") should be better
            return TidyPlatesThreat ~= nil
        end,
        func = GetNameplateAnchor.ThreatPlates,
    },
    [7] = {
        used = function()
            return TidyPlates ~= nil
        end,
        func = GetNameplateAnchor.TidyPlates,
    },
	[8] = {
        used = function()
			return _G.oUF_NamePlateDriver
		end,
        func = GetNameplateAnchor.oUF,
    },
    [9] = {
        used = function(frame) return frame.UnitFrame ~= nil end,
        func = GetNameplateAnchor.Blizzard,
    },
}

local anchors = {
    ["GladiusExParty"] = {
        noPortait = true,
        units = {
            party1 = "GladiusExButtonFrameparty1",
            party2 = "GladiusExButtonFrameparty2",
            party3 = "GladiusExButtonFrameparty3",
            party4 = "GladiusExButtonFrameparty4"
        }
    },
    ["GladiusExArena"] = {
        noPortait = true,
        alignLeft = true,
        units = {
            arena1 = "GladiusExButtonFramearena1",
            arena2 = "GladiusExButtonFramearena2",
            arena3 = "GladiusExButtonFramearena3",
            arena4 = "GladiusExButtonFramearena4",
            arena5 = "GladiusExButtonFramearena5",
        }
    },
    ["ElvUI"] = {
        func = GetAnchor.ElvUIFrames,
        noPortait = true,
        units = {
            player = "ElvUF_Player",
            pet = "ElvUF_Pet",
            target = "ElvUF_Target",
            focus = "ElvUF_Focus",
            party1 = "ElvUF_PartyGroup1UnitButton2",
            party2 = "ElvUF_PartyGroup1UnitButton3",
            party3 = "ElvUF_PartyGroup1UnitButton4",
            party4 = "ElvUF_PartyGroup1UnitButton5",
            arena1 = "ElvUF_Arena1",
            arena2 = "ElvUF_Arena2",
            arena3 = "ElvUF_Arena3",
            arena4 = "ElvUF_Arena4",
            arena5 = "ElvUF_Arena5",
        },
    },
    ["NDui"] = {
        func = GetAnchor.NDuiFrames,
        noPortait = true,
        units = {
            player = "oUF_Player",
            pet = "oUF_Pet",
            target = "oUF_Target",
            focus = "oUF_Focus",
            party1 = "oUF_PartyGroup1UnitButton2",
            party2 = "oUF_PartyGroup1UnitButton3",
            party3 = "oUF_PartyGroup1UnitButton4",
            party4 = "oUF_PartyGroup1UnitButton5",
            arena1 = "oUF_Arena1",
            arena2 = "oUF_Arena2",
            arena3 = "oUF_Arena3",
            arena4 = "oUF_Arena4",
            arena5 = "oUF_Arena5",
        },
    },
    ["bUnitFrames"] = {
        noPortait = true,
        alignLeft = true,
        units = {
            player = "bplayerUnitFrame",
            pet = "bpetUnitFrame",
            target = "btargetUnitFrame",
            focus = "bfocusUnitFrame",
            arena1 = "barena1UnitFrame",
            arena2 = "barena2UnitFrame",
            arena3 = "barena3UnitFrame",
            arena4 = "barena4UnitFrame",
        },
    },
    ["Shadowed Unit Frames"] = {
        func = GetAnchor.ShadowedUnitFrames,
        units = {
            player = "SUFUnitplayer",
            pet = "SUFUnitpet",
            target = "SUFUnittarget",
            focus = "SUFUnitfocus",
            party1 = "SUFHeaderpartyUnitButton1",
            party2 = "SUFHeaderpartyUnitButton2",
            party3 = "SUFHeaderpartyUnitButton3",
            party4 = "SUFHeaderpartyUnitButton4",
        },
    },
    ["ZPerl"] = {
        func = GetAnchor.ZPerl,
        units = {
            player = "XPerl_PlayerportraitFrame",
            pet = "XPerl_Player_PetportraitFrame",
            target = "XPerl_TargetportraitFrame",
            focus = "XPerl_FocusportraitFrame",
            party1 = "XPerl_party1portraitFrame",
            party2 = "XPerl_party2portraitFrame",
            party3 = "XPerl_party3portraitFrame",
            party4 = "XPerl_party4portraitFrame",
        },
    },
    ["sArena"] = {
        func = GetAnchor.sArena,
        units = {
            arena1 = "sArenaEnemyFrame1",
            arena2 = "sArenaEnemyFrame2",
            arena3 = "sArenaEnemyFrame3",
            arena4 = "sArenaEnemyFrame4",
            arena5 = "sArenaEnemyFrame5",
        },
    },
    ["Blizzard"] = {
        units = {
            player = "PlayerPortrait",
            pet = "PetPortrait",
            target = "TargetFramePortrait",
            focus = "FocusFramePortrait",
            party1 = "PartyMemberFrame1Portrait",
            party2 = "PartyMemberFrame2Portrait",
            party3 = "PartyMemberFrame3Portrait",
            party4 = "PartyMemberFrame4Portrait",
            arena1 = "ArenaEnemyFrame1ClassPortrait",
            arena2 = "ArenaEnemyFrame2ClassPortrait",
            arena3 = "ArenaEnemyFrame3ClassPortrait",
            arena4 = "ArenaEnemyFrame4ClassPortrait",
            arena5 = "ArenaEnemyFrame5ClassPortrait",
        },
    },
}

BigDebuffs.anchors = anchors

function BigDebuffs:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("BigDebuffsDB", defaults, true)

    -- Upgrade old database
    if type(self.db.profile.raidFrames.dispellable) == "number" then
        self.db.profile.raidFrames.dispellable = {
            cc = self.db.profile.raidFrames.dispellable,
            roots = self.db.profile.raidFrames.roots
        }
    end
    for i = 1, #units do
        local key = units[i]:gsub("%d", "")
        if type(self.db.profile.unitFrames[key]) == "boolean" then
            self.db.profile.unitFrames[key] = {
                enabled = self.db.profile.unitFrames[key],
                anchor = "auto",
                anchorPoint = "auto",
                relativePoint = "auto",
                x = 0,
                y = 0,
                matchFrameHeight = true,
                size = 50
            }
        else
            if type(self.db.profile.unitFrames[key].anchorPoint) ~= "string" then
                self.db.profile.unitFrames[key].anchorPoint = "auto"
            end

            if type(self.db.profile.unitFrames[key].relativePoint) ~= "string" then
                self.db.profile.unitFrames[key].relativePoint = "auto"
            end

            if type(self.db.profile.unitFrames[key].x) ~= "number" then
                self.db.profile.unitFrames[key].x = 0
            end

            if type(self.db.profile.unitFrames[key].y) ~= "number" then
                self.db.profile.unitFrames[key].y = 0
            end

            if type(self.db.profile.unitFrames[key].matchFrameHeight) ~= "boolean" then
                self.db.profile.unitFrames[key].matchFrameHeight = true
            end
        end
    end

    if self.db.profile.raidFrames.showAllClassBuffs == nil then
        self.db.profile.raidFrames.showAllClassBuffs = true
    end

    self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
    self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
    self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
    self.frames = {}
    self.UnitFrames = {}
    self.Nameplates = {}
    self:SetupOptions()
end

local function HideBigDebuffs(frame)
    if not frame.BigDebuffs then return end
    for i = 1, #frame.BigDebuffs do
        frame.BigDebuffs[i]:Hide()
    end
end

function BigDebuffs:Refresh()
    for frame, _ in pairs(self.frames) do
        if frame:IsVisible() then CompactUnitFrame_UpdateAuras(frame) end
        if frame and frame.BigDebuffs then self:AddBigDebuffs(frame) end
    end
    for unit, frame in pairs(self.UnitFrames) do
        frame:Hide()
        frame.current = nil
        if self.db.profile.unitFrames.cooldownCount then
            local text = frame.cooldown:GetRegions()
            if text then
                text:SetFont(LibSharedMedia:Fetch("font", BigDebuffs.db.profile.unitFrames.cooldownFont),
                    self.db.profile.unitFrames.cooldownFontSize, self.db.profile.unitFrames.cooldownFontEffect)
            end
        end
        frame.cooldown:SetHideCountdownNumbers(not self.db.profile.unitFrames.cooldownCount)
        frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
        self:UNIT_AURA(unit)
    end
    for unit, frame in pairs(self.Nameplates) do
        frame:Hide()
        frame.current = nil
        if self.db.profile.unitFrames.cooldownCount then
            local text = frame.cooldown:GetRegions()
            if text then
                text:SetFont(LibSharedMedia:Fetch("font", BigDebuffs.db.profile.unitFrames.cooldownFont),
                    self.db.profile.unitFrames.cooldownFontSize, self.db.profile.unitFrames.cooldownFontEffect)
            end
        end
        frame.cooldown:SetHideCountdownNumbers(not self.db.profile.unitFrames.cooldownCount)
        frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
        self:UNIT_AURA_NAMEPLATE(unit)
    end
end

function BigDebuffs:AttachUnitFrame(unit)
    if InCombatLockdown() then return end

    local frame = self.UnitFrames[unit]
    local frameName = addonName .. unit .. "UnitFrame"

    if not frame then
        frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
        self.UnitFrames[unit] = frame
        frame:SetScript("OnEvent", function() self:UNIT_AURA(unit) end)
        if self.db.profile.unitFrames.cooldownCount then
            local text = frame.cooldown:GetRegions()
            if text then
                text:SetFont(LibSharedMedia:Fetch("font", BigDebuffs.db.profile.unitFrames.cooldownFont),
                    self.db.profile.unitFrames.cooldownFontSize, self.db.profile.unitFrames.cooldownFontEffect)
            end
        end
        frame.cooldown:SetHideCountdownNumbers(not self.db.profile.unitFrames.cooldownCount)
        frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
        frame.icon:SetDrawLayer("BORDER")
        frame:RegisterUnitEvent("UNIT_AURA", unit)
        frame:RegisterForDrag("LeftButton")
        frame:SetMovable(true)
        frame.unit = unit
    end

    frame:EnableMouse(self.test)

    _G[frameName.."Name"]:SetText(self.test and not frame.anchor and unit)

    frame.anchor = nil
    frame.blizzard = nil

    local config = self.db.profile.unitFrames[unit:gsub("%d", "")]

    if config.anchor == "auto" then
        -- Find a frame to attach to
        for k,v in pairs(anchors) do
            local anchor, parent, noPortait
            if v.units[unit] then
                if v.func then
                    anchor, parent, noPortait = v.func(v.units[unit])
                else
                    anchor = _G[v.units[unit]]
                end

                if anchor then
                    frame.anchor, frame.parent, frame.noPortait = anchor, parent, noPortait
                    if v.noPortait then frame.noPortait = true end
                    frame.alignLeft = v.alignLeft
                    frame.blizzard = (k == "Blizzard" or k == "sArena")
                    if not frame.blizzard then break end
                end
            end
        end
    end

    if frame.anchor then
        if frame.blizzard then
            -- Blizzard Frame
            frame:SetParent(frame.anchor:GetParent())
            frame:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
            frame.cooldown:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
            frame.anchor:SetDrawLayer("BACKGROUND")
            frame.cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        else
            frame:SetParent(frame.parent and frame.parent or frame.anchor)
            frame:SetFrameLevel(99)
        end

        frame:ClearAllPoints()

        if config.anchorPoint ~= "auto" or frame.noPortait then
            if config.anchorPoint == "auto" then
                -- No portrait, so attach to the side
                if frame.alignLeft then
                    frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
                else
                    frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
                end
            else
                if config.relativePoint == "auto" then
                    if config.anchorPoint == "BOTTOM" then
                        frame:SetPoint("TOP", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "BOTTOMLEFT" then
                        frame:SetPoint("BOTTOMRIGHT", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "BOTTOMRIGHT" then
                        frame:SetPoint("BOTTOMLEFT", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "CENTER" then
                        frame:SetPoint("CENTER", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "LEFT" then
                        frame:SetPoint("RIGHT", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "RIGHT" then
                        frame:SetPoint("LEFT", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "TOP" then
                        frame:SetPoint("BOTTOM", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "TOPLEFT" then
                        frame:SetPoint("TOPRIGHT", frame.anchor, config.anchorPoint, config.x, config.y)
                    elseif config.anchorPoint == "TOPRIGHT" then
                        frame:SetPoint("TOPLEFT", frame.anchor, config.anchorPoint, config.x, config.y)
                    end
                else
                    frame:SetPoint(config.relativePoint, frame.anchor, config.anchorPoint, config.x, config.y)
                end
            end

            if not config.matchFrameHeight then
                frame:SetSize(config.size, config.size)
            else
                local height = frame.anchor:GetHeight()
                frame:SetSize(height, height)
            end
        else
            frame:SetAllPoints(frame.anchor)
        end
    else
        -- Manual
        frame:SetParent(UIParent)
        frame:ClearAllPoints()

        if not self.db.profile.unitFrames[unit] then self.db.profile.unitFrames[unit] = {} end

        if self.db.profile.unitFrames[unit].position then
            frame:SetPoint(unpack(self.db.profile.unitFrames[unit].position))
        else
            -- No saved position, anchor to the blizzard position
            if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then LoadAddOn("Blizzard_ArenaUI") end
            local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
            frame:SetPoint("CENTER", relativeFrame, "CENTER")
        end

        frame:SetSize(config.size, config.size)
    end
end

function BigDebuffs:AttachNameplate(unit)
    local frame = self.Nameplates[unit]
    if (not frame or frame:IsForbidden()) then
        return
    end

    local config = self.db.profile.nameplates

    if config.cooldownCount then
        local text = frame.cooldown:GetRegions()
        if text then
            text:SetFont(LibSharedMedia:Fetch("font", config.cooldownFont),
                config.cooldownFontSize, config.cooldownFontEffect)
        end
    end
    frame.cooldown:SetHideCountdownNumbers(not config.cooldownCount)
    frame.cooldown.noCooldownCount = not config.cooldownCount

    frame:EnableMouse(config.tooltips)

    local anchorStyle = "enemyAnchor"
    if (not UnitCanAttack("player", unit) and config["friendlyAnchor"].friendlyAnchorEnabled == true) then
        anchorStyle = "friendlyAnchor"
    end

    frame:ClearAllPoints()
    if config[anchorStyle].anchor == "RIGHT" then
        frame:SetPoint("LEFT", frame.anchor, "RIGHT", config[anchorStyle].x, config[anchorStyle].y)
    elseif config[anchorStyle].anchor == "TOP" then
        frame:SetPoint("BOTTOM", frame.anchor, "TOP", config[anchorStyle].x, config[anchorStyle].y)
    elseif config[anchorStyle].anchor == "LEFT" then
        frame:SetPoint("RIGHT", frame.anchor, "LEFT", config[anchorStyle].x, config[anchorStyle].y)
    elseif config[anchorStyle].anchor == "BOTTOM" then
        frame:SetPoint("TOP", frame.anchor, "BOTTOM", config[anchorStyle].x, config[anchorStyle].y)
    end

    frame:SetSize(config[anchorStyle].size, config[anchorStyle].size)
end

function BigDebuffs:SaveUnitFramePosition(frame)
    self.db.profile.unitFrames[frame.unit].position = { frame:GetPoint() }
end

function BigDebuffs:Test()
    self.test = not self.test
    self:Refresh()
end

local TestDebuffs = {}

local function InsertTestDebuff(spellID, dispelType)
    local texture = GetSpellTexture(spellID)
    table.insert(TestDebuffs, { spellID, texture, 0, dispelType })
end

local function UnitDebuffTest(unit, index)
    local debuff = TestDebuffs[index]
    if not debuff then return end
    -- name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId
    return "Test", debuff[2], 0, debuff[4], 60, GetTime() + 60, nil, nil, nil, debuff[1]
end

function BigDebuffs:OnEnable()
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("UNIT_PET")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        self:RegisterEvent("PLAYER_TALENT_UPDATE")
        self:PLAYER_TALENT_UPDATE()
    end

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        self:RegisterEvent("PLAYER_FOCUS_CHANGED")
    end

    InsertTestDebuff(8122, "Magic") -- Psychic Scream
    InsertTestDebuff(408, nil) -- Kidney Shot
    InsertTestDebuff(1766, nil) -- Kick

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        InsertTestDebuff(51514, "Curse") -- Hex
        InsertTestDebuff(316099, "Magic") -- Unstable Affliction
        InsertTestDebuff(208086, nil) -- Colossus Smash
    end

    InsertTestDebuff(339, "Magic") -- Entangling Roots
    InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
    InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
    InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
    InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
    InsertTestDebuff(772, nil) -- Rend
end

function BigDebuffs:PLAYER_ENTERING_WORLD()
    for i = 1, #units do
        self:AttachUnitFrame(units[i])
    end
end

local function UnitBuffByName(unit, name)
    for i = 1, 40 do
        local n = UnitBuff(unit, i)
        if n == name then return true end
    end
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED()

    local _, event, _,_,_,_,_, destGUID, _,_,_, spellId, spellName = CombatLogGetCurrentEventInfo()

    -- SPELL_INTERRUPT doesn't fire for some channeled spells
    if event ~= "SPELL_INTERRUPT" and event ~= "SPELL_CAST_SUCCESS" then return end

    if spellId == 0 then spellId = spellIdByName[spellName] end

    local spell = self.Spells[spellId]
    if not spell then return end
    local spellType = spell.parent and self.Spells[spell.parent].type or spell.type
    if spellType ~= "interrupts" then return end

    -- Find unit
    for i = 1, #unitsWithRaid do
        local unit = unitsWithRaid[i]
        if destGUID == UnitGUID(unit) and (event ~= "SPELL_CAST_SUCCESS" or
            (UnitChannelInfo and select(7, UnitChannelInfo(unit)) == false))
        then
            local duration = spell.parent and self.Spells[spell.parent].duration or spell.duration

            if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and UnitBuffByName(unit, "Calming Waters") then
                duration = duration * 0.5
            end

            if WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
                local _, playerClass = UnitClass("player")
                if playerClass == "PALADIN" then
                    local improvedConcAuraRank = select(5, GetTalentInfo(2, 12))
                    if improvedConcAuraRank > 0 and UnitBuffByName(unit, "Concentration Aura") then
                        duration = duration * (1.0 - 0.1 * improvedConcAuraRank)
                    end
                end
                if playerClass == "SHAMAN" then
                    local focusedMindRank = select(5, GetTalentInfo(3, 14))
                    if focusedMindRank > 0 then
                        duration = duration * (1.0 - 0.1 * focusedMindRank)
                    end
                end
            end

            self.units[destGUID] = self.units[destGUID] or {}
            self.units[destGUID].expires = GetTime() + duration
            self.units[destGUID].spellId = spellId
            self.units[destGUID].duration = duration
            self.units[destGUID].spellId = spell.parent and spell.parent or spellId

            -- Make sure we clear it after the duration
            C_Timer.After(duration, function()
                self:UNIT_AURA_ALL_UNITS()
            end)

            self:UNIT_AURA_ALL_UNITS()

            return

        end
    end
end

function BigDebuffs:UNIT_AURA_ALL_UNITS()
    for i = 1, #unitsWithRaid do
        local unit = unitsWithRaid[i]

        if self.AttachedFrames[unit] then
            self:ShowBigDebuffs(self.AttachedFrames[unit])
        end

        if not unit:match("^raid") and not unit:find("nameplate") then
            self:UNIT_AURA(unit)
        end

        if unit:find("nameplate") then
            self:UNIT_AURA_NAMEPLATE(unit)
        end
    end
end

BigDebuffs.AttachedFrames = {}

local MAX_BUFFS = 6

function BigDebuffs:AddBigDebuffs(frame)
    if not frame or not frame.displayedUnit or not UnitIsPlayer(frame.displayedUnit) then return end
    local frameName = frame:GetName()
    if self.db.profile.raidFrames.increaseBuffs then
        for i = 4, MAX_BUFFS do
            local buffPrefix = frameName .. "Buff"
            local buffFrame = _G[buffPrefix .. i] or
                CreateFrame("Button", buffPrefix .. i, frame, "CompactBuffTemplate")
            buffFrame:ClearAllPoints()
            buffFrame:SetSize(frame.buffFrames[1]:GetSize())
            if math.fmod(i - 1, 3) == 0 then
                buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 3], "TOPRIGHT")
            else
                buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 1], "BOTTOMLEFT")
            end
        end
    end

    self.AttachedFrames[frame.displayedUnit] = frame

    frame.BigDebuffs = frame.BigDebuffs or {}
    local max = self.db.profile.raidFrames.maxDebuffs + 1 -- add a frame for warning debuffs
    for i = 1, max do
        local big = frame.BigDebuffs[i] or
            CreateFrame("Button", frameName .. "BigDebuffsRaid" .. i, frame, "CompactDebuffTemplate")
        big:ClearAllPoints()
        if i > 1 then
            if self.db.profile.raidFrames.anchor == "INNER" or self.db.profile.raidFrames.anchor == "RIGHT" or self.db.profile.raidFrames.anchor == "TOP" then
                big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "LEFT" then
                big:SetPoint("BOTTOMRIGHT", frame.BigDebuffs[i-1], "BOTTOMLEFT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "BOTTOM" then
                big:SetPoint("TOPLEFT", frame.BigDebuffs[i-1], "TOPRIGHT", 0, 0)
            end
        else
            if self.db.profile.raidFrames.anchor == "INNER" then
                big:SetPoint("BOTTOMLEFT", frame.debuffFrames[1], "BOTTOMLEFT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "LEFT" then
                big:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, 1)
            elseif self.db.profile.raidFrames.anchor == "RIGHT" then
                big:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 1)
            elseif self.db.profile.raidFrames.anchor == "TOP" then
                big:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 1)
            elseif self.db.profile.raidFrames.anchor == "BOTTOM" then
                big:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 1)
            end
        end

        big.cooldown:SetHideCountdownNumbers(not self.db.profile.raidFrames.cooldownCount)
        big.cooldown.noCooldownCount = not self.db.profile.raidFrames.cooldownCount

        big.cooldown:SetDrawEdge(false)
        frame.BigDebuffs[i] = big
        big:Hide()
        self.frames[frame] = true
        self:ShowBigDebuffs(frame)
    end
    return true
end

local pending = {}

hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
    if not BigDebuffs.db.profile then return end
    if not BigDebuffs.db.profile.raidFrames then return end
    if not BigDebuffs.db.profile.raidFrames.enabled then return end
    if frame:IsForbidden() then return end
    local name = frame:GetName()
    if not name or not name:match("^Compact") then return end
    if InCombatLockdown() and not frame.BigDebuffs then
        if not pending[frame] then pending[frame] = true end
    else
        BigDebuffs:AddBigDebuffs(frame)
    end
end)

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    function BigDebuffs:PLAYER_TALENT_UPDATE()
        local specID = GetSpecializationInfo(GetSpecialization() or 1)
        self.specDispel = specID and self.specDispelTypes[specID] and self.specDispelTypes[specID]
    end
end

function BigDebuffs:PLAYER_REGEN_ENABLED()
    for frame,_ in pairs(pending) do
        BigDebuffs:AddBigDebuffs(frame)
        pending[frame] = nil
    end
end

function BigDebuffs:IsPriorityDebuff(id)
    for i = 1, #BigDebuffs.PriorityDebuffs do
        if id == BigDebuffs.PriorityDebuffs[i] then
            return true
        end
    end
end

hooksecurefunc("CompactUnitFrame_HideAllDebuffs", HideBigDebuffs)

function BigDebuffs:IsDispellable(unit, dispelType)
    if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
        if (not dispelType) or (not self.dispelTypes) then return end
        if type(self.dispelTypes[dispelType]) == "function" then return self.dispelTypes[dispelType]() end

        -- dwarves can use Stoneform to remove diseases and poisons
        if (not self.dispelTypes[dispelType]) and
            unit == "player" and
            (dispelType == "Poison" or dispelType == "Disease")
        then
            return IsUsableSpell("Stoneform")
        end

        return self.dispelTypes[dispelType]
    else
        if not dispelType or not self.specDispel then return end
        if type(self.specDispel[dispelType]) == "function" then return self.specDispel[dispelType]() end
        return self.specDispel[dispelType]
    end
end

function BigDebuffs:GetDebuffSize(id, dispellable)
    if self.db.profile.raidFrames.pve > 0 then
        local _, instanceType = IsInInstance()
        if dispellable and instanceType and (instanceType == "raid" or instanceType == "party") then
            return self.db.profile.raidFrames.pve
        end
    end

    if not self.Spells[id] then return end
    id = self.Spells[id].parent or id -- Check for parent spellID

    local category = self.Spells[id].type

    if not category or not self.db.profile.raidFrames[category] then return end

    -- Check for user set
    if self.db.profile.spells[id] then
        if self.db.profile.spells[id].raidFrames and self.db.profile.spells[id].raidFrames == 0 then return end
        if self.db.profile.spells[id].size then return self.db.profile.spells[id].size end
    end

    if self.Spells[id].noraidFrames and
        (not self.db.profile.spells[id] or not self.db.profile.spells[id].raidFrames)
    then
        return
    end

    local dispellableSize = self.db.profile.raidFrames.dispellable[category]
    if dispellable and dispellableSize and dispellableSize > 0 then return dispellableSize end

    if self.db.profile.raidFrames[category] > 0 then
        return self.db.profile.raidFrames[category]
    end
end

-- For raid frames
function BigDebuffs:GetDebuffPriority(id)
    if not self.Spells[id] then return 0 end
    id = self.Spells[id].parent or id -- Check for parent spellID

    return self.db.profile.spells[id] and self.db.profile.spells[id].priority or
        self.db.profile.priority[self.Spells[id].type] or 0
end

-- For unit frames
function BigDebuffs:GetAuraPriority(id)
    if not self.Spells[id] then return end
    id = self.Spells[id].parent or id -- Check for parent spellID
	if not self.Spells[id] then return end

    -- Make sure category is enabled
    if not self.db.profile.unitFrames[self.Spells[id].type] then return end

    -- Check for user set
    if self.db.profile.spells[id] then
        if self.db.profile.spells[id].unitFrames and self.db.profile.spells[id].unitFrames == 0 then return end
        if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
    end

    if self.Spells[id].nounitFrames and
        (not self.db.profile.spells[id] or not self.db.profile.spells[id].unitFrames)
    then
        return
    end

    return self.db.profile.priority[self.Spells[id].type] or 0
end

-- For nameplates
function BigDebuffs:GetNameplatesPriority(id)
    if not self.Spells[id] then return end
    id = self.Spells[id].parent or id -- Check for parent spellID

    -- Make sure category is enabled
    if not self.db.profile.nameplates[self.Spells[id].type] then return end

    -- Check for user set
    if self.db.profile.spells[id] then
        if self.db.profile.spells[id].nameplates and self.db.profile.spells[id].nameplates == 0 then return end
        if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
    end

    if self.Spells[id].nonameplates and
        (not self.db.profile.spells[id] or not self.db.profile.spells[id].nameplates)
    then
        return
    end

    return self.db.profile.priority[self.Spells[id].type] or 0
end

if LibClassicDurations then
    hooksecurefunc("CompactUnitFrame_UtilSetBuff", function(buffFrame, unit, index, filter)
        if not LibClassicDurations then return end
        local name, icon, count, debuffType, duration, expirationTime, unitCaster,
            canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
        local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster)
        if duration == 0 and durationNew then
            duration = durationNew
            expirationTime = expirationTimeNew
        end
        local enabled = expirationTime and expirationTime ~= 0;
        if enabled then
            local startTime = expirationTime - duration;
            CooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);
        else
            CooldownFrame_Clear(buffFrame.cooldown);
        end
    end)
end

local function CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff, ...)
    local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff
    -- make sure you are using the correct index here!
    --isBossAura says make this look large.
    --isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, _, _, spellId = ...;

    if index == -1 then
        -- it's an interrupt
        local spell = BigDebuffs.units[UnitGUID(unit)]
        spellId = spell.spellId
        icon = GetSpellTexture(spellId)
        count = 1
        duration = spell.duration
        expirationTime = spell.expires
    else
        if name == nil then
            -- for backwards compatibility - this functionality will be removed in a future update
            if unit then
                if (isBossBuff) then
                    name, icon, count, debuffType, duration, expirationTime, unitCaster, _, _, spellId = UnitBuff(unit, index, filter);
                else
                    name, icon, count, debuffType, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff(unit, index, filter);
                end
            else
                return;
            end
        end
    end

    debuffFrame.filter = filter;
    debuffFrame.icon:SetTexture(icon);
    if ( count > 1 ) then
        local countText = count;
        if ( count >= 100 ) then
            countText = BUFF_STACKS_OVERFLOW;
        end
        debuffFrame.count:Show();
        debuffFrame.count:SetText(countText);
    else
        debuffFrame.count:Hide();
    end
    debuffFrame:SetID(index);

    if LibClassicDurations then
        local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster)
        if duration == 0 and durationNew then
            duration = durationNew
            expirationTime = expirationTimeNew
        end
    end

    local enabled = expirationTime and expirationTime ~= 0;
    if enabled then
        local startTime = expirationTime - duration;
        local text = debuffFrame.cooldown:GetRegions();
        text:SetFont(LibSharedMedia:Fetch("font", BigDebuffs.db.profile.raidFrames.cooldownFont),
            BigDebuffs.db.profile.raidFrames.cooldownFontSize, BigDebuffs.db.profile.raidFrames.cooldownFontEffect);
        CooldownFrame_Set(debuffFrame.cooldown, startTime, duration, true);
    else
        CooldownFrame_Clear(debuffFrame.cooldown);
    end

    local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
    debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

    debuffFrame.isBossBuff = isBossBuff;
    if ( isBossAura ) then
        local size = min(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.maxHeight);
        debuffFrame:SetSize(size, size);
    else
        debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize);
    end

    debuffFrame:Show();
end

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    local Default_CompactUnitFrame_Util_IsPriorityDebuff = CompactUnitFrame_Util_IsPriorityDebuff
    local function CompactUnitFrame_Util_IsPriorityDebuff(spellId)
        return BigDebuffs:IsPriorityBigDebuff(spellId) or Default_CompactUnitFrame_Util_IsPriorityDebuff(spellId)
    end

    local function SetDebuffsHelper(debuffFrames, frameNum, maxDebuffs, filter, isBossAura, isBossBuff, auras)
        if auras then
            for i = 1,#auras do
                local aura = auras[i];
                if frameNum > maxDebuffs then
                    break;
                end
                local debuffFrame = debuffFrames[frameNum];
                local index, name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId = aura[1], aura[2], aura[3], aura[4], aura[5], aura[6], aura[7], aura[8], aura[9], aura[10], aura[11];
                local unit = nil;
                CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff, name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId);
                frameNum = frameNum + 1;

                if isBossAura then
                    --Boss auras are about twice as big as normal debuffs, so we may need to display fewer buffs
                    local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize;
                    maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
                end
            end
        end
        return frameNum, maxDebuffs;
    end

    local function NumElements(arr)
        return arr and #arr or 0;
    end

    local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};

    local function CompactUnitFrame_CouldDisplayAura(auraInfo, ...)
        local displayOnlyDispellableDebuffs = ...;

        if auraInfo.isNameplateOnly then
            return false;
        end

        if auraInfo.isBossAura then
            return true;
        end

        if auraInfo.isHarmful and CompactUnitFrame_Util_IsPriorityDebuff(auraInfo.spellId) then
            return true;
        end

        if auraInfo.isHarmful and (not displayOnlyDispellableDebuffs) and CompactUnitFrame_Util_ShouldDisplayDebuff(auraInfo.sourceUnit, auraInfo.spellId) then
            return true;
        end

        if auraInfo.isHelpful and CompactUnitFrame_UtilShouldDisplayBuff(auraInfo.sourceUnit, auraInfo.spellId, auraInfo.canApplyAura) then
            return true;
        end

        local isHarmfulAndRaid = auraInfo.isHarmful and auraInfo.isRaid;
        if isHarmfulAndRaid and (not auraInfo.isBossAura) and displayOnlyDispellableDebuffs and CompactUnitFrame_Util_ShouldDisplayDebuff(auraInfo.sourceUnit, auraInfo.spellId) and (not CompactUnitFrame_Util_IsPriorityDebuff(auraInfo.spellId)) then
            return true;
        end

        if isHarmfulAndRaid and dispellableDebuffTypes[auraInfo.debuffType] ~= nil then
            return true;
        end

        return false;
    end

    hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame, isFullUpdate, updatedAuraInfos)

        if (not frame) or frame:IsForbidden() then return end

        if (not UnitIsPlayer(frame.displayedUnit)) then return end

        local displayOnlyDispellableDebuffs = frame.optionTable.displayOnlyDispellableDebuffs;

        -- if AuraUtil.ShouldSkipAuraUpdate(isFullUpdate, updatedAuraInfos, CompactUnitFrame_CouldDisplayAura, displayOnlyDispellableDebuffs) then
        --     return;
        -- end

        local doneWithBuffs = not frame.buffFrames or not frame.optionTable.displayBuffs or frame.maxBuffs == 0;
        local doneWithDebuffs = not frame.debuffFrames or not frame.optionTable.displayDebuffs or frame.maxDebuffs == 0;
        local doneWithDispelDebuffs = not frame.dispelDebuffFrames or not frame.optionTable.displayDispelDebuffs or frame.maxDispelDebuffs == 0;

        local numUsedBuffs = 0;
        local numUsedDebuffs = 0;
        local numUsedDispelDebuffs = 0;

        -- The following is the priority order for debuffs
        local bossDebuffs, bossBuffs, priorityDebuffs, nonBossDebuffs, nonBossRaidDebuffs;
        local index = 1;
        local batchCount = frame.maxDebuffs;

        if not doneWithDebuffs then
            AuraUtil.ForEachAura(frame.displayedUnit, "HARMFUL", batchCount, function(...)
                local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = ...;
                if isBossAura then
                    if not bossDebuffs then
                        bossDebuffs = {};
                    end
                    tinsert(bossDebuffs, {index, ...});
                    numUsedDebuffs = numUsedDebuffs + 1;
                    if numUsedDebuffs == frame.maxDebuffs then
                        doneWithDebuffs = true;
                        return true;
                    end
                elseif CompactUnitFrame_Util_IsPriorityDebuff(spellId) then
                    if not priorityDebuffs then
                        priorityDebuffs = {};
                    end
                    tinsert(priorityDebuffs, {index, ...});
                elseif not displayOnlyDispellableDebuffs and CompactUnitFrame_Util_ShouldDisplayDebuff(unitCaster, spellId) then
                    if not nonBossDebuffs then
                        nonBossDebuffs = {};
                    end
                    tinsert(nonBossDebuffs, {index, ...});
                end

                index = index + 1;
                return false;
            end);
        end

        if not doneWithBuffs or not doneWithDebuffs then
            local maxBuffs = BigDebuffs.db.profile.raidFrames.increaseBuffs and MAX_BUFFS or frame.maxBuffs
            index = 1;
            batchCount = math.max(frame.maxDebuffs, maxBuffs);
            AuraUtil.ForEachAura(frame.displayedUnit, "HELPFUL", batchCount, function(...)
                local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = ...;
                if isBossAura then
                    -- Boss Auras are considered Debuffs for our purposes.
                    if not doneWithDebuffs then
                        if not bossBuffs then
                            bossBuffs = {};
                        end
                        tinsert(bossBuffs, {index, ...});
                        numUsedDebuffs = numUsedDebuffs + 1;
                        if numUsedDebuffs == frame.maxDebuffs then
                            doneWithDebuffs = true;
                        end
                    end
                elseif CompactUnitFrame_UtilShouldDisplayBuff(unitCaster, spellId, canApplyAura) then
                    if not doneWithBuffs then
                        numUsedBuffs = numUsedBuffs + 1;
                        local buffFrame = frame.buffFrames[numUsedBuffs];
                        CompactUnitFrame_UtilSetBuff(buffFrame, index, ...);
                        if numUsedBuffs == maxBuffs then
                            doneWithBuffs = true;
                        end
                    end
                end

                index = index + 1;
                return doneWithBuffs and doneWithDebuffs;
            end);
        end

        numUsedDebuffs = math.min(frame.maxDebuffs, numUsedDebuffs + NumElements(priorityDebuffs));
        if numUsedDebuffs == frame.maxDebuffs then
            doneWithDebuffs = true;
        end

        if not doneWithDispelDebuffs then
            --Clear what we currently have for dispellable debuffs
            for debuffType, display in pairs(dispellableDebuffTypes) do
                if ( display ) then
                    frame["hasDispel"..debuffType] = false;
                end
            end
        end

        if not doneWithDispelDebuffs or not doneWithDebuffs then
            batchCount = math.max(frame.maxDebuffs, frame.maxDispelDebuffs);
            index = 1;
            AuraUtil.ForEachAura(frame.displayedUnit, "HARMFUL|RAID", batchCount, function(...)
                local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = ...;
                if not doneWithDebuffs and displayOnlyDispellableDebuffs then
                    if CompactUnitFrame_Util_ShouldDisplayDebuff(unitCaster, spellId) and not isBossAura and not CompactUnitFrame_Util_IsPriorityDebuff(spellId) then
                        if not nonBossRaidDebuffs then
                            nonBossRaidDebuffs = {};
                        end
                        tinsert(nonBossRaidDebuffs, {index, ...});
                        numUsedDebuffs = numUsedDebuffs + 1;
                        if numUsedDebuffs == frame.maxDebuffs then
                            doneWithDebuffs = true;
                        end
                    end
                end
                if not doneWithDispelDebuffs then
                    if ( dispellableDebuffTypes[debuffType] and not frame["hasDispel"..debuffType] ) then
                        frame["hasDispel"..debuffType] = true;
                        numUsedDispelDebuffs = numUsedDispelDebuffs + 1;
                        local dispellDebuffFrame = frame.dispelDebuffFrames[numUsedDispelDebuffs];
                        CompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
                        if numUsedDispelDebuffs == frame.maxDispelDebuffs then
                            doneWithDispelDebuffs = true;
                        end
                    end
                end
                index = index + 1;
                return (doneWithDebuffs or not displayOnlyDispellableDebuffs) and doneWithDispelDebuffs;
            end);
        end

        local frameNum = 1;
        local maxDebuffs = frame.maxDebuffs;

        do
            local isBossAura = true;
            local isBossBuff = false;
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HARMFUL", isBossAura, isBossBuff, bossDebuffs);
        end
        do
            local isBossAura = true;
            local isBossBuff = true;
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HELPFUL", isBossAura, isBossBuff, bossBuffs);
        end
        do
            local isBossAura = false;
            local isBossBuff = false;
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HARMFUL", isBossAura, isBossBuff, priorityDebuffs);
        end
        do
            local isBossAura = false;
            local isBossBuff = false;
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HARMFUL|RAID", isBossAura, isBossBuff, nonBossRaidDebuffs);
        end
        do
            local isBossAura = false;
            local isBossBuff = false;
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HARMFUL", isBossAura, isBossBuff, nonBossDebuffs);
        end
        numUsedDebuffs = frameNum - 1;

        CompactUnitFrame_HideAllBuffs(frame, numUsedBuffs + 1);
        CompactUnitFrame_HideAllDebuffs(frame, numUsedDebuffs + 1);
        CompactUnitFrame_HideAllDispelDebuffs(frame, numUsedDispelDebuffs + 1);

        BigDebuffs:ShowBigDebuffs(frame)
    end)
else
    local Default_CompactUnitFrame_UtilIsPriorityDebuff = CompactUnitFrame_UtilIsPriorityDebuff

    local function CompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)
        local _,_,_,_,_,_,_,_,_, spellId = UnitDebuff(unit, index, filter)
        return BigDebuffs:IsPriorityDebuff(spellId) or Default_CompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)
    end

    local function CompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

        local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");

        local showAllClassBuffs = BigDebuffs.db.profile.raidFrames.showAllClassBuffs and canApplyAura

        if ( hasCustom ) then
            return showForMySpec or (alwaysShowMine and (showAllClassBuffs or unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
        else
            return (showAllClassBuffs or unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
        end
    end

    local function CompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter)
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitDebuff(unit, index, filter);

        local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");

        local showAllClassBuffs = BigDebuffs.db.profile.raidFrames.showAllClassBuffs and canApplyAura

        if ( hasCustom ) then
            return showForMySpec or (alwaysShowMine and (showAllClassBuffs or unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );   --Would only be "mine" in the case of something like forbearance.
        else
            return true;
        end
    end

    hooksecurefunc("CompactUnitFrame_UpdateDebuffs", function(frame)
        if ( not frame.debuffFrames or not frame.optionTable.displayDebuffs ) then
            CompactUnitFrame_HideAllDebuffs(frame);
            return;
        end

        local index = 1;
        local frameNum = 1;
        local filter = nil;
        local maxDebuffs = frame.maxDebuffs;
        --Show both Boss buffs & debuffs in the debuff location
        --First, we go through all the debuffs looking for any boss flagged ones.
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false);
                    frameNum = frameNum + 1;
                    --Boss debuffs are about twice as big as normal debuffs, so display one less.
                    local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
                    maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
                end
            else
                break;
            end
            index = index + 1;
        end
        --Then we go through all the buffs looking for any boss flagged ones.
        index = 1;
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitBuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true);
                    frameNum = frameNum + 1;
                    --Boss debuffs are about twice as big as normal debuffs, so display one less.
                    local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
                    maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
                end
            else
                break;
            end
            index = index + 1;
        end

        --Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
        index = 1;
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) ) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end

        if ( frame.optionTable.displayOnlyDispellableDebuffs ) then
            filter = "RAID";
        end

        index = 1;
        --Now, we display all normal debuffs.
        if ( frame.optionTable.displayNonBossDebuffs ) then
        while ( frameNum <= maxDebuffs ) do
            local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
            if ( debuffName ) then
                if ( CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and
                    not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter)) then
                    local debuffFrame = frame.debuffFrames[frameNum];
                    CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        end

        for i=frameNum, frame.maxDebuffs do
            local debuffFrame = frame.debuffFrames[i];
            debuffFrame:Hide();
        end

        BigDebuffs:ShowBigDebuffs(frame)
    end)

    -- Show extra buffs
    hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(frame)
        if ( not frame.buffFrames or not frame.optionTable.displayBuffs ) then
            CompactUnitFrame_HideAllBuffs(frame);
            return;
        end

        if not UnitIsPlayer(frame.displayedUnit) then
            return
        end

        if (not BigDebuffs.db.profile.raidFrames.increaseBuffs) and
           (not BigDebuffs.db.profile.raidFrames.showAllClassBuffs)
        then
            return
        end

        local maxBuffs = BigDebuffs.db.profile.raidFrames.increaseBuffs and MAX_BUFFS or frame.maxBuffs

        local index = 1;
        local frameNum = 1;
        local filter = nil;
        while ( frameNum <= maxBuffs ) do
            local buffName = UnitBuff(frame.displayedUnit, index, filter);
            if ( buffName ) then
                if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
                    local buffFrame = frame.buffFrames[frameNum];
                    if buffFrame then
                        CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter);
                    end
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        for i=frameNum, maxBuffs do
            local buffFrame = frame.buffFrames[i];
            if buffFrame then
                buffFrame:Hide();
            end
        end
    end)
end

function BigDebuffs:ShowBigDebuffs(frame)
    if (not self.db.profile.raidFrames.enabled) or
        (not frame.debuffFrames) or
        (not frame.BigDebuffs) or
        (not self:ShowInRaids()) or
        (not UnitIsPlayer(frame.displayedUnit))
    then
        return
    end

    local UnitDebuff = self.test and UnitDebuffTest or UnitDebuff

    HideBigDebuffs(frame)

    local debuffs = {}
    local big
    local now = GetTime()
    local warning, warningId

    for i = 1, 40 do
        local _,_,_, dispelType, _, time, caster, _,_, id = UnitDebuff(frame.displayedUnit, i)
        if id then
            local reaction = caster and UnitReaction("player", caster) or 0
            local friendlySmokeBomb = id == 212183 and reaction > 4
            local size = self:GetDebuffSize(id, self:IsDispellable(frame.displayedUnit, dispelType))
            if size and not friendlySmokeBomb then
                big = true
                local duration = time and time - now or 0
                tinsert(debuffs, { i, size, duration, self:GetDebuffPriority(id) })
            elseif self.db.profile.raidFrames.redirectBliz or
            (self.db.profile.raidFrames.anchor == "INNER" and not self.db.profile.raidFrames.hideBliz) then
                if not frame.optionTable.displayOnlyDispellableDebuffs or
                    self:IsDispellable(frame.displayedUnit, dispelType)
                then
                    -- duration 0 to preserve Blizzard order
                    tinsert(debuffs, { i, self.db.profile.raidFrames.default, 0, 0 })
                end
            end

            -- Set warning debuff
            if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
                local k
                for j = 1, #self.WarningDebuffs do
                    if id == self.WarningDebuffs[j] and
                    self.db.profile.raidFrames.warningList[id] and
                    not friendlySmokeBomb and
                    (not k or j < k) then
                        k = j
                        warning = i
                        warningId = id
                    end
                end
            end

        end
    end

    -- check for interrupts
    local guid = UnitGUID(frame.displayedUnit)
    if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
        local spellId = self.units[guid].spellId
        local size = self:GetDebuffSize(spellId, false)
        if size then
            big = true
            tinsert(debuffs, { -1, size, 0, self:GetDebuffPriority(spellId) })
        end
    end

    if #debuffs > 0 then
        -- insert the warning debuff if it exists and we have a big debuff
        if big and warning then
            local size = self.db.profile.raidFrames.warning
            -- remove duplicate
            for k,v in pairs(debuffs) do
                if v[1] == warning then
                    if self.Spells[warningId] then size = v[2] end -- preserve the size
                    table.remove(debuffs, k)
                    break
                end
            end
            tinsert(debuffs, { warning, size, 0, 0, true })
        else
            warning = nil
        end

        -- sort by priority > size > duration > index
        table.sort(debuffs, function(a, b)
            if a[4] == b[4] then
                if a[2] == b[2] then
                    if a[3] < b[3] then return true end
                    if a[3] == b[3] then return a[1] < b[1] end
                end
                return a[2] > b[2]
            end
            return a[4] > b[4]
        end)

        local index = 1

        if self.db.profile.raidFrames.hideBliz or
        self.db.profile.raidFrames.anchor == "INNER" or
        self.db.profile.raidFrames.redirectBliz then
            CompactUnitFrame_HideAllDebuffs(frame)
        end

        for i = 1, #debuffs do
            if index <= self.db.profile.raidFrames.maxDebuffs or debuffs[i][1] == warning then
                if not frame.BigDebuffs[index] then break end
                frame.BigDebuffs[index].baseSize = frame:GetHeight() * debuffs[i][2] * 0.01
                CompactUnitFrame_UtilSetDebuff(frame.BigDebuffs[index],
                    frame.displayedUnit, debuffs[i][1], nil, false, false)
                frame.BigDebuffs[index].cooldown:SetSwipeColor(0, 0, 0, 0.7)
                index = index + 1
            end
        end
    end
end

function BigDebuffs:IsPriorityBigDebuff(id)
    if not self.Spells[id] then return end
    id = self.Spells[id].parent or id -- Check for parent spellID
    return self.Spells[id].priority
end

function BigDebuffs:UNIT_AURA(unit)
    if not self.db.profile.unitFrames.enabled or
        not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled or
        (GetNumGroupMembers() > 5 and unit:match("party"))
    then
        return
    end

    self:AttachUnitFrame(unit)

    local frame = self.UnitFrames[unit]
    if not frame then return end

    local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff

    local now = GetTime()
    local left, priority, duration, expires, icon, debuff, buff, interrupt = 0, 0

    for i = 1, 40 do
        -- Check debuffs
        local _, n, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
        if id then
            if self.Spells[id] then
                if LibClassicDurations then
                    local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, id, caster)
                    if d == 0 and durationNew then
                        d = durationNew
                        e = expirationTimeNew
                    end
                end
                local reaction = caster and UnitReaction("player", caster) or 0
                local friendlySmokeBomb = id == 212183 and reaction > 4
                local p = self:GetAuraPriority(id)
                if p and p >= priority and not friendlySmokeBomb then
                    if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
                        left = e - now
                        duration = d
                        debuff = i
                        priority = p
                        expires = e
                        icon = n
                    end
                end
            end
        end

        -- Check buffs
        if LibClassicDurations then
            _, n, _,_, d, e, caster, _,_, id = LibClassicDurations:UnitAura(unit, i, "HELPFUL")
        else
            _, n, _,_, d, e, caster, _,_, id = UnitBuff(unit, i)
        end
        if id then
            if self.Spells[id] then
                if LibClassicDurations then
                    local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, id, caster)
                    if d == 0 and durationNew then
                        d = durationNew
                        e = expirationTimeNew
                    end
                end
                local p = self:GetAuraPriority(id)
                if p and p >= priority then
                    if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
                        left = e - now
                        duration = d
                        debuff = i
                        priority = p
                        expires = e
                        icon = n
                        buff = true
                    end
                end
            end
        end
    end

    -- Check for interrupt
    local guid = UnitGUID(unit)
    if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
        local spell = self.units[guid]
        local spellId = spell.spellId
        local p = self:GetAuraPriority(spellId)
        if p and p >= priority then
            left = spell.expires - now
            duration = self.Spells[spellId].duration
            debuff = spellId
            expires = spell.expires
            icon = GetSpellTexture(spellId)
            interrupt = spellId
        end
    end


    if debuff then
        if duration < 1 then duration = 1 end -- auras like Solar Beam don't have a duration

        if frame.current ~= icon then
            if frame.blizzard then
                -- Blizzard Frame

                -- fix Obsidian Claw icon
                icon = icon == 611425 and 1508487 or icon

                frame.icon:SetTexture(icon)

                if not frame.mask then
                    frame.mask = frame:CreateMaskTexture()
                    frame.mask:SetAllPoints(frame.icon)
                    frame.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                    frame.icon:AddMaskTexture(frame.mask)
                end
            else
                frame.icon:SetTexture(icon)
            end
        end

        frame.cooldown:SetCooldown(expires - duration, duration)
        frame:Show()
        frame.cooldown:SetSwipeColor(0, 0, 0, 0.6)

        -- set for tooltips
        frame:SetID(debuff)
        frame.buff = buff
        frame.interrupt = interrupt
        frame.current = icon
		if GridStatusBigDebuffs then GridStatusBigDebuffs:SendGained(unit, icon, expires, duration) end
    else
        frame:Hide()
        frame.current = nil
        if GridStatusBigDebuffs then GridStatusBigDebuffs:SendLost(unit) end
    end
end

function BigDebuffs:UNIT_AURA_NAMEPLATE(unit)
    if not self.db.profile.nameplates.enabled then return end

    self:AttachNameplate(unit)

    local frame = self.Nameplates[unit]
    if not frame then return end

    local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff

    local now = GetTime()
    local left, priority, duration, expires, icon, debuff, buff, interrupt = 0, 0

    for i = 1, 40 do
        -- Check debuffs
        local _, n, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
        if id then
            if self.Spells[id] then
                if LibClassicDurations then
                    local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, id, caster)
                    if d == 0 and durationNew then
                        d = durationNew
                        e = expirationTimeNew
                    end
                end
                local reaction = caster and UnitReaction("player", caster) or 0
                local friendlySmokeBomb = id == 212183 and reaction > 4
                local p = self:GetNameplatesPriority(id)
                if p and p >= priority and not friendlySmokeBomb then
                    if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
                        left = e - now
                        duration = d
                        debuff = i
                        priority = p
                        expires = e
                        icon = n
                    end
                end
            end
        end

        -- Check buffs
        if LibClassicDurations then
            _, n, _,_, d, e, caster, _,_, id = LibClassicDurations:UnitAura(unit, i, "HELPFUL")
        else
            _, n, _,_, d, e, caster, _,_, id = UnitBuff(unit, i)
        end
        if id then
            if self.Spells[id] then
                if LibClassicDurations then
                    local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, id, caster)
                    if d == 0 and durationNew then
                        d = durationNew
                        e = expirationTimeNew
                    end
                end
                local p = self:GetNameplatesPriority(id)
                if p and p >= priority then
                    if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
                        left = e - now
                        duration = d
                        debuff = i
                        priority = p
                        expires = e
                        icon = n
                        buff = true
                    end
                end
            end
        end
    end

    -- Check for interrupt
    local guid = UnitGUID(unit)
    if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
        local spell = self.units[guid]
        local spellId = spell.spellId
        local p = self:GetNameplatesPriority(spellId)
        if p and p >= priority then
            left = spell.expires - now
            duration = self.Spells[spellId].duration
            debuff = spellId
            expires = spell.expires
            icon = GetSpellTexture(spellId)
            interrupt = spellId
        end
    end


    if debuff then
        if duration < 1 then duration = 1 end -- auras like Solar Beam don't have a duration

        if frame.current ~= icon then
            frame.icon:SetTexture(icon)
        end

        frame.cooldown:SetCooldown(expires - duration, duration)
        frame:Show()
        frame.cooldown:SetSwipeColor(0, 0, 0, 0.6)

        -- set for tooltips
        frame:SetID(debuff)
        frame.buff = buff
        frame.interrupt = interrupt
        frame.current = icon
    else
        frame:Hide()
        frame.current = nil
    end

    --Hide/Disable auras which shouldn't be shown. Seems to fix false icons from appearing and getting stuck.
    if frame.current ~= nil and (not unit:find("nameplate")
        or (not UnitCanAttack("player", unit) and not self.db.profile.nameplates.friendly)
        or (UnitCanAttack("player", unit) and not self.db.profile.nameplates.enemy)
        or (not UnitIsPlayer(unit) and not self.db.profile.nameplates.npc)
        or (UnitIsUnit("player", unit)))
    then
        frame:Hide()
        frame.current = nil
    end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
    self:UNIT_AURA("focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
    self:UNIT_AURA("target")
end

function BigDebuffs:UNIT_PET()
    self:UNIT_AURA("pet")
end

function BigDebuffs:NAME_PLATE_UNIT_ADDED(_, unit)
    local namePlate = C_NamePlate.GetNamePlateForUnit(unit)

    if namePlate:IsForbidden() then return end

    local anchor, frame

    for k, v in ipairs(nameplatesAnchors) do
        if v.used(namePlate) then
            anchor, frame = v.func(namePlate)
            break
        end
    end

    if not frame or not anchor or frame:IsForbidden() then return end

    if not frame.BigDebuffs then
        frame.BigDebuffs = CreateFrame("Frame", "$parent.BigDebuffs", frame)
        frame.BigDebuffs:SetFrameLevel(frame:GetFrameLevel())

        frame.BigDebuffs.icon = frame.BigDebuffs:CreateTexture("$parent.Icon", "OVERLAY", nil, 3)
        frame.BigDebuffs.icon:SetAllPoints(frame.BigDebuffs)

        frame.BigDebuffs.cooldown = CreateFrame("Cooldown", "$parent.Cooldown", frame.BigDebuffs, "CooldownFrameTemplate")
        frame.BigDebuffs.cooldown:SetAllPoints(frame.BigDebuffs)
        frame.BigDebuffs.cooldown:SetDrawEdge(false)
        frame.BigDebuffs.cooldown:SetAlpha(1)
        frame.BigDebuffs.cooldown:SetDrawBling(false)
        frame.BigDebuffs.cooldown:SetDrawSwipe(true)
        frame.BigDebuffs.cooldown:SetReverse(true)

        if frame:IsForbidden() then return end
        frame.BigDebuffs:SetScript("OnEnter", function(self)
            if NamePlateTooltip:IsForbidden() then return end
            if ( BigDebuffs.db.profile.nameplates.tooltips ) then
                if self:IsForbidden() then return end
                NamePlateTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
                if self.interrupt then
                    NamePlateTooltip:SetSpellByID(self.interrupt)
                elseif self.buff then
                    NamePlateTooltip:SetUnitBuff(self.unit, self:GetID());
                else
                    NamePlateTooltip:SetUnitDebuff(self.unit, self:GetID());
                end
            elseif NamePlateTooltip:IsOwned(self) then
                NamePlateTooltip:Hide();
            end
        end)

        frame.BigDebuffs:SetScript("OnLeave", function()
            if NamePlateTooltip:IsForbidden() then return end
            NamePlateTooltip:Hide()
        end)
    end

    frame.BigDebuffs.anchor = anchor

    self.Nameplates[unit] = frame.BigDebuffs

    frame.BigDebuffs.unit = unit
    frame.BigDebuffs:RegisterUnitEvent("UNIT_AURA", unit)
    frame.BigDebuffs:SetScript("OnEvent", function()
        self:UNIT_AURA_NAMEPLATE(unit)
    end)

    self:UNIT_AURA_NAMEPLATE(unit)

    table.insert(unitsWithRaid, unit)
end

function BigDebuffs:NAME_PLATE_UNIT_REMOVED(_, unit)
    local frame = self.Nameplates[unit]

    if frame then frame:UnregisterEvent("UNIT_AURA") end

    for i = 1, #unitsWithRaid do
        if (unitsWithRaid[i] == unit) then
            table.remove(unitsWithRaid, i)
        end
    end
end

function BigDebuffs:ShowInRaids()
    local grpSize = GetNumGroupMembers();
    local inRaid = self.db.profile.raidFrames.inRaid;
    if ( inRaid.hide and grpSize > inRaid.size ) then
        return false;
    end

    return true;
end

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
    InterfaceOptionsFrame_OpenToCategory(addonName)
    InterfaceOptionsFrame_OpenToCategory(addonName)
end
