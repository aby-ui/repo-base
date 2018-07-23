local Recount = _G.Recount

local revision = tonumber(string.sub("$Revision: 1441 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local pairs = pairs
local string = string
local table = table
local type = type

local GetScreenWidth = GetScreenWidth
local PlaySound = PlaySound

local ColorPickerFrame = ColorPickerFrame
local OpacitySliderFrame = OpacitySliderFrame

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local Colors = {}
Recount.Colors = Colors

local ItemsToUpdate = {}
local TypeToUpdate = {}
local ColorMultiplier = {}
local TextureBackgroundsToUpdate = {}


local TYPE_TEXTURE = 1
local TYPE_BORDER = 2
local TYPE_BACKGROUND = 3
local TYPE_FUNC = 4
local TYPE_FONT = 5

local Cur_Branch
local Cur_Name
local TempColor = {}
local PreviousColor = {}

local function Color_Change()
	local r, g, b = ColorPickerFrame:GetColorRGB()

	TempColor.r = r
	TempColor.g = g
	TempColor.b = b
	if not ColorPickerFrame.hasOpacity then
		TempColor.a = nil
	else
		TempColor.a = 1.0 - OpacitySliderFrame:GetValue()
	end

	Colors:SetColor(Cur_Branch, Cur_Name, TempColor)
end

local function Opacity_Change()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = 1.0 - OpacitySliderFrame:GetValue()

	TempColor.r = r
	TempColor.g = g
	TempColor.b = b
	TempColor.a = a

	Colors:SetColor(Cur_Branch, Cur_Name, TempColor)
end

local function Fake_Change()
end

local function Color_Cancel()
	Colors:SetColor(Cur_Branch, Cur_Name, PreviousColor)
end

function Colors:GetColor(Branch, Name)
	if Branch == "Class" then
		if not Recount.db.profile.Colors[Branch][Name] then
			local classcol
			if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[Name] then
				classcol = CUSTOM_CLASS_COLORS[Name]
			else
				classcol = RAID_CLASS_COLORS[Name]
			end
			classcol.a = 1
			return classcol
		end
	elseif Branch == "Realtime" then
		if not Recount.db.profile.Colors[Branch][Name] then
			if string.find(Name,"Top$") then
				return {r = 1.0, g = 0.0, b = 0.0, a = 1.0}
			else
				return {r = 0.2, g = 0.0, b = 0.0, a = 0.4}
			end
		end
	end
	if Recount.db.profile.Colors[Branch][Name] and not Recount.db.profile.Colors[Branch][Name].a then
		Recount.db.profile.Colors[Branch][Name].a = 1
	end

	return Recount.db.profile.Colors[Branch][Name]
end

local LastSet

function Colors:SetColor(Branch, Name, c)
	if type(Recount.db.profile.Colors[Branch][Name]) ~= "table" then
		Recount.db.profile.Colors[Branch][Name] = {}
	end
	Recount.db.profile.Colors[Branch][Name].r = c.r
	Recount.db.profile.Colors[Branch][Name].g = c.g
	Recount.db.profile.Colors[Branch][Name].b = c.b

	--[[if c.a and Branch ~= "Class" then
		Recount.db.profile.Colors[Branch][Name].a = c.a
	elseif c.a and Branch == "Class" then
		Recount.db.profile.Colors[Branch][Name].a = nil
	end]]
	Recount.db.profile.Colors[Branch][Name].a = c.a

	Colors:UpdateColor(Branch, Name)
end

function Colors:UpdateAllColors()
	local c
	for k1, Branch in pairs(ItemsToUpdate) do
		for k2, Name in pairs(Branch) do
			c = Recount.db.profile.Colors[k1][k2]
			if c then
				Colors:SetColor(k1, k2, c)
			end
		end
	end
end

function Colors:UpdateColor(Branch, Name)

	local c = Colors:GetColor(Branch, Name)

	local Items = ItemsToUpdate[Branch][Name]

	if LastSet ~= Name then
		LastSet = Name
	end

	for k, v in pairs(TypeToUpdate[Branch][Name]) do
		if v == TYPE_TEXTURE then
			local Multi = ColorMultiplier[Branch][Name][k]
			if c.a then
				if Multi then
					Items[k]:SetVertexColor(c.r * Multi.r, c.g * Multi.g, c.b * Multi.b, c.a * Multi.a)
				else
					Items[k]:SetVertexColor(c.r, c.g, c.b, c.a)
				end
			else
				if Multi then
					Items[k]:SetVertexColor(c.r * Multi.r, c.g * Multi.g, c.b * Multi.b)
				else
					Items[k]:SetVertexColor(c.r, c.g, c.b)
				end
			end
		elseif v == TYPE_BORDER then
			if c.a then
				Items[k]:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
			else
				Items[k]:SetBackdropBorderColor(c.r, c.g, c.b)
			end
		elseif v == TYPE_BACKGROUND then
			if c.a then
				Items[k]:SetBackdropColor(c.r, c.g, c.b, c.a)
			else
				Items[k]:SetBackdropColor(c.r, c.g, c.b)
			end
		elseif v == TYPE_FUNC then
			Items[k][1](Items[k][2],{c.r, c.g, c.b, c.a})
		elseif v == TYPE_FONT then
			if c.a then
				Items[k]:SetTextColor(c.r, c.g, c.b, c.a)
			else
				Items[k]:SetTextColor(c.r, c.g, c.b)
			end
		end
	end
end


function Colors:UnregisterItem(Item)
	for k1, Branch in pairs(ItemsToUpdate) do
		for k2, Name in pairs(Branch) do
			for k, v in pairs(Name) do
				if v == Item then
					Name[k] = nil
					TypeToUpdate[k1][k2][k] = nil
					ColorMultiplier[k1][k2][k] = nil
				end
			end
		end
	end
end

function Colors:RegisterFunction(Branch, Name, Func, Pass)
	local c = Colors:GetColor(Branch, Name)
	if c.a then
		Func(Pass,{c.r, c.g, c.b, c.a})
	else
		Func(Pass,{c.r, c.g, c.b})
	end

	if type(ItemsToUpdate[Branch]) ~= "table" then
		ItemsToUpdate[Branch] = {}
		TypeToUpdate[Branch] = {}
		ColorMultiplier[Branch] = {}
	end

	if type(ItemsToUpdate[Branch][Name]) ~= "table" then
		ItemsToUpdate[Branch][Name] = {}
		TypeToUpdate[Branch][Name] = {}
		ColorMultiplier[Branch][Name] = {}
	end

	table.insert(ItemsToUpdate[Branch][Name],{Func, Pass})
	table.insert(TypeToUpdate[Branch][Name],TYPE_FUNC)
end

function Colors:RegisterTexture(Branch, Name, Texture, Multi)
	local c = Colors:GetColor(Branch, Name)

	if not Texture.SetVertexColor then
		Texture.SetVertexColor = Texture.SetStatusBarColor
	end

	if c.a then
		if Multi then
			Texture:SetVertexColor(c.r * Multi.r, c.g * Multi.g, c.b * Multi.b, c.a * Multi.a)
		else
			Texture:SetVertexColor(c.r, c.g, c.b, c.a)
		end
	else
		if Multi then
			Texture:SetVertexColor(c.r * Multi.r, c.g * Multi.g, c.b * Multi.b)
		else
			Texture:SetVertexColor(c.r, c.g, c.b)
		end
	end

	if type(ItemsToUpdate[Branch]) ~= "table" then
		ItemsToUpdate[Branch] = {}
		TypeToUpdate[Branch] = {}
		ColorMultiplier[Branch] = {}
	end

	if type(ItemsToUpdate[Branch][Name]) ~= "table" then
		ItemsToUpdate[Branch][Name] = {}
		TypeToUpdate[Branch][Name] = {}
		ColorMultiplier[Branch][Name] = {}
	end

	local entry = #ItemsToUpdate[Branch][Name] + 1
	table.insert(ItemsToUpdate[Branch][Name],Texture)
	table.insert(TypeToUpdate[Branch][Name],TYPE_TEXTURE)

	if Multi then
		ColorMultiplier[Branch][Name][entry] = Multi
	end
end

function Colors:RegisterBorder(Branch, Name, frame)
	local c = Colors:GetColor(Branch, Name)
	if c.a then
		frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
	else
		frame:SetBackdropBorderColor(c.r, c.g, c.b)
	end

	if type(ItemsToUpdate[Branch]) ~= "table" then
		ItemsToUpdate[Branch] = {}
		TypeToUpdate[Branch] = {}
		ColorMultiplier[Branch] = {}
	end

	if type(ItemsToUpdate[Branch][Name]) ~= "table" then
		ItemsToUpdate[Branch][Name] = {}
		TypeToUpdate[Branch][Name] = {}
		ColorMultiplier[Branch][Name] = {}
	end

	table.insert(ItemsToUpdate[Branch][Name],frame)
	table.insert(TypeToUpdate[Branch][Name],TYPE_BORDER)
end

function Colors:RegisterBackground(Branch, Name, frame)
	local c = Colors:GetColor(Branch, Name)
	if c.a then
		frame:SetBackdropColor(c.r, c.g, c.b, c.a)
	else
		frame:SetBackdropColor(c.r, c.g, c.b)
	end

	if type(ItemsToUpdate[Branch]) ~= "table" then
		ItemsToUpdate[Branch] = {}
		TypeToUpdate[Branch] = {}
		ColorMultiplier[Branch] = {}
	end

	if type(ItemsToUpdate[Branch][Name]) ~= "table" then
		ItemsToUpdate[Branch][Name] = {}
		TypeToUpdate[Branch][Name] = {}
		ColorMultiplier[Branch][Name] = {}
	end

	table.insert(ItemsToUpdate[Branch][Name],frame)
	table.insert(TypeToUpdate[Branch][Name],TYPE_BACKGROUND)
end

function Colors:RegisterFont(Branch, Name, frame)
	local c = Colors:GetColor(Branch, Name)
	if c.a then
		frame:SetTextColor(c.r, c.g, c.b, c.a)
	else
		frame:SetTextColor(c.r, c.g, c.b)
	end

	if type(ItemsToUpdate[Branch]) ~= "table" then
		ItemsToUpdate[Branch] = {}
		TypeToUpdate[Branch] = {}
		ColorMultiplier[Branch] = {}
	end

	if type(ItemsToUpdate[Branch][Name]) ~= "table" then
		ItemsToUpdate[Branch][Name] = {}
		TypeToUpdate[Branch][Name] = {}
		ColorMultiplier[Branch][Name] = {}
	end

	table.insert(ItemsToUpdate[Branch][Name],frame)
	table.insert(TypeToUpdate[Branch][Name],TYPE_FONT)
end

function Colors:EditColor(Branch, Name, Attach)
	Cur_Branch = Branch
	Cur_Name = Name

	ColorPickerFrame:Hide()
	PlaySound(856)
	local r, g, b = ColorPickerFrame:GetColorRGB()

	local c = Colors:GetColor(Branch, Name)

	if c.a then
		ColorPickerFrame.hasOpacity = true
		ColorPickerFrame.opacity = 1.0 - c.a
		ColorPickerFrame.opacityFunc = Opacity_Change -- Elsia: Was Color_Change
	else
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame.opacityFunc = nil
	end
	ColorPickerFrame.func = Color_Change

	ColorPickerFrame:SetColorRGB(c.r, c.g, c.b)
	--ColorPickerFrame.previousValues = c
	PreviousColor.r, PreviousColor.g, PreviousColor.b = c.r, c.g, c.b
	ColorPickerFrame.cancelFunc = Color_Cancel

	ColorPickerFrame:ClearAllPoints()
	if Attach then
		local leftPos = Attach:GetLeft() -- Elsia: Side code adapted from Mirror
		local rightPos = Attach:GetRight()
		local side
		local oside
		if not rightPos then
			rightPos = 0
		end
		if not leftPos then
			leftPos = 0
		end

		local rightDist = GetScreenWidth() - rightPos

		if leftPos and rightDist < leftPos then
			side = "LEFT"
			oside = "RIGHT"
		else
			side = "RIGHT"
			oside = "LEFT"
		end

		ColorPickerFrame:SetPoint(oside, Attach, side, 0, 0)
	end
	ColorPickerFrame:Show()
end

--[[function Colors:Debug()
	for k1, Branch in pairs(ItemsToUpdate) do
		for k2, Name in pairs(Branch) do
			Recount:Print(getn(Name).." "..k1.." "..k2)

			local Items = ItemsToUpdate[k1][k2]

			for k, v in pairs(TypeToUpdate[k1][k2]) do
				if v == TYPE_TEXTURE then
					Recount:Print("Texture:" .. getn(Items[k]))
				elseif v == TYPE_BORDER then
					Recount:Print("Border:" .. getn(Items[k]))
				elseif v == TYPE_BACKGROUND then
					Recount:Print("Background:" .. getn(Items[k]))
				elseif v == TYPE_FUNC then
					Recount:Print("Func:" .. getn(Items[k]))
				elseif v == TYPE_FONT then
					Recount:Print("Font:" .. getn(Items[k]))
				end
			end
		end
	end
end]]
