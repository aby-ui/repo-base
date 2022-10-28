local XLoot = select(2, ...)
local lib = {}
XLoot.Stack = lib
local L = XLoot.L
local print = print

local AnchorPrototype = XLoot.NewPrototype()

-- ANCHOR element
do
	local backdrop = { bgFile = [[Interface\Tooltips\UI-Tooltip-Background]] }

	function AnchorPrototype:OnDragStart()
		if self.data.draggable ~= false then
			self:StartMoving()
		end
	end

	function AnchorPrototype:OnDragStop()
		self:StopMovingOrSizing()
		self.data.x = self:GetLeft()
		self.data.y = self:GetTop()
	end

	function AnchorPrototype:Show()
		self:SetClampedToScreen(true)
		self:Position()
		self.data.visible = true
		self:_Show()
	end

	function AnchorPrototype:Hide()
		self:SetClampedToScreen(false)
		if self.data.direction == 'up' then
			self:Position(self.data.x, self.data.y - 20)
		elseif self.data.direction then
			self:Position(self.data.x, self.data.y + 20)
		end
		self:GetTop() -- Force reflow
		self:GetBottom()
		self.data.visible = false
		self:_Hide()
	end

	function AnchorPrototype:Position(x, y)
		self:ClearAllPoints()
		self:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', x or self.data.x, y or self.data.y)
		self:SetHeight(20)
		-- self:SetWidth(self.label:GetStringWidth() + 100)
		self:SetWidth(175)
	end

	function AnchorPrototype:AnchorChild(child, to)
		child:ClearAllPoints()
		child:SetPoint(
			self.childPoint,
			to ~= self and to or self,
			self.parentPoint,
			self.offset,
			self.spacing
		)
		if self.data and self.data.scale then
			child:SetScale(child.scale_mod and self.data.scale * child.scale_mod or self.data.scale)
		elseif child.scale_mod then
			child:SetScale(child.scale_mod)
		end
	end

	function AnchorPrototype:UpdateSVData(svdata)
		if svdata then
			if self.data == svdata then
				local mod = self:GetScale() / svdata.scale
				svdata.x = svdata.x * mod
				svdata.y = svdata.y * mod
			end
			self.data = svdata
			self:SetScale(svdata.scale)
			self:Position()
			if svdata.visible then
				self:Show()
			else
				self:Hide()
			end
			self.offset = svdata.offset or 0
			self.spacing = svdata.spacing or 2
			local horizontal = svdata.alignment == 'right' and 'RIGHT' or 'LEFT'
			self.childPoint, self.parentPoint = 'BOTTOM'..horizontal, 'TOP'..horizontal
			if svdata.direction == 'down' then
				self.childPoint, self.parentPoint = self.parentPoint, self.childPoint
				self.spacing = -self.spacing
			end
		else
			self.data = {}
		end
	end

	local function Hide_OnClick(self)
		self.parent:Hide()
	end

	local function Hide_OnEnter(self)
		GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
		GameTooltip:SetText(L.anchor_hide_desc)
		GameTooltip:Show()
		self.label:SetTextColor(1, 1, 1)
	end

	local function Hide_OnLeave(self)
		GameTooltip:Hide()
		self.label:SetTextColor(.4, .4, .4)
	end

	function lib:CreateAnchor(text, svdata)
		local anchor = CreateFrame('Button', nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
		AnchorPrototype:New(anchor)
		anchor:SetBackdrop(backdrop)
		anchor:SetBackdropColor(0, 0, 0, 0.7)
		anchor:SetMovable(true)
		anchor:SetClampedToScreen(true)
		anchor:RegisterForDrag('LeftButton')
		anchor:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		anchor:SetScript('OnDragStart', anchor.OnDragStart)
		anchor:SetScript('OnDragStop', anchor.OnDragStop)
		anchor:SetAlpha(0.8)

		local hide = CreateFrame('Button', nil, anchor)
		hide:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
		hide:SetPoint('RIGHT', -3, 0)
		hide:SetHeight(16)
		hide:SetHitRectInsets(10, 10, 1, -2)
		hide:SetScript('OnClick', Hide_OnClick)
		hide:SetScript('OnEnter', Hide_OnEnter)
		hide:SetScript('OnLeave', Hide_OnLeave)
		hide.parent = anchor
		anchor.hide = hide

		hide.label = hide:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		hide.label:SetPoint('TOP')
		hide.label:SetPoint('BOTTOM')
		hide.label:SetText(L.anchor_hide)
		Hide_OnLeave(hide) -- Set text color
		hide:SetWidth(hide.label:GetStringWidth()+30)

		local label = anchor:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
		label:SetPoint('CENTER', -5, 0)
		label:SetJustifyH('MIDDLE')
		label:SetText(text)
		anchor.label = label

		anchor:SetHeight(20)
		anchor:SetWidth(label:GetStringWidth() + 100)

		anchor:UpdateSVData(svdata)

		return anchor
	end
end
-- END ANCHOR element

local function AnchorScale(self, scale)
	self:SetScale(scale)
	if self.children then
		for _, child in pairs(self.children) do
			child:SetScale(scale)
		end
	end
end

local table_insert = table.insert
local function AcquireChild(self)
	for _, f in ipairs(self.children) do
		if not f.active then
			return f
		end
	end
	local child = self:Factory()
	table_insert(self.children, child)
	return child, true
end

-- STATIC STACK
do
	local function Push(self)
		local child, new = AcquireChild(self)
		if new then
			local n = #self.children
			self:AnchorChild(child, n > 1 and self.children[n-1] or nil)
		end
		child:Show()
		child.active = true
		return child
	end

	local function Pop(self, child)
		child:Hide()
		child.active = false
		if child.Popped then
			child:Popped()
		end
	end

	local function Restack(self)
		local children = self.children
		for i,child in ipairs(self.children) do
			child:ClearAllPoints()
			self:AnchorChild(child, i == 1 and self or children[i-1])
		end
	end

	function lib:CreateStaticStack(factory, ...)
		local anchor = self:CreateAnchor(...)
		anchor.children = {}
		anchor.Factory = factory
		anchor.Push = Push
		anchor.Pop = Pop
		anchor.Scale = AnchorScale
		anchor.Restack = Restack
		return anchor
	end
end

