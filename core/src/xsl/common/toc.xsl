<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html rdf dc cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/toc.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common ToC</dc:title>
    <cvs:date>$Date: 2006-12-31 13:55:06 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

  <xsl:param name="toc.expand.depth" select="1"/>
  <xsl:param name="nav.revisionflag" select="1"/>

<!-- ==================================================================== -->

  <xsl:template match="toc/title|tocentry/title|titleabbrev|notoc/title">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="toc|tocentry|notoc" mode="toc-rel-path">
    <xsl:call-template name="toc-rel-path"/>
  </xsl:template>
  <xsl:template name="toc-rel-path">
    <xsl:param name="pageid" select="@id"/>
    <xsl:variable name="entry" select="$autolayout//*[@id=$pageid]"/>
    <xsl:variable name="filename" select="concat($entry/@dir,$entry/@filename)"/>
    <xsl:variable name="slash-count">
      <xsl:call-template name="toc-directory-depth">
        <xsl:with-param name="filename" select="$filename"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="depth">
      <xsl:choose>
        <xsl:when test="starts-with($filename, '/')">
          <xsl:value-of select="$slash-count - 1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$slash-count"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$depth &gt; 0">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string">../</xsl:with-param>
        <xsl:with-param name="count" select="$depth"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="toc-directory-depth">
    <xsl:param name="filename"/>
    <xsl:param name="count" select="0"/>
    <xsl:choose>
      <xsl:when test="contains($filename,&quot;/&quot;)">
        <xsl:call-template name="toc-directory-depth">
          <xsl:with-param name="filename" select="substring-after($filename,'/')"/>
          <xsl:with-param name="count" select="$count + 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$count"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="summary">
<!-- nop; -->
  </xsl:template>
  <xsl:template name="navitems">
    <xsl:param name="pageid"/>
    <xsl:param name="toclevel" select="count(ancestor::*)"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:param name="revisionflag" select="@revisionflag"/>
    <xsl:param name="mark.current.page" select="1"/>
    <xsl:param name="link.wrapper" select="''"/>
    <xsl:variable name="page" select="."/>
    <xsl:variable name="target" select="($page/descendant-or-self::tocentry[@tocskip = '0']             |$page/following::tocentry[@tocskip='0'])[1]      |$page[name(.) = 'notoc']"/>
    <xsl:variable name="navitem-value">
      <xsl:choose>
	<xsl:when test="titleabbrev">
          <xsl:apply-templates select="titleabbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$pageid = @id and $mark.current.page != ''">
	<xsl:attribute name="class">
	  <xsl:value-of select="$nav.current.label"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="@id"/>
	</xsl:attribute>
	<span>
	  <xsl:value-of select="$navitem-value"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="*//*[@id=$pageid] or *[@id=$pageid]">
	    <xsl:attribute name="class">
	      <xsl:value-of select="$nav.ancestor.label"/>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@id"/>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="class">
	      <xsl:value-of select="@id"/>
	    </xsl:attribute>    
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:call-template name="link.to.page">
          <xsl:with-param name="href" select="@href"/>
          <xsl:with-param name="page" select="$target"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="linktext">
            <xsl:choose>
              <xsl:when test="$link.wrapper != ''">
                <xsl:element name="{$link.wrapper}">
                  <xsl:value-of select="$navitem-value"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$navitem-value"/>
              </xsl:otherwise>
            </xsl:choose>
	    <xsl:if test="$nav.revisionflag != '0' and $revisionflag">
              <span class="{$revisionflag}">
		<xsl:value-of select="$revisionflag"/>
	      </span>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
