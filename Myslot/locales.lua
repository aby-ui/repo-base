local _, MySlot = ...

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})


MySlot.L = L

--
-- Use http://www.wowace.com/addons/myslot/localization/ to translate thanks
-- 
local locale = GetLocale()

if locale == 'enUs' then
L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = true
L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = true
L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = true
L["All slots were restored"] = true
L["Are you SURE to import ?"] = true
L["Bad importing text [CRC32]"] = true
L["Bad importing text [TEXT]"] = true
L["Close"] = true
L["Export"] = true
L["Feedback"] = true
L["Ignore unactived pet[id=%s], %s"] = true
L["Ignore unlearned skill [id=%s], %s"] = true
L["Import"] = true
L["Import is not allowed when you are in combat"] = true
L["Importing text [ver:%s] is not compatible with current version"] = true
L["Macro %s was ignored, check if there is enough space to create"] = true
L["Time"] = true
L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"
L["Use random mount instead of an unactived mount"] = true

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
L["Are you SURE to import ?"] = "Bist du sicher, dass du importieren möchtest?"
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
L["Close"] = "Schließen"
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
L["Feedback"] = "Rückmeldung"
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"--]] 
--[[Translation missing --]]
--[[ L["All slots were restored"] = "All slots were restored"--]] 
--[[Translation missing --]]
--[[ L["Are you SURE to import ?"] = "Are you SURE to import ?"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [CRC32]"] = "Bad importing text [CRC32]"--]] 
--[[Translation missing --]]
--[[ L["Bad importing text [TEXT]"] = "Bad importing text [TEXT]"--]] 
--[[Translation missing --]]
--[[ L["Close"] = "Close"--]] 
--[[Translation missing --]]
--[[ L["Export"] = "Export"--]] 
--[[Translation missing --]]
--[[ L["Feedback"] = "Feedback"--]] 
--[[Translation missing --]]
--[[ L["Ignore unactived pet[id=%s], %s"] = "Ignore unactived pet[id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Ignore unlearned skill [id=%s], %s"] = "Ignore unlearned skill [id=%s], %s"--]] 
--[[Translation missing --]]
--[[ L["Import"] = "Import"--]] 
--[[Translation missing --]]
--[[ L["Import is not allowed when you are in combat"] = "Import is not allowed when you are in combat"--]] 
--[[Translation missing --]]
--[[ L["Importing text [ver:%s] is not compatible with current version"] = "Importing text [ver:%s] is not compatible with current version"--]] 
--[[Translation missing --]]
--[[ L["Macro %s was ignored, check if there is enough space to create"] = "Macro %s was ignored, check if there is enough space to create"--]] 
--[[Translation missing --]]
--[[ L["Time"] = "Time"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Myslot is for transferring settings between accounts. Feedback farmer1992@gmail.com"--]] 
--[[Translation missing --]]
--[[ L["Use random mount instead of an unactived mount"] = "Use random mount instead of an unactived mount"--]] 

elseif locale == 'zhCN' then
L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] 忽略出错技能 DEBUG INFO = [S=%s T=%s I=%s] 请将出错的字符和 DEBUG INFO 发给作者 %s"
L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] 忽略不支持的按键绑定 [ %s ]，请通知作者 %s"
L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] 忽略不支持的按键类型 [ %s ]，请通知作者 %s"
L["All slots were restored"] = "所有按钮及按键邦定位置恢复完毕"
L["Are you SURE to import ?"] = "你确定要导入吗？"
L["Bad importing text [CRC32]"] = "导入字符码校验不合法 [CRC32]"
L["Bad importing text [TEXT]"] = "导入字符不合法 [TEXT]"
L["Close"] = "关闭"
L["Export"] = "导出"
L["Feedback"] = "问题/建议"
L["Ignore unactived pet[id=%s], %s"] = "忽略未开启的战斗宠物[id=%s]：%s"
L["Ignore unlearned skill [id=%s], %s"] = "忽略未掌握技能[id=%s]：%s"
L["Import"] = "导入"
L["Import is not allowed when you are in combat"] = "请在非战斗时候使用导入功能"
L["Importing text [ver:%s] is not compatible with current version"] = "导入字串 [ver:%s] 不兼容当前版本"
L["Macro %s was ignored, check if there is enough space to create"] = "宏 [ %s ] 被忽略，请检查是否有足够的空格创建宏"
L["Time"] = "时间"
L["TOC_NOTES"] = "保存你的技能按钮位置。反馈：farmer1992@gmail.com"
L["Use random mount instead of an unactived mount"] = "使用随机坐骑代替没有的坐骑"

elseif locale == 'zhTW' then
L["[WARN] Ignore slot due to an unknown error DEBUG INFO = [S=%s T=%s I=%s] Please send Importing Text and DEBUG INFO to %s"] = "[WARN] 忽略出錯的欄位：DEBUG INFO = [S=%s T=%s I=%s] 請將出錯的字串與DEBUG INFO發給作者 %s。"
L["[WARN] Ignore unsupported Key Binding [ %s ] , contact %s please"] = "[WARN] 忽略不支援的按鍵設置：K = [ %s ] ，請通知作者 %s"
L["[WARN] Ignore unsupported Slot Type [ %s ] , contact %s please"] = "[WARN] 忽略不支援的欄位設置：K = [ %s ] ，請通知作者 %s"
L["All slots were restored"] = "所有按鍵設定都已恢復完畢"
L["Are you SURE to import ?"] = "你確定要導入嗎？"
L["Bad importing text [CRC32]"] = "錯誤的導入字串[CRC32]"
L["Bad importing text [TEXT]"] = "錯誤的導入字串[TEXT]"
L["Close"] = "關閉"
L["Export"] = "導出"
L["Feedback"] = "反饋"
L["Ignore unactived pet[id=%s], %s"] = "忽略沒有的寵物 [id=%s]：%s"
L["Ignore unlearned skill [id=%s], %s"] = "忽略未習得技能 [id=%s], %s"
L["Import"] = "導入"
L["Import is not allowed when you are in combat"] = "請在非戰鬥狀態時使用導入功能"
L["Importing text [ver:%s] is not compatible with current version"] = "導入的字串版本與當前版本不相容。(字串版本號：%s)"
L["Macro %s was ignored, check if there is enough space to create"] = "忽略巨集 [%s] ，請檢查是否有足夠的欄位創建新巨集"
L["Time"] = "時間"
L["TOC_NOTES"] = "Myslot可以跨帳號綁定技能與按鍵設置。反饋通道：farmer1992@gmail.com"
L["Use random mount instead of an unactived mount"] = "使用隨機座騎代替沒有的座騎"

end

