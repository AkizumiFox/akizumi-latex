# make check   build every example from scratch; fails on the first LaTeX error
# make clean   remove build output
EXAMPLES := hw note exam slides book

.PHONY: check clean install

check:
	@cd examples && rm -rf build && for f in $(EXAMPLES); do \
	  printf '%-8s' $$f; \
	  latexmk -r latexmkrc -halt-on-error -interaction=nonstopmode $$f.tex >/dev/null 2>&1 \
	    && echo ok || { echo FAILED; grep -m5 -A3 '^!' build/$$f.log; exit 1; }; \
	done

clean:
	rm -rf examples/build

install:
	./install.sh
