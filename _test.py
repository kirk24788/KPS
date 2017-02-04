import sys
import re


# Test if all supported Classes/Specs have meta info
print "Testing Class/Spec Meta-Data..."
from utils.config import SUPPORTED_SPECS
from utils.kps import parse_rotation_meta
exception_raised = False
for class_name in sorted(SUPPORTED_SPECS.keys()):
    spec_names = sorted(SUPPORTED_SPECS[class_name])
    for spec_name in spec_names:
        try:
            parse_rotation_meta(class_name, spec_name)
        except Exception as e:
            print "Test Failure: %s " % str(e)
            exception_raised = True


# Test if all supported Classes/Specs contain valid spells
print "Testing Class/Spec Meta-Data..."
from utils.config import SUPPORTED_SPECS
exception_raised = False

for class_name in sorted(SUPPORTED_SPECS.keys()):
    spec_names = sorted(SUPPORTED_SPECS[class_name])
    spells = []
    with open("rotations/%s_spells.lua" % class_name, "r") as f:
        data = f.read()
        for line in data.split("\n"):
            prefix = "kps.spells.%s." % class_name
            prefix_length = len(prefix)
            if line.startswith(prefix):
                spells.append(line[prefix_length:].split("=")[0].strip())
for class_name in sorted(SUPPORTED_SPECS.keys()):
    spec_names = sorted(SUPPORTED_SPECS[class_name])
    spells = []
    with open("rotations/%s_spells.lua" % class_name, "r") as f:
        data = f.read()
        for line in data.split("\n"):
            prefix = "kps.spells.%s." % class_name
            prefix_length = len(prefix)
            if line.startswith(prefix):
                spells.append(line[prefix_length:].split("=")[0].strip())
    for spec_name in spec_names:
        rotation_file = "rotations/%s_%s.lua" % (class_name, spec_name)
        with open(rotation_file, "r") as f:
            line_nr = 0
            data = f.read()
            if "@generated_from" in data:
                print "...skipping generated '%s'" % rotation_file
            else:
                for line in data.split("\n"):
                    line_nr = line_nr + 1
                    if "local spells" not in line:
                        for match in re.findall("spells\.([a-zA-Z0-9]*)", line):
                            if match not in spells:
                                print "%s:%d - Unknown 'spells.%s'" % (rotation_file, line_nr, match)
                                exception_raised = True

if exception_raised:
    sys.exit(1)
print "...OK"
