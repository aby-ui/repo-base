-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Button
  -- l3_texture			backdrop texture
  -- l3_color           backdrop color
  -- l3_border			backdrop border
  -- highlight			highlight vertex color
  -- font				1

-- Tabbutton
  -- l3_texture			backdrop texture
  -- l3_color           backdrop color
  -- l3_border			backdrop border
  -- highlight			highlight vertex color

-- Checkbutton
  -- l3_texture			backdrop texture
  -- l3_color           backdrop color
  -- l3_border			backdrop border
  -- highlight			highlight vertex color

-- Checkbox
  -- thumb 				thumb color
  
-- Radiobutton
  -- thumb 				thumb color
--

-- Vars
 -- Colorbutton (this is a very early version, it's going to be overhauled)
  -- .tag	the widget that's being edited  
  -- .mode	"backdrop" "backdrop_border" or "fontstring" determines which color of .tag is being edited


if NyxGUIPass then return end

local tinsert = table.insert

local ng = NyxGUI(NyxGUImajor)

ng:RegisterType("Button")
ng:RegisterType("Colorbutton")
ng:RegisterType("Checkbutton")
ng:RegisterType("Tabbutton")
ng:RegisterType("Checkbox")
ng:RegisterType("Radiobutton")

function ng:SetButtonsFont(font)
 ng.ButtonsFont = font
end

-- Button
function ng.constructors.Button(addon, name, parent, theme)
 local f = CreateFrame("Button", name, parent)
 f:SetSize(75, 25)
 
 f.highlight = f:CreateTexture()
 f.highlight:SetAllPoints()
 f.highlight:SetBlendMode("ADD")
 f.highlight:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
 ng:AnimateHighlight(f)

 --f:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
 f:SetNormalFontObject(ng:GetFont(addon, theme, "button"))
 f.backdrop_type = "l3"

 return f
end

function ng.set_theme.Button(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l3_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l3_border"]))
 self.highlight:SetVertexColor(ng.hex2rgba(th["highlight"]))
 self.highlight:SetAlpha(0)
 --self.highlight:SetTexture(ng.hex2rgba(th["highlight"]))
 --self:GetHighlightTexture():SetVertexColor(ng.hex2rgba(th["highlight"]))
end

-- ColorButton
local cb_backdrop = { bgFile   = "Interface\\Buttons\\GreyscaleRamp64",
                      edgeFile = "Interface\\Buttons\\WHITE8X8",
			          edgeSize = 1 }


local function colorButton_update(self, ...)
 self:SetBackdropColor(...)
end

function ng.constructors.Colorbutton(addon, name, parent, theme)
 local f = CreateFrame("Frame", name, parent)
 f:SetSize(18, 18)
 f:SetBackdrop(cb_backdrop)
 f:SetBackdropColor(0, 0, 0, 1)
 f:SetBackdropBorderColor(1, 1, 1, 1)
 f.text = ng.constructors.Label(addon, nil, parent, theme)
 f.text:SetPoint("LEFT", f, "RIGHT", 5, 0)
 f.SetText = ng.set_text_function
 f.update = colorButton_update
 return f
end

function ng.scripts.Colorbutton.OnMouseUp(self, button)

 if not self.tag then return end

 local e = self.tag
 local func
 local Or, Og, Ob, Oa
 
 if self.mode == "backdrop" then
  func = e.SetBackdropColor
  Or, Og, Ob, Oa = e:GetBackdropColor()
 elseif self.mode == "backdrop_border" then
  func = e.SetBackdropBorderColor
  Or, Og, Ob, Oa = e:GetBackdropBorderColor()
 elseif self.mode == "fontstring" then
  func = e.SetTextColor
  Or, Og, Ob, Oa = e:GetTextColor()
 end

 ColorPickerFrame.func = function()
  local r, g, b = ColorPickerFrame:GetColorRGB()
  local a = 1 - OpacitySliderFrame:GetValue()
  self:SetBackdropColor(r, g, b, a)
  func(e, r, g, b, a)
  if self.func then
   self:func(e, r, g, b, a)
  end
 end

 ColorPickerFrame.opacityFunc = ColorPickerFrame.func
 ColorPickerFrame.cancelFunc = function() 
  self:SetBackdropColor(Or, Og, Ob, Oa)
  func(e, Or, Og, Ob, Oa)
  if self.func_cancel then
   self:func_cancel(e, Or, Og, Ob, Oa)
  end
 end

 ColorPickerFrame:SetColorRGB(Or, Og, Ob)
 ColorPickerFrame.hasOpacity = true
 ColorPickerFrame.opacity = 1 - Oa
 
 ColorPickerFrame:Hide()
 ColorPickerFrame:Show()
end

-- Tabbutton
function ng.constructors.Tabbutton(addon, name, parent, theme, fixedIndex)
 local f = ng.constructors.Button(addon, name, parent, theme)

 if not parent.tabbuttons then parent.tabbuttons = {} end
 tinsert(parent.tabbuttons, f)

 if not parent.tabs then parent.tabs = {} end
 
 local tab
 if fixedIndex and parent.tabs[fixedIndex] then
  tab = parent.tabs[fixedIndex]
 else
  tab = CreateFrame("Frame", nil, parent)
  tab:SetAllPoints()
  tinsert(parent.tabs, tab)
 end

 f.tab = tab
 local lastButton = #(parent.tabbuttons)
 if lastButton == 1 then
  f:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 25)
 else
  f:SetPoint("TOPLEFT", parent.tabbuttons[lastButton - 1], "TOPRIGHT", 0, 0)
 end
 
 f.index = fixedIndex or lastButton
 return f
end

ng.set_theme.Tabbutton = ng.set_theme.Button

function ng.scripts.Tabbutton.OnClick(self)
 local p = self:GetParent()

 for _,v in pairs(p.tabbuttons) do
  if v.index == self.index then
   v.selected = true
   v:setHighlightAlpha(0.5)
   v.lockedhighlight = true
  else
   v.selected = false
   v:setHighlightAlpha(0)
   v.lockedhighlight = false
  end
 end
 
 for _,v in pairs(p.tabs) do
  v:Hide()
 end

 --self:LockHighlight()
 self.selected = true
 p.index = self.index
 self.tab:Show()
end

-- Checkbutton
local function checkbutton_setcolor(self)
 local old_alpha = self.highlight:GetAlpha()
 if self.checked then
  self:SetBackdropColor(ng.hex2rgba(self.checked_color))
  self:SetBackdropBorderColor(ng.hex2rgba(self.checked_border))
  self.highlight:SetVertexColor(ng.hex2rgba(self.checked_highlight))
 else
  self:SetBackdropColor(ng.hex2rgba(self.unchecked_color))
  self:SetBackdropBorderColor(ng.hex2rgba(self.unchecked_border))
  self.highlight:SetVertexColor(ng.hex2rgba(self.unchecked_highlight))
 end
 self.highlight:SetAlpha(old_alpha)
end

function ng.constructors.Checkbutton(addon, name, parent, theme, checked_color, unchecked_color)
 local f = ng.constructors.Button(addon, name, parent, theme)

 f.checked_color    = checked_color or "05770D26" 
 f.checked_border   = checked_color or "00240033" 
 f.unchecked_color  = unchecked_color or "77050D26" 
 f.unchecked_border = unchecked_color or "24000033"
 local r, g, b, a = ng.hex2rgba(f.checked_color)
 f.checked_highlight = ng.rgba2hex(r + 0.3, g + 0.3, b + 0.3, a + 0.3)
 r, g, b, a = ng.hex2rgba(f.unchecked_color)
 f.unchecked_highlight = ng.rgba2hex(r + 0.3, g + 0.3, b + 0.3, a + 0.3)

 f.SetChecked = function(self, value)
                 f.checked = value
                 checkbutton_setcolor(self)
                end
 return f
end

function ng.set_theme.Checkbutton(self, th)
 checkbutton_setcolor(self)
 self.highlight:SetAlpha(0)
end

function ng.scripts.Checkbutton.OnClick(self)
 self.checked = not self.checked

 checkbutton_setcolor(self)
 
 if self.func then self.func(self) end
end

-- Checkbox
function ng.constructors.Checkbox(addon, name, parent, theme)
 local f = CreateFrame("Checkbutton", name, parent, "OptionsCheckButtonTemplate")

 tex = f:GetCheckedTexture()
 tex:ClearAllPoints()
 tex:SetPoint("CENTER")
 tex:SetSize(10, 10)
 tex:SetColorTexture(0.4, 0.4, 0.4, 0.8)
 
 if name then
  f.text = _G[name.."Text"]
  f.text:SetFontObject(ng:GetFont(addon, theme, "button"))
 else
  f.text = ng.constructors.Label(addon, nil, parent, theme)
  f.text:SetFontObject(ng:GetFont(addon, theme, "button"))
  f.text:SetPoint("LEFT", f, "RIGHT", 5, 0)
 end

 f.SetText = ng.set_text_function

 return f
end

function ng.set_theme.Checkbox(self, th)
 self:GetCheckedTexture():SetColorTexture(ng.hex2rgba(th["thumb"]))
end

local function radiobutton_click(f)
 local p = f:GetParent()
 
 for k in pairs(p.radiobuttons) do
  if k ~= f then
   k:SetChecked(false)
  end
 end
 
 f:SetChecked(true)
 
 if f.func then f:func(f) end
end

-- Radiobutton
function ng.constructors.Radiobutton(addon, name, parent, theme)
 local f = ng.constructors.Checkbox(addon, name, parent, theme)
 
 if not parent.radiobuttons then
  parent.radiobuttons = {}
 end

 parent.radiobuttons[f] = true
 
 --local tex = f:GetCheckedTexture()
 --tex:SetTexture("Interface\\COMMON\\Indicator-Gray")
 --tex:SetSize(18, 18)

 f:SetScript("OnClick", radiobutton_click)
 
 return f
end

function ng.set_theme.Radiobutton(self, th)
 --self:GetCheckedTexture():SetVertexColor(ng.hex2rgba(th["thumb"]))
 self:GetCheckedTexture():SetColorTexture(ng.hex2rgba(th["thumb"]))
end
