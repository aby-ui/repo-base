local MOGUScale_dbdf11f5b07258936fb1c5a31eaa969c = 1;
local MOGUScale_1b5523f0adb45c4b8ee51f89ebf6f2b2 = 0;
local BScale = {};
local function MOGUScale_391d78be8cd75f94fdabb3c3607320f6(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_1346009d8936868590c1d007e3efcfae)
    MOGUScale_1346009d8936868590c1d007e3efcfae = MOGUScale_1346009d8936868590c1d007e3efcfae or UIParent;
    local MOGUScale_4e0a062a388e29d4bf2e9c2dba5d6d18 = MOGUScale_1346009d8936868590c1d007e3efcfae:GetRight() / MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetScale();
    local MOGUScale_4845dcb186992213ddd66d11d248ca10 = MOGUScale_1346009d8936868590c1d007e3efcfae:GetTop() / MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetScale();
    local MOGUScale_0273923d6c5c6a7963a964a97885cb41 = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetRight();
    local MOGUScale_4d1cba81a5f3aaeb91e0bbb6dd482b32 = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetTop();
    local MOGUScale_05046f3bd52e7289c52881d983bc7179 = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetLeft();
    local MOGUScale_79af1dd4b579612573bca88bd9393bca = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetBottom();
    if (MOGUScale_0273923d6c5c6a7963a964a97885cb41 and MOGUScale_4d1cba81a5f3aaeb91e0bbb6dd482b32 and MOGUScale_05046f3bd52e7289c52881d983bc7179 and MOGUScale_79af1dd4b579612573bca88bd9393bca) then
        local MOGUScale_b254e387cf58e982ba24fcb3e8a63995 = (MOGUScale_0273923d6c5c6a7963a964a97885cb41 > MOGUScale_4e0a062a388e29d4bf2e9c2dba5d6d18 and (MOGUScale_4e0a062a388e29d4bf2e9c2dba5d6d18 - MOGUScale_0273923d6c5c6a7963a964a97885cb41)) or (MOGUScale_05046f3bd52e7289c52881d983bc7179 < 0 and (0 - MOGUScale_05046f3bd52e7289c52881d983bc7179)) or 0;
        local MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf = (MOGUScale_4d1cba81a5f3aaeb91e0bbb6dd482b32 > MOGUScale_4845dcb186992213ddd66d11d248ca10 and (MOGUScale_4845dcb186992213ddd66d11d248ca10 - MOGUScale_4d1cba81a5f3aaeb91e0bbb6dd482b32)) or (MOGUScale_79af1dd4b579612573bca88bd9393bca < 0 and (0 - MOGUScale_79af1dd4b579612573bca88bd9393bca)) or 0;
        MOGUScale_b254e387cf58e982ba24fcb3e8a63995 = (MOGUScale_b254e387cf58e982ba24fcb3e8a63995 + MOGUScale_05046f3bd52e7289c52881d983bc7179);
        MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf = (MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf + MOGUScale_4d1cba81a5f3aaeb91e0bbb6dd482b32);
        if (MOGUScale_b254e387cf58e982ba24fcb3e8a63995 ~= 0 or MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf ~= 0) then
            MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:SetPoint("TOPLEFT", MOGUScale_1346009d8936868590c1d007e3efcfae, "BOTTOMLEFT", MOGUScale_b254e387cf58e982ba24fcb3e8a63995, MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf);
        end
    end
end

function BScale:SetPoint(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_7dce5c33f0d4836b30c14f18b2fc43f7, MOGUScale_ca419ffef1b6a70d3765ee23720dcdb7, relativePoint, MOGUScale_b0e97041a98efeaf027801ac5f63b882, MOGUScale_fc1a2e8123dbe055ed6fd6d145898303)
    local MOGUScale_1346009d8936868590c1d007e3efcfae = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetParent() or UIParent;
    MOGUScale_b0e97041a98efeaf027801ac5f63b882 = MOGUScale_b0e97041a98efeaf027801ac5f63b882 / MOGUScale_1346009d8936868590c1d007e3efcfae:GetScale();
    MOGUScale_fc1a2e8123dbe055ed6fd6d145898303 = MOGUScale_fc1a2e8123dbe055ed6fd6d145898303 / Parnet:GetScale();
    MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:SetPoint(MOGUScale_7dce5c33f0d4836b30c14f18b2fc43f7, MOGUScale_ca419ffef1b6a70d3765ee23720dcdb7, relativePoint, MOGUScale_b0e97041a98efeaf027801ac5f63b882, MOGUScale_fc1a2e8123dbe055ed6fd6d145898303);
    MOGUScale_391d78be8cd75f94fdabb3c3607320f6(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_1346009d8936868590c1d007e3efcfae);
end

local function MOGUScale_e850d39c00b42c6c8a2873ebee73e4a5(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_6188847d8059cc6f73041de255401a71)
    if (not (MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetTop() and MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetLeft())) then
        return nil;
    end
    local MOGUScale_b254e387cf58e982ba24fcb3e8a63995 = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetLeft() * MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetScale() / MOGUScale_6188847d8059cc6f73041de255401a71;
    local MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf = MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetTop() * MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:GetScale() / MOGUScale_6188847d8059cc6f73041de255401a71;
    return MOGUScale_b254e387cf58e982ba24fcb3e8a63995, MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf;
end

function BScale:SetScale(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_6188847d8059cc6f73041de255401a71)
    assert(type(MOGUScale_6188847d8059cc6f73041de255401a71) == "number", "Invalid <scale>, the type of scale must be number.");
    local MOGUScale_b254e387cf58e982ba24fcb3e8a63995, MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf = MOGUScale_e850d39c00b42c6c8a2873ebee73e4a5(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a, MOGUScale_6188847d8059cc6f73041de255401a71);
    MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:SetScale(MOGUScale_6188847d8059cc6f73041de255401a71);
    MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:ClearAllPoints();
    MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", MOGUScale_b254e387cf58e982ba24fcb3e8a63995, MOGUScale_a0f453fd098c0b0fda780f69cda6ffbf);
    MOGUScale_391d78be8cd75f94fdabb3c3607320f6(MOGUScale_411b8aa6d5954c6020f0b9c9e80e847a);
end

function BScale:StartScaling(button)
    if (button == "LeftButton") then
        self.frame:LockHighlight();
        local frame = self.frame:GetParent();
        self.FrameToScale = frame;
        self.ScalingWidth = frame:GetWidth();
        local oldscale, framescale = frame:GetEffectiveScale(), frame:GetScale();
        local topleftX, cursorX = frame:GetLeft() * oldscale, GetCursorPosition();
        self.ScaleX = TrinketMenu.ScalingWidth * framescale / (cursorX - topleftX);
        self.frame.updateframe:Show();
    end
end

function BScale:StopScaling(button)
    if (button == "LeftButton") then
        self.frame.updateframe:Hide();
        self.frame:UnlockHighlight();
        self.scale = self.FrameToScale:GetScale();
        self.FrameToScale = nil
    end
end

function BScale:Scaling()
    local frame = self.FrameToScale;
    local oldscale = frame:GetEffectiveScale();
    local frameX, cursorX = frame:GetLeft() * oldscale, GetCursorPosition();
    cursorX = frameX + (cursorX - frameX) * self.ScaleX;
    if ((cursorX - frameX) > self.minwidth) then
        local newscale = (cursorX - frameX) / self.ScalingWidth;
        self:SetScale(frame, newscale);
    end
end

function BScale:Create(parent, width, height, minwidth)
    assert(type(parent) == "table", "BScale: The frame to scale must be a UI Object.");
    assert(type(width) == "number", "BScale: The parameter width must be a number vale.");
    assert(type(height) == "number", "BScale: The parameter height must be a number vale.");
    local minwidth = type(minwidth) == "number" and minwidth or 32;
    slef.minwidth = minwidth;
    self.frame = CreateFrame("Button", parent:GetName() .. "Resize", parent);
    self.frame:SetNormalTexture("Interface\\AddOns\\MOGU\\Library\\Artworks\\ResizeButton");
    self.frame:SetHighlightTexture("Interface\\AddOns\\MOGU\\Library\\Artworks\\ResizeButton");
    self.frame:SetWidth(width);
    self.frame:SetHeight(height);
    self.frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0);
    self.frame.updateframe = CreateFrame("Frame", nil, self.frame);
    self.scale = 1;
    self.frame:SetScript("OnLoad", function(self)
        self:SetFrameLevel(self:GetFrameLevel() + 2);
    end);
    self.frame:SetScript("OnMouseDown", function(self, button)
        BScale:StartScaling(button);
    end);
    self.frame:SetScript("OnMouseUp", function(self, button)
        BScale:StopScaling(button);
    end);
    self.frame.updateframe:SetScript("OnUpdate", function(self)
        BScale:Scaling();
    end);
end

function BScale:InitScale(scale)
    if (self.frame) then
        self:SetScale(self.frame:GetParent(), scale);
    end
end

function BScale:GetScale()
    if (self.frame) then
        return self.scale;
    else
        return nil;
    end
end

function BScale:ClearAllPoints()
    if (self.frame) then
        self.frame:ClearAllPoints();
    end
end

function BScale:SetPoint(...)
    if (self.frame) then
        self.frame:SetPoint(...);
    end
end

function BScale:SetWidth(width)
    if (self.frame) then
        self.frame:SetWidth(width);
    end
end

function BScale:SetHeight(height)
    if (self.frame) then
        self.frame:SetHeight(height);
    end
end

function BScale:constructor(parent, width, height, minwidth)
    if (parent and width and height) then
        self:Create(parent, width, height);
    end
end

BLibrary:Register(BScale, "BScale", MOGUScale_dbdf11f5b07258936fb1c5a31eaa969c, MOGUScale_1b5523f0adb45c4b8ee51f89ebf6f2b2);
