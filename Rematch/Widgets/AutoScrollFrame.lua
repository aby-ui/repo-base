--[[

	AutoScrollFrame is a scrollframe widget that has a few benefits over HybridScrollFrame:

		- No assembly required. The widget is self-contained and requires very little setup.
		- Built to be resizable:
			- List buttons are created on demand as the scrollframe expands.
			- List buttons adjust width based on the scrollframe's width.
			- Scroll up/down buttons reliably update as the list size changes.
			- Page up/down distance adjusts to the scrollframe size.
		- No globals except AutoScrollFrame created. Entire widget is made of anonymous elements.
		- No iteration over buttons; instead uses a callback function to fill buttons.
		- Button template can be an XML template OR a lua function for an all-lua addon.

	To use:

	1) Create either a button template or a constructor function to build out list buttons.
	2) Create an ordered table to be your list of data.
	3) Create a function to fill in a button given an item from the list of data.
	4) Create the widget with AutoScrollFrame:Create(parent,template,list,callback) (see below)
	5) Size and position it like a regular frame.
	6) When the data in the list has changed, call handle:Update()
	7) That's it! AutoScrollFrame will take care of the rest.

	API:

	handle = AutoScrollFrame:Create(parent,template,list,callback)
	- This will create a new instance of an AutoScrollFrame and return its handle.
		Paramters:
			parent: The frame the widget will be initially attached/parented to.
			template: The name of the XML template or the function to build a button. (see below)
			list: The ordered table. The data to display in the order to display it.
			callback: The function to fill in one of the list button's data. (see below)

	handle:Update()
	- Updates the displayed contents of the list. It's not necessary to call this due to new
		buttons possibly being created. AutoScrollFrame will handle that. Just call when the
		contents of the list have changed. It will run the callback for each visible button.

	handle:ScrollToIndex(index)
	- This will scroll the list to the index'th item, centering it as best it can.

	handle:SetFastScroll(boolean)
	- The default behavior of mousewheel and scroll buttons is to move up/down one line at a time.
		If FastScroll is enabled, mousewheel/scroll buttons will move up/down a whole page at a time,
		just as clicking above or below the thumb will do with or without this setting.
	
	handle:WrapUpdate(preFunc,postFunc)
	- Sets a function to run before and/or after the list is updated.

	buttons,captureButton = handle:GetListButtons()
	- This returns list buttons and the capture button within the scrollframe. In normal use this
		should never be needed. But if an addon implements drag and drop it can be useful.
		The captureButton is an invisible button that takes up the empty space below the list when
		the list doesn't fill the scrollframe. For drag and drop purposes too.


	On Template Button Function:

		When the template in Create() is a function and not an XML template, AutoScrollFrame will
		create a button and call the function with the new button as the first parameter. The
		function's job is to create elements within the button and to give it a height:

			local function createButton(button)
				button:SetHeight(24)
				button.Text = button:CreateFontString(nil,"ARTWORK","GameFontNormal")
				button.Text:SetAllPoints()
				button.Text:SetJustifyH("LEFT")
			end

		This height should be the same for every created button. The width will change based on the
		width of the scrollframe, which is 30 less than the width of the whole AutoScrollFrame.

	On Callback Function:

		Instead of iterating over all buttons in the scrollframe and handling the hiding/showing
		and other housekeeping, AutoScrollFrame will call the callback for each displayed button
		with the button as its first parameter and the list item as the second. For example:

			local function fillButton(button,info)
				button.Text:SetText(info.Next)
			end
		
	Also:

		Each AutoScrollFrame is made of a base Frame with inset borders and a marble background.
		Within this frame is a ScrollFrame anchored 5px from each corner (topleft,5,-5) that
		overlaps the scrollbar on the right side.

		The handle returned by AutoScrollFrame:Create() is not a true frame but should be treated
		as one. handle:SetShown(not handle:IsVisible()) and such will run the methods on the
		underlying base frame.

		Button width is sized to be 30px less than the width of the AutoScrollFrame widget, or
		5px from the left edge and 25px from the right (5px + 20px for scrollbar).

		There are no size limits on an AutoScrollFrame but a minimum height of 120 is recommended.

	Example Use:

		-- callback to fill the button's contents
		function fillButton(button,info)
			button.Text:SetText(info)
		end

		-- template function to build the list button
		function createButton(button)
			button:SetHeight(24)
			button.Text = button:CreateFontString(nil,"ARTWORK","GameFontNormal")
			button.Text:SetAllPoints()
			button.Text:SetJustifyH("LEFT")
		end

		local data = {}
		for i=1,50 do -- making some data (list can start out empty too!)
			tinsert(data,"Test Data #"..i)
		end

		local asf = AutoScrollFrame:Create(UIParent, createButton, data, fillButton)
		asf:SetSize(300,300)
		asf:SetPoint("CENTER")

		asf:Update()

	01/01/2016 version 002 added AutoScrollFrame:WrapUpdate(preFunc,postFunc)
	12/26/2016 version 001 initial release

]]

local version = 002 -- increment anytime changes are made to this file

if not AutoScrollFrame or AutoScrollFrame.version<version then

	-- local functions to define later
	local createNewButton, setOffset, updateScrollButtons, onSizeChanged, adjustRange, onMouseWheel

	AutoScrollFrame = {}
	AutoScrollFrame.version = version

	-- each created handle will get this metatable that makes the handle behave as a widget
	local meta = {}
	function meta.__index(self,key)
		if AutoScrollFrame[key] then -- if method exists in AutoScrollFrame, use it
			return AutoScrollFrame[key]
		elseif type(self.frame[key])=="function" then -- otherwise it's probably a frame method for the base frame (handle.frame:Show())
			return function(self,...) -- self here is the calling handle still
				return self.frame[key](self.frame,...) -- call the key method with the passed paramters to the handle.frame
			end
		end
	end

	-- when the calling addon wants to force an update, call this. it will call the callback for each button to display.
	function AutoScrollFrame:Update()
		-- confirm whether we should be doing an update
		if not self.frame:IsVisible() then
			-- don't do an update if scrollframe isn't on screen
			self.updateNeeded = true -- but flag for an update when it's shown
			return
		end
		if self.updating then
			-- if we're in an update already (like first render or setOffset near max range)
			return -- then no need to run again
		end
		-- flag to prevent updating being called from within an update
		self.updating = true
		-- make sure there are enough buttons to span the scrollHeight
		if not self.buttons then
			self.buttons = {createNewButton(self)}
			self.buttons[1]:SetPoint("TOPLEFT",self.scrollChild)
			self.scrollFrame.Buttons = self.buttons -- just in case need outside access
			self.buttonHeight = floor(self.buttons[1]:GetHeight()+0.5)
		end
		-- if an update happening before sizing (shouldn't!) force a resize
		if not self.scrollHeight then
			onSizeChanged(self,floor(self.frame:GetWidth()+0.5),floor(self.frame:GetHeight()+0.5))
		end
		local numButtons = ceil(self.scrollHeight/self.buttonHeight) + 1
		-- create buttons not already made
		for i=#self.buttons+1,numButtons do
			self.buttons[i] = createNewButton(self)
			self.buttons[i]:SetPoint("TOPLEFT",0,-(i-1)*self.buttonHeight)
		end
		-- make any scrollbar adjustments needed
		adjustRange(self)
		-- if a pre-update wrap exists, run it
		if self.preFunc then
			self.preFunc(self)
		end
		-- update the buttons
		local list = self.list
		local numData = #list -- size of the list of data
		local callback = self.callback -- the function to update a single button's contents
		local width = self.scrollWidth-21 -- width adjusted based on scrollWidth
		local element = floor(self.element) -- this is the "element" offset, integer starting at 0
		local lastButton -- only relevant for lists that don't fill scrollframe; the last list button shown
		for i=1,#self.buttons do
			local button = self.buttons[i]
			local show
			if i<=numButtons then
				local index = i+element
				if index<=numData and callback then
					button:SetWidth(width) -- adjust width based on scrollWidth
					button.index = index
					callback(button,list[index]) -- run the callback to update button's contents
					lastButton = button
					show = true
				end
			end
			button:SetShown(show)
		end
		-- if list didn't fill whole scrollframe, display capture button
		local captureButton = self.captureButton
		if self.range==0 then
			captureButton:Show()
			captureButton.lastButton = lastButton -- can potentially be nil if 0 items in list!
			captureButton:SetPoint("TOP",lastButton or self.scrollFrame,lastButton and "BOTTOM" or "TOP")
		else
			captureButton:Hide()
			captureButton.lastButton = nil
		end
		-- if a post-update wrap exists, run it
		if self.postFunc then
			self.postFunc(self)
		end
		-- all done!
		self.updating = nil
	end

	-- This creates a new AutoScrollFrame and returns a handle to the created object.
	-- parent (frame): the frame that this widget is being parented to
	-- template (string): the XML template of the list buttons (fix height, expect variable width or 30 less than scrollFrame width)
	-- list (table): ordered table of data to display in the list
	-- callback (function): the function called to fill a button with an entry in the list (button,info)
	function AutoScrollFrame:Create(parent,template,list,callback)
		-- outside manipulation of an AutoScrollFrame is by its handle (ie handle:Update())
		local handle = { template=template, list=list, callback=callback, offset=0, element=0, range=0, }
		-- turn handle into a widget to use AutoScrollFrame methods (and frame methods for handle.frame)
		setmetatable(handle,meta)
		-- create the base frame + scrollframe + scrollbar and necessary bits
		handle.frame = CreateFrame("Frame",nil,parent)
		handle.frame:SetFlattensRenderLayers(true) -- weird fix for buttons in scrollchild not being clipped
		-- create dark marbled background
		local back = handle.frame:CreateTexture(nil,"BACKGROUND")
		back:SetPoint("TOPLEFT",1,-1)
		back:SetPoint("BOTTOMRIGHT",-1,1)
		back:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble",true,true)
		back:SetHorizTile(true)
		back:SetVertTile(true)
		-- border around the edge
		for k,v in pairs({{"UI-Frame-InnerTopLeft","TOPLEFT",0,0},{"UI-Frame-InnerTopRight","TOPRIGHT",0,0},{"UI-Frame-InnerBotLeftCorner","BOTTOMLEFT",0,0}, {"UI-Frame-InnerBotRight","BOTTOMRIGHT",0,0},{"_UI-Frame-InnerTopTile","TOPLEFT",6,0,"TOPRIGHT",-6,0}, {"_UI-Frame-InnerBotTile","BOTTOMLEFT",6,0,"BOTTOMRIGHT",-6,0},{"!UI-Frame-InnerLeftTile","TOPLEFT",0,-6,"BOTTOMLEFT",0,6}, {"!UI-Frame-InnerRightTile","TOPRIGHT",0,-6,"BOTTOMRIGHT",0,6}}) do
			local border = handle.frame:CreateTexture(nil,"BORDER",v[1])
			border:ClearAllPoints()
			border:SetPoint(v[2],v[3],v[4])
			if v[5] then
				border:SetPoint(v[5],v[6],v[7])
			end
		end
		-- scrollFrame
		handle.scrollFrame = CreateFrame("ScrollFrame",nil,handle.frame)
		handle.scrollFrame:SetPoint("TOPLEFT",5,-5)
		handle.scrollFrame:SetPoint("BOTTOMRIGHT",-5,5)
		-- scrollChild (onSizeChanged will give this a size)
		handle.scrollChild = CreateFrame("Frame",nil,handle.scrollFrame)
		handle.scrollChild:SetPoint("TOPLEFT")
		handle.scrollFrame:SetScrollChild(handle.scrollChild)
		-- scrollBar slider
		handle.scrollBar = CreateFrame("Slider",nil,handle.scrollFrame)
		handle.scrollBar:SetSize(16,0)
		handle.scrollBar:SetPoint("TOPRIGHT",1,-14)
		handle.scrollBar:SetPoint("BOTTOMRIGHT",1,11)
		-- scrollbar thumb
		handle.scrollBar:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		handle.scrollThumb = handle.scrollBar:GetThumbTexture()
		handle.scrollThumb:SetSize(16,24)
		handle.scrollThumb:SetTexCoord(0.2,0.8,0.125,0.875)
		-- scrollbar artwork
		local scrollTop = handle.scrollBar:CreateTexture(nil,"ARTWORK")
		scrollTop:SetSize(24,48)
		scrollTop:SetPoint("TOPLEFT",-5,18)
		scrollTop:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scrollTop:SetTexCoord(0,0.45,0,0.2)
		local scrollBot = handle.scrollBar:CreateTexture(nil,"ARTWORK")
		scrollBot:SetSize(24,64)
		scrollBot:SetPoint("BOTTOMLEFT",-5,-15)
		scrollBot:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scrollBot:SetTexCoord(0.515625,0.97,0.1440625,0.4140625)
		local scrollMid = handle.scrollBar:CreateTexture(nil,"ARTWORK")
		scrollMid:SetSize(24,0)
		scrollMid:SetPoint("TOPLEFT",-5,-30)
		scrollMid:SetPoint("BOTTOMLEFT",-5,49)
		scrollMid:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scrollMid:SetTexCoord(0,0.45,0.1640625,1)
		-- scroll up/down buttons sit outside the top and bottom of the slider
		handle.scrollUpButton = CreateFrame("Button",nil,handle.scrollBar,"UIPanelScrollUpButtonTemplate")
		handle.scrollUpButton:SetPoint("BOTTOM",handle.scrollBar,"TOP",1,-1)
		handle.scrollUpButton.delta = 1
		handle.scrollDownButton = CreateFrame("Button",nil,handle.scrollBar,"UIPanelScrollDownButtonTemplate")
		handle.scrollDownButton:SetPoint("TOP",handle.scrollBar,"BOTTOM",1,2)
		handle.scrollDownButton.delta = -1
		-- page up/down invisible buttons stretch between the scroll up/down buttons and the thumb
		-- not using click behavior of the bar to avoid using ValueStep and StepsPerPage
		handle.pageUpButton = CreateFrame("Button",nil,handle.scrollBar)
		handle.pageUpButton:SetSize(18,0)
		handle.pageUpButton:SetPoint("TOP")
		handle.pageUpButton:SetPoint("BOTTOM",handle.scrollThumb,"TOP")
		handle.pageUpButton.delta = 1
		handle.pageDownButton = CreateFrame("Button",nil,handle.scrollBar)
		handle.pageDownButton:SetSize(18,0)
		handle.pageDownButton:SetPoint("TOP",handle.scrollThumb,"BOTTOM")
		handle.pageDownButton:SetPoint("BOTTOM")
		handle.pageDownButton.delta = -1
		-- invisible captureButton stretches over empty space when the list doesn't fill the scrollframe
		-- top is anchored in Update (with captureButton.lastButton defined as the last button listed)
		handle.captureButton = CreateFrame("Button",nil,handle.scrollFrame)
		handle.captureButton:SetPoint("BOTTOMLEFT")
		handle.captureButton:SetPoint("BOTTOMRIGHT",-21,0)
		-- closures are to ensure 'handle' is the 'self' for each script handler
		handle.frame:SetScript("OnShow",function(self) if handle.updateNeeded then handle:Update() end end)
		handle.frame:SetScript("OnSizeChanged",function(self,w,h) onSizeChanged(handle,w,h) end)
		handle.scrollBar:SetScript("OnValueChanged",function(self,value,userInput) setOffset(handle,value) end)
		handle.scrollFrame:SetScript("OnMouseWheel",function(self,delta) onMouseWheel(handle,delta) end)
		handle.scrollUpButton:SetScript("OnClick",function(self) onMouseWheel(handle,self.delta) end)
		handle.scrollDownButton:SetScript("OnClick",function(self) onMouseWheel(handle,self.delta) end)
		handle.pageUpButton:SetScript("OnMouseDown",function(self) onMouseWheel(handle,self.delta,true) end)
		handle.pageDownButton:SetScript("OnMouseDown",function(self) onMouseWheel(handle,self.delta,true) end)
		-- update initial state of buttons
		updateScrollButtons(handle)
		-- and finally return the handle
		return handle
	end

	-- scrolls the list to the given list index (1->self.listSize), making it centered as best it can
	-- a negative index will scroll to the end
	function AutoScrollFrame:ScrollToIndex(index)
		local offset = max(0,min(self.range,self.buttonHeight*index-self.scrollHeight/2))
		setOffset(self,offset)
	end

	-- in its default state, mousewheel up/down and the up/down scroll buttons go up/down one line at a time
	-- if fastScroll is enabled, the list will scroll a page at a time.
	function AutoScrollFrame:SetFastScroll(value)
		self.fastScroll = value
	end

	-- returns a reference to the list of buttons (self.buttons) and the captureButton (self.captureButton)
	function AutoScrollFrame:GetListButtons()
		return self.buttons,self.captureButton
	end

	function AutoScrollFrame:WrapUpdate(preFunc,postFunc)
		self.preFunc = type(preFunc)=="function" and preFunc
		self.postFunc = type(postFunc)=="function" and postFunc
	end

	------------------------------------------------------------
	-- Everything following this is local to this module only --
	------------------------------------------------------------

	-- creates and returns a new list button based on the stored template
	function createNewButton(self)
		local button
		if type(self.template)=="function" then -- if template is a function
			button = CreateFrame("Button",nil,self.scrollChild)
			self.template(button) -- call template function with the new button
		else -- otherwise it's an XML template
			button = CreateFrame("Button",nil,self.scrollChild,self.template)
		end
		return button
	end

	-- based off HybridScrollFrame_SetOffset in HybridScrollFrame.lua
	-- self is the handle, offset is the intended absolute offset in pixels
	-- this function defines self.element which is a 0-based float that's an offset from the first list item
	-- (element of 5.5 would be halfway down the 6th entry in the list)
	function setOffset(self,offset)
		local buttonHeight = self.buttonHeight
		local element = offset/buttonHeight
		local overflow = element - floor(element)
		offset = max(0,min(self.range,offset))
		local changed = floor(self.element)~=floor(element)
		self.offset = offset
		self.element = element
		if changed then -- if element has changed then update buttons
			self:Update()
		end
		self.scrollFrame:SetVerticalScroll(overflow*buttonHeight)
		self.scrollBar:SetValue(offset)
		updateScrollButtons(self)
	end

	-- updates the state of the scroll/page up/down buttons and whether thumb displays
	function updateScrollButtons(self)
		local scrollBar,range,offset = self.scrollBar,self.range,self.offset
		self.scrollThumb:SetShown(range>0)
		-- update scroll/page up
		local canScrollUp = range>0 and offset>0
		self.scrollUpButton:SetEnabled(canScrollUp)
		self.pageUpButton:SetShown(canScrollUp)
		if canScrollUp then
			self.pageUpButton:SetPoint("BOTTOM",self.scrollThumb,"TOP")
		end
		-- update scroll/page down
		local canScrollDown = range>0 and offset<range
		self.scrollDownButton:SetEnabled(canScrollDown)
		self.pageDownButton:SetShown(canScrollDown)
		if canScrollDown then
			self.pageDownButton:SetPoint("TOP",self.scrollThumb,"BOTTOM")
		end
	end

	-- script handler for frame OnSizeChanged; self is the handle
	function onSizeChanged(self,w,h)
		self.scrollWidth = w-9
		self.scrollHeight = h-10
		self.scrollChild:SetSize(self.scrollWidth,self.scrollHeight)
		if self.buttonHeight then -- don't do an update if we're just setting up
			self:Update()
		end
	end

	-- adjusts the scrollbar's range based on the height of data and scrollframe
	function adjustRange(self)
		local listSize = #self.list
		local range = max(0,listSize*self.buttonHeight-self.scrollHeight)
		-- only need to make adjustments if range has changed
		if range~=self.range then
			self.scrollBar:SetMinMaxValues(0,range)
			local offset = max(0,min(range,self.offset))
			-- if we were at the end of list prior to adjustment, change offset to new end of range
			if self.offset==self.range and offset~=0 then
				offset = range
			end
			self.range = range
			-- if offset changed (or we're at start) then set new offset
			if self.offset~=offset or offset==0 then
				self.offset = offset
				setOffset(self,offset)
			end
		end
	end

	-- delta is 1 for mousewheel up, -1 for mousewheel down
	function onMouseWheel(self,delta,byPage)
		local buttonHeight = self.buttonHeight
		if buttonHeight then
			if byPage or self.fastScroll then -- for fastScroll, scroll a whole page (number of elements minus 1)
				delta = floor(self.scrollHeight/buttonHeight-1)*delta
			end
			local newOffset = max(0,min(self.range,(floor(self.element)-delta)*buttonHeight))
			if newOffset ~= self.offset then
				setOffset(self,newOffset)
			end
		end
	end

end
