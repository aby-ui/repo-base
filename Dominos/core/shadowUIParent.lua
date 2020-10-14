-- The Shadow UI Parent is just a hidden frame with the same dimensions as the
-- UIParent. We use this as a central place for hiding frames, as there are
-- several bits of the UI that we cannot just call Frame:Hide() on without
-- affecting other parts of logic for them

local _, Addon = ...

local ShadowUIParent = Addon:CreateHiddenFrame('Frame', nil, UIParent)

ShadowUIParent:SetAllPoints(UIParent)

Addon.ShadowUIParent = ShadowUIParent
