local AppName = ...
local AL = LibStub("AceLocale-3.0")
local L = AL:NewLocale(AppName, "enUS", true)

L["focus"] = "Focus"
L["mouseover"] = "Mouseover"
L["pet"] = "Pet"
L["playertarget"] = "Target"
L["arena%d"]="Arena%d"
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55fControl + Left Click|r to lock frames"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fDrag|r to move the frame"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fLeft Click|r to lock/unlock frames"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + Left Click|r to toggle sound"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fRight Click|r to open the configuration window"

-----------------------------------------------------------------------------

L = AL:NewLocale(AppName, "deDE")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55fStrg + Linksklick|r, um die Rahmen zu sperren"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fZiehen|r, um den Rahmen zu verschieben"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55fLinksklick|r, um die Rahmen fest- und freizusetzen"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fRechtsklick|r, um das Konfigurationsfenster zu öffnen"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + Linksklick|r, um das Audiosignal zu ein- und auszuschalten."
L["focus"] = "Fokus"
L["mouseover"] = "Mouseover"
L["pet"] = "Begleiter"
L["playertarget"] = "Ziel"

end

L = AL:NewLocale(AppName, "esES")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = " |cffeda55fControl + Clic Izquierdo|r para bloquear los marcos"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fArrastrar|r para mover el marco"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = " |cffeda55fClic Izquierdo|r para bloquear/desbloquear los marcos"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55fClic Derecho|r para abrir la ventana de configuración"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + boton Izquierdo|r para activar/desactivar sonido"
L["focus"] = "Foco"
L["mouseover"] = "Sobre el raton"
L["pet"] = "Mascota"
L["playertarget"] = "Objetivo"

end

L = AL:NewLocale(AppName, "esMX")
if L then

end

L = AL:NewLocale(AppName, "frFR")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = " |cffeda55fCtrl + Clic gauche|r pour verrouiller"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55fDrag|r pour déplacer"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = " |cffeda55fClic gauche|r pour verrouiller/déverrouiller les frames"
L["|cffeda55fRight Click|r to open the configuration window"] = " |cffeda55fClic droit|r pour ouvrir la fenêtre de configuration"
L["|cffeda55fShift + Left Click|r to toggle sound"] = " |cffeda55fShift + Clic gauche|r pour activer/désactiver le son"
L["focus"] = "Focus"
L["mouseover"] = "Mouseover"
L["pet"] = "Familier"
L["playertarget"] = "Cible"

end

L = AL:NewLocale(AppName, "koKR")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55fCtrl + 클릭|r 창 잠그기"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f끌기|r 프레임 이동"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f클릭|r 창 잠금/해제"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f오른쪽 클릭|r 설정 창 열기"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + 클릭|r 소리 전환"
L["focus"] = "주시 대상"
L["mouseover"] = "마우스오버"
L["pet"] = "소환수"
L["playertarget"] = "대상"

end

L = AL:NewLocale(AppName, "ruRU")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55f[Control + Щелчок левой кнопкой]|r закрепляет фреймы"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f[Двигайте]|r для перемещения окна"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f[Щелчок левой кнопкой]|r закрепляет/освобождает фреймы"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f[Щелчок правой кнопкой]|r открывает окно настроек"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + Щелчок левой кнопкой|r — переключить звук"
L["focus"] = "Фокус"
L["mouseover"] = "Наведение курсора"
L["pet"] = "Питомец"
L["playertarget"] = "Цель"

end

L = AL:NewLocale(AppName, "zhCN")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55fCtrl+点击|r锁定所有框架"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f拖拽|r 移动位置"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f点击|r锁定/解锁框架"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f右击|r打开设置窗口"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + 左键点击|r 来开启/关闭音效"
L["focus"] = "焦点"
L["mouseover"] = "鼠标悬停"
L["pet"] = "宠物"
L["playertarget"] = "目标"

end

L = AL:NewLocale(AppName, "zhTW")
if L then
L["|cffeda55fControl + Left Click|r to lock frames"] = "|cffeda55fCtrl+左鍵|r 鎖定所有框架"
L["|cffeda55fDrag|r to move the frame"] = "|cffeda55f拖拽|r 移動位置"
L["|cffeda55fLeft Click|r to lock/unlock frames"] = "|cffeda55f左鍵|r 鎖定/解鎖框架"
L["|cffeda55fRight Click|r to open the configuration window"] = "|cffeda55f右鍵|r 開啟設定視窗"
L["|cffeda55fShift + Left Click|r to toggle sound"] = "|cffeda55fShift + 左鍵|r 切換音效"
L["focus"] = "專注目標"
L["mouseover"] = "滑鼠目標"
L["pet"] = "寵物"
L["playertarget"] = "目標"

end

