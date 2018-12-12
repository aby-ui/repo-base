local _,L = ...
local rematch = Rematch
local panel = RematchMiniQueue
local settings, queue

rematch:InitModule(function()
	settings = RematchSettings
	queue = settings.LevelingQueue
	rematch.MiniQueue = panel

	panel.Top.QueueButton:SetText(L["Queue"])

	panel.Status.Clear.tooltipTitle = rematch.QueuePanel.Status.Clear.tooltipTitle
	panel.Status.Clear.tooltipBody = rematch.QueuePanel.Status.Clear.tooltipBody
end)

function panel:Update()
	panel:UpdateStatus()
	rematch.QueuePanel.List:Update()
end

function panel:UpdateStatus()
	local active,form = settings.QueueActiveSort, "%s%d"
	panel.Status.Clear:SetShown(active)
	panel.Status.Icon:SetShown(active)
	if active then
		panel.Status.Text:SetPoint("RIGHT",-44,0)
		panel.Status.Icon:SetTexture(rematch.QueuePanel.sortInfo[settings.QueueSortOrder][1])
	else
		if not rematch.localeSquish then
			form = L["Pets: %s%d"]
		end
		panel.Status.Text:SetPoint("RIGHT",-8,0)
	end
	panel.Status.Text:SetText(format(form,rematch.hexWhite,#queue))
end

-- steals the queue's DropButton and List when miniqueue shown and returns it when hidden
function panel:OnShow()
	rematch.QueuePanel.List:SetParent(self)
	rematch.QueuePanel.List:SetPoint("TOPLEFT",panel.Status,"BOTTOMLEFT")
	rematch.QueuePanel.List:SetPoint("BOTTOMRIGHT")
	rematch.QueuePanel.DropButton:SetParent(self)
end
function panel:OnHide()
	rematch.QueuePanel.DropButton:SetParent(rematch.QueuePanel)
	rematch.QueuePanel.List:SetParent(rematch.QueuePanel)
	rematch.QueuePanel.List:SetPoint("TOPLEFT",rematch.QueuePanel.Top,"BOTTOMLEFT",0,-2)
	rematch.QueuePanel.List:SetPoint("BOTTOMRIGHT",rematch.QueuePanel,"BOTTOMRIGHT")
end

