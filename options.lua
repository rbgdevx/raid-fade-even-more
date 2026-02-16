local AddonName, NS = ...

local next = next

---@type RaidFadeEvenMore
local RaidFadeEvenMore = NS.RaidFadeEvenMore
local RaidFadeEvenMoreFrame = NS.RaidFadeEvenMore.frame

local Options = {}
NS.Options = Options

function Options:SlashCommands(_)
  Settings.OpenToCategory(NS.settingsCategory:GetID())
end

local function OnSettingChanged(_setting, _value)
  local _key = _setting:GetVariable()
  RaidFadeEvenMoreDB[_key] = _value

  NS.Interface:RefreshFrames()
end

function Options:Setup()
  local category = Settings.RegisterVerticalLayoutCategory("Raid Fade Even More")
  Settings.RegisterAddOnCategory(category)
  NS.settingsCategory = category

  do
    local key = "alpha"
    local defaultValue = NS.DefaultDatabase[key]
    local min = 0.05
    local max = 1.0
    local step = 0.05

    local setting = Settings.RegisterAddOnSetting(
      category,
      "alpha",
      key,
      RaidFadeEvenMoreDB,
      Settings.VarType.Number,
      "Alpha",
      defaultValue
    )
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Sets the in/out of range alpha value"
    local options = Settings.CreateSliderOptions(min, max, step)
    -- options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
      return string.format("%.2f", value)
    end)
    Settings.CreateSlider(category, setting, options, tooltip)
  end

  do
    local key = "background"
    local defaultValue = NS.DefaultDatabase[key]

    -- categoryTbl, variable, variableKey, variableTbl, variableType, name, defaultValue
    local setting = Settings.RegisterAddOnSetting(
      category,
      "background",
      key,
      RaidFadeEvenMoreDB,
      "boolean",
      "Include Background Alpha",
      defaultValue
    )
    setting:SetValueChangedCallback(OnSettingChanged)

    local tooltip = "Also lowers the background alpha"
    Settings.CreateCheckbox(category, setting, tooltip)
  end

  SLASH_RFEM1 = "/raidfadeevenmore"
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
