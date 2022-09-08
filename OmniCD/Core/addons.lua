local E, L, C = select(2, ...):unpack()
_G["OmniCD_E"] = E

function E:Counters()
	if ( IsAddOnLoaded("OmniCC") or IsAddOnLoaded("tullaCC") ) then
		self.OmniCC = true
	end
end

local unitFrameData = {
	--  [1] = AddOn name
	--  [2] = Party frame name ex) GroupNum%dUnitNum(-%d)
	--  [3] = Party frame unit key
	--  [4] = Delay
	--  [5] = Max frame index
	--  [6] = Min frame index

	{   [1] = "VuhDo", -- toplevel
		[2] = "Vd%dH", -- panel# not group
		[3] = "raidid",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "Grid2",
		[2] = "Grid2LayoutHeader%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Grid2-Role",
		[2] = "Grid2LayoutHeader1UnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "Aptechka",
		[2] = "NugRaid%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "InvenRaidFrames3",
		[2] = "InvenRaidFrames3Group%dUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 5,
		[6] = 0, -- Group0 for party
	},
	{   [1] = "Lime",
		[2] = "LimeGroup%dUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 5,
		[6] = 0,
	},
	{   [1] = "Plexus",
		[2] = "PlexusLayoutHeader%dUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40, -- certain layout uses Header1 only
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
		[4] = 2,
		[5] = 50,
	},
	{   [1] = "Cell",
		[2] = "CellPartyFrameMember",
		[3] = "unitid",
		[4] = 1,
	},
	{
		[1] = "Cell-Raid",
		[2] = "CellRaidFrameMember",
		[3] = "unitid",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "ElvUI",
		[2] = "ElvUF_PartyGroup1UnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "ElvUI-Raid",
		[2] = "ElvUF_RaidGroup%dUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40, -- 'Raid Wide Sorting' uses RaidGroup1 only
	},
	{   [1] = "ElvUI-Raid40",
		[2] = "ElvUF_Raid40Group%dUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "Tukui",
		[2] = "TukuiPartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "Tukui-Raid",
		[2] = "TukuiRaidUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40,
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
		[5] = 40,
	},
	{   [1] = "ShadowUF-Raid1", -- 'Separate raid frames' option
		[2] = "SUFHeaderraid%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "ZPerl",
		[2] = "XPerl_party",
		[3] = "partyid",
		[4] = 1,
	},
	{   [1] = "ZPerl-Raid",
		[2] = "XPerl_Raid_Grp%dUnitButton",
		[3] = "partyid",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "PitBull4", -- no default raid frames
		[2] = "PitBull4_Groups_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40,
	},
	{   [1] = "NDui",
		[2] = "oUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "NDui-Raid",
		[2] = "oUF_Raid%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "KkthnxUI",
		[2] = "oUF_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{   [1] = "KkthnxUI-Raid",
		[2] = "oUF_Raid%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "RUF", -- uses Blizzard raid frames
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
	{
		[1] = "ShestakUI-Raid",
		[2] = "oUF_RaidHeal%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "ShestakUI-DPS-Raid",
		[2] = "oUF_RaidDPS%dUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "GW2_UI",
		[2] = "GwCompactPartyFrame",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "GW2_UI-Party",
		[2] = "GwPartyFrame",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "GW2_UI-Raid",
		[2] = "GwCompactRaidFrame",
		[3] = "unit",
		[4] = 1,
		[5] = 40
	},
	{
		[1] = "AltzUI",
		[2] = "Altz_PartyUnitButton",
		[3] = "unit",
		[4] = 1,
	},
	{
		[1] = "AltzUI-Raid-Healer",
		[2] = "Altz_HealerRaidUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40
	},
	{
		[1] = "AltzUI-Raid-DPS",
		[2] = "Altz_DpsRaidUnitButton",
		[3] = "unit",
		[4] = 1,
		[5] = 40
	},
	{
		[1] = "AshToAsh",
		[2] = "AshToAshUnit%dUnit",
		[3] = "unit",
		[4] = 1,
		[5] = 40
	},
	{
		[1] = "oUF_Ruri",
		[2] = "oUF_Raid%dUnitButton",
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
			self.customUF.minIndex = enabled.minIndex
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
		["enabled"] = false,
	}

	for i = 1, #unitFrameData do
		local unitFrame = unitFrameData[i]
		local name = unitFrame[1]
		local addonName = name:match("[^%-]+")
		if _G[addonName] or IsAddOnLoaded(addonName) then
			self.customUF.enabled = self.customUF.enabled or {}
			self.customUF.enabled[name] = {
				["frame"] = unitFrame[2],
				["unit"] = unitFrame[3],
				["delay"] = unitFrame[4],
				["index"] = unitFrame[5] or 5,
				["minIndex"] = unitFrame[6] or 1,
			}

			self.customUF.optionTable[name] = name

			if not self.customUF.prio then
				self.customUF.prio = name
			end
		end
	end

	if self.customUF.enabled then
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

		self:SetPixelMult()
	end
end

function E:LoadAddOns()
	self:Counters()
	self:UnitFrames()
    C_Timer.After(1, function() E:Refresh(true) end) --abyui
end

E.unitFrameData = unitFrameData
