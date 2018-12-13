
BuildEnv(...)

Applicant = Addon:NewClass('Applicant', Object)

local AceSerializer = LibStub('AceSerializer-3.0')

Applicant:InitAttr{
    'ID',
    'Status',
    'PendingStatus',
    'NumMembers',
    'IsNew',
    'Msg',
    'OrderID',

    'Index',
    'Name',
    'ShortName',
    'Class',
    'LocalizedClass',
    'Level',
    'ItemLevel',
    'HonorLevel',
    'IsTank',
    'IsHealer',
    'IsDamage',
    'IsAssignedRole',
    'Relationship',
    'PvPRating',
    'Progression',
    'IsMeetingStone',
    'Source',

    'Result',
    'Touchy',
    'RoleID',
    'RoleName',
    'ActivityID',
}

local APPLICANT_HAD_RESULT = {
    failed = true,
    cancelled = true,
    declined = true,
    invitedeclined = true,
    timedout = true,
}

local APPLICANT_ALREADY_TOUGHT = {
    invited = true,
    inviteaccepted = true,
    invitedeclined = true,
}

function Applicant:Constructor(id, index, activityId)
    -- local id, status, pendingStatus, numMembers, isNew, comment, orderID = C_LFGList.GetApplicantInfo(id)
    
    local info = C_LFGList.GetApplicantInfo(id)
    local status = info.applicationStatus
    local pendingStatus = info.pendingApplicationStatus
    local numMembers = info.numMembers
    local isNew = info.isNew
    local comment = info.comment
    local orderID = info.displayOrderID
    local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = C_LFGList.GetApplicantMemberInfo(id, index)
    local msg, isMeetingStone, progression, pvpRating, source  = DecodeDescriptionData(comment)

    self:SetID(id)
    self:SetActivityID(activityId)
    self:SetStatus(status)
    self:SetPendingStatus(pendingStatus)
    self:SetNumMembers(numMembers)
    self:SetIsNew(isNew)
    self:SetMsg(msg)
    self:SetOrderID(orderID)

    self:SetIndex(index)
    self:SetName(name)
    self:SetShortName(Ambiguate(name, 'short'))
    self:SetClass(class)
    self:SetLocalizedClass(localizedClass)
    self:SetLevel(level)
    self:SetItemLevel(floor(itemLevel))
    self:SetHonorLevel(honorLevel)
    self:SetIsTank(tank)
    self:SetIsHealer(healer)
    self:SetIsDamage(damage)
    self:SetIsAssignedRole(assignedRole)
    self:SetRelationship(relationship)

    self:SetIsMeetingStone(isMeetingStone)
    self:SetPvPRating(isMeetingStone and tonumber(pvpRating) or 0)
    self:SetSource(source)
    if isMeetingStone then
        self:SetProgression(progression)
    end

    self:SetResult(pendingStatus or not APPLICANT_HAD_RESULT[status])
    self:SetTouchy(not APPLICANT_ALREADY_TOUGHT[status])
    self:SetRoleID(tank and '1' or healer and '2' or damage and '3' or assignedRole and '4')
end

function Applicant:GetPvPText()
    local usePvPRating = IsUsePvPRating(self:GetActivityID())
    local useHonorLevel = IsUseHonorLevel(self:GetActivityID())
    if not usePvPRating and not useHonorLevel then
        return
    end

    local text = self:GetHonorLevel()
    if usePvPRating then
        text = text .. '/' .. self:GetPvPRating()
    end
    return text
end

function Applicant:IsUseHonorLevel()
    return IsUseHonorLevel(self:GetActivityID())
end
