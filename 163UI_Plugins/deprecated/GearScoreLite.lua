local f = {}
GearScoreL = f
local TenTonHammerTooltip = CreateFrame("GAMETOOLTIP","TenTonHammerTooltip163",nil,"GameTooltipTemplate")
TenTonHammerTooltip:SetOwner(UIParent, "ANCHOR_NONE")
f.data = {
    ["ItemTypes"] = {
        ["INVTYPE_RELIC"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0 },
        ["INVTYPE_TRINKET"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 33, ["Enchantable"] = 0, ["Weapon"] = 0  },
        ["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2, ["ItemSlot"] = 16, ["Enchantable"] = 1, ["Weapon"] = 2  },
        ["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 16, ["Enchantable"] = 1, ["Weapon"] = 1  },
        ["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 1, ["Weapon"] = 1  },
        ["INVTYPE_RANGED"] = { ["SlotMOD"] = 2, ["ItemSlot"] = 18, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 2, ["ItemSlot"] = 18, ["Enchantable"] = 2, ["Weapon"] = 0  },
        ["INVTYPE_THROWN"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0  },
        -- ["INVTYPE_RANGED"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 1, ["Weapon"] = 0  },
        -- ["INVTYPE_THROWN"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 0, ["Weapon"] = 0  },
        -- ["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = .3164, ["ItemSlot"] = 18, ["Enchantable"] = 2, ["Weapon"] = 0  },
        ["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 1, ["Weapon"] = 1  },
        ["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 36, ["Enchantable"] = 1, ["Weapon"] = 1  },
        ["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 17, ["Enchantable"] = 0, ["Weapon"] = 1  },
        ["INVTYPE_HEAD"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 1, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_NECK"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 2, ["Enchantable"] = 0, ["Weapon"] = 0  },
        ["INVTYPE_SHOULDER"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 3, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_CHEST"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 5, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_ROBE"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 5, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_BODY"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 5, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_WAIST"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 6, ["Enchantable"] = 0, ["Weapon"] = 0  },
        ["INVTYPE_LEGS"] = { ["SlotMOD"] = 1, ["ItemSlot"] = 7, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_FEET"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 8, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_WRIST"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 9, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_HAND"] = { ["SlotMOD"] = .75, ["ItemSlot"] = 10, ["Enchantable"] = 1, ["Weapon"] = 0  },
        ["INVTYPE_FINGER"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 31, ["Enchantable"] = 2, ["Weapon"] = 0  },
        ["INVTYPE_CLOAK"] = { ["SlotMOD"] = .5625, ["ItemSlot"] = 15, ["Enchantable"] = 1, ["Weapon"] = 0  },
    },
    ColorArray = {
        [0] = { .55, .55, .55  },
        [1] = { .55, .55, .55 },
        [2] = { 1, 1, 1 },
        [3] = { .12, 1, 0 },
        [4] = { 0, .5, 1 },
        [5] = { .69, .28, .97 },
        [6] = { .94, .47, 0 },
        [7] = { 1, 0, 0 },
        [8] = { 1, 0, 0 },
    },
}

function f:GetColor(score)
    if ( score == 0 ) then return .1, .1, .1, "|cff1A1A1A"; end;
    local color = {};
    local index = 0;
    local ColorArray = f.data.ColorArray;
    score = floor( score / 2);
    if ( score >= 6000 ) then score = 5999; end;
    local a = floor(score / 1e3) + 1;
    local b = a + 1;
    local c = mod(score, 1e3);
    for i = 1,3 do
        local d = ( ColorArray[b][i] - ColorArray[a][i]) / 1e3;
        color[i] = ColorArray[a][i] + (d * c);
    end;
    color[4] =  "|cff" .. string.format("%02x%02x%02x",color[1] * 255, color[2] * 255, color[3] * 255);
    return unpack(color);
end;

function f:GetBeltBuckle(itemLink, gemCount)
    local id = itemLink:match("item:(%d+):")
    local SocketCount = f:GetGemInfo(select(2, GetItemInfo(id)))
    if ( ( SocketCount - gemCount ) == -1 ) then
        return true;
    else
        return false;
    end;
end;

function f:GetGemInfo(itemLink)
    if(true) then return 0, {}, 0, nil end --fix7
    local GemCount = 0;
    --local Gems = { [0] = 0 };
    --local MissingGems = {
    --    ["Meta"] = 0,
    --    ["Red"] = 0,
    --    ["Yellow"] = 0,
    --    ["Blue"] = 0
    --};
    local MissingGemCount = 0;
    if not ( itemLink or itemLink == "" ) then
        return 0, {}, MissingGemCount, nil;
    end;
    --local EmptyTextures = {
    --    ["Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta"] = "Meta",
    --    ["Interface\\ItemSocketingFrame\\UI-EmptySocket-Red"] = "Red",
    --    ["Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow"] = "Yellow",
    --    ["Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue"] = "Blue"
    --};
    for i = 1, 4 do
        if ( _G["TenTonHammerTooltip163Texture"..i] ) then
            _G["TenTonHammerTooltip163Texture"..i]:SetTexture("");
        end;
    end;
    --TenTonHammerTooltip:SetOwner(f,"ANCHOR_NONE");
    --TenTonHammerTooltip:ClearLines();
    TenTonHammerTooltip:SetHyperlink(itemLink);
    for i = 1,4 do
        local texture = _G["TenTonHammerTooltip163Texture"..i]:GetTexture();
        if ( texture ) then
            if texture:find("Interface\\ItemSocketingFrame\\UI%-EmptySocket%-") then --if ( EmptyTextures[texture] ) then
                --MissingGems[EmptyTextures[texture]] = MissingGems[EmptyTextures[texture]] + 1;
                MissingGemCount = MissingGemCount + 1;
            end;
            GemCount = GemCount + 1;
            --local gemName, gemLink = GetItemGem(itemLink, i);
            --tinsert(Gems, {
            --    ["Name"] = gemName,
            --    ["Link"] = gemLink,
            --    ["Texture"] = texture
            --});
        end;
    end;
    --return #Gems, Gems, MissingGemCount, MissingGems;
    return GemCount, nil, MissingGemCount
end;
function f:GetEnchantInfo(itemLink)
    local enchantid = itemLink:match'item:%d+:(%d*):'
    return enchantid~="0" and enchantid~="" and enchantid
end;

local GS_Formula = { {nil, 1}, { 73, 1 }, { 81.375, .8125 }, { 91.45, .65 }, { 91.45, .5 }, { 91.45, .5 }, { 81.375, .8125 } };
local GS_FormulaVanilla = { {nil, 1}, { 8, 2 }, { .75, 1.8 }, { 26, 1.2 }, { 26, .923 }, { 26, .923 }, { 81.375, .8125 } };
local GS_FormulaCataclysm = { {nil, 1}, { 91.45000, 0.65000 },{ 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 } };
local GS_FormulaCataclysm2 = { {nil, 1}, { 81.375, 0.8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 } };
local ItemSubStringTable = {};
function f:GetItemScore(ItemLink, PlayerRole, PlayerClass)
    table.wipe(ItemSubStringTable)
    local found, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]");
    --print(ItemSubString);
    for v in string.gmatch(ItemSubString, "[^:]+") do tinsert(ItemSubStringTable, v); end
    local ItemID = ItemSubStringTable[2];
    local ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemID);
    --print(ItemName, ItemLink, ItemRarity, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice);
    if not ( f.data.ItemTypes[ItemEquipSlot] ) then return nil, nil; end;
    --local ItemStats = f:ScanItem(ItemLink) or {};
    if (ItemRarity == 7) then ItemLevel = 187; end;
    --local GS_Formula = { {ItemLevel, 1}, { 73, 1 }, { 81.375, .8125 }, { 91.45, .65 }, { 91.45, .5 }, { 91.45, .5 }, { 81.375, .8125 } };
    --local GS_FormulaVanilla = { {ItemLevel, 1}, { 8, 2 }, { .75, 1.8 }, { 26, 1.2 }, { 26, .923 }, { 26, .923 }, { 81.375, .8125 } };
    --local GS_FormulaCataclysm = { {ItemLevel, 1}, { 91.45000, 0.65000 },{ 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 }, { 91.45000, 0.65000 } };
    --local GS_FormulaCataclysm2 = { {ItemLevel, 1}, { 81.375, 0.8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 }, { 81.375, .8125 } };
    GS_Formula[1][1] = ItemLevel; GS_FormulaVanilla[1][1] = ItemLevel; GS_FormulaCataclysm[1][1] = ItemLevel; GS_FormulaCataclysm2[1][1] = ItemLevel;
    GS_Formula[0] = GS_Formula[1];
    GS_FormulaVanilla[0] = GS_FormulaVanilla[1];
    --local RoleRate, IncorrectItems, pvpFlag = f:GetRoleRate(PlayerRole, f:GetItemRole(ItemStats), IncorrectItems)
    local RoleRate = 1
    local ItemScore = 0;
    --local pvpItemScore = 1;
    if ( ItemLevel > 277 ) then
        ItemScore = floor(  (((ItemLevel - GS_FormulaCataclysm[ItemRarity][1]) / GS_FormulaCataclysm[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate  );
        --pvpItemScore = floor(  (((ItemLevel - GS_FormulaCataclysm[ItemRarity][1]) / GS_FormulaCataclysm[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291)  );
    elseif ( ItemLevel > 120 ) then
        ItemScore = floor(  (((ItemLevel - GS_Formula[ItemRarity][1]) / GS_Formula[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate  );
        --pvpItemScore = floor(  (((ItemLevel - GS_Formula[ItemRarity][1]) / GS_Formula[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291)  );
    else
        ItemScore = floor(  (((ItemLevel - GS_FormulaVanilla[ItemRarity][1]) / GS_FormulaVanilla[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291) * RoleRate  );
        --pvpItemScore = floor(  (((ItemLevel - GS_FormulaVanilla[ItemRarity][1]) / GS_FormulaVanilla[ItemRarity][2]) * f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] * 1.8291)  );
    end;


    --[[-- PVP Item Scoring
    if ItemIsWeapon(ItemEquipSlot) then
        if ( pvpFlag ) then
            pvpItemScore = floor(1.25 * pvpItemScore);
        end;
    elseif ( ItemEquipSlot ~= "INVTYPE_TRINKET" ) then
        if ( not pvpFlag ) then
            pvpItemScore = floor(ItemScore * 0.75);
        end;
    end;
    ]]

    if ( ItemScore < 0 ) then ItemScore = 0; end;
    --if ( pvpItemScore < 0 ) then pvpItemScore = 0; end;

    --local r,g,b, hex =  f:GetColor( floor( 12.25 * ItemScore / f.data.ItemTypes[ItemEquipSlot]["SlotMOD"] ) );

    -- if ( PlayerClass == "HUNTER" ) then
    --     if ( ItemEquipSlot == "INVTYPE_RANGED" or ItemEquipSlot == "INVTYPE_RANGEDRIGHT" ) then
    --         ItemScore = floor(ItemScore * 5.3224);
    --         --pvpItemScore = floor(pvpItemScore * 5.3224);
    --     end;
    --     if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then
    --         ItemScore = floor(ItemScore * .3164);
    --         --pvpItemScore = floor(pvpItemScore * .3164);
    --     end;
    -- end;

    return ItemScore --, hex;
end;

function ItemIsWeapon(ItemEquipSlot)
    local a = ItemEquipSlot;
    if ( a == "INVTYPE_2HWEAPON" or a == "INVTYPE_HOLDABLE" or a == "INVTYPE_WEAPON" or a == "INVTYPE_SHIELD" or a == "INVTYPE_RANGEDRIGHT" or a == "INVTYPE_THROWN" or a == "INVTYPE_RANGED" or a == "INVTYPE_WEAPONOFFHAND" or a == "INVTYPE_WEAPONMAINHAND" or a == "INVTYPE_RELIC" ) then
        return true;
    else
        return false;
    end;
end;

function f:GetPlayerInfo(unit)
    --local GearScore, PVEScore, PVPScore, RaidScore, SpecID, SpecName, PlayerRole, ThumbsUp, ThumbsDown, AltSpecID, AltSpecName, PreviousVote;
    --local pvpGearScore = 0;
    local ClassLocale, Class = UnitClass(unit);
    local PlayerLevel = UnitLevel(unit);
    local PlayerName = UnitName(unit);
    --if( AchievementFrameComparison ) then AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY"); end;
    --SetAchievementComparisonUnit("player");
    --PVEScore = 0;
    --f:GetPVEScore();
    --RaidScore = f:GetRaidScore();
    --PVPScore = f:GetPVPScore();
    local GearScore = 0;
    local WeaponValue = 0;
    local WeaponScore = 0;
    --local pvpWeaponScore = 0;
    --local ActiveTalentGroup = GetActiveTalentGroup();
    --local PassiveTalentGroup = 1;
    --if ( ActiveTalentGroup == 1 ) then PassiveTalentGroup = 2; end;
    --for i = 1, GetNumSpecializations(false) do
    --    local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetSpecializationInfo(i, false, false, ActiveTalentGroup);
    --    if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
    --        SpecID = TabID;
    --        SpecName = TabName;
    --    end;
    --end;
    --for i = 1, GetNumSpecializations(false) do
    --    local TabID, TabName, TabDescription, TabIcon, TabPoints, TabBackground, TabPreviewPoints, TabIsUnlocked = GetSpecializationInfo(i, false, false, PassiveTalentGroup);
    --    if (TabPoints >= 31) or (( PlayerLevel < 71 ) and ( TabPoints > 0 ))  then
    --        AltSpecID = TabID;
    --        AltSpecName = TabName;
    --    end;
    --end;
    --local PlayerRole = f.data.ClassRoles[Class][SpecID] or 0;
    --local AltPlayerRole = f.data.ClassRoles[Class][AltSpecID] or 0;
    local AverageItemLevel = 0;
    local ItemCount = 0;
    --local IncorrectItems = {};
    local Order = {1,2,3,15,5,9,10,6,7,8,11,12,13,14,16,17,18};
    for i = 1,17 do
        local index = Order[i];
        local ItemLink = GetInventoryItemLink(unit, index);
        if ( ItemLink ) then
            local ItemName, ItemLink2, ItemQuality, ItemLevel, ItemReqLevel, ItemClass, ItemSubclass, ItemMaxStack, ItemEquipSlot, ItemTexture, ItemVendorPrice = GetItemInfo(ItemLink);

            if ( ItemQuality == 7 ) then
                ItemLevel = 187;
                ItemQuality = 3;
            end
            local GemCount, Gems, MissingGemCount, MissingGems = f:GetGemInfo(ItemLink);
            local ItemScore, IncorrectItems, ItemColor, PVPItemScore = f:GetItemScore(ItemLink, nil, Class);
            if not ( ItemScore ) then ItemScore = 0; end;
            --if not ( PVPItemScore ) then PVPItemScore = 0; end;
            if ( f.data.ItemTypes[ItemEquipSlot] ) and ( f.data.ItemTypes[ItemEquipSlot]["Enchantable"] ~= 0) then
                local EnchantInfo = f:GetEnchantInfo(ItemLink);
                if ( EnchantInfo ) then
                    ItemScore = ItemScore * 1.03;
                    --PVPItemScore = PVPItemScore * 1.03;
                end;
            end;
            if ( ItemEquipSlot == "INVTYPE_WAIST" ) then
                if ( f:GetBeltBuckle(ItemLink, GemCount) ) then
                    ItemScore = ItemScore * 1.03;
                    --PVPItemScore = PVPItemScore * 1.03;
                end;
            end;
            ItemScore = ItemScore * ( 1 - ( .02 * MissingGemCount ) );
            --PVPItemScore = PVPItemScore * ( 1 - ( .02 * MissingGemCount ) );
            ItemScore = floor(ItemScore);
            --PVPItemScore = floor(PVPItemScore);
            if ( f.data.ItemTypes[ItemEquipSlot]["Weapon"] > 0 ) then
                WeaponValue = WeaponValue + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
                WeaponScore = WeaponScore + ItemScore;
                --pvpWeaponScore = pvpWeaponScore + PVPItemScore;
                ItemCount = ItemCount + f.data.ItemTypes[ItemEquipSlot]["Weapon"];
                --AverageItemLevel = AverageItemLevel + ( ItemLevel * f.data.ItemTypes[ItemEquipSlot]["Weapon"] );
            else
                --AverageItemLevel = AverageItemLevel + ItemLevel;
                ItemCount = ItemCount + 1;
            end;
            GearScore = GearScore + ItemScore;
            --pvpGearScore = pvpGearScore + PVPItemScore;
        end;
    end;
    if ( WeaponValue > 2 ) then
        GearScore = GearScore - floor(WeaponScore - ( 2 * WeaponScore / WeaponValue ));
        --pvpGearScore = pvpGearScore - floor(pvpWeaponScore - ( 2 * pvpWeaponScore / WeaponValue ));
    end;
    --AverageItemLevel = AverageItemLevel / 17;
    --ThumbsUp, ThumbsDown = 0,0;
    --if ( TenTonHammer_Database[f.Realm][PlayerName] ) then
    --    local PlayerData = TenTonHammer_Database[f.Realm][PlayerName];
    --    local PlayerDataArray = {};
    --    for v in string.gmatch(PlayerData, "[^:]+") do tinsert(PlayerDataArray, v); end;
    --    ThumbsUp = PlayerDataArray[6];
    --    ThumbsDown = PlayerDataArray[7];
    --    PreviousVote = PlayerDataArray[8];
    --end;
    --PVEScore = pvpGearScore;
    --f.PlayerInfo = {
    --    ["SpecID"] = SpecID,
    --    ["AltSpecID"] = AltSpecID,
    --    ["AltSpecName"] = AltSpecName,
    --    ["SpecName"] = SpecName,
    --    ["PlayerRole"] = PlayerRole,
    --    ["AltPlayerRole"] = AltPlayerRole,
    --    ["CLASS"] = Class,
    --    ["ClassLocale"] = ClassLocale,
    --    ["GearScore"] = GearScore,
    --    ["PVPScore"] = PVPScore,
    --    ["PVEScore"] = pvpGearScore,
    --    ["RaidScore"] = RaidScore,
    --    ["ThumbsUp"] = ThumbsUp,
    --    ["ThumbsDown"] =ThumbsDown,
    --};
    --local TimeStamp = f:GetTimeStamp();
    --local DatabaseConstruct = strjoin(":", TimeStamp, GearScore, RaidScore, PVEScore, PVPScore, ThumbsUp or 0, ThumbsDown or 0, PreviousVote or 0, 0 );
    --if not ( TenTonHammer_Database[f.Realm] ) then TenTonHammer_Database[f.Realm] = {}; end;
    --TenTonHammer_Database[f.Realm][PlayerName] = DatabaseConstruct;
    return GearScore, select(4, f:GetColor(GearScore));
end;
