local GlobalAddonName, ExRT = ...

local ELib,L = ExRT.lib,ExRT.L
local module = ExRT:New("VisNote",L.VisualNote)

local VMRT = nil

local wipe, pairs, type, max, min, unpack, abs, select, sqrt, tremove, string, floor, math, PI = wipe, pairs, type, max, min, unpack, abs, select, sqrt, tremove, string, floor, math, PI

local LibDeflate = LibStub:GetLibrary("LibDeflate")

module.db.await = {}

local DATA_VERSION = 2

function module.options:Load()
	self:CreateTilte()
	self.title:Point(2,5)

	local special_counter = 0
	local update_tmr = 0
	local isLiveSession = false
	self:SetScript("OnUpdate",function(self,elapsed)
		update_tmr = update_tmr + elapsed
		if update_tmr > 1 then
			update_tmr = 0
			if special_counter > 0 then
				special_counter = 0
				module.options:SaveData()
				if isLiveSession then
					module.options:GenerateString(true)
				end
			end
		end
	end)

	local timers = {}

	local dots = {}
	local dot_size,half_dot_size_sq = 6,4
	local dots_pos_X,dots_pos_Y = {},{}
	local dots_SIZE,dots_COLOR,dots_GROUP = {},{},{}
	local dots_OBJ,dots_SYNC = {},{}

	local icons = {}
	local icon_pos_X,icon_pos_Y = {},{}
	local icon_SIZE,icon_TYPE,icon_GROUP = {},{},{}
	local icon_OBJ,icon_SYNC = {},{}

	local texts = {}
	local text_pos_X,text_pos_Y = {},{}
	local text_SIZE,text_DATA,text_GROUP,text_COLOR = {},{},{},{}
	local text_OBJ,text_SYNC = {},{}

	local objects = {}
	local object_pos_X,object_pos_Y = {},{}
	local object_SIZE,object_GROUP,object_COLOR,object_TYPE = {},{},{},{}
	local object_DATA1,object_DATA2,object_SYNC = {},{},{}

	local images = {}
	local image_pos_X,image_pos_Y = {},{}
	local image_pos_X2,image_pos_Y2 = {},{}
	local image_path,image_alpha = {},{}
	local image_GROUP = {}
	local image_OBJ,image_SYNC = {},{}

	local lines = {}

	local locked_img = {}

	local lockedGroups = {}

	local backgrounds = {}
	local curr_group = 0
	local curr_color = 4
	local curr_map = 1
	local curr_data = {}
	local curr_icon = 1
	local curr_text = ""
	local curr_imgpath = ExRT.isClassic and "interface/icons/ability_hunter_snipershot" or "interface/icons/achievement_boss_archaedas"
	local curr_object = 1
	local curr_trans = 100

	local tool_selected = 1

	module.db.opt_data = {
		dots = dots,
		dots_pos_X = dots_pos_X,
		dots_pos_Y = dots_pos_Y,
		dots_SIZE = dots_SIZE,
		dots_COLOR = dots_COLOR,
		dots_GROUP = dots_GROUP,
		dots_OBJ = dots_OBJ,
		dots_SYNC = dots_SYNC,

		icons = icons,
		icon_pos_X = icon_pos_X,
		icon_pos_Y = icon_pos_Y,
		icon_SIZE = icon_SIZE,
		icon_TYPE = icon_TYPE,
		icon_GROUP = icon_GROUP,
		icon_OBJ = icon_OBJ,
		icon_SYNC = icon_SYNC,

		texts = texts,
		text_pos_X = text_pos_X,
		text_pos_Y = text_pos_Y,
		text_SIZE = text_SIZE,
		text_DATA = text_DATA,
		text_COLOR = text_COLOR,
		text_GROUP = text_GROUP,
		text_OBJ = text_OBJ,
		text_SYNC = text_SYNC,

		objects = objects,
		object_pos_X = object_pos_X,
		object_pos_Y = object_pos_Y,
		object_SIZE = object_SIZE,
		object_GROUP = object_GROUP,
		object_COLOR = object_COLOR,
		object_TYPE = object_TYPE,
		object_DATA1 = object_DATA1,
		object_DATA2 = object_DATA2,
		object_SYNC = object_SYNC,

		lines = lines,

		images = images,
		image_pos_X = image_pos_X,
		image_pos_Y = image_pos_Y,
		image_pos_X2 = image_pos_X2,
		image_pos_Y2 = image_pos_Y2,
		image_path = image_path,
		image_alpha = image_alpha,
		image_GROUP = image_GROUP,
		image_OBJ = image_OBJ,
		image_SYNC = image_SYNC,

		locked_img = locked_img,

		backgrounds = backgrounds,
	}

	local colors = {
		{0,0,0},
		{127/255,127/255,127/255},
		{136/255,0/255,21/255},
		{237/255,28/255,36/255},
		{255/255,127/255,39/255},
		{255/255,242/255,0/255},
		{34/255,177/255,76/255},
		{0/255,162/255,232/255},
		{63/255,72/255,204/255},
		{163/255,73/255,164/255},

		{1,1,1},
		{195/255,195/255,195/255},
		{185/255,122/255,87/255},
		{255/255,174/255,201/255},
		{255/255,201/255,14/255},
		{239/255,228/255,176/255},
		{181/255,230/255,29/255},
		{153/255,217/255,234/255},
		{112/255,146/255,190/255},
		{200/255,191/255,231/255},

		{0.67,0.83,.45},
		{0,1,.59},
		{.53,.53,.93},
		{.64,.19,.79},
	}

	local icons_list = {
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_5",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
		"Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
		{"Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0,0.26171875,0.26171875,0.5234375},
		{"Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0,0.26171875},
		{"Interface\\LFGFrame\\UI-LFG-ICON-ROLES",0.26171875,0.5234375,0.26171875,0.5234375},
		UnitFactionGroup("player") == "Alliance" and "Interface\\FriendsFrame\\PlusManz-Alliance" or "Interface\\FriendsFrame\\PlusManz-Horde",
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0,0.25},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.5,0.75},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0,0.25,0.25,0.5},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0,0.25},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.49609375,0.7421875,0.25,0.5},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.5,0.5,0.75},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0.25,0.5},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.25,0.49609375,0,0.25},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0.25,0.5},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.5,0.73828125,0.5,0.75},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0,0.25},
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",0.7421875,0.98828125,0.5,0.75},
	}

	local IsDotIn
	local LockedImgHideAll

	function self:Clear()
		for d,_ in pairs(dots) do
			d:Hide()
		end
		wipe(dots_pos_X)
		wipe(dots_pos_Y)
		wipe(dots_SIZE)
		wipe(dots_COLOR)
		wipe(dots_GROUP)
		wipe(dots_OBJ)
		wipe(dots_SYNC)

		for d,_ in pairs(icons) do
			d:Hide()
		end
		wipe(icon_pos_X)
		wipe(icon_pos_Y)
		wipe(icon_SIZE)
		wipe(icon_TYPE)
		wipe(icon_GROUP)
		wipe(icon_OBJ)
		wipe(icon_SYNC)

		for d,_ in pairs(texts) do
			d:Hide()
		end
		wipe(text_pos_X)
		wipe(text_pos_Y)
		wipe(text_SIZE)
		wipe(text_DATA)
		wipe(text_COLOR)
		wipe(text_GROUP)
		wipe(text_OBJ)
		wipe(text_SYNC)

		for d,_ in pairs(objects) do
			d:Hide()
		end
		wipe(object_pos_X)
		wipe(object_pos_Y)
		wipe(object_SIZE)
		wipe(object_GROUP)
		wipe(object_COLOR)
		wipe(object_TYPE)
		wipe(object_DATA1)
		wipe(object_DATA2)
		wipe(object_SYNC)

		for d,_ in pairs(lines) do
			d:Hide()
		end

		wipe(image_pos_X)
		wipe(image_pos_Y)
		wipe(image_pos_X2)
		wipe(image_pos_Y2)
		wipe(image_path)
		wipe(image_alpha)
		wipe(image_GROUP)
		wipe(image_OBJ)
		wipe(image_SYNC)

		for d,_ in pairs(images) do
			d:Hide()
		end
	end


	self.main = ELib:ScrollFrame(self):Size(790,535):Point("TOP",0,-81):Height(535)
	self.main.C:SetWidth(790-2)
	self.main.ScrollBar:Hide()

	-----------------------
	--- Select tools ------
	-----------------------

	function self:SetTool(data)
		if tool_selected == 7 then	--Hard fix
			LockedImgHideAll()
		end

		tool_selected = data.tool
		curr_object = data.object

		self.curr_color_texture:SetShown((data.color or data.icon or data.imgpath) and true or false)
		if data.color then
			self.curr_color_texture:SetColorTexture(unpack(data.color))
			if data.colorMini then
				for i=1,#self.color_selector_mini do self.color_selector_mini[i]:Show() end
				for i=1,#self.color_selector do self.color_selector[i]:Hide() end
			else
				for i=1,#self.color_selector do self.color_selector[i]:Show() end
				for i=1,#self.color_selector_mini do self.color_selector_mini[i]:Hide() end
			end
		else
			for i=1,#self.color_selector do self.color_selector[i]:Hide() end
			for i=1,#self.color_selector_mini do self.color_selector_mini[i]:Hide() end
		end

		if tool_selected == 4 and (curr_object == 3 or curr_object == 5 or curr_object == 6) then
			for i=1,#self.line_selector do 
				ELib:Border(self.line_selector[i],2,.24,.25,.30,1)
				self.line_selector[i]:Show() 
			end
			ELib:Border(curr_object == 3 and self.line_selector[1] or curr_object == 5 and self.line_selector[2] or curr_object == 6 and self.line_selector[3],2,.24,.7,.30,1)	
		else
			for i=1,#self.line_selector do self.line_selector[i]:Hide() end
		end

		if data.icon then
			self.curr_color_texture:SetTexture(data.icon)
			for i=1,#self.icon_selector do self.icon_selector[i]:Show() end
		else
			for i=1,#self.icon_selector do self.icon_selector[i]:Hide() end
		end
		
		if data.size then
			self.size:Show()
			self.size:SetTo(data.size)
		else
			self.size:Hide()
		end

		if data.transparent then
			self.trans:Show()
			self.trans:SetTo(data.transparent)			
		else
			self.trans:Hide()
		end

		if data.imgpath then
			self.imgpath:Show()
			self.imgpath:SetText(curr_imgpath)
			self.imgpath:SetCursorPosition(1)
			self.curr_color_texture:SetTexture(curr_imgpath)
		else
			self.imgpath:Hide()
		end

		self.textAddData:SetShown(data.text)

		for k,v in pairs(self) do
			if type(k)=='string' and k:find("^tool_select_") then
				ELib:Border(v,2,.24,.25,.30,1)
			end
		end
		ELib:Border(data.button,2,.24,.7,.30,1)		
	end

	self.tool_select_brush = ELib:Icon(self,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256",25,true):Point("TOPLEFT",10,-20):OnClick(function(self)
		module.options:SetTool{
			tool = 1,
			color = colors[curr_color],
			size = dot_size,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_brush,2,.24,.25,.30,1)
	self.tool_select_brush.texture:ClearAllPoints()
	self.tool_select_brush.texture:SetPoint("CENTER")
	self.tool_select_brush.texture:SetSize(8,8)

	self.tool_select_icons = ELib:Icon(self,"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",25,true):Point("LEFT",self.tool_select_brush,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 2,
			icon = icons_list[curr_icon],
			button = self,
		}
	end)
	ELib:Border(self.tool_select_icons,2,.24,.25,.30,1)
	self.tool_select_icons.texture:ClearAllPoints()
	self.tool_select_icons.texture:SetPoint("CENTER")
	self.tool_select_icons.texture:SetSize(20,20)

	self.tool_select_text = ELib:Icon(self,nil,25,true):Point("LEFT",self.tool_select_icons,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 3,
			color = colors[curr_color],
			text = true,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_text,2,.24,.25,.30,1)
	self.tool_select_text.texture:Hide()
	self.tool_select_text.text = self.tool_select_text:CreateFontString(nil,"ARTWORK","GameFontWhite")
	self.tool_select_text.text:SetFont(self.tool_select_text.text:GetFont(),10)
	self.tool_select_text.text:SetPoint("CENTER")
	self.tool_select_text.text:SetText("TEXT")


	self.tool_select_objects = ELib:Icon(self,"Interface\\TargetingFrame\\UI-RaidTargetingIcon_2",25,true):Point("LEFT",self.tool_select_text,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 4,
			object = 1,
			color = colors[curr_color],
			size = dot_size,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_objects,2,.24,.25,.30,1)
	self.tool_select_objects.texture:Hide()
	do
		local size = 8
		local circleLen = 2*PI*size
		local len = ceil(circleLen / (2 / 2))
		for i=0,len do
			local x = 0 + size * math.cos(2*PI/len*i)
			local y = 0 + size * math.sin(2*PI/len*i)

			local o = self.tool_select_objects:CreateTexture()
			o:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
			o:SetPoint("CENTER",self.tool_select_objects,"CENTER",x,-y)

			o:SetSize(2,2)
		end
	end


	self.tool_select_objects_fullcircle = ELib:Icon(self,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256",25,true):Point("TOPLEFT",self.tool_select_brush,"BOTTOMLEFT",0,-5):OnClick(function(self)
		module.options:SetTool{
			tool = 4,
			object = 2,
			color = colors[curr_color],
			transparent = curr_trans/2,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_objects_fullcircle,2,.24,.25,.30,1)
	self.tool_select_objects_fullcircle.texture:ClearAllPoints()
	self.tool_select_objects_fullcircle.texture:SetPoint("CENTER")
	self.tool_select_objects_fullcircle.texture:SetSize(20,20)
	self.tool_select_objects_fullcircle.texture:SetAlpha(.75)



	self.tool_select_objects_line = ELib:Icon(self,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256",25,true):Point("LEFT",self.tool_select_objects_fullcircle,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 4,
			object = 3,
			color = colors[curr_color],
			colorMini = true,
			size = dot_size,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_objects_line,2,.24,.25,.30,1)
	self.tool_select_objects_line.texture:Hide()
	do
		local l = self.tool_select_objects_line:CreateLine()
		
		l:SetStartPoint("CENTER",-8,-8)
		l:SetEndPoint("CENTER",8,8)

		l:SetColorTexture(1,1,1,1)
		l:SetThickness(2)
	end

	do
		self.line_selector = {}
		for i=1,3 do
			self.line_selector[i] = ELib:Icon(self,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256",30,true):Point("TOPLEFT",420 + 33 * (i-1),-35):OnClick(function(self)
				module.options:SetTool{
					tool = 4,
					object = (i == 1 and 3) or (i == 2 and 5) or (i == 3 and 6),
					color = colors[curr_color],
					colorMini = true,
					size = dot_size,
					button = self,
				}
			end)
			ELib:Border(self.line_selector[i],2,.24,.25,.30,1)
			self.line_selector[i].texture:Hide()
			do
				local l = self.line_selector[i]:CreateLine()
				
				l:SetStartPoint("CENTER",-8,-8)
				l:SetEndPoint("CENTER",8,8)
		
				l:SetColorTexture(1,1,1,1)
				l:SetThickness(2)

				if i == 3 then
					l:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/lineGapped","REPEAT")
					l:SetTexCoord(0,.15,0,1)
					l:SetThickness(4)
				elseif i == 2 then
					local lr = self.line_selector[i]:CreateLine()
					lr:SetStartPoint("CENTER",0,8)
					lr:SetEndPoint("CENTER",8,8)
			
					lr:SetColorTexture(1,1,1,1)
					lr:SetThickness(2)

					local ll = self.line_selector[i]:CreateLine()
					ll:SetStartPoint("CENTER",8,0)
					ll:SetEndPoint("CENTER",8,8)
			
					ll:SetColorTexture(1,1,1,1)
					ll:SetThickness(2)
				end
			end
		end
	end


	self.tool_select_objects_rectangle = ELib:Icon(self,nil,25,true):Point("LEFT",self.tool_select_objects_line,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 4,
			object = 4,
			color = colors[curr_color],
			transparent = curr_trans/2,
			button = self,
		}
	end):Icon(1,1,1,1)
	ELib:Border(self.tool_select_objects_rectangle,2,.24,.25,.30,1)
	self.tool_select_objects_rectangle.texture:ClearAllPoints()
	self.tool_select_objects_rectangle.texture:SetPoint("CENTER")
	self.tool_select_objects_rectangle.texture:SetSize(16,16)
	self.tool_select_objects_rectangle.texture:SetAlpha(.75)


	self.tool_select_move = ELib:Icon(self,"interface\\cursor\\ui-cursor-move",25,true):Point("LEFT",self.tool_select_objects_rectangle,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 5,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_move,2,.24,.25,.30,1)
	self.tool_select_move.texture:ClearAllPoints()
	self.tool_select_move.texture:SetPoint("CENTER")
	self.tool_select_move.texture:SetSize(18,18)
	self.tool_select_move.texture:SetAlpha(.75)


	self.tool_select_objects_image = ELib:Icon(self,curr_imgpath,25,true):Point("LEFT",self.tool_select_objects,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 6,
			imgpath = curr_imgpath,
			transparent = curr_trans/2,
			button = self,
		}
	end)
	ELib:Border(self.tool_select_objects_image,2,.24,.25,.30,1)
	self.tool_select_objects_image.texture:ClearAllPoints()
	self.tool_select_objects_image.texture:SetPoint("CENTER")
	self.tool_select_objects_image.texture:SetSize(20,20)
	self.tool_select_objects_image.texture:SetTexCoord(.1,.9,.1,.9)


	self.tool_select_objects_locker = ELib:Icon(self,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128",25,true):Point("LEFT",self.tool_select_move,"RIGHT",5,0):OnClick(function(self)
		module.options:SetTool{
			tool = 7,
			button = self,
		}
	end):Tooltip("Left click on note - Lock/unlock objects for moving/removing\nRight click on note - select specific object from all objects under cursor")
	ELib:Border(self.tool_select_objects_locker,2,.24,.25,.30,1)
	self.tool_select_objects_locker.texture:ClearAllPoints()
	self.tool_select_objects_locker.texture:SetPoint("CENTER")
	self.tool_select_objects_locker.texture:SetSize(20,20)
	self.tool_select_objects_locker.texture:SetTexCoord(.625,.6875,.5,.625)



	local COLOR_SIZE = 45
	self.curr_color_texture = self:CreateTexture()
	self.curr_color_texture:SetPoint("TOPLEFT",290,-31)
	self.curr_color_texture:SetSize(COLOR_SIZE,COLOR_SIZE)
	self.curr_color_texture:SetColorTexture(0,0,0)
	self.curr_color_texture._SetTexture = self.curr_color_texture.SetTexture
	function self.curr_color_texture:SetTexture(texture)
		if type(texture) == 'table' then
			self:SetTexCoord(select(2,unpack(texture)))
			self:_SetTexture(texture[1])
		else
			self:SetTexCoord(0,1,0,1)
			self:_SetTexture(texture)
		end
	end

	self.color_selector = {}
	for i=1,#colors do
		self.color_selector[i] = ELib:Icon(self,nil,floor(COLOR_SIZE / 2),true):Icon(unpack(colors[i])):OnClick(function()
			curr_color = i
			self.curr_color_texture:SetColorTexture(unpack(colors[i]))
		end)
		if i == 1 then
			self.color_selector[i]:NewPoint("TOPLEFT",self.curr_color_texture,"TOPRIGHT",1,0)
		elseif i == 11 then
			self.color_selector[i]:NewPoint("BOTTOMLEFT",self.curr_color_texture,"BOTTOMRIGHT",1,0)
		elseif i == 21 then
			self.color_selector[i]:NewPoint("LEFT",self.color_selector[10],"RIGHT",1,0)
		elseif i == 23 then
			self.color_selector[i]:NewPoint("LEFT",self.color_selector[20],"RIGHT",1,0)
		else
			self.color_selector[i]:NewPoint("LEFT",self.color_selector[i-1],"RIGHT",1,0)
		end
	end

	self.color_selector_mini = {}
	for i=1,#colors do
		local colorNum = i
		if i > 10 and i <= 12 then
			colorNum = i + 10
		elseif i > 12 and i <= 22 then
			colorNum = i - 2
		end

		self.color_selector_mini[i] = ELib:Icon(self,nil,floor((COLOR_SIZE - 3) / 4),true):Icon(unpack(colors[colorNum])):OnClick(function()
			curr_color = colorNum
			self.curr_color_texture:SetColorTexture(unpack(colors[colorNum]))
		end)
		if i == 1 then
			self.color_selector_mini[i]:NewPoint("TOPLEFT",self.curr_color_texture,"TOPRIGHT",1,-1)
		elseif (i - 1) % 6 == 0 then
			self.color_selector_mini[i]:NewPoint("TOP",self.color_selector_mini[i-6],"BOTTOM",0,-1)
		else
			self.color_selector_mini[i]:NewPoint("LEFT",self.color_selector_mini[i-1],"RIGHT",1,0)
		end
	end

	self.icon_selector = {}
	for i=1,#icons_list do
		local t = icons_list[i]
		self.icon_selector[i] = ELib:Icon(self,type(t)=='table' and t[1] or t,floor(COLOR_SIZE / 2),true):OnClick(function()
			curr_icon = i
			self.curr_color_texture:SetTexture(icons_list[i])
		end)
		if type(t)=='table' then
			self.icon_selector[i].texture:SetTexCoord(select(2,unpack(t)))
		end
		if i == 1 then
			self.icon_selector[i]:NewPoint("TOPLEFT",self.curr_color_texture,"TOPRIGHT",1,0)
		elseif i == 13 then
			self.icon_selector[i]:NewPoint("BOTTOMLEFT",self.curr_color_texture,"BOTTOMRIGHT",1,0)
		else
			self.icon_selector[i]:NewPoint("LEFT",self.icon_selector[i-1],"RIGHT",1,0)
		end
	end

	self.size = ELib:Slider(self,L.VisualNoteSize):Size(100):Point("TOPLEFT",170,-50):Range(3,36):SetTo(8):OnChange(function(self,val)
		dot_size = floor(val+0.5)
		half_dot_size_sq = (dot_size / 3) ^ 2
		self.tooltipText = dot_size
		self:tooltipReload()
	end)

	self.trans = ELib:Slider(self,L.bossmodsalpha):Size(100):Point("TOPLEFT",170,-50):Range(1,50):SetTo(50):OnChange(function(self,val)
		curr_trans = floor(val+0.5) * 2
		self.tooltipText = curr_trans
		self:tooltipReload()
	end)
	self.trans.Low:SetText("0%")
	self.trans.High:SetText("100%")
	self.trans.Low.SetText = function() end
	self.trans.High.SetText = function() end

	self.textAddData = ELib:Edit(self):Size(100,20):Point("TOPLEFT",160,-50):TopText(L.VisualNoteTextToAdd):OnChange(function(self)
		curr_text = self:GetText()
	end)
	self.textAddData:SetMaxBytes(100)
	self.textAddData.Button = ELib:Templates_GUIcons(3,self.textAddData)
	self.textAddData.Button:SetPoint("LEFT",self.textAddData,"RIGHT",1,0)
	self.textAddData.Button:SetSize(20,20)
	ELib:Border(self.textAddData.Button,1,.24,.25,.30,1)

	local classToColor = {
		WARRIOR=13,
		PALADIN=14,
		HUNTER=21,
		ROGUE=6,
		PRIEST=11,
		DEATHKNIGHT=4,
		SHAMAN=9,
		MAGE=8,
		WARLOCK=23,
		MONK=22,
		DRUID=5,
		DEMONHUNTER=24,
	}

	local function TextAddData_SetValue(_,arg1,arg2)
		ELib:DropDownClose()
		self.textAddData:SetText(arg1)
		curr_color = arg2
		self.curr_color_texture:SetColorTexture(unpack(colors[arg2]))
	end

	self.textAddData.Button:SetScript("OnClick",function(self)
		self.List = {}

		for _, name, _, class in ExRT.F.IterateRoster do
			name = ExRT.F.delUnitNameServer(name)
			local colorTable = colors[ classToColor[class] ]
			self.List[#self.List + 1] = {
				text = name,
				colorCode = "|cff"..format("%02x%02x%02x",colorTable[1]*255,colorTable[2]*255,colorTable[3]*255),
				justifyH = "CENTER",
				arg1 = name,
				arg2 = classToColor[class],
				func = TextAddData_SetValue,
			}
		end

		ELib.ScrollDropDown.ClickButton(self)
	end)
	self.textAddData.Button.Width = 200
	self.textAddData.Button.Lines = 20
	self.textAddData.Button.isButton = true
	self.textAddData.Button.isModern = true

	self.imgpath = ELib:Edit(self,curr_imgpath):Size(250,20):Point("LEFT",self.curr_color_texture,"RIGHT",10,0):TopText("Image path:"):OnChange(function(self)
		curr_imgpath = self:GetText():trim()
		curr_imgpath = tonumber(curr_imgpath) or curr_imgpath
		module.options.curr_color_texture:SetTexture(curr_imgpath)
	end)


	self.tool_select_brush:Click()

	---------------------
	--- Background ------
	---------------------

	local function GetBackground()
		local dot
		for d,_ in pairs(backgrounds) do
			if not d:IsShown() then
				dot = d
				break
			end
		end
		if not dot then
			dot = self.main.C:CreateTexture(nil,"BACKGROUND")
			backgrounds[dot] = true
		end
		dot:Show()
		return dot
	end
	local function SetBackground(background,centerX,centerY,scale)
		for b,_ in pairs(backgrounds) do
			b:Hide()
		end
		if type(background) == 'string' then
			local b = GetBackground()
			b:SetSize(self.main:GetSize())
			b:SetTexture(background)
			b:SetPoint("TOPLEFT",0,0)
			return b
		elseif type(background) == 'table' then
			local b = GetBackground()
			b:SetSize(self.main:GetSize())
			b:SetColorTexture(unpack(background))
			b:SetPoint("TOPLEFT",0,0)
			return b
		elseif type(background) == 'number' then
			local layers = C_Map.GetMapArtLayers(background)
			if layers and layers[1] then
				local layerInfo = layers[1]

				local backData = C_Map.GetMapArtLayerTextures(background,1)

				local widthCount = ceil(layerInfo.layerWidth/layerInfo.tileWidth)
				local heightCount = ceil(layerInfo.layerHeight/layerInfo.tileHeight)

				scale = scale or 1

				local adjustX = self.main:GetWidth() / 2 - layerInfo.layerWidth * (centerX or 0.5) * scale
				local adjustY = self.main:GetHeight() / 2 - layerInfo.layerHeight * (centerY or 0.5) * scale

				for i=1,heightCount do
					for j=1,widthCount do
						local p = (i-1)*widthCount + j
						local t = GetBackground()

						t:SetSize(layerInfo.tileWidth*scale,layerInfo.tileHeight*scale)
						t:SetPoint("TOPLEFT",adjustX + layerInfo.tileWidth * (j-1) * scale,-(i-1)*layerInfo.tileHeight * scale-adjustY)

						t:SetTexture(backData[p])
					end
				end
			end
		end
	end
	self.SetBackground = SetBackground

	self.SelectMapDropDown = ELib:DropDown(self,260,11):Size(90):Point("TOPLEFT",615,-55):SetText(L.VisualNoteSelectMap.."...")
	self.SelectMapDropDown.Lines = nil
	local function SelectMapDropDown_SetValue(_,arg1,arg2)
		ELib:DropDownClose()
		SetBackground(unpack(arg1))
		curr_map = arg2
		curr_data[2] = arg2
	end
	self.SelectMapDropDown.Text:SetFont(self.SelectMapDropDown.Text:GetFont(),8)

	local function ZoneNameFromMap(mapID)
		return (C_Map.GetMapInfo(mapID or 0) or {}).name or ("Map ID "..mapID)
	end

	local maps = {
		--1-10
		{"None",{}},
		{L.S_ZoneT22Uldir..": "..L.bossName[2141],{1149,0.51,0.3,2}},	--MOTHER
		{L.S_ZoneT22Uldir..": "..L.bossName[2144],{1148,0.5,0.3,1.8}},	--Taloc
		{L.S_ZoneT22Uldir..": "..L.bossName[2136],{1151,0.47,0.5,1.6}},	--Zek'voz
		{L.S_ZoneT22Uldir..": "..L.bossName[2134],{1152,0.51,0.45,1.5}},	--Vectis
		{L.S_ZoneT22Uldir..": "..L.bossName[2128],{1153,0.53,0.5,1.5}},	--Fetid Devourer
		{L.S_ZoneT22Uldir..": "..L.bossName[2145],{1154,0.5,0.53,1.5}},	--Zul
		{L.S_ZoneT22Uldir..": "..L.bossName[2135],{1155,0.52,0.85,3}},	--Mythrax
		{L.S_ZoneT22Uldir..": "..L.bossName[2122],{1155,0.52,0.27,2.2}},	--G'huun
		{ICON_TAG_RAID_TARGET_SKULL3 or "white",{"Interface/Buttons/WHITE8X8"}},

		--11-20
		{L.S_ZoneT22Uldir..": "..L.bossName[2135].." [S]",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/Uldir7"}},
		{L.EJInstanceName[968],{934,0.54}},
		{L.EJInstanceName[1001],{936,nil,nil,0.9}},
		{L.EJInstanceName[1041],{1004,nil,nil,0.9}},
		{L.EJInstanceName[1012],{1010,nil,nil,0.9}},
		{L.EJInstanceName[1023],{1162,nil,nil,0.8}},
		{L.EJInstanceName[1022],{1041,nil,nil,0.9}},
		{L.EJInstanceName[1036],{1039,nil,nil,0.9}},
		{L.EJInstanceName[1030],{1038,nil,nil,0.8}},
		{L.S_ZoneT23Siege..": "..L.bossName[2265].." [H]",{1358,0.29,0.37,6}},	--Frida H

		--21-30
		{L.S_ZoneT23Siege..": "..L.bossName[2265].." [A]",{1352,0.49,0.70,6}},	--Frida A
		{L.S_ZoneT23Siege..": "..L.bossName[2263].." [H]",{1358,0.41,0.65,6}},	--Grong H
		{L.S_ZoneT23Siege..": "..L.bossName[2284].." [A]",{1352,0.49,0.52,6}},	--Grong A
		{L.S_ZoneT23Siege..": "..L.bossName[2266].." [H]",{1358,0.49,0.65,6}},	--Flamefist H
		{L.S_ZoneT23Siege..": "..L.bossName[2285].." [A]",{1352,0.49,0.33,6}},	--Flamefist A
		{L.S_ZoneT23Siege..": "..L.bossName[2271],{1353,0.42,0.67,1.5}},	--Treasure Guardian
		{L.S_ZoneT23Siege..": "..L.bossName[2268],{1354,0.475,0.67,2.5}},	--Loa Council
		{L.S_ZoneT23Siege..": "..L.bossName[2272],{1357,0.475,0.48,3}},		--King Rastakhan
		{L.S_ZoneT23Siege..": "..L.bossName[2276],{1352,0.49,0.32,6}},		--Mekkatorque
		{L.S_ZoneT23Siege..": "..L.bossName[2281],{1364,0.5,0.49}},		--Jaina

		--31-40
		{L.S_ZoneT23Storms..": "..L.bossName[2269],{1345,0.51,0.37,3}},		--Cabal
		{L.S_ZoneT23Storms..": "..L.bossName[2273],{1346,0.27,0.53,3}},		--Uunat

		{L.S_ZoneT24Eternal..": "..L.bossName[2298],{1512,0.49,0.48,3}},	--Abyssal Commander Sivara
		{L.S_ZoneT24Eternal..": "..L.bossName[2305],{1513,0.47,0.19,6}},	--Radiance of Azshara
		{L.S_ZoneT24Eternal..": "..L.bossName[2289],{1514,0.5,0.5,1}},		--Blackwater Behemoth
		{L.S_ZoneT24Eternal..": "..L.bossName[2304],{1513,0.47,0.69,6}},	--Lady Ashvane
		{L.S_ZoneT24Eternal..": "..L.bossName[2303],{1517,0.74,0.47,2.5}},	--Orgozoa
		{L.S_ZoneT24Eternal..": "..L.bossName[2311],{1518,0.34,0.48,1.5}},	--The Queen's Court
		{L.S_ZoneT24Eternal..": "..L.bossName[2293],{1519,0.17,0.48,4}},	--Za'qul
		{L.S_ZoneT24Eternal..": "..L.bossName[2299],{1520,0.47,0.53,1.1}},	--Queen Azshara

		--41-50
		{L.EJInstanceName[1178].." [1]",{1490,0.6,nil,0.3}},
		{L.EJInstanceName[1178].." [2]",{1491,nil,nil,0.9}},
		{L.EJInstanceName[1178].." [3]",{1494,nil,nil,0.9}},
		{L.EJInstanceName[1178].." [4]",{1497,nil,nil,0.9}},
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2329],{1581,0.51,0.83,5}},	--Wrathion
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2327],{1581,0.22,0.60,5}},	--Maut
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2334],{1581,0.78,0.60,4}},	--Prophet Skitra
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2328],{1592,0.48,0.47,2.3}},	--Dark Inquisitor Xanesh
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2336],{1593,0.39,0.55,1.7}},	--Vexiona
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2333],{1590,0.55,0.58,2.5}},	--The Hivemind

		--51-60
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2331],{1591,0.61,0.64,1.7}},	--Ra-den the Despoiled
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2335],{1594,0.52,0.73,3}},	--Shad'har the Insatiable
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2343],{1595,0.33,0.57,1.5}},	--Drest'agath
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2345],{1596,0.48,0.31,3}},	--Il'gynoth, Corruption Reborn
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2337],{1597,0.48,0.5,1.2}},	--Carapace of N'Zoth
		{L.S_ZoneT25Nyalotha..": "..L.bossName[2344],{1597,0.48,0.26,4}},	--N'Zoth the Corruptor
		{"Razorgore the Untamed",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_razorgore"}},
		{"Vaelastrasz the Corrupt",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_vaelastrasz"}},
		{"Broodlord Laylash",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_broodlord"}},
		{"Firemaw",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_firemaw"}},

		--61-70
		{"Ebonroc",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_ebonroc"}},
		{"Flamegor",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_flamegor"}},
		{"Chromaggus",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_chromaggus"}},
		{"Nefarian",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bwl_nefarian"}},
		{"Molten Core",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/mc"}},
		{"Zul'gurub",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/zg"}},
		{"Ruins of Ahn'Qiraj",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/aq20"}},
		{"Map",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/aq40"}},
		{"Entrance",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/aq40_entrance"}},
		{"C'Thun",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/aq40_cthun"}},

		--71-80
		{"Map",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx"}},
		{"Arachnid Quarter",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx_arachnid"}},
		{"Construct Quarter",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx_construct"}},
		{"Militairy Quarter",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx_militairy"}},
		{"Plague Quarter",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx_plague"}},
		{"Sapphiron / Kel'thuzad",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/naxx_sapp_kel"}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2398],{1735,0.59,0.80,5}},	--Shriekwing
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2418],{1735,0.67,0.50,5}},	--Huntsman Altimor
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2402],{1746,0.53,0.53,1.5}},--Kael'thas
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2383],{1735,0.36,0.35,5}},	--Hungering Destroyer

		--81-90
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2399],{1735,0.59,0.80,5}},	--Sludgefist
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2405],{1745,0.65,0.24,5}},	--Broker Curator
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2406],{1744,0.44,0.44,3}},	--Lady Inerva Darkvein
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2412],{1750,0.56,0.54,2}},--The Council of Blood
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2417],{1747,0.29,0.51,3}},	--Stone Legion Generals
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2407].." 1",{1747,0.52,0.52,2.5}},	--Sire Denathrius
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2407].." 2",{1748,0.49,0.53,1}},	--Sire Denathrius
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2407].." 2",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria102"}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2407].." 1",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria101"}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2417],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria9"}},

		--91-100
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2412],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria8"}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2405],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria6"}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2402],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria7"}},
		{L.NoteColorBlack:lower(),{{0,0,0,1}}},
		{L.NoteColorGrey:lower(),{{.5,.5,.5,1}}},
		{L.NoteColorGreen:lower(),{{.5,1,.5,1}}},
		{L.NoteColorRed:lower(),{{1,.5,.5,1}}},
		{L.NoteColorBlue:lower(),{{.5,.5,1,1}}},
		{L.NoteColorYellow:lower(),{{1,1,.5,1}}},
		{L.S_ZoneT26CastleNathria..": "..L.bossName[2398].."/"..L.bossName[2399],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/nathria1"}},	--Shriekwing/Sludgefist

		--101-110
		{ZoneNameFromMap(1339),{1339,nil,nil,0.8}},	--Warsong Gulch
		{ZoneNameFromMap(1366),{1366,nil,nil,0.9}},	--Arathi Basin
		{ZoneNameFromMap(1537),{1537,nil,nil,0.9}},	--Alterac Valley
		{ZoneNameFromMap(397),{397,nil,nil,0.9}},	--Eye of the Storm
		{ZoneNameFromMap(169),{169,nil,nil,0.9}},	--Isle of Conquest
		{ZoneNameFromMap(275),{275,nil,nil,0.9}},	--The Battle for Gilneas
		{ZoneNameFromMap(1334),{1334,nil,nil,0.9}},	--Wintergrasp
		{ZoneNameFromMap(1478),{1478,nil,nil,0.9}},	--Ashran
		{ZoneNameFromMap(206),{206,nil,nil,0.9}},	--Twin Peaks
		{ZoneNameFromMap(423),{423,nil,nil,0.9}},	--Silvershard Mines

		--111-120
		{ZoneNameFromMap(417),{417,nil,nil,0.9}},	--Temple of Kotmogu
		{ZoneNameFromMap(907),{907,nil,nil,0.9}},	--Seething Shore
		{ZoneNameFromMap(1576),{1576,nil,nil,0.9}},	--Deepwind Gorge
		{L.S_ZoneT27SoD..": "..L.bossName[2435].." 1",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod10a"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2435].." 2",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod10b"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2435].." 3",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod10c"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2423],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod1"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2433],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod2"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2429],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod3"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2432],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod4"}},

		--121-130
		{L.S_ZoneT27SoD..": "..L.bossName[2434],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod5"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2430],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod6"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2436],{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod7"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2422].." 1",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod9a"}},
		{L.S_ZoneT27SoD..": "..L.bossName[2422].." 2",{"Interface/AddOns/"..GlobalAddonName.."/mediamodern/sod9b"}},
		{"Black Temple 1",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt1"}},
		{"Black Temple 2",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt2"}},
		{"Black Temple 3",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt3"}},
		{"Black Temple 4",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt4"}},
		{"Black Temple 5",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt5"}},

		--131-140
		{"Black Temple 6",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt6"}},
		{"Black Temple 7",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt7"}},
		{"Black Temple 8",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/bt8"}},
		{"Gruul's Lair",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/gruul"}},
		{"Battle for Mount Hyjal",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/hyj"}},
		{"Magtheridon's Lair",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/mag"}},
		{"Serpentshrine Cavern",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/sc"}},
		{"Tempest Keep",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/tk"}},
		{"Sunwell Plateau 1",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/sw1"}},
		{"Sunwell Plateau 2",{"Interface/AddOns/"..GlobalAddonName.."/mediaclassic/sw2"}},

		--141-150
	}
	local mapsSorted = {
		1,
		{L.NoteColor,10,94,95,96,97,98,99},
		{L.S_ZoneT27SoD,114,115,116,124,125,123,122,121,120,119,118,117},
		{L.S_ZoneT26CastleNathria.." Ingame",100,93,91,92,90,89,88},
		{L.S_ZoneT26CastleNathria,77,78,79,80,81,82,83,84,85,86,87},
		{BATTLEFIELDS,101,102,103,104,105,106,107,108,109,110,111,112,113},
		{L.S_ZoneT25Nyalotha,45,46,47,48,49,50,51,52,53,54,55,56},
		{L.S_ZoneT24Eternal,40,39,38,37,36,35,34,33},
		{L.S_ZoneT23Storms,32,31},
		{L.S_ZoneT23Siege,30,29,28,27,26,25,24,23,22,21,20},
		{L.S_ZoneT22Uldir,9,8,11,7,6,5,4,2,3},
		{DUNGEONS..": "..EXPANSION_NAME7,41,42,43,44,12,13,14,15,16,17,18,19},
	}
	if ExRT.isBC then
		mapsSorted = {
			1,
			{L.NoteColor,10,94,95,96,97,98,99},
			{"Sunwell Plateau",139,140},
			{"Battle for Mount Hyjal",135},
			{"Black Temple",126,127,128,129,130,131,132,133},
			{"Tempest Keep",138},
			{"Serpentshrine Cavern",137},
			{"Gruul's Lair",134},
			{"Magtheridon's Lair",136},
			{"Blackwing Lair","by Wollie",57,58,59,60,61,62,63,64},
			{"Molten Core",65},
			{"Naxxramas","by Wollie",71,72,73,74,75,76},
			{"Ruins of Ahn'Qiraj",67},
			{"Temple of Ahn'Qiraj",68,69,70},
			{"Zul'gurub",66},
		}
	elseif ExRT.isClassic then
		mapsSorted = {
			1,
			{L.NoteColor,10,94,95,96,97,98,99},
			{"Blackwing Lair","by Wollie",57,58,59,60,61,62,63,64},
			{"Molten Core",65},
			{"Naxxramas","by Wollie",71,72,73,74,75,76},
			{"Ruins of Ahn'Qiraj",67},
			{"Temple of Ahn'Qiraj",68,69,70},
			{"Zul'gurub",66},
		}
	end
	for i=1,#mapsSorted do
		local p = mapsSorted[i]
		if type(p)=='table' then
			local subList = {}
			for j=2,#p do
				if type(p[j])=="string" then
					subList[#subList + 1] = {
						text = p[j],
						isTitle = true,
					}
				else
					subList[#subList + 1] = {
						text = maps[ p[j] ][1],
						func = SelectMapDropDown_SetValue,
						arg1 = maps[ p[j] ][2],
						arg2 = mapsSorted[i][j],
					}
				end
			end
			self.SelectMapDropDown.List[#self.SelectMapDropDown.List + 1] = {
				text = p[1],
				subMenu = subList,
			}
		else
			self.SelectMapDropDown.List[#self.SelectMapDropDown.List + 1] = {
				text = maps[p][1],
				func = SelectMapDropDown_SetValue,
				arg1 = maps[p][2],
				arg2 = mapsSorted[i],
			}
		end
	end
	function self:SetPredefinedMap(pos)
		if not maps[pos] then
			SetBackground(unpack(maps[1][2]))
			curr_map = 1
		else
			SetBackground(unpack(maps[pos][2]))
			curr_map = pos
		end
	end
	function self:SetDebugMap(...)
		SetBackground(...)
	end


	---------------------
	--- DOTS (BRUSH) ----
	---------------------

	local function GetDot()
		local dot
		for d,_ in pairs(dots) do
			if not d:IsShown() then
				dot = d
				break
			end
		end
		if not dot then
			dot = self.main.C:CreateTexture(nil,"ARTWORK",nil,2)
			dot:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
			dots[dot] = true
		end
		dot:Show()
		return dot
	end

	local ignoreLimitations
	local function AddDot(x,y)
		x = floor(x + 0.5)
		y = floor(y + 0.5)
		if x > self.main:GetWidth() or y > self.main:GetHeight() then
			return
		end
		if not ignoreLimitations then
			for i=1,#dots_pos_X do
				local x2,y2 = dots_pos_X[i],dots_pos_Y[i]

				local dX = (x - x2)
				local dY = (y - y2)
				if dots_COLOR[i] == curr_color and (dX * dX + dY * dY) <= half_dot_size_sq then
					return
				end
			end
		end

		local d = GetDot()
		d:SetSize(dot_size,dot_size)
		d:SetPoint("CENTER",self.main.C,"TOPLEFT", x, -y)
		d:SetAlpha(1)
		d:SetVertexColor(unpack(colors[curr_color]))
		local p = #dots_pos_X+1
		dots_pos_X[p] = x
		dots_pos_Y[p] = y
		dots_SIZE[p] = dot_size
		dots_COLOR[p] = curr_color
		dots_GROUP[p] = curr_group
		dots_OBJ[p] = d
		if ignoreLimitations then
			dots_SYNC[p] = true
		else
			special_counter = special_counter + 1
		end
	end

	function self:AddDot(x,y,color,size)
		local a,b = dot_size,curr_color
		dot_size = size
		curr_color = color
		ignoreLimitations = true
		AddDot(x,y)
		dot_size = a
		curr_color = b
		ignoreLimitations = nil
	end
	function self:NextGroup()
		curr_group = curr_group + 1
	end

	local function ProcessDot(fromX,fromY,toX,toY,stackFix)
		if stackFix > 300 then
			return
		end
		local dX = (fromX - toX)
		local dY = (fromY - toY)
		local dist = sqrt(dX * dX + dY * dY)

		local k = 2 / max(1,dist)
		local x = fromX + (toX - fromX) * k
		local y = fromY + (toY - fromY) * k

		if (fromX == toX and fromY == toY) or (dX == 0 and dY == 0) then
			AddDot(toX,toY)
			return
		elseif (fromX < toX and x > toX) or (fromX > toX and x < toX) then
			AddDot(toX,toY)
			return
		else
			AddDot(x,y)
			ProcessDot(x,y,toX,toY,stackFix+1)
			return
		end
	end


	---------------------
	------- LINE --------
	---------------------

	local function GetLine()
		local line
		for l,_ in pairs(lines) do
			if not l:IsShown() then
				line = l
				break
			end
		end
		if not line then
			line = self.main.C:CreateLine(nil,"ARTWORK",nil,2)
			line:SetTexture("interface/buttons/white8x8")
			lines[line] = true
		end
		line:Show()
		return line
	end


	---------------------
	---- LOCKED IMG -----
	---------------------

	local function LockedImgSetState(self,state)
		if state then
			self:SetTexCoord(.625,.6875,.5,.625)
			self:SetVertexColor(1,.5,.5,1)
		else
			self:SetTexCoord(.6875,.75,.5,.625)
			self:SetVertexColor(.5,1,.5,1)
		end
	end

	local function SetLockedImg(obj,group,isHide)
		local img
		for l,_ in pairs(locked_img) do
			if l.g == group then
				img = l
				break
			end
		end
		if isHide then
			if img then
				img:Hide()
				img.g = nil
			end
			return
		end
		if not img then
			for l,_ in pairs(locked_img) do
				if not l:IsShown() then
					img = l
					break
				end
			end
		end
		if not img then
			img = self.main.C:CreateTexture(nil,"ARTWORK",nil,7)
			img:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
			img.SetState = LockedImgSetState
			locked_img[img] = true
		end
		img:ClearAllPoints()
		img:SetPoint("CENTER",obj,0,0)
		img:SetSize(30,30)
		img.o = obj
		img.g = group
		img:SetState(lockedGroups[group])
		img:Show()
		return img
	end
	local function UpdateLockedImg(group)
		for l,_ in pairs(locked_img) do
			if l.g == group then
				l:SetState(lockedGroups[group])
			end
		end
	end
	function LockedImgHideAll()
		for l,_ in pairs(locked_img) do
			if l:IsShown() then
				l:Hide()
			end
			l.g = nil
		end
	end

	---------------------
	--- ICONS -----------
	---------------------

	local function GetIcon()
		local icon
		for i,_ in pairs(icons) do
			if not i:IsShown() then
				icon = i
				break
			end
		end
		if not icon then
			icon = self.main.C:CreateTexture(nil,"ARTWORK",nil,-1)
			icons[icon] = true
		end
		local t = icons_list[curr_icon]
		if type(t) == 'table' then
			icon:SetTexCoord(select(2,unpack(t)))
			icon:SetTexture(t[1])
		else
			icon:SetTexCoord(0,1,0,1)
			icon:SetTexture(t)
		end
		icon:SetAlpha(1)
		icon:Show()
		return icon
	end

	local function ProcessIcon(fromX,fromY,toX,toY)
		local I = nil
		local p = nil
		for i=#icon_pos_X,1,-1 do
			if icon_GROUP[i] == curr_group then
				I = icon_OBJ[i]
				p = i
				break
			elseif icon_GROUP[i] < curr_group then
				break
			end
		end

		if not I then
			I = GetIcon()
		end
		I:SetPoint("CENTER",self.main.C,"TOPLEFT",fromX,-fromY)
		local size = max(max(6,toX - fromX),max(6,toY - fromY)) * 2
		I:SetSize(size,size)

		if not p then
			p = #icon_pos_X+1
		end
		icon_pos_X[p] = fromX
		icon_pos_Y[p] = fromY
		icon_SIZE[p] = size
		icon_OBJ[p] = I
		icon_TYPE[p] = curr_icon
		icon_GROUP[p] = curr_group
	end

	function self:AddIcon(x,y,type,size)
		local a = curr_icon
		curr_icon = type

		if icons_list[curr_icon] then
			local I = GetIcon()
			I:SetPoint("CENTER",self.main.C,"TOPLEFT",x,-y)
			I:SetSize(size,size)

			local p = #icon_pos_X+1

			icon_pos_X[p] = x
			icon_pos_Y[p] = y
			icon_SIZE[p] = size
			icon_OBJ[p] = I
			icon_TYPE[p] = curr_icon
			icon_SYNC[p] = true
			icon_GROUP[p] = curr_group
		end

		curr_icon = a
	end

	---------------------
	--- TEXT ------------
	---------------------

	local function GetText()
		local text
		for t,_ in pairs(texts) do
			if not t:IsShown() then
				text = t
				break
			end
		end
		if not text then
			text = self.main.C:CreateFontString(nil,"ARTWORK","GameFontNormal",4)
			text:SetFont(text:GetFont(),12,"OUTLINE")
			texts[text] = true
		end
		text:SetTextColor(unpack(colors[curr_color]))
		text:SetAlpha(1)
		text:SetText(curr_text)
		text:Show()
		return text
	end

	local function ProcessText(fromX,fromY,toX,toY)
		local T = nil
		local p = nil
		for i=#text_pos_X,1,-1 do
			if text_GROUP[i] == curr_group then
				T = text_OBJ[i]
				p = i
				break
			elseif text_GROUP[i] < curr_group then
				break
			end
		end

		if not T then
			T = GetText()
		end
		T:SetPoint("CENTER",self.main.C,"TOPLEFT",fromX,-fromY)
		local size = max(10,toX - fromX)
		T:SetFont(T:GetFont(),size,"OUTLINE")

		if not p then
			p = #text_pos_X+1
		end
		text_pos_X[p] = fromX
		text_pos_Y[p] = fromY
		text_SIZE[p] = size
		text_OBJ[p] = T
		text_DATA[p] = curr_text
		text_COLOR[p] = curr_color
		text_GROUP[p] = curr_group
	end

	function self:AddText(x,y,text,color,size)
		local a,b = curr_text,curr_color
		curr_text = text
		curr_color = color

		local T = GetText()
		T:SetPoint("CENTER",self.main.C,"TOPLEFT",x,-y)
		T:SetFont(T:GetFont(),size,"OUTLINE")

		local p = #text_pos_X+1

		text_pos_X[p] = x
		text_pos_Y[p] = y
		text_SIZE[p] = size
		text_OBJ[p] = T
		text_DATA[p] = curr_text
		text_COLOR[p] = curr_color
		text_SYNC[p] = true
		text_GROUP[p] = curr_group

		curr_text = a
		curr_color = b
	end

	---------------------
	--- OBJECTS ---------
	---------------------

	local function GetDotObj()
		local dot
		for d,_ in pairs(objects) do
			if not d:IsShown() then
				dot = d
				break
			end
		end
		if not dot then
			dot = self.main.C:CreateTexture(nil,"ARTWORK",nil,1)
			dot:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
			dot.isC = true
			objects[dot] = true
		end
		if not dot.isC then
			dot:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
			dot.isC = true
		end
		dot:SetPoint("CENTER",self.main.C,"TOPLEFT",-1000,1000)
		dot:Show()
		return dot
	end

	local function ProcessObject(fromX,fromY,toX,toY)
		for o,_ in pairs(objects) do
			if o.g == curr_group then
				o:Hide()
			end
		end
		for l,_ in pairs(lines) do
			if l.g == curr_group then
				l:Hide()
			end
		end
		local size
		if curr_object == 1 then
			size = min(max(10,toX - fromX),max(10,toY - fromY)) * 2
			local circleLen = 2*PI*size
			local len = ceil(circleLen / (dot_size / 2))
			for i=0,len-1 do
				local x = fromX + size * math.cos(2*PI/len*i)
				local y = fromY + size * math.sin(2*PI/len*i)

				local o = GetDotObj()
				o:SetPoint("CENTER",self.main.C,"TOPLEFT",x,-y)
				o.g = curr_group
				o.t = nil

				o:SetSize(dot_size,dot_size)
				o:SetAlpha(1)
				o:SetVertexColor(unpack(colors[curr_color]))
			end
		elseif curr_object == 2 then
			size = min(max(10,toX - fromX),max(10,toY - fromY)) * 2

			local o = GetDotObj()
			o:SetPoint("CENTER",self.main.C,"TOPLEFT",fromX,-fromY)
			o.g = curr_group
			o.t = curr_trans / 100

			o:SetSize(size,size)
			o:SetVertexColor(unpack(colors[curr_color]))
			o:SetAlpha(curr_trans / 100)
		elseif curr_object == 3 or curr_object == 5 or curr_object == 6 then
			fromX,fromY = max(0,min(800,fromX)), max(0,min(550,fromY))
			toX,toY = max(0,min(800,toX)), max(0,min(550,toY))

			size = dot_size

			local l = GetLine()

			l:SetStartPoint("TOPLEFT",self.main.C,fromX,-fromY)
			l:SetEndPoint("TOPLEFT",self.main.C,toX,-toY)

			l.g = curr_group
			l.t = nil

			l:SetThickness(size)
			l:SetAlpha(1)

			if curr_object == 3 or curr_object == 5 then
				l:SetColorTexture(unpack(colors[curr_color]))
				l:SetVertexColor(1,1,1,1)

				if curr_object == 5 then
					local ll,lr = GetLine(), GetLine()
					
					ll:SetColorTexture(unpack(colors[curr_color]))
					ll:SetVertexColor(1,1,1,1)
					lr:SetColorTexture(unpack(colors[curr_color]))
					lr:SetVertexColor(1,1,1,1)
					
					ll.g = curr_group
					lr.g = curr_group
					
					ll:SetThickness(size)
					ll:SetAlpha(1)
					lr:SetThickness(size)
					lr:SetAlpha(1)
					
					ll:SetEndPoint("TOPLEFT",self.main.C,toX,-toY)
					lr:SetEndPoint("TOPLEFT",self.main.C,toX,-toY)

					local angle = 20 * (PI/180)
					local rotatedX = math.cos(angle) * (fromX - toX) * 0.2 - math.sin(angle) * (fromY - toY) * 0.2 + toX
					local rotatedY = math.sin(angle) * (fromX - toX) * 0.2 + math.cos(angle) * (fromY - toY) * 0.2 + toY

					ll:SetStartPoint("TOPLEFT",self.main.C,rotatedX,-rotatedY)

					local angle = -20 * (PI/180)
					local rotatedX = math.cos(angle) * (fromX - toX) * 0.2 - math.sin(angle) * (fromY - toY) * 0.2 + toX
					local rotatedY = math.sin(angle) * (fromX - toX) * 0.2 + math.cos(angle) * (fromY - toY) * 0.2 + toY

					lr:SetStartPoint("TOPLEFT",self.main.C,rotatedX,-rotatedY)
				end
			elseif curr_object == 6 then
				--l:SetHorizTile(true)
				l:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/lineGapped","REPEAT")
				l:SetVertexColor(unpack(colors[curr_color]))

				local dX = (fromX - toX)
				local dY = (fromY - toY)
				local dist = sqrt(dX * dX + dY * dY)

				local c = dist / 1024 * 4

				l:SetTexCoord(0,c,0,1)
			end
		elseif curr_object == 4 then
			size = curr_trans

			local o = GetDotObj()
			o:SetTexture()
			o:SetColorTexture(unpack(colors[curr_color]))
			o.isC = nil

			local width,height = max(5,toX-fromX),max(5,toY-fromY)
			if IsShiftKeyDown() then
				width = max(width,height)
				height = width
			end
			toX = fromX + width
			toY = fromY + height

			o:SetPoint("CENTER",self.main.C,"TOPLEFT",fromX+width/2,-fromY-height/2)
			o.g = curr_group
			o.t = curr_trans / 100

			o:SetSize(width,height)
			o:SetAlpha(curr_trans / 100)
		end

		local p
		for i=#object_pos_X,1,-1 do
			if object_GROUP[i] == curr_group then
				p = i
				break
			elseif object_GROUP[i] < curr_group then
				break
			end
		end
		if not p then
			p = #object_pos_X+1
		end
		object_pos_X[p] = fromX
		object_pos_Y[p] = fromY
		object_SIZE[p] = size
		object_TYPE[p] = curr_object
		object_GROUP[p] = curr_group
		object_COLOR[p] = curr_color
		if curr_object == 1 then
			object_DATA1[p] = dot_size
			object_DATA2[p] = 0
		elseif curr_object == 2 then
			object_DATA1[p] = curr_trans
			object_DATA2[p] = 0
		elseif curr_object == 3 or curr_object == 5 or curr_object == 6 then
			object_DATA1[p] = toX
			object_DATA2[p] = toY
		elseif curr_object == 4 then
			object_DATA1[p] = toX
			object_DATA2[p] = toY
		end

		return p
	end

	function self:AddObject(x,y,type,size,color,data1,data2)
		local a,b,c,d = curr_object,dot_size,curr_color,curr_trans
		curr_object = type
		dot_size = type == 1 and data1 or size
		curr_color = color
		curr_trans = type == 4 and size or data1

		local p 
		if type == 3 or type == 5 or type == 6 then
			p = ProcessObject(x,y,data1,data2)
		elseif type == 4 then
			p = ProcessObject(x,y,data1,data2)
		else
			p = ProcessObject(x,y,x+size/2,y+size/2)
		end
		object_SYNC[p] = true

		curr_object = a
		dot_size = b
		curr_color = c
		curr_trans = d
	end

	---------------------
	------ IMAGES -------
	---------------------

	local function GetImage()
		local image
		for i,_ in pairs(images) do
			if not i:IsShown() then
				image = i
				break
			end
		end
		if not image then
			image = self.main.C:CreateTexture(nil,"ARTWORK",nil,-2)
			images[image] = true
		end
		image:SetAlpha(curr_trans / 100)
		image:SetTexture(curr_imgpath)
		image:Show()
		return image
	end

	local function ProcessImage(fromX,fromY,toX,toY)
		local I = nil
		local p = nil
		for i=#image_pos_X,1,-1 do
			if image_GROUP[i] == curr_group then
				I = image_OBJ[i]
				p = i
				break
			elseif image_GROUP[i] < curr_group then
				break
			end
		end

		if not I then
			I = GetImage()
		end

		local revHor,revVer
		local width = max(2,abs(toX - fromX))
		local height = max(2,abs(toY - fromY))
		if toX < fromX then
			revHor = true
		end
		if toY < fromY then
			revVer = true
		end
		if abs(fromX - toX) < 2 then
			toX = fromX + (revHor and -2 or 2)
		end
		if abs(fromY - toY) < 2 then
			toY = fromY + (revVer and -2 or 2)
		end
		if IsShiftKeyDown() then
			if width == height then
				--nothing
			elseif width < height then
				toY = fromY + (revVer and -1 or 1)*abs(toX - fromX)
				height = max(2,abs(fromY - toY))
			else
				toX = fromX + (revHor and -1 or 1)*abs(toY - fromY)
				width = max(2,abs(toX - fromX))
			end
		end

		local layer = -2
		local sq = abs(toX - fromX)*abs(fromY - toY)
		if sq > 350000 then
			layer = -6
		elseif sq > 100000 then
			layer = -5
		elseif sq > 50000 then
			layer = -4
		elseif sq > 20000 then
			layer = -3
		end

		I:SetPoint("TOPLEFT",self.main.C,"TOPLEFT",revHor and toX or fromX,-(revVer and toY or fromY))
		I:SetSize(width,height)
		I:SetTexCoord(revHor and 1 or 0,revHor and 0 or 1,revVer and 1 or 0,revVer and 0 or 1)
		I:SetDrawLayer("ARTWORK",layer)
		I.t = curr_trans / 100

		if not p then
			p = #image_pos_X+1
		end
		image_pos_X[p] = fromX
		image_pos_Y[p] = fromY
		image_pos_X2[p] = toX
		image_pos_Y2[p] = toY
		image_path[p] = curr_imgpath
		image_alpha[p] = curr_trans
		image_OBJ[p] = I
		image_GROUP[p] = curr_group
	end

	function self:AddImage(x,y,x2,y2,path,alpha)
		local a,b = curr_imgpath,curr_trans
		curr_imgpath = path
		curr_trans = alpha

		local I = GetImage()

		local revHor,revVer
		local width = max(2,x2 - x)
		local height = max(2,y2 - y)
		if x2 < x then
			revHor = true
			width = max(2,x - x2)
		end
		if y2 < y then
			revVer = true
			height = max(2,y - y2)
		end
		if abs(x - x2) < 2 then
			x2 = x + (revHor and -2 or 2)
		end
		if abs(y - y2) < 2 then
			y2 = y + (revVer and -2 or 2)
		end

		local layer = -2
		local sq = abs(x - x2)*abs(y - y2)
		if sq > 350000 then
			layer = -6
		elseif sq > 100000 then
			layer = -5
		elseif sq > 50000 then
			layer = -4
		elseif sq > 20000 then
			layer = -3
		end

		I:SetPoint("TOPLEFT",self.main.C,"TOPLEFT",revHor and x2 or x,-(revVer and y2 or y))
		I:SetSize(width,height)
		I:SetTexCoord(revHor and 1 or 0,revHor and 0 or 1,revVer and 1 or 0,revVer and 0 or 1)
		I:SetDrawLayer("ARTWORK",layer)
		I.t = curr_trans / 100

		local p = #image_pos_X+1

		image_pos_X[p] = x
		image_pos_Y[p] = y
		image_pos_X2[p] = x2
		image_pos_Y2[p] = y2
		image_path[p] = curr_imgpath
		image_alpha[p] = curr_trans
		image_OBJ[p] = I
		image_GROUP[p] = curr_group

		curr_imgpath = a
		curr_trans = b
	end

	---------------------
	------ MOVE ---------
	---------------------

	local movePrevX,movePrevY
	local moveObjects = {}
	local function ProcessMove(fromX,fromY,toX,toY)
		if movePrevX ~= fromX or movePrevY ~= fromY then
			wipe(moveObjects)
			movePrevX = fromX
			movePrevY = fromY

			for i=1,#dots_pos_X do
				local x2,y2 = dots_pos_X[i],dots_pos_Y[i]

				local dX = (fromX - x2)
				local dY = (fromY - y2)
				if sqrt(dX * dX + dY * dY) <= (dots_SIZE[i]/2) and not moveObjects[ dots_GROUP[i] ] then
					moveObjects[ dots_GROUP[i] ] = {
						type = 1,
					}
					local all_obj = moveObjects[ dots_GROUP[i] ]
					for j=1,#dots_pos_X do
						if dots_GROUP[i] == dots_GROUP[j] then
							all_obj[#all_obj+1] = {
								obj = dots_OBJ[j],
								index = j,
								x_table = dots_pos_X,
								y_table = dots_pos_Y,
								x = dots_pos_X[j],
								y = dots_pos_Y[j],
							}
						end
					end
				end
			end
			for i=1,#icon_pos_X do
				local x2,y2 = icon_pos_X[i],icon_pos_Y[i]

				local dX = (fromX - x2)
				local dY = (fromY - y2)
				if sqrt(dX * dX + dY * dY) <= (icon_SIZE[i]/2) then
					moveObjects[ icon_GROUP[i] ] = {
						type = 2,
						index = i,
						x_table = icon_pos_X,
						y_table = icon_pos_Y,
						obj = icon_OBJ[i],
						x = x2,
						y = y2,
					}
				end
			end
			for i=1,#text_pos_X do
				local obj = text_OBJ[i]
				if MouseIsOver(obj) then
					moveObjects[ text_GROUP[i] ] = {
						type = 3,
						index = i,
						x_table = text_pos_X,
						y_table = text_pos_Y,
						obj = text_OBJ[i],
						x = text_pos_X[i],
						y = text_pos_Y[i],
					}
				end
			end
			for i=1,#object_pos_X do
				local x2,y2 = object_pos_X[i],object_pos_Y[i]

				if object_TYPE[i] == 1 then
					local dX = (fromX - x2)
					local dY = (fromY - y2)
					local d = sqrt(dX * dX + dY * dY)
					if d <= (object_SIZE[i] + object_DATA1[i] / 2) and d >= (object_SIZE[i] - object_DATA1[i] / 2) then
						moveObjects[ object_GROUP[i] ] = {
							type = 4,
							index = i,
							x_table = object_pos_X,
							y_table = object_pos_Y,
							x = object_pos_X[i],
							y = object_pos_Y[i],
						}
						local all_obj = moveObjects[ object_GROUP[i] ]
						for d,_ in pairs(objects) do
							if d.g == object_GROUP[i] then
								all_obj[#all_obj+1] = {
									obj = d,
									x = select(4,d:GetPoint()),
									y = -select(5,d:GetPoint()),
								}
							end
						end
					end
				elseif object_TYPE[i] == 2 then
					local dX = (fromX - x2)
					local dY = (fromY - y2)
					if sqrt(dX * dX + dY * dY) <= (object_SIZE[i] / 2) then
						moveObjects[ object_GROUP[i] ] = {
							type = 5,
							index = i,
							x_table = object_pos_X,
							y_table = object_pos_Y,
							x = object_pos_X[i],
							y = object_pos_Y[i],
						}
						for o,_ in pairs(objects) do
							if o.g == object_GROUP[i] then
								moveObjects[ object_GROUP[i] ].obj = o
								break
							end
						end
					end
				elseif object_TYPE[i] == 3 or object_TYPE[i] == 5 or object_TYPE[i] == 6 then
					if IsDotIn(fromX,fromY,x2,object_DATA1[i],object_DATA1[i],x2,y2-object_SIZE[i],object_DATA2[i]-object_SIZE[i],object_DATA2[i]+object_SIZE[i],y2+object_SIZE[i]) or
					IsDotIn(fromX,fromY,x2-object_SIZE[i],x2+object_SIZE[i],object_DATA1[i]+object_SIZE[i],object_DATA1[i]-object_SIZE[i],y2,y2,object_DATA2[i],object_DATA2[i]) then
						moveObjects[ object_GROUP[i] ] = {
							type = 6,
							index = i,
							x_table = object_pos_X,
							y_table = object_pos_Y,
							x = object_pos_X[i],
							y = object_pos_Y[i],
							x2_table = object_DATA1,
							y2_table = object_DATA2,
							x2 = object_DATA1[i],
							y2 = object_DATA2[i],
						}
						local all_obj = moveObjects[ object_GROUP[i] ]
						for d,_ in pairs(lines) do
							if d.g == object_GROUP[i] then
								all_obj[#all_obj+1] = {
									obj = d,
								}
							end
						end
					end
				elseif object_TYPE[i] == 4 then
					if fromX >= x2 and fromX <= object_DATA1[i] and fromY >= y2 and fromY <= object_DATA2[i] then
						moveObjects[ object_GROUP[i] ] = {
							type = 7,
							index = i,
							x_table = object_pos_X,
							y_table = object_pos_Y,
							x = object_pos_X[i],
							y = object_pos_Y[i],
							x2_table = object_DATA1,
							y2_table = object_DATA2,
							x2 = object_DATA1[i],
							y2 = object_DATA2[i],
						}
						for o,_ in pairs(objects) do
							if o.g == object_GROUP[i] then
								moveObjects[ object_GROUP[i] ].obj = o
								break
							end
						end
					end
				end
			end
			for i=1,#image_pos_X do
				local xg1,yg1 = image_pos_X, image_pos_Y
				local xg2,yg2 = image_pos_X2, image_pos_Y2

				local x2,y2 = image_pos_X[i],image_pos_Y[i]
				local x3,y3 = image_pos_X2[i],image_pos_Y2[i]
	
				if x3 < x2 then 
					x2,x3 = x3,x2 
					xg1,xg2 = xg2,xg1
				end
				if y3 < y2 then 
					y2,y3 = y3,y2 
					yg1,yg2 = yg2,yg1
				end
	
				if fromX >= x2 and fromX <= x3 and fromY >= y2 and fromY <= y3 then
					moveObjects[ image_GROUP[i] ] = {
						type = 8,
						index = i,
						x_table1 = xg1,
						y_table1 = yg1,
						x_table2 = xg2,
						y_table2 = yg2,
						obj = image_OBJ[i],
						x1 = x2,
						y1 = y2,
						x2 = x3,
						y2 = y3,
					}
				end
			end
		end

		local diffX,diffY = toX - fromX, toY - fromY
		for group,data in pairs(moveObjects) do
			if lockedGroups[group] then
				--do nothing
			elseif data.type == 1 then
				local a_data = data
				for i=1,#a_data do
					local data = a_data[i]
					data.x_table[ data.index ] = max(0,min(800,data.x + diffX))
					data.y_table[ data.index ] = max(0,min(550,data.y + diffY))
					data.obj:SetPoint("CENTER",self.main.C,"TOPLEFT",data.x_table[ data.index ],-data.y_table[ data.index ])
				end
			elseif data.type == 2 or data.type == 3 or data.type == 5 then
				data.x_table[ data.index ] = max(0,min(800,data.x + diffX))
				data.y_table[ data.index ] = max(0,min(550,data.y + diffY))
				data.obj:SetPoint("CENTER",self.main.C,"TOPLEFT",data.x_table[ data.index ],-data.y_table[ data.index ])
			elseif data.type == 4 then
				data.x_table[ data.index ] = max(0,min(800,data.x + diffX))
				data.y_table[ data.index ] = max(0,min(550,data.y + diffY))

				local a_data = data
				for i=1,#a_data do
					local data = a_data[i]
					data.obj:SetPoint("CENTER",self.main.C,"TOPLEFT",data.x + diffX,-(data.y + diffY))
				end
			elseif data.type == 6 then
				local x1,y1 = max(0,min(800,data.x + diffX)), max(0,min(550,data.y + diffY))
				local x2,y2 = max(0,min(800,data.x2 + diffX)), max(0,min(550,data.y2 + diffY))

				data.x_table[ data.index ] = x1
				data.y_table[ data.index ] = y1
				data.x2_table[ data.index ] = x2
				data.y2_table[ data.index ] = y2

				local a_data = data
				for i=1,#a_data do
					local obj_data = a_data[i]
					obj_data.obj:SetStartPoint("TOPLEFT",self.main.C,x1,-y1)
					obj_data.obj:SetEndPoint("TOPLEFT",self.main.C,x2,-y2)
				end
			elseif data.type == 7 then
				data.x_table[ data.index ] = max(0,min(800,data.x + diffX))
				data.y_table[ data.index ] = max(0,min(550,data.y + diffY))
				data.x2_table[ data.index ] = max(0,min(800,data.x2 + diffX))
				data.y2_table[ data.index ] = max(0,min(550,data.y2 + diffY))

				local width,height = max(5,data.x2_table[ data.index ]-data.x_table[ data.index ]),max(5,data.y2_table[ data.index ]-data.y_table[ data.index ])
				data.obj:SetPoint("CENTER",self.main.C,"TOPLEFT",data.x_table[ data.index ]+width/2,-data.y_table[ data.index ]-height/2)
				data.obj:SetSize(width,height)
			elseif data.type == 8 then
				data.x_table1[ data.index ] = data.x1 + diffX
				data.y_table1[ data.index ] = data.y1 + diffY
				data.x_table2[ data.index ] = data.x2 + diffX
				data.y_table2[ data.index ] = data.y2 + diffY

				local width,height = max(2,data.x_table2[ data.index ]-data.x_table1[ data.index ]),max(2,data.y_table2[ data.index ]-data.y_table1[ data.index ])
				data.obj:SetPoint("TOPLEFT",self.main.C,"TOPLEFT",data.x_table1[ data.index ],-data.y_table1[ data.index ])
				data.obj:SetSize(width,height)
			end
		end
	end

	---------------------------------
	--- OnUpdate, OnClick funcs -----
	---------------------------------

	local CheckAlpha

	local prevX,prevY
	local function DotsUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		ProcessDot(prevX or x,prevY or y,x,y,1)
		prevX,prevY = x,y
	end

	local function IconsUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if not prevX then
			prevX,prevY = x,y
		end
		ProcessIcon(prevX,prevY,x,y)
	end

	local function TextsUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if not prevX then
			prevX,prevY = x,y
		end
		ProcessText(prevX,prevY,x,y)
	end

	local function ObjectsUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if not prevX then
			prevX,prevY = x,y
		end
		ProcessObject(prevX,prevY,x,y)
	end

	local function MoveUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if not prevX then
			prevX,prevY = x,y
		end
		ProcessMove(prevX,prevY,x,y)
	end

	local function ImageUpdate(self,elapsed)
		if not IsMouseButtonDown("LeftButton") then
			self:SetScript("OnUpdate",CheckAlpha)
			return
		end
		local x,y = ExRT.F.GetCursorPos(self)
		if not prevX then
			prevX,prevY = x,y
		end
		ProcessImage(prevX,prevY,x,y)
	end

	local groups_alpha_now,groups_alpha_pending = {},{}

	function IsDotIn(pX,pY,point1x,point2x,point3x,point4x,point1y,point2y,point3y,point4y)
		local D1 = (pX - point1x) * (point2y - point1y) - (pY - point1y) * (point2x - point1x)	--1,2
		local D2 = (pX - point2x) * (point3y - point2y) - (pY - point2y) * (point3x - point2x)	--2,3
		local D3 = (pX - point3x) * (point4y - point3y) - (pY - point3y) * (point4x - point3x)	--3,4
		local D4 = (pX - point4x) * (point1y - point4y) - (pY - point4y) * (point1x - point4x)	--4,1

		return (D1 < 0 and D2 < 0 and D3 < 0 and D4 < 0) or (D1 > 0 and D2 > 0 and D3 > 0 and D4 > 0)
	end

	local groupsUnderCursor = {}
	local function UpdateGroupsUnderCursor(x,y)
		for k,v in pairs(groupsUnderCursor) do
			groupsUnderCursor[k] = nil
		end

		for i=1,#dots_pos_X do
			local x2,y2 = dots_pos_X[i],dots_pos_Y[i]

			local dX = (x - x2)
			local dY = (y - y2)
			if sqrt(dX * dX + dY * dY) <= (dots_SIZE[i]/2) then
				groupsUnderCursor[ dots_GROUP[i] ] = true
			end
		end
		for i=1,#icon_pos_X do
			local x2,y2 = icon_pos_X[i],icon_pos_Y[i]

			local dX = (x - x2)
			local dY = (y - y2)
			if sqrt(dX * dX + dY * dY) <= (icon_SIZE[i]/2) then
				groupsUnderCursor[ icon_GROUP[i] ] = true
			end
		end
		for i=1,#text_pos_X do
			local obj = text_OBJ[i]
			if MouseIsOver(obj) then
				groupsUnderCursor[ text_GROUP[i] ] = true
			end
		end
		for i=1,#object_pos_X do
			local x2,y2 = object_pos_X[i],object_pos_Y[i]

			if object_TYPE[i] == 1 then
				local dX = (x - x2)
				local dY = (y - y2)
				local d = sqrt(dX * dX + dY * dY)
				if d <= (object_SIZE[i] + object_DATA1[i] / 2) and d >= (object_SIZE[i] - object_DATA1[i] / 2) then
					groupsUnderCursor[ object_GROUP[i] ] = true
				end
			elseif object_TYPE[i] == 2 then
				local dX = (x - x2)
				local dY = (y - y2)
				if sqrt(dX * dX + dY * dY) <= (object_SIZE[i] / 2) then
					groupsUnderCursor[ object_GROUP[i] ] = true
				end
			elseif object_TYPE[i] == 3 or object_TYPE[i] == 5 or object_TYPE[i] == 6 then
				if IsDotIn(x,y,x2,object_DATA1[i],object_DATA1[i],x2,y2-object_SIZE[i],object_DATA2[i]-object_SIZE[i],object_DATA2[i]+object_SIZE[i],y2+object_SIZE[i]) then
					groupsUnderCursor[ object_GROUP[i] ] = true
				elseif IsDotIn(x,y,x2-object_SIZE[i],x2+object_SIZE[i],object_DATA1[i]+object_SIZE[i],object_DATA1[i]-object_SIZE[i],y2,y2,object_DATA2[i],object_DATA2[i]) then
					groupsUnderCursor[ object_GROUP[i] ] = true
				end
			elseif object_TYPE[i] == 4 then
				if x >= x2 and x <= object_DATA1[i] and y >= y2 and y <= object_DATA2[i] then
					groupsUnderCursor[ object_GROUP[i] ] = true
				end
			end
		end
		for i=1,#image_pos_X do
			local x2,y2 = image_pos_X[i],image_pos_Y[i]
			local x3,y3 = image_pos_X2[i],image_pos_Y2[i]

			if x3 < x2 then x2,x3 = x3,x2 end
			if y3 < y2 then y2,y3 = y3,y2 end

			if x >= x2 and x <= x3 and y >= y2 and y <= y3 then
				groupsUnderCursor[ image_GROUP[i] ] = true
			end
		end
	end

	local alphaTabPos = nil
	local alphaTabNow = nil
	function CheckAlpha(self,elapsed)
		local x,y = ExRT.F.GetCursorPos(self)
		UpdateGroupsUnderCursor(x,y)
		if (alphaTabNow and not groupsUnderCursor[alphaTabNow]) or tool_selected ~= 7 then
			alphaTabNow = nil
			alphaTabPos = nil
		end
		if not alphaTabNow then
			for k,v in pairs(groupsUnderCursor) do
				if tool_selected == 7 or not lockedGroups[k] then
					groups_alpha_pending[ k ] = true
				end
			end
		else
			groups_alpha_pending[ alphaTabNow ] = true
		end

		for g,_ in pairs(groups_alpha_pending) do
			if not groups_alpha_now[g] then
				groups_alpha_now[g] = true
				for i=1,#dots_pos_X do
					if dots_GROUP[i] == g then
						dots_OBJ[i]:SetAlpha(.5)

						if tool_selected == 7 then
							SetLockedImg(dots_OBJ[i],g)
						end
					end
				end
				for i=1,#icon_pos_X do
					if icon_GROUP[i] == g then
						icon_OBJ[i]:SetAlpha(.5)

						if tool_selected == 7 then
							SetLockedImg(icon_OBJ[i],g)
						end
					end
				end
				for i=1,#text_pos_X do
					if text_GROUP[i] == g then
						text_OBJ[i]:SetAlpha(.5)

						if tool_selected == 7 then
							SetLockedImg(text_OBJ[i],g)
						end
					end
				end
				for o,_ in pairs(objects) do
					if o.g == g then
						if o.t then
							o:SetAlpha(o.t >= .5 and o.t / 2 or o.t + .5)
						else
							o:SetAlpha(.5)
						end

						if tool_selected == 7 then
							SetLockedImg(o,g)
						end
					end
				end
				for l,_ in pairs(lines) do
					if l.g == g then
						l:SetAlpha(.5)

						if tool_selected == 7 then
							SetLockedImg(l,g)
						end
					end
				end
				for i=1,#image_pos_X do
					if image_GROUP[i] == g then
						image_OBJ[i]:SetAlpha(image_OBJ[i].t >= .5 and image_OBJ[i].t / 2 or image_OBJ[i].t + .5)

						if tool_selected == 7 then
							SetLockedImg(image_OBJ[i],g)
						end
					end
				end
			end
		end
		for g,_ in pairs(groups_alpha_now) do
			if not groups_alpha_pending[g] then
				groups_alpha_now[g] = nil
				for i=1,#dots_pos_X do
					if dots_GROUP[i] == g then
						dots_OBJ[i]:SetAlpha(1)

						if tool_selected == 7 then
							SetLockedImg(dots_OBJ[i],g,true)
						end
					end
				end
				for i=1,#icon_pos_X do
					if icon_GROUP[i] == g then
						icon_OBJ[i]:SetAlpha(1)

						if tool_selected == 7 then
							SetLockedImg(icon_OBJ[i],g,true)
						end
					end
				end
				for i=1,#text_pos_X do
					if text_GROUP[i] == g then
						text_OBJ[i]:SetAlpha(1)

						if tool_selected == 7 then
							SetLockedImg(text_OBJ[i],g,true)
						end
					end
				end
				for o,_ in pairs(objects) do
					if o.g == g then
						o:SetAlpha(o.t or 1)

						if tool_selected == 7 then
							SetLockedImg(o,g,true)
						end
					end
				end
				for l,_ in pairs(lines) do
					if l.g == g then
						l:SetAlpha(1)

						if tool_selected == 7 then
							SetLockedImg(l,g,true)
						end
					end
				end
				for i=1,#image_pos_X do
					if image_GROUP[i] == g then
						image_OBJ[i]:SetAlpha(image_OBJ[i].t)

						if tool_selected == 7 then
							SetLockedImg(image_OBJ[i],g,true)
						end
					end
				end
			end
		end
		for g,_ in pairs(groups_alpha_pending) do
			groups_alpha_pending[g] = nil
		end
	end

	local function CheckAlphaTab(self)
		local list = {}
		for k,v in pairs(groupsUnderCursor) do
			list[#list+1] = {tostring(k),k}
		end
		sort(list,function(a,b)return a[1]<b[1] end)
		alphaTabPos = (alphaTabPos or 0) + 1
		if alphaTabPos > #list then
			alphaTabPos = nil
		end
		if alphaTabPos and #list > 1 then
			alphaTabNow = list[alphaTabPos][2]
		else
			alphaTabNow = nil
		end
	end

	local function ClearSomething(self)
		local x,y = ExRT.F.GetCursorPos(self)
		UpdateGroupsUnderCursor(x,y)

		local groups_to_remove = {}
		local isSomethingRemoved = false
		for k,v in pairs(groupsUnderCursor) do
			if not lockedGroups[k] then
				groups_to_remove[ k ] = true
				isSomethingRemoved = true
			end
		end

		for i=#dots_pos_X,1,-1 do
			if groups_to_remove[ dots_GROUP[i] ] then
				dots_OBJ[i]:Hide()
				tremove(dots_pos_X,i)
				tremove(dots_pos_Y,i)
				tremove(dots_SIZE,i)
				tremove(dots_COLOR,i)
				tremove(dots_GROUP,i)
				tremove(dots_OBJ,i)
				tremove(dots_SYNC,i)
			end
		end
		for i=#icon_pos_X,1,-1 do
			if groups_to_remove[ icon_GROUP[i] ] then
				icon_OBJ[i]:Hide()
				tremove(icon_pos_X,i)
				tremove(icon_pos_Y,i)
				tremove(icon_SIZE,i)
				tremove(icon_GROUP,i)
				tremove(icon_OBJ,i)
				tremove(icon_TYPE,i)
				tremove(icon_SYNC,i)
			end
		end
		for i=#text_pos_X,1,-1 do
			if groups_to_remove[ text_GROUP[i] ] then
				text_OBJ[i]:Hide()
				tremove(text_pos_X,i)
				tremove(text_pos_Y,i)
				tremove(text_SIZE,i)
				tremove(text_GROUP,i)
				tremove(text_OBJ,i)
				tremove(text_DATA,i)
				tremove(text_COLOR,i)
				tremove(text_SYNC,i)
			end
		end
		for i=#object_pos_X,1,-1 do
			if groups_to_remove[ object_GROUP[i] ] then
				for o,_ in pairs(objects) do
					if o.g == object_GROUP[i] then
						o:Hide()
					end
				end
				for l,_ in pairs(lines) do
					if l.g == object_GROUP[i] then
						l:Hide()
					end
				end
				tremove(object_pos_X,i)
				tremove(object_pos_Y,i)
				tremove(object_SIZE,i)
				tremove(object_GROUP,i)
				tremove(object_COLOR,i)
				tremove(object_TYPE,i)
				tremove(object_DATA1,i)
				tremove(object_DATA2,i)
				tremove(object_SYNC,i)
			end
		end
		for i=#image_pos_X,1,-1 do
			if groups_to_remove[ image_GROUP[i] ] then
				image_OBJ[i]:Hide()
				tremove(image_pos_X,i)
				tremove(image_pos_Y,i)
				tremove(image_pos_X2,i)
				tremove(image_pos_Y2,i)
				tremove(image_OBJ,i)
				tremove(image_GROUP,i)
				tremove(image_path,i)
				tremove(image_alpha,i)
				tremove(image_SYNC,i)
			end
		end

		if isSomethingRemoved and isLiveSession then
			module.options:GenerateString()
		elseif isSomethingRemoved then
			module.options:SaveData()
		end
	end

	local function LockUnlockSomething(self)
		local x,y = ExRT.F.GetCursorPos(self)
		UpdateGroupsUnderCursor(x,y)

		if alphaTabNow then
			lockedGroups[alphaTabNow] = not lockedGroups[alphaTabNow]
			UpdateLockedImg(alphaTabNow)
		else
			for k,v in pairs(groupsUnderCursor) do
				lockedGroups[k] = not lockedGroups[k]
				UpdateLockedImg(k)
			end
		end
	end


	self.main.C:SetScript("OnMouseDown",function(self,button)
		if self.popup then return end
		prevX,prevY = nil
		if button == "LeftButton" then
			module.options:NextGroup()
			if tool_selected == 1 then
				self:SetScript("OnUpdate",DotsUpdate)
			elseif tool_selected == 2 then
				self:SetScript("OnUpdate",IconsUpdate)
			elseif tool_selected == 3 then
				if curr_text == "" then return end
				self:SetScript("OnUpdate",TextsUpdate)
			elseif tool_selected == 4 then
				self:SetScript("OnUpdate",ObjectsUpdate)
			elseif tool_selected == 5 then
				self:SetScript("OnUpdate",MoveUpdate)
			elseif tool_selected == 6 then
				if curr_imgpath == "" then return end
				self:SetScript("OnUpdate",ImageUpdate)
			elseif tool_selected == 7 then
				LockUnlockSomething(self)
			end
		elseif button == "RightButton" then
			if tool_selected == 7 then
				CheckAlphaTab(self)
			else
				ClearSomething(self)
			end
		end
	end)
	self.main.C:SetScript("OnMouseUp",function(self,button)
		if self.popup then return end
		if tool_selected ~= 1 and button == "LeftButton" then
			special_counter = special_counter + 1
		end
		if tool_selected == 5 and button == "LeftButton" then
			if isLiveSession then
				module.options:GenerateString()
			else
				module.options:SaveData()
			end
		end
		self:SetScript("OnUpdate",CheckAlpha)
	end)
	self.main.C:SetScript("OnUpdate",CheckAlpha)

	self.main:SetScript("OnMouseWheel",function(self,delta)
		local x,y = ExRT.F.GetCursorPos(self)

		local oldScale = self.C:GetScale()
		local newScale = oldScale + delta * 0.25
		if newScale < 1 then
			newScale = 1
		elseif newScale > 7 then
			newScale = 7
		end
		self.C:SetScale( newScale )

		self.scrollH = self:GetWidth() - self:GetWidth() / newScale
		self.scrollV = self:GetHeight() - self:GetHeight() / newScale

		local scrollNowH = self:GetHorizontalScroll()
		local scrollNowV = self:GetVerticalScroll()

		scrollNowH = scrollNowH + x / oldScale - x / newScale
		scrollNowV = scrollNowV + y / oldScale - y / newScale

		if scrollNowH > self.scrollH then scrollNowH = self.scrollH end
		if scrollNowH < 0 then scrollNowH = 0 end
		if scrollNowV > self.scrollV then scrollNowV = self.scrollV end
		if scrollNowV < 0 then scrollNowV = 0 end

		self:SetHorizontalScroll(scrollNowH)
		self:SetVerticalScroll(scrollNowV)
	end)
	function self.main:ResetScale()
		self.C:SetScale(1)
		self:SetHorizontalScroll(0)
		self:SetVerticalScroll(0)
	end

	----------------------------
	--- Sync & data funcs ------
	----------------------------

	function self:GenerateString(live)
		self:SaveData()

		local uid = curr_data[1]
		if uid then
			VMRT.VisNote.sync_data[uid] = VMRT.VisNote.sync_data[uid] or {}
			local syncData = VMRT.VisNote.sync_data[uid]
			syncData.sender = ExRT.SDB.charKey
			syncData.time = time()

			module.options.lastUpdate:SetText( L.NoteLastUpdate..": "..syncData.sender.." ("..date("%H:%M:%S %d.%m.%Y",syncData.time)..")" )
		end

		--[[
		Header:
		byte254 - info header
		byte1 - 1st info header
		byte: data version
		byte: length of note uid
		note uid
		byte: length of note name
		note name (max 50 bytes)

		byte254 - info header
		byte2 - 2st info header
		byte: map number
		]]

		local str = live and "" or (string.char(254)..string.char(1)..string.char(DATA_VERSION)..string.char(#curr_data[1])..curr_data[1]..string.char(#(curr_data.name or "")+1)..(curr_data.name or "")..string.char(254)..string.char(2)..string.char(curr_map))
		local prevGroup,prevX,prevY,prevDiffX,prevDiffY

		local function UpdateHeader(i)
			local p1 = dots_COLOR[i] * 1000 + dots_pos_X[i]
			local p2 = dots_SIZE[i] * 1000 + dots_pos_Y[i]
			str = str .. string.char(255) .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

			prevX = dots_pos_X[i]
			prevY = dots_pos_Y[i]
			prevGroup = dots_GROUP[i]
			prevDiffX,prevDiffY = nil	  
		end

		for i=1,#dots_pos_X do
			if not live or not dots_SYNC[i] then
				if dots_GROUP[i] ~= prevGroup then
					UpdateHeader(i)
				end
				local diffX = dots_pos_X[i] - prevX
				local diffY = dots_pos_Y[i] - prevY
				if abs(diffX) >= 50 or abs(diffY) >= 50 then
					UpdateHeader(i)
					diffX = dots_pos_X[i] - prevX
					diffY = dots_pos_Y[i] - prevY
				end
				if prevDiffX == diffX and prevDiffY == diffY then
					str = str ..string.char(254)
				else
					local p = ((diffX < 0 and 50 or 0) + diffX * (diffX < 0 and -1 or 1)) * 100 + (diffY < 0 and 50 or 0) + diffY * (diffY < 0 and -1 or 1)
					str = str ..string.char(floor(p / 250) + 1) .. string.char(p % 250 + 1)
				end
				prevX = dots_pos_X[i]
				prevY = dots_pos_Y[i]
				prevDiffX,prevDiffY = diffX,diffY

				dots_SYNC[i] = true
			end
		end


		for i=1,#icon_pos_X do
			if not live or not icon_SYNC[i] then
				str = str .. string.char(255) .. string.char(251) .. string.char(1)

				local p1 = icon_TYPE[i] * 1000 + icon_pos_X[i]
				local p2 = icon_pos_Y[i]

				str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

				local p3 = icon_SIZE[i]
				str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1)

				icon_SYNC[i] = true
			end
		end

		for i=1,#text_pos_X do
			if not live or not text_SYNC[i] then
				local text_len = #text_DATA[i]
				str = str .. string.char(255) .. string.char(251) .. string.char(2)

				local p1 = text_COLOR[i] * 1000 + text_pos_X[i]
				local p2 = text_pos_Y[i]

				str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

				local p3 = text_SIZE[i]
				str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1)

				str = str .. string.char(text_len + 1) .. text_DATA[i]

				text_SYNC[i] = true
			end
		end

		for i=1,#object_pos_X do
			if not live or not object_SYNC[i] then
				if object_TYPE[i] == 1 then
					str = str .. string.char(255) .. string.char(251) .. string.char(3)

					local p1 = object_COLOR[i] * 1000 + object_pos_X[i]
					local p2 = object_DATA1[i] * 1000 + object_pos_Y[i]

					str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

					local p3 = object_SIZE[i]
					str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1)
				elseif object_TYPE[i] == 2 then
					str = str .. string.char(255) .. string.char(251) .. string.char(4)

					local p1 = object_COLOR[i] * 1000 + object_pos_X[i]
					local p2 = floor(object_DATA1[i] / 2 + 0.5) * 1000 + object_pos_Y[i]

					str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

					local p3 = object_SIZE[i]
					str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1)
				elseif object_TYPE[i] == 3 or object_TYPE[i] == 5 or object_TYPE[i] == 6 then
					str = str .. string.char(255) .. string.char(251) .. string.char((object_TYPE[i] == 3 and 5) or (object_TYPE[i] == 5 and 7) or (object_TYPE[i] == 6 and 8))

					local p1 = object_COLOR[i] * 1000 + object_pos_X[i]
					local p2 = object_SIZE[i] * 1000 + object_pos_Y[i]

					str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

					local p3 = object_DATA1[i]
					local p4 = object_DATA2[i]
					str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1) .. string.char(floor(p4 / 250) + 1) .. string.char(p4 % 250 + 1)
				elseif object_TYPE[i] == 4 then
					str = str .. string.char(255) .. string.char(251) .. string.char(6)

					local p1 = object_COLOR[i] * 1000 + object_pos_X[i]
					local p2 = floor(object_SIZE[i] / 2 + 0.5) * 1000 + object_pos_Y[i]

					str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

					local p3 = object_DATA1[i]
					local p4 = object_DATA2[i]
					str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1) .. string.char(floor(p4 / 250) + 1) .. string.char(p4 % 250 + 1)
				end

				object_SYNC[i] = true
			end
		end

		for i=1,#image_pos_X do
			if not live or not image_SYNC[i] then
				str = str .. string.char(255) .. string.char(251) .. string.char(9)

				local p1 = (image_pos_X[i] < 0 and 20000 or 0) + abs(image_pos_X[i])
				local p2 = (image_pos_Y[i] < 0 and 20000 or 0) + abs(image_pos_Y[i])

				str = str .. string.char(floor(p1 / 250) + 1) .. string.char(p1 % 250 + 1) .. string.char(floor(p2 / 250) + 1) .. string.char(p2 % 250 + 1)

				local p3 = (image_pos_X2[i] < 0 and 20000 or 0) + abs(image_pos_X2[i])
				local p4 = (image_pos_Y2[i] < 0 and 20000 or 0) + abs(image_pos_Y2[i])

				str = str .. string.char(floor(p3 / 250) + 1) .. string.char(p3 % 250 + 1) .. string.char(floor(p4 / 250) + 1) .. string.char(p4 % 250 + 1)

				local p5 = image_alpha[i]

				str = str .. string.char(floor(p5 / 250) + 1) .. string.char(p5 % 250 + 1)

				local map = {}
				local path = tostring(image_path[i]):sub(1,10000)
				for j=1,#path do
					local b = path:sub(j,j):byte()
					if b > 250 then
						map[#map+1] = j
						path = path:sub(1,j-1)..string.char(b - 250)..path:sub(j+1)
					end
				end

				local str_len = #path
				str = str .. string.char(floor(str_len / 250) + 1) .. string.char(str_len % 250 + 1) .. path
				
				local map_len = #map				
				str = str .. string.char(floor(map_len / 250) + 1) .. string.char(map_len % 250 + 1)

				for j=1,map_len do
					str = str .. string.char(floor(map[j] / 250) + 1) .. string.char(map[j] % 250 + 1)
				end				

				image_SYNC[i] = true
			end
		end

		if #str == 0 then
			return
		end

		local compressed = LibDeflate:CompressDeflate(str,{level = 9})
		local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)

		encoded = encoded .. "##F##"

		local parts = ceil(#encoded / 252)

		--Hard to get to disconnect limit
		for i=1,parts do
			local msg = encoded:sub( (i-1)*252+1 , i*252 )
			ExRT.F.SendExMsg("VN",msg)
		end
	end
	function self:SaveData()
		local data = curr_data
		data[2] = curr_map
		local str = ""

		for i=3,#data do
			data[i] = nil
		end

		local prevGroup,prevX,prevY

		local function UpdateHeader(i)
			if str ~= "" then
				data[#data+1] = str
			end
			data[#data + 1] = "D"
			data[#data + 1] = dots_pos_X[i]
			data[#data + 1] = dots_pos_Y[i]
			data[#data + 1] = dots_COLOR[i]
			data[#data + 1] = dots_SIZE[i]

			str = ""

			prevX = dots_pos_X[i]
			prevY = dots_pos_Y[i]
			prevGroup = dots_GROUP[i]
		end
		for i=1,#dots_pos_X do
			if dots_GROUP[i] ~= prevGroup then
				UpdateHeader(i)
			end
			local diffX = dots_pos_X[i] - prevX
			local diffY = dots_pos_Y[i] - prevY

			str = str .. diffX .. ","
			str = str .. diffY .. "," 

			prevX = dots_pos_X[i]
			prevY = dots_pos_Y[i]
		end
		if str ~= "" then
			data[#data+1] = str
		end

		for i=1,#icon_pos_X do
			data[#data + 1] = "I"
			data[#data + 1] = icon_pos_X[i]
			data[#data + 1] = icon_pos_Y[i]
			data[#data + 1] = icon_TYPE[i]
			data[#data + 1] = icon_SIZE[i]
		end
		for i=1,#text_pos_X do
			data[#data + 1] = "T"
			data[#data + 1] = text_pos_X[i]
			data[#data + 1] = text_pos_Y[i]
			data[#data + 1] = text_COLOR[i]
			data[#data + 1] = text_SIZE[i]
			data[#data + 1] = text_DATA[i]
		end
		for i=1,#object_pos_X do
			data[#data + 1] = "O"
			data[#data + 1] = object_pos_X[i]
			data[#data + 1] = object_pos_Y[i]
			data[#data + 1] = object_COLOR[i]
			data[#data + 1] = object_SIZE[i]
			data[#data + 1] = object_DATA1[i]
			data[#data + 1] = object_DATA2[i]
			data[#data + 1] = object_TYPE[i]
		end
		for i=1,#image_pos_X do
			data[#data + 1] = "G"
			data[#data + 1] = image_pos_X[i]
			data[#data + 1] = image_pos_Y[i]
			data[#data + 1] = image_pos_X2[i]
			data[#data + 1] = image_pos_Y2[i]
			data[#data + 1] = image_alpha[i]
			data[#data + 1] = image_path[i]
		end

		return data
	end
	function self:LoadData(data)
		module.options:Clear()
		module.options:SetPredefinedMap(data[2])
		curr_data = data

		local pos = 3
		local color,size
		local X,Y
		while data[pos] do
			if data[pos] == "D" then
				module.options:NextGroup()
				color,size = data[pos+3],data[pos+4]
				X,Y = data[pos+1],data[pos+2]
				local str_data = data[pos+5]

				while str_data ~= "" do
					local x,y,p2 = strsplit(",",str_data,3)
					str_data = p2
					x = tonumber(x)
					y = tonumber(y)

					module.options:AddDot(X+x,Y+y,color,size)

					X = X+x
					Y = Y+y
				end

				pos = pos + 6
			elseif data[pos] == "I" then
				module.options:NextGroup()
				color,size = data[pos+3],data[pos+4]
				X,Y = data[pos+1],data[pos+2]

				module.options:AddIcon(X,Y,color,size)

				pos = pos + 5
			elseif data[pos] == "T" then
				module.options:NextGroup()
				color,size = data[pos+3],data[pos+4]
				X,Y = data[pos+1],data[pos+2]
				local str_data = data[pos+5]

				module.options:AddText(X,Y,str_data,color,size)

				pos = pos + 6
			elseif data[pos] == "O" then
				module.options:NextGroup()
				color,size = data[pos+3],data[pos+4]
				X,Y = data[pos+1],data[pos+2]
				local data1,data2,type = data[pos+5],data[pos+6],data[pos+7]

				module.options:AddObject(X,Y,type,size,color,data1,data2)

				pos = pos + 8
			elseif data[pos] == "G" then
				module.options:NextGroup()
				local x,y = data[pos+1],data[pos+2]
				local x2,y2 = data[pos+3],data[pos+4]
				local alpha,path = data[pos+5],data[pos+6]

				module.options:AddImage(x,y,x2,y2,path,alpha)

				pos = pos + 7
			else
				pos = pos + 1
			end
		end

		module.options.NoteName:SetText(data.name or "")
		local syncData = VMRT.VisNote.sync_data[data[1] or ""]
		if syncData then
			module.options.lastUpdate:SetText( L.NoteLastUpdate..": "..syncData.sender.." ("..date("%H:%M:%S %d.%m.%Y",syncData.time)..")" )
		else
			module.options.lastUpdate:SetText("")
		end

		module.options.chkStopUpdate:SetChecked(data.disableUpdate) 
	end
	function self:CreateNew()
		local new = {}
		local _,serverID,playerUID = strsplit("-",UnitGUID'player')
		local t = time()
		local uid = serverID..playerUID..t
		local foundUID = false
		while true do
			for i=1,#VMRT.VisNote.data do
				if VMRT.VisNote.data[i][1] == uid then
					foundUID = true
					break
				end
			end
			if foundUID then
				t = t - 1
				uid = serverID..playerUID..t
			else
				break
			end
		end
		new[1] = uid
		return new
	end
	function self:LoadNewest()
		local newest,nT = nil
		for uid,data in pairs(VMRT.VisNote.sync_data) do
			if not newest or nT < data.time then
				newest = uid
				nT = data.time
			end
		end
		local toLoad = nil
		if newest then
			for i=1,#VMRT.VisNote.data do
				if VMRT.VisNote.data[i][1] == newest then
					toLoad = VMRT.VisNote.data[i]
					break
				end
			end
		end
		if not toLoad then
			if #VMRT.VisNote.data > 0 then
				toLoad = VMRT.VisNote.data[#VMRT.VisNote.data]
			else
				VMRT.VisNote.data[1] = self:CreateNew()
				toLoad = VMRT.VisNote.data[1]
			end
		end
		self:LoadData(toLoad)
	end
	function self:GetCurrentData()
		return curr_data
	end

	self.clearAll = ELib:Button(self,L.messagebutclear):Size(90,20):Point("TOPLEFT",615,-30):OnClick(function(self)
		module.options:Clear()
		module.options:SaveData()
	end)

	self.sendButton = ELib:Button(self,L.messagebutsend):Size(90,20):Point("TOPLEFT",710,-30):OnClick(function(self)
		module.options:GenerateString()
	end)

	self.liveButton = ELib:Button(self,L.VisualNoteLiveSession):Size(90,20):Point("TOPLEFT",710,-55):OnClick(function(self)
		if not isLiveSession then
			module.options:GenerateString()
			self.Texture:SetGradientAlpha("VERTICAL",0.05,0.26,0.09,1, 0.20,0.41,0.25,1)
		else
			self.Texture:SetGradientAlpha("VERTICAL",0.05,0.06,0.09,1, 0.20,0.21,0.25,1)
		end
		isLiveSession = not isLiveSession
	end)

	self.SelectNote = ELib:DropDown(self,205,10):Size(135):Point("TOPLEFT",195,-5):SetText(L.VisualNoteSelectNote.."...")
	local function SelectNote_SetValue(_,arg)
		ELib:DropDownClose()
		module.options:LoadData(arg)
	end
	function self.SelectNote:PreUpdate()
		self.List = {
			{
				colorCode = "|cff00ff00",
				text = L.ProfilesNew,
				justifyH = "CENTER",
				func = function ()
					ELib.ScrollDropDown.Close()
					local new = module.options:CreateNew()
					VMRT.VisNote.data[#VMRT.VisNote.data + 1] = new
					module.options:LoadData(new)
				end,
			}
		}
		for i=#VMRT.VisNote.data,1,-1 do
			local noteName = VMRT.VisNote.data[i].name
			if not noteName or #noteName == 0 then
				noteName = L.messageTab1.." "..i
			end
			self.List[#self.List + 1] = {
				text = noteName,
				justifyH = "CENTER",
				arg1 = VMRT.VisNote.data[i],
				func = SelectNote_SetValue,
			}
		end
	end

	self.NoteName = ELib:Edit(self):Size(200,20):Point(410,-5):LeftText(LFG_LIST_TITLE..":"):OnChange(function(self,isUser)
		if not isUser then return end
		curr_data.name = self:GetText()
	end)
	self.NoteName:SetMaxBytes(50)

	self.removeButton = ELib:Button(self,L.cd2RemoveButton):Size(90,20):Point("TOPLEFT",615,-5):OnClick(function(self)
		StaticPopupDialogs["EXRT_VISNOTE_REMOVE"] = {
			text = L.cd2RemoveButton,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				for i=#VMRT.VisNote.data,1,-1 do
					if VMRT.VisNote.data[i] == curr_data then
						tremove(VMRT.VisNote.data,i)
					end
				end
				if #VMRT.VisNote.data == 0 then
					local new = module.options:CreateNew()
					VMRT.VisNote.data[#VMRT.VisNote.data + 1] = new
				end
				module.options:LoadData(VMRT.VisNote.data[#VMRT.VisNote.data])
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_VISNOTE_REMOVE")
	end)

	self.lastUpdate = ELib:Text(self,"",8):Point("BOTTOMLEFT",self,"BOTTOMLEFT",5,2):Color()

	self.chkHidePopup = ELib:Check(self,L.VisualNoteDisablePopup,VMRT.VisNote.DisablePopup):Point("BOTTOMRIGHT",self,"BOTTOMRIGHT",-10,5):Scale(.8):Size(10,10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VMRT.VisNote.DisablePopup = true
		else
			VMRT.VisNote.DisablePopup = nil
		end
	end) 

	self.chkStopUpdate = ELib:Check(self,L.VisualNoteDisableUpdateShort):Tooltip(L.VisualNoteDisableUpdate):Point("BOTTOMRIGHT",self,"BOTTOMRIGHT",-240,5):Scale(.8):Size(10,10):Left():OnClick(function(self) 
		curr_data.disableUpdate = self:GetChecked()
	end) 

	self.copyButton = ELib:Button(self,L.BossmodsKormrokCopy):Size(90,20):Point("TOPLEFT",710,-5):OnClick(function()
		self:SaveData()
		local new = self:CreateNew()
		for i=2,#curr_data do
			new[i] = curr_data[i]
		end
		new.name = (curr_data.name or "").." *"
		VMRT.VisNote.data[#VMRT.VisNote.data + 1] = new
		self:LoadData(new)
	end)

	local SCALE = 1 / 4

	local frame = ELib:Popup(L.message):Size(790*SCALE+6,535*SCALE+15+3):Point("LEFT",UIParent,"LEFT",100,0)
	module.frame = frame
	frame:Hide()
	frame.defWidth = 790*SCALE+6
	frame.defHeight = 535*SCALE+15+3

	frame.Close:SetScript("OnClick",function (self)
		module.db.PopupIsOn = false
		self:GetParent():Hide()
	end)

	frame:SetResizable(true)
	frame.buttonResize = CreateFrame("Frame",nil,frame)
	frame.buttonResize:SetSize(15,15)
	frame.buttonResize:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.buttonResize:SetFrameStrata("TOOLTIP")
	frame.buttonResize.back = frame.buttonResize:CreateTexture(nil, "BACKGROUND")
	frame.buttonResize.back:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\Resize")
	frame.buttonResize.back:SetAllPoints()
	frame.buttonResize.back:SetAlpha(.7)
	frame.buttonResize:SetScript("OnMouseDown", function(self)
		frame.Prop = frame:GetWidth() / frame:GetHeight()
		frame:StartSizing()
	end)
	frame.buttonResize:SetScript("OnMouseUp", function(self)
		frame:StopMovingOrSizing()
	end)
	frame:SetScript("OnSizeChanged", function (self, width, height)
		if self.lock or not self.Prop then 
			return 
		end
		if width/height >= self.Prop then
			width = height * self.Prop
			self.lock = true
			self:SetWidth(width)
			self.lock = false
		else
			height = width / self.Prop
			self.lock = true
			self:SetHeight(height)
			self.lock = false
		end
		local rate = width / frame.defWidth
		VMRT.VisNote.PopupSizeRate = rate
		VMRT.VisNote.PopupWidth = width
		VMRT.VisNote.PopupHeight = height
		module.options.main:SetScale(SCALE * rate)
	end)
	frame:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VMRT.VisNote.PopupLeft = self:GetLeft()
		VMRT.VisNote.PopupTop = self:GetTop()
	end)


	function module.ShowPopup()
		frame:Show()
		if VMRT.VisNote.PopupWidth and VMRT.VisNote.PopupHeight then
			frame:SetSize(VMRT.VisNote.PopupWidth, VMRT.VisNote.PopupHeight)
		end
		self.main:SetScale(SCALE*(VMRT.VisNote.PopupSizeRate or 1))
		self.main:SetParent(frame)
		self.main:ClearAllPoints()
		self.main:SetPoint("CENTER",0,-9)
		self.main.C.popup = true

		self.main.C:SetScript("OnUpdate",nil)

		if VMRT.VisNote.PopupLeft and VMRT.VisNote.PopupTop then 
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.VisNote.PopupLeft,VMRT.VisNote.PopupTop)
		end

		self.showPopup:Hide()
	end

	self.showPopup = ELib:Button(self,""):Size(20,20):Point("TOPLEFT",self.main,0,0):Tooltip(L.VisualNotePopupButTooltip.."\n"..L.VisualNotePopupButTooltip2):OnClick(function()
		if IsShiftKeyDown() then
			VMRT.VisNote.PopupWidth = nil
			VMRT.VisNote.PopupHeight = nil
			VMRT.VisNote.PopupSizeRate = nil
			VMRT.VisNote.PopupLeft = nil
			VMRT.VisNote.PopupTop = nil
			frame:Size(790*SCALE+6,535*SCALE+15+3):NewPoint("LEFT",UIParent,"LEFT",100,0)
		end
		module.db.PopupIsOn = true
		module:ShowPopup()

		ExRT.Options.Frame:Hide()
	end)
	self.showPopup:SetFrameStrata("DIALOG")

	self.showPopup.texture = self.showPopup:CreateTexture(nil,"ARTWORK")
	self.showPopup.texture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	self.showPopup.texture:SetTexCoord(0.4375,0.5,0.5,0.625)
	self.showPopup.texture:SetPoint("CENTER")
	self.showPopup.texture:SetSize(18,18)

	self.isWide = 810
	function self:OnShow()
		if self.main.C.popup then
			self.main:SetScale(1)
			self.main:SetParent(self)
			self.main:ClearAllPoints()
			self.main:SetPoint("TOP",0,-81)

			self.main.C.popup = nil

			self.main.C:SetScript("OnUpdate",CheckAlpha)

			self.showPopup:Show()

			frame:Hide()

			self.main:ResetScale()
		end

		self:LoadNewest()	  
	end
	self:SetScript("OnHide",function()
		if module.db.PopupIsOn then
			module:ShowPopup()
		end
	end)
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.VisNote = VMRT.VisNote or {}
	VMRT.VisNote.data = VMRT.VisNote.data or {}
	VMRT.VisNote.sync_data = VMRT.VisNote.sync_data or {}

	module:RegisterAddonMessage()
end

function module:UnpackString(str,sender)
	if str:sub(1,1):byte() == 254 then
		local c = str:sub(2,2):byte()
		if c == 1 then
			c = str:sub(3,3):byte()
			if c ~= DATA_VERSION then
				module.db.await = nil
				return
			end
			module.db.await = {}
			c = str:sub(4,4):byte()
			module.db.await[1] = str:sub(5,5+c-1)
			str = str:sub(5+c)

			c = str:sub(1,1):byte()
			module.db.await.name = str:sub(2,2+c-2)
			str = str:sub(2+c-1)

			local found = nil
			for i=1,#VMRT.VisNote.data do
				if VMRT.VisNote.data[i][1] == module.db.await[1] then
					if VMRT.VisNote.data[i].disableUpdate then
						module.db.await = nil
						return
					end
					VMRT.VisNote.data[i] = module.db.await
					found = true
					break
				end
			end
			if not found then
				VMRT.VisNote.data[#VMRT.VisNote.data + 1] = module.db.await
			end
			module.popup:Popup(sender)
			local uid = module.db.await[1]
			if uid then
				VMRT.VisNote.sync_data[uid] = VMRT.VisNote.sync_data[uid] or {}
				VMRT.VisNote.sync_data[uid].sender = sender
				VMRT.VisNote.sync_data[uid].time = time()
			end
		end
	end
	if str:sub(1,1):byte() == 254 then
		local c = str:sub(2,2):byte()
		if c == 2 then
			if not module.db.await then
				return
			end
			c = str:sub(3,3):byte()
			module.db.await[2] = c
			str = str:sub(4)
		end
	end
	if not module.db.await then
		return
	end
	local data = {strsplit(string.char(255),str)}
	for i=1,#data do
		local len = #data[i]
		if len > 0 and data[i]:sub(1,1):byte() <= 250 then
			local p1 = (data[i]:sub(1,1):byte() - 1) * 250 + (data[i]:sub(2,2):byte() - 1)
			local p2 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)

			local x,y = p1 % 1000,p2 % 1000
			local color,size = floor(p1 / 1000),floor(p2 / 1000)

			module.db.await[#module.db.await + 1] = "D"
			module.db.await[#module.db.await + 1] = x
			module.db.await[#module.db.await + 1] = y
			module.db.await[#module.db.await + 1] = color
			module.db.await[#module.db.await + 1] = size

			local pos = 5
			local prevDiffX,prevDiffY
			local astr = ""
			while true do
				local c = data[i]:sub(pos,pos)
				if c == "" then
					break
				end
				local X,Y
				if c:byte()==254 then
					X,Y = prevDiffX,prevDiffY
					pos = pos + 1
				else
					local p = (data[i]:sub(pos,pos):byte() - 1) * 250 + (data[i]:sub(pos+1,pos+1):byte() - 1)
					X,Y = floor(p / 100),p % 100
					if X > 50 then
						X = -(X - 50)
					end
					if Y > 50 then
						Y = -(Y - 50)
					end
					pos = pos + 2
				end
				prevDiffX,prevDiffY = X,Y

				astr = astr .. X .. "," .. Y ..","

				x = X+x
				y = Y+y
			end

			module.db.await[#module.db.await + 1] = astr
		elseif len > 0 and data[i]:sub(1,1):byte() == 251 then
			local c = data[i]:sub(2,2):byte()
			if c == 1 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local icon_type,size = floor(p1 / 1000),p3

				module.db.await[#module.db.await + 1] = "I"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = icon_type
				module.db.await[#module.db.await + 1] = size
			elseif c == 2 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)
				local p4 = (data[i]:sub(9,9):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local color,size = floor(p1 / 1000),p3

				module.db.await[#module.db.await + 1] = "T"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = color
				module.db.await[#module.db.await + 1] = size
				module.db.await[#module.db.await + 1] = data[i]:sub(10,10+p4-1)
			elseif c == 3 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local color,think = floor(p1 / 1000),floor(p2 / 1000)
				local size = p3

				module.db.await[#module.db.await + 1] = "O"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = color
				module.db.await[#module.db.await + 1] = size
				module.db.await[#module.db.await + 1] = think
				module.db.await[#module.db.await + 1] = 0
				module.db.await[#module.db.await + 1] = 1
			elseif c == 4 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local color,think = floor(p1 / 1000),floor(p2 / 1000)
				local size = p3

				module.db.await[#module.db.await + 1] = "O"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = color
				module.db.await[#module.db.await + 1] = size
				module.db.await[#module.db.await + 1] = think * 2
				module.db.await[#module.db.await + 1] = 0
				module.db.await[#module.db.await + 1] = 2
			elseif c == 5 or c == 7 or c == 8 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)
				local p4 = (data[i]:sub(9,9):byte() - 1) * 250 + (data[i]:sub(10,10):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local color,size = floor(p1 / 1000),floor(p2 / 1000)

				module.db.await[#module.db.await + 1] = "O"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = color
				module.db.await[#module.db.await + 1] = size
				module.db.await[#module.db.await + 1] = p3
				module.db.await[#module.db.await + 1] = p4
				module.db.await[#module.db.await + 1] = (c == 5 and 3) or (c == 7 and 5) or (c == 8 and 6) or 3
			elseif c == 6 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)
				local p4 = (data[i]:sub(9,9):byte() - 1) * 250 + (data[i]:sub(10,10):byte() - 1)

				local x,y = p1 % 1000,p2 % 1000
				local color,size = floor(p1 / 1000),floor(p2 / 1000)

				module.db.await[#module.db.await + 1] = "O"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = color
				module.db.await[#module.db.await + 1] = size * 2
				module.db.await[#module.db.await + 1] = p3
				module.db.await[#module.db.await + 1] = p4
				module.db.await[#module.db.await + 1] = 4
			elseif c == 9 then
				local p1 = (data[i]:sub(3,3):byte() - 1) * 250 + (data[i]:sub(4,4):byte() - 1)
				local p2 = (data[i]:sub(5,5):byte() - 1) * 250 + (data[i]:sub(6,6):byte() - 1)
				local p3 = (data[i]:sub(7,7):byte() - 1) * 250 + (data[i]:sub(8,8):byte() - 1)
				local p4 = (data[i]:sub(9,9):byte() - 1) * 250 + (data[i]:sub(10,10):byte() - 1)
				local p5 = (data[i]:sub(11,11):byte() - 1) * 250 + (data[i]:sub(12,12):byte() - 1)

				local x,y = p1 > 20000 and -(p1-20000) or p1,p2 > 20000 and -(p2-20000) or p2
				local x2,y2 = p3 > 20000 and -(p3-20000) or p3,p4 > 20000 and -(p4-20000) or p4
				local alpha = p5

				local str_len = (data[i]:sub(13,13):byte() - 1) * 250 + (data[i]:sub(14,14):byte() - 1)

				local path = data[i]:sub(15,14+str_len)

				local map_len = (data[i]:sub(15+str_len,15+str_len):byte() - 1) * 250 + (data[i]:sub(16+str_len,16+str_len):byte() - 1)
				for j=1,map_len do
					local pos = (data[i]:sub(16+str_len+j*2-1,16+str_len+j*2-1):byte() - 1) * 250 + (data[i]:sub(16+str_len+j*2,16+str_len+j*2):byte() - 1)

					path = path:sub(1,pos-1)..string.char(path:sub(pos,pos):byte() + 250)..path:sub(pos+1)
				end

				path = tonumber(path) or path

				module.db.await[#module.db.await + 1] = "G"
				module.db.await[#module.db.await + 1] = x
				module.db.await[#module.db.await + 1] = y
				module.db.await[#module.db.await + 1] = x2
				module.db.await[#module.db.await + 1] = y2
				module.db.await[#module.db.await + 1] = alpha
				module.db.await[#module.db.await + 1] = path
			end
		end
	end

	if module.options.LoadData then
		module.options:LoadData(module.db.await)
	end
end

module.db.syncStr = {}
function module:addonMessage(sender, prefix, ...)
	if prefix == "VN" then
		local _, zoneType, difficulty, _, maxPlayers, _, _, mapID = GetInstanceInfo()
		if difficulty == 7 or difficulty == 17 then
			return
		end
		if (IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender))
			or sender == ExRT.SDB.charKey 
			or sender == ExRT.SDB.charName 
		then
			return
		end
		local str = table.concat({...}, "\t")
		module.db.syncStr[sender] = module.db.syncStr[sender] or ""
		module.db.syncStr[sender] = module.db.syncStr[sender] .. str
		if module.db.syncStr[sender]:find("##F##$") then
			local str = module.db.syncStr[sender]:sub(1,-6)
			module.db.syncStr[sender] = nil

			local decoded = LibDeflate:DecodeForWoWAddonChannel(str)
			local decompressed = LibDeflate:DecompressDeflate(decoded)

			module:UnpackString(decompressed,sender)
		end
	end
end

do
	local frame = CreateFrame("Frame",nil,UIParent,BackdropTemplateMixin and "BackdropTemplate")
	module.popup = frame

	frame:SetBackdrop({bgFile="Interface\\Addons\\"..GlobalAddonName.."\\media\\White"})
	frame:SetBackdropColor(0.05,0.05,0.07,0.98)
	frame:SetSize(250,65)
	frame:SetPoint("RIGHT",UIParent,"CENTER",-200,0)
	frame:SetFrameStrata("DIALOG")
	frame:SetClampedToScreen(true)

	frame.border = ExRT.lib:Shadow(frame,20)

	frame.label = frame:CreateFontString(nil,"OVERLAY","GameFontWhiteSmall")
	frame.label:SetFont(frame.label:GetFont(),10)
	frame.label:SetPoint("TOP",0,-4)
	frame.label:SetTextColor(1,1,1,1)
	frame.label:SetText("MRT: "..L.VisualNote)

	frame.player = frame:CreateFontString(nil,"OVERLAY","GameFontWhiteSmall")
	frame.player:SetFont(frame.player:GetFont(),10)
	frame.player:SetPoint("TOP",0,-16)
	frame.player:SetTextColor(1,1,1,1)
	frame.player:SetText("MyName-MyRealm")

	frame.b1 = ELib:Button(frame,L.minimapmenuclose):Point("BOTTOMLEFT",5,5):Size(100,20):OnClick(function() frame:Hide() end)
	frame.b3 = ELib:Button(frame,L.VisualNoteOpen):Point("BOTTOMRIGHT",-5,5):Size(100,20):OnClick(function() 
		frame:Hide() 
		ExRT.Options:Open(module.options) 
		if module.options.LoadData and module.db.await then
			module.options:LoadData(module.db.await) 
		end
	end)

	frame.b1.icon = frame.b1:CreateTexture(nil,"ARTWORK")
	frame.b1.icon:SetPoint("RIGHT",frame.b1:GetTextObj(),"LEFT")
	frame.b1.icon:SetSize(18,18)
	frame.b1.icon:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	frame.b1.icon:SetTexCoord(0.125+(0.1875 - 0.125)*6,0.1875+(0.1875 - 0.125)*6,0.5,0.625)
	frame.b1.icon:SetVertexColor(1,0,0,1)

	frame.b3.icon = frame.b3:CreateTexture(nil,"ARTWORK")
	frame.b3.icon:SetPoint("RIGHT",frame.b3:GetTextObj(),"LEFT")
	frame.b3.icon:SetSize(18,18)
	frame.b3.icon:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	frame.b3.icon:SetTexCoord(0.125+(0.1875 - 0.125)*7,0.1875+(0.1875 - 0.125)*7,0.5,0.625)
	frame.b3.icon:SetVertexColor(0,1,0,1)

	function frame:Popup(player)
		if module.options.main and module.options.main.C:IsVisible() then
			return
		end
		if VMRT and VMRT.VisNote and VMRT.VisNote.DisablePopup then
			return
		end
		frame.player:SetText(player)
		frame:Show()
	end

	frame:Hide()
end