local XLoot = select(2, ...)
local lib = {
	skins = {},
	masque_tweaks = {},
}
XLoot.Skin = lib
local L = XLoot.L
local print = print

-- Custom skins
-- To add your own, simply make XLoot a dependency then call XLoot:RegisterSkin(name, skin_table)
-- skin_table being a table with these keys:
-- [required] texture - Path to texture
-- [optional] name - Shown in UI, name provided to RegisterSkin used by default
-- [optional] size, size_highlight
-- [optional] row_spacing
-- [optional] frame_color_*, loot_color_* -- See above
-- [optional] color_mod - Multiplier for border quality colors
-- [optional] padding, padding_highlight - Padding refers to how far outward (or inward) the border should be offset from the frame

-- Tweaking Masque skins
-- To keep from having to change this file, call XLoot:RegisterMasqueTweak(skin_name, skin_table)
-- following the same rules as custom skins
-- Quick or temporary tweaks can be added to SKIN_TWEAKS.lua

-- Base skin template
lib.base = {
	bar_texture = [[Interface\AddOns\XLoot\Textures\bar]],
	color_mod = .75,
	row_spacing = 2,
}

-- Skin registration
function XLoot:RegisterSkin(skin_name, skin_table)
	setmetatable(skin_table, { __index = lib.base })
	skin_table.key = skin_name
	lib.skins[skin_name] = skin_table
end

-- Masque tweaks
function XLoot:RegisterMasqueTweak(masque_name, tweak_table)
	lib.masque_tweaks[masque_name] = tweak_table
	-- Apply to existing skins
	if lib.skins[masque_name] then
		for k, v in pairs(tweak_table) do
			lib.skins[masque_name][k] = v
		end
	end
end

-- Skinning
local function subtable_insert(t, k, v)
	if not t[k] then
		t[k] = {}
	end
	table.insert(t[k], v)
end

do
	local base = {
		padding = 2,
		size = 16,
		layer = 'ARTWORK',
		mode = 'BLEND',
		r = 1,
		g = 1,
		b = 1,
		a = 1
	}
	local types = {
		highlight = {
			mode = 'ADD',
			layer = 'HIGHLIGHT',
			texture = [[Interface\Buttons\ButtonHilight-Square]],
			size = 8,
			padding = 0,
			r = .8,
			g = .8,
			b = .8,
			a = .8
		}
	}

	local mt = {
		__index = function(t, k)
			local ttype = rawget(t, 'type')
			if ttype and types[ttype] and types[ttype][k] then
				return types[ttype][k]
			end
			return base[k] or nil
		end
	}

	local function meta(t)
		return setmetatable(t, mt)
	end

	local function update_borders(frame, options, borders, r, g, b, a)
		local padding = options.padding
		local size = options.size/2
		r = r or options.r
		g = g or options.g
		b = b or options.b
		a = a or options.a
		for pos, tex in ipairs(borders) do
			-- Set texture options
			tex:SetDrawLayer(options.layer)
			tex:SetTexture(options.texture)
			tex:SetBlendMode(options.mode)
			tex:SetWidth(size)
			tex:SetHeight(size)
			tex:SetVertexColor(r, g, b, a)

			-- Position texture
			tex:ClearAllPoints()
			if pos == 1 then
				tex:SetTexCoord(0, 1/6, 0, 1/6)
				tex:SetPoint("TOPLEFT", frame, "TOPLEFT", -padding, padding)
			elseif pos == 2 then
				tex:SetTexCoord(5/6, 1, 0, 1/6)
				tex:SetPoint("TOPRIGHT", frame, "TOPRIGHT", padding, padding)
			elseif pos == 3 then
				tex:SetTexCoord(0, 1/6, 5/6, 1)
				tex:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -padding, -padding)
			elseif pos == 4 then
				tex:SetTexCoord(5/6, 1, 5/6, 1)
				tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", padding, -padding)
			elseif pos == 5 then
				tex:SetTexCoord(1/6, 5/6, 0, 1/6)
				tex:SetPoint("TOPLEFT", borders[1], "TOPRIGHT")
				tex:SetPoint("TOPRIGHT", borders[2], "TOPLEFT")
			elseif pos == 6 then
				tex:SetTexCoord(1/6, 5/6, 5/6, 1)
				tex:SetPoint("BOTTOMLEFT", borders[3], "BOTTOMRIGHT")
				tex:SetPoint("BOTTOMRIGHT", borders[4], "BOTTOMLEFT")
			elseif pos == 7 then
				tex:SetTexCoord(0, 1/6, 1/6, 5/6)
				tex:SetPoint("TOPLEFT", borders[1], "BOTTOMLEFT")
				tex:SetPoint("BOTTOMLEFT", borders[3], "TOPLEFT")
			elseif pos == 8 then
				tex:SetTexCoord(5/6, 1, 1/6, 5/6)
				tex:SetPoint("TOPRIGHT", borders[2], "BOTTOMRIGHT")
				tex:SetPoint("BOTTOMRIGHT", borders[4], "TOPRIGHT")
			end
		end
	end

	local function create_borders(frame, options)
		local borders = { }
		for i = 1, 8 do
			borders[i] = frame:CreateTexture()
		end
		update_borders(frame, options, borders)
		return borders
	end

	local backdrop = {
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
		insets = {left = 3, right = 3, top = 3, bottom = 3},
	}

	local backdrop_empty = {
		bgFile = ''
	}

	local bd_color = { 0, 0, 0, .9 }
	local g_color = { .5, .5, .5, .6 }

	-- Frame methods
	-- https://www.wowace.com/projects/xloot/issues/205 is not reproducible, but user gets error reliably
	local alphaworks = false
	local function SetBorderColor(self, r, g, b, a)
		for i, x in pairs(self._skin_borders) do
			x:SetVertexColor(r, g, b, a or 1)
		end
	end

	local function GetBorderColor(self)
		return self._skin_borders[1]:GetVertexColor()
	end

	local function SetGradientColor(self, r, g, b, a)
		self.gradient:SetGradient('VERTICAL', CreateColor(0.1, 0.1, 0.1, 0), CreateColor(r, g, b, a))
	end

	function lib:Gradient(frame)
		local g = frame:CreateTexture(nil, 'BORDER')
		frame.gradient = g
		g:SetTexture([[Interface\ChatFrame\ChatFrameBackground]])
		g:SetPoint('TOPLEFT', 3, -3)
		g:SetPoint('BOTTOMRIGHT', -3, 3)
		-- g:SetBlendMode'ADD'
		frame.SetGradientColor = SetGradientColor
		frame:SetGradientColor(unpack(g_color))
	end

	function lib:Backdrop(frame, opt_backdrop)
		frame:SetBackdrop(opt_backdrop or backdrop)
		frame:SetBackdropColor(unpack(bd_color))
	end

	-- Lib methods
	-- Basic skin
	function lib:Skin(frame, options)
		-- Store options
		frame._skin_options = meta(options)

		-- Apply backdrop
		if options.backdrop ~= false then
			self:Backdrop(frame, type(options.backdrop) == 'table' and options.backdrop or nil)
		end

		-- Gradient
		if options.gradient ~= false then
			self:Gradient(frame)
		end

		-- Borders
		frame._skin_borders = create_borders(frame, options)
		frame.SetBorderColor = SetBorderColor
		frame.GetBorderColor = GetBorderColor
	end

	function lib:SkinRaw(frame, options)
		return create_borders(frame, meta(options)), SetBorderColor
	end

	function lib:UpdateSkin(frame, options, r, g, b, a)
		frame._skin_options = meta(options)
		update_borders(frame, options, frame._skin_borders, r, g, b, a)
	end

	-- Highlights
	local function ShowHighlight(self, status)
		for _, tex in ipairs(self._highlights) do
			tex:Show()
		end
	end

	local function HideHighlight(self)
		for _, tex in ipairs(self._highlights) do
			tex:Hide()
		end
	end

	local function SetHighlightColor(self, r, g, b, a)
		for _, tex in ipairs(self._highlights) do
			tex:SetVertexColor(r, g, b, a)
		end
	end

	local function GetHighlightColor(self)
		return self._highlights[1]:GetVertexColor()
	end

	local highlight = { type = 'highlight' }

	-- Add highlight borders to a frame
	function lib:Highlight(frame, options)
		-- Default options
		options = meta(options or highlight)

		frame._highlights = create_borders(frame, options)
		frame._higlight_options = options

		frame.ShowHighlight = ShowHighlight
		frame.HideHighlight = HideHighlight
		frame.SetHighlightColor = SetHighlightColor
		frame.GetHighlightColor = GetHighlightColor
		if options.layer ~= 'HIGHLIGHT' then
			frame:HideHighlight()
		end
	end

	function lib:UpdateHighlight(frame, options, r, g, b, a)
		frame._higlight_options = meta(options)
		update_borders(frame, options, frame._highlights, r, g, b, a)
	end
end


-- Create a subset of skins to be applied
do
	-- Merge current skin with set options
	local function compile(data, name)
		assert(data.sets[name], "Bad set name given to XLoot.Skin")
		-- Return cached
		if not data.compiled[name] then
			data.compiled[name] = {}
		elseif next(data.compiled[name]) then
			return data.compiled[name]
		end
		-- Generate to cache
		local out = data.compiled[name]
		local skin = (data.SKIN and lib.skins[data.SKIN]) and lib.skins[data.SKIN] or lib.current
		local set = data.sets[name]
		-- Copy defaults
		for k,v in pairs(lib.base) do
			out[k] = v
		end
		-- Copy skin data
		for k,v in pairs(skin) do
			out[k] = v
		end
		-- Extract data for highlights
		if skin.highlight
			and set.type
			and set.type == 'highlight'
			and type(skin.highlight) == 'table' then
			for k,v in pairs(skin.highlight) do
				out[k] = v
			end
			-- Highlights shouldn't inherit default texture
			if not skin.highlight.texture then
				out.texture = nil
			end
		end
		-- Apply set overrides
		for k,v in pairs(set) do
			out[k] = v
		end
		-- Apply metatable
		setmetatable(out, getmetatable(skin))
		return out
	end

	-- Re-compile and Re-apply all
	local function Reskin(self)
		local data = self._skin_data
		-- Clear cache
		for k,v in pairs(data.compiled) do
			wipe(v)
		end
		-- Update skins
		for set_name,frames in pairs(data.skinned) do
			for i,frame in ipairs(frames) do
				lib:UpdateSkin(frame, compile(data, set_name), frame:GetBorderColor())
			end
		end
		-- Update highlights
		for set_name,frames in pairs(data.highlighted) do
			for i,frame in ipairs(frames) do
				lib:UpdateHighlight(frame, compile(data, set_name), frame:GetHighlightColor())
			end
		end
		return compile(data, data.default or next(data.sets))
	end

	local function Skin(self, frame, set_name)
		local data = self._skin_data
		set_name = set_name or data.default
		local skin = compile(data, set_name)
		lib:Skin(frame, skin)
		subtable_insert(data.skinned, set_name, frame)
		return skin
	end

	local function Highlight(self, frame, set_name)
		local data = self._skin_data
		set_name = set_name or data.default
		lib:Highlight(frame, compile(data, set_name))
		subtable_insert(data.highlighted, set_name, frame)
	end

	-- Embed required functions and create data set to skin multiple similar frames
	XLoot.skinners = {}
	function XLoot:MakeSkinner(target, sets, default_set)
		if not default_set and not sets.default then
			sets.default = {}
		end
		target._skin_data = {
			skinned = {},
			highlighted = {},
			compiled = {},
			sets = sets,
			default = default_set or "default"
		}
		target.Reskin = Reskin
		target.Skin = Skin
		target.Highlight = Highlight
		table.insert(XLoot.skinners, target)
		return target
	end
end

-------------------------------------------------------------------------------
-- Default skins
local svelte = {
	name = ('|c2244dd22%s|r'):format(L.skin_svelte),
	texture = [[Interface\AddOns\XLoot\Textures\border_svelte]],
}
local legacy = {
	name = ('|c2244dd22%s|r'):format(L.skin_legacy),
	row_spacing = 3,
	texture = [[Interface\AddOns\XLoot\Textures\border_legacy]],
	size = 16,
	highlight = {
		size = 12
	},
	color_mod = .85,
}
local smooth = {
	name = ('|c2244dd22%s|r'):format(L.skin_smooth),
	row_spacing = 3,
	texture = [[Interface\AddOns\XLoot\Textures\border_smooth]],
	size = 14,
	padding = 1,
	highlight = {
		size = 6,
		padding = -1
	},
	color_mod = .9,
}

-- Register default skins
XLoot:RegisterSkin('svelte', svelte)
XLoot:RegisterSkin('legacy', legacy)
XLoot:RegisterSkin('smooth', smooth)

-------------------------------------------------------------------------------
-- Index Masque skins later so we definitely catch all of them

function XLoot:SkinsOnInitialize()
	-- Masque skins
	local Masque = LibStub('Masque', true) or LibStub('LibButtonFacade', true)
	if Masque and Masque.GetSkins then
		-- Add available skins
		local Masque_Skins = Masque:GetSkins()
		if type(Masque_Skins) == 'table' then
			for k, v in pairs(Masque_Skins) do
				if k ~= 'Blizzard' and v.Normal.Texture then
					local skin = { }
					-- Guess at dimensions
					if v.Icon.Height and v.Normal.Height then
						skin.padding = (v.Normal.Height - v.Icon.Height) / 4
						skin.row_spacing = v.Icon.Height / 16
						skin.size = v.Icon.Height / 2
					end
					skin.texture = v.Normal.Texture
					skin.name = ('|c22dddd22Masque:|r %s'):format(k)
					-- Apply existing tweak
					if lib.masque_tweaks[k] then
						for mk,mv in pairs(lib.masque_tweaks[k]) do
							skin[mk] = mv
						end
					end
					-- Register
					XLoot:RegisterSkin(k, skin)
				end
			end
		else -- Warn about outdated Masque
			print("XLoot: Use of masque skins requires the beta version of Masque.")
		end
	end

	XLoot:ApplySkinTweaks()

	-- Activate current skin
	self:SetSkin(self.db.profile.skin)
end

-------------------------------------------------------------------------------
-- Skin access

function XLoot:SetSkin(name)
	lib.current = lib.skins[lib.skins[name] and name or 'smooth']
end

