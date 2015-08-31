.PHONY: build test phony

build: .pygit2-stamp

test: build
	export PYTHONPATH=$$(echo imports/pygit2/build/lib.*) && \
		export LD_LIBRARY_PATH=imports/libgit2/lib && \
		./test.py

.pygit2-stamp: .libgit2-stamp .peru/lastimports
	cd imports/pygit2 && \
		export LIBGIT2=../libgit2 && \
		export LD_LIBRARY_PATH=../libgit2/lib && \
		python3 setup.py build
	@touch $@

.libgit2-stamp: .peru/lastimports
	cd imports/libgit2 && \
		mkdir -p lib && \
		cd lib && \
		cmake .. && \
		make
	@touch $@

# The lastimports is not touched by peru unless the imports have actually
# changed, so it's useful as a build stamp for all the imports. Because this
# rule depends on a phone target, it will always run, which is also what we
# want.
.peru/lastimports: phony
	peru sync

# This target does nothing. Because it's phony, it always "runs", which means
# if you depend on it directly you always run too.
phony:
