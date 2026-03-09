<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:a="http://www.w3.org/2005/Atom" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:date="http://exslt.org/dates-and-times"
		exclude-result-prefixes=" html rdf dc cvs rss cvsf date a "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/atom.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Atom</dc:title>
    <cvs:date>$Date: 2009-12-07 21:07:39 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>Processing Atom 1.0 feeds with XSLT</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:template match="a:feed">
    <xsl:param name="ancestor"/>
    <xsl:apply-templates select="a:entry">
      <xsl:with-param name="ancestor" select="$ancestor"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="a:entry">
    <xsl:param name="ancestor"/>
    <div class="{local-name(.)}">
      <xsl:apply-templates select="a:title[1]"/>
      <!-- Need for categories?
      <xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Atom'"/>
	<xsl:with-param name="name" select="'Categories'"/>
      </xsl:call-template>
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:call-template name="gentext.space"/>        
      <xsl:apply-templates select="a:category" mode="categories"/>
      -->
      <p class="date">
	<xsl:call-template name="feed.date.format">
      	  <xsl:with-param name="node" select="a:updated"/>
          <xsl:with-param name="ancestor" select="$ancestor"/>
	</xsl:call-template>
      </p>
      <xsl:apply-templates select="a:content"/>
    </div>
  </xsl:template>

  <xsl:template match="a:category" mode="categories">
    <xsl:value-of select="@term"/>
    <xsl:if test="position() != last()">
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="a:*"/>
  <xsl:template match="*" mode="links"/>
  <xsl:template match="*" mode="categories"/>

  <xsl:template match="a:content[@type='text']|a:summary[@type='text']">
    <xsl:param name="wrapper" select="'p'"/>
    <xsl:element name="{$wrapper}">
      <xsl:call-template name="insert.class">
	<xsl:with-param name="value" select="$description.label"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a:content[@type='xhtml']|a:summary[@type='xhtml']">
    <xsl:param name="wrapper" select="'div'"/>
    <xsl:element name="{$wrapper}">
      <xsl:call-template name="insert.class">
	<xsl:with-param name="value" select="$description.label"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a:title">
    <xsl:param name="wrapper" select="'h3'"/>
    <xsl:element name="{$wrapper}">
      <xsl:choose>
        <xsl:when test="../a:link[@type = 'text/html']">
	  <a href="{../a:link[@type = 'text/html'][1]/@href}">
	    <xsl:apply-templates/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>


  <xsl:template match="a:subtitle">
    <xsl:param name="wrapper" select="'p'"/>
    <xsl:element name="{$wrapper}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
