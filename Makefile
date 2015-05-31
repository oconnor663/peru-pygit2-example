run: imports/pygit2-stamp
	export PYTHONPATH=$$(echo imports/pygit2/build/lib.*) && \
		export LD_LIBRARY_PATH=imports/libgit2/lib && \
		echo PYTHONPATH is really "'$$PYTHONPATH'" && \
		./test.py

imports/libgit2-stamp: peru.yaml
	cd imports/libgit2 && \
		mkdir -p lib && \
		cd lib && \
		cmake .. && \
		make
	touch $@

imports/pygit2-stamp: peru.yaml imports/libgit2-stamp
	cd imports/pygit2 && \
		export LIBGIT2=../libgit2 && \
		export LD_LIBRARY_PATH=../libgit2/lib && \
		python3 setup.py build
	touch $@
