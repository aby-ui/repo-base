-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Dropdown
  -- l2_texture			backdrop texture
  -- l2_color           backdrop color
  -- l2_border			backdrop border
--

-- Vars
 -- Dropdown
  -- .list				the list of elements to show
  -- .index			    the selected element's index
  -- .OnValueChanged	function (don't use SetScript, just attach this var or hook the existing script)

if NyxGUIPass then return end

local ng = NyxGUI(NyxGUImajor)

ng:RegisterType("Dropdown")

local mf, dropdowns

-- Dropdown
local black = {0, 0, 0, 0}
local function hideList()
 if ng.opened_dropdown then
  if ng.opened_dropdown.original_border then
   ng.opened_dropdown:SetBackdropBorderColor(ng.hex2rgba(ng.opened_dropdown.original_border))
  else
   ng.opened_dropdown:SetBackdropBorderColor(black)
  end
  ng.opened_dropdown = nil
 end
 mf:Hide()
end

local function showList(self, isRefresh)
 if not self.list or (not isRefresh and mf.list == self.list and mf:IsVisible()) then 
  hideList()
  return
 end

 mf:SetParent(self)
 mf:SetPoint("TOP", self, "BOTTOM")
 mf:SetFrameStrata("DIALOG")
 mf.list = self.list
 mf.update_pre = self.update_pre
 mf.update_post = self.update_post
 mf.update_button = self.update_button
 mf:update()

 if self.highlighted_border then
  self:SetBackdropBorderColor(ng.hex2rgba(self.highlighted_border))
 else
  self:SetBackdropBorderColor({1, 1, 1, 1})
 end
 
 ng.opened_dropdown = self

 for _,v in pairs(dropdowns) do
  if v ~= self then
   if v.original_border then
    v:SetBackdropBorderColor(ng.hex2rgba(v.original_border))
   else
    v:SetBackdropBorderColor(black)
   end
  end
 end
 
 mf:Show()
end

function ng.scripts.Dropdown.OnClick(self)
 showList(self)
end

local function dropdown_listbutton_onclick(btn)
 ng.opened_dropdown:SetText(btn.left_text:GetText())
 ng.opened_dropdown.index = btn.index

 if ng.opened_dropdown.OnValueChanged then
  ng.opened_dropdown:OnValueChanged()
 end

 hideList()
end

local function select_index(self, i)
 if not self.list or not self.list[i] then
  self:SetText("")
  self.index = 0
  return
 end
 
 self.index = i
 self:SetText(self.list[i])
 if self.OnValueChanged then
  self:OnValueChanged()
 end
end

local function dropdown_init(self)
 if not self.list then return end
 
 self:Select(1)
end

function ng.constructors.Dropdown(addon, name, parent, theme)
 local f = CreateFrame("Button", name, parent)
 
 if not dropdowns then dropdowns = {} end
 
 if not mf then
  mf = ng:New("NyxGUI", "Listbox", "NyxGUIDropdownList", f)
  mf:SetSize(200, 200)
  mf:Initialize("NyxGUIDropdownListButton")
  mf.hideSelection = true
  mf:SetBackdropColor(0, 0, 0, 1)
  for k,v in pairs(mf.buttons) do
   v.func = dropdown_listbutton_onclick
   v:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.2)
  end
  mf:Hide()
 end

 local tex = f:CreateTexture()
 tex:SetSize(24, 24)
 tex:SetTexture("Interface\\Buttons\\UI-MicroStream-Yellow")
 tex:SetPoint("RIGHT", f, "RIGHT", -5, 0)
 f.arrow = tex

 f:SetSize(80, 20)
 f.text = ng:New(addon, "Label", nil, f)
 f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
 f.text:SetPoint("BOTTOMRIGHT", f.arrow, "BOTTOMLEFT", -1, 1)
 f.SetText = ng.set_text_function

 f:SetScript("OnHide", hideList)
 f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
 f.backdrop_type = "l2"
 
 f.Initialize = dropdown_init
 f.Select = select_index
 
 dropdowns[#dropdowns + 1] = f
 return f
end

function ng.set_theme.Dropdown(self, th)
 
 self:SetBackdropColor(ng.hex2rgba(th["l2_color"]))
 self:GetHighlightTexture():SetVertexColor(ng.hex2rgba(th["highlight"]))

 local r, g, b, a = ng.hex2rgba(th["l2_border"])
 self:SetBackdropBorderColor(r, g, b, a)
 self.original_border = th["l2_border"]
 self.highlighted_border = ng.rgba2hex(r + 0.3, g + 0.3, b + 0.3, a + 0.3)
end
