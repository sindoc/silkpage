<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/0.1/"
		exclude-result-prefixes=" html rdf dc cvs rss urfm " 
		version="1.0">
  
  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/header.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common HTML Header</dc:title>
    <cvs:date>$Date: 2005-08-18 16:33:10 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This stylesheet contains some common templates needed in page headers
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->


<xsl:template name="translations">
  <xsl:param name="page"/>
  <xsl:variable name="tocentry" select="$autolayout/autolayout//*[@id=$page/@id]"/>
  <xsl:if test="$autolayout/autolayout/config[@param=$trl.label]/@value != ''">
    <ul id="{$trls.label}">
      <li>
	<xsl:choose>
	  <xsl:when test="@lang=$l10n.gentext.default.language or not(@lang)">
	    <xsl:call-template name="gentext.template">
	      <xsl:with-param name="context" select="'Languages'"/>
	      <xsl:with-param name="name" select="$l10n.gentext.default.language"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:when test="$tocentry/@id = $page/@id and 
			  @lang != $l10n.gentext.default.language">
	    <a href="{$tocentry/@filename}" title="{$tocentry/title[1]}">
	      <xsl:call-template name="gentext.template">
		<xsl:with-param name="context" select="'Languages'"/>
		<xsl:with-param name="name" select="$l10n.gentext.default.language"/>
	      </xsl:call-template>
	    </a>
	  </xsl:when>
	</xsl:choose>
      </li>
      <xsl:apply-templates select="$autolayout/autolayout/config" 
			   mode="trl.mode">
	<xsl:with-param name="page" select="$page"/>
      </xsl:apply-templates>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="config" mode="trl.mode">
  <xsl:param name="page"/>
  <xsl:variable name="tocentry" select="//*[@id=$page/@id]"/>
  <xsl:variable name="href" select="concat($tocentry/@filename,'.',@value)"/>
  <xsl:if test="@param=$trl.label">
    <li>
      <a href="{$href}">
	<xsl:call-template name="gentext.template">
	  <xsl:with-param name="context" select="'Languages'"/>
	  <xsl:with-param name="name" select="@value"/>
	</xsl:call-template>
      </a>
    </li>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
