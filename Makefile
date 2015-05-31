run: .pygit2-stamp
	export PYTHONPATH=$$(echo imports/pygit2/build/lib.*) && \
		export LD_LIBRARY_PATH=imports/libgit2/lib && \
		./test.py

.pygit2-stamp: .libgit2-stamp
	cd imports/pygit2 && \
		export LIBGIT2=../libgit2 && \
		export LD_LIBRARY_PATH=../libgit2/lib && \
		python3 setup.py build
	touch $@

.libgit2-stamp: .imports-stamp
	cd imports/libgit2 && \
		mkdir -p lib && \
		cd lib && \
		cmake .. && \
		make
	touch $@

.imports-stamp: peru.yaml
	peru sync
	touch $@
