--[[[
@module KPS Initialization
@description
KPS Initialization
]]--

kps = {}

kps.env = {}
kps.env.kps = kps
kps.env.spells = {}

-- Toggles
kps.enabled = false
kps.cooldowns = false
kps.interrupt = false
kps.defensive = false
kps.multiTarget = false

-- Spell Info - will be updated after each spell cast
kps.gcd = 1.5
kps.lastCast = nil
kps.lastTargetGUID = nil
kps.autoAttackEnabled = false

-- Cast Sequence Settings
kps.maxCastSequenceLength = 10
