local AddonName, NS = ...

local LibStub = LibStub
local CopyTable = CopyTable
local next = next

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

---@type RaidFadeEvenMore
local RaidFadeEvenMore = NS.RaidFadeEvenMore
local RaidFadeEvenMoreFrame = NS.RaidFadeEvenMore.frame

local Options = {}
NS.Options = Options

NS.AceConfig = {
  name = AddonName,
  type = "group",
  args = {
    background = {
      name = "Also Lower Background Texture Opacity",
      desc = "This makes the entire raid frames see-through essentially",
      type = "toggle",
      width = "double",
      order = 1,
      set = function(_, val)
        NS.db.global.background = val
        NS.Interface:RefreshFrames()
      end,
      get = function(_)
        return NS.db.global.background
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
      order = 2,
      set = function(_, val)
        NS.db.global.alpha = val
        NS.Interface:RefreshFrames()
      end,
      get = function(_)
        return NS.db.global.alpha
      end,
    },
    spacing1 = { type = "description", order = 3, name = " " },
    debug = {
      name = "Toggle debug mode",
      desc = "Turning this feature on prints debug messages to the chat window.",
      type = "toggle",
      width = "full",
      order = 99,
      set = function(_, val)
        NS.db.global.debug = val
      end,
      get = function(_)
        return NS.db.global.debug
      end,
    },
    reset = {
      name = "Reset Everything",
      type = "execute",
      width = "normal",
      order = 100,
      func = function()
        RaidFadeEvenMoreDB = CopyTable(NS.DefaultDatabase)
        NS.db = RaidFadeEvenMoreDB
        NS.Interface:RefreshFrames()
      end,
    },
  },
}

function Options:SlashCommands(_)
  AceConfigDialog:Open(AddonName)
end

function Options:Setup()
  AceConfig:RegisterOptionsTable(AddonName, NS.AceConfig)
  AceConfigDialog:AddToBlizOptions(AddonName, AddonName)

  SLASH_RFEM1 = AddonName
  SLASH_RFEM2 = "/rfem"

  function SlashCmdList.RFEM(message)
    self:SlashCommands(message)
  end
end

function RaidFadeEvenMore:ADDON_LOADED(addon)
  if addon == AddonName then
    RaidFadeEvenMoreFrame:UnregisterEvent("ADDON_LOADED")

    RaidFadeEvenMoreDB = RaidFadeEvenMoreDB and next(RaidFadeEvenMoreDB) ~= nil and RaidFadeEvenMoreDB or {}

    -- Copy any settings from default if they don't exist in current profile
    NS.CopyDefaults(NS.DefaultDatabase, RaidFadeEvenMoreDB)

    -- Reference to active db profile
    -- Always use this directly or reference will be invalid
    NS.db = RaidFadeEvenMoreDB

    -- Remove table values no longer found in default settings
    NS.CleanupDB(RaidFadeEvenMoreDB, NS.DefaultDatabase)

    Options:Setup()
  end
end
RaidFadeEvenMoreFrame:RegisterEvent("ADDON_LOADED")
