--[[
	bindableButton:
		An abstract button class used to allow keybound to work transparently
		on both the stock blizzard bindings, and click bindings
--]]

local _, Addon = ...
local KeyBound = LibStub('LibKeyBound-1.0')

local BindableButton = Addon:CreateClass('CheckButton')

-- there's a nice assumption here: all hotkey text will use the same naming
-- convention the call here is wacky because this functionality is actually
-- called for the blizzard buttons _before_ I'm able to bind the action button
-- methods to them
function BindableButton:UpdateHotkey(buttonType)
	local key = BindableButton.GetHotkey(self, buttonType)

	if key ~= ''  and Addon:ShowBindingText() then
		self.HotKey:SetText(key)
		self.HotKey:Show()
	else
		--blank out non blank text, such as RANGE_INDICATOR
		self.HotKey:SetText('')
		self.HotKey:Hide()
	end
end

--returns what hotkey to display for the button
function BindableButton:GetHotkey(buttonType)
	local key = BindableButton.GetBlizzBindings(self, buttonType)
			 or BindableButton.GetClickBindings(self)

	return key and KeyBound:ToShortKey(key) or ''
end

-- returns all blizzard bindings assigned to the button
function BindableButton:GetBlizzBindings(buttonType)
	buttonType = buttonType or self.buttonType

	if buttonType then
		local id = self:GetAttribute('bindingid') or self:GetID()
		return GetBindingKey(buttonType .. id)
	end
end

-- returns all click bindings assigned to the button
function BindableButton:GetClickBindings()
	return GetBindingKey(('CLICK %s:LeftButton'):format(self:GetName()))
end

-- returns a comma separated list of all bindings for the given action button
-- used for keybound support
do
    local buffer = {}

    local function addBindings(t, ...)
        for i = 1, select("#", ...) do
            local binding = select(i, ...)
            table.insert(t, GetBindingText(binding))
        end
    end

    function BindableButton:GetBindings()
        wipe(buffer)

        addBindings(buffer, self:GetBlizzBindings())
        addBindings(buffer, self:GetClickBindings())

        return table.concat(buffer, ", ")
    end
end

--set bindings (more keybound support)
function BindableButton:SetKey(key)
	if self.buttonType then
		local id = self:GetAttribute('bindingid') or self:GetID()
		SetBinding(key, self.buttonType .. id)
	else
		SetBindingClick(key, self:GetName(), 'LeftButton')
	end
end

--clears all bindings from the button (keybound support again)
do
	local function clearBindings(...)
		for i = 1, select('#', ...) do
			SetBinding(select(i, ...), nil)
		end
	end

	function BindableButton:ClearBindings()
		clearBindings(self:GetBlizzBindings())
		clearBindings(self:GetClickBindings())
	end
end


-- exports
Addon.BindableButton = BindableButton