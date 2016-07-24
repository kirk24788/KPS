#!/usr/bin/env python
# -*- coding: utf-8 -*-

from threading import Thread
from subprocess import call
import time
import sys


def run_cmd():
    print "Running:", " ".join(sys.argv[2:])
    call(sys.argv[2:])

max_duration = int(sys.argv[1])

started_at = time.time()
t = Thread(target=run_cmd, args=())
t.start()

while t.isAlive():
    time.sleep(1)
    if time.time()-started_at > max_duration:
        sys.exit(1)


