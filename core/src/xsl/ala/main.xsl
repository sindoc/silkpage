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
  <xsl:include href="../silkpage/footer.xsl"/>
  <xsl:include href="../silkpage/toc.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/silkpage/main.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, ALA Theme's Main Stylesheet</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:48 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
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
        <xsl:when test="$notoc|$toc[@id=$id]|$autolayout/autolayout/toc//*[not(descendant::tocentry) and not(ancestor::tocentry)][@id=$id]">0</xsl:when>
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
        <div id="wrapper">
          <xsl:call-template name="header"/>
          <xsl:choose>
            <xsl:when test="$toc">
              <xsl:apply-templates select="$toc" mode="header.wrap">
                <xsl:with-param name="pageid" select="$id"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>&#xA0;</xsl:otherwise>
          </xsl:choose>
          <div id="{$body.label}" class="{@id}">
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
            <xsl:if test="$sidebar|$toc">
              <div id="{$sidebar.label}">
                <div id="{$subnav.label}">
                  <xsl:choose>
                    <xsl:when test="$sidebar and count($sidebar)='1'">
                      <xsl:attribute name="class">
                        <xsl:value-of select="$sidebar/@id"/>
                      </xsl:attribute>
	<xsl:choose>
                        <xsl:when test="$toc">
                          <xsl:apply-templates select="$toc">
                            <xsl:with-param name="pageid" select="@id"/>
                          </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>&#xA0;</xsl:otherwise>
                      </xsl:choose>
                      <xsl:apply-templates select="$sidebar">
                        <xsl:with-param name="page" select="$id"/>
                      </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
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
                      <xsl:if test="$pages.search-box != ''">
                        <xsl:call-template name="user.search-box"/>
                        <xsl:call-template name="hr.access"/>
                      </xsl:if>
                </div>
              </div>
              <xsl:call-template name="hr.access"/>
            </xsl:if>
          </div>
          <xsl:call-template name="webpage.footer"/>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="page.presentation">
    <xsl:param name="sidebar" select="''"/>
    <xsl:param name="secnav" select="''"/>
    <xsl:choose>
      <xsl:when test="$sidebar != '0' and $secnav = '0'">
        <xsl:attribute name="class">
          <xsl:text>twocol sidebar</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$secnav != '0' and $sidebar = '0'">
        <xsl:attribute name="class">
          <xsl:text>twocol sidebar</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$secnav != '0' and $sidebar != '0'">
        <xsl:attribute name="class">
          <xsl:text>twocol sidebar</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$secnav = '0' and $sidebar = '0'">
        <xsl:attribute name="class">
          <xsl:text>onecol</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">
          <xsl:text>Style sheet cannot detect presentation state of the page.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="title" mode="head.mode">
    <xsl:param name="id" select="/webpage/@id"/>
    <xsl:variable name="title" select="$autolayout/autolayout/config[@param='title'][1]"/>
    <title>
      <xsl:choose>
        <xsl:when test="$title">
          <xsl:choose>
            <xsl:when test="$autolayout/autolayout/toc[@id=$id]">
              <xsl:value-of select="$title/@value"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$title/@value"/>
              <xsl:text> - </xsl:text>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>
</xsl:stylesheet>
