local O = tdDropDown_Option

O.Mail = true		-- 开启/关闭收件人列表			(true:开启  nil:关闭)
O.AH   = true		-- 开启/关闭拍卖行收藏列表		(true:开启  nil:关闭)
O.Trade = true
O.Search  = true	-- 开启/关闭拍卖行列表选择后即搜索	(true:开启  nil:关闭)
O.Menu = true		-- 列表边框设置				(true:圆角  nil:默认)
--O.Glyph = true      -- 雕纹搜索框
O.EJ = true         -- 地下城搜索框
O.Friends = true    -- 好友状态广播
O.Achieve = true
O.MAX = 25


--[[
使用下面的函数给输入框创建下拉列表

先定义一个表:
local table = {
	profile = "BrowseName",		-- 输入框的名称(必须)
	event = "VARIABLES_LOADED",	-- 激活事件(可选, 默认为事件:VARIABLES_LOADED)
	short = true,			-- 是否减少输入框宽度(可选)
	move = nil,			-- 输入框是否向左移一些
	func = function()
		return arg1 == "Blizzard_AuctionUI"
	end,				-- 验证函数(可选)
	click = function()
		AuctionFrameBrowse_Search()
	end,				-- 选择列表后执行(可选),例中可让拍卖行列表选择后即搜索
}
再使用下面语句即可:
tdCreateDropDown(table)
]]

------ create dropdown
local mail = {}
function tdHookSendMail(recipient, subject, body) tdInsertValueIfNotExist("SendMailNameEditBox", recipient); end
mail.hook = function() hooksecurefunc("SendMail", function(...) tdHookSendMail(...) end) end
mail.profile = "SendMailNameEditBox"
mail.over = true

local ah = {}
ah.profile = "BrowseName"
ah.event = "ADDON_LOADED"
ah.short = true
function tdHookAuctionSearch(...) if AuctionHouseFrame.SearchBar.SearchBox:IsVisible() then tdInsertValueIfNotExist("BrowseName", AuctionHouseFrame.SearchBar.SearchBox:GetText()); end end
ah.hook = function()
    hooksecurefunc(AuctionHouseFrame.SearchBar, "StartSearch", function(...) tdHookAuctionSearch(...) end)
end
ah.func = function(arg1) return arg1 == "Blizzard_AuctionHouseUI" end
ah.click = O.Search and function() AuctionHouseFrame.SearchBar:StartSearch() end

local trade = {}
trade.profile = "TradeSkillFrame.SearchBox"
trade.event = "ADDON_LOADED"
trade.short = true
trade.func = function(arg1) return arg1 == "Blizzard_TradeSkillUI" end

--[[local glyph = {}
glyph.profile = "GlyphFrameSearchBox"
glyph.event = "ADDON_LOADED"
glyph.over = true
glyph.func = function(arg1) return arg1 == "Blizzard_GlyphUI" end]]

local ej = {}
ej.profile = "EncounterJournalSearchBox"
ej.event = "ADDON_LOADED"
ej.func = function(arg1) return arg1 == "Blizzard_EncounterJournal" end
ej.short = true
ej.hook = function()
    local point, relativeTo, relativePoint, xOffset, yOffset = EncounterJournalSearchBox:GetPoint()
    EncounterJournalSearchBox:SetPoint(point, relativeTo, relativePoint, xOffset-19, yOffset)
    EncounterJournalSearchBox:SetWidth(EncounterJournalSearchBox:GetWidth()-19)
end
ej.click = function() RunOnNextFrame(function()
    if EncounterJournalSearchBoxSearchButton1 and EncounterJournalSearchBoxSearchButton1:IsVisible() then EncounterJournalSearchBoxSearchButton1:Click() end
end) end

local friends = {}
friends.profile = "FriendsFrameBroadcastInput"
friends.short = true
friends.click = function() FriendsFrameBroadcastInput_OnEnterPressed(FriendsFrameBroadcastInput) end

local achieve = {}
achieve.profile = "AchievementFrame.searchBox"
achieve.event = "ADDON_LOADED"
achieve.short = true
achieve.func = function(arg1) return arg1 == "Blizzard_AchievementUI" end
--WardrobeCollectionFrameSearchBox HeirloomsJournalSearchBox ToyBox.searchBox PetJournalSearchBox RematchPetPanel MountJournalSearchBox

if false and U1_FRAME_NAME then
    local u1addon = {}
    u1addon.profile = U1_FRAME_NAME.."AddonSearchBox"
    u1addon.move = true
    tdCreateDropDown(u1addon)
end

if O.Mail then  tdCreateDropDown(mail) end
if O.AH then tdCreateDropDown(ah) end
if O.Trade then tdCreateDropDown(trade) end
--if O.Glyph then tdCreateDropDown(glyph) end
if O.EJ then tdCreateDropDown(ej) end
if O.Friends then tdCreateDropDown(friends) end
if O.Achieve then tdCreateDropDown(achieve) end
