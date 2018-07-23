-- NyxGUI Library
-- by Jadya EU - Well of Eternity

-- Theme info:
 -- Frame
  -- l0_texture			backdrop texture
  -- l0_color           backdrop color
  -- l0_border			backdrop border

 -- Groupbox
  -- l1_texture			backdrop texture
  -- l1_color           backdrop color
  -- l1_border			backdrop border
--

if NyxGUIPass then return end

local ng = NyxGUI(NyxGUImajor)

ng:RegisterType("Frame")
ng:RegisterType("Groupbox")
ng:RegisterType("Label")

-- Frame
function ng.constructors.Frame(addon, name, parent, theme)
 local f = CreateFrame("Frame", name, parent)
 f.backdrop_type = "l0"
 return f
end

function ng.set_theme.Frame(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l0_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l0_border"]))
end

-- Groupbox
function ng.constructors.Groupbox(addon, name, parent, theme)
 local f = CreateFrame("Frame", name, parent)
 f.backdrop_type = "l1"
 f.text = ng.constructors.Label(addon, nil, f, theme)
 f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 2, 12)
 f.SetText = ng.set_text_function
 return f
end

function ng.set_theme.Groupbox(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l1_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l1_border"]))
end

function ng.constructors.Label(addon, name, parent, theme)
 local f = parent:CreateFontString()
 f:SetFontObject(ng:GetFont(addon, theme, "label"))
 return f
end
