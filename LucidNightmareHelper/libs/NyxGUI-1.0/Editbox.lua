-- NyxGUI Library
-- by Jadya EU - Well of Eternity


-- Theme info:
 -- Editbox
  -- l2_texture			backdrop texture
  -- l2_color           backdrop color
  -- l2_border			backdrop border

--

if NyxGUIPass then return end

local ng = NyxGUI(NyxGUImajor)

ng:RegisterType("Editbox", "Editbox")

function ng.constructors.Editbox(addon, name, parent, theme)
 local f = CreateFrame("Editbox", name, parent)
 f:SetSize(150, 15)
 f:SetTextInsets(5, 0, 0, 0)
 f:SetAutoFocus(false)
 f:SetFontObject(ng:GetFont(addon, theme, "button"))
 f.backdrop_type = "l2"
 f.text = ng.constructors.Label(addon, nil, f, theme)
 f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 2, 12)
 f.SetTitle = ng.set_text_function
 return f
end

function ng.set_theme.Editbox(self, th)
 self:SetBackdropColor(ng.hex2rgba(th["l2_color"]))
 self:SetBackdropBorderColor(ng.hex2rgba(th["l2_border"]))
end

function ng.scripts.Editbox.OnEnterPressed(self)
 self:ClearFocus()
 if self.func then
  self:func()
 end
end

function ng.scripts.Editbox.OnEscapePressed(self)
 self:ClearFocus()
 if self.cancelfunc then
  self:cancelfunc()
 end
end
