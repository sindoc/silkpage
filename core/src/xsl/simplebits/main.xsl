<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

<!-- ==================================================================== -->

<xsl:import href="http://silkpage.markupware.com/release/core/current/src/xsl/common/main.xsl"/>
<xsl:include href="header.xsl"/>
<xsl:include href="param.xsl"/>
<xsl:include href="toc.xsl"/>
<xsl:include href="footer.xsl"/>

<rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/simplebits/main.xsl">
  <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
  <dc:format>application/xsl+xml</dc:format>
  <dc:title>SilkPage Core XSLT, SimpleBits Theme, Main Stylesheet</dc:title>
  <cvs:date>$Date: 2006-12-31 14:00:47 $</cvs:date>
  <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
  <dc:description>
    This stylesheet generates the XHTML output for the SimpleBits theme.
  </dc:description>
</rdf:Description>

<xsl:output indent="yes" method="xml" encoding="UTF-8"
	    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:param name="autolayout" select="document($autolayout-file, /*)"/>
<xsl:param name="local.l10n.xml" select="document('../common/l10n.xml')"/>

<xsl:template match="webpage" mode="trl">
  <xsl:apply-templates select="ancestor-or-self::webpage"/>
</xsl:template>
  
<!-- ==================================================================== -->

  <xsl:template match="webpage">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="notoc" select="$autolayout/autolayout/descendant::notoc[@id=$id]"/>
    <xsl:variable name="sidebar" select="descendant::sidebar|$autolayout/autolayout/sidebar"/>
    <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
    <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc                                    |$autolayout/autolayout/toc[1])[last()]"/>
    <xsl:variable name="noprocess" select="'webpage sidebar'"/>
    <xsl:variable name="relpath">
      <xsl:call-template name="root-rel-path">
        <xsl:with-param name="webpage" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="filename">
      <xsl:apply-templates select="." mode="filename"/>
    </xsl:variable>
    <html>
      <xsl:call-template name="html.attributes">
	<xsl:with-param name="type" select="$output.method"/>
      </xsl:call-template>
      <xsl:apply-templates select="head" mode="head.mode"/>
      <xsl:apply-templates select="config" mode="head.mode"/>
      <body id="{@id}">
	<xsl:call-template name="header"/>
	<xsl:call-template name="hr.access"/>
	<div id="{$body.label}">
	  <div id="{$content.label}">
	    <div id="{$content.title.label}">
	      <!-- breadcrumb navigation -->
	      <xsl:if test="@id = $autolayout/autolayout/toc/tocentry//*[$id=@id]/@id and $breadcrumb.label != ''">
		<xsl:call-template name="hr.access"/>
		<div id="{$breadcrumb.label}">
		  <xsl:call-template name="breadcrumb-nav">
		    <xsl:with-param name="page" select="."/>
		    <xsl:with-param name="toc" select="$toc"/>
		  </xsl:call-template>
		</div>
	      </xsl:if>
	      <xsl:apply-templates select="./head/title" mode="title.mode"/>
	      <xsl:apply-templates select="./head/summary" mode="title.mode"/>
	    </div>
	    <xsl:apply-templates select="child::*[not(contains($noprocess,name(.)))]|processing-instruction('php')"/>
	    <!-- sitemap generation -->
	    <xsl:if test="$id = $sitemap.label">
	      <xsl:apply-templates select="$autolayout/autolayout" mode="sitemap">
		<xsl:with-param name="pageid" select="@id"/>
                </xsl:apply-templates>
	      </xsl:if>
	      <!-- content feeds -->
	      <xsl:if test="$id=$feeds.label">
		<xsl:call-template name="feeds"/>
	      </xsl:if>
	      <xsl:apply-templates select="config" mode="external"/>
	      <xsl:call-template name="process.footnotes"/>
	  </div>
	  <xsl:call-template name="hr.access"/>
	  <!-- Sidebar 
	       <xsl:if test="@id != $toc/@id">
	  -->
	  <xsl:if test="$sidebar|$toc">
	    <div id="{$sidebar.label}">
	      <xsl:choose>
		<xsl:when test="$toc">
		  <xsl:apply-templates select="$toc">
		    <xsl:with-param name="pageid" select="@id"/>
		  </xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>&#xA0;</xsl:otherwise>
	      </xsl:choose>
	      <xsl:for-each select="$sidebar">
		<div>
		  <xsl:if test="@id">
		    <xsl:attribute name="id">
		      <xsl:value-of select="@id"/>
		    </xsl:attribute>
		  </xsl:if>
		  <xsl:attribute name="class">
		    <xsl:choose>
		      <xsl:when test="@role">
			<xsl:value-of select="@role"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name(.)"/>
		      </xsl:when>
		      <xsl:when test="@id">
			<xsl:value-of select="@id"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name(.)"/>
		      </xsl:when>
		      <xsl:otherwise>
			<xsl:value-of select="local-name(.)"/>
		      </xsl:otherwise>
		    </xsl:choose>
		  </xsl:attribute>
		  <xsl:apply-templates select="ancestor-or-self::sidebar">
		    <xsl:with-param name="page" select="$id"/>
		  </xsl:apply-templates>
		</div>
	      </xsl:for-each>
	      <xsl:if test="$pages.search-box != ''">
		<xsl:call-template name="user.search-box"/>
	      </xsl:if>
	    </div>
	  </xsl:if>
	  <!--
	      </xsl:if>
	  -->
	</div>
	<xsl:call-template name="hr.access"/>
	<xsl:call-template name="webpage.footer"/>
      </body>
    </html>
  </xsl:template>

<xsl:template match="head/summary" mode="title.mode">
  <p class="{local-name(.)}">
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
