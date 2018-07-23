-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
local _G = getfenv(0)

-- Functions

-- Libraries
local math = _G.math
local table = _G.table

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local FOLDER_NAME, private = ...
local panel = _G.CreateFrame("Frame")
panel.InsideAlphaMultiplier = 1 / 3
panel.UpdateDistance = 0.5
panel.UpdateRateDefault = 0.04

-- Faster so that spinning the minimap appears smooth
panel.UpdateRateRotating = 0.02

local Minimap = Minimap

-----------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------
local CurrentMapID
local UpdateRate = panel.UpdateRateDefault
local UpdateForce, IsInside, RotateMinimap, Radius, Quadrants

-- Lots of thanks to Routes (http://www.wowace.com/addons/routes/)
do
	local SplitPoints = {}
	local X, Y, Facing, Width, Height
	local FacingSin, FacingCos

	local PaintPath
	do
		-- @return True if the point's quadrant is rounded.
		local function IsQuadrantRound(X, Y)
			-- Y-axis is flipped
			return Quadrants[Y <= 0 and (X >= 0 and 1 or 2) or (X >= 0 and 4 or 3)]
		end

		local Points = {}
		local LastExitPoint
		local IsClockwise

		local LastRoundX, LastRoundY

		local AddRoundSplit
		do
			local AngleStart, AngleEnd, AngleIncrement
			local ArcSegmentLength, TwoPi = math.pi / 20, math.pi * 2
			local Atan2, Cos, Sin = math.atan2, math.cos, math.sin

			-- Fills the triangle's intersection with round minimap borders.
			-- @param EndX..EndY Intersection point to fill to from (LastRoundX,LastRoundY).
			function AddRoundSplit(EndX, EndY)
				AngleStart, AngleEnd = Atan2(-LastRoundY, LastRoundX), Atan2(-EndY, EndX)
				LastRoundX = nil
				LastRoundY = nil

				if IsClockwise then
					AngleIncrement = -ArcSegmentLength
					if AngleStart < AngleEnd then
						AngleStart = AngleStart + TwoPi
					end
				else
					AngleIncrement = ArcSegmentLength
					if AngleEnd < AngleStart then
						AngleEnd = AngleEnd + TwoPi
					end
				end

				for Angle = AngleStart + AngleIncrement, AngleEnd - AngleIncrement / 2, AngleIncrement do
					Points[#Points + 1] = Cos(Angle) / 2
					Points[#Points + 1] = -Sin(Angle) / 2
				end
			end
		end

		local AddSplit
		do
			local Infinity = math.huge
			local StartX, StartY
			local Ax, Ay, Bx, By
			local SplitX, SplitY, Side
			local StartDistance2, StartPoint
			local NearestDistance2, NearestPoint
			local Distance2
			local ForStart, ForEnd, ForStep

			-- Adds split points between the last exit intersection and the most recent entrance intersection.
			-- @param WrapToStart True if (EndX,EndY) is the first point and doesn't need to be re-added to the Points list.
			function AddSplit(EndX, EndY, WrapToStart)
				StartX, StartY = Points[LastExitPoint], Points[LastExitPoint + 1]
				LastExitPoint = nil

				if IsQuadrantRound(StartX, StartY) then
					LastRoundX, LastRoundY = StartX, StartY
				else
					LastRoundX = nil
					LastRoundY = nil
				end

				if #SplitPoints > 0 then
					if IsClockwise then
						-- Split points to the right of line AB are valid
						Ax, Ay = EndX, EndY
						Bx, By = StartX, StartY
					else
						Ax, Ay = StartX, StartY
						Bx, By = EndX, EndY
					end

					-- Find first split point after start
					StartDistance2 = Infinity
					StartPoint = nil

					NearestDistance2 = Infinity
					NearestPoint = nil

					ForEnd, ForStep = #SplitPoints - 1, IsClockwise and -2 or 2

					for Index = IsClockwise and ForEnd or 1, IsClockwise and 1 or ForEnd, ForStep do
						SplitX, SplitY = SplitPoints[Index], SplitPoints[Index + 1]
						Side = (Bx - Ax) * (SplitY - Ay) - (By - Ay) * (SplitX - Ax)

						if Side > 0 then
							-- Valid split point
							Distance2 = (StartX - SplitX) ^ 2 + (StartY - SplitY) ^ 2

							if Distance2 < NearestDistance2 then
								NearestPoint, NearestDistance2 = Index, Distance2
							end

							if Distance2 < StartDistance2 and Distance2 < (EndX - SplitX) ^ 2 + (EndY - SplitY) ^ 2 then
								StartPoint, StartDistance2 = Index, Distance2
							end
						end
					end

					if not StartPoint then
						StartPoint = NearestPoint
					end

					-- Add all split points after start
					if StartPoint then
						SplitX, SplitY = SplitPoints[StartPoint], SplitPoints[StartPoint + 1]
						if LastRoundX then
							AddRoundSplit(SplitX, SplitY)
						elseif SplitX == 0 or SplitY == 0 then
							LastRoundX, LastRoundY = SplitX, SplitY
						end
						Points[#Points + 1] = SplitX
						Points[#Points + 1] = SplitY

						ForStart, ForEnd = StartPoint + 2, StartPoint + #SplitPoints - 2
						for Index = IsClockwise and ForEnd or ForStart, IsClockwise and ForStart or ForEnd, ForStep do
							SplitX, SplitY = SplitPoints[(Index - 1) % #SplitPoints + 1], SplitPoints[Index % #SplitPoints + 1]
							Side = (Bx - Ax) * (SplitY - Ay) - (By - Ay) * (SplitX - Ax)

							if Side > 0 then
								-- Valid split point
								if LastRoundX then
									AddRoundSplit(SplitX, SplitY)
								elseif SplitX == 0 or SplitY == 0 then
									LastRoundX, LastRoundY = SplitX, SplitY
								end
								Points[#Points + 1] = SplitX
								Points[#Points + 1] = SplitY
							else
								break
							end
						end
					end
				end

				if LastRoundX then
					AddRoundSplit(EndX, EndY)
				end

				if not WrapToStart then
					-- Add re-entry point
					Points[#Points + 1] = EndX
					Points[#Points + 1] = EndY
				end
			end
		end

		local AddIntersection
		do
			local ABx, ABy
			local PointX, PointY
			local IntersectPos, Intercept, Length2, Temp
			--- Adds the intersection of line AB with the minimap to the Points list.
			-- @param PerpDist2 Distance from center to intersection squared.
			-- @param IsExiting True if should save found intersection as the last exit point.
			function AddIntersection(Ax, Ay, Bx, By, PerpDist2, IsExiting)
				PointX = nil
				PointY = nil
				ABx, ABy = Ax - Bx, Ay - By
				--assert( ABx ~= 0 or ABy ~= 0, "Points A and B don't form a line." )

				-- Clip to square
				if Ax >= -0.5 and Ax <= 0.5 and Ay >= -0.5 and Ay <= 0.5 then
					PointX, PointY = Ax, Ay
				else
					if ABy ~= 0 then
						-- Not horizontal line
						-- Test vertical intersection
						Intercept = ABy < 0 and -0.5 or 0.5
						IntersectPos = (Ay - Intercept) / ABy

						if IntersectPos >= 0 and IntersectPos <= 1 then
							PointX = Ax - ABx * IntersectPos

							if PointX >= -0.5 and PointX <= 0.5 then
								PointY = Intercept
							end
						end
					end

					if not PointY and ABx ~= 0 then
						-- Was no vertical intersect
						-- Not vertical line
						-- Test horizontal intersection
						Intercept = ABx < 0 and -0.5 or 0.5
						IntersectPos = (Ax - Intercept) / ABx

						if IntersectPos >= 0 and IntersectPos <= 1 then
							PointY = Ay - ABy * IntersectPos

							if PointY >= -0.5 and PointY <= 0.5 then
								PointX = Intercept
							end
						end
					end

					if not PointX or not PointY then
						return
					end
				end

				if IsQuadrantRound(PointX, PointY) then
					-- Clip to circle
					if PerpDist2 < 0.25 then
						Length2 = ABx * ABx + ABy * ABy
						Temp = ABx * Bx + ABy * By

						IntersectPos = ((Temp * Temp - Length2 * (Bx * Bx + By * By - 0.25)) ^ 0.5 - Temp) / Length2

						if IntersectPos >= 0 and IntersectPos <= 1 then
							PointX, PointY = Bx + ABx * IntersectPos, By + ABy * IntersectPos
						else
							return
						end
					else
						return
					end
				end

				if LastExitPoint then
					AddSplit(PointX, PointY)
				else
					if IsExiting then
						LastExitPoint = #Points + 1
					end
					Points[#Points + 1] = PointX
					Points[#Points + 1] = PointY
				end
			end
		end

		local COORD_MAX = 2 ^ 16 - 1
		local BYTES_PER_TRIANGLE = 2 * 2 * 3
		local Ax, Ax2, Ay, Ay2, Bx, Bx2, By, By2, Cx, Cx2, Cy, Cy2
		local ABx, ABy, BCx, BCy, ACx, ACy
		local AInside, BInside, CInside
		local IntersectPos, PerpX, PerpY
		local ABPerpDist2, BCPerpDist2, ACPerpDist2
		local Dot00, Dot01, Dot02, Dot11, Dot12
		local Denominator, U, V
		local Texture, Left, Top
		--- Callback to ApplyZone to clip and paint all path triangles to the minimap.
		-- @see Overlay.ApplyZone'

		function PaintPath(self, PathData, FoundX, FoundY, R, G, B)
			if FoundX and (private.Options.ModulesExtra["Minimap"].DetectionRing) then
				FoundX, FoundY = FoundX * Width - X, FoundY * Height - Y
				if RotateMinimap then
					FoundX, FoundY = FoundX * FacingCos - FoundY * FacingSin, FoundX * FacingSin + FoundY * FacingCos
				end
				--Do Not remove.  Disabled to unclutter map untill good way to limit number can be fount
				private.DrawFound( self, FoundX + 0.5, FoundY + 0.5, private.DetectionRadius / ( Radius * 2 ), "OVERLAY", R, G, B )
			end

			local PointsOffset, LinesOffset, TrianglesOffset = private.GetPathPrimitiveOffsets(PathData)
			for Index = TrianglesOffset, #PathData, BYTES_PER_TRIANGLE do
				Ax, Ax2, Ay, Ay2, Bx, Bx2, By, By2, Cx, Cx2, Cy, Cy2 = PathData:byte(Index, Index + BYTES_PER_TRIANGLE - 1)
				Ax, Ay = (Ax * 256 + Ax2) / COORD_MAX * Width - X, (1 - (Ay * 256 + Ay2) / COORD_MAX) * Height - Y
				Bx, By = (Bx * 256 + Bx2) / COORD_MAX * Width - X, (1 - (By * 256 + By2) / COORD_MAX) * Height - Y
				Cx, Cy = (Cx * 256 + Cx2) / COORD_MAX * Width - X, (1 - (Cy * 256 + Cy2) / COORD_MAX) * Height - Y

				if RotateMinimap then
					Ax, Ay = Ax * FacingCos - Ay * FacingSin, Ax * FacingSin + Ay * FacingCos
					Bx, By = Bx * FacingCos - By * FacingSin, Bx * FacingSin + By * FacingCos
					Cx, Cy = Cx * FacingCos - Cy * FacingSin, Cx * FacingSin + Cy * FacingCos
				end

				if not ((Ax > 0.5 and Bx > 0.5 and Cx > 0.5) or (Ax < -0.5 and Bx < -0.5 and Cx < -0.5) or (Ay > 0.5 and By > 0.5 and Cy > 0.5) or (Ay < -0.5 and By < -0.5 and Cy < -0.5)) then
					-- If all points are on one side, cannot possibly intersect
					if IsQuadrantRound(Ax, Ay) then
						AInside = Ax * Ax + Ay * Ay <= 0.25
					else
						AInside = Ax <= 0.5 and Ax >= -0.5 and Ay <= 0.5 and Ay >= -0.5
					end

					if IsQuadrantRound(Bx, By) then
						BInside = Bx * Bx + By * By <= 0.25
					else
						BInside = Bx <= 0.5 and Bx >= -0.5 and By <= 0.5 and By >= -0.5
					end

					if IsQuadrantRound(Cx, Cy) then
						CInside = Cx * Cx + Cy * Cy <= 0.25
					else
						CInside = Cx <= 0.5 and Cx >= -0.5 and Cy <= 0.5 and Cy >= -0.5
					end

					if AInside and BInside and CInside then
						-- No possible intersections
						private.TextureAdd(self, "ARTWORK", R, G, B,
							Ax + 0.5, Ay + 0.5, Bx + 0.5, By + 0.5, Cx + 0.5, Cy + 0.5)
					else
						ABx, ABy = Ax - Bx, Ay - By
						BCx, BCy = Bx - Cx, By - Cy
						ACx, ACy = Ax - Cx, Ay - Cy

						if (ABx ~= 0 or ABy ~= 0) and (BCx ~= 0 or BCy ~= 0) and (ACx ~= 0 or ACy ~= 0) then
							-- Intersection between the side and a line perpendicular to it that passes through the center
							IntersectPos = (Ax * ABx + Ay * ABy) / (ABx * ABx + ABy * ABy)
							PerpX, PerpY = Ax - IntersectPos * ABx, Ay - IntersectPos * ABy

							-- From center to intersection squared
							ABPerpDist2 = PerpX * PerpX + PerpY * PerpY

							IntersectPos = (Bx * BCx + By * BCy) / (BCx * BCx + BCy * BCy)
							PerpX, PerpY = Bx - IntersectPos * BCx, By - IntersectPos * BCy
							BCPerpDist2 = PerpX * PerpX + PerpY * PerpY

							IntersectPos = (Ax * ACx + Ay * ACy) / (ACx * ACx + ACy * ACy)
							PerpX, PerpY = Ax - IntersectPos * ACx, Ay - IntersectPos * ACy
							ACPerpDist2 = PerpX * PerpX + PerpY * PerpY


							if #Points > 0 then
								table.wipe(Points)
							end
							LastExitPoint = nil

							-- Check intersection with circle with radius at minimap's corner
							if ABPerpDist2 < 0.5 or BCPerpDist2 < 0.5 or ACPerpDist2 < 0.5 then
								-- Inside radius ~= 0.71
								-- Find all polygon vertices
								IsClockwise = BCx * (By + Cy) + ABx * (Ay + By) + (Cx - Ax) * (Cy + Ay) > 0

								if AInside then
									Points[#Points + 1] = Ax
									Points[#Points + 1] = Ay
								else
									AddIntersection(Ax, Ay, Cx, Cy, ACPerpDist2, true)
									AddIntersection(Ax, Ay, Bx, By, ABPerpDist2)
								end

								if BInside then
									Points[#Points + 1] = Bx
									Points[#Points + 1] = By
								else
									AddIntersection(Bx, By, Ax, Ay, ABPerpDist2, true)
									AddIntersection(Bx, By, Cx, Cy, BCPerpDist2)
								end

								if CInside then
									Points[#Points + 1] = Cx
									Points[#Points + 1] = Cy
								else
									AddIntersection(Cx, Cy, Bx, By, BCPerpDist2, true)
									AddIntersection(Cx, Cy, Ax, Ay, ACPerpDist2)
								end

								if LastExitPoint then
									-- Final split points between C and A
									AddSplit(Points[1], Points[2], true)
								end

								-- Draw tris between convex polygon vertices
								for Index = #Points, 6, -2 do
									private.TextureAdd(self, "ARTWORK", R, G, B,
										Points[1] + 0.5, Points[2] + 0.5, Points[Index - 3] + 0.5, Points[Index - 2] + 0.5, Points[Index - 1] + 0.5, Points[Index] + 0.5)
								end
							end

							if #Points == 0 then
								-- No intersections
								-- Check if the center is in the triangle
								Dot00, Dot01 = ACx * ACx + ACy * ACy, ACx * BCx + ACy * BCy
								Dot02 = ACx * -Cx - ACy * Cy
								Dot11, Dot12 = BCx * BCx + BCy * BCy, BCx * -Cx - BCy * Cy

								Denominator = Dot00 * Dot11 - Dot01 * Dot01

								if Denominator ~= 0 then
									-- Points aren't co-linear
									U = (Dot11 * Dot02 - Dot01 * Dot12) / Denominator
									V = (Dot00 * Dot12 - Dot01 * Dot02) / Denominator

									if U > 0 and V > 0 and U + V < 1 then
										-- Entire minimap is contained
										for Index = 1, 4 do
											Texture = private.TextureCreate(self, "ARTWORK", R, G, B)
											Left, Top = Index == 2 or Index == 3, Index <= 2
											Texture:SetPoint("LEFT", self, Left and "LEFT" or "CENTER")
											Texture:SetPoint("RIGHT", self, Left and "CENTER" or "RIGHT")
											Texture:SetPoint("TOP", self, Top and "TOP" or "CENTER")
											Texture:SetPoint("BOTTOM", self, Top and "CENTER" or "BOTTOM")

											if Quadrants[Index] then
												-- Rounded
												Texture:SetTexture([[Interface\CHARACTERFRAME\TempPortraitAlphaMask]])
												Texture:SetTexCoord(Left and 0 or 0.5, Left and 0.5 or 1, Top and 0 or 0.5, Top and 0.5 or 1)
											else
												-- Square
												Texture:SetTexture([[Interface\Buttons\WHITE8X8]])
												Texture:SetTexCoord(0, 1, 0, 1)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local MinimapShapes = {
		-- [ Shape ] = { Q1, Q2, Q3, Q4 } where true = rounded and false = squared
		["ROUND"] = { true, true, true, true },
		["SQUARE"] = { false, false, false, false },
		["CORNER-TOPRIGHT"] = { true, false, false, false },
		["CORNER-TOPLEFT"] = { false, true, false, false },
		["CORNER-BOTTOMLEFT"] = { false, false, true, false },
		["CORNER-BOTTOMRIGHT"] = { false, false, false, true },
		["SIDE-TOP"] = { true, true, false, false },
		["SIDE-LEFT"] = { false, true, true, false },
		["SIDE-BOTTOM"] = { false, false, true, true },
		["SIDE-RIGHT"] = { true, false, false, true },
		["TRICORNER-BOTTOMLEFT"] = { false, true, true, true },
		["TRICORNER-BOTTOMRIGHT"] = { true, false, true, true },
		["TRICORNER-TOPRIGHT"] = { true, true, false, true },
		["TRICORNER-TOPLEFT"] = { true, true, true, false },
	}

	local LastQuadrants, UpdateRangeRing
	local RadiiInside = { 150, 120, 90, 60, 40, 25 }
	local RadiiOutside = { 233 + 1 / 3, 200, 166 + 2 / 3, 133 + 1 / 3, 100, 66 + 2 / 3 }
	local Cos, Sin = math.cos, math.sin

	-- Draws paths on the minimap from a given player position and direction.
	function panel:Paint(Map, NewX, NewY, NewFacing)
		private.TextureRemoveAll(self)

		Quadrants = MinimapShapes[_G.GetMinimapShape and _G.GetMinimapShape()] or MinimapShapes["ROUND"]

		-- Minimap shape changed
		if Quadrants ~= LastQuadrants then
			LastQuadrants = Quadrants
			UpdateRangeRing = true

			-- Cache split points
			table.wipe(SplitPoints)

			for quadrant = 1, 4 do
				if Quadrants[quadrant] then
					-- Round
					if not Quadrants[(quadrant - 2) % 4 + 1] then
						-- Transition from previous
						local Angle = (quadrant - 1) * math.pi / 2
						-- Round coords to exactly 0 or 0.5 Necessary for later comparisons
						SplitPoints[#SplitPoints + 1] = math.floor(Cos(Angle) + 0.5) * 0.5
						SplitPoints[#SplitPoints + 1] = math.floor(Sin(Angle) + 0.5) * -0.5
					end

					if not Quadrants[quadrant % 4 + 1] then
						-- Transition to next
						local Angle = quadrant * math.pi / 2
						SplitPoints[#SplitPoints + 1] = math.floor(Cos(Angle) + 0.5) * 0.5
						SplitPoints[#SplitPoints + 1] = math.floor(Sin(Angle) + 0.5) * -0.5
					end
				else
					-- Square
					local Left, Top = quadrant == 2 or quadrant == 3, quadrant <= 2
					SplitPoints[#SplitPoints + 1] = Left and -0.5 or 0.5
					SplitPoints[#SplitPoints + 1] = Top and -0.5 or 0.5
				end
			end
		end

		if not Radius then
			-- Minimap radius changed
			Radius = (IsInside and RadiiInside or RadiiOutside)[Minimap:GetZoom() + 1]
			UpdateRangeRing = true
		end

		if private.Options.ModulesExtra["Minimap"].RangeRing then
			-- Re-fit ring quadrants to minimap shape and size
			if UpdateRangeRing then
				UpdateRangeRing = nil

				local radius = Radius / private.DetectionRadius / 2
				local minRadius = 0.5 - radius
				local maxRadius = 0.5 + radius

				for index = 1, 4 do
					local texture = self.RangeRing[index]
					if Quadrants[index] and Radius < private.DetectionRadius then
						-- Round and too large to fit
						texture:Hide()
					else
						local isLeft = index == 2 or index == 3
						local isTop = index <= 2
						texture:SetTexCoord(isLeft and minRadius or 0.5, isLeft and 0.5 or maxRadius, isTop and minRadius or 0.5, isTop and 0.5 or maxRadius)
						texture:Show()
					end
				end
			end
			self.RangeRing:Show()
		end

		local Side = Radius * 2
		Width, Height = private.GetMapSize(Map)

		-- Simplifies data decompression
		Width, Height = Width / Side, Height / Side

		X, Y = NewX / Side, NewY / Side
		Facing = NewFacing

		if RotateMinimap then
			FacingSin, FacingCos = Sin(Facing), Cos(Facing)
		end

		private.ApplyZone(self, Map, PaintPath)
	end
end

-- Force a repaint when the minimap swaps between indoor and outdoor zoom.
function panel:MINIMAP_UPDATE_ZOOM()
	local zoomLevel = Minimap:GetZoom()
	local insideZoomValue = _G.GetCVar("minimapInsideZoom")

	if _G.GetCVar("minimapZoom") == insideZoomValue then
		-- Indeterminate case
		-- Any change to make the cvars unequal
		Minimap:SetZoom(zoomLevel > 0 and zoomLevel - 1 or zoomLevel + 1)
	end

	IsInside = Minimap:GetZoom() == insideZoomValue + 0
	Minimap:SetZoom(zoomLevel)
	UpdateForce = true
	Radius = nil

	-- Update indoor alpha value
	if self.Alpha then
		self:SetAlpha(self.Alpha)
	end
end

local function SetCurrentZoneMapID()
	if _G.WorldMapFrame:IsVisible() then
		return
	end
	local originalMapID = _G.GetCurrentMapAreaID()

	_G.SetMapToCurrentZone()
	CurrentMapID = _G.GetCurrentMapAreaID()

	_G.SetMapByID(originalMapID)
end

-- Force a repaint and cache map size when changing zones.
function panel:ZONE_CHANGED_NEW_AREA()
	SetCurrentZoneMapID()
	UpdateForce = true
end

panel.PLAYER_LOGIN = panel.ZONE_CHANGED_NEW_AREA

do
	local PreviousMapID

	-- Force a repaint if world map swaps back to the current zone (making player coordinates available).
	function panel:WORLD_MAP_UPDATE()
		local mapID = _G.GetCurrentMapAreaID()
		if PreviousMapID ~= mapID then
			PreviousMapID = mapID

			if mapID == CurrentMapID then
				UpdateForce = true
			end
		end
	end
end

function panel:OnShow()
	UpdateForce = true
end

do
	local GetPlayerMapPosition = GetPlayerMapPosition
	local GetCVarBool = GetCVarBool
	local GetPlayerFacing = GetPlayerFacing
	local GetCurrentMapAreaID = GetCurrentMapAreaID
	local UpdateNext = 0
	local LastX, LastY, LastFacing

	function panel:OnUpdate(elapsed)
		UpdateNext = UpdateNext - elapsed
		private.Modules.WorldMapTemplate.MouseOverCheck(self)
		if UpdateForce or UpdateNext <= 0 then
			UpdateNext = UpdateRate

			local playerX, playerY = GetPlayerMapPosition("player")
			playerX = playerX or 0
			playerY = playerY or 0

			-- If the coordinates are for wrong map
			if not CurrentMapID or (playerX == 0 and playerY == 0) or playerX < 0 or playerX > 1 or playerY < 0 or playerY > 1 or CurrentMapID ~= GetCurrentMapAreaID() then
				UpdateForce = nil
				self.RangeRing:Hide()
				private.TextureRemoveAll(self)
				return
			end

			RotateMinimap = GetCVarBool("rotateMinimap")
			UpdateRate = self[RotateMinimap and "UpdateRateRotating" or "UpdateRateDefault"]

			local playerFacing = RotateMinimap and GetPlayerFacing() or 0
			local mapWidth, mapHeight = private.GetMapSize(CurrentMapID)
			playerX = playerX * mapWidth
			playerY = playerY * mapHeight

			if UpdateForce or playerFacing ~= LastFacing or (playerX - LastX) ^ 2 + (playerY - LastY) ^ 2 >= self.UpdateDistance then
				UpdateForce = nil
				LastX, LastY = playerX, playerY
				LastFacing = playerFacing

				return self:Paint(CurrentMapID, playerX, playerY, playerFacing)
			end
		end
	end
end

do
	local FrameSetAlpha = panel.SetAlpha

	-- Fades overlay when indoors.
	function panel:SetAlpha(alpha, ...)
		return FrameSetAlpha(self, IsInside and alpha * panel.InsideAlphaMultiplier or alpha, ...)
	end
end

--- Reparents this canvas to Frame.
-- @return True if set successfully.
function panel:SetMinimapFrame(Frame)
	if self.ScrollFrame and self.ScrollFrame:GetParent() ~= Frame then
		self.ScrollFrame:SetParent(Frame)
		self.ScrollFrame:SetAllPoints()
		UpdateForce = true
		Radius = nil
		return true
	end
end

-- Force a repaint if shown paths change.
-- @param mapID AreaID that changed, or nil if all zones must update.
function panel:OnMapUpdate(mapID)
	if not mapID or mapID == CurrentMapID then
		UpdateForce = true
	end
end

function panel:OnEnable()
	self.ScrollFrame:Show()
	self:RegisterEvent("WORLD_MAP_UPDATE")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_LOGIN")
end

function panel:OnDisable()
	self.ScrollFrame:Hide()
	private.TextureRemoveAll(self)
	self:UnregisterEvent("WORLD_MAP_UPDATE")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
end

-- Initializes the canvas after its dependencies load.
function panel:OnLoad()
	self.ScrollFrame = _G.CreateFrame("ScrollFrame")
	self.ScrollFrame:Hide()
	self.ScrollFrame:SetScrollChild(self)

	self:SetAllPoints()
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnUpdate", self.OnUpdate)
	self:SetScript("OnEvent", private.Modules.OnEvent)
	self:RegisterEvent("MINIMAP_UPDATE_ZOOM")

	-- Hook to force a repaint when minimap zoom changes.
	_G.hooksecurefunc(Minimap, "SetZoom", function(self, zoom, ...)
		UpdateForce = true
		Radius = nil
	end)

	-- [ Quadrant ] = Texture
	local rangeRing = _G.CreateFrame("Frame", nil, self.ScrollFrame)
	self.RangeRing = rangeRing

	-- Setup the range ring's textures
	rangeRing:SetAllPoints()
	rangeRing:SetAlpha(0.8)

	local color = _G.NORMAL_FONT_COLOR

	for index = 1, 4 do
		local isLeft = index == 2 or index == 3
		local isTop = index <= 2

		local texture = rangeRing:CreateTexture()
		texture:SetPoint("LEFT", rangeRing, isLeft and "LEFT" or "CENTER")
		texture:SetPoint("RIGHT", rangeRing, isLeft and "CENTER" or "RIGHT")
		texture:SetPoint("TOP", rangeRing, isTop and "TOP" or "CENTER")
		texture:SetPoint("BOTTOM", rangeRing, isTop and "CENTER" or "BOTTOM")
		texture:SetTexture([[SPELLS\CIRCLE]])
		texture:SetBlendMode("ADD")
		texture:SetVertexColor(color.r, color.g, color.b)

		rangeRing[index] = texture
	end

	self:SetMinimapFrame(Minimap)
end

function panel:OnUnload()
	self:SetScript("OnShow", nil)
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnEvent", nil)
	self:UnregisterEvent("MINIMAP_UPDATE_ZOOM")
end

function panel:OnUnregister()
	self.Paint = nil
	self.OnShow = nil
	self.OnUpdate = nil
	self.MINIMAP_UPDATE_ZOOM = nil
	self.ZONE_CHANGED_NEW_AREA = nil
	self.WORLD_MAP_UPDATE = nil
	self.PLAYER_LOGIN = nil
end

function panel.RangeRingSetEnabled(Enable)
	private.Options.ModulesExtra["Minimap"].RangeRing = Enable
	panel.Config.RangeRing:SetChecked(Enable)

	if Enable then
		UpdateForce = true
	elseif panel.Loaded then
		panel.RangeRing:Hide()
	end
end

function panel.DetectionRingSetEnabled(Enable)
	private.Options.ModulesExtra["Minimap"].DetectionRing = Enable
	panel.Config.DetectionRing:SetChecked(Enable)
end

function panel:OnSynchronize(OptionsExtra)
	self.RangeRingSetEnabled(OptionsExtra.RangeRing ~= false)
	self.DetectionRingSetEnabled(OptionsExtra.DetectionRing ~= false)
end

private.Modules.Register("Minimap", panel, private.L.MODULE_MINIMAP)

local Config = panel.Config
local Checkbox = _G.CreateFrame("CheckButton", "$parentRangeRing", Config, "InterfaceOptionsCheckButtonTemplate")
Config.RangeRing = Checkbox
local DetectionRing = _G.CreateFrame("CheckButton", "$parentDetectionRing", Config, "InterfaceOptionsCheckButtonTemplate")
Config.DetectionRing =  DetectionRing

function Checkbox.setFunc(Enable)
	panel.RangeRingSetEnabled(Enable == "1")
end

function DetectionRing.setFunc(Enable)
	panel.DetectionRingSetEnabled(Enable == "1")
end

Checkbox:SetPoint("TOPLEFT", Config.Enabled, "BOTTOMLEFT")
local Label = _G[Checkbox:GetName() .. "Text"]
Label:SetPoint("RIGHT", Config, "RIGHT", -6, 0)
Label:SetJustifyH("LEFT")
Label:SetFormattedText(private.L.MODULE_RANGERING_FORMAT, private.DetectionRadius)
Checkbox:SetHitRectInsets(4, 4 - Label:GetStringWidth(), 4, 4)
Checkbox.SetEnabled = private.Config.ModuleCheckboxSetEnabled
Checkbox.tooltipText = private.L.MODULE_RANGERING_DESC
Config:AddControl(Checkbox)

DetectionRing:SetPoint("TOPLEFT", Checkbox, "BOTTOMLEFT")
local Label = _G[DetectionRing:GetName() .. "Text"]
Label:SetPoint("RIGHT", Config, "RIGHT", -6, 0)
Label:SetJustifyH("LEFT")
Label:SetFormattedText(private.L.MODULE_DETECTIONRING_FORMAT, private.DetectionRadius)
DetectionRing:SetHitRectInsets(4, 4 - Label:GetStringWidth(), 4, 4)
DetectionRing.SetEnabled = private.Config.DetectionRingSetEnabled
--DetectionRing.tooltipText = private.L.MODULE_RANGERING_DESC
Config:AddControl(DetectionRing)


Config:SetHeight(Config:GetHeight() + Checkbox:GetHeight() + DetectionRing:GetHeight())

function _G.NPCScanOverlayMinimap_Toggle()
	private.Modules[_G._NPCScanOverlayOptions.Modules.Minimap and "Disable" or "Enable"]("Minimap")
end
