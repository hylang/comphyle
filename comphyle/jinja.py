#!/usr/bin/env python

from email.Utils import formatdate
from jinja2 import Template
import time
import os


def rfc_2822(dateobj):
    return formatdate(time.mktime(dateobj.timetuple()))


def render_fd(fpath, ctx):
  output_name = fpath.replace(".jinja2", "")
  t = Template(open(fpath, "r").read())
  ctx['rfc_2822_date'] = rfc_2822(ctx['when'])
  open(output_name, "w").write(t.render(**ctx))
  print open(output_name, 'r').read()
  os.unlink(fpath)
