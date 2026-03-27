<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="xalanredirect lxslt exsl"
                version="1.0">

  <xsl:import href="../../../tools/docbook-xsl/html/chunk.xsl"/>

  <xsl:param name="html.stylesheet">css/spec.css</xsl:param>
  <xsl:param name="section.autolabel" select="'1'"/>
  <xsl:param name="generate.component.toc" select="'1'"/>
  <xsl:param name="chunker.output.method" select="'html'"/>
  <xsl:param name="chunker.output.indent" select="'no'"/>
  <xsl:param name="chunker.output.encoding" select="'UTF-8'"/>
  <xsl:param name="table.borders.with.css" select="1"/>

  <xsl:template name="user.head.content">
    <xsl:param name="node" select="."/>
    <meta name="theme" content="spec"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
  </xsl:template>
</xsl:stylesheet>
