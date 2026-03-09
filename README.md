# SilkPage

SilkPage is a legacy XML/XSLT publishing system that was migrated from SVN into Git.

In this workspace it is kept under:

- `~/ws/git/github/sindoc/silkpage`

Primary areas:

- `core/` for the SilkPage build logic, XSLT, CSS, and packaging
- `www/silkpage.markupware.com/` for the Ant-based website preview and publish configuration
- `docs/` for the standalone documentation build based on `make`, `xsltproc`, `xmllint`, and `tidy`
- `site/` for site content sources
- `templates/` for reusable site templates

## Command-Line Workflow

Use the root `Makefile` to discover the available entrypoints:

- `make help`
- `make check`
- `make docs-html`
- `make website-preview`

## Current Build Reality

- the documentation build is runnable on this machine with the existing XML toolchain
- the site preview still depends on `ant`, which is not currently installed on this machine
- the core packaging targets in `core/build.xml` also depend on `ant`
