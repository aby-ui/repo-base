local _, T = ...
local E = T.Evie

function T.GetMouseFocus()
	local f = GetMouseFocus()
	return f and f.IsForbidden and not f:IsForbidden() and f or nil
end
function T.IsDescendantOf(self, ancestor)
	if not (self and ancestor) then
		return false
	end
	repeat
		self = not self:IsForbidden() and self:GetParent()
	until (self or ancestor) == ancestor
	return self == ancestor
end
do
	local f, q, nq = CreateFrame("Frame"), {}, 0
	function T.After0(func)
		nq = nq + 1
		q[nq] = func
	end
	f:SetScript("OnUpdate", function()
		if nq ~= 0 then
			local i, f = 1, q[1]
			while f do
				securecall(f)
				i, q[i] = i + 1
				f = q[i]
			end
			nq = 0
		end
	end)
end

do
	local function DropDownMenuButton_OnEnter(self)
		if self and self.tooltipTitle == nil and self.tooltipText == nil and type(self.tooltipOnButton) == "function" then
			self.tooltipOwner, self.tooltipOnLeave = self, securecall(self.tooltipOnButton, self, self.arg1, self.arg2)
		else
			self.tooltipOwner, self.tooltipOnLeave = nil
		end
	end
	local function DropDownMenuButton_OnLeave(self)
		if self and self.tooltipOwner and type(self.tooltipOnLeave) == "function" then
			securecall(self.tooltipOnLeave, self.tooltipOwner)
			self.tooltipOnLeave, self.tooltipOwner = nil
		end
	end
	hooksecurefunc("UIDropDownMenuButton_OnEnter", DropDownMenuButton_OnEnter)
	hooksecurefunc("UIDropDownMenuButton_OnLeave", DropDownMenuButton_OnLeave)
	for i=1,UIDROPDOWNMENU_MAXLEVELS do
		for j=1,UIDROPDOWNMENU_MAXBUTTONS do
			local b = _G["DropDownList" .. i .. "Button" .. j]
			b:HookScript("OnEnter", DropDownMenuButton_OnEnter)
			b:HookScript("OnLeave", DropDownMenuButton_OnLeave)
		end
	end
end

local CreateLazyItemButton do
	local itemIDs, OnEnter = {}
	local function OnUpdateSync(self, elapsed)
		if GameTooltip:IsOwned(self) then
			local t = (self.nextUp or 0) + elapsed
			if t > 0.5 then
				t = 0
				OnEnter(self)
			end
			self.nextUp = 0
		else
			self:SetScript("OnUpdate", nil)
		end
	end
	function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local iid, generic = itemIDs[self], true
		for i=0,4 do
			for j=1,GetContainerNumSlots(i) do
				if GetContainerItemID(i, j) == iid then
					generic = false
					GameTooltip:SetBagItem(i, j)
					break
				end
			end
		end
		if generic then
			GameTooltip:SetItemByID(iid)
		end
		GameTooltip:Show()
		self:SetScript("OnUpdate", OnUpdateSync)
	end
	local function OnLeave(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	local function OnShow(self)
		self.Count:SetText((GetItemCount(itemIDs[self])))
	end
	local function OnClick()
		if InCombatLockdown() then
			UIErrorsFrame:TryDisplayMessage(LE_GAME_ERR_NOT_IN_COMBAT or -1, ERR_NOT_IN_COMBAT, RED_FONT_COLOR:GetRGB());
		end
	end
	function CreateLazyItemButton(parent, itemID)
		local f = CreateFrame("Button", nil, parent, "InsecureActionButtonTemplate")
		f:SetScript("OnShow", OnShow)
		itemIDs[f], f.itemID = itemID, itemID
		f.Icon = f:CreateTexture(nil, "ARTWORK")
		f.Icon:SetAllPoints()
		f.Icon:SetTexture(GetItemIcon(itemID))
		f.Count = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
		f.Count:SetPoint("BOTTOMRIGHT", -1, 2)
		f:SetAttribute("type", "macro")
		f:SetAttribute("macrotext", SLASH_STOPSPELLTARGET1 .. "\n" .. SLASH_USE1 .. " item:" .. itemID)
		f:SetScript("OnEnter", OnEnter)
		f:SetScript("OnLeave", OnLeave)
		f:SetScript("PreClick", OnClick)
		f:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		f:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
		return f,f
	end
	function E:BAG_UPDATE_DELAYED()
		for k in pairs(itemIDs) do
			if k:IsVisible() then
				OnShow(k)
			end
		end
	end
	T.CreateLazyItemButton = CreateLazyItemButton
end

ShoppingTooltip1TextLeft3:SetJustifyH("LEFT")

do -- SetModifierSensitiveTooltip
	local func, owner, watching, a1, a2, a3, a4, a5
	local function watch()
		if watching:IsOwned(owner) then
			func(watching, a1, a2, a3, a4, a5)
			watching:Show()
		else
			func, owner, watching, a1, a2, a3, a4, a5 = nil
			return "remove"
		end
	end
	function T.SetModifierSensitiveTip(...)
		local owatching = watching
		func, watching, a1, a2, a3, a4, a5 = ...
		if watching then
			owner = watching:GetOwner()
			if not owatching then
				E.MODIFIER_STATE_CHANGED = watch
			end
		end
	end
end