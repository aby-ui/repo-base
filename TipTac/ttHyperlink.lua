local gtt = GameTooltip;

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
local ttHyperlink = tt:RegisterElement({},"Hyperlink");

-- Hyperlinks which are supported
local supportedHyperLinks = {
	item = true,
	spell = true,
	unit = true,
	quest = true,
	enchant = true,
	achievement = true,
	instancelock = true,
	talent = true,
	glyph = true,
};

--------------------------------------------------------------------------------------------------------
--                                              Scripts                                               --
--------------------------------------------------------------------------------------------------------

-- OnHyperlinkEnter
local function OnHyperlinkEnter(self,refString)
	local linkToken = refString:match("^([^:]+)");
	if (supportedHyperLinks[linkToken]) then
		--GameTooltip_SetDefaultAnchor(gtt,self);
        gtt:ClearAllPoints()
        gtt:SetOwner(self, "ANCHOR_CURSOR")
		gtt:SetHyperlink(refString);
	end
end

-- OnHyperlinkLeave
local function OnHyperlinkLeave(self)
	gtt:Hide();
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttHyperlink:OnLoad()
	cfg = TipTac_Config;
end

function ttHyperlink:OnApplyConfig(cfg)
	-- ChatFrame Hyperlink Hover -- Az: this may need some more testing, code seems wrong
	if (cfg.enableChatHoverTips or self.hookedHoverHyperlinks) then
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = _G["ChatFrame"..i];
			if (i == 1) and (cfg.enableChatHoverTips) and (not self.hookedHoverHyperlinks) then		-- Az: why only on first window?
				self["oldOnHyperlinkEnter"..i] = chat:GetScript("OnHyperlinkEnter");
				self["oldOnHyperlinkLeave"..i] = chat:GetScript("OnHyperlinkLeave");
				self.hookedHoverHyperlinks = true;
			end
			chat:SetScript("OnHyperlinkEnter",cfg.enableChatHoverTips and OnHyperlinkEnter or self["oldOnHyperlinkEnter"..i]);
			chat:SetScript("OnHyperlinkLeave",cfg.enableChatHoverTips and OnHyperlinkLeave or self["oldOnHyperlinkLeave"..i]);
		end
--		if (GuildBankMessageFrame) then
--			GuildBankMessageFrame:SetScript("OnHyperlinkEnter",cfg.enableChatHoverTips and OnHyperlinkEnter or nil);
--			GuildBankMessageFrame:SetScript("OnHyperlinkLeave",cfg.enableChatHoverTips and OnHyperlinkLeave or nil);
--		end
	end
end