-- Prevent tainting global _.
local _
local _G = _G


function EventAlert_Options_OnLoad()
	-- UIPanelWindows["EA_Options_Frame"] = {area = "center", pushable = 0};
end

function EAFun_SetButtonState(button, state)
	if state == 1 then
		button:SetButtonState("PUSHED", true);
	else
		button:SetButtonState("NORMAL", false);
	end
end

function EventAlert_Options_Init()
	EA_Options_Frame_Header_Text:SetFontObject(GameFontNormal);
	EA_Options_Frame_Header_Text:SetText("EventAlertMod Options");
	EA_Options_Frame_VerUrlText:SetText(EA_XOPT_VERURLTEXT);

	EA_Options_Frame_DoAlertSound:SetChecked(EA_Config.DoAlertSound);
	EA_Options_Frame_ShowFrame:SetChecked(EA_Config.ShowFrame);
	EA_Options_Frame_ShowName:SetChecked(EA_Config.ShowName);
	EA_Options_Frame_ShowFlash:SetChecked(EA_Config.ShowFlash);
	EA_Options_Frame_ShowTimer:SetChecked(EA_Config.ShowTimer);
	EA_Options_Frame_ChangeTimer:SetChecked(EA_Config.ChangeTimer);
	EA_Options_Frame_AllowESC:SetChecked(EA_Config.AllowESC);
	EA_Options_Frame_AltAlerts:SetChecked(EA_Config.AllowAltAlerts);

	-- EA_Options_Frame_ToggleClassEvents:Disable();
	local sTexturePath = "Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-BlueButton-Down";
	EA_Options_Frame_ToggleIconOptions:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleClassEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleOtherEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleTargetEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleSCDEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleGroupEvents:SetPushedTexture(sTexturePath);

	-- EA_SpellCondition_Frame_StackText:SetText(EA_XOPT_SPELLCOND_STACK);
	-- EA_SpellCondition_Frame_SelfText:SetText(EA_XOPT_SPELLCOND_SELF);
	-- EA_SpellCondition_Frame_OverGrowText:SetText(EA_XOPT_SPELLCOND_OVERGROW);
end

function EventAlert_Options_ToggleIconOptionsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_Icon_Options_Frame:IsVisible() then
		EA_Icon_Options_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
	else
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end
		if EA_Group_Events_Frame:IsVisible() then EA_Group_Events_Frame:Hide(); end

		EA_Icon_Options_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	end
end

function EventAlert_Options_ToggleClassEventsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_Class_Events_Frame:IsVisible() then
		EA_Class_Events_Frame:Hide();
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end
		if EA_Group_Events_Frame:IsVisible() then EA_Group_Events_Frame:Hide(); end

		EA_Class_Events_Frame:Show();
		if (EA_Config.AllowAltAlerts == true) then
			EA_ClassAlt_Events_Frame:Show();
		else
			EA_ClassAlt_Events_Frame:Hide();
		end
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	end
end

function EventAlert_Options_ToggleOtherEventsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_Other_Events_Frame:IsVisible() then
		EA_Other_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end
		if EA_Group_Events_Frame:IsVisible() then EA_Group_Events_Frame:Hide(); end

		EA_Other_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	end
end

function EventAlert_Options_ToggleTargetEventsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_Target_Events_Frame:IsVisible() then
		EA_Target_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end
		if EA_Group_Events_Frame:IsVisible() then EA_Group_Events_Frame:Hide(); end

		EA_Target_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	end
end

function EventAlert_Options_ToggleSCDEventsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_SCD_Events_Frame:IsVisible() then
		EA_SCD_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_Group_Events_Frame:IsVisible() then EA_Group_Events_Frame:Hide(); end

		EA_SCD_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	end
end

function EventAlert_Options_ToggleGroupEventsFrame()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	if EA_Group_Events_Frame:IsVisible() then
		EA_Group_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end

		EA_Group_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleGroupEvents, 1);
	end
end

function EventAlert_Options_CloseAnchorFrames()
	EA_SpellCondition_Frame:Hide();
	EA_GroupEventSetting_Frame:Hide();
	local iGroupCnt = #EA_GrpItems[EA_playerClass];
	local FrameNamePrefix = "EAGrpAnchorFrame_";
	local eaf = nil;
	if EA_Anchor_Frame1 ~= nil then
		EA_Anchor_Frame1:Hide();
		EA_Anchor_Frame2:Hide();
		EA_Anchor_Frame3:Hide();
		EA_Anchor_Frame4:Hide();
		EA_Anchor_Frame5:Hide();
		EA_Anchor_Frame6:Hide();
		EA_Anchor_Frame7:Hide();
		EA_Anchor_Frame8:Hide();
		EA_Anchor_Frame9:Hide();
		EA_Anchor_Frame10:Hide();
		EA_Options_Frame_ToggleIconOptions:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleClassEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleOtherEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleTargetEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleSCDEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleGroupEvents:SetButtonState("NORMAL", false);
		for iGroupID = 1, iGroupCnt do
			eaf = _G[FrameNamePrefix..iGroupID];
			if eaf~=nil then eaf:Hide() end;
		end
	end
end



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
local G_GroupItems = {};
local G_OrderIndexs = {};
local G_TempGroupValids = nil;	-- [SpellIndex][CheckIndex][SubCheckCnts] = true/false
local G_Group_CfgFramePrefix = "EAGECfgFrame";

function EAFun_GroupEvent_GetValueFromFrameItem(FrameItemName, fIsDropdown)
	local fGetValue, sReturnValue, iNumValue = false, nil, 0;
	local aFrameItem = _G[FrameItemName];
	if (fIsDropdown == nil) then fIsDropdown = false end;
	if (aFrameItem ~= nil) then
		if (fIsDropdown) then
			sReturnValue = UIDropDownMenu_GetSelectedValue(aFrameItem);
		else
			sReturnValue = aFrameItem:GetText();
		end
		iNumValue = tonumber(sReturnValue);
		if (iNumValue ~= nil) then sReturnValue = iNumValue end;
		if (sReturnValue ~= nil and sReturnValue ~= "") then fGetValue = true end;
	end
	return fGetValue, sReturnValue;
end

function EAFun_GroupEvent_GetValueFromGroupItem(Param, iSpellIndex, iCheckIndex, iSubCheckIndex)
	local fGetValue, sReturnValue = false, nil;
	if iSubCheckIndex ~= nil then
		-- Get SubCheck Values
		if G_GroupItems.Spells[iSpellIndex] ~= nil then
		if G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex] ~= nil then
		if G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex] ~= nil then
			sReturnValue = G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex][Param];
		end
		end
		end
	elseif iCheckIndex ~= nil then
		-- Get Check Values
		if G_GroupItems.Spells[iSpellIndex] ~= nil then
		if G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex] ~= nil then
			sReturnValue = G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex][Param];
		end
		end
	elseif iSpellIndex ~= nil then
		-- Get Spell Values
		if G_GroupItems.Spells[iSpellIndex] ~= nil then
			sReturnValue = G_GroupItems.Spells[iSpellIndex][Param];
		end
	end
	if (sReturnValue ~= nil) then fGetValue = true end;
	return fGetValue, sReturnValue;
end

-- function PrintTempGroupValids()
-- 	print ("---------- DUMP TempGroupValids Info ----------");
-- 	for iInd_i, aValue_i in ipairs(G_TempGroupValids) do
-- 		for iInd_j, aValue_j in ipairs(aValue_i) do
-- 			for iInd_k, aValue_k in ipairs(aValue_j) do
-- 				if (aValue_k) then
-- 					print ("["..iInd_i.."]["..iInd_j.."]["..iInd_k.."]: true");
-- 				else
-- 					print ("["..iInd_i.."]["..iInd_j.."]["..iInd_k.."]: false");
-- 				end
-- 			end
-- 		end
-- 	end
-- end
-- 
-- function PrintTempGroupItem(aTempGroupItem)
-- 	local function PrintVal(Prewords, Value)
-- 		local newValue
-- 		if Value ~= nil then
-- 			newValue = Value;
-- 			if (Value == true) then newValue = "true" end;
-- 			if (Value == false) then newValue = "false" end;
-- 			print (Prewords..newValue);
-- 		end
-- 	end
-- 	
-- 	print ("---------- DUMP aTempGroupItem Info ----------");
-- 	PrintVal("LocX=", aTempGroupItem.LocX);
-- 	PrintVal("LocY=", aTempGroupItem.LocY);
-- 	PrintVal("IconSize=", aTempGroupItem.IconSize);
-- 	PrintVal("IconAlpha=", aTempGroupItem.IconAlpha);
-- 	PrintVal("ActiveTalentGroup=", aTempGroupItem.ActiveTalentGroup);
-- 	for iInd_i, aValue_i in ipairs(aTempGroupItem.Spells) do
-- 		PrintVal("    Spells["..iInd_i.."].SpellIconID=", aValue_i.SpellIconID);
-- 		for iInd_j, aValue_j in ipairs(aValue_i.Checks) do
-- 			PrintVal ("        Checks["..iInd_j.."].CheckAndOp=", aValue_j.CheckAndOp);
-- 			for iInd_k, aValue_k in ipairs(aValue_j.SubChecks) do
-- 				PrintVal("            SubChecks["..iInd_k.."].SubCheckAndOp=", aValue_k.SubCheckAndOp);
--                                 PrintVal("                EventType=", aValue_k.EventType);
--                                 PrintVal("                UnitType=", aValue_k.UnitType);
--                                 PrintVal("                CheckCD =", aValue_k.CheckCD);
--                                 PrintVal("                PowerTypeNum =", aValue_k.PowerTypeNum);
--                                 PrintVal("                PowerType =", aValue_k.PowerType);
--                                 PrintVal("                PowerLessThan =", aValue_k.PowerLessThan);
--                                 PrintVal("                PowerLessThanValue =", aValue_k.PowerLessThanValue);
--                                 PrintVal("                PowerLessThanPercent =", aValue_k.PowerLessThanPercent);
--                                 PrintVal("                HealthLessThan =", aValue_k.HealthLessThan);
--                                 PrintVal("                HealthLessThanValue =", aValue_k.HealthLessThanValue);
--                                 PrintVal("                HealthLessThanPercent =", aValue_k.HealthLessThanPercent);
--                                 PrintVal("                CastByPlayer =", aValue_k.CastByPlayer);
--                                 PrintVal("                CheckAuraExist =", aValue_k.CheckAuraExist);
--                                 PrintVal("                CheckAuraNotExist =", aValue_k.CheckAuraNotExist);
--                                 PrintVal("                StackLessThan =", aValue_k.StackLessThan);
--                                 PrintVal("                StackLessThanValue =", aValue_k.StackLessThanValue);
--                                 PrintVal("                TimeLessThan =", aValue_k.TimeLessThan);
--                                 PrintVal("                TimeLessThanValue =", aValue_k.TimeLessThanValue);
-- 			end
-- 		end
-- 	end
-- end

function EAFun_GroupEvent_LoadGroupEventToFrame(GroupID)
	local AddNewCheckBtn, AddNewSubCheckBtn = nil, nil;
	EAFun_GroupEvent_ClearAllSpell_Click();
	G_OrderIndexs = {};
	if (GroupID <= #EA_GrpItems[EA_playerClass]) then
		G_GroupItems = EA_GrpItems[EA_playerClass][GroupID];
	else	-- New GroupItems, give the default structure.
		G_GroupItems = {
			enable = true,
			LocX = 0,
			LocY = -200,
			IconSize = 80,
			IconAlpha = 0.5,
			IconPoint = "Top",
			IconRelatePoint = "Top",
			Spells = {
				[1] = {
					SpellIconID = "",
					Checks = {
						[1] = {
							CheckAndOp = true,
							SubChecks = {
								[1] = {
									SubCheckAndOp = true,
								},
							},
						},
					},
				},
			},
		}
	end
	G_TempGroupValids = {};
	EA_GroupEventSetting_Frame.GroupID = GroupID;
	EA_GroupEventSetting_Frame.IconPoint = G_GroupItems.IconPoint;
	EA_GroupEventSetting_Frame.IconRelatePoint = G_GroupItems.IconRelatePoint;
	EA_GroupEventSetting_Frame_IconSize:SetValue(G_GroupItems.IconSize);
	EA_GroupEventSetting_Frame_IconAlpha:SetValue(G_GroupItems.IconAlpha * 100);
	EA_GroupEventSetting_Frame_Talent1:SetChecked(false);
	EA_GroupEventSetting_Frame_Talent2:SetChecked(false);
	EA_GroupEventSetting_Frame_Talent3:SetChecked(false);
	EA_GroupEventSetting_Frame_Talent4:SetChecked(false);
	if (G_GroupItems.ActiveTalentGroup) ~= nil then
		if (G_GroupItems.ActiveTalentGroup==1) then EA_GroupEventSetting_Frame_Talent1:SetChecked(true) end;
		if (G_GroupItems.ActiveTalentGroup==2) then EA_GroupEventSetting_Frame_Talent2:SetChecked(true) end;
		if (G_GroupItems.ActiveTalentGroup==3) then EA_GroupEventSetting_Frame_Talent3:SetChecked(true) end;
		if (G_GroupItems.ActiveTalentGroup==4) then EA_GroupEventSetting_Frame_Talent4:SetChecked(true) end;
	end
	EA_GroupEventSetting_Frame_HideOnLeaveCombat:SetChecked(false);
	if (G_GroupItems.HideOnLeaveCombat) ~= nil then
		if (G_GroupItems.HideOnLeaveCombat) then EA_GroupEventSetting_Frame_HideOnLeaveCombat:SetChecked(true) end;
	end
	EA_GroupEventSetting_Frame_HideOnLostTarget:SetChecked(false);
	if (G_GroupItems.HideOnLostTarget) ~= nil then
		if (G_GroupItems.HideOnLostTarget) then EA_GroupEventSetting_Frame_HideOnLostTarget:SetChecked(true) end;
	end
	EA_GroupEventSetting_Frame_LocX:SetText(G_GroupItems.LocX);
	EA_GroupEventSetting_Frame_LocY:SetText(G_GroupItems.LocY);
	for iInd_i, aValue_i in ipairs(G_GroupItems.Spells) do
		-- G_TempGroupValids[iInd_i] = {};
		EAFun_GroupEvent_AddNewSpellBtn_Click(EAGE_SpellsFrame_NewSpellBtn);
		for iInd_j, aValue_j in ipairs(aValue_i.Checks) do
			-- G_TempGroupValids[iInd_i][iInd_j] = {};
			-- if (iInd_j == 1) then G_GroupItems.Spells[iInd_i].Checks[iInd_j].CheckAndOp = true end;
			if (iInd_j >= 2) then
				AddNewCheckBtn = _G[G_Group_CfgFramePrefix..iInd_i.."_NewCheckBtn"];
				EAFun_GroupEvent_AddNewCheckBtn_Click(AddNewCheckBtn);
			end
			for iInd_k, aValue_k in ipairs(aValue_j.SubChecks) do
				-- G_TempGroupValids[iInd_i][iInd_j][iInd_k] = true;
				-- if (iInd_k == 1) then G_GroupItems.Spells[iInd_i].Checks[iInd_j].SubChecks[iInd_k].SubCheckAndOp = true end;
				if (iInd_k >= 2) then
					AddNewSubCheckBtn = _G[G_Group_CfgFramePrefix..iInd_i.."_"..iInd_j.."_NewSubCheckBtn"];
					EAFun_GroupEvent_AddNewSubCheckBtn_Click(AddNewSubCheckBtn);
				end
			end
		end
	end
end

function EAFun_GroupEvent_SaveFrameToGroupEvent()
	-- Some logic, valid all of G_GroupItems and G_TempGroupValids, confirm which item is valid.
	-- and then save G_GroupItems to EA_GrpItems[EA_playerClass][GroupID]
	local fHasSpellItem, fHasCheckItem, fHasSubCheckItem, fCheckValid = false, false, false, true;
	local aTempSubCheckItem = {};
	local aTempCheckItem = {};
	local aTempSpellItem = {};
	local aTempGroupItem = {};
	local iSpellIndex, iCheckIndex, iSubCheckIndex = 0, 0, 0;
	local sSpellFramePrefix, sCheckFramePrefix, sSubCheckFramePrefix = "", "", "";
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;

	aTempGroupItem = {};
	aTempGroupItem.Spells = {};
	iSpellIndex = 0;
	fHasSpellItem = false;
	local iInd_i, aValue_i = 0, nil;
	-- print ("---------- Print Save GroupItem Logs ----------");
	-- for iInd_i, aValue_i in ipairs(G_TempGroupValids) do	-- [SpellIndex][CheckIndex][SubCheckCnts] = true/false
	for iOrdInd_i, iOrdValue_i in ipairs(G_OrderIndexs) do
		iInd_i = iOrdValue_i;
		aValue_i = G_TempGroupValids[iInd_i];
		aTempSpellItem = {};
		aTempSpellItem.Checks = {};
		iCheckIndex = 0;
		fHasCheckItem = false;
		for iInd_j, aValue_j in ipairs(aValue_i) do	-- [CheckIndex][SubCheckCnts] = true/false
			aTempCheckItem = {};
			aTempCheckItem.SubChecks = {};
			iSubCheckIndex = 0;
			fHasSubCheckItem = false;
			for iInd_k, aValue_k in ipairs(aValue_j) do	-- [SubCheckCnts] = true/false
				if (aValue_k) then
					iSubCheckIndex = iSubCheckIndex + 1;
					fCheckValid = true;
					sSubCheckFramePrefix = G_Group_CfgFramePrefix..iInd_i.."_"..iInd_j.."_"..iInd_k;
					aTempSubCheckItem = {};

					-- Logic AND/OR
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckOpDropdown", true);
					if (iSubCheckIndex == 1) then sReturnValue = true end;
					if (sReturnValue == 1 or sReturnValue == true) then sReturnValue = true else sReturnValue = false end;
					aTempSubCheckItem.SubCheckAndOp = sReturnValue;

					-- EventType "UNIT_POWER_UPDATE"
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckEventTypeDowndown", true);
					
					aTempSubCheckItem.EventType = sReturnValue;

					-- UnitType
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckUnitTypeDowndown", true);
					
					aTempSubCheckItem.UnitType = sReturnValue;

					-- (Optional)Check cooldown
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckCDTextBox");
					if (fGetValue) then aTempSubCheckItem.CheckCD = sReturnValue else aTempSubCheckItem.CheckCD = nil end;

					if (aTempSubCheckItem.EventType == "UNIT_POWER_UPDATE") then
						-- PowerType
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckPowerTypeDowndown", true);
						
						aTempSubCheckItem.PowerTypeNum = sReturnValue;

						-- CompType: 1:<, 2:<=, 3:=, 4:>=, 5:>
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckPowerCompDowndown", true);
						-- if (sReturnValue == 1) then sReturnValue = true else sReturnValue = false end;
						aTempSubCheckItem.PowerCompType = sReturnValue;

						-- (1 in 2)Value or Percent
						local PowerValue = nil;
						fGetValue, PowerValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckPowerTextBox");
						if (not fGetValue) then fCheckValid = false end;
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckPowerCompTypeDowndown", true);
						aTempSubCheckItem.PowerLessThanValue = nil;
						aTempSubCheckItem.PowerLessThanPercent = nil;
						if sReturnValue == 1 then
							aTempSubCheckItem.PowerLessThanValue = PowerValue;
						else
							aTempSubCheckItem.PowerLessThanPercent = PowerValue;
						end
					elseif (aTempSubCheckItem.EventType == "UNIT_HEALTH") then
						-- CompType: 1:<, 2:<=, 3:=, 4:>=, 5:>
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckHealthCompDowndown", true);
						-- if (sReturnValue == 1) then sReturnValue = true else sReturnValue = false end;
						aTempSubCheckItem.HealthCompType = sReturnValue;

						-- (1 in 2)Value or Percent
						local HealthValue = nil;
						fGetValue, HealthValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckHealthTextBox");
						if (not fGetValue) then fCheckValid = false end;
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckHealthCompTypeDowndown", true);
						aTempSubCheckItem.HealthLessThanValue = nil;
						aTempSubCheckItem.HealthLessThanPercent = nil;
						if sReturnValue == 1 then
							aTempSubCheckItem.HealthLessThanValue = HealthValue;
						else
							aTempSubCheckItem.HealthLessThanPercent = HealthValue;
						end
					elseif (aTempSubCheckItem.EventType == "UNIT_AURA") then
						-- Check if cast by player
						local oCheckbox = _G[sSubCheckFramePrefix.."_SubCheckCastByPlayerCheckBox"];
						sReturnValue = oCheckbox:GetChecked();
						if (sReturnValue == 1) then sReturnValue = true else sReturnValue = nil end;
						aTempSubCheckItem.CastByPlayer = sReturnValue;

						-- (1 in 2) Check Aura Exists, Not Exists
						local AuraValue = nil;
						fGetValue, AuraValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckAuraIDTextBox");
						if (not fGetValue) then fCheckValid = false end;
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckAuraExistDowndown", true);
						aTempSubCheckItem.CheckAuraExist = nil;
						aTempSubCheckItem.CheckAuraNotExist = nil;
						if sReturnValue == 1 then
							aTempSubCheckItem.CheckAuraExist = AuraValue;
						else
							aTempSubCheckItem.CheckAuraNotExist = AuraValue;
						end

						-- (Only Exists) time compare, CompType: 1:<, 2:<=, 3:=, 4:>=, 5:>
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckTimeCompDowndown", true);
						-- if (sReturnValue == 1) then sReturnValue = true else sReturnValue = false end;
						aTempSubCheckItem.TimeCompType = sReturnValue;

						-- (Only Exists) time seconds
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckAuraTimeTextBox");
						aTempSubCheckItem.TimeLessThanValue = sReturnValue;
						if (not fGetValue) then
							aTempSubCheckItem.TimeCompType = nil;
							aTempSubCheckItem.TimeLessThanValue = nil;
						end

						-- (Only Exists) stack compare, CompType: 1:<, 2:<=, 3:=, 4:>=, 5:>
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckStackCompDowndown", true);
						-- if (sReturnValue == 1) then sReturnValue = true else sReturnValue = false end;
						aTempSubCheckItem.StackCompType = sReturnValue;

						-- (Only Exists) stacks
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckAuraStackTextBox");
						aTempSubCheckItem.StackLessThanValue = sReturnValue;
						if (not fGetValue) then
							aTempSubCheckItem.StackCompType = nil;
							aTempSubCheckItem.StackLessThanValue = nil;
						end
					elseif (aTempSubCheckItem.EventType == "UNIT_COMBO_POINTS") then
						-- <=:true, >=:false
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckComboCompDowndown", true);
						-- if (sReturnValue == 1) then sReturnValue = true else sReturnValue = false end;
						aTempSubCheckItem.ComboCompType = sReturnValue;

						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSubCheckFramePrefix.."_SubCheckComboTextBox");
						aTempSubCheckItem.ComboLessThanValue = sReturnValue;
						if (not fGetValue) then
							fCheckValid = false;
							aTempSubCheckItem.ComboCompType = nil;
							aTempSubCheckItem.ComboLessThanValue = nil;
						end
					end
                                        
					-- Add to aTempCheckItem
					if (fCheckValid) then
						aTempCheckItem.SubChecks[iSubCheckIndex] = aTempSubCheckItem;
					else
						iSubCheckIndex = iSubCheckIndex - 1;
					end
					if (iSubCheckIndex > 0) then
						fHasSubCheckItem = true;
					end
				end
			end
			if (fHasSubCheckItem) then
				iCheckIndex = iCheckIndex + 1;
				fCheckValid = true;
				sCheckFramePrefix = G_Group_CfgFramePrefix..iInd_i.."_"..iInd_j;
				fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sCheckFramePrefix.."_CheckOpDropdown", true);
				if (iCheckIndex == 1) then sReturnValue = true end;
				if (sReturnValue == 1 or sReturnValue == true) then sReturnValue = true else sReturnValue = false end;
				aTempCheckItem.CheckAndOp = sReturnValue;
				if (fCheckValid) then
					aTempSpellItem.Checks[iCheckIndex] = aTempCheckItem;
				else
					iCheckIndex = iCheckIndex - 1;
				end
				if (iCheckIndex > 0) then
					fHasCheckItem = true;
				end
			end
		end
		if (fHasCheckItem) then
			iSpellIndex = iSpellIndex + 1;
			fCheckValid = true;
			sSpellFramePrefix = G_Group_CfgFramePrefix..iInd_i;
			fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromFrameItem(sSpellFramePrefix.."_SpellTextBox");
			aTempSpellItem.SpellIconID = sReturnValue;
			if (sReturnValue == "") then fCheckValid = false end;
			if (fCheckValid) then
				aTempGroupItem.Spells[iSpellIndex] = aTempSpellItem;
			else
				iSpellIndex = iSpellIndex - 1;
			end
			if (iSpellIndex > 0) then
				fHasSpellItem = true;
			end
		end
	end
	if (fHasSpellItem) then
		aTempGroupItem.enable = true;
		aTempGroupItem.LocX = tonumber(EA_GroupEventSetting_Frame_LocX:GetText());
		aTempGroupItem.LocY = tonumber(EA_GroupEventSetting_Frame_LocY:GetText());
		aTempGroupItem.IconSize = EA_GroupEventSetting_Frame_IconSize:GetValue();
		aTempGroupItem.IconAlpha = EA_GroupEventSetting_Frame_IconAlpha:GetValue() / 100;
		aTempGroupItem.IconPoint = EA_GroupEventSetting_Frame.IconPoint;
		aTempGroupItem.IconRelatePoint = EA_GroupEventSetting_Frame.IconRelatePoint;
		if (EA_GroupEventSetting_Frame_Talent1:GetChecked()) then aTempGroupItem.ActiveTalentGroup = 1 end;
		if (EA_GroupEventSetting_Frame_Talent2:GetChecked()) then aTempGroupItem.ActiveTalentGroup = 2 end;
		if (EA_GroupEventSetting_Frame_Talent3:GetChecked()) then aTempGroupItem.ActiveTalentGroup = 3 end;
		if (EA_GroupEventSetting_Frame_Talent4:GetChecked()) then aTempGroupItem.ActiveTalentGroup = 4 end;
		if (EA_GroupEventSetting_Frame_HideOnLeaveCombat:GetChecked()) then aTempGroupItem.HideOnLeaveCombat = true end;
		if (EA_GroupEventSetting_Frame_HideOnLostTarget:GetChecked()) then aTempGroupItem.HideOnLostTarget = true end;

		-- This is a Valid GroupItem, Update or Append to current GroupID
		CreateFrames_EventsFrame_ClearSpellList(6);
		-- wipe GC_IndexOfGroupFrame
		GC_IndexOfGroupFrame = {};
		local iGroupID = EA_GroupEventSetting_Frame.GroupID;
		EA_GrpItems[EA_playerClass][iGroupID] = aTempGroupItem;
		-- create all frames
		CreateFrames_EventsFrame_CreateSpellList(6);
		-- refresh all icons
		CreateFrames_EventsFrame_RefreshSpellList(6);
	end
end

function EAFun_GroupEvent_ClearAllSpell_Click()
	local SpellFrame, CheckFrame, SubCheckFrame = nil, nil, nil;
	if (G_TempGroupValids ~= nil) then
		for iInd_i, aValue_i in ipairs(G_TempGroupValids) do
			for iInd_j, aValue_j in ipairs(aValue_i) do
				for iInd_k, aValue_k in ipairs(aValue_j) do
					SubCheckFrame = _G[G_Group_CfgFramePrefix..iInd_i.."_"..iInd_j.."_"..iInd_k];
					if SubCheckFrame~= nil then SubCheckFrame:Hide() end;
				end
				CheckFrame = _G[G_Group_CfgFramePrefix..iInd_i.."_"..iInd_j];
				if CheckFrame~= nil then CheckFrame:Hide() end;
			end
			SpellFrame = _G[G_Group_CfgFramePrefix..iInd_i];
			if SpellFrame~= nil then SpellFrame:Hide() end;
		end
	end
	EAGE_SpellsFrame_NewSpellBtn.SpellCnts = 0;
	-- EAGE_SpellsFrame_NewSpellBtn:ClearAllPoints();
	-- EAGE_SpellsFrame_NewSpellBtn:SetPoint("TOPLEFT", EA_GroupEventSetting_Frame_SpellScrollFrameList, "TOPLEFT", 0, 0);
	EAGE_SpellsFrame_NewSpellBtn.PreFrame = EA_GroupEventSetting_Frame_SpellScrollFrameList;
end

-- function DumpOrderIndexs(sTitle)
-- 	local sRetStr = "Order:";
-- 	if sTitle~=nil then sRetStr = sTitle..sRetStr end;
-- 	for i, v in ipairs(G_OrderIndexs) do
-- 		sRetStr = sRetStr.."["..i.."]=S"..v..", ";
-- 	end
-- 	print (sRetStr);
-- end
-- function DumpFrameName(aFrame)
-- 	local sRetStr = "";
-- 	if aFrame ~= nil then 
-- 		sRetStr = aFrame:GetName();
-- 	else
-- 		sRetStr = "nil";
-- 	end
-- 	return sRetStr;
-- end
function EAFun_GroupEvent_OrderBtn_OnClick(self)
	local fOrderUp = self.OrderUp;
	local iSpellIndex, iPreSpellIndex, iNextSpellIndex = self.SpellIndex, nil, nil;
	local fGoToMove, fPreFrameOk, fNextFrameOk, fExtraFrameOk = false, false, false, false;
	local SpellFrame = _G[G_Group_CfgFramePrefix..iSpellIndex];
	local PreSpellFrame = SpellFrame.PreFrame;
	local NextSpellFrame = SpellFrame.NextFrame;
	local ExtraSpellFrame = nil;
	local iOrderIndex, iPreOrderIndex, iNextOrderIndex = SpellFrame.OrderIndex, nil, nil;
	local iPpoint, iPrelativeTo, iPrelativePoint, iPxOfs, iPyOfs = nil, nil, nil, nil, nil;
	local iSpoint, iSrelativeTo, iSrelativePoint, iSxOfs, iSyOfs = SpellFrame:GetPoint();
	local iNpoint, iNrelativeTo, iNrelativePoint, iNxOfs, iNyOfs = nil, nil, nil, nil, nil;

	if (PreSpellFrame ~= nil and PreSpellFrame ~= EA_GroupEventSetting_Frame_SpellScrollFrameList) then
		fPreFrameOk = true;
		iPpoint, iPrelativeTo, iPrelativePoint, iPxOfs, iPyOfs = PreSpellFrame:GetPoint();
		iPreSpellIndex = PreSpellFrame.SpellIndex;
		iPreOrderIndex = PreSpellFrame.OrderIndex;
		if (fOrderUp) then
			fGoToMove = true;
			fExtraFrameOk = false;
			ExtraSpellFrame = PreSpellFrame.PreFrame;
			if (ExtraSpellFrame ~= nil) then
				fExtraFrameOk = true;
			end
		end
	end
	if (NextSpellFrame ~= nil) then
		fNextFrameOk = true;
		iNpoint, iNrelativeTo, iNrelativePoint, iNxOfs, iNyOfs = NextSpellFrame:GetPoint();
		iNextSpellIndex = NextSpellFrame.SpellIndex;
		iNextOrderIndex = NextSpellFrame.OrderIndex;
		if (not fOrderUp) then
			fGoToMove = true;
			fExtraFrameOk = false;
			ExtraSpellFrame = NextSpellFrame.NextFrame;
			if (ExtraSpellFrame ~= nil) then
				fExtraFrameOk = true;
				iPpoint, iPrelativeTo, iPrelativePoint, iPxOfs, iPyOfs = ExtraSpellFrame:GetPoint();
			end
		end
	end

	if (fGoToMove) then
		if (fOrderUp) then
			-- Original : ExtraSpellFrame, PreSpellFrame, SpellFrame, NextSpellFrame
			-- Change To: ExtraSpellFrame, SpellFrame, PreSpellFrame, NextSpellFrame
			
			G_OrderIndexs[iPreOrderIndex] = iSpellIndex;
			G_OrderIndexs[iOrderIndex] = iPreSpellIndex;
			PreSpellFrame.OrderIndex = iOrderIndex;
			SpellFrame.OrderIndex = iPreOrderIndex;
			if (fExtraFrameOk) then
				ExtraSpellFrame.NextFrame = SpellFrame;
			end
			SpellFrame:SetPoint(iPpoint, iPrelativeTo, iPrelativePoint, iPxOfs, iPyOfs);
			SpellFrame.PreFrame = iPrelativeTo;
			SpellFrame.NextFrame = PreSpellFrame;
			if (fPreFrameOk) then
				PreSpellFrame:SetPoint(iSpoint, SpellFrame, iSrelativePoint, iSxOfs, iSyOfs);
				PreSpellFrame.PreFrame = SpellFrame;
				PreSpellFrame.NextFrame = nil;
				if (fNextFrameOk) then PreSpellFrame.NextFrame = NextSpellFrame end;
			end
			if (fNextFrameOk) then
				NextSpellFrame:SetPoint(iNpoint, PreSpellFrame, iNrelativePoint, iNxOfs, iNyOfs);
				NextSpellFrame.PreFrame = PreSpellFrame;
			else
				EAGE_SpellsFrame_NewSpellBtn.PreFrame = PreSpellFrame;
			end
		else	-- Original : PreSpellFrame, SpellFrame, NextSpellFrame, ExtraSpellFrame
			-- Change To: PreSpellFrame, NextSpellFrame, SpellFrame, ExtraSpellFrame
			G_OrderIndexs[iNextOrderIndex] = iSpellIndex;
			G_OrderIndexs[iOrderIndex] = iNextSpellIndex;
			SpellFrame.OrderIndex = iNextOrderIndex;
			NextSpellFrame.OrderIndex = iOrderIndex;
			if (fPreFrameOk) then
				if (fNextFrameOk) then PreSpellFrame.NextFrame = NextSpellFrame end;
			end
			if (fNextFrameOk) then
				NextSpellFrame:SetPoint(iSpoint, iSrelativeTo, iSrelativePoint, iSxOfs, iSyOfs);
				NextSpellFrame.PreFrame = iSrelativeTo;
				NextSpellFrame.NextFrame = SpellFrame;
			end
			SpellFrame:SetPoint(iNpoint, NextSpellFrame, iNrelativePoint, iNxOfs, iNyOfs);
			SpellFrame.PreFrame = NextSpellFrame;
			SpellFrame.NextFrame = nil;
			if (fExtraFrameOk) then
				SpellFrame.NextFrame = ExtraSpellFrame;
				ExtraSpellFrame:SetPoint(iPpoint, SpellFrame, iPrelativePoint, iPxOfs, iPyOfs)
				ExtraSpellFrame.PreFrame = SpellFrame;
			else
				EAGE_SpellsFrame_NewSpellBtn.PreFrame = SpellFrame;
			end
		end
	end
end

function EAFun_GroupEvent_CloseBtn_OnClick(self)
	local iSpellIndex = self.SpellIndex;
	local iCheckIndex = self.CheckIndex;
	local iSubCheckIndex= self.SubCheckIndex;
	local iCloseLevel = self.CloseLevel;
	local sSpellFramePrefix = G_Group_CfgFramePrefix..iSpellIndex;
	local sCheckFramePrefix = "";
	local sSubCheckFramePrefix = "";

	local DelFrame, RootFrame = nil, nil;
	local sRelateToPoint, iOffsetX = "BOTTOMLEFT", 0;
	local sRootRelateToPoint, iRootOffsetX = "TOPLEFT", 0;
	local SpellFrame, CheckFrame = nil, nil;
	
	if (iCloseLevel == 1) then
		RootFrame = EA_GroupEventSetting_Frame_SpellScrollFrameList;
		DelFrame  = _G[sSpellFramePrefix];
		sRootRelateToPoint = "TOPLEFT";
		iRootOffsetX = 0;
		for iInd_j, aValue_j in ipairs(G_TempGroupValids[iSpellIndex]) do
			for iInd_k, aValue_k in ipairs(aValue_j) do
				G_TempGroupValids[iSpellIndex][iInd_j][iInd_k] = false;
			end
		end
	elseif (iCloseLevel == 2) then
		sCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex;
		RootFrame = _G[sSpellFramePrefix.."_CloseBtn"];
		DelFrame  = _G[sCheckFramePrefix];
		sRootRelateToPoint = "BOTTOMLEFT";
		iRootOffsetX = 15;
		SpellFrame = _G[sSpellFramePrefix];
		SpellFrame:SetHeight(SpellFrame:GetHeight() - DelFrame:GetHeight());
		for iInd_k, aValue_k in ipairs(G_TempGroupValids[iSpellIndex][iCheckIndex]) do
			G_TempGroupValids[iSpellIndex][iCheckIndex][iInd_k] = false;
		end
	elseif (iCloseLevel == 3) then
		sCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex;
		sSubCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex;
		RootFrame = _G[sCheckFramePrefix.."_CloseBtn"];
		DelFrame  = _G[sSubCheckFramePrefix];
		sRootRelateToPoint = "BOTTOMLEFT";
		iRootOffsetX = 15;
		SpellFrame = _G[sSpellFramePrefix];
		CheckFrame = _G[sCheckFramePrefix];
		SpellFrame:SetHeight(SpellFrame:GetHeight() - DelFrame:GetHeight());
		CheckFrame:SetHeight(CheckFrame:GetHeight() - DelFrame:GetHeight());
		G_TempGroupValids[iSpellIndex][iCheckIndex][iSubCheckIndex] = false;
	end
        
	local PreDelFrame = DelFrame.PreFrame;
	local NextDelFrame = DelFrame.NextFrame;
	if (NextDelFrame == nil) then
		PreDelFrame.NextFrame = nil;
		if (iCloseLevel == 1) then
			EAGE_SpellsFrame_NewSpellBtn.PreFrame = PreDelFrame;
		end
	else
		PreDelFrame.NextFrame = NextDelFrame;
		NextDelFrame.PreFrame = PreDelFrame;
	        
		sRelateToPoint = "BOTTOMLEFT";
		iOffsetX = 0;
		if (PreDelFrame == RootFrame) then 
			sRelateToPoint = sRootRelateToPoint;
			iOffsetX = iRootOffsetX;
		end
		NextDelFrame:SetPoint("TOPLEFT", PreDelFrame, sRelateToPoint, iOffsetX, 0);
	end
	DelFrame:Hide();
	DelFrame.PreFrame = nil;
	DelFrame.NextFrame = nil;
	DelFrame = nil;
end

function EAFun_GroupEvent_SpellTextOnEnterPressed(self)
	local iSpellID = tonumber(self:GetText());
	if (iSpellID ~= nil) then
		local sName, sRank, sIcon = GetSpellInfo(iSpellID);
		if (sRank ~= nil and sRank ~= "") then sName = sName.."("..sRank..")" end;
		if self.SpellName ~= nil then self.SpellName:SetText(sName) end;
		if self.SpellIcon ~= nil then 
			--self.SpellIcon:SetBackdrop({bgFile = sIcon}) 
			--for 7.0
			if not self.SpellIcon.texture then self.SpellIcon.texture = self.SpellIcon:CreateTexture() end
			self.SpellIcon.texture:SetAllPoints(self.SpellIcon)
			self.SpellIcon.texture:SetTexture(sIcon)	
		end;
		self:ClearFocus();
	end
end

function EAFun_GetUnitNameWithTitle(Title, UnitID)
	local sname, srealm = UnitName(UnitID);
	if (sname~=nil) then
		Title = Title.."("..sname..")";
	end
	return Title;
end
function EAFun_GroupEvent_DropDown_OnLoad(DropDown, ItemValues, DefaultValue, ExtraInfo)
	local function MyDropDownClick(self)
		EAFun_GroupEvent_DropDown_OnClick(self, DropDown, DefaultValue, ExtraInfo);
	end
	local function MyDropDownInit()
		local selectedValue = UIDropDownMenu_GetSelectedValue(DropDown);
		if selectedValue == nil then selectedValue = 0 end;
		local function AddItem(text, value)
			local info = {};
			info.text = text;
			info.func = MyDropDownClick;
			info.value = value;
			info.checked = false;
			if (info.value == selectedValue) then
				info.checked = true;
			end
			UIDropDownMenu_AddButton(info)
		end
		if (ItemValues == EA_XGRPALERT_UNITTYPES) then
			for iItemIndex, aItemValue in ipairs(ItemValues) do
				AddItem(EAFun_GetUnitNameWithTitle(aItemValue.text, aItemValue.value), aItemValue.value);
			end
		else
			for iItemIndex, aItemValue in ipairs(ItemValues) do
				AddItem(aItemValue.text, aItemValue.value);
			end
		end
	end
	UIDropDownMenu_Initialize(DropDown, MyDropDownInit);
	UIDropDownMenu_SetSelectedValue(DropDown, DefaultValue);
	if (ExtraInfo ~= nil) then
		if (ExtraInfo.EventIndex == nil) then
			EAFun_GroupEvent_ChangeEventType_Click(DefaultValue, ExtraInfo);
		else
			EAFun_GroupEvent_ChangeAuraCheck_Click(DefaultValue, ExtraInfo);
		end
	end
end

function EAFun_GroupEvent_DropDown_OnClick(self, DropDown, DefaultValue, ExtraInfo)
	local SelValue = self.value;
	if SelValue == nil then SelValue = DefaultValue end;
	UIDropDownMenu_SetSelectedValue(DropDown, SelValue);
	if (ExtraInfo ~= nil) then
		if (ExtraInfo.EventIndex == nil) then
			EAFun_GroupEvent_ChangeEventType_Click(SelValue, ExtraInfo);
		else
			EAFun_GroupEvent_ChangeAuraCheck_Click(SelValue, ExtraInfo);
		end
	end
end

-- Create Spell Configuration Items
-- Show a SpellIcon
function EAFun_GroupEvent_AddNewSpellBtn_Click(self)
	self.SpellCnts = self.SpellCnts + 1;
	local iSpellIndex = self.SpellCnts;
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;
	local sSpellFramePrefix = G_Group_CfgFramePrefix..iSpellIndex;
	local IconPath = "Interface/Icons/Spell_Nature_Polymorph_Cow";
	-- local IconPath = "";
	local PreSpellFrame = self.PreFrame;
	local sRelateToPoint = "BOTTOMLEFT";
	if (PreSpellFrame == nil or PreSpellFrame == EA_GroupEventSetting_Frame_SpellScrollFrameList) then 
		PreSpellFrame = EA_GroupEventSetting_Frame_SpellScrollFrameList;
		PreSpellFrame.OrderIndex = 0;
		sRelateToPoint = "TOPLEFT";
	end

	G_OrderIndexs[iSpellIndex] = iSpellIndex;
	G_TempGroupValids[iSpellIndex] = {};
	local SpellFrame = _G[sSpellFramePrefix];
	if (SpellFrame == nil) then
		SpellFrame = CreateFrame("Frame", sSpellFramePrefix, EA_GroupEventSetting_Frame_SpellScrollFrameList);
	end
	SpellFrame.SpellIndex = iSpellIndex;
	SpellFrame.OrderIndex = iSpellIndex;
	SpellFrame:SetWidth(680);
	SpellFrame:SetHeight(65);
	SpellFrame:SetPoint("TOPLEFT", PreSpellFrame, sRelateToPoint, 0, 0);
	SpellFrame:SetBackdrop({bgFile="", edgeFile="Interface/Tooltips/UI-Tooltip-Border"});
	SpellFrame:Show();
	PreSpellFrame.NextFrame = SpellFrame;
	SpellFrame.PreFrame = PreSpellFrame;
	SpellFrame.NextFrame = nil;
	-- self:ClearAllPoints();
	-- self:SetPoint("TOPLEFT", SpellFrame, "BOTTOMLEFT", 0, 0);
	self.PreFrame = SpellFrame;

	-- <------------- Create Spell Configuration Items Starts ---------------> --
	-- <------------- Create Spell Configuration Items Starts ---------------> --
	local CloseBtn = _G[sSpellFramePrefix.."_CloseBtn"];
	if (CloseBtn == nil) then
		CloseBtn = CreateFrame("Button", sSpellFramePrefix.."_CloseBtn", SpellFrame, "OptionsButtonTemplate");
	end
	CloseBtn:SetWidth(20);
	CloseBtn:SetHeight(20);
	CloseBtn:SetText("X");
	CloseBtn:SetPoint("TOPLEFT", SpellFrame, "TOPLEFT", 12, -10);
	CloseBtn:SetScript("OnClick", EAFun_GroupEvent_CloseBtn_OnClick);
	CloseBtn.SpellIndex = iSpellIndex;
	CloseBtn.CloseLevel = 1;
	CloseBtn:Show();
	
	local SpellText1 = _G[sSpellFramePrefix.."_SpellText1"];
	if (SpellText1 == nil) then
		SpellText1 = SpellFrame:CreateFontString(sSpellFramePrefix.."_SpellText1", "ARTWORK", "GameFontNormal");
	end
	SpellText1:SetPoint("TOPLEFT", CloseBtn, "TOPRIGHT", 0, -2);
	SpellText1:SetText("["..iSpellIndex.."]"..EX_XCLSALERT_SPELL);

	--// G_GroupItems.Spells[iSpellIndex].SpellIconID
	--// G_Group_CfgFramePrefix..iSpellIndex.."_SpellTextBox"
	local SpellTextBox = _G[sSpellFramePrefix.."_SpellTextBox"];
	if (SpellTextBox == nil) then
		SpellTextBox = CreateFrame("EditBox", sSpellFramePrefix.."_SpellTextBox", SpellFrame, "EA_SpellEditBoxTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = "";
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("SpellIconID", iSpellIndex);
		if (fGetValue) then
			sDefaultValue = sReturnValue;
		end
	SpellTextBox:SetText(sDefaultValue);
	SpellTextBox:SetScript("OnEnterPressed", EAFun_GroupEvent_SpellTextOnEnterPressed);
	SpellTextBox:SetPoint("TOPLEFT", SpellText1, "TOPRIGHT", 10, 5);
	SpellTextBox:Show();

	local SpellText2 = _G[sSpellFramePrefix.."_SpellText2"];
	if (SpellText2 == nil) then
		SpellText2 = SpellFrame:CreateFontString(sSpellFramePrefix.."_SpellText2", "ARTWORK", "GameFontNormal");
	end
	SpellText2:SetPoint("TOPLEFT", SpellTextBox, "TOPRIGHT", 10, -5);
	SpellText2:SetText(EA_XGRPALERT_SPELLNAME);

	local SpellName = _G[sSpellFramePrefix.."_SpellName"];
	if (SpellName == nil) then
		SpellName = SpellFrame:CreateFontString(sSpellFramePrefix.."_SpellName", "ARTWORK", "GameFontNormal");
	end
	SpellName:SetPoint("TOPLEFT", SpellText2, "TOPRIGHT", 0, 0);
	SpellName:SetText("");

	local SpellIcon = _G[sSpellFramePrefix.."_SpellIcon"];
	if (SpellIcon == nil) then
		SpellIcon = CreateFrame("Frame", sSpellFramePrefix.."_SpellIcon", SpellFrame);
	end
	SpellIcon:SetWidth(50);
	SpellIcon:SetHeight(50);
	SpellIcon:SetPoint("TOPLEFT", SpellFrame, "TOPRIGHT", -58, -8);
	--SpellIcon:SetBackdrop({bgFile = IconPath});
	
	--for 7.0
	if not SpellIcon.texture then SpellIcon.texture = SpellIcon:CreateTexture() end
	SpellIcon.texture:SetAllPoints(SpellIcon)
	SpellIcon.texture:SetTexture(IconPath)	
	
	SpellIcon:Show();

	local SpellText3 = _G[sSpellFramePrefix.."_SpellText3"];
	if (SpellText3 == nil) then
		SpellText3 = SpellFrame:CreateFontString(sSpellFramePrefix.."_SpellText3", "ARTWORK", "GameFontNormal");
	end
	SpellText3:SetPoint("TOPRIGHT", SpellIcon, "TOPLEFT", -5, -4);
	SpellText3:SetText(EA_XGRPALERT_SPELLICON);
	SpellTextBox.SpellName = SpellName;
	SpellTextBox.SpellIcon = SpellIcon;
	EAFun_GroupEvent_SpellTextOnEnterPressed(SpellTextBox);

	local OrderUpBtn = _G[sSpellFramePrefix.."_OrderUpBtn"];
	if (OrderUpBtn == nil) then
		OrderUpBtn = CreateFrame("Button", sSpellFramePrefix.."_OrderUpBtn", SpellFrame, "OptionsButtonTemplate");
	end
	OrderUpBtn:SetWidth(120);
	OrderUpBtn:SetHeight(20);
	OrderUpBtn:SetText(EA_XGRPALERT_TITLEORDERUP);
	OrderUpBtn:SetPoint("BOTTOMRIGHT", SpellFrame, "BOTTOMRIGHT", -150, 15);
	OrderUpBtn.OrderUp = true;
	OrderUpBtn.SpellIndex = iSpellIndex;
	OrderUpBtn:SetScript("OnClick", EAFun_GroupEvent_OrderBtn_OnClick);
	OrderUpBtn:Show();

	local OrderDownBtn = _G[sSpellFramePrefix.."_OrderDownBtn"];
	if (OrderDownBtn == nil) then
		OrderDownBtn = CreateFrame("Button", sSpellFramePrefix.."_OrderDownBtn", SpellFrame, "OptionsButtonTemplate");
	end
	OrderDownBtn:SetWidth(120);
	OrderDownBtn:SetHeight(20);
	OrderDownBtn:SetText(EA_XGRPALERT_TITLEORDERDOWN);
	OrderDownBtn:SetPoint("TOPLEFT", OrderUpBtn, "TOPRIGHT", 10, 0);
	OrderDownBtn.OrderUp = false;
	OrderDownBtn.SpellIndex = iSpellIndex;
	OrderDownBtn:SetScript("OnClick", EAFun_GroupEvent_OrderBtn_OnClick);
	OrderDownBtn:Show();
	-- <------------- Create Spell Configuration Items Ends ---------------> --
	-- <------------- Create Spell Configuration Items Ends ---------------> --

	local NewCheckBtn = _G[sSpellFramePrefix.."_NewCheckBtn"];
	if (NewCheckBtn == nil) then
		NewCheckBtn = CreateFrame("Button", sSpellFramePrefix.."_NewCheckBtn", SpellFrame, "OptionsButtonTemplate");
	end
	NewCheckBtn:SetWidth(150);
	NewCheckBtn:SetHeight(20);
	NewCheckBtn:SetText(EA_XGRPALERT_NEWCHECKBTN);
	NewCheckBtn:SetPoint("TOPLEFT", CloseBtn, "BOTTOMLEFT", 20, 0);
	NewCheckBtn:Show();
	NewCheckBtn:SetScript("OnClick", EAFun_GroupEvent_AddNewCheckBtn_Click);
	NewCheckBtn.PreFrame = CloseBtn;
	NewCheckBtn.SpellIndex = iSpellIndex;
	NewCheckBtn.CheckCnts = 0;

	-- Automatic call AddNewBtn to Create Check Items
	EAFun_GroupEvent_AddNewCheckBtn_Click(NewCheckBtn);
end

-- Create Check Configuration Items
-- Show a Logic-Operation
function EAFun_GroupEvent_AddNewCheckBtn_Click(self)
	self.CheckCnts = self.CheckCnts + 1;
	local iSpellIndex = self.SpellIndex;
	local iCheckIndex = self.CheckCnts;
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;
	local sSpellFramePrefix = G_Group_CfgFramePrefix..iSpellIndex;
	local sCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex;

	local RootFrame = _G[sSpellFramePrefix.."_CloseBtn"];
	local PreCheckFrame = self.PreFrame;
	local iOffsetX = 0;
	if (PreCheckFrame == RootFrame) then iOffsetX = 15 end;

	G_TempGroupValids[iSpellIndex][iCheckIndex] = {};
	local SpellFrame = _G[sSpellFramePrefix];
	local CheckFrame = _G[sCheckFramePrefix];
	if (CheckFrame == nil) then
		CheckFrame = CreateFrame("Frame", sCheckFramePrefix, SpellFrame);
	end
	CheckFrame:SetWidth(620);
	CheckFrame:SetHeight(45);
	CheckFrame:SetPoint("TOPLEFT", PreCheckFrame, "BOTTOMLEFT", iOffsetX, 0);
	CheckFrame:Show();
	PreCheckFrame.NextFrame = CheckFrame;
	CheckFrame.PreFrame = PreCheckFrame;
	CheckFrame.NextFrame = self;
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", CheckFrame, "BOTTOMLEFT", 5, 0);
	self.PreFrame = CheckFrame;
	SpellFrame:SetHeight(SpellFrame:GetHeight() + 45);

	-- <------------- Create Check Configuration Items Starts ---------------> --
	-- <------------- Create Check Configuration Items Starts ---------------> --
	local CloseBtn = _G[sCheckFramePrefix.."_CloseBtn"];
	if (CloseBtn == nil) then
		CloseBtn = CreateFrame("Button", sCheckFramePrefix.."_CloseBtn", CheckFrame, "OptionsButtonTemplate");
	end
	CloseBtn:SetWidth(20);
	CloseBtn:SetHeight(20);
	CloseBtn:SetText("X");
	CloseBtn:SetPoint("TOPLEFT", CheckFrame, "TOPLEFT", 10, -5);
	CloseBtn:SetScript("OnClick", EAFun_GroupEvent_CloseBtn_OnClick);
	CloseBtn.SpellIndex = iSpellIndex;
	CloseBtn.CheckIndex = iCheckIndex;
	CloseBtn.CloseLevel = 2;
	CloseBtn:Show();
	
	local CheckTitle = _G[sCheckFramePrefix.."_CheckTitle"];
	if (CheckTitle == nil) then
		CheckTitle = CheckFrame:CreateFontString(sCheckFramePrefix.."_CheckTitle", "ARTWORK", "GameFontNormal");
	end
	CheckTitle:SetPoint("TOPLEFT", CloseBtn, "TOPRIGHT", 0, -2);
	CheckTitle:SetText("["..iCheckIndex.."]"..EA_XGRPALERT_TITLECHECK);
	
	--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].CheckAndOp
	--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_CheckOpDropdown"
	local CheckOpDropdown = _G[sCheckFramePrefix.."_CheckOpDropdown"];
	if (CheckOpDropdown == nil) then
		CheckOpDropdown = CreateFrame("CheckButton", sCheckFramePrefix.."_CheckOpDropdown", CheckFrame, "UIDropDownMenuTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = 1;
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CheckAndOp", iSpellIndex, iCheckIndex);
		if (fGetValue) then
			if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
		end
	UIDropDownMenu_SetWidth(CheckOpDropdown, 60);
	EAFun_GroupEvent_DropDown_OnLoad(CheckOpDropdown, EA_XGRPALERT_LOGICS, sDefaultValue);
	CheckOpDropdown:SetPoint("TOPLEFT", CheckTitle, "TOPRIGHT", -15, 5);
	CheckOpDropdown:Show();

	-- <------------- Create Check Configuration Items Ends ---------------> --
	-- <------------- Create Check Configuration Items Ends ---------------> --
	
	local NewSubCheckBtn = _G[sCheckFramePrefix.."_NewSubCheckBtn"];
	if (NewSubCheckBtn == nil) then
		NewSubCheckBtn = CreateFrame("Button", sCheckFramePrefix.."_NewSubCheckBtn", CheckFrame, "OptionsButtonTemplate");
	end
	NewSubCheckBtn:SetWidth(150);
	NewSubCheckBtn:SetHeight(20);
	NewSubCheckBtn:SetText(EA_XGRPALERT_NEWSUBCHECKBTN);
	NewSubCheckBtn:SetPoint("TOPLEFT", CloseBtn, "BOTTOMLEFT", 20, 0);
	NewSubCheckBtn:Show();
	NewSubCheckBtn:SetScript("OnClick", EAFun_GroupEvent_AddNewSubCheckBtn_Click);
	NewSubCheckBtn.PreFrame = CloseBtn;
	NewSubCheckBtn.SpellIndex = iSpellIndex;
	NewSubCheckBtn.CheckIndex = iCheckIndex;
	NewSubCheckBtn.SubCheckCnts = 0;

	-- Automatic call AddNewBtn to Create SubCheck Items
	EAFun_GroupEvent_AddNewSubCheckBtn_Click(NewSubCheckBtn);
end

-- Create SubCheck Configuration Items
-- Show a Logic-Operation, EventType, UnitType...
function EAFun_GroupEvent_AddNewSubCheckBtn_Click(self)
	self.SubCheckCnts = self.SubCheckCnts + 1;
	local iSpellIndex = self.SpellIndex;
	local iCheckIndex = self.CheckIndex;
	local iSubCheckIndex = self.SubCheckCnts;
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;
	local sSpellFramePrefix = G_Group_CfgFramePrefix..iSpellIndex;
	local sCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex;
	local sSubCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex;
	local ExtraInfo = {["SpellIndex"]=iSpellIndex, ["CheckIndex"]=iCheckIndex, ["SubCheckIndex"]=iSubCheckIndex,};

	local RootFrame = _G[sCheckFramePrefix.."_CloseBtn"];
	local PreSubCheckFrame = self.PreFrame;
	local iOffsetX = 0;
	if (PreSubCheckFrame == RootFrame) then iOffsetX = 15 end;

	G_TempGroupValids[iSpellIndex][iCheckIndex][iSubCheckIndex] = true;
	local SpellFrame = _G[sSpellFramePrefix];
	local CheckFrame = _G[sCheckFramePrefix];
	local SubCheckFrame = _G[sSubCheckFramePrefix];
	if (SubCheckFrame == nil) then
		SubCheckFrame = CreateFrame("Frame", sSubCheckFramePrefix, CheckFrame);
	end
	SubCheckFrame:SetWidth(620);
	SubCheckFrame:SetHeight(80);
	SubCheckFrame:SetPoint("TOPLEFT", PreSubCheckFrame, "BOTTOMLEFT", iOffsetX, 0);
	SubCheckFrame:Show();
	PreSubCheckFrame.NextFrame = SubCheckFrame;
	SubCheckFrame.PreFrame = PreSubCheckFrame;
	SubCheckFrame.NextFrame = self;
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", SubCheckFrame, "BOTTOMLEFT", 5, 0);
	self.PreFrame = SubCheckFrame;
	CheckFrame:SetHeight(CheckFrame:GetHeight() + 80);
	SpellFrame:SetHeight(SpellFrame:GetHeight() + 80);

	-- <------------- Create SubCheck Configuration Items Starts ---------------> --
	-- <------------- Create SubCheck Configuration Items Starts ---------------> --
	local CloseBtn = _G[sSubCheckFramePrefix.."_CloseBtn"];
	if (CloseBtn == nil) then
		CloseBtn = CreateFrame("Button", sSubCheckFramePrefix.."_CloseBtn", SubCheckFrame, "OptionsButtonTemplate");
	end
	CloseBtn:SetWidth(20);
	CloseBtn:SetHeight(20);
	CloseBtn:SetText("X");
	CloseBtn:SetPoint("TOPLEFT", SubCheckFrame, "TOPLEFT", 10, -5);
	CloseBtn:SetScript("OnClick", EAFun_GroupEvent_CloseBtn_OnClick);
	CloseBtn.SpellIndex = iSpellIndex;
	CloseBtn.CheckIndex = iCheckIndex;
	CloseBtn.SubCheckIndex = iSubCheckIndex;
	CloseBtn.CloseLevel = 3;
	CloseBtn:Show();
	
	local SubCheckTitle = _G[sSubCheckFramePrefix.."_SubCheckTitle"];
	if (SubCheckTitle == nil) then
		SubCheckTitle = SubCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubCheckTitle", "ARTWORK", "GameFontNormal");
	end
	SubCheckTitle:SetPoint("TOPLEFT", CloseBtn, "TOPRIGHT", 0, -2);
	SubCheckTitle:SetText("["..iSubCheckIndex.."]"..EA_XGRPALERT_TITLESUBCHECK);

	--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].SubCheckAndOp
	--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckOpDropdown"
	local SubCheckOpDropdown = _G[sSubCheckFramePrefix.."_SubCheckOpDropdown"];
	if (SubCheckOpDropdown == nil) then
		SubCheckOpDropdown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckOpDropdown", SubCheckFrame, "UIDropDownMenuTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = 1;
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("SubCheckAndOp", iSpellIndex, iCheckIndex, iSubCheckIndex);
		if (fGetValue) then
			if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
		end
	UIDropDownMenu_SetWidth(SubCheckOpDropdown, 60);
	EAFun_GroupEvent_DropDown_OnLoad(SubCheckOpDropdown, EA_XGRPALERT_LOGICS, sDefaultValue);
	SubCheckOpDropdown:SetPoint("TOPLEFT", SubCheckTitle, "TOPRIGHT", -15, 5);
	SubCheckOpDropdown:Show();

	local SubCheckText1 = _G[sSubCheckFramePrefix.."_SubCheckText1"];
	if (SubCheckText1 == nil) then
		SubCheckText1 = SubCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubCheckText1", "ARTWORK", "GameFontNormal");
	end
	SubCheckText1:SetPoint("TOPLEFT", SubCheckOpDropdown, "TOPRIGHT", 0, -5);
	SubCheckText1:SetText(EA_XGRPALERT_EVENTTYPE);

	--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].EventType
	--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckEventTypeDowndown"
	local SubCheckEventTypeDowndown = _G[sSubCheckFramePrefix.."_SubCheckEventTypeDowndown"];
	if (SubCheckEventTypeDowndown == nil) then
		SubCheckEventTypeDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckEventTypeDowndown", SubCheckFrame, "UIDropDownMenuTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = "UNIT_POWER_UPDATE";
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("EventType", iSpellIndex, iCheckIndex, iSubCheckIndex);
		if (fGetValue) then
			sDefaultValue = sReturnValue;
		end
	UIDropDownMenu_SetWidth(SubCheckEventTypeDowndown, 210);
	EAFun_GroupEvent_DropDown_OnLoad(SubCheckEventTypeDowndown, EA_XGRPALERT_EVENTTYPES, sDefaultValue, ExtraInfo);
	SubCheckEventTypeDowndown:SetPoint("TOPLEFT", SubCheckText1, "TOPRIGHT", -15, 5);
	SubCheckEventTypeDowndown:Show();

	local SubCheckText2 = _G[sSubCheckFramePrefix.."_SubCheckText2"];
	if (SubCheckText2 == nil) then
		SubCheckText2 = SubCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubCheckText2", "ARTWORK", "GameFontNormal");
	end
	SubCheckText2:SetPoint("TOPLEFT", SubCheckTitle, "BOTTOMLEFT", 0, -10);
	SubCheckText2:SetText(EA_XGRPALERT_UNITTYPE);

	--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].UnitType
	--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckUnitTypeDowndown"
	local SubCheckUnitTypeDowndown = _G[sSubCheckFramePrefix.."_SubCheckUnitTypeDowndown"];
	if (SubCheckUnitTypeDowndown == nil) then
		SubCheckUnitTypeDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckUnitTypeDowndown", SubCheckFrame, "UIDropDownMenuTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = "player";
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("UnitType", iSpellIndex, iCheckIndex, iSubCheckIndex);
		if (fGetValue) then
			sDefaultValue = sReturnValue;
		end
	UIDropDownMenu_SetWidth(SubCheckUnitTypeDowndown, 170);
	EAFun_GroupEvent_DropDown_OnLoad(SubCheckUnitTypeDowndown, EA_XGRPALERT_UNITTYPES, sDefaultValue);
	SubCheckUnitTypeDowndown:SetPoint("TOPLEFT", SubCheckText2, "TOPRIGHT", -15, 5);
	SubCheckUnitTypeDowndown:Show();

	local SubCheckText3 = _G[sSubCheckFramePrefix.."_SubCheckText3"];
	if (SubCheckText3 == nil) then
		SubCheckText3 = SubCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubCheckText3", "ARTWORK", "GameFontNormal");
	end
	SubCheckText3:SetPoint("TOPLEFT", SubCheckUnitTypeDowndown, "TOPRIGHT", 0, -5);
	SubCheckText3:SetText(EA_XGRPALERT_CHECKCD);

	--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].CheckCD
	--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckCDTextBox"
	local SubCheckCDTextBox = _G[sSubCheckFramePrefix.."_SubCheckCDTextBox"];
	if (SubCheckCDTextBox == nil) then
		SubCheckCDTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckCDTextBox", SubCheckFrame, "EA_SpellEditBoxTemplate");
	end	-- Get GroupItem Value
		sDefaultValue = "";
		fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CheckCD", iSpellIndex, iCheckIndex, iSubCheckIndex);
		if (fGetValue) then
			sDefaultValue = sReturnValue;
		end
	SubCheckCDTextBox:SetText(sDefaultValue);
	SubCheckCDTextBox:SetPoint("TOPLEFT", SubCheckText3, "TOPRIGHT", 10, 5);
	SubCheckCDTextBox:Show();
	-- <------------- Create SubCheck Configuration Items Ends ---------------> --
	-- <------------- Create SubCheck Configuration Items Ends ---------------> --
end

-- Create UNIT_POWER_UPDATE, UNIT_HEALTH, UNIT_AURA, UNIT_COMBO_POINTS EventItems
-- Show 1 sub-frame from 3 sub-frames, and Hide the other 2 sub-frames.
function EAFun_GroupEvent_ChangeEventType_Click(EventType, ExtraInfo)
	local iSpellIndex = ExtraInfo.SpellIndex;
	local iCheckIndex = ExtraInfo.CheckIndex;
	local iSubCheckIndex= ExtraInfo.SubCheckIndex;
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;
	local ExtraInfo = {["SpellIndex"]=iSpellIndex, ["CheckIndex"]=iCheckIndex, ["SubCheckIndex"]=iSubCheckIndex, ["EventIndex"]=3};
	local sSubCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex;
	local SubCheckFrame = _G[sSubCheckFramePrefix];
	local SubEventFrame, iShowEventIndex = nil, 1;

	if (EventType == "UNIT_POWER_UPDATE") then
		iShowEventIndex = 1;
	elseif (EventType == "UNIT_HEALTH") then
		iShowEventIndex = 2;
	elseif (EventType == "UNIT_AURA") then
		iShowEventIndex = 3;
	elseif (EventType == "UNIT_COMBO_POINTS") then
		iShowEventIndex = 4;
	end
	
	for iLoop=1,4 do
		SubEventFrame = _G[sSubCheckFramePrefix.."_"..iLoop];
		if (iLoop ~= iShowEventIndex) then	
			-- Hide this EventItems Frame
			if (SubEventFrame ~= nil) then 
				SubEventFrame:Hide();
			end
		else	-- Show this EventItems Frame
			if (SubEventFrame == nil) then
				SubEventFrame = CreateFrame("Frame", sSubCheckFramePrefix.."_"..iLoop, SubCheckFrame);
			end
			SubEventFrame:SetWidth(590);
			SubEventFrame:SetHeight(50);
			if (iLoop == 1) then
				-- <------------ Create UNIT_POWER_UPDATE EventItems Starts ------------> --
				-- <------------ Create UNIT_POWER_UPDATE EventItems Starts ------------> --
				-- print ("Create UNIT_POWER_UPDATE EventItems");
				local SubEventPowerText1 = _G[sSubCheckFramePrefix.."_SubEventPowerText1"];
				if (SubEventPowerText1 == nil) then
					SubEventPowerText1 = SubEventFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventPowerText1", "ARTWORK", "GameFontNormal");
				end
				SubEventPowerText1:SetPoint("TOPLEFT", SubEventFrame, "TOPLEFT", 0, -58);
				SubEventPowerText1:SetText(EA_XGRPALERT_POWERTYPE);
				
				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].PowerTypeNum
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckPowerTypeDowndown"
				local SubCheckPowerTypeDowndown = _G[sSubCheckFramePrefix.."_SubCheckPowerTypeDowndown"];
				if (SubCheckPowerTypeDowndown == nil) then
					SubCheckPowerTypeDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckPowerTypeDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 0;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("PowerTypeNum", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						sDefaultValue = sReturnValue;
					end
				UIDropDownMenu_SetWidth(SubCheckPowerTypeDowndown, 90);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckPowerTypeDowndown, EA_XGRPALERT_POWERTYPES, sDefaultValue);
				SubCheckPowerTypeDowndown:SetPoint("TOPLEFT", SubEventPowerText1, "TOPRIGHT", -15, 5);
				SubCheckPowerTypeDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].PowerCompType
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckPowerCompDowndown"
				local SubCheckPowerCompDowndown = _G[sSubCheckFramePrefix.."_SubCheckPowerCompDowndown"];
				if (SubCheckPowerCompDowndown == nil) then
					SubCheckPowerCompDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckPowerCompDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("PowerCompType", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						-- if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
						sDefaultValue = sReturnValue;
					end
				UIDropDownMenu_SetWidth(SubCheckPowerCompDowndown, 60);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckPowerCompDowndown, EA_XGRPALERT_COMPARES, sDefaultValue);
				SubCheckPowerCompDowndown:SetPoint("TOPLEFT", SubCheckPowerTypeDowndown, "TOPRIGHT", -30, 0);
				SubCheckPowerCompDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].PowerLessThanValue or PowerLessThanPercent
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckPowerCompTypeDowndown"
				local SubCheckPowerCompTypeDowndown = _G[sSubCheckFramePrefix.."_SubCheckPowerCompTypeDowndown"];
				if (SubCheckPowerCompTypeDowndown == nil) then
					SubCheckPowerCompTypeDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckPowerCompTypeDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("PowerLessThanPercent", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = 2 end;
					end
				UIDropDownMenu_SetWidth(SubCheckPowerCompTypeDowndown, 75);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckPowerCompTypeDowndown, EA_XGRPALERT_COMPARETYPES, sDefaultValue);
				SubCheckPowerCompTypeDowndown:SetPoint("TOPLEFT", SubCheckPowerCompDowndown, "TOPRIGHT", -30, 0);
				SubCheckPowerCompTypeDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].PowerLessThanValue or PowerLessThanPercent
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckPowerTextBox"
				local SubCheckPowerTextBox = _G[sSubCheckFramePrefix.."_SubCheckPowerTextBox"];
				if (SubCheckPowerTextBox == nil) then
					SubCheckPowerTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckPowerTextBox", SubEventFrame, "EA_SpellEditBoxTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = "";
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("PowerLessThanValue", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					else
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("PowerLessThanPercent", iSpellIndex, iCheckIndex, iSubCheckIndex);
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					end
				SubCheckPowerTextBox:SetText(sDefaultValue);
				SubCheckPowerTextBox:SetPoint("TOPLEFT", SubCheckPowerCompTypeDowndown, "TOPRIGHT", -5, -2);
				SubCheckPowerTextBox:Show();
				-- <------------ Create UNIT_POWER_UPDATE EventItems Ends ------------> --
				-- <------------ Create UNIT_POWER_UPDATE EventItems Ends ------------> --

			elseif (iLoop == 2) then
				-- <------------ Create UNIT_HEALTH EventItems Starts ------------> --
				-- <------------ Create UNIT_HEALTH EventItems Starts ------------> --
				-- print ("Create UNIT_HEALTH EventItems");
				local SubEventHealthText1 = _G[sSubCheckFramePrefix.."_SubEventHealthText1"];
				if (SubEventHealthText1 == nil) then
					SubEventHealthText1 = SubEventFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventHealthText1", "ARTWORK", "GameFontNormal");
				end
				SubEventHealthText1:SetPoint("TOPLEFT", SubEventFrame, "TOPLEFT", 0, -58);
				SubEventHealthText1:SetText(EA_XGRPALERT_HEALTH);
				
				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].HealthCompType
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckHealthCompDowndown"
				local SubCheckHealthCompDowndown = _G[sSubCheckFramePrefix.."_SubCheckHealthCompDowndown"];
				if (SubCheckHealthCompDowndown == nil) then
					SubCheckHealthCompDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckHealthCompDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("HealthCompType", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						-- if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
						sDefaultValue = sReturnValue;
					end
				UIDropDownMenu_SetWidth(SubCheckHealthCompDowndown, 60);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckHealthCompDowndown, EA_XGRPALERT_COMPARES, sDefaultValue);
				SubCheckHealthCompDowndown:SetPoint("TOPLEFT", SubEventHealthText1, "TOPRIGHT", -15, 5);
				SubCheckHealthCompDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].HealthLessThanValue or HealthLessThanPercent
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckHealthCompTypeDowndown"
				local SubCheckHealthCompTypeDowndown = _G[sSubCheckFramePrefix.."_SubCheckHealthCompTypeDowndown"];
				if (SubCheckHealthCompTypeDowndown == nil) then
					SubCheckHealthCompTypeDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckHealthCompTypeDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("HealthLessThanPercent", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = 2 end;
					end
				UIDropDownMenu_SetWidth(SubCheckHealthCompTypeDowndown, 75);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckHealthCompTypeDowndown, EA_XGRPALERT_COMPARETYPES, sDefaultValue);
				SubCheckHealthCompTypeDowndown:SetPoint("TOPLEFT", SubCheckHealthCompDowndown, "TOPRIGHT", -30, 0);
				SubCheckHealthCompTypeDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].HealthLessThanValue or HealthLessThanPercent
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckHealthTextBox"
				local SubCheckHealthTextBox = _G[sSubCheckFramePrefix.."_SubCheckHealthTextBox"];
				if (SubCheckHealthTextBox == nil) then
					SubCheckHealthTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckHealthTextBox", SubEventFrame, "EA_SpellEditBoxTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = "";
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("HealthLessThanValue", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					else
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("HealthLessThanPercent", iSpellIndex, iCheckIndex, iSubCheckIndex);
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					end
				SubCheckHealthTextBox:SetText(sDefaultValue);
				SubCheckHealthTextBox:SetPoint("TOPLEFT", SubCheckHealthCompTypeDowndown, "TOPRIGHT", -5, -2);
				SubCheckHealthTextBox:Show();
				-- <------------ Create UNIT_HEALTH EventItems Ends ------------> --
				-- <------------ Create UNIT_HEALTH EventItems Ends ------------> --

			elseif (iLoop == 3) then
				-- <------------ Create UNIT_AURA EventItems Starts ------------> --
				-- <------------ Create UNIT_AURA EventItems Starts ------------> --
				-- print ("Create UNIT_AURA EventItems");
				local SubEventAuraText1 = _G[sSubCheckFramePrefix.."_SubEventAuraText1"];
				if (SubEventAuraText1 == nil) then
					SubEventAuraText1 = SubEventFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventAuraText1", "ARTWORK", "GameFontNormal");
				end
				SubEventAuraText1:SetPoint("TOPLEFT", SubEventFrame, "TOPLEFT", 0, -58);
				SubEventAuraText1:SetText(EA_XGRPALERT_CHECKAURA);
				
				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].CheckAuraExist or CheckAuraNotExist
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckAuraExistDowndown"
				local SubCheckAuraExistDowndown = _G[sSubCheckFramePrefix.."_SubCheckAuraExistDowndown"];
				if (SubCheckAuraExistDowndown == nil) then
					SubCheckAuraExistDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckAuraExistDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CheckAuraNotExist", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = 2 end;
					end
				UIDropDownMenu_SetWidth(SubCheckAuraExistDowndown, 75);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckAuraExistDowndown, EA_XGRPALERT_CHECKAURAS, sDefaultValue, ExtraInfo);
				SubCheckAuraExistDowndown:SetPoint("TOPLEFT", SubEventAuraText1, "TOPRIGHT", -15, 5);
				SubCheckAuraExistDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].CheckAuraExist or CheckAuraNotExist
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckAuraIDTextBox"
				local SubCheckAuraIDTextBox = _G[sSubCheckFramePrefix.."_SubCheckAuraIDTextBox"];
				if (SubCheckAuraIDTextBox == nil) then
					SubCheckAuraIDTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckAuraIDTextBox", SubEventFrame, "EA_SpellEditBoxTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = "";
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CheckAuraExist", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					else
						fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CheckAuraNotExist", iSpellIndex, iCheckIndex, iSubCheckIndex);
						if (sReturnValue ~= nil) then sDefaultValue = sReturnValue end;
					end
				SubCheckAuraIDTextBox:SetText(sDefaultValue);
				SubCheckAuraIDTextBox:SetPoint("TOPLEFT", SubCheckAuraExistDowndown, "TOPRIGHT", -5, -2);
				SubCheckAuraIDTextBox:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].CastByPlayer
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckCastByPlayerCheckBox"
				local SubCheckCastByPlayerCheckBox = _G[sSubCheckFramePrefix.."_SubCheckCastByPlayerCheckBox"];
				if (SubCheckCastByPlayerCheckBox == nil) then
					SubCheckCastByPlayerCheckBox = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckCastByPlayerCheckBox", SubEventFrame, "OptionsCheckButtonTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = false;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("CastByPlayer", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						sDefaultValue = sReturnValue;
					end
				SubCheckCastByPlayerCheckBox:SetChecked(sDefaultValue);
				_G[SubCheckCastByPlayerCheckBox:GetName().."Text"]:SetText(EA_XGRPALERT_CASTBYPLAYER);
				SubCheckCastByPlayerCheckBox:SetPoint("BOTTOMLEFT", SubCheckAuraIDTextBox, "TOPRIGHT", 225, 3);
				SubCheckCastByPlayerCheckBox:Show();
				-- <------------ Create UNIT_AURA EventItems Ends ------------> --
				-- <------------ Create UNIT_AURA EventItems Ends ------------> --
			elseif (iLoop == 4) then
				-- <------------ Create UNIT_COMBO_POINTS EventItems Starts ------------> --
				-- <------------ Create UNIT_COMBO_POINTS EventItems Starts ------------> --
				-- print ("Create UNIT_COMBO_POINTS EventItems");
				local SubEventComboText1 = _G[sSubCheckFramePrefix.."_SubEventComboText1"];
				if (SubEventComboText1 == nil) then
					SubEventComboText1 = SubEventFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventComboText1", "ARTWORK", "GameFontNormal");
				end
				SubEventComboText1:SetPoint("TOPLEFT", SubEventFrame, "TOPLEFT", 0, -58);
				SubEventComboText1:SetText(EA_XGRPALERT_COMBOPOINT);

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].ComboCompType
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckComboCompDowndown"
				local SubCheckComboCompDowndown = _G[sSubCheckFramePrefix.."_SubCheckComboCompDowndown"];
				if (SubCheckComboCompDowndown == nil) then
					SubCheckComboCompDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckComboCompDowndown", SubEventFrame, "UIDropDownMenuTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = 1;
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("ComboCompType", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						-- if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
						sDefaultValue = sReturnValue;
					end
				UIDropDownMenu_SetWidth(SubCheckComboCompDowndown, 60);
				EAFun_GroupEvent_DropDown_OnLoad(SubCheckComboCompDowndown, EA_XGRPALERT_COMPARES, sDefaultValue);
				SubCheckComboCompDowndown:SetPoint("TOPLEFT", SubEventComboText1, "TOPRIGHT", -15, 5);
				SubCheckComboCompDowndown:Show();

				--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].ComboLessThanValue
				--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckComboTextBox"
				local SubCheckComboTextBox = _G[sSubCheckFramePrefix.."_SubCheckComboTextBox"];
				if (SubCheckComboTextBox == nil) then
					SubCheckComboTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckComboTextBox", SubEventFrame, "EA_SpellEditBoxTemplate");
				end	-- Get GroupItem Value
					sDefaultValue = "";
					fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("ComboLessThanValue", iSpellIndex, iCheckIndex, iSubCheckIndex);
					if (fGetValue) then
						sDefaultValue = sReturnValue;
					end
				SubCheckComboTextBox:SetText(sDefaultValue);
				SubCheckComboTextBox:SetWidth(35);
				SubCheckComboTextBox:SetMaxLetters(1);
				SubCheckComboTextBox:SetPoint("TOPLEFT", SubCheckComboCompDowndown, "TOPRIGHT", -5, -2);
				SubCheckComboTextBox:Show();
				-- <------------ Create UNIT_COMBO_POINTS EventItems Ends ------------> --
				-- <------------ Create UNIT_COMBO_POINTS EventItems Ends ------------> --
			end
			SubEventFrame:SetPoint("TOPLEFT", SubCheckFrame, "TOPLEFT", 30, 0);
			-- SubEventFrame:SetBackdrop({bgFile = "Interface/Icons/INV_Misc_Herb_Felblossom"});
			SubEventFrame:Show();
		end
	end
end

-- Contiune Create UNIT_AURA AuraChcekItems
-- Show 1 sub-frame of CheckAuraExist, hide when CheckAuraNotExist
function EAFun_GroupEvent_ChangeAuraCheck_Click(AuraCheck, ExtraInfo)
	local iSpellIndex = ExtraInfo.SpellIndex;
	local iCheckIndex = ExtraInfo.CheckIndex;
	local iSubCheckIndex= ExtraInfo.SubCheckIndex;
	local iEventIndex = ExtraInfo.EventIndex;
	local fGetValue, sReturnValue, sDefaultValue = false, nil, nil;

	local sSubCheckFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex;
	local sSubEventFramePrefix = G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_"..iEventIndex;
	local SubEventFrame = _G[sSubEventFramePrefix];
	local SubAuraCheckFrame = nil;


	-- AuraCheck == 1, to show additional frame.
	-- AuraCheck == 2. to hide.
	SubAuraCheckFrame = _G[sSubEventFramePrefix.."_"..1];
	if (AuraCheck == 2) then	-- Hide this AuraCheckItems Frame
		if (SubAuraCheckFrame ~= nil) then 
			SubAuraCheckFrame:Hide();
		end
	else				-- Show this AuraCheckItems Frame
		if (SubAuraCheckFrame == nil) then
			SubAuraCheckFrame = CreateFrame("Frame", sSubEventFramePrefix.."_"..1, SubEventFrame);
		end
		SubAuraCheckFrame:SetWidth(370);
		SubAuraCheckFrame:SetHeight(25);

		-- <------------ Contiune Create UNIT_AURA AuraChcekItems Starts ------------> --
		-- <------------ Contiune Create UNIT_AURA AuraChcekItems Starts ------------> --
		-- Create UNIT_POWER_UPDATE EventItems
		-- print ("Create ContiuneUNIT_AURA EventItems");
		local SubEventAuraText2 = _G[sSubCheckFramePrefix.."_SubEventAuraText2"];
		if (SubEventAuraText2 == nil) then
			SubEventAuraText2 = SubAuraCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventAuraText2", "ARTWORK", "GameFontNormal");
		end
		SubEventAuraText2:SetPoint("TOPLEFT", SubAuraCheckFrame, "TOPLEFT", 10, -3);
		SubEventAuraText2:SetText(EA_XGRPALERT_AURATIME);
		
		--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].TimeCompType
		--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckTimeCompDowndown"
		local SubCheckTimeCompDowndown = _G[sSubCheckFramePrefix.."_SubCheckTimeCompDowndown"];
		if (SubCheckTimeCompDowndown == nil) then
			SubCheckTimeCompDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckTimeCompDowndown", SubAuraCheckFrame, "UIDropDownMenuTemplate");
		end	-- Get GroupItem Value
			sDefaultValue = 1;
			fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("TimeCompType", iSpellIndex, iCheckIndex, iSubCheckIndex);
			if (fGetValue) then
				-- if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
				sDefaultValue = sReturnValue;
			end
		UIDropDownMenu_SetWidth(SubCheckTimeCompDowndown, 50);
		EAFun_GroupEvent_DropDown_OnLoad(SubCheckTimeCompDowndown, EA_XGRPALERT_COMPARES, sDefaultValue);
		SubCheckTimeCompDowndown:SetPoint("TOPLEFT", SubEventAuraText2, "TOPRIGHT", -15, 5);
		SubCheckTimeCompDowndown:Show();

		--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].TimeLessThanValue
		--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckAuraTimeTextBox"
		local SubCheckAuraTimeTextBox = _G[sSubCheckFramePrefix.."_SubCheckAuraTimeTextBox"];
		if (SubCheckAuraTimeTextBox == nil) then
			SubCheckAuraTimeTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckAuraTimeTextBox", SubAuraCheckFrame, "EA_SpellEditBoxTemplate");
		end	-- Get GroupItem Value
			sDefaultValue = "";
			fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("TimeLessThanValue", iSpellIndex, iCheckIndex, iSubCheckIndex);
			if (fGetValue) then
				sDefaultValue = sReturnValue;
			end
		SubCheckAuraTimeTextBox:SetText(sDefaultValue);
		SubCheckAuraTimeTextBox:SetWidth(35);
		SubCheckAuraTimeTextBox:SetMaxLetters(3);
		SubCheckAuraTimeTextBox:SetPoint("TOPLEFT", SubCheckTimeCompDowndown, "TOPRIGHT", -5, -2);
		SubCheckAuraTimeTextBox:Show();

		local SubEventAuraText3 = _G[sSubCheckFramePrefix.."_SubEventAuraText3"];
		if (SubEventAuraText3 == nil) then
			SubEventAuraText3 = SubAuraCheckFrame:CreateFontString(sSubCheckFramePrefix.."_SubEventAuraText3", "ARTWORK", "GameFontNormal");
		end
		SubEventAuraText3:SetPoint("TOPLEFT", SubCheckAuraTimeTextBox, "TOPRIGHT", 10, -3);
		SubEventAuraText3:SetText(EA_XGRPALERT_AURASTACK);
		
		--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].StackCompType
		--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckStackCompDowndown"
		local SubCheckStackCompDowndown = _G[sSubCheckFramePrefix.."_SubCheckStackCompDowndown"];
		if (SubCheckStackCompDowndown == nil) then
			SubCheckStackCompDowndown = CreateFrame("CheckButton", sSubCheckFramePrefix.."_SubCheckStackCompDowndown", SubAuraCheckFrame, "UIDropDownMenuTemplate");
		end	-- Get GroupItem Value
			sDefaultValue = 1;
			fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("StackCompType", iSpellIndex, iCheckIndex, iSubCheckIndex);
			if (fGetValue) then
				-- if (sReturnValue) then sDefaultValue = 1 else sDefaultValue = 0 end;
				sDefaultValue = sReturnValue;
			end
		UIDropDownMenu_SetWidth(SubCheckStackCompDowndown, 50);
		EAFun_GroupEvent_DropDown_OnLoad(SubCheckStackCompDowndown, EA_XGRPALERT_COMPARES, sDefaultValue);
		SubCheckStackCompDowndown:SetPoint("TOPLEFT", SubEventAuraText3, "TOPRIGHT", -15, 5);
		SubCheckStackCompDowndown:Show();

		--// G_GroupItems.Spells[iSpellIndex].Checks[iCheckIndex].SubChecks[iSubCheckIndex].StackLessThanValue
		--// G_Group_CfgFramePrefix..iSpellIndex.."_"..iCheckIndex.."_"..iSubCheckIndex.."_SubCheckAuraStackTextBox"
		local SubCheckAuraStackTextBox = _G[sSubCheckFramePrefix.."_SubCheckAuraStackTextBox"];
		if (SubCheckAuraStackTextBox == nil) then
			SubCheckAuraStackTextBox = CreateFrame("EditBox", sSubCheckFramePrefix.."_SubCheckAuraStackTextBox", SubAuraCheckFrame, "EA_SpellEditBoxTemplate");
		end	-- Get GroupItem Value
			sDefaultValue = "";
			fGetValue, sReturnValue = EAFun_GroupEvent_GetValueFromGroupItem("StackLessThanValue", iSpellIndex, iCheckIndex, iSubCheckIndex);
			if (fGetValue) then
				sDefaultValue = sReturnValue;
			end
		SubCheckAuraStackTextBox:SetText(sDefaultValue);
		SubCheckAuraStackTextBox:SetWidth(35);
		SubCheckAuraStackTextBox:SetMaxLetters(3);
		SubCheckAuraStackTextBox:SetPoint("TOPLEFT", SubCheckStackCompDowndown, "TOPRIGHT", -5, -2);
		SubCheckAuraStackTextBox:Show();
		-- <------------ Contiune Create UNIT_AURA AuraChcekItems Ends ------------> --
		-- <------------ Contiune Create UNIT_AURA AuraChcekItems Ends ------------> --

		SubAuraCheckFrame:SetPoint("TOPLEFT", SubEventFrame, "TOPLEFT", 220, -55);
		-- SubAuraCheckFrame:SetBackdrop({bgFile = "Interface/Icons/INV_Misc_Herb_Felblossom"});
		SubAuraCheckFrame:Show();
	end
end
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------



function EventAlert_Options_AlertSoundSelect_OnLoad()
	UIDropDownMenu_Initialize(EA_Options_Frame_AlertSoundSelect, EventAlert_Options_AlertSoundSelect_Initialize);
	UIDropDownMenu_SetSelectedID(EA_Options_Frame_AlertSoundSelect, EA_Config.AlertSoundValue);
	UIDropDownMenu_SetWidth(EA_Options_Frame_AlertSoundSelect, 130);
end


function EventAlert_Options_AlertSoundSelect_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(EA_Options_Frame_AlertSoundSelect);
	if selectedValue == nil then selectedValue = 0 end;

	local info = {};
	local function AddItem(text, value)
		info.text = text;
		info.func = EventAlert_Options_AlertSoundSelect_OnClick;
		info.value = value;
		if (info.value == selectedValue) then
			info.checked = 1;
		end
		info.checked = checked
		UIDropDownMenu_AddButton(info)
	end

	AddItem("ShaysBell", 1);
	AddItem("Flute", 2);
	AddItem("Netherwind", 3);
	AddItem("PolyCow", 4);
	AddItem("Rockbiter", 5);
	AddItem("Yarrrr!", 6);
	AddItem("Broken Heart", 7);
	AddItem("Millhouse 1!", 8);
	AddItem("Millhouse 2!", 9);
	AddItem("Pissed Satyr", 10);
	AddItem("Pissed Dwarf", 11);
end


function EventAlert_Options_AlertSoundSelect_OnClick(self)
	local SelValue = self.value;
	if SelValue == nil then SelValue = 0 end;
	UIDropDownMenu_SetSelectedValue(EA_Options_Frame_AlertSoundSelect, SelValue);

	if (SelValue == 1) then
		EA_Config.AlertSound = "Sound\\Spells\\ShaysBell.ogg";
	elseif (SelValue == 2) then
		EA_Config.AlertSound = "Sound\\Spells\\FluteRun.ogg";
	elseif (SelValue == 3) then
		EA_Config.AlertSound = "Sound\\Spells\\NetherwindFocusImpact.ogg";
	elseif (SelValue == 4) then
		EA_Config.AlertSound = "Sound\\Spells\\PolyMorphCow.ogg";
	elseif (SelValue == 5) then
		EA_Config.AlertSound = "Sound\\Spells\\RockBiterImpact.ogg";
	elseif (SelValue == 6) then
		EA_Config.AlertSound = "Sound\\Spells\\YarrrrImpact.ogg";
	elseif (SelValue == 7) then
		EA_Config.AlertSound = "Sound\\Spells\\valentines_brokenheart.ogg";
	elseif (SelValue == 8) then
		EA_Config.AlertSound = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Ready01.ogg";
	elseif (SelValue == 9) then
		EA_Config.AlertSound = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Pyro01.ogg";
	elseif (SelValue == 10) then
		EA_Config.AlertSound = "Sound\\Creature\\Satyre\\SatyrePissed4.ogg";
	elseif (SelValue == 11) then
		EA_Config.AlertSound = "Sound\\Creature\\Mortar Team\\MortarTeamPissed9.ogg";
	end
	EA_Config.AlertSoundValue = SelValue;
	PlaySoundFile(EA_Config.AlertSound);
end

function EventAlert_Options_MouseDown(button)
	if button == "LeftButton" then
		EA_Options_Frame:StartMoving();
	end
end

function EventAlert_Options_MouseUp(button)
	if button == "LeftButton" then
		EA_Options_Frame:StopMovingOrSizing();
	end
end