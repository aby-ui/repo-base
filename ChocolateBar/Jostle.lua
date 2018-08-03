local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local Jostle = ChocolateBar.Jostle
local bottomFrames = {}
local topFrames = {}
Jostle.hooks = {}
local Debug = ChocolateBar.Debug
local JostleUpdate = CreateFrame("Frame")
local _G, pairs = _G, pairs

local blizzardFrames = {
	'PlayerFrame',
	'TargetFrame',
	'MinimapCluster',
	'PartyMemberFrame1',
	'TicketStatusFrame',
	'WorldStateAlwaysUpFrame',
	'MainMenuBar',
	'MultiBarRight',
	'CT_PlayerFrame_Drag',
	'CT_TargetFrame_Drag',
	'Gypsy_PlayerFrameCapsule',
	'Gypsy_TargetFrameCapsule',
	'GMChatStatusFrame',
	--'ConsolidatedBuffs',
	'BuffFrame',
	'DEFAULT_CHAT_FRAME',
	'ChatFrame2',
	'GroupLootFrame1',
	'TutorialFrameParent',
	'FramerateLabel',
	'DurabilityFrame',
	'CastingBarFrame',
	'OrderHallCommandBar',
	'MicroButtonAndBagsBar',
}

local blizzardFramesData = {}

local start = GetTime()
local nextTime = 0
local fullyInitted = false

local JostleFrame = CreateFrame("Frame")
Jostle.Frame  = JostleFrame
JostleFrame:SetScript("OnUpdate", function(this, elapsed)
	local now = GetTime()
	if now - start >= 3 then
		fullyInitted = true
		for k,v in pairs(blizzardFramesData) do
			blizzardFramesData[k] = nil
		end
		this:SetScript("OnUpdate", function(this, elapsed)
			if GetTime() >= nextTime then
				Jostle:Refresh()
				this:Hide()
			end
		end)
	end
end)

function JostleFrame:Schedule(time)
	time = time or 0
	nextTime = GetTime() + time
	self:Show()
end

JostleFrame:UnregisterAllEvents()
JostleFrame:SetScript("OnEvent", function(this, event, ...)
	return Jostle[event](Jostle, ...)
end)
JostleFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
JostleFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
JostleFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
JostleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
JostleFrame:RegisterEvent("UNIT_ENTERING_VEHICLE")
JostleFrame:RegisterEvent("UNIT_EXITED_VEHICLE")

if not Jostle.hooks.WorldMapFrame_Hide then
	Jostle.hooks.WorldMapFrame_Hide = true
	hooksecurefunc(WorldMapFrame, "Hide", function()
		if Jostle.WorldMapFrame_Hide then
			Jostle:WorldMapFrame_Hide()
		end
	end)
end

if not Jostle.hooks.TicketStatusFrame_OnEvent then
	Jostle.hooks.TicketStatusFrame_OnEvent = true
    SetOrHookScript(TicketStatusFrame, "OnEvent", function()
		if Jostle.TicketStatusFrame_OnEvent then
			Jostle:TicketStatusFrame_OnEvent()
		end
	end)
end

if not Jostle.hooks.UIParent_ManageFramePositions then
	Jostle.hooks.UIParent_ManageFramePositions = true
	hooksecurefunc("UIParent_ManageFramePositions", function()
		if Jostle.UIParent_ManageFramePositions then
			Jostle:UIParent_ManageFramePositions()
		end
	end)
end

if not Jostle.hooks.PlayerFrame_SequenceFinished then
	Jostle.hooks.PlayerFrame_SequenceFinished = true
	hooksecurefunc("PlayerFrame_SequenceFinished", function()
		if Jostle.PlayerFrame_SequenceFinished then
			Jostle:PlayerFrame_SequenceFinished()
		end
	end)
end

--7.0 by warbaby
if not Jostle.hooks.UIParent_UpdateTopFramePositions then
	Jostle.hooks.UIParent_UpdateTopFramePositions = true
	hooksecurefunc("UIParent_UpdateTopFramePositions", function()
		if Jostle.UIParent_UpdateTopFramePositions then
			Jostle:UIParent_UpdateTopFramePositions()
		end
	end)
end

hooksecurefunc("UIParent_UpdateTopFramePositions", function() Jostle:Refresh() end)

function Jostle:UIParent_UpdateTopFramePositions()
	self:Refresh(PlayerFrame, TargetFrame, TicketStatusFrame, GMChatStatusFrame, BuffFrame)
end

function Jostle:WorldMapFrame_Hide()
	--JostleFrame:Schedule()
end

function Jostle:TicketStatusFrame_OnEvent()
	self:Refresh(TicketStatusFrame, GMChatStatusFrame, BuffFrame)
end

function Jostle:UIParent_ManageFramePositions()
	self:Refresh(MainMenuBar, GroupLootFrame1, TutorialFrameParent, FramerateLabel, DurabilityFrame)
end

function Jostle:PlayerFrame_SequenceFinished()
	self:Refresh(PlayerFrame)
end

function Jostle:UNIT_ENTERING_VEHICLE()
	MainMenuBar:SetMovable(true)
	MainMenuBar:SetUserPlaced(false)
end

function Jostle:UNIT_EXITED_VEHICLE()
	self:Refresh(MainMenuBar)
end

function Jostle:PLAYER_ENTERING_WORLD()
	self:Refresh(BuffFrame, PlayerFrame, TargetFrame)
end

function Jostle:WorldMapFrame_Hide()
	--JostleFrame:Schedule()
end

function Jostle:UIParent_ManageFramePositions()
	--self:Refresh(MainMenuBar, GroupLootFrame1, TutorialFrameParent, FramerateLabel, DurabilityFrame)
end

local function GetScreenTop()
	local bottom = GetScreenHeight()
	for _,frame in pairs(topFrames) do
    Debug(frame)
		if frame.IsShown and frame:IsShown() and frame.GetBottom and frame:GetBottom() and frame:GetBottom() < bottom then
			bottom = frame:GetBottom()
		end
	end
	return bottom
end

local function GetScreenBottom()
	local top = 0
	local isBottomAdjusting = false
	for _,frame in pairs(bottomFrames) do
		if frame.IsShown and frame:IsShown() and frame.GetTop and frame:GetTop() and frame:GetTop() > top then
			top = frame:GetTop()
			isBottomAdjusting = true
		end
	end
	return top
end

local function UpdateBottom()

end

local function UpdateTop()

end

local function Adjust()
end

function Jostle:RegisterBottom(frame)
	if frame and not bottomFrames[frame] then
		bottomFrames[frame] = frame
		JostleFrame:Schedule()
	end
end

function Jostle:RegisterTop(frame)
  Debug("RegisterTop")
	if frame and not topFrames[frame] then
		topFrames[frame] = frame
		JostleFrame:Schedule()
	end
end

function Jostle:Unregister(frame)
	if frame and topFrames[frame] then
		topFrames[frame] = nil
	elseif frame and bottomFrames[frame] then
		bottomFrames[frame] = nil
		JostleFrame:Schedule()
	end
end

local tmp = {}
local queue = {}
local inCombat = false
function Jostle:ProcessQueue()
	if not inCombat and HasFullControl() then
		for k in pairs(queue) do
			self:Refresh(k)
			queue[k] = nil
		end
	end
end
function Jostle:PLAYER_CONTROL_GAINED()
	self:ProcessQueue()
end

function Jostle:PLAYER_REGEN_ENABLED()
	inCombat = false
	self:ProcessQueue()
end

function Jostle:PLAYER_REGEN_DISABLED()
	inCombat = true
end

local function isClose(alpha, bravo)
	return math.abs(alpha - bravo) < 0.1
end

function Jostle:Refresh(...)
	if not fullyInitted then
		return
	end

	local screenHeight = GetScreenHeight()
	local topOffset = GetScreenTop() or screenHeight
	local bottomOffset = GetScreenBottom() or 0
	if topOffset ~= screenHeight or bottomOffset ~= 0 then
		JostleFrame:Schedule(10)
	end

	local frames
	if select('#', ...) >= 1 then
		for k in pairs(tmp) do
			tmp[k] = nil
		end
		for i = 1, select('#', ...) do
			tmp[i] = select(i, ...)
		end
		frames = tmp
	else
		frames = blizzardFrames
	end

	if inCombat or not HasFullControl() and not UnitHasVehicleUI("player") then
		for _,frame in ipairs(frames) do
			if type(frame) == "string" then
				frame = _G[frame]
			end
			if frame then
				queue[frame] = true
			end
		end
		return
	end

	local screenHeight = GetScreenHeight()
	for _,frame in ipairs(frames) do
		if type(frame) == "string" then
			frame = _G[frame]
		end

		local framescale = frame and frame.GetScale and frame:GetScale() or 1

		if frame and not blizzardFramesData[frame] and frame.GetTop and frame:GetCenter() and select(2, frame:GetCenter()) then
			if select(2, frame:GetCenter()) <= screenHeight / 2 or frame == MultiBarRight then
				blizzardFramesData[frame] = {y = frame:GetBottom(), top = false}
			else
				blizzardFramesData[frame] = {y = frame:GetTop() - screenHeight / framescale, top = true}
			end
			if frame == MinimapCluster then
				blizzardFramesData[frame].lastX = GetScreenWidth() - MinimapCluster:GetWidth()
				blizzardFramesData[frame].lastY = GetScreenHeight()
				blizzardFramesData[frame].lastScale = 1
			end
		end
	end

	for _,frame in ipairs(frames) do
		if type(frame) == "string" then
			frame = _G[frame]
		end

		local framescale = frame and frame.GetScale and frame:GetScale() or 1

		if ((frame and frame.IsUserPlaced and not frame:IsUserPlaced()) or ((frame == DEFAULT_CHAT_FRAME or frame == ChatFrame2) and SIMPLE_CHAT == "1") or frame == FramerateLabel) and (frame ~= ChatFrame2 or SIMPLE_CHAT == "1") then
			local frameData = blizzardFramesData[frame]
			if (select(2, frame:GetPoint(1)) ~= UIParent and select(2, frame:GetPoint(1)) ~= WorldFrame) then
				-- do nothing
			elseif bottomOffset == 0 and (frame == MainMenuBar or frame == CastingBarFrame or frame == FramerateLabel or ((frame == DEFAULT_CHAT_FRAME or frame == ChatFrame2))) then
				-- do nothing
			elseif frame == PlayerFrame and (CT_PlayerFrame_Drag or Gypsy_PlayerFrameCapsule) then
				-- do nothing
			elseif frame == TargetFrame and (CT_TargetFrame_Drag or Gypsy_TargetFrameCapsule) then
				-- do nothing
			elseif frame == PartyMemberFrame1 and (CT_MovableParty1_Drag or Gypsy_PartyFrameCapsule) then
				-- do nothing
			elseif frame == MainMenuBar and Gypsy_HotBarCapsule then
				-- do nothing
			elseif frame == MinimapCluster and select(3, frame:GetPoint(1)) ~= "TOPRIGHT" then
				-- do nothing
			elseif frame == DurabilityFrame and DurabilityFrame:IsShown() and (DurabilityFrame:GetLeft() > GetScreenWidth() or DurabilityFrame:GetRight() < 0 or DurabilityFrame:GetBottom() > GetScreenHeight() or DurabilityFrame:GetTop() < 0) then
				DurabilityFrame:Hide()
			elseif frame == FramerateLabel and ((frameData.lastX and not isClose(frameData.lastX, frame:GetLeft())) or not isClose(WorldFrame:GetHeight() * WorldFrame:GetScale(), UIParent:GetHeight() * UIParent:GetScale()))  then
				-- do nothing
			elseif frame == PlayerFrame or frame == MainMenuBar or frame == TargetFrame or frame == BuffFrame or frame == CastingBarFrame or frame == TutorialFrameParent or frame == FramerateLabel or frame == DurabilityFrame or frame == WatchFrame or not (frameData.lastScale and frame.GetScale and frameData.lastScale == frame:GetScale()) or not (frameData.lastX and frameData.lastY and (not isClose(frameData.lastX, frame:GetLeft()) or not isClose(frameData.lastY, frame:GetTop()))) then
				local anchor
				local anchorAlt
				local width, height = GetScreenWidth(), GetScreenHeight()
				local x

				if frame:GetRight() and frame:GetLeft() then
					local anchorFrame = UIParent
					if frame == GroupLootFrame1 or frame == FramerateLabel then
						x = 0
						anchor = ""
					elseif frame:GetRight() / framescale <= width / 2 then
						x = frame:GetLeft() / framescale
						anchor = "LEFT"
					else
						x = frame:GetRight() - width / framescale
						anchor = "RIGHT"
					end
					local y = blizzardFramesData[frame].y
					local offset = 0
					if blizzardFramesData[frame].top then
						anchor = "TOP" .. anchor
						offset = ( topOffset - height ) / framescale
					else
						anchor = "BOTTOM" .. anchor
						offset = bottomOffset / framescale
					end
					if frame == MinimapCluster and not MinimapBorderTop:IsShown() then
						offset = offset + MinimapBorderTop:GetHeight() * 3/5
                    elseif GMChatStatusFrame and frame == GMChatStatusFrame then
                        if ( TicketStatusFrame:IsShown() ) then
						offset = offset - TicketStatusFrame:GetHeight() * TicketStatusFrame:GetScale()
                        end
                    elseif frame == BuffFrame then
                        if ( TicketStatusFrame:IsShown() ) then
                            offset = offset - TicketStatusFrame:GetHeight() * TicketStatusFrame:GetScale()
                        end
                        if ( GMChatStatusFrame and GMChatStatusFrame:IsShown() ) then
                            offset = offset - GMChatStatusFrame:GetHeight() * GMChatStatusFrame:GetScale() - 5
                        end
					elseif frame == DEFAULT_CHAT_FRAME then
						y = MainMenuBar:GetHeight() * MainMenuBar:GetScale() + 32
						if StanceBarFrame and (PetActionBarFrame:IsShown() or StanceBarFrame:IsShown()) then
							offset = offset + StanceBarFrame:GetHeight() * StanceBarFrame:GetScale()
						end
						if MultiBarBottomLeft:IsShown() then
							offset = offset + MultiBarBottomLeft:GetHeight() * MultiBarBottomLeft:GetScale() - 21
						end
					elseif frame == ChatFrame2 then
						y = MainMenuBar:GetHeight() * MainMenuBar:GetScale() + 32
						if MultiBarBottomRight:IsShown() then
							offset = offset + MultiBarBottomRight:GetHeight() * MultiBarBottomRight:GetScale() - 21
						end
					elseif frame == GroupLootFrame1 or frame == TutorialFrameParent or frame == FramerateLabel then
						if MultiBarBottomLeft:IsShown() or MultiBarBottomRight:IsShown() then
							offset = offset + MultiBarBottomLeft:GetHeight() * MultiBarBottomLeft:GetScale()
						end
					elseif frame == DurabilityFrame or frame == WatchFrame then
						anchorFrame = MinimapCluster
						x = 0
						y = 0
						offset = 0
						if frame == WatchFrame and DurabilityFrame:IsShown() then
							y = y - DurabilityFrame:GetHeight() * DurabilityFrame:GetScale()
						end
						if frame == DurabilityFrame then
							x = -20
						end
						anchor = "TOPRIGHT"
						anchorAlt = "BOTTOMRIGHT"
						if MultiBarRight:IsShown() then
							x = x - MultiBarRight:GetWidth() * MultiBarRight:GetScale()
							if MultiBarLeft:IsShown() then
								x = x - MultiBarLeft:GetWidth() * MultiBarLeft:GetScale()
							end
						end
					elseif frame == OrderHallCommandBar and OrderHallCommandBar:IsShown() then
							anchorAlt = "TOPLEFT"
							anchor = "TOPLEFT"
					end
					if frame == FramerateLabel then
						anchorFrame = WorldFrame
					end

					frame:ClearAllPoints()
					frame:SetPoint(anchor, anchorFrame, anchorAlt or anchor, x, y + offset)
					blizzardFramesData[frame].lastX = frame:GetLeft()
					blizzardFramesData[frame].lastY = frame:GetTop()
					blizzardFramesData[frame].lastScale = framescale

					if frame == MainMenuBar then
						MainMenuBar:SetMovable(true)
						MainMenuBar:SetUserPlaced(true)
					end
					if frame == OrderHallCommandBar then
						frame:SetPoint("RIGHT", "UIParent" ,"RIGHT",0, 0);
					end
				end
			end
		end
	end
end
