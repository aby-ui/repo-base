-------------------------------------------------------------------------------
-- ListBox.lua
--
-- A custom control for use with AceConfig.  This control doesn't implement
-- the spec exactly--it just does what it needs to for AuctionLite's purposes.
-------------------------------------------------------------------------------

local _

local AceGUI = LibStub("AceGUI-3.0");
local Version = 1;

local Type = "ListBox";
local ListBox = {};

-- Draw the list box.
local function ListBox_Update(box)
  local scrollFrame = box.scrollFrame;
  local buttons = box.buttons;
  local list = box.obj.list;
  local values = box.obj.values;
  local numButtons = #buttons;
  local numCategories = #list;
  if numCategories > numButtons and not scrollFrame:IsShown() then
    OptionsList_DisplayScrollBar(box);
  elseif numCategories <= numButtons and scrollFrame:IsShown() then
    OptionsList_HideScrollBar(box);
  end

  FauxScrollFrame_Update(scrollFrame, numCategories, numButtons,
                         buttons[1]:GetHeight());

  OptionsList_ClearSelection(box, box.buttons);

  local offset = FauxScrollFrame_GetOffset(scrollFrame);
  for i = 1, numButtons do
    local item = list[i + offset];
    if item then
      OptionsList_DisplayButton(buttons[i], { name = item, id = i + offset });
      if values[i + offset] then
        OptionsList_SelectButton(box, buttons[i]);
      end
    else
      OptionsList_HideButton(buttons[i]);
    end
  end
end

-- Handle a mouse click on an entry.
local function ListButton_OnClick(button)
  local box = button:GetParent();
  local id = button.element.id;
  box.obj:Fire("OnValueChanged", id, not box.obj.values[id]);
  box.obj:Fire("OnClosed");
  ListBox_Update(box);
end

-- Acquire this widget.
function ListBox:OnAcquire()
  self:SetDisabled(false);
end

-- Release this widget for reuse.
function ListBox:OnRelease()
  self.frame:ClearAllPoints();
  self.frame:Hide();
  self:SetDisabled(false);
end

-- Enable/disable the widget.
function ListBox:SetDisabled(disabled)
  self.disabled = disabled;
  if disabled then
    self.box:EnableMouse(false);
    self.label:SetTextColor(0.5, 0.5, 0.5);
  else
    self.box:EnableMouse(true);
    self.label:SetTextColor(1, 0.82, 0);
  end
end

-- Indicate whether it's a multiselect control.
function ListBox:SetMultiselect(multi)
  self.multi = multi;
end

-- Set (and show/hide) the widget label.
function ListBox:SetLabel(text)
  if (text or "") == "" then
    self.frame:SetHeight(196);
    self.box:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0);
    self.label:Hide();
    self.label:SetText("");
  else
    self.frame:SetHeight(216);
    self.box:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -20);
    self.label:Show();
    self.label:SetText(text);
  end
end

-- Set the contents of the widget.  Must be a integer-indexed list.
function ListBox:SetList(list)
  self.list = list;
  self.values = {};
  ListBox_Update(self.box);
end

-- Unused, since only multiselect is supported for now.
function ListBox:SetValue(value)
  assert(false);
end

-- Activate/deactivate an item.
function ListBox:SetItemValue(key, value)
  if not value then
    value = nil;
  end
  self.values[key] = value;
  ListBox_Update(self.box);
end

-- Build a new widget.  We use OptionsFrameListTemplate as provided by
-- Blizzard, with a few nefarious tweaks.
local function Constructor()
  local num = AceGUI:GetNextWidgetNum(Type);
  local frame = CreateFrame("Frame", "AceGUI30ListBox" .. num, UIParent);
  local self = {};
  for k, v in pairs(ListBox) do self[k] = v end;
  self.num = num;
  self.type = Type;
  self.frame = frame;
  frame.obj = self;
  
  frame:SetHeight(216);

  local box = CreateFrame("Frame", "AceGUI30ListBoxBox" .. num, frame,
                          "OptionsFrameListTemplate");
  box.update = ListBox_Update;
  box:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -20);
  box:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0);
  box:SetHeight(196);

  local buttons = box.buttons;
  local maxButtons = math.floor((box:GetHeight() - 8) / box.buttonHeight);
  while #buttons < maxButtons do
    local index = #buttons + 1;
    local button = CreateFrame("Button", box:GetName() .. "Button" ..  index,
                               box, "OptionsListButtonTemplate");
    button:SetPoint("TOPLEFT", buttons[#buttons], "BOTTOMLEFT");
    tinsert(buttons, button);
  end
  local button;
  for _, button in ipairs(buttons) do
    button.text:SetText("Button");
    button:SetPoint("RIGHT", button:GetParent(), "RIGHT");
    button:SetScript("OnClick", ListButton_OnClick);
  end
  box.buttons = buttons;

  self.box = box;
  box.obj = self;

  local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall");
  label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2);
  label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2);
  label:SetJustifyH("LEFT");
  label:SetHeight(18);
  self.label = label;
  label.obj = self;

  AceGUI:RegisterAsWidget(self);
  return self;
end

AceGUI:RegisterWidgetType(Type, Constructor, Version);
