.PHONY: build test phony

build: .pygit2-stamp

test: build
	export PYTHONPATH=$$(echo imports/pygit2/build/lib.*) && \
		export LD_LIBRARY_PATH=imports/libgit2/lib && \
		./test.py

.pygit2-stamp: .libgit2-stamp .imports-stamp
	cd imports/pygit2 && \
		export LIBGIT2=../libgit2 && \
		export LD_LIBRARY_PATH=../libgit2/lib && \
		python3 setup.py build
	@touch $@

.libgit2-stamp: .imports-stamp
	cd imports/libgit2 && \
		mkdir -p lib && \
		cd lib && \
		cmake .. && \
		make
	@touch $@

# Because this target depends on phony, it will always rebuild when referenced.
# But we don't want that always-rebuilding property to be transitive. To avoid
# that, we don't always update the *timestamp* of our stamp file. To never
# force depending rules to rebuild, we could've used `touch -a $@`, which
# creates a file but never changes its modify time. In this case, we *do* want
# to force callers to rebuild when peru.yaml has changed, so we use the -r flag
# to have touch copy its timestamp.
# TODO: Use the .peru/lastimports file for a version of this that's aware of
#       overrides too, once peru stops stomping on it every time.
.imports-stamp: peru.yaml phony
	peru sync
	@touch -r peru.yaml $@

# This target does nothing. Because it's phony, it always "runs", which means
# if you depend on it directly you always run too.
phony:
