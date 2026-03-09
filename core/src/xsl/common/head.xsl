<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/0.1/"
		exclude-result-prefixes=" html rdf dc cvs rss urfm " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/rss.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common HTML Head</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:51 $</cvs:date>
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
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'SilkPage'"/>
          </xsl:call-template>
        </xsl:attribute>
      </meta>
      <meta name="author" content="{$site.author}"/>
      <xsl:apply-templates select="ancestor-or-self::webpage//rss|ancestor-or-self::webpage//urfm" mode="head.mode"/>
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
      <xsl:apply-templates select="$autolayout/autolayout/style                                  |$autolayout/autolayout/script                                  |$autolayout/autolayout/headlink" mode="head.mode">
        <xsl:with-param name="webpage" select="ancestor::webpage"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="head.mode"/>
      <xsl:call-template name="user.head.content">
        <xsl:with-param name="node" select="ancestor::webpage"/>
      </xsl:call-template>
    </head>
  </xsl:template>
  <xsl:template match="rss" mode="head.mode">
    <xsl:variable name="feed" select="document(@feed, .)"/>
    <link rel="alternate" type="application/rdf+xml">
      <xsl:attribute name="title">
        <xsl:value-of select="$feed//rss:channel/rss:title[1]"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="@feed"/>
      </xsl:attribute>
    </link>
  </xsl:template>

  <xsl:template match="urfm" mode="head.mode">
    <xsl:variable name="feed" select="document(@feed, .)"/>
    <link rel="alternate" type="application/rdf+xml">
      <xsl:attribute name="title">
        <xsl:value-of select="$feed//urfm:Channel/urfm:title[1]"/>
      </xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="@feed"/>
      </xsl:attribute>
    </link>
  </xsl:template>

  <xsl:template match="keywords" mode="head.mode">
    <meta name="keywords" content="{.}"/>
  </xsl:template>

  <xsl:template match="summary" mode="head.mode">
    <meta name="description" content="{.}"/>
  </xsl:template>

</xsl:stylesheet>
