local UnitBuff, UnitDebuff = UnitBuff, UnitDebuff
local UnitName, UnitClass, UnitVehicleSeatInfo, UnitAura, UnitIsPlayer, UnitPlayerControlled, sub = _G.UnitName, _G.UnitClass, _G.UnitVehicleSeatInfo, _G.UnitAura, _G.UnitIsPlayer, _G.UnitPlayerControlled, _G.string.sub

local co = setmetatable({}, {__index = function(t, cl)
    cl = cl or "UNKNOWN"
	local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[cl] or RAID_CLASS_COLORS[cl]
	if c then
		t[cl] = ("ff%02x%02x%02x"):format(c.r * 255, c.g * 255, c.b * 255)
	else
		t[cl] = "ffffffff"
	end
	return t[cl]
end })

function CastByHook(auraFunc, ...)
    if IsAddOnLoaded("TipTac") then return end
	local _, uid, id, f = ...
	-- if o == SetUnitBuff then
	-- 	f = "HELPFUL " .. (f or "")
	-- elseif o == SetUnitDebuff then
	-- 	f = "HARMFUL " .. (f or "")
	-- end

	local _, _, _, _, _, _, _, c = auraFunc(uid, id, f)

	local cl, str
	if(c) then
		if not UnitIsPlayer(c) and UnitPlayerControlled(c) then
			local n
			_, n = UnitVehicleSeatInfo(c, 1)
			if n then
				_, cl = UnitClass(n)
				str=("|c%s%s|r"):format(co[cl], n)
				
				_, n = UnitVehicleSeatInfo(c, 2)
				if n then
					_, cl = UnitClass(n)
					str=str.." & "..("|c%s%s|r"):format(co[cl], n)
				end
			else
				local cl2, n2
				if c=="pet" then
					_, cl= UnitClass(c);_, cl2= UnitClass("player");n, n2 = UnitName(c), UnitName("player")
				elseif sub(c,1,8)=="partypet" then
					id = sub(c, 9)
					_, cl= UnitClass(c);_, cl2= UnitClass("party"..id);n, n2 = UnitName(c), UnitName("party"..id)
				elseif sub(c,1,7)=="raidpet" then
					id = sub(c, 8)
					_, cl= UnitClass(c);_, cl2= UnitClass("raid"..id);n, n2 = UnitName(c), UnitName("raid"..id)
				end
				if(cl) then
					str=("|c%s%s|r (|c%s%s|r)"):format(co[cl], n,co[cl2], n2)
				else
					_, cl = UnitClass(c)
					str = ("|c%s%s|r"):format(co[cl], UnitName(c))
				end
			end
		else
			_, cl = UnitClass(c)
			str = ("|c%s%s|r"):format(co[cl], UnitName(c))
		end
	end
	if(str) then
		GameTooltip:AddLine("施法者:"..str)
		GameTooltip:Show()
	end
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(...)
	CastByHook( UnitAura, ...)
end)
hooksecurefunc(GameTooltip, "SetUnitBuff", function(...)
	CastByHook( UnitBuff, ...)
end)
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(...)
	CastByHook( UnitDebuff, ...)
end)

local mountsData = {}
local function UpdateMountsData()
    for i = 1, C_MountJournal.GetNumMounts() do
        local creatureName, spellId, icon, active, summonable, source, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(i)
        if spellId then
            mountsData[spellId] = (isCollected and 1 or -1) * mountID
        end
    end
end

CoreDependCall("Blizzard_Collections", function()
    if CollectionsJournal then
        CollectionsJournal:HookScript("OnHide", UpdateMountsData)
    end
end)

UpdateMountsData()

local function hookMountBuffInfo(self, unit, index, filter)
    if InCombatLockdown() then return end
    if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) then return end
    -- if UnitIsUnit(unit, "player") then return end
    local name, texture, count, debuffType, duration, expirationTime, _, _, _, spellId, _, _, _, _, timeMod = UnitAura(unit, index, filter);
    local mountID = mountsData[spellId]
    if (mountID) then
        local creatureDisplayID, descriptionText, sourceText, isSelfMount = C_MountJournal.GetMountInfoExtraByID(abs(mountID))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine("坐骑来源：", mountID > 0 and "(已收集)" or "(未收集)", mountID > 0 and 0 or 1, mountID > 0 and 1 or 0, 0, mountID > 0 and 0 or 1, mountID > 0 and 1 or 0, 0)
        GameTooltip:AddLine(sourceText, 1, 1, 1)
        GameTooltip:Show()
    end

    local frame = self:GetOwner()
    local name = frame:GetName()
    if not frame._hook163 and name and name:find("^TargetFrameBuff[0-9]+$") then
        frame._hook163 = 1
        SetOrHookScript(frame, "OnClick", function(self)
            if InCombatLockdown() then return end
            local spellId = select(10, UnitAura(self.unit, self:GetID(), nil))
            if  mountsData[spellId] then
                if not IsAddOnLoaded("Blizzard_Collections") then
                    CollectionsJournal_LoadUI()
                end
                if not CollectionsJournal:IsVisible() then
                    ToggleFrame(CollectionsJournal)
                end
                MountJournal.selectedSpellID = spellId;
               	MountJournal.selectedMountID = abs(mountsData[spellId]);
               	MountJournal_UpdateMountDisplay();
            end
        end)
    end
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(...)
    hookMountBuffInfo(...)
end)
hooksecurefunc(GameTooltip, "SetUnitBuff", function(...)
    hookMountBuffInfo(...)
end)