<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
		xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'
		xmlns:dc='http://purl.org/dc/elements/1.1/'
		xmlns:cvs='http://www.markupware.com/metadata/cvs#'
                exclude-result-prefixes=" html rdf dc cvs "
                version='1.0'>

<rdf:Description rdf:about=''>
  <rdf:type rdf:resource="FIXME"/>
  <dc:type rdf:resource='http://purl.org/dc/dcmitype/Text'/>
  <dc:format>application/xsl+xml</dc:format>
  <dc:title>FIXME</dc:title>
  <dc:date>2004-05-12</dc:date>
  <cvs:date>$Date: 2005-07-28 22:05:55 $</cvs:date>
  <dc:rights>Copyright &#169; 2004 MarkupWare. All rights reserved.</dc:rights>
  <dc:description>FIXME</dc:description>
</rdf:Description>

<xsl:output indent="yes"
            method="xml"/>

<!-- ==================================================================== -->

<xsl:template name="header">

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

