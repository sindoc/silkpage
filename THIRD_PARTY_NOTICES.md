# Third-Party Notices

SilkPage redistributes or references third-party components that must be
reviewed before any commercial licensing program is finalized.

## Repository Inventory

Core bundled Java artifacts under `core/share/lib/java/`:

- `resolver-1_0.jar`: Apache XML Resolver. License to verify and preserve.
- `jtidy.jar`: JTidy. License to verify and preserve.
- `saxon9he.jar`: Saxon-HE distribution. MPL 2.0 is likely, but verify the
  exact packaged version.
- `saxon-6_5_3.jar`: Saxon 6.5.3 legacy distribution. License must be
  confirmed for current redistribution.
- `saxon-ext-6.4.jar`: Saxon extension library. License must be confirmed.
- `calabash.jar`: legacy Calabash distribution. License must be confirmed.

Additional toolchain artifacts under `tools/calabash/`:

- `xmlcalabash-1.5.7-120.jar`: XML Calabash 1.5.7.
- `lib/Saxon-HE-12.3.jar`: Saxon-HE 12.3.
- `lib/xmlresolver-5.2.1.jar` and `lib/xmlresolver-5.2.1-data.jar`: XML
  Resolver 5.2.1.
- `lib/httpclient-4.5.14.jar`, `lib/httpcore-4.4.16.jar`,
  `lib/httpmime-4.5.14.jar`: Apache HttpComponents.
- `lib/commons-logging-1.2.jar`, `lib/commons-codec-1.11.jar`,
  `lib/commons-io-2.2.jar`, `lib/commons-fileupload-1.4.jar`: Apache Commons.
- `lib/slf4j-api-1.7.36.jar`, `lib/slf4j-simple-1.7.36.jar`: SLF4J.
- `lib/xercesImpl-2.9.1.jar`, `lib/xml-apis-1.4.01.jar`: Xerces and XML APIs.
- `lib/jing-20220510.jar`, `lib/isorelax-20030108.jar`,
  `lib/isorelax-20090621.jar`, `lib/relaxngDatatype-20020414.jar`,
  `lib/xsdlib-2013.6.1.jar`, `lib/msv-core-2013.6.1.jar`: RELAX NG and schema
  tooling.
- `lib/tagsoup-1.2.1.jar`, `lib/htmlparser-1.4.jar`: HTML parsing.
- `lib/commonmark-0.21.0.jar`, `lib/icu4j-72.1.jar`, `lib/classindex-3.3.jar`,
  `lib/annotations-18.0.0.jar`, `lib/javax.servlet-api-3.1.0.jar`,
  `lib/org.restlet-2.2.2.jar`, `lib/org.restlet.ext.slf4j-2.2.2.jar`,
  `lib/org.restlet.ext.fileupload-2.2.2.jar`, `lib/nwalsh-annotations-1.0.0.jar`,
  `lib/ant-1.9.4.jar`, `lib/ant-launcher-1.9.4.jar`, `lib/junit-4.13.2.jar`,
  `lib/hamcrest-core-1.3.jar`: licenses must be confirmed and carried forward.

DocBook resources under `tools/docbook-xsl/`:

- DocBook XSL stylesheets and assets.
- Embedded image assets used by the stylesheets.
- WebHelp submodule content with its own license pointer.

## Actions Required Before Commercial Release

- Decide which of the above artifacts are shipped in the product versus used
  only for development or build.
- Add the upstream license text for every redistributed dependency to the
  release bundle.
- Confirm version-specific licenses instead of relying on family-level
  assumptions.
- Remove or replace any artifact whose redistribution terms are unclear.
- Record checksums or exact versions used in release builds.

## Current State

This inventory is concrete enough for repository triage, but it is not yet a
completed legal notice pack.
