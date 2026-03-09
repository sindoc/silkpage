<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                exclude-result-prefixes="html"
                version='1.0'>

<xsl:import href="http://silkpage.markupware.com/release/core/current/src/xsl/common/main.xsl"/>
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

  <xsl:variable name="notoc" select="$autolayout/autolayout/descendant::notoc[@id=$id]"/>
  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <xsl:variable name="noprocess" select="'webpage sidebar'"/>

  <xsl:variable name="hassidebar">
    <xsl:choose>
      <xsl:when test="not(child::sidebar)">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="hassecnav">
    <xsl:choose>
      <xsl:when test="$notoc
	|$toc[@id=$id]
	|$autolayout/autolayout/toc//*[not(descendant::tocentry) and not(ancestor::tocentry)][@id=$id]
	">0</xsl:when>
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

  <html>
    <xsl:apply-templates select="head" mode="head.mode"/>
    <xsl:apply-templates select="config" mode="head.mode"/>
    <body>
      <xsl:call-template name="page.presentation">
        <xsl:with-param name="sidebar" select="$hassidebar"/>
        <xsl:with-param name="secnav" select="$hassecnav"/>
      </xsl:call-template>
      <xsl:call-template name="header"/>
        <xsl:choose>
          <xsl:when test="$toc">
            <xsl:apply-templates select="$toc">
              <xsl:with-param name="pageid" select="@id"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
	<!-- Sidebar -->
	  <xsl:if test="sidebar[1] or $autolayout/autolayout/sidebar[1]">
  	    <div>
 	      <xsl:attribute name="id">
	        <xsl:value-of select="$sidebar.label"/>
	      </xsl:attribute>
	      <xsl:apply-templates select="sidebar[1]"/>
              <xsl:apply-templates select="$autolayout/autolayout/sidebar[1]">
		<xsl:with-param name="page" select="$id"/>
	      </xsl:apply-templates>
	    </div>
	  </xsl:if>
        <div>
	  <xsl:attribute name="id">
	    <xsl:value-of select="$content.label"/>
	  </xsl:attribute>
    	    <xsl:if test="$viewsrc.label != ''">
	      <xsl:call-template name="viewsrc"/>
	    </xsl:if>

          <xsl:apply-templates select="./head/title" mode="title.mode"/>
          <xsl:apply-templates select="child::*[not(contains($noprocess,name(.)))]"/>
	  <xsl:if test="@id = $sitemap.label">
	    <xsl:call-template name="sitemap">
	      <xsl:with-param name="pageid" select="@id"/>
	    </xsl:call-template>
	  </xsl:if>
          <xsl:call-template name="process.footnotes"/>
	</div>
        <xsl:call-template name="webpage.footer"/>
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

<xsl:template match="sidebar">
  <xsl:param name="page" select="''"/>
  <xsl:apply-templates>
    <xsl:with-param name="webpage" select="$page"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template name="page.presentation">

  <xsl:param name="sidebar" select="''"/>
  <xsl:param name="secnav" select="''"/>

  <xsl:choose>
    <xsl:when test="$sidebar != '0' and $secnav = '0'">
      <xsl:attribute name="class">
        <xsl:text>twocol sidebar</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$secnav != '0' and $sidebar = '0'">
      <xsl:attribute name="class">
        <xsl:text>twocol secnav</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$secnav != '0' and $sidebar != '0'">
      <xsl:attribute name="class">
        <xsl:text>threecol</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$secnav = '0' and $sidebar = '0'">
      <xsl:attribute name="class">
        <xsl:text>onecol</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
        <xsl:text>Style sheet cannot detect presentation state of the page.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="hr.hide">
   <hr class="hide"/>
</xsl:template>

</xsl:stylesheet>
