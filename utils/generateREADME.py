#!/usr/bin/env python
import os
import re

# ****************************************************************
# * Creates README File from Template filled with dynamic data:
# *   - Module Description
# ****************************************************************

TEMPLATE = open(os.path.dirname(os.path.abspath(__file__))+"/templates/README.md").read()



def load_files(file_list, name, files):
    
    for f in files:
        filename = os.path.dirname(os.path.abspath(__file__)) + "/../" + name + "/"+ f
        if (os.path.isfile(filename)):
            file_list.append(filename)
modules = []
os.path.walk("./modules",load_files, modules)

module_data = ""

for module in modules:
    content = open(module).read()
    offset = 0
    sections = []
    while offset >= 0:
        offset = content.find("--[[[", offset)
        if offset >= 0:
            end = content.find("]]--", offset)
            if end > 0:
                sections.append((offset+5, end))
            offset = offset + 1
    for start,end in sections:
        data = content[start+1:end]
        if data.startswith("@module"):
            module_data = module_data + "\n\n####" + data[7:] + "\nMembers:\n\n"
        elif data.startswith("@function"):
            module_data = module_data + " * " + data[10:]

template_data = {}
template_data["modules"] = module_data[2:]

print TEMPLATE % template_data