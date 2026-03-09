# SilkPage

**SilkPage** is an XML-based web publishing framework evolved from
[DocBook Website](http://docbook.sourceforge.net/). It provides a structured,
standards-compliant approach to publishing websites using XML content with XSL and CSS
presentation layers.

> Version 0.6.0 — © 2004–2009 [MarkupWare](http://www.markupware.com/)

---

## History

| Period | Host | VCS |
|--------|------|-----|
| 2004–2008 | [java.net](https://java.net) (`cvs.dev.java.net` → `svn.java.net`) | CVS, then SVN |
| 2008–2024 | [Launchpad.net](https://launchpad.net) | Bazaar |
| 2024–present | [GitHub — sindoc/silkpage](https://github.com/sindoc/silkpage) | Git |

SilkPage was created in December 2004 and originally developed on java.net (first under CVS,
later migrated to SVN). After java.net was decommissioned in 2017, the project was hosted on
Launchpad. It is now preserved and maintained on GitHub.

---

## What is SilkPage?

SilkPage turns XML-authored content into standard-compliant XHTML websites. Its mission is to
provide an outstanding web publishing framework built around XML markup languages and web
standards.

Key differentiators from its ancestor DocBook Website:

- **WaSP-compliant XHTML output** — valid XHTML 1.0 Strict/Transitional
- **Richer XSL/CSS customization** — separate XSL and CSS customization layers per site
- **XML feed support** — integrated RSS 1.0 / RDF / Atom feed generation
- **Ant-driven automation** — Apache Ant build system for preview, publish, and scaffolding
- **Accessibility-first** — developed with accessibility and usability in mind

---

## Key Features

| Feature | Description |
|---------|-------------|
| **XML Content Management** | Website content authored entirely in XML |
| **WaSP Compliant** | Standards-compliant XHTML output |
| **Accessibility** | Accessibility and usability built in |
| **Separate Presentation Model** | XSL and CSS customization layers |
| **XML Feeds** | RSS 1.0, RDF/XML, and Atom feed generation |
| **CSS Themes** | Multiple ready-to-use themes: butterfly, mozilla, phenix, silkpage, simplebits, xwtk, ala, gimp, markupware, tabular, website, common |

---

## Supported Standards

- XHTML 1.0 (Strict / Transitional)
- XML 1.0 / XSLT 1.0
- CSS Level 1 & 2
- RSS 1.0 / RDF/XML
- Atom Syndication Format
- FOAF (Friend of a Friend)
- DOAP (Description of a Project)
- XML Catalogs (OASIS)

---

## Prerequisites

Before installing SilkPage, install the following:

| Software | Minimum Version | Notes |
|----------|----------------|-------|
| [Java SE](https://java.sun.com/) | 1.4 | Required |
| [Apache Ant](https://ant.apache.org/) | 1.6.1 | Required |
| [Saxon XSLT](http://saxon.sourceforge.net/) | — | Required (bundled in `-plus` distribution) |
| [Apache XML Commons Resolver](http://xml.apache.org/commons/) | — | Required (bundled) |
| [JTidy](http://jtidy.sourceforge.net/) | — | Required for XHTML validation (bundled) |
| [DocBook XSL Stylesheets](http://docbook.sourceforge.net/) | — | Optional (bundled in `-plus`) |
| [DocBook Website](http://docbook.sourceforge.net/) | — | Optional (bundled in `-plus`) |

**System requirements:** Pentium II or higher, 32 MB RAM, 20 MB disk space.

---

## Installation

### 1. Download

SilkPage is distributed in two bundles:

- **`silkpage-VERSION.zip`** — SilkPage only (requires separate DocBook resources)
- **`silkpage-VERSION-plus.zip`** — SilkPage + all required DocBook resources *(recommended)*

### 2. Unpack and verify

```bash
unzip silkpage-VERSION-plus.zip
cd silkpage-VERSION
ant -f src/xml/build/tasks.xml config
```

A successful install prints:

```
config:
  [echo] SilkPage (VERSION)
  [echo] user.name: jhe
  [echo] os.name: Linux
  [echo] temp.dir: /tmp
  [echo] DocBook Website installed ? true
  [echo] DocBook XSL installed ? true
```

---

## Directory Structure

```
silkpage-VERSION/          ← SILKPAGE_HOME
├── cfg/                   ← Configuration files
│   ├── catalog.xml        ← XML catalog for entity/URI resolution
│   └── tidy.properties    ← JTidy XHTML validation settings
├── docs/                  ← User Guide and documentation (DocBook XML)
├── share/
│   ├── lib/               ← Code libraries (JARs)
│   └── tools/             ← DocBook Website + DocBook XSL stylesheets
└── src/
    ├── css/               ← CSS stylesheets and themes
    ├── xml/               ← Ant build instructions
    └── xsl/               ← XSL stylesheets for XHTML output
```

---

## Usage — Ant Commands

Run all commands from `SILKPAGE_HOME` with:

```bash
ant -f src/xml/build/tasks.xml TARGET
```

| Target | Description |
|--------|-------------|
| `config` | Print configuration and verify installation |
| `scratch` | Generate a new website skeleton (scaffolding) |
| `preview` | Generate the website locally for preview |
| `publish` | Publish the generated website (e.g., via FTP) |

---

## Customization

SilkPage supports two levels of presentation customization:

- **XSL layer** — Override or extend the XSL stylesheets in `src/xsl/` to change the XHTML
  structure and rendering.
- **CSS layer** — Override or create CSS stylesheets in `src/css/` to control visual
  presentation. Multiple themes are provided out of the box.

---

## Documentation

A complete **DocBook XML User Guide** is included in [`docs/`](docs/). It covers:

- Introduction and key concepts
- System requirements and installation
- Usage and workflow
- Global and per-instance configuration files
- Ant command reference
- FAQ and troubleshooting
- Glossary and resources

To build the HTML version of the user guide:

```bash
cd docs
make html-chunk   # chunked HTML (one file per section)
make html         # single-page HTML
make pdf          # PDF via FOP
```

---

## Authors

- **Javad K. Heshmati** — `javad@khakbaz.com` (MarkupWare)
- **Sina K. Heshmati** — `sina@khakbaz.com` (MarkupWare)

---

## License

- **Software**: [GNU General Public License (GPL)](http://www.gnu.org/licenses/gpl.html)
- **Documentation**: [GNU Free Documentation License 1.1+](http://www.gnu.org/copyleft/fdl.html)

---

## Project Links

- **GitHub**: https://github.com/sindoc/silkpage
- **Original java.net project**: https://silkpage.dev.java.net/ *(archived/offline)*
- **Launchpad**: https://launchpad.net/silkpage *(archived)*
