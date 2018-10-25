local addonName, vars = ...
local L = vars.L

local Skada = Skada

local mod = Skada:NewModule(L["Explosive Orbs"])
local spellmod = Skada:NewModule(L["Explosive Orbs"].." - "..L["Number of player spells"])

local DEBUG = false
local debug = function(...) if DEBUG then print(...) end end
local ORB_NPC = "120651"
local in_challenge_with_orb

local orbs_curr = {}
local orbs_total = {}

local targets = {} --target[1]="party<1>"  target["party1"]="party1target"

-- record target change event for set
local function log_orb_click(set, playerid, id, orbs)
    if not in_challenge_with_orb and not DEBUG then return end
    if not set or not set.players or not playerid or not id then return end
	local player = Skada:get_player(set, playerid)
	if not player then return end
    debug("click", set.name, player.orb_click, player.orb_hit, set.orb_count)

    if not orbs[id] then
        set.orb_count = set.orb_count + 1
        orbs[id] = {}
    end

    -- bit1 targeted, bit2 hit. so 1 or 3 means targeted, 2 or 3 means hits
    local flag = orbs[id][player.id] or 0
    if flag~=1 and flag~=3 then
        orbs[id][player.id] = flag + 1 -- mark as counted
        player.orb_click = player.orb_click + 1
        debug("click", set.name, player.orb_click, player.orb_hit, set.orb_count)
    end
end

local function TargetChange(self, event, unitid)
    local guid = UnitGUID(targets[unitid])
    if not guid then return end
    local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid)
    if not DEBUG and npc_id ~= ORB_NPC then return end
    local playerid = UnitGUID(unitid)
    log_orb_click(Skada.current, playerid, guid, orbs_curr)
    log_orb_click(Skada.total, playerid, guid, orbs_total)
end

local event_frames = {}
for i=1, 5 do
    local unitid = (i == 5) and "player" or "party" .. i
    targets[i] = unitid
    targets[unitid] = unitid .. "target"
    event_frames[i] = CreateFrame("Frame")
    event_frames[i]:SetScript("OnEvent", TargetChange)
end

local function RegisterOrUnregisterUnitTargetEvent(reg)
    for i, f in ipairs(event_frames) do
        if reg then
            f:RegisterUnitEvent("UNIT_TARGET", targets[i])
        else
            f:UnregisterEvent("UNIT_TARGET")
        end
    end
end

local state_frame = CreateFrame("Frame")
state_frame:RegisterEvent("CHALLENGE_MODE_START")
state_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
state_frame:SetScript("OnEvent", function()
    local level, affixes, wasEnergized = C_ChallengeMode.GetActiveKeystoneInfo();
    if affixes and (affixes[1] == 13 or affixes[2] == 13 or affixes[3] == 13) then
        RegisterOrUnregisterUnitTargetEvent(true)
        in_challenge_with_orb = true
    else
        RegisterOrUnregisterUnitTargetEvent(false)
        in_challenge_with_orb = false
    end
end)

local function log_orb_hit(set, dmg, orbs)
    if not set or not set.players then return end
	local player = Skada:get_player(set, dmg.playerid, dmg.playername)
	if not player then return end

    local id = dmg.targetid
    if not orbs[id] then
        set.orb_count = set.orb_count + 1
        orbs[id] = {}
    end

    -- bit1 targeted, bit2 hit. so 1 or 3 means targeted, 2 or 3 means hits
    local flag = orbs[id][player.id] or 0
    if flag~=2 and flag~=3 then
        orbs[id][player.id] = flag + 2 -- mark as counted
        player.orb_hit = player.orb_hit + 1
        debug("hit", set.name, player.orb_click, player.orb_hit, set.orb_count)
    end

    -- Add spell to player if it does not exist.
    if not player.orb_spells[dmg.spellname] then
        player.orb_spells[dmg.spellname] = {id = dmg.spellid, name = dmg.spellname, count = 0}
    end
		
    -- Get the spell from player.
    local spell = player.orb_spells[dmg.spellname]
    spell.count = spell.count + 1
end

local dmg = {}

local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    if not in_challenge_with_orb and not DEBUG then return end
	local spellId, spellName, spellSchool, amount, overkill, school, resist, block, absorb = ...
    if not amount or amount <= 0 then return end
    local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", dstGUID)
    if not DEBUG and npc_id ~= ORB_NPC then return end

	dmg.playerid = srcGUID
	dmg.playername = srcName
	dmg.spellid = spellId
	dmg.spellname = spellName
	dmg.amount = (amount or 0) + (overkill or 0) + (absorb or 0)
	dmg.targetid = dstGUID
	dmg.targetname = dstName
	
	log_orb_hit(Skada.current, dmg, orbs_curr)
	log_orb_hit(Skada.total, dmg, orbs_total)
end

local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, GetSpellInfo(6603), "spellShcool", ...)
end

function mod:Update(win, set)
	local max = 0
	
	local nr = 1
	for i, player in ipairs(set.players) do
		if player.orb_hit > 0 or player.orb_click > 0 then
			local d = win.dataset[nr] or {}
			win.dataset[nr] = d

			d.label = player.name
			d.value = player.orb_hit
			d.valuetext = "选:" .. player.orb_click .. " 击:" .. player.orb_hit..(" (%02.1f%%)"):format(player.orb_hit / set.orb_count * 100)
			d.id = player.id
			d.class = player.class
			
			if player.orb_hit > max then
				max = player.orb_hit
			end
			nr = nr + 1
		end
	end
	
	-- Sort the possibly changed bars.
	win.metadata.maxvalue = max
end

function spellmod:Enter(win, id, label)
	spellmod.playerid = id
	spellmod.title = label..": "..L["Explosive Orbs"]
end

-- Detail view of a player - spells.
function spellmod:Update(win, set)
	-- View spells for this player.

	local player = Skada:find_player(set, self.playerid)

    local max = 0
	local nr = 1
	if player then
		for spellname, spell in pairs(player.orb_spells) do
				
			local d = win.dataset[nr] or {}
			win.dataset[nr] = d
			
			d.label = spellname
			d.value = spell.count
			d.icon = select(3, GetSpellInfo(spell.id))
			d.id = spellname
			d.spellid = spell.id
			d.valuetext = Skada:FormatNumber(spell.count)

            if spell.count > max then
                max = spell.count
            end
			
			nr = nr + 1
		end
		
		-- Sort the possibly changed bars.
		win.metadata.maxvalue = max
	end
end

function mod:OnEnable()
	spellmod.metadata 		= {}
	mod.metadata 			= {click1 = spellmod, showspots = true, icon = 135799 } --select(3, C_ChallengeMode.GetAffixInfo(13))

	Skada:RegisterForCL(SpellDamage, 'SPELL_DAMAGE', {src_is_interesting = true})
	Skada:RegisterForCL(SpellDamage, 'SPELL_PERIODIC_DAMAGE', {src_is_interesting = true})
	Skada:RegisterForCL(SpellDamage, 'SPELL_BUILDING_DAMAGE', {src_is_interesting = true})
	Skada:RegisterForCL(SpellDamage, 'RANGE_DAMAGE', {src_is_interesting = true})
	Skada:RegisterForCL(SwingDamage, 'SWING_DAMAGE', {src_is_interesting = true})

    RegisterOrUnregisterUnitTargetEvent(true)
	Skada:AddMode(self)
end

function mod:OnDisable()
    RegisterOrUnregisterUnitTargetEvent(false)
	Skada:RemoveMode(self)
end

-- Called by Skada when a new player is added to a set.
function mod:AddPlayerAttributes(player)
    debug("new player", player.name, player.orb_hit)
	if not player.orb_hit then
		player.orb_hit = 0
        player.orb_click = 0
		player.orb_spells = {}
	end
    for i, unitid in ipairs(targets) do TargetChange(nil, nil, unitid) end
end

-- Called by Skada when a new set is created.
function mod:AddSetAttributes(set)
    debug("new set", set.name, set.orb_count)
    wipe(orbs_curr)
    wipe(orbs_total)
	if not set.orb_count then
		set.orb_count = 0
    end
    for i, unitid in ipairs(targets) do TargetChange(nil, nil, unitid) end
end

function mod:GetSetSummary(set)
	return Skada:FormatNumber(set.orb_count)
end