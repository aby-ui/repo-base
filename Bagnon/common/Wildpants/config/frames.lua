--[[
	frames.lua
		Frame specific settings menu
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):GetLocale(CONFIG)
local ADDON, Addon = CONFIG:match('[^_]+'), _G[CONFIG:match('[^_]+')]
local Frames = Addon.GeneralOptions:New('FrameOptions', CreateAtlasMarkup('Vehicle-HammerGold-2'))

function Frames:Populate()
  -- Selection
  self.sets = Addon.profile[self.frame]
  self:AddFrameChoice()

  local enabled = Addon.Frames:IsEnabled(self.frame)
  local enable = self:AddCheck('enabled')
  enable:SetValue(enabled)
  enable:SetCall('OnInput', function()
    local addon = Addon.Frames:Get(self.frame).addon
    if addon then
      if enabled then
        DisableAddOn(addon)
      else
        EnableAddOn(addon)
      end
    end
  end)

  if enabled then
    -- Display
		self:Add('Header', DISPLAY, 'GameFontHighlight', true)
		self:AddRow(Config.displayRowHeight, function()
			if Config.components then
				if self.frame ~= 'guild' then
					self:AddCheck('bagToggle')
				end

        self:AddCheck('sort')
				self:AddCheck('search')
				self:AddCheck('options')

				if self.frame ~= 'vault' then
					self:AddCheck('money')

          if not Addon.IsClassic and self.frame ~= 'guild' then
            self:AddCheck('currency')
          end
				end

        self:AddCheck('broker')
			end

			if Config.tabs then
				self:AddCheck('leftTabs')
			end
		end)

		-- Appearance
		self:Add('Header', L.Appearance, 'GameFontHighlight', true)
		self:AddRow(70, function()
			if Config.colors then
				self:AddColor('color')
				self:AddColor('borderColor')
			end

			self:AddCheck('reverseBags')
			self:AddCheck('reverseSlots')
			self:AddCheck('bagBreak')

			if REAGENTBANK_CONTAINER and self.frame == 'bank' then
				self:AddCheck('exclusiveReagent')
			end
		end)

    self:AddRow(150, function()
      self:AddChoice {arg = 'strata', {key = 'LOW', text = LOW}, {key = 'MEDIUM', text = AUCTION_TIME_LEFT2}, {key = 'HIGH', text = HIGH}}
      self:AddPercentage('alpha')
      self:AddPercentage('scale', 20, 300)
      self:AddPercentage('itemScale', 20, 200)
      self:AddSlider('spacing', -15, 15)

      if Config.columns then
        self:AddSlider('columns', 1, 50)
      end
    end)
  end
end
