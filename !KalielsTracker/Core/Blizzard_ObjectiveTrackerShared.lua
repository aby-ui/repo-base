-- *****************************************************************************************************
-- ***** ITEM FUNCTIONS
-- *****************************************************************************************************
local function OnRelease(framePool, frame)
	frame:Hide();
	frame:ClearAllPoints();
	frame:SetParent(nil);
end

local g_questObjectiveItemPool = CreateFramePool("BUTTON", nil, "KT_QuestObjectiveItemButtonTemplate", OnRelease);
function KT_QuestObjectiveItem_AcquireButton(parent)
	local itemButton = g_questObjectiveItemPool:Acquire();
	itemButton:SetParent(parent);

	return itemButton;
end

function KT_QuestObjectiveItem_ReleaseButton(button)
	g_questObjectiveItemPool:Release(button);
end

function KT_QuestObjectiveItem_Initialize(itemButton, questLogIndex)
	local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex);
	itemButton:SetID(questLogIndex);
	itemButton.charges = charges;
	itemButton.rangeTimer = -1;
	SetItemButtonTexture(itemButton, item);
	SetItemButtonCount(itemButton, charges);
	KT_QuestObjectiveItem_UpdateCooldown(itemButton);
end

function KT_QuestObjectiveItem_OnLoad(self)
	self:RegisterForClicks("AnyUp");
end

function KT_QuestObjectiveItem_OnEvent(self, event, ...)
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		self.rangeTimer = -1;
	elseif ( event == "BAG_UPDATE_COOLDOWN" ) then
		KT_QuestObjectiveItem_UpdateCooldown(self);
	end
end

function KT_QuestObjectiveItem_OnUpdate(self, elapsed)
	-- Handle range indicator
	local rangeTimer = self.rangeTimer;
	if ( rangeTimer ) then
		rangeTimer = rangeTimer - elapsed;
		if ( rangeTimer <= 0 ) then
			local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(self:GetID());
			if ( not charges or charges ~= self.charges ) then
				KT_ObjectiveTracker_Update(KT_OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST);
				return;
			end
			local count = self.HotKey;
			local valid = IsQuestLogSpecialItemInRange(self:GetID());
			if ( valid == 0 ) then
				count:Show();
				count:SetVertexColor(1.0, 0.1, 0.1);
			elseif ( valid == 1 ) then
				count:Show();
				count:SetVertexColor(0.6, 0.6, 0.6);
			else
				count:Hide();
			end
			rangeTimer = TOOLTIP_UPDATE_TIME;
		end

		self.rangeTimer = rangeTimer;
	end
end

function KT_QuestObjectiveItem_OnShow(self)
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("BAG_UPDATE_COOLDOWN");
end

function KT_QuestObjectiveItem_OnHide(self)
	self:UnregisterEvent("PLAYER_TARGET_CHANGED");
	self:UnregisterEvent("BAG_UPDATE_COOLDOWN");
end

function KT_QuestObjectiveItem_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetQuestLogSpecialItem(self:GetID());
end

function KT_QuestObjectiveItem_OnClick(self, button)
	if ( IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow() ) then
		local link, item, charges, showItemWhenComplete = GetQuestLogSpecialItemInfo(self:GetID());
		if ( link ) then
			ChatEdit_InsertLink(link);
		end
	else
		UseQuestLogSpecialItem(self:GetID());
	end
end

function KT_QuestObjectiveItem_UpdateCooldown(itemButton)
	local start, duration, enable = GetQuestLogSpecialItemCooldown(itemButton:GetID());
	if ( start ) then
		CooldownFrame_Set(itemButton.Cooldown, start, duration, enable);
		if ( duration > 0 and enable == 0 ) then
			SetItemButtonTextureVertexColor(itemButton, 0.4, 0.4, 0.4);
		else
			SetItemButtonTextureVertexColor(itemButton, 1, 1, 1);
		end
	end
end

local g_questFindGroupButtonPool = CreateFramePool("BUTTON", nil, "KT_QuestObjectiveFindGroupButtonTemplate", OnRelease);
function KT_QuestObjectiveFindGroup_AcquireButton(parent, questID)
	local button = g_questFindGroupButtonPool:Acquire();
	button:SetParent(parent);
	button.questID = questID;

	return button;
end

function KT_QuestObjectiveFindGroup_ReleaseButton(self)
	self.questID = nil;
	g_questFindGroupButtonPool:Release(self);
end

function KT_QuestObjectiveFindGroup_OnMouseDown(self)
	if self:IsEnabled() then
		self.Icon:SetPoint("CENTER", self, "CENTER", -2, -1);
	end
end

function KT_QuestObjectiveFindGroup_OnMouseUp(self)
	if self:IsEnabled() then
		self.Icon:SetPoint("CENTER", self, "CENTER", -1, 0);
	end
end

function KT_QuestObjectiveFindGroup_OnEnter(self)
	GameTooltip:SetOwner(self);
	GameTooltip:AddLine(TOOLTIP_TRACKER_FIND_GROUP_BUTTON, HIGHLIGHT_FONT_COLOR:GetRGB());

	GameTooltip:Show();
end

function KT_QuestObjectiveFindGroup_OnLeave(self)
	GameTooltip:Hide();
end

function KT_QuestObjectiveFindGroup_OnClick(self)
	local isFromGreenEyeButton = true;
	--We only want green eye button groups to display the create a group button if there are already groups there.
	LFGListUtil_FindQuestGroup(self.questID, isFromGreenEyeButton);
end

function KT_QuestObjectiveSetupBlockButton_AddRightButton(block, button, buttonOffsetsTag)
	if block.rightButton == button then
		-- TODO: Fix for real, some event causes the findGroup button to get added twice (could happen for any button)
		-- so it doesn't need to be reanchored another time
		return;
	end

	button:ClearAllPoints();

	if block.rightButton then
		button:SetPoint("RIGHT", block.rightButton, "LEFT", -KT_ObjectiveTracker_GetPaddingBetweenButtons(block), 0);
	else
		button:SetPoint("TOPRIGHT", block, KT_ObjectiveTracker_GetButtonOffsets(block, buttonOffsetsTag));
	end

	button:Show();

	block.rightButton = button;
	block.lineWidth = block.lineWidth - button:GetWidth() - KT_ObjectiveTracker_GetPaddingBetweenButtons(block);
end

function KT_QuestObjectiveSetupBlockButton_FindGroup(block, questID)
	-- Cache this off to avoid spurious calls to C_LFGList.CanCreateQuestGroup, for a given quest the result will not change until
	-- completed, and when completed this world quest should no longer be on the tracker.
	if block.hasGroupFinderButton == nil then
		block.hasGroupFinderButton = C_LFGList.CanCreateQuestGroup(questID);
	end

	if block.hasGroupFinderButton then
		local groupFinderButton = block.groupFinderButton;
		if not groupFinderButton then
			groupFinderButton = KT_QuestObjectiveFindGroup_AcquireButton(block, questID);
			block.groupFinderButton = groupFinderButton;
		end

		KT_QuestObjectiveSetupBlockButton_AddRightButton(block, groupFinderButton, "groupFinder");
	else
		KT_QuestObjectiveReleaseBlockButton_FindGroup(block);
	end

	return block.hasGroupFinderButton;
end

function KT_QuestObjectiveReleaseBlockButton_FindGroup(block)
	block.hasGroupFinderButton = nil;

	if block.groupFinderButton then
		KT_QuestObjectiveFindGroup_ReleaseButton(block.groupFinderButton);
		block.groupFinderButton = nil;
	end
end

function KT_QuestObjectiveSetupBlockButton_Item(block, questLogIndex, isQuestComplete)
	local item, showItemWhenComplete, _;
	if questLogIndex then
		_, item, _, showItemWhenComplete = GetQuestLogSpecialItemInfo(questLogIndex);
	end

	local shouldShowItem = item and (not isQuestComplete or showItemWhenComplete);

	if shouldShowItem then
		local itemButton = block.itemButton;
		if not itemButton then
			itemButton = KT_QuestObjectiveItem_AcquireButton(block);
			block.itemButton = itemButton;
		end

		KT_QuestObjectiveItem_Initialize(itemButton, questLogIndex);
		KT_QuestObjectiveSetupBlockButton_AddRightButton(block, itemButton, "useItem");
	else
		KT_QuestObjectiveReleaseBlockButton_Item(block);
	end

	return shouldShowItem;
end

function KT_QuestObjectiveReleaseBlockButton_Item(block)
	if block.itemButton then
		KT_QuestObjectiveItem_ReleaseButton(block.itemButton);
		block.itemButton = nil;
	end
end

function KT_QuestObjective_SetupHeader(block, initialLineWidth)
	block.rightButton = nil;
	block.lineWidth = initialLineWidth or KT_OBJECTIVE_TRACKER_TEXT_WIDTH;
end
