local addonName, addon = ...
local L = addon.L
local F = addon.funcs
local P = addon.pixelPerfectFuncs
local A = addon.animations

-----------------------------------------
-- forked from ElvUI
-----------------------------------------
local FADEFRAMES, FADEMANAGER = {}, CreateFrame('FRAME')
FADEMANAGER.interval = 0.025

-----------------------------------------
-- fade manager onupdate
-----------------------------------------
local function Fading(_, elapsed)
    FADEMANAGER.timer = (FADEMANAGER.timer or 0) + elapsed

    if FADEMANAGER.timer > FADEMANAGER.interval then
        FADEMANAGER.timer = 0

        for frame, info in next, FADEFRAMES do
            if frame:IsVisible() then
                info.fadeTimer = (info.fadeTimer or 0) + (elapsed + FADEMANAGER.interval)
            else -- faster for hidden frames
                info.fadeTimer = info.timeToFade + 1
            end

            if info.fadeTimer < info.timeToFade then
                if info.mode == 'IN' then
                    frame:SetAlpha((info.fadeTimer / info.timeToFade) * info.diffAlpha + info.startAlpha)
                else
                    frame:SetAlpha(((info.timeToFade - info.fadeTimer) / info.timeToFade) * info.diffAlpha + info.endAlpha)
                end
            else
                frame:SetAlpha(info.endAlpha)
                -- NOTE: remove from FADEFRAMES
                if frame and FADEFRAMES[frame] then
                    if frame.fade then
                        frame.fade.fadeTimer = nil
                    end
                    FADEFRAMES[frame] = nil
                end
            end
        end

        if not next(FADEFRAMES) then
            -- print("FINISHED FADING!")
            FADEMANAGER:SetScript('OnUpdate', nil)
        end
    end
end

-----------------------------------------
-- fade
-----------------------------------------
local function FrameFade(frame, info)
    frame:SetAlpha(info.startAlpha)

    if not frame:IsProtected() then
        frame:Show()
    end

    if not FADEFRAMES[frame] then
        FADEFRAMES[frame] = info
        FADEMANAGER:SetScript('OnUpdate', Fading)
    else
        FADEFRAMES[frame] = info
    end
end

function A:FrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = 'IN'
    frame.fade.timeToFade = timeToFade
    frame.fade.startAlpha = startAlpha
    frame.fade.endAlpha = endAlpha
    frame.fade.diffAlpha = endAlpha - startAlpha

    FrameFade(frame, frame.fade)
end

function A:FrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
    if frame.fade then
        frame.fade.fadeTimer = nil
    else
        frame.fade = {}
    end

    frame.fade.mode = 'OUT'
    frame.fade.timeToFade = timeToFade
    frame.fade.startAlpha = startAlpha
    frame.fade.endAlpha = endAlpha
    frame.fade.diffAlpha = startAlpha - endAlpha

    FrameFade(frame, frame.fade)
end