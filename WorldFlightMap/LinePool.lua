---- LINE POOL ----
-- copy/pasta of TexturePoolMixin, just for lines

local LinePoolMixin = CreateFromMixins(ObjectPoolMixin)
local function LinePoolFactory(linePool)
	return linePool.parent:CreateLine(nil, linePool.layer, linePool.textureTemplate, linePool.subLayer)
end

function LinePoolMixin:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc)
	ObjectPoolMixin.OnLoad(self, LinePoolFactory, resetterFunc)
	self.parent = parent
	self.layer = layer
	self.subLayer = subLayer
	self.textureTemplate = textureTemplate
end

--[[ global ]] function CreateLinePool(parent, layer, subLayer, textureTemplate, resetterFunc)
	local linePool = CreateFromMixins(LinePoolMixin)
	linePool:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc or FramePool_Hide)
	return linePool
end
