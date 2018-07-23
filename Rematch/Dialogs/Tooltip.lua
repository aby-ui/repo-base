
local _,L = ...
local rematch = Rematch
local tooltip = RematchTooltip

function rematch:ShowTooltip(title,body,anchorPoint,relativeTo,relativePoint,xoff,yoff)
	if rematch:UIJustChanged() or (RematchSettings.HideTooltips and not anchorPoint) then
		return -- don't show tooltip if ui just changed or HideTooltips enabled (with no given anchor)
	end
	if not title then -- grab tooltip from calling widget if one isn't passed
		title = self.tooltipTitle
		body = self.tooltipBody
	end

	if not title then return end -- leave if no tooltip to show

	tooltip.Title:SetText(title)
	tooltip.Body:SetText(body)

	-- adjust width based on width of title and bofy
	local titleWidth = min(tooltip.Title:GetStringWidth(),200)
	local width
	if not body then
		width = titleWidth -- for tooltips with just a title, make width the title width
	else
		width = max(titleWidth,200) -- for tooltips with a body make width the max of title or 180
		-- but both title and body width are less than 180, shrink to max width of title and body
		local bodyWidth=tooltip.Body:GetStringWidth()
		if width>titleWidth and width>bodyWidth then
			width = max(titleWidth,bodyWidth)
		end
	end

	tooltip.Title:SetSize(width,0)
	tooltip.Body:SetSize(width,0)

	-- now adjust actual width to the wider width of the wrapped title and body
	width = max(tooltip.Title:GetWrappedWidth(),tooltip.Body:GetWrappedWidth())

	tooltip:SetSize(width+16,tooltip.Title:GetStringHeight() + (body and tooltip.Body:GetStringHeight()+2 or 0) + 16)

	if anchorPoint=="cursor" then
		tooltip:SetScript("OnUpdate",tooltip.OnUpdate)
	elseif not anchorPoint or anchorPoint==true then
		rematch:SmartAnchor(tooltip,self)
	else
		tooltip:ClearAllPoints()
		tooltip:SetPoint(anchorPoint,relativeTo,relativePoint,xoff,yoff)
	end

	tooltip:Show()
end

function tooltip:OnUpdate(elapsed)
	local x,y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	x = x/scale
	y = y/scale
	self:ClearAllPoints()
	if x>UIParent:GetWidth()/2 then -- right half of screen
		self:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMLEFT",x-2,y+2)
	else -- left half of screen
		self:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",x+2,y+2)
	end
end

function rematch:HideTooltip()
	tooltip:Hide()
	tooltip:SetScript("OnUpdate",nil)
	RematchTableTooltip:Hide()
end

-- A TableTooltip is a tooltip designed for formatted text that doesn't wrap,
-- especially for displaying data in columns or in-line textures that want
-- vertically-centered fontstrings. Use RematchTooltip for traditional tooltips
-- with wrapping lines of text.
-- data is an ordered table with each entry as a line; a line can be either a
-- string or a sub-table that will display in separate columns:
-- ex: {"This is the title", {"Wins:",wins},	{"Losses:",losses} }
-- layout is an optional unordered table to define extra details
-- ex: {height=16, justifyH={"LEFT","RIGHT"},colors={nil,{1,1,1}}}
function rematch:ShowTableTooltip(anchorTo,data,layout)
	local tooltip = RematchTableTooltip

	-- if nothing passed then leave
	if not anchorTo or not data then
		return
	end

	local height = layout and layout.height or 16 -- each row is 16 height unless layout says otherwise
	tooltip.Rows = tooltip.Rows or {}

	-- wipe old tooltip
	for _,row in ipairs(tooltip.Rows) do
		for _,column in ipairs(row.Columns) do
			column:SetText("")
			column:SetWidth(0)
			column:Hide()
		end
		row:Hide()
	end

	local maxColumns = 1 -- maximum number of columns in a row
	for i=1,#data do
		-- each row is just a frame to contain the columns which are fontstrings
		local row = tooltip.Rows[i]
		if not row then
			row = CreateFrame("Frame",nil,tooltip)
			if i==1 then -- first row is positioned to the topleft of the tooltip
				row:SetPoint("TOPLEFT",8,-8)
			else -- further rows are anchored to the previous
				row:SetPoint("TOPLEFT",tooltip.Rows[i-1],"BOTTOMLEFT")
			end
			row.Columns = {}
			tooltip.Rows[i] = row
		end
		-- some rows have one column, some have multiple
		local numColumns = type(data[i])=="table" and #data[i] or 1
		for j=1,numColumns do
			local column = row.Columns[j]
			if not column then
				column = row:CreateFontString(nil,"ARTWORK","GameFontNormal")
				if j==1 then -- first colum anchors to the left of its parent row
					column:SetPoint("LEFT")
				else -- rest of coumns anchor to the previous column
					column:SetPoint("LEFT",row.Columns[j-1],"RIGHT",6,0)
				end
				row.Columns[j] = column
			end
			column:SetHeight(height)
			column:SetText((numColumns>1 and data[i][j] or data[i]) or "")
			column:SetJustifyH((layout and layout.justifyH) and layout.justifyH[j] or "LEFT")
			-- if colors layout used for this column, use it
			if layout and layout.colors and layout.colors[j] then
				column:SetTextColor(layout.colors[j][1],layout.colors[j][2],layout.colors[j][3])
			elseif i==1 then -- otherwise if firts row, make text white
				column:SetTextColor(1,1,1)
			else -- otherwise gold normal color
				column:SetTextColor(1,.82,0)
			end
			column:Show()
		end
		maxColumns = max(numColumns,maxColumns)
		row.numColumns = numColumns
		row:SetHeight(height)
		row:SetWidth(100)
		row:Show()
	end

	-- resize columns for multi-column rows
	for j=1,maxColumns do
		local maxWidth = 0
		-- first pass, figure out the max width of a column among all rows
		for i=1,#data do
			local numColumns = tooltip.Rows[i].numColumns
			if j<=numColumns and numColumns>1 then -- only dealing with multi-column rows here
				maxWidth = max(maxWidth,tooltip.Rows[i].Columns[j]:GetStringWidth())
			end
		end
		-- second pass, set width of a colum in each row to the maxWidth
		for i=1,#data do
			local numColumns = tooltip.Rows[i].numColumns
			if j<=numColumns and numColumns>1 then
				tooltip.Rows[i].Columns[j]:SetWidth(maxWidth)
			end
		end
	end

	-- now find the max width for the whole tooltip
	local maxWidth = 0
	for i=1,#data do
		local numColumns = tooltip.Rows[i].numColumns
		local width = 0
		for j=1,numColumns do
			if numColumns==1 then
				width = width + tooltip.Rows[i].Columns[1]:GetStringWidth()
			else
				width = width + tooltip.Rows[i].Columns[j]:GetWidth()
			end
			if j>1 then
				width = width + 6
			end
		end
		maxWidth = max(maxWidth,width)
	end

	tooltip:SetSize(maxWidth+18,#data*height+16)

	tooltip:Show()
	rematch:SmartAnchor(tooltip,anchorTo)
end
