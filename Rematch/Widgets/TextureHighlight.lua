--[[
	On the theory that the mouse can only interact with one element on the screen at
	a time, there's no need for every element to always define its own highlight.

	rematch:ShowTextureHighlight(texture) will parent a shared frame to the texture's
	parent, then make the frame's texture the same as the given texture, but with
	alphaMode "ADD", causing the texture to light up.

	Use rematch:HideTextureHighlight() to remove it.

	CompositeButtons use this method to highlight its textures, but with its own frame.

	TODO: Make CompositeButtons use this instead and add UpdateTextureHighlight to
	the postUpdateFuncs of its scrollframes.
]]

local _,L = ...
local rematch = Rematch

local highlight = CreateFrame("Frame",nil,UIParent,"RematchUseParentLevel")
highlight:SetSize(32,32)
highlight:EnableMouse(false)
highlight:Hide()

highlight.Overlay = highlight:CreateTexture(nil,"OVERLAY")
highlight.Overlay:SetAllPoints(true)
highlight.Overlay:SetAlpha(0.75) -- adjust this to control "brightness"
highlight.Overlay:SetBlendMode("ADD")

local currentTexture -- the texture currently being highlighted

function rematch:ShowTextureHighlight(texture)
	local parent = texture and texture:GetParent()
	if parent then
		currentTexture = texture
		highlight:SetParent(parent)
		highlight:SetPoint("TOPLEFT",texture,"TOPLEFT")
		highlight:SetPoint("BOTTOMRIGHT",texture,"BOTTOMRIGHT")
		highlight.Overlay:SetTexture(texture:GetTexture())
		highlight.Overlay:SetTexCoord(texture:GetTexCoord())
		highlight:Show()
	else
		currentTexture = nil
	end
end

function rematch:HideTextureHighlight()
	currentTexture = nil
	highlight:Hide()
end

-- call this when the contents of the button/texture may change to update the highlight
function rematch:UpdateTextureHighlight()
	if currentTexture then
		if currentTexture:IsVisible() then -- if texture still on screen, update it
			highlight.Overlay:SetTexture(currentTexture:GetTexture())
			highlight.Overlay:SetTexCoord(currentTexture:GetTexCoord())
			highlight:Show()
		else -- underlying texture no longer on screen, hide highlight but don't nil
			 -- currentTexture in case the underlying texture is shown later (this is
			 -- to fix the problem of a highlight no longer updating on mouseover scrolling)
			highlight:Hide()
		end
	end
end
