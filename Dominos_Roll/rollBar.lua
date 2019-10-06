--[[
	rollBar
		A dominos frame for rolling on items when in a party
--]]

local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos')

local ContainerFrame = Dominos:CreateClass('Frame', Dominos.Frame)

do
	function ContainerFrame:New(id, frame, tooltip)
		local bar = ContainerFrame.proto.New(self, id, tooltip)

		bar.repositionedFrame = frame

		bar:Layout()

		return bar
	end

	function ContainerFrame:GetDefaults()
		return {
			point = 'BOTTOM',
            x = 0,
            y = 128,
			columns = 1,
			spacing = 2,
			showInPetBattleUI = true,
			showInOverrideUI = true,
		}
	end

	function ContainerFrame:Layout()
		local frame = self.repositionedFrame

		frame:ClearAllPoints()
		frame:SetPoint('BOTTOM', self.header)

		local pW, pH = self:GetPadding()
		self:SetSize(317 + pW, 119 + pH)
	end

	function ContainerFrame:CreateMenu()
		local menu = Dominos:NewMenu(self.id)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

		local panel = menu:NewPanel(l.Layout)

		panel.opacitySlider = panel:NewOpacitySlider()
		panel.fadeSlider = panel:NewFadeSlider()
		panel.scaleSlider = panel:NewScaleSlider()
		panel.paddingSlider = panel:NewPaddingSlider()

		self.menu = menu
	end
end

local ContainerFrameModule = Dominos:NewModule('RollBars')

do
	function ContainerFrameModule:OnInitialize()
		-- exports
		-- luacheck: push ignore 122
		GroupLootContainer.ignoreFramePositionManager = true
		AlertFrame.ignoreFramePositionManager = true
		-- luacheck: pop
	end

	function ContainerFrameModule:Load()
		self.frames = {
			ContainerFrame:New('roll', _G.GroupLootContainer, L.TipRollBar)
		}

		if Dominos:IsBuild("retail") then
			tinsert(self.frames, ContainerFrame:New('alerts', _G.AlertFrame))
		end
	end

	function ContainerFrameModule:Unload()
		for _, frame in pairs(self.frames) do
			frame:Free()
		end
	end
end
