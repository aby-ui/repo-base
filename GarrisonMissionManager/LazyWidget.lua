local addon_name, addon_env = ...

-- [AUTOLOCAL START]
local CreateFrame = CreateFrame
local GetItemInfoInstant = GetItemInfoInstant
local type = type
-- [AUTOLOCAL END]

local function SetTextureOrItem(widget, method, texture, item_id)
   if texture then
      widget[method](widget, texture)
      return
   end
   if item_id then
      local itemID, itemType, itemSubType, itemEquipLoc, itemTexture = GetItemInfoInstant(item_id)
      if itemTexture then
         widget[method](widget, itemTexture)
      else
         assert(nil, "SHOULD NEVER HAPPEN")
      end
      return
   end
end

local points = { "BOTTOMRIGHT", "BOTTOMLEFT", "TOPLEFT", "TOP" }

local function Widget(a)
   local type = a.type or a[1]
   local parent = a.parent or a[2]
   local template = a.template or a[3]

   local widget
   if type == "Texture" then
      widget = parent:CreateTexture(nil, a.Layer, template, a.SubLayer)
   elseif type == "FontString" then
      widget = parent:CreateFontString(nil, a.Layer, template)
   else
      widget = CreateFrame(type, nil, parent, template)
   end
   if a.Hide then widget:Hide() end
   local prop = a.Atlas if prop then widget:SetAtlas(prop, a.AtlasSize) end
   local prop = a.Width if prop then widget:SetWidth(prop) end
   local prop = a.Height if prop then widget:SetHeight(prop) end
   local prop = a.EnableMouse if prop ~= nil then widget:EnableMouse(prop) end

   for idx = 1, #points do
      local point_name = points[idx]
      local prop = a[point_name] if prop then
         if prop == true then widget:SetPoint(point_name, parent, point_name, 0, 0)                 -- TOP = true,                         -- attach TOP to parrent's TOP
         elseif #prop == 2 then widget:SetPoint(point_name, parent, point_name, prop[1], prop[2])   -- TOP = { 0, 20 }                     -- attach TOP to parrent's TOP +0,20
         elseif #prop == 3 then widget:SetPoint(point_name, parent, prop[1], prop[2], prop[3])      -- TOP = { "BOTTOM", 0, 20 }           -- attach TOP to parrent's BOTTOM +0,20
         elseif #prop == 4 then widget:SetPoint(point_name, prop[1], prop[2], prop[3], prop[4]) end -- TOP = { UIParent, "BOTTOM", 0, 20 } -- attach TOP to another frame's BOTTOM +0,20
      end
   end

   local texture, item_id
   local prop = a.TextureToItem if prop then
      item_id = prop
   end
   if type == "Button" then
      local prop = a.NormalTexture if prop then texture = prop end
      SetTextureOrItem(widget, 'SetNormalTexture', texture, item_id)
      local prop = a.HighlightTexture if prop then
         -- if type(prop)
      end
   else
      SetTextureOrItem(widget, 'SetTexture', texture, item_id)
   end

   local prop = a.Color if prop then widget:SetTexture(prop[1], prop[2], prop[3], prop[4]) end

   local prop = a.Text if prop then widget:SetText(prop) end

   local prop = a.FrameLevelOffset if prop then widget:SetFrameLevel(widget:GetFrameLevel() + prop) end

   local prop = a.OnClick if prop then widget:SetScript("OnClick", prop) end
   local prop = a.OnEnter if prop then widget:SetScript("OnEnter", prop) end
   local prop = a.OnLeave if prop then widget:SetScript("OnLeave", prop) end
   local prop = a.OnEvent if prop then widget:SetScript("OnEvent", prop) end

   local prop = a.Scale   if prop then widget:SetScale(prop) end

   return widget
end
addon_env.Widget = Widget
