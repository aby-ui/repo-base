--[[
	CompositeButtons are intrinsic buttons that create pseudo-buttons from the
	textures in the ARTWORK layer of a button. Its aim is to solve the problem
	of list buttons being encumbered by too many overlaying buttons and all the
	different textures, script handlers and special handling it creates.

	For example, the old (4.8.9) RematchTeamListButtonTemplate had a separate
	button for notes, preferences, win record, 3 pets and a separate frame for
	the favorites star (so highlight textures would appear below it). The pet
	buttons had multiple layers of textures too. This represented 7 different
	elements that intercept mouse events and three times as many layers of
	textures with their own separate highlights and handling.

	The new team list button template has no overlaying buttons. Everything
	clickable is a texture in the ARTWORK layer of the button. When the mouse
	moves over one of these textures, it's highlighted by a single reticle
	duplicating the texture	with an ADD blend mode, causing the texture to
	brighten. OnClicks, OnEnters and OnLeaves are defined to the texture as if
	it was a button.

	To use:
	1. Create a widget of type RematchCompositeButton 
	2. Add textures to the ARTWORK drawlayer (they will automatically gain
		highlight behavior but will not intercept clicks)
	3. Things that shouldn't be clicked should be in other layers
	4. If they must be in ARTWORK and remain uninteractive:
			texture.ignoreComposite = true
	5. To set script handlers:
			button:SetTextureScript(texture,"OnClick",func)
			Supported handlers: "OnClick", "OnEnter", "OnLeave"
	6. In the parent button's OnClick, check for button:HasFocus() to tell
		if the button has focus but not an active texture. Clicks will go
		through the textures to the underlying button; use HasFocus() to ignore.
]]

RematchCompositeButton = {} -- this is just a namespace for use bY XML

local allButtons = {} -- indexed by button, every created composite button
local onClicks = {} -- indexed by texture, function to run when a texture clicked
local onEnters = {} -- indexed by texture, function to run when mouse enters a texture
local onLeaves = {} -- indexed by texture, function to run when mouse leaves a texture

-- only one button can have focus and one texture in a button can share focus
local focusedButton = nil -- button that the mouse is currently over
local focusedTexture = nil -- texture within the above button that mouse is over

local reticle = CreateFrame("Frame", "RematchCompositeButtonReticle", UIParent)

-- method to add a script handler to a texture assigned to each button:
-- button:SetTextureScript(button.Icon,"OnClick",function() end)
local function setTextureScript(self, texture, handler, func)
	if handler=="OnClick" then
		onClicks[texture] = func -- note: self will be parent button, not texture
	elseif handler=="OnEnter" then
		onEnters[texture] = func
	elseif handler=="OnLeave" then
		onLeaves[texture] = func
	end	
end

-- method to return true if the mouse is over the button but not any active textures
local function hasFocus(self)
	return focusedButton==self and not focusedTexture
end

-- when a button is created, add it and its textures to allButtons
-- (this assumes buttons are created in XML fully formed when OnLoad happens. for
-- buttons created with CreateFrame, call this after all textures are created.)
function RematchCompositeButton:OnPreLoad()
	allButtons[self] = {}
	-- add textures in the ARTWORK layer to the new allButtons entry
	local index = 1
	for _,child in ipairs({self:GetRegions()}) do
		if child:GetObjectType()=="Texture" and child:GetDrawLayer()=="ARTWORK" and not child.ignoreComposite then
			allButtons[self][index] = child
			index = index + 1
		end
	end
	self:RegisterForClicks("AnyUp") -- all buttons accept any mouse button
	-- assign methods to the button
	self.SetTextureScript = setTextureScript
	self.HasFocus = hasFocus
end

-- onenter starts up reticle monitoring for texture interaction
function RematchCompositeButton:OnPreEnter()
	focusedButton = self -- set focus to this button
	focusedTexture = nil
	reticle:SetParent(self)
	reticle.Overlay:Hide()
	reticle:Show() -- start up reticle if it's not started
end

-- onleave stops reticle monitoring
function RematchCompositeButton:OnPreLeave()
	-- if texture has focus, run its OnLeave if applicable
	if focusedButton and focusedTexture and onLeaves[focusedTexture] then
		onLeaves[focusedTexture](focusedTexture)
	end
	focusedButton = nil -- drop focus from this button
	focusedTexture = nil
	reticle:Hide() -- hide reticle
end

-- on a MouseDown, the overlay is hidden to show the normal texture underneath
-- this has the effect of making the texture look a bit darker
function RematchCompositeButton:OnPreMouseDown()
	if focusedTexture then
		reticle.Overlay:Hide()
	end
end

-- on a MouseDown, then overlay is shown again, making the texture lighter
function RematchCompositeButton:OnPreMouseUp()
	if focusedTexture then
		reticle.Overlay:Show()
	end
end

-- on a click of the button, run the texture's OnClick if defined
function RematchCompositeButton:OnPreClick(button)
	if focusedButton==self and focusedTexture and onClicks[focusedTexture] then
		onClicks[focusedTexture](focusedTexture,button)
	end
end

-- when a button hides that has ownership of the reticle, the reticle hides too.
-- make sure the texture's OnLeave runs too
function RematchCompositeButton:OnPreHide()
	if focusedButton==self and focusedTexture and onLeaves[focusedTexture] then
		onLeaves[focusedTexture](focusedTexture)
	end
end

-- the reticle is a frame that's on screen while the mouse is over a composite
-- button. it watches for the mouse moving over a texture, sets focusedTexture
-- and highlights the texture.
reticle:SetSize(32,32)
reticle.Overlay = reticle:CreateTexture(nil,"OVERLAY")
reticle.Overlay:SetAlpha(0.75)
reticle.Overlay:SetBlendMode("ADD")
reticle:EnableMouse(false)
reticle:SetScript("OnUpdate",function(self,elapsed)
	if focusedButton and allButtons[focusedButton] then
		for _,texture in ipairs(allButtons[focusedButton]) do
			if MouseIsOver(texture) and texture:IsVisible() then
				if focusedTexture ~= texture then
					-- if leaving another texture, do its OnLeave first if needed
					if focusedTexture and onLeaves[focusedTexture] then
						onLeaves[focusedTexture](focusedTexture)
					end
					focusedTexture = texture
					-- position reticle over the texture
					self.Overlay:SetPoint("TOPLEFT", texture, "TOPLEFT")
					self.Overlay:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT")
					-- copy the texture to make it lighten the existing one
					self.Overlay:SetTexture(texture:GetTexture())
					self.Overlay:SetTexCoord(texture:GetTexCoord())
					-- show reticle
					self.Overlay:Show()
					-- finally do an OnEnter of the focused texture
					if onEnters[texture] then
						onEnters[texture](texture)
					end
				end
				return
			end
		end
		-- if we reached here mouse is not over texture
		-- first do any OnLeave of the focused texture if one exists
		if focusedTexture and onLeaves[focusedTexture] then
			onLeaves[focusedTexture](focusedTexture)
		end
		focusedTexture = nil
		-- then hide the overlay
		self.Overlay:ClearAllPoints()
		self.Overlay:Hide()
	end
end)
