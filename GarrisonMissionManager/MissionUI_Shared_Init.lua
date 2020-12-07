local addon_name, addon_env = ...
if not addon_env.load_this then return end

local pending_init = {}

local function TryAllPendinigInit()
   for base_frame_name, options in pairs(pending_init) do
      local init = options.init
      if _G[base_frame_name] then
         init(options)
         pending_init[base_frame_name] = nil
      end
   end
end

function addon_env.AddInitUI(gmm_options)
   local follower_type = gmm_options.follower_type
   local options = GarrisonFollowerOptions[follower_type]

   gmm_options.base_frame_name = options.missionFrame
   -- TODO: combine into single function function
   addon_env.InitGMMFollowerOptions(gmm_options)

   pending_init[gmm_options.base_frame_name] = gmm_options

   return TryAllPendinigInit()
end
