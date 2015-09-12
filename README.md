# KPS
_JUST ANOTHER PLUA ADDON FOR WORLD OF WARCRAFT_

This addon in combination with enabled protected LUA will help you get the most
out of your WoW experience. This addon is based on JPS with a lot of refactoring
to clean up the codebase which has grown a lot in the last 4 years.

The main goal is to have a clean and fast codebase to allow further development.

*Huge thanks to jhtordeux for his contributions to KPS!*

*Thanks to jp-ganis, htordeux, nishikazuhiro, hax mcgee, pcmd
and many more for all their contributions to the original JPS!*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Copyright (C) 2015 Mario Mancino


## Commands

 * `/kps` - Show enabled status.
 * `/kps enable/disable/toggle` - Enable/Disable the addon.
 * `/kps cooldowns/cds` - Toggle use of cooldowns.
 * `/kps pew` - Spammable macro to do your best moves, if for some reason you don't want it fully automated.
 * `/kps interrupt/int` - Toggle interrupting.
 * `/kps multitarget/multi/aoe` - Toggle manual MultiTarget mode.
 * `/kps defensive/def` - Toggle use of defensive cooldowns.
 * `/kps help` - Show this help text.




## Builds and Classes

All healing specs except for druid restoration are currently without a rotation. All DPS Specs have at least one rotation automatically generated
from SimCraft - those might not be fully functional. 

**Supported in 6.2.2:**

 * Deathknight: Blood
 * Druid: Restoration
 * Paladin: Retribution
 * Warlock: Destruction



##  Development
If you want to help developing this AddOn, you are welcome, but there a few rules to make sure KPS is maintable.


### Prerequisites
If you don't have it yet please install Brew (http://brew.sh) and run `brew install coreutils` in a terminal to
make sure you have gtimeout (required for automated testing).
You also have to install the Command Line Utils to for `make` and of course you need to have LUA installed (also available via brew!).

If you don't have a Mac, you somehow have to provide these tools:

* gtimeout (gnu timeout)
* python (at least 2.6)
* make


### Pull Requests
Before creating a pull request, please run a `make test` in your KPS directory - only create the request if *ALL* tests
are OK!

### Code Guidelines
* Use 4 spaces for indentation - *NO TABS!*


### Open Issues
* missing dps class rotations


