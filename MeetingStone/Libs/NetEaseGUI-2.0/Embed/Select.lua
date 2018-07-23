
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('Select', 1)
if not View then
    return
end

local function donothing() return nil end
local _SelectModes = {
    NONE = {
        SetSelected = donothing,
        GetSelected = donothing,
        IsSelected = donothing,
        SelectAll = donothing,
        GetSelectedItem = donothing,
        SetSelectedItem = donothing,
    },
    RADIO = {
        SetSelected = function(self, index)
            if index ~= self.selected or self.selectedItem ~= self:GetItem(index) then
                self.selected = index
                self.selectedItem = self:GetItem(index)
                self:Refresh()
                self:Fire('OnSelectChanged', index, self.selectedItem)
            end
        end,
        GetSelected = function(self)
            return self.selected
        end,
        IsSelected = function(self, index)
            return self.selected == index
        end,
        SelectAll = donothing,
        GetSelectedItem = function(self)
            return self.selected and self:GetItem(self.selected) or nil
        end,
        SetSelectedItem = function(self, item)
            for i = 1, self:GetItemCount() do
                if self:GetItem(i) == item then
                    self:SetSelected(i)
                    return
                end
            end
            self:SetSelected(nil)
        end,
        _Select_OnRefresh = function(self)
            if self.selectedItem then
                self:SetSelectedItem(self.selectedItem)
            end
        end
    },
    MULTI = {
        SetSelected = function(self, index)
            self.selected[index] = not self.selected[index] or nil
            self:Refresh()
        end,
        GetSelected = function(self)
            return self.selected
        end,
        IsSelected = function(self, index)
            return self.selected[index]
        end,
        SelectAll = function(self, flag)
            if flag then
                for i = 1 + self:GetExcludeCount(), self:GetItemCount() + self:GetExcludeCount() do
                    self.selected[i] = true
                end
            else
                wipe(self.selected)
            end
            self:Refresh()
        end,
        GetSelectedItem = donothing,
        SetSelectedItem = donothing,
    }
}

function View:SetSelectMode(mode)
    mode = mode:upper()

    if not (mode == 'NONE' or mode == 'MULTI' or mode == 'RADIO') then
        error(([[Cannot set select mode to '%s']]):format(mode), 2)
    end
    self.selectMode = mode

    for k, v in pairs(_SelectModes[mode]) do
        self[k] = v
    end

    if mode == 'MULTI' then
        self.selected = {}
    else
        self.selected = nil
    end
end

function View:GetSelectMode()
    return self.selectMode or 'NONE'
end
