
local _, _NS = ...
local L = _NS.L


local U1Profiles = _G.U1Profiles

StaticPopupDialogs['U1PROFILE_RELOADUI'] = {preferredIndex = 3,
	text = L["Current addon enable states will be lost, are you SURE?"],
	button1 = YES,
	button2 = NO,
    OnAccept = function(self, data)
        local load_prof, load_opts = data[1], data[2]
        _NS.PROFILE_CHANGED = true
        U1Profiles:LoadProfile(load_prof, load_opts)
        ReloadUI()
    end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
}

StaticPopupDialogs['U1PROFILE_RESETDB'] = {preferredIndex = 3,
	text = L["Current addon enable states will be lost, are you SURE?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
        U1Profiles:BackupSession(L["Before Restore"])
        U1DB = nil
        _G[U1_FRAME_NAME]:SetUserPlaced(false)
        ReloadUI()
    end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
}

StaticPopupDialogs['U1PROFILE_DELETE'] = { preferredIndex = 3,
	text = L["Are you sure to delete this profile?"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self, data)
        local index, ptype = data[1], data[2]
        U1Profiles:RemoveProfile(index, ptype)
        U1Profiles.f.selectedIndex = nil
        U1Profiles.f.scroll.update()
        U1Profiles.f.detailframe:UpdateDetail()
    end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
}

function U1Profiles:CreateFrame()

local f = WW:Frame('U1ProfileFrame', _G[U1_FRAME_NAME], "BasicFrameTemplateWithInset"):Size(500, 250):TOP(0, -50):SetToplevel(1):SetFrameStrata("DIALOG")
U1Profiles.f = f

local function tabOnClick(self)
    PanelTemplates_Tab_OnClick(self, f)
    f.profileType = f.selectedTab==1 and 'manual' or 'auto'
    f.selectedIndex = nil

    -- tab changed, hide!
    if(f.detailframe) then
        f.detailframe:Hide()
    end

    CoreUIEnableOrDisable(f.btnNew, f.selectedTab==1);

    return f.scroll and f.scroll.update()
end

local rowOnClick = function(row)
    if(row.index == f.selectedIndex) then
        row:UnlockHighlight()
        f.selectedIndex = nil
    else
        row:LockHighlight()
        f.selectedIndex = row.index
    end
    f.detailframe.isNewProfile = nil
    f.detailframe:UpdateDetail()
    --f.scroll.update()

    local scrollframe = f.scroll
    for _, btn in next, scrollframe.buttons do
        if(btn ~= row) then
            btn:UnlockHighlight()
        end
    end
end

f.TitleText:SetText(L["AbyUI Profiles"])
f.InsetBg:SetPoint("TOPLEFT", 4, -50)
CoreUIMakeMovable(f)

f:Button("$parentTab1", "TabButtonTemplate", "tab1"):BL(f.InsetBg, "TOPLEFT", 5, 0):SetText(L["Saved"]):SetID(1)
:SetScript("OnClick", tabOnClick)
PanelTemplates_TabResize(f.tab1, -10)

f:Button("$parentTab2", "TabButtonTemplate", "tab2"):LEFT(f.tab1, "RIGHT", 0, 0):SetText(L["Auto"]):SetID(2)
:SetScript("OnClick", tabOnClick)
CoreUIEnableTooltip(f.tab2, "", L["EAC will automatically save profiles before logout, after login, or loading another profile."])
PanelTemplates_TabResize(f.tab2, -10)

PanelTemplates_SetNumTabs(f(), 2)
tabOnClick(f.tab1)
--f.selectedTab = 1
--PanelTemplates_UpdateTabs(f())

f.btnNew = TplPanelButton(f):SetText(L["Create Profile"]):AutoWidth() f.btnNew:SetWidth(f.btnNew:GetWidth()+4)
--f.btnImport = TplPanelButton(f):SetText("导入方案"):AutoWidth()
f.btnReset = TplPanelButton(f):SetText(L["Restore Default"]):AutoWidth() f.btnReset:SetWidth(f.btnReset:GetWidth()+4)
CoreUIAnchor(f.InsetBg, "BOTTOMRIGHT", "TOPRIGHT", -5, 0, "RIGHT", "LEFT", 0, 0, --[[f.btnImport,]] f.btnNew, f.btnReset)

local scroll = CoreUICreateHybridStep1(nil, f(), nil, true, true, nil)
WW(scroll):TL(f.InsetBg, 3, -3):BR(f.InsetBg, -2-21, 2):un() --:TL(3, -20)
f.scroll = scroll

local function fix_text_width(obj)
    obj:GetFontString():SetAllPoints()
end

scroll.creator = function(self, index, name)
    local row = WW(self.scrollChild):Button(name):LEFT():RIGHT():Size(0, 20)
    row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], 'ADD')
    row:RegisterForClicks'LeftButtonUp'
    row:SetScript('OnClick', rowOnClick)

    row.profile = row:Button():Size(120, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(111):GetButtonText():SetJustifyH("Left"):up()
    row.numadddons = row:Button():Size(120, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(222):GetButtonText():SetJustifyH("Left"):up()
    row.savedate = row:Button():Size(110, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Left"):up()
    row.character = row:Button():Size(200, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Left"):up()
    row.meminfo = row:Button():Size(1, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Left"):up()

    fix_text_width(row.profile)
    fix_text_width(row.numadddons)
    fix_text_width(row.character)
    fix_text_width(row.savedate)
    fix_text_width(row.meminfo)

    CoreUIAnchor(row, "LEFT", "LEFT", 5, 0, "LEFT", "RIGHT", 5, 0, row.profile, row.numadddons, row.savedate, row.character, row.meminfo)
    return row:un()
end

scroll.getNumFunc = function()
    return U1Profiles:GetNumProfiles(f.profileType) or 20 -- 20 for test
end

local function count_enabled_addons(prof)
    if (prof and prof.num_addons) then return prof.num_addons end
    if(prof and prof.u1dbaddons) then
        local sum, sum_par = 0, 0
        for k, v in next, prof.u1dbaddons do
            local info = U1GetAddonInfo(k)
            if(v and v==1 and info and info.installed and not info.hide) then
                local count = true
                if not info.parent then sum_par = sum_par + 1 end
                --必须父插件启用了才算
                while(info and info.parent) do
                    local vp = prof.u1dbaddons[info.parent]
                    local ip = U1GetAddonInfo(info.parent);
                    if vp and ip and (ip.installed or ip.dummy) and (vp==1 or ip.hide or ip.protected) then
                        info = ip;
                    else
                        count = false;
                        break;
                    end
                end
                if count then
                    sum = sum + 1
                end
            end
        end
        local nums = sum_par --.."/"..sum; --/run for k,v in pairs(U1DBG.profiles.auto) do print(v.num_addons) v.num_addons = nil end
        --prof.num_addons = nums
        return nums
    else
        return UNKNOWN
    end
end

scroll.updateFunc = function(self, row, index)
    row.index = index
    local ptype = f.profileType
    if(index == f.selectedIndex) then
        row:LockHighlight()
    else
        row:UnlockHighlight()
    end

    local prof = U1Profiles:GetProfileByIndex(index, ptype)
    --print('row.Update', index, ptype, prof)
    row.profile:SetText(prof and (ptype == "auto" and "" or L["Profile: "])..prof.name)

    row.numadddons:SetText(prof and (L["AddOns: "] ..count_enabled_addons(prof)))

    do
        local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[prof.class]
        if(color) then
            row.character:GetFontString():SetTextColor(color.r, color.g, color.b)
        else
            row.character:GetFontString():SetTextColor(1, 1, 1)
        end
        row.character:SetText(prof.user and ('|cffffd100|r ' .. prof.user))
    end

    do
        local date_fmt = '%Y/%m/%d'
        local time_fmt = ' %H:%M'

        local txt = date(date_fmt, prof.savedate)
        local today = date(date_fmt)
        if(txt == today) then
            txt = L["Today"]
        end
        txt = txt..date(time_fmt, prof.savedate)
        row.savedate:SetText(txt)
    end

    row.meminfo:SetText(prof and prof.meminfo)
end

CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", 0)

local detailframe = WW:Frame('U1ProfileDetailFrame', f):Size(220, 170):TL("$parent", 'TR', -11, -14)
:Backdrop([[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
[[Interface\DialogFrame\UI-DialogBox-Border]],
32, { 11, 12, 12, 11, }, 32)
local df = detailframe
df:Hide()

df.btnClose = WW:Button(nil, df, 'UIPanelCloseButton'):SetPoint('TOPRIGHT', -4, -4):SetScript('OnClick', function(self)
    self:GetParent():Hide()
end)

df.lableprofilename = df:CreateFontString():Size(150, 20):SetFontObject(_G[UUI.FONT_PANEL_BUTTON.."N"]):SetJustifyH("LEFT"):SetText("ABC"):TL(df, 20, -20)
df.profilename = WW:EditBox(nil, df, 'InputBoxTemplate'):Size(100, 20):TL(df, 38, -50)
df.profilename:SetScript('OnEnterPressed', function(self) self:ClearFocus() end)
df.profilename:SetScript('OnEscapePressed', function(self) self:ClearFocus() end)
df.profilename:SetAutoFocus(false)
df.profilename:SetScript('OnTextChanged', function(self)
    local txt = self:GetText()
    if(not f.detailframe.isNewProfile and txt == ''
        and txt==f.detailframe:GetCurrentSelectedProfile().name) then
        f.detailframe.rename:Disable()
    else
        f.detailframe.rename:Enable()
    end
end)

df.u1dbaddons = TplCheckButton(df):Size(24):Set3Fonts(UUI.FONT_PANEL_BUTTON):SetText(L["AddOn States"]):TL(df, 30, -78):un()
df.u1dbconfigs = TplCheckButton(df):Size(24):Set3Fonts(UUI.FONT_PANEL_BUTTON):SetText(L["AddOn Options"]):TL(df.u1dbaddons, "BOTTOMLEFT", 0, 5):un()
CoreUIEnableTooltip(df.u1dbconfigs, L["Hint"], L["In addition of saving addon enable/disable states, also save the options shown in the EAC panel."])
--df.frameset = CoreUICreateCheckButton(df, nil, nil, '框体位置'):LEFT(df.addonstatus, 120, 0):un()
--df.keybinds = CoreUICreateCheckButton(df, nil, nil, '按键绑定'):LEFT(df.addonsprofile, 120, 0):un()
--df.blizzprofile = CoreUICreateCheckButton(df, nil, nil, '暴雪设置'):TL(df.addonsprofile, 0, -30):un()
--df.chatprofile = CoreUICreateCheckButton(df, nil, nil, '聊天配置'):LEFT(df.blizzprofile, 120, 0):un()

local _check_keys = {
    'u1dbaddons', 'u1dbconfigs',
}


--[[
--  self notes:
--      the reason why I use ``f.detailframe'' here is that ``detailframe'' is a reference to a
--      wrapper that wraps ``detailframe'' in order to provide features like `chained call', once
--      it's unwrapped, it will no longer hold the reference to the acture frame, so we use
--      ``f.detailframe'' here to call the acture frame instread of just a wrapper.
--]]

do
    df.load = TplPanelButton(df, nil, 24):SetText(L["Load"]):AutoWidth():BL(df, 30, 20):SetScript('OnClick', function(self)
        local opts = f.detailframe:UpdateOptions()

        local index, ptype = f.detailframe:GetSelected()
        local prof = U1Profiles:GetProfileByIndex(index, ptype)

        StaticPopup_Show("U1PROFILE_RELOADUI", nil, nil, { prof, opts })
    end)
end

--df.export = TplPanelButton(df):SetText('导出'):Size(90, 30):TL(df.load, 'TOPRIGHT', 10, 0):SetScript('OnClick', function()
--    print'export on click'
--end)

df.delete = TplPanelButton(df, nil, 24):SetText(L["Delete"]):AutoWidth():TL(df.load, 'TOPRIGHT', 10, 0):SetScript('OnClick', function()
    local index, ptype = f.detailframe:GetSelected()
    if index and ptype then
        StaticPopup_Show("U1PROFILE_DELETE", nil, nil, { index, ptype })
    end
end)

df.rename = TplPanelButton(df):SetText(L["Rename"]):Size(60, 20):LEFT(df.profilename, 'RIGHT', 5, 0):SetScript('OnClick', function()
    local newname = f.detailframe:GetInputName()
    local prof = f.detailframe:GetCurrentSelectedProfile()
    if( (not prof)
        or f.detailframe.isNewProfile
        or newname == ''
        or prof.name == newname
        ) then return end

    prof.name = newname
    f.scroll.update()
    f.detailframe:UpdateDetail()
    f.detailframe:DeselectAll()
    f.detailframe:Hide()
end)

df.save = TplPanelButton(df):SetText(L["Save"]):Size(50, 20):LEFT(df.delete, 'RIGHT', 10, 0):SetScript('OnClick', function()
    local profname = f.detailframe:GetInputName()
    if(not profname or profname == '') then
        profname = L["Unnamed"]
    end
    if(f.detailframe.isNewProfile) then
        -- unset isNewProfile
        f.detailframe.isNewProfile = nil

        -- create profile and save it
        local _, ptype = f.detailframe:GetSelected()
        local prof, index = U1Profiles:CreateProfile(profname, ptype)

        U1Profiles:EditProfileOption(prof, f.detailframe:UpdateOptions())
        U1Profiles:SaveProfile(prof)

        f.selectedIndex = index
        f.scroll.update()
        f.detailframe:UpdateDetail()
        f.detailframe:Hide();
    else -- override selected
        local opts = f.detailframe:UpdateOptions()
        local prof = f.detailframe:GetCurrentSelectedProfile()
        if(prof) then
            prof.name = profname;
            U1Profiles:EditProfileOption(prof, opts)
            U1Profiles:SaveProfile(prof)
            f.scroll.update()
            f.detailframe:UpdateDetail()
            f.detailframe:DeselectAll()
            f.detailframe:Hide()
        end
    end
end)

function detailframe:GetInputName()
    return self.profilename:GetText()
end

function detailframe:UpdateDetail(onShow)
    if(self.isNewProfile) then
        self.lableprofilename:SetText(L["New profile name: "])
        self.profilename:SetText''
        --self.save:Disable()

        for _, v in next, _check_keys do
            local btn = self[v]
            btn:SetChecked(true)
            btn:EnableOrDisable(true)
        end

        self.save:Enable()
        self.rename:Disable()
        self.load:Disable()
        self.delete:Disable()
    else
        local prof = self:GetCurrentSelectedProfile()
        if(prof) then
            self.lableprofilename:SetText(L["Change profile name: "])
            self.profilename:SetText(prof.name)

            for _, v in next, _check_keys do
                local btn, cfg = self[v], prof.config[v]
                btn:SetChecked(cfg)
                btn:EnableOrDisable(cfg)
            end

            self.rename:Disable() -- disable untile it's changed
            self.save:Enable()
            self.load:Enable()
            self.delete:Enable()
        else
            return self:Hide()
        end
    end

    -- clear focus after the buttons are clicked
    self.profilename:ClearFocus()

    if(not onShow) then
        self:Show()
    end
end

detailframe:SetScript('OnShow', function(self)
    self:UpdateDetail(true)
end)

-- clear new profile on hide
detailframe:SetScript('OnHide', function(self)
    self.isNewProfile = nil
    self:DeselectAll()
end)

function detailframe:NewProfile()
    --local prof, index = U1Profiles:CreateProfile('testtesttest', f.profileType)
    --self:SelectRow(index)

    self.isNewProfile = true
    self:DeselectAll()
    self:UpdateDetail()
end

function detailframe:SelectRow(index)
    f.selectedIndex = index
    f.scroll.update()
    self:UpdateDetail()
end

function detailframe:DeselectAll()
    f.selectedIndex = nil
    for _, row in next, f.scroll.buttons do
        row:UnlockHighlight()
    end
end

function detailframe:GetSelected()
    return f.selectedIndex, f.profileType
end

function detailframe:GetCurrentSelectedProfile()
    local index, ptype = self:GetSelected()
    return U1Profiles:GetProfileByIndex(index, ptype)
end

-- expose `.config' for debug
detailframe.config = {}
function detailframe:UpdateOptions()
    wipe(self.config)

    for _, v in next, _check_keys do
        self.config[v] = self[v]:GetChecked()
    end
    --self.config.u1db = true
    --self.config.u1dbaddons = self.u1dbaddons:GetChecked()
    --self.config.u1dbconfigs = self.u1dbconfigs:GetChecked()

    return self.config
end

f.btnNew:SetScript('OnClick', function(self)
    f.detailframe:NewProfile()
end)

f.btnReset:SetScript("OnClick", function(self)
    StaticPopup_Show'U1PROFILE_RESETDB'
end)

f.detailframe = detailframe

--f.btnImport:SetScript('OnClick', function(self)
--    print('import btn clicked')
--end)

return f()
end -- function U1Profiles:CreateFrame()


