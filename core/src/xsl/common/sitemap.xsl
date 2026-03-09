<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/sitemap.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Sitemap</dc:title>
    <cvs:date>$Date: 2006-12-14 10:26:53 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This stylesheet generates a sitemap based on the site layout.
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

<xsl:template match="autolayout" mode="sitemap">
  <xsl:param name="pageid" select="''"/>

  <xsl:variable name="relpath">
    <xsl:call-template name="toc-rel-path">
      <xsl:with-param name="pageid" select="$pageid"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:apply-templates select="toc" mode="sitemap">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:apply-templates>
  <div class="notoc">
    <h2>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'Meta'"/>
        <xsl:with-param name="name" select="'notoc'"/>
      </xsl:call-template>
      <xsl:call-template name="link-backtotop">
        <xsl:with-param name="wrapper" select="''"/>
      </xsl:call-template>
    </h2>
    <ul class="notoc">
      <xsl:apply-templates select="notoc" mode="sitemap">
        <xsl:with-param name="pageid" select="$pageid"/>
        <xsl:with-param name="relpath" select="$relpath"/>
      </xsl:apply-templates>
    </ul>
  </div>
</xsl:template>

<xsl:template name="sitemap.tocentry">
  <xsl:param name="pageid"/>
  <xsl:param name="relpath"/>
  <li class="{@id}">
    <p class="{@id}">
    <xsl:call-template name="navitems">
      <xsl:with-param name="pageid" select="$pageid"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:call-template>
    <xsl:apply-templates select="summary" mode="sitemap"/>
	<!--
      <xsl:if test="sitemap.pageformats = '1'">
	<dd class="formats">
	  <ul>
	    <xsl:call-template name="page-formats">
	      <xsl:with-param name="page" select="document(@page, /)"/>
	      <xsl:with-param name="dir" select="@dir"/>
	    </xsl:call-template>
	  </ul>
	</dd>
      </xsl:if>
      <xsl:if test="@id = /autolayout/toc/*/@id">
	<xsl:call-template name="link-backtotop"/>
      </xsl:if>
	-->
    </p>
    <xsl:if test="descendant::tocentry">
      <ul>
	<xsl:apply-templates select="tocentry" mode="sitemap">
	  <xsl:with-param name="pageid" select="$pageid"/>
	  <xsl:with-param name="relpath" select="$relpath"/>
	</xsl:apply-templates>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

<xsl:template match="summary" mode="sitemap">
  <span class="hbar">
    <xsl:text>&#8212;</xsl:text>
  </span>
  <span class="{local-name(.)} {../@id}">
    <xsl:apply-templates mode="sitemap"/>
  </span>
</xsl:template>

<xsl:template match="notoc" mode="sitemap">
  <xsl:param name="pageid" select="''"/>
  <xsl:param name="relpath" select="''"/>
  <xsl:call-template name="sitemap.tocentry">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="toc" mode="sitemap">
  <xsl:param name="pageid"/>
  <xsl:param name="relpath"/>
  <ul class="{local-name(.)}">
    <xsl:apply-templates select="tocentry" mode="sitemap">
      <xsl:with-param name="pageid" select="$pageid"/>
      <xsl:with-param name="relpath" select="$relpath"/>
    </xsl:apply-templates>
  </ul>
</xsl:template>

<xsl:template match="tocentry" mode="sitemap">
  <xsl:param name="pageid"/>
  <xsl:param name="relpath"/>
  <xsl:call-template name="sitemap.tocentry">
    <xsl:with-param name="pageid" select="$pageid"/>
    <xsl:with-param name="relpath" select="$relpath"/>    
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
