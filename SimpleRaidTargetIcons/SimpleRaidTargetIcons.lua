-- Simple Raid Target Icons
--
--------------------------------
--                            --
-- Concept originally by Qzot --
--                            --
--------------------------------

local srti = {};
srti.version = GetAddOnMetadata("simpleraidtargeticons","version");


SRTI_HEADER = SRTI_TITLE .. " " .. srti.version;
SRTI_MSG_HELP_TEXT = SRTI_TITLE .. SRTI_MSG_HELP_TEXT;
BINDING_HEADER_SRTI_TITLE = SRTI_OPTIONS_BLZ_INTERFACE_PANEL_NAME;


local iconStrings = {
	none = 0,
	clear = 0,
	remove = 0,
	yellow = 1,
	star = 1,
	orange = 2,
	circle = 2,
	purple = 3,
	diamond = 3,
	green = 4,
	triangle = 4,
	silver = 5,
	moon = 5,
	blue = 6,
	square = 6,
	red = 7,
	x = 7,
	cross = 7,
	white = 8,
	skull = 8,
};

local iconNames = {
	"remove icon",
	"yellow star",
	"orange circle",
	"purple diamond",
	"green triangle",
	"silver moon",
	"blue square",
	"red cross",
	"white skull",
};

local thirdParty = {
	"PugLax",
}
local clickFrameScripts = {};
local clickFrames = {
	"WorldFrame",
	"TargetFrame",
	"FocusFrame",
	"Boss1TargetFrame",
	"Boss2TargetFrame",
	"Boss3TargetFrame",
	"Boss4TargetFrame",
	"Boss5TargetFrame",
};
local thirdPartyFrameScripts = {};

function srti.Print(msg)
	for text in string.gmatch(msg, "[^\n]+") do
		text = string.gsub(text,"%%1","|cffffcc00");
		text = string.gsub(text,"%%0(%S+)","|cff9999ff%1|r");
		DEFAULT_CHAT_FRAME:AddMessage(text,0.7,0.7,0.7);
	end
end

local function print(msg)
	srti.Print(msg);
end

function srti.PrintHelp()
	print(SRTI_MSG_HELP_TEXT);
	for i=0, 8 do
		local text = "";
		for string, index in pairs(iconStrings) do
			if ( index == i ) then
				text = text.." / %0"..string;
			end
		end

		print("  %0"..i..text.." - %1"..iconNames[i+1]);
	end
end

srti.defaults = {
	["ctrl"] = true,
	["alt"] = false,
	["shift"] = false,
	["singlehover"] = false,

	["double"] = true,
	["speed"] = 0.25,
	["radialscale"] = 1.0,
	["doublehover"] = false,

	["bindinghover"] = false,

	["hovertime"] = 0.2,
};

-- srti.frame
-- the main menu frame and event catcher

srti.frame = CreateFrame("button", "SRTIRadialMenu", UIParent);

srti.frame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
srti.frame:RegisterEvent("ADDON_LOADED");
srti.frame:RegisterEvent("PLAYER_LOGIN");
srti.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
srti.frame:RegisterEvent("PLAYER_TARGET_CHANGED");

srti.frame:SetFrameStrata("TOOLTIP");

srti.frame:SetWidth(100);
srti.frame:SetHeight(100);
srti.frame:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", 0, 0 );
srti.frame:SetClampedToScreen(true);

srti.frame:Hide();
srti.frame.origShow = srti.frame.Show;

function srti.frame:Show()
	srti.frame.p = srti.frame:CreateTexture("SRTIRadialMenuPortrait","BORDER");
	srti.frame.p:SetWidth(40);
	srti.frame.p:SetHeight(40);
	srti.frame.p:SetPoint("CENTER", srti.frame, "CENTER", 0, 0 );
	srti.frame.b = srti.frame:CreateTexture("SRTIRadialMenuBorder", "BACKGROUND");
	srti.frame.b:SetTexture("Interface\\Minimap\\UI-TOD-Indicator");
	srti.frame.b:SetWidth(80);
	srti.frame.b:SetHeight(80);
	srti.frame:SetScale(SRTISaved.radialscale or 1.0);
	srti.frame.b:SetTexCoord(0.5,1,0,1);
	srti.frame.b:SetPoint("CENTER", srti.frame, "CENTER", 10, -10 );
	for i=1, 8 do
		srti.frame[i] = srti.frame:CreateTexture("SRTIRadialMenu"..i,"OVERLAY");
	end

	srti.frame:origShow();
	srti.frame.Show = srti.frame.origShow;
	srti.frame.origShow = nil;

	srti.frame:SetScript("OnUpdate", 
		function(self, arg1)
			local portrait = srti.frame.portrait;
			srti.frame.portrait = nil;
			local saved, index = self.index, GetRaidTargetIndex("target");
			self.index = nil;
			if ( self.test ) then
				index = srti.menu.test.index or 0;
			end
			local curtime = GetTime();
			if ( not self.hiding ) then
				if ( self.test ) then
					SetPortraitTexture( srti.frame.p, "player" );
				elseif ( not UnitExists("target") or ( not UnitPlayerOrPetInRaid("target") and UnitIsDeadOrGhost("target") ) ) then -- check if we need same for UnitPlayerOrPetInParty("target")
					if ( portrait ) then
						self:Hide();
						return;
					else
						self.hiding = curtime;
					end
--[[disable by ghostduke	elseif ( portrait ) then
					if ( portrait == 0 and not ( UnitIsUnit("target","mouseover") or srti.nameplate) ) then -- temporarily disable for MoP beta
                                        	self:Hide();
						return;
					end
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
					SetPortraitTexture( srti.frame.p, "target" );
--]]		                end

				local x, y = GetCursorPosition();
				local s = srti.frame:GetEffectiveScale();
				local mx, my = srti.frame:GetCenter();
				x = x / s;
				y = y / s;

				local a, b = y - my, x - mx;

				local dist = floor(math.sqrt( a*a + b*b ));

				if ( dist > 60 ) then
					if ( dist > 200 ) then
						self.lingering = nil;
						self.hiding = curtime;
						self.showinghowing = nil;
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
					elseif ( not self.lingering ) then
						self.lingering = curtime;
					end
				else
					self.lingering = nil;

					if ( dist > 20 and dist < 50 ) then
						local pos = math.deg(math.atan2( a, b )) + 27.5;
						self.index = mod(11-ceil(pos/45),8)+1;
					end
				end

				for i=1, 8 do
					local t = self[i];
					if ( index == i ) then
						t:SetTexCoord(0,1,0,1);
						t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up");
					else
						-- check 3rd party modifications first
						local PugLax = IsAddOnLoaded("PugLax")
						if (PugLax and _G["PugLax"].CreateRaidIcon) and SRTISaved.PugLax then
							_G["PugLax"]:CreateRaidIcon(t,i)
						else
							t:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
							SetRaidTargetIconTexture(t,i);
						end
					end
				end

				if ( self.hovering ) then
					if ( self.index and ( not saved or saved == self.index ) ) then
						self.hovering = self.hovering + arg1;
						if ( self.hovering > ( SRTISaved.hovertime or 0.2 ) ) then
							self:Click();
						end
					else
						self.hovering = 0;
					end
				end
			end

			if ( self.showing ) then
				local status = curtime - self.showing;
				if ( status > 0.1 ) then
					srti.frame.p:SetAlpha(1);
					srti.frame.b:SetAlpha(1);
					for i=1, 8 do
						local t, radians = self[i], (0.375 - i/8) * 360;
						t:SetPoint("CENTER", self, "CENTER", 36*cos(radians), 36*sin(radians) );
						t:SetAlpha(0.5);
						t:SetWidth(18);
						t:SetHeight(18);
					end
					self.showing = nil;
				else
					status = status / 0.1;
					srti.frame.p:SetAlpha(status);
					srti.frame.b:SetAlpha(status);
					for i=1, 8 do
						local t, radians = self[i], (0.375 - i/8) * 360;
						t:SetPoint("CENTER", self, "CENTER", (20*status + 16)*cos(radians), (20*status + 16)*sin(radians) );
						if ( i == index ) then
							t:SetAlpha(status);
						else
							t:SetAlpha(0.5*status);
						end
						t:SetWidth(9*status + 9);
						t:SetHeight(9*status + 9);
					end
				end
			elseif ( self.hiding ) then
				local status = curtime - self.hiding;
				if ( status > 0.1 ) then
					self.hiding = nil;
					self:Hide();
				else
					status = 1 - status / 0.1;
					srti.frame.p:SetAlpha(status);
					srti.frame.b:SetAlpha(status);
					for i=1, 8 do
						local t, radians = self[i], (0.375 - i/8) * 360;
						if ( self.index == i ) then
							t:SetWidth(36-18*status);
							t:SetHeight(36-18*status);
							t:SetAlpha(min(4*status,1));
						else
							t:SetPoint("CENTER", self, "CENTER", (20*status + 16)*cos(radians), (20*status + 16)*sin(radians) );
							t:SetAlpha(0.75*status);
							t:SetWidth(18*status);
							t:SetHeight(18*status);
						end
					end
				end
			else
				for i=1, 8 do
					local t = self[i];
					if ( i == index ) then
						t:SetAlpha(1);
					else
						t:SetAlpha(0.75);
					end
					t:SetWidth(18);
					t:SetHeight(18);
				end
			end

			if ( self.index ) then
				local t = self[self.index];
				local alpha, width = t:GetAlpha(), t:GetWidth();

				if ( not self.time or saved ~= self.index ) then
					self.time = curtime;
				end
				local s = 1 + min( (curtime - self.time)/0.05, 1 );

				t:SetAlpha(min(alpha+0.125*s,1));
				t:SetWidth(width*s);
				t:SetHeight(width*s);
			end

			if ( self.lingering ) then
				local status = curtime - self.lingering;
				if ( status > 0.75 ) then
					self.hiding = curtime;
					self.lingering = nil
					self.showing = nil
					self.index = nil;
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
				end
			end
		end);

	srti.frame:SetScript("OnClick", function(self,arg1)
			if ( not self.hiding ) then
				local index = GetRaidTargetIndex("target");
				if ( self.test ) then
					index = srti.menu.test.index;
				end
				if ( ( arg1 == "RightButton" and index and index > 0 ) or ( self.index and self.index > 0 and self.index == index ) ) then
					self.index = index;
					PlaySound163("igMiniMapZoomOut");
					srti.SetRaidTarget(0);
				elseif ( self.index ) then
					PlaySound163("igMiniMapZoomIn");
					srti.SetRaidTarget(self.index);
				else
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
				end
				self.showing = nil;
				self.hiding = GetTime();
			end
		end
		);
end

function srti.UpdateSaved()
	if ( not SRTISaved ) then
		SRTISaved = {};
	end
	for k, v in pairs(srti.defaults) do
		if ( SRTISaved[k] == nil ) then
			SRTISaved[k] = v;
		end
	end
	if SRTISaved.thirdPartyFrames and next(SRTISaved.thirdPartyFrames) then -- clean up v1.2 structure if found
		SRTISaved.thirdPartyFrames = nil
	end
	SRTIExternalUF = SRTIExternalUF or {};
	srti.Options();
	srti.saved = SRTISaved;
end

local thirdPartyUF = {
	["XPerl"] = {"XPerl_Target","XPerl_Focus","XPerl_TargetTarget"},
	["Perl_Config"] = {"Perl_Target_NameFrame_CastClickOverlay","Perl_Target_StatsFrame_CastClickOverlay","Perl_Focus_NameFrame_CastClickOverlay",
		"Perl_Focus_StatsFrame_CastClickOverlay","Perl_Target_Target_StatsFrame_CastClickOverlay","Perl_Target_Target_NameFrame_CastClickOverlay"},
	["PitBull4"] = {"PitBull4_Frames_target","PitBull4_Frames_targettarget","PitBull4_Frames_focus","PitBull4_Frames_focustarget"},
	["ShadowedUnitFrames"] = {"SUFUnittarget","SUFUnittargettarget","SUFUnitfocus","SUFUnitfocustarget"},
	["Stuf"] = {"Stuf.units.target","Stuf.units.focus","Stuf.units.targettarget"},
}
srti.frame:SetScript("OnEvent", function(self,event,...)
	local addon = ...;
	if ( event == "ADDON_LOADED" ) then
		if addon == "SimpleRaidTargetIcons" then
			srti.UpdateSaved();
		end
		if thirdPartyUF[addon] then
			srti.RegisterExternalUFPrebuilt()
		end
		if SRTIExternalUF[strlower(addon)] then
			srti.AddExternalFrameScripts()
		end
	elseif ( event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" ) then
		srti.RegisterExternalUFPrebuilt()
		srti.AddExternalFrameScripts()
		self:UnregisterEvent("PLAYER_LOGIN")
	else
		if ( self:IsVisible() and not self.exists and not self.hiding ) then
			self.index = nil;
			self.showing = nil;
			self.hiding = GetTime();
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
			self.exists = nil;
		elseif ( self.exists ) then
			self.exists = nil;
		end
	end
end
);

function srti.ShowFromBinding()
	if ( not srti.frame:IsVisible() ) then
		local hovering = nil;
		if ( SRTISaved.bindinghover ) then
			hovering = 0;
		end
		if ( srti.menu and srti.menu:IsVisible() ) then
			srti.menu.test.ShowRadial(hovering);
		else
			srti.frame.hovering = hovering;
			srti.Show(1);
		end
	end
end

function srti.Show(frombinding)
	if SRTISaved.debug == nil then
		if IsInRaid() and not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return
		end
	end
	
	srti.frame.showing = GetTime();
	srti.frame.hiding = nil;
	srti.frame.index = nil;
	srti.frame.lingering = nil;
	srti.frame.test = nil;
--[[        local mFocus = GetMouseFocus();
if ( (not mFocus:GetAttribute("unit")))then
  ChatFrame1:AddMessage("There is no mouse enabled frame under the cursor")
else
  local name = mFocus:GetName() --or tostring(mFocus)
  ChatFrame1:AddMessage(name .. " has the mouse focus")
--  ChatFrame1:AddMessage(mFocus.id .. " has the mouse focus")
end
--]]
--king	if ( UnitExists("target") and (frombinding or UnitIsUnit("target","mouseover")) ) then
        if ( UnitExists("target") ) then
                if ( frombinding ) then
		   srti.frame.exists = nil;
	        else
                   srti.frame.exists = 1;
                end;
--                if ( not ( mFocus= ) ) then
--                    return;
--                end;
        else
	        return;	
	end;
	srti.frame.portrait = frombinding;
	local x,y = GetCursorPosition();
	local s = srti.frame:GetEffectiveScale();
	srti.frame:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", x/s, y/s );
	srti.frame:Show();
end

function srti.IsNameplateUnderMouse()
    do return end --163ui fix 7.2
	local numch = WorldFrame:GetNumChildren();
	if numch > 0 then
		for i=1,numch do
			local f=select(i,WorldFrame:GetChildren());
			if f:IsShown() and f:IsMouseOver() then
				-- 3rd party nameplate addons
				if f.aloftData then -- Aloft
					return 1;
				end
				if f.extended then -- TidyPlates
					return 1;
				end
				if f.done then -- caelNameplates + clones (shNameplates, ...)
					return 1;
				end
				if f.styled then -- rNameplates (zork)
					return 1;
				end
				if f.healthOriginal then -- dNameplates + eNameplates
					return 1;
				end
				if f.NPAHooked then -- NPA (NamePlatesAdvanced)
					return 1;
				end
				-- default nameplates
				-- 4.1
				local fname = f:GetName();
				if fname and string.find(fname, "NamePlate%d+") then
					return 1;
				end
			end
		end
	end
	return nil
end

function srti.AreModifiersDown()
	if ( not SRTISaved.ctrl and not SRTISaved.alt and not SRTISaved.shift ) then
		return ;
	elseif ( SRTISaved.ctrl and IsControlKeyDown() ) then
		return 1;
	elseif ( SRTISaved.alt and IsAltKeyDown() ) then
		return 1;
	elseif ( SRTISaved.shift and IsShiftKeyDown() ) then
		return 1;
	end
	return false;
end

local origSetRaidTarget = SetRaidTarget;
function srti.SetRaidTarget(index,unit,fromBinding)
	index = index or 0;
	if ( srti.frame.test ) then
		if ( index == 0 ) then
			srti.menu.test.icon:Hide();
			srti.menu.test.index = nil;
		else
			srti.menu.test.icon:Show();
			srti.menu.test.index = index;
			SetRaidTargetIconTexture(srti.menu.test.icon,index);
		end
		return;
	end

	if ( srti.frame:IsVisible() ) then
		srti.frame.i = index;
		srti.frame:Click();
	end
	if ( not fromBinding ) then
		origSetRaidTarget("target", index);
	end
end
hooksecurefunc("SetRaidTarget",function(unit,index) srti.SetRaidTarget(index,unit,1) end);

do
	for _,frameName in pairs(clickFrames) do
		clickFrameScripts[frameName] = _G[frameName]:GetScript("OnMouseUp")
		if not clickFrameScripts[frameName] and _G[frameName]:IsObjectType("Button") then
			_G[frameName]:RegisterForClicks("AnyUp");
		end
		_G[frameName]:SetScript("OnMouseUp", function(self,arg1) srti.OnMouseUp(self,arg1) end)
	end
end

function srti.AddExternalFrameScripts()
	SRTIExternalUF = SRTIExternalUF or {}
	for addon, frames in pairs(SRTIExternalUF) do
		for i,frameName in ipairs(frames) do
			if _G[frameName] then
				if not thirdPartyFrameScripts[frameName] then
					local mouseUp = _G[frameName]:GetScript("OnMouseUp")
					if not mouseUp and _G[frameName]:IsObjectType("Button") then
						_G[frameName]:RegisterForClicks("AnyUp")
					end
					_G[frameName]:SetScript("OnMouseUp", function(self,arg1) srti.OnMouseUp(self,arg1) end)
					thirdPartyFrameScripts[frameName] = true
					clickFrameScripts[frameName] = mouseUp
				end
			end
		end
	end
end

function srti.RegisterExternalUFPrebuilt()
	SRTIExternalUF = SRTIExternalUF or {}
	for addon, frames in pairs(thirdPartyUF) do
		for i, frameName in ipairs(frames) do
			srti.RegisterExternalFrame(frameName,addon,true)
		end
	end
end

function srti.RegisterExternalFrame(frameName, addon, prebuilt)
	-- validate
	local frameName = frameName or GetMouseFocus():GetName()
	if not frameName or not _G[frameName] or not _G[frameName]:IsMouseEnabled() then return end -- no frame, not a global frame or not mouse enabled
	if tContains(clickFrames,frameName) then return end
	if (not prebuilt) and (not UnitExists("mouseover")) then return end -- no mouseover unit, so probably not a unitframe at all
	-- check if already stored
	SRTIExternalUF = SRTIExternalUF or {}
	local found
	for addon, frames in pairs(SRTIExternalUF) do
		for i,frame in ipairs(frames) do
			if frame == frameName then
				found = true
				break
			end
		end
	end
	if found then return end
	-- check if addon to save frames under is loaded
	if addon and IsAddOnLoaded(strlower(addon)) then
		SRTIExternalUF[strlower(addon)] = SRTIExternalUF[strlower(addon)] or {}
		tinsert(SRTIExternalUF[strlower(addon)], frameName)
		srti.AddExternalFrameScripts()
		return
	end
	if not addon then
		-- static dialog to ask user to enter addonName
		StaticPopupDialogs["SRTI_GET_ADDON_NAME"] = StaticPopupDialogs["SRTI_GET_ADDON_NAME"] or {
			preferredIndex = 3,
			text = YELLOW_FONT_COLOR_CODE.."SRTI"..FONT_COLOR_CODE_CLOSE.."\nSelect the addon "..GREEN_FONT_COLOR_CODE.."%s"..FONT_COLOR_CODE_CLOSE.." belongs to.\nNavigate to your \\Interface\\AddOns\\ folder and check for Addon Name.",
			button1 = ACCEPT,
			button2 = CANCEL,
			hasEditBox = true,
			EditBoxOnEnterPressed = function(self) return self:GetParent().button1:Click() end,
			EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
			whileDead = true,
			hideOnEscape = true,
			timeout = 0,
			OnAccept = function(self,data)
				local addon = self.editBox:GetText()
				if addon and not IsAddOnLoaded(strlower(addon)) then
					srti.Print("No "..RED_FONT_COLOR_CODE..addon..FONT_COLOR_CODE_CLOSE.." addon found!")
					return true
				end
				if frameName and addon then
 					srti.RegisterExternalFrame(frameName, addon)
 				end
			end,
			OnShow = function(self,data)
				self.editBox:SetText(frameName)
			end,
		}
 		StaticPopup_Show("SRTI_GET_ADDON_NAME", frameName)
	end
end

function srti.OnMouseUp(frame, btn)
	if ( btn == "LeftButton" ) then
		local curtime = GetTime();
		local x, y = GetCursorPosition();
		local modifiers = srti.AreModifiersDown();
 		srti.nameplate = srti.IsNameplateUnderMouse()
		local double = ( SRTISaved.double and srti.click and curtime - srti.click < (SRTISaved.speed or 0.25) and abs(x-srti.clickX) < 20 and abs(y-srti.clickY) < 20 );
		if ( modifiers or double ) then
			if ( ( modifiers and SRTISaved.singlehover ) or ( double and SRTISaved.doublehover ) ) then
				srti.frame.hovering = 0;
			else
				srti.frame.hovering = nil;
			end
			srti.click = nil;
			srti.Show();
		else
			srti.click = curtime;
		end
		srti.clickX, srti.clickY = x, y;
	end
	if clickFrameScripts[frame:GetName()] then
		clickFrameScripts[frame:GetName()](frame,btn)
	end
end

SlashCmdList["SRTI"] = function(msg)
	msg = msg:lower();
	local num = tonumber(msg);
	if ( msg == "" ) then
		
                InterfaceOptionsFrame_OpenToCategory(srti.menu);
                InterfaceOptionsFrame_OpenToCategory(srti.menu);
	elseif ( num and num < 9 ) then
		srti.SetRaidTarget(num);
	elseif ( msg == "debug" ) then
		if ( SRTISaved.debug ) then
			SRTISaved.debug = nil;
		else
			SRTISaved.debug = 1;
		end
	else
		for string, index in pairs(iconStrings) do
			if ( msg == string ) then
				srti.SetRaidTarget(index);
				return;
			end
		end

		srti.PrintHelp();
	end
end

SLASH_SRTI1 = "/srti";

-- ugly quick hack to make old UIOptions style check box
local function CreateCheckBox(name, parent)
	local f = CreateFrame("CheckButton", name, parent, "OptionsCheckButtonTemplate")
	f:SetWidth(26)
	f:SetHeight(26)
	return f
end


function srti.Options()
        srti.menu = CreateFrame("FRAME","SRTIMenu",UIParent);
        srti.menu.name = SRTI_OPTIONS_BLZ_INTERFACE_PANEL_NAME;
        InterfaceOptions_AddCategory(srti.menu);
--	srti.menu:SetWidth(460);
--	srti.menu:SetHeight(31);
--	srti.menu:SetPoint("TOP",0,-100);
--	srti.menu:EnableMouse(1);
--	srti.menu:SetMovable(1);

--	tinsert(UISpecialFrames,"SRTIMenu");

	srti.menu:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 3, top = 3, bottom = 5 }
		});
	srti.menu:SetBackdropBorderColor(0.4, 0.4, 0.4);
	srti.menu:SetBackdropColor(0.15, 0.15, 0.15);

--	srti.menu.titleregion = srti.menu:CreateTitleRegion(srti.menu);
--	srti.menu.titleregion:SetAllPoints(srti.menu);
    --srti.menu:SetMovable(true)
    --srti.menu:RegisterForDrag('LeftButton')
    --srti.menu:SetScript('OnDragStart', function(f) f:StartMoving() end)
    --srti.menu:SetScript('OnDragStop', function(f) f:StopMovingOrSizing() end)


	srti.menu.title = srti.menu:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	srti.menu.title:SetText(SRTI_HEADER);
	srti.menu.title:SetPoint("TOPLEFT",srti.menu,"TOPLEFT",8,-8);

--	srti.menu.close = CreateFrame("BUTTON",nil,srti.menu,"UIPanelCloseButton");
--	srti.menu.close:SetPoint("TOPRIGHT",srti.menu,"TOPRIGHT");

	srti.menu.options = CreateFrame("FRAME","SRTIMenuOptions",srti.menu);
	srti.menu.options:SetWidth(292);
	srti.menu.options:SetHeight(488);
	srti.menu.options:SetPoint("TOPLEFT",srti.menu,"TOPLEFT",5,-30);
--	srti.menu.options:EnableMouse(1);
	srti.menu.options:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 3, top = 3, bottom = 5 }
		});
	srti.menu.options:SetBackdropBorderColor(0.4, 0.4, 0.4);
	srti.menu.options:SetBackdropColor(0.15, 0.15, 0.15);

	srti.menu.optionheader = srti.menu.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	srti.menu.optionheader:SetText(SRTI_OPTIONS_HEADER);
	srti.menu.optionheader:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",8,-8);


	srti.menu.options.singleframe = CreateFrame("FRAME",nil,srti.menu.options);
	srti.menu.options.singleframe:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT", 8, -40);
	srti.menu.options.singleframe:SetPoint("BOTTOMRIGHT",srti.menu.options,"TOPRIGHT", -8, -94);
	srti.menu.options.singleframe:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.menu.options.singleframe:SetBackdropBorderColor(0, 0, 0);
	srti.menu.options.singleframe:SetBackdropColor(0.1, 0.1, 0.1);

	srti.menu.singletext = srti.menu.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	srti.menu.singletext:SetText(SRTI_OPTIONS_SINGLE_HEADER);
	srti.menu.singletext:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-25);

	srti.menu.modifiertext = srti.menu.options.singleframe:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	srti.menu.modifiertext:SetText(SRTI_OPTIONS_SINGLE_MODIFIERS);
	srti.menu.modifiertext:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-49);

	srti.menu.shift = CreateCheckBox("SRTIcb3",srti.menu.options.singleframe);
	srti.menu.shift:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",82,-42);
	srti.menu.shift:SetHitRectInsets(0,-30,5,5);
	srti.menu.shift.option = "shift";
	SRTIcb3Text:SetText(SRTI_OPTIONS_SINGLE_SHIFT);

	srti.menu.ctrl = CreateCheckBox("SRTIcb1",srti.menu.options.singleframe);
	srti.menu.ctrl:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",142,-42);
	srti.menu.ctrl:SetHitRectInsets(0,-30,5,5);
	srti.menu.ctrl.option = "ctrl";
	SRTIcb1Text:SetText(SRTI_OPTIONS_SINGLE_CTRL);

	srti.menu.alt = CreateCheckBox("SRTIcb2",srti.menu.options.singleframe);
	srti.menu.alt:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",202,-42);
	srti.menu.alt:SetHitRectInsets(0,-30,5,5);
	srti.menu.alt.option = "alt";
	SRTIcb2Text:SetText(SRTI_OPTIONS_SINGLE_ALT);

	srti.menu.singlehover = CreateCheckBox("SRTIcb4",srti.menu.options.singleframe);
	srti.menu.singlehover:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",16,-66);
	srti.menu.singlehover:SetHitRectInsets(0,-130,5,5);
	srti.menu.singlehover.option = "singlehover";
	SRTIcb4Text:SetText(SRTI_OPTIONS_HOVER);


	srti.menu.options.doubleframe = CreateFrame("FRAME",nil,srti.menu.options);
	srti.menu.options.doubleframe:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT", 8, -113);
	srti.menu.options.doubleframe:SetPoint("BOTTOMRIGHT",srti.menu.options,"TOPRIGHT", -8, -194);
	srti.menu.options.doubleframe:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.menu.options.doubleframe:SetBackdropBorderColor(0, 0, 0);
	srti.menu.options.doubleframe:SetBackdropColor(0.1, 0.1, 0.1);

	srti.menu.doubletext = srti.menu.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	srti.menu.doubletext:SetText(SRTI_OPTIONS_DOUBLE_HEADER);
	srti.menu.doubletext:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-98);

	srti.menu.doublecb = CreateCheckBox("SRTIcb5",srti.menu.options.doubleframe);
	srti.menu.doublecb:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",16,-115);
	srti.menu.doublecb:SetHitRectInsets(0,-30,5,5);
	SRTIcb5Text:SetText(SRTI_OPTIONS_DOUBLE_ENABLE);

	srti.menu.doublehover = CreateCheckBox("SRTIcb6",srti.menu.options.doubleframe);
	srti.menu.doublehover:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",90,-115);
	srti.menu.doublehover:SetHitRectInsets(0,-130,5,5);
	srti.menu.doublehover.option = "doublehover";
	SRTIcb6Text:SetText(SRTI_OPTIONS_HOVER);

	srti.menu.doublespeed = CreateFrame("Slider","SRTIslider1",srti.menu.options.doubleframe,"OptionsSliderTemplate");
	srti.menu.doublespeed:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-160);
	srti.menu.doublespeed:SetPoint("TOPRIGHT",srti.menu.options,"TOPRIGHT",-18,-160);
	srti.menu.doublespeed:SetMinMaxValues(0.15,0.5);
	srti.menu.doublespeed:SetValueStep(0.01);
	srti.menu.doublespeed.option = "speed";
	SRTIslider1Low:SetText(SRTI_OPTIONS_DOUBLE_SPEED_MIN);
	SRTIslider1High:SetText(SRTI_OPTIONS_DOUBLE_SPEED_MAX);


	srti.menu.options.bindingframe = CreateFrame("FRAME",nil,srti.menu.options);
	srti.menu.options.bindingframe:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT", 8, -213);
	srti.menu.options.bindingframe:SetPoint("BOTTOMRIGHT",srti.menu.options,"TOPRIGHT", -8, -296);
	srti.menu.options.bindingframe:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.menu.options.bindingframe:SetBackdropBorderColor(0, 0, 0);
	srti.menu.options.bindingframe:SetBackdropColor(0.1, 0.1, 0.1);

	srti.menu.bindingtext = srti.menu.options:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	srti.menu.bindingtext:SetText(SRTI_OPTIONS_BINDING_HEADER);
	srti.menu.bindingtext:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-198);

	srti.menu.bindingkey1 = CreateFrame("Button","SRTIkb1",srti.menu.options.bindingframe,"UIPanelButtonTemplate")
	srti.menu.bindingkey1:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",16,-219);
	srti.menu.bindingkey1:SetWidth(220);
	srti.menu.bindingkey1:SetNormalFontObject(GameFontHighlightSmall);
	srti.menu.bindingkey1:SetHighlightFontObject(GameFontHighlightSmall);
	srti.menu.bindingkey1:SetScript("OnClick",function(self,arg1) srti.SetKeyBinding(arg1,"SRTI_SHOW",1) end);
	srti.menu.bindingkey1:RegisterForClicks("AnyUp")

	srti.menu.unbindingkey1 = CreateFrame("Button",nil,srti.menu.options.bindingframe);
	srti.menu.unbindingkey1:SetPoint("LEFT",srti.menu.bindingkey1,"RIGHT",-6,-1.5);
	srti.menu.unbindingkey1:SetWidth(32);
	srti.menu.unbindingkey1:SetHeight(32);
	--clear:SetHitRectInsets(9,7,-7,10);
	srti.menu.unbindingkey1:SetNormalTexture("Interface\\Buttons\\CancelButton-Up");
	srti.menu.unbindingkey1:SetPushedTexture("Interface\\Buttons\\CancelButton-Down");
	local h = srti.menu.unbindingkey1:CreateTexture(nil,"HIGHLIGHT");
	h:SetTexture("Interface\\Buttons\\CancelButton-Highlight");
	h:SetAllPoints();
	h:SetBlendMode("ADD");
	srti.menu.unbindingkey1:SetHighlightTexture(h);
	srti.menu.unbindingkey1:SetScript("OnClick",function(self, arg1) srti.SetKeyBinding(arg1,"SRTI_SHOW",1,1) end);

	srti.menu.bindingkey2 = CreateFrame("Button","SRTIkb2",srti.menu.options.bindingframe,"UIPanelButtonTemplate")
	srti.menu.bindingkey2:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",16,-242);
	srti.menu.bindingkey2:SetWidth(220);
	srti.menu.bindingkey2:SetNormalFontObject(GameFontHighlightSmall);
	srti.menu.bindingkey2:SetHighlightFontObject(GameFontHighlightSmall);
	srti.menu.bindingkey2:SetScript("OnClick",function(self, arg1) srti.SetKeyBinding(arg1,"SRTI_SHOW",2) end);
	srti.menu.bindingkey2:RegisterForClicks("AnyUp")

	srti.menu.unbindingkey2 = CreateFrame("Button",nil,srti.menu.options.bindingframe);
	srti.menu.unbindingkey2:SetPoint("LEFT",srti.menu.bindingkey2,"RIGHT",-6,-1.5);
	srti.menu.unbindingkey2:SetWidth(32);
	srti.menu.unbindingkey2:SetHeight(32);
	--clear:SetHitRectInsets(9,7,-7,10);
	srti.menu.unbindingkey2:SetNormalTexture("Interface\\Buttons\\CancelButton-Up");
	srti.menu.unbindingkey2:SetPushedTexture("Interface\\Buttons\\CancelButton-Down");
	h = srti.menu.unbindingkey2:CreateTexture(nil,"HIGHLIGHT");
	h:SetTexture("Interface\\Buttons\\CancelButton-Highlight");
	h:SetAllPoints();
	h:SetBlendMode("ADD");
	srti.menu.unbindingkey2:SetHighlightTexture(h);
	srti.menu.unbindingkey2:SetScript("OnClick",function(self, arg1) srti.SetKeyBinding(arg1,"SRTI_SHOW",2,1) end);

	srti.menu.bindinghover = CreateCheckBox("SRTIcb7",srti.menu.options.bindingframe);
	srti.menu.bindinghover:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",16,-268);
	srti.menu.bindinghover:SetHitRectInsets(0,-130,5,5);
	srti.menu.bindinghover.option = "bindinghover";
	SRTIcb7Text:SetText(SRTI_OPTIONS_HOVER);


	srti.menu.options.hoverframe = CreateFrame("FRAME",nil,srti.menu.options);
	srti.menu.options.hoverframe:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT", 8, -298);
	srti.menu.options.hoverframe:SetPoint("BOTTOMRIGHT",srti.menu.options,"TOPRIGHT", -8, -372);
	srti.menu.options.hoverframe:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.menu.options.hoverframe:SetBackdropBorderColor(0, 0, 0);
	srti.menu.options.hoverframe:SetBackdropColor(0.1, 0.1, 0.1);

	srti.menu.hovertime = CreateFrame("Slider","SRTIslider2",srti.menu.options,"OptionsSliderTemplate");
	srti.menu.hovertime:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-312);
	srti.menu.hovertime:SetPoint("TOPRIGHT",srti.menu.options,"TOPRIGHT",-18,-312);
	srti.menu.hovertime:SetMinMaxValues(0.0,0.5);
	srti.menu.hovertime:SetValueStep(0.05);
	srti.menu.hovertime.option = "hovertime";
	SRTIslider2Low:SetText(SRTI_OPTIONS_HOVER_TIME_MIN);
	SRTIslider2High:SetText(SRTI_OPTIONS_HOVER_TIME_MAX);

	srti.menu.radialscale = CreateFrame("Slider","SRTIsliderScale",srti.menu.options.doubleframe,"OptionsSliderTemplate");
	srti.menu.radialscale:SetPoint("TOPLEFT",srti.menu.options,"TOPLEFT",18,-340);
	srti.menu.radialscale:SetPoint("TOPRIGHT",srti.menu.options,"TOPRIGHT",-18,-340);
	srti.menu.radialscale:SetMinMaxValues(0.5,2.5);
	srti.menu.radialscale:SetValueStep(0.1);
	srti.menu.radialscale.option = "radialscale";
	SRTIsliderScaleLow:SetText(SRTI_OPTIONS_RADIAL_SCALE_MIN:format(0.5*100));
	SRTIsliderScaleHigh:SetText(SRTI_OPTIONS_RADIAL_SCALE_MAX:format(2.5*100));

	srti.menu.test = CreateFrame("FRAME",nil,srti.menu);
--	srti.menu.test:EnableMouse(1);
--	srti.menu.test:SetMovable(1);
	srti.menu.test:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 3, top = 3, bottom = 5 }
		});
	srti.menu.test:SetBackdropBorderColor(0.4, 0.4, 0.4);
	srti.menu.test:SetBackdropColor(0.15, 0.15, 0.15);
	srti.menu.test:SetPoint("TOPRIGHT",srti.menu,"TOPRIGHT",-5,-30);
	srti.menu.test:SetPoint("BOTTOMLEFT",srti.menu.options,"BOTTOMRIGHT",0,0);


	srti.menu.test.model = CreateFrame("PLAYERMODEL",nil,srti.menu.test);
	srti.menu.test.model:SetPoint("TOPRIGHT",srti.menu.test,"TOPRIGHT",-6,-6);
	srti.menu.test.model:SetPoint("BOTTOMLEFT",srti.menu.test,"BOTTOMLEFT",6,6);
	srti.menu.test.model:SetRotation(0.61);
	srti.menu.test.model:SetLight(true,false,-.5,-.2,-.6,0.5,1,1,1,1,1,1,0.8);
	srti.menu.test.model:SetScript("OnShow", function(self)
			srti.menu.test.model:SetPosition(0,0,0);
			srti.menu.test.model:SetUnit("player");
			srti.menu.test.model:SetPosition(0,0,-0.2);
		end
		);
	srti.menu.test.model:GetScript("OnShow")();

	srti.menu.test.icon = srti.menu.test.model:CreateTexture(nil,"OVERLAY");
	srti.menu.test.icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
	srti.menu.test.icon:SetWidth(42);
	srti.menu.test.icon:SetHeight(42);
	srti.menu.test.icon:SetPoint("TOP",srti.menu.test.model,"TOP",0,-2);
	srti.menu.test.icon:Hide();

	srti.menu.test.text = srti.menu.test.model:CreateFontString(nil,"OVERLAY","NumberFontNormal");
	srti.menu.test.text:SetText(SRTI_OPTIONS_TEST);
	srti.menu.test.text:SetPoint("TOP",srti.menu.test.icon,"BOTTOM");

	srti.menu.test.help = srti.menu.test:CreateFontString(nil,"ARTWORK","GameFontDisable");
	srti.menu.test.help:SetText(SRTI_OPTIONS_TEST_HELP);
	srti.menu.test.help:SetPoint("BOTTOM",srti.menu.test,"BOTTOM",0,8);
	srti.menu.test.help:SetPoint("LEFT",srti.menu.test,"LEFT",0,8);
	srti.menu.test.help:SetPoint("RIGHT",srti.menu.test,"RIGHT",0,-8);


	srti.menu.test.ShowRadial = function(hovering)
		srti.frame.hovering = hovering;
		srti.frame.showing = GetTime();
		srti.frame.hiding = nil;
		srti.frame.index = nil;
		srti.frame.lingering = nil;
		srti.frame.test = 1;
		srti.frame.portrait = nil;

		local x,y = GetCursorPosition();
		local s = srti.frame:GetEffectiveScale();
		srti.frame:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", x/s, y/s );
		srti.frame:Show();
	end

	srti.menu.test:SetScript("OnMouseUp",function(self, arg1)
		if ( arg1 == "LeftButton" ) then
			local time = GetTime();
			local x, y = GetCursorPosition();
			local modifiers = srti.AreModifiersDown();
			local double = ( SRTISaved.double and srti.click and time - srti.click < (SRTISaved.speed or 0.25) and abs(x-srti.clickX) < 20 and abs(y-srti.clickY) < 20 );
			if ( modifiers or double ) then
				if ( ( modifiers and SRTISaved.singlehover ) or ( double and SRTISaved.doublehover ) ) then
					srti.menu.test.ShowRadial(0);
				else
					srti.menu.test.ShowRadial();
				end
			else
				srti.click = time;
			end
			srti.clickX, srti.clickY = x, y;
		end
	end
	);
	
	-- prune addons that we support but are not actually loaded.
	-- DEBUG: addons with spaces in the name will create problems.
	-- revisit this part to add support for those at a later date.
	for i,addonname in ipairs(thirdParty) do
		if not IsAddOnLoaded(addonname) then
			tremove(thirdParty,i);
		end
	end
	-- add integration options for those that are.
	if next(thirdParty) then
		srti.menu.Modifer3RDCB = function(self)
			SRTISaved[self.option] = self:GetChecked() == 1;
		end;
		srti.menu.thirdparty = CreateFrame("FRAME",nil,srti.menu)
		srti.menu.thirdparty:EnableMouse(1);
		srti.menu.thirdparty:SetMovable(1);
		srti.menu.thirdparty:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 5, right = 3, top = 3, bottom = 5 }
			});
		srti.menu.thirdparty:SetBackdropBorderColor(0.4, 0.4, 0.4);
		srti.menu.thirdparty:SetBackdropColor(0.15, 0.15, 0.15);
		srti.menu.thirdparty:SetHeight(50);
		srti.menu.thirdparty:SetPoint("TOPLEFT",srti.menu.options,"BOTTOMLEFT",0,0);
		srti.menu.thirdparty:SetPoint("TOPRIGHT",srti.menu.test,"BOTTOMRIGHT",0,0);
		srti.menu.thirdpartytext = srti.menu.thirdparty:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
		srti.menu.thirdpartytext:SetText(SRTI_OPTIONS_3RDPARTY);
		srti.menu.thirdpartytext:SetPoint("TOPLEFT",srti.menu.thirdparty,"TOPLEFT",8,-8);
		-- todo: horizontal scrollframe this section
		for i,addonname in ipairs(thirdParty) do
			srti.menu.thirdparty.addonname = CreateCheckBox("SRTIcb"..addonname,srti.menu.thirdparty);
			if i == 1 then
				srti.menu.thirdparty.addonname:SetPoint("BOTTOMLEFT",srti.menu.thirdparty,"BOTTOMLEFT",8,5);
			else
				srti.menu.thirdparty.addonname:SetPoint("LEFT",srti.menu.thirdparty[thirdParty[i-1]],"RIGHT",(_G["SRTIcb"..thirdParty[i-1].."Text"]:GetStringWidth()+5),0);
			end
			srti.menu.thirdparty.addonname:SetHitRectInsets(0,-30,5,5);
			srti.menu.thirdparty.addonname.option = addonname
			_G["SRTIcb"..addonname.."Text"]:SetText(addonname);
			srti.menu.thirdparty.addonname:SetScript("OnClick", srti.menu.Modifer3RDCB)
		end
	end
	
	srti.menu.UpdateCB = function()
		if ( SRTISaved.ctrl or SRTISaved.alt or SRTISaved.shift ) then
			srti.menu.singletext:SetFontObject("GameFontHighlightSmall");
			srti.menu.modifiertext:SetFontObject("GameFontHighlightSmall");
			SRTIcb4Text:SetFontObject("GameFontNormalSmall");
		else
			srti.menu.singletext:SetFontObject("GameFontDisableSmall");
			srti.menu.modifiertext:SetFontObject("GameFontDisableSmall");
			SRTIcb4Text:SetFontObject("GameFontDisableSmall");
		end
	end;

	srti.menu.ModiferCB = function(self)
                if (self:GetChecked()) then
                   SRTISaved[self.option] = true;
                else
                   SRTISaved[self.option] = false;
                end;
		srti.menu.UpdateCB();
	end;

	srti.menu.UpdateDouble = function()
		if ( SRTISaved.double ) then
			srti.menu.doubletext:SetFontObject("GameFontHighlightSmall");
			SRTIslider1Text:SetFontObject("GameFontNormalSmall");
			SRTIslider1Low:SetFontObject("GameFontHighlightSmall");
			SRTIslider1High:SetFontObject("GameFontHighlightSmall");
			SRTIcb6Text:SetFontObject("GameFontNormalSmall");
		else
			srti.menu.doubletext:SetFontObject("GameFontDisableSmall");
			SRTIslider1Text:SetFontObject("GameFontDisableSmall");
			SRTIslider1Low:SetFontObject("GameFontDisableSmall");
			SRTIslider1High:SetFontObject("GameFontDisableSmall");
			SRTIcb6Text:SetFontObject("GameFontDisableSmall");
		end
	end;

	srti.menu.DoubleCB = function(self)
                if (self:GetChecked()) then
                   SRTISaved.double = true;
                else
                   SRTISaved.double = false;
                end;
		srti.menu.UpdateDouble();
	end;

	srti.menu.UpdateSlider = function()
		SRTIslider1Text:SetText(SRTI_OPTIONS_DOUBLE_SPEED:format(string.sub(SRTISaved.speed,1,4) or 0.25));
		SRTIslider2Text:SetText(SRTI_OPTIONS_HOVER_TIME:format(string.sub(SRTISaved.hovertime,1,4) or 0.2));
		SRTIsliderScaleText:SetText(SRTI_OPTIONS_RADIAL_SCALE:format(SRTISaved.radialscale and SRTISaved.radialscale*100 or 100));
	end;

	srti.menu.DoubleSlider = function(self)
		SRTISaved[self.option] = self:GetValue();
		srti.menu.UpdateSlider();
	end;
	
	srti.menu.ScaleSlider = function(self)
		SRTISaved[self.option] = self:GetValue()
		srti.frame:SetScale(SRTISaved[self.option] or 1.0);
		srti.menu.UpdateSlider();
	end;
	
	srti.menu.ctrl:SetScript("OnClick",srti.menu.ModiferCB);
	srti.menu.alt:SetScript("OnClick",srti.menu.ModiferCB);
	srti.menu.shift:SetScript("OnClick",srti.menu.ModiferCB);
	srti.menu.singlehover:SetScript("OnClick",srti.menu.ModiferCB);

	srti.menu.doublecb:SetScript("OnClick",srti.menu.DoubleCB);
	srti.menu.doublehover:SetScript("OnClick",srti.menu.ModiferCB);
	srti.menu.doublespeed:SetScript("OnValueChanged",srti.menu.DoubleSlider);
	srti.menu.hovertime:SetScript("OnValueChanged",srti.menu.DoubleSlider);
	srti.menu.radialscale:SetScript("OnValueChanged",srti.menu.ScaleSlider);

	srti.menu.bindinghover:SetScript("OnClick",srti.menu.ModiferCB);

	srti.menu.UpdateBindings = function()
		local binding1, binding2 = GetBindingKey("SRTI_SHOW");

		if ( binding1 ) then
			srti.menu.bindingkey1:SetText(GetBindingText(binding1, "KEY_"));
			srti.menu.bindingkey1:SetAlpha(1);
		else
			srti.menu.bindingkey1:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
			srti.menu.bindingkey1:SetAlpha(0.8);
		end
		if ( binding2 ) then
			srti.menu.bindingkey2:SetText(GetBindingText(binding2, "KEY_"));
			srti.menu.bindingkey2:SetAlpha(1);
		else
			srti.menu.bindingkey2:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
			srti.menu.bindingkey2:SetAlpha(0.8);
		end
	end;

	srti.menu.Update = function()
		srti.menu.ctrl:SetChecked(SRTISaved.ctrl);
		srti.menu.alt:SetChecked(SRTISaved.alt);
		srti.menu.shift:SetChecked(SRTISaved.shift);
		srti.menu.singlehover:SetChecked(SRTISaved.singlehover);

		srti.menu.doublespeed:SetValue(SRTISaved.speed);
		srti.menu.hovertime:SetValue(SRTISaved.hovertime);
		srti.menu.radialscale:SetValue(SRTISaved.radialscale);
		srti.menu.doublecb:SetChecked(SRTISaved.double);
		srti.menu.doublehover:SetChecked(SRTISaved.doublehover);
                srti.menu.bindinghover:SetChecked(SRTISaved.bindinghover);
		
		if next(thirdParty) then
			for i,addonname in pairs(thirdParty) do
				local checkbox = _G["SRTIcb"..addonname]
				if checkbox then
					checkbox:SetChecked(SRTISaved[checkbox.option] );
				end
			end
		end

		srti.menu.UpdateCB();
		srti.menu.UpdateSlider();
		srti.menu.UpdateDouble();
		srti.menu.UpdateBindings();
	end;

	srti.menu:SetScript("OnShow", srti.menu.Update);

	srti.menu.Update();

	srti.Options = function()
		if ( srti.menu:IsVisible() ) then
			srti.menu:Hide();
		else
			srti.menu:Show();
		end
	end
end



function srti.SetKeyBinding(button,binding,index,mode)
	srti.keybindings = CreateFrame("FRAME","SRTIKeyBindingsFrame",UIParent);
	srti.keybindings:EnableKeyboard(1);
	srti.keybindings:EnableMouse(1);
	srti.keybindings:EnableMouseWheel(1);
	srti.keybindings:SetFrameStrata("FULLSCREEN_DIALOG");
	srti.keybindings:SetAllPoints();

	srti.keybindings.bg = srti.keybindings:CreateTexture(nil,"BACKGROUND");
	srti.keybindings.bg:SetTexture(0.15,0.15,0.15);
	srti.keybindings.bg:SetAlpha(0.75);
	srti.keybindings.bg:SetAllPoints();

	srti.keybindings.frame = CreateFrame("FRAME",nil,srti.keybindings);
	srti.keybindings.frame:SetPoint("CENTER",srti.keybindings,"CENTER", 0, 50);
	srti.keybindings.frame:SetWidth(400);
	srti.keybindings.frame:SetHeight(100);
	srti.keybindings.frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.keybindings.frame:SetBackdropBorderColor(0, 0, 0);
	srti.keybindings.frame:SetBackdropColor(0.1, 0.1, 0.1);

	srti.keybindings.keytext = srti.keybindings.frame:CreateFontString(nil,"ARTWORK","GameFontHighlightLarge");
	srti.keybindings.keytext:SetPoint("CENTER");

	srti.keybindings.helptext = srti.keybindings.frame:CreateFontString(nil,"ARTWORK","GameFontNormal");
	srti.keybindings.helptext:SetPoint("TOP",srti.keybindings.frame,"TOP",0,-4);

	srti.keybindings.warntext = srti.keybindings.frame:CreateFontString(nil,"ARTWORK","GameFontNormal");
	srti.keybindings.warntext:SetPoint("BOTTOM",srti.keybindings.frame,"BOTTOM",0,4);

	srti.keybindings.acceptframe = CreateFrame("FRAME",nil,srti.keybindings.frame);
	srti.keybindings.acceptframe:SetPoint("TOP",srti.keybindings.frame,"BOTTOM", 0, 0);
	srti.keybindings.acceptframe:SetWidth(400);
	srti.keybindings.acceptframe:SetHeight(28);
	srti.keybindings.acceptframe:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
	srti.keybindings.acceptframe:SetBackdropBorderColor(0, 0, 0);
	srti.keybindings.acceptframe:SetBackdropColor(0.1, 0.1, 0.1);

	srti.keybindings.esctext = srti.keybindings.acceptframe:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	srti.keybindings.esctext:SetPoint("CENTER",srti.keybindings.acceptframe,"CENTER",0);
	srti.keybindings.esctext:SetText(SRTI_BINDINGS_ESC);

	srti.keybindings.accept = CreateFrame("BUTTON",nil,srti.keybindings.acceptframe,"UIPanelButtonTemplate");
	srti.keybindings.accept:SetPoint("RIGHT",srti.keybindings.acceptframe,"RIGHT",-2,0);
	srti.keybindings.accept:SetText(ACCEPT);
	srti.keybindings.accept:SetWidth(80);
	srti.keybindings.accept:SetHeight(22);
	srti.keybindings.accept:Disable();

	srti.keybindings.accept:SetScript("OnClick", function(self,arg1)
			srti.keybindings:Hide();
			if ( srti.keybindings.mode ) then
				if ( srti.keybindings.key ) then
					SetBinding(srti.keybindings.key);
				end
			elseif ( srti.keybindings.key and srti.keybindings.binding ) then
				local key1, key2 = GetBindingKey(srti.keybindings.binding);
				if ( key1 ) then
					SetBinding(key1);
				end
				if ( key2 ) then
					SetBinding(key2);
				end
				if ( srti.keybindings.index == 1 ) then
					SetBinding(srti.keybindings.key, srti.keybindings.binding);
					if ( key2 ) then
						SetBinding(key2, srti.keybindings.binding);
					end
				else
					if ( key1 ) then
						SetBinding(key1, srti.keybindings.binding);
					end
					SetBinding(srti.keybindings.key, srti.keybindings.binding);
				end
			end
			SaveBindings(GetCurrentBindingSet());
			srti.menu.UpdateBindings();
		end);

	function srti.keybindings.OnShow(self)
		if ( srti.keybindings.mode ) then
			if ( not srti.keybindings.key ) then
				srti.keybindings:Hide();
			end
			srti.keybindings.helptext:SetText(format(SRTI_BINDINGS_UNBIND_HELP, GetBindingText(binding, "BINDING_NAME_")));
			srti.keybindings.keytext:SetText(srti.keybindings.key);
			srti.keybindings.warntext:SetText("");
			srti.keybindings.accept:Enable();
		else
			srti.keybindings.helptext:SetText(format(SRTI_BINDINGS_BIND_HELP, GetBindingText(binding, "BINDING_NAME_")));
			srti.keybindings.keytext:SetText(srti.keybindings.key or NOT_BOUND);
			srti.keybindings.warntext:SetText("");
			if ( srti.keybindings.key ) then
				srti.keybindings.accept:Enable();
			else
				srti.keybindings.accept:Disable();
			end
		end
	end

	function srti.keybindings.OnKeyDown(key)
		local screenshotKey = GetBindingKey("SCREENSHOT");
		if ( screenshotKey and key == screenshotKey ) then
			Screenshot();
			return;
		end
		if ( key=="ESCAPE" ) then
			srti.keybindings:Hide();
		elseif ( not srti.keybindings.mode and key ~= "LeftButton" and key ~= "RightButton" and key ~= "SHIFT" and key ~= "ALT" and key ~= "CTRL" and key ~= "UNKNOWN" ) then
			srti.keybindings.OnShow();
			if ( key == "MiddleButton" ) then
				key = "BUTTON3";
			elseif ( key == "Button4" ) then
				key = "BUTTON4"
			elseif ( key == "Button5" ) then
				key = "BUTTON5"
			end
			if ( srti.keybindings.modifier ) then
				if IsLeftShiftKeyDown() then
					key = "LSHIFT-"..key
				end
				if IsLeftAltKeyDown() then
					key = "LALT-"..key
				end
				if IsLeftControlKeyDown() then
					key = "LCTRL-"..key
				end
				if IsRightShiftKeyDown() then
					key = "RSHIFT-"..key
				end
				if IsRightAltKeyDown() then
					key = "RALT-"..key
				end
				if IsRightControlKeyDown() then
					key = "RCTRL-"..key
				end
			else
				if IsShiftKeyDown() then
					key = "SHIFT-"..key
				end
				if IsAltKeyDown() then
					key = "ALT-"..key
				end
				if IsControlKeyDown() then
					key = "CTRL-"..key
				end
			end

			srti.keybindings.keytext:SetText( key );
			srti.keybindings.key = key;
			srti.keybindings.accept:Enable()

			local oldAction = GetBindingAction(key);
			if ( oldAction ~= "" and oldAction ~= srti.keybindings.binding ) then
				local oldkeys = select("#",GetBindingKey(oldAction));
				if ( oldkeys > 1 ) then
					srti.keybindings.warntext:SetText(format(SRTI_BINDINGS_BIND_WARN, GetBindingText(oldAction, "BINDING_NAME_")));
				else
					srti.keybindings.warntext:SetText(format(SRTI_BINDINGS_BIND_WARN_UNBOUND, GetBindingText(oldAction, "BINDING_NAME_")));
				end
			end
		end
	end

	srti.keybindings:SetScript("OnKeyDown", function(self, arg1) srti.keybindings.OnKeyDown(arg1) end);
	srti.keybindings:SetScript("OnMouseUp", function(self, arg1) srti.keybindings.OnKeyDown(arg1) end);
	srti.keybindings:SetScript("OnMouseWheel", function(self, arg1)
			if ( arg1 > 0 ) then
				srti.keybindings.OnKeyDown("MOUSEWHEELUP")
			else
				srti.keybindings.OnKeyDown("MOUSEWHEELDOWN")
			end
		end);

	srti.SetKeyBinding = function(button,binding,index,mode)
		srti.keybindings.binding = binding or "SRTI_SHOW";
		srti.keybindings.index = index or 1;
		srti.keybindings.key = select(srti.keybindings.index,GetBindingKey(srti.keybindings.binding));
		srti.keybindings.mode = mode;

		srti.keybindings.accept:Disable();
		srti.keybindings:Show();
		srti.keybindings.OnShow();
		srti.keybindings.OnKeyDown(button);
	end;

	srti.SetKeyBinding(button, binding, index, mode);
end

SRTI = srti;
