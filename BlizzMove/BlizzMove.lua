-- BlizzMmove, move the blizzard frames by yess
local db = nil
local frame = CreateFrame("Frame")
local optionPanel = nil

local defaultDB = {
    version = "20180816",
    AchievementFrame = {save = true},
    CalendarFrame = {save = true},
    AuctionFrame = {save = true},
    GuildBankFrame = {save = true},
    CastingBarFrame = {save = true},
    WardrobeFrame = {save = true},
    --QuestFrame = {save = true},
    EclipseBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MonkHarmonyBarFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    WarlockPowerFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    PriestBarFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    PaladinPowerBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    RuneFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    TotemFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    --InsanityBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    ComboPointPlayerFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MageArcaneChargesFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MinimapCluster = {save = true, modifyKey = "IsShiftKeyDown", },
    Boss1TargetFrame = {save = false, modifyKey = "IsShiftKeyDown", },
    MirrorTimer1 = {save = true, modifyKey = "IsShiftKeyDown", },
    PVEFrame = {save = true, },
    CollectionsJournal = {save = true, },
    GuildFrame = {save = true, },
    FriendsFrame = {save = true, },
    ObjectiveTrackerFrame = { save = true, },
    WorldMapFrame = {save = true, },
    ScrappingMachineFrame = { save = true, },
    AzeriteEmpoweredItemUI = { save = true, },
}

local userPlaced = {
}
local unitFrameAddOns = {
    "XPerl",
    "oUF",
}
local function hasUnitFrameAddOns()
    for _, addon in ipairs(unitFrameAddOns) do
        if IsAddOnLoaded(addon) or GetAddOnEnableState(UnitName("player"),addon)>=2 then
            return true
        end
    end
end

local function Print(...)
    local s = "BlizzMove:"
    for i=1,select("#", ...) do
        local x = select(i, ...)
        s = strjoin(" ",s,tostring(x))
    end
    DEFAULT_CHAT_FRAME:AddMessage(s)
end

local function NeedPlayerFrame_AdjustAttachments(frame)
    if frame == TotemFrame then
        PlayerFrame_AdjustAttachments()
    end
end

local function saveDefaultPos(frame)
    local settings = frame.settings
    settings.default = settings.default or {}
    local def = settings.default
    table.wipe(def)
    for i=1, frame:GetNumPoints() do
        def[i] = {frame:GetPoint(i)}
        if def[i][2] then
            def[i][2] = def[i][2]:GetName()
        end
    end
end

local function OnShow(self, ...)
    local settings = self.settings
    if settings then
        if not settings.default then -- set defaults
            saveDefaultPos(self);
        end
        if not settings.defaultScale then
            settings.defaultScale = self:GetScale()
        end
        if(InCombatLockdown() and self:IsProtected())then return end
        if settings.point and settings.save then
            if settings.scale then self:SetScale(settings.scale) end
            if not settings.relativeTo or (type(settings.relativeTo)=="string" and _G[settings.relativeTo]) then
                local w, h = self:GetSize();
                self:ClearAllPoints()
                self.__blizzMove = 1
                self:SetPoint(settings.point,settings.relativeTo, settings.relativePoint, settings.xOfs,settings.yOfs)
                if self:GetHeight()~=h then self:SetHeight(h) end
                if self:GetWidth()~=w then self:SetWidth(w) end
                self.__blizzMove = nil
            end
        end
    end
end

local function OnHide(self)
    if self:IsToplevel() and not (self:IsProtected() and InCombatLockdown()) then
        self:SetFrameLevel(1)
    end
end

local running = {} --已经记录的
local function runOnNext(self)
    if not self.__blizzMove then
        self.__blizzMove = 1
        saveDefaultPos(self)
        if self:IsProtected() and InCombatLockdown() then
            --CoreLeaveCombatCall(self, nil, OnShow)
        else
            OnShow(self);
        end
        running[self] = nil
        self.__blizzMove = nil
    end
end
local function hookSetPoint(self, point, parent, relative, offsetx, offsety)
    if not self.__blizzMove then
        if not running[self] then
            running[self] = 1
            RunOnNextFrame(runOnNext, self)
        end
    end
end

local function OnDragStart(self)
    local frameToMove = self.frameToMove
    local settings = frameToMove.settings
    if settings and not settings.default then -- set defaults
        saveDefaultPos(frameToMove);
    end
    if not settings.modifyKey or _G[settings.modifyKey]() then
        frameToMove:StartMoving()
        frameToMove.isMoving = true
    end
    NeedPlayerFrame_AdjustAttachments(frameToMove);
end

local function OnDragStop(self)
    local frameToMove = self.frameToMove
    local settings = frameToMove.settings
    frameToMove:StopMovingOrSizing()
    frameToMove.isMoving = false
    if settings then
        settings.point, settings.relativeTo, settings.relativePoint, settings.xOfs, settings.yOfs = frameToMove:GetPoint()
    end
    if not userPlaced[frameToMove] then
        frameToMove:SetUserPlaced(false) --如果不设置，默认就是true，UIParent就会跳过设置其位置，也就无法获取新的位置。但是跟踪窗体的问题？
    end
    if frameToMove:IsToplevel() and not (frameToMove:IsProtected() and InCombatLockdown()) then
        frameToMove:SetFrameLevel(1)
        frameToMove:Raise()
    end
    NeedPlayerFrame_AdjustAttachments(frameToMove);
end

local function OnMouseWheel(self, value, ...)
    if self.noNeedControlKey or IsControlKeyDown() then
        local frameToMove = self.frameToMove
        local scale = frameToMove:GetScale() or 1
        if frameToMove.settings and not frameToMove.settings.defaultScale then
            frameToMove.settings.defaultScale = scale
        end
        if(value == 1) then --scale up
            scale = scale +.05
            if(scale > 2) then
                scale = 2
            end
        else -- scale down
            scale = scale - .05
            if(scale < .5) then
                scale = .5
            end
        end
        frameToMove.__blizzMove = 1
        CoreUISetScale(frameToMove, scale)
        --frameToMove:SetScale(scale)
        frameToMove.__blizzMove = nil
        if frameToMove.settings then
            frameToMove.settings.scale = scale
        end
        if frameToMove:IsMovable() then
            frameToMove:StartMoving();
            OnDragStop(self); --因为位置有调整，所以要执行一下，但实际上不需要，因为CoreUISetScale修改了当前的Point，再移动后的相对位置由暴雪计算完成。
        end
        --Debug("scroll", arg1, scale, frameToMove:GetScale())
    end
end

local function resetFrame(f)
    f.__blizzMove = 1
    if f and f.settings then
        local defScale = f.settings.defaultScale
        if(defScale) then
            f:SetScale(defScale)
        end
        local def = f.settings.default
        if def then
            f:ClearAllPoints()
            for _, v in ipairs(def) do
                f:SetPoint(v[1],v[2],v[3],v[4],v[5]);
            end
        end
        --warbaby 重置默认值，在resetDB时也有用。
        table.wipe(f.settings)
        f.settings.defaultScale= defScale;
        f.settings.default= def;
        if f:GetName() and defaultDB[f:GetName()] then
            for k, v in pairs(defaultDB[f:GetName()]) do f.settings[k] = v end
        end
    end
    NeedPlayerFrame_AdjustAttachments(f);
    f.__blizzMove = nil
end

local function OnMouseUp(self, ...)
    OnDragStop(self)
    local frameToMove = self.frameToMove
    if IsControlKeyDown() then
        if IsAltKeyDown() and IsShiftKeyDown() then
            resetFrame(frameToMove)
            return
        end

        local settings = frameToMove.settings
        --toggle save
        if settings then
            settings.save = not settings.save
            if settings.save then
                U1Message("|cff00d100保存此框体的位置|r") --: ",frameToMove:GetName(),"。")
            else
                U1Message("|cffd10000不保存此框体的位置（下次进游戏会恢复原位）|r") --: ",frameToMove:GetName(),"。")
            end
        else
            Print("保存框体的位置:: ",frameToMove:GetName(),"。")
            db[frameToMove:GetName()] = {}
            settings = db[frameToMove:GetName()]
            settings.save = true
            settings.point, settings.relativeTo, settings.relativePoint, settings.xOfs, settings.yOfs = frameToMove:GetPoint()
            if settings.relativeTo then
                settings.relativeTo = settings.relativeTo:GetName()
            end
            frameToMove.settings = settings
        end
    end
end

local loadWithTable = {}
--提供了callback则frameNameToMove就没用了
function BM_SetMoveHandlerWith(frameNameToMove, loadWith, callback)
    if IsAddOnLoaded(loadWith) then
        if callback then callback() else BM_SetMoveHandler(_G[frameNameToMove]) end
    else
        loadWithTable[loadWith] = callback or frameNameToMove
    end
end
function BM_SetMoveHandler(frameToMove, handler)
    if not frameToMove then
        return
    end
    if not handler then
        handler = frameToMove
    end

    local settings = db[frameToMove:GetName()]
    if not settings then
        settings = defaultDB[frameToMove:GetName()] or {}
        db[frameToMove:GetName()] = settings
    end
    --if not settings.save then
    --    settings.default = nil settings.defaultScale = nil --始终重置默认值，取游戏初始值，因为多个handler的问题，统一在ADDON_LOADED里清理
    --end
    frameToMove.settings = settings
    handler.frameToMove = frameToMove

    if not handler.EnableMouse then return end

    handler:EnableMouse(true)
    frameToMove:SetMovable(true)
    handler:RegisterForDrag("LeftButton");

    CoreHookScript(handler, "OnMouseDown", OnDragStart)
    CoreHookScript(handler, "OnDragStop", OnDragStop)

    --override frame position according to settings when shown
    frameToMove:HookScript("OnShow", OnShow)
    if frameToMove:IsShown() then OnShow(frameToMove) end
    if frameToMove:IsToplevel() then
        CoreHookScript(frameToMove, "OnHide", OnHide, true)
    end

    --hook OnMouseUp
    handler:HookScript("OnMouseUp", OnMouseUp)

    --hook Scroll for setting scale
    handler:EnableMouseWheel(true)
    handler:HookScript("OnMouseWheel",OnMouseWheel)

    if not frameToMove.__blizzMoveHooked then
        hooksecurefunc(frameToMove, "SetPoint", hookSetPoint);
        frameToMove.__blizzMoveHooked = 1
    end
    if QuestLogFrame~=frameToMove then
        --local w, h = handler:GetSize()
        --handler:SetClampedToScreen(true)
        --if w and h then handler:SetClampRectInsets(w-5, -w+5, 0, 0) end
    end --Carbonite同时显示，小地图美化也要挪动一些出屏幕等
end

local function resetDB()
    for k, v in pairs(db) do
        if type(v) == "table" then
            local f = _G[k]
            if f then resetFrame(f) end
        end
    end
end

local function OnEvent(self, event, arg1, arg2)
    --Debug(event, arg1, arg2)
    if event == "PLAYER_ENTERING_WORLD" then
        local hasConflict = hasUnitFrameAddOns();

        frame:RegisterEvent("ADDON_LOADED") --for blizz lod addons
        db = BlizzMoveDB and BlizzMoveDB.version == defaultDB.version and BlizzMoveDB or defaultDB
        BlizzMoveDB = db
        for k, v in pairs(db) do
            if type(v)=="table" then
                v.default = nil v.defaultScale = nil --始终重置默认值，取游戏初始值，因为多个handler的问题，统一在ADDON_LOADED里清理
            end
        end
        BM_SetMoveHandler(CharacterFrame,PaperDollFrame)
        BM_SetMoveHandler(CharacterFrame,TokenFrame)
        BM_SetMoveHandler(CharacterFrame,ReputationFrame)
        if(PetPaperDollFrameCompanionFrame) then BM_SetMoveHandler(CharacterFrame,PetPaperDollFrameCompanionFrame) end
        BM_SetMoveHandler(SpellBookFrame)
        BM_SetMoveHandler(QuestLogFrame)
        BM_SetMoveHandler(FriendsFrame)
        --BM_SetMoveHandler(WatchFrame,WatchFrameCollapseExpandButton)
        --userPlaced[WatchFrame] = true --加了也不好，UIParent里写的有问题
        BM_SetMoveHandler(ObjectiveTrackerFrame,ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)
        WW(ObjectiveTrackerFrame.HeaderMenu):Button("OTFMover"):Size(40,22):RIGHT(ObjectiveTrackerFrame.HeaderMenu.MinimizeButton, "LEFT", 0,0):up():un()
        CoreUIEnableTooltip(OTFMover, "面板移动","Ctrl点击保存位置\nCtrl滚轮缩放\nC+S+A点击重置")
        BM_SetMoveHandler(ObjectiveTrackerFrame,OTFMover)
        BM_SetMoveHandler(GameMenuFrame)
        BM_SetMoveHandler(GossipFrame)
        BM_SetMoveHandler(DressUpFrame)
        BM_SetMoveHandler(QuestFrame)
        BM_SetMoveHandler(MerchantFrame)
        BM_SetMoveHandler(HelpFrame)
        BM_SetMoveHandler(PlayerTalentFrame)
        BM_SetMoveHandler(ClassTrainerFrame)
        BM_SetMoveHandler(MailFrame)
        BM_SetMoveHandler(BankFrame)
        BM_SetMoveHandler(VideoOptionsFrame)
        BM_SetMoveHandler(InterfaceOptionsFrame)
        BM_SetMoveHandler(LootFrame)
        BM_SetMoveHandler(PVPFrame)
        BM_SetMoveHandler(LFDParentFrame)
        BM_SetMoveHandler(QuestLogPopupDetailFrame);
        BM_SetMoveHandler(MirrorTimer1)
        BM_SetMoveHandler(PVEFrame)

        --SetCVar("lockedWorldMap", "0") --WorldMap
        WW(WorldMapFrame):Button("WMAPMover"):Size(150,22):TOP(WorldMapFrame, 0,0):up():un()
        BM_SetMoveHandler(WorldMapFrame, WMAPMover) --enable scale --abandoned because quest poi --TODO aby8
        WorldMapFrame:SetClampedToScreen(true)

        BM_SetMoveHandler(TradeFrame)

        if not hasConflict and U1GetCfgValue and U1GetCfgValue("BlizzMove", "powerbar") then
            BM_SetMoveHandler(EclipseBarFrame)
            BM_SetMoveHandler(PaladinPowerBarFrame)
            for i=1,3 do BM_SetMoveHandler(PaladinPowerBarFrame, PaladinPowerBarFrame["rune"..i]) end
            PaladinPowerBarFrame:SetFrameStrata("LOW")
            BM_SetMoveHandler(RuneFrame)
            for i=1,6 do BM_SetMoveHandler(RuneFrame, RuneFrame["Rune"..i]) end
            BM_SetMoveHandler(TotemFrame)
            for i=1,4 do BM_SetMoveHandler(TotemFrame, _G["TotemFrameTotem"..i]) end
            --7.0.3
            --BM_SetMoveHandler(InsanityBarFrame)
            BM_SetMoveHandler(WarlockPowerFrame)
            BM_SetMoveHandler(MageArcaneChargesFrame)
            BM_SetMoveHandler(MonkHarmonyBarFrame)
            for i=1,1 do BM_SetMoveHandler(MonkHarmonyBarFrame, MonkHarmonyBarFrame.LightEnergy[i]) end
            BM_SetMoveHandler(ComboPointPlayerFrame)
        end

        if U1GetCfgValue and U1GetCfgValue("BlizzMove", "movecastbar") then
            BM_SetMoveHandler(CastingBarFrame)
        end

        BM_SetMoveHandlerWith("InspectFrame", "Blizzard_InspectUI");
        BM_SetMoveHandlerWith("GuildBankFrame", "Blizzard_GuildBankUI");
        BM_SetMoveHandlerWith("TradeSkillFrame", "Blizzard_TradeSkillUI");
        BM_SetMoveHandlerWith("ItemSocketingFrame", "Blizzard_ItemSocketingUI");
        BM_SetMoveHandlerWith("BarberShopFrame", "Blizzard_BarbershopUI");
        BM_SetMoveHandlerWith("MacroFrame", "Blizzard_MacroUI");
        BM_SetMoveHandlerWith("PlayerTalentFrame", "Blizzard_TalentUI");
        BM_SetMoveHandlerWith("CalendarFrame", "Blizzard_Calendar");
        BM_SetMoveHandlerWith("ClassTrainerFrame", "Blizzard_TrainerUI");
        BM_SetMoveHandlerWith("KeyBindingFrame", "Blizzard_BindingUI");
        BM_SetMoveHandlerWith("AuctionFrame", "Blizzard_AuctionUI");
        BM_SetMoveHandlerWith("LookingForGuildFrame", "Blizzard_LookingForGuildUI");
        BM_SetMoveHandlerWith("ArchaeologyFrame", "Blizzard_ArchaeologyUI");
        BM_SetMoveHandlerWith("ArtifactRelicForgeFrame", "Blizzard_ArtifactUI");
        BM_SetMoveHandlerWith("ScrappingMachineFrame", "Blizzard_ScrappingMachineUI");
        BM_SetMoveHandlerWith("AzeriteEmpoweredItemUI", "Blizzard_AzeriteUI");

        if not hasConflict then 
            BM_SetMoveHandler(PlayerPowerBarAlt) 
            if IsAddOnLoaded("Dominos_Encounter") then
                PlayerPowerBarAlt:SetScript("OnDragStart", function() U1Message("由于多米诺动作条已启用，不能拖动，请点击|TInterface\\Addons\\Dominos\\Dominos:0|t按钮进行布局") end)
                PlayerPowerBarAlt:SetScript("OnDragStop", nil)
            end
        end
        --if not hasConflict then BM_SetMoveHandler(Boss1TargetFrame) Boss1TargetFrame:SetClampedToScreen(true) end --
        if not hasConflict then BM_SetMoveHandler(MinimapCluster, MinimapZoneTextButton) end

        BM_SetMoveHandler(ChatConfigFrame);

        --4.3
        BM_SetMoveHandler(RaidParentFrame)

        --UIParent ManageFrame 的时候，不会清Point，只会设，很可能出问题
        --if not U1IsAddonInstalled("Dominos") then
            --BM_SetMoveHandler(ExtraActionBarFrame, ExtraActionButton1) --有多米诺会冲突
        --end
        
        --BM_SetMoveHandler(LFRParentFrame)
        BM_SetMoveHandlerWith("VoidStorageFrame", "Blizzard_VoidStorageUI")

        BM_SetMoveHandlerWith(nil, "Blizzard_AchievementUI", function()
            BM_SetMoveHandler(AchievementFrame, AchievementFrameHeader)
            AchievementFrameSummaryAchievements:HookScript("OnShow", function()
                for i=1, 4 do
                    local f = _G["AchievementFrameSummaryAchievement"..i]
                    if f then f:SetFrameLevel(f:GetParent():GetFrameLevel()+1) end
                end
            end)
        end)

        --当年层次bug之后会导致副本手册无法点击
        --BM_SetMoveHandlerWith("EncounterJournal", "Blizzard_EncounterJournal")
        BM_SetMoveHandlerWith(nil, "Blizzard_EncounterJournal", function()
            CoreUICreateMover(EncounterJournal, 26, 0, 0, 0)
            EncounterJournal:EnableMouse(false)
        end)

        BM_SetMoveHandlerWith("TransmogrifyFrame", "Blizzard_ItemAlterationUI")
        BM_SetMoveHandlerWith(nil, "Blizzard_ReforgingUI", function() BM_SetMoveHandler(ReforgingFrame) ReforgingFrame.InvisibleButton:SetPoint("TOPLEFT", 0, -30) end);

        --6.0
        BM_SetMoveHandlerWith(nil, "Blizzard_GarrisonUI", function()
            BM_SetMoveHandler(GarrisonLandingPage)
            BM_SetMoveHandler(GarrisonMissionFrame)
            BM_SetMoveHandler(GarrisonBuildingFrame)
            BM_SetMoveHandler(GarrisonCapacitiveDisplayFrame)
        end)

        BM_SetMoveHandlerWith(nil, "Blizzard_Collections", function()
            BM_SetMoveHandler(WardrobeFrame)
            BM_SetMoveHandler(CollectionsJournal)
        end)

        BM_SetMoveHandlerWith(nil, "Blizzard_GuildUI", function()
            BM_SetMoveHandler(GuildFrame)
            BM_SetMoveHandler(GuildFrame, GuildFrame.TitleMouseover);
        end);


        frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
        
    elseif event=="ADDON_LOADED" then
        local frame = loadWithTable[arg1]
        if frame then
            if type(frame)=="string" then
                BM_SetMoveHandler(_G[frame])
            else
                frame()
            end
            loadWithTable[arg1] = nil
        end
    end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")


----------------------------------------------------------
-- User function to move/lock a frame with a handler
-- handler, the frame the user has clicked on
-- frameToMove, the handler itself, a parent frame of handler 
--              that has UIParent as Parent or nil  
----------------------------------------------------------
BlizzMove = {}
function BlizzMove:Toggle(handler)
    if not handler then
        handler = GetMouseFocus()
    end

    if handler:GetName() == "WorldFrame" then
        return
    end

    local lastParent = handler
    local frameToMove = handler
    local i=0
    --get the parent attached to UIParent from handler
    while lastParent and lastParent ~= UIParent and i < 100 do
        frameToMove = lastParent --set to last parent
        lastParent = lastParent:GetParent()
        i = i +1
    end
    if handler and frameToMove then
        if handler:GetScript("OnDragStart") then
            handler:SetScript("OnDragStart", nil)
            Print("Frame: ",frameToMove:GetName()," locked.")
        else
            Print("Frame: ",frameToMove:GetName()," to move with handler ",handler:GetName())
            BM_SetMoveHandler(frameToMove, handler)
        end

    else
        Print("Error parent not found.")
    end

end

BINDING_HEADER_BLIZZMOVE = "BlizzMove";
BINDING_NAME_MOVEFRAME = "Move/Lock a Frame";

function BlizzMove_ResetDB()
    resetDB()
end

hooksecurefunc("PlayerFrame_AdjustAttachments", function()
    if ( not PLAYER_FRAME_CASTBARS_SHOWN ) then
        return;
    end
    if ( PetFrame and PetFrame:IsShown() ) then
    elseif TotemFrame and TotemFrame:IsShown() then
        if select(2,TotemFrame:GetPoint())~=PlayerFrame then
            CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM", 0, 10);
        end
    end
end)

hooksecurefunc(TotemFrame, "StopMovingOrSizing", function()
    PlayerFrame_AdjustAttachments()
end)

function SetScaleHandler(handler, frame)
    handler.frameToMove = frame
    handler.noNeedControlKey = 1
    handler:EnableMouseWheel(true)
    handler:SetScript("OnMouseWheel",OnMouseWheel)
end

--[[
--世界地图不能因为有Blob显示的问题
SetScaleHandler(WorldMapTitleButton,WorldMapFrame)
hooksecurefunc(WorldMapFrame, "SetScale", function()
    WorldMapBlobFrame_CalculateHitTranslations();
    if ( WORLDMAP_SETTINGS.selectedQuest and not WORLDMAP_SETTINGS.selectedQuest.completed ) then
        WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, true);
    end
end)
]]
CoreDependCall("Blizzard_BattlefieldMinimap", function() SetScaleHandler(BattlefieldMinimapTab,BattlefieldMinimap) end)
