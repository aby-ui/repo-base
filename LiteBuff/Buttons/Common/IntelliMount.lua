local _, LiteBuff = ...
local L = LiteBuff.L

local _, _, icon = GetSpellInfo(150544)

local button = LiteBuff:CreateActionButton('IntelliMount', '智能坐骑', nil, nil, 'DUAL')
button:SetFlyProtect('type1', 'macro', 'type2', 'macro')
button.icon:SetIcon(icon)

button.OnTooltipText =function(self, tooltip)
    GameTooltip:AddLine(L["left click"]..'智能坐骑', 1, 1, 1, 1)
    GameTooltip:AddLine(L["right click"]..'载客坐骑', 1, 1, 1, 1)
    GameTooltip:AddLine('中键: 水面坐骑', 1, 1, 1, 1)
    GameTooltip:AddLine("ALT-"..L["left click"]..'修理坐骑', 1, 1, 1, 1)
    GameTooltip:AddLine("ALT-"..L["right click"]..'水下坐骑', 1, 1, 1, 1)
    GameTooltip:AddLine("ALT-中键: 取消坐骑", 1, 1, 1, 1)
    GameTooltip:AddLine("CTL-"..L["left click"]..'地面坐骑', 1, 1, 1, 1)
end

button:SetAttribute('type1', 'macro')
button:SetAttribute('type2', 'macro')
button:SetAttribute('type3', 'macro')
button:SetAttribute('alt-type1', 'macro')
button:SetAttribute('alt-type2', 'macro')
button:SetAttribute('alt-type3', 'macro')
button:SetAttribute('ctrl-type1', 'macro')
button:SetAttribute('macrotext1', '/run LBIntelliMountSummon("normal")')
button:SetAttribute('macrotext2', '/run LBIntelliMountSummon("passenger")')
button:SetAttribute('macrotext3', '/run LBIntelliMountSummon("surface")')
button:SetAttribute('alt-macrotext1', '/run LBIntelliMountSummon("vendor")')
button:SetAttribute('alt-macrotext2', '/run LBIntelliMountSummon("underwater")')
button:SetAttribute('alt-macrotext3', select(2, UnitClass'player') == 'DRUID' and '/cancelform\n/dismount' or '/dismount')
button:SetAttribute('ctrl-macrotext1', '/run LBIntelliMountSummon("nofly")')

button:SetAttribute('dark_when_combat', "1")

button:SetAttribute('_onmouseup', [[
    self:ChildUpdate('onmouseup', '_onmouseup')
]])
button.OnMountStateChanged = function(self, mounted)
    self.status = mounted and "Y" or nil
    return self:UpdateStatus()
end
button:SetAttribute('_onstate-mountstate', [[
    self:CallMethod('OnMountStateChanged', newstate == 1)
]])
RegisterStateDriver(button, 'mountstate', '[mounted][flying] 1; 0')
button:SetAttribute('_onstate-combatstate', [[self:CallMethod('OnMountStateChanged', false)]])
RegisterStateDriver(button, 'combatstate', '[combat] 1; 0')

----------------------------------------------------------------
-- Code from IntelliMount/UtilityMounts.lua  by Abin 2014/10/21
----------------------------------------------------------------
local utilityMounts = {
    { id =  30174, underwater = 1 }, --乌龟
   	{ id =  60424, passenger = 1 }, --机械师的摩托车，联盟的
    { id =  55531, passenger = 1 }, --机械路霸，部落的
   	{ id =  61447, passenger = 1, vendor = 1 }, --旅行者猛犸
   	{ id =  61469, passenger = 1 }, --重型猛犸
    { id =  61467, passenger = 1 }, --重型黑色猛犸战象
   	{ id =  64731, underwater = 1 }, --海龟
   	{ id =  75973, passenger = 1 }, --火箭
   	{ id =  93326, passenger = 1 },  --砂石幼龙
   	{ id =  98718, underwater = 1 }, --驯服的海马
   	{ id = 118089, surface = 1 },  --天蓝水黾
   	{ id = 121820, passenger = 1 }, --黑曜夜之翼
   	{ id = 122708, passenger = 1, vendor = 1 }, --雄壮远足牦牛
   	{ id = 127271, surface = 1 }, --猩红水黾
   	--{ id = 179244, passenger = 1 }, --代驾型机械路霸，只能自己坐
    { id = 214791, underwater = 1 },  --深海喂食者
    { id = 223018, underwater = 1 },  --深海水母
    { id = 278979, underwater = 1 },  --拍浪水母
    { id = 253711, underwater = 1 },  --池塘水母
    { id = 228919, underwater = 1 },  --暗水鳐鱼
    { id = 278803, underwater = 1 },  --无尽之海鳐鱼
    { id = 245725, passenger = 1 }, --奥格瑞玛拦截飞艇
    { id = 245723, passenger = 1 }, --暴风城逐天战机


}
--[[获取方式
--/print MountJournal.selectedSpellID
for i=1,C_MountJournal.GetNumMounts() do
  local n,sId,_,_,_,_,_,_,_,_,_,mId=C_MountJournal.GetDisplayedMountInfo(i)
  if sId then
    local _,_,_,self,t = C_MountJournal.GetMountInfoExtraByID(mId)
    if(t~=230 and t~=248) or self then print(n, GetSpellLink(sId), t, self) end
  end
end]]

-- 早已失效
if select(2, UnitClass("player")) == "WARLOCK" then
	--tinsert(utilityMounts, { id = 5784, surface = 1 })
	--tinsert(utilityMounts, { id = 23161, surface = 1 })
end

local gotMountsData = false

local mountsData = {}
for _, v in ipairs(utilityMounts) do
    mountsData[v.id] = v
end

--登入及关闭坐骑收藏时触发
local function UpdateMountsData()
    local count = C_MountJournal.GetNumMounts()
    if count > 0 then gotMountsData = true end
    for i = 1, count do
        local creatureName, spellId, icon, active, summonable, source, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(i)
        if creatureName and not hideOnChar and isCollected then
            --收藏的特殊坐骑 - 会的特殊坐骑 - 普通坐骑
            if mountsData[spellId] or isFavorite then
                --之前已经存在的都是特殊坐骑, 新创建的是普通坐骑
                mountsData[spellId] = mountsData[spellId] or { normal = 1 }
                mountsData[spellId].owned = 1
                mountsData[spellId].favorite = isFavorite
                mountsData[spellId].index = i
                mountsData[spellId].mountID = mountID
                local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)
                --[[
                http://wow.gamepedia.com/API_C_MountJournal.GetMountInfoExtra
                230 for most ground mounts
                231 for  [Riding Turtle] and Sea Turtle
                232 for  [Vashj'ir Seahorse] (was named Abyssal Seahorse prior to Warlords of Draenor)
                241 for Blue, Green, Red, and Yellow Qiraji Battle Tank (restricted to use inside Temple of Ahn'Qiraj)
                242 for Swift Spectral Gryphon (hidden in the mount journal, used while dead in certain zones)
                247 for Red Flying Cloud
                248 for most flying mounts, including those that change capability based on riding skill
                254 for Subdued Seahorse
                269 for Azure and Crimson Water Strider 水黾
                284 for Chauffeured Mekgineer's Chopper and Chauffeured Mechano-Hog 机械路霸
                --]]
                --if(creatureName=="代驾型机械路霸")then print(creatureName, mountType, isFactionSpecific) end
                if(mountType==230 or mountType==269 or mountType==284)then
                    mountsData[spellId].groundOnly = 1
                end
            end
        end
    end
end

CoreDependCall("Blizzard_Collections", function()
    if CollectionsJournal then
        CollectionsJournal:HookScript("OnHide", UpdateMountsData)
    end
end)

CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    button.status = IsMounted() and "Y" or nil
    button:UpdateStatus()
    UpdateMountsData()
    return "REMOVE"
end)

local chosen = {}
local delay_timer
function LBIntelliMountSummon(utility, delay)
    if not gotMountsData then UpdateMountsData() end
    if IsFlying() then U1Message("正在飞行, 请珍惜生命……") return end
    --if IsMounted() then Dismount() return end
    local nofly = false
    if utility == "nofly" then
        nofly = true
        utility = "normal"
    end

    --游泳时自动判断是否使用飞行坐骑还是水面坐骑
    if not delay and IsSwimming() and utility=="normal" then
        if GetTime() - (delay_timer or 0) < 0.25 then
            CoreCancelBucket("IntelliMountDelay")
            utility = "surface"
        else
            utility = IsFlyableArea() and "normal" or "surface"
            delay_timer = GetTime()
            return CoreScheduleBucket("IntelliMountDelay", 0.25, function() LBIntelliMountSummon(utility, "delay") end)
        end
    elseif not delay and not IsSwimming() and utility=="normal" then
        if GetTime() - (delay_timer or 0) < 0.2 then
            CoreCancelBucket("IntelliMountDelay")
            utility = "surface"
        else
            delay_timer = GetTime()
            return CoreScheduleBucket("IntelliMountDelay", 0.2, function() LBIntelliMountSummon("normal", "delay") end)
        end
    end

    delay_timer = nil
    wipe(chosen);

    --检索收藏的坐骑
    for id, data in next, mountsData do
        if utility and data[utility] and data.favorite and IsUsableSpell(id) then
            --如果在不可飞行的位置则排除掉飞行坐骑, 暴雪的按钮不会在地面招出会飞的坐骑
            if (IsFlyableArea() or not nofly) or data.groundOnly then
                tinsert(chosen, id)
            end
        end
    end

    --没有收藏的, 看下有没有未收藏的特殊坐骑
    if #chosen==0 and utility~="normal" then
        for id, data in next, mountsData do
            if data[utility] and data.owned then
                tinsert(chosen, id)
            end
        end
    end

    --print("before", unpack(chosen))
    --如果区域可以飞行，而且收藏的里面有非groundOnly的，则去掉
    --如果只收藏了地面坐骑则只会召唤地面的
    if #chosen > 0 and IsFlyableArea() then
        local hasFlyingFav = false
        for _, id in next, chosen do
            if not mountsData[id].groundOnly then
                hasFlyingFav = true
                break
            end
        end
        --移除groundOnly的
        if hasFlyingFav then
            for i = #chosen, 1, -1 do
                if mountsData[chosen[i]].groundOnly then
                    tremove(chosen, i)
                end
            end
        else
            --逻辑问题: 不会去召唤可以飞行的特殊坐骑
        end
    end
    --print("after", unpack(chosen))

    if #chosen==0 then
        C_MountJournal.SummonByID(0) --都没有就使用暴雪的随机坐骑按钮, 但一般也会报错
    else
        C_MountJournal.SummonByID(mountsData[chosen[random(1, #chosen)]].mountID);
    end
end