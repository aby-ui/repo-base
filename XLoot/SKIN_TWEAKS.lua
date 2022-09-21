function XLoot:ApplySkinTweaks()
	XLoot:RegisterMasqueTweak('LiteStep', { size = 16, padding = 0 })
	XLoot:RegisterMasqueTweak('LiteStep - XLT', { size = 16, padding = 0 })
	XLoot:RegisterMasqueTweak('simpleSquare', { size = 12, row_spacing = 4 })
	XLoot:RegisterMasqueTweak('Caith', { size = 12, row_spacing = 4 })
	XLoot:RegisterMasqueTweak('Svelte Shadow', { size = 14 })
	XLoot:RegisterMasqueTweak('Square Shadow', { size = 16 })
	XLoot:RegisterMasqueTweak('Darion', { size = 10, row_spacing = 2, padding = 0 })
	XLoot:RegisterMasqueTweak('Darion Clean', { size = 10, row_spacing = 2, padding = 0 })
	-- I suggest you add your own addon which depends on XLoot and
	-- add your tweaks there, however you can do it by hand here.
	-- See the reference at the top of skins.lua
	-- XLoot:RegisterMasqueTweak('', { })
end
