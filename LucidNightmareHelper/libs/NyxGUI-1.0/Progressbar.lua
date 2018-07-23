-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Progressbar
  -- l2_texture			backdrop texture
  -- l2_color           backdrop color
  -- l2_border			backdrop border
  -- l3_texture         foreground texture

if NyxGUIPass then return end

local floor = math.floor

local ng = NyxGUI(NyxGUImajor)

ng:RegisterType("Progressbar")

-- Progressbar
local function setColors(f, r1, g1, b1, r2, g2, b2)
 f.r1 = r1
 f.g1 = g1
 f.b1 = b1
 f.r2 = r2
 f.g2 = g2
 f.b2 = b2
end

local function lerp(i, k, p)
 return (1 - p) * i + p * k
end


local function setValue(f, p)
 local t = p / 100
 local r = lerp(f.r1, f.r2, t)
 local g = lerp(f.g1, f.g2, t)
 local b = lerp(f.b1, f.b2, t)
 f.foreground:SetColorTexture(r, g, b, 1)
 f.foreground:SetWidth(f:GetWidth() * t - 2)
 f.valuetext:SetText(floor(p).." %")
end

function ng.constructors.Progressbar(addon, name, parent, theme)
 local f = CreateFrame("Frame", name, parent)
 f:SetSize(100, 20)
 
 f.text = ng.constructors.Label(addon, nil, f, theme)
 f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 12)
 
 f.valuetext = ng.constructors.Label(addon, nil, f, theme)
 f.valuetext:SetPoint("CENTER", f, "CENTER")

 f.backdrop_type = "l2"
 
 f.foreground = f:CreateTexture()
 f.foreground:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
 f.foreground:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)

 f.SetColors = setColors
 f:SetColors(0.3, 0, 0, 0, 0.3, 0)

 f.SetText = ng.set_text_function
 f.SetValue = setValue
 return f
end

function ng.set_theme.Progressbar(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l2_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l2_border"]))
end
