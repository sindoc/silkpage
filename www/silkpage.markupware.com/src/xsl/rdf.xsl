<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/rdf/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <xsl:import href="http://silkpage.markupware.com/release/core/current/src/xsl/ala/chunk.xsl"/>
  <xsl:import href="param.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/custom-rdf.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, RDF Customization</dc:title>
    <cvs:date>$Date: 2006-04-17 10:13:02 $</cvs:date>
    <dc:rights>Copyright &#169; 2004 MarkupWare.</dc:rights>
    <dc:description>
    This XSLT stylesheet customizes the generation of RDF metadata, optionally
    generated for each XML source.
  </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

<!-- ==================================================================== -->
  <xsl:param name="generate.rdf" select="'yes'"/>

</xsl:stylesheet>
