<?xml version="1.0" encoding="UTF-8"?>
<!--
  build.xpl — SilkPage website build pipeline (XProc 1.0)
  Processor: XML Calabash 1.5.7 (Norman Walsh's XProc implementation)
  XSLT:      Saxon 12 HE (Phase 1 via Calabash) + Saxon 6.5.3 (Phase 2 via exec)

  See build.sh for the invocation command.

  Phase 1 — autolayout (p:xslt inside Calabash):
    Transforms layout.xml to autolayout.xml using DocBook Website autolayout.xsl.

  Phase 2 — website chunking (p:exec to Saxon 6.5.3):
    DocBook Website's chunk-website.xsl uses Saxon 6.5.3 extension functions
    (com.nwalsh.saxon.Website) to write chunked HTML files directly to disk.
    These XSLT 1.0 extensions cannot run inside p:xslt (single output only),
    so we delegate to Saxon 6.5.3 via p:exec after Phase 1 completes.
    The catalog maps live http:// import URIs to local file:// paths.
-->
<p:declare-step name="build-silkpage-website"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                version="1.0">

  <p:output port="result" sequence="true"/>

  <!-- Options (all absolute filesystem paths, no trailing slash except output-root) -->

  <p:option name="layout"      required="true"/>  <!-- abs path: layout.xml -->
  <p:option name="autolayout"  required="true"/>  <!-- abs path: autolayout.xml (output) -->
  <p:option name="saxon653"    required="true"/>  <!-- abs path: saxon-6_5_3.jar -->
  <p:option name="resolver"    required="true"/>  <!-- abs path: resolver-1_0.jar -->
  <p:option name="catalog"     required="true"/>  <!-- abs path: catalog-resolved.xml -->
  <p:option name="source"      required="true"/>  <!-- abs path: index.xml -->
  <p:option name="stylesheet"  required="true"/>  <!-- abs path: silkpage/main.xsl -->
  <p:option name="output-root" required="true"/>  <!-- abs path: dist/website/ dir -->

  <!-- Phase 1a: Load layout.xml -->

  <p:load name="layout-doc">
    <p:with-option name="href" select="concat('file://', $layout)"/>
  </p:load>

  <!-- Phase 1b: Transform layout.xml to autolayout (in-memory) -->

  <p:xslt name="generate-autolayout">
    <p:input port="source">
      <p:pipe step="layout-doc" port="result"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="tools/docbook-xsl/website/autolayout.xsl"/>
    </p:input>
    <p:input port="parameters"><p:empty/></p:input>
  </p:xslt>

  <!-- Phase 1c: Write autolayout.xml to disk -->

  <p:store name="store-autolayout" indent="true">
    <p:input port="source">
      <p:pipe step="generate-autolayout" port="result"/>
    </p:input>
    <p:with-option name="href" select="concat('file://', $autolayout)"/>
  </p:store>

  <!--
    Phase 2: Chunk website XML to HTML via Saxon 6.5.3
    cx:depends-on ensures Calabash waits for store-autolayout to complete
    before launching the Saxon process (which reads autolayout.xml from disk).
  -->

  <p:exec name="chunk-website"
          command="java"
          result-is-xml="false"
          wrap-result-lines="true"
          cx:depends-on="store-autolayout">
    <p:input port="source"><p:empty/></p:input>
    <p:with-option name="args" select="concat(
        '-cp ', $saxon653, ':', $resolver,
        ' -Dxml.catalog.files=', $catalog,
        ' com.icl.saxon.StyleSheet',
        ' -x org.apache.xml.resolver.tools.ResolvingXMLReader',
        ' -y org.apache.xml.resolver.tools.ResolvingXMLReader',
        ' -r org.apache.xml.resolver.tools.CatalogResolver',
        ' file://', $autolayout,
        ' ', $stylesheet,
        ' autolayout-file=file://', $autolayout,
        ' output-root=', $output-root,
        ' nav.graphics=0',
        ' chunker.output.encoding=UTF-8')"/>
  </p:exec>

  <!-- Emit Saxon diagnostic output -->
  <p:identity>
    <p:input port="source">
      <p:pipe step="chunk-website" port="result"/>
    </p:input>
  </p:identity>

</p:declare-step>
