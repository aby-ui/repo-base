VB_VESRION = '6.1'

--163ui_edit
local MasqueGroupName, MasqueGroup = "vBar Buttons", nil
local function applyMasque(icon)
    if MasqueGroup == nil then
        local Masque = LibStub and LibStub('Masque', true)
        MasqueGroup = Masque and Masque:Group(MasqueGroupName) or false
    end
    if not MasqueGroup then return end
    if icon.__masqued then
        MasqueGroup:RemoveButton(icon)
    else
        MasqueGroup:AddButton(icon)
        icon.__masqued = true
    end
end

VB_BACKDROP = {bgFile = 'Interface/Tooltips/UI-Tooltip-Background'}

VB_BUTTON_SIZE = 42
VB_DRAG_HANDLE = 12
VB_DRAG_WIDTH = 38
VB_DRAG_HEIGHT = 16

VB_SIZES = {
   [1] = .8,
   [.8] = .67,
   [.67] = 1,
}

VB_MENU = {
   hslot12 = '横排双行12键',
   gslot12 = '竖排单行12键',
   hslot6 = '横排单行12键',
   zfslot12 = '横排三行12键',
   sslot12 = '竖排双行12键',
   zfslot9 = '正方9键',
   large = '尺寸为大',
   medium = '尺寸为中',
   small = '尺寸为小',
   dft = '增加动作条1',
   dst = '增加动作条2',
   ddt = '增加动作条3',
   labels = '显示热键',
   stancebars = '使用姿态切换',
   hide = '隐藏vBar',
}


-- DEFAULTS
VB_DEFAULT_SHAPE = 'zfslot12'
VB_DEFAULT_ENTER = ''
VB_DEFAULT_CURSOR = ''
VB_DEFAULT_dst = ''
VB_DEFAULT_dft = ''
VB_DEFAULT_SIZE = .67
VB_DEFAULT_LEFT = 1900
VB_DEFAULT_TOP = 400
VB_DEFAULT_LABELS = false
VB_DEFAULT_CLEARED = false
VB_DEFAULT_CLICKED = false

-- SAVED VARIABLES
VBar = { }
VBar.cleared = VB_DEFAULT_CLEARED
VBar.leftclicked = VB_DEFAULT_CLICKED
VBar.rightclicked = VB_DEFAULT_CLICKED
-- GLOBAL VARIABLES
VB_numpads = { }
VB_lockbars = nil
VB_clickme = false
VB_class = ''
VB_numpad = nil
VB_login = '0'

-- MESSAGES
VB_PASTEL = '|cffffff80'
VB_BRIGHT = '|cffffff00'
VB_PLAIN = '|r'
VB_TITLE = VB_PASTEL .. 'VBar: ' .. VB_PLAIN
VB_DESCRIPTION = VB_BRIGHT .. 'VBar ' .. VB_VESRION .. ': ' .. VB_PASTEL .. '鼠标悬浮在动作条第一格上方，左键按住拖动,右键点击弹出功能菜单，重置打/VBar reset。'
VB_HIDDEN = VB_TITLE .. '自动隐藏'
VB_RESET = VB_TITLE .. '重置到默认状态.'
VB_CLICK_ERROR = '左键按住拖动,右键点击弹出功能菜单'
VB_ENTER_UNBOUND = ''
VB_dft_UNBOUND = ''
VB_dst_UNBOUND = ''
VB_USING_STANCEBARS = VB_TITLE .. '鼠标左键点击第一个按钮上方移动.'
VB_NOT_USING_STANCEBARS = VB_TITLE .. ''
VB_STANCELESS_CLASS = VB_TITLE .. '仅战士，武僧,牧师,德鲁伊,盗贼能用.'
VB_dst_TOPSLOTS = VB_TITLE .. ''
VB_dst_RIGHTSLOTS = VB_TITLE .. ''
VB_MOONKIN_BAR = VB_TITLE .. ''

-- ACTION BAR SLOTS

VB_NORMAL_SLOTS = {
   85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
   97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120
}

VB_DRUID_SLOTS = {
   85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
   24, 23, 22, 21
}

VB_TREE_SLOTS = {
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
   48, 47, 46, 45, 13, 14, 15, 16, 17, 18, 19, 20,
   21, 22, 23, 24
}

VB_MOONKIN_SLOTS = {
   13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
   36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25,
   37, 38, 39, 40
}

VB_ROGUE_SLOTS = {
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
   97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
   96, 95, 94, 93
}

VB_MONK_SLOTS = {
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
   24, 23, 22, 21     -- action bar 2 slots
}

VB_WARRIOR_SLOTS = {
   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
   109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
   24, 23, 22, 21    
}

VB_CLASS_SLOTS = {
   deathknight = VB_NORMAL_SLOTS,
   druid = VB_DRUID_SLOTS,
   hunter = VB_NORMAL_SLOTS,
   mage = VB_NORMAL_SLOTS,
   moonkin = VB_MOONKIN_SLOTS,
   paladin = VB_NORMAL_SLOTS,
   priest = VB_NORMAL_SLOTS,
   rogue = VB_ROGUE_SLOTS,
   shaman = VB_NORMAL_SLOTS,
   tree = VB_TREE_SLOTS,
   warlock = VB_NORMAL_SLOTS,
   warrior = VB_WARRIOR_SLOTS,
   monk =  VB_MONK_SLOTS,
   demonhunter = VB_NORMAL_SLOTS
}


-- STANCE BARS

VB_CLASS_STANCEBARS = {druid = 1, moonkin = 2, priest = 3, rogue = 4, monk = 5, tree = 6,warrior = 7}
VB_STANCES ={
[1] = { 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84 },
[2] = { 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96 },
[3] = { 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108 }
}
-- [4] = { 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120}



--  LAYOUTS

VB_KEYBOARDS = {

hslot12 = {
   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 1, col = 2, type='Numeric', label = '', binding = '' },
   { row = 1, col = 3, type='Numeric', label = '', binding = '' },
   { row = 1, col = 4, type='Numeric', label = '', binding = '' },
   { row = 1, col = 5, type='Numeric', label = '', binding = '' },
   { row = 1, col = 6, type='Numeric', label = '', binding = '' },
   { row = 2, col = 1, type='Numeric', label = '', binding = '' },
   { row = 2, col = 2, type='Numeric', label = '', binding = '' },
   { row = 2, col = 3, type='Numeric', label = '', binding = '' },
   { row = 2, col = 4, type='Numeric', label = '', binding = '' },
   { row = 2, col = 5, type='Numeric', label = '', binding = '' },
   { row = 2, col = 6, type='Numeric', label = '', binding = '' },

   { row = 3.3, col = 3 - 3.3, type='dft', label = '', binding = '' },
   { row = 1, col = 3 - 3.3, type='dft', label = '', binding = '' },
   { row = 2, col = 3 - 3.3, type='dft', label = '', binding = '' },


   { row = 3.3, col = 1, type='dst', label = '', binding = '' },
   { row = 3.3, col = 2, type='dst', label = '', binding = '' },
   { row = 3.3, col = 3, type='dst', label = '', binding = '' },
   { row = 3.3, col = 4, type='dst', label = '', binding = '' },
   { row = 3.3, col = 5, type='dst', label = '', binding = '' },
   { row = 3.3, col = 6, type='dst', label = '', binding = '' }

},

gslot12 = {

   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 2, col = 1, type='Numeric', label = '', binding = '' },
   { row = 3, col = 1, type='Numeric', label = '', binding = '' },
   { row = 4, col = 1, type='Numeric', label = '', binding = '' },
   { row = 5, col = 1, type='Numeric', label = '', binding = '' },
   { row = 6, col = 1, type='Numeric', label = '', binding = '' },
   { row = 7, col = 1, type='Numeric', label = '', binding = '' },
   { row = 8, col = 1, type='Numeric', label = '', binding = '' },
   { row = 9, col = 1, type='Numeric', label = '', binding = '' },
   { row = 10, col = 1, type='Numeric', label = '', binding = '' },
   { row = 11, col = 1, type='Numeric', label = '', binding = '' },
   { row = 12, col = 1, type='Numeric', label = '', binding = '' },

   { row = 1, col = 2, type='dft', label = '', binding = '' },
   { row = 2, col = 2, type='dft', label = '', binding = '' },
   { row = 3, col = 2, type='dft', label = '', binding = '' },
   { row = 4, col = 2, type='dft', label = '', binding = '' },
   { row = 5, col = 2, type='dft', label = '', binding = '' },
   { row = 6, col = 2, type='dft', label = '', binding = '' },
   { row = 7, col = 2, type='dft', label = '', binding = '' },
   { row = 8, col = 2, type='dft', label = '', binding = '' },
   { row = 9, col = 2, type='dft', label = '', binding = '' },
   { row = 10, col = 2, type='dft', label = '', binding = '' },
   { row = 11, col = 2, type='dft', label = '', binding = '' },
   { row = 12, col = 2, type='dft', label = '', binding = '' },   


   
   { row = 13.3, col = 1, type='ddt', label = '', binding = '' },
   { row = 14.3, col = 1, type='ddt', label = '', binding = '' },

   
   { row = 13.3, col = 2, type='dst', label = '', binding = '' },
   { row = 14.3, col = 2, type='dst', label = '', binding = '' },
},

hslot6 = {

   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 1, col = 2, type='Numeric', label = '', binding = '' },
   { row = 1, col = 3, type='Numeric', label = '', binding = '' },
   { row = 1, col = 4, type='Numeric', label = '', binding = '' },
   { row = 1, col = 5, type='Numeric', label = '', binding = '' },
   { row = 1, col = 6, type='Numeric', label = '', binding = '' },
   { row = 1, col = 7, type='Numeric', label = '', binding = '' },
   { row = 1, col = 8, type='Numeric', label = '', binding = '' },
   { row = 1, col = 9, type='Numeric', label = '', binding = '' },
   { row = 1, col = 10, type='Numeric', label = '', binding = '' },
   { row = 1, col = 11, type='Numeric', label = '', binding = '' },
   { row = 1, col = 12, type='Numeric', label = '', binding = '' },
   
   { row = 2, col = 1, type='dft', label = '', binding = '' },
   { row = 2, col = 2, type='dft', label = '', binding = '' },
   { row = 2, col = 3, type='dft', label = '', binding = '' },
   { row = 2, col = 4, type='dft', label = '', binding = '' },
   { row = 2, col = 5, type='dft', label = '', binding = '' },
   { row = 2, col = 6, type='dft', label = '', binding = '' },
   { row = 2, col = 7, type='dft', label = '', binding = '' },
   { row = 2, col = 8, type='dft', label = '', binding = '' },
   { row = 2, col = 9, type='dft', label = '', binding = '' },
   { row = 2, col = 10, type='dft', label = '', binding = '' },
   { row = 2, col = 11, type='dft', label = '', binding = '' },
   { row = 2, col = 12, type='dft', label = '', binding = '' },   
   
   { row = 1, col = 13.3, type='dst', label = '', binding = '' },
   { row = 1, col = 14.3, type='dst', label = '', binding = '' },
   { row = 1, col = 2 - 3.3, type='dst', label = '', binding = '' },
   { row = 1, col = 3 - 3.3, type='dst', label = '', binding = '' },   

   { row = 2, col = 13.3, type='ddt', label = '', binding = '' },
   { row = 2, col = 14.3, type='ddt', label = '', binding = '' },
   { row = 2, col = 2 - 3.3, type='ddt', label = '', binding = '' },
   { row = 2, col = 3 - 3.3, type='ddt', label = '', binding = '' },
},

zfslot12 = {

   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 1, col = 2, type='Numeric', label = '', binding = '' },
   { row = 1, col = 3, type='Numeric', label = '', binding = '' },
   { row = 1, col = 4, type='Numeric', label = '', binding = '' },
   { row = 2, col = 1, type='Numeric', label = '', binding = '' },
   { row = 2, col = 2, type='Numeric', label = '', binding = '' },
   { row = 2, col = 3, type='Numeric', label = '', binding = '' },
   { row = 2, col = 4, type='Numeric', label = '', binding = '' },
   { row = 3, col = 1, type='Numeric', label = '', binding = '' },
   { row = 3, col = 2, type='Numeric', label = '', binding = '' },
   { row = 3, col = 3, type='Numeric', label = '', binding = '' },
   { row = 3, col = 4, type='Numeric', label = '', binding = '' },
   
   { row = 1, col = 5.5, type='ddt', label = '', binding = '' },
   { row = 1, col = 6.5, type='ddt', label = '', binding = '' },
   { row = 2, col = 5.5, type='ddt', label = '', binding = '' },
   { row = 2, col = 6.5, type='ddt', label = '', binding = '' },
   { row = 3, col = 5.5, type='ddt', label = '', binding = '' },
   { row = 3, col = 6.5, type='ddt', label = '', binding = '' },
   
   { row = 1, col = 1 - 1.5, type='dft', label = '', binding = '' },
   { row = 2, col = 1 - 1.5, type='dft', label = '', binding = '' },
   { row = 3, col = 1 - 1.5, type='dft', label = '', binding = '' },

   { row = 4, col = 1, type='dst', label = '', binding = '' },
   { row = 4, col = 2, type='dst', label = '', binding = '' },
   { row = 4, col = 3, type='dst', label = '', binding = '' },
   { row = 4, col = 4, type='dst', label = '', binding = '' }

},

sslot12 = {

   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 1, col = 2, type='Numeric', label = '', binding = '' },
   { row = 2, col = 1, type='Numeric', label = '', binding = '' },
   { row = 2, col = 2, type='Numeric', label = '', binding = '' },
   { row = 3, col = 1, type='Numeric', label = '', binding = '' },
   { row = 3, col = 2, type='Numeric', label = '', binding = '' },
   { row = 4, col = 1, type='Numeric', label = '', binding = '' },
   { row = 4, col = 2, type='Numeric', label = '', binding = '' },
   { row = 5, col = 1, type='Numeric', label = '', binding = '' },
   { row = 5, col = 2, type='Numeric', label = '', binding = '' },
   { row = 6, col = 1, type='Numeric', label = '', binding = '' },
   { row = 6, col = 2, type='Numeric', label = '', binding = '' },

   { row = 2, col = 2 -3.3, type='ddt', label = '', binding = '' },
   { row = 3, col = 2 -3.3, type='ddt', label = '', binding = '' },
   { row = 4, col = 2 -3.3, type='ddt', label = '', binding = '' },
   { row = 5, col = 2 -3.3, type='ddt', label = '', binding = '' },
   { row = 6, col = 2 -3.3, type='ddt', label = '', binding = '' },

   { row = 1, col = 2 - 3.3, type='dft', label = '', binding = '' },
   { row = 1, col = 3 - 3.3, type='dft', label = '', binding = '' },

   { row = 2, col = 3 - 3.3, type='dst', label = '', binding = '' },
   { row = 3, col = 3 - 3.3, type='dst', label = '', binding = '' },
   { row = 4, col = 3 - 3.3, type='dst', label = '', binding = '' },
   { row = 5, col = 3 - 3.3, type='dst', label = '', binding = '' },
   { row = 6, col = 3 - 3.3, type='dst', label = '', binding = '' }

},

zfslot9 = {

   { row = 1, col = 1, type='Numeric', label = '', binding = '' },
   { row = 1, col = 2, type='Numeric', label = '', binding = '' },
   { row = 1, col = 3, type='Numeric', label = '', binding = '' },
   { row = 2, col = 1, type='Numeric', label = '', binding = '' },
   { row = 2, col = 2, type='Numeric', label = '', binding = '' },
   { row = 2, col = 3, type='Numeric', label = '', binding = '' },
   { row = 3, col = 1, type='Numeric', label = '', binding = '' },
   { row = 3, col = 2, type='Numeric', label = '', binding = '' },
   { row = 3, col = 3, type='Numeric', label = '', binding = '' },

   { row = 1, col = 4.3, type='ddt', label = '', binding = '' },
   { row = 2, col = 4.3, type='ddt', label = '', binding = '' },
   { row = 3, col = 4.3, type='ddt', label = '', binding = '' },

   { row = 1, col = 1 - 2.6, type='dft', label = '', binding = '' },
   { row = 1, col = 2 - 2.6, type='dft', label = '', binding = '' },


   { row = 2, col = 1 - 2.6, type='dst', label = '', binding = '' },
   { row = 2, col = 2 - 2.6, type='dst', label = '', binding = '' },
   { row = 3, col = 1 - 2.6, type='dst', label = '', binding = '' },
   { row = 3, col = 2 - 2.6, type='dst', label = '', binding = '' }

},

}


----------------------------------------------------------------------------------------------------
VB_INSTRUCTIONS =

[[
<big>VBar</big> <i>for WOD 6.1</i>
]]

----------------------------------------------------------------------------------------------------
function VB_DisplayHotkey(button)
   local pad = button.npb_pad
   local label = button.npb_label
   if not button.npb_pad then return end
   local hotkey = _G[button:GetName()..'HotKey']
   local mnf = _G[button:GetName().."Name"]
   if label == '' then
      hotkey:SetText(RANGE_INDICATOR)
      hotkey:SetPoint('TOPLEFT', button, 'TOPLEFT', 1, -2)
      hotkey:Hide()
	  mnf:Hide()
   else
      hotkey:SetText(label)
      hotkey:SetPoint('TOPLEFT', button, 'TOPLEFT', -2, -2)
      hotkey:Show()
	  mnf:Show()
   end
end


----------------------------------------------------------------------------------------------------

function VB_UpdateHotkeys(self, actionButtonType)
   VB_DisplayHotkey(self)
end


----------------------------------------------------------------------------------------------------

function VB_time()
   if GetTime then return GetTime() end
   if os and os.time then return os.time() end
   return 0
end

----------------------------------------------------------------------------------------------------

function VB_Chat(message)
   if not message or not DEFAULT_CHAT_FRAME then return end
   DEFAULT_CHAT_FRAME:AddMessage(message)
end

----------------------------------------------------------------------------------------------------
function VB_DoSlash(cmd)
   cmd = string.lower(cmd)

   if cmd == 'help' then
      VB_Help()
      return end

   if cmd == 'show' then
      VB_Show()
      return end

   if cmd == 'hide' then
      VB_Hide()
      return end

   if cmd == 'jump' then
      VB_Chat(GetBindingKey('Jump'))
      return end

   if cmd == 'slots' then
      VB_ListSlots()
      return end

   if cmd == 'reset' then
      VB_HideNumpad()
      VBar = { }
      VB_clickme = false
      VB_CheckValues()
      VB_ShowNumpad()
      VB_Chat(VB_RESET)
	  VB_ToggleLabels()
      return end

   local numpad = VB_GetNumpad()
   if not VBar.leftclicked or not VBar.rightclicked then
      VB_SetBackdrop(numpad)

   end
   VB_Show()
end

----------------------------------------------------------------------------------------------------
function VB_ListSlots()
   for slot = 1, 120 do
      local texture = GetActionTexture(slot)
      if texture then
         VB_Chat(slot .. ': ' .. texture) end
   end
end

----------------------------------------------------------------------------------------------------
function VB_DoLoad(self)
   self:RegisterEvent('PLAYER_LOGIN')
   self:RegisterEvent('PLAYER_LOGOUT')
   self:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE')
   self:RegisterEvent('PLAYER_REGEN_DISABLED')
   self:RegisterEvent('PLAYER_REGEN_ENABLED')
   self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
   SlashCmdList['VB'] = VB_DoSlash
   SLASH_VB1 = '/vb'
   SLASH_VB2 = '/vbar'
   hooksecurefunc('ActionButton_UpdateHotkeys', VB_UpdateHotkeys)
end

----------------------------------------------------------------------------------------------------
function VB_DoEvent(self, event, arg1)
   if event == 'PLAYER_LOGIN' then
      VB_Initialize()
      VB_login = '1'
   end

   if event == 'PLAYER_LOGOUT' then
      VB_LogOut() end

   if event == 'CHAT_MSG_CHANNEL_NOTICE' then
      VB_Notify()
      self:UnregisterEvent('CHAT_MSG_CHANNEL_NOTICE')
      end

   if VB_login == '1' then
      if event == 'PLAYER_SPECIALIZATION_CHANGED' and arg1 == "player" then
         VB_HideNumpad()
         VB_GetClass()
         VB_SetState()
         VB_ShowNumpad()
      end
   end

   if VBar.disabled then return end

   if event == 'PLAYER_REGEN_DISABLED' then
      VB_LockBars() end

   if event == 'PLAYER_REGEN_ENABLED' then
      VB_UnlockBars() end
end

----------------------------------------------------------------------------------------------------
function VB_Initialize()
   VB_GetClass()
   VB_CheckValues()
   VB_ClearSlots()
   if VBar.stancebars and not VBar.disabled then
      ChangeActionBarPage(VBar.barpage) end
   if not VBar.disabled then
      VB_ShowNumpad() 
	  end
end

----------------------------------------------------------------------------------------------------
function VB_Notify()
   if VBar.disabled then
      VB_Chat(VB_DISABLED) end
end

----------------------------------------------------------------------------------------------------
function VB_LogOut()
   VBar.barpage = 1
   if VBar.stancebars and not VBar.disabled then
      VBar.barpage = GetActionBarPage() end
end

----------------------------------------------------------------------------------------------------
function VB_LockBars()
   if LOCK_ACTIONBAR == '1' then return end
   local numpad = VB_GetNumpad()
   VB_ClearBackdrop(numpad)
   LOCK_ACTIONBAR = '1'
   VBar.unlock = true
end

----------------------------------------------------------------------------------------------------
function VB_UnlockBars()
   if not VBar.unlock then return end
   LOCK_ACTIONBAR = '0'
   VBar.unlock = false
end

----------------------------------------------------------------------------------------------------
function VB_GetClass()
   local localizedClass, englishClass = UnitClass('player')
   VB_class = string.lower(englishClass)
   for fx = 1, GetNumShapeshiftForms() do
      local icon, isActive, isCastable, spellId = GetShapeshiftFormInfo(fx)
      if spellId == 24858 then --'Moonkin Form'
         VB_class = 'moonkin' end
      if spellId == 33891 then --'Tree of Life'
         VB_class = 'tree' end
   end
end

----------------------------------------------------------------------------------------------------

function VB_ClearSlots()
   if VBar.cleared then return end

   if VB_class == 'druid' and (GetActionTexture(85) or GetActionTexture(109)) then
      PickupAction(85)
      PutItemInBackpack()
      PickupAction(109)
      PutItemInBackpack()
   end

   VBar.cleared = true
end

----------------------------------------------------------------------------------------------------

function VB_CheckValues()
   local stances = VB_CLASS_STANCEBARS[VB_class]
   local n = VBar
   if not n then
      n = { } end
   if not n.shape or not VB_KEYBOARDS[n.shape] then
      n.shape = VB_DEFAULT_SHAPE end
   if not n.ddt then
      n.ddt = '' end
   if not n.dft then
      n.dft = '' end
   if not n.dst or VB_class == 'moonkin' then
      n.dst = '' end
   if not n.size or not VB_SIZES[n.size] then
      n.size = VB_DEFAULT_SIZE end
   if not n.left or n.left < 0 or n.left > 4000 then
      n.left = VB_DEFAULT_LEFT end
   if not n.top or n.top < 0 or n.top > 4000 then
      n.top = VB_DEFAULT_TOP end
   if not n.stancebars or not stances then
      n.stancebars = false end
   if not n.barpage or n.barpage < 1 or n.barpage > 6 then
      n.barpage = 1 end
   if n.labels ~= false then
      n.labels = true end
end

----------------------------------------------------------------------------------------------------

function VB_ClickMe(self, motion)
   if VBar.leftclicked and VBar.rightclicked then return end
   if UnitAffectingCombat('player') == 1 then return end
   if VB_clickme then return end
   VB_clickme = true
   VB_Chat(VB_DESCRIPTION)
   UIErrorsFrame:AddMessage(VB_CLICK_ERROR, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
end

----------------------------------------------------------------------------------------------------

function VB_CreateNumpad(shape, ddt, dft, dst)

   function VB_DoDragStart(self, button)
      if UnitAffectingCombat('player') == 1 then return end
      VBar.leftclicked = true
      --VB_SetBackdrop(self)
      self:StartMoving()
   end

   function VB_DoDragStop(self, button)
      self:StopMovingOrSizing()
      --VB_ClearBackdrop(self)
      VBar.left = self:GetLeft()
      VBar.top = self:GetTop()
   end

   function VB_DoMouseDown(self, button)
      if UnitAffectingCombat('player') == 1 then return end
      if IsMouseButtonDown('leftbutton') then
          VB_DoDragStart(self, button)
      else
         --VB_SetBackdrop(self)
         VBar.rightclicked = true
         VB_ToggleMenu()
      end
   end

   function VB_DoEnter(self, motion)
      VB_SetBackdrop(self)
      VB_ClickMe(self, motion)
   end

   ----------------------------------------------------------------------------------------------------

   local numpad = CreateFrame('Frame', 'NumpadFrame', UIParent)
   if CoreHideOnPetBattle then CoreHideOnPetBattle(numpad) end
   numpad:SetMovable(1)
   numpad:EnableMouse(1)
   --numpad:RegisterForDrag('LeftButton')
   --numpad:SetScript('OnDragStart', VB_DoDragStart)
   --numpad:SetScript('OnDragStop', VB_DoDragStop)
   numpad:SetScript('OnMouseDown', VB_DoMouseDown)
   numpad:SetScript('OnMouseUp', VB_DoDragStop)
   numpad:SetScript('OnEnter', VB_DoEnter)
   numpad:SetScript('OnLeave', function(self) VB_ClearBackdrop(self) end)
   numpad:SetWidth(VB_DRAG_WIDTH)
   numpad:SetHeight(VB_DRAG_HEIGHT)
   numpad:SetClampedToScreen(true)
   numpad:Hide()

   local keyboard = VB_KEYBOARDS[shape]
   for keynum, key in ipairs(keyboard) do
      local chosen = (key.type == ddt or key.type == dft or key.type == dst)
      if key.type == 'Numeric' or chosen then
         local keyname = shape .. ddt .. dft .. dst .. keynum
         VB_CreateButton(numpad, keyname, keynum, key.col, key.row, key.width)
      end
   end

   VB_numpads[shape .. ddt .. dft .. dst] = numpad
end

----------------------------------------------------------------------------------------------------
function VB_SetButtonActions(button, keynum)
   local action = VB_CLASS_SLOTS[VB_class][keynum]

   if VBar.stancebars then

      local output = ''
      for sx = 1, 3 do
         local stance = (keynum < 12) and VB_STANCES[sx][keynum] or action
         output = output .. '[bonusbar:' .. sx .. ']' .. stance .. '; '
      end
      output = output .. action

      RegisterStateDriver(button, "page", output)
   else
      UnregisterStateDriver(button, "page")

      button:SetAttribute("action", action)
   end
end


function VB_CreateButton(numpad, keyname, keynum, col, row)

   function VB_OnDragStart(self, button)
      if UnitAffectingCombat('player') == 1 or (LOCK_ACTIONBAR == '1' and not IsModifiedClick("PICKUPACTION")) then return end
      PickupAction(ActionButton_GetPagedID(self))
   end

   local button = CreateFrame('CheckButton', keyname, numpad, 'ActionBarButtonTemplate')
   button:SetAttribute('type', 'action')

   SecureHandler_OnLoad(button)

   button:WrapScript(button, "OnAttributeChanged", [[
      name = name:match("^state%-(.+)")
      if name then
         control:RunAttribute("_onstate-"..name, name, value)
         return false
      end  ]]
   )

   button:SetAttribute("_onstate-page", [[
      local stateid, newstate = ...
      self:SetAttribute("action", tonumber(newstate)) ]]
   )

   VB_SetButtonActions(button, keynum)

   local left = VB_BUTTON_SIZE * (col - 1)
   local top = - (VB_BUTTON_SIZE * (row - 1) + VB_DRAG_HANDLE)
   button:SetAttribute('showgrid', U1GetCfgValue and U1GetCfgValue("vbar", "showGrid") and 1 or 0)
   button:HookScript('OnAttributeChanged', ActionButton_UpdateFlash)
   button:SetWidth(VB_BUTTON_SIZE-2);
   button:SetHeight(VB_BUTTON_SIZE-2);
   button:SetScript('OnDragStart', VB_OnDragStart)
   button:SetPoint('TOPLEFT', left, top)
   applyMasque(button)
   button:Show()
   numpad:SetAttribute('addchild', button)
end

----------------------------------------------------------------------------------------------------

function VB_GetNumpad()
   local shape = VBar.shape
   local ddt = VBar.ddt
   local dft = VBar.dft
   local dst = VBar.dst
   if not shape then shape = 'hslot12' end
   if not ddt then ddt = '' end
   if not dft then dft = '' end
   if not dst then dst = '' end
   local numpad = VB_numpads[shape .. ddt .. dft .. dst]
   if numpad then return numpad end
   VB_CreateNumpad(shape, ddt, dft, dst)
   local numpad = VB_numpads[shape .. ddt .. dft .. dst]
   return numpad
end

----------------------------------------------------------------------------------------------------
function VB_SetState()
   local numpad = VB_GetNumpad()
   local keyboard = VB_KEYBOARDS[VBar.shape]
   local ddt = VBar.ddt
   local dft = VBar.dft
   local dst = VBar.dst

   for keynum, key in ipairs(keyboard) do
      local chosen = (key.type == ddt or key.type == dft or key.type == dst)
      if key.type == 'Numeric' or chosen then
         local name = VBar.shape .. ddt .. dft .. dst .. keynum
         local button = _G[name]

         VB_SetButtonActions(button, keynum)
      end
   end
end

----------------------------------------------------------------------------------------------------
function VB_ShowNumpad()
   local numpad = VB_GetNumpad()
   local keyboard = VB_KEYBOARDS[VBar.shape]
   local ddt = VBar.ddt
   local dft = VBar.dft
   local dst = VBar.dst
   ClearOverrideBindings(numpad)
   for keynum, key in ipairs(keyboard) do
      local chosen = (key.type == ddt or key.type == dft or key.type == dst)
      if key.type == 'Numeric' or chosen then
         local name = VBar.shape .. ddt .. dft .. dst .. keynum

         local label = (VBar.labels) and key.label or ''
         local button = _G[name]
         button.npb_pad = true
         button.npb_label = label
         VB_DisplayHotkey(button)

         SetOverrideBindingClick(numpad, false, key.binding, name)
         SetOverrideBindingClick(numpad, false, 'Shift-' .. key.binding, name)

      end
   end
   numpad:SetScale(VBar.size)
   numpad:ClearAllPoints()
   numpad:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', VBar.left, VBar.top)


   if not VBar.leftclicked or not VBar.rightclicked then
      VB_SetBackdrop(numpad) end

   if VBar.hidden then return end
   numpad:Show()
   VBar.disabled = false
end

----------------------------------------------------------------------------------------------------
function VB_HideNumpad()
   local numpad = VB_GetNumpad()
   ClearOverrideBindings(numpad)
   numpad:Hide()
   VBar.disabled = true
end

----------------------------------------------------------------------------------------------------
function VB_ShapeNumpad(shape)
   if UnitAffectingCombat('player') == 1 then return end
   if not VBar.shape or not VB_KEYBOARDS[VBar.shape] then
      VBar.shape = 'hslot12' end
   if not shape then
      shape = next(VB_KEYBOARDS, VBar.shape) end
   if not shape then
      shape = next(VB_KEYBOARDS, nil) end
   VB_HideNumpad()
   VBar.shape = shape
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_SizeNumpad(size)
   if UnitAffectingCombat('player') == 1 then return end
   if not VBar.size or not VB_SIZES[VBar.size] then
      VBar.size = 1 end
   if not size then
      size = VB_SIZES[VBar.size] end
   if not size then
      size = 1 end
   VBar.left = VBar.left * VBar.size / size
   VBar.top = VBar.top * VBar.size / size
   VBar.size = size
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_Toggleddt()
   if UnitAffectingCombat('player') == 1 then return end
   VB_HideNumpad()
   VBar.ddt = (VBar.ddt == 'ddt') and '' or 'ddt'
   if VBar.ddt == 'ddt' then
      UIErrorsFrame:AddMessage(VB_ENTER_UNBOUND, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME) end
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_Toggledft()
   if UnitAffectingCombat('player') == 1 then return end
   VB_HideNumpad()
   VBar.dft = (VBar.dft == 'dft') and '' or 'dft'
   if VBar.dft == 'dft' then
      UIErrorsFrame:AddMessage(VB_dft_UNBOUND, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME) end
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_Toggledst()
   if UnitAffectingCombat('player') == 1 then return end
   VB_HideNumpad()
   VBar.dst = (VBar.dst == 'dst') and '' or 'dst'
   if VBar.dst == 'dst' and VB_class == 'moonkin' then
      VB_Chat(VB_dst_TOPSLOTS) end
   if VBar.dst == 'dst' and (VB_class == 'druid') then
      VB_Chat(VB_dst_RIGHTSLOTS) end
   if VBar.dst == 'dst' then
      UIErrorsFrame:AddMessage(VB_dst_UNBOUND, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME) end
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_ToggleLabels()
   if UnitAffectingCombat('player') == 1 then return end
   VB_HideNumpad()
   VBar.labels = not VBar.labels
   VB_ShowNumpad()
end

----------------------------------------------------------------------------------------------------
function VB_ToggleStancebars()
   if UnitAffectingCombat('player') == 1 then return end
   local stances = VB_CLASS_STANCEBARS[VB_class]
   if not stances then VB_Chat(VB_STANCELESS_CLASS) return end
   VBar.stancebars = not VBar.stancebars
   VB_SetState()
   if VBar.stancebars then
      VB_Chat(VB_USING_STANCEBARS)
   else
      VB_Chat(VB_NOT_USING_STANCEBARS)
      if VB_class == 'moonkin' then VB_Chat(VB_MOONKIN_BAR) end
   end
end

----------------------------------------------------------------------------------------------------
function VB_Disable()
   if UnitAffectingCombat('player') == 1 then return end
   VB_HideNumpad()
   VB_Chat(VB_DISABLED)
end

----------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD",Update) 
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("UNIT_TARGET",Update) 
f:SetScript("OnEvent",function(self, event, ...) 
   local InCombat, Target = InCombatLockdown(),UnitExists("target")
    if f == "PLAYER_REGEN_ENABLED" or (not InCombat and not Target) then 
		--VB_Hide()
	end
    if f == "PLAYER_ENTERING_WORLD" then 
		--VB_Hide() 
   end 
   if f == "PLAYER_REGEN_DISABLED"  or (not InCombat and Target) then 
	VB_Show()
	end 
end)
	
	
function VB_Hide()
   local numpad = VB_GetNumpad()
   numpad:Hide()
   VBar.hidden = true
   VB_Chat("VBar已经隐藏, 输入/vbar重新显示");
 --  VB_Chat(VB_HIDDEN)
end

function VB_Show()
   local numpad = VB_GetNumpad()
   VBar.hidden = false
   numpad:Show()
end

----------------------------------------------------------------------------------------------------

function VB_SetBackdrop(frame)
   VB_backdrop = true
   frame:SetBackdrop(VB_BACKDROP)
end

function VB_ClearBackdrop(frame)
   VB_backdrop = false
   frame:SetBackdrop(nil)
end

function VB_ToggleBackdrop(frame)
   if not VB_backdrop then
      VB_SetBackdrop(frame)
   else
      VB_ClearBackdrop(frame)
   end
end

----------------------------------------------------------------------------------------------------

function VB_InitializeMenu()
   local s = VBar.shape
   local menu = {
      { text = VB_MENU.hslot12, func = VBM_hslot12, checked = (s == 'hslot12') },
      { text = VB_MENU.gslot12, func = VBM_gslot12, checked = (s == 'gslot12') },
      { text = VB_MENU.hslot6, func = VBM_hslot6, checked = (s == 'hslot6') },
      { text = VB_MENU.zfslot9, func = VBM_zfslot9, checked = (s == 'zfslot9') },
      { text = VB_MENU.zfslot12, func = VBM_zfslot12, checked = (s == 'zfslot12') },
      { text = VB_MENU.sslot12, func = VBM_sslot12, checked = (s == 'sslot12') },
      { text = VB_MENU.large, func = VBM_large, checked = (VBar.size == 1) },
      { text = VB_MENU.medium, func = VBM_medium, checked = (VBar.size == .8) },
      { text = VB_MENU.small, func = VBM_small, checked = (VBar.size == .67) },
      { text = VB_MENU.dft, func = VBM_dft, checked = (VBar.dft == 'dft') },
      { text = VB_MENU.dst, func = VBM_dst, checked = (VBar.dst == 'dst') },
      { text = VB_MENU.ddt, func = VBM_ddt, checked = (VBar.ddt == 'ddt') },
      { text = VB_MENU.labels, func = VBM_labels, checked = VBar.labels },
      { text = VB_MENU.stancebars, func = VBM_stancebars, checked = VBar.stancebars },
      { text = VB_MENU.hide, func = VBM_hide },
   }
   for ix in ipairs(menu) do
      UIDropDownMenu_AddButton(menu[ix])
   end
end

function VB_ToggleMenu()
   ToggleDropDownMenu(1, nil, VB_MenuFrame, 'cursor')
end

function VB_DoneMenu()
   if UnitAffectingCombat('player') == 1 then return end
   local numpad = VB_GetNumpad()
   VB_ClearBackdrop(numpad)
end

function VBM_hslot12()    VB_ShapeNumpad('hslot12'); VB_DoneMenu(); end
function VBM_gslot12()     VB_ShapeNumpad('gslot12'); VB_DoneMenu(); end
function VBM_hslot6() VB_ShapeNumpad('hslot6'); VB_DoneMenu(); end
function VBM_zfslot12()      VB_ShapeNumpad('zfslot12'); VB_DoneMenu(); end
function VBM_zfslot9()      VB_ShapeNumpad('zfslot9'); VB_DoneMenu(); end
function VBM_sslot12()  VB_ShapeNumpad('sslot12'); VB_DoneMenu(); end
function VBM_large()      VB_SizeNumpad(1); VB_DoneMenu(); end
function VBM_medium()     VB_SizeNumpad(.8); VB_DoneMenu(); end
function VBM_small()      VB_SizeNumpad(.67); VB_DoneMenu(); end
function VBM_dft()      VB_Toggledft(); VB_DoneMenu(); end
function VBM_dst()        VB_Toggledst(); VB_DoneMenu(); end
function VBM_ddt()      VB_Toggleddt(); VB_DoneMenu(); end
function VBM_labels()     VB_ToggleLabels(); VB_DoneMenu(); end
function VBM_stancebars() VB_ToggleStancebars(); VB_DoneMenu(); end
function VBM_hide()       VB_Hide(); VB_DoneMenu(); end
function VB_Help() VB_Chat("show, hide, slots, reset") end