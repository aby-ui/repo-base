-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Listbox
  -- l2_texture			backdrop texture
  -- l2_border			backdrop border
  -- highlight			highlight vertex color
  
 -- Listbutton
  -- l3_border			backdrop border
  -- highlight			highlight vertex color
--

-- Listbox
 -- .list
 -- .update_pre(self)						fired before the list update
 -- .update_post(self)						fired after the list update
 -- .update_button(btn, list, index)		fired for every button during the update
 -- .hideSelection

if NyxGUIPass then return end

local ng = NyxGUI(NyxGUImajor)
ng:RegisterType("Listbox")
ng:RegisterType("Listbutton")

-- Listbox
local function listbox_update(self)
 local offset = HybridScrollFrame_GetOffset(self)
 local buttons = self.buttons
 local height = buttons[1]:GetHeight()
 

 if self.update_pre then
  self:update_pre()
 end

 local list = self.list
 
 if not list then
  for i = 1, #buttons do
   buttons[i]:Hide()
  end
  HybridScrollFrame_Update(self, 0, height)
  return
 end

 for i = 1, #buttons do
  local index = offset + i

  if list[index] then
   buttons[i].index = index
   if self.update_button then
    self.update_button(buttons[i], list, index)
   end

   if not self.hideSelection and self.sel_index == index then
    buttons[i]:LockHighlight()
   else
    buttons[i]:UnlockHighlight()
   end
   buttons[i]:Show()
  else
   buttons[i].index = nil
   buttons[i]:Hide()
  end
 end
 
 if self.update_post then
  self:update_post()
 end

 HybridScrollFrame_Update(self, height * #list, height)
end

local function scrollbar_valuechanged(self)
 HybridScrollFrame_OnValueChanged(self, self:GetValue())
end

local function listbox_init(self, buttontype, list)
 HybridScrollFrame_CreateButtons(self, buttontype, 0, 0, "TOPLEFT", "TOPLEFT", 0, 0, "TOP", "BOTTOM")
 
 local buttons = self.buttons
 
 local w = self:GetWidth()
 for i = 1,#buttons do
  ng.scripts.Listbutton.OnLoad(buttons[i])
  buttons[i]:SetScript("OnClick", ng.scripts.Listbutton.OnClick)
  if self.addon and self.theme then
   ng:AddToTheme(self.addon, self.theme, "Listbutton", buttons[i])
  end
  buttons[i]:SetWidth(w)
 end

 if list ~= nil then
  self.list = list
 end

 self.scrollBar:SetScript("OnValueChanged", scrollbar_valuechanged)

 self.update = listbox_update
 self:update()
end

function scroll_up(self)
 local p = self:GetParent()
 p:SetValue(p:GetValue() - (p.scrollStep or (p:GetHeight() / 2)))
 PlaySound(826)
end

function scroll_down(self)
 local p = self:GetParent()
 p:SetValue(p:GetValue() + (p.scrollStep or (p:GetHeight() / 2)))
 PlaySound(826)
end

function ng.constructors.Listbox(addon, name, parent, theme)

 assert(name, "NyxGUI: New(Listbox) the name parameter cannot be nil.")

 local lb = CreateFrame("Scrollframe", name, parent, "HybridScrollFrameTemplate")

 lb.backdrop_type = "l1"
 lb.addon = addon
 lb.theme = theme
 
 local sb = ng:New(addon, "SliderV", name.."ScrollBar", lb, theme)

 sb:SetPoint("TOPLEFT", lb, "TOPRIGHT", 4, -15)
 sb:SetPoint("BOTTOMLEFT", lb, "BOTTOMRIGHT", 4, 15)
 
 -- ScrollUp button
 local f = CreateFrame("Button", name.."ScrollUp", sb)
 f:SetPoint("BOTTOMLEFT", sb, "TOPLEFT", 1, 1)
 f:SetPoint("BOTTOMRIGHT", sb, "TOPRIGHT", 1, 1)
 f:SetHeight(15)
 f:SetNormalTexture("Interface\\Buttons\\Arrow-Up-Up")
 f:SetPushedTexture("Interface\\Buttons\\Arrow-Up-Down")
 f:SetScript("OnClick", scroll_up)
 lb.scrollUp = f

 -- ScrollDown button
 f = CreateFrame("Button", name.."ScrollDown", sb)
 f:SetPoint("TOPLEFT", sb, "BOTTOMLEFT", 1, -2)
 f:SetPoint("TOPRIGHT", sb, "BOTTOMRIGHT", 1, -2)
 f:SetHeight(15)
 f:SetNormalTexture("Interface\\Buttons\\Arrow-Down-Up")
 f:SetPushedTexture("Interface\\Buttons\\Arrow-Down-Down")
 f:SetScript("OnClick", scroll_down)
 lb.scrollDown = f

 sb.doNotHide = true
 sb.text_value:Hide()

 lb.scrollBar = sb
 lb.Initialize = listbox_init
 
 return lb
end

function ng.set_theme.Listbox(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l1_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l2_border"]))
end

local function listbutton_isselected(self)
 return self:GetParent():GetParent().sel_index == self.index
end

-- Listbutton
function ng.scripts.Listbutton.OnLoad(self)
 self:SetWidth(self:GetParent():GetParent():GetWidth())
 self.IsSelected = listbutton_isselected
end

function ng.set_theme.Listbutton(self, th)
 self:SetBackdropBorderColor(ng.hex2rgba(th["l3_border"]))
 self:GetHighlightTexture():SetVertexColor(ng.hex2rgba(th["highlight"]))
end

function ng.scripts.Listbutton.OnClick(self)
 local p = self:GetParent():GetParent()
 if p.sel_index == self.index then
  self.wasSelected = true
 else
  self.wasSelected = false
  p.sel_index = self.index
 end
 if self.func then self:func(self) end
 p:update()
end
