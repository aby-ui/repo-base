--[[
   AutoScrollFrame is an intrinsic scrollframe widget that has a few benefits over HybridScrollFrame:

   - No assembly required. The widget is self-contained and requires very little setup.
   - Built to be resizable:
      - List buttons are created on demand as the scrollframe expands.
      - List buttons automatically adjust width based on the scrollframe's width.
      - Scroll up/down buttons reliably update as the list size changes.
      - Page up/down distance adjusts to the scrollframe size changes.
   - More easily implement scrollframes with buttons of varied height. 
   - No globals except the mixin created. The entire widget is made of anonymous elements.
   - No iteration over buttons. Instead uses a callback function to fill buttons.
   - Heavily customized scrollbar that includes to-top and to-bottom scrollbar buttons.
   - A capture button covers the empty part of short lists to support drag-and-drop.
   
   To create:
      <RematchAutoScrollFrame parentKey="PetList"/>
         or
      panel.PetList = CreateFrame("RematchAutoScrollFrame",nil,panel)

   Required attributes (required for data to display):
      .list (table) ordered list of data to display in the scrollframe (can be a list of tables)
      .template (string) XML template name to use for list buttons
      .callback (function(button,info)) function that's called to fill a button with info (info is a list entry)
   
   Optional attributes:
      .preUpdateFunc (function(self)) function to run before scrollFrame:Update() happens
      .postUpdateFunc (function(self)) function to run after scrollFrame:Update() happens
	  .dynamicButtonHeight (function(self,index)) returns height of button at index
      .templateType (string) the type of widget to use other than "Button" (eg. "RematchCompositeButton")

   API expected to be used:
      autoScrollFrame:Update() -- call to refresh the contents (no need to do this on size changes)
	  autoScrollFrame:ScrollToIndex(index) -- jump to an index (1-size or -1 for the end) in the list
	  autoScrollFrame:IsIndexVisible(index) -- returns true if indexed button is fully within the visible scrollframe
	  autoScrollFrame:ChangeTemplate(template) -- change template that the scrollframe uses
	  autoScrollFrame:BlingIndex(index) -- flashes the button at the given index
	  autoScrollFrame:GetButtonWidth() -- returns the current width of the scrollframe's buttons
	  autoScrollFrame:IsOverEmptyArea() -- returns true if the mouse is over the empty area of an incomplete list (the capture button)

   For scrollframes where buttons can be variable height:
   - Define .dynamicButtonHeight as a function that will return the height of the button at the given
     index. No need to set button height in the callback; it's handled automatically during updates
   - If all buttons are fixed height but the fixed height can change, don't define .dynamicButtonHeight
     and instead define .buttonHeight and do an Update()

   For callback, prior to the callback being called:
      - The button has an .index assigned equal to the index in the list
      - The button has been sized (width and height)
]]


local _,L = ...
local rematch = Rematch

RematchAutoScrollFrameMixin = {} -- functions to be used for each instance
local mixin = RematchAutoScrollFrameMixin

-- local functions
local createNewButton, adjustRange, setOffset, updateScrollButtons
local scrollByLine, scrollByPage, scrollByMousewheel
local getButtonHeight, updateDataHeight, getElementFromOffset, getOffsetFromIndex

--[[ OnLoad, OnShow and OnSizeChanged are intrinsicOrder="precall" ]]

-- precall OnLoad will setup the scrollframe
function mixin:OnLoad()
   local scrollBar = self.ScrollFrame.ScrollBar

   self.offset = 0 -- scrollbar offset in px
   self.range = 0 -- max offset of scrollbar in pixels (dataHeight-scrollHeight); 0 when scrollbar disabled
   self.element = 0 -- the index of the button that comes before the first visible button (0 means button1 is first visible)
   self.elementOffset = 0 -- the offset just after the element (so top button lines up precisely)
   self.overflow = 0 -- the percent (0.0-0.999) down the top button that the scrollframe is scrolled
   self.dataHeight = 0 -- pixel height of all data as if it were one long frame
   self.scrollHeight = nil -- pixel height of the visible scroll area
   self.scrollWidth = nil -- pixel width of the visible scroll area
   self.buttonHeight = nil -- pixel height of the button template for the first button
   self.hasButtons = nil -- true when the scrollframe has buttons defined (everything initialized)

   -- anchor PageUp/PageDown capture buttons between the thumb and respective up/down buttons
   scrollBar.PageUpButton:SetPoint("TOP",scrollBar.UpButton,"BOTTOM")
   scrollBar.PageUpButton:SetPoint("BOTTOM",scrollBar.ScrollThumb,"TOP",0,-2)
   scrollBar.PageDownButton:SetPoint("TOP",scrollBar.ScrollThumb,"BOTTOM",0,3)
   scrollBar.PageDownButton:SetPoint("BOTTOM",scrollBar.DownButton,"TOP",0,1)

   -- set script handlers for controls that change the scrollframe/scrollbar offset
   -- note closures! self is the parent frame and not the control!

   -- sliding thumb
   scrollBar:SetScript("OnValueChanged",function(_,value,userInput) setOffset(self,value) end)
   -- mousewheel over scrollframe
   self.ScrollFrame:SetScript("OnMouseWheel",function(_,delta) scrollByMousewheel(self,delta) end)
   -- buttons that scroll up
   scrollBar.TopButton:SetScript("OnClick",function() setOffset(self,0) end)
   scrollBar.UpButton:SetScript("OnClick",function() scrollByLine(self,1) end)
   scrollBar.PageUpButton:SetScript("OnClick",function() scrollByPage(self,1) end)
   -- buttons that scroll down
   scrollBar.BottomButton:SetScript("OnClick",function() setOffset(self,-1) end)
   scrollBar.DownButton:SetScript("OnClick",function() scrollByLine(self,-1) end)
   scrollBar.PageDownButton:SetScript("OnClick",function() scrollByPage(self,-1) end)
   
   updateScrollButtons(self) -- disable scrollbar buttons initially (range is 0)
   scrollBar.ScrollThumb:Hide() -- and thumb is hidden by default
end

-- precall OnShow will update the list if it's needed
function mixin:OnShow()
   if self.updateNeeded then
      self:Update()
   end
end

-- precall when the parent frame changes size, adjust scrollchild size and do an update
function mixin:OnSizeChanged(w,h)
   w = floor(w+0.5) -- round width to nearest integer
   h = floor(h+0.5) -- height too
   self.scrollWidth = w-9
   self.scrollHeight = h-10
   self.ScrollFrame:GetScrollChild():SetSize(self.scrollWidth,self.scrollHeight)
   -- if scrollframe has buttons, run the update
   if self.hasButtons then
      self:Update()
   end
end

--[[ autoScrollFrame:Update() and autoScrollFrame:ScrollToIndex(index) are intended for the scrollframe owner ]]

-- this is called when the list needs updated for any reason (content changes, scrollbar range/position changes, etc)
-- the owner of the scrollframe should call this (myScrollFrame:Update()) when it wants to do a manual update too
function mixin:Update()
   if not self:IsVisible() then
      -- don't do an update if scrollframe isn't on screen
      self.updateNeeded = true -- but flag for an update when it's shown
      return
   end
   -- if scrollframe doesn't have buttons nor data defined, hide scrollbar and leave
   if not self.template or not self.list or not self.callback then
      return
   end
   if self.updating then
      -- if we're in an update already (like first render or setOffset near max range)
      return -- then leave with no need to run again
   end
   self.updating = true

   -- if no buttons defined yet, create just one to kick start table
   if not self.ScrollFrame.Buttons then -- if no buttons have yet been made
      self.ScrollFrame.Buttons = {createNewButton(self)}
      self.ScrollFrame.Buttons[1]:SetPoint("TOPLEFT")
      self.buttonHeight = floor(self.ScrollFrame.Buttons[1]:GetHeight()+0.5)
      self.hasButtons = true
   end
   local buttons = self.ScrollFrame.Buttons

   -- if an update happening before sizing force a resize to define a scrollHeight
   if not self.scrollHeight then -- ** this may retrigger an Update; double check
      self:OnSizeChanged(floor(self:GetWidth()+0.5),floor(self:GetHeight()+0.5))
   end

   -- recalculate height of all data
   updateDataHeight(self)
   -- update range if dataHeight or scrollHeight changed
   adjustRange(self)

   -- if a pre-update wrap exists, run it
   if self.preUpdateFunc then
      self.preUpdateFunc(self)
   end

   local list = self.list -- the table of data we're displaying
   local listSize = #self.list -- the size of the list
   local listIndex = self.element + 1 -- the index of the current button to be updated
   -- the remaining height of the scrollFrame includes the portion of the overflow button
   -- that's extended above the top button; as each button is added its height is removed
   -- from this remaining total; when it gets to 0 we're done updating list buttons
   local remaining = self.scrollHeight+self.overflow -- remaing height of scrollframe to fill
   local callback = self.callback -- user-defined function to update a single button's contents
   local buttonWidth = self.scrollWidth-25 -- width adjusted based on scrollWidth
   local lastButton -- only relevant for lists that don't fill scrollFrame

   -- update a button as long as there's data to show and there's area remaining to fill
   local buttonIndex = 1
   while listIndex<=listSize and remaining do
      local buttonHeight = getButtonHeight(self,listIndex)
      if buttonHeight and buttonHeight>0 then -- confirm there's a button of an actual height to display

         -- create button if it's needed
         if not buttons[buttonIndex] then
            buttons[buttonIndex] = createNewButton(self)
            buttons[buttonIndex]:SetPoint("TOPLEFT",buttons[buttonIndex-1],"BOTTOMLEFT")
         end

         if remaining<0 then -- if we've consumed all of the scrollHeight remaining, stop after this button
            remaining = nil
         else -- reduce the remaining scrollHeight to update by the buttonHeight
            remaining = remaining - buttonHeight
         end
         
         -- set index, size and run callback
         local button = buttons[buttonIndex]
         button.index = listIndex
		 button:SetSize(buttonWidth,buttonHeight)
         callback(button,self.list[listIndex])
         button:Show()
         lastButton = button

         -- and increment list and button index to do next button
         listIndex = listIndex + 1
         buttonIndex = buttonIndex + 1

      else -- if no buttonHeight then finish (should never run this; just for insurance)
         remaining = nil
      end
   end

   -- hide any remaining buttons that didn't get updated
   for i=buttonIndex,#buttons do
      buttons[i]:Hide()
   end

   -- if list didn't fill whole scrollframe, display capture button
   local captureButton = self.ScrollFrame.CaptureButton
   if self.range==0 then -- list didn't fill scrollframe (scrollbar disabled)
      captureButton:Show()
      captureButton.lastButton = lastButton -- can potentially be nil if 0 items in list!
      captureButton:SetPoint("TOP",lastButton or self.ScrollFrame,lastButton and "BOTTOM" or "TOP")
   else
      captureButton:Hide()
      lastButton = nil
   end

   -- if a post-update wrap exists, run it
   if self.postUpdateFunc then
      self.postUpdateFunc(self)
   end

   -- all done!
   self.updating = nil

end

-- scrolls the list to the given index (1->self.listSize), making it centered as best it can.
-- a negative index will scroll to the end
function mixin:ScrollToIndex(index)
   local offset
   if index==-1 then -- special case to scroll to end for -1 index
      offset = -1 
   elseif self.range==0 then -- if scrollbar disabled, scroll to top
      offset = 0
   else -- otherwise find an offset that puts the index centered as best it can in the visible list
      offset = getOffsetFromIndex(self,index)
   end
   setOffset(self,offset)
end

-- returns the indexed button if it's fully visible within the scrollframe, nil otherwise
function mixin:IsIndexVisible(index)
	local buttons = self.ScrollFrame.Buttons
	for _,button in ipairs(buttons) do
		if button.index==index and button:IsVisible() and button:GetTop()<(self.ScrollFrame:GetTop()+8) and button:GetBottom()>(self.ScrollFrame:GetBottom()-8) then
			return button
		end
	end
end

-- changes the template for the scrollframe; this should not be called frequently since each time
-- it will create new buttons and the old ones will never be garbage collected. For Rematch it's used
-- when CompactListMode changes, which is a rare event. For frequent changes, keep one template and
-- change the .buttonHeight and repurpose the template.
function mixin:ChangeTemplate(template)
   if type(template)=="string" and self.template~=template then -- only bother changing template if it's changing
      self.template = template
      local buttons = self.ScrollFrame.Buttons
      if buttons then -- only if template was previously applied in an Update
         for _,button in ipairs(buttons) do
            button:Hide() -- hide all old buttons
         end
         self.ScrollFrame.Buttons = nil -- remove buttons table so new one will be made
         self:Update() -- and force an update
      end
   end
end

-- this will flash an animated fade in-out texture over the indexed button, to draw attention to it
function mixin:BlingIndex(index)
	local button = self:IsIndexVisible(index)
	local bling = self.ScrollFrame.Bling
	if button then
		bling:ClearAllPoints()
		bling:SetParent(button)
		-- anchor bling to the "Back" texture if it exists and it's visible
		local anchorTo = button.Back
		if not anchorTo or not anchorTo:IsVisible() then
			anchorTo = button -- otherwise anchor bling to whole button
		end
		bling:SetPoint("TOPLEFT",anchorTo,"TOPLEFT",1,-1)
		bling:SetPoint("BOTTOMRIGHT",anchorTo,"BOTTOMRIGHT",-1,1)
		bling:SetFrameLevel(button:GetFrameLevel()+5)
		bling:Show()
	end
end

-- returns the current width of buttons
function mixin:GetButtonWidth()
	return self.scrollWidth-25
end

-- returns true if the mouse is over the capture button, or the blank area when the scrollframe list isn't full
function mixin:IsOverEmptyArea()
	return MouseIsOver(self.ScrollFrame.CaptureButton)
end

--[[ Local functions shared by all of the above methods]]

-- creates and returns a new button based on the stored template
function createNewButton(self)
	-- to create a list of CompositeButtons, define templateType as "RematchCompositeButton"
	local templateType = self.templateType or "Button"
	return CreateFrame(templateType,nil,self.ScrollFrame:GetScrollChild(),self.template)
end

-- adjusts the scrollbar's range based on the height of data and scrollframe
-- this should be called after updateDataHeight
function adjustRange(self)
   local listSize = #self.list
   local range = max(0,self.dataHeight-self.scrollHeight)
   -- only need to make adjustments if range has changed
   if range~=self.range then
      self.ScrollFrame.ScrollBar:SetMinMaxValues(0,range)
      local offset = max(0,min(range,self.offset))
      -- if we were at the end of the list prior to adjustment, change offset to new end of range
      if self.offset==self.range and offset~=0 then
         offset = range
      end
      self.range = range
      -- if offset changed (or we're at start) then set new offset
      if self.offset~=offset or offset==0 then
         self.offset = offset
         setOffset(self,offset)
      elseif offset==range then -- otherwise if we're at the end of the list
         updateScrollButtons(self) -- just update the buttons (so down is disabled on a resize)
      end
   end
end

-- based off HybridScrollFrame_SetOffset in HybridScrollFrame.lua
-- self is the handle, offset is the intended absolute offset in pixels
function setOffset(self,offset)
   -- special case, if offset is -1 then scroll to end (self.range)
   if offset==-1 then
      offset = self.range
   end
   -- constraint offset between 0 and max range and round it to a whole number
   self.offset = floor(max(0,min(self.range,offset))+0.5)

   -- recalculate the element and related info from the offset
   local element, elementOffset, overflow = getElementFromOffset(self,self.offset)
   local changed = self.element ~= element -- before saving, note if we're changing elements

   self.element = element
   self.overflow = overflow
   self.elementOffset = elementOffset

   if changed then -- if element has changed then update buttons
      self:Update()
   end

   self.ScrollFrame:SetVerticalScroll(self.overflow)
   self.ScrollFrame.ScrollBar:SetValue(self.offset)
   updateScrollButtons(self)
end

-- updates the state of the scroll/page up/down buttons and whether thumb displays
function updateScrollButtons(self)
   local scrollBar,range,offset = self.ScrollFrame.ScrollBar,self.range,self.offset
   scrollBar.ScrollThumb:SetShown(range>0)
   -- update scroll/page up
   local canScrollUp = range>0 and offset>0
   scrollBar.TopButton:SetEnabled(canScrollUp)
   scrollBar.UpButton:SetEnabled(canScrollUp)
   scrollBar.PageUpButton:SetEnabled(canScrollUp)
   local canScrollDown = range>0 and offset<range
   scrollBar.BottomButton:SetEnabled(canScrollDown)
   scrollBar.DownButton:SetEnabled(canScrollDown)
   scrollBar.PageDownButton:SetEnabled(canScrollDown)
end

-- scrolls up or down one line, making the top button align with the top afterwards (overflow=0)
-- delta of 1 = scroll up, delta of -1 = scroll down
function scrollByLine(self,delta)
   local newOffset
   if delta==1 and self.overflow>0 then -- if we're scrolling up and top button is partially hidden
      newOffset = self.elementOffset -- then scroll up to top of the partially hidden button
   else
      local buttonHeight
      if delta==1 and self.element>0 then
         buttonHeight = getButtonHeight(self,self.element)
      else
         buttonHeight = getButtonHeight(self,self.element+1)
      end      
      newOffset = self.elementOffset - delta*buttonHeight -- otherwise scroll up/down next whole button
   end
   newOffset = max(0,min(self.range,newOffset)) -- keep it constrained to 0-range
   --local newOffset = max(0,min(self.range,(floor(self.element)-delta)*buttonHeight))
   if newOffset ~= self.offset then
      setOffset(self,newOffset)
   end
end

-- scrolls up or down by a whole scrollHeight page
function scrollByPage(self,delta)
   local newOffset
   if delta==1 then -- if scrolling up then scroll up a scrollHeight less one button height
      newOffset = self.elementOffset - delta*(self.scrollHeight-getButtonHeight(self,self.element))
   else -- if scrolling down then scroll whole scrollHeight
      newOffset = self.elementOffset - delta*(self.scrollHeight)
   end
   local element, elementOffset, overflow = getElementFromOffset(self,newOffset)
   newOffset = max(0,min(self.range,elementOffset))
   if newOffset ~= self.offset then
      setOffset(self,newOffset)
   end
end

-- mousewheel scrolls by line or page depending on SlowMousewheelScroll setting
function scrollByMousewheel(self,delta)
   if self.range>0 then
      if RematchSettings.SlowMousewheelScroll then
         scrollByLine(self,delta)
      else
         scrollByPage(self,delta)
      end
   end
end

-- returns the height of the button at the index
function getButtonHeight(self,index)
   -- if a dynamic function defined, get it from the callback
   if self.dynamicButtonHeight then
      if index>0 and index<=#self.list then -- only return a height of index is valid
         return self.dynamicButtonHeight(self,index) or 0
      else -- for invalid index return 0
         return 0
      end
   else -- for fixed height buttons return saved height
      return self.buttonHeight
   end
end

-- updates self.dataHeight to be the pixel height of all data in the list
function updateDataHeight(self)
   local dataHeight = 0

   -- if using dynamic heights, calculate total height
   if self.dynamicButtonHeight then
      for i=1,#self.list do -- add height of button at each index to total
         dataHeight = dataHeight + getButtonHeight(self,i)
      end
   else -- otherwise it's simply size of list times fixed button height
      dataHeight = #self.list * self.buttonHeight
   end
   self.dataHeight = dataHeight
end

-- this function takes an offset and returns the element, elementOffset and overflow from that offset
function getElementFromOffset(self,offset)
   local element = 0 -- index of button before first visible on the list
   local elementOffset = 0 -- offset at the end of that button (so top of first visible button)
   local overflow = 0 -- pixels the top button is scrolled up (remainder)

   if not self.dynamicButtonHeight then -- if this scrollframe's buttons are fixed height
      local buttonHeight = self.buttonHeight
      local roughElement = offset/buttonHeight -- approximate index of button prior to first on screen
      element = floor(roughElement) -- element is the actual index
      overflow = floor((roughElement-element)*buttonHeight+0.5) -- remainder goes into overflow
      elementOffset = element*buttonHeight -- offset to end of element
   else -- otherwise this scrollframe's buttons are dynamic height (bit more complicated!)
      local prior = 0 -- pixels prior to present offset
      local index = 1 -- starting with first list index
      -- for variable-height buttons we increment the element by adding buttonHeights to
      -- a total (prior) until we've reached the offset
      while prior<offset do
         local buttonHeight = getButtonHeight(self,index)
         local post = prior + buttonHeight -- the "after" prior value, saving in a separate variable
         if buttonHeight and buttonHeight>0 then
            if post>offset then -- if we've passed the offset
               overflow = buttonHeight-(post-offset) -- then store the remaining pixels into the overflow
            else
               element = element + 1 -- otherwise increment element
               elementOffset = elementOffset+buttonHeight -- offset to end of element
            end
            prior = post -- update prior to the version added to the buttonHeight
         else -- safety check: if buttonHeight won't advance prior, leave
            prior = offset
         end
         index = index + 1
      end
   end

   return element, elementOffset, overflow
end

-- this takes an index and converts it to an offset where the indexed item is centered
-- in the list and the top button/element is aligned (overflow is 0)
function getOffsetFromIndex(self,index)
   local offset = 0

   if not self.dynamicButtonHeight then -- for fixed heights this is easy
      offset = (index+1)*self.buttonHeight -- index+1 to pad offset to slightly above center
   else -- for dynamic heights need to total up heights
      for i=1,index+1 do -- index+1 to pad offset to slightly above center here too
         offset = offset+getButtonHeight(self,i)
      end
   end

   offset = offset - self.scrollHeight/2 -- adjust offset by half of the scrollHeight to center it
   -- to get the top button to line up, getting the elementOffset as the final offset
   local _,elementOffset = getElementFromOffset(self,offset)
   return elementOffset
end
