local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

	--------------------
	--About DCS Frame --
	--------------------
	local DCSAboutDCSFrame = CreateFrame("Button", "DCSAboutDCSFrame", InterfaceOptionsFrame) -- Parent is InterfaceOptionsFrame so that it can show over check boxes as checkboxes text is the highest level "TOOLTIP" and cannot be hidden or overlayed.
		DCSAboutDCSFrame:ClearAllPoints()
		DCSAboutDCSFrame:SetFrameStrata("TOOLTIP")
		DCSAboutDCSFrame:SetPoint("CENTER", -29, 6)
		DCSAboutDCSFrame:SetScale(1)
		DCSAboutDCSFrame:SetSize(370, 562)
		DCSAboutDCSFrame:EnableMouse(true)

		DCSAboutDCSFrame.mask = DCSAboutDCSFrame:CreateMaskTexture()
		DCSAboutDCSFrame.mask:SetTexture("Interface\\QUESTFRAME\\UI-QUESTLOG-EMPTY-TOPLEFT", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		DCSAboutDCSFrame.mask:SetSize(370, 562)
		DCSAboutDCSFrame.mask:SetPoint("TOPLEFT", DCSAboutDCSFrame, "TOPLEFT", 2, -2)
		
		DCSAboutDCSFrame.texture = DCSAboutDCSFrame:CreateTexture(nil,"ARTWORK")
		DCSAboutDCSFrame.texture:SetPoint("TOPLEFT", DCSAboutDCSFrame, "TOPLEFT", -372, 0)
		DCSAboutDCSFrame.texture:SetTexture("Interface\\QUESTFRAME\\QuestBackgroundHordeAlliance")
		DCSAboutDCSFrame.texture:SetSize(1270, 1405)
		DCSAboutDCSFrame.texture:AddMaskTexture(DCSAboutDCSFrame.mask)
		DCSAboutDCSFrame:Hide()	--Hidden by default so there is no issue like we had with ghost stats. Only shows if you click DCSAboutDCSButton.

		DCSAboutDCSFrame:SetScript("OnClick", function(self, button, down)
			DCSAboutDCSFrame:Hide()
		end)
		
		DejaCharacterStatsPanel:SetScript("OnHide", function(self) -- So that the frame hides when switching to a different panel or closing the InterfaceOptionsFrame
			DCSAboutDCSFrame:Hide()
		end)
		
	-------------------------
	--About DCS Seal Frame --
	-------------------------
	local DCSAboutDCSFrameSeal = CreateFrame("Frame", "DCSAboutDCSFrameSeal", DCSAboutDCSFrame)
		DCSAboutDCSFrameSeal:ClearAllPoints()
		--DCSAboutDCSFrameSeal:SetFrameStrata("DIALOG")
		DCSAboutDCSFrameSeal:SetPoint("BOTTOM", 0, 25)
		DCSAboutDCSFrameSeal:SetScale(0.65)
		DCSAboutDCSFrameSeal:SetSize(110, 110)

		DCSAboutDCSFrameSeal.mask = DCSAboutDCSFrameSeal:CreateMaskTexture()
		DCSAboutDCSFrameSeal.mask:SetTexture("Interface\\QUESTFRAME\\UI-QUESTLOG-EMPTY-TOPLEFT", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		DCSAboutDCSFrameSeal.mask:SetSize(110, 110)
		DCSAboutDCSFrameSeal.mask:SetPoint("CENTER", DCSAboutDCSFrameSeal, "CENTER", 0, 0)
		
		DCSAboutDCSFrameSeal.texture = DCSAboutDCSFrameSeal:CreateTexture(nil,"ARTWORK")
		DCSAboutDCSFrameSeal.texture:SetPoint("TOPLEFT", DCSAboutDCSFrameSeal, "TOPLEFT", -127, 1045)
		DCSAboutDCSFrameSeal.texture:SetTexture("Interface\\QUESTFRAME\\QuestBackgroundHordeAlliance")
		DCSAboutDCSFrameSeal.texture:SetSize(1270, 1305)
		DCSAboutDCSFrameSeal.texture:AddMaskTexture(DCSAboutDCSFrameSeal.mask)

	---------------------
	--About DCS Button --
	---------------------
	local DCSAboutDCSButton = CreateFrame("Button", "DCSAboutDCSButton", DejaCharacterStatsPanel, "UIPanelButtonTemplate")
		DCSAboutDCSButton:ClearAllPoints()
		DCSAboutDCSButton:SetPoint("BOTTOMRIGHT", -113, 8)
		DCSAboutDCSButton:SetScale(0.80)
		DCSAboutDCSButton:SetWidth(118)
		DCSAboutDCSButton:SetHeight(30)
		_G[DCSAboutDCSButton:GetName() .. "Text"]:SetText(L["About DCS"])
		
		DCSAboutDCSButton:SetScript("OnClick", function(self, button, down)
			if DCSAboutDCSFrame:IsShown() then
				DCSAboutDCSFrame:Hide()
			else
				DCSAboutDCSFrame:Show()
				local difference = DCSAboutDCSFrame:GetRight() - DCSAboutDCSFrame:GetLeft() - 50 --probably can be moved outside of function. since won't be often used, let remain 
				--DCSAboutDCS_FS:SetWidth(DCSAboutDCSFrame:GetRight() - DCSAboutDCSFrame:GetLeft() - 50)
				DCSAboutDCS_FS:SetWidth(difference) --somehow feels wrong to set a width of fontstring repeatedly to the same number. 
				--DCSAboutDCS_ThanksFS:SetWidth(DCSAboutDCSFrame:GetRight() - DCSAboutDCSFrame:GetLeft() - 50)
				DCSAboutDCS_ThanksFS:SetWidth(difference)
			end
		end)

	----------
	-- Text --
	----------
	
	-- Title
	local DCSAboutDCS_TitleFS = DCSAboutDCSFrame:CreateFontString("DCSAboutDCS_TitleFS", "OVERLAY", "GameFontNormal")
		DCSAboutDCS_TitleFS:SetText('|cff00c0ffDejaCharacterStats|r')
		DCSAboutDCS_TitleFS:SetPoint("TOP", 0, -30)
		DCSAboutDCS_TitleFS:SetFont("Fonts\\FRIZQT__.TTF", 25)
	
	-- Body
	local DCSAboutDCS_FS = DCSAboutDCSFrame:CreateFontString("DCSAboutDCS_FS", "OVERLAY", "GameFontNormal")
		DCSAboutDCS_FS:SetTextColor(0, 0, 0, 1)
		DCSAboutDCS_FS:SetShadowColor(0, 192, 255, 0)
		DCSAboutDCS_FS:SetFont("Fonts\\FRIZQT__.TTF", 13)
		DCSAboutDCS_FS:SetJustifyH("LEFT")
		DCSAboutDCS_FS:SetPoint("TOP", 0, -75)
		DCSAboutDCS_FS:Show();
		
		DCSAboutDCS_FS:SetText(
			"|cff0094c4Author:|r Dejoblue" .. "|n" .. 
			"|cff0094c4Admins:|r Dejoblue, Kakjens" .. "|n" .. 
			"|cff0094c4Contributers:|r Dejoblue, Kakjens, loudsoul" .. "|n" .. 
			"|cff0094c4Localization Translators:|r" .. "|n" ..
			"|cff0094c4    French:|r Lightuky, Medaleux, sv002, Darkcraft92," .. "|n" .. 						--(French)
			"        Ymvej, Druidzor, napnapnapnapnap" .. "|n" ..										--(French) Continued French list
			"|cff0094c4    German:|r pas06, flow0284, Markurion," .. "|n" .. 						--(German)
			"        Branduril, NekoNyaaaa" .. "|n" ..													--(German) Continued German list
			"|cff0094c4    Portuguese:|r Othra, Rhyrol" .. "|n" ..									--(Portuguese)
			"|cff0094c4    Spanish:|r Tholagar, Mikel391, MrUrkaz," .. "|n" ..						--(Spanish)
			"         Krounted, Valhallanem" .. "|n" ..													--(Spanish) Continued Spanish list
			"|cff0094c4    Italian:|r infinitybofh, INoobInside" .. "|n" ..							--(Portuguese)
			"|cff0094c4    Korean:|r PositiveMind, yuk6196, netaras," .. "|n" ..					--(Korean)
			"        meloppy, next96" .. "|n" ..														--(Korean) Continued Traditional Chinese list
			"|cff0094c4    Russian:|r Nappsel, Wishko, berufegoru," .. "|n" ..						--(Russian)
			"        Hubbotu, n1mrorox" .. "|n" ..																--(Russian) Continued Russian list
			"|cff0094c4    Simplified Chinese:|r C_Reus, alvisjiang," .. "|n" ..					--(Simplified Chinese)
			"        aenerv7, xlfd2008, y123ao6" .. "|n" ..																--(Simplified Chinese) Continued Simplified Chinese list
			"|cff0094c4    Traditional Chinese:|r BNSSNB, killsophia," .. "|n" ..					--(Traditional Chinese)
			"        konraddo, y123ao6" .. "|n" ..														--(Traditional Chinese) Continued Traditional Chinese list
			-- "|n" ..																					--(Spacer)
			"|cff0094c4Special Thanks:|r" .. "|n" ..
			"|cff0094c4    Communities:|r Blizzard, Curse, ElvUI," .. "|n" .. 
			"        WoWInterface, and Reddit's /r/wow" .. "|n" ..
			"|cff0094c4    Individuals:|r Baudzila, 10leej, wizardanim," .. "|n" ..
			"        Phanx, Ro, Choonster, Zork, Lombra," .. "|n" ..
			"        myrroddin, Darth_Predator, sirann," .. "|n" ..
			"        and YOU"
		);

	-- Thanks
	local DCSAboutDCS_ThanksFS = DCSAboutDCSFrame:CreateFontString("DCSAboutDCS_ThanksFS", "OVERLAY", "GameFontNormal")
		DCSAboutDCS_ThanksFS:SetTextColor(0, 192, 255, 1)
		DCSAboutDCS_ThanksFS:SetShadowColor(0, 0, 0, 1)
		DCSAboutDCS_ThanksFS:SetFont("Fonts\\FRIZQT__.TTF", 25)
		DCSAboutDCS_ThanksFS:SetJustifyH("CENTER")
		DCSAboutDCS_ThanksFS:SetPoint("BOTTOM", 0, 90)
		DCSAboutDCS_ThanksFS:Show();

		DCSAboutDCS_ThanksFS:SetText("Thank You!");
