local AddonName, NS = ...

local Interface = NS.Interface

local LibStub = LibStub

RaidFadeEvenMore = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceEvent-3.0")

function RaidFadeEvenMore:PLAYER_ENTERING_WORLD()
  Interface:Initialize()
end

function RaidFadeEvenMore:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New(AddonName .. "DB", NS.DefaultDatabase, true)
  self:SetupOptions()
end

function RaidFadeEvenMore:OnEnable()
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
end
