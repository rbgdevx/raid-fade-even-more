local _, NS = ...

local Interface = {}
NS.Interface = Interface

local GetNumGroupMembers = GetNumGroupMembers
local strsub = strsub
local hooksecurefunc = hooksecurefunc

local initialized = false

local function getDesiredAlpha()
  local db = NS and NS.db and NS.db
  return (db and db.alpha) or 0.3
end

local function backgroundFollows()
  local db = NS and NS.db and NS.db
  return db and db.background
end

-- Party/Raid-only filter by unit prefix
local group = { part = true, raid = true }
-- local EPS = 0.001

local function primeIgnoreParentAlpha(frame)
  if frame and frame.SetIgnoreParentAlpha then
    frame:SetIgnoreParentAlpha(true)
  end
end

-- Reapply our alpha mapping WITHOUT calling CompactUnitFrame_UpdateInRange
local function remapAlpha(frame)
  if not frame or not frame.displayedUnit then
    return
  end

  -- Only handle party/raid units
  local prefix = strsub(frame.displayedUnit, 1, 4)
  if not group[prefix] then
    return
  end

  -- Ensure parents don't multiply our alpha
  primeIgnoreParentAlpha(frame)
  primeIgnoreParentAlpha(frame.background)

  -- During roster churn (join/leave) CompactUnitFrames can exist briefly with unitExists=false,
  -- and Blizzard may not have populated inRange/outOfRange yet. Never pass nil to SetAlphaFromBoolean.
  local desiredAlpha = getDesiredAlpha()
  if frame.inRange ~= nil then
    -- Prefer inRange if present (can be boolean or a "secret" value).
    -- We want: in-range => 1, out-of-range => desiredAlpha.
    frame:SetAlphaFromBoolean(frame.inRange, 1, desiredAlpha)
  elseif frame.outOfRange ~= nil then
    -- Fallback: outOfRange is usually a boolean.
    frame:SetAlphaFromBoolean(frame.outOfRange, desiredAlpha, 1)
  else
    return
  end

  if frame.background then
    if backgroundFollows() then
      if frame.inRange ~= nil then
        frame.background:SetAlphaFromBoolean(frame.inRange, 1, desiredAlpha)
      elseif frame.outOfRange ~= nil then
        frame.background:SetAlphaFromBoolean(frame.outOfRange, desiredAlpha, 1)
      end
    else
      frame.background:SetAlpha(1)
    end
  end
end

-- When settings sliders change, just reapply to existing frames
function Interface:RefreshFrames()
  for i = 1, 40 do -- Iterate through potential raid frames (up to 40)
    local frame = _G["CompactRaidFrame" .. i]
    if frame then
      remapAlpha(frame)
    end
  end
  for i = 1, GetNumGroupMembers() do -- Iterate through party frames (up to 4)
    local frame = _G["CompactPartyFrameMember" .. i]
    if frame then
      remapAlpha(frame)
    end
  end
end

function Interface:Initialize()
  if initialized then
    return
  end
  initialized = true

  -- Hook the central function where Blizzard calls frame:SetAlpha().
  -- Cannot override CompactUnitFrame_GetRangeAlpha because replacing a global
  -- taints the execution context, and boolean tests on secret values (outOfRange)
  -- error in tainted code. hooksecurefunc is safe — it runs after the original.
  -- This catches ALL code paths: UNIT_PHASE, UNIT_FLAGS, INCOMING_RESURRECT_CHANGED,
  -- UNIT_OTHER_PARTY_CHANGED, INCOMING_SUMMON_CHANGED, UpdateDistance, etc.
  if CompactUnitFrame_UpdateCenterStatusIcon then
    hooksecurefunc("CompactUnitFrame_UpdateCenterStatusIcon", function(frame)
      remapAlpha(frame)
    end)
  end

  -- Run AFTER Blizzard updates alpha, then remap it to our desired value.
  hooksecurefunc("CompactUnitFrame_UpdateInRange", function(frame)
    if not frame or not frame.optionTable or not frame.optionTable.fadeOutOfRange then
      return
    end
    remapAlpha(frame)
  end)

  -- Also react to general "update all":
  if CompactUnitFrame_UpdateAll then
    hooksecurefunc("CompactUnitFrame_UpdateAll", remapAlpha)
  end
end
