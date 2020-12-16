--[[
	rollBar
		A dominos frame for rolling on items when in a party
--]]

local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos')

local ContainerFrame = Dominos:CreateClass('Frame', Dominos.Frame)

do
	function ContainerFrame:New(id, frame, description)
		local bar = ContainerFrame.proto.New(self, id, description)

		bar.repositionedFrame = frame
		bar.description = description

		bar:Layout()

		return bar
	end

	function ContainerFrame:GetDisplayName()
		if self.id == "roll" then
			return L.RollBarDisplayName
		end

		if self.id == "alerts" then
			return L.AlertsBarDisplayName
		end

		return ContainerFrame.proto:GetDisplayName()
	end

	function ContainerFrame:GetDescription()
		return self.description
	end

	function ContainerFrame:GetDefaults()
		return {
			point = 'LEFT',
			columns = 1,
			spacing = 2,
			showInPetBattleUI = true,
			showInOverrideUI = true,
		}
	end

	function ContainerFrame:Layout()
		local frame = self.repositionedFrame

		frame:ClearAllPoints()
		frame:SetPoint('BOTTOM', self)

		local pW, pH = self:GetPadding()
		self:SetSize(317 + pW, 119 + pH)
	end

	function ContainerFrame:OnCreateMenu(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')

		local panel = menu:NewPanel(l.Layout)

		panel.scaleSlider = panel:NewScaleSlider()
		panel.paddingSlider = panel:NewPaddingSlider()

		menu:AddFadingPanel()
	end
end

local ContainerFrameModule = Dominos:NewModule('RollBars')

do
	function ContainerFrameModule:OnInitialize()
		-- exports
		-- luacheck: push ignore 122
		_G.GroupLootContainer.ignoreFramePositionManager = true
		_G.AlertFrame.ignoreFramePositionManager = true
		-- luacheck: pop
	end

	function ContainerFrameModule:Load()
		self.frames = {
			ContainerFrame:New('roll', _G.GroupLootContainer, L.TipRollBar)
		}

		if Dominos:IsBuild("retail") then
			table.insert(self.frames, ContainerFrame:New('alerts', _G.AlertFrame))
		end
	end

	function ContainerFrameModule:Unload()
		for _, frame in pairs(self.frames) do
			frame:Free()
		end
	end
end
