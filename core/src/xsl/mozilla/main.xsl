<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

<xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website-common.xsl"/>
<xsl:include href="../common/sitemap.xsl"/>
<xsl:include href="toc.xsl"/>
<xsl:include href="footer.xsl"/>
<xsl:include href="header.xsl"/>
<xsl:include href="param.xsl"/>

<xsl:output indent="yes"
            method="xml"
            encoding="UTF-8"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

<xsl:param name="autolayout" select="document($autolayout-file, /*)"/>

<!-- ==================================================================== -->

<xsl:template match="webpage">

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="hassidebar">
    <xsl:choose>
      <xsl:when test="@id = $autolayout/autolayout/toc//*/@id">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="." mode="filename"/>
  </xsl:variable>

  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <html>
    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>
    <body id="www-mozilla-org">
      <div id="container">

  <p class="skipLink">
    <a accesskey="2" href="#{$content.label}">
      <xsl:text>Skip to main content</xsl:text>
    </a>
  </p>
      <xsl:call-template name="header"/>
	<div id="mBody">
        <xsl:choose>
          <xsl:when test="$toc">
            <xsl:apply-templates select="$toc">
              <xsl:with-param name="pageid" select="@id"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>

        <div>
	  <xsl:attribute name="id">
	    <xsl:value-of select="$content.label"/>
	  </xsl:attribute>
	  <xsl:if test="$hassidebar != '0'">
	    <xsl:attribute name="class">
	      <xsl:text>right</xsl:text>
	    </xsl:attribute>
	  </xsl:if>
          <xsl:apply-templates select="./head/title" mode="title.mode"/>
          <xsl:apply-templates select="child::*[name(.) != 'webpage']"/>
	  <xsl:if test="@id = $sitemap.label">
	    <xsl:call-template name="sitemap">
	      <xsl:with-param name="pageid" select="@id"/>
	    </xsl:call-template>
	  </xsl:if>
          <xsl:call-template name="process.footnotes"/>
        </div>
	</div>
        <xsl:call-template name="webpage.footer"/>
      </div>
    </body>
  </html>
</xsl:template>

<xsl:template match="title" mode="head.mode">
  <xsl:param name="pageid" select="../../@id"/>
  <xsl:variable name="title"
                select="$autolayout/autolayout/config[@param='title'][1]"/>
  <title>
    <xsl:choose>
      <xsl:when test="$title and $pageid != $autolayout/autolayout/toc/@id">
        <xsl:value-of select="$title/@value"/>
        <xsl:text> - </xsl:text>
	<xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </title>
</xsl:template>

<xsl:template match="webtoc">
  <!-- nop -->
</xsl:template>

<xsl:template name="user.search-box">
  <xsl:param name="node" select="."/>
</xsl:template>


<xsl:template name="items">
  <xsl:param name="page" select="''"/>
  <xsl:param name="altval" select="@altval"/>
  <xsl:param name="id" select="@value"/>
  <xsl:variable name="tocentry"
                select="$autolayout//*[@id=$id]"/>
  <xsl:if test="count($tocentry) != 1">
          <xsl:message>
	    <xsl:value-of select="@param"/>
            <xsl:text> link to </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> does not id a unique page.</xsl:text>
          </xsl:message>
        </xsl:if>
        <xsl:variable name="dir">
          <xsl:choose>
            <xsl:when test="starts-with($tocentry/@dir, '/')">
              <xsl:value-of select="substring($tocentry/@dir, 2)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$tocentry/@dir"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="root-rel-path">
	      <xsl:with-param name="webpage" select="$page"/>
	    </xsl:call-template>
            <xsl:value-of select="$dir"/>
            <xsl:value-of select="$filename-prefix"/>
            <xsl:value-of select="$tocentry/@filename"/>
          </xsl:attribute>
          <xsl:value-of select="$altval"/>
        </a>
</xsl:template>

</xsl:stylesheet>
