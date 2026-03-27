<?xml version="1.0"?>
<!--
  docbook4-compat.xsl — No-namespace (DocBook 4) content element templates.

  The DocBook XSL snapshot (1.79.2+) matches only d:* (DocBook 5 namespace)
  elements.  SilkPage source XML uses no-namespace DocBook 4 elements inside
  <webpage>.  Without this file every content element falls through to the
  catch-all match="*" rule and appears as a red <span> in the output.

  This stylesheet is xsl:include'd from silkpage/main.xsl (after the imports)
  so its templates shadow the catch-all but yield to any more-specific rules
  already defined in the website or SilkPage stylesheets.

  Only elements actually present in silkpage.markupware.com source XML are
  covered; everything else continues to use whatever template exists upstream.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- ======================================================================
     Block elements
     ====================================================================== -->

<xsl:template match="para">
  <p>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@role">
      <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="section">
  <div class="section">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="section/title">
  <h2>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<!-- sidebar inside a webpage — rendered as an aside block -->
<xsl:template match="sidebar">
  <div class="sidebar">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="sidebar/title">
  <h3 class="sidebar-title"><xsl:apply-templates/></h3>
</xsl:template>

<!-- ======================================================================
     Lists
     ====================================================================== -->

<xsl:template match="itemizedlist">
  <div class="itemizedlist">
    <xsl:if test="title">
      <p class="title"><strong><xsl:value-of select="title"/></strong></p>
    </xsl:if>
    <ul>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="orderedlist">
  <div class="orderedlist">
    <xsl:if test="title">
      <p class="title"><strong><xsl:value-of select="title"/></strong></p>
    </xsl:if>
    <ol>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="listitem"/>
    </ol>
  </div>
</xsl:template>

<xsl:template match="itemizedlist/listitem|orderedlist/listitem">
  <li>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="variablelist">
  <div class="variablelist">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="title">
      <p class="title"><strong><xsl:value-of select="title"/></strong></p>
    </xsl:if>
    <dl>
      <xsl:apply-templates select="varlistentry"/>
    </dl>
  </div>
</xsl:template>

<!-- Suppress title rendered above — avoid double output -->
<xsl:template match="variablelist/title|itemizedlist/title|orderedlist/title"/>

<xsl:template match="varlistentry">
  <xsl:apply-templates select="term"/>
  <dd>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="listitem/node()"/>
  </dd>
</xsl:template>

<xsl:template match="varlistentry/term">
  <dt>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

<!-- ======================================================================
     Tables  (basic DocBook CALS table subset)
     ====================================================================== -->

<xsl:template match="table|informaltable">
  <table>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@frame">
      <xsl:attribute name="frame"><xsl:value-of select="@frame"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="table/title">
  <caption><xsl:apply-templates/></caption>
</xsl:template>

<xsl:template match="tgroup">
  <xsl:apply-templates select="thead|tbody|tfoot"/>
</xsl:template>

<xsl:template match="colspec|spanspec"/>

<xsl:template match="thead">
  <thead><xsl:apply-templates/></thead>
</xsl:template>

<xsl:template match="tbody">
  <tbody><xsl:apply-templates/></tbody>
</xsl:template>

<xsl:template match="tfoot">
  <tfoot><xsl:apply-templates/></tfoot>
</xsl:template>

<xsl:template match="row">
  <tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="thead/row/entry">
  <th>
    <xsl:if test="@align">
      <xsl:attribute name="style">text-align:<xsl:value-of select="@align"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </th>
</xsl:template>

<xsl:template match="entry">
  <td>
    <xsl:if test="@align">
      <xsl:attribute name="style">text-align:<xsl:value-of select="@align"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </td>
</xsl:template>

<!-- ======================================================================
     Inline elements
     ====================================================================== -->

<!-- DocBook 4 ulink: <ulink url="...">text</ulink> -->
<xsl:template match="ulink">
  <a href="{@url}">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(node()) = 0">
        <xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="acronym|abbrev">
  <acronym>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </acronym>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="@role = 'bold' or @role = 'strong'">
      <strong><xsl:apply-templates/></strong>
    </xsl:when>
    <xsl:otherwise>
      <em><xsl:apply-templates/></em>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="phrase">
  <span>
    <xsl:if test="@role">
      <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="replaceable">
  <em class="replaceable"><code><xsl:apply-templates/></code></em>
</xsl:template>

<xsl:template match="sgmltag|tag">
  <code class="sgmltag"><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="literal|code">
  <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="filename|command|option|envar|varname|classname|methodname|parameter">
  <code class="{local-name()}"><xsl:apply-templates/></code>
</xsl:template>

<!-- ======================================================================
     Media objects (minimal: render alt text)
     ====================================================================== -->

<xsl:template match="inlinemediaobject|mediaobject">
  <xsl:apply-templates select="imageobject[1]|textobject[1]"/>
</xsl:template>

<xsl:template match="imageobject">
  <xsl:apply-templates select="imagedata"/>
</xsl:template>

<xsl:template match="imagedata">
  <img src="{@fileref}">
    <xsl:if test="@width">
      <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@depth">
      <xsl:attribute name="height"><xsl:value-of select="@depth"/></xsl:attribute>
    </xsl:if>
    <xsl:attribute name="alt">
      <xsl:value-of select="ancestor::mediaobject/textobject/phrase|
                            ancestor::inlinemediaobject/textobject/phrase"/>
    </xsl:attribute>
  </img>
</xsl:template>

<xsl:template match="textobject">
  <!-- suppress: used as alt text source above, not rendered directly -->
</xsl:template>

<!-- ======================================================================
     Glossary (used in glossary.xml loaded via key lookup)
     ====================================================================== -->

<xsl:template match="glossary">
  <div class="glossary">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="glossentry">
  <div class="glossentry">
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <dt class="glossterm"><xsl:apply-templates select="glossterm"/></dt>
    <dd class="glossdef"><xsl:apply-templates select="glossdef"/></dd>
  </div>
</xsl:template>

<xsl:template match="glossterm">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glossdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="glossseealso">
  <p class="glossseealso">
    <xsl:text>See also: </xsl:text>
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
