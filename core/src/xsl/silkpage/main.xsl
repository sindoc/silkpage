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
  <xsl:include href="footer.xsl"/>
  <xsl:include href="toc.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage/main.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, SilkPage Theme's Main Stylesheet</dc:title>
    <cvs:date>$Date: 2005-08-10 15:40:37 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>
      This is the main stylesheet of SilkPage theme.
    </dc:description>
  </rdf:Description>
  
  <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

  <xsl:param name="autolayout" select="document($autolayout-file, /*)"/>
  <xsl:param name="local.l10n.xml" select="document('../common/l10n.xml')"/>

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
    <xsl:variable name="hassidebar">
      <xsl:choose>
        <xsl:when test="not(child::sidebar)">0</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="hassecnav">
      <xsl:choose>
        <xsl:when test="$notoc  |$toc[@id=$id]  |$autolayout/autolayout/toc//*[not(descendant::tocentry) and not(ancestor::tocentry)][@id=$id]  ">0</xsl:when>
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
      <xsl:call-template name="html.attributes">
        <xsl:with-param name="type" select="$output.method"/>
      </xsl:call-template>
      <xsl:apply-templates select="head" mode="head.mode"/>
      <xsl:apply-templates select="config" mode="head.mode"/>
      <body>
        <xsl:call-template name="page.presentation">
          <xsl:with-param name="sidebar" select="$hassidebar"/>
          <xsl:with-param name="secnav" select="$hassecnav"/>
        </xsl:call-template>
        <xsl:call-template name="header"/>
        <div id="{$body.label}" class="{@id}">
          <xsl:choose>
            <xsl:when test="$toc">
              <xsl:apply-templates select="$toc">
                <xsl:with-param name="pageid" select="@id"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>&#xA0;</xsl:otherwise>
          </xsl:choose>
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="$content.label"/>
            </xsl:attribute>
            <xsl:apply-templates select="./head/title" mode="title.mode"/>
	    <xsl:apply-templates select="child::*[not(contains($noprocess,name(.)))]"/>
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
            <xsl:call-template name="process.footnotes"/>
          </div>
	  <xsl:call-template name="hr.access"/>
<!-- Sidebar -->
          <xsl:if test="$sidebar">
            <div id="{$sidebar.label}">
   	      <xsl:choose>
	        <xsl:when test="count($sidebar)='1'">
              	  <xsl:attribute name="class">
	            <xsl:value-of select="$sidebar/@id"/>
         	  </xsl:attribute>
                  <xsl:apply-templates select="$sidebar">
                    <xsl:with-param name="page" select="$id"/>
                  </xsl:apply-templates>
	        </xsl:when>
	        <xsl:otherwise>
		  <xsl:for-each select="$sidebar">
		    <div>
      		      <xsl:if test="@id">
		        <xsl:attribute name="class">
		          <xsl:value-of select="@id"/>
		        </xsl:attribute>
		      </xsl:if>
	             <xsl:apply-templates select="ancestor-or-self::sidebar">
        	       <xsl:with-param name="page" select="$id"/>
	             </xsl:apply-templates>
		   </div>
		 </xsl:for-each>
	       </xsl:otherwise>
	      </xsl:choose>
            </div>
          </xsl:if>
	  <xsl:call-template name="hr.access"/>
          <xsl:call-template name="webpage.footer"/>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
