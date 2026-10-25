# make check    rebuild every example (python3 bin/ax selftest examples)
# make test-ax  create and build one ax project of each kind
# make test     both
# Without make (e.g. Windows): py bin/ax selftest
.PHONY: check test-ax test clean install

check:
	python3 bin/ax selftest examples

test-ax:
	python3 bin/ax selftest projects

test:
	python3 bin/ax selftest

clean:
	rm -rf examples/build

install:
	python3 install.py
