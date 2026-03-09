<?xml version="1.0"?>
<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/rdf/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">


  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/custom-param.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Customization Parameters</dc:title>
    <cvs:date>$Date: 2006-04-17 10:13:02 $</cvs:date>
    <dc:rights>Copyright &#169; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This style sheet contains user-specific XSLT parameters
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:param name="site.author" select="'SilkTeam'"/>
  <xsl:param name="site.url" select="'http://silkpage.markupware.com'"/>
  <xsl:param name="site.id" select="'SilkPage'"/>
  <xsl:param name="site.license" select="'http://creativecommons.org/licenses/by-nc-sa/2.0/'"/>
  <xsl:param name="css.decoration" select="0"/>
  <xsl:param name="collect.xref.targets" select="'yes'"/>
  <xsl:param name="generate.rdf" select="'no'"/>
  <xsl:param name="website.database.document" select="'website.database.xml'"/>   <xsl:param name="acronyms.database.document" select="'glossary.xml'"/>
  <xsl:param name="process.acronyms" select="'1'"/>
  <xsl:param name="process.external-url" select="'1'"/>

  <!-- Local Parameters -->
  <xsl:param name="dev.label" select="'dev'"/>
  <xsl:param name="member.label" select="'member'"/>
  <xsl:param name="team.label" select="'team'"/>

</xsl:stylesheet>
