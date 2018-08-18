
BuildEnv(...)

debug = IsAddOnLoaded('!!!!!tdDevTools') and print or nop

Addon = LibStub('AceAddon-3.0'):NewAddon('MeetingStone', 'AceEvent-3.0', 'LibModule-1.0', 'LibClass-2.0', 'AceHook-3.0')

GUI = LibStub('NetEaseGUI-2.0')

function Addon:OnInitialize()
    --[[ aby8
    self:SecureHook('LFGListUtil_OpenBestWindow', function()
        HideUIPanel(PVEFrame)
        self:Toggle()
    end)
    --]]
    -- self:RawHook('SetItemRef', true)

    self:RegisterMessage('MEETINGSTONE_NEW_VERSION')
    self:RegisterMessage('MEETINGSTONE_FILTER_DATA_UPDATED')

    self.mountCache = setmetatable({}, {
        __index = function(t, k)
            for _, id in ipairs(C_MountJournal.GetMountIDs()) do
                local displayId = C_MountJournal.GetMountInfoExtraByID(id)
                if displayId == k then
                    local v = select(11, C_MountJournal.GetMountInfoByID(id))
                    t[k] = v
                    return v
                end
            end
        end
    })
    self:RegisterEvent('COMPANION_LEARNED', function()
        wipe(self.mountCache)
    end)

    local lfgTooManyDialog = _G.StaticPopupDialogs['LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS']
    if lfgTooManyDialog and lfgTooManyDialog.text and strlenutf8(lfgTooManyDialog.text) == #lfgTooManyDialog.text then
        lfgTooManyDialog.text = L['你的队伍成员已经达到当前活动的人数上限，活动已经自动解散。']
    end
end

function Addon:OnEnable()
    if IsAddOnLoaded('RaidBuilder') then
        DisableAddOn('RaidBuilder')
        GUI:CallWarningDialog(L.FoundRaidBuilder, true, nil, ReloadUI)
        return
    end

    if Profile:GetLastVersion() < 70200.06 then
        --SetCVar('profanityFilter', 1)
    end

    Profile:SaveLastVersion()
end

function Addon:MEETINGSTONE_NEW_VERSION(_, version, url, isSupport, changeLog)
    version = format('%.02f', tonumber(version) or 0)
    if not isSupport then
        self.url = url
        self.changeLog = changeLog

        self:ShowNewVersion(url, changeLog)
    end

    if changeLog then
        System:Logf(L.NewVersionWithChangeLog, version, url, changeLog)
    else
        System:Logf(L.NewVersion, version, url)
    end
end

function Addon:Toggle()
    if Logic:IsSupport() then
        if MainPanel:IsShown() then
            Addon:HideModule('MainPanel')
        else
            if ApplicantPanel:HasNewPending() then
                MainPanel:SelectPanel(ManagerPanel)
            elseif DataCache:GetObject('ActivitiesData'):IsNew() then
                MainPanel:SelectPanel(ActivitiesParent)
            elseif App:HasNewFollower() then
                MainPanel:SelectPanel(AppParent)
            elseif C_LFGList.GetActiveEntryInfo() then
                MainPanel:SelectPanel(ManagerPanel)
            end
            Addon:ShowModule('MainPanel')
        end
    else
        self:ShowNewVersion(self.url, self.changeLog)
    end
end

function Addon:ShowNewVersion(url, changeLog)
    if changeLog then
        GUI:CallUrlDialog(url, format(L.NotSupportVersionWithChangeLog, changeLog), 1)
    else
        GUI:CallUrlDialog(url, L.NotSupportVersion, 1)
    end
end

function Addon:FindMount(id)
    if not id then
        return
    end
    return self.mountCache[id]
end

function Addon:MEETINGSTONE_FILTER_DATA_UPDATED(_, data)
    ClearCheckContentCache()
    self.filterPinyin = #data.pinyin > 0 and data.pinyin or nil
    self.filterNormal = #data.normal > 0 and data.normal or nil
end

function Addon:GetFilterData()
    return self.filterPinyin, self.filterNormal
end

-- function Addon:SetItemRef(link, text, button, chatFrame)
--     local type, panel = strsplit(':', link)
--     if type == 'meetingstonepanel' then
--         panel = self:GetModule(panel, true)
--         if panel and MainPanel:GetPanelIndex(panel) then
--             Addon:ToggleModule('MainPanel')
--             MainPanel:SelectPanel(panel)
--         end
--         return
--     elseif type == 'meetingstonedialog' then
--         panel = _ENV[panel]
--         if panel then
--             ToggleFrame(panel)
--         end
--         return
--     end
--     return self.hooks.SetItemRef(link, text, button, chatFrame)
-- end
