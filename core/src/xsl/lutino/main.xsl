<?xml version='1.0'?>
<!-- =============================================================================
     Lutino SilkPage Theme — Main XSL
     Transforms SilkPage/DocBook Website XML to HTML using the Lutino design
     system. Follows the structure of core/src/xsl/butterfly/main.xsl.
     ============================================================================= -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website-common.xsl"/>
  <xsl:include href="toc.xsl"/>

  <xsl:output indent="yes"
              method="xml"
              encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

  <xsl:param name="autolayout" select="document($autolayout-file, /*)"/>

  <!-- CSS base URL — override at build time via -param css.base.url -->
  <xsl:param name="css.base.url">../../core/src/css/lutino/</xsl:param>
  <!-- Site display name -->
  <xsl:param name="site.title">AI Life</xsl:param>
  <xsl:param name="site.subtitle">Scenarios from AI's life</xsl:param>
  <!-- Copyright -->
  <xsl:param name="copyright.year">2025</xsl:param>
  <xsl:param name="copyright.holder">Lutino / SinDoc</xsl:param>

  <!-- ======================================================================
       Root
       ====================================================================== -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ======================================================================
       Webpage
       ====================================================================== -->
  <xsl:template match="webpage">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="relpath">
      <xsl:call-template name="root-rel-path">
        <xsl:with-param name="webpage" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
    <xsl:variable name="toc"
                  select="($tocentry/ancestor-or-self::toc
                          |$autolayout/autolayout/toc[1])[last()]"/>

    <html lang="en">
      <xsl:call-template name="page.head">
        <xsl:with-param name="relpath" select="$relpath"/>
      </xsl:call-template>
      <body>
        <div id="page-wrapper">
          <!-- Banner -->
          <xsl:call-template name="allpages.banner">
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
          <!-- Body grid -->
          <div class="layout-body">
            <!-- Left: TOC -->
            <div class="navtoc-wrapper">
              <xsl:choose>
                <xsl:when test="$toc">
                  <xsl:apply-templates select="$toc">
                    <xsl:with-param name="pageid" select="@id"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise><nav class="navtoc"></nav></xsl:otherwise>
              </xsl:choose>
            </div>
            <!-- Right: content -->
            <main id="mainContent">
              <!-- Page title -->
              <xsl:apply-templates select="head/title" mode="page.title.mode"/>
              <!-- Page properties (from <meta> elements) -->
              <xsl:call-template name="page.properties"/>
              <!-- Content blocks -->
              <xsl:apply-templates select="child::*[name(.) != 'webpage' and name(.) != 'head']"/>
              <xsl:call-template name="process.footnotes"/>
            </main>
          </div>
          <!-- Footer -->
          <xsl:call-template name="page.footer">
            <xsl:with-param name="relpath" select="$relpath"/>
          </xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ======================================================================
       <head> element
       ====================================================================== -->
  <xsl:template name="page.head">
    <xsl:param name="relpath" select="''"/>
    <head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <xsl:apply-templates select="head" mode="head.mode"/>
      <!-- Theme CSS -->
      <link rel="stylesheet" type="text/css">
        <xsl:attribute name="href">
          <xsl:value-of select="$relpath"/>
          <xsl:value-of select="$css.base.url"/>
          <xsl:text>main.css</xsl:text>
        </xsl:attribute>
      </link>
    </head>
  </xsl:template>

  <!-- title in <head> -->
  <xsl:template match="title" mode="head.mode">
    <xsl:variable name="site" select="$autolayout/autolayout/config[@param='title'][1]"/>
    <title>
      <xsl:if test="$site">
        <xsl:value-of select="$site/@value"/>
        <xsl:text> — </xsl:text>
      </xsl:if>
      <xsl:value-of select="."/>
    </title>
  </xsl:template>

  <!-- Page title rendered as h1 -->
  <xsl:template match="title" mode="page.title.mode">
    <h1 class="page-title"><xsl:value-of select="."/></h1>
  </xsl:template>

  <!-- ======================================================================
       Page properties (meta elements from Logseq properties)
       ====================================================================== -->
  <xsl:template name="page.properties">
    <xsl:if test="head/meta[@name != 'description']">
      <div class="page-properties">
        <xsl:for-each select="head/meta[@name != 'description' and @name != 'public']">
          <span class="prop-entry">
            <span class="prop-key"><xsl:value-of select="@name"/></span>
            <xsl:text> </xsl:text>
            <span class="prop-value">
              <xsl:choose>
                <!-- asset-code gets chip styling -->
                <xsl:when test="@name = 'asset-code'">
                  <code class="asset-code"><xsl:value-of select="@content"/></code>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="@content"/></xsl:otherwise>
              </xsl:choose>
            </span>
          </span>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- ======================================================================
       Banner (header bar)
       ====================================================================== -->
  <xsl:template name="allpages.banner">
    <xsl:param name="relpath" select="''"/>
    <header class="titlebar" role="banner">
      <div>
        <a class="site-title">
          <xsl:attribute name="href">
            <xsl:value-of select="$relpath"/>
            <xsl:value-of select="$autolayout/autolayout/toc[1]/@filename"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$autolayout/autolayout/config[@param='title']">
              <xsl:value-of select="$autolayout/autolayout/config[@param='title'][1]/@value"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$site.title"/></xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:if test="$site.subtitle != ''">
          <span class="site-subtitle"><xsl:value-of select="$site.subtitle"/></span>
        </xsl:if>
      </div>
    </header>
  </xsl:template>

  <!-- ======================================================================
       Footer
       ====================================================================== -->
  <xsl:template name="page.footer">
    <xsl:param name="relpath" select="''"/>
    <footer class="navfoot" role="contentinfo">
      <span class="copyright">
        <xsl:text>© </xsl:text>
        <xsl:value-of select="$copyright.year"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$copyright.holder"/>
      </span>
      <span>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$relpath"/>
            <xsl:value-of select="$autolayout/autolayout/toc[1]/@filename"/>
          </xsl:attribute>
          Home
        </a>
      </span>
    </footer>
  </xsl:template>

  <!-- keep the old name for compatibility with website-common.xsl -->
  <xsl:template name="webpage.footer">
    <xsl:call-template name="page.footer"/>
  </xsl:template>

  <!-- ======================================================================
       Outliner blocks (rendered by edn2xml.py as <ls:block> elements)
       ====================================================================== -->
  <xsl:template match="ls:block" xmlns:ls="urn:logseq:block">
    <div class="ls-block">
      <div class="ls-block-content">
        <xsl:apply-templates select="ls:content"/>
      </div>
      <xsl:if test="ls:block">
        <div class="ls-children">
          <xsl:apply-templates select="ls:block"/>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="ls:content" xmlns:ls="urn:logseq:block">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- page-ref links -->
  <xsl:template match="ls:page-ref" xmlns:ls="urn:logseq:block">
    <a class="page-ref">
      <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
      <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <!-- tag spans -->
  <xsl:template match="ls:tag" xmlns:ls="urn:logseq:block">
    <span class="tag"><xsl:text>#</xsl:text><xsl:value-of select="."/></span>
  </xsl:template>

  <!-- ======================================================================
       Standard DocBook inline/block elements
       ====================================================================== -->
  <xsl:template match="para">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <ul class="ls-outline"><xsl:apply-templates select="listitem"/></ul>
  </xsl:template>

  <xsl:template match="orderedlist">
    <ol><xsl:apply-templates select="listitem"/></ol>
  </xsl:template>

  <xsl:template match="listitem">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="emphasis[@role='bold'] | emphasis[@role='strong']">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="emphasis">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="literal | code">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="programlisting">
    <pre><code><xsl:apply-templates/></code></pre>
  </xsl:template>

  <xsl:template match="blockquote">
    <blockquote><xsl:apply-templates/></blockquote>
  </xsl:template>

  <xsl:template match="link">
    <a class="page-ref">
      <xsl:attribute name="href"><xsl:value-of select="@linkend"/>.html</xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="ulink">
    <a>
      <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
      <xsl:attribute name="rel">noopener noreferrer</xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="phrase[@role='tag']">
    <span class="tag"><xsl:text>#</xsl:text><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="phrase[@role='asset-code']">
    <code class="asset-code"><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template name="hspacer"/>

</xsl:stylesheet>
