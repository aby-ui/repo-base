-- Prevent tainting global _.
local _
local _G = _G


--------------------------------------------------------------------------------
-- Create Basic Spell Frames, Anchor Frames, Speciall Frames
--------------------------------------------------------------------------------
function EventAlert_CreateFrames()
	-- Create anchor frames used for mod customization.
		if (EA_Config.AllowESC == true) then
			tinsert(UISpecialFrames,"EA_Anchor_Frame1");
		end

		local iLocOffset_X = 100 + EA_Position.xOffset;
		local iLocOffset_Y = 0 + EA_Position.yOffset
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame1", 1); -- (1) self buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame2", 1); -- (1) self buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame3", 1); -- (1) self buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame4", 1); -- (1) self buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame5", 2); -- (2) target buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame6", 2); -- (2) target buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame7", 2); -- (2) target buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame8", 2); -- (2) target buff
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame9", 3); -- (3) Skill Cool-Down
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame10", 3); -- (3) Skill Cool-Down
	-- Self Buff/Debuff
		EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, UIParent, EA_Position.xLoc, EA_Position.yLoc);
		EA_Anchor_Frame2:SetPoint("CENTER", EA_Anchor_Frame1, iLocOffset_X, iLocOffset_Y);
		EA_Anchor_Frame3:SetPoint("CENTER", EA_Anchor_Frame1, -1 * iLocOffset_X, iLocOffset_Y);
		EA_Anchor_Frame4:SetPoint("CENTER", EA_Anchor_Frame3, -1 * iLocOffset_X, iLocOffset_Y);
	-- Target Buff/Debuff
		EA_Anchor_Frame5:SetPoint("CENTER", EA_Anchor_Frame1, -1 * iLocOffset_X, -1 * iLocOffset_Y);
		EA_Anchor_Frame6:SetPoint("CENTER", EA_Anchor_Frame5, -1 * iLocOffset_X, -1 * iLocOffset_Y);
		EA_Anchor_Frame7:SetPoint("CENTER", EA_Anchor_Frame5, -1 * iLocOffset_X, -1 * iLocOffset_Y);
		EA_Anchor_Frame8:SetPoint("CENTER", EA_Anchor_Frame7, -1 * iLocOffset_X, -1 * iLocOffset_Y);
	-- Spell Cooldowns
		EA_Anchor_Frame9:SetPoint("CENTER", EA_Anchor_Frame1, 0, 80 + iLocOffset_Y);
		EA_Anchor_Frame10:SetPoint("CENTER", EA_Anchor_Frame9, iLocOffset_X, iLocOffset_Y);

		local EA_OptHeight = EA_Options_Frame:GetHeight();
		EA_Icon_Options_Frame:SetHeight(EA_OptHeight);

	-- Create primary alert frames
		CreateFrames_EventsFrame_CreateSpellList(1);
		CreateFrames_EventsFrame_RefreshSpellList(1);
		EA_Class_Events_Frame:SetHeight(EA_OptHeight);

	-- Create alternate alert frames
		CreateFrames_EventsFrame_CreateSpellList(2);
		CreateFrames_EventsFrame_RefreshSpellList(2);
		EA_ClassAlt_Events_Frame:SetHeight(EA_OptHeight);

	-- Create other alert frames. (Mostly trinket procs)
		CreateFrames_EventsFrame_CreateSpellList(3);
		CreateFrames_EventsFrame_RefreshSpellList(3);
		EA_Other_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Target's Debuffs alert frames. (Target's Debuffs only now)
		CreateFrames_EventsFrame_CreateSpellList(4);
		CreateFrames_EventsFrame_RefreshSpellList(4);
		EA_Target_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Spells' Cooldown alert frames.
		CreateFrames_EventsFrame_CreateSpellList(5);
		CreateFrames_EventsFrame_RefreshSpellList(5);
		EA_SCD_Events_Frame:SetHeight(EA_OptHeight);
		
	-- Create GroupEventChecks alert frames.
		CreateFrames_EventsFrame_CreateSpellList(6);
		CreateFrames_EventsFrame_RefreshSpellList(6);
		EA_Group_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Execution alert frames.
		local eaexf = CreateFrame("FRAME", "EventAlert_ExecutionFrame", UIParent);
		eaexf:ClearAllPoints();
		eaexf:SetFrameStrata("BACKGROUND");
		eaexf:SetPoint("TOP", UIParent, "TOP", 0, -50);
		eaexf:SetHeight(256);
		eaexf:SetWidth(256);
		
		
		eaexf:Hide();

	EA_Class_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 175);
	EA_ClassAlt_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 175);
	EA_Other_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 100);
	EA_Target_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 100);
	EA_SCD_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 100);
	EA_Group_Events_Frame_SpellScrollFrame:SetHeight(EA_OptHeight - 100);
	
	--CreateFrames_CreateMinimapOptionFrame()
end


function CreateFrames_CreateAnchorFrame(AnchorFrameName, typeIndex)
		local eaaf = CreateFrame("FRAME", AnchorFrameName, UIParent);
		eaaf:ClearAllPoints();
		eaaf:SetFrameStrata("DIALOG");
		-- eaaf:SetFrameStrata("LOW");
		eaaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Nature_Polymorph_Cow"});

		eaaf.spellName = eaaf:CreateFontString(AnchorFrameName.."_Name","OVERLAY");
		eaaf.spellName:SetFontObject(ChatFontNormal);
		eaaf.spellName:SetPoint("BOTTOM", 0, -15);

		eaaf.spellTimer = eaaf:CreateFontString(AnchorFrameName.."_Timer","OVERLAY");
		eaaf.spellTimer:SetFontObject(ChatFontNormal);
		eaaf.spellTimer:SetPoint("TOP", 0, 15);

		eaaf:SetMovable(true);
		eaaf:EnableMouse(true);
		if (typeIndex == 1) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp);
		elseif (typeIndex == 2) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2);
		elseif (typeIndex == 3) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown3);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp3);
		end
		eaaf:Hide();
end

function CreateFrames_CreateSpellFrame(index, typeIndex)
	local sFramePrefix = "EAFrame_";
	if typeIndex == 2 then sFramePrefix = "EATarFrame_" end;
	if typeIndex == 3 then sFramePrefix = "EAScdFrame_" end;

	local eaf = _G[sFramePrefix..index];
	if (eaf == nil) then 
		
		eaf = CreateFrame("FRAME", sFramePrefix..index, EA_Main_Frame);
		CooldownFramePrefix = "Cooldown_"
		eaf.cooldown = CreateFrame("Cooldown", sFramePrefix..CooldownFramePrefix..index, eaf, "CooldownFrameTemplate");
		if ((typeIndex == 3) and EA_Position.SCD_UseCooldown) then			
			eaf.useCooldown = true
		else			
			eaf.useCooldown = false
		end
		--[[
		if ((typeIndex == 3) and EA_Position.SCD_UseCooldown) then
			eaf = CreateFrame("Cooldown", sFramePrefix..index, EA_Main_Frame, "CooldownFrameTemplate");
			eaf.useCooldown = true;
		else
			eaf = CreateFrame("FRAME", sFramePrefix..index, EA_Main_Frame);
			eaf.useCooldown = false;
		end
		]]--
		eaf.spellName = eaf:CreateFontString(sFramePrefix..index.."_Name","OVERLAY");
		eaf.spellTimer = eaf:CreateFontString(sFramePrefix..index.."_Timer","OVERLAY");
		eaf.spellStack = eaf:CreateFontString(sFramePrefix..index.."_Stack","OVERLAY");
	end
	eaf.noCooldownCount = true;

	if (EA_Config.AllowESC == true) then
		tinsert(UISpecialFrames,sFramePrefix..index);
	end

	eaf:ClearAllPoints();
	eaf:SetFrameStrata("HIGH");
	eaf.redsectext = false;
	eaf.whitesectext = false;
	eaf.overgrow = false;

	eaf.spellName:SetFontObject(ChatFontNormal);
	eaf.spellName:SetPoint("TOP", eaf, "BOTTOM", 0, -0.1 * EA_Config.IconSize);
	--eaf.spellName:SetPoint("BOTTOM", 0, -15);

	eaf.spellTimer:SetFontObject(ChatFontNormal);
	eaf.spellTimer:SetPoint("TOP", 0, EA_Config.TimerFontSize*1.1);

	eaf.spellStack:SetFontObject(ChatFontNormal);
	eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 15);

	local spellId = tonumber(index);
	local name, rank, icon = GetSpellInfo(spellId);
	if rank == nil then rank = "nil" end;
	if typeIndex == 1 then
		if EA_SPELLINFO_SELF[spellId] == nil then EA_SPELLINFO_SELF[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
		EA_SPELLINFO_SELF[spellId].name = name;
		EA_SPELLINFO_SELF[spellId].rank = rank;
		if (spellId == 48517) then          -- Druid / Eclipse (Solar): replace the Icon as Wrath (Rank 1)
			_, _, icon, _, _, _, _, _, _ = GetSpellInfo(5176);
		elseif (spellId == 48518) then      -- Druid / Eclipse (Lunar): replace the Icon as Starfire (Rank 1)
			_, _, icon, _, _, _, _, _, _ = GetSpellInfo(2912);
		elseif (spellId == 8921) then       -- Druid / Moonfire: always use the starfall picture
			icon = "Interface/Icons/Spell_Nature_Starfall";
		end
		EA_SPELLINFO_SELF[spellId].icon = icon;
	elseif typeIndex == 2 then
		if EA_SPELLINFO_TARGET[spellId] == nil then EA_SPELLINFO_TARGET[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
		EA_SPELLINFO_TARGET[spellId].name = name;
		EA_SPELLINFO_TARGET[spellId].rank = rank;
		EA_SPELLINFO_TARGET[spellId].icon = icon;
	elseif typeIndex == 3 then
		if EA_SPELLINFO_SCD[spellId] == nil then EA_SPELLINFO_SCD[spellId] = {name, rank, icon} end;
		EA_SPELLINFO_SCD[spellId].name = name;
		EA_SPELLINFO_SCD[spellId].rank = rank;
		EA_SPELLINFO_SCD[spellId].icon = icon;
	end
end

-- function CreateFrames_CreateSpecialFrame(index)
function CreateFrames_SpecialFrames_Show(index)
	local sFramePrefix = "EAFrameSpec_";

	local eaf = _G[sFramePrefix..index];
	if (eaf ~= nil) then 
		-- 已建立特殊能力框架，直接更新
		
		local iPowerType = floor((index - 1000000) / 10)		
		
		if (index == EA_SpecPower.LifeBloom.frameindex[1]) then
			EventAlert_UpdateLifeBloom("player");
        elseif ((index == EA_SpecPower.LunarPower.frameindex[1]) or (index == EA_SpecPower.LunarPower.frameindex[2])) then
      			EventAlert_UpdateSinglePower(iPowerType)
		elseif (index == EA_SpecPower.ComboPoint.frameindex[1]) then
			EventAlert_UpdateComboPoint()		
		elseif (iPowerType == EA_SpecPower.Runes.powerId) then
			
			EventAlert_UpdateRunes()
		else
			EventAlert_UpdateSinglePower(iPowerType)
		end		
		return
	end
	
	
	-- 尚未建立特殊能力框架，以下是第一次執行
	eaf = CreateFrame("FRAME", sFramePrefix..index, EA_Main_Frame);
	eaf.spellName = eaf:CreateFontString(sFramePrefix..index.."_Name","OVERLAY");
	eaf.spellTimer = eaf:CreateFontString(sFramePrefix..index.."_Timer","OVERLAY");
	eaf.spellStack = eaf:CreateFontString(sFramePrefix..index.."_Stack","OVERLAY");
	
	if not(eaf.texture) then 
		eaf.texture = eaf:CreateTexture() 
		eaf.texture:SetAllPoints(eaf)
	end
	
	if (EA_Config.AllowESC == true) then
		tinsert(UISpecialFrames,sFramePrefix..index);
	end

	eaf:ClearAllPoints();
	eaf:SetFrameStrata("HIGH");
	eaf.spellName:SetFontObject(ChatFontNormal);
	eaf.spellName:SetPoint("TOP", eaf, "BOTTOM", 0, -EA_Config.IconSize * 0.1);

	eaf.spellTimer:SetFontObject(ChatFontNormal);
	eaf.spellTimer:SetPoint("CENTER", eaf, "CENTER", 0, EA_Config.TimerFontSize * 0.8);

	eaf.spellStack:SetFontObject(ChatFontNormal);
	eaf.spellStack:SetPoint("BOTTOMRIGHT", eaf, "BOTTOMRIGHT", 0, EA_Config.IconSize * 0.1);

	eaf:SetWidth(EA_Config.IconSize);
	eaf:SetHeight(EA_Config.IconSize);

	if index == EA_SpecPower.Rage.frameindex[1] then
		-- 戰士/熊D怒氣的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Warrior_Rampage"});
	elseif index == EA_SpecPower.Focus.frameindex[1] then
		-- 獵人集中值的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Marksmanship"});
	elseif index == EA_SpecPower.Focus.frameindex[2] then
		-- 寵物集中值的圖案				
		--eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Marksmanship"});
		local specIcon = select(3,GetSpellInfo(982))
		eaf.texture:SetTexture(specIcon)
	elseif index == EA_SpecPower.Energy.frameindex[1] then
		-- 盜賊/貓D/武僧能量的圖案
		--eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Nature_Healingway"});
		eaf:SetBackdrop({bgFile = "Interface/Icons/Trade_Engineering"});
	elseif index == EA_SpecPower.RunicPower.frameindex[1] then
		-- 死亡騎士符文能量的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Arcane_Rune"});
	elseif index == EA_SpecPower.SoulShards.frameindex[1] then
		-- 術士靈魂碎片的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Inv_Misc_Gem_Amethyst_02"});
	elseif index == EA_SpecPower.LunarPower.frameindex[1] then
		-- 鳥D星能的圖案
		--eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Druid_Eclipse"});
		local specIcon = select(3,GetSpellInfo(77492))
		eaf.texture:SetTexture(specIcon)	
	elseif index == EA_SpecPower.HolyPower.frameindex[1] then
		-- 聖騎士的聖能圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Holy_PowerwordBarrier"});		
	elseif index == EA_SpecPower.LightForce.frameindex[1] then
		-- 武僧真氣的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Monk_HealthSphere"});			
	elseif index == EA_SpecPower.Insanity.frameindex[1] then
		-- 暗牧瘋狂值的圖案
		--eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Priest_Insanity"});			
		--local specIcon = select(3,GetSpellInfo(77486))
		local specIcon = 1386550
		eaf.texture:SetTexture(specIcon)
	elseif index == EA_SpecPower.BurningEmbers.frameindex[1] then
		-- 術士燃火餘燼的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Inv_Misc_Embers"});			
	elseif index == EA_SpecPower.DemonicFury.frameindex[1] then
		-- 術士惡魔之怒的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Fire_FelFlameRing"});			
	elseif index == EA_SpecPower.LifeBloom.frameindex[1] then
		-- 補D生命之花的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/INV_Misc_Herb_FelBlossom"});
	elseif index == EA_SpecPower.ComboPoint.frameindex[1] then
		-- 盜賊/貓D連擊點的圖案
		eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_WhirlWind"});
	elseif index == EA_SpecPower.ArcaneCharges.frameindex[1] then		
		-- 秘法充能圖案
		--eaf:SetBackdrop({bgFile = "Interface/Icons/Arcane_Charges"});			
		local specIcon = select(3,GetSpellInfo(30451))
		eaf.texture:SetTexture(specIcon)
	elseif index == EA_SpecPower.Maelstrom.frameindex[1] then		
		-- 薩滿元能圖案		
		local specIcon = select(3,GetSpellInfo(556))
		specIcon = 136010
		eaf.texture:SetTexture(specIcon)
	elseif index == EA_SpecPower.Fury.frameindex[1] then		
		-- 惡魔獵人魔怒圖案
		local specIcon
		specIcon = 1305156
		eaf.texture:SetTexture(specIcon)
	elseif index == EA_SpecPower.Pain.frameindex[1] then		
		-- 惡魔獵人魔痛圖案
		local specIcon
		local specIcon = select(3,GetSpellInfo(203747))		
		eaf.texture:SetTexture(specIcon)
	end
	
end

function CreateFrames_SpecialFrames_Hide(index)
	
	local sFramePrefix = "EAFrameSpec_";
	local eaf = _G[sFramePrefix..index];
	if (eaf ~= nil) then
		eaf:Hide();
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Create ScrollListFrame And Items(Icon, CheckButton, EditBox, ConfigButton, FontString)
--------------------------------------------------------------------------------
function CreateFrames_EventsFrame_CreateScrollFrame(ParentFrameObj, ScrollFrameHeight, xOffset, yOffset)
	local framewidth = ParentFrameObj:GetWidth();
	local framename = ParentFrameObj:GetName();
	local panel3 = CreateFrame("ScrollFrame", framename.."_SpellListFrameScroll", ParentFrameObj, "UIPanelScrollFrameTemplate");
	local scc = CreateFrame("Frame", framename.."_SpellListFrame", panel3);
		panel3:SetScrollChild(scc);
		panel3:SetPoint("TOPLEFT", ParentFrameObj, "TOPLEFT", xOffset, yOffset);
		scc:SetPoint("TOPLEFT", panel3, "TOPLEFT", 0, 0);
		panel3:SetWidth(framewidth-45);
		panel3:SetHeight(ScrollFrameHeight);
		scc:SetWidth(framewidth-45);
		scc:SetHeight(ScrollFrameHeight);
		-- panel3:SetHorizontalScroll(-50);
		-- panel3:SetVerticalScroll(50);
		panel3:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		panel3:SetScript("OnVerticalScroll", function()  end);
		panel3:EnableMouse(true);
		panel3:SetVerticalScroll(0);
		panel3:SetHorizontalScroll(0);
end

function CreateFrames_CreateSpellListIcon(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, IconPath)
	SpellID = tonumber(SpellID);	
	local SpellIcon = _G[FrameNamePrefix..SpellID];
	if (SpellIcon == nil) then
		SpellIcon = CreateFrame("Frame", FrameNamePrefix..SpellID, ParentFrameObj);
	end
	SpellIcon:SetWidth(25);
	SpellIcon:SetHeight(25);
	SpellIcon:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
	--SpellIcon:SetBackdrop({bgFile = IconPath});
	
	--for 7.0
	if not SpellIcon.texture then SpellIcon.texture = SpellIcon:CreateTexture() end
	SpellIcon.texture:SetAllPoints(SpellIcon)
	SpellIcon.texture:SetTexture(IconPath)	
	
	SpellIcon:Show();
end

local function ChkboxGetChecked(self)
	local iSpellID = self.SpellID;
	local iFrameIndex = self.FrameIndex;
	local EditboxObj = self.EditboxObj;
	local fValue = false;
	if (IsShiftKeyDown()) then
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_DEBUG_P2.."="..tostring(iSpellID).." / "..GetSpellLink(iSpellID));
	end
	EditboxObj:SetText(tostring(iSpellID));
	if (self:GetChecked()) then
		fValue = true;
	else
		fValue = false;
	end
	if (iFrameIndex == 1) then
		EA_Items[EA_playerClass][iSpellID].enable = fValue;
	elseif (iFrameIndex == 2) then
		EA_AltItems[EA_playerClass][iSpellID].enable = fValue;
	elseif (iFrameIndex == 3) then
		EA_Items[EA_CLASS_OTHER][iSpellID].enable = fValue;
	elseif (iFrameIndex == 4) then
		EA_TarItems[EA_playerClass][iSpellID].enable = fValue;
	elseif (iFrameIndex == 5) then
		EA_ScdItems[EA_playerClass][iSpellID].enable = fValue;
	elseif (iFrameIndex == 6) then
		EA_GrpItems[EA_playerClass][iSpellID].enable = fValue;
	end
end


local function ChkboxGameToolTip(self)
	local iTooltipSpellID = self.TooltipSpellID;
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetSpellByID(iTooltipSpellID);
end


function CreateFrames_CreateSpellListChkbox(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, SpellName, SpellRank, FrameIndex, EditboxObj)
	
	SpellID = tonumber(SpellID);	
	local iTooltipSpellID = SpellID;

	local fValue = true;
	if FrameIndex == 1 then
		fValue = EA_Items[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 2 then
		fValue = EA_AltItems[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 3 then
		fValue = EA_Items[EA_CLASS_OTHER][SpellID].enable;
	elseif FrameIndex == 4 then
		fValue = EA_TarItems[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 5 then
		fValue = EA_ScdItems[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 6 then
		fValue = EA_GrpItems[EA_playerClass][SpellID].enable;
		iTooltipSpellID = EA_GrpItems[EA_playerClass][SpellID].Spells[1].SpellIconID;
	end

	local SpellChkbox = _G[FrameNamePrefix..SpellID];
	if (SpellChkbox == nil) then
		SpellChkbox = CreateFrame("CheckButton", FrameNamePrefix..SpellID, ParentFrameObj, "OptionsCheckButtonTemplate");
	end
	SpellChkbox:SetPoint("TOPLEFT", LocOffsetX + 25, LocOffsetY);
	SpellChkbox:SetChecked(fValue);

	if (SpellRank == "") then
		_G[SpellChkbox:GetName().."Text"]:SetText(SpellName.." ["..SpellID.."]");
	else
		_G[SpellChkbox:GetName().."Text"]:SetText(SpellName.."("..SpellRank..") ["..SpellID.."]");
	end

	SpellChkbox.SpellID = SpellID;
	SpellChkbox.TooltipSpellID = iTooltipSpellID;
	SpellChkbox.EditboxObj = EditboxObj;
	SpellChkbox.FrameIndex = FrameIndex;
	SpellChkbox:UnregisterAllEvents();
	SpellChkbox:RegisterForClicks("AnyUp");
	SpellChkbox:SetScript("OnClick", ChkboxGetChecked);
	SpellChkbox:SetScript("OnEnter", ChkboxGameToolTip);
	SpellChkbox:Show();
end

-- function CreateFrames_CreateSpellListEditbox(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, EditWidth, SpellText)
--  SpellID = tonumber(SpellID);
--
--  local SpellEditBox = _G[FrameNamePrefix..SpellID];
--  if (SpellEditBox == nil) then
--      SpellEditBox = CreateFrame("EditBox", FrameNamePrefix..SpellID, ParentFrameObj);
--      SpellEditBox:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
--      SpellEditBox:SetFontObject(ChatFontNormal);
--      SpellEditBox:SetWidth(EditWidth);
--      SpellEditBox:SetHeight(25);
--      SpellEditBox:SetMaxLetters(0);
--      SpellEditBox:SetAutoFocus(false);
--      SpellEditBox:SetText(SpellText);
--
--         local function ShowEditBoxGameToolTip()
--          SpellEditBox:SetTextColor(0, 1, 1);
--          GameTooltip:SetOwner(SpellEditBox, "ANCHOR_RIGHT");
--          GameTooltip:SetSpellByID(SpellID);
--         end
--         local function HideEditBoxGameToolTip()
--          SpellEditBox:SetTextColor(1, 1, 1);
--          SpellEditBox:HighlightText(0,0);
--          SpellEditBox:ClearFocus();
--          GameTooltip:Hide();
--         end
--      SpellEditBox:SetScript("OnEnter", ShowEditBoxGameToolTip);
--      SpellEditBox:SetScript("OnLeave", HideEditBoxGameToolTip);
--  else
--      if (not SpellEditBox:IsShown()) then
--          SpellEditBox:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
--          SpellEditBox:Show();
--      end
--  end
-- end



-- function CreateFrames_CfgBtn_SaveSpellCondition(FrameIndex, SpellID)
function CreateFrames_CfgBtn_SaveSpellCondition(self)
	-- Get saved condition of spell
	local FrameIndex = self.FrameIndex;
	local SpellID = self.SpellID;
	local SC_Stack, SC_Self, SC_OverGrow, SC_RedSecText, SC_OrderWtd = nil, nil, nil, nil, nil;
	local Chk_Stack, Chk_OverGrow, Chk_RedSecText, Chk_OrderWtd = false, false, false, false;

	-- // Get Checkbox and TextEdit Value From SpellConditionFrame and Recheck if valid.
	local function CreateFrames_CfgBtnFun_GetChkText(ChkBox, TextEdit)
		local ChkValue, NumValue = nil, nil;
		ChkValue = ChkBox:GetChecked();
		NumValue = TextEdit:GetText();
		NumValue = tonumber(NumValue);
		return ChkValue, NumValue;
	end
	Chk_Stack, SC_Stack = CreateFrames_CfgBtnFun_GetChkText(EA_SpellCondition_Frame_Stack, EA_SpellCondition_Frame_StackEditBox);
	if ((not Chk_Stack) or (SC_Stack == nil) or (SC_Stack <= 1)) then
		Chk_Stack = false;
		SC_Stack = nil;
	end

	SC_Self = EA_SpellCondition_Frame_Self:GetChecked()
	
	
	--CHKBOX 的勾選資訊回傳函數 GetChecked() : true表示打勾, false(nil)表示無打勾
	--if (SC_Self == 1) then 
	--	SC_Self = true;
	--else
	--	SC_Self = false;
	--end

	Chk_OverGrow, SC_OverGrow = CreateFrames_CfgBtnFun_GetChkText(EA_SpellCondition_Frame_OverGrow, EA_SpellCondition_Frame_OverGrowEditBox);
	if ((not Chk_OverGrow) or (SC_OverGrow == nil) or (SC_OverGrow <= 0) or (SC_OverGrow >= 100)) then
		Chk_OverGrow = false;
		SC_OverGrow = nil;
	end
	Chk_RedSecText, SC_RedSecText = CreateFrames_CfgBtnFun_GetChkText(EA_SpellCondition_Frame_RedSecText, EA_SpellCondition_Frame_RedSecTextEditBox);
	if ((not Chk_RedSecText) or (SC_RedSecText == nil) or (SC_RedSecText <= 0) or (SC_RedSecText >= 100)) then
		Chk_RedSecText = false;
		SC_RedSecText = nil;
	end
	Chk_OrderWtd, SC_OrderWtd = CreateFrames_CfgBtnFun_GetChkText(EA_SpellCondition_Frame_OrderWtd, EA_SpellCondition_Frame_OrderWtdEditBox);
	if ((not Chk_OrderWtd) or (SC_OrderWtd == nil) or (SC_OrderWtd <= 0) or (SC_OrderWtd >= 21)) then
		Chk_OrderWtd = false;
		SC_OrderWtd = nil;
	end


	-- // Save Checkbox and TextEdit Value To SaveVariables
	local function CreateFrames_CfgBtnFun_SaveToItem(EAItem)
		
		EAItem.stack = SC_Stack;
		EAItem.self = SC_Self;
		EAItem.overgrow = SC_OverGrow;
		EAItem.redsectext = SC_RedSecText;
		EAItem.orderwtd = SC_OrderWtd;
	end
	if (FrameIndex == 1) then
		CreateFrames_CfgBtnFun_SaveToItem(EA_Items[EA_playerClass][SpellID])
	-- elseif (FrameIndex == 2) then
	-- 	CreateFrames_CfgBtnFun_SaveToItem(EA_AltItems[EA_playerClass][SpellID])
	elseif (FrameIndex == 3) then
		CreateFrames_CfgBtnFun_SaveToItem(EA_Items[EA_CLASS_OTHER][SpellID])
	elseif (FrameIndex == 4) then
		CreateFrames_CfgBtnFun_SaveToItem(EA_TarItems[EA_playerClass][SpellID])
	elseif (FrameIndex == 5) then
		CreateFrames_CfgBtnFun_SaveToItem(EA_ScdItems[EA_playerClass][SpellID])
	end

	EA_SpellCondition_Frame:Hide();
end

local function EACFFun_EventsFrame_CheckSpellID(spellID, ReCheckSpell)
	local EA_name, EA_rank, EA_icon = GetSpellInfo(spellID);
	if EA_name == nil then EA_name = "" end;
	if EA_rank == nil then EA_rank = "" end;

	if (ReCheckSpell) then
		if (spellID == 33151) then
			EA_rank = "";
		elseif (spellID == 48517) then      -- Druid / Eclipse (Solar): replace the Icon as Wrath (Rank 1)
			_, _, EA_icon = GetSpellInfo(5176);
		elseif (spellID == 48518) then      -- Druid / Eclipse (Lunar): replace the Icon as Starfire (Rank 1)
			_, _, EA_icon = GetSpellInfo(2912);
		elseif (spellID == 8921) then       -- Druid / Moonfire: always use the starfall picture
			EA_icon = "Interface/Icons/Spell_Nature_Starfall";
		end
	end
	return EA_name, EA_rank, EA_icon;
end
-- function CreateFrames_CfgBtn_LoadSpellCondition(FrameIndex, SpellID)
function CreateFrames_CfgBtn_LoadSpellCondition(self)
	-- Get saved condition of spell
	local FrameIndex = self.FrameIndex;
	local SpellID = self.SpellID;
	local ReCheckSpell = false;
	if (FrameIndex == 1) then ReCheckSpell = true end;
	local SpellName, SpellRank, SpellIconPath = EACFFun_EventsFrame_CheckSpellID(SpellID, ReCheckSpell);
	if (SpellRank ~= nil and SpellRank ~= "") then SpellName = SpellName.."("..SpellRank..")" end;
	
	--EA_SpellCondition_Frame_SpellIcon:SetBackdrop({bgFile = SpellIconPath});
	
	--for 7.0 
	if not EA_SpellCondition_Frame_SpellIcon.texture then
		EA_SpellCondition_Frame_SpellIcon.texture = EA_SpellCondition_Frame_SpellIcon:CreateTexture()		
	end
	EA_SpellCondition_Frame_SpellIcon.texture:SetAllPoints(EA_SpellCondition_Frame_SpellIcon)
	EA_SpellCondition_Frame_SpellIcon.texture:SetTexture(SpellIconPath)
	-----------------------------------------------------------------------
	
	EA_SpellCondition_Frame_SpellNameText:SetText(SpellName);
	local iTextWidth = EA_SpellCondition_Frame_SpellNameText:GetTextWidth();
	EA_SpellCondition_Frame_SpellNameText:SetWidth(iTextWidth);
	local function SNTGameToolTip()
		GameTooltip:SetOwner(EA_SpellCondition_Frame_SpellNameText, "ANCHOR_RIGHT");
		GameTooltip:SetSpellByID(SpellID);
	end
	EA_SpellCondition_Frame_SpellNameText:SetScript("OnEnter", SNTGameToolTip);


	-- // Get Checkbox and TextEdit Value From SaveVariables
	local SC_Stack, SC_Self, SC_OverGrow, SC_RedSecText, SC_OrderWtd = nil, nil, nil, nil, nil;
	local Chk_Stack, Chk_OverGrow, Chk_RedSecText, Chk_OrderWtd = false, false, false, false;
	local function CreateFrames_CfgBtnFun_GetFromSave(EAItem)
		
		SC_Stack = EAItem.stack;
		SC_Self = EAItem.self;
		SC_OverGrow = EAItem.overgrow;
		SC_RedSecText = EAItem.redsectext;
		SC_OrderWtd = EAItem.orderwtd;
	end
	if (FrameIndex == 1) then
		CreateFrames_CfgBtnFun_GetFromSave(EA_Items[EA_playerClass][SpellID]);
	-- elseif (FrameIndex == 2) then
	-- 	CreateFrames_CfgBtnFun_GetFromSave(EA_AltItems[EA_playerClass][SpellID]);
	elseif (FrameIndex == 3) then
		CreateFrames_CfgBtnFun_GetFromSave(EA_Items[EA_CLASS_OTHER][SpellID]);
	elseif (FrameIndex == 4) then
		CreateFrames_CfgBtnFun_GetFromSave(EA_TarItems[EA_playerClass][SpellID]);
	elseif (FrameIndex == 5) then
		CreateFrames_CfgBtnFun_GetFromSave(EA_ScdItems[EA_playerClass][SpellID]);
	end
	if (SC_Stack == nil or SC_Stack <=1) then
		Chk_Stack = false;
		SC_Stack = 1;
	else
		Chk_Stack = true;
	end
	
	if (SC_OverGrow == nil or SC_OverGrow <=0) then
		Chk_OverGrow = false;
		SC_OverGrow = 100;
	else
		Chk_OverGrow = true;
	end
	if (SC_RedSecText == nil or SC_RedSecText <=0) then
		Chk_RedSecText = false;
		SC_RedSecText = -1;
	else
		Chk_RedSecText = true;
	end
	if (SC_OrderWtd == nil or SC_OrderWtd <=0 or SC_OrderWtd >=21) then
		Chk_OrderWtd = false;
		SC_OrderWtd = 1;
	else
		Chk_OrderWtd = true;
	end


	-- Set SpellCondition Stack Checkbox & Editbox
	local function CreateFrames_CfgBtnFun_SetChkText(ChkBox, TextEdit, ChkValue, NumValue)
		ChkBox:SetChecked(ChkValue);
		if (ChkValue) then
			TextEdit:SetText(NumValue);
		else
			TextEdit:SetText("");
		end
	end
	CreateFrames_CfgBtnFun_SetChkText(EA_SpellCondition_Frame_Stack, EA_SpellCondition_Frame_StackEditBox, Chk_Stack, SC_Stack);
	EA_SpellCondition_Frame_Self:SetChecked(SC_Self);
	CreateFrames_CfgBtnFun_SetChkText(EA_SpellCondition_Frame_OverGrow, EA_SpellCondition_Frame_OverGrowEditBox, Chk_OverGrow, SC_OverGrow);
	CreateFrames_CfgBtnFun_SetChkText(EA_SpellCondition_Frame_RedSecText, EA_SpellCondition_Frame_RedSecTextEditBox, Chk_RedSecText, SC_RedSecText);
	CreateFrames_CfgBtnFun_SetChkText(EA_SpellCondition_Frame_OrderWtd, EA_SpellCondition_Frame_OrderWtdEditBox, Chk_OrderWtd, SC_OrderWtd);

	EA_SpellCondition_Frame:ClearAllPoints();
	EA_SpellCondition_Frame:SetPoint("LEFT", EA_Options_Frame, "RIGHT", 0, 0);
	EA_SpellCondition_Frame:Show();
	EA_SpellCondition_Frame_Save.FrameIndex = FrameIndex;
	EA_SpellCondition_Frame_Save.SpellID = SpellID;
	EA_SpellCondition_Frame_Save:SetScript("OnClick", CreateFrames_CfgBtn_SaveSpellCondition);
	-- EA_SpellCondition_Frame_Save:SetScript("OnClick", function()
	-- 	CreateFrames_CfgBtn_SaveSpellCondition(FrameIndex, SpellID);
	-- end);
end

function CreateFrames_CreateSpellListCfgBtn(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, FrameIndex)
	SpellID = tonumber(SpellID);

	local SpellCfgBtn = _G[FrameNamePrefix..SpellID];
	if (SpellCfgBtn == nil) then
		SpellCfgBtn = CreateFrame("Button", FrameNamePrefix..SpellID, ParentFrameObj);
	end
	SpellCfgBtn:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
	SpellCfgBtn:SetWidth(25);
	SpellCfgBtn:SetHeight(25);
	SpellCfgBtn:SetNormalTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton-Down");
	SpellCfgBtn:SetHighlightTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton-Highlight", "BLEND");
	if (FrameIndex <= 5) then
		SpellCfgBtn.FrameIndex = FrameIndex;
		SpellCfgBtn.SpellID = SpellID;
		SpellCfgBtn:SetScript("OnClick", CreateFrames_CfgBtn_LoadSpellCondition);
		-- SpellCfgBtn:SetScript("OnClick", function()
		-- 	CreateFrames_CfgBtn_LoadSpellCondition(FrameIndex, SpellID);
		-- end);
	elseif (FrameIndex == 6) then
		SpellCfgBtn.GroupID = SpellID;
		SpellCfgBtn:SetScript("OnClick", CreateFrames_CfgBtn_LoadGroupEvent);
		-- SpellCfgBtn:SetScript("OnClick", function()
		-- 	CreateFrames_CfgBtn_LoadGroupEvent(SpellID);
		-- end);
	end
	SpellCfgBtn:Show();
end


local function CreateFrames_CfgBtn_GroupFrame_OnMouseDown(self)
	self:StartMoving();
end

local function CreateFrames_CfgBtn_GroupFrame_OnMouseUp(self)
	local iGroupID = self.GroupID;
	self:StopMovingOrSizing();
	local EA_point, _, EA_relativePoint, EA_xOfs, EA_yOfs = self:GetPoint();
	-- EA_GrpItems[EA_playerClass][iGroupID].IconPoint = EA_point;
	-- EA_GrpItems[EA_playerClass][iGroupID].IconRelatePoint = EA_relativePoint;
	-- EA_GrpItems[EA_playerClass][iGroupID].LocX = EA_xOfs;
	-- EA_GrpItems[EA_playerClass][iGroupID].LocY = EA_yOfs;
	self.GC.IconPoint = EA_point;
	self.GC.IconRelatePoint = EA_relativePoint;
	self.GC.LocX = EA_xOfs;
	self.GC.LocY = EA_yOfs;
end

local function CreateFrames_CfgBtn_ShowGroupFramePos(self)
	local iGroupID = self.GroupID;
	local FrameNamePrefix = "EAGrpAnchorFrame_";
	local aGroupChecks = EA_GrpItems[EA_playerClass][iGroupID];
	local eaf = _G[FrameNamePrefix..iGroupID];
	if (eaf == nil) then
		eaf = CreateFrame("Frame", FrameNamePrefix..iGroupID, UIParent);
		eaf:SetMovable(true);
		eaf:EnableMouse(true);
		eaf.spellName = eaf:CreateFontString(FrameNamePrefix..iGroupID.."_Name","OVERLAY");
		eaf.spellTimer = eaf:CreateFontString(FrameNamePrefix..iGroupID.."_Timer","OVERLAY");
		eaf.spellStack = eaf:CreateFontString(FrameNamePrefix..iGroupID.."_Stack","OVERLAY");
		eaf:SetScript("OnMouseDown", CreateFrames_CfgBtn_GroupFrame_OnMouseDown);
		eaf:SetScript("OnMouseUp", CreateFrames_CfgBtn_GroupFrame_OnMouseUp);
		eaf:ClearAllPoints();
		eaf:SetFrameStrata("DIALOG");
		-- eaf:SetFrameStrata("LOW");
	
		eaf.spellName:SetFontObject(ChatFontNormal);
		eaf.spellName:SetPoint("BOTTOM", 0, -15);
	
		eaf.spellTimer:SetFontObject(ChatFontNormal);
		eaf.spellTimer:SetPoint("TOP", 0, EA_Config.TimerFontSize*1.1);
	
		eaf.spellStack:SetFontObject(ChatFontNormal);
		eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 15);
		
		eaf.texture = eaf:CreateTexture()
		eaf.texture:SetAllPoints(eaf)
		
		eaf:Hide();
	end

	if (eaf:IsShown()) then
		eaf:Hide();
	else
		if eaf.GC == nil then eaf.GC = { } end;
		eaf.GC = aGroupChecks;
		--eaf:SetBackdrop({bgFile = eaf.GC.Spells[1].SpellIconPath});
		
		--for 7.0
		--if not(eaf.texture) then eaf.texture = eaf:CreateTexture() end
		--eaf.texture:SetAllPoints(eaf)
		
		
		eaf.texture:SetTexture(eaf.GC.Spells[1].SpellIconPath)
		----------------------------------------------------------
		
		if (eaf.GC.IconAlpha ~= nil) then eaf:SetAlpha(eaf.GC.IconAlpha) end;
		eaf:SetPoint(eaf.GC.IconPoint, UIParent, eaf.GC.IconRelatePoint, eaf.GC.LocX, eaf.GC.LocY);
		eaf:SetWidth(eaf.GC.IconSize);
		eaf:SetHeight(eaf.GC.IconSize);
		if (EA_Config.ShowName == true) then
			eaf.spellName:SetText(eaf.GC.Spells[1].SpellName);
			SfontName, SfontSize = eaf.spellName:GetFont();
			eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
		else
			eaf.spellName:SetText("");
		end
		eaf:Show();
	end
end
function CreateFrames_CreateSpellListCfgBtn2(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, FrameIndex)
	SpellID = tonumber(SpellID);

	local SpellCfgBtn = _G[FrameNamePrefix..SpellID];
	if (SpellCfgBtn == nil) then
		SpellCfgBtn = CreateFrame("Button", FrameNamePrefix..SpellID, ParentFrameObj);
	end
	SpellCfgBtn:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
	SpellCfgBtn:SetWidth(25);
	SpellCfgBtn:SetHeight(25);
	SpellCfgBtn:SetNormalTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton2-Down");
	SpellCfgBtn:SetHighlightTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton2-Highlight", "BLEND");
	SpellCfgBtn.GroupID = SpellID;
	SpellCfgBtn:SetScript("OnClick", CreateFrames_CfgBtn_ShowGroupFramePos);
	SpellCfgBtn:Show();
end

-- function CreateFrames_CreateSpellListFontStr(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY)
--  SpellID = tonumber(SpellID);
--
--  local SpellFontStr = _G[FrameNamePrefix..SpellID];
--  if (SpellFontStr == nil) then
--      SpellFontStr = ParentFrameObj:CreateFontString(FrameNamePrefix..SpellID, "ARTWORK", "GameFontNormal");
--      SpellFontStr:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
--      SpellFontStr:SetWidth(60);
--      SpellFontStr:SetHeight(25);
--      SpellFontStr:SetText("["..tostring(SpellID).."]");
--  else
--      if (not SpellFontStr:IsShown()) then
--          SpellFontStr:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
--          SpellFontStr:Show();
--      end
--  end
-- end

-- function CreateFrames_CfgBtn_LoadGroupEvent(GroupID)
function CreateFrames_CfgBtn_LoadGroupEvent(self)
	local GroupID = self.GroupID;
	EA_GroupEventSetting_Frame:ClearAllPoints();
	EA_GroupEventSetting_Frame:SetPoint("TOPLEFT", EA_Options_Frame, "TOPLEFT", -50, -20);
	EA_GroupEventSetting_Frame:Show();
	local iGroupID = self.GroupID;
	local eaf = _G["EAGrpAnchorFrame_"..GroupID];
	if (eaf ~= nil) then eaf:Hide() end;
	EAFun_GroupEvent_LoadGroupEventToFrame(GroupID);
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- CreateSpellList, ClearSpellList, RefreshSpellList
--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_CreateSpellList(EAItems, typeIndex)
	for index,value in pairsByKeys(EAItems) do
		CreateFrames_CreateSpellFrame(index, typeIndex);
	end
end
function CreateFrames_EventsFrame_CreateSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_CreateSpellList(EA_Items[EA_playerClass], 1);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_CreateSpellList(EA_AltItems[EA_playerClass], 1);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_CreateSpellList(EA_Items[EA_CLASS_OTHER], 1);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_CreateSpellList(EA_TarItems[EA_playerClass], 2);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_CreateSpellList(EA_ScdItems[EA_playerClass], 3);
	elseif (FrameIndex == 6) then
		for iGrpIndex, aGrpChecks in ipairs (EA_GrpItems[EA_playerClass]) do
			CreateFrames_CreateGroupCheckFrame(iGrpIndex);
		end
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_ClearSpellList(EAItems, FrameNamePrefix)
	local f1, f2, f3, f4;
	for index,value in pairsByKeys(EAItems) do
		f1 = _G[FrameNamePrefix.."_Icon_"..index];
		f2 = _G[FrameNamePrefix.."_ChkBtn_"..index];
		f3 = _G[FrameNamePrefix.."_CfgBtn_"..index];
		f4 = _G[FrameNamePrefix.."_CfgBtn2_"..index];
		if f1 ~= nil then
			f1:Hide();
		end
		if f2 ~= nil then
			f2:SetScript("OnClick", nil);
			f2:UnregisterAllEvents();
			f2:Hide();
		end
		if f3 ~= nil then
			f3:SetScript("OnClick", nil);
			f3:UnregisterAllEvents();
			f3:Hide();
		end
		if f4 ~= nil then
			f4:SetScript("OnClick", nil);
			f4:UnregisterAllEvents();
			f4:Hide();
		end
		f1 = nil;
		f2 = nil;
		f3 = nil;
		f4 = nil;
	end
	collectgarbage();
end
local function EACFFun_EventsFrame_ClearSpellFrame(EAItems, FrameNamePrefix)
	local eaf = nil;
	for iGrpIndex, aGrpChecks in ipairs (EAItems) do
		eaf = _G[FrameNamePrefix..iGrpIndex];
		if (eaf ~= nil) then
			eaf:UnregisterAllEvents();
			eaf:Hide();
			eaf = nil;	
		end
	end
	collectgarbage();
end
function CreateFrames_EventsFrame_ClearSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_ClearSpellList(EA_Items[EA_playerClass], "EA_ClassFrame");
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_ClearSpellList(EA_AltItems[EA_playerClass], "EA_ClassAltFrame");
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_ClearSpellList(EA_Items[EA_CLASS_OTHER], "EA_OtherFrame");
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_ClearSpellList(EA_TarItems[EA_playerClass], "EA_TargetFrame");
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_ClearSpellList(EA_ScdItems[EA_playerClass], "EA_SCDFrame");
	elseif (FrameIndex == 6) then
		EACFFun_EventsFrame_ClearSpellList(EA_GrpItems[EA_playerClass], "EA_GroupFrame");
		EACFFun_EventsFrame_ClearSpellFrame(EA_GrpItems[EA_playerClass], "EAGrpFrame_");
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EAItems, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, EditboxObj)
	local CanCfg, ReCheckSpell = false, false;
	if FrameIndex == 1 then
		CanCfg = true;
		ReCheckSpell = true;
	elseif FrameIndex == 3 then
		CanCfg = true;
	elseif FrameIndex == 4 then
		CanCfg = true;
	end
	for index, value in pairsByKeys(EAItems) do
		-- local EA_name, EA_rank, EA_icon = GetSpellInfo(index);
		local EA_name, EA_rank, EA_icon = EACFFun_EventsFrame_CheckSpellID(index, ReCheckSpell);
		CreateFrames_CreateSpellListIcon(index, FrameNamePrefix.."_Icon_", ParentFrameObj, LocOffsetX, LocOffsetY, EA_icon);
		CreateFrames_CreateSpellListChkbox(index, FrameNamePrefix.."_ChkBtn_", ParentFrameObj, LocOffsetX, LocOffsetY, EA_name, EA_rank, FrameIndex, EditboxObj);
		if (CanCfg) then CreateFrames_CreateSpellListCfgBtn(index, FrameNamePrefix.."_CfgBtn_", ParentFrameObj, LocOffsetX, LocOffsetY, FrameIndex) end;
		LocOffsetY = LocOffsetY - 25;
	end
end
function CreateFrames_EventsFrame_RefreshSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_Items[EA_playerClass], "EA_ClassFrame", EA_Class_Events_Frame_SpellScrollFrameList, 0, 0, EA_Class_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_AltItems[EA_playerClass], "EA_ClassAltFrame", EA_ClassAlt_Events_Frame_SpellScrollFrameList, 0, 0, EA_ClassAlt_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_Items[EA_CLASS_OTHER], "EA_OtherFrame", EA_Other_Events_Frame_SpellScrollFrameList, 0, 0, EA_Other_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_TarItems[EA_playerClass], "EA_TargetFrame", EA_Target_Events_Frame_SpellScrollFrameList, 0, 0, EA_Target_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_ScdItems[EA_playerClass], "EA_SCDFrame", EA_SCD_Events_Frame_SpellScrollFrameList, 0, 0, EA_SCD_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 6) then
		local LocOffsetY = 0;
		local EA_name, EA_rank, EA_icon = "", "", "";
		for iGrpIndex, aGrpChecks in ipairs (EA_GrpItems[EA_playerClass]) do
			EA_name, _, EA_icon = EACFFun_EventsFrame_CheckSpellID(aGrpChecks.Spells[1].SpellIconID, false);
			EA_rank = EA_XGRPALERT_TALENTS;
			if (aGrpChecks.ActiveTalentGroup ~= nil) then
				
				if (aGrpChecks.ActiveTalentGroup == 1) then 
					EA_rank = EA_XGRPALERT_TALENT1
				elseif (aGrpChecks.ActiveTalentGroup == 2) then
					EA_rank = EA_XGRPALERT_TALENT2
				elseif (aGrpChecks.ActiveTalentGroup == 3) then
					EA_rank = EA_XGRPALERT_TALENT3
				elseif (aGrpChecks.ActiveTalentGroup == 4) then
					EA_rank = EA_XGRPALERT_TALENT4
				end								
			end
			CreateFrames_CreateSpellListIcon(iGrpIndex, "EA_GroupFrame_Icon_", EA_Group_Events_Frame_SpellScrollFrameList, 0, LocOffsetY, EA_icon);
			CreateFrames_CreateSpellListChkbox(iGrpIndex, "EA_GroupFrame_ChkBtn_", EA_Group_Events_Frame_SpellScrollFrameList, 0, LocOffsetY, EA_name, EA_rank, FrameIndex, EA_Group_Events_Frame_SpellEditBox);
			CreateFrames_CreateSpellListCfgBtn(iGrpIndex, "EA_GroupFrame_CfgBtn_", EA_Group_Events_Frame_SpellScrollFrameList, 0, LocOffsetY, FrameIndex);
			CreateFrames_CreateSpellListCfgBtn2(iGrpIndex, "EA_GroupFrame_CfgBtn2_", EA_Group_Events_Frame_SpellScrollFrameList, -25, LocOffsetY, FrameIndex);
			LocOffsetY = LocOffsetY - 25;
		end
	end
end


local GC_PowerType={[0]="MANA", [1]="RAGE", [2]="FOCUS", [3]="ENERGY", [4]="COMBO_POINT", [5]="RUNES", [6]="RUNIC_POWER", [7]="SOUL_SHARDS", [8]="LUNAR_POWER", 
	[9]="HOLY_POWER", [10]="ALT_POWER", [11]="MAELSTROM", [12]="LIGHT_FORCE", [13]="INSANITY", [14]="BURNING_EMBERS", [15]="DEMONIC_FURY", [16]="ARCANE_CHARGES", [17]="FURY",[18]="PAIN"};
function CreateFrames_CreateGroupCheckFrame(iGroupIndex)
	local FrameNamePrefix = "EAGrpFrame_";
	local aGroupChecks = EA_GrpItems[EA_playerClass][iGroupIndex];
	local eaf = _G[FrameNamePrefix..iGroupIndex];
	if (eaf == nil) then
		eaf = CreateFrame("Frame", FrameNamePrefix..iGroupIndex, UIParent);
		eaf.spellName = eaf:CreateFontString(FrameNamePrefix..iGroupIndex.."_Name","OVERLAY");
		eaf.spellTimer = eaf:CreateFontString(FrameNamePrefix..iGroupIndex.."_Timer","OVERLAY");
		eaf.spellStack = eaf:CreateFontString(FrameNamePrefix..iGroupIndex.."_Stack","OVERLAY");
	end
	-- eaf.noCooldownCount = true;
	-- eaf:SetFrameStrata("DIALOG");
	eaf:ClearAllPoints();
	eaf:SetFrameStrata("HIGH");
	-- eaf:SetFrameStrata("LOW");

	eaf.spellName:SetFontObject(ChatFontNormal);
	eaf.spellName:SetPoint("BOTTOM", 0, -15);

	eaf.spellTimer:SetFontObject(ChatFontNormal);
	eaf.spellTimer:SetPoint("TOP", 0, EA_Config.TimerFontSize*1.1);

	eaf.spellStack:SetFontObject(ChatFontNormal);
	eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 15);
	
	if eaf.GC == nil then eaf.GC = { } end;
	eaf.GC = aGroupChecks;

        local aGroupFrameEvents = {};
        local aGroupFrameIndexs = {};
        local sEventType, iEventSeq, sname, iconpath = "", 0, "", "";
	for iInd_i, aValue_i in ipairs(aGroupChecks.Spells) do
		sname, _, iconpath = GetSpellInfo(aValue_i.SpellIconID);
		eaf.GC.Spells[iInd_i].SpellName = sname;
		eaf.GC.Spells[iInd_i].SpellIconPath = iconpath;
		eaf.GC.Spells[iInd_i].SpellResult = false;
		for iInd_j, aValue_j in ipairs(aValue_i.Checks) do
			eaf.GC.Spells[iInd_i].Checks[iInd_j].CheckResult = false;
			if (iInd_j == 1) then eaf.GC.Spells[iInd_i].Checks[iInd_j].CheckAndOp = true end;
			for iInd_k, aValue_k in ipairs(aValue_j.SubChecks) do
				if (iInd_k == 1) then eaf.GC.Spells[iInd_i].Checks[iInd_j].SubChecks[iInd_k].SubCheckAndOp = true end;
				sEventType = aValue_k.EventType;
				if aGroupFrameEvents[sEventType] == nil then aGroupFrameEvents[sEventType] = 0 end;
				aGroupFrameEvents[sEventType] = aGroupFrameEvents[sEventType] + 1;
				iEventSeq = aGroupFrameEvents[sEventType];
				if aGroupFrameIndexs[sEventType] == nil then aGroupFrameIndexs[sEventType] = {} end;
				if aGroupFrameIndexs[sEventType][iGroupIndex] == nil then aGroupFrameIndexs[sEventType][iGroupIndex] = {} end;
				if aGroupFrameIndexs[sEventType][iGroupIndex][iEventSeq] == nil then aGroupFrameIndexs[sEventType][iGroupIndex][iEventSeq] = {} end;
				aGroupFrameIndexs[sEventType][iGroupIndex][iEventSeq].Spells = iInd_i;
				aGroupFrameIndexs[sEventType][iGroupIndex][iEventSeq].Checks = iInd_j;
				aGroupFrameIndexs[sEventType][iGroupIndex][iEventSeq].SubChecks = iInd_k;
				if (sEventType == "UNIT_POWER_UPDATE") then
					eaf.GC.Spells[iInd_i].Checks[iInd_j].SubChecks[iInd_k].PowerType = GC_PowerType[aValue_k.PowerTypeNum];
				end
				eaf.GC.Spells[iInd_i].Checks[iInd_j].SubChecks[iInd_k].SubCheckResult = false;
				
				-- // Parameters Transfrom, From EAM 4.7.01 -> 4.7.02
				if (aValue_k.PowerLessThan ~= nil) then
					if (aValue_k.PowerLessThan) then aValue_k.PowerCompType = 2 else aValue_k.PowerCompType = 4 end;
					aValue_k.PowerLessThan = nil;
				end
				if (aValue_k.HealthLessThan ~= nil) then
					if (aValue_k.HealthLessThan) then aValue_k.HealthCompType = 2 else aValue_k.HealthCompType = 4 end;
					aValue_k.HealthLessThan = nil;
				end
				if (aValue_k.StackLessThan ~= nil) then
					if (aValue_k.StackLessThan) then aValue_k.StackCompType = 2 else aValue_k.StackCompType = 4 end;
					aValue_k.StackLessThan = nil;
				end
				if (aValue_k.TimeLessThan ~= nil) then
					if (aValue_k.TimeLessThan) then aValue_k.TimeCompType = 2 else aValue_k.TimeCompType = 4 end;
					aValue_k.TimeLessThan = nil;
				end
				if (aValue_k.ComboLessThan ~= nil) then
					if (aValue_k.ComboLessThan) then aValue_k.ComboCompType = 2 else aValue_k.ComboCompType = 4 end;
					aValue_k.ComboLessThan = nil;
				end
			end
		end
	end

	eaf:UnregisterAllEvents();
	for sEventType, iEventSeq in pairs(aGroupFrameEvents) do
		eaf:RegisterEvent(sEventType == "UNIT_POWER" and "UNIT_POWER_UPDATE" or sEventType);
		if GC_IndexOfGroupFrame[sEventType] == nil then GC_IndexOfGroupFrame[sEventType] = {} end;
		if GC_IndexOfGroupFrame[sEventType][iGroupIndex] == nil then GC_IndexOfGroupFrame[sEventType][iGroupIndex] = {} end;
		GC_IndexOfGroupFrame[sEventType][iGroupIndex] = aGroupFrameIndexs[sEventType][iGroupIndex];
	end
	if (eaf.GC.ActiveTalentGroup ~= nil) then eaf:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end;
	if (eaf.GC.HideOnLeaveCombat ~= nil) then eaf:RegisterEvent("PLAYER_REGEN_ENABLED") end;
	eaf:RegisterEvent("PLAYER_TARGET_CHANGED")
	eaf:SetScript("OnEvent", EventAlert_GroupFrameCheck_OnEvent);

	eaf.GC.GroupIndex = iGroupIndex;
	eaf.GC.GroupIconID = 0;
	eaf.GC.GroupResult = false;
	eaf:ClearAllPoints();
	eaf:SetPoint(aGroupChecks.IconPoint, UIParent, aGroupChecks.IconRelatePoint, aGroupChecks.LocX, aGroupChecks.LocY);	-- 0, -100
	eaf:SetWidth(0);
	eaf:SetHeight(0);
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Select All, LoadDefault, Add Spell, Del Spell
--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_SelAll(EAItems, FrameName, Status)
	for index, value in pairsByKeys(EAItems) do
		index = tonumber(index);
		EAItems[index].enable = Status;
		local f2 = _G[FrameName..index];
		if (f2 ~= nil) then f2:SetChecked(Status) end;
	end
end
function CreateFrames_EventsFrame_SelAll(FrameIndex, Status)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_SelAll(EA_Items[EA_playerClass], "EA_ClassFrame_ChkBtn_", Status);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_SelAll(EA_AltItems[EA_playerClass], "EA_ClassAltFrame_ChkBtn_", Status);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_SelAll(EA_Items[EA_CLASS_OTHER], "EA_OtherFrame_ChkBtn_", Status);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_SelAll(EA_TarItems[EA_playerClass], "EA_TargetFrame_ChkBtn_", Status);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_SelAll(EA_ScdItems[EA_playerClass], "EA_SCDFrame_ChkBtn_", Status);
	elseif (FrameIndex == 6) then
		EACFFun_EventsFrame_SelAll(EA_GrpItems[EA_playerClass], "EA_GroupFrame_ChkBtn_", Status);
	end
end

--------------------------------------------------------------------------------
function CreateFrames_EventsFrame_LoadDefault(FrameIndex)
	CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
	EventAlert_LoadClassSpellArray(FrameIndex);
	CreateFrames_EventsFrame_CreateSpellList(FrameIndex);
	CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
end

--------------------------------------------------------------------------------
local function EACFFun_GetSpellButton_ByFrame(FrameIndex)
	if (FrameIndex == 1) then
		return EA_Class_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 2) then
		return EA_ClassAlt_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 3) then
		return EA_Other_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 4) then
		return EA_Target_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 5) then
		return EA_SCD_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 6) then
		return EA_Group_Events_Frame_SpellEditBox;
	end
end
function CreateFrames_EventsFrame_AddSpell(FrameIndex)
	if (FrameIndex <= 5) then
		local typeIndex = 1;
		if (FrameIndex == 4) then typeIndex = 2 end;
		if (FrameIndex == 5) then typeIndex = 3 end;
	
		local SpellButton = EACFFun_GetSpellButton_ByFrame(FrameIndex);
		SpellButton:ClearFocus();
		local spellID = SpellButton:GetText();
		if spellID ~= nil and spellID ~= "" then
			spellID = tonumber(spellID);
			-- Check if is a valid spellID
			local sname = GetSpellInfo(spellID);
			if (sname ~= nil) then
				CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
				-- 為了便於分享法術id 所以儲存時增加儲存法術名稱
				local sname = GetSpellInfo(spellID);
				if (FrameIndex==1 and EA_Items[EA_playerClass][spellID] == nil) then EA_Items[EA_playerClass][spellID] = {enable=true,name=sname,self=true} end;
				if (FrameIndex==2 and EA_AltItems[EA_playerClass][spellID] == nil) then EA_AltItems[EA_playerClass][spellID] = {enable=true,name=sname} end;
				if (FrameIndex==3 and EA_Items[EA_CLASS_OTHER][spellID] == nil) then EA_Items[EA_CLASS_OTHER][spellID] = {enable=true,name=sname} end;
				if (FrameIndex==4 and EA_TarItems[EA_playerClass][spellID] == nil) then EA_TarItems[EA_playerClass][spellID] = {enable=true,name=sname,self=true} end;
				if (FrameIndex==5 and EA_ScdItems[EA_playerClass][spellID] == nil) then EA_ScdItems[EA_playerClass][spellID] = {enable=true,name=sname} end;
				CreateFrames_CreateSpellFrame(spellID, typeIndex);
				CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
			end
		end
	elseif (FrameIndex == 6) then
		-- Call Setting windows
		-- CreateFrames_CfgBtn_LoadGroupEvent(#EA_GrpItems[EA_playerClass] + 1);
		EA_Group_Events_Frame_AddSpell.GroupID = #EA_GrpItems[EA_playerClass] + 1;
		CreateFrames_CfgBtn_LoadGroupEvent(EA_Group_Events_Frame_AddSpell);
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EAItems, FrameName)
	spellID = tonumber(spellID);
	local TempPlayerClass = {};
	local IsCurrSpell = false;
	for index,value in pairsByKeys(EAItems) do
		if (index ~= spellID) then
			TempPlayerClass[index] = value; -- Store the existed spells
		else
			IsCurrSpell = true;             -- Find the spell match to delete
		end;
	end
	-- Check if is a spell in current list
	if (IsCurrSpell) then
        EA_Deleted = EA_Deleted or {} EA_Deleted[spellID] = 1
		CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
		if (FrameIndex == 1) then
			EA_Items[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 2) then
			EA_AltItems[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 3) then
			EA_Items[EA_CLASS_OTHER] = TempPlayerClass;
		elseif (FrameIndex == 4) then
			EA_TarItems[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 5) then
			EA_ScdItems[EA_playerClass] = TempPlayerClass;
		end
		local eaf = _G[FrameName..spellID];
		eaf:SetScript("OnUpdate", nil);
		eaf:Hide();
		eaf = nil;
		CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
	end
end

function CreateFrames_EventsFrame_DelSpell(FrameIndex)
	local SpellButton = EACFFun_GetSpellButton_ByFrame(FrameIndex);
	SpellButton:ClearFocus();
	local spellID = SpellButton:GetText();
	if spellID ~= nil and spellID ~= "" then
		if (FrameIndex == 1) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_Items[EA_playerClass], "EAFrame_");
		elseif (FrameIndex == 2) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_AltItems[EA_playerClass], "EAFrame_");
		elseif (FrameIndex == 3) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_Items[EA_CLASS_OTHER], "EAFrame_");
		elseif (FrameIndex == 4) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_TarItems[EA_playerClass], "EATarFrame_");
		elseif (FrameIndex == 5) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_ScdItems[EA_playerClass], "EAScdFrame_");
		elseif (FrameIndex == 6) then
			-- delete all frames
			CreateFrames_EventsFrame_ClearSpellList(6);
			-- delete from GrpItems
			table.remove(EA_GrpItems[EA_playerClass], spellID);
			-- wipe GC_IndexOfGroupFrame
			GC_IndexOfGroupFrame = {};
			-- create all frames
			CreateFrames_EventsFrame_CreateSpellList(6);
			-- refresh all icons
			CreateFrames_EventsFrame_RefreshSpellList(6);
		end
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_RemoveAll(FrameIndex, EAItems, FrameName)
	CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
	
	for index,value in pairsByKeys(EAItems) do
		if index ~= nil and index ~= "" then
			local spellID = tonumber(index);
			local eaf = _G[FrameName..spellID];
			eaf:SetScript("OnUpdate", nil);
			eaf:Hide();
			eaf = nil;
		end
	end
	
	-- clear all spells
	EAItems = wipe(EAItems);
	
	CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
end
function CreateFrames_EventsFrame_RemoveAllSpells(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_RemoveAll(FrameIndex, EA_Items[EA_playerClass], "EAFrame_");
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_RemoveAll(FrameIndex, EA_AltItems[EA_playerClass], "EAFrame_");
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_RemoveAll(FrameIndex, EA_Items[EA_CLASS_OTHER], "EAFrame_");
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_RemoveAll(FrameIndex, EA_TarItems[EA_playerClass], "EATarFrame_");
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_RemoveAll(FrameIndex, EA_ScdItems[EA_playerClass], "EAScdFrame_");
	end
end

--------------------------------------------------------------------------------

function CreateFrames_CreateMinimapOptionFrame()
	
	local eaf = CreateFrame("BUTTON","EA_MinimapOption",Minimap)
	
	eaf:SetWidth(30)
	eaf:SetHeight(30)
	eaf:SetPoint("TOPRIGHT",Minimap,"BOTTOMRIGHT",10,-60)
	eaf:SetAlpha(0.7)
	eaf:SetBackdrop({bgFile = "Interface/Icons/Trade_Engineering"})	
	--啟用滑鼠相關功能
	eaf:EnableMouse(true)	
	--啟用可移動框架功能
	eaf:SetMovable(true)						
	--註冊滑鼠左鍵按下事件
	eaf:RegisterForClicks("LeftButtonDown")
	--註冊滑鼠右鍵拖曳事件
	eaf:RegisterForDrag("RightButton")
	
	eaf:SetScript("OnClick", function(self,button)																	
									if not(EA_Options_Frame:IsVisible()) then			
										EA_Options_Frame:Show()
									else						
										EA_Options_Frame:Hide()
									end
							end
				)
	eaf:SetScript("OnDragStart", function(self,button)																	
									eaf:StartMoving()
							end
				)					
	eaf:SetScript("OnDragStop", function(self,button)																	
									eaf:StopMovingOrSizing()
							end
				)					
	eaf:SetScript("OnReceiveDrag", function(self)
									--self 為拖曳後新位置的框架物件
									local newX = self:GetLeft()
									local newY = self:GetTop()
									return
							end
				)									
	eaf:SetScript("OnEnter", function()	
								eaf:SetAlpha(1)	
								GameTooltip:SetOwner(eaf,"BOTTOM_LEFT")
								local t=""
								t = t..EA_XCMD_CMDHELP["TITLE"].."\n"
								t = t..EA_XCMD_CMDHELP["OPT"].."\n"
								t = t..EA_XCMD_CMDHELP["HELP"].."\n"
								for k,v in pairs(EA_XCMD_CMDHELP) do
									if v[1] then t = t..v[1].."\n"..v[2].."\n" end									
								end
								GameTooltip:SetText(t)
							end	)
	eaf:SetScript("OnLeave", function()	
								eaf:SetAlpha(0.8)
								GameTooltip:Hide()
							end	)
							
	if EA_Config.OPTION_ICON == true then
		EA_MinimapOption:Show()
	else
		EA_MinimapOption:Hide()
	end
end
