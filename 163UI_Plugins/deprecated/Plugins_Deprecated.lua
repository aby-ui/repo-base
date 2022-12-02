--[[------------------------------------------------------------
群星庭院助手
作者 bitingsock https://mods.curse.com/addons/wow/256918-court-of-stars-helper
---------------------------------------------------------------]]
local npccheck = {}
local NoMore = false
local tarIndex = 1
local function CoShelper(tooltip)
	if NoMore then
		if IsShiftKeyDown() ~= true then
			NoMore = false
		end
		return
	end
	local mapid,_ = C_Map.GetBestMapForUnit("player")
	local _,unit = tooltip:GetUnit()
	if unit == nil then return; end;
	if mapid == 761 and UnitGUID(unit) then
		local npcid = string.sub(UnitGUID(unit),-17,-12)
		local line = ""
		if npcid == "105117" then line = "炼金,潜行者 [下毒]" --Flask of the Solemn Night
		elseif npcid == "105157" then line = "工程,地精,侏儒 [关闭构造体]" --Arcane Power Conduit
		elseif npcid == "106110" then line = "萨满,剥皮,铭文 [移动速度]" --Waterlogged Scroll
		elseif npcid == "105160" then line = "恶魔猎手,术士,牧师 [暴击]" --Fel Orb
		elseif npcid == "105340" then line = "德鲁伊,采药 [急速]" --Umbral Bloom
		elseif npcid == "106018" then line = "盗贼,战士,制皮 [引小BOSS]" --Bazaar Goods
		elseif npcid == "106112" then line = "治疗,裁缝,急救 [引小BOSS]" --Wounded Nightborne Civilian
		elseif npcid == "106113" then line = "珠宝,采矿 [引小BOSS]" --Lifesized Nightborne Statue
		elseif npcid == "105831" then line = "圣骑,牧师 [减伤]" --Infernal Tome
		elseif npcid == "105249" then line = "烹饪800,熊猫人 [提升血量]" --Nightshade Refreshments
		elseif npcid == "105215" then line = "猎人,锻造 [引小BOSS并直接杀死]" --Discarded Junk
		elseif npcid == "106024" then line = "法师,附魔,精灵 [增加伤害]" --Magical Lantern
		elseif npcid == "106108" then line = "死骑,武僧 [回复能力]" -- Starlight Rose Brew
		else return
		end
		tooltip:AddLine("爱不易: "..line, 255/255, 106/255, 0/255, true)
		if npccheck[npcid] == nil then
			npccheck[npcid] = true
		end
		if npccheck[npcid] or IsShiftKeyDown() then
			SendChatMessage("【爱不易】"..GetUnitName(unit)..": "..line ,"PARTY" ,nil ,"1");
			SetRaidTarget(unit, tarIndex)
			tarIndex=tarIndex+1
			if tarIndex == 9 then tarIndex = 1 end;
			npccheck[npcid] = false
			NoMore = true
		end
	end
end
GameTooltip:HookScript("OnTooltipSetUnit", CoShelper)

--[[------------------------------------------------------------
转团提醒
---------------------------------------------------------------]]
function U1IsDoingWorldQuest()
    if not WORLD_QUEST_TRACKER_MODULE or not WORLD_QUEST_TRACKER_MODULE.usedBlocks then return end
    local count = 0
    for k,v in pairs(WORLD_QUEST_TRACKER_MODULE.usedBlocks) do
        count = count + 1
    end
    if count > GetNumWorldQuestWatches() then
        return true
    end
end

CoreOnEvent("CHAT_MSG_SYSTEM", function(event, msg)
    if msg == ERR_PARTY_CONVERTED_TO_RAID and not IsInInstance() and U1IsDoingWorldQuest() then
        if DBM and not U1DBMAlert then
            U1DBMAlert = DBM:NewMod("U1DBMAlert")
            DBM:GetModLocalization("U1DBMAlert"):SetGeneralLocalization{ name = "爱不易" }
            U1DBMAlert.warn = U1DBMAlert:NewSpecialWarning("%s") --:NewAnnounce("%s", 1, "Interface\\Icons\\Spell_Nature_WispSplode")
        end
        local leader
        for i=1, 40 do
            local unit = "raid" .. i
            if UnitIsGroupLeader(unit) then
                if UnitIsUnit(unit, "player") then
                    leader = 0
                else
                    local name, server = UnitName(unit)
                    server = server ~= "" and server or GetRealmName()
                    leader = name .. "-" .. server
                end
            end
        end
        if leader and leader ~= 0 then
            if U1DBMAlert then
                U1DBMAlert.warn:Show(ERR_PARTY_CONVERTED_TO_RAID)
                if leader then U1DBMAlert.warn:Show("团长：" .. leader) end
            else
                UIErrorsFrame:AddMessage("团长：" .. leader, 1, 0.5, 0)
                UIErrorsFrame:AddMessage(ERR_PARTY_CONVERTED_TO_RAID, 1, 0.5, 0)
            end
            SendChatMessage("【爱不易】转团提醒，团长：" .. leader, "RAID")
        end
    end
end)

--[[------------------------------------------------------------
达萨罗之战种族转换, 一直不怎么完善
---------------------------------------------------------------]]
do
    --GetSpellSubtext(7744)
    local racial = {
        7744, --亡灵意志
        69179, --奥术洪流
        26297, --巨魔
        33697, --兽人
        20549, --牛头人
        69070, --火箭跳 --69041, --火箭腰带
        274738, --先祖召唤 玛格汉兽人
        255654, --至高岭 蛮牛冲撞
        260364, --夜之子

        20594, --矮人石像
        58984, --暗夜精灵
        28880, --德莱尼
        265221, --黑铁矮人
        59752, --自利
        20589, --侏儒逃脱
        256948, --虚空精灵
        255647, --光铸
        68992, --狼人
    }
    for _, id in ipairs(racial) do racial[GetSpellInfo(id)] = true end --racial["炽天使"] = true
    local pattern = "^" .. string.format(ERR_LEARN_SPELL_S, "(.+)") .. "$" --"你学会新的法术：%s"
    CoreOnEvent("CHAT_MSG_SYSTEM", function(event, msg)
        if not U1GetCfgValue(addonName, 'AutoSwapRacial') then return end
        local _, _, link = msg:find(pattern)
        if link then
            local _, _, id, name = link:find("\124Hspell:(%d+).-\124h%[(.-)%]\124h")
            if id and name and racial[name] then
                for i=1, 120 do
                    local type, oldid = GetActionInfo(i)
                    if type == "spell" then
                        local oldname = GetSpellInfo(oldid)
                        if racial[oldname] and name ~= oldname then
                            local replace
                            replace = function()
                                id = tonumber(id)
                                PickupSpell(id)
                                PlaceAction(i)
                                if select(4, GetCursorInfo()) == id then
                                    return C_Timer.After(0.3, replace)
                                end
                                ClearCursor()
                                U1Message("已自动将动作条上的"..(GetSpellLink(oldid)).."替换为"..link)
                            end
                            C_Timer.After(0.3, replace)
                            break
                        end
                    end
                end
            end
        end
    end)
end

--[[------------------------------------------------------------
丰灵头
---------------------------------------------------------------]]
do
    local items = {166796, 166798, 166797, 166799, 166800, 166801 } for i, v in ipairs(items) do items[v] = true end
    local pattern = "^" .. string.format(LOOT_ITEM_PUSHED_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
    CoreOnEvent("CHAT_MSG_LOOT", function(event, msg)
        local _, _, link = msg:find(pattern)
        local itemId = link and select(3, link:find("\124Hitem:(%d+):"))
        itemId = itemId and tonumber(itemId)
        if itemId and items[itemId] then
            for i=1, 120 do
                local type, id = GetActionInfo(i)
                if type == "item" and items[id] then
                    PickupItem(itemId)
                    PlaceAction(i)
                    ClearCursor()
                    U1Message("已自动将动作条上的"..(select(2, GetItemInfo(id))).."替换为"..link)
                    break
                end
            end
        end
    end)
end

--[[------------------------------------------------------------
项链特质鼠标中键点击查看
---------------------------------------------------------------]]
CoreDependCall("Blizzard_AzeriteEssenceUI", function()
    if AzeriteEssenceUI and AzeriteEssenceUI.EssenceList and AzeriteEssenceUI.EssenceList.buttons then
        for _, btn in ipairs(AzeriteEssenceUI.EssenceList.buttons) do
            btn:HookScript("OnEnter", function(self)
                self._abyuiNext = 0
                GameTooltip:AddLine("中键点击查看下一级(爱不易提供)", 0, 1, 0)
                GameTooltip:Show()
            end)
            btn:HookScript("OnClick", function(self, button)
                if button == "MiddleButton" then
                    btn._abyuiNext = (btn._abyuiNext or 0) + 1
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    GameTooltip:SetAzeriteEssence(self.essenceID, (self.rank + btn._abyuiNext) % 4 );
                    GameTooltip:AddLine("中键点击查看下一级(爱不易提供)", 0, 1, 0)
                    GameTooltip:Show();
                end
            end)
            btn:RegisterForClicks("AnyUp")
        end
    end
end)