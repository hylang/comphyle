#!/usr/bin/env python

from jinja2 import Template
import os


def render_fd(fpath, ctx):
  output_name = fpath.replace(".jinja2", "")
  t = Template(open(fpath, "r").read())
  open(output_name, "w").write(t.render(**ctx))
  os.unlink(fpath)
