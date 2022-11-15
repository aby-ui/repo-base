

local AddonName, Data = ...

Data.Templates = Data.Templates or {}
Data.Templates.SelectorTemplate = function(parent)
	local frame = CreateFrame("frame", nil, parent)
	Mixin(frame, Data.Mixins.BackportedSelectorMixin)
	frame.templateType = "BUTTON"
	--frame.buttonTemplate = "SelectorButtonTemplate" --todo, this requires SelectorButtonTemplate to be a defined XML template which we can't to since this is a library and we throw errors if the same xml template gets definned multiple times
	frame.buttonTemplate = nil
	return frame
end
