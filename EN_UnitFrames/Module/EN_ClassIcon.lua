
local frames = {
    player = 'EUF_PlayerFramePortrait',
    target = 'EUF_TargetFramePortrait',
    party1 = 'EUF_PartyFrame1Portrait',
    party2 = 'EUF_PartyFrame2Portrait',
    party3 = 'EUF_PartyFrame3Portrait',
    party4 = 'EUF_PartyFrame4Portrait',
}
local icons = {}
for k, v in next, frames do
    icons[k] = v .. 'Icon'
end

local optionkey = {
	player = 'PLAYERCLASSICONSMALL',
	target = "TARGETCLASSICONSMALL",
	party1 = "PARTYCLASSICONSMALL",
	party2 = "PARTYCLASSICONSMALL",
	party3 = "PARTYCLASSICONSMALL",
	party4 = "PARTYCLASSICONSMALL",
}

function EUF_SetClass(_, unit)
    local frame = frames[unit]
    if(not frame) then return end
    frame = _G[frame]
    local icon = _G[icons[unit]]

    icon:SetTexCoord(0, 1, 0, 1)
    local _, class = UnitClass(unit)

    if(class and UnitIsPlayer(unit) and EUF_CurrentOptions and EUF_CurrentOptions[optionkey[unit]] == 1) then
        EUF_SetPortraitTexture(icon, class)
        frame:Show()
    else
        frame:Hide()
    end
end

function EUF_SetPortraitTexture(portrait, class)
	-- Set 8 class icon
	portrait:SetTexture("Interface\\WorldStateFrame\\Icons-Classes");
	local Coord = CLASS_BUTTONS[class];	
	portrait:SetTexCoord(Coord[1],Coord[2],Coord[3],Coord[4]);
end

function EUF_ClassIcon_Update(unit, iconType, value)
	if unit=="player" then
		if iconType=="Big" then			
		else
			if value == 0 then
				EUF_PlayerFramePortrait:Hide();
			else
				EUF_SetClass(PlayerPortrait, "player");
			end
		end
	elseif unit=="target" then
		if iconType=="Big" then			
		else
			if value == 0 then
				EUF_TargetFramePortrait:Hide();
			else
				EUF_SetClass(TargetFramePortrait, "target")
			end
		end
	elseif unit=="party" then
		if iconType=="Big" then		
		else
			for i = 1, MAX_PARTY_MEMBERS do
                local unit = 'party' ..i
                if(UnitName(unit)) then
					if value == 0 then
						getglobal("EUF_PartyFrame" .. i .. "Portrait"):Hide()
					else
						EUF_SetClass(getglobal("PartyMemberFrame" .. i .. "Portrait"), unit)
					end
				end
			end
		end
	end
end


CoreOnEvent('PLAYER_TARGET_CHANGED', function()
    return EUF_SetClass(nil, 'target')
end)
CoreOnEvent('GROUP_ROSTER_UPDATE', function()
    if(not IsInRaid())then
        for i = 1, 4 do
            EUF_SetClass(nil, 'party'..i)
        end
    end
end)

function EUF_FrameClassIcon_Update()	
	EUF_ClassIcon_Update("player", "Small", EUF_CurrentOptions["PLAYERCLASSICONSMALL"]);	
	EUF_ClassIcon_Update("target", "Small", EUF_CurrentOptions["PLAYERCLASSICONSMALL"]);	
	EUF_ClassIcon_Update("party", "Small", EUF_CurrentOptions["PARTYCLASSICONSMALL"]);
end

