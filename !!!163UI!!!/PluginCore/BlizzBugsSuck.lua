-- Fix missing bonus effects on shipyard map in non-English locales
-- Problem is caused by Blizzard checking a localized API value
-- against a hardcoded English string.
-- New in 6.2, confirmed still bugged in 7.0.3.22293
if GetLocale() ~= "enUS" then
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, name)
		if name == "Blizzard_GarrisonUI" then
			hooksecurefunc("GarrisonShipyardMap_SetupBonus", function(self, missionFrame, mission)
				if (mission.typePrefix == "ShipMissionIcon-Bonus" and not missionFrame.bonusRewardArea) then
					missionFrame.bonusRewardArea = true
					for id, reward in pairs(mission.rewards) do
						local posX = reward.posX or 0
						local posY = reward.posY or 0
						posY = posY * -1
						missionFrame.BonusAreaEffect:SetAtlas(reward.textureAtlas, true)
						missionFrame.BonusAreaEffect:ClearAllPoints()
						missionFrame.BonusAreaEffect:SetPoint("CENTER", self.MapTexture, "TOPLEFT", posX, posY)
						break
					end
				end
			end)
			self:UnregisterAllEvents()
		end
	end)
end