#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import spells
from kps import setup_logging_and_get_args

# ****************************************************************
# * Checks Class Rotation Spells for outdated and duplicate Spells
# ****************************************************************

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Checks Class Rotation Spells for outdated and duplicate Spells')
    parser.add_argument('-l','--limit', help='Limit Analysation to given KPS Class', required=False, default=None, choices=spells.SUPPORTED_CLASSES)
    args = setup_logging_and_get_args(parser)
    if args.limit:
        spells.PlayerSpells(args.limit, validate=True, ignore_validation_errors=False)
    else:
        for wow_class in spells.SUPPORTED_CLASSES:
            spells.PlayerSpells(wow_class, validate=True, ignore_validation_errors=False)
