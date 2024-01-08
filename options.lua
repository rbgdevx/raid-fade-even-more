local AddonName, NS = ...

local LibStub = LibStub
local CopyTable = CopyTable

local RaidFadeEvenMore = LibStub("AceAddon-3.0"):GetAddon(AddonName)

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    background = {
      name = "Also Lower Background Texture Opacity",
      desc = "This makes the entire raid frames see-through essentially",
      type = "toggle",
      width = "double",
      order = 0,
      set = function(_, val)
        RaidFadeEvenMore.db.global.background = val
        NS.Interface:RefreshFrames()
      end,
      get = function(_)
        return RaidFadeEvenMore.db.global.background
      end,
    },
    alpha = {
      name = "Alpha",
      desc = "Sets the out of range alpha value",
      type = "range",
      width = "double",
      min = 0,
      max = 1,
      step = 0.01,
      order = 1,
      set = function(_, val)
        RaidFadeEvenMore.db.global.alpha = val
        NS.Interface:RefreshFrames()
      end,
      get = function(_)
        return RaidFadeEvenMore.db.global.alpha
      end,
    },
    spacing1 = { type = "description", order = 2, name = " " },
    reset = {
      name = "Reset",
      type = "execute",
      width = "half",
      order = 3,
      func = function()
        RaidFadeEvenMoreDB = CopyTable(NS.DefaultDatabase)
        RaidFadeEvenMore.db = RaidFadeEvenMoreDB
        NS.Interface:RefreshFrames()
      end,
    },
  },
}

function RaidFadeEvenMore:SetupOptions()
  LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, NS.AceConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(AddonName, AddonName)
end
