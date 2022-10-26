


function BattleGroundEnemies:NewContainer(playerButton, createChildF, setupChildF)
	local f = CreateFrame("Frame", nil, playerButton)

	f.inputs = {}
	f.childFrames = {}

	function f:Display()
		if not self.config then return end
		local config = self.config.Container
		if not config then return end
		
		local verticalGrowdirection = config.VerticalGrowdirection
		local horizontalGrowdirection = config.HorizontalGrowDirection
		local framesPerRow = config.IconsPerRow
		local horizontalSpacing = config.HorizontalSpacing
		local verticalSpacing = config.VerticalSpacing
		local iconSize = config.IconSize
		local useButtonHeightAsSize = config.UseButtonHeightAsSize


		if useButtonHeightAsSize then iconSize = playerButton:GetHeight() end

		local growLeft = horizontalGrowdirection == "leftwards"
		local growUp = verticalGrowdirection == "upwards"
		self:Show()
		local widestRow = 0
		local highestColumn = 0
		local numInputs = #self.inputs
		local pointX, offsetX, offsetY, pointY, offsetDirectionX, offsetDirectionY


		if growLeft then
			pointX = "RIGHT"
			offsetDirectionX = -1
		else
			pointX = "LEFT"
			offsetDirectionX = 1
		end

		if growUp then
			pointY = "BOTTOM"
			offsetDirectionY = 1
		else
			pointY = "TOP"
			offsetDirectionY = -1
		end

		local point = pointY..pointX

		local column = 1
		local row = 1

		for i = 1, numInputs do
			local childFrame = self.childFrames[i]
			if not childFrame then
				childFrame = createChildF(playerButton, f)
				function childFrame:Remove()
					table.remove(f.inputs, self.key)
					f:Display()
				end
			end

			childFrame:SetSize(iconSize, iconSize)


			self.childFrames[i] = childFrame
			childFrame.key = i


			childFrame.input = self.inputs[i]
			setupChildF(f, childFrame, self.inputs[i])
			

			childFrame:ClearAllPoints()

			local rowWidth
			local columnHeight

			if column > 1 then
				offsetX = (column - 1) * (iconSize + horizontalSpacing) * offsetDirectionX
				rowWidth =  column * (iconSize + horizontalSpacing) - horizontalSpacing
			else
				offsetX = 0
				rowWidth = iconSize
			end

			if row > 1 then
				offsetY = (row - 1) * (iconSize + verticalSpacing) * offsetDirectionY
				columnHeight = row * (iconSize + verticalSpacing) - verticalSpacing
			else
				offsetY = 0
				columnHeight = iconSize
			end

			if rowWidth > widestRow then
				widestRow = rowWidth
			end
			if columnHeight > highestColumn then
				highestColumn = columnHeight
			end

			childFrame:SetPoint(point, self, point, offsetX, offsetY)
			childFrame:Show()

			if column < framesPerRow then
				column = column + 1
			else
				row = row + 1
				column = 1
			end
		end

		for i = numInputs + 1, #self.childFrames do --hide all unused frames
			local childFrame = self.childFrames[i]
			childFrame:Hide()
		end


		if numInputs == 0 then --This same as widestRow == 0 and highestColumn == 0
			self:SetWidth(0.01)
			self:SetHeight(iconSize)
			self:Hide()
		else
			if widestRow == 0 then
				self:SetWidth(0.01)
			else
				self:SetWidth(widestRow)
			end

			if highestColumn == 0 then
				self:SetHeight(iconSize)
			else
				self:SetHeight(highestColumn)
			end
		end
	end

	function f:ResetInputs()
		wipe(self.inputs)
	end

	function f:NewInput(inputData)
		local key= #self.inputs + 1
		inputData.key = key
		self.inputs[key] = inputData
		return self.inputs[key]
	end

	function f:FindInputByAttribute(attribute, value)
		for i = 1, #self.inputs do
			if self.inputs[i][attribute] == value then
				return self.inputs[i]
			end
		end
	end

	function f:UpdateInput(input, inputData)
		Mixin(input, inputData)
		return input
	end

	function f:Reset()
		self:ResetInputs()
		self:Display()
	end

	function f:ApplyAllSettings()
		self:Display()
		for i = 1, #self.childFrames do
			local childFrame = self.childFrames[i]
			if childFrame.ApplyChildFrameSettings then childFrame:ApplyChildFrameSettings() end
		end
	end
	return f
end