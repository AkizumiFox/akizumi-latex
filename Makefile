# make check    build every example from scratch; fails on the first LaTeX error
# make test-ax  create and build one ax project of each kind in a temp dir
# make clean    remove build output
EXAMPLES := hw note exam slides book

.PHONY: check test-ax clean install

check:
	@cd examples && rm -rf build && for f in $(EXAMPLES); do \
	  printf '%-8s' $$f; \
	  latexmk -r latexmkrc -halt-on-error -interaction=nonstopmode $$f.tex >/dev/null 2>&1 \
	    && echo ok || { echo FAILED; grep -m5 -A3 '^!' build/$$f.log; exit 1; }; \
	done

test-ax:
	@tmp=$$(mktemp -d) && cd $$tmp && \
	for k in hw note exam slides book paper; do \
	  printf '%-8s' $$k; \
	  ax new $$k t-$$k --title Test </dev/null >/dev/null && \
	  (cd t-$$k && ax build >/dev/null) && echo ok || { echo FAILED; exit 1; }; \
	done && (cd t-hw && ax both >/dev/null && echo "both    ok") && rm -rf $$tmp

clean:
	rm -rf examples/build

install:
	./install.sh
