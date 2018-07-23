local coreui_frame = CreateFrame("Frame");

--- 将材质变为单色, 是否支持材质变色
local isDesaturatedSupported = coreui_frame:CreateTexture():SetDesaturated(true)
function CoreUIDesaturateTexture(texture, r, g, b, alpha)
    if isDesaturatedSupported == 1 then
        if not texture:IsDesaturated() then
            texture:SetDesaturated(true);
        end
    else
        if r == nil then r,g,b,alpha = 0.4, 0.4, 0.4, 1 end
        texture:SetVertexColor(r,g,b,alpha);
    end
end
function CoreUIUndesaturateTexture(texture)
    if isDesaturatedSupported == 1 then
        if texture:IsDesaturated() then
            texture:SetDesaturated(false);
        end
    else
        texture:SetVertexColor(1,1,1,1);
    end
end

function CoreUIEnableOrDisable(self, enable)
    if self then
        if(enable)then self:Enable() else self:Disable(); end
    end
end

function CoreUIShowOrHide(self, show)
    if self then
        if show then self:Show() else self:Hide() end
    end
end

function CoreUIGetTextSize(text, fontstring)
    TestFontString = TestFontString or CreateFrame("Frame"):CreateFontString()
    local test = TestFontString
    test:SetFontObject(fontstring:GetFontObject())
    test:SetText(text)
    return test:GetStringWidth(), test:GetStringHeight()
end

local CreateResizeButton_OnMouseDown, CreateResizeButton_OnMouseUp --通用函数节约内存
---创建一个缩放的HandlerButton
--@param point 缩放按钮的位置,一般是BOTTOMRIGHT
--@param resizePoint 设置缩放的边缘,用于调用Frame:StartSizing方法,如果省略,则和point是一样的
function CoreUICreateResizeButton(frame, point, resizePoint, offsetX, offsetY, size)
    local btn = CreateFrame("Button", nil, frame);
    local size = size or 16;
    btn:SetWidth(size);
    btn:SetHeight(size);
    btn:SetPoint(point, frame, offsetX or 0, offsetY or 0);
    btn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up");
    btn:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight");
    btn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down");
    local ULx,ULy,LLx,LLy,URx,URy,LRx,LRy=0,0,0,1,1,0,1,1
    if(point:find("LEFT"))then ULx=1;LLx=1;URx=0;LRx=0 end
    if(point:find("TOP"))then ULy=1;LLy=0;URy=1;LRy=0 end
    btn:GetNormalTexture():SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
    btn:GetHighlightTexture():SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
    btn:GetPushedTexture():SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
    btn.resizePoint = resizePoint or point;

    CreateResizeButton_OnMouseDown = CreateResizeButton_OnMouseDown or function(self)
        self:SetButtonState("PUSHED", true);
        SetCursor("Interface\\CURSOR\\openhandglow");
        self:GetHighlightTexture():Hide();
        self:GetParent():StartSizing(self.resizePoint);
    end
    CreateResizeButton_OnMouseUp = CreateResizeButton_OnMouseUp or function(self)
        self:SetButtonState("NORMAL", false);
        SetCursor(nil); --Show the cursor again
        self:GetHighlightTexture():Show();
        self:GetParent():StopMovingOrSizing();
    end
    btn:SetScript("OnMouseDown", CreateResizeButton_OnMouseDown);
    btn:SetScript("OnMouseUp", CreateResizeButton_OnMouseUp);
    return btn;
end

---页面框架增加鼠标提示
--@param frame 要增加支持的框架
--@param title 提示的标题, 可以省略, 颜色自动为白色
--@param content 提示的信息, 如果是字符串则直接显示, 或者是function(frame, tip)
local EnableTooltip_OnLeave
function CoreUIEnableTooltip(frame, title, content, update)
    frame:EnableMouse(true);
    frame.tooltipTitle=title;
    frame.tooltipText=content;
    if(type(content)=="function") then frame.tooltipText=" "; frame._tooltipText=content; end
    CoreHookScript(frame, "OnEnter",CoreUIShowTooltip);
    if update then frame.UpdateTooltip = CoreUIShowTooltip end

    EnableTooltip_OnLeave = EnableTooltip_OnLeave or function(self) GameTooltip:Hide(); end
    CoreHookScript(frame, "OnLeave", EnableTooltip_OnLeave);
end

function CoreUIAddNewbieTooltip(self, newbieText, r, g, b)
    if ( SHOW_NEWBIE_TIPS == "1" ) then
        self:AddLine(" ");
        self:AddLine(newbieText, r or 0, g or 0.82, b or 0, 1);
    end
end

--tooltipTitle,tooltipText,tooltipLines,tooltipAnchorPoint
function CoreUIShowTooltip(self, anchor)
    if(self.tooltipTitle or self.tooltipText or self.tooltipLines) then
        GameTooltip:SetOwner(self, anchor or self.tooltipAnchorPoint);
        GameTooltip:ClearLines();
        if(self.tooltipLines)then
            if(type(self.tooltipLines)=="string")then
                self.tooltipLines = {strsplit("`", self.tooltipLines) }
            end
            if(type(self.tooltipLines)=="table" and #self.tooltipLines > 0)then
                GameTooltip:AddLine(self.tooltipLines[1],1,1,1)
                for i=2, #self.tooltipLines do
                    GameTooltip:AddLine(self.tooltipLines[i],nil,nil,nil,true); --最后一个参数是换行
                end
            end
        else
            if(self.tooltipTitle)then GameTooltip:AddLine(self.tooltipTitle,1,1,1); end
        end

        if(type(self._tooltipText)=="function") then
            self._tooltipText(self, GameTooltip);
        else
            GameTooltip:AddLine(self.tooltipText,nil,nil,nil,true); --最后一个参数是换行
        end

        GameTooltip:Show();
    end
end

---设置职业颜色
--@param buttonString fontString对象, 要有SetText和SetTextColor方法
--@param text 文本
--@param class 职业英文,全大写
function CoreUISetTextWithClassColor(buttonString, text, class)
    buttonString:SetText(text);
    if ( class ) then
        local classColor = RAID_CLASS_COLORS[class];
        buttonString:SetTextColor(classColor.r, classColor.g, classColor.b);
    else
        buttonString:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    end
end

---创建一个包含标题框的对话框, 层次为DIALOG
--@return wrapped, 具有title属性.
function CoreUICreateDialog(name,parent,width,height)
    local f = WW:Frame(name,parent):Size(width,height)
    f:SetFrameStrata("DIALOG");
    -- wrapped:Backdrop(bgFile, edgeFile, edgeSize, insets, tileSize)
    f:Backdrop("Interface\\DialogFrame\\UI-DialogBox-Background-Dark","Interface\\DialogFrame\\UI-DialogBox-Border",32,{11,11,12,10},32);
    local header = f:Texture(nil, "ARTWORK", "Interface\\DialogFrame\\UI-DialogBox-Header"):Size(300,68):TOP(0,12)
    f.title = f:CreateFontString(nil, "ARTWORK", "GameFontNormal"):TOP(header,0,-14);
    return f;
end

---创建一个CheckButton, 默认值为size=26, font="GameFontNormalSmall"
--对象可以具有tooltipText, tooltipOwnerPoint(默认为ANCHOR_RIGHT), func(OnClick脚本)属性
--@return wrapped
function CoreUICreateCheckButton(parent, name, size, text, font)
    size = size or 26;
    font = font or "GameFontNormalSmall";
    local cb = TplCheckButton(parent, name);
    cb:SetSize(size, size);
    cb.text:SetFontObject(font);
    if text then cb.text:SetText(text); end
    return cb;
end

---创建一个右侧有图标的CheckButton
--具有SetIcon和SetText属性
--SetText一定要在SetIcon之后调用才能正确计算宽度
function CoreUICreateCheckButtonWithIcon(parent, name, size, iconSize)
    local cb = CoreUICreateCheckButton(parent, name, size);
    cb:Button():Key("icon"):LEFT(cb.text, "RIGHT", 3, -1):SetSize(iconSize)
    :CreateTexture():Key("tex"):ALL():up():un();

    cb.SetIcon = CoreUISetCheckButtonIcon;
    cb.SetText = CoreUISetCheckButtonText;
    return cb;
end
---参数为nil则隐藏图标
function CoreUISetCheckButtonIcon(self, ...)
    if(...==nil) then
        self.icon:Hide();
    else
        self.icon:Show();
        self.icon.tex:SetTexture(...);
    end
end
---右侧图标紧跟按钮, 但如果文字过长则自动缩短
function CoreUISetCheckButtonText(self, text, left)
    self.text:SetSize(0,0); --自动大小
    self.text:SetText(text);

    --计算控件的实际宽度, 用于缩减宽度
    local width = (left or 0) + self:GetWidth() * (1-0.183) + self.text:GetWidth();
    --不知道为什么, 如果用LEFT-RIGHT的anchor, 第一个控件会错位一点. 但用下面的方式, OnMouseDown有问题
    --self.text:ClearAllPoints();
    --self.text:SetPoint("TOPLEFT", self, "TOPRIGHT", -2, (select(2, self.text:GetFont())-self:GetSize())/2+0.5);

    if(self.icon:IsVisible()) then
        width = width + 3 + self.icon:GetWidth() + 10;
    else
        width = width + 5;
    end

    if( width > self:GetParent():GetWidth() ) then
        self.text:SetWidth(self.text:GetWidth()-(width-self:GetParent():GetWidth()));
        local _, fontHeight = self.text:GetFont();
        self.text:SetHeight(fontHeight);
    end
end

---创建一个移动响应区，Anchor是TOPLEFT和TOPRIGHT的
local Mover_OnMouseDown, Mover_OnMouseUp;
function CoreUICreateMover(frame, height, offsetLeft, offsetRight, offsetTop)
    frame:SetMovable(true)
    local mover = WW(frame):Frame():Size(0,height)
    mover:TL(offsetLeft,offsetTop):TR(offsetRight,offsetTop)
    mover:EnableMouse():SetFrameLevel(0)
    Mover_OnMouseDown = Mover_OnMouseDown or function(self) self:GetParent():StartMoving() end
    Mover_OnMouseUp = Mover_OnMouseUp or function(self) self:GetParent():StopMovingOrSizing() end
    mover:SetScript("OnMouseDown", Mover_OnMouseDown);
    mover:SetScript("OnMouseUp", Mover_OnMouseUp);
end

--- 移动, 如果有target函数, 则实际移动的是
local CoreUIMakeMovable_OnMouseDown,CoreUIMakeMovable_OnMouseUp;
function CoreUIMakeMovable(f, target)
    --[[ 用这种方法不能点击外部移动
        f:EnableMouse(true);
        f:CreateTitleRegion():SetAllPoints();
    --]]
    if(target)then
        f._moveTarget = target;
        target:SetMovable(true);
        target:SetClampedToScreen(true)
    else
        f:SetMovable(true);
        f:SetClampedToScreen(true)
    end
    CoreUIMakeMovable_OnMouseDown = CoreUIMakeMovable_OnMouseDown or function(self)
        local frame = self._moveTarget or self;
        if(frame:IsMovable()) then frame:StartMoving(); end
    end
    CoreUIMakeMovable_OnMouseUp = CoreUIMakeMovable_OnMouseUp or function(self)
        local frame = self._moveTarget or self;
        frame:StopMovingOrSizing();
    end
    f:EnableMouse(true);
    f:SetScript("OnMouseDown", CoreUIMakeMovable_OnMouseDown);
    f:SetScript("OnMouseUp", CoreUIMakeMovable_OnMouseUp);
end

---用4.2的tile创建高分辨率的边框
--@param frame 要创建边框的框体
--@param outset 边框距离框体的空白，正数是在外面，负数是在里面
--@param borderTextureTemplatePrefix 需要在XML里创建的Texture模板前缀，会自动加上"L","R","T","B"
--@param borderWidth 边框宽度，对左和右是宽度，上和下是高度, 暂时要求一致
--@param cornerTextureFile 四角的材质文件
--@param cornerSize 四角的大小，必须是一样的
--@param rotateCorner 是否旋转材质，如果为true，则材质文件是左上角，旋转得到的，如果是false则切割四角
function CoreUIDrawBorder(frame, outset, borderTextureTemplatePrefix, borderWidth, cornerTextureFile, cornerSize, rotateCorner)
    local f = WW(frame)
    local layer = "BORDER"
    local tl = f:CreateTexture(nil, layer):SetTexture(cornerTextureFile):Size(cornerSize):TL(-outset, outset):un()
    local tr = f:CreateTexture(nil, layer):SetTexture(cornerTextureFile):Size(cornerSize):TR(outset, outset):un()
    local bl = f:CreateTexture(nil, layer):SetTexture(cornerTextureFile):Size(cornerSize):BL(-outset, -outset):un()
    local br = f:CreateTexture(nil, layer):SetTexture(cornerTextureFile):Size(cornerSize):BR(outset, -outset):un()
    if rotateCorner then
        tr:SetTexCoord(1,0,1,1,0,0,0,1)
        bl:SetTexCoord(0,1,0,0,1,1,1,0)
        br:SetTexCoord(1,1,0,1,1,0,0,0)
    else
        tl:SetTexCoord(0, 0.5, 0, 0.5)
        tr:SetTexCoord(0.5, 1, 0, 0.5)
        bl:SetTexCoord(0, 0.5, 0.5, 1)
        br:SetTexCoord(0.5, 1, 0.5, 1)
    end
    local l = f:CreateTexture(nil, layer, borderTextureTemplatePrefix.."L"):TL(tl, "BL"):BR(bl, "TL", borderWidth, 0):un()
    local r = f:CreateTexture(nil, layer, borderTextureTemplatePrefix.."R"):TL(tr, "BR", -borderWidth, 0):BR(br, "TR"):un()
    local t = f:CreateTexture(nil, layer, borderTextureTemplatePrefix.."T"):TL(tl, "TR"):BR(tr, "TL", 0, -borderWidth):un()
    local b = f:CreateTexture(nil, layer, borderTextureTemplatePrefix.."B"):TL(bl, "BR", 0, borderWidth):BR(br, "BL"):un()
    if f~=frame then f:un() end
    return tl, tr, bl, br, l, r, t, b
end

local nonUIParent = CreateFrame("Frame") nonUIParent:SetFrameStrata("BACKGROUND")
---创建一个平铺的背景,而且可以不随UI缩放而变化
function CoreUIDrawBG(frame, textureTemplateName, inset, noParent)
    frame = WW:un(frame)
    local tex = (noParent and nonUIParent or frame):CreateTexture(nil, "BACKGROUND", textureTemplateName)
    tex:Hide();
    tex:SetPoint("TOPLEFT", frame, "TOPLEFT", inset, -inset)
    tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset, inset)
    if noParent then
        CoreHookScript(frame, "OnShow", function(self) tex:Show() end)
        CoreHookScript(frame, "OnHide", function(self) tex:Hide() end)
    end
    return tex
end

function CoreUIRegisterSlash(name, slash1, slash2, func)
    SlashCmdList[name] = func;
    _G["SLASH_"..name.."1"] = slash1;
    if slash2 then _G["SLASH_"..name.."2"] = slash2; end
end

CoreUIRegisterSlash("RL", "/rl", nil, function() U1DB.loadSpeed2 = nil ReloadUI() end)
CoreUIRegisterSlash("RL2", "/rl2", nil, function() U1DB.loadSpeed2 = 1 ReloadUI() end) --慢速加载

---一系列控件排列用的方法
function CoreUIAnchor(container, initPoint, initRelative, initX, initY, subPoint, subRelative, subX, subY, ...)
    local first = ...;
    first:ClearAllPoints();
    first:SetPoint(initPoint, WW:un(container), initRelative, initX, initY);
    for i=2, select("#", ...) do
        local obj = select(i, ...);
        obj:ClearAllPoints();
        obj:SetPoint(subPoint, WW:un(first), subRelative, subX, subY);
        first = obj;
    end
end

---闪烁
function CoreUICreateFlash(frame, texture, ...)
    if not frame.__flash then
        local tex = frame:CreateTexture(nil);
        tex:SetDrawLayer("OVERLAY", 7);
        tex:SetTexture(texture)
        if(...) then tex:SetTexCoord(...); end
        tex:SetBlendMode("ADD")
        tex:SetAllPoints();
        UICoreFrameFlashStop(tex);
        frame.__flash = tex;
    end
    return frame.__flash;
end

function CoreUISetEditText(text, insert)
    local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
    if insert then
        chatFrame.editBox:Insert(text);
    else
        chatFrame.editBox:SetText(text);
    end
    chatFrame.editBox:Show();
    chatFrame.editBox:HighlightText()
    chatFrame.editBox:SetFocus()
end

CoreDependCall("Blizzard_BindingUI", function()
    KeyBindingFrameScrollFrame:HookScript("OnVerticalScroll", CoreUIHideCallOut)
end)

function CoreUIShowKeyBindingFrame(scrollTo)
    if not IsAddOnLoaded("Blizzard_BindingUI") then KeyBindingFrame_LoadUI(); end

    if ( scrollTo == nil ) then
        ShowUIPanel(KeyBindingFrame);
        return;
    else
        local num = GetNumBindings();
        for i = 1, num, 1 do
            local header, _, _ = GetBinding(i);
            if ( header == scrollTo) then
                ShowUIPanel(KeyBindingFrame);
                KeyBindingFrameScrollFrameScrollBar:SetValue((i -1)*KEY_BINDING_HEIGHT);
                CoreUIShowCallOut(_G[format("KeyBindingFrameBinding%d", i-KeyBindingFrameScrollFrame.offset)], nil, nil, -15, 3, -385, -5)
                break;
            end
        end
    end
end

function CoreUISelectAce3Tree(...)
    if not AceGUI30TreeButton1:IsVisible() then return end
    local status = AceGUI30TreeButton1.toggle.button.obj;
    status = (status.status or status.localstatus).groups;
    local path
    for i=1, select("#", ...)-1 do
        local n = select(i, ...);
        path = path and path.."\001"..n or n;
        status[path] = true;
    end
    AceGUI30TreeButton1:GetParent().obj:SelectByPath(...);
    AceGUI30TreeButton1:GetParent().obj:RefreshTree();
end

---当frame可以移动时，强制设置锚点，以便保持左上角或右上角不变
function CoreUIKeepCorner(frame, point)
    local left, top, width, height = frame:GetLeft(), frame:GetTop(), frame:GetWidth(), frame:GetHeight();
    if left==nil or top==nil then return end
    if point:find("RIGHT") then
        left = left + width;
    end
    if point:find("BOTTOM") then
        top = top + height
    end
    frame:ClearAllPoints()
    frame:SetPoint(point, UIParent, "BOTTOMLEFT", left, top);
end

function CoreUISetButtonFonts(button, normal, highlight, disable)
    button:SetNormalFontObject(normal)
    if highlight then button:SetHighlightFontObject(highlight) end
    if disable then button:SetDisabledFontObject(disable) end
end

--- 缩放时保持左上角位置不变
function CoreUISetScale(frame, scale)
    local anchor = select(2, frame:GetPoint())
    if frame:GetNumPoints()<=1 and (anchor == UIParent or anchor == nil) then
        if not frame:GetLeft() or not frame:GetTop() then frame:SetScale(scale) return end
        local x = frame:GetLeft() * frame:GetScale() / scale;
        local y = frame:GetTop() * frame:GetScale() / scale;
        frame:SetScale(scale);
        frame:ClearAllPoints();
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);
    else
        frame:SetScale(scale)
    end
end

---参数是左上角和右下角 --U1CallOut:HookScript("OnHide", function(self) self:SetParent(UIParent) self:ClearAllPoints() end) 就会崩溃
function CoreUIShowCallOut(parent, relative1, relative2, x1, y1, x2, y2)
    if U1CallOut then
        relative1 = relative1 or parent
        relative2 = relative2 or relative1 or parent
        U1CallOut:SetParent(parent)
        U1CallOut:SetFrameStrata("TOOLTIP")
        U1CallOut:SetPoint("TOPLEFT", relative1, "TOPLEFT", x1 or 0, y1 or 0);
        U1CallOut:SetPoint("BOTTOMRIGHT", relative2, "BOTTOMRIGHT", x2 or 0, y2 or 0);
        U1CallOut:Show();
    end
end
function CoreUIHideCallOut()
    if U1CallOut then U1CallOut:Hide() end
end
