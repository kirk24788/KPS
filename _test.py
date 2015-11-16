import sys



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
if exception_raised:
    sys.exit(1)
print "...OK"