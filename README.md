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



## Usage

* coming soon



## Documentation

* `brew install coreutils`



## Open Issues

* dps class rotations
* heal class support (maybe in a seperate addon...)
* a lot more...



## Commands

* coming soon




## Unsupported Builds and Classes

All unsupported except warlock destruction



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



