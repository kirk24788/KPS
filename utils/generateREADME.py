#!/usr/bin/env python
import os
import re

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

    return module_data[2:]

def read_open_issues():
    files = []
    os.path.walk(".",load_files, files)
    files = [f for f in files if f.endswith(".lua")]
    todos = ""
    for f in files:
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

print TEMPLATE % template_data