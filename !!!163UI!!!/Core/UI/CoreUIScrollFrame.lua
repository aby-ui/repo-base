
----------------------------------------------------------------------------
-- slider
-- Faux需要手工设置OnVerticalScroll
-- FauxScrollFrame_OnVerticalScroll(self, offset, 12, ProfilerScrollFrame_Update)
--[[
ProfilerScrollFrame:SetScript("OnVerticalScroll",function(self, offset)
      local value = offset
      local itemHeight = 12;
      local updateFunction =  ProfilerScrollFrame_Update;
      local scrollbar = self.scrollBar;
      scrollbar:SetValue(value);
      self.offset = floor((value / itemHeight) + 0.5);
      if ( updateFunction ) then
         updateFunction(self);
      end
end);
]]
----------------------------------------------------------------------------
local CoreUICreateModernScrollBar_OnValueChanged = function(self, value)
    self:GetParent():SetVerticalScroll(value)
end
local CoreUICreateModernScrollBar_OnVerticalScroll = function(self, offset)
    self.scrollBar:SetValue(offset);
end
local CoreUICreateModernScrollBar_OnMouseWheel = function(self, delta)
    delta = (delta>0 and -1 or 1)*self.scrollBar:GetHeight()
    self.scrollBar:SetValue(self.scrollBar:GetValue() + delta);
end
local CoreUICreateModernScrollBar_OnScrollRangeChanged = function(self,xrange,yrange)
    local scrollbar = self.scrollBar;
    if ( not yrange ) then
        yrange = self:GetVerticalScrollRange();
    end
    local value = scrollbar:GetValue();
    if ( value > yrange ) then
        value = yrange;
    end
    scrollbar:SetMinMaxValues(0, yrange);
    scrollbar:SetValue(value);
end
--*****************************************************************
-- hook表示是否修改父面板的一些滚动相关的事件
--*****************************************************************
function CoreUICreateModernScrollBar(parent, offsetX, offsetY, hook, barWidth, thumbHeight, backAlpha)
    backAlpha = backAlpha  or 0.75;
    thumbHeight = thumbHeight or 40;
    barWidth = barWidth or 8;
    local parentKey = "scrollBar";
    local r,g,b,factor,start,stop=1,0,0,1,.3,.6
    local backOffset=1 --上下留出的背景是多少
    local bar = WW(parent):Slider():Key(parentKey):TR(offsetX, offsetY-backOffset):BR(offsetX, -(offsetY-backOffset)-1):SetWidth(barWidth):AddFrameLevel(1);

    --创建一个向上和向下各出backOffset个像素的背景
    local back = bar:Frame():TL(-1,backOffset):BR(0,-backOffset):Key("back");
    back:Backdrop([[Interface\QUESTFRAME\UI-TextBackground-BackdropBackground]], nil, 0, 0, nil)
    --Interface\DialogFrame\UI-DialogBox-Background
    back:SetBackdropColor(1,1,1,backAlpha);
    back:SetFrameLevel(bar:GetFrameLevel());

    local thumb = bar:Texture():Key("thumbTexture"):SetColorTexture(1,1,1):SetGradientAlpha("HORIZONTAL",r,g,b,start,r*factor,g*factor,b*factor,stop);
    thumb:SetWidth(barWidth-1):SetHeight(thumbHeight);
    bar:SetThumbTexture(thumb);
    bar:SetMinMaxValues(0, bar:GetParent():GetVerticalScrollRange());
    bar:SetValue(0);

    bar:SetScript("OnValueChanged", CoreUICreateModernScrollBar_OnValueChanged);
    if(hook)then
        parent:SetScript("OnVerticalScroll", CoreUICreateModernScrollBar_OnVerticalScroll);
        parent:SetScript("OnMouseWheel", CoreUICreateModernScrollBar_OnMouseWheel);
        parent:SetScript("OnScrollRangeChanged", CoreUICreateModernScrollBar_OnScrollRangeChanged);
    end
    return bar();
end

CoreUICreateHybridUpdateScroll = function(scrollFrame)
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local buttons = scrollFrame.buttons;
    local numButtons = #buttons;
    local numData = scrollFrame:getNumFunc();
    local button, index, class;
    for i = 1, numButtons do
        local button, index = buttons[i], offset + i;
        if(index > numData) then
            button:Hide();
        else
            scrollFrame:updateFunc(button, index);
            button:Show();
        end
    end

    local totalHeight = numData * scrollFrame.buttonHeight;
    local displayedHeight = numButtons * scrollFrame.buttonHeight;
    if(scrollFrame.noScrollBar and scrollFrame.scrollBar) then scrollFrame.scrollBar.doNotHide = true end --可以enable和disable按钮
    HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
    if scrollFrame.scrollBar and floor(totalHeight - scrollFrame:GetHeight() + 0.5)<=0 then scrollFrame.scrollBar:SetMinMaxValues(0,1) end --不然左侧拖动滚动会出问题,用1是为了防止HybridScrollFrame_Update里的>= math.floor(maxVal)
    if(scrollFrame.noScrollBar and scrollFrame.scrollBar) then scrollFrame.scrollBar:Hide() end
end
local CoreUICreateHybrid_OnValueChanged = function(self, value) HybridScrollFrame_OnValueChanged(LFG_SUBTYPEID_FLEXRAID and self or self:GetParent(), value); end
local CoreUICreateHybrid_DummyButton = CreateFrame("Button");
--- 复制HybridScrollFrame_OnMouseWheel，按住Shift一次滚动一次, 按住Ctrl可以翻页滚动
local CoreUICreateHybrid_OnMouseWheel = function(self, delta, stepSize)
    if ( not self.scrollBar:IsVisible() and not self.noScrollBar ) then
        return;
    end

    local minVal, maxVal = 0, self.range;
    if not stepSize then
        if IsShiftKeyDown() then
            stepSize = self.stepType=="LINE" and self.stepSizePage or self.stepSizeLine
        else
            stepSize = self.stepType == "PAGE" and self.stepSizePage or self.stepType == "LINE" and self.stepSizeLine or self.stepSize
        end
    end
    if ( delta == 1 ) then
        self.scrollBar:SetValue(max(minVal, self.scrollBar:GetValue() - stepSize));
    else
        self.scrollBar:SetValue(min(maxVal, self.scrollBar:GetValue() + stepSize));
    end
end
--- 复制HybridScrollFrame_CreateButtons, 将template改为creator
function CoreUICreateHybridButtonsOnSizeChanged(self)
    CoreUICreateHybridButtonsAgain(self.scroll)
    self.scroll.update()
end
function CoreUICreateHybridButtonsAgain(self)
    if(self.args) then
        CoreUICreateHybridButtons(self, unpack(self.args));
    end
end
function CoreUICreateHybridButtons(self, initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint)
    self.args = self.args or {};
    self.args[1],self.args[2],self.args[3],self.args[4],self.args[5],self.args[6],self.args[7],self.args[8] = initialOffsetX, initialOffsetY, initialPoint, initialRelative, offsetX, offsetY, point, relativePoint;
    self.buttonCache = self.buttonCache or {}; --所有创建的.
    local scrollChild = self.scrollChild;
    local button, buttonHeight, buttons, numButtons;

    initialPoint = initialPoint or "TOPLEFT";
    initialRelative = initialRelative or "TOPLEFT";
    point = point or "TOPLEFT";
    relativePoint = relativePoint or "BOTTOMLEFT";
    offsetX = offsetX or 0;
    offsetY = offsetY or 0;

    if ( self.buttons ) then
        buttons = self.buttons;
        buttonHeight = buttons[1]:GetHeight();
    else
        button = self:creator(1, nil);
        buttonHeight = button:GetHeight();
        button:SetPoint(initialPoint, scrollChild, initialRelative, initialOffsetX, initialOffsetY);
        buttons = {}
        tinsert(buttons, button);
        tinsert(self.buttonCache, button);
    end

    self.buttonHeight = math.floor(buttonHeight + .5) - offsetY;

    local numButtons = math.ceil(self:GetHeight() / buttonHeight) + 1;

    for i = #buttons + 1, numButtons do
        button = self.buttonCache[i];
        if not button then
            button = self:creator(i, nil);
            tinsert(self.buttonCache, button);
        end
        button:SetPoint(point, buttons[i-1], relativePoint, offsetX, offsetY);
        tinsert(buttons, button);
    end

    scrollChild:SetWidth(self:GetWidth())
    scrollChild:SetHeight(numButtons * buttonHeight);
    self:SetVerticalScroll(0);
    self:UpdateScrollChildRect();

    self.buttons = buttons;
    local scrollBar = self.scrollBar;
    if(scrollBar)then
        scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
        scrollBar:SetValueStep(.005);
        scrollBar:SetValue(0);
    end

    --如果有stepSize则翻页按stepSize来，否则按buttonHeight来
    self.stepSizePage = math.floor(self:GetHeight()/self.buttonHeight)*self.buttonHeight;
    self.stepSizeLine = self.buttonHeight;
    self.stepSize = math.ceil(self:GetHeight()/self.buttonHeight/2)*self.buttonHeight;
end

--------------------------------------------------------------------------
---创建HybridScrollFrame第一步, 生成对象可以用来写function
---@param outBar 是否把滚动条放置在框架外部，当useBlizzardBar的时候无用
function CoreUICreateHybridStep1(name, parent, barWidth, outBar, useBlizzardBar, stepType)
    local scroll = CreateFrame("ScrollFrame", name, parent, "HybridScrollFrameTemplate");
    scroll.stepType = stepType
    scroll:SetScript("OnMouseWheel", CoreUICreateHybrid_OnMouseWheel);

    local barWidth = barWidth or 6
    --滚动条必须CreateButtons之前调用,CreateButtons会SetMinMaxValue
    if not useBlizzardBar then
        local bar = CoreUICreateModernScrollBar(scroll, outBar and barWidth+1 or -1, 1, false, barWidth, 32, 1)
        bar:SetScript("OnValueChanged", CoreUICreateHybrid_OnValueChanged);
        bar:SetFrameLevel(bar:GetFrameLevel()+1);
        scroll.scrollUp = CoreUICreateHybrid_DummyButton;
        scroll.scrollDown = CoreUICreateHybrid_DummyButton;
        bar:SetFrameLevel(bar:GetFrameLevel()+1);
    else
        local bar = CreateFrame("Slider", (name or tostring(scroll)).."ScrollBar", scroll, "MinimalHybridScrollBarTemplate")
        bar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 0, -16)
        bar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 0, 16)
        _G[bar:GetName().."Track"]:SetAlpha(0.3)
        scroll.scrollBar = bar
        bar:SetFrameLevel(bar:GetFrameLevel()+1);
    end

    return scroll;
end

--- 第二步生成按钮, 刷新页面, 在进行此步骤之前必须设置
-- @param scroll的anchor或者高度
-- @param scroll.getNumFunc
-- @param scroll.updateFunc
-- @param scroll.creator 注意，应该以scroll.scrollChild为父对象创建按钮
function CoreUICreateHybridStep2(scroll, initialOffsetX, initialOffsetY, initialPoint, initialRelative, buttonOffset)
    assert(scroll.creator, "HybridScrollFrameError: no creator provided.")
    assert(scroll.getNumFunc, "HybridScrollFrameError: getNumFunc attribute not set.")
    assert(scroll.updateFunc, "HybridScrollFrameError: getNumFunc attribute not set.")

    CoreUICreateHybridButtons(scroll, initialOffsetX, initialOffsetY, initialPoint, initialRelative, 0, -buttonOffset, "TOP", "BOTTOM")
    --scroll.buttonOffset = buttonOffset; --不需要, CreateButtons中的scroll.buttonHeight已经计算进去了
    scroll.update = scroll.update or function() CoreUICreateHybridUpdateScroll(scroll) end;
    scroll.update();
end

function CoreUIScrollTo(scroll, offset)
    --如果scrollBar:GetValue 位于offset 到 offset - scroll:GetHeight() + buttonHeight之间则不滚动, 否则滚
    local curr = scroll.scrollBar:GetValue();
    offset = offset * scroll.buttonHeight;
    if(curr>offset) then
        curr = offset
    elseif(curr < offset + scroll.buttonHeight - scroll:GetHeight()) then
        curr = offset + scroll.buttonHeight - scroll:GetHeight()
    else
        return --不需要滚动
    end
    scroll.scrollBar:SetValue(curr);
end

function CoreUIScrollSavePos(scroll)
    scroll._savedpos = scroll.scrollBar:GetValue();
end

function CoreUIScrollLoadPos(scroll)
    scroll.scrollBar:SetValue(scroll._savedpos or 0);
end
