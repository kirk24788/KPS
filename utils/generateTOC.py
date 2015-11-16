#!/usr/bin/env python
import os
import re
from config import INTERFACE_VERSION

# ****************************************************************
# * Checks Common Rotation Files for outdated and duplicate Spells
# ****************************************************************

TITLE = "KPS Addon"
NOTES = "Karnofsky Performance System"
SAVED_VARIABLES = ""
SAVED_VARIABLES_PER_CHAR = "KPS_SETTINGS"
DEPENDENCIES = ""


print "## Interface: %s" % INTERFACE_VERSION
print "## Title: |cffff8000%s" % TITLE
print "## Notes: %s" % NOTES
print "## SavedVariables: %s" % SAVED_VARIABLES
print "## Dependencies: %s" % DEPENDENCIES
print "## SavedVariablesPerCharacter: %s" % SAVED_VARIABLES_PER_CHAR
print ""

for line in open(os.path.dirname(os.path.abspath(__file__))+"/../_test.lua").read().split("\n"):
    match = re.match(r'^require\(\"(.*)\"\).*', line)
    if match:
        requirement = match.group(1)
        luaFile = requirement.replace(".", "\\") + ".lua"
        print luaFile
    elif line.startswith("--LIB:"):
        print line[6:]
