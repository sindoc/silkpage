.PHONY: help status check docs-html docs-clean website-preview core-dist test-case-01

help:
	@printf "silkpage commands:\n"
	@printf "  make status          Show git status\n"
	@printf "  make check           Check local build dependencies\n"
	@printf "  make docs-html       Build the standalone docs HTML output\n"
	@printf "  make docs-clean      Clean generated docs output\n"
	@printf "  make website-preview Run the Ant-based site preview if ant is installed\n"
	@printf "  make core-dist       Run the Ant-based core dist target if ant is installed\n"
	@printf "  make test-case-01    Run the first audio feature regression test\n"

status:
	git status -sb

check:
	@for x in make xsltproc xmllint tidy zip java javac ant; do \
		printf "%s: " "$$x"; \
		command -v "$$x" || true; \
	done

docs-html:
	$(MAKE) -C docs html-single html-chunk css

docs-clean:
	$(MAKE) -C docs clean

website-preview:
	@if command -v ant >/dev/null 2>&1; then \
		ant -f www/silkpage.markupware.com/build.xml preview; \
	else \
		printf "ant is not installed; cannot run website preview\n" >&2; \
		exit 1; \
	fi

core-dist:
	@if command -v ant >/dev/null 2>&1; then \
		ant -f core/build.xml dist; \
	else \
		printf "ant is not installed; cannot run core dist\n" >&2; \
		exit 1; \
	fi

test-case-01:
	bash tests/test-case-01-audio.sh
