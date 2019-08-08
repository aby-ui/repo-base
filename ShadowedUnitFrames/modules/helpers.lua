-- Block Timers
local BlockTimers = {}
function BlockTimers:Inject(module, event)
	ShadowUF.Tags.customEvents["SUF_" .. event] = module
	module.EnableTag = BlockTimers.EnableTag
	module.DisableTag = BlockTimers.DisableTag
end

function BlockTimers:EnableTag(frame, fontString)
	fontString.block.fontString = fontString
end

function BlockTimers:DisableTag(frame, fontString)
	fontString.block.fontString = nil
end


ShadowUF.BlockTimers = BlockTimers;

-- Dynamic Blocks
local DynamicBlocks = {}
function DynamicBlocks:Inject(module)
	module.OnLayoutWidgets = function(_, frame)
		if( not frame.visibility[module.moduleKey] or not frame[module.moduleKey].blocks) then return end

		local height = frame[module.moduleKey]:GetHeight()
		for _, block in pairs(frame[module.moduleKey].blocks) do
			block:SetHeight(height)
		end
	end
end

ShadowUF.DynamicBlocks = DynamicBlocks
