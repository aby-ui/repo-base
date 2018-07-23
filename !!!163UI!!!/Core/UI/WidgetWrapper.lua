--[[
-- 实现Widget的封装，可以连锁调用，并且提供一些方便的函数，不会污染
-- 例如：local frame = lib:Frame("name"):SetSize(100,200):SetAlpha(0.1)
-- 注意
-- 1. wrapper上面并不保存任何属性, 所有设置都直接设置到_F上
-- 2. (已取消)wrapper只有_F和_1,_2,_3,_4,_5这几个属性
-- 3. (已取消)可以用wrapper:Returned()返回上次调用的结果, 但最多支持5个
-- 4. 自动UnWrap()

-- 注意wrapper对象的生命周期，只有如下情况返回给缓存池:
-- 1. 调用了un()方法
-- 2. 调用了up()方法
-- 3. 赋值给一个wrapper的属性
-- 连续调用wrapper:CreateFontString():up():un()就可以完全清理
-- 上面是错误的, 因为up()会导致重复封装.
-- WW(f):un();

API：
 - WWRun, WW:Run(function(name, first) ... end)
 - wrapped = WW(widgetObject) 封装一个原始的对象，重复封装一个已经封装过的也可以，会自动跳过
 - frame = WW:un(wrapped or frame)
 - wrapped = WW:FrameType(name , parent , template), WW:Button(...) 调用CreateFrame("Frame"/"Button", ...)的快捷方法, 返回的对象是已封装的
 -         = wrapped:FrameType(name, template, parentKey)
 - wrapped = WW:Font(...)
 - n, h, d = WW:Font3(prefix, inherit, fontHeight, colors, flags, shadowX, shadowY)
 - n, h, d = WW:CallFonts3(prefix, funcName, ...)
 - wrappedParent = wrapped:up() 返回上级封装, 即WW(self:GetParent()), 有了这个就可以写frame:Frame(...):up():Frame(...)创建两个平级的子框架
 - 反封装:
        (Deprecated) widget = wrapped:UnWrap() 会释放keep的,并可以缓存
        widget = wrapped:un() 会释放keep的,并可以缓存
        widget = wrapped/0 除法操作可以反封装
        widget = wrapped()
        (Deprecated) widget = -wrapped 负数操作反封装
        (Deprecated) widget = wrapped:un()
 - (removed) wrapper:Returned() 返回上次调用的结果, 但最多支持5个

 - wrapper("Function", ...) -> widget:Function(...)
 - wrapped:SetSize(width, height), 如果不提供height则两者相同
 - wrapped:Size(width, height) 同上
 - wrapped:AddFrameLevel(delta[, relative])
 - wrapped:On(script)
 - wrapped:Load()
 - wrapped:Backdrop(bgFile, edgeFile, edgeSize, insets, tileSize)
 - wrapped:SetParentKey(key)
 - wrapped:Key(key) 同上
 - wrapped:AddToScroll(scroll)

 - wrapped:Point(point, relativeTo, relativePoint, x, y) relativeTo支持字符串，而且支持$parent别名；relativePoint可省略，取point的值
 - wrapped:LEFT(...) 是Point("LEFT", ...)的快捷方法
 - wrapped:BOTTOMRIGHT(...)和BR(...) 是Point("BOTTOMRIGHT", ...)的快捷方法
 - wrapped:ALL() 是SetAllPoints()的快捷方法

 - wrapper:SetBackdropBG(bgFile, tileSize)
 - wrapper:SetBackdropEdge(edgeFile, edgeSize, left, right, top, bottom)

 - wrappedEditBox:CreateText(inherit, layer) 是给EditBox创建文字显示的方法

 - wrapped:Texture(name, layer, str_texture, ...)
 - wrappedTexture:SetFile(str_texture, ...) 设置材质文件名和TexCoord的快捷方法，...可以是(left, right, top, bottom) 或 (ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
 - wrappedTexture:ToTexture(type, ...) wrapped:Texture("file"):ToTexture("Highlight")
 - wrappedTexture:SetTexRotate(angel)

 - wrapped:SetFontHeightAndFlags(height, flags)
 - wrapped:SetFontHeight(height)
 - wrapped:SetFontFlags(flags)
 - wrapped:Set3Fonts(prefix)
 - wrapped:SetButtonFont(font)
 - wrapper:SetTextFont(fontNameOrObject, size, flag)
 - wrapped:GetButtonText()
 - wrappedButton:SetButtonFont("GameFontNormalSmall"):GetButtonText():RIGHT(-2,0):SetTextColor(...)
    <ButtonText>
        <Anchors>
            <Anchor point="RIGHT" x="-2" y="0"/>
        </Anchors>
        <Color r="0.973" g="0.937" b="0.580"/>
    </ButtonText>
    <NormalFont style="GameFontNormalSmall"/>

]]

WW = {}
local lib_meta = {}
local wrapper_meta = {}

_G.WidgetWrapper = WW

local SupportedTypes = {"Frame", "Button", "CheckButton", "ColorSelect", "Cooldown", "GameTooltip", "ScrollFrame", "SimpleHTML", "Slider", "StatusBar", "EditBox", "MessageFrame", "ScrollingMessageFrame", "Model", "PlayerModel", "DressUpModel", "TabardModel", "Minimap", "ArchaeologyDigSiteFrame", "MovieFrame", "QuestPOIFrame", }
for i=1, #SupportedTypes do SupportedTypes[SupportedTypes[i]] = true end


--为了避免消耗,使用同一个table,因为是单线程的
local CALLING_ARGS = {}
local CALLING_ARGS_LEN = 0
--把参数里的wrapped对象还原
local function transferArgs(...)
    table.wipe(CALLING_ARGS) --使用select#之后需要清除
    CALLING_ARGS_LEN = select("#", ...)
    for i=1, CALLING_ARGS_LEN do
        local argi = select(i,...)
        if argi and getmetatable(argi)==wrapper_meta then
            CALLING_ARGS[i] = argi._F
        else
            CALLING_ARGS[i] = argi
        end
    end
end

lib_meta.__index = function(lib, key)
    local func
    
    --缓存:Frame, :Button, ..., :Font等
    --这个毫无意义, 因为如果调用到这里, rawget肯定是nil啊
    --func = rawget(lib, key)
    --if func then return func end

    if SupportedTypes[key] then
        func = function(self, ...)
            transferArgs(...);
            local frame = CreateFrame(key, unpack(CALLING_ARGS,1,CALLING_ARGS_LEN))
            return self:Wrap(frame)
        end
        lib[key] = func
        return func
    elseif  key == "Font" then
        func = function(self, ...)
            local font = CreateFont(...)
            return self:Wrap(font)
        end
        lib[key] = func
        return func
    end
    --return nil, so lib:Other will cause errors.
end

local MAX_REUSE = 10;
local REUSE_WRAPPERS = {} --重用之前UnWrap的对象

--@param keep 是否将本wrapper保存在frame上, 会占用内存. 但是连续的WW()或者up()则可以重用之前的, 一般不需要
function WW:Wrap(frame, keep)
    if getmetatable(frame) == wrapper_meta then return frame end
    if frame.__wrapper then return frame.__wrapper end
    local wrapper = table.remove(REUSE_WRAPPERS) or {}
    rawset(wrapper, "_F", frame);
    if keep then frame.__wrapper = wrapper; end
    setmetatable(wrapper, wrapper_meta);
    return wrapper;
end

function WW:un(frame)
    if getmetatable(frame) == wrapper_meta then return frame() end
    return frame
end

function WW:Font(name, inherit, fontHeight, r, g, b, alpha)
    local font = self:Wrap(CreateFont(name));
    font:CopyFontObject(inherit);
    if(fontHeight) then font:SetFontHeight(fontHeight) end
    if(r and g and b) then
        font:SetTextColor(r,g,b,alpha)
    end
    return font;
end

---创建用于按钮的3个字体, 其中colors是{{1,1,1[,alpha]}, {r,g,b,alpha], {r,g,b,alpha}}
function WW:Font3(prefix, inherit, fontHeight, colors, flags, shadowX, shadowY)
    local n, h, d
    n = WW:Font(prefix.."N", inherit, fontHeight, unpack(colors[1]))
    h = WW:Font(prefix.."H", inherit, fontHeight, unpack(colors[2]))
    if colors[3] then
        d = WW:Font(prefix.."D", inherit, fontHeight, unpack(colors[3]))
    end
    if flags then n:SetFontFlags(flags) h:SetFontFlags(flags) if d then d:SetFontFlags(flags) end end
    if shadowX then n:SetShadowOffset(shadowX, shadowY) h:SetShadowOffset(shadowX, shadowY) if d then d:SetShadowOffset(shadowX, shadowY) end end
    return n:un(), h:un(), d and d:un()
end
---同时执行3个字体的修改
function WW:CallFonts3(prefix, funcName, ...)
    local n, h, d
    local n = prefix.."N" assert(_G[n], format("Font %s not exists.", n)) n=_G[n]
    local h = prefix.."H" assert(_G[h], format("Font %s not exists.", h)) h=_G[h]
    local d = _G[prefix.."D"]
    n[funcName](n, ...)
    h[funcName](h, ...)
    if d then d[funcName](d, ...) end
    return n, h, d
end

lib_meta.__call = WW.Wrap
setmetatable(WW, lib_meta);

--================================================================
-- 设置封装对象的meta行为
--================================================================

--[[ 没什么必要,所以去掉了
---让 -W(Frame):Set...():Set...() 返回真实Frame, 适合在前面添加
wrapper_meta.__unm = function(op)
    return op._F
end
]]

---让 W(Frame):Set...():Set...()/0: 返会真实Frame, 适合在后面添加
wrapper_meta.__div = function(op1, op2)
    return op1._F;
end

--默认WidgetAPI中需要返回值的, 其他都返回frame本身. 除这些外还有一些, 但是暂时不考虑
--[[
GameTooltip:NumLines()
EditBox:SetFont(...) -> isValid
GameTooltip:SetXXX(...)
ScrollingMessageFrame:AtBottom/AtTop()
Texture:SetTexture("texture") -> visible
--]]
local GETTER_PATTERNS = {"^Has[A-Z]", "^Is[A-Z]", "^Can[A-Z]", "^Create[A-Z]", "^Get[A-Z]"}
local function IsGetterMethod(methodName)
    for i=1, #GETTER_PATTERNS do
        if methodName:find(GETTER_PATTERNS[i]) then
            return true
        end
    end
end

---定义wrapper对象的默认操作
wrapper_meta.__index = function(wrapper, key)
    --if(DEBUG_MODE)then print(key) end
    assert(key~="_F", "this wrapper is clear and reused.");
    --_F不应该执行到meta这里, 到这里了就说明wrapper上没有_F了.
    local func
    
    --通用方法, 新增加的一些方便函数, 比如SetSize之类.
    --另外,存储所有方法的公共缓存
    func = wrapper_meta[key]
    if func then return func end
    
    --创建子对象的操作lib:Frame("parent"):Frame("child", "template", "parentKey")
    if SupportedTypes[key] then
        func = function(self, name, template, parentKey)
            local frame = CreateFrame(key, name, self._F, template)
            local wrapped = WW:Wrap(frame)
            self._F.__wrapper = self; --用来之后up()的
            if parentKey then
                self._F[parentKey] = frame
                --self[parentKey] = wrapped --注释掉, 因为wrapper上不保存任何属性
            end
            return wrapped
        end
        wrapper_meta[key] = func
        return func
    end
        
    --处理CreateAnimation, CreateAnimationGroup, CreateFontString, CreateTexture, 返回结果同样Wrapper
    if key=="CreateAnimation" or key=="CreateAnimationGroup" or key=="CreateFontString" or key=="CreateTexture" or key=="CreateControlPoint" then
        func = function(self, ...)
            local obj = self._F[key](self._F, ...)
            return WW:Wrap(obj)
        end
        wrapper_meta[key] = func
        return func
    end

    if type(wrapper._F[key])=="function" then
        if not IsGetterMethod(key) then
            --如果不是GetterMethod, 则封装原始调用, 最后返回的是self
            --注意: 对于自定义的函数, 这里会有问题, 比如自己写了一个frame:SetTooltip(...) return true end,
            --这时通过Wrapper调用的话会返回frame而不是期望的true, 应该是通过wrapper("SetTooltip", ...)来调
            func = function(self, ...)
                assert(self._F[key], "attempt to call method '"..key.."' (a nil value)");
                transferArgs(...);
                local _1,_2,_3,_4,_5 = self._F[key](self._F, unpack(CALLING_ARGS,1,CALLING_ARGS_LEN))
                --还是不能设置,会多40个字节,即使是nil
                --rawset(self, "_1", _1) rawset(self, "_2", _2) rawset(self, "_3", _3) rawset(self, "_4", _4) rawset(self, "_5", _5)
                return self
            end
            wrapper_meta[key] = func
            return func
        else
            --不能直接返回函数, 必须返回一个封装, 否则会报Attempt to find 'this' in non-framescript object
            --这里缓存在meta上并没有问题, 即便frame1和frame2都有upate方法,但都调用meta["update"]并没有问题
            func = function(self, ...)
                assert(self._F[key], "attempt to call method '"..key.."' (a nil value)");
                return self._F[key](self._F, ...)
            end
            wrapper_meta[key] = func
            return func
        end
    end

    --返回_F的对应属性, wrapper上没有任何内容
    return wrapper._F[key]
end

---使用wrapped对象赋值时, 如果被赋值的对象是一个wrapper, 则把其UnWrap后再赋值
---frame.texture = frame:CreateTexture(...) 此时会把texture对象真正的存到Frame中
wrapper_meta.__newindex = function(wrapper, key, value)
    if getmetatable(value)==wrapper_meta then
        wrapper._F[key] = value:un(); --释放自身的wrapper, 如果已经有局部变量保存了wrapper, 那么可能会出错, 那样应该使用f.x=wrapper()
    else
        wrapper._F[key] = value
    end
end

---通过wrapper("SetToolTip", ...)则可以直接调用该函数
---而wrapper()则相当于un()
wrapper_meta.__call = function(self, func, ...)
    if(func)then
        return self._F[func](self._F,...);
    else
        return self._F;
    end
end

--================================================================
-- 与封装相关的操作
--================================================================
---UnWrap, 同时清理wrapper对象，可供下次缓存用
function wrapper_meta:un()
    local f = self._F;
    f.__wrapper = nil;
    self._F = nil;
    if(#REUSE_WRAPPERS<MAX_REUSE) then
        table.insert(REUSE_WRAPPERS, self);
    end
    return f;
end

---返回上一次被屏蔽的调用结果
function wrapper_meta:Returned()
    assert(false, "This function is deprecated due to memory consideration.")
    return rawget(self, "_1"),rawget(self, "_2"),rawget(self, "_3"),rawget(self, "_4"),rawget(self, "_5")
end

---向上一层
function wrapper_meta:up()
    local _F = rawget(self, "_F");
    local parent = _F:GetParent();
    self:un(); --释放自身的wrapper,因为一般用到up的地方都是连续性的.
    local wrapped = WW:Wrap(parent);
    --parent.__wrapper = nil; --让父对象可以垃圾回收
    return wrapped;
end

--===============================================
-- 增加的便利方法
--===============================================

---同时设置高度和宽度
function wrapper_meta:SetSize(width, height)
    self._F:SetWidth(width)
    self._F:SetHeight(height or width)
    return self
end
wrapper_meta.Size = wrapper_meta.SetSize

--[[获取width, height
function wrapper_meta:GetSize()
    return self:GetWidth(), self:GetHeight()
end
]]

--调用On'Load'或其他, 例如On("Load"), On("Enter")
function wrapper_meta:On(script, ...)
    self._F:GetScript("On"..script)(self._F, ...)
    return self
end
function wrapper_meta:Load(script)
    return self:On("Load")
end

--增加FrameLevel, 如果不提供relative则是本身
function wrapper_meta:AddFrameLevel(delta, relative)
    relative = relative or self._F
    self._F:SetFrameLevel(relative:GetFrameLevel()+delta);
    return self;
end

---快速设置Backdrop
-- @param insets 如果是一个数字，则作为所有边的inset，如果是table：
--               如果提供全部四个参数值，将按左－右－上-下的顺序作用于四个边框。
--               如果提供两个，第一个用于左-右，第二个用于上-下。
function wrapper_meta:Backdrop(bgFile, edgeFile, edgeSize, insets, tileSize)
    local left, right, top, bottom, inset_obj
    if type(insets)=="number" then
        left=insets right=insets top=insets bottom=insets
    elseif type(insets)=="table" then
        if #insets==1 then
            left=insets[1] right=insets[1] top=insets[1] bottom=insets[1]
        elseif #insets==2 then
            left=insets[1] right=insets[1] top=insets[2] bottom=insets[2]
        elseif #insets==4 then
            left=insets[1] right=insets[2] top=insets[3] bottom=insets[4]
        else
            error("insets should have 1 or 2 or 4 elements.")
        end
    end
    inset_obj = {left=left, right=right, top=top, bottom=bottom}
    self:SetBackdrop({bgFile=bgFile, edgeFile=edgeFile, edgeSize=edgeSize, tile=(tileSize and true or nil), tileSize=tileSize, insets=inset_obj})
    return self
end

function wrapper_meta:SetBackdropBG(bgFile, tileSize)
    local backdrop = self._F:GetBackdrop() or {};
    backdrop.bgFile = bgFile;
    if tileSize then
        backdrop.tile = tileSize > 0;
        backdrop.tileSize = tileSize;
    end
    self._F:SetBackdrop(backdrop);
    return self;
end

function wrapper_meta:SetBackdropEdge(edgeFile, edgeSize, left, right, top, bottom)
    local backdrop = self._F:GetBackdrop() or {};
    backdrop.edgeFile = edgeFile;
    if(edgeSize)then backdrop.edgeSize = edgeSize end
    if(left)then
        backdrop.insets.left = left;
        backdrop.insets.right = right;
        backdrop.insets.top = top;
        backdrop.insets.bottom = bottom;
    end
    self._F:SetBackdrop(backdrop);
    return self;
end

--在没有ParentKey参数的时候用, 比如CreateTexture
function wrapper_meta:SetParentKey(key)
    local parent = self._F:GetParent()
    if parent then
        parent[key] = self._F
    end
    return self
end
wrapper_meta.Key=wrapper_meta.SetParentKey

--6.0新增的keyValue
function wrapper_meta:kv(key, value)
    self._F[key] = value
    return self
end

--Not to break the chain. Scroll:EditBox
function wrapper_meta:AddToScroll(scroll)
    if not scroll then scroll = self._F:GetParent() end
    scroll:SetScrollChild(self._F);
    return self;
end

-------------------------------------------------
-- SetPoint
-------------------------------------------------

local abbr_points = {
    ["TL"] = "TOPLEFT",
    ["BL"] = "BOTTOMLEFT",
    ["TR"] = "TOPRIGHT",
    ["BR"] = "BOTTOMRIGHT",
    ["T"] = "TOP",
    ["B"] = "BOTTOM",
    ["L"] = "LEFT",
    ["R"] = "RIGHT",
}
--1. relative支持$parent字符串
--2. relativePoint可省略, 跟point一样
function wrapper_meta:Point(point, relativeTo, relativePoint, x, y)
    if type(relativeTo)=="string" then
        if relativeTo=="$parent" then
            relativeTo = self._F:GetParent()
        else
            if relativeTo:find("%$parent") then
                local parentName = ""
                local parent = self._F:GetParent()
                while parent and not parent:GetName() do parent = parent:GetParent() end
                if parent and parent:GetName() then parentName = parent:GetName() end
                relativeTo = relativeTo:gsub("%$parent", parentName)
            end
            relativeTo = _G[relativeTo]
        end
        --[[ TODO: 同时支持SetPoint("LEFT", "$parent", 3, 4) 和SetPoint("LEFT", "RIGHT", 3, 4)
        if(type(relativeTo)~="table")then
            --这个参数是relativePoint
            y = x;
            x = relativePoint;
            relativePoint = relativeTo;
            relativeTo = self._F:GetParent();
        end
        --]]
    end

    if type(relativeTo)=="table" and type(relativePoint)=="number" then
        y = x
        x = relativePoint
        relativePoint = point
    end

    point = abbr_points[point] or point
    if(relativeTo==nil) then
        return self:SetPoint(point)
    else
        relativePoint = abbr_points[relativePoint] or relativePoint
        return self:SetPoint(point, relativeTo, relativePoint, x, y)
    end
end

function wrapper_meta:LEFT(...) return self:Point("LEFT", ...) end
function wrapper_meta:RIGHT(...) return self:Point("RIGHT", ...) end
function wrapper_meta:CENTER(...) return self:Point("CENTER", ...) end
function wrapper_meta:TOP(...) return self:Point("TOP", ...) end
function wrapper_meta:BOTTOM(...) return self:Point("BOTTOM", ...) end
function wrapper_meta:TOPLEFT(...) return self:Point("TOPLEFT", ...) end
function wrapper_meta:TOPRIGHT(...) return self:Point("TOPRIGHT", ...) end
function wrapper_meta:BOTTOMLEFT(...) return self:Point("BOTTOMLEFT", ...) end
function wrapper_meta:BOTTOMRIGHT(...) return self:Point("BOTTOMRIGHT", ...) end
wrapper_meta.TL = wrapper_meta.TOPLEFT
wrapper_meta.TR = wrapper_meta.TOPRIGHT
wrapper_meta.BL = wrapper_meta.BOTTOMLEFT
wrapper_meta.BR = wrapper_meta.BOTTOMRIGHT
function wrapper_meta:ALL(...) return self:SetAllPoints(...) end
function wrapper_meta:CLEAR(...) return self:ClearAllPoints(...) end

-------------------------------------------------
-- EditBox
-------------------------------------------------

--[[EditBox创建FontString对象的方法, 根本不用，只要SetFontObject(ChatFontNormal)即可
function wrapper_meta:CreateText(inherit, layer)
    assert(self:GetObjectType()=="EditBox", "Only EditBox can call this function");
    local font = self:CreateFontString(nil, layer, inherit):GetFontObject()
    self:SetFontObject(font)
    return self
end
]]

-------------------------------------------------
-- Button
-------------------------------------------------

--- EditBox创建FontString对象的方法
function wrapper_meta:SetButtonFont(font)
    if font then
        self._F:SetNormalFontObject(WW:un(font))
    end
    --Button必须调用SetText()后才能获取GetFontString()，而且不能设置空串
    if not self._F:GetFontString() then
        self._F:SetText(" ")
    end
    return self;
end

--- 用UIPanelButtonTemplate创建的带Text的Button
function wrapper_meta:SetTextFont(font, size, flag)
    if type(font) ~= "string" then
        font = font:GetFont()
    end
    self._F.Text:SetFont(font, size, flag)
    return self;
end

--- 获取封装好了的FontString()
function wrapper_meta:GetButtonText()
    return WW(self._F:GetFontString())
end

function wrapper_meta:AutoWidth()
    self._F:SetWidth(self._F:GetFontString():GetStringWidth()+(self._F.mid and 12 or 0));
    return self;
end

-------------------------------------------------
-- Font
-------------------------------------------------
function wrapper_meta:SetFontHeightAndFlags(height, flags)
    local f = self._F
    if f:GetObjectType()~="Font" and f:GetObjectType()~="FontString" then
        f = f:GetFontObject();
        assert(f and f:GetObjectType()=="Font", "Need a font object.");
    end
    local name, oldheight, oldflags = f:GetFont();
    f:SetFont(name, height or oldheight, flags or oldflags);
    return self;
end

function wrapper_meta:SetFontHeight(height)
    return self:SetFontHeightAndFlags(height, nil);
end

---MONOCHROME,OUTLINE,THICKOUTLINE
function wrapper_meta:SetFontFlags(flags)
    return self:SetFontHeightAndFlags(nil, flags);
end

---设置3种字体
function wrapper_meta:Set3Fonts(prefix)
    local f = self._F
    assert(f:GetObjectType()=="Button" or f:GetObjectType()=="CheckButton", "Need a button object.")
    local normal = prefix.."N" assert(_G[normal], format("Font %s not exists.", normal))
    local highlight = prefix.."H" assert(_G[highlight], format("Font %s not exists.", highlight))
    f:SetNormalFontObject(normal)
    f:SetHighlightFontObject(highlight)
    local disabled = prefix.."D"
    if disabled then
        f:SetDisabledFontObject(disabled)
    end
    return self
end

-------------------------------------------------
-- Texture
-------------------------------------------------

--- 设置材质文件名和TexCoord的快捷方法
function wrapper_meta:SetFile(str_texture, ...) --(left, right, top, bottom) or (ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
    self:SetTexture(str_texture)
    if ... then self:SetTexCoord(...) end --function a(...) if ... then print(... " ok") end end
    return self
end

--- 同时创建texture和设置材质, 注意参数顺序
function wrapper_meta:Texture(name, layer, str_texture, ...)
    return self:CreateTexture(name, layer):SetFile(str_texture, ...)
end

--- 旋转材质支持0, 90, -90, 180, "V", "H"
function wrapper_meta:SetTexRotate(angel)
    if angel==0 then
        self:SetTexCoord(0,0,0,1,1,0,1,1) --正常
    elseif angel==90 then
        self:SetTexCoord(0,1,1,1,0,0,1,0) --向右(顺时针)翻转90度
    elseif angel==180 or angel==-180 then
        self:SetTexCoord(1,1,1,0,0,1,0,0) --旋转180度
    elseif angel==270 or angel==-90 then
        self:SetTexCoord(1,0,0,0,1,1,0,1) --向左翻转90度
    elseif angel=="V" then
        self:SetTexCoord(0,1,0,0,1,1,1,0) --垂直翻转
    elseif angel=="H" then
        self:SetTexCoord(1,0,1,1,0,0,0,1) --水平翻转
    else
        error("can't rotate by angel: "..angel)
    end
    return self
end

--[[
Slider:SetThumbTexture(texture , str_layer) --or Slider:SetThumbTexture(str_filename , str_layer)
StatusBar:SetStatusBarTexture(texture , str_layer)
Button:SetDisabledTexture(texture) --or Button:SetDisabledTexture(str_filename)
Button:SetHighlightTexture(texture , str_mode)
Button:SetNormalTexture(texture)
Button:SetPushedTexture(texture)
CheckButton:SetCheckedTexture(texture)
CheckButton:SetDisabledCheckedTexture(texture)
CheckButton:SetDisabledTexture(texture)
CheckButton:SetHighlightTexture(texture , str_mode)
CheckButton:SetNormalTexture(texture)
CheckButton:SetPushedTexture(texture)
ColorSelect:SetColorValueTexture(texture)
ColorSelect:SetColorValueThumbTexture(texture)
ColorSelect:SetColorWheelTexture(texture)
ColorSelect:SetColorWheelThumbTexture(texture)
]]
--这些类型都用wrapped:Texture("file"):ToTexture("Highlight", str_mode)
-------------------------------------------------
local cacheToTexture = setmetatable({}, {__index=function(self, type) self[type]="Set"..type.."Texture" return self[type] end})
function wrapper_meta:ToTexture(type, ...)
    local parent = self._F:GetParent()
    parent[cacheToTexture[type]](parent, self._F, ...)
    return self
end

-- 方便在WOWLua里测试的
-- WW:Run(function(name, first) WW:Frame(name); if first then ... end end)
local hooksecureorigin, hookscriptorigin, hooks;
function WidgetWrapper:Run(func, name)
    hooks = hooks or {}; --保存所有测试Frame的hooks
    if self.LastRun then
        self.LastRun:Hide();
        if self.LastRun.UnregisterAllEvents then
            self.LastRun:UnregisterAllEvents();
            CoreUnregisterAllEvents(self.LastRun);
        end
        table.wipe(self.LastHook);
    end
    local name = name or "WidgetWrapperTestRun"..format("%x", random(999999999));

    --hook
    hooks[name] = {};

    hooksecureorigin = hooksecurefunc;
    hooksecurefunc = function(obj, fname, hook)
        if(type(obj)=="string") then
            table.insert(hooks[name], fname); --第二个参数是hook
        else
            table.insert(hooks[name], hook);
        end
        local id = #hooks[name];
        local newhook = function(...)
            if(hooks[name][id])then
                hooks[name][id](...)
            end
        end
        if(type(obj)=="string") then
            hooksecureorigin(obj, newhook);
        else
            hooksecureorigin(obj, fname, newhook)
        end
    end

    hookscriptorigin = getmetatable(UIParent).__index.HookScript;
    getmetatable(UIParent).__index.HookScript = function(self, handler, hook)
        table.insert(hooks[name], hook);
        local id = #hooks[name];
        local newhook = function(...)
            if(hooks[name][id])then
                hooks[name][id](...)
            end
        end
        hookscriptorigin(self, handler, newhook)
    end

    --call
    xpcall(function() return func(name, not self.NotFirst, self.LastName) end, geterrorhandler())

    --unhook
    getmetatable(UIParent).__index.HookScript = hookscriptorigin;
    hooksecurefunc = hooksecureorigin;

    self.LastName = name;
    self.LastRun = _G[name];
    self.LastHook = hooks[name];
    self.NotFirst = true;
end

WWRun = function(func, name) return WidgetWrapper:Run(func, name) end
