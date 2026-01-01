local _, NS = ...

local CreateFrame = CreateFrame

---@class DBTable : table
---@field alpha number
---@field background boolean

---@class RaidFadeEvenMore
---@field ADDON_LOADED function
---@field PLAYER_LOGIN function
---@field PLAYER_ENTERING_WORLD function
---@field SlashCommands function
---@field frame Frame
---@field db DBTable

---@type RaidFadeEvenMore
---@diagnostic disable-next-line: missing-fields
local RaidFadeEvenMore = {}
NS.RaidFadeEvenMore = RaidFadeEvenMore

local RaidFadeEvenMoreFrame = CreateFrame("Frame", "RaidFadeEvenMoreFrame")
RaidFadeEvenMoreFrame:SetScript("OnEvent", function(_, event, ...)
  if RaidFadeEvenMore[event] then
    RaidFadeEvenMore[event](RaidFadeEvenMore, ...)
  end
end)
NS.RaidFadeEvenMore.frame = RaidFadeEvenMoreFrame

NS.DefaultDatabase = {
  alpha = 0.2,
  background = false,
}
