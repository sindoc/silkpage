<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
  <xsl:include href="../common/utils.xsl"/>
  <xsl:include href="../common/toc.xsl"/>
  <xsl:output method="html"/>
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
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="$navmenu.label"/>
            </xsl:attribute>
            <ul id="nav">
              <xsl:apply-templates select="tocentry/tocentry">
                <xsl:with-param name="pageid" select="$pageid"/>
                <xsl:with-param name="relpath" select="$relpath"/>
              </xsl:apply-templates>
            </ul>
          </div>
	  <hr class="hide"/>
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
    <ul>
      <xsl:apply-templates select="tocentry" mode="navbar">
        <xsl:with-param name="pageid" select="$pageid"/>
        <xsl:with-param name="relpath" select="$relpath"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>
<!-- ==================================================================== -->
  <xsl:template match="tocentry">
    <xsl:param name="pageid"/>
    <xsl:param name="toclevel" select="count(ancestor::*)"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:if test="ancestor::*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="link.wrapper" select="'emphasis'"/>
        </xsl:call-template>
      </li>
    </xsl:if>
    <xsl:if test="..//*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="link.wrapper" select="'emphasis'"/>
          <xsl:with-param name="mark.current.page" select="''"/>
        </xsl:call-template>
        <xsl:if test="descendant::tocentry">
          <ul>
            <xsl:apply-templates select="tocentry">
              <xsl:with-param name="pageid" select="$pageid"/>
              <xsl:with-param name="relpath" select="$relpath"/>
              <xsl:with-param name="link.emphasis" select="''"/>
              <xsl:with-param name="mark.current.page" select="''"/>
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tocentry" mode="navbar">
    <xsl:param name="pageid" select="@id"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:variable name="position" select="count(preceding-sibling::*)-1"/>
    <li>
      <xsl:if test="$navbar.label != ''">
        <xsl:attribute name="id">
	  <xsl:value-of select="$navbar.label"/>
	  <xsl:text>_</xsl:text>
	  <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="navitems">
        <xsl:with-param name="pageid" select="$pageid"/>
        <xsl:with-param name="relpath" select="$relpath"/>
        <xsl:with-param name="link.wrapper" select="'emphasis'"/>
        <xsl:with-param name="mark.current.page" select="''"/>
      </xsl:call-template>
    </li>
  </xsl:template>
</xsl:stylesheet>
