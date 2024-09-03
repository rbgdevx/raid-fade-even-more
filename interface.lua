local _, NS = ...

local Interface = {}
NS.Interface = Interface

local UnitInRange = UnitInRange
local GetNumGroupMembers = GetNumGroupMembers
local strsub = strsub
local hooksecurefunc = hooksecurefunc

local group = {
  part = true, -- party, only check char 1 to 4
  raid = true,
}

-- ever since the UNIT_IN_RANGE_UPDATE event we need to update the frames
-- when the slider options are changed for visual feedback
function Interface:RefreshFrames()
  for i = 1, GetNumGroupMembers() do
    local frame = _G["CompactRaidFrame" .. i]
    if frame and frame.displayedUnit then
      CompactUnitFrame_UpdateInRange(frame)

      if NS.db.global.background == false then
        frame.background:SetAlpha(1)
      end
    end
  end
end

function Interface:Initialize()
  --[Change Raid Frame OOR Fade/Alpha Transparency]
  hooksecurefunc("CompactUnitFrame_UpdateInRange", function(frame)
    if not frame.optionTable.fadeOutOfRange then
      return
    end

    -- ignore player, nameplates
    if not group[strsub(frame.displayedUnit, 1, 4)] then
      return
    end

    local inRange, checkedRange = UnitInRange(frame.displayedUnit)

    if checkedRange and not inRange then
      frame:SetAlpha(NS.db.global.alpha)

      if NS.db.global.background then
        frame.background:SetAlpha(NS.db.global.alpha)
      end
    else
      frame:SetAlpha(1)
      frame.background:SetAlpha(1)
    end
  end)
end
