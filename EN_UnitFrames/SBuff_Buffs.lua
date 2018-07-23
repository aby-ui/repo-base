SBuff_Version = "3.11";

local SBuff_MAX_PARTY_BUFFS = 12;
local SBuff_MAX_PARTY_DEBUFFS = 8;
local SBuff_MAX_PET_BUFFS = 8;
local SBuff_MAX_PET_DEBUFFS = 8;

-- change system original variables
--MAX_PARTY_BUFFS = SBuff_MAX_PARTY_BUFFS;
--MAX_PARTY_DEBUFFS = SBuff_MAX_PARTY_DEBUFFS;

local function CreatePartyBuffs2()
	local i;
	for i = 1,4,1 do
		local buff;
		local party = "PartyMemberFrame"..i;
		local db;
		--Buff
		for j = 1, SBuff_MAX_PARTY_BUFFS, 1 do
			buff = CreateFrame("Button", party.."Buff"..j, getglobal(party), "PartyBuffFrameTemplate");
			buff:SetID(j);
			buff:ClearAllPoints();
			if j == 1 then
				buff:SetPoint("TOPLEFT", party, "TOPLEFT", 48, -32);
			else
				buff:SetPoint("LEFT", party.."Buff"..j-1, "RIGHT", 2, 0);
			end;
		end
		--Debuff
		db = getglobal(party.."Debuff1");
		db:ClearAllPoints();
		db:SetPoint("LEFT", party, "RIGHT",-7, 5);--Deubff位置
        --已有5个
		for j = 5, SBuff_MAX_PARTY_DEBUFFS, 1 do
			buff = CreateFrame("Button", party.."Debuff"..j, getglobal(party), "PartyDebuffFrameTemplate");
			buff:SetID(j);
			buff:ClearAllPoints();
			buff:SetPoint("LEFT", party.."Debuff"..j-1, "RIGHT", 2, 0);
		end
	end
end

local function PetDebuffOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetUnitDebuff(PetFrame.unit, self:GetID());
end

local function PetBuffOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetUnitBuff(PetFrame.unit, self:GetID());
end

local function CreatePetBuffs()
	--Buff
	for j = 1, SBuff_MAX_PET_BUFFS, 1 do
		local buff = CreateFrame("Button", "PetFrameBuff"..j, PetFrame, "PartyBuffFrameTemplate");
		buff:SetID(j);
		buff:ClearAllPoints();
		buff:SetScript("OnEnter",PetBuffOnEnter);
		if j == 1 then
			buff:SetPoint("TOPLEFT", "PetFrame", "TOPLEFT", 48, -42);
		else
			buff:SetPoint("LEFT", "PetFrameBuff"..j-1, "RIGHT", 2, 0);
		end;
	end
	--Debuff
	PetFrameDebuff1:ClearAllPoints();
	--PetFrameDebuff1:SetPoint("LEFT", "PetFrame", "RIGHT", -7, -5);
	PetFrameDebuff1:SetPoint("TOP", "PetFrameBuff1", "BOTTOM", 0, -2);
	for j = 5, SBuff_MAX_PET_DEBUFFS, 1 do
		local buff = CreateFrame("Button", "PetFrameDebuff"..j, PetFrame, "PartyDebuffFrameTemplate");
		buff:SetID(j);
		buff:ClearAllPoints();
		buff:SetScript("OnEnter",PetDebuffOnEnter);
		buff:SetPoint("LEFT", "PetFrameDebuff"..j-1, "RIGHT", 2, 0);
	end
end

--Create BuffFrame and DebuffFrame
CreatePartyBuffs2();
CreatePetBuffs();

--Hide BuffTooltip
local mg_showpartybuff = true
--safe, always the last function
SBuff_Orig_PartyMemberBuffTooltip_Update = PartyMemberBuffTooltip_Update;
PartyMemberBuffTooltip_Update = function(self)
	if not mg_showpartybuff then
		SBuff_Orig_PartyMemberBuffTooltip_Update(self)
	end
	return;
end

--Hook RefreshDebuffs func
--RefreshBuffs is safe to call
hooksecurefunc("RefreshDebuffs", function(frame, unit, numDebuffs, suffix, checkCVar)
	local name = frame:GetName();
	numDebuffs = numDebuffs or 4;
	if string.find(name, "^PartyMemberFrame%d$") then
		if mg_showpartybuff then
			RefreshBuffs(frame, unit, SBuff_MAX_PARTY_BUFFS);
		end
	elseif (name == "PetFrame") then
		RefreshBuffs(frame, unit, SBuff_MAX_PET_BUFFS);
	end
end)

function partybufftoggle(flag)
	mg_showpartybuff = flag
	for j=1,4 do
		if flag then
			RefreshBuffs(_G["PartyMemberFrame"..j], "party"..j, SBuff_MAX_PET_BUFFS)
		else
			for i=1,SBuff_MAX_PET_BUFFS do
				_G["PartyMemberFrame"..j.."Buff"..i]:Hide()
			end
		end
	end
end