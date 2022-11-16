if not U1_WOW10 then return end
--[[
    "TabButtonTemplate" "OptionsFrameTabButtonTemplate"
        临时在10.0 XML增加TabButtonTemplate继承PanelTopTabButtonTemplate
        兼容可用PanelTopTabButtonMixin and "PanelTopTabButtonTemplate" or "TabButtonTemplate"
        父框体 inherits="PanelTopTabButtonTemplate" mixin="PanelTopTabButtonMixin"
            <KeyValue key="tabPadding" value="0" type="number"/>
            <KeyValue key="minTabWidth" value="40" type="number"/>
            <KeyValue key="maxTabWidth" value="2000" type="number"/>
            PanelTemplates_TabResize

    "OptionsCheckButtonTemplate"
        暂时创建 "InterfaceOptionsCheckButtonTemplate"的别名, 后者限制275宽度，注意这个在 SharedXML\DeprecatedTemplates.xml 里
        或者用'UICheckButtonTemplate'但是个头比较大

    "OptionsButtonTemplate" -> "UIPanelButtonTemplate" (90, 21)

    SetMinResize/SetMax
        if UIParent.SetResizeBounds then --abyui10
            frame:SetResizeBounds(minWidth, minHeight, maxWidth, maxHeight); --可以省略后面的
        else
            frame:SetMinResize(minWidth, minHeight);
            frame:SetMaxResize(maxWidth, maxHeight);
        end
    end

    SetGradientAlpha("HORIZONTAL",r,g,b,start,r*factor,g*factor,b*factor,stop)
        SetGradient("HORIZONTAL", CreateColor(r,g,b,start), CreateColor(r*factor,g*factor,b*factor,stop)

    移除事件 VOID_STORAGE_OPEN
        机制是 PLAYER_INTERACTION_MANAGER_FRAME_SHOW(Enum.PlayerInteractionType) @see PlayerInteractionFrameManager.lua

    SetFont 第三个参数

    if C_Container and C_Container.GetContainerItemLink then
        -- Dragonflight
        itemLink = C_Container.GetContainerItemLink(container, slot)
    else
        -- Shadowlands
        local _, _, _, _, _, _, il, _, _, _ = GetContainerItemInfo(container, slot)
        itemLink = il
    end

    CURSOR_UPDATE -> CURSOR_CHANGED

    <TitleRegion setAllPoints="true"/>非法，可参考QuickKeybind.xml
            <Frame parentKey="Header" inherits="DialogHeaderTemplate">
                <KeyValues>
                    <KeyValue key="textString" value="QUICK_KEYBIND_MODE" type="global"/>
                </KeyValues>
            </Frame>

    C_GossipInfo.SelectAvailableQuest(self:GetID()) --改为选择questId

    GearManagerDialogPopup -> GearManagerPopupFrame

    SetFromScale -> SetScaleFrom SetFromAlpha不变

    srti.menu.test.model:SetLight(true,false,-.5,-.2,-.6,0.5,1,1,1,1,1,1,0.8);
    	local lightValues = { omnidirectional = false, point = CreateVector3D(-.5,-.2,-.6), ambientIntensity = 0.5, ambientColor = CreateColor(1,1,1), diffuseIntensity = 1, diffuseColor = CreateColor(1,1,0.8) }
	    srti.menu.test.model:SetLight(true,lightValues);



	EventRegistry:RegisterCallback("ContainerFrame.CloseBag", self.UpdateBagButtonHighlight, self);
	EventRegistry:RegisterCallback("ContainerFrame.OpenBag", self.UpdateBagButtonHighlight, self);

    ContainerIDToInventoryID(1) -> 31 PutItemInBag()

    ActionButtonUseKeyDown

    CreateAtlasMarkup(GetClassAtlas(classFileName:lower()))

    if type(Settings) == "table" and type(Settings.RegisterCanvasLayoutCategory) == "function" then

    不需要SetOrHookScript了直接Hook即可
    GetPoint() -> GetPoint(1) --不需要了
    CreateFrame("GameTooltip") 必须加名字，否则有BUG，装备价格不显示

    C_GossipInfo.GetNumOptions() 没了,直接 C_GossipInfo.GetOptions(), C_GossipInfo.SelectOption(需要选择 gossipOptionID,而不是index)

    ContainerFrameUtil_EnumerateContainerFrames() 不要用
--]]

--[[------------------------------------------------------------
10.0的按钮各个材质大小不是联动的，需要单独设置 @see BaseActionButtonMixin:UpdateButtonArt(hideDivider)
---------------------------------------------------------------]]
local scales = {}
do
    local testButton = CreateFrame("CheckButton", "_abyBtnCoreUISetActionButtonSize10", UIParent, "ActionBarButtonTemplate") testButton:Hide()
    local w1, h1 = testButton:GetSize()
    for k, v in pairs(testButton) do
        if type(v) == "table" and v.GetSize then
            if not v:GetPoint(2) then --ignore those SetAllPoints()
                local w, h = v:GetSize()
                scales[k] = { w / w1, h / h1 }
            end
        end
    end

    function CoreUISetActionButtonSize10(btn, size)
        btn:SetNormalAtlas("UI-HUD-ActionBar-IconFrame-AddRow");
        btn:SetPushedAtlas("UI-HUD-ActionBar-IconFrame-AddRow-Down");
        if InCombatLockdown() then return end
        btn:SetSize(size, size)
        for k, v in pairs(btn) do
            if type(v) == "table" and v.GetSize then
                if not v:GetPoint(2) then
                    local scale = scales[k]
                    if scale then
                        v:SetSize(size * scale[1], size * scale[2])
                    end
                end
            end
        end
    end
end

do
    CoreOnEvent("VARIABLES_LOADED", function()
        if U1DBG.show_3rd_bindings then
            U1DBG.show_3rd_bindings = nil
            BINDING_HEADER_OTHER = "BINDING_HEADER_OTHER"
            C_Timer.After(0.1, function()
                SettingsPanel:OpenToCategory(SettingsPanel.keybindingsCategory.ID)
            end)
        end

        local name = "AbySettingsBindingToggleButton"
        local ok, def = pcall(function() return
            SettingsPanel.Container.SettingsList.Header.DefaultsButton
        end)
        if not ok then return end

        local working = BINDING_HEADER_OTHER ~= BINDING_HEADER_MISC

        local btn = WW:Button(name, def:GetParent(), "UIPanelButtonTemplate")
                      :Size(110, 22):TR(def, "TL", -10, 0)
                      :SetText('\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo:' .. (20) .. '\124t' .. (working and "  重载保证安全  " or "  显示插件热键  "))
                      :SetScript("OnDoubleClick", function()
                    if not working then U1DBG.show_3rd_bindings = true end
                    ReloadUI()
                end)  :un()

        btn.tooltipText = "|cffffff00临时显示插件定义的热键|r\n\n因为暴雪的BUG,中文客户端无法显示插件自定义的热键（参见https://bbs.nga.cn/read.php?tid=34037994 oyg123大佬曾发现并解决过9.1打开地图卡顿的问题）。\n\n爱不易根据这个帖子，增加这个按钮，'|cffffff00双击|r'此按钮会重载界面并显示这些热键，但是这样可能导致界面失效的问题。所以设置完热键后，请再次重载界面。"
        btn.Text:ClearAllPoints()
        btn.Text:SetPoint("RIGHT")
        btn.Text:SetJustifyH("RIGHT")
        hooksecurefunc(SettingsPanel.CategoryList, "SetCurrentCategory", function(self)
            if self.currentCategory == SettingsPanel.keybindingsCategory then
                btn:Show()
            else
                btn:Hide()
            end
        end)
        SettingsPanel:HookScript("OnHide", function()
            if working then
                U1Message("你之前开启了显示插件热键功能，当前环境可能不安全，建议/rl重载界面")
            end
        end)
    end)
end

do
    --- 屏蔽鼠标提示不停刷新的点
    --UpdateTooltip本来就有0.2秒的间隔, 需要新的机制，就是延迟出提示
    local lastModifierTime = 0
    CoreOnEvent("MODIFIER_STATE_CHANGED", function() lastModifierTime = GetTime() end)
    function AbyUpdateTooltipWrapperFunc(func, interval, caller)
        return function(self, ...)
            if self == nil then self = caller end
            if self == nil then return end
            local t = self._abyUTT or 0
            local now = GetTime()
            if now - t < interval and t > lastModifierTime then return end
            self._abyUTT = now
            return func(self, ...)
        end
    end
end

do
    TradeFramePlayerNameText:SetParent(TradeFrame.TitleContainer)
    TradeFrameRecipientNameText:SetParent(TradeFrame.TitleContainer)
end

--[[------------------------------------------------------------
10.0.2
/run TooltipDataProcessor.AddTooltipPostCall("ALL", function(self, data) dumpp(data) end)
GameTooltipTemplate  GameTooltipDataMixin 提供 GetUnit GetItem GetSpell
C_TooltipInfo 提供获取方法，但需要 TooltipUtil.SurfaceArgs(tData.lines[2])
BUG: Enum.TooltipDataType.Macro无法得知是账户还是角色,返回的应该加上MAX_ACCOUNT_MACROS
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tip, tData)
    local _, unit = TooltipUtil.GetDisplayedUnit(tip)   --tData: {guid, healthGUID, lines, type}

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tip, tData)
    local link = tooltipData.guid and C_Item.GetItemLinkByGUID(tooltipData.guid) or tooltipData.hyperlink
    或 name, link, id = TooltipUtil.GetDisplayedItem(tip) --tData: {guid, id, lines, type}

removed OnTooltipAddMoney OnTooltipSetAchievement OnTooltipSetEquipmentSet OnTooltipSetItem OnTooltipSetQuest OnTooltipSetSpell OnTooltipSetUnit

{
  {
    args = {
      { field = "type", intVal = 0, },
      { field = "leftText", stringVal = "冬泉豹幼崽", },
      { field = "leftColor", colorVal = { b = 0, g = 1, r = 0.11764706671238, },
      { boolVal = true, field = "wrapText", },
    },
    lineIndex = 1,
    type = 0,
  }
}
---------------------------------------------------------------]]
if not LE_ITEM_CLASS_CONSUMABLE then
    LE_ITEM_CLASS_CONSUMABLE = Enum.ItemClass.Consumable;
    LE_ITEM_CLASS_CONTAINER = Enum.ItemClass.Container;
    LE_ITEM_CLASS_WEAPON = Enum.ItemClass.Weapon;
    LE_ITEM_CLASS_GEM = Enum.ItemClass.Gem;
    LE_ITEM_CLASS_ARMOR = Enum.ItemClass.Armor;
    LE_ITEM_CLASS_REAGENT = Enum.ItemClass.Reagent;
    LE_ITEM_CLASS_PROJECTILE = Enum.ItemClass.Projectile;
    LE_ITEM_CLASS_TRADEGOODS = Enum.ItemClass.Tradegoods;
    LE_ITEM_CLASS_ITEM_ENHANCEMENT = Enum.ItemClass.ItemEnhancement;
    LE_ITEM_CLASS_RECIPE = Enum.ItemClass.Recipe;
    LE_ITEM_CLASS_QUIVER = Enum.ItemClass.Quiver;
    LE_ITEM_CLASS_QUESTITEM = Enum.ItemClass.Questitem;
    LE_ITEM_CLASS_KEY = Enum.ItemClass.Key;
    LE_ITEM_CLASS_MISCELLANEOUS = Enum.ItemClass.Miscellaneous;
    LE_ITEM_CLASS_GLYPH = Enum.ItemClass.Glyph;
    LE_ITEM_CLASS_BATTLEPET = Enum.ItemClass.Battlepet;
    LE_ITEM_CLASS_WOW_TOKEN = Enum.ItemClass.WoWToken;

    LE_ITEM_WEAPON_AXE1H = Enum.ItemWeaponSubclass.Axe1H;
    LE_ITEM_WEAPON_AXE2H = Enum.ItemWeaponSubclass.Axe2H;
    LE_ITEM_WEAPON_BOWS = Enum.ItemWeaponSubclass.Bows;
    LE_ITEM_WEAPON_GUNS = Enum.ItemWeaponSubclass.Guns;
    LE_ITEM_WEAPON_MACE1H = Enum.ItemWeaponSubclass.Mace1H;
    LE_ITEM_WEAPON_MACE2H = Enum.ItemWeaponSubclass.Mace2H;
    LE_ITEM_WEAPON_POLEARM = Enum.ItemWeaponSubclass.Polearm;
    LE_ITEM_WEAPON_SWORD1H = Enum.ItemWeaponSubclass.Sword1H;
    LE_ITEM_WEAPON_SWORD2H = Enum.ItemWeaponSubclass.Sword2H;
    LE_ITEM_WEAPON_WARGLAIVE = Enum.ItemWeaponSubclass.Warglaive;
    LE_ITEM_WEAPON_STAFF = Enum.ItemWeaponSubclass.Staff;
    LE_ITEM_WEAPON_BEARCLAW = Enum.ItemWeaponSubclass.Bearclaw;
    LE_ITEM_WEAPON_CATCLAW = Enum.ItemWeaponSubclass.Catclaw;
    LE_ITEM_WEAPON_UNARMED = Enum.ItemWeaponSubclass.Unarmed;
    LE_ITEM_WEAPON_GENERIC = Enum.ItemWeaponSubclass.Generic;
    LE_ITEM_WEAPON_DAGGER = Enum.ItemWeaponSubclass.Dagger;
    LE_ITEM_WEAPON_THROWN = Enum.ItemWeaponSubclass.Thrown;
    LE_ITEM_WEAPON_OBSOLETE3 = Enum.ItemWeaponSubclass.Obsolete3;
    LE_ITEM_WEAPON_CROSSBOW = Enum.ItemWeaponSubclass.Crossbow;
    LE_ITEM_WEAPON_WAND = Enum.ItemWeaponSubclass.Wand;
    LE_ITEM_WEAPON_FISHINGPOLE = Enum.ItemWeaponSubclass.Fishingpole;

    LE_ITEM_ARMOR_GENERIC = Enum.ItemArmorSubclass.Generic;
    LE_ITEM_ARMOR_CLOTH = Enum.ItemArmorSubclass.Cloth;
    LE_ITEM_ARMOR_LEATHER = Enum.ItemArmorSubclass.Leather;
    LE_ITEM_ARMOR_MAIL = Enum.ItemArmorSubclass.Mail;
    LE_ITEM_ARMOR_PLATE = Enum.ItemArmorSubclass.Plate;
    LE_ITEM_ARMOR_COSMETIC = Enum.ItemArmorSubclass.Cosmetic;
    LE_ITEM_ARMOR_SHIELD = Enum.ItemArmorSubclass.Shield;
    LE_ITEM_ARMOR_LIBRAM = Enum.ItemArmorSubclass.Libram;
    LE_ITEM_ARMOR_IDOL = Enum.ItemArmorSubclass.Idol;
    LE_ITEM_ARMOR_TOTEM = Enum.ItemArmorSubclass.Totem;
    LE_ITEM_ARMOR_SIGIL = Enum.ItemArmorSubclass.Sigil;
    LE_ITEM_ARMOR_RELIC = Enum.ItemArmorSubclass.Relic;

    LE_ITEM_GEM_INTELLECT = Enum.ItemGemSubclass.Intellect;
    LE_ITEM_GEM_AGILITY = Enum.ItemGemSubclass.Agility;
    LE_ITEM_GEM_STRENGTH = Enum.ItemGemSubclass.Strength;
    LE_ITEM_GEM_STAMINA = Enum.ItemGemSubclass.Stamina;
    LE_ITEM_GEM_SPIRIT = Enum.ItemGemSubclass.Spirit;
    LE_ITEM_GEM_CRITICALSTRIKE = Enum.ItemGemSubclass.Criticalstrike;
    LE_ITEM_GEM_MASTERY = Enum.ItemGemSubclass.Mastery;
    LE_ITEM_GEM_HASTE = Enum.ItemGemSubclass.Haste;
    LE_ITEM_GEM_VERSATILITY = Enum.ItemGemSubclass.Versatility;
    LE_ITEM_GEM_MULTIPLESTATS = Enum.ItemGemSubclass.Multiplestats;
    LE_ITEM_GEM_ARTIFACTRELIC = Enum.ItemGemSubclass.Artifactrelic;

    LE_ITEM_RECIPE_BOOK = Enum.ItemRecipeSubclass.Book;
    LE_ITEM_RECIPE_LEATHERWORKING = Enum.ItemRecipeSubclass.Leatherworking;
    LE_ITEM_RECIPE_TAILORING = Enum.ItemRecipeSubclass.Tailoring;
    LE_ITEM_RECIPE_ENGINEERING = Enum.ItemRecipeSubclass.Engineering;
    LE_ITEM_RECIPE_BLACKSMITHING = Enum.ItemRecipeSubclass.Blacksmithing;
    LE_ITEM_RECIPE_COOKING = Enum.ItemRecipeSubclass.Cooking;
    LE_ITEM_RECIPE_ALCHEMY = Enum.ItemRecipeSubclass.Alchemy;
    LE_ITEM_RECIPE_FIRST_AID = Enum.ItemRecipeSubclass.FirstAid;
    LE_ITEM_RECIPE_ENCHANTING = Enum.ItemRecipeSubclass.Enchanting;
    LE_ITEM_RECIPE_FISHING = Enum.ItemRecipeSubclass.Fishing;
    LE_ITEM_RECIPE_JEWELCRAFTING = Enum.ItemRecipeSubclass.Jewelcrafting;
    LE_ITEM_RECIPE_INSCRIPTION = Enum.ItemRecipeSubclass.Inscription;

    LE_ITEM_MISCELLANEOUS_JUNK = Enum.ItemMiscellaneousSubclass.Junk;
    LE_ITEM_MISCELLANEOUS_REAGENT = Enum.ItemMiscellaneousSubclass.Reagent;
    LE_ITEM_MISCELLANEOUS_COMPANION_PET = Enum.ItemMiscellaneousSubclass.CompanionPet;
    LE_ITEM_MISCELLANEOUS_HOLIDAY = Enum.ItemMiscellaneousSubclass.Holiday;
    LE_ITEM_MISCELLANEOUS_OTHER = Enum.ItemMiscellaneousSubclass.Other;
    LE_ITEM_MISCELLANEOUS_MOUNT = Enum.ItemMiscellaneousSubclass.Mount;
    LE_ITEM_MISCELLANEOUS_MOUNT_EQUIPMENT = Enum.ItemMiscellaneousSubclass.MountEquipment;
end

if not C_LFGList.GetActivityInfo then
    -- Use GetLfgCategoryInfo going forward
    function C_LFGList.GetCategoryInfo(categoryID)
        local categoryInfo = C_LFGList.GetLfgCategoryInfo(categoryID);
        if categoryInfo then
            return categoryInfo.name, categoryInfo.separateRecommended, categoryInfo.autoChooseActivity, categoryInfo.preferCurrentArea, categoryInfo.showPlaystyleDropdown;
        end
    end

    function C_LFGList.GetActivityInfo(activityID, questID, showWarmode)
        local activityInfo = C_LFGList.GetActivityInfoTable(activityID, questID, showWarmode);
        if activityInfo then
            return activityInfo.fullName, activityInfo.shortName, activityInfo.categoryID, activityInfo.groupFinderActivityGroupID, activityInfo.ilvlSuggestion, activityInfo.filters, activityInfo.minLevel, activityInfo.maxNumPlayers, activityInfo.displayType, activityInfo.orderIndex, activityInfo.useHonorLevel, activityInfo.showQuickJoinToast, activityInfo.isMythicPlusActivity, activityInfo.isRatedPvpActivity, activityInfo.isCurrentRaidActivity;
        end
    end
end

do
    --10.0.2
    GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
    GetContainerItemLink = GetContainerItemLink or C_Container.GetContainerItemLink
    GetContainerItemID = GetContainerItemID or C_Container.GetContainerItemID
    GetContainerItemInfo = GetContainerItemInfo or function(...)
        local item = C_Container.GetContainerItemInfo(...)
        if item then
            return item.iconFileID, item.stackCount, item.isLocked, item.quality, item.isReadable, item.hasLoot, item.hyperlink, item.isFiltered, item.hasNoValue, item.itemID, item.isBound
        end
    end
    GetContainerNumFreeSlots = GetContainerNumFreeSlots or C_Container.GetContainerNumFreeSlots
    ContainerIDToInventoryID = ContainerIDToInventoryID or C_Container.ContainerIDToInventoryID
    GetContainerItemCooldown = GetContainerItemCooldown or C_Container.GetContainerItemCooldown
    IsBattlePayItem = IsBattlePayItem or C_Container.IsBattlePayItem

    --TODO:abyui102
    TooltipUtil.GetRepairCostForTooltipData = function(tooltipData)
        if tooltipData then
            for i, arg in ipairs(tooltipData.args) do
                if arg.field == "repairCost" then return arg.intVal end
            end
        end
        return 0
    end
end