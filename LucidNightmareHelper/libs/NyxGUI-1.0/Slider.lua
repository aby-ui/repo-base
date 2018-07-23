-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Slider
  -- l2_texture			backdrop texture
  -- l2_color           backdrop color
  -- l2_border			backdrop border
  -- thumb				slider thumb color
--

if NyxGUIPass then return end

local floor = math.floor

local ng = NyxGUI(NyxGUImajor)
ng:RegisterType("Slider")
ng:RegisterType("SliderH")
ng:RegisterType("SliderV")

function ng.constructors.Slider(addon, name, parent, theme)
 local f = CreateFrame("Slider", name, parent)
 f:SetValueStep(1)
 f.SetText = ng.set_text_function
 f.backdrop_type = "l2"

 return f
end

function ng.constructors.SliderH(addon, name, parent, theme)
 local f = ng.constructors.Slider(addon, name, parent, theme)
 f:SetOrientation("HORIZONTAL")
 f:SetSize(150, 15)
 f:SetHitRectInsets(0, 0, -10, -10)
 
 f:SetThumbTexture(0.4, 0.4, 0.4, 0.8)
 local tex = f:GetThumbTexture()
 tex:SetTexture()
 tex:SetSize(20, 11)
 f.thumbTexture = tex

 local txt = ng.constructors.Label(addon, name and (name.."Text") or nil, f)
 txt:SetPoint("TOPLEFT", f, "TOPLEFT", -5, 10)
 txt:SetFontObject(ng:GetFont(addon, theme, "label"))
 f.text = txt
 
 txt = ng.constructors.Label(addon, name and (name.."Value") or nil, f)
 txt:SetPoint("TOP", f, "BOTTOM")
 txt:SetFontObject(ng:GetFont(addon, theme, "label"))
 f.text_value = txt
 
 return f
end

function ng.set_theme.SliderH(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l2_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l2_border"]))
 self.thumbTexture:SetColorTexture(ng.hex2rgba(th["thumb"]))
end

function ng.constructors.SliderV(addon, name, parent, theme)
 local f = ng.constructors.Slider(addon, name, parent, theme)
 f:SetOrientation("VERTICAL")
 f:SetSize(15, 150)
 f:SetHitRectInsets(-10, -10, 0, 0)
 
 f:SetThumbTexture(0.4, 0.4, 0.4, 0.8)
 local tex = f:GetThumbTexture()
 tex:SetSize(11, 20)
 f.thumbTexture = tex

 local txt = ng.constructors.Label(addon, name and (name.."Text") or nil, f)
 txt:SetPoint("TOPLEFT", f, "TOPLEFT", -5, 10)
 txt:SetFontObject(ng:GetFont(addon, theme, "label"))
 f.text = txt
 
 txt = ng.constructors.Label(addon, name and (name.."Value") or nil, f)
 txt:SetPoint("LEFT", f, "RIGHT")
 txt:SetFontObject(ng:GetFont(addon, theme, "label"))
 f.text_value = txt
 
 return f
end

ng.set_theme.SliderV = ng.set_theme.SliderH
