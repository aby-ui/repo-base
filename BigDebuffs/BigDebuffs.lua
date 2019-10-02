--print("|cff00dfff[BigDebuffs-v4.9]|r原作者|c00FF9900Curse:Jordon|r,由|c00FF9900NGA:伊甸外|r于7.23日翻译修改,输入|cff33ff99/bd|r设置.")
--翻译汉化修改：NGA  @伊甸外  barristan@sina.com  http://bbs.ngacn.cc/nuke.php?func=ucp&uid=7350579
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
            default = 30,
            special = 30,
            pve = 50,
            warningList = {
                [212183] = true, -- Smoke Bomb
                [81261] = true, -- Solar Beam
                [233490] = true, -- Unstable Affliction
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
                size = 50,
            },
            target = {
                enabled = true,
                anchor = "auto",
                size = 50,
            },
            pet = {
                enabled = true,
                anchor = "auto",
                size = 50,
            },
            party = {
                enabled = true,
                anchor = "auto",
                size = 50,
            },
            cc = true,
            interrupts = true,
            immunities = true,
            immunities_spells = true,
            buffs_defensive = true,
            buffs_offensive = true,
            buffs_other = true,
            roots = true,
        },
        priority = {
            immunities = 80,
            immunities_spells = 70,
            cc = 60,
            interrupts = 55,
            buffs_defensive = 50,
            buffs_offensive = 40,
            buffs_other = 30,
            roots = 51,
            special = 19,
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
        },
        WARLOCK = {
            -- Felhunter's Devour Magic or Doomguard's Dispel Magic
            Magic = function() return IsUsableSpell(GetSpellInfo(19736)) or IsUsableSpell(GetSpellInfo(19476)) end,
        },
    }
    BigDebuffs.dispelTypes = classDispel[select(2, UnitClass("player"))] or {}
else
    defaults.profile.unitFrames.focus = {
        enabled = true,
        anchor = "auto",
        size = 50,
    }

    defaults.profile.unitFrames.arena = {
        enabled = true,
        anchor = "auto",
        size = 50,
    }

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
}

local anchors = {
    ["ElvUI"] = {
        noPortait = true,
        units = {
            player = "ElvUF_Player",
            pet = "ElvUF_Pet",
            target = "ElvUF_Target",
            focus = "ElvUF_Focus",
            party1 = "ElvUF_PartyGroup1UnitButton1",
            party2 = "ElvUF_PartyGroup1UnitButton2",
            party3 = "ElvUF_PartyGroup1UnitButton3",
            party4 = "ElvUF_PartyGroup1UnitButton4",
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
            }
        end
    end

    self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
    self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
    self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
    self.frames = {}
    self.UnitFrames = {}
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
                    frame.blizzard = k == "Blizzard"
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

        if frame.noPortait then
            -- No portrait, so attach to the side
            if frame.alignLeft then
                frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
            else
                frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
            end
            local height = frame.anchor:GetHeight()
            frame:SetSize(height, height)
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

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        self:RegisterEvent("PLAYER_TALENT_UPDATE")
        self:RegisterEvent("PLAYER_FOCUS_CHANGED")
        self:PLAYER_TALENT_UPDATE()
    end

    -- (finish animations deprecated in latest OmniCC)
    -- Prevent OmniCC finish animations
    if OmniCC and OmniCC.TriggerEffect then
        self:RawHook(OmniCC, "TriggerEffect", function(object, cooldown)
            local name = cooldown:GetName()
            if name and name:find(addonName) then return end
            self.hooks[OmniCC].TriggerEffect(object, cooldown)
        end, true)
    end

    InsertTestDebuff(8122, "Magic") -- Psychic Scream
    InsertTestDebuff(408, nil) -- Kidney Shot

    if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
        InsertTestDebuff(233490, "Magic") -- Unstable Affliction
        InsertTestDebuff(114404, nil) -- Void Tendrils
    end

    InsertTestDebuff(339, "Magic") -- Entangling Roots
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
            local _, class = UnitClass(unit)

            if UnitBuffByName(unit, "Calming Waters") then
                duration = duration * 0.5
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

        if not unit:match("^raid") then
            self:UNIT_AURA(unit)
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
            if self.db.profile.raidFrames.anchor == "INNER" then
                big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "LEFT" then
                big:SetPoint("BOTTOMRIGHT", frame.BigDebuffs[i-1], "BOTTOMLEFT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "RIGHT" then
                big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
            end
        else
            if self.db.profile.raidFrames.anchor == "INNER" then
                big:SetPoint("BOTTOMLEFT", frame.debuffFrames[1], "BOTTOMLEFT", 0, 0)
            elseif self.db.profile.raidFrames.anchor == "LEFT" then
                big:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, 1)
            elseif self.db.profile.raidFrames.anchor == "RIGHT" then
                big:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 1)
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

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
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

local function IsPriorityDebuff(id)
    for i = 1, #BigDebuffs.PriorityDebuffs do
        if id == BigDebuffs.PriorityDebuffs[i] then
            return true
        end
    end
end

hooksecurefunc("CompactUnitFrame_HideAllDebuffs", HideBigDebuffs)

function BigDebuffs:IsDispellable(unit, dispelType)
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        -- if stoneform is usable and it's on player
        if not dispelType then return end
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

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    local Default_CompactUnitFrame_UtilIsPriorityDebuff = CompactUnitFrame_UtilIsPriorityDebuff

    local function CompactUnitFrame_UtilIsPriorityDebuff(...)
        local default = Default_CompactUnitFrame_UtilIsPriorityDebuff(...)
        local _,_,_,_,_,_,_,_,_, spellId = UnitDebuff(...)
        return BigDebuffs:IsPriorityBigDebuff(spellId) or default
    end

    local Default_CompactUnitFrame_UpdateDebuffs = CompactUnitFrame_UpdateDebuffs
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
    local MAX_BUFFS = 6
    hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(frame)
        if not UnitIsPlayer(frame.displayedUnit) then
            return
        end

        if not BigDebuffs.db.profile.raidFrames.increaseBuffs then return end

        if ( not frame.optionTable.displayBuffs ) then
            CompactUnitFrame_HideAllBuffs(frame);
            return;
        end

        local index = 1;
        local frameNum = 1;
        local filter = nil;
        while ( frameNum <= 6 ) do
            local buffName = UnitBuff(frame.displayedUnit, index, filter);
            if ( buffName ) then
                if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and
                    not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) )
                then
                    local buffFrame = frame.buffFrames[frameNum];
                    CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter);
                    frameNum = frameNum + 1;
                end
            else
                break;
            end
            index = index + 1;
        end
        for i=frameNum, 6 do
            local buffFrame = frame.buffFrames[i];
            if buffFrame then buffFrame:Hide() end
        end
    end)
else
    local Default_CompactUnitFrame_Util_IsPriorityDebuff = CompactUnitFrame_Util_IsPriorityDebuff
    local function CompactUnitFrame_Util_IsPriorityDebuff(...)
        local default = Default_CompactUnitFrame_Util_IsPriorityDebuff(...)
        local spellId = select(10, ...)
        return BigDebuffs:IsPriorityBigDebuff(spellId) or default
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
                CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, "HARMFUL", isBossAura, isBossBuff, name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId);
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

    local MAX_BUFFS = 6
    hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
        if not UnitIsPlayer(frame.displayedUnit) then
            return
        end

        local doneWithBuffs = not frame.buffFrames or not frame.optionTable.displayBuffs or frame.maxBuffs == 0;
        local doneWithDebuffs = not frame.debuffFrames or not frame.optionTable.displayDebuffs or frame.maxDebuffs == 0;
        local doneWithDispelDebuffs = not frame.dispelDebuffFrames or not frame.optionTable.displayDispelDebuffs or frame.maxDispelDebuffs == 0;

        local numUsedBuffs = 0;
        local numUsedDebuffs = 0;
        local numUsedDispelDebuffs = 0;

        local displayOnlyDispellableDebuffs = frame.optionTable.displayOnlyDispellableDebuffs;

        -- The following is the priority order for debuffs
        local bossDebuffs, bossBuffs, priorityDebuffs, nonBossDebuffs;
        local index = 1;
        local batchCount = frame.maxDebuffs;

        if not doneWithDebuffs then
            AuraUtil.ForEachAura(frame.displayedUnit, "HARMFUL", batchCount, function(...)
                if CompactUnitFrame_Util_IsBossAura(...) then
                    if not bossDebuffs then
                        bossDebuffs = {};
                    end
                    tinsert(bossDebuffs, {index, ...});
                    numUsedDebuffs = numUsedDebuffs + 1;
                    if numUsedDebuffs == frame.maxDebuffs then
                        doneWithDebuffs = true;
                        return true;
                    end
                elseif CompactUnitFrame_Util_IsPriorityDebuff(...) then
                    if not priorityDebuffs then
                        priorityDebuffs = {};
                    end
                    tinsert(priorityDebuffs, {index, ...});
                elseif not displayOnlyDispellableDebuffs and CompactUnitFrame_Util_ShouldDisplayDebuff(...) then
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
                if CompactUnitFrame_Util_IsBossAura(...) then
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
                elseif CompactUnitFrame_UtilShouldDisplayBuff(...) then
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
                if not doneWithDebuffs and displayOnlyDispellableDebuffs then
                    if CompactUnitFrame_Util_ShouldDisplayDebuff(...) and not CompactUnitFrame_Util_IsBossAura(...) and not CompactUnitFrame_Util_IsPriorityDebuff(...) then
                        if not nonBossDebuffs then
                            nonBossDebuffs = {};
                        end
                        tinsert(nonBossDebuffs, {index, ...});
                        numUsedDebuffs = numUsedDebuffs + 1;
                        if numUsedDebuffs == frame.maxDebuffs then
                            doneWithDebuffs = true;
                        end
                    end
                end
                if not doneWithDispelDebuffs then
                    local debuffType = select(4, ...);
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
            frameNum, maxDebuffs = SetDebuffsHelper(frame.debuffFrames, frameNum, maxDebuffs, "HARMFUL|RAID", isBossAura, isBossBuff, nonBossDebuffs);
        end
        numUsedDebuffs = frameNum - 1;

        CompactUnitFrame_HideAllBuffs(frame, numUsedBuffs + 1);
        CompactUnitFrame_HideAllDebuffs(frame, numUsedDebuffs + 1);
        CompactUnitFrame_HideAllDispelDebuffs(frame, numUsedDispelDebuffs + 1);

        BigDebuffs:ShowBigDebuffs(frame)
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
        not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled
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
        _, n, _,_, d, e, caster, _,_, id = UnitBuff(unit, i)
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
                SetPortraitToTexture(frame.icon, icon)

                -- Adapt
                -- if frame.anchor and Adapt and Adapt.portraits[frame.anchor] then
                --  Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("BACKGROUND")
                -- end
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
        -- Adapt
        -- if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
        --  Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
        -- end

        frame:Hide()
        frame.current = nil
		if GridStatusBigDebuffs then GridStatusBigDebuffs:SendLost(unit) end
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
