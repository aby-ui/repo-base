local LowHealthWarnings = {
	["player"] = false,
	["target"] = false
};

local UNIT_MODELS = {
	["player"] = "EUF_3DPortrait_PlayerModel",
	["target"] = "EUF_3DPortrait_TargetModel"
}

local UNIT_PORTRAITS = {
	["player"] = "PlayerPortrait",
	["target"] = "TargetFramePortrait",
}

function EUF_3DPortrait_OnLoad(self)	
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("GROUP_ROSTER_UPDATE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	self:RegisterEvent("UNIT_HEALTH");
end
-------------------
-- 3D头像关闭时不在执行OnUpdate
function EUF_3DPortrait_OnUpdate()	
	if EUF_CurrentOptions["3DPORTRAIT"] == 1  then
		EUF_3DPortrait_Show3D=EUF_CurrentOptions["3DPORTRAIT"]
		EUF_3DPortrait_PlayerFrame:Show();		
		EUF_3DPortrait_Update3D("player");
		EUF_3DPortrait_TargetFrame:Show();
		EUF_3DPortrait_Update3D("target");
	else		
		PlayerPortrait:Show();
		EUF_3DPortrait_PlayerFrame:Hide();
		TargetFramePortrait:Show();
		EUF_3DPortrait_TargetFrame:Hide();
	end
end

function EUF_3DPortrait_Update3D(unit)
	local model = getglobal(UNIT_MODELS[unit]);
	model:ClearModel();
	model:SetUnit(unit);
	--默认camera是全身，如果设置0以后仍然是全身，则设置1
	local x1, y1, z1 = model:GetCameraPosition()
	model:SetCamera(0);
	if x1 and y1 and z1 then
		local x2, y2, z2 = model:GetCameraPosition()
		if x1 == x2 and y1 == y2 and z1 == z2 then
			model:SetCamera(1);
		end
	end
	EUF_3DPortrait_SetLights3D(unit);
	--if EUF_3DPortrait_IsMeshLoaded(unit) then
		getglobal(UNIT_PORTRAITS[unit]):Hide();
	--else
	--	getglobal(UNIT_PORTRAITS[unit]):Show();
	--end
end

function EUF_3DPortrait_Percent(value, maxValue)
	if maxValue == 0 then
		return 0;
	else
		return math.floor(value * 100 / maxValue);
	end
end

function EUF_3DPortrait_SetLights3D(unit)
	LowHealthWarnings[unit] = false;
	if (not UnitIsConnected(unit)) or UnitIsGhost(unit) then
		getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 0.25, 0.25, 0.25);
	elseif UnitIsDead(unit) then
		getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, 0.3, 0.3);
	else
		if EUF_3DPortrait_Percent(UnitHealth(unit), UnitHealthMax(unit)) < 20 then
			LowHealthWarnings[unit] = true;
			EUF_3DPortraitFrame:Show();
        else
            --SetLight(enabled[, omni, dirX, dirY, dirZ, ambIntensity[, ambR, ambG, ambB], dirIntensity[, dirR, dirG, dirB]])
			getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, 1, 1);
		end
	end
end

function EUF_3DPortrait_IsMeshLoaded(unit)
	return type(getglobal(UNIT_MODELS[unit]):GetModel()) == "string";
end

function EUF_3DPortrait_OnEvent(self, event,...)
	local arg1=select(1,...)
	if EUF_3DPortrait_Show3D then
		if event == "PLAYER_TARGET_CHANGED" then
			EUF_3DPortrait_Update3D("target");
		elseif event == "UNIT_PORTRAIT_UPDATE" and UNIT_MODELS[arg1] then
			EUF_3DPortrait_Update3D(arg1);
		elseif event == "UNIT_HEALTH" and UNIT_MODELS[arg1] then
			EUF_3DPortrait_SetLights3D(arg1);
		end
	end
end

local timer = 0;
local sign = 1;
function EUF_3DPortrait_Update(self, elapsed)
	timer = timer + elapsed;
	if timer > 0.5 then
		sign = -sign;
	end
	timer = mod(timer, 0.5);

	local redIntensity = 0;
	if sign == 1 then
		redIntensity = 0.7 - timer;
	else
		redIntensity = timer + 0.2;
	end

	local hide = true;
	for unit, warn in pairs(LowHealthWarnings) do
		if warn and getglobal(UNIT_MODELS[unit]):IsVisible() then
			getglobal(UNIT_MODELS[unit]):SetLight(true, false, 0, 0, 0, 1.0, 1, redIntensity, redIntensity);
			hide = false;
		end
	end
	if hide then
		EUF_3DPortraitFrame:Hide();
	end
end