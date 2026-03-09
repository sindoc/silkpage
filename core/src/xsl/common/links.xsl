<?xml version="1.0"?>
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
    <cvs:date>$Date: 2005-07-28 22:05:51 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>FIXME</dc:description>
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
  <xsl:if test="$viewsrc.rss != ''">
    <xsl:apply-templates select="$page//link[@xlink:role=$namespace.rss]" mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$viewsrc.atom != ''">
    <xsl:apply-templates select="$page//link[@xlink:role=$namespace.atom]" mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$viewsrc.doap != '' and not(starts-with($page/@id,$sponsor.label))">
    <xsl:apply-templates select="$page//link[@xlink:role=$namespace.doap]" mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$viewsrc.foaf != ''">
    <xsl:apply-templates select="$page//link[@xlink:role=$namespace.foaf]" mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$viewsrc.urfm != ''">
    <xsl:apply-templates select="$page//link[@xlink:role=$namespace.urfm]" mode="link.mode"/>
  </xsl:if>
  <xsl:if test="$viewsrc.rdf != '' and $tocentry">
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
	  <xsl:value-of select="$viewsrc.rdf"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$tocentry/title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.rdf"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="$viewsrc.xml != '' and $tocentry">
    <span class="{$xml.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:call-template name="root-rel-path"/>
	  <xsl:value-of select="$tocentry/@page"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.xml"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$tocentry/title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.xml"/>
      </a>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="link" mode="link.mode">
  <xsl:if test="@xlink:role=$namespace.urfm">
    <xsl:variable name="urfm" select="document(@xlink:href, /)"/>
    <span class="{$urfm.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="@xlink:href"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.urfm"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.urfm"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@xlink:role=$namespace.rss">
    <xsl:variable name="rss" select="document(@xlink:href, /)"/>
    <span class="{$rss.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="@xlink:href"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.rss"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$rss//rss:channel/rss:title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.rss"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@xlink:role=$namespace.doap">
    <xsl:variable name="doap" select="document(@xlink:href, /)"/>
    <xsl:variable name="urfm-in-doap" select="document($doap//doap:Project/doap:download-page/@rdf:resource, .)"/>
    <span class="{$doap.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="@xlink:href"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.doap"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$doap//doap:Project/doap:name[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.doap"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
    <xsl:if test="$urfm-in-doap//urfm:Channel and $viewsrc.urfm != ''">
      <span class="{$urfm.label}">
	<a>
	  <xsl:attribute name="href">
	    <xsl:value-of select="$doap//doap:Project/doap:download-page/@rdf:resource"/>
	  </xsl:attribute>
	  <xsl:attribute name="title">
	    <xsl:value-of select="$viewsrc.urfm"/>
	    <xsl:text> - </xsl:text>
	    <xsl:value-of select="$urfm-in-doap//urfm:Channel/urfm:title[1]"/>
	  </xsl:attribute>
	  <xsl:value-of select="$viewsrc.urfm"/>
	</a>
	<xsl:text> | </xsl:text>
      </span>
    </xsl:if>
  </xsl:if>
  <xsl:if test="@xlink:role=$namespace.atom">
    <xsl:variable name="atom" select="document(@xlink:href, /)"/>
    <span class="{$atom.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="@xlink:href"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.atom"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$atom//atom:feed/atom:title[1]"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.atom"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@xlink:role=$namespace.foaf">
    <xsl:variable name="foaf" select="document(@xlink:href, /)"/>
    <span class="{$foaf.label}">
      <a>
	<xsl:attribute name="href">
	  <xsl:value-of select="@xlink:href"/>
	</xsl:attribute>
	<xsl:attribute name="title">
	  <xsl:value-of select="$viewsrc.foaf"/>
	</xsl:attribute>
	<xsl:value-of select="$viewsrc.foaf"/>
      </a>
      <xsl:text> | </xsl:text>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="rss:title|atom:title|doap:name" mode="link.mode">
</xsl:template>

</xsl:stylesheet>
