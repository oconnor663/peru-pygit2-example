#! /usr/bin/env python3

import pygit2
import tempfile

repo_dir = tempfile.mkdtemp()

print("Creating repo at {}".format(repo_dir))

repo = pygit2.init_repository(repo_dir)
