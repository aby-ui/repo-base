-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print
	

	
local IconDragger = TMW:NewModule("IconDragger", "AceTimer-3.0", "AceEvent-3.0")
TMW.IconDragger = IconDragger



function IconDragger:OnInitialize()
	WorldFrame:HookScript("OnMouseDown", function() -- this contains other bug fix stuff too
		IconDragger.DraggerFrame:Hide()
		IconDragger.IsDragging = nil
	end)
end


---------- Icon Dragging ----------
function IconDragger:DropDownFunc()
	local lastAddedCentury = 1
	local hasAddedOne = false

	for i, handlerData in ipairs(IconDragger.Handlers) do
		local info = TMW.DD:CreateInfo()

		info.notCheckable = true
		
		local shouldAddButton = handlerData.dropdownFunc(IconDragger, info)
		
		info.func = IconDragger.Handler
		info.arg1 = handlerData.actionFunc

		if shouldAddButton then
			-- Spacers are placed between each increment of 100 in the order.
			local thisCentury = floor(handlerData.order/100) + 1

			if hasAddedOne and lastAddedCentury < thisCentury then
				TMW.DD:AddSpacer()
			end

			TMW.DD:AddButton(info)

			lastAddedCentury = thisCentury
			hasAddedOne = true
		end


	end	

	if hasAddedOne then
		TMW.DD:AddSpacer()
	end
	
	local info = TMW.DD:CreateInfo()
	info.text = CANCEL
	info.notCheckable = true
	TMW.DD:AddButton(info)
end

IconDragger.Dropdown = TMW.C.Config_DropDownMenu_NoFrame:New()
IconDragger.Dropdown:SetFunction(IconDragger.DropDownFunc)
local Dropdown = IconDragger.Dropdown

function IconDragger:Start(icon)
	IconDragger.srcicon = icon

	IconDragger.DraggerFrame:SetScale(icon.group:GetEffectiveScale())

	local tex = IconDragger.srcicon.attributes.texture
	if tex == "" or not tex then
		tex = "Interface\\AddOns\\TellMeWhen\\Textures\\Disabled"
	end
	IconDragger.DraggerFrame.texture:SetTexture(tex)
	
	IconDragger.DraggerFrame:Show()
	IconDragger.IsDragging = true
end

function IconDragger:SetIsDraggingFalse()
	IconDragger.IsDragging = false
end

function IconDragger:CompleteDrag(script, icon)
	IconDragger.DraggerFrame:Hide()
	IconDragger:ScheduleTimer("SetIsDraggingFalse", 0.1)

	-- icon is the destination
	icon = icon or GetMouseFocus()

	if IconDragger.IsDragging then

		if type(icon) == "table" and icon.IsIcon and not icon:IsControlled() then -- if the frame that got the drag is an icon, set the destination stuff.

			IconDragger.desticon = icon
			IconDragger.destFrame = nil

			if script == "OnDragStop" then -- wait for OnDragReceived
				return
			end

			if IconDragger.desticon == IconDragger.srcicon then
				return
			end

			Dropdown:SetDropdownAnchor("TOPLEFT", icon, "BOTTOMLEFT", 0, 0)

		else
			IconDragger.desticon = nil
			IconDragger.destFrame = icon -- not actually an icon. just some frame.
			local cursorX, cursorY = GetCursorPosition()
			local UIScale = UIParent:GetScale()
			-- We offset the position here by 1 so that the frame is always under the cursor.
			-- Otherwise, it might not be under the cursor, causing the dropdown to never auto-hide if the user
			-- never drags their cursor over it.
			Dropdown:SetDropdownAnchor(nil, UIParent, "BOTTOMLEFT", cursorX/UIScale - 1, cursorY/UIScale + 1)
		end

		if not DropDownList1:IsShown() or TMW.DD.OPEN_MENU ~= Dropdown then
			Dropdown:Toggle(1)
		end
	end
end

function IconDragger:NoGlobalToProfile(invert)
	local srcicon = IconDragger.srcicon
	local desticon = IconDragger.desticon

	if not (srcicon and desticon) then
		return nil
	end

	if srcicon.group.Domain == "global" and desticon.group.Domain == "profile" then
		return invert
	end

	return true
end

function IconDragger:NoProfileToGlobal(invert)
	local srcicon = IconDragger.srcicon
	local desticon = IconDragger.desticon

	if not (srcicon and desticon) then
		return nil
	end

	if srcicon.group.Domain == "profile" and desticon.group.Domain == "global" then
		return invert
	end

	return true
end


IconDragger.Handlers = {}
function IconDragger:RegisterIconDragHandler(order, dropdownFunc, actionFunc)
	TMW:ValidateType("2 (order)", "IconDragger:RegisterIconDragHandler(order, dropdownFunc, actionFunc)", order, "number")
	TMW:ValidateType("3 (func)", "IconDragger:RegisterIconDragHandler(order, dropdownFunc, actionFunc)", dropdownFunc, "function")
	TMW:ValidateType("4 (func)", "IconDragger:RegisterIconDragHandler(order, dropdownFunc, actionFunc)", actionFunc, "function")
	
	tinsert(IconDragger.Handlers, {
		order = order,
		dropdownFunc = dropdownFunc,
		actionFunc = actionFunc,
	})
	
	TMW:SortOrderedTables(IconDragger.Handlers)
end

IconDragger:RegisterIconDragHandler(1,	-- Move
	function(IconDragger, info)
		if IconDragger.desticon then
			info.text = L["ICONMENU_MOVEHERE"]
			info.tooltipTitle = nil
			info.tooltipText = nil
			return true
		end
	end,
	function(IconDragger)
		-- move the actual settings
		local srcgs = IconDragger.srcicon.group:GetSettings()
		local srcics = IconDragger.srcicon:GetSettings()
		
		TMW:PrepareIconSettingsForCopying(srcics, srcgs)
		
		IconDragger.desticon.group:GetSettings().Icons[IconDragger.desticon:GetID()] = srcgs.Icons[IconDragger.srcicon:GetID()]
		srcgs.Icons[IconDragger.srcicon:GetID()] = nil
		
		-- preserve buff/debuff/other types textures
		IconDragger.desticon:SetInfo("texture", IconDragger.srcicon.attributes.texture)
	end
)
IconDragger:RegisterIconDragHandler(2,	-- Copy
	function(IconDragger, info)
		if IconDragger.desticon then
			info.text = L["ICONMENU_COPYHERE"]
			info.tooltipTitle = nil
			info.tooltipText = nil
			return true
		end
	end,
	function(IconDragger)
		-- copy the settings
		local srcgs = IconDragger.srcicon.group:GetSettings()
		local srcics = IconDragger.srcicon:GetSettings()
		TMW:PrepareIconSettingsForCopying(srcics, srcgs)
		
		IconDragger.desticon.group:GetSettings().Icons[IconDragger.desticon:GetID()] = TMW:CopyWithMetatable(srcics)

		-- Erase the GUID from the new icon.
		IconDragger.desticon:GetSettings().GUID = nil

		-- preserve buff/debuff/other types textures
		IconDragger.desticon:SetInfo("texture", IconDragger.srcicon.attributes.texture)
	end
)
IconDragger:RegisterIconDragHandler(3,	-- Swap
	function(IconDragger, info)
		if IconDragger.desticon then
			info.text = L["ICONMENU_SWAPWITH"]
			info.tooltipTitle = nil
			info.tooltipText = nil
			return true
		end
	end,
	function(IconDragger)
		-- swap the actual settings
		local destgs = IconDragger.desticon.group:GetSettings()
		local destics = IconDragger.desticon:GetSettings()
		local srcgs = IconDragger.srcicon.group:GetSettings()
		local srcics = IconDragger.srcicon:GetSettings()
		TMW:PrepareIconSettingsForCopying(destics, destgs)
		TMW:PrepareIconSettingsForCopying(srcics, srcgs)
		
		destgs.Icons[IconDragger.desticon:GetID()] = srcics
		srcgs.Icons[IconDragger.srcicon:GetID()] = destics

		-- preserve buff/debuff/other types textures
		local desttex = IconDragger.desticon.attributes.texture
		IconDragger.desticon:SetInfo("texture", IconDragger.srcicon.attributes.texture)
		IconDragger.srcicon:SetInfo("texture", desttex)
	end
)
IconDragger:RegisterIconDragHandler(4,	-- Insert
	function(IconDragger, info)
		if IconDragger.desticon then
			info.text = L["ICONMENU_INSERTHERE"]
			info.tooltipTitle = L["ICONMENU_INSERTHERE"]
			info.tooltipText = L["ICONMENU_INSERTHERE_DESC"]:format(
				IconDragger.srcicon:GetFullName(), 
				IconDragger.desticon:GetFullName()
			)
			return true
		end
	end,
	function(IconDragger)
		-- move the actual settings
		local srcgs = IconDragger.srcicon.group:GetSettings()
		local srcics = IconDragger.srcicon:GetSettings()
		
		TMW:PrepareIconSettingsForCopying(srcics, srcgs)
		
		local targetId = IconDragger.desticon:GetID()
		local ics = tremove(srcgs.Icons, IconDragger.srcicon:GetID())
		tinsert(IconDragger.desticon.group:GetSettings().Icons, targetId, ics)
		
		-- preserve buff/debuff/other types textures
		IconDragger.desticon:SetInfo("texture", IconDragger.srcicon.attributes.texture)
	end
)

local function Split(IconDragger, domain)
	if InCombatLockdown() then
		-- Groups can't be added in combat
		error("TMW: Can't create groups while in combat")
	end

	local group = TMW:Group_Add(domain)

	-- back up the icon data of the source group
	local SOURCE_ICONS = IconDragger.srcicon.group:GetSettings().Icons


	-- copy the source group.
	-- pcall so that, in the rare event of some unforseen error, we don't lose the user's settings (they haven't yet been restored)
	local success, err = pcall(function()
		-- nullify it (we don't want to copy it)
		IconDragger.srcicon.group:GetSettings().Icons = nil
	
		TMW:CopyTableInPlaceUsingDestinationMeta(IconDragger.srcicon.group:GetSettings(), group:GetSettings())
	end)

	-- restore the icon data of the source group
	IconDragger.srcicon.group:GetSettings().Icons = SOURCE_ICONS
	
	-- now it is safe to error since we restored the old settings
	assert(success, err)


	local gs = group:GetSettings()

	-- Generate a new GUID for the new group.
	gs.GUID = nil
	group:GetGUID()

	-- group tweaks
	gs.Rows = 1
	gs.Columns = 1
	gs.Name = ""
	gs.Alpha = 1

	-- adjustments and positioning
	local p = gs.Point
	p.point, p.relativeTo, p.relativePoint, p.x, p.y = IconDragger.DraggerFrame.texture:GetPoint(1)
	
	p.relativeTo = "UIParent"
	
	--group:Setup()

	-- move the actual icon settings
	gs.Icons[1] = IconDragger.srcicon.group.Icons[IconDragger.srcicon:GetID()]
	IconDragger.srcicon.group.Icons[IconDragger.srcicon:GetID()] = nil

	-- preserve textures
	if group and group[1] then
		group[1]:SetInfo("texture", IconDragger.srcicon.attributes.texture)
	end

	group:Setup()
end


IconDragger:RegisterIconDragHandler(40,	-- Split to profile
	function(IconDragger, info)
		if IconDragger.destFrame then
			info.text = L["ICONMENU_SPLIT"]
			info.tooltipTitle = L["ICONMENU_SPLIT"]
			info.tooltipText = L["ICONMENU_SPLIT_DESC"]

			if InCombatLockdown() then
				info.tooltipWhileDisabled = true
				info.tooltipText = L["ICONMENU_SPLIT_NOCOMBAT_DESC"]
				info.disabled = true
			end

			return true
		end
	end,
	function(IconDragger)
		Split(IconDragger, "profile")
	end
)
IconDragger:RegisterIconDragHandler(41,	-- Split to global
	function(IconDragger, info)
		if IconDragger.destFrame then
			info.text = L["ICONMENU_SPLIT_GLOBAL"]
			info.tooltipTitle = L["ICONMENU_SPLIT_GLOBAL"]
			info.tooltipText = L["ICONMENU_SPLIT_DESC"] .. "\r\n\r\n" .. L["GLOBAL_GROUP_GENERIC_DESC"]

			if InCombatLockdown() then
				info.tooltipWhileDisabled = true
				info.tooltipText = L["ICONMENU_SPLIT_NOCOMBAT_DESC"]
				info.disabled = true
			end

			return true
		end
	end,
	function(IconDragger)
		Split(IconDragger, "global")
	end
)

---------- Icon Handler ----------
function IconDragger:Handler(method)
	-- close the menu
	TMW.DD:CloseDropDownMenus()

	-- save misc. settings
	TMW.IE:SaveSettings()

	-- attempt to create a backup before doing anything
	IconDragger.srcicon:SaveBackup()
	if IconDragger.desticon then
		IconDragger.desticon:SaveBackup()
	end

	-- finally, invoke the method to handle the operation.
	method(IconDragger)

	-- then, update things
	TMW:Update()
	TMW.IE:LoadIcon(1)
end

