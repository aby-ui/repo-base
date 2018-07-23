
local _, _NS = ...
local L = _NS.L
U1Profiles = {}
local P = U1Profiles

local format = format
local wipe = wipe
local pairs = pairs


local function copyTable(src, dest)
	if (type(dest) ~= "table") or (src == dest) then dest = {} end
	if type(src) == "table" then
        wipe(dest);
		for k,v in pairs(src) do
			if type(v) == "table" then
				-- try to index the key first so that the metatable creates the defaults, if set, and use that table
				v = copyTable(v, dest[k])
			end
			dest[k] = v
		end
	end
	return dest
end

local function checkNCreate(tbl, key)
    if(not tbl[key]) then
        tbl[key] = {}
    end
    return tbl[key]
end

local function upgradeProfile(prof)
    -- local c = prof.config
    -- if(c) then
    --     c.u1dbaddons = (c.u1dbaddons or c.u1dbconfigs)
    --     c.u1dbconfigs = nil
    -- end
end

local function sortByDate(a, b)
    return a.savedate > b.savedate
end

function P:Initialize()
    U1DBG.profiles = U1DBG.profiles or {}
    checkNCreate(U1DBG, 'profiles')

    self.db = U1DBG.profiles

    checkNCreate(self.db, 'auto')
    checkNCreate(self.db, 'manual')

    for _, k in next, { 'auto', 'manual' } do
        for _,  v in next, self.db[k] do
            upgradeProfile(v)
        end
    end

    P.Initialize = nil
end

function P:Show()
    if(not self.Frame) then
        self.Frame = self:CreateFrame()
    else
        self.Frame:Show()
    end
end

function P:GetProfileByIndex(index ,ptype)
    return self.db[ptype] and self.db[ptype][index]
end

function P:GetProfileByName(name, ptype)
    for index, prof in self:IterateProfiles(ptype) do
        if(prof.name == name) then
            return prof, index
        end
    end
end

function P:GetProfile(name, ptype)
    if(type(name) == 'number') then
        return self:GetProfileByIndex(name, ptype)
    else
        return self:GetProfileByName(name, ptype)
    end
end

function P:IterateProfiles(ptype)
    return next, self.db and self.db[ptype] or _empty_table
end

function P:GetNumProfiles(ptype)
    return self.db and #self.db[ptype]
end

function P:CreateProfile(name, ptype)
    assert(ptype, 'must give a type')
    assert(name, 'must give a name')

    local prof = self:NewProfile()
    prof.name = name
    prof.ptype = ptype
    prof.config = {
        -- defaults ?
        --u1db = true,
    }

    table.insert(self.db[ptype], prof)

    --print('P:CreateProfile returns', prof, #self.db[ptype])
    return prof, #self.db[ptype]
end

function P:NewProfile()
    return {
        --U1DBG = {},
        --time = time(),
    }
end

function P:EditProfileOption(prof, opts)
    for k, v in next, opts do
        prof.config[k] = v
    end
end

function P:RemoveProfile(index, ptype)
    assert(type(index) == 'number', 'index is not numeric.')
    table.remove(self.db[ptype], index or index)
end

function P:SaveProfile(prof)
    if(prof.config.u1dbconfigs) then
        prof.u1dbconfigs = copyTable(U1DB.configs, prof.u1dbconfigs)
        prof.u1dbframes = copyTable(U1DB.frames, prof.u1dbframes)
        prof.u1dbignoreList = copyTable(U1DB.ignoreList, prof.u1dbignoreList)
        prof.u1dbcollectList = copyTable(U1DB.collectList, prof.u1dbcollectList)
    else
        prof.u1dbconfigs = nil
        prof.u1dbframes = nil
        prof.u1dbignoreList = nil
        prof.u1dbcollectList = nil
    end

    if(prof.config.u1dbaddons) then
        prof.u1dbaddons = copyTable(U1DB.addons, prof.u1dbaddons)
    else
        prof.u1dbaddons = nil
    end

    prof.savedate = time()
    prof.class = select(2, UnitClass'player')
    prof.user = UnitName'player'
    prof.realm = GetRealmName()

    table.sort(self.db.auto, sortByDate)
    table.sort(self.db.manual, sortByDate)
end

function P:LoadProfile(prof, opts)
    assert(prof and opts, "[U1Profiles:LoadProfile] usage: prof, opts")

    self:BackupSession(L["Before Load Profile"])

    if(opts.u1dbconfigs and prof.u1dbconfigs) then
        U1DB.configs = copyTable(prof.u1dbconfigs, U1DB.configs)
        U1DB.frames = copyTable(prof.u1dbframes, U1DB.frames)
        U1DB.ignoreList = copyTable(prof.u1dbignoreList, U1DB.ignoreList)
        U1DB.collectList = copyTable(prof.u1dbcollectList, U1DB.collectList)
    end

    if(opts.u1dbaddons and prof.u1dbaddons) then
        U1DB.addons = copyTable(prof.u1dbaddons, U1DB.addons)
        self:EnableOrDisableAddOn(U1DB.addons)
    end
end

function P:EnableOrDisableAddOn(addons)
    if(addons) then
        for k, v in pairs(addons) do
            local origin = GetAddOnEnableState(U1PlayerName,k)>=2
            if v==1 then
                if not origin then EnableAddOn(k) end
            else
                if origin then DisableAddOn(k) end
            end
        end
    end
end

local backup_type = 'auto'
local backup_opts = { 
    u1dbaddons = true,
    u1dbconfigs = true,
}
local _has_backed_up = false
local _player, _realm = (UnitName'player'), GetRealmName()

function P:BackupSession(key)
    --print(key, _has_backed_up)
    if(not _has_backed_up) then
        _has_backed_up = true
    else
        return
    end

    local prof
    -- go through profiles to find the one for current user
    for index, profile in self:IterateProfiles(backup_type) do
        if(profile.name == key and profile.user == _player and profile.realm == _realm) then
            prof = profile
            break
        end
    end

    -- if not found , start a new one
    if(not prof) then
        prof = self:CreateProfile(key, backup_type)
        self:EditProfileOption(prof, backup_opts)
    end

    prof.num_addons = nil
    self:SaveProfile(prof)
end

local eventFrame = CreateFrame'Frame'
P.eventFrame = eventFrame

local reloading
eventFrame:SetScript('OnEvent', function(self, event)
    if(event == 'VARIABLES_LOADED') then
        if P.Initialize then P:Initialize() end
    elseif event == 'PLAYER_LOGIN' then
        if P.Initialize then
            self:UnregisterEvent("VARIABLES_LOADED")
            P:Initialize()
        end
        local last_time = U1DB.last_logout_time
        -- ignore reload login event, and login soon after logout in 1 hour
        if last_time ~= "reload" and (last_time == nil or time() - last_time > 60 * 60) then
            if(UnitLevel("player") >= 10) then
                P:BackupSession(L["After Login"])
            end
        end
    elseif event == 'PLAYER_LOGOUT' then
        U1DB.last_logout_time = reloading and "reload" or time()
        if(not reloading and UnitLevel("player") >= 10) then
            P:BackupSession(L["Before Logout"])
        end
    end
end)

eventFrame:RegisterEvent'VARIABLES_LOADED'
eventFrame:RegisterEvent'PLAYER_LOGOUT'
eventFrame:RegisterEvent'PLAYER_LOGIN'

hooksecurefunc("ReloadUI", function()
    reloading = true
end)
