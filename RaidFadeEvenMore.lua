local _, NS = ...

---@type RaidFadeEvenMore
local RaidFadeEvenMore = NS.RaidFadeEvenMore
local RaidFadeEvenMoreFrame = NS.RaidFadeEvenMore.frame

local Interface = NS.Interface

function RaidFadeEvenMore:PLAYER_ENTERING_WORLD()
  Interface:Initialize()
end

function RaidFadeEvenMore:PLAYER_LOGIN()
  RaidFadeEvenMoreFrame:UnregisterEvent("PLAYER_LOGIN")
  RaidFadeEvenMoreFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
RaidFadeEvenMoreFrame:RegisterEvent("PLAYER_LOGIN")
