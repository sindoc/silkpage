<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exslt">

<xsl:output indent="yes"
            method="xml"/>

<!-- ==================================================================== -->

<xsl:template name="header">

  <xsl:variable name="id" select="@id"/>
  <xsl:variable name="page" select="."/>
  <xsl:variable 
	name="headitems"
	select="$page/config[@param='headlink']
		|$page/config[@param='header']
		|$autolayout/autolayout/config[@param='headlink']
		|$autolayout/autolayout/config[@param='header']"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="banner-left"
                select="$autolayout/autolayout/config[@param='banner-left'][1]"/>
  <xsl:variable name="banner-right"
                select="$autolayout/autolayout/config[@param='banner-right'][1]"/>

  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc
                                   |$autolayout/autolayout/toc[1])[last()]"/>

  <div>
    <xsl:attribute name="id">
      <xsl:value-of select="$header.label"/>
    </xsl:attribute>
    <h1>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$relpath"/>
        <xsl:value-of select="$autolayout/autolayout/toc[1]/@filename"/>
      </xsl:attribute>
      <xsl:value-of select="$autolayout/autolayout/config[@param='title'][1]/@value"/>
    </a>
    </h1>
    <xsl:choose>
      <xsl:when test="$toc">
        <xsl:apply-templates select="$toc" mode="header.wrap">
          <xsl:with-param name="pageid" select="$id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>&#160;</xsl:otherwise>
    </xsl:choose>

      <xsl:if test="$pages.search-box != ''">
        <xsl:call-template name="user.search-box"/>
      </xsl:if>

    <xsl:if test="$headitems.label != ''">
      <ul>
	<xsl:apply-templates select="$headitems" mode="header.item.mode">
 	  <xsl:with-param name="page" select="$page"/>
        </xsl:apply-templates>
      </ul>
    </xsl:if>
  </div>
  <hr class="hide"/>
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
        <a href="{@value}">
          <xsl:value-of select="@altval"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>

</xsl:stylesheet>

