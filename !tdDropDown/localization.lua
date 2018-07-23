
tdDropDown_Locale = {}
tdDropDown_Option = {}

local L = tdDropDown_Locale

local locale = GetLocale()
if locale == "zhCN" then
	L.Add = "|cff00ff00添加选项: |r%s"
	L.Del = "|cffff0000删除选项: |r%s"
    L.DelAll = "|cffff0000删除全部选项!|r"
	L.Search = "搜索"
	L.Next = "下一页"
	L.Num = "列表增强：已记录|cff00ff00%d|r条。"
	L.ShowList = "<左键> 打开列表"
	L.ClearInput = "<右键> 清空文字"
elseif locale == "zhTW" then
	L.Add = "|cff00ff00添加: |r%s" 
	L.Del = "|cffff0000刪除: |r%s" 
    L.DelAll = "|cffff0000刪除全部選項!|r"
	L.Search = "搜索"
	L.Next = "下一頁" 
	L.Num = "列表中共有|cff00ff00%d|r條記錄。" 
	L.ShowList = "<左鍵> 打開列表" 
	L.ClearInput = "<右鍵> 清空文字"
else
	L.Add = "|cff00ff00Add: |r%s"
	L.Del = "|cffff0000Del: |r%s"
    L.DelAll = "|cffff0000Delete All!|r"
	L.Search = "Search"
	L.Next = "Next Page"
	L.Num = "List number: |cff00ff00%d|r"
	L.ShowList = "<Left Button> Open List"
	L.ClearInput = "<Right Button> Clear Text"
end