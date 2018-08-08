local ids = {1,}
local function GetPrevCompleatedTutorial(id)
    for i=2, #ids do
        if ids[i]==id then return ids[i-1] end
    end
end

local function GetNextCompleatedTutorial(id)
    for i=1, #ids-1 do
        if ids[i]==id then return ids[i+1] end
    end
end

local MAX_TUTORIAL_VERTICAL_TILE = 30;
local MAX_TUTORIAL_IMAGES = 1;

local TutorialU1Frame_TOP_HEIGHT = 80;
local TutorialU1Frame_MIDDLE_HEIGHT = 10;
local TutorialU1Frame_BOTTOM_HEIGHT = 30;
local TutorialU1Frame_WIDTH = 364;

local DISPLAY_DATA = {
	-- layers can be BACKGROUND, BORDER, ARTWORK, OVERLAY, HIGHLIGHT
	-- if you don't assign one it will default to ARTWORK

--[[
	[1] = { --TUTORIAL_QUESTGIVERS
		tileHeight = 30,
        text = "任务NPC头顶上都会有一个感叹号(\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0\124t)。|cffffd200右键点击|r他们可以获得一个任务。任务NPC头顶上都会有一个感叹号(\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0\124t)。|cffffd200右键点击|r他们可以获得一个任务。任务NPC头顶上都会有一个感叹号(\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0\124t)。|cffffd200右键点击|r他们可以获得一个任务。任务NPC头顶上都会有一个感叹号(\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0\124t)。|cffffd200右键点击|r他们可以获得一个任务。任务NPC头顶上都会有一个感叹号(\124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0\124t)。|cffffd200右键点击|r他们可以获得一个任务。",
        title = "aaf发发发",
		textBox = {topLeft_xOff = 33, topLeft_yOff = -290, bottomRight_xOff = -29, bottomRight_yOff = 35},
		imageData1 = { "Interface\\AddOns\\!!!163UI.pics!!!\\!tdDropDown", 0, .1953125, 0, 1, w = 320, h = 250, }, --256, 200
	},
]]
};
--U1TUTORIAL_DISPLAY_DATA = DISPLAY_DATA

function TutorialU1Frame_OnLoad(self)
    CoreUIMakeMovable(TutorialU1Frame)
	for i = 1, MAX_TUTORIAL_VERTICAL_TILE do
		local texture = self:CreateTexture("TutorialU1FrameLeft"..i, "BORDER");
		texture:SetTexture("Interface\\TutorialFrame\\UI-TUTORIAL-FRAME");
		texture:SetTexCoord(0.3066406, 0.3261719, 0.656250025, 0.675781275);
		texture:SetSize(11, 10);
		texture = self:CreateTexture("TutorialU1FrameRight"..i, "BORDER");
		texture:SetTexture("Interface\\TutorialFrame\\UI-TUTORIAL-FRAME");
		texture:SetTexCoord(0.3496094, 0.3613281, 0.656250025, 0.675781275);
		texture:SetSize(7, 10);
    end
	TutorialU1FrameLeft1:SetPoint("TOPLEFT", TutorialU1FrameTop, "BOTTOMLEFT", 6, 0);
	TutorialU1FrameRight1:SetPoint("TOPRIGHT", TutorialU1FrameTop, "BOTTOMRIGHT", -1, 0);
	
	for i = 1, MAX_TUTORIAL_IMAGES do
		local texture = self:CreateTexture("TutorialU1FrameImage"..i, "ARTWORK");
        local border = self:CreateTexture();
        border:SetTexture("Interface\\BUTTONS\\UI-Quickslot-Depress")
        border:SetTexCoord(.06, .94, .06, .94)
        border:SetVertexColor(0, 0, 0)
        texture.border = border
	end

	TutorialU1Frame_ClearTextures();
end

function TutorialU1Frame_OnEvent(self, event, ...)
	if ( event == "DISPLAY_SIZE_CHANGED" ) then
		TutorialU1Frame_Update(TutorialU1Frame.id);
	end
end

function TutorialU1Frame_OnShow(self)
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
	TutorialU1Frame_CheckNextPrevButtons();
end

function TutorialU1Frame_OnHide(self)
	self:UnregisterEvent("DISPLAY_SIZE_CHANGED");
end

function TutorialU1Frame_CheckNextPrevButtons()
	local prevTutorial = GetPrevCompleatedTutorial(TutorialU1Frame.id);
	while ( prevTutorial and DISPLAY_DATA[prevTutorial].tileHeight == 0) do
		prevTutorial = GetPrevCompleatedTutorial(prevTutorial);
	end
	if ( prevTutorial ) then
		TutorialU1FramePrevButton:Enable();
	else
		TutorialU1FramePrevButton:Disable();
	end
	
	local nextTutorial = GetNextCompleatedTutorial(TutorialU1Frame.id);
	while ( nextTutorial and DISPLAY_DATA[nextTutorial].tileHeight == 0) do
		nextTutorial = GetNextCompleatedTutorial(nextTutorial);
	end	
	if ( nextTutorial ) then
		TutorialU1FrameNextButton:Enable();
	else
		TutorialU1FrameNextButton:Disable();
	end
end

function TutorialU1Frame_Update(currentTutorial)
	TutorialU1Frame_ClearTextures();
	TutorialU1Frame.id = currentTutorial;

	local displayData = DISPLAY_DATA[ currentTutorial ];
	if ( not displayData ) then
		return;
	end

	local _, className = UnitClass("player");
	local _, raceName  = UnitRace("player");
	className = strupper(className);
	raceName = strupper(raceName);
	if ( className == "DEATHKNIGHT") then
		raceName = "DEATHKNIGHT";
	end

    -- setup the frame
--[[
	if (displayData.anchorData) then
		local anchorData = displayData.anchorData;
		TutorialU1Frame:SetPoint( anchorData.align, UIParent, anchorData.align, anchorData.xOff, anchorData.yOff );
	end
]]

    local anchorParentLeft = TutorialU1FrameLeft1;
    local anchorParentRight = TutorialU1FrameRight1;
    for i = 2, displayData.tileHeight do
        local leftTexture = _G["TutorialU1FrameLeft"..i];
        local rightTexture = _G["TutorialU1FrameRight"..i];
        leftTexture:SetPoint("TOPLEFT", anchorParentLeft, "BOTTOMLEFT", 0, 0);
        rightTexture:SetPoint("TOPRIGHT", anchorParentRight, "BOTTOMRIGHT", 0, 0);
        leftTexture:Show();
        rightTexture:Show();
        anchorParentLeft = leftTexture;
        anchorParentRight = rightTexture;
    end
    TutorialU1FrameBottom:SetPoint("TOPLEFT", anchorParentLeft, "BOTTOMLEFT", 0, 0);
    TutorialU1FrameBottom:SetPoint("TOPRIGHT", anchorParentRight, "TOPRIGHT", 0, 0);

    local height = TutorialU1Frame_TOP_HEIGHT + (displayData.tileHeight * TutorialU1Frame_MIDDLE_HEIGHT) + TutorialU1Frame_BOTTOM_HEIGHT;
    TutorialU1Frame:SetSize(TutorialU1Frame_WIDTH, height);

	if (displayData.raidwarning) then
		RaidNotice_AddMessage(RaidWarningFrame, text, HIGHLIGHT_FONT_COLOR);
		return;
	end
	
	-- setup the title
	-- check for race-class specific first, then race specific, then class, then normal
	if (displayData.tileHeight > 0) then
        if (displayData.title) then
            TutorialU1FrameTitle:SetText(displayData.title);
        end
    end

	if (displayData.text) then
		TutorialU1FrameText:SetText(displayData.text);
	end
	
	if (displayData.textBox) then
		if(displayData.textBox.font) then
			TutorialU1FrameText:SetFontObject(displayData.textBox.font);
		end
		TutorialU1FrameTextScrollFrame:SetPoint("TOPLEFT", TutorialU1Frame, "TOPLEFT", displayData.textBox.topLeft_xOff, displayData.textBox.topLeft_yOff);
		TutorialU1FrameTextScrollFrame:SetPoint("BOTTOMRIGHT", TutorialU1Frame, "BOTTOMRIGHT", displayData.textBox.bottomRight_xOff, displayData.textBox.bottomRight_yOff);
	end

	-- setup the callout
	local callOut = displayData.callOut;
	if(callOut) then
		if ( callOut.align2 ) then
			TutorialU1FrameCallOut:SetPoint( callOut.align2, callOut.parent, callOut.align2, callOut.xOff2, callOut.yOff2 );
		else
			TutorialU1FrameCallOut:SetSize(callOut.width, callOut.height);
		end
		TutorialU1FrameCallOut:SetPoint( callOut.align, callOut.parent, callOut.align, callOut.xOff, callOut.yOff );
		TutorialU1FrameCallOut:Show();
	end

	-- setup images
	for i = 1, MAX_TUTORIAL_IMAGES do
		local imageTexture = _G["TutorialU1FrameImage"..i];
		local imageData = displayData["imageData"..i];
		if(imageData and imageTexture) then
            local file, left, right, top, bottom = imageData[1], imageData[2], imageData[3], imageData[4], imageData[5]
            imageTexture:SetTexture(file);
            imageTexture:SetTexCoord(left or 0, right or 1, top or 0, bottom or 1);
			imageTexture:SetPoint( "TOP", TutorialU1Frame, 5, -40);
            if imageData.w then
                imageTexture:SetSize(imageData.w, imageData.h)
            end
    		imageTexture:SetDrawLayer(imageData.layer or "BACKGROUND", 1);
            imageTexture.border:SetDrawLayer(imageData.layer or "BACKGROUND", 2);
            imageTexture.border:SetAllPoints(imageTexture)
			imageTexture:Show();
		elseif( imageTexture ) then
			imageTexture:ClearAllPoints();
			imageTexture:SetTexture("");
			imageTexture:Hide();
		end
	end

	-- show
    ShowUIPanel(TutorialU1Frame)
	--TutorialU1Frame:Show();
	TutorialU1Frame_CheckNextPrevButtons();
end

function TutorialU1Frame_ClearTextures()
	--TutorialU1Frame:ClearAllPoints();
	TutorialU1FrameBottom:ClearAllPoints();
	TutorialU1FrameTextScrollFrame:ClearAllPoints();
	TutorialU1FrameText:SetFontObject(GameFontNormal);
	TutorialU1FrameText:SetText("");
	TutorialU1FrameBackground:SetAlpha(1.0);

    -- top & left1 & right1 never have thier anchors changed; or are independantly hidden
	for i = 2, MAX_TUTORIAL_VERTICAL_TILE do
		local leftTexture = _G["TutorialU1FrameLeft"..i];
		local rightTexture = _G["TutorialU1FrameRight"..i];
		leftTexture:ClearAllPoints();
		rightTexture:ClearAllPoints();
		leftTexture:Hide();
		rightTexture:Hide();
	end

	for i = 1, MAX_TUTORIAL_IMAGES do
		local imageTexture = _G["TutorialU1FrameImage"..i];
		imageTexture:ClearAllPoints();
		imageTexture:SetTexture("");
		imageTexture:Hide();
	end

end

function TutorialU1FramePrevButton_OnClick(self)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	local prevTutorial = GetPrevCompleatedTutorial(TutorialU1Frame.id);
	while ( prevTutorial and DISPLAY_DATA[prevTutorial].tileHeight == 0) do
		prevTutorial = GetPrevCompleatedTutorial(prevTutorial);
	end
	if ( prevTutorial ) then
		TutorialU1Frame_Update(prevTutorial);
	end
end

function TutorialU1FrameNextButton_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	local nextTutorial = GetNextCompleatedTutorial(TutorialU1Frame.id);
	while ( nextTutorial and DISPLAY_DATA[nextTutorial].tileHeight == 0) do
		nextTutorial = GetNextCompleatedTutorial(nextTutorial);
	end
	if ( nextTutorial ) then
		TutorialU1Frame_Update(nextTutorial);
	end
end

function TutorialU1Frame_Hide()
	PlaySound(851); --"igMainMenuClose"
	HideUIPanel(TutorialU1Frame);
end

function TutorialU1Frame_SetTutorial(datas)
    table.wipe(ids);
    for k, v in pairs(datas) do
        DISPLAY_DATA[k] = v
        table.insert(ids, k)
    end
    table.sort(ids)
    TutorialU1Frame_Update(ids[1])
end

--[[------------------------------------------------------------
Example
---------------------------------------------------------------]]
--[[
CoreOnEvent("PLAYER_LOGIN", function()

    local btn = TplPanelButton(WorldMapDetailFrame, "CarboniteTutorialButton", 19):SetText("可接任务及采集助手"):AutoWidth():TR(4,2):SetFrameStrata("DIALOG"):un()
    btn:SetAlpha(0.5)
    btn:SetNormalFontObject(GameFontHighlight)
    btn:SetScript("OnEnter", function(self)
        UIFrameFadeIn(self, .2, .5, 1)
    end)
    btn:SetScript("OnLeave", function(self)
        UIFrameFadeOut(self, .2, 1, .2)
    end)
    btn:SetScript("OnClick", function()
        if WorldMapFrame:IsVisible() and UIPanelWindows["WorldMapFrame"] and UIPanelWindows["WorldMapFrame"].area == "full" then
            HideUIPanel(WorldMapFrame)
        end
        TutorialU1Frame_SetTutorial({
            [201] = {
                tileHeight = 25,
                text = "有爱的可接任务和采集助手是|cffffd200五星任务采集|r(Carbonite)的功能。可以从上方信息条\124TInterface\\Icons\\ACHIEVEMENT_GUILDPERK_MRPOPULARITY_RANK2:0\124t按钮，或者有爱控制台启用插件。注意|cffffd200任务数据库|r一定要开启。",
                title = "可接任务功能说明",
                textBox = {topLeft_xOff = 33, topLeft_yOff = -250, bottomRight_xOff = -29, bottomRight_yOff = 35},
                imageData1 = { "Interface\\AddOns\\Carbonite\\TutorialCarbonite", 0, 1, 0, 300/2048, w = 348, h = 300/512*348, }, --320, 250, 256, 200
            },
            [202] = {
                tileHeight = 25,
                text = "启用插件后，在屏幕右侧可以看到|cffffd200任务追踪列表|r，点击其顶部的|cffffd200黄色圆点|r就是开启和关闭可接任务的显示（蓝色表示只显示每日任务）。同时点击左上的\124TInterface\\AddOns\\Carbonite\\Gfx\\Skin\\ButWatchMenu:0\124t|cffffd200按钮|r，可以在菜单中调整要显示任务的等级范围，还可以从服务器上获取已完成的任务。",
                title = "可接任务功能说明",
                textBox = {topLeft_xOff = 33, topLeft_yOff = -250, bottomRight_xOff = -29, bottomRight_yOff = 35},
                imageData1 = { "Interface\\AddOns\\Carbonite\\TutorialCarbonite", 0, 1, 400/2048, (400+300)/2048, w = 348, h = 300/512*348, },
            },
            [203] = {
                tileHeight = 25,
                text = "注意，启用插件后，默认的大地图将被五星任务采集的无级缩放卫星地图|cffffd200替换|r，但您随时可以按|cffffd200ALT+M|r打开默认的地图界面。在选项中也可以设置为不替换默认大地图。五星任务插件占用较大，但有爱特别提供了|cffffd200即时开关|r的功能，只要点击信息条上的\124TInterface\\Icons\\ACHIEVEMENT_GUILDPERK_MRPOPULARITY_RANK2:0\124t按钮（或是在控制台中开关），就可以完全不占用任何CPU，所以您在打副本时轻轻一点，就不会带来卡顿。需要做任务或采集时，再点一下，就可以开启使用。",
                title = "可接任务功能说明",
                textBox = {topLeft_xOff = 33, topLeft_yOff = -80, bottomRight_xOff = -29, bottomRight_yOff = 35},
            },
            [204] = {
                tileHeight = 25,
                text = "要使用采集助手，需要先在控制台中加载采集点数据。例如图中先选中|cffffd200'显示草药采集点'|r然后点击|cffffd200'导入草药采集点'|r，确定。此时卫星地图上就可以显示出已知的草药点了。",
                title = "采集助手功能说明",
                textBox = {topLeft_xOff = 33, topLeft_yOff = -220, bottomRight_xOff = -29, bottomRight_yOff = 35},
                imageData1 = { "Interface\\AddOns\\Carbonite\\TutorialCarbonite", 0, 1, 800/2048, (800+255)/2048, w = 348, h = 255/512*348, },
            },
            [205] = {
                tileHeight = 25,
                text = "五星任务采集也提供了|cffffd200'采集路径'|r功能，具体使用方法是，右键点击地图，菜单中选择|cffffd200'路径'|r，再选择|cffffd200'当前显示的采集点'|r，就可以规划出比较合理的采集路径了。",
                title = "采集助手功能说明",
                textBox = {topLeft_xOff = 33, topLeft_yOff = -220, bottomRight_xOff = -29, bottomRight_yOff = 35},
                imageData1 = { "Interface\\AddOns\\Carbonite\\TutorialCarbonite", 0, 1, 1200/2048, (1200+260)/2048, w = 348, h = 260/512*348, },
            },
        })
    end)
end)
--]]