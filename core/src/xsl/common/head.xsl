<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/"
		exclude-result-prefixes=" html rdf dc cvs rss urfm " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/head.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common HTML Head</dc:title>
    <cvs:date>$Date: 2006-04-27 23:27:39 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This XSLT stylesheet generates the content of head element, such as 
      metadate and accessibility links in XHTML output.
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:template match="head" mode="head.mode">
    <xsl:variable name="nodes" select="*"/>
    <head>
      <meta name="generator">
        <xsl:attribute name="content">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'Meta'"/>
	    <xsl:with-param name="name" select="'SilkPage'"/>
          </xsl:call-template>
        </xsl:attribute>
      </meta>
      <meta name="author">
	<xsl:attribute name="content">
	  <xsl:call-template name="site-author"/>	  
	</xsl:attribute>
      </meta>
      <xsl:apply-templates select="ancestor-or-self::webpage/config" mode="head.mode"/>
      <xsl:if test="$html.stylesheet != ''">
        <link rel="stylesheet" href="{$html.stylesheet}" type="text/css">
          <xsl:if test="$html.stylesheet.type != ''">
            <xsl:attribute name="type">
              <xsl:value-of select="$html.stylesheet.type"/>
            </xsl:attribute>
          </xsl:if>
        </link>
      </xsl:if>
      <xsl:variable name="thisid" select="ancestor-or-self::webpage/@id"/>
      <xsl:variable name="thisrelpath">
        <xsl:apply-templates select="$autolayout//*[@id=$thisid]" mode="toc-rel-path"/>
      </xsl:variable>
      <xsl:variable name="topid">
        <xsl:call-template name="top.page"/>
      </xsl:variable>
      <xsl:if test="$topid != ''">
        <link rel="home">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$topid]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$topid]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:variable name="upid">
        <xsl:call-template name="up.page"/>
      </xsl:variable>
      <xsl:if test="$upid != ''">
        <link rel="up">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$upid]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$upid]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:variable name="previd">
        <xsl:call-template name="prev.page"/>
      </xsl:variable>
      <xsl:if test="$previd != ''">
        <link rel="previous">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$previd]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$previd]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:variable name="nextid">
        <xsl:call-template name="next.page"/>
      </xsl:variable>
      <xsl:if test="$nextid != ''">
        <link rel="next">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$nextid]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$nextid]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:variable name="firstid">
        <xsl:call-template name="first.page"/>
      </xsl:variable>
      <xsl:if test="$firstid != ''">
        <link rel="first">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$firstid]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$firstid]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:variable name="lastid">
        <xsl:call-template name="last.page"/>
      </xsl:variable>
      <xsl:if test="$lastid != ''">
        <link rel="last">
          <xsl:attribute name="href">
            <xsl:call-template name="page.uri">
              <xsl:with-param name="page" select="$autolayout//*[@id=$lastid]"/>
              <xsl:with-param name="relpath" select="$thisrelpath"/>
            </xsl:call-template>
	  </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="$autolayout//*[@id=$lastid]/title"/>
          </xsl:attribute>
        </link>
      </xsl:if>
      <xsl:apply-templates select="$autolayout/autolayout/style|
				   $autolayout/autolayout/script|
				   $autolayout/autolayout/meta|
				   $autolayout/autolayout/headlink" 
					mode="head.mode">
        <xsl:with-param name="webpage" select="ancestor::webpage"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="head.mode"/>
      <xsl:call-template name="user.head.content">
        <xsl:with-param name="node" select="ancestor::webpage"/>
      </xsl:call-template>
    </head>
  </xsl:template>
  
  <xsl:template match="config" mode="head.mode">
    <xsl:variable name="href">
      <xsl:call-template name="sources-href"/>
    </xsl:variable>
    <xsl:if test="@param='RSS10'">
      <xsl:variable name="type" select="'application/rdf+xml'"/>
      <xsl:call-template name="head.link">
	<xsl:with-param name="type" select="$type"/>
	<xsl:with-param name="title" select="'RSS'"/>
	<xsl:with-param name="href" select="$href"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="@param='DOAP'">
      <xsl:call-template name="head.link">
	<xsl:with-param name="type" select="'application/rdf+xml'"/>
	<xsl:with-param name="title" select="'DOAP'"/>
	<xsl:with-param name="href" select="$href"/>
      </xsl:call-template>            
    </xsl:if>
    <xsl:if test="@param='Atom'">
      <xsl:call-template name="head.link">
	<xsl:with-param name="type" select="'application/atom+xml'"/>
	<xsl:with-param name="title" select="'Atom'"/>
	<xsl:with-param name="href" select="$href"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="@param='FOAF'">
      <xsl:call-template name="head.link">
	<xsl:with-param name="type" select="'application/rdf+xml'"/>
	<xsl:with-param name="title" select="'FOAF'"/>
	<xsl:with-param name="href" select="$href"/>
      </xsl:call-template>            
    </xsl:if>
    <xsl:if test="@param='URFM'">
      <xsl:call-template name="head.link">
	<xsl:with-param name="type" select="'application/rdf+xml'"/>
	<xsl:with-param name="title" select="'URFM'"/>
	<xsl:with-param name="href" select="$href"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

<xsl:template match="keywords" mode="head.mode">
  <meta name="keywords" content="{.}"/>
</xsl:template>

<xsl:template match="summary" mode="head.mode">
  <meta name="description" content="{.}"/>
</xsl:template>
  
<xsl:template name="head.link">
  <xsl:param name="type"/>
  <xsl:param name="rel" select="'alternate'"/>
  <xsl:param name="title"/>
  <xsl:param name="href"/>
  <link rel="{$rel}" type="{$type}" title="{$title}" href="{$href}"/>
</xsl:template>

<xsl:template name="style.attributes">
  <xsl:if test="@type">
    <xsl:attribute name="type">
      <xsl:value-of select="@type"/>
    </xsl:attribute>
  </xsl:if>
  <xsl:if test="@media">
    <xsl:attribute name="media">
      <xsl:value-of select="@media"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="style" mode="head.mode">
  <style>
    <xsl:call-template name="style.attributes"/>
    <xsl:apply-templates/>
  </style>
</xsl:template>

<xsl:template match="style[@src]" mode="head.mode" priority="2">
  <xsl:param name="webpage" select="ancestor::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$webpage"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="starts-with(@src, '/')">
      <link rel="stylesheet" href="{@src}">
	<xsl:call-template name="style.attributes"/>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <link rel="stylesheet" href="{$relpath}{@src}">
	<xsl:call-template name="style.attributes"/>
      </link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="meta" mode="head.mode">
  <xsl:choose>
    <xsl:when test="@http-equiv">
      <meta http-equiv="{@http-equiv}" content="{@content}"/>
    </xsl:when>
    <xsl:otherwise>
      <meta name="{@name}" content="{@content}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="title" mode="head.mode">
  <xsl:param name="id" select="/webpage/@id"/>
  <title>
    <xsl:value-of select="."/>
    <xsl:text> -- </xsl:text>
    <xsl:value-of select="../summary[1]"/>
  </title>
</xsl:template>
</xsl:stylesheet>
