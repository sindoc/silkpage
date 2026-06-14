<?xml version='1.0'?>
<!-- =============================================================================
     Lutino SilkPage Theme — TOC XSL
     Renders the left-column navigation from the autolayout TOC tree.
     ============================================================================= -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html"/>

  <xsl:param name="toc.expand.depth" select="2"/>
  <xsl:param name="nav.text.spacer">&#160;&#160;</xsl:param>

  <!-- ======================================================================
       TOC root
       ====================================================================== -->
  <xsl:template match="toc">
    <xsl:param name="pageid" select="@id"/>
    <xsl:variable name="relpath">
      <xsl:call-template name="toc-rel-path">
        <xsl:with-param name="pageid" select="$pageid"/>
      </xsl:call-template>
    </xsl:variable>
    <nav class="navtoc" aria-label="Site navigation">
      <xsl:if test="title">
        <div class="toc-title"><xsl:value-of select="title"/></div>
      </xsl:if>
      <ul>
        <xsl:apply-templates select="tocentry|titleabbrev">
          <xsl:with-param name="pageid"  select="$pageid"/>
          <xsl:with-param name="relpath" select="$relpath"/>
          <xsl:with-param name="depth"   select="1"/>
        </xsl:apply-templates>
      </ul>
    </nav>
  </xsl:template>

  <!-- ======================================================================
       TOC entry
       ====================================================================== -->
  <xsl:template match="tocentry">
    <xsl:param name="pageid"  select="''"/>
    <xsl:param name="relpath" select="''"/>
    <xsl:param name="depth"   select="1"/>

    <xsl:variable name="entry-id" select="@id"/>
    <xsl:variable name="filename" select="@filename"/>
    <xsl:variable name="dir">
      <xsl:choose>
        <xsl:when test="starts-with(@dir,'/')">
          <xsl:value-of select="substring(@dir,2)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="@dir"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="is-current" select="$entry-id = $pageid"/>

    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$relpath"/>
          <xsl:value-of select="$dir"/>
          <xsl:value-of select="$filename"/>
        </xsl:attribute>
        <xsl:if test="$is-current">
          <xsl:attribute name="class">current</xsl:attribute>
          <xsl:attribute name="aria-current">page</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="titleabbrev|title"/>
      </a>
      <xsl:if test="tocentry and $depth &lt; $toc.expand.depth">
        <ul>
          <xsl:apply-templates select="tocentry">
            <xsl:with-param name="pageid"  select="$pageid"/>
            <xsl:with-param name="relpath" select="$relpath"/>
            <xsl:with-param name="depth"   select="$depth + 1"/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="titleabbrev"/>

</xsl:stylesheet>
