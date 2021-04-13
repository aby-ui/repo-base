DFPixelUtil = {};

function DFPixelUtil.GetPixelToUIUnitFactor()
	local physicalWidth, physicalHeight = GetPhysicalScreenSize();
	return 768.0 / physicalHeight;
end

function DFPixelUtil.GetNearestPixelSize(uiUnitSize, layoutScale, minPixels)
	if uiUnitSize == 0 and (not minPixels or minPixels == 0) then
		return 0;
	end

	local uiUnitFactor = DFPixelUtil.GetPixelToUIUnitFactor();
	local numPixels = Round((uiUnitSize * layoutScale) / uiUnitFactor);
	local rawNumPixels = numPixels;
	if minPixels then
		if uiUnitSize < 0.0 then
			if numPixels > -minPixels then
				numPixels = -minPixels;
			end
		else
			if numPixels < minPixels then
				numPixels = minPixels;
			end
		end
	end

	return numPixels * uiUnitFactor / layoutScale;
end

function DFPixelUtil.SetWidth(region, width, minPixels)
	region:SetWidth(DFPixelUtil.GetNearestPixelSize(width, region:GetEffectiveScale(), minPixels));
end

function DFPixelUtil.SetHeight(region, height, minPixels)
	region:SetHeight(DFPixelUtil.GetNearestPixelSize(height, region:GetEffectiveScale(), minPixels));
end

function DFPixelUtil.SetSize(region, width, height, minWidthPixels, minHeightPixels)
	DFPixelUtil.SetWidth(region, width, minWidthPixels);
	DFPixelUtil.SetHeight(region, height, minHeightPixels);
end

function DFPixelUtil.SetPoint(region, point, relativeTo, relativePoint, offsetX, offsetY, minOffsetXPixels, minOffsetYPixels)
	region:SetPoint(point, relativeTo, relativePoint, 
		DFPixelUtil.GetNearestPixelSize(offsetX, region:GetEffectiveScale(), minOffsetXPixels), 
		DFPixelUtil.GetNearestPixelSize(offsetY, region:GetEffectiveScale(), minOffsetYPixels)
	);
end

function DFPixelUtil.SetStatusBarValue(statusBar, value)
	local width = statusBar:GetWidth();
	if width and width > 0.0 then
		local min, max = statusBar:GetMinMaxValues();
		local percent = ClampedPercentageBetween(value, min, max);
		if percent == 0.0 or percent == 1.0 then
			statusBar:SetValue(value);
		else
			local numPixels = DFPixelUtil.GetNearestPixelSize(statusBar:GetWidth() * percent, statusBar:GetEffectiveScale());
			local roundedValue = Lerp(min, max, numPixels / width);
			statusBar:SetValue(roundedValue);
		end
	else
		statusBar:SetValue(value);
	end
end
