
local WIDGET, VERSION = 'DataGridViewGridItem', 3

local GUI = LibStub('NetEaseGUI-2.0')
local DataGridViewGridItem = GUI:NewClass(WIDGET, 'Button', VERSION)
if not DataGridViewGridItem then
    return
end

local STYLES = {
    LEFT = function(self)
        self.Icon:Hide()
        self:SetNormalFontObject('GameFontHighlightLeft')
    end,
    RIGHT = function(self)
        self.Icon:Hide()
        self:SetNormalFontObject('GameFontHighlightRight')
    end,
    NORMAL = function(self)
        self.Icon:Hide()
        self:SetNormalFontObject('GameFontHighlight')
    end,
    ICON = function(self, width, height)
        self.width = tonumber(width)
        self.height = tonumber(height)

        self.Text:Hide()
        self.Icon:SetPoint('CENTER')
        self.Icon:SetSize(width or 16, height or width or 16)
    end,
    ICONTEXT = function(self, width, height)
        self.width = tonumber(width)
        self.height = tonumber(height)

        self.Icon:SetPoint('LEFT')
        self.Icon:SetSize(width or 16, height or width or 16)
        self.Text:ClearAllPoints()
        self.Text:SetPoint('LEFT', self.Icon, 'RIGHT', 2, 0)
        -- self.Text:SetPoint('TOPRIGHT')
        -- self.Text:SetPoint('BOTTOMRIGHT')
        self.Text:SetPoint('RIGHT')
        self:SetNormalFontObject('GameFontHighlightLeft')
    end,
}

local function StyleHelper(object, style, ...)
    STYLES[style](object, ...)
end

local function TextureHelper(data)
    local path, height, width, _, _, dimx, dimy, left, right, top, bottom, r, g, b = strsplit(':', data)

    dimx = tonumber(dimx)
    dimy = tonumber(dimy)
    left = tonumber(left)
    right = tonumber(right)
    top = tonumber(top)
    bottom = tonumber(bottom)
    r = tonumber(r)
    g = tonumber(g)
    b = tonumber(b)

    if dimx and dimy and left and right and top and bottom then
        left, right, top, bottom = left/dimx, right/dimx, top/dimy, bottom/dimy
    else
        left, right, top, bottom = nil
    end

    if r and g and b then
        r, g, b = r/255, g/255, b/255
    else
        r, g, b = nil
    end

    width = tonumber(width)
    height = tonumber(height)

    return path, left, right, top, bottom, width, height, r, g, b
end

function DataGridViewGridItem:Constructor(_, style)
    local Text = self:CreateFontString(nil, 'OVERLAY')
    Text:SetPoint('LEFT')
    Text:SetPoint('RIGHT')
    Text:SetWordWrap(false)
    self:SetFontString(Text)

    local Icon = self:CreateTexture(nil, 'OVERLAY')
    Icon:SetSize(16, 16)

    self.Text = Text
    self.Icon = Icon

    StyleHelper(self, strsplit(':', style or 'NORMAL'))

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
    self:SetScript('OnClick', self.OnClick)
    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', self.OnLeave)

    self:RegisterForClicks('anyUp')
end

function DataGridViewGridItem:FireHandler(handler)
    local parent = self:GetParent()
    local view   = parent:GetOwner()
    local item   = view:GetItem(parent:GetID())
    local key    = self.key

    view:Fire(handler, self, item, key)
    view:Fire(handler .. '_' .. key, self, item, key)
end

function DataGridViewGridItem:OnClick(click, ...)
    local parent = self:GetParent()
    local view = parent:GetOwner()
    if parent:IsEnabled() then
        parent:Click(click, ...)

        if click == 'LeftButton' then
            self:FireHandler('OnGridClick')
        end
    end
end

function DataGridViewGridItem:OnEnter()
    local parent = self:GetParent()
    if not parent:IsEnabled() then
        parent:UnlockHighlight()
    else
        parent:LockHighlight()
    end
    parent:OnEnter()
    self:FireHandler('OnGridEnter')
end

function DataGridViewGridItem:OnLeave()
    local parent = self:GetParent()

    parent:UnlockHighlight()
    parent:OnLeave()
    self:FireHandler('OnGridLeave')
end

function DataGridViewGridItem:SetIcon(icon, left, right, top, bottom, width, height)
    if not self.Icon then
        return
    end

    if not icon or icon == '' then
        self.Icon:Hide()
        self.Icon:SetSize(width or 1, height or width or 1)
        return
    end

    local data = icon:match('|T([^|]+)|t')
    if data then
        icon, left, right, top, bottom, width, height, r, g, b = TextureHelper(data)
    end

    self.Icon:SetTexture(icon)

    if left then
        if type(left) == 'table' then
            local coords = left
            self.Icon:SetTexCoord(
                coords.left or coords[1],
                coords.right or coords[2],
                coords.top or coords[3],
                coords.bottom or coords.bot or coords[4])
        elseif type(left) == 'number' then
            self.Icon:SetTexCoord(left, right, top, bottom)
        end
    else
        self.Icon:SetTexCoord(0, 1, 0, 1)
    end

    width = width or self.width or 16
    height = height or self.height or width or 16

    self.Icon:SetSize(width, height)
    self.Icon:Show()
end

function DataGridViewGridItem:SetIconAtlas(atlas, useAtlasSize)
    if not self.Icon then
        return
    end
    if not atlas or not GetAtlasInfo(atlas) then
        self.Icon:Hide()
        self.Icon:SetSize(1, 1)
        return
    end

    self.Icon:SetAtlas(atlas, useAtlasSize)
    self.Icon:Show()
end
