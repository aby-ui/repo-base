local E, L, C = select(2, ...):unpack()
_G["OmniCD_E"] = E

function E:Counters()
	if ( IsAddOnLoaded("OmniCC") or IsAddOnLoaded("tullaCC") ) then
		self.OmniCC = true
	end
end

local unitFrameData = {
	--  [1] = AddOn name
	--  [2] = Party frame name -%d
	--  [3] = Party frame unit key
	--  [4] = Delay

	{   [1] = "VuhDo",
		[2] = "Vd1H",
		[3] = "raidid",
		[4] = 1,
	},
	{   [1] = "VuhDo-Panel2",
		[2] = "Vd2H",
		[3] = "raidid",
		[4] = 1,
	},
	{   [1] = "VuhDo-Panel3",
		[2] = "Vd3H",
		[3] = "raidid",
		[4] = 1,
	},
	{   [1] = "VuhDo-Panel4",
		[2] = "Vd4H",
		[3] = "raidid",
		[4] = 1,
	},
	{   [1] = "VuhDo-Panel5",
		[2] = "Vd5H",
		[3] = "raidid",
		[4] = 1,
	},
	{   [1] = "Grid2",
		[2] = "Grid2LayoutHeader1UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Aptechka",
		[2] = "NugRaid1UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "InvenRaidFrames3",
		[2] = "InvenRaidFrames3Group0UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Lime",
		[2] = "LimeGroup0UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Plexus",
		[2] = "PlexusLayoutHeader1UnitButton",
		[3] = "unit",
		[4] = 1,
	},
    {   [1] = "Grid",
   		[2] = "GridLayoutHeader1UnitButton",
   		[3] = "unit",
   		[4] = 1,
   	},
    {   [1] = "CompactRaid",
   		[2] = "CompactRaidPartyFrameParty",
   		[3] = "unit",
   		[4] = 1,
   	},
	{   [1] = "HealBot",
		[2] = "HealBot_Action_HealUnit",
		[3] = "unit",
		[4] = 1,
		[5] = 50,
	},
	{   [1] = "Cell",
		[2] = "CellPartyFrameMember",
		[3] = "unitid",
		[4] = 1,
	},
	{   [1] = "ElvUI",
		[2] = "ElvUF_PartyGroup1UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Tukui",
		[2] = "TukuiPartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "ShadowUF",
		[2] = "SUFHeaderpartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "ShadowUF-Raid",
		[2] = "SUFHeaderraidUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 50,
	},
	{   [1] = "ShadowUF-Raid1",
		[2] = "SUFHeaderraid1UnitButton", -- For Group 1 with 'Separate raid frames' enabled in SUF
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "ZPerl",
		[2] = "XPerl_party",
		[3] = "partyid",
		[4] = 1,
	},
	{   [1] = "PitBull4",
		[2] = "PitBull4_Groups_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "NDui",
		[2] = "oUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "KkthnxUI",
		[2] = "oUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "RUF",
		[2] = "oUF_RUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "ShestakUI",
		[2] = "oUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "ShestakUI-DPS",
		[2] = "oUF_PartyDPSUnitButton",
		[3] = "unit",
		[4] = 1,
	},
}

function E:SetActiveUnitFrameData()
	if self.customUF.enabled then
		local active = self.db.position.uf == "auto" and self.customUF.prio or self.db.position.uf
		local enabled = self.customUF.enabled[active]
		if enabled then
			self.customUF.frame = enabled.frame
			self.customUF.unit = enabled.unit
			self.customUF.delay = enabled.delay
			self.customUF.index = enabled.index
		end
		self.customUF.active = active
	end
end

function E:UnitFrames()
	self.customUF = {
		["optionTable"] = {
			auto = L["Auto"],
			blizz = "Blizzard",
		},
		["enabled"] = false, -- [86]
	}

	for i = 1, #unitFrameData do
		local unitFrame = unitFrameData[i]
		local name = unitFrame[1]
		local addonName = name:gsub("-.+", "")
		if _G[addonName] or IsAddOnLoaded(addonName) then
			self.customUF.enabled = self.customUF.enabled or {}
			self.customUF.enabled[name] = {
				["frame"] = unitFrame[2],
				["unit"] = unitFrame[3],
				["delay"] = unitFrame[4],
				["index"] = unitFrame[5] or 5,
			}

			self.customUF.optionTable[name] = name

			if not self.customUF.prio then
				self.customUF.prio = name
			end
		end
	end

	if self.customUF.enabled then -- retain db value if no UI is enabled
		for zone in pairs(self.CFG_ZONE) do
			local uf = self.DB.profile.Party[zone].position.uf
			if uf ~= "blizz" and not self.customUF.enabled[uf] then
				self.DB.profile.Party[zone].position.uf = "auto"
			end
		end

		self:SetActiveUnitFrameData()

		if not self.DB.global.disableElvMsg then
			--E.StaticPopup_Show("OMNICD_Elv_MSG")
		end

		self:SetPixelMult() -- set after addons load
	end
end

function E:LoadAddOns()
	self:Counters()
	self:UnitFrames()
    C_Timer.After(1, function() E:Refresh(true) end) --abyui
end

E.unitFrameData = unitFrameData
