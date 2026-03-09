<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage/toc.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, HTML ToC for SilkPage Theme</dc:title>
    <cvs:date>$Date: 2006-12-31 13:55:06 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

<!-- ==================================================================== -->

  <xsl:include href="../common/utils.xsl"/>
  <xsl:include href="../common/toc.xsl"/>
  <xsl:output method="xml"/>

<!-- ==================================================================== -->

<xsl:template match="toc">
  <xsl:param name="pageid" select="@id"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$pageid"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="*[not(tocentry)][@id=$pageid]">
    </xsl:when>
    <xsl:when test="../*/@id=$pageid">
    </xsl:when>
    <xsl:otherwise>
      <div id="{$secnav.label}">
	<ul>
	  <xsl:apply-templates select="tocentry/tocentry">
	    <xsl:with-param name="pageid" select="$pageid"/>
	    <xsl:with-param name="relpath" select="$relpath"/>
	  </xsl:apply-templates>
	</ul>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="toc" mode="header.wrap">
  <xsl:param name="pageid" select="@id"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$pageid"/>
    </xsl:call-template>
  </xsl:variable>
  <div id="{$primnav.label}">
    <ul>
      <xsl:apply-templates select="tocentry[@tocskip != '1']" mode="primnav">
	<xsl:with-param name="pageid" select="$pageid"/>
	<xsl:with-param name="relpath" select="$relpath"/>
      </xsl:apply-templates>
    </ul>
  </div>
</xsl:template>

<xsl:template match="tocentry" mode="primnav">
  <xsl:param name="pageid" select="@id"/>
  <xsl:param name="relpath" select="''"/>
  <xsl:variable name="position" select="count(preceding-sibling::*)-1"/>
  <li>
    <xsl:call-template name="navitems">
      <xsl:with-param name="pageid" select="$pageid"/>
      <xsl:with-param name="relpath" select="$relpath"/>
      <xsl:with-param name="revisionflag" select="@revisionflag"/>
      <xsl:with-param name="link.wrapper" select="'span'"/>
    </xsl:call-template>
  </li>
</xsl:template>

  <xsl:template match="tocentry">
    <xsl:param name="pageid"/>
    <xsl:param name="toclevel" select="count(ancestor::*)"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:if test="ancestor::*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
	  <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="link.wrapper" select="$secnav.linkwrapper"/>
          <xsl:with-param name="revisionflag" select="@revisionflag"/>
        </xsl:call-template>
      </li>
    </xsl:if>
    <xsl:if test="..//*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="revisionflag" select="@revisionflag"/>
          <xsl:with-param name="link.wrapper" select="'strong'"/>
        </xsl:call-template>
        <xsl:if test="descendant::tocentry">
          <ul>
            <xsl:apply-templates select="tocentry">
              <xsl:with-param name="pageid" select="$pageid"/>
              <xsl:with-param name="relpath" select="$relpath"/>
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
