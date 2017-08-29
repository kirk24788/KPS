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
kps.lastTarget = nil
kps.lastTargetGUID = nil
kps.autoAttackEnabled = false

-- Cast Sequence Settings
kps.maxCastSequenceLength = 10


--[[

ps ax|grep Warcraft|grep -v grep

echo -e "process attach -p `ps ax|grep Warcraft|grep -v grep|awk '{print $1}'`\nmemory write 0x100a1931a 0xeb\nprocess detach\nquit" > /tmp/luaunlock && lldb -s /tmp/luaunlock

echo -e "process attach -p `ps ax|grep 'MacOS/World of Warcraft'|grep -v grep|awk '{print $1}'`\nmemory write 0x100a1931a 0xeb\nprocess detach\nquit" > /tmp/luaunlock && lldb -s /tmp/luaunlock

——————————————————————————————————————————————————————

x64 build 24742 (7.2.5)

0000000100bf6d1c         lea        rax, qword [ds:0x101e578b8]
0000000100bf6d23         cmp        qword [ds:rax], 0x0
0000000100bf6d27         je         0x100bf6d94
0000000100bf6d29         cmp        ebx, 0x2b
0000000100bf6d2c         ja         0x100bf6d94

echo -e "process attach -p `ps ax|grep 'MacOS/World of Warcraft'|grep -v grep|awk '{print $1}'`\nmemory write 0x100bf6d2c 0xeb\nprocess detach\nquit" > /tmp/luaunlock && lldb -s /tmp/luaunlock

]]
