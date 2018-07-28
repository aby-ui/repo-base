local UnitAura, UnitGUID, pairs = UnitAura, UnitGUID, pairs

local MAX_BUFFS = 6

local L = setmetatable(GridBuffIconsLocale or {}, {__index = function(t, k) t[k] = k return k end})

local GridRoster = Grid:GetModule("GridRoster")
local GridFrame = Grid:GetModule("GridFrame")
local GridBuffIcons = Grid:NewModule("GridBuffIcons", "AceBucket-3.0")

local function WithAllGridFrames(func)
    for _, frame in pairs(GridFrame.registeredFrames) do
        func(frame)
    end
end

GridBuffIcons.menuName = L["Buff Icons"]

GridBuffIcons.defaultDB = {
    enabled = true,
    iconsize = 9,
    offsetx = 10,
    offsety = -1,
    alpha = 1,
    iconnum = 3,
    iconperrow = 3,
    showbuff = nil,
    buffmine = nil,
    bufffilter = true,
    showcooldown = true,
    showcdtext = false,
    namefilter = nil,
    nameforce = nil,
    orientation = "VERTICAL",
    anchor = "TOPRIGHT",
    color = { r = 0, g = 0.5, b = 1.0, a = 1.0 },
    ecolor = { r = 1, g = 1, b = 0, a = 1.0 },
    rcolor = { r = 1, g = 0, b = 0, a = 1.0 },
    unit_buff_icons = {
        color = { r=1, g=1, b=1, a=1 },
        text = "BuffIcons",
        enable = true,
        priority = 30,
        range = false
    }
}

local options = {
    type = "group",
    inline = GridFrame.options.args.bar.inline,
    name = L["Buff Icons"],
    desc = L["Buff Icons"],
    order = 1200,
    get = function(info)
        local k = info[#info]
        return GridBuffIcons.db.profile[k]
    end,
    set = function(info, v)
        local k = info[#info]
        GridBuffIcons.db.profile[k] = v
        GridBuffIcons:UpdateAllUnitsBuffs()
    end,
    args = {
        enabled = {
            order = 40, width = "double",
            type = "toggle",
            name = L["启用模块"],
            desc = L["启用/停用模块，会在框体外部(可设置)显示所有的增益或负面状态图标。"],
            get = function()
                return GridBuffIcons.db.profile.enabled;
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.enabled = v;
                if v and not GridBuffIcons.enabled then
                    GridBuffIcons:OnEnable()
                elseif not v and GridBuffIcons.enabled then
                    GridBuffIcons:OnDisable()
                end
            end,
        },
        showbuff = {
            order = 50, width = "single",
            type = "toggle",
            name = L["Show Buff instead of Debuff"],
            desc = L["If selected, the icons will present unit buffs instead of debuffs."],
        },
        buffmine = {
            order = 51, width = "single",
            type = "toggle",
            name = L["Only Mine"],
            disabled = function(info) return not GridBuffIcons.db.profile.showbuff end,
        },
        bufffilter = {
            order = 52, width = "double",
            type = "toggle",
            name = L["Only castable/removable"],
            desc = L["If selected, only shows the buffs you can cast or the debuffs you can remove."],
        },
        showcooldown = {
            order = 53,
            type = "toggle",
            name = L["Show cooldown on icon"],
        },
        showcdtext = {
            order = 54,
            type = "toggle",
            name = L["Show Cooldown text"],
            desc = L["If disabled, OmniCC will not add texts on the icons."],
        },
        iconsize = {
            order = 55, width = "double",
            type = "range",
            name = L["Icons Size"],
            desc = L["Size for each buff icon"],
            max = 16,
            min = 5,
            step = 1,
            get = function () return GridBuffIcons.db.profile.iconsize end,
            set = function(_, v)
                GridBuffIcons.db.profile.iconsize = v;
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconSize(f) end)
            end
        },
        alpha = {
            order = 70, width = "double",
            type = "range",
            name = L["Alpha"],
            desc = L["Alpha value for each buff icon"],
            max = 1,
            min = 0.1,
            step = 0.1,
            get = function () return GridBuffIcons.db.profile.alpha end,
            set = function(_, v)
                GridBuffIcons.db.profile.alpha = v;
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconAlpha(f) end)
            end
        },
        offsetx = {
            order = 60, width = "double",
            type = "range",
            name = L["Offset X"],
            desc = L["X-axis offset from the selected anchor point, minus value to move inside."],
            max = 20,
            min = -20,
            step = 1,
            get = function () return GridBuffIcons.db.profile.offsetx end,
            set = function(_, v)
                GridBuffIcons.db.profile.offsetx = v;
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconPos(f) end)
            end
        },
        offsety = {
            order = 65, width = "double",
            type = "range",
            name = L["Offset Y"],
            desc = L["Y-axis offset from the selected anchor point, minus value to move inside."],
            max = 20,
            min = -20,
            step = 1,
            get = function () return GridBuffIcons.db.profile.offsety end,
            set = function(_, v)
                GridBuffIcons.db.profile.offsety = v;
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconPos(f) end)
            end
        },
        iconnum = {
            order = 75, width = "double",
            type = "range",
            name = L["Icon Numbers"],
            desc = L["Max icons to show."],
            max = MAX_BUFFS,
            min = 1,
            step = 1,
        },
        iconperrow = {
            order = 76, width = "double",
            type = "range",
            name = L["Icons Per Row"],
            desc = L["Sperate icons in several rows."],
            max = MAX_BUFFS,
            min = 0,
            step = 1,
            get = function()
                return GridBuffIcons.db.profile.iconperrow;
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.iconperrow = v;
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconPos(f) end);
            end,
        },
        orientation = {
            order = 80,  width = "double",
            type = "select",
            name = L["Orientation of Icon"],
            desc = L["Set icons list orientation."],
            get = function ()
                return GridBuffIcons.db.profile.orientation
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.orientation = v
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconPos(f) end)
            end,
            values ={["HORIZONTAL"] = L["HORIZONTAL"], ["VERTICAL"] = L["VERTICAL"]}
        },
        anchor = {
            order = 90,  width = "double",
            type = "select",
            name = L["Anchor Point"],
            desc = L["Anchor point of the first icon."],
            get = function ()
                return GridBuffIcons.db.profile.anchor
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.anchor = v
                WithAllGridFrames(function (f) GridBuffIcons.ResetBuffIconPos(f) end)
            end,
            values ={["TOPRIGHT"] = L["TOPRIGHT"], ["TOPLEFT"] = L["TOPLEFT"], ["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"]}
        },
        namefilter = {
            order = 200, width = "full",
            type = "input",
            multiline = 3,
            name =  L["Buffs/Debuffs Never Shown"],
            desc =  L["Buff or Debuff names never to show, seperated by ','"],
            get = function()
                return GridBuffIcons.db.profile.namefilter;
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.namefilter = v;
                GridBuffIcons:SetNameFilter(true)
                GridBuffIcons:UpdateAllUnitsBuffs();
            end,
        },
        --[[ --8.0 removed because performance problem
        nameforce = {
            order = 201, width = "full",
            type = "input",
            multiline = 3,
            name =  L["Buffs/Debuffs Always Shown"],
            desc =  L["Buff or Debuff names which will always be shown if applied, seperated by ','"],
            get = function()
                return GridBuffIcons.db.profile.nameforce;
            end,
            set = function(_, v)
                GridBuffIcons.db.profile.nameforce = v;
                GridBuffIcons:SetNameFilter(false)
                GridBuffIcons:UpdateAllUnitsBuffs();
            end,
        },
        --]]
    }
}

(Grid or GridFrame).options.args.GridBuffIcons = options;

function GridBuffIcons.InitializeFrame(gridFrameObj, f)
    if not f.BuffIcons then
        f.BuffIcons = {};
        for i=1, MAX_BUFFS do
            local bar = f.Bar or f.indicators.bar
            local bg = CreateFrame("Frame", "$parentGridBuffIcon"..i, bar)
            bg:SetFrameLevel(bar:GetFrameLevel() + 3)
            bg.icon = bg:CreateTexture("$parentTex", "OVERLAY");
            bg.icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
            bg.icon:SetAllPoints(bg);
            bg.cd = CreateFrame("Cooldown", "$parentCD", bg, "CooldownFrameTemplate")
            bg.cd:SetAllPoints(bg.icon)
            bg.cd:SetReverse(true)
            bg.cd:SetDrawBling(false)
            bg.cd:SetDrawEdge(false)
            bg.cd:SetSwipeColor(0, 0, 0, 0.6)  --will be overrided by omnicc
            f.BuffIcons[i] = bg
        end

        GridBuffIcons.ResetBuffIconSize(f);
        GridBuffIcons.ResetBuffIconPos(f);
        GridBuffIcons.ResetBuffIconAlpha(f);
    end
end

function GridBuffIcons.ResetBuffIconSize(f)
    if(f.BuffIcons) then
        for _,v in pairs(f.BuffIcons) do
            v:SetWidth(GridBuffIcons.db.profile.iconsize);
            v:SetHeight(GridBuffIcons.db.profile.iconsize);
        end
    end
end

function GridBuffIcons.ResetBuffIconPos(f)
    local icons = f.BuffIcons
    local xadjust = 1;
    local yadjust = 1;
    local p = GridBuffIcons.db.profile;
    if(string.find(p.anchor, "BOTTOM")) then yadjust = -1; end;
    if(string.find(p.anchor, "LEFT")) then xadjust = -1; end;
    if(icons) then
        for k,v in pairs(icons) do
            v:ClearAllPoints();
            if(k==1) then
                v:SetPoint(p.anchor, f, p.anchor, xadjust * p.offsetx, yadjust * p.offsety)
            elseif(p.iconperrow and p.iconperrow>0 and (k-1)%p.iconperrow==0) then
                if(p.orientation == "VERTICAL") then
                    if(string.find(p.anchor, "RIGHT")) then
                        if(p.offsetx<=0) then
                            v:SetPoint("RIGHT", icons[k-p.iconperrow], "LEFT", -1, 0); --向内侧(左)
                        else
                            v:SetPoint("LEFT", icons[k-p.iconperrow], "RIGHT", 1, 0);  --向外侧(右)
                        end
                    elseif(string.find(p.anchor, "LEFT")) then
                        if(p.offsetx<=0) then
                            v:SetPoint("LEFT", icons[k-p.iconperrow], "RIGHT", 1, 0);  --向内侧(右)
                        else
                            v:SetPoint("RIGHT", icons[k-p.iconperrow], "LEFT", -1, 0);
                        end
                    end
                else
                    if(string.find(p.anchor, "TOP")) then
                        if(p.offsety<=0) then
                            v:SetPoint("TOP", icons[k-p.iconperrow], "BOTTOM", 0, -1);  --向内侧(下)
                        else
                            v:SetPoint("BOTTOM", icons[k-p.iconperrow], "TOP", 0, 1);  --向内侧(上)
                        end
                    elseif(string.find(p.anchor, "BOTTOM")) then
                        if(p.offsety<=0) then
                            v:SetPoint("BOTTOM", icons[k-p.iconperrow], "TOP", 0, 1);
                        else
                            v:SetPoint("TOP", icons[k-p.iconperrow], "BOTTOM", 0, -1);
                        end
                    end
                end
            else
                if(p.orientation == "VERTICAL") then
                    if(string.find(p.anchor, "BOTTOM")) then
                        v:SetPoint("BOTTOM", icons[k-1], "TOP", 0, 1);  --向上增长
                    else
                        v:SetPoint("TOP", icons[k-1], "BOTTOM", 0, -1); --向下增长
                    end
                else
                    if(string.find(p.anchor, "LEFT")) then
                        v:SetPoint("LEFT", icons[k-1], "RIGHT", 1, 0);  --向右增长
                    else
                        v:SetPoint("RIGHT", icons[k-1], "LEFT", -1, 0);  --向左增长
                    end
                end
            end
        end
    end
end

function GridBuffIcons.ResetBuffIconAlpha(f)
    if(f.BuffIcons) then
        for k,v in pairs(f.BuffIcons) do
            v:SetAlpha( GridBuffIcons.db.profile.alpha );
        end
    end
end

function GridBuffIcons:OnInitialize()
    self.super.OnInitialize(self)
    WithAllGridFrames(function(f) GridBuffIcons.InitializeFrame(nil, f); end)
    hooksecurefunc(GridFrame, "InitializeFrame", self.InitializeFrame);
end

function GridBuffIcons:OnEnable()
    if not GridBuffIcons.db.profile.enabled then return end
    self.enabled = true
    self:RegisterEvent("UNIT_AURA")
    if(not self.bucket) then
        self:Debug("registering bucket");
        self.bucket = self:RegisterBucketMessage("Grid_UpdateLayoutSize", 1, "UpdateAllUnitsBuffs")
    end
    self:SetNameFilter(true)
    self:SetNameFilter(false)

    self:UpdateAllUnitsBuffs();
end

function GridBuffIcons:OnDisable()
    self.enabled = nil
    self:UnregisterEvent("UNIT_AURA")
    if(self.bucket) then
        self:Debug("unregistering bucket");
        self:UnregisterBucket(self.bucket);
        self.bucket = nil;
    end
    for k,v in pairs(GridFrame.registeredFrames) do
        if(v.BuffIcons) then
            for i=1, MAX_BUFFS do v.BuffIcons[i]:Hide() end
        end
    end
end

function GridBuffIcons:SetNameFilter(filterOrForce)
    local setting, temp
    if filterOrForce then
        setting = GridBuffIcons.db.profile.namefilter
        self.namefilter = self.namefilter or {}
        temp = self.namefilter
    else
        setting = GridBuffIcons.db.profile.nameforce
        self.nameforce = self.nameforce or {}
        temp = self.nameforce
    end
    local str = string.gsub(setting or "", "，", ",")
    wipe(temp)
    for _, v in ipairs({strsplit(",\n", str)}) do
        temp[v:trim()] = true
    end
end

function GridBuffIcons:Reset()
    self.super.Reset(self)
    self:SetNameFilter(true)
    self:SetNameFilter(false)
end

local function showBuffIcon(v, n, setting, icon, expires, duration)
    v.BuffIcons[n]:Show()
    v.BuffIcons[n].icon:SetTexture(icon);
    if (setting.showcooldown) then
        v.BuffIcons[n].cd.noCooldownCount = not setting.showcdtext
        v.BuffIcons[n].cd:SetDrawEdge(v.BuffIcons[n].cd.noCooldownCount)
        v.BuffIcons[n].cd:SetCooldown(expires - duration, duration)
    else
        v.BuffIcons[n].cd:SetCooldown(0, 0)
    end
end
local function updateFrame(v)
    local i = 1
    local n = 1
    local setting = GridBuffIcons.db.profile
    local showbuff = setting.showbuff

    --[[ --8.0 removed because of performance problem
    for name, _ in pairs(GridBuffIcons.nameforce) do
        local name, rank, icon, count, debuffType, duration, expires, caster, isStealable, _, spellID = UnitAura(v.unit, name);
        if name then
            showBuffIcon(v, n, setting, icon, expires, duration)
            n=n+1
        end
    end
    --]]
    local filter = setting.bufffilter
    if showbuff then
        filter = filter and (setting.buffmine and "HELPFUL|RAID|PLAYER" or "HELPFUL|RAID") or (setting.buffmine and "HELPFUL|PLAYER" or "HELPFUL")
    else
        filter = filter and "HARMFUL|RAID" or "HARMFUL"
    end
    while(n <= setting.iconnum and i<40) do
        local name, icon, count, debuffType, duration, expires, caster, isStealable, _, spellID = UnitAura(v.unit, i, filter);
        if (name) then
            if not showbuff or (duration and duration > 0 or setting.bufffilter) then  --ignore mount, world buff etc
                if not GridBuffIcons.namefilter[name] and not GridBuffIcons.nameforce[name] then
                    showBuffIcon(v, n, setting, icon, expires, duration)
                    n=n+1
                end
            end
        else
            break;
        end
        i=i+1
    end
    for i=n, MAX_BUFFS do
        v.BuffIcons[i]:Hide();
    end
end

function GridBuffIcons:UNIT_AURA(event, unitid)
    if not self.enabled then return end
    -- if GridRoster.GetRaidUnitGUID then
    -- 	local guid = GridRoster:GetRaidUnitGUID(unitid)
    -- 	if not guid then return end
    -- 	GridFrame:WithGUIDFrames(guid, updateFrame)
    -- else
    local guid = UnitGUID(unitid)
    if not GridRoster:IsGUIDInRaid(guid) then return end
    for k,v in pairs(GridFrame.registeredFrames) do
        if v.unitGUID == guid then updateFrame(v) end
    end
    -- end

end

function GridBuffIcons:UpdateAllUnitsBuffs()
    for guid, unitid in GridRoster:IterateRoster() do
        self:UNIT_AURA("UpdateAllUnitsBuffs", unitid)
    end
    --self:UNIT_AURA("player");
end