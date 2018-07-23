if U1IsAddonEnabled("Battle Pet Current Stats") then return end
--[[------------------------------------------------------------
## Title: Battle Pet Current Stats
## Notes: Displays the stats of battle pets in play during a pet battle.
## Notes-zhCN: 在默认的对战界面上显示双方当前激活宠物的攻击、速度和血量，以便做好预判。
## Author: Gello
## Version: 1.0.2 - 2016.8.13
---------------------------------------------------------------]]
local frame = CreateFrame("Frame")
frame.notSetUp = true
frame.texCoords = {Power={0,.5,0,.5}, Speed={0,.5,.5,1}, Health={.5,1,.5,1}}

-- PetBattleUI appears to load very early, but not guaranteed: check if loaded
-- at PLAYER_LOGIN to setup, and then watch for ADDON_LOADED until setup turns it off
frame:SetScript("OnEvent",function(self,event,...)
  if self.notSetUp and IsAddOnLoaded("Blizzard_PetBattleUI") then
    self:SetUpWidgets() -- runs once when PetBattleUI known to be loaded
  else
    self:UpdateWidgets() -- runs every other time (events registered in setup)
  end
end)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

-- sets up a icon+text widget
-- parent: PetBattleFrame.ActiveAlly or PetBattleFrame.ActiveEnemy
-- widgetType: "Health" "Power" or "Speed"
-- anchor: the corner of the parent to anchor the top of the widget's icon
-- xoff: x-offset from the anchor
function frame:CreateWidget(parent,widgetType,anchor,xoff)
  local widget = CreateFrame("Frame",nil,parent)
  widget:SetSize(15,15)
  widget.icon = widget:CreateTexture(nil,"OVERLAY")
  widget.icon:SetAllPoints(true)
  widget.icon:SetTexture("Interface\\PetBattles\\PetBattle-StatIcons")
  if frame.texCoords[widgetType] then
    widget.icon:SetTexCoord(unpack(frame.texCoords[widgetType]))
  end
  widget.text = widget:CreateFontString(nil,"ARTWORK")
  widget.text:SetFont("Interface\\AddOns\\163UI_Plugins\\7.0\\BattlePetCurrentStats_Aziti.ttf", 15, "")
  widget.text:SetPoint("LEFT",widget.icon,"RIGHT",1,0)
  widget:SetPoint("TOP",parent,anchor,xoff,-1)
  return widget
end

-- creates widgets and registers for events
function frame:SetUpWidgets()
  self.notSetUp = nil
  self.widgets = {}
  for i=1,2 do
    self.widgets[i] = {}
    local parent = i==1 and PetBattleFrame.ActiveAlly or PetBattleFrame.ActiveEnemy
    local anchor = i==1 and "BOTTOMRIGHT" or "BOTTOMLEFT"
    local offset = i==1 and -170 or 10
    self.widgets[i].Health = i==1 and self:CreateWidget(parent,"Health",anchor,offset+120) or self:CreateWidget(parent,"Health",anchor,offset+4)
    self.widgets[i].Power = i==1 and self:CreateWidget(parent,"Power",anchor,offset+60) or self:CreateWidget(parent,"Power",anchor,offset+80)
    self.widgets[i].Speed = i==1 and self:CreateWidget(parent,"Speed",anchor,offset+0) or self:CreateWidget(parent,"Speed",anchor,offset+138)
  end
  self:UnregisterEvent("ADDON_LOADED")
  self:RegisterEvent("PET_BATTLE_AURA_APPLIED")
  self:RegisterEvent("PET_BATTLE_AURA_CHANGED")
  self:RegisterEvent("PET_BATTLE_AURA_CANCELED")
  self:RegisterEvent("PET_BATTLE_HEALTH_CHANGED")
  self:RegisterEvent("PET_BATTLE_PET_CHANGED")
  self:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
end

-- updates both ally and enemy active pet stats
-- NOTE: the stat is the same as the one on the tooltip! It does NOT adjust
-- based on auras or pet type "racials" like flyer's speed over 50% life.
function frame:UpdateWidgets()
  for i=1,2 do
    local pet = C_PetBattles.GetActivePet(i)
    local health = C_PetBattles.GetHealth(i,pet)
    local maxHealth = C_PetBattles.GetMaxHealth(i,pet)
    self.widgets[i].Health.text:SetText(format("%.1f%%",health*100/maxHealth))
    self.widgets[i].Power.text:SetText(C_PetBattles.GetPower(i,pet))
    self.widgets[i].Speed.text:SetText(C_PetBattles.GetSpeed(i,pet))
  end
end
