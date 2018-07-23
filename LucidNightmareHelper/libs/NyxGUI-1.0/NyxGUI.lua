-- NyxGUI Library
-- by Vildiesel EU - Well of Eternity

-- How to embed:
-- NyxGUI("1.0")  returns the library table for the specified major version (recommended)
-- NyxGUI()       returns the library table for the latest major version available

local ceil, tremove, Clamp, Saturate = math.ceil, table.remove, Clamp, Saturate

if NyxGUI and NyxGUI.v[NyxGUImajor] and NyxGUI.v[NyxGUImajor].minor >= NyxGUIminor then
 NyxGUIPass = true -- let the other scripts know that we don't need them
 return
elseif NyxGUI then
 NyxGUI.v[NyxGUImajor] = { minor = NyxGUIminor }
else
 NyxGUI = { v = { [NyxGUImajor] = { minor = NyxGUIminor } } }

 setmetatable(NyxGUI, { 
                        __tostring = function(self)
                                      local s = "|cff00FF00"
                                      for k in pairs(self.v) do
									   s = s..k.." "
									  end
									  return s:sub(1, #s - 1).."|r"
                                     end,

                        __call     = function(self, s)
						              if s == nil then
									   local latest = ""
									   local result
									   for k,v in pairs(self.v) do
									    if k > latest then 
										 latest = k
										 result = v 
										end
									   end
									   return result
									  end

                                      assert(self.v[s], "NyxGUI Version '"..s.."' does not exist (available versions: "..tostring(self)..")")
                                      return self.v[s]
                                 	 end })
end

local ng = NyxGUI(NyxGUImajor)

local themes = {}
local data   = {}

local default_theme = {
                      -- textures and colors
				       l0_texture     = "Interface\\Buttons\\GreyscaleRamp64",
				       --l0_edge        = "",
                       l0_color       = "121212e6",
				       l0_border      = "1A1A1Ae6",
					   l1_texture     = "Interface\\Buttons\\WHITE8X8",
					   l1_color       = "000000FF",
					   l1_border      = "1A1A1AFF",
					   l2_texture     = "Interface\\Buttons\\WHITE8X8",
					   l2_color       = "1A1A1AFF",
					   l2_border      = "1A1A1AFF",
					   l3_texture     = "Interface\\Buttons\\WHITE8X8",
					   l3_color       = "1A1A1AFF",
					   l3_border      = "1A1A1AFF",
					   thumb          = "666666CC",
					   highlight      = "FFFFFF33",
					  -- fonts
					   f_label_name   = "Fonts\\FRIZQT__.ttf",
					   f_label_h      = 10,
					   f_label_flags  = "",
					   f_label_color  = "FFFFFFFF",
					   f_button_name  = "Fonts\\FRIZQT__.ttf",
					   f_button_h     = 12,
					   f_button_flags = "",
					   f_button_color = "FFFFFFFF",
					  }

local theme_meta    = { __index = default_theme }

function ng:SetDefaultTheme(addon, theme)
 themes[addon].default_theme = theme
end

function ng:GetDefaultTheme(addon)
 if not themes[addon] then
  return "default" 
 else
  return themes[addon].default_theme or "default"
 end
end

function ng:Initialize(addon, savedVariable, theme_default_name, theme_default_data)
 data[addon] = {}

 data[addon]["backdrops"] = {
                             l0 = { 
                                   bgFile = "Interface\\Buttons\\WHITE8X8", 
                                   edgeFile = "Interface\\Buttons\\WHITE8X8", 
		     	                   edgeSize = 1
			   	                  },
                             l1 = { 
                                   bgFile = "Interface\\Buttons\\WHITE8X8", 
                                   edgeFile = "Interface\\Buttons\\WHITE8X8", 
		     	                   edgeSize = 1
			   	                  },
							 l2 = { 
                                   bgFile = "Interface\\Buttons\\GreyscaleRamp64", 
                                   edgeFile = "Interface\\Buttons\\WHITE8X8", 
		     	                   edgeSize = 1
			   	                  },
                             l3 = {
                                   bgFile = "Interface\\Buttons\\GreyscaleRamp64", 
                                   edgeFile = "Interface\\Buttons\\WHITE8X8", 
		     	                   edgeSize = 1
			   	                  }
                            }

 if savedVariable and savedVariable["NyxGUI_Data"] then
  themes[addon] = savedVariable["NyxGUI_Data"]

  for _,v in pairs(themes[addon]) do
   if type(v) == "table" then
    setmetatable(v, theme_meta)
   end
  end

  local theme = theme_default_name or "default"
  ng:SetDefaultTheme(addon, theme)
  ng:LoadTheme(addon, theme, theme_default_data)
  return
 end

 themes[addon] = {}

 if savedVariable then
  savedVariable["NyxGUI_Data"] = themes[addon]
 end

 local theme = theme_default_name or "default"
 ng:SetDefaultTheme(addon, theme)
 ng:LoadTheme(addon, theme, theme_default_data)
end

----------------------------------
function ng:RegisterType(t)
 if not ng.scripts      then ng.scripts      = {} end
 if not ng.constructors then ng.constructors = {} end
 if not ng.set_theme    then ng.set_theme    = {} end
 if not ng.set_backdrop then ng.set_backdrop = {} end

 assert(not ng.constructors[t], "NyxGUI: ng:RegisterType() - Type |cff00FF00"..t.."|r already exists")
 
 ng.scripts[t]      = {}
 ng.constructors[t] = {}
end
----------------------------------

local function getVar(addon, theme, t)
 if not addon then addon = "no_addon" end

 theme = theme or ng:GetDefaultTheme(addon)
 
 if not data[addon] then
  data[addon] = {}
 end
 
 if not data[addon][theme] then
  data[addon][theme] = {}
 end

 if not t then return data[addon][theme] end
 
 if not data[addon][theme][t] then
  data[addon][theme][t] = {}
 end
 
 return data[addon][theme][t]
end

-- @theme	theme identifier (nil == "default", false == widget not themed)
function ng:New(addon, t, name, parent, theme, ...)

 assert(ng.constructors[t], "NyxGUI: ng:New() - Widget type '"..t.."' does not exist.")
 
 theme = theme ~= false and (theme or ng:GetDefaultTheme(addon)) or false
 local f = ng.constructors[t](addon, name, parent, theme, ...)
 
 for k,v in pairs(ng.scripts[t]) do
  f:SetScript(k, v)
 end
 
 if theme ~= false then
  ng:AddToTheme(addon, theme, t, f)
 end

 return f
end

local function set_backdrop(addon, w)
 local bd = w:GetBackdrop()

 if bd and bd.bgFile == data[addon].backdrops[w.backdrop_type].bgFile then return end
 
 w:SetBackdrop(data[addon].backdrops[w.backdrop_type])
end

function ng:UpdateWidgetTheme(addon, theme, t, w)
 if w.backdrop_type then
  set_backdrop(addon, w)
 end
 
 if ng.set_theme[t] and themes[addon][theme] then
  ng.set_theme[t](w, themes[addon][theme])
 end
end

function ng:GetFont(addon, theme, t)
 theme = theme or ng:GetDefaultTheme(addon)

 local fontname = addon..theme.."Font"..t
 
 local font = _G[fontname]

 if not font then
  font = CreateFont(fontname)
  font:SetFontObject("Tooltip_Med")
 end

 return font
end

local function checkFont(addon, theme, t)
 local font = ng:GetFont(addon, theme, t)
 local name, height = font:GetFont()
 local r, g, b, a = font:GetTextColor()
 local th = themes[addon][theme]

 if name ~= th["f_"..t.."_name"] or height ~= th["f_"..t.."_h"] then
  font:SetFont(th["f_"..t.."_name"], th["f_"..t.."_h"], th["f"..t.."_flags"])
 end

 font:SetTextColor(ng.hex2rgba(th["f_"..t.."_color"]))
end

function ng:UpdateTheme(addon, theme, t)
 theme = theme or ng:GetDefaultTheme(addon)
 
 -- no widgets in this theme set
 if not data[addon] or not data[addon][theme] then return end

 data[addon].backdrops.l0.bgFile = themes[addon][theme]["l0_texture"]
 data[addon].backdrops.l1.bgFile = themes[addon][theme]["l1_texture"]
 data[addon].backdrops.l2.bgFile = themes[addon][theme]["l2_texture"]
 data[addon].backdrops.l3.bgFile = themes[addon][theme]["l3_texture"]

 checkFont(addon, theme, "label")
 checkFont(addon, theme, "button")
 
 local var = data[addon][theme]
 -- set theme for a specified t..
 if t then
  for _,w in pairs(var[t]) do
   ng:UpdateWidgetTheme(addon, theme, t, w)
  end
  return
 end

 -- .. or for every registered widget
 for k,v in pairs(var) do
  for _,w in pairs(v) do
   ng:UpdateWidgetTheme(addon, theme, t, w)
  end
 end
end

function ng:SetThemeData(addon, theme, contents)
 local result = themes[addon][theme]

 if not result then return end
 
 if contents then
  for k,v in pairs(contents) do
   result[k] = v
  end
 end
 
 ng:UpdateTheme(addon, theme)
end

function ng:LoadTheme(addon, theme, defaults)
 local result = themes[addon][theme]
 getVar(addon, theme) -- automatically creates the data variable

 if not result then
  result = {}
  setmetatable(result, theme_meta)
  themes[addon][theme] = result
  ng:SetThemeData(addon, theme, defaults)  
  return
 end
 
 setmetatable(result, theme_meta)
 ng:UpdateTheme(addon, theme)
end

-- throws a widget into the theme set with the appropriate t
-- mainly for xml inherited NyxGUI Listbuttons which bypass the NyxGUI:New() constructor
function ng:AddToTheme(addon, theme, t, widget)
 theme = theme or ng:GetDefaultTheme(addon)
 
 local var = getVar(addon, theme, t)
 var[#var + 1] = widget
 ng:UpdateWidgetTheme(addon, theme, t, widget)
end

function ng:RemoveFromTheme(addon, theme, t, widget)
 theme = theme or ng:GetDefaultTheme(addon)
 
 local found
 local var = getVar(addon, theme, t)

 for i = 1, #var do
  if var[i] == parent then
   found = true
   break
  end
 end
 
 if found then
  tremove(var, i)
 end
end
--

-- utils
function ng:SetFrameMovable(f, flag)
 if flag then
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
 else
  f:EnableMouse(false)
  f:SetMovable(false)
  f:RegisterForDrag()
  f:SetScript("OnDragStart", nil)
  f:SetScript("OnDragStop", nil)
 end
end

-- internals
function ng.set_text_function(self, s)
 self.text:SetText(s)
end

function ng.rgba2hex(r, g, b, a)
  r = Saturate(r) * 255
  g = Saturate(g) * 255
  b = Saturate(b) * 255
  a = Saturate(a) * 255
 return ("%.2x%.2x%.2x%.2x"):format(r, g, b, a)
end

local function hex2color(s)
 local result = tonumber(s, 16)
 return result and (result / 255) or 0
end

function ng.hex2rgba(s)
 local l = #s
 if l ~= 6 and l ~= 8 then
  return 0, 0, 0, 0
 else
  local r = hex2color(s:sub(1, 2))
  local g = hex2color(s:sub(3, 4))
  local b = hex2color(s:sub(5, 6))

  local a
  if l == 8 then
   a = hex2color(s:sub(7, 8))
  end
  return r, g, b, a
 end
end

-- NyxGUI internal components
ng:Initialize("NyxGUI")
