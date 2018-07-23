local tdPack = tdCore(...)

CoreDependCall("Bagnon", function()

local ipairs = ipairs
local tinsert = table.insert

local PackButton = tdPack('PackButton')

local SIZE = 20
local NORMAL_TEXTURE_SIZE = 64 * (SIZE/36)

function PackButton:Init()
    self:SetSize(SIZE, SIZE)
    
    local nt = self:CreateTexture()
    nt:SetTexture([[Interface\Buttons\UI-Quickslot2]])
    nt:SetSize(NORMAL_TEXTURE_SIZE, NORMAL_TEXTURE_SIZE)
    nt:SetPoint('CENTER', 0, -1)
    self:SetNormalTexture(nt)

    local pt = self:CreateTexture()
    pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
    pt:SetAllPoints(self)
    self:SetPushedTexture(pt)

    local ht = self:CreateTexture()
    ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
    ht:SetAllPoints(self)
    self:SetHighlightTexture(ht)

    local icon = self:CreateTexture()
    icon:SetAllPoints(self)
    icon:SetTexture([[Interface\Icons\INV_Misc_Bag_10_Green]])
end

local orig_PlaceOptionsToggle = Bagnon.Frame.PlaceOptionsToggle
function Bagnon.Frame:PlaceOptionsToggle()
	local width, height = orig_PlaceOptionsToggle(self)

	local frameID = self.frameID
    if frameID == 'inventory' or frameID == 'bank' then
		local button = PackButton:GetPackButton(self)
		button:ClearAllPoints()
		button:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -56, -8)
		button:Show()

		width = width + button:GetWidth() + 4
		height = button:GetHeight()
	end
	return width, height
end

local orig_PlaceTitleFrame = Bagnon.Frame.PlaceTitleFrame
function Bagnon.Frame:PlaceTitleFrame()
	local w, h = orig_PlaceTitleFrame(self)
	local frame = self.titleFrame
	
	local packButton = PackButton:GetPackButton(self)
	local frameID = self.frameID
	if (frameID=='inventory' or frameID=='bank') and packButton and frame then
		frame:SetPoint('RIGHT', packButton, 'LEFT', -4, 0)
	end
	return w, h
end

local orig_PlaceSearchFrame = Bagnon.Frame.PlaceSearchFrame
function Bagnon.Frame:PlaceSearchFrame()
	local w, h = orig_PlaceSearchFrame(self)
    if self.frameID ~= 'inventory' and  self.frameID ~= 'bank' then return end --163ui
	local frame = self.searchFrame
	
	local packButton = PackButton:GetPackButton(self)
	if packButton and frame then
		frame:SetPoint('RIGHT', packButton, 'LEFT', -4, 0)
	end
	return w, h
end

end)
