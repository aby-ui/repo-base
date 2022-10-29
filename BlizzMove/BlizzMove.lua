--[[
local abytfm = WW:Button("AbyTotemFrameMover", UIParent):Size(100,40):SetFrameStrata("BACKGROUND"):SetPoint(TotemFrame:GetPoint(1))
:CreateTexture():SetColorTexture(0,1,0,0.5):ALL():up():un()
CoreUIEnableTooltip(abytfm, "面板移动","按住SHIFT拖动\nCtrl点击保存位置\nCtrl滚轮缩放\nC+S+A点击重置")
]]
-- BlizzMmove, move the blizzard frames by yess
local db
local frame = CreateFrame("Frame")

local defaultDB = {
    version = "20221029",

    EclipseBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MonkHarmonyBarFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    WarlockPowerFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    PriestBarFrame  = {save = true, modifyKey = "IsShiftKeyDown", },
    PaladinPowerBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    RuneFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    TotemFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    ComboPointPlayerFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MageArcaneChargesFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    --InsanityBarFrame = {save = true, modifyKey = "IsShiftKeyDown", },
    MirrorTimer1 = {save = true, modifyKey = "IsShiftKeyDown", },
    PlayerPowerBarAlt = { save = true, },

    QuestFrame = {save = true},
    GossipFrame = {save = true},
    PVEFrame = {save = true, },
    CharacterFrame = {save = true, },
    FriendsFrame = {save = true, },
    AuctionHouseFrame = {save = true},

    --ScrappingMachineFrame = { save = true, },
    --AzeriteEmpoweredItemUI = { save = true, },
    --AchievementFrame = {save = true},
    --WorldMapFrame = {save = true, },
    --CommunitiesFrame = {save = true},
    --CollectionsJournal = {save = true, },
    --AuctionFrame = {save = true},
    --GuildBankFrame = {save = true},
    --CalendarFrame = {save = true},
    --GuildFrame = {save = true, },
    --WardrobeFrame = {save = true},
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
    local settings = frame._settings_
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
    local settings = self._settings_
    if settings then
        if not settings.default then -- set defaults
            saveDefaultPos(self);
        end
        if not settings.defaultScale then
            settings.defaultScale = self:GetScale()
        end
        if(InCombatLockdown() and self:IsProtected())then return end
        if settings.point and settings.save then --OnShow还会被hookPoint调用, 尽量减少hook修改, 所以只处理save=true的(实际save=false的可以不记录settings)
            if settings.scale then self:SetScale(settings.scale) end
            if not settings.relativeTo or (type(settings.relativeTo)=="string" and _G[settings.relativeTo]) then
                local w, h = self:GetSize();
                self:ClearAllPoints()
                self.__blizzMove = 1
                self:SetPoint(settings.point,settings.relativeTo, settings.relativePoint, settings.xOfs,settings.yOfs)
                if self:GetHeight()~=h then self:SetHeight(h) end
                if self:GetWidth()~=w then self:SetWidth(w) end
                if self:GetRight() <= 0 or self:GetLeft() >= GetScreenWidth() or self:GetTop() <= 0 or self:GetBottom() >= GetScreenHeight() then
                    self:ClearAllPoints()
                    self:SetPoint("CENTER")
                    settings.point, settings.relativeTo, settings.relativePoint, settings.xOfs, settings.yOfs = nil, nil, nil, nil, nil
                end
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
local function runOnNext(self, ...)
    if not self.__blizzMove then
        self.__blizzMove = 1
        --saveDefaultPos(self) --要在hooks SetPoint的时候设置
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
        saveDefaultPos(self) --其他插件设置位置，更新默认位置
        if not running[self] then
            running[self] = 1
            RunOnNextFrame(runOnNext, self)
        end
    end
end

local function OnDragStart(self, button)
    if button == "RightButton" then return end
    local frameToMove = self.frameToMove
    local settings = frameToMove._settings_
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
    frameToMove:StopMovingOrSizing()
    frameToMove.isMoving = false

    local settings = frameToMove._settings_
    settings.point, settings.relativeTo, settings.relativePoint, settings.xOfs, settings.yOfs = frameToMove:GetPoint(1)
    if settings.relativeTo then
        if settings.relativeTo:GetName() == nil then
            settings.point, settings.relativeTo, settings.relativePoint, settings.xOfs, settings.yOfs =
              "TOPLEFT", "UIParent", "BOTTOMLEFT", self:GetLeft(), self:GetTop()
        else
            settings.relativeTo = settings.relativeTo:GetName()
        end
    end

    if not userPlaced[frameToMove] then
        frameToMove:SetUserPlaced(false) --如果不设置，默认就是true，UIParent就会跳过设置其位置，也就无法获取新的位置。但是跟踪窗体的问题？
    end
    --[[ --10.0注释掉试试
    if frameToMove:IsToplevel() and not (frameToMove:IsProtected() and InCombatLockdown()) then
        frameToMove:SetFrameLevel(1)
        frameToMove:Raise()
    end
    --]]
    NeedPlayerFrame_AdjustAttachments(frameToMove);
end

local function OnMouseWheel(self, value, ...)
    if self.noNeedControlKey or IsControlKeyDown() then
        local frameToMove = self.frameToMove
        local scale = frameToMove:GetScale() or 1
        if frameToMove._settings_ and not frameToMove._settings_.defaultScale then
            frameToMove._settings_.defaultScale = scale
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
        CoreUISetScale(frameToMove, scale) --frameToMove:SetScale(scale)
        if frameToMove._settings_ then
            frameToMove._settings_.scale = scale
        end
        if frameToMove:IsMovable() then
            --frameToMove:StartMoving(); --这句会导致飘. 如果没有这句reload后的位置不对, 修改CoreUISetScale支持anchor=nil后, 去掉这句没问题
            OnDragStop(self); --因为位置有调整，所以要执行一下，但实际上不需要，因为CoreUISetScale修改了当前的Point，再移动后的相对位置由暴雪计算完成。
        end
        frameToMove.__blizzMove = nil
        --Debug("scroll", arg1, scale, frameToMove:GetScale())
    end
end

local function resetFrame(f)
    f.__blizzMove = 1
    if f and f._settings_ then
        local defScale = f._settings_.defaultScale
        if(defScale) then
            f:SetScale(defScale)
        end
        local def = f._settings_.default
        if def then
            f:ClearAllPoints()
            for _, v in ipairs(def) do
                f:SetPoint(v[1],v[2],v[3],v[4],v[5]);
            end
        end
        --warbaby 重置默认值，在resetDB时也有用。
        table.wipe(f._settings_)
        f._settings_.defaultScale= defScale;
        f._settings_.default= def;
        if f:GetName() and defaultDB[f:GetName()] then
            for k, v in pairs(defaultDB[f:GetName()]) do f._settings_[k] = v end
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

        local settings = frameToMove._settings_
        --toggle save
        local fname = frameToMove:GetName()
        settings.save = not settings.save
        if settings.save then
            if fname then
                U1Message("|cff00d100保存此框体的位置|r") --: ",frameToMove:GetName(),"。")
                db[fname] = settings
            else
                U1Message("|cffd10000此框体没有名字, 无法保存位置|r")
            end
        else
            if fname then db[fname] = nil end
            U1Message("|cffd10000不保存此框体的位置（下次进游戏会恢复原位）|r") --: ",frameToMove:GetName(),"。")
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
function BM_SetMoveHandler(frameToMove, handler, multiHandler)
    if not frameToMove or (not multiHandler and frameToMove._settings_) then
        return
    end
    if not handler then
        handler = frameToMove
    end

    if not frameToMove._settings_ then
        local settings = db[frameToMove:GetName()]
        if not settings then
            settings = defaultDB[frameToMove:GetName()] or {}
            if settings.save then
                db[frameToMove:GetName()] = settings
            else
                db[frameToMove:GetName()] = nil --no need to save, just clean it
            end
        end
        --if not settings.save then
        --    settings.default = nil settings.defaultScale = nil --始终重置默认值，取游戏初始值，因为多个handler的问题，统一在ADDON_LOADED里清理
        --end
        frameToMove._settings_ = settings
    end
    handler.frameToMove = frameToMove

    if not handler.EnableMouse then return end

    handler:EnableMouse(true)
    frameToMove:SetMovable(true)
    handler:RegisterForDrag("LeftButton");

    handler:HookScript("OnMouseDown", OnDragStart)
    handler:HookScript("OnMouseUp", OnMouseUp)
    --handler:HookScript("OnDragStop", OnDragStop) --OnMouseUp已经替代了

    --override frame position according to settings when shown
    frameToMove:HookScript("OnShow", OnShow)
    if frameToMove:IsShown() then OnShow(frameToMove) end
    if frameToMove:IsToplevel() then
        CoreHookScript(frameToMove, "OnHide", OnHide, true)
    end

    --hook OnMouseUp

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
function BM_CreateMover(frame, height, offsetLeft, offsetRight, offsetTop)
    frame:SetMovable(true)
    local mover = WW(frame):Frame():Key("_blizMover"):Size(0,height)
    mover:TL(offsetLeft,offsetTop):TR(offsetRight,offsetTop)
    mover:EnableMouse():AddFrameLevel(1, frame)
    --mover:SetClampedToScreen(true) --没效果
    return mover:un()
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
        BM_SetMoveHandler(CharacterFrame,PaperDollFrame, true)
        BM_SetMoveHandler(CharacterFrame,TokenFrame, true)
        BM_SetMoveHandler(CharacterFrame,ReputationFrame, true)
        if(PetPaperDollFrameCompanionFrame) then BM_SetMoveHandler(CharacterFrame,PetPaperDollFrameCompanionFrame, true) end
        BM_SetMoveHandler(SpellBookFrame)
        BM_SetMoveHandler(FriendsFrame)
        BM_SetMoveHandler(GameMenuFrame)
        BM_SetMoveHandler(GossipFrame)
        BM_SetMoveHandler(QuestFrame)
        BM_SetMoveHandler(DressUpFrame)
        BM_SetMoveHandler(MerchantFrame)
        BM_SetMoveHandler(HelpFrame)
        --BM_SetMoveHandler(StoreFrame) --StoreFrame无法操作, badSelf
        BM_SetMoveHandlerWith("ClassTrainerFrame", "Blizzard_TrainerUI")
        BM_SetMoveHandler(MailFrame)
        BM_SetMoveHandler(BankFrame)
        BM_SetMoveHandler(TradeFrame)
        BM_SetMoveHandler(QuestLogPopupDetailFrame);
        BM_SetMoveHandler(MirrorTimer1)
        BM_SetMoveHandler(PVEFrame)
        --BM_SetMoveHandler(PVPFrame) --没有PVP
        --BM_SetMoveHandler(LFDParentFrame) --移动PVEFrame就够了
        --BM_SetMoveHandler(LootFrame) --10.0

        --和Mapster冲突切无法解决
        --SetCVar("lockedWorldMap", "0") --WorldMap
        if not IsAddOnLoaded("Mapster") then
            WW(WorldMapFrame):Button("WMAPMover"):Size(150,22):TOP(WorldMapFrame, 0,0):up():un()
            BM_SetMoveHandler(WorldMapFrame, WMAPMover) --enable scale --abandoned because quest poi
            CoreDependCall("Mapster", function()
                U1Message("Mapster-地图增强与面板移动冲突，请重载界面")
            end)
        end
        WorldMapFrame:SetClampedToScreen(true)


        if not hasConflict and U1GetCfgValue and U1GetCfgValue("BlizzMove", "powerbar") then
            BM_SetMoveHandler(EclipseBarFrame)

            BM_SetMoveHandler(PaladinPowerBarFrame)
            PaladinPowerBarFrame:SetFrameStrata("LOW")
            --for i=1,3 do BM_SetMoveHandler(PaladinPowerBarFrame, PaladinPowerBarFrame["rune"..i], true) end

            --BM_SetMoveHandler(RuneFrame)
            for i=1,6 do BM_SetMoveHandler(RuneFrame, RuneFrame["Rune"..i], true) end

            --[[ --诡异的问题, 拖动之后，hooksecurefunc("TotemFrame_Update")无输出,但实际是运行到了的,怀疑是安全环境导致的,不能拖动TotemFrame本身,只能用锚点定位
            BM_SetMoveHandler(TotemFrame)
            for i=1,4 do BM_SetMoveHandler(TotemFrame, _G["TotemFrameTotem"..i], true) end
            --]]

            if AbyTotemFrameMover then
                BM_SetMoveHandler(AbyTotemFrameMover)
                hooksecurefunc(TotemFrame, "SetPoint", function()
                    if TotemFrame.__settingByAby then return end
                    AbyTotemFrameMover:SetSize(TotemFrame:GetSize())
                    TotemFrame.__settingByAby = true
                    TotemFrame:ClearAllPoints()
                    TotemFrame:SetPoint("TOPLEFT", AbyTotemFrameMover)
                    TotemFrame.__settingByAby = nil
                    TotemFrame:SetScale(AbyTotemFrameMover:GetScale())
                end)
            end

            --7.0.3
            --BM_SetMoveHandler(InsanityBarFrame)

            BM_SetMoveHandler(WarlockPowerFrame)
            BM_SetMoveHandler(MageArcaneChargesFrame)

            for i=1,5 do
                local tables = MonkHarmonyBarFrame.classResourceButtonTable or MonkHarmonyBarFrame.LightEnergy
                BM_SetMoveHandler(MonkHarmonyBarFrame, tables[i], true)
            end

            BM_SetMoveHandler(ComboPointPlayerFrame)
        end

        BM_SetMoveHandlerWith("InspectFrame", "Blizzard_InspectUI");
        BM_SetMoveHandlerWith("GuildBankFrame", "Blizzard_GuildBankUI");
        BM_SetMoveHandlerWith("TradeSkillFrame", "Blizzard_TradeSkillUI");
        BM_SetMoveHandlerWith("ItemSocketingFrame", "Blizzard_ItemSocketingUI");
        --BM_SetMoveHandlerWith("BarberShopFrame", "Blizzard_BarbershopUI");
        BM_SetMoveHandlerWith("MacroFrame", "Blizzard_MacroUI");
        BM_SetMoveHandlerWith("PlayerTalentFrame", "Blizzard_TalentUI");
        BM_SetMoveHandlerWith("CalendarFrame", "Blizzard_Calendar");
        BM_SetMoveHandlerWith("ClassTrainerFrame", "Blizzard_TrainerUI");
        BM_SetMoveHandlerWith("KeyBindingFrame", "Blizzard_BindingUI");
        --BM_SetMoveHandlerWith("AuctionFrame", "Blizzard_AuctionUI");
        BM_SetMoveHandlerWith("LookingForGuildFrame", "Blizzard_LookingForGuildUI");
        BM_SetMoveHandlerWith("ArchaeologyFrame", "Blizzard_ArchaeologyUI");
        BM_SetMoveHandlerWith("ArtifactRelicForgeFrame", "Blizzard_ArtifactUI");
        BM_SetMoveHandlerWith("ScrappingMachineFrame", "Blizzard_ScrappingMachineUI");
        BM_SetMoveHandlerWith("AzeriteEmpoweredItemUI", "Blizzard_AzeriteUI");
        BM_SetMoveHandlerWith("SoulbindViewer", "Blizzard_Soulbinds");

        if not hasConflict then
            BM_SetMoveHandler(PlayerPowerBarAlt)
            --[[ --多米诺发现BlizzMove启用时不加载Encounter模块
            if IsAddOnLoaded("Dominos_Encounter") then
                PlayerPowerBarAlt:SetScript("OnDragStart", function() U1Message("由于多米诺动作条已启用，不能拖动，请点击|TInterface\\Addons\\Dominos\\Dominos:0|t按钮进行布局") end)
                PlayerPowerBarAlt:SetScript("OnDragStop", nil)
            end
            --]]
        end

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
            BM_SetMoveHandler(AchievementFrame, AchievementFrame.Header)
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

        --6.0
        BM_SetMoveHandlerWith(nil, "Blizzard_GarrisonUI", function()
            BM_SetMoveHandler(GarrisonLandingPage)
            BM_SetMoveHandler(GarrisonMissionFrame)
            BM_SetMoveHandler(GarrisonBuildingFrame)
            BM_SetMoveHandler(GarrisonCapacitiveDisplayFrame)
        end)

        BM_SetMoveHandlerWith(nil, "Blizzard_Collections", function()
            BM_SetMoveHandler(WardrobeFrame)
            do
                -- fix a stupid anchor family connection issue blizzard added in 9.1.5
                local checkbox = _G.WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox;
                checkbox.Label:ClearAllPoints();
                checkbox.Label:SetPoint("LEFT", checkbox, "RIGHT", 2, 1);
                checkbox.Label:SetPoint("RIGHT", checkbox, "RIGHT", 160, 1);
            end
            local mover = BM_CreateMover(CollectionsJournal, 26, 30, 30, 0)
            BM_SetMoveHandler(CollectionsJournal, mover)
        end)
        CoreDependCall("Rematch", function() RematchJournal:EnableMouse(false) end) --不能遮挡拖动

        BM_SetMoveHandlerWith(nil, "Blizzard_GuildUI", function()
            BM_SetMoveHandler(GuildFrame)
            BM_SetMoveHandler(GuildFrame, GuildFrame.TitleMouseover, true);
        end);

        --8.0
        BM_SetMoveHandlerWith("AuctionHouseFrame", "Blizzard_AuctionHouseUI");
        --BM_SetMoveHandlerWith("CommunitiesFrame", "Blizzard_Communities"); --TODO:abyui10 无法移动
        BM_SetMoveHandlerWith("AzeriteEssenceUI", "Blizzard_AzeriteEssenceUI");
        --BM_SetMoveHandlerWith("AzeriteEmpoweredItemUI", "Blizzard_AzeriteUI");
        BM_SetMoveHandlerWith("OrderHallTalentFrame", "Blizzard_OrderHallUI");

        --9.0
        BM_SetMoveHandler(ItemTextFrame)
        BM_SetMoveHandlerWith("WeeklyRewardsFrame", "Blizzard_WeeklyRewards");

        --10.0
        BM_SetMoveHandler(QuickKeybindFrame)
        BM_SetMoveHandler(SettingsPanel)
        BM_SetMoveHandlerWith(nil, "Blizzard_ClassTalentUI", function()
            local mover = BM_CreateMover(ClassTalentFrame, 80, 30, 30, 0)
            BM_SetMoveHandler(ClassTalentFrame, mover)
            mover:SetFrameStrata("HIGH")
        end)

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
