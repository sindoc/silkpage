<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		exclude-result-prefixes=" html rdf dc cvs doap rss xlink atom urfm " 
		version="1.0">
  
  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/links.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Links</dc:title>
    <cvs:date>$Date: 2009-12-07 21:07:39 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>This style sheet provides some templates for generating 
    different link items.</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

  <xsl:template name="links">
    <xsl:param name="page" select="''"/>
    <xsl:param name="altval" select="@altval"/>
    <xsl:param name="id" select="@value"/>
    <xsl:variable name="tocentry" select="$autolayout//*[@id=$id]"/>
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
      <xsl:attribute name="title">
      <xsl:value-of select="$altval"/>
      </xsl:attribute>	
      <xsl:value-of select="$altval"/>
    </a>
  </xsl:template>

<xsl:template name="page-formats">

  <xsl:param name="page" select="."/>
  <xsl:variable name="id" select="@id"/>
  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
  <xsl:if test="$sources.rss10 != ''">
    <xsl:apply-templates select="$page/config[@param='RSS10']"
			 mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$sources.atom != ''">
    <xsl:apply-templates select="$page/config[@param='Atom']" 
			 mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$sources.doap != '' and 
		not(starts-with($page/@id,$sponsor.label))">
    <xsl:apply-templates select="$page/config[@param='DOAP']" 
			 mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$sources.foaf != ''">
    <xsl:apply-templates select="$page/config[@param='FOAF']" 
			 mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$sources.urfm != ''">
    <xsl:apply-templates select="$page//config[@param='URFM']" 
			 mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$sources.rdf != '' and $tocentry">
    <span class="{$rdf.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:call-template name="root-rel-path"/>
	  <xsl:apply-templates select="$tocentry" mode="calculate-dir"/>
	  <xsl:value-of select="$filename-prefix"/>
	  <xsl:choose>
	    <xsl:when test="$tocentry/@filename">
	      <xsl:value-of select="$tocentry/@filename"/>
	      <xsl:value-of select="$rdf.ext"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="'index.html'"/>
	      <xsl:value-of select="$rdf.ext"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$sources.rdf"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$tocentry/title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$sources.rdf"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="$sources.xml != '' and $tocentry">
    <span class="{$xml.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:call-template name="root-rel-path"/>
	  <xsl:value-of select="$tocentry/@page"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$sources.xml"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$tocentry/title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$sources.xml"/>
      </a>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="config[@param='DOAP']|
		     config[@param='URFM']|
		     config[@param='FOAF']|
		     config[@param='Atom']|
		     config[@param='RSS10']"
	      mode="link.mode">
  <xsl:if test="@param='URFM'">
    <span class="{$urfm.label}">
      <a title="{$sources.urfm}">
	<xsl:attribute name="href">
          <xsl:call-template name="sources-href"/>
        </xsl:attribute>
	<xsl:value-of select="$sources.urfm"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@param='RSS10'">
    <span class="{$rss10.label}">
      <a title="{$sources.rss10}">
	<xsl:attribute name="href">
          <xsl:call-template name="sources-href"/>
        </xsl:attribute>
	<xsl:value-of select="$sources.rss10"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@param='DOAP'">
    <xsl:variable name="doap" select="document(@value, /)"/>
    <xsl:variable name="urfm-in-doap" select="document($doap//doap:Project/doap:download-page/@rdf:resource, .)"/>
    <span class="{$doap.label}">
      <a title="{$sources.doap}">
	<xsl:attribute name="href">
          <xsl:call-template name="sources-href"/>
        </xsl:attribute>
	<xsl:value-of select="$sources.doap"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
    <xsl:if test="$urfm-in-doap//urfm:Channel and $sources.urfm != ''">
      <span class="{$urfm.label}">
	<a href="{$doap//doap:Project/doap:download-page/@rdf:resource}"
	   title="{$sources.urfm}">
	  <xsl:value-of select="$sources.urfm"/>
	</a>
	<xsl:text> | </xsl:text>
      </span>
    </xsl:if>
  </xsl:if>
  <xsl:if test="@param='Atom'">
    <span class="{$atom.label}">
      <a title="{$sources.atom}">
	<xsl:attribute name="href">
          <xsl:call-template name="sources-href"/>
        </xsl:attribute>
	<xsl:value-of select="$sources.atom"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@param='FOAF'">
    <span class="{$foaf.label}">
      <a title="{$sources.foaf}">
	<xsl:attribute name="href">
          <xsl:call-template name="sources-href"/>
        </xsl:attribute>
	<xsl:value-of select="$sources.foaf"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template name="sources-href">
  <xsl:variable name="page" select=".."/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="entry" select="$autolayout/autolayout//*[@id=$id]"/>
  <xsl:variable name="dir" select="$entry/ancestor-or-self::tocentry/@dir"/>
  <xsl:choose>
    <xsl:when test="starts-with(@value, 'http://') or starts-with(@value,'https://')">
      <xsl:value-of select="@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="root-rel-path">
        <xsl:with-param name="webpage" select="$page"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="starts-with($dir, '/')">
           <xsl:value-of select="substring($dir, 2)"/>
        </xsl:when>
        <xsl:when test="contains($entry/@page,$entry/@dir)">
          <xsl:value-of select="$entry/@dir"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$dir"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="@value"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rss:title|atom:title|doap:name" mode="link.mode">
</xsl:template>

<xsl:template name="access-skipNav">
  <ul class="skipNav">
    <li>
      <a href="#{$content.label}">
	<xsl:call-template name="gentext.template">
	  <xsl:with-param name="context" select="'Access'"/>
	  <xsl:with-param name="name" select="'SkipToContent'"/>
	</xsl:call-template>
      </a>
    </li>
    <xsl:if test="sidebar">
      <li>
	<a href="#{$sidebar.label}">
	  <xsl:call-template name="gentext.template">
	    <xsl:with-param name="context" select="'Access'"/>
	    <xsl:with-param name="name" select="'SkipToSidebar'"/>
	  </xsl:call-template>
	</a>
      </li>
    </xsl:if>
  </ul>
</xsl:template>

<xsl:template name="link-backtotop">
  <xsl:param name="wrapper" select="'dd'"/>
  <xsl:variable name="text">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="'Directive'"/>
      <xsl:with-param name="name" select="'backtotop'"/>
    </xsl:call-template>    
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$wrapper != ''">
      <xsl:element name="{$wrapper}">
	<xsl:attribute name="class">
	  <xsl:text>backtop</xsl:text>
	</xsl:attribute>
	<span>
	  <a href="#{$header.label}" title="{$text}">
	    <xsl:value-of select="$text"/>
	  </a>
	</span>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <span class="backtop">
	<a href="#{$header.label}" title="{$text}">
	  <xsl:value-of select="$text"/>
	</a>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="config" mode="item.mode">
  <xsl:param name="page"/>
  <xsl:param name="class" select="$footer.label"/>
  <xsl:variable name="position">
    <xsl:choose>
      <xsl:when test="$class=$footer.label">footlink</xsl:when>
      <xsl:when test="$class=$header.label">headlink</xsl:when>
    </xsl:choose>      
  </xsl:variable>
  <xsl:if test="position() &gt; 1">
    <span class="vbar {@value}">
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <span>
    <xsl:attribute name="class">
      <xsl:choose>
	<xsl:when test="$class=$header.label">
	  <xsl:value-of select="$headitem.label"/>
	</xsl:when>
	<xsl:when test="$class=$footer.label">
	  <xsl:value-of select="$footitem.label"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="''"/>
	</xsl:otherwise>
      </xsl:choose>      
      <xsl:text> </xsl:text>
      <xsl:value-of select="@value"/>
    </xsl:attribute>
    <xsl:if test="@param=$position">
      <xsl:choose>
	<xsl:when test="starts-with(@value, 'http://') or
			starts-with(@value, 'https://')">
	  <a href="{@value}" title="{@altval}" target="_blank">
	    <xsl:value-of select="@altval"/>
	  </a>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="links">
	    <xsl:with-param name="page" select="$page"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </span>
</xsl:template>

<xsl:template name="breadcrumb-nav">
  <xsl:param name="page"/>
  <xsl:param name="toc"/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="ancestor" select="$autolayout/autolayout/toc//*[.//*[@id=$id]]"/>
  <ul>
	<!--
	<li class="here">
	<span>
	<xsl:call-template name="gentext.template">
	<xsl:with-param name="context" select="'Meta'"/>
	<xsl:with-param name="name" select="'YouAreHere'"/>
	</xsl:call-template>
	<xsl:value-of select="$biblioentry.item.separator"/>
	<xsl:call-template name="gentext.space"/>
        </span>
        </li>
	-->
    <li class="{$toc/@id}">
      <a>
        <xsl:attribute name="title">
	  <xsl:call-template name="gentext.nav.home"/>
	</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:call-template name="homeuri"/>
	</xsl:attribute>
	<xsl:call-template name="gentext.nav.home"/>
      </a>
    </li>
    <xsl:for-each select="$ancestor">
      <li class="{@id}">
        <span class="navsep">
	  <xsl:value-of select="$nav.breadcrumb.separator"/>
	</span>
	<a title="{summary/text()}">
	  <xsl:attribute name="href">
	    <xsl:call-template name="root-rel-path">
	      <xsl:with-param name="webpage" select="$page"/>
	    </xsl:call-template>
	    <xsl:choose>
	      <xsl:when test="starts-with(@dir, '/')">
		<xsl:value-of select="substring(@dir, 2)"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="@dir"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:value-of select="$filename-prefix"/>
	    <xsl:value-of select="@filename"/>
	  </xsl:attribute>
	  <xsl:value-of select="title/text()"/>
	</a>
      </li>
    </xsl:for-each>
    <li class="{$id}">
      <span class="navsep">
        <xsl:value-of select="$nav.breadcrumb.separator"/>
      </span>
      <span>
	<xsl:value-of select="//head/title[1]"/>
      </span>
    </li>
  </ul>
</xsl:template>

</xsl:stylesheet>
