<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="xalanredirect lxslt exsl dc rdf cvs"
                version="1.0">

<!-- ==================================================================== -->

<!-- $Id: html.xsl,v 1.1.1.1 2005-07-28 22:08:08 sina Exp $ -->

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/docs/src/xsl/header.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Documentation XSLT, Customization Layer</dc:title>
    <cvs:date>$Date: 2005-07-28 22:08:08 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

  <!--<xsl:include href="titlepage-html.xsl"/>-->

<!-- ============================================================ -->
<!-- Parameters -->

<xsl:param name="navig.showtitles" select="1"/>
<xsl:param name="www.root" select="''"/>

<xsl:param name="css.path" select="concat($www.root, 'css/')"/>

<xsl:param name="css.stylesheet">
  <xsl:choose>
    <xsl:when test="/book/@status='WD'">base.css</xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized status: '</xsl:text>
        <xsl:value-of select="/article/@status"/>
        <xsl:text>'; styling as Working Draft.</xsl:text>
      </xsl:message>
      <xsl:text>base.css</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>

<xsl:param name="html.stylesheet">
  <xsl:value-of select="$css.path"/>
  <xsl:value-of select="$css.stylesheet"/>
</xsl:param>

<xsl:param name="section.autolabel" select="'1'"/>

<xsl:param name="generate.component.toc" select="'1'"/>

<xsl:param name="chunker.output.method" select="'html'"/>
<xsl:param name="chunker.output.indent" select="'no'"/>
<xsl:param name="chunker.output.encoding" select="'ISO-8859-1'"/>

<xsl:param name="table.borders.with.css" select="1"/>
<xsl:param name="making.diffs" select="0"/>

<xsl:param name="number.paras" select='0'/>

<xsl:template match="/">
  <xsl:if test="$number.paras != 0 and not(function-available('exsl:node-set'))">
    <xsl:message>
      <xsl:text>Paragraph numbering is unavailable. </xsl:text>
      <xsl:text>Use a processor that supports exsl:node-set().</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:apply-imports/>
</xsl:template>

<!-- ============================================================ -->
<!-- HTML META -->

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates select="//articleinfo/releaseinfo[@role='meta']"
		       mode="head.meta.content"/>
  <xsl:if test="$number.paras != 0">
    <style type="text/css">
span.paranum { color: #7F7F7F;
               font-style: italic;
               font-family: monospace;
             }
    </style>
  </xsl:if>
</xsl:template>

<xsl:template match="releaseinfo" mode="head.meta.content">
  <meta name="cvsinfo">
    <xsl:attribute name="content">
      <xsl:value-of select="substring-before(substring-after(.,'$'),'$')"/>
    </xsl:attribute>
  </meta>
</xsl:template>

<!-- ============================================================ -->
<!-- Titlepage -->

<xsl:template match="pubdate" mode="titlepage.mode">
  <h2>
    <xsl:choose>
      <xsl:when test="/*/@status = 'WD'">
	<xsl:text>Working Draft</xsl:text>
      </xsl:when>
      <xsl:when test="/*/@status">
	<xsl:text>???Status: </xsl:text>
	<xsl:value-of select="/*/@status"/>
	<xsl:text>???</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>???Unknown Status???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:text>&#160;</xsl:text>

    <xsl:apply-templates mode="titlepage.mode"/>
  </h2>
</xsl:template>

<xsl:template match="bibliorelation[@type='isversionof']" mode="titlepage.mode">
  <xsl:if test="preceding-sibling::bibliorelation[@type='isversionof']">
    <xsl:message terminate='yes'>
      <xsl:text>Only one bibliorelation/@type='isversionof' is allowed.</xsl:text>
    </xsl:message>
  </xsl:if>

  <dl>
    <dt><span class="version-heading">Latest version:</span></dt>
    <dd>
      <p>
	<a href="{$www.root}{normalize-space(.)}">
	  <xsl:value-of select="$www.root"/>
	  <xsl:value-of select="."/>
	</a>
      </p>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="bibliorelation[@type='hasversion']" mode="titlepage.mode">
  <xsl:if test="preceding-sibling::bibliorelation[@type='hasversion']">
    <xsl:message terminate='yes'>
      <xsl:text>Only one bibliorelation/@type='hasversion' is allowed.</xsl:text>
    </xsl:message>
  </xsl:if>

  <dl>
    <dt><span class="version-heading">This version:</span></dt>
    <dd>
      <p>
	<a href="{$www.root}{normalize-space(.)}">
	  <xsl:value-of select="$www.root"/>
	  <xsl:value-of select="."/>
	</a>
      </p>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="bibliorelation[@type='replaces']" mode="titlepage.mode">
  <xsl:if test="not(preceding-sibling::bibliorelation[@type='replaces'])">
    <xsl:variable name="specs" select="../bibliorelation[@type='replaces']"/>
    <dl>
      <dt>
	<span class="version-heading">
	  <xsl:text>Previous version</xsl:text>
	  <xsl:if test="count($specs) &gt; 1">s</xsl:if>
	  <xsl:text>:</xsl:text>
	</span>
      </dt>
      <dd>
	<p>
	  <xsl:for-each select="$specs">
	    <a href="{$www.root}{normalize-space(.)}">
	      <xsl:value-of select="$www.root"/>
	      <xsl:value-of select="."/>
	    </a>
	    <xsl:if test="position() &lt; last()">
	      <br/>
	    </xsl:if>
	  </xsl:for-each>
	</p>
      </dd>
    </dl>
  </xsl:if>
</xsl:template>

<xsl:template match="authorgroup" mode="titlepage.mode">
  <xsl:variable name="editors" select="editor"/>
  <xsl:variable name="authors" select="author"/>
  <xsl:variable name="contrib" select="othercredit"/>

  <xsl:if test="$editors">
    <dl>
      <dt>
        <span class="editor-heading">
          <xsl:text>Editor</xsl:text>
          <xsl:if test="count($editors) &gt; 1">s</xsl:if>
          <xsl:text>:</xsl:text>
        </span>
      </dt>
      <dd>
        <p>
          <xsl:apply-templates select="$editors" mode="titlepage.mode"/>
        </p>
      </dd>
    </dl>
  </xsl:if>

  <xsl:if test="$authors">
    <dl>
      <dt>
        <span class="author-heading">
          <xsl:text>Author</xsl:text>
          <xsl:if test="count($authors) &gt; 1">s</xsl:if>
          <xsl:text>:</xsl:text>
        </span>
      </dt>
      <dd>
        <p>
          <xsl:apply-templates select="$authors" mode="titlepage.mode"/>
        </p>
      </dd>
    </dl>
  </xsl:if>

  <xsl:if test="$contrib">
    <dl>
      <dt>
        <span class="contrib-heading">
          <xsl:text>Contributor</xsl:text>
          <xsl:if test="count($contrib) &gt; 1">s</xsl:if>
          <xsl:text>:</xsl:text>
        </span>
      </dt>
      <dd>
        <p>
          <xsl:apply-templates select="$contrib" mode="titlepage.mode"/>
        </p>
      </dd>
    </dl>
  </xsl:if>
</xsl:template>

<xsl:template match="ulink" mode="revision-links">
  <xsl:if test="position() = 1"> (</xsl:if>
  <xsl:if test="position() &gt; 1">, </xsl:if>
  <a href="{@url}"><xsl:value-of select="@role"/></a>
  <xsl:if test="position() = last()">)</xsl:if>
</xsl:template>

<xsl:template match="editor|author|othercredit" mode="titlepage.mode">
  <xsl:call-template name="person.name"/>
  <xsl:if test="contrib">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="contrib" mode="titlepage.mode"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:if test="affiliation/orgname">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="affiliation/orgname" mode="titlepage.mode"/>
  </xsl:if>
  <xsl:apply-templates select="affiliation/address/email"
                       mode="titlepage.mode"/>
  <xsl:if test="position()&lt;last()"><br/></xsl:if>
</xsl:template>

<xsl:template match="email" mode="titlepage.mode">
  <xsl:text>&#160;</xsl:text>
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="abstract" mode="titlepage.mode">
  <dl>
    <dt>
      <a>
        <xsl:attribute name="name">
          <xsl:call-template name="object.id"/>
        </xsl:attribute>
      </a>
      <span class="abstract-heading">
        <xsl:apply-templates select="." mode="object.title.markup"/>
        <xsl:text>:</xsl:text>
      </span>
    </dt>
    <dd>
      <xsl:apply-templates mode="titlepage.mode"/>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="legalnotice[@role='status']" mode="titlepage.mode">
  <dl>
    <dt>
      <a>
        <xsl:attribute name="name">
          <xsl:call-template name="object.id"/>
        </xsl:attribute>
      </a>
      <span class="status-heading">
        <xsl:apply-templates select="." mode="object.title.markup"/>
        <xsl:text>:</xsl:text>
      </span>
    </dt>
    <dd>
      <xsl:apply-templates mode="titlepage.mode"/>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="legalnotice/title" mode="titlepage.mode">
</xsl:template>

<xsl:template match="releaseinfo" mode="titlepage.mode">
  <xsl:comment>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:comment>
</xsl:template>

<xsl:template match="jobtitle|shortaffil|orgname|contrib"
              mode="titlepage.mode">
  <xsl:apply-templates/>
</xsl:template>

<!-- ============================================================ -->
<!-- Component TOC -->

<xsl:template name="component.toc">
  <xsl:if test="$generate.component.toc != 0">
    <xsl:variable name="nodes" select="section|sect1"/>
    <xsl:variable name="apps" select="bibliography|glossary|appendix"/>

    <xsl:if test="$nodes">
      <div class="toc">
        <h2>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key">TableofContents</xsl:with-param>
          </xsl:call-template>
        </h2>

        <xsl:if test="$nodes">
          <xsl:element name="{$toc.list.type}">
            <xsl:apply-templates select="$nodes" mode="toc"/>
          </xsl:element>
        </xsl:if>

        <xsl:if test="$apps">
          <h3>Appendixes</h3>

          <xsl:element name="{$toc.list.type}">
            <xsl:apply-templates select="$apps" mode="toc"/>
          </xsl:element>
        </xsl:if>
      </div>
      <hr/>
    </xsl:if>
  </xsl:if>
</xsl:template>
<!-- ================================================================= -->

<!-- support role='non-normative' -->
<!--
<xsl:template match="preface|chapter|appendix" mode="title.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:variable name="title" select="(docinfo/title 
                                      |prefaceinfo/title
                                      |chapterinfo/title
                                      |appendixinfo/title
                                      |title)[1]"/>
  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
  <xsl:if test="@role='non-normative'">
    <xsl:text> (Non-Normative)</xsl:text>
  </xsl:if>
</xsl:template>
-->

<!-- support role='non-normative' -->
<!--
<xsl:template match="section
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3
                     |simplesect"
              mode="title.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:variable name="title" select="(sectioninfo/title
                                      |sect1info/title
                                      |sect2info/title
                                      |sect3info/title
                                      |sect4info/title
                                      |sect5info/title
                                      |refsect1info/title
                                      |refsect2info/title
                                      |refsect3info/title
                                      |title)[1]"/>

  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
  <xsl:if test="@role='non-normative'">
    <xsl:text> (Non-Normative)</xsl:text>
  </xsl:if>
</xsl:template>
-->

<!-- ============================================================ -->

<xsl:template match="quote">
  <xsl:variable name="depth">
    <xsl:call-template name="dot.count">
      <xsl:with-param name="string">
        <xsl:number level="multiple"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:text>"</xsl:text>
      <xsl:call-template name="inline.charseq"/>
      <xsl:text>"</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>'</xsl:text>
      <xsl:call-template name="inline.charseq"/>
      <xsl:text>'</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="filename">
  <b>
    <xsl:apply-templates/>
  </b>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="para/revhistory">
  <xsl:variable name="numcols">
    <xsl:choose>
      <xsl:when test="//authorinitials">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div class="{name(.)}">
    <table border="1" width="100%" summary="Revision history">
      <xsl:apply-templates mode="titlepage.mode">
        <xsl:with-param name="numcols" select="$numcols"/>
      </xsl:apply-templates>
    </table>
  </div>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="processing-instruction('lb')">
  <br/>
</xsl:template>

<!-- ============================================================ -->

<!--
<xsl:template match="para">
  <xsl:variable name="p">
    <xsl:apply-imports/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('exsl:node-set') and $number.paras != 0">
      <xsl:apply-templates select="exsl:node-set($p)/node()" mode="addNumber">
        <xsl:with-param name="pnum">
          <span class="paranum">
            <xsl:text>[&#xB6;</xsl:text>
            <xsl:number level="any"/>
            <xsl:text>]</xsl:text>
          </span>
          <xsl:text>&#160;</xsl:text>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$p"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="p" mode="addNumber">
  <xsl:param name="pnum" select="''"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="$pnum"/>
    <xsl:copy-of select="text()|comment()|processing-instruction()|*"/>
  </xsl:copy>
</xsl:template>
-->

<!-- ============================================================ -->

<xsl:template match="envar">
  <xsl:call-template name="inline.monoseq">
    <xsl:with-param name="content">
      <xsl:text>$</xsl:text>
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="user.header.navigation">
  <xsl:param name="node" select="."/>
    <div id="header">
        <p class="access"><a href="#content">Skip Navigation</a></p>
        <div id="path">
	    <a 	href="http://silkpage.markupware.com"
		title="SilkPage Web Page"><span>SilkPage</span></a>
	    <a 	href="http://silkpage.markupware.com/docs"
		title="SilkPage Documentation Page"><span>Documentation</span></a>
	    <a 	href="http://silkpage.markupware.com/docs/user-guide.html"
		title="SilkPage Documentation - User Guide Page"><span>User Guide</span></a>
        </div>
        <hr class="access" />
    </div>
    
</xsl:template>
</xsl:stylesheet>
