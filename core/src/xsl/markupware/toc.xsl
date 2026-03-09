<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                exclude-result-prefixes="html"
                version='1.0'>

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

  <xsl:if test="descendant::tocentry">
    <div>
      <xsl:attribute name="id">
        <xsl:value-of select="$primnav.label"/>
      </xsl:attribute>
      <ul>
        <xsl:apply-templates select="tocentry" mode="primnav">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
      <xsl:choose>
        <xsl:when test="*[not(tocentry)][@id=$pageid]">
        </xsl:when>
        <xsl:when test="../*/@id=$pageid">
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="$secnav.label"/>
            </xsl:attribute>
            <ul>
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
<!-- ==================================================================== -->
  <xsl:template match="tocentry">
    <xsl:param name="pageid"/>
    <xsl:param name="link.emphasis" select="'1'"/>
    <xsl:param name="toclevel" select="count(ancestor::*)"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:if test="ancestor::*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="mark.current.page" select="1"/>
          <xsl:with-param name="link.emphasis" select="$link.emphasis"/>
        </xsl:call-template>
      </li>
    </xsl:if>
    <xsl:if test="..//*[@id=$pageid]">
      <li>
        <xsl:call-template name="navitems">
          <xsl:with-param name="pageid" select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="mark.current.page" select="1"/>
          <xsl:with-param name="link.emphass" select="$link.emphasis"/>
        </xsl:call-template>
        <xsl:if test="descendant::tocentry">
          <ul>
            <xsl:apply-templates select="tocentry">
              <xsl:with-param name="pageid" select="$pageid"/>
              <xsl:with-param name="relpath" select="$relpath"/>
              <xsl:with-param name="link.emphasis" select="''"/>
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

<xsl:template match="tocentry" mode="primnav">
  <xsl:param name="pageid" select="@id"/>
  <xsl:param name="relpath" select="''"/>

  <xsl:variable name="position" select="count(preceding-sibling::*)-1"/>

  <li>
    <xsl:if test="*//*[@id=$pageid] or *[@id=$pageid]">
      <xsl:attribute name="class">
        <xsl:value-of select="$primnav.label"/>
        <xsl:value-of select="$nav.ancestor.label"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$primnav.label != ''">
      <xsl:attribute name="class">
<!--
	<xsl:call-template name="item-position">
	  <xsl:with-param name="prefix" select="''"/>
	  <xsl:with-param name="input" select="$position"/>
	</xsl:call-template>
-->
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="navitems">
      <xsl:with-param name="pageid" select="$pageid"/>
      <xsl:with-param name="relpath" select="$relpath"/>
      <xsl:with-param name="link.span" select="'1'"/>
    </xsl:call-template>
  </li>
</xsl:template>

</xsl:stylesheet>
