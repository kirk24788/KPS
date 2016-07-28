#!/usr/bin/env python
import os
import re
from kps import parse_rotation_meta
from config import WOW_VERSION, SUPPORTED_SPECS

# ****************************************************************
# * Creates README File from Template filled with dynamic data:
# *   - Module Description
# ****************************************************************

def load_files(file_list, name, files):
    for f in files:
        filename = os.path.dirname(os.path.abspath(__file__)) + "/../" + name + "/"+ f
        if (os.path.isfile(filename)):
            file_list.append(filename)

def read_module_data():
    modules = []
    os.path.walk("./modules",load_files, modules)

    module_data = ""
    for module in sorted(modules):
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

    return module_data[2:]

def parse_rotation_info(filename):
    rotation_data = open(filename,"r").read()


def read_rotation_data():
    rotations = []

    fully_supported = {}
    untested_supported = {}
    outdated = {}
    generated = {}

    for class_name_lower, spec_names in SUPPORTED_SPECS.iteritems():
        class_name = class_name_lower.title()
        for spec_name_lower in spec_names:
            spec_name = spec_name_lower.title()
            meta = parse_rotation_meta(class_name_lower, spec_name_lower)
            if "generated_from" in meta.keys():
                if class_name not in generated.keys():
                    generated[class_name] = []
                generated[class_name].append("%s (%s)" % (spec_name, meta["version"] ))
            elif meta["version"] == WOW_VERSION:
                if "untested" in meta.keys():
                    if class_name not in untested_supported.keys():
                        untested_supported[class_name] = []
                    untested_supported[class_name].append(spec_name)
                else:
                    if class_name not in fully_supported.keys():
                        fully_supported[class_name] = []
                    fully_supported[class_name].append(spec_name)
            else:
                if class_name not in outdated.keys():
                    outdated[class_name] = []
                outdated[class_name].append("%s (%s)" % (spec_name, meta["version"] ))
    rotation_data = "**Fully Supported in %s:**\n\n" % WOW_VERSION
    if fully_supported.keys() == []:
        rotation_data = rotation_data + "None\n\n"
    else:
        for class_name in sorted(fully_supported.keys()):
            spec_names = sorted(fully_supported[class_name])
            rotation_data = "%s* %s: %s\n" % (rotation_data, class_name, ", ".join(spec_names))
        rotation_data = rotation_data + "\n"

    if len(untested_supported.keys()) > 0:
        rotation_data = rotation_data + "**Untested Rotations in %s:**\n\n" % WOW_VERSION
        for class_name in sorted(untested_supported.keys()):
            spec_names = sorted(untested_supported[class_name])
            rotation_data = "%s* %s: %s\n" % (rotation_data, class_name, ", ".join(spec_names))
        rotation_data = rotation_data + "\n"

    if len(outdated.keys()) > 0:
        rotation_data = rotation_data + "**Outdated Rotations:**\n\n"
        for class_name in sorted(outdated.keys()):
            spec_names = sorted(outdated[class_name])
            rotation_data = "%s* %s: %s\n" % (rotation_data, class_name, ", ".join(spec_names))
        rotation_data = rotation_data + "\n"

    if len(generated.keys()) > 0:
        rotation_data = rotation_data + "**Automatically Generated Rotations:**\n_(Might not be fully functional)_\n\n"
        for class_name in sorted(generated.keys()):
            spec_names = sorted(generated[class_name])
            rotation_data = "%s* %s: %s\n" % (rotation_data, class_name, ", ".join(spec_names))
        rotation_data = rotation_data + "\n"
    return rotation_data

def read_open_issues():
    files = []
    os.path.walk(".",load_files, files)
    files = [f for f in files if f.endswith(".lua")]
    todos = ""
    for f in sorted(files):
        content = open(f).read()
        line_count = 1
        for line in content.split("\n"):
            if line.lstrip().startswith("--") and "TODO" in line:
                comment = line.split("TODO")[1]
                comment = comment[1:] if comment.startswith(":") else comment
                todos = todos + (" * `%s:%s` - %s\n" % (f.split("/.././")[1], line_count, comment.lstrip()))
            line_count = line_count + 1
    return todos

TEMPLATE = open(os.path.dirname(os.path.abspath(__file__))+"/templates/README.md").read()
template_data = {}
template_data["modules"] = read_module_data()
template_data["issues"] = read_open_issues()
template_data["rotations"] = read_rotation_data()
template_data["version"] = WOW_VERSION

print TEMPLATE % template_data
