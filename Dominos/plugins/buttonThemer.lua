local AddonName = ...
local ButtonThemer = LibStub('AceAddon-3.0'):GetAddon(AddonName):NewModule('ButtonThemer')

local _NormalButtonWidth = _G['ActionButton1']:GetWidth()

function ButtonThemer:OnInitialize()
    local Masque = LibStub('Masque', true)

    if Masque then
        Masque:Register(AddonName, function(...)
            local addon, group, skinId, gloss, backdrop, colors, disabled = ...

            if disabled then
                for button in pairs(Masque:Group(AddonName, group).Buttons) do
                    self:ApplyDefaultTheme(button)
                end
            end
        end)

        self.Register = function(self, button, groupName, ...)
            local group = Masque:Group(AddonName, groupName)

            group:AddButton(button, ...)

            if not group.db or group.db.disabled then
                self:ApplyDefaultTheme(button)
            end
        end
    else
        self.Register = self.ApplyDefaultTheme
    end
end

function ButtonThemer:Unload()
    self.shouldReskin = true
end

function ButtonThemer:Reskin()
    if not self.shouldReskin then return end

    self.shouldReskin = nil

    local Masque = LibStub('Masque', true)
    if Masque then
        for _, groupName in pairs(Masque:Group(AddonName).SubList or {}) do
            Masque:Group(AddonName, groupName):ReSkin()
        end
    end
end

function ButtonThemer:ApplyDefaultTheme(button)
    button.icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)

    local r = button:GetWidth() / _NormalButtonWidth

    local nt = button:GetNormalTexture()
    nt:ClearAllPoints()
    nt:SetPoint('TOPLEFT', -15 * r, 15 * r)
    nt:SetPoint('BOTTOMRIGHT', 15 * r, -15 * r)
    nt:SetVertexColor(1, 1, 1, 0.5)

    local floatingBG = _G[('%sFloatingBG'):format(button:GetName())]
    if floatingBG then
        floatingBG:Hide()
    end
end
