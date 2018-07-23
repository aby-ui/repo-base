--===================================================
-- 一些默认界面为了适应全lua脚本方式, 需要进行一些Hook和修改
--===================================================
---由于脚本创建template对象时，Create一调用就会执行OnLoad，所以只能重新整理
hooksecurefunc("MagicButton_OnLoad", function(self)
	local leftHandled = false;
	local rightHandled = false;

	for i=1, self:GetNumPoints() do
		local point, relativeTo, relativePoint, offsetX, offsetY = self:GetPoint(i);
		if (relativeTo:GetObjectType() == "Button" and (point == "TOPLEFT" or point == "LEFT")) then
			leftHandled = true;
		elseif (relativeTo:GetObjectType() == "Button" and (point == "TOPRIGHT" or point == "RIGHT")) then
			rightHandled = true;
		elseif (point == "BOTTOMLEFT") then
			leftHandled = true;
		elseif (point == "BOTTOMRIGHT") then
			rightHandled = true;
		end
	end

    if (leftHandled and self.LeftSeparator) then self.LeftSeparator:Hide() end

	if (rightHandled and self.RightSeparator) then self.RightSeparator:Hide() end
end)