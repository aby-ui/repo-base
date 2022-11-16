--[[------------------------------------------------------------
AnimationSystem会导致污染
接口是SetUpAnimation2, 在EventAlertMod里调用
---------------------------------------------------------------]]

--[[	animTable = {	--Note that only consistent data should be in here. These tables are meant to be shared across "sessions" of animations. Put changing data in the frame.
	totalTime = number,		--Time to complete the animation in seconds.
	updateFunc = function,		--The function called to do the actual change. Takes self, elapsed fraction. Usually frame.SetPoint, frame.SetAlpha, ect.
	getPosFunc = function,		--The function returning the data being passed into updateFunc. For example. might return .18 if updateFunc is frame.SetAlpha.
--]]
local AnimatingFrames = {};

local AnimUpdateFrame = CreateFrame("Frame");

local function Animation_UpdateFrame(self, animElapsed, animTable)
    local totalTime = animTable.totalTime
    if ( animElapsed and (animElapsed < totalTime)) then	--Should be animating
        local elapsedFraction = self._aby_animReverse and (1-animElapsed/totalTime) or (animElapsed/totalTime);
        animTable.updateFunc(self, animTable.getPosFunc(self, elapsedFraction));
    else	--Just finished animating
        animTable.updateFunc(self, animTable.getPosFunc(self, self._aby_animReverse and 0 or 1));
        self._aby_animating = false;

        AnimatingFrames[self][animTable.updateFunc] = 0;	--We use 0 instead of nil'ing out because we don't want to mess with 'next' (used in pairs)

        if ( self._aby_animPostFunc ) then
            self._aby_animPostFunc(self);
        end

    end
end

local totalElapsed = 0;
local function Animation_OnUpdate(self, elapsed)
    totalElapsed = totalElapsed + elapsed;
    local isAnyFrameAnimating = false;
    for frame, frameTable in pairs(AnimatingFrames) do
        for frameTable, animTable in pairs(frameTable) do
            if ( animTable ~= 0 ) then
                Animation_UpdateFrame(frame, totalElapsed - frame._aby_animStartTime, animTable);
                isAnyFrameAnimating = true;
            end
        end
    end
    if ( not isAnyFrameAnimating ) then
        wipe(AnimatingFrames);
        AnimUpdateFrame:SetScript("OnUpdate", nil);
    end
end

function SetUpAnimation2(frame, animTable, postFunc, reverse)
    if ( type(animTable.updateFunc) == "string" ) then
        animTable.updateFunc = frame[animTable.updateFunc];
    end
    if ( not AnimatingFrames[frame] ) then
        AnimatingFrames[frame] = {};
    end

    AnimatingFrames[frame][animTable.updateFunc] = animTable;

    frame._aby_animStartTime = totalElapsed;
    frame._aby_animReverse = reverse;
    frame._aby_animPostFunc = postFunc;
    frame._aby_animating = true;

    animTable.updateFunc(frame, animTable.getPosFunc(frame, frame._aby_animReverse and 1 or 0));

    AnimUpdateFrame:SetScript("OnUpdate", Animation_OnUpdate);
end

function CancelAnimations2(frame)
    local anims = AnimatingFrames[frame];
    if ( anims ) then
        for k, v in pairs(anims) do
            anims[k] = 0;
        end
    end
end