<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage/header.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, HTML Header for SilkPage Theme</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:58 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:template name="header">
    <xsl:variable name="page" select="."/>
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="headitems" select="$page/config[@param='headlink']   |$page/config[@param='header']   |$autolayout/autolayout/config[@param='headlink']   |$autolayout/autolayout/config[@param='header']"/>
    <xsl:variable name="relpath">
      <xsl:call-template name="root-rel-path">
        <xsl:with-param name="webpage" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="banner" select="$autolayout/autolayout/config[@param='banner'][1]"/>
    <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=id]"/>
    <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc                                    |$autolayout/autolayout/toc[1])[last()]"/>
    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="$header.label"/>
      </xsl:attribute>
      <div id="h3">
        <xsl:if test="$access.skipnav != 0">
          <p class="{$access.class}">
            <a href="#{$content.label}">
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'SkipNavigation'"/>
              </xsl:call-template>
            </a>
          </p>
        </xsl:if>
        <a>
          <xsl:attribute name="id">
            <xsl:value-of select="$title.label"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$toc/title[1]"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:call-template name="homeuri"/>
          </xsl:attribute>
          <xsl:attribute name="accesskey">
            <xsl:value-of select="$access.key.home"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$banner">
              <img>
                <xsl:attribute name="src">
                  <xsl:value-of select="$relpath"/>
                  <xsl:value-of select="$banner/@value"/>
                </xsl:attribute>
                <xsl:attribute name="alt">
                  <xsl:choose>
                    <xsl:when test="$banner/@altval">
                      <xsl:value-of select="$banner/@altval"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="gentext.nav.home"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </img>
            </xsl:when>
            <xsl:when test="$autolayout/autolayout/config[@param='title'][1]">
              <xsl:value-of select="$autolayout/autolayout/config[@param='title'][1]/@value"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$autolayout/autolayout/toc/title[1]"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
	<xsl:call-template name="hr.access"/>
        <xsl:if test="$pages.search-box != ''">
          <xsl:call-template name="user.search-box"/>
	  <xsl:call-template name="hr.access"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$toc">
            <xsl:apply-templates select="$toc" mode="header.wrap">
              <xsl:with-param name="pageid" select="$id"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>&#xA0;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$headitems.label != ''">
          <ul>
            <xsl:apply-templates select="$headitems" mode="header.item.mode">
              <xsl:with-param name="page" select="$page"/>
            </xsl:apply-templates>
          </ul>
        </xsl:if>
<!--
        <xsl:if test="$viewsrc.label != ''">
          <ul>
            <xsl:attribute name="id">
              <xsl:value-of select="$viewsrc.label"/>
            </xsl:attribute>
            <xsl:call-template name="page-formats"/>
          </ul>
        </xsl:if>
-->
      </div>
    </div>
  </xsl:template>
  <xsl:template match="config" mode="header.item.mode">
    <xsl:param name="page" select="''"/>
    <li>
      <xsl:attribute name="class">
        <xsl:value-of select="$headitem.label"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@param='headlink'">
          <xsl:call-template name="links">
            <xsl:with-param name="page" select="$page"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <a href="{@value}" title="{@altval}">
            <xsl:value-of select="@altval"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>
</xsl:stylesheet>

