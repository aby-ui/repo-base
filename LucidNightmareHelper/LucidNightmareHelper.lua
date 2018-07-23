-- Lucid Nightmare Helper
-- by Vildiesel EU - Well of Eternity

local format = string.format

local addonName, addonTable = ...
local ng
local L = addonTable.L

local player_icon = "interface\\worldmap\\WorldMapArrow"

local containerW, containerH = 25000, 25000
local buttonW, buttonH = 20, 20

local north = 1
local east = 2
local south = 3
local west = 4
local oppositeDir = {3, 4, 1, 2}
local playerRotation = {0, 270, 180, 90}
local coord_offset = {{0, -1},{1, 0},{0, 1},{-1, 0}}

local dir_to_region = {"TOP", "RIGHT", "BOTTOM", "LEFT"}
local dir_to_region_opposite = {"BOTTOM", "LEFT", "TOP", "RIGHT"}

local color_strings = {"Yellow","Blue","Red","Green","Purple"}
local colors = {{1, 1, 0},{0, 0.6, 1},{1, 0, 0},{0, 1, 0},{1, 0, 1}}

local buttonsPool = {}
local linksPool = {}
local rooms = {}
local links = {}
local current_room, last_room, last_dir, mf, scrollframe, container, playerframe, max_room_number, tracking_disabled, mouse_interaction_active

------------------------------------------------------------
-- UNIT_SPELLCAST_SUCCEEDED doesn't fire anymore as of 7.3.5
local function detectDir(x, y)
 if y > -1410 then
  return north
 elseif y < -1440 then
  return south
 elseif x < 660 then
  return east
 elseif x > 720 then
  return west
 end
end
------------------------------------------------------------

local function getMapPosition(cx, cy)
 return (containerW / 2) + (buttonW + 6) * cx, (containerH / 2) + (buttonH + 6) * cy
end

local function centerCam(cx, cy)
 local x, y = getMapPosition(cx, cy)
 scrollframe:SetHorizontalScroll(x - 200 + buttonW / 2)
 scrollframe:SetVerticalScroll(y - 200 + buttonH / 2)
end

local function roomMouseDown(self)
 local r
 for _,v in pairs(rooms) do
  if self == v.button then
   r = v
   break
  end
 end

 mf.roomInteractionDialog.selected_room = r
 mf.roomInteractionDialog.lbl_selected:SetText(format(L["Selected Room: %s"], "|cff00ff00"..r.number.."|r"))
 mf.roomInteractionDialog.sel_room_marker:SetPoint("CENTER", r.button, "CENTER")
 mf.roomInteractionDialog.sel_room_marker:Show()
 mf.roomInteractionDialog.btn_goto.step = 0
 mf.roomInteractionDialog.btn_goto:SetText(L["Set Player location"])
end

local function getUnused(t)
 local pool = t == "link" and linksPool or buttonsPool
 if #pool > 0 then
  return tremove(pool, 1)
 elseif t == "link" then
  local link = container:CreateTexture()
  link:SetSize(3, 3)
  return link
 else
  local btn = ng:New(addonName, "Frame", nil, container)
  btn:SetScript("OnMouseDown", roomMouseDown)
  btn:SetSize(buttonW, buttonH)
  btn.text = btn:CreateFontString()
  btn.text:SetFont("Fonts\\FRIZQT__.TTF", 12, "MONOCHROME")
  btn.text:SetAllPoints()
  btn.text:SetText("")
  btn.blockades = {}
  for i = 1,4 do
   btn.blockades[i] = btn:CreateTexture()
   btn.blockades[i]:SetTexture("interface\\common\\voicechat-muted")
   btn.blockades[i]:SetSize(buttonW / 2, buttonW / 2)
   --btn.blockades[i]:Hide()
  end
  btn.blockades[north]:SetPoint("CENTER", btn, "TOP")
  btn.blockades[east]:SetPoint("CENTER", btn, "RIGHT")
  btn.blockades[west]:SetPoint("CENTER", btn, "LEFT")
  btn.blockades[south]:SetPoint("CENTER", btn, "BOTTOM")
  return btn
 end
end

local function createElement(t, r, ...)
 local f = getUnused(t)
 if t == "button" then
  local x, y = getMapPosition(r.cx, r.cy)
  f:SetPoint("TOPLEFT", container, "TOPLEFT", x, -y)
  f:SetBackdropColor(1, 1, 1, 1)
  f:SetBackdropBorderColor(0, 0, 0, 0) 
  f:EnableMouse(mouse_interaction_active)
  for i = 1,4 do
   f.blockades[i].active = false
   f.blockades[i]:Hide()
  end
  r.button = f
 else -- link
  local r2, dir = ...
  f:ClearAllPoints()
  f:SetPoint(dir_to_region_opposite[dir], r.button, dir_to_region[dir])
  f:SetPoint(dir_to_region[dir], r2.button, dir_to_region_opposite[dir])
  local count = #links
  --if count > 0 then
  -- links[count]:SetColorTexture(1, 1, 1, 1)
  --end
  links[count + 1] = f
  links[count + 1]:SetColorTexture(1, 1, 1, 1)
  --f:SetColorTexture(0, 1, 1, 1)
 end
 f:Show()
end

local function resetColor(r, c, t)
 for k,v in pairs(rooms) do
  if v ~= r and v.POI_c == c and v.POI_t == t then
   if t == "rune" then
    v.button:SetBackdropColor(1, 1, 1, 1)
   else
    v.button:SetBackdropBorderColor(0, 0, 0, 0)
   end
   v.POI_c = nil
  end
 end
end

local function setRoomNumber(r)
 max_room_number = max_room_number + 1
 if max_room_number < 100 then
  r.button.text:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
  --r.button.text:SetTextHeight(12)
 else
  r.button.text:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
  --r.button.text:SetTextHeight(9)
 end
 r.button.text:SetText("|cff000000"..max_room_number.."|r")
 r.number = max_room_number
end

local function recolorRoom(r)
 local func = r.POI_t == "rune" and r.button.SetBackdropColor or r.button.SetBackdropBorderColor
 
 if r.POI_c == 6 then
  r.button:SetBackdropColor(1, 1, 1, 1) 
  r.button:SetBackdropBorderColor(0, 0, 0, 0)
 else
  func(r.button, unpack(colors[r.POI_c]))
 end
end

local function newRoom(cx, cy)
 local r = {}
 r.neighbors = {}
 rooms[#rooms + 1] = r
 r.cx = cx
 r.cy = cy
 return r
end

local function setCurrentRoom(r)
 last_room = current_room
 current_room = r
 centerCam(r.cx, r.cy)
 playerframe:SetParent(r.button)
 playerframe:SetAllPoints()
 playerframe.tex:SetRotation(math.rad(playerRotation[last_dir or north]))
 
 for _,v in pairs(rooms) do
  v.button:SetAlpha(0.65)
 end

 for _,v in pairs(r.neighbors) do
  v.button:SetAlpha(1)  
 end 
 r.button:SetAlpha(1)  
 
 mf.current_room_label:SetText(format(L["Current Room: %s"], "|cff00ff00"..r.number.."|r"))
end

local function linkRooms(dir, r1, r2)
 r1.neighbors[dir] = r2
 r2.neighbors[oppositeDir[dir]] = r1
 createElement("link", r1, r2, dir)
end

local function getRoomJumpOffset(r, cx, cy)
  local offsetX, offsetY = cx, cy
 
 local function isFree()
  for _,v in pairs(rooms) do
   if v.cx == r.cx + offsetX and v.cy == r.cy + offsetY then
    return
   end
  end

  return true
 end
 
 local free = isFree()
 while not free do
  offsetX = offsetX + cx
  offsetY = offsetY + cy
  free = isFree()
 end

 return offsetX, offsetY
end

local function addRoom(dir, forceJump)
 local cx, cy = unpack(coord_offset[dir])
 local dx = cx * (buttonW + 6)
 local dy = cy * (buttonH + 6)

 if not forceJump then
  local found
  for k,v in pairs(rooms) do
   if v.cx == current_room.cx + cx and v.cy == current_room.cy + cy then
    found = v
    break
   end
  end
  
  if found then
   linkRooms(dir, current_room, found)
   mf.jumpDialog:Show()
   return found
  end
 end

 local r = newRoom(current_room.cx, current_room.cy)
 
 local offsetX, offsetY = getRoomJumpOffset(r, cx, cy)

 r.cx = r.cx + offsetX
 r.cy = r.cy + offsetY

 createElement("button", r)
 setRoomNumber(r)
 linkRooms(dir, current_room, r)
 return r
end

local function ResetMap()
 for _,v in pairs(rooms) do
  v.button:Hide()
  buttonsPool[#buttonsPool + 1] = v.button
 end

 for _,v in pairs(links) do
  v:Hide()
  linksPool[#linksPool + 1] = v
 end
 
 wipe(rooms)
 wipe(links)
 
 rooms[1] = newRoom(0, 0, containerW / 2, containerH / 2)
 
 max_room_number = -1
 createElement("button", rooms[1])
 setRoomNumber(rooms[1])

 setCurrentRoom(rooms[1])
end

local function toggleMouseInteraction(flag)
 for _,v in pairs(rooms) do
  v.button:EnableMouse(flag)
 end
 
 if flag then
  mf.roomInteractionDialog.selected_room = nil
  mf.roomInteractionDialog.lbl_selected:SetText(format(L["Selected Room: %s"], "|cff00ff00"..NONE.."|r"))
  mf.roomInteractionDialog.btn_goto.step = 0
  mf.roomInteractionDialog.sel_room_marker:Hide()
  mf.roomInteractionDialog.btn_goto:SetText(L["Set Player location"])
 end

 mf.roomInteractionDialog:SetShown(flag)
end

local function update()
 
 local y, x = UnitPosition("player")
 
 if math.abs(x - lx) > 70 or math.abs(y - ly) > 70 then
  local dir = detectDir(lx, ly)
  if dir then
   last_dir = dir
   setCurrentRoom(current_room.neighbors[dir] or addRoom(dir))
  end
 end
 
 lx = x
 ly = y
 
 if IsControlKeyDown() then
  if not mouse_interaction_active then
   mouse_interaction_active = true
   toggleMouseInteraction(true)
  end
 elseif mouse_interaction_active then
  mouse_interaction_active = false
  toggleMouseInteraction()
 end

 -- camera nav
 if scrollframe.dragging_camera then
  local cur_x, cur_y = GetCursorPosition()
  if cur_x ~= scrollframe.cursor_x then
   scrollframe:SetHorizontalScroll(scrollframe.last_horiz + scrollframe.cursor_x - cur_x)
  end
  if cur_y ~= scrollframe.cursor_y then
   scrollframe:SetVerticalScroll(scrollframe.last_vert + cur_y - scrollframe.cursor_y)
  end
 end
end

local default_theme = {
				   l0_color      = "191919ff",
				   l0_border     = "191919ff",
				   l0_texture    = "Interface\\Buttons\\GreyscaleRamp64",
				   --l0_texture    = "environments\\stars\\brokenshore_skybox_stormy_front03",
                   l2_color      = "444444cc",
				   l2_border     = "000000aa",
				   l1_texture    = "environments\\stars\\brokenshore_skybox_stormy_front03",
				   l3_color      = "555555ff",
				   l3_border     = "000000aa",
				   l3_texture    = "item\\objectcomponents\\weapon\\challengeknife_effect_smoke",
				   thumb         = "00aaffbb",
				   highlight     = "00aaff33",
	              -- fonts
				   f_label_name   = "Fonts\\FRIZQT__.ttf",
				   f_label_h      = 12,
				   f_label_flags  = "",
				   f_label_color  = "FFFFFFFF",
				   f_button_name  = "Fonts\\FRIZQT__.ttf",
				   f_button_h     = 11,
				   f_button_flags = "",
				   f_button_color = "FFFFFFFF",
				  }


local function setPOIClick(self)
 current_room.POI_t = self.t
 current_room.POI_c = self.c
 recolorRoom(current_room)
end

local function createJumpDialog()
 mf.jumpDialog = ng:New(addonName, "Frame", nil, mf)
 ng:SetFrameMovable(mf.jumpDialog, true)
 mf.jumpDialog:SetPoint("CENTER", UIParent, "CENTER")
 mf.jumpDialog:SetSize(300, 150)
 mf.jumpDialog:SetFrameStrata("DIALOG")
 
 -- top header
 local f = ng:New(addonName, "Groupbox", nil, mf.jumpDialog)
 f:SetHeight(20)
 f:SetPoint("TOPLEFT")
 f:SetPoint("TOPRIGHT", mf.jumpDialog, "TOPRIGHT")
 f.text:ClearAllPoints()
 f.text:SetPoint("CENTER") 
 f:SetText("Lucid Nightmare Helper")
 
 -- dialog text
 f = ng:New(addonName, "Label", nil, mf.jumpDialog)
 f:SetPoint("TOPLEFT", mf.jumpDialog, "TOPLEFT", 5, -25)
 f:SetPoint("BOTTOMRIGHT", mf.jumpDialog, "BOTTOMRIGHT", -5, 40)
 f:SetText(L["You have encountered an existing room on the map, do you recognize it as the room that you wanted to enter?"])
 
 -- keep linked button
 f = ng:New(addonName, "Button", nil, mf.jumpDialog)
 f:SetPoint("BOTTOMLEFT", mf.jumpDialog, "BOTTOMLEFT", 10, 10)
 f:SetText(L["Yes, keep it linked"])
 f:SetSize(120, 25)
 f:SetScript("OnClick", function() mf.jumpDialog:Hide() end)
 
 -- undo and jump over button
 f = ng:New(addonName, "Button", nil, mf.jumpDialog)
 f:SetPoint("BOTTOMRIGHT", mf.jumpDialog, "BOTTOMRIGHT", -10, 10)
 f:SetText(L["No, jump over"])
 f:SetSize(120, 25)
 f:SetScript("OnClick", function()
   -- revert the default link and jump over
   local n = #links
   linksPool[#linksPool + 1] = links[n]
   links[n]:Hide()
   links[n] = nil
   
   current_room.neighbors[oppositeDir[last_dir]] = nil
   current_room = last_room
   setCurrentRoom(addRoom(last_dir, true))
   mf.jumpDialog:Hide()
  end)
 
 mf.jumpDialog:Hide()
end

local function createRoomInteractionDialog()
 mf.roomInteractionDialog = ng:New(addonName, "Frame", nil, scrollframe)
 mf.roomInteractionDialog:SetPoint("TOPLEFT")
 mf.roomInteractionDialog:SetSize(140, 80)
 mf.roomInteractionDialog:SetFrameStrata("DIALOG")

 -- top header
 local f = ng:New(addonName, "Groupbox", nil, mf.roomInteractionDialog)
 f:SetHeight(20)
 f:SetPoint("TOPLEFT")
 f:SetPoint("TOPRIGHT", mf.roomInteractionDialog, "TOPRIGHT")
 f.text:ClearAllPoints()
 f.text:SetPoint("CENTER") 

 mf.roomInteractionDialog.lbl_selected = f.text
 
 f = mf.roomInteractionDialog:CreateTexture()
 f:SetTexture("interface\\minimap\\UI-QuestBlob-MinimapRing")
 f:SetBlendMode("ADD")
 f:SetSize(buttonW * 2, buttonH * 2)
 f:Hide()
 
 mf.roomInteractionDialog.sel_room_marker = f
 
 -- go to button
 f = ng:New(addonName, "Button", nil, mf.roomInteractionDialog)
 f:SetPoint("TOP", mf.roomInteractionDialog, "TOP", 0, -25)
 f:SetText(L["Set Player location"])
 f:SetSize(120, 20)
 f.step = 0
 f:SetScript("OnClick", function(self)
   if not mf.roomInteractionDialog.selected_room then return end
   
   if self.step == 0 then
    self.step = 1
    self:SetText(L["Click again to confirm"])
   else
    self.step = 0
    self:SetText(L["Set Player location"])
    setCurrentRoom(mf.roomInteractionDialog.selected_room)
   end
  end)
 mf.roomInteractionDialog.btn_goto = f
 
  -- clear markers button
 f = ng:New(addonName, "Button", nil, mf.roomInteractionDialog)
 f:SetPoint("TOP", mf.roomInteractionDialog, "TOP", 0, -50)
 f:SetText(L["Clear Markers"])
 f:SetSize(120, 20)
 f.step = 0
 f:SetScript("OnClick", function(self)
   if not mf.roomInteractionDialog.selected_room then return end
   
   mf.roomInteractionDialog.selected_room.button:SetBackdropColor(1, 1, 1, 1) 
   mf.roomInteractionDialog.selected_room.button:SetBackdropBorderColor(0, 0, 0, 0)
  end)
 
 mf.roomInteractionDialog:Hide()
end


local function createHelpDialog()
 mf.helpDialog = ng:New(addonName, "Frame", nil, mf)
 ng:SetFrameMovable(mf.helpDialog, true)
 mf.helpDialog:SetPoint("CENTER", UIParent, "CENTER")
 mf.helpDialog:SetSize(500, 260)
 mf.helpDialog:SetFrameStrata("DIALOG")
 
 -- top header
 local f = ng:New(addonName, "Groupbox", nil, mf.helpDialog)
 f:SetHeight(20)
 f:SetPoint("TOPLEFT")
 f:SetPoint("TOPRIGHT", mf.helpDialog, "TOPRIGHT")
 f.text:ClearAllPoints()
 f.text:SetPoint("CENTER")
 f.text:SetText(HELP_LABEL)
 
 f = ng:New(addonName, "Label", nil, mf.helpDialog)
 f:SetPoint("TOPLEFT", mf.helpDialog, "TOPLEFT", 10, -25)
 f:SetPoint("BOTTOMRIGHT", mf.helpDialog, "BOTTOMRIGHT", -10, 25)
 f:SetText(format("\n|cffffff00%s|r\n", L["How does the Endless Halls tool work?"])..
           format("|cffeeeeff%s|r\n",   L["It tracks player movement through the halls, generating a map that can be used to mark special rooms and retrace your steps into them when necessary."])..
           format("|cffeeeeff%s|r\n\n", L["There is a shenanigan, however: in every maze there are a few one-directional doors that lead to a random location, they cannot be recognized by either the addon or the player. If you feel you got teleported or you're simply lost, I'd recommend to use the Enabled button to deactivate mapping until you find a familiar room, then reposition the player into that room on the map and re-enable to restart mapping from there."])..
           format("|cffffff00%s|r\n",   L["How can I reposition the player on the map?"])..
           format("|cffeeeeff%s|r\n\n", L["Hold the Ctrl key, then click on the desired room to select it (a round circle will appear around the room), then click the 'Set player location' button twice"]))
 f:SetJustifyH("LEFT")
 f:SetJustifyV("TOP")
  
 f = ng:New(addonName, "Button", nil, mf.helpDialog)
 f:SetSize(75, 20)
 f:SetPoint("BOTTOM", mf.helpDialog, "BOTTOM", 0, 5)
 f:SetScript("OnClick", function() mf.helpDialog:Hide() end)
 f:SetText(CLOSE)
 
 mf.helpDialog:Hide()
end

local function setBlockade(self)
 local i = self.c
 local btn = current_room.button
 
 btn.blockades[i].active = not btn.blockades[i].active
 btn.blockades[i]:SetShown(btn.blockades[i].active)
end

local function initialize()

 if mf then 
  mf:SetShown(not mf:IsShown())
  return
 end

 local function hideTooltip()
  GameTooltip:Hide()
 end
 
 ng = NyxGUI("1.0")
 ng:Initialize(addonName, nil, "main", default_theme)
 
 mf = ng:New(addonName, "Frame", nil, UIParent)
 ng:SetFrameMovable(mf, true)
 mf:SetPoint("CENTER")
 mf:SetSize(525, 480)
 
 local topheader = ng:New(addonName, "Groupbox", nil, mf)
 topheader:SetHeight(20)
 topheader:SetPoint("TOPLEFT")
 topheader:SetPoint("TOPRIGHT", mf, "TOPRIGHT", -20, 0)
 topheader.text:ClearAllPoints()
 topheader.text:SetPoint("CENTER") 
 topheader:SetText("Lucid Nightmare Helper - 清醒梦魇助手")
 
 mf.current_room_label = ng:New(addonName, "Label", nil, mf)
 mf.current_room_label:SetPoint("TOP", topheader, "BOTTOM", 0, -10)
 
 scrollframe = CreateFrame("ScrollFrame", nil, mf)
 scrollframe:SetPoint("TOPLEFT", mf, "TOPLEFT", 75, -50)
 scrollframe:SetPoint("TOPRIGHT", mf, "TOPRIGHT", -30, -50)
 scrollframe:SetPoint("BOTTOMLEFT", mf, "BOTTOMLEFT", 75, 50)
 scrollframe:SetPoint("BOTTOMRIGHT", mf, "BOTTOMRIGHT", -30, 50)
 
 scrollframe.bg = scrollframe:CreateTexture()
 scrollframe.bg:SetAllPoints()
 scrollframe.bg:SetColorTexture(0, 0, 0, 1)
 
 container = CreateFrame("Frame", nil, scrollframe)
 container:SetSize(containerW, containerH)
 scrollframe:SetScrollChild(container)
 
 local last_x, last_y = 0,0
 scrollframe:SetScript("OnMouseDown", function(self, button)
   if button ~= "RightButton" then return end

   -- snapshot cursor and scroll values
   local x, y = GetCursorPosition()
   scrollframe.cursor_x = x
   scrollframe.cursor_y = y
   scrollframe.last_horiz = scrollframe:GetHorizontalScroll()
   scrollframe.last_vert = scrollframe:GetVerticalScroll()
   scrollframe.dragging_camera = true
  end)
  
 scrollframe:SetScript("OnMouseUp", function(self, button)
  if button ~= "RightButton" then return end
  scrollframe.dragging_camera = false
 end)

 scrollframe.centerButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.centerButton.tex = scrollframe.centerButton:CreateTexture()
 scrollframe.centerButton.tex:SetTexture("interface\\cursor\\crosshairs")
 scrollframe.centerButton.tex:SetAllPoints()
 scrollframe.centerButton:SetSize(20, 20)
 scrollframe.centerButton:SetPoint("CENTER", scrollframe, "TOPRIGHT", 0, -35)
 scrollframe.centerButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Center camera to the current room"])
  GameTooltip:Show()
  end)
 scrollframe.centerButton:SetScript("OnLeave", hideTooltip)
 scrollframe.centerButton:SetScript("OnClick", function() centerCam(current_room.cx, current_room.cy) end)

 scrollframe.resetButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.resetButton.tex = scrollframe.resetButton:CreateTexture()
 scrollframe.resetButton.tex:SetTexture("interface\\common\\voicechat-muted")
 scrollframe.resetButton.tex:SetAllPoints()
 scrollframe.resetButton:SetSize(20, 20)
 scrollframe.resetButton:SetPoint("CENTER", scrollframe, "TOPRIGHT")
 scrollframe.resetButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L["Erase the current map and start over"])
  GameTooltip:Show()
  end)
 scrollframe.resetButton:SetScript("OnLeave", hideTooltip)
 scrollframe.resetButton:SetScript("OnClick", ResetMap)
 
 scrollframe.infoButton = CreateFrame("Button", nil, scrollframe)
 scrollframe.infoButton.tex = scrollframe.infoButton:CreateTexture()
 scrollframe.infoButton.tex:SetTexture("interface\\friendsframe\\informationicon")
 scrollframe.infoButton.tex:SetAllPoints()
 scrollframe.infoButton:SetSize(20, 20)
 scrollframe.infoButton:SetPoint("CENTER", scrollframe, "TOPRIGHT", -35, 0)
 scrollframe.infoButton:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(INFO)
  GameTooltip:AddLine(L["You can navigate the map by Right-Click Dragging it"])
  GameTooltip:Show()
  end)
 scrollframe.infoButton:SetScript("OnLeave", hideTooltip)
 
 playerframe = CreateFrame("Frame")
 playerframe:SetAllPoints()
 playerframe.tex = playerframe:CreateTexture()
 playerframe.tex:SetAllPoints()
 playerframe.tex:SetTexture(player_icon)
 
 local f = ng:New(addonName, "Label", nil, mf)
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 15, -50)
 f:SetText(L["Markers"])

 for i = 1,5 do
  f = CreateFrame("Button", nil, mf)
  f.tex = f:CreateTexture()
  f.tex:SetAllPoints()
  f.tex:SetTexture("interface\\icons\\boss_odunrunes_"..(i == 3 and "orange" or color_strings[i]))

  --f:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -40 + i * -32)
  f:SetPoint("TOPLEFT", mf, "TOPLEFT", 39 + 32 * (i % 2 - 1), -40 + math.ceil(i/2) * -32)
  f:SetSize(30, 30)
  f.t = "rune"
  f.c = i
  f:SetScript("OnClick", setPOIClick)
  --f:SetText(color_strings[i].." Rune")
  
  f = CreateFrame("Button", nil, mf)
  f.tex = f:CreateTexture()
  f.tex:SetAllPoints()
  f.tex:SetTexture("spells\\mage_frostorb_orb")
  f.tex:SetVertexColor(unpack(colors[i]))
  
  --f:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -220 + i * -32)
  f:SetPoint("TOPLEFT", mf, "TOPLEFT", 39 + 32 * (i % 2 - 1), -280 + math.ceil(i/2) * -32)
  f:SetSize(30, 30)
  f.t = "orb"
  f.c = i
  f:SetScript("OnClick", setPOIClick)
  --f:SetText(color_strings[i].." Orb")
 end
 
 -- door markers
 f = CreateFrame("Button", nil, mf)
 f.tex = f:CreateTexture()
 f.tex:SetAllPoints()
 f.tex:SetTexture("dungeons\\textures\\6hu_garrison\\6hu_garrison_rocks")
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -200)
 f:SetSize(25, 15)
 f.c = north
 f:SetScript("OnClick", setBlockade)

 f = CreateFrame("Button", nil, mf)
 f.tex = f:CreateTexture()
 f.tex:SetAllPoints()
 f.tex:SetTexture("dungeons\\textures\\6hu_garrison\\6hu_garrison_rocks")
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 9, -216)
 f:SetSize(15, 25)
 f.c = west
 f:SetScript("OnClick", setBlockade)
 
 f = CreateFrame("Button", nil, mf)
 f.tex = f:CreateTexture()
 f.tex:SetAllPoints()
 f.tex:SetTexture("dungeons\\textures\\6hu_garrison\\6hu_garrison_rocks")
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 51, -216)
 f:SetSize(15, 25)
 f.c = east
 f:SetScript("OnClick", setBlockade)

 f = CreateFrame("Button", nil, mf)
 f.tex = f:CreateTexture()
 f.tex:SetAllPoints()
 f.tex:SetTexture("dungeons\\textures\\6hu_garrison\\6hu_garrison_rocks")
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 25, -242)
 f:SetSize(25, 15)
 f.c = south
 f:SetScript("OnClick", setBlockade)
 
 f = ng:New(addonName, "Button", nil, mf)
 f:SetPoint("TOPLEFT", mf, "TOPLEFT", 15, -420)
 f:SetSize(50, 30)
 f.c = 6
 f:SetScript("OnClick", setPOIClick)
 f:SetText(L["Clear"])

 f = ng:New(addonName, "SliderH", nil, mf)
 f:SetPoint("TOPLEFT", scrollframe, "BOTTOMRIGHT", -100, -20)
 f:SetPoint("TOPRIGHT", scrollframe, "BOTTOMRIGHT", 0, -20)
 f.text:ClearAllPoints()
 f.text:SetPoint("BOTTOM", f, "TOP", 0, 2)
 f:SetText(OPACITY)
 f:SetMinMaxValues(40, 100)
 f:SetValue(100)
 f:SetScript("OnValueChanged", function(self, value)
   mf:SetAlpha(value / 100)
  end)
 
 f = ng:New(addonName, "Checkbutton", nil, mf)
 f:SetSize(75, 20)
 f:SetPoint("BOTTOMLEFT", scrollframe, "TOPLEFT", 5, 5)
 f.checked_color    = checked_color or "05ff0Dff" 
 f.unchecked_color  = unchecked_color or "ff050Dff"
 f:SetChecked(true)
 f:SetText(L["Enabled"])
 f:SetScript("OnClick", function(self)
   self:SetChecked(tracking_disabled)
   tracking_disabled = not tracking_disabled
   self:SetText(tracking_disabled and L["Disabled"] or L["Enabled"])
  end)
 f:SetScript("OnEnter", function(self)
   GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
   GameTooltip:ClearLines()
   GameTooltip:AddLine(L["This button pauses/unpauses the map generation"])
   GameTooltip:Show()
  end)
 f:SetScript("OnLeave", hideTooltip)
 
 f = ng:New(addonName, "Button", nil, mf)
 f:SetSize(50, 20)
 f:SetPoint("TOPRIGHT", mf, "TOPRIGHT", -25, 0)
 f:SetScript("OnClick", function() mf.helpDialog:Show() end)
 f:SetText(HELP_LABEL)
  
 f = ng:New(addonName, "Button", nil, mf)
 f:SetSize(75, 20)
 f:SetPoint("BOTTOM", mf, "BOTTOM", 0, 10)
 f:SetScript("OnClick", function() mf:Hide() end)
 f:SetText(CLOSE)
 
 f = ng:New(addonName, "Button", nil, mf)
 f:SetSize(20, 20)
 f:SetPoint("TOPRIGHT")
 f:SetScript("OnClick", function() mf:Hide() end)
 f:SetText("X")
 
 createJumpDialog()
 createRoomInteractionDialog()
 createHelpDialog()
 
 ResetMap()
 
 ly, lx = UnitPosition("player")
 
 mf:SetScript("OnUpdate", update)
 mf:SetScript("OnEvent", function(self, event, ...) self[event](...) end)
 
 local delay = 0
 function mf.UNIT_SPELLCAST_SUCCEEDED(...)
  if not mf:IsShown() or tracking_disabled then return end
 
   local spellID = select(5, ...)
   local dir
   
   if spellID == 247350 then
    dir = north
   elseif spellID == 247352 then
    dir = east
   elseif spellID == 247351 then
    dir = south
   elseif spellID == 247353 then
    dir = west
   else
    return
   end
 
   -- trying to fix the double room generation issue
   -- I still cannot reproduce it with my character/client
   -- guessing the event is fired twice for some reason
   local now = GetTime()
   if now - delay < 0.3 then return end
   
   mf.jumpDialog:Hide() 
   last_dir = dir
   setCurrentRoom(current_room.neighbors[dir] or addRoom(dir))
   delay = now
 end

 mf:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end



--[===[@debug@
local function debugfunc(s)
 if s == "n" then
  mf.UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, 247350)
 elseif s == "e" then
  mf.UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, 247352)
 elseif s == "s" then
  mf.UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, 247351)
 else
  mf.UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, 247353)
 end
end
SLASH_LUCIDNIGHTMAREHELPERDEBUG1 = "/lnd"
SlashCmdList["LUCIDNIGHTMAREHELPERDEBUG"] = debugfunc
--@end-debug@]===]

-- slash command
SLASH_LUCIDNIGHTMAREHELPER1 = "/lucid"
SLASH_LUCIDNIGHTMAREHELPER2 = "/ln"
SlashCmdList["LUCIDNIGHTMAREHELPER"] = initialize
