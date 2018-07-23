
BuildEnv(...)

local RoleItem = Addon:NewClass('RoleItem', GUI:GetClass('DataGridViewGridItem'))

function RoleItem:Constructor()
    local function ButtonOnClick(object)
        self:GetParent():FireHandler('OnRoleClick', object.role)
    end

    local RoleIcon1 = CreateFrame('Button', nil, self) do
        GUI:Embed(RoleIcon1, 'Tooltip')
        RoleIcon1:SetTooltipAnchor('ANCHOR_TOP')
        RoleIcon1:SetSize(19, 19)
        RoleIcon1:SetPoint('RIGHT', self, 'CENTER', -2, 0)
        RoleIcon1:SetNormalTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        RoleIcon1:SetHighlightTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]], 'ADD')
        RoleIcon1:SetScript('OnClick', ButtonOnClick)
    end

    local RoleIcon2 = CreateFrame('Button', nil, self) do
        GUI:Embed(RoleIcon2, 'Tooltip')
        RoleIcon2:SetTooltipAnchor('ANCHOR_TOP')
        RoleIcon2:SetSize(19, 19)
        RoleIcon2:SetPoint('LEFT', self, 'CENTER', 2, 0)
        RoleIcon2:SetNormalTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        RoleIcon2:SetHighlightTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]], 'ADD')
        RoleIcon2:SetScript('OnClick', ButtonOnClick)
    end

    self.RoleIcon1 = RoleIcon1
    self.RoleIcon2 = RoleIcon2
end

function RoleItem:SetMember(applicant)
    local assignedRole = applicant:IsAssignedRole()
    local tank = applicant:IsTank()
    local healer = applicant:IsHealer()
    local damage = applicant:IsDamage()
    local result = applicant:GetResult()
    local touchy = applicant:GetTouchy()

    local RoleIcon1 = self.RoleIcon1 do
        local role1 = tank and 'TANK' or (healer and 'HEALER' or (damage and 'DAMAGER'))
        local RoleIcon1NormalTexture = RoleIcon1:GetNormalTexture()

        RoleIcon1NormalTexture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role1))
        RoleIcon1NormalTexture:SetDesaturated(not result)

        RoleIcon1:GetHighlightTexture():SetTexCoord(GetTexCoordsForRoleSmallCircle(role1))
        RoleIcon1:SetEnabled(result and touchy and role1 ~= assignedRole)
        RoleIcon1:SetAlpha(role1 == assignedRole and 1 or 0.3)
        RoleIcon1:Show()
        RoleIcon1:SetTooltip(SET_ROLE, _G[role1])

        RoleIcon1.role = role1
    end

    local RoleIcon2 = self.RoleIcon2 do
        local role2 = (tank and healer and 'HEALER') or ((tank or healer) and damage and 'DAMAGER')

        RoleIcon2:SetShown(role2)

        if not role2 then
            return
        end

        local RoleIcon2NormalTexture = RoleIcon2:GetNormalTexture()
        RoleIcon2NormalTexture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role2))
        RoleIcon2NormalTexture:SetDesaturated(not result)

        RoleIcon2:GetHighlightTexture():SetTexCoord(GetTexCoordsForRoleSmallCircle(role2))
        RoleIcon2:SetEnabled(result and touchy and role2 ~= assignedRole)
        RoleIcon2:SetAlpha(role2 == assignedRole and 1 or 0.3)
        RoleIcon2:SetTooltip(SET_ROLE, _G[role2])

        RoleIcon2.role = role2
    end
end
