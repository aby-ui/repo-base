--[[
--        LibRevision.lua
--           Finds the revisions of a given addon and works out the version.
--           Written by Ken Allan <ken@norganna.org>
--           This code is hereby released into the Public Domain without warranty.
--
--        Usage:
--           local libRevision = LibStub("LibRevision")
--
--           libRevision:Set("svnUrl", "svnRev", "5.1.DEV.", ...)
--           libRevision:Get("addon")
--]]

local LIBRARY_VERSION_MAJOR = "LibRevision"
local LIBRARY_VERSION_MINOR = 3

local lib = LibStub:NewLibrary(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR)
if not lib then return end

if not lib.versions then
	lib.versions = {}
end

function lib:Get(addon)
	return lib.versions[addon:lower()]
end

function lib:Set(url, revision, dev, ...)
	local repo,file
	if not (url and revision) then return end

	local n = select("#", ...)
	for i=1, n do
		local sub = select(i, ...)
		repo, file = url:match("%$URL: .*/("..sub..")/([^%$]+) %$")
		if repo then break end
	end
	local rev = tonumber(revision:match("(%d+)")) or 0

	if repo then
		local branch,name = file:match("^(trunk)/([^/]+)/")
		if not branch then
			branch,name = file:match("^branches/([^/]+)/([^/]+)/")
		end

		if branch then
			local embed, addition
			local addon = name:lower()

			local vaddon = lib.versions[addon]
			if not vaddon then
				vaddon = {}
				lib.versions[addon] = vaddon
			end

			local vrev = max(vaddon['x-revision'] or 0, rev)

			local ver = GetAddOnMetadata(addon, "Version")
			if not ver or ver:sub(0,2) == "<%" then
				ver = (dev or "DEV.")..vrev
				if branch ~= "trunk" then -- if a DEV side branch, add to additional info
					addition = branch
				end
			end

			if not IsAddOnLoaded(addon) then
				embed = true
				addition = (addition or "").."/embedded"
			end

			if not vaddon["x-revisions"] then
				vaddon["x-revisions"] = {}
			end

			vaddon.name = name
			vaddon.version = ver
			vaddon["x-branch"] = branch
			vaddon["x-revision"] = vrev
			vaddon["x-revisions"][file] = rev
			vaddon["x-embedded"] = embed
			vaddon["x-swatter-extra"] = addition

			if SetAddOnDetail then
				SetAddOnDetail(name, vaddon)
			end

			return vaddon, file, rev
		end
	end
end
