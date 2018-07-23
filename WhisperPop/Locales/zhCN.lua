------------------------------------------------------------
-- zhCN.lua
--
-- 简体中文本地化文件
--
-- Abin
-- 2015-08-26
------------------------------------------------------------

if GetLocale() ~= "zhCN" then return end

local _, addon = ...

addon.L = {
	["title"] = "WhisperPop",
	["desc"] = "显示角色发送与接收到的密语聊天消息，并且将聊天记录跨角色保存。",
	["no new messages"] = "没有未阅读消息",
	["new messages from"] = "未阅读消息来自: ",
	["receive only"] = "仅显示接收到的消息",
	["toggle frame"] = "打开/关闭WhisperPop框体",
	["general options"] = "一般选项",
	["sound notify"] = "启用声音提示",
	["timestamp"] = "显示时间戳",
	["save messages"] = "保存聊天记录",
	["show realms"] = "显示服务器名称后缀",
	["foreign realms"] = "仅不同服时显示",
	["clear all"] = "清空聊天",
	["clear all confirm"] = "即将永久删除所有未保护的消息记录，你确定吗？",
	["settings tooltip 1"] = "|cff00ff00点击：|r打开设置窗口",
	["settings tooltip 2"] = "|cff00ff00Shift-点击：|r清空所有已保存的聊天记录",
	["show notify button"] = "显示屏幕提示按钮",
	["delete player records"] = "删除所有来自|cff00ff00%s|r的记录",
	["filter settings"] = "过滤设置",
	["ignore tag messages"] = "不保存标签类消息（以 |cff00ff00<|r 或 |cff00ff00[|r 开头的）",
	["apply third-party filters"] = "继承第三方插件过滤器",
	["frame settings"] = "窗体设置",
	["button scale"] = "按钮缩放",
	["list scale"] = "列表缩放",
	["list width"] = "列表宽度",
	["list height"] = "列表高度",
	["reset frames"] = "重置窗体",
	["reset frames confirm"] = "将WhisperPop窗体的尺寸与位置恢复到初始值，你确定吗？",
	["protected"] = "已保护",
	["cannot delete protected"] = "与|cffff0000%s|r的聊天记录已被保护，请先解除保护后再删除。",
}