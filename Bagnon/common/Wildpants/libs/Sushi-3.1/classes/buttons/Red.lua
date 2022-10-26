--[[
Copyright 2008-2022 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local Red = LibStub('Sushi-3.1').TextedClickable:NewSushi('RedButton', 1, 'Button', 'UIPanelButtonNoTooltipTemplate', true)
if not Red then return end

Red.WidthOff = 20
Red.bottom = 5
Red.right = 11
Red.left = 11
