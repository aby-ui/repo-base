--[[-
LibExtraTip

LibExtraTip is a library of API functions for manipulating additional information into GameTooltips by either adding information to the bottom of existing tooltips (embedded mode) or by adding information to an extra "attached" tooltip construct which is placed to the bottom of the existing tooltip.

Copyright (C) 2008-2019, by the respective below authors.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

@author Matt Richard (Tem)
@author Ken Allan <ken@norganna.org>
@author brykrys
@libname LibExtraTip
@version 1.(see below)
--]]

local LIBNAME = "LibExtraTip"
local VERSION_MAJOR = 1
local VERSION_MINOR = 347
-- Minor Version cannot be a SVN Revison in case this library is used in multiple repositories
-- Should be updated manually with each (non-trivial) change

-- A string unique to this version to prevent frame name conflicts.
local LIBSTRING = LIBNAME.."_"..VERSION_MAJOR.."_"..VERSION_MINOR
local lib = LibStub:NewLibrary(LIBNAME.."-"..VERSION_MAJOR, VERSION_MINOR)
if not lib then return end

LibStub("LibRevision"):Set("$URL$","$Rev$","5.15.DEV.", 'auctioneer', 'libs')

-- need to know early if we're using Classic or Modern version
local MINIMUM_CLASSIC = 11300
local MAXIMUM_CLASSIC = 19999
-- version, build, date, tocversion = GetBuildInfo()
local _,_,_,tocVersion = GetBuildInfo()
lib.Classic = (tocVersion > MINIMUM_CLASSIC and tocVersion < MAXIMUM_CLASSIC)


-- Call function to deactivate any outdated version of the library.
-- (calls the OLD version of this function, NOT the one defined in this
-- file's scope)
if lib.Deactivate then lib:Deactivate() end

-- Forward definition of a few locals that get defined at the bottom of
-- the file.
local tooltipMethodPrehooks
local tooltipMethodPosthooks
local ExtraTipClass

--[[ The following events are enabled by default unless disabled in the
	callback options "enabled" table all other events are default disabled.
	Note that this only applies to events that will lead to calling ProcessCallbacks,
	currently any method that fires OnTooltipSetItem, OnTooltipSetSpell or
	OnTooltipSetUnit
--]]
local defaultEnable = {
	SetAuctionItem = true,
	SetAuctionSellItem = true,
	SetBagItem = true,
	SetBuybackItem = true,
	SetGuildBankItem = true,
	SetInboxItem = true,
	SetInventoryItem = true,
	SetLootItem = true,
	SetLootRollItem = true,
	SetMerchantItem = true,
	SetQuestItem = true,
	SetQuestLogItem = true,
	SetSendMailItem = true,
	SetTradePlayerItem = true,
	SetTradeTargetItem = true,
	SetRecipeReagentItem = true,
	SetRecipeResultItem = true,
    SetTradeSkillItem = true,
    SetCraftItem = true,
	SetHyperlink = true,
	SetHyperlinkAndCount = true, -- Creating a tooltip via lib:SetHyperlinkAndCount()
	SetBattlePet = true,
	SetBattlePetAndCount = true,
}

--[[ The following callback types are always enabled regardless of the event ]]
local alwaysEnable = {
	extrashow = true,
	extrahide = true,
}

-- Money Icon setup
local iconpath = "Interface\\MoneyFrame\\UI-"
local goldicon = "%.0f|T"..iconpath.."GoldIcon:0|t"
local silvericon = "%s|T"..iconpath.."SilverIcon:0|t"
local coppericon = "%s|T"..iconpath.."CopperIcon:0|t"

-- Other constants
local MATHHUGE = math.huge

-- Function that calls all the interested tooltips
local function ProcessCallbacks(reg, tiptype, tooltip, ...)
	if not reg then return end

	local event = reg.additional.event or "Unknown"
	local default = defaultEnable[event]

	if lib.sortedCallbacks and #lib.sortedCallbacks > 0 then
		for i,options in ipairs(lib.sortedCallbacks) do
			if options.type == tiptype then
				local enable = default
				if options.allevents or alwaysEnable[tiptype] then
					enable = true
				elseif options.enable and options.enable[event] ~= nil then
					enable = options.enable[event]
				end
				if enable then
					options.callback(tooltip, ...)
				end
			end
		end
	end
end

-- Function that gets run when an item is set on a registered tooltip.
local function OnTooltipSetItem(tooltip)
	local self = lib
    -- DebugPrintQuick("OnTooltipSetItem called" ) -- DEBUGGING
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if self.sortedCallbacks and #self.sortedCallbacks > 0 then
		tooltip:Show()

		local testname, item = tooltip:GetItem()
        --DebugPrintQuick("OnTooltipSetItem GetItem", testname, item ) -- DEBUGGING -- enchanting window always returns nil
		if not item then
			item = reg.item or reg.additional.link
		elseif testname == "" then
			-- Blizzard broke tooltip:GetItem() in 6.2. Detect and fix the bug if possible. Remove workaround when fixed by Blizzard. [LTT-56]
			-- thanks to sapu for identifying bug and suggesting workaround
			-- Broken differently in 7.0 because 0 is not printed in itemstrings, and it would find the player level as the first number [LTT-59]
			local checkItemID = strmatch(item, "item:(%d*):") -- this match string should find the itemID in any link
			--DebugPrintQuick("failed name check ", checkItemID, testname, item, item:gsub(".*item:", ""), reg.item, reg.additional.link )
			if not checkItemID or checkItemID == "" then -- it's usually "" for recipes
				item = reg.item or reg.additional.link -- try to find a valid link from another source (or set to nil if we can't find one)
			end
		end

		if item and not reg.hasItem then
            -- DebugPrintQuick("OnTooltipSetItem has item" ) -- DEBUGGING
			local name,link,quality,ilvl,minlvl,itype,isubtype,stack,equiploc,texture = GetItemInfo(item)
			if link then
				name = name or "unknown" -- WotLK bug
				reg.hasItem = true
				local extraTip = self:GetFreeExtraTipObject()
				reg.extraTip = extraTip
				extraTip:Attach(tooltip)
				local r,g,b = GetItemQualityColor(quality)
				extraTip:AddLine(name,r,g,b)

				local quantity = reg.quantity or 1

				reg.additional.item = item
				reg.additional.quantity = quantity
				reg.additional.name = name
				reg.additional.link = link
				reg.additional.quality = quality
				reg.additional.itemLevel = ilvl
				reg.additional.minLevel = minlvl
				reg.additional.itemType = itype
				reg.additional.itemSubtype = isubtype
				reg.additional.stackSize = stack
				reg.additional.equipLocation = equiploc
				reg.additional.texture = texture

                --DebugPrintQuick("OnTooltipSetItem callback called" ) -- DEBUGGING
				ProcessCallbacks(reg, "item", tooltip, item,quantity,name,link,quality,ilvl,minlvl,itype,isubtype,stack,equiploc,texture)
				tooltip:Show()
				if reg.extraTipUsed then
					extraTip:Show()
					ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
				end
			end
		end
	end
end

-- Function that gets run when a spell is set on a registered tooltip.
local function OnTooltipSetSpell(tooltip)
    --DebugPrintQuick("OnTooltipSetSpell called" ) -- DEBUGGING
	local self = lib
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if self.sortedCallbacks and #self.sortedCallbacks > 0 then
		tooltip:Show()
		local name, spellID = tooltip:GetSpell()
		local link = reg.additional.link

		if name and not reg.hasItem then
			reg.hasItem = true
			local extraTip = self:GetFreeExtraTipObject()
			reg.extraTip = extraTip
			extraTip:Attach(tooltip)
			extraTip:AddLine(name, 1,0.8,0)

			reg.additional.name = name
			reg.additional.category = category
			reg.additional.spellID = spellID

			ProcessCallbacks(reg, "spell", tooltip, link, name, category, spellID)
			tooltip:Show()
			if reg.extraTipUsed then
				extraTip:Show()
				ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
			end
		end
	end
end

-- Function that gets run when a unit is set on a registered tooltip.
local function OnTooltipSetUnit(tooltip)
	local self = lib
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if self.sortedCallbacks and #self.sortedCallbacks > 0 then
		tooltip:Show()
		local name, unitId = tooltip:GetUnit()

		if name and not reg.hasItem then
			reg.hasItem = true
			local extraTip = self:GetFreeExtraTipObject()
			reg.extraTip = extraTip
			extraTip:Attach(tooltip)
			extraTip:AddLine(name, 0.8,0.8,0.8)

			ProcessCallbacks(reg, "unit", tooltip, name, unitId)
			tooltip:Show()
			if reg.extraTipUsed then
				extraTip:Show()
				ProcessCallbacks(reg, "extrashow", tooltip, extraTip)
			end
		end
	end
end

-- Function that gets run when a registered tooltip's item is cleared.
local function OnTooltipCleared(tooltip)
    --DebugPrintQuick("OnTooltipCleared called ")   -- DEBUGGING
	local reg = lib.tooltipRegistry[tooltip]
	if not reg then return end

	if reg.ignoreOnCleared then return end
	tooltip:SetFrameLevel(1)

	reg.extraTipUsed = nil
	reg.quantity = nil
	reg.hasItem = nil
	reg.item = nil
	wipe(reg.additional)
	local extraTip = reg.extraTip
	if extraTip then
		reg.extraTip = nil
		extraTip:Release()
		extraTip:ClearLines()
		extraTip:SetHeight(0)
		extraTip:SetWidth(0)
		extraTip:Hide()
		ProcessCallbacks(reg, "extrahide", tooltip, extraTip)
		tinsert(lib.extraTippool, extraTip)
	end
end

-- Run when a BattlePet is loaded into a BettlePetTooltip
-- Requires special handling as BattlePetTooltips aren't real tooltips and lack most of the scripts and methods we normally use
-- Hooked directly from BattlePetTooltipTemplate_SetBattlePet
local function OnTooltipSetBattlePet(tooltip, data)
	local reg = lib.tooltipRegistry[tooltip]
	if not reg then return end

	-- OnTooltipCleared is normally called via OnHide for BattlePets
	-- clean up here in case a new BattlePet is loaded into a visible tooltip, in which case OnHide would not have been triggered
	if reg.hasItem then
		OnTooltipCleared(tooltip)
	end
	if lib.sortedCallbacks and #lib.sortedCallbacks > 0 then
		-- extract values from data
		local speciesID = data.speciesID
		local level = data.level
		local breedQuality = data.breedQuality
		local maxHealth = data.maxHealth
		local power = data.power
		local speed = data.speed
		local battlePetID = data.battlePetID or "0x0000000000000000"
		local name = data.name
		local customName = data.customName
		local petType = data.petType
		local colcode, r, g, b
		if breedQuality == -1 then
			colcode = NORMAL_FONT_COLOR_CODE
			r, g, b = NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
		else
			local coltable = ITEM_QUALITY_COLORS[breedQuality] or ITEM_QUALITY_COLORS[0]
			colcode = coltable.hex
			r, g, b = coltable.r, coltable.g, coltable.b
		end

		-- for certain events there may already be info stored in reg - e.g. SetBattlePetAndCount
		local quantity = reg.quantity or 1
		local link = reg.item
		if not link then
			-- it's a bit of a pain that we need to reconstruct a link here, just so it can be chopped up again...
			link = format("%s|Hbattlepet:%d:%d:%d:%d:%d:%d:%s|h[%s]|h|r", colcode, speciesID, level, breedQuality, maxHealth, power, speed, battlePetID, customName or name)
		end

		reg.hasItem = true
		local extraTip = lib:GetFreeExtraTipObject()
		reg.extraTip = extraTip
		extraTip:Attach(tooltip)
		extraTip:AddLine(name, r, g, b)

		reg.additional.name = name
		reg.additional.link = link
		reg.additional.speciesID = speciesID
		reg.additional.quality = breedQuality
		reg.additional.quantity = quantity
		reg.additional.level = level
		reg.additional.customName = customName -- nil if no custom name
		reg.additional.petType = petType
		reg.additional.maxHealth = maxHealth
		reg.additional.power = power
		reg.additional.speed = speed
		reg.additional.battlePetID = battlePetID -- if not 0 it's a pet in your journal

		reg.additional.event = reg.additional.event or "SetBattlePet"

		ProcessCallbacks(reg, "battlepet", tooltip, link, quantity, name, speciesID, breedQuality, level)
		if reg.extraTipUsed then
			reg.extraTip:Show()
			ProcessCallbacks(reg, "extrashow", tooltip, reg.extraTip)
		end
	end
end

-- Function that gets run when a registered tooltip's size changes.
local function OnSizeChanged(tooltip,w,h)
	local reg = lib.tooltipRegistry[tooltip]
	if not reg then return end

	local extraTip = reg.extraTip
	if extraTip then
		extraTip:MatchSize()
	end
end

local function ShowCalled(tooltip)
	local reg = lib.tooltipRegistry[tooltip]
	if not reg then return end

	local extraTip = reg.extraTip
	if extraTip then
		extraTip:MatchSize()
	end
end

function lib:GetFreeExtraTipObject()
	if not self.extraTippool then self.extraTippool = {} end
	return tremove(self.extraTippool) or ExtraTipClass:new()
end

--[[ hookStore:
	@since version 1.1
	(see below for hookStore version)
	stores control information for method and script hooks on tooltips
	lib.hookStore[tooltip][method] = <control>
	<control> = {prehook, posthook}
	<control> is an upvalue to our installed hookstub: insert new values to change the hook, or wipe it to deactivate

	if we are updating, keep the old hookStore table IF it has the right version, so that we can reuse the hook stubs
--]]
local HOOKSTORE_VERSION = "C"
if not lib.hookStore or lib.hookStore.version ~= HOOKSTORE_VERSION then
	lib.hookStore = {version = HOOKSTORE_VERSION}
end

-- Called to install/modify a pre-/post-hook on the given tooltip's method
local function hookmethod(tip, method, prehook, posthook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local control
	-- check for existing hook
	control = lib.hookStore[tip][method]
	if control then
		control[1] = prehook or control[1] or false --(avoid nil values by substituting false instead)
		control[2] = posthook or control[2] or false
		return
	end
	-- prepare upvalues
	local orig = tip[method]
	if not orig then
		-- There should be an original method - abort if it's missing
		if nLog then
			nLog.AddMessage("LibExtraTip", "Hooks", N_NOTICE, "Missing method", "LibExtraTip:hookmethod detected missing method: "..tostring(method))
		end
		return
	end
	control = {prehook or false, posthook or false}
	lib.hookStore[tip][method] = control
	-- install hook stub
	local stub = function(...)
		local hook
		-- prehook
		hook = control[1]
		if hook then hook(...) end
		-- original hook
		local a,b,c,d,e,f,g,h,i,j,k = orig(...)
		-- posthook
		hook = control[2]
		if hook then hook(...) end
		-- return values from original
		return a,b,c,d,e,f,g,h,i,j,k
	end
	tip[method] = stub
	--[[
	Note: neither the stub hook nor the original function should be called directly after our hook is installed,
	because the behaviour of any other third-party hooks to the same method would then be undefined
	(i.e. they might get called or they might not...)
	--]]
end

-- Called to install/modify a secure post-hook on the given tooltip's method (pre-hooks cannot be applied securely)
local function hooksecure(tip, method, posthook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	-- check for existing hook
	local methodkey = "#"..method -- use modified key to avoid conflict with old hook stubs
	local control = lib.hookStore[tip][methodkey]
	if control then
		control[1] = posthook or control[1]
		return
	end
	if not tip[method] then
		-- There should be an original method - abort if it's missing
		if nLog then
			nLog.AddMessage("LibExtraTip", "Hooks", N_NOTICE, "Missing method", "LibExtraTip:hooksecure detected missing method: "..tostring(method))
		end
		return
	end
	control = {posthook}
	lib.hookStore[tip][methodkey] = control
	-- install hook stub
	local stub = function(...)
		local hook = control[1]
		if hook then hook(...) end
	end
	hooksecurefunc(tip, method, stub)
	-- Using control table protects against multiple hooking and allows us to change or disable the hook
end


-- Called to deactivate our stub hook for the given tooltip's method
-- The stub is left in place: we assume we are undergoing a version upgrade, and that the stubs will be reused
--[[ not used in this version (left in place in case needed for future changes)
local function unhook(tip,method)
	wipe(lib.hookStore[tip][method])
end
--]]

-- Called to install/modify a pre-hook on the given tooltip's event
-- Currently we do not need any posthooks on scripts
local function hookscript(tip, script, prehook)
	if not lib.hookStore[tip] then lib.hookStore[tip] = {} end
	local control
	-- check for existing hook
	control = lib.hookStore[tip][script]
	if control then
		control[1] = prehook or control[1]
		return
	end
	-- prepare upvalues
	local orig = tip:GetScript(script)
	control = {prehook}
	lib.hookStore[tip][script] = control
	-- install hook stub
	local stub = function(...)
		local h
		-- prehook
		h = control[1]
		if h then h(...) end
		-- original hook
		if orig then orig(...) end
	end
	tip:SetScript(script, stub)
end

-- Called to deactivate all our pre-hooks on the given tooltip's event
--local function unhookscript(tip,script)
-- not used in this version

-- Called to install a post hook on a global function
-- func must be the name of a global function
local function hookglobal(func, posthook)
	if not lib.hookStore.global then lib.hookStore.global = {} end
	local control = lib.hookStore.global[func]
	if control then
		control[1] = posthook or control[1]
		return
	end
	control = {posthook}
	local orig = _G[func]
	if type(orig) ~= "function" then
		if nLog then
			nLog.AddMessage("LibExtraTip", "Hooks", N_WARNING, "Global hook - not a function", "LibExtraTip:hookglobal attempted to hook "..tostring(func).." which is not a global function name")
		end
		return
	end
	local stub = function(...)
		local hook = control[1]
		if hook then hook(...) end
	end
	-- As we only need post-hooks we can use hooksecurefunc
	-- Using control table protects against multiple hooking and allows us to change or disable the hook
	hooksecurefunc(func, stub)
end


--[[-
	Adds the provided tooltip to the list of tooltips to monitor for items.
	@param tooltip GameTooltip object
	@return true if tooltip is registered
	@since 1.0
]]
function lib:RegisterTooltip(tooltip)
	local specialTooltip
	if not tooltip or type(tooltip) ~= "table" or type(tooltip.GetObjectType) ~= "function" then return end
	if tooltip:GetObjectType() ~= "GameTooltip" then
		if tooltip:GetObjectType() == "Frame" then
			-- is it a BattlePetTooltip? check for some of the entries from BattlePetTooltipTemplate
			if tooltip.BattlePet and tooltip.PetType and tooltip.PetTypeTexture then
				specialTooltip = "battlepet"
			else
				return
			end
		else
			return
		end
	end

	if not self.tooltipRegistry then
		self.tooltipRegistry = {}
		self:GenerateTooltipMethodTable()
	end

	if not self.tooltipRegistry[tooltip] then
		local reg = {}
		self.tooltipRegistry[tooltip] = reg
		reg.additional = {}

		if specialTooltip == "battlepet" then
			reg.NoColumns = true -- This is not a GameTooltip so it has no Text columns. Cannot support certain functions such as embedding
			hookscript(tooltip,"OnHide",OnTooltipCleared)
			hookscript(tooltip,"OnSizeChanged",OnSizeChanged)
			hookglobal("BattlePetTooltipTemplate_SetBattlePet", OnTooltipSetBattlePet) -- yes we hook the same function every time - hookglobal protects against multiple hooks
		else
			hookscript(tooltip,"OnTooltipSetItem",OnTooltipSetItem)
			hookscript(tooltip,"OnTooltipSetUnit",OnTooltipSetUnit)
			hookscript(tooltip,"OnTooltipSetSpell",OnTooltipSetSpell)
			hookscript(tooltip,"OnTooltipCleared",OnTooltipCleared)
			hookscript(tooltip,"OnSizeChanged",OnSizeChanged)
			hooksecure(tooltip, "Show", ShowCalled)

			for k,v in pairs(tooltipMethodPrehooks) do
				hookmethod(tooltip,k,v)
			end
			for k,v in pairs(tooltipMethodPosthooks) do
				hookmethod(tooltip,k,nil,v)
			end
		end
		return true
	end
end

--[[-
	Checks to see if the tooltip has been registered with LibExtraTip
	@param tooltip GameTooltip object
	@return true if tooltip is registered
	@since 1.0
]]
function lib:IsRegistered(tooltip)
	if not self.tooltipRegistry or not self.tooltipRegistry[tooltip] then
		return
	end
	return true
end

--[[-
	Returns a reference to the extra tip currently attached to the specified tooltip (if any)
	Intended for tooltip styling AddOns - should only be used to alter cosmetic elements of the tooltip
	(Use caution when modifying Text line fonts, as LibExtraTip also modifies the fonts)
	@param tooltip as registered tooltip
	@return extratip if any attached to tooltip (may be hidden and/or empty)
	@since 1.324
]]
function lib:GetExtraTip(tooltip)
	if not self.tooltipRegistry then return end
	local reg = self.tooltipRegistry[tooltip]
	if reg then
		return reg.extraTip
	end
end


--[[-
	Adds a callback to be informed of any registered tooltip's activity.
	The parameters passed to callbacks vary depending on the type of callback
	@param options a table containing entries defining the required callback
		type (string, required) the callback type, e.g. "item", "spell", and others
		callback (function, required) the function to be called back when the appropriate event occurs
		enable (table, optional) a table containing <event>=<boolean> pairs, specifying which events to respond to
			callbacks are usually only generated for events enabled either by this table, or by the defaultEnable table
		allevents (boolean, optional) if true always triggers a callback regardless of the event, overrides defaultEnable and options.event table
	@param priority the priority of the callback (optional, default 200)
	@since 1.0
]]
local sortFunc
function lib:AddCallback(options,priority)
-- Lower priority gets called before higher priority.  Default is 200.
	if not options then return end
	local otype = type(options)
	if otype == "function" then
		options = {type = "item", callback = options}
	elseif otype == "table" then
		-- check required keys
		if type(options.type) ~= "string" or type(options.callback) ~= "function" then
			return
		end
		-- copy into a new table for our internal use
		local copyoptions = {type = options.type, callback = options.callback}
		if options.allevents == true then
			copyoptions.allevents = true
		elseif type(options.enable) == "table" then
			copyoptions.enable = options.enable
		end

		options = copyoptions
	else
		return
	end

	if not sortFunc then
		local callbacks = self.callbacks
		if not callbacks then
			callbacks = {}
			self.callbacks = callbacks
			self.sortedCallbacks = {}
		end
		sortFunc = function(a,b)
			return callbacks[a] < callbacks[b]
		end
	end

	self.callbacks[options] = priority or 200
	tinsert(self.sortedCallbacks,options)
	sort(self.sortedCallbacks,sortFunc)
end

--[[-
	Removes the given callback from the list of callbacks.
	@param callback the callback to remove from notifications
	@return true if successfully removed
	@since 1.0
]]
function lib:RemoveCallback(callback)
	if not (callback and self.callbacks) then return end
	if not self.callbacks[callback] then
		-- backward compatibility for old 'function' style AddCallback and RemoveCallback
		for options, priority in pairs(self.callbacks) do
			if options.callback == callback then
				callback = options
				break
			end
		end
		if not self.callbacks[callback] then return end
	end
	self.callbacks[callback] = nil
	for index,options in ipairs(self.sortedCallbacks) do
		if options == callback then
			tremove(self.sortedCallbacks, index)
			return true
		end
	end
end

--[[-
	Sets the default embed mode of the library (default false)
	A false embedMode causes AddLine, AddDoubleLine and AddMoneyLine to add lines to the attached tooltip rather than embed added lines directly in the item tooltip.
	This setting only takes effect when embed mode is not specified on individual AddLine, AddDoubleLine and AddMoneyLine commands.
	@param flag boolean flag if true embeds by default
	@since 1.0
]]
function lib:SetEmbedMode(flag)
	self.embedMode = flag and true or false
end

--[[-
	Adds a line to a registered tooltip.
	@param tooltip GameTooltip object
	@param text the contents of the tooltip line
	@param r (0-1) red component of the tooltip line color (optional)
	@param g (0-1) green component of the tooltip line color (optional)
	@param b (0-1) blue component of the tooltip line color(optional)
	@param embed (boolean) override the lib's embedMode setting (optional)
	@param wrap (boolean) specify line-wrapping for long lines (optional)
	@see SetEmbedMode
	@since 1.0
]]
function lib:AddLine(tooltip, text, r, g, b, embed, wrap)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if reg.NoColumns then
		embed = false
	else
		if r and not g then embed = r r = nil end -- deprecated: (tooltip, text, embed) form
		if embed == nil then embed = self.embedMode end
	end
	if not embed then
		reg.extraTip:AddLine(text, r, g, b, wrap)
		reg.extraTipUsed = true
	else
		tooltip:AddLine(text, r, g, b, wrap)
	end
end

--[[-
	Adds a two-columned line to the tooltip.
	@param tooltip GameTooltip object
	@param textLeft the left column's contents
	@param textRight the left column's contents
	@param r red component of the tooltip line color (optional)
	@param g green component of the tooltip line color (optional)
	@param b blue component of the tooltip line color (optional)
	@param embed override the lib's embedMode setting (optional)
	@see SetEmbedMode
	@since 1.0
]]
function lib:AddDoubleLine(tooltip,textLeft,textRight,lr,lg,lb,rr,rg,rb,embed)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if reg.NoColumns then
		embed = false
	else
		if lr and not lg and not rr then embed = lr lr = nil end
		if lr and lg and rr and not rg then embed = rr rr = nil end
		if embed == nil then embed = self.embedMode end
	end
	if not embed then
		reg.extraTip:AddDoubleLine(textLeft,textRight,lr,lg,lb,rr,rg,rb)
		reg.extraTipUsed = true
	else
		tooltip:AddDoubleLine(textLeft,textRight,lr,lg,lb,rr,rg,rb)
	end
end

--[[-
	Creates a string representation of the money value passed using embedded textures for the icons
	@param money the money value to be converted in copper
	@param concise when false (default), the representation of 1g is "1g 00s 00c" when true, it is simply "1g" (optional)
	@since 1.0
]]
function lib:GetMoneyText(money, concise)
	local g = floor(money / 10000)
	local s = floor(money % 10000 / 100)
	local c = floor(money % 100)

    local colorBlindEnabled = GetCVar("colorblindMode") == "1"

	local moneyText = ""

	local sep, fmt = "", "%d"
	if g > 0 then
        if colorBlindEnabled then
		    moneyText = format("%.0f",g) .. GOLD_AMOUNT_SYMBOL
        else
		    moneyText = goldicon:format(g)
        end
		sep, fmt = " ", "%02d"
	end

	if s > 0 or (money >= 10000 and (concise and c > 0) or not concise) then
        if colorBlindEnabled then
		    moneyText = moneyText .. sep .. format(fmt,s) .. SILVER_AMOUNT_SYMBOL
        else
		    moneyText = moneyText..sep..silvericon:format(fmt):format(s)
        end
		sep, fmt = " ", "%02d"
	end

	if not concise or c > 0 or money < 100 then
        if colorBlindEnabled then
		    moneyText = moneyText .. sep .. format(fmt,c) .. COPPER_AMOUNT_SYMBOL
        else
            moneyText = moneyText..sep..coppericon:format(fmt):format(c)
        end
	end

	return moneyText
end

--[[-
	Adds a line with text in the left column and a money frame in the right.
	The money parameter is given in copper coins (i.e. 1g 27s 5c would be 12705)
	@param tooltip GameTooltip object
	@param text the contents of the tooltip line
	@param money the money value to be displayed (in copper)
	@param r red component of the tooltip line color (optional)
	@param g green component of the tooltip line color (optional)
	@param b blue component of the tooltip line color (optional)
	@param embed override the lib's embedMode setting (optional)
	@param concise specify if concise money mode is to be used (optional)
	@see SetEmbedMode
	@since 1.0
]]
function lib:AddMoneyLine(tooltip,text,money,r,g,b,embed,concise)
	local reg = self.tooltipRegistry[tooltip]
	if not reg then return end

	if reg.NoColumns then
		embed = false
	else
		if r and not g then embed = r r = nil end
		if embed == nil then embed = self.embedMode end
	end

	local moneyText = self:GetMoneyText(money, concise)

	if not embed then
		reg.extraTip:AddDoubleLine(text,moneyText,r,g,b,1,1,1)
		reg.extraTipUsed = true
	else
		tooltip:AddDoubleLine(text,moneyText,r,g,b,1,1,1)
	end
end

--[[-
	Sets a tooltip to hyperlink with specified quantity
	@param tooltip GameTooltip object
	@param link hyperlink to display in the tooltip
	@param quantity quantity of the item to display (optional)
	@param detail additional detail items to set for the callbacks (optional)
	@return true if successful
	@since 1.0
]]
function lib:SetHyperlinkAndCount(tooltip, link, quantity, detail)
    --DebugPrintQuick("SetHyperlinkAndCount", link, quantity, detail ) -- DEBUGGING
	local reg = self.tooltipRegistry[tooltip]
	if not reg or reg.NoColumns then return end -- NoColumns tooltips can't handle :SetHyperlink

	OnTooltipCleared(tooltip)
	reg.quantity = quantity
	reg.item = link
	reg.additional.event = "SetHyperlinkAndCount"
	reg.additional.eventLink = link
	if detail then
		for k,v in pairs(detail) do
			reg.additional[k] = v
		end
	end
	reg.ignoreOnCleared = true
	reg.ignoreSetHyperlink = true
	tooltip:SetHyperlink(link)
	reg.ignoreSetHyperlink = nil
	reg.ignoreOnCleared = nil
	return true
end

--[[-
	Set a (BattlePet) tooltip to (battlepetpet)link
	Although Pet Cages cannot be stacked, some Addons may wish to group identical Pets together for display purposes
	@param tooltip Frame(BattlePetTooltipTemplate) object
	@param link battlepet link to display in the tooltip
	@param quantity quantity of the item to display (optional)
	@param detail additional detail items to set for the callbacks (optional)
	@return true if successful
	@since 1.325

	-- ref: BattlePetToolTip_Show in FrameXML\BattlePetTooltip.lua
	-- ref: FloatingBattlePet_Show in FrameXML\FloatingPetBattleTooltip.lua
]]
local BATTLE_PET_TOOLTIP = {}
function lib:SetBattlePetAndCount(tooltip, link, quantity, detail)
	if not link then return end
	local reg = self.tooltipRegistry[tooltip]
	if not reg or not reg.NoColumns then return end -- identify BattlePet tooltips by their NoColumns flag
	local head, speciesID, level, breedQuality, maxHealth, power, speed, tail = strsplit(":", link)
	if not tail or head:sub(-9) ~= "battlepet" then return end
	speciesID = tonumber(speciesID)
	if not speciesID or speciesID < 1 then return end
	local name, icon, petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	if not name then return end

	-- set up the battlepet table
	BATTLE_PET_TOOLTIP.speciesID = speciesID
	BATTLE_PET_TOOLTIP.name = name
	BATTLE_PET_TOOLTIP.level = tonumber(level)
	BATTLE_PET_TOOLTIP.breedQuality = tonumber(breedQuality)
	BATTLE_PET_TOOLTIP.petType = petType
	BATTLE_PET_TOOLTIP.maxHealth = tonumber(maxHealth)
	BATTLE_PET_TOOLTIP.power = tonumber(power)
	BATTLE_PET_TOOLTIP.speed = tonumber(speed)
	local customName = strmatch(tail, "%[(.+)%]")
	if (customName ~= BATTLE_PET_TOOLTIP.name) then
		BATTLE_PET_TOOLTIP.customName = customName
	else
		BATTLE_PET_TOOLTIP.customName = nil
	end

	-- set up reg
	OnTooltipCleared(tooltip)
	reg.quantity = quantity
	reg.item = link
	reg.additional.event = "SetBattlePetAndCount"
	reg.additional.eventLink = link
	if detail then
		for k,v in pairs(detail) do
			reg.additional[k] = v
		end
	end

	-- load the tooltip (will trigger a call to OnTooltipSetBattlePet)
	reg.ignoreOnCleared = true
	BattlePetTooltipTemplate_SetBattlePet(tooltip, BATTLE_PET_TOOLTIP)

	local owned = C_PetJournal.GetOwnedBattlePetString(speciesID)
	tooltip.Owned:SetText(owned)
	if owned == nil then
		if tooltip.Delimiter then
			-- if .Delimiter is present it requires special handling (FloatingBattlePetTooltip)
			tooltip:SetSize(260,150)
			tooltip.Delimiter:ClearAllPoints()
			tooltip.Delimiter:SetPoint("TOPLEFT",tooltip.SpeedTexture,"BOTTOMLEFT",-6,-5)
		else
			tooltip:SetSize(260,122)
		end
	else
		if tooltip.Delimiter then
			tooltip:SetSize(260,164)
			tooltip.Delimiter:ClearAllPoints()
			tooltip.Delimiter:SetPoint("TOPLEFT",tooltip.SpeedTexture,"BOTTOMLEFT",-6,-19)
		else
			tooltip:SetSize(260,136)
		end
	end

	tooltip:Show()
	reg.ignoreOnCleared = nil
	return true
end

--[[-
	Get the additional information from a tooltip event.
	Often additional event details are available about the situation under which the tooltip was invoked, such as:
		* The call that triggered the tooltip.
		* The slot/inventory/index of the item in question.
		* Whether the item is usable or not.
		* Auction price information.
		* Ownership information.
		* Any data provided by the Get*Info() functions.
	If you require access to this information for the current tooltip, call this function to retrieve it.
	@param tooltip GameTooltip object
	@return table containing the additional information
	@since 1.0
]]
function lib:GetTooltipAdditional(tooltip)
	local reg = self.tooltipRegistry[tooltip]
	if reg then
		return reg.additional
	end
	return nil
end



--[[ INTERNAL USE ONLY
	Deactivates this version of the library, rendering it inert.
	Needed to run before an upgrade of the library takes place.
	@since 1.0
]]
function lib:Deactivate()
	-- deactivate all hook stubs
	for tooltip, tiptable in pairs(lib.hookStore) do
		if tooltip ~= "version" then -- skip over the version indicator
			for method, control in pairs(tiptable) do
				wipe(control) -- disable the hook stub by removing all hooks from the control table
			end
		end
	end

	-- deactivate and discard any existing extra tooltips
	-- (should be extremely rare that any would exist at this point
	-- therefore minimal code just to prevent errors in those rare instances)
	if self.tooltipRegistry then
		for _, reg in pairs(self.tooltipRegistry) do
			local tip = reg.extraTip
			if tip then
				tip:Hide()
				tip:Release()
			end
			reg.extraTip = nil
			reg.extraTipUsed = nil

		end
	end
	self.extraTippool = nil
end

--[[ INTERNAL USE ONLY
	Activates this version of the library.
	Configures this library for use by setting up its variables and reregistering any previously registered tooltips and callbacks.
	@since 1.0
]]
function lib:Activate()
	local oldreg = self.tooltipRegistry
	if oldreg then
		self.tooltipRegistry = nil
		for tooltip in pairs(oldreg) do
			self:RegisterTooltip(tooltip)
		end
	end
	local oldcallbacks = self.callbacks
	if oldcallbacks then
		self.callbacks = nil
		for options, priority in pairs(oldcallbacks) do
			self:AddCallback(options, priority)
		end
	end
end

-- Sets all the complex spell details
local function SetSpellDetail(reg, link)
	local name, _, icon, ctime, minRange, maxRange, spellID = GetSpellInfo(link)
	local subname = GetSpellSubtext(spellID)
	reg.additional.name = name
	reg.additional.link = link
	reg.additional.rank = subname
	reg.additional.subname = subname
	reg.additional.icon = icon
	reg.additional.castTime = ctime
	reg.additional.minRange = minRange
	reg.additional.maxRange = maxRange
	reg.additional.spellID = spellID
end

--[[ INTERNAL USE ONLY
	Generates a tooltip method table.
	The tooltip method table supplies hooking information for the tooltip registration functions, including the methods to hook and a function to run that parses the hooked functions parameters.
	@since 1.0
	Addendum: generates 2 method tables, for prehooks and posthooks. Where the prehook sets a flag, a posthook must be installed to clear it. Specifically: reg.ignoreOnCleared
]]
function lib:GenerateTooltipMethodTable() -- Sets up hooks to give the quantity of the item
	local tooltipRegistry = self.tooltipRegistry
	self.GenerateTooltipMethodTable = nil -- only run once

	tooltipMethodPrehooks = {

		-- Default enabled events

		SetAuctionItem = function(self,type,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local _,_,q,_,cu,_,_,minb,inc,bo,ba,hb,_,own,ownf = GetAuctionItemInfo(type,index)
			reg.quantity = q
			reg.additional.event = "SetAuctionItem"
			reg.additional.eventType = type
			reg.additional.eventIndex = index
			reg.additional.canUse = cu
			reg.additional.minBid = minb
			reg.additional.minIncrement = inc
			reg.additional.buyoutPrice = bo
			reg.additional.bidAmount = ba
			reg.additional.highBidder = hb
			reg.additional.owner = own
			reg.additional.ownerFull = ownf
			reg.item = GetAuctionItemLink(type,index) -- Workaround [LTT-56], Remove when fixed by Blizzard
		end,

		SetAuctionSellItem = function(self)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local name,texture,quantity,quality,canUse,price = GetAuctionSellItemInfo()
			reg.quantity = quantity
			reg.additional.event = "SetAuctionSellItem"
			reg.additional.canUse = canUse
		end,

		SetBagItem = function(self,bag,slot)
			OnTooltipCleared(self)
			local tex,q,l,_,r,loot = GetContainerItemInfo(bag,slot)
			if tex then -- only process occupied slots
				local reg = tooltipRegistry[self]
				reg.ignoreOnCleared = true
				reg.quantity = q
				reg.additional.event = "SetBagItem"
				reg.additional.eventContainer = bag
				reg.additional.eventIndex = slot
				reg.additional.readable = r
				reg.additional.locked = l
				reg.additional.lootable = loot
			end
		end,

		SetBuybackItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local name,texture,price,quantity = GetBuybackItemInfo(index)
			reg.quantity = quantity
			reg.additional.event = "SetBuybackItem"
			reg.additional.eventIndex = index
		end,

		SetGuildBankItem = function(self, tab, index)
			OnTooltipCleared(self)
			local texture, quantity, locked = GetGuildBankItemInfo(tab, index)
			if texture then -- only process occupied slots
				local reg = tooltipRegistry[self]
				reg.ignoreOnCleared = true
				reg.quantity = quantity
				reg.additional.event = "SetGuildBankItem"
				reg.additional.eventContainer = tab
				reg.additional.eventIndex = index
				reg.additional.locked = locked
				reg.item = GetGuildBankItemLink(tab,index) -- Workaround [LTT-56], Remove when fixed by Blizzard
			end
		end,

		SetInboxItem = function(self, index, itemIndex)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetInboxItem"
			reg.additional.eventIndex = index
			reg.additional.eventSubIndex = itemIndex -- may be nil
			if itemIndex then
				local _,_,_,q,_,cu = GetInboxItem(index, itemIndex)
				reg.quantity = q
				reg.additional.canUse = cu
			end
		end,

		SetInventoryItem = function(self, unit, index)
			OnTooltipCleared(self)
			local link = GetInventoryItemLink(unit, index)
			if link then -- only process occupied slots
				local reg = tooltipRegistry[self]
				reg.ignoreOnCleared = true
				reg.quantity = GetInventoryItemCount(unit, index)
				reg.additional.event = "SetInventoryItem"
				reg.additional.eventIndex = index
				reg.additional.eventUnit = unit
				reg.additional.link = link
			end
		end,

		SetLootItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local _,_,q = GetLootSlotInfo(index)
			reg.quantity = q
			reg.additional.event = "SetLootItem"
			reg.additional.eventIndex = index
		end,

		SetLootRollItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local texture, name, count, quality = GetLootRollItemInfo(index)
			reg.quantity = count
			reg.additional.event = "SetLootRollItem"
			reg.additional.eventIndex = index
		end,

		SetMerchantItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local _,_,p,q,na,cu,ec = GetMerchantItemInfo(index)
			reg.quantity = q
			reg.additional.event = "SetMerchantItem"
			reg.additional.eventIndex = index
			reg.additional.price = p
			reg.additional.numAvailable = na
			reg.additional.canUse = cu
			reg.additional.extendedCost = ec
			reg.item = GetMerchantItemLink(index) -- Workaround [LTT-56], Remove when fixed by Blizzard
		end,

		SetQuestItem = function(self,type,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local _,_,q,_,cu = GetQuestItemInfo(type,index)
			reg.quantity = q
			reg.additional.event = "SetQuestItem"
			reg.additional.eventType = type
			reg.additional.eventIndex = index
			reg.additional.canUse = cu
			reg.additional.link = GetQuestItemLink(type,index) -- Workaround [LTT-56], Remove when fixed by Blizzard
		end,

		SetQuestLogItem = function(self,type,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local _,q,cu
			if type == "choice" then
				_,_,q,_,cu = GetQuestLogChoiceInfo(index)
			else
				_,_,q,_,cu = GetQuestLogRewardInfo(index)
			end
			reg.quantity = q
			reg.additional.event = "SetQuestLogItem"
			reg.additional.eventType = type
			reg.additional.eventIndex = index
			reg.additional.canUse = cu
			reg.additional.link = GetQuestLogItemLink(type,index) -- Workaround [LTT-56], Remove when fixed by Blizzard
		end,

		SetSendMailItem = function(self, index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local name, itemID, texture, quantity = GetSendMailItem(index)
			reg.quantity = quantity
			reg.additional.event = "SetSendMailItem"
			reg.additional.eventIndex = index
		end,

		SetTradePlayerItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local name, texture, quantity = GetTradePlayerItemInfo(index)
			reg.quantity = quantity
			reg.additional.event = "SetTradePlayerItem"
			reg.additional.eventIndex = index
		end,

		SetTradeTargetItem = function(self,index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local name, texture, quantity = GetTradeTargetItemInfo(index)
			reg.quantity = quantity
			reg.additional.event = "SetTradeTargetItem"
			reg.additional.eventIndex = index
		end,

		SetRecipeReagentItem = function(self, recipeID, reagentIndex)
            -- used on Current WoW only
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetRecipeReagentItem"
			reg.additional.eventIndex = recipeID
			reg.additional.eventSubIndex = reagentIndex
            local _,_,q,rc = C_TradeSkillUI.GetRecipeReagentInfo(recipeID, reagentIndex)
            reg.quantity = q
            reg.additional.playerReagentCount = rc
            reg.additional.link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex) -- Workaround [LTT-56], Remove when fixed by Blizzard
		end,

--[[
Old Classic Crafting APIs (removed in 3.0)
REMOVED - CloseCraft
REMOVED - CollapseCraftSkillLine
REMOVED - CraftIsEnchanting
REMOVED - CraftIsPetTraining
REMOVED - CraftOnlyShowMakeable
REMOVED - DoCraft
REMOVED - ExpandCraftSkillLine
REMOVED - GetNumCrafts
REMOVED - GetCraftButtonToken
REMOVED - GetCraftCooldown
REMOVED - GetCraftDescription
REMOVED - GetCraftDisplaySkillLine
REMOVED - GetCraftFilter
REMOVED - GetCraftIcon
REMOVED - GetCraftInfo
REMOVED - GetCraftItemLink
REMOVED - GetCraftItemNameFilter
REMOVED - GetCraftName
REMOVED - GetCraftNumMade
REMOVED - GetCraftNumReagents
REMOVED - GetCraftReagentInfo
REMOVED - GetCraftReagentItemLink
REMOVED - GetCraftRecipeLink
REMOVED - GetCraftSelectionIndex
REMOVED - GetCraftSkillLine
REMOVED - GetCraftSlots
REMOVED - GetCraftSpellFocus
REMOVED - SelectCraft
REMOVED - SetCraftFilter
REMOVED - SetCraftItemNameFilter
]]
		SetCraftItem = function(self, recipeID, reagentIndex)
            -- used on Classic only
            --DebugPrintQuick("SetCraftItem called", recipeID, reagentIndex ) -- DEBUGGING
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetCraftItem"
			reg.additional.eventIndex = recipeID
			reg.additional.eventSubIndex = reagentIndex
            if reagentIndex then
                local _,_,q,rc = GetCraftReagentInfo(recipeID, reagentIndex)
                reg.quantity = q
                reg.additional.playerReagentCount = rc
                reg.additional.link = GetCraftReagentItemLink(recipeID, reagentIndex)
                --DebugPrintQuick("SetCraftItem reagents1", q, rc, reg.additional.link ) -- DEBUGGING
            else
				local link = GetCraftItemLink(recipeID)
				reg.additional.link = link
                --DebugPrintQuick("SetCraftItem reagents2", link ) -- DEBUGGING
				reg.quantity = GetCraftNumMade(recipeID)
				if link and link:match("spell:%d") then
					SetSpellDetail(reg, link)
				end
            end
		end,

		SetTradeSkillItem = function(self, recipeID, reagentIndex)
            -- used on Classic only
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetTradeSkillItem"
			reg.additional.eventIndex = recipeID
			reg.additional.eventSubIndex = reagentIndex
            if reagentIndex then
                local _,_,q,rc = GetTradeSkillReagentInfo(recipeID, reagentIndex)
                reg.quantity = q
                reg.additional.playerReagentCount = rc
                reg.additional.link = GetTradeSkillReagentItemLink(recipeID, reagentIndex)
            else
				local link = GetTradeSkillItemLink(recipeID)
				reg.additional.link = link
				reg.quantity = GetTradeSkillNumMade(recipeID)
				if link and link:match("spell:%d") then
					SetSpellDetail(reg, link)
				end
            end
		end,

		SetRecipeResultItem = function(self, recipeID)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetRecipeResultItem"
			reg.additional.eventIndex = recipeID

            if (lib.Classic) then
                reg.additional.recipeInfo = nil     -- don't have a match for GetRecipeInfo in classic
                local minMade, maxMade = GetTradeSkillNumMade(recipeID)
                reg.additional.minMade = minMade
                reg.additional.maxMade = maxMade
                if minMade and maxMade then -- protect against nil values
                    reg.quantity = (minMade + maxMade) / 2 -- ### todo: may not be an integer, if this causes problems may need to math.floor it
                elseif maxMade then
                    reg.quantity = maxMade
                else
                    reg.quantity = minMade -- note: may still be nil
                end
                reg.additional.link = GetTradeSkillRecipeLink(recipeID) -- Workaround [LTT-56], Remove when fixed by Blizzard
            else
                local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID) -- returns a table with a ton of info
                reg.additional.recipeInfo = recipeInfo -- for now just attach whole table to reg.additional
                local minMade, maxMade = C_TradeSkillUI.GetRecipeNumItemsProduced(recipeID)
                reg.additional.minMade = minMade
                reg.additional.maxMade = maxMade
                if minMade and maxMade then -- protect against nil values
                    reg.quantity = (minMade + maxMade) / 2 -- ### todo: may not be an integer, if this causes problems may need to math.floor it
                elseif maxMade then
                    reg.quantity = maxMade
                else
                    reg.quantity = minMade -- note: may still be nil
                end
                reg.additional.link = C_TradeSkillUI.GetRecipeItemLink(recipeID) -- Workaround [LTT-56], Remove when fixed by Blizzard
            end
		end,

		SetHyperlink = function(self,link)
            -- DebugPrintQuick("SetHyperlink called ", link )   -- DEBUGGING
			local reg = tooltipRegistry[self]
			if reg.ignoreSetHyperlink then return end
			OnTooltipCleared(self)
			reg.ignoreOnCleared = true
			reg.additional.event = "SetHyperlink"
			reg.additional.eventLink = link
			reg.additional.link = link
		end,

		-- Default disabled events:

		--[[ disabled due to taint issues
		SetAction = function(self,actionid)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local t,id,sub = GetActionInfo(actionid)
			reg.additional.event = "SetAction"
			reg.additional.eventIndex = actionid
			reg.additional.actionType = t
			reg.additional.actionIndex = id
			reg.additional.actionSubtype = subtype
			if t == "item" then
				reg.quantity = GetActionCount(actionid)
			elseif t == "spell" then
				if id and id > 0 then
					local link = GetSpellLink(id, sub)
					SetSpellDetail(reg, link)
				end
			end
		end,
		--]]

		SetCurrencyToken = function(self, index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetCurrencyToken"
			reg.additional.eventIndex = index
		end,

		SetPetAction = function(self, index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetPetAction"
			reg.additional.eventIndex = index
		end,

		SetQuestLogRewardSpell = function(self)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetQuestLogRewardSpell"
		end,

		SetQuestRewardSpell = function(self)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetQuestRewardSpell"
		end,

		SetShapeshift = function(self, index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetShapeshift"
			reg.additional.eventIndex = index
		end,

		--[[ disabled due to probable taint issues
		SetSpellBookItem = function(self,index,booktype)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			local link = GetSpellLink(index, booktype)
			if link then
				reg.additional.event = "SetSpellBookItem"
				reg.additional.eventIndex = index
				reg.additional.eventType = booktype
				SetSpellDetail(reg, link)
			end
		end,
		--]]

		SetTalent = function(self, index, isInspect, talentGroup, inspectedUnit, classID)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetTalent"
			reg.additional.eventIndex = index
		end,

		SetTrainerService = function(self, index)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetTrainerService"
			reg.additional.eventIndex = index
		end,

		--[[ may also be causing taint? disabled just in case - we don't use it for anything
		SetUnit = function(self, unit)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetUnit"
			reg.additional.eventUnit= unit
		end,
		--]]

		--[[ disabled due to taint issues
		SetUnitAura = function(self, unit, index, filter)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetUnitAura"
			reg.additional.eventUnit = unit
			reg.additional.eventIndex = index
			reg.additional.eventFilter = filter
		end,
		--]]

		--[[ disabled due to possible taint issues
		SetUnitBuff = function(self, unit, index, filter)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetUnitBuff"
			reg.additional.eventUnit = unit
			reg.additional.eventIndex = index
			reg.additional.eventFilter = filter
		end,

		SetUnitDebuff = function(self, unit, index, filter)
			OnTooltipCleared(self)
			local reg = tooltipRegistry[self]
			reg.ignoreOnCleared = true
			reg.additional.event = "SetUnitDebuff"
			reg.additional.eventUnit = unit
			reg.additional.eventIndex = index
			reg.additional.eventFilter = filter
		end,
		--]]
	}

	local function posthookClearIgnore(self)
		tooltipRegistry[self].ignoreOnCleared = nil
	end
	tooltipMethodPosthooks = {
		SetAuctionItem = posthookClearIgnore,
		SetAuctionSellItem = posthookClearIgnore,
		SetBagItem = posthookClearIgnore,
		SetBuybackItem = posthookClearIgnore,
		SetGuildBankItem = posthookClearIgnore,
		SetInboxItem = posthookClearIgnore,
		SetInventoryItem = posthookClearIgnore,
		SetLootItem = posthookClearIgnore,
		SetLootRollItem = posthookClearIgnore,
		SetMerchantItem = posthookClearIgnore,
		SetQuestItem = posthookClearIgnore,
		SetQuestLogItem = posthookClearIgnore,
		SetSendMailItem = posthookClearIgnore,
		SetTradePlayerItem = posthookClearIgnore,
		SetTradeTargetItem = posthookClearIgnore,
		SetRecipeReagentItem = posthookClearIgnore,
		SetRecipeResultItem = posthookClearIgnore,
        SetTradeSkillItem = posthookClearIgnore,
        SetCraftItem = posthookClearIgnore,

		SetHyperlink = function(self)
			local reg = tooltipRegistry[self]
			if not reg.ignoreSetHyperlink then
				reg.ignoreOnCleared = nil
			end
		end,

		--SetAction = posthookClearIgnore,
		SetCurrencyToken = posthookClearIgnore,
		SetPetAction = posthookClearIgnore,
		SetQuestLogRewardSpell = posthookClearIgnore,
		SetQuestRewardSpell = posthookClearIgnore,
		SetShapeshift = posthookClearIgnore,
		--SetSpellBookItem = posthookClearIgnore,
		SetTalent = posthookClearIgnore,
		SetTrainerService = posthookClearIgnore,
		--SetUnit = posthookClearIgnore,
		--SetUnitAura = posthookClearIgnore,
		--SetUnitBuff = posthookClearIgnore,
		--SetUnitDebuff = posthookClearIgnore,
	}

end

do -- ExtraTip "class" definition
	local methods = {"InitLines","Attach","Show","MatchSize","Release","SetParentClamp"}
	local scripts = {"OnShow","OnHide","OnSizeChanged"}
	local numTips = 0
	local class = {}
	ExtraTipClass = class

	local addLine,addDoubleLine,show = GameTooltip.AddLine,GameTooltip.AddDoubleLine,GameTooltip.Show

	local line_mt = {
		__index = function(t,k)
			local v = _G[t.name..k]
			rawset(t,k,v)
			return v
		end
	}

	function class:new()
		local n = numTips + 1
		numTips = n
		local o = CreateFrame("GameTooltip",LIBSTRING.."Tooltip"..n,UIParent,"GameTooltipTemplate")
		o:SetClampedToScreen(false) -- workaround for tooltip overlap problem [LTT-55]: allow extra tip to get pushed off screen instead

		for _,method in pairs(methods) do
			o[method] = self[method]
		end

		for _,script in pairs(scripts) do
			o:SetScript(script,self[script])
		end

		o.Left = setmetatable({name = o:GetName().."TextLeft"},line_mt)
		o.Right = setmetatable({name = o:GetName().."TextRight"},line_mt)
		return o
	end

	local pointsRight = {"TOPRIGHT", "BOTTOMRIGHT"}
	local pointsCentre = {"TOP", "BOTTOM"}
	local pointsLeft = {"TOPLEFT", "BOTTOMLEFT"}
	local attachPointsLookup = {
		TOPLEFT = pointsLeft,
		TOPRIGHT = pointsRight,
		BOTTOMLEFT = pointsLeft,
		BOTTOMRIGHT = pointsRight,
		TOP = pointsCentre,
		BOTTOM = pointsCentre,
		LEFT = pointsLeft,
		RIGHT = pointsRight,
		CENTER = pointsCentre,
	}
	function class:Attach(tooltip)
		if self.parent then self:SetParentClamp(0) end
		self.parent = tooltip
		self:SetParent(tooltip)
		self:SetOwner(tooltip,"ANCHOR_NONE")
		local parentPoint = tooltip:GetPoint(1)
		local attach = attachPointsLookup[parentPoint] or pointsRight
		self:SetPoint(attach[1], tooltip, attach[2])
	end

	function class:Release()
		if self.parent then self:SetParentClamp(0) end
		self.parent = nil
		self:SetParent(nil)
		self.inMatchSize = nil
	end

	function class:InitLines()
		local nlines = self:NumLines()
		local changedLines = self.changedLines or 0
		if changedLines < nlines then
			for i = changedLines + 1, nlines do
				local left,right = self.Left[i],self.Right[i]
				local font
				if i == 1 then
					font = GameFontNormal
				else
					font = GameFontNormalSmall
				end

				local r,g,b,a

				r,g,b,a = left:GetTextColor()
				left:SetFontObject(font)
				left:SetTextColor(r,g,b,a)

				r,g,b,a = right:GetTextColor()
				right:SetFontObject(font)
				right:SetTextColor(r,g,b,a)
			end
			self.changedLines = nlines
			return true
		end
	end

	function class:SetParentClamp(h)
		local p = self.parent
		if not p then return end
		local l,r,t,b = p:GetClampRectInsets()
		p:SetClampRectInsets(l,r,t,-h)
	end

	function class:OnShow()
		self:SetParentClamp(self:GetHeight())
		self:MatchSize()
	end

	function class:OnSizeChanged(w,h)
		self:SetParentClamp(h)
		self:MatchSize()
	end

	function class:OnHide()
		self:SetParentClamp(0)
	end

	-- The right-side text is statically positioned to the right of the left-side text.
	-- As a result, manually changing the width of the tooltip causes the right-side text to not be in the right place.
	local function fixRight(tooltip, width)
		local lefts = tooltip.Left or tooltip.LibExtraTipLeft
		if not lefts then
			lefts = setmetatable({name = tooltip:GetName().."TextLeft"},line_mt)
			tooltip.LibExtraTipLeft = lefts -- use key containing lib name, to try to ensure it doesn't clash with anything
		end
		local rights = tooltip.Right or tooltip.LibExtraTipRight
		if not rights then
			rights = setmetatable({name = tooltip:GetName().."TextRight"},line_mt)
			tooltip.LibExtraTipRight = rights -- use key containing lib name, to try to ensure it doesn't clash with anything
		end

		local xofs = width - tooltip:GetPadding() - 20.5 -- constant value obtained by analysing default tooltip layout

		for line = 1, tooltip:NumLines() do
			local left, right = lefts[line], rights[line]
			if left and right then
				right:ClearAllPoints()
				right:SetPoint("RIGHT", left, "LEFT", xofs, 0) -- approximates the layout used by Blizzard, but for the new width
			end
		end
	end

	function class:MatchSize()
		local p = self.parent
		if not p then return end
		if self.inMatchSize then return end
		self.inMatchSize = true
		local pw = p:GetWidth()
		local w = self:GetWidth()
		local d = pw - w
		-- if the difference is less than a pixel, we don't want to waste time fixing it
		if d > .5 then
			self:SetWidth(pw)	-- parent is wider, so we make child tip match
			fixRight(self, pw)
		elseif d < -.5 then
			local reg = lib.tooltipRegistry[p]
			if not reg.NoColumns then
				p:SetWidth(w)	-- the parent is smaller than the child tip, make the parent wider
				fixRight(p, w)	-- fix right aligned items in the game tooltip, not working currently as it shifts by the wrong amount
				p:GetWidth()	-- in certain rare cases, inspecting the width here is necessary to force the tooltip to resize properly
			end
		end
		self.inMatchSize = nil
	end

	function class:Show()
		show(self)
		if self:InitLines() then
			-- sometimes 'show' needs to be called twice to correctly resize the tooltip
			-- calling it once (before OR after InitLines) doesn't always work {LTT-42}
			show(self)
		end
		self:MatchSize()
	end

end

-- More housekeeping upgrade stuff
lib:SetEmbedMode(lib.embedMode)
lib:Activate()


--[[ Debugging Code -----------------------------------------------------

local DebugLib = LibStub("DebugLib")
local debug, assert, printQuick
if DebugLib then
	debug, assert, printQuick = DebugLib("LibExtraTip")
else
	function debug() end
	assert = debug
	printQuick = debug
end

-- when you just want to print a message and don't care about the rest
function DebugPrintQuick(...)
	printQuick(...)
end

-- Debugging Code ]]  -----------------------------------------------------


--[[ Test Code -----------------------------------------------------

local LT = LibStub("LibExtraTip-1")

LT:RegisterTooltip(GameTooltip)
LT:RegisterTooltip(ItemRefTooltip)

--[=[
LT:AddCallback(function(tip,item,quantity,name,link,quality,ilvl)
	LT:AddDoubleLine(tip,"Item Level:",ilvl,nil,nil,nil,1,1,1,0)
	LT:AddDoubleLine(tip,"Item Level:",ilvl,1,1,1,0)
	LT:AddDoubleLine(tip,"Item Level:",ilvl,0)
end,0)
--]=]
LT:AddCallback(function(tip,item,quantity,name,link,quality,ilvl)
	quantity = quantity or 1
	local price = GetSellValue(item)
	if price then
		LT:AddMoneyLine(tip,"Sell to vendor"..(quantity > 1 and "("..quantity..")" or "") .. ":",price*quantity,1)
	end
	LT:AddDoubleLine(tip,"Item Level:",ilvl,1)
end)

-- Test Code ]]-----------------------------------------------------

--[[ Debugging code
local f = {"AddDoubleLine", "AddFontStrings", "AddLine", "AddTexture", "AppendText", "ClearLines", "FadeOut", "GetAnchorType", "GetItem", "GetSpell", "GetOwner", "GetUnit", "IsUnit", "NumLines", "SetAction", "SetAuctionCompareItem", "SetAuctionItem", "SetAuctionSellItem", "SetBagItem", "SetBuybackItem", "SetCraftItem", "SetCraftSpell", "SetCurrencyToken", "SetGuildBankItem", "SetHyperlink", "SetInboxItem", "SetInventoryItem", "SetLootItem", "SetLootRollItem", "SetMerchantCompareItem", "SetMerchantItem", "SetMinimumWidth", "SetOwner", "SetPadding", "SetPetAction", "SetPlayerBuff", "SetQuestItem", "SetQuestLogItem", "SetQuestLogRewardSpell", "SetQuestRewardSpell", "SetSendMailItem", "SetShapeshift", "SetSpell", "SetTalent", "SetText", "SetTracking", "SetTradePlayerItem", "SetTradeTargetItem", "SetTrainerService", "SetUnit", "SetUnitAura", "SetUnitBuff", "SetUnitDebuff"}

for _,k in ipairs(f) do
	print("Hooking ", k)
	local h = GameTooltip[k]
	GameTooltip[k] = function(...)
	    local t
	    for i=2,5 do
			if not t then
				t = debugstack(i,1,0):gsub("\n[.\s\n]*", ""):gsub(": in function.*", "")
				if not t:match("Interface\\") then t = nil
				else t = t:gsub("Interface\\", "") end
			end
		end
		if t then
			print(t..": "..k.."(", ..., ")")
		elseif true then
			print("-------");
			print(debugstack());
			print("Call to: "..k.."(", ..., ")")
			print("-------");
		end
		return h(...)
	end
end
--]]
