mg_EUF_Options = mg_EUF_Options or {}
FOCUSFRAME_TITLE = "Focus";
FOCUSFRAME_DRAG = "Drag to move";
FOCUSFRAME_DRAG_LOCKED = "Use /focusframe unlock to move.";
if GetLocale() == "zhCN" then
  FOCUSFRAME_TITLE = "焦点目标"
  FOCUSFRAME_DRAG = "按住鼠标左键拖动来移动框体"
  FOCUSFRAME_DRAG_LOCKED = "使用 /focusframe unlock"
elseif GetLocale() == "zhTW" then
  FOCUSFRAME_TITLE = "焦點目標"
  FOCUSFRAME_DRAG = "按住滑鼠左鍵拖動來移動框體"
  FOCUSFRAME_DRAG_LOCKED = "使用 /focusframe unlock"
end
function MGFocusFrame_OnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
  if (not mg_EUF_Options.lockpos) then
    GameTooltip:SetText(FOCUSFRAME_DRAG, nil, nil, nil, nil, 1);
  else
    GameTooltip:SetText(FOCUSFRAME_DRAG_LOCKED, nil, nil, nil, nil, 1);
  end
end

function MGFocusFrame_SavePos()
  local point, relativeTo, relativePoint, xOfs, yOfs = FocusFrame:GetPoint(1);
  mg_EUF_Options.scale = FocusFrame:GetScale();
  mg_EUF_Options.point = point;
  mg_EUF_Options.relativePoint = relativePoint;
  mg_EUF_Options.yOfs = yOfs;
  mg_EUF_Options.xOfs = xOfs;
end
function MGFocusFrame_OnDragStart(self)
  if (not mg_EUF_Options.lockpos) then
    self:GetParent():StartMoving();
    self.isMoving = true;
  end
end

function MGFocusFrame_OnDragStop(self)
  self:GetParent():StopMovingOrSizing();
  self.isMoving = false;
  MGFocusFrame_SavePos();
end
FocusFrame:HookScript("OnDragStop", MGFocusFrame_SavePos)
function MGFocusSetPoint()
	FocusFrame:ClearAllPoints()
	if mg_EUF_Options.point and mg_EUF_Options.relativePoint and mg_EUF_Options.xOfs and mg_EUF_Options.yOfs then
		FocusFrame:SetScale(mg_EUF_Options.scale);
		FocusFrame:SetPoint(mg_EUF_Options.point,UIParent, mg_EUF_Options.relativePoint,mg_EUF_Options.xOfs, mg_EUF_Options.yOfs);
	else
		FocusFrame:SetPoint("TOP",UIParent,"TOP",50,-30)
	end
	--FOCUS_FRAME_LOCKED = false
end
local f= CreateFrame'Frame'
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent",MGFocusSetPoint)

local f2=_G["TargetFrame"]
f2:SetAttribute("shift-type2","macro")
f2:SetAttribute("shift-type1","macro")
f2:SetAttribute("*macrotext2","/clearfocus")
f2:SetAttribute("*macrotext1","/focus")