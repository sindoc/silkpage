<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		extension-element-prefixes=" html rdf rdfs cvs xlink urfm doap rss cvsf date foaf dc "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/xlink.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Xlink</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:54 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>This stylesheet processes external resources referenced by xlink</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>
  
<!-- ==================================================================== -->

<xsl:template match="link">
  <xsl:variable name="id" select="/webpage/@id"/>
  <xsl:variable name="role" select="@xlink:role"/>
  <xsl:choose>
    <xsl:when test="starts-with(@xlink:href,'http://')
		    and $process.external-url = '0'">
      <xsl:message>
	<xsl:text>Failed to process: [</xsl:text>
	<xsl:value-of select="@xlink:href"/>
	<xsl:text>] External file processing disabled</xsl:text>
	<xsl:value-of select="$process.external-url"/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="href" select="document(@xlink:href, .)"/>
      <xsl:choose>
	<xsl:when test="not($href)">
	  <xsl:message>
	    <xsl:text>External file processing failed: [</xsl:text>
	    <xsl:value-of select="@xlink:href"/>
	    <xsl:text>]</xsl:text>
	  </xsl:message>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:if test="$role = $namespace.urfm">
	    <xsl:call-template name="urfm">
	      <xsl:with-param name="href" select="$href"/>
	    </xsl:call-template>
	  </xsl:if>
	  <xsl:if test="$role = $namespace.doap">
	    <xsl:call-template name="doap">
	      <xsl:with-param name="href" select="$href"/>
	      <xsl:with-param name="id" select="$id"/>
	    </xsl:call-template>
	  </xsl:if>
	  <xsl:if test="$role = $namespace.foaf">
	    <xsl:call-template name="foaf">
	      <xsl:with-param name="href" select="$href"/>
	      <xsl:with-param name="id" select="$id"/>
	    </xsl:call-template>
	  </xsl:if>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
