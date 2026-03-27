<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:suwl="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.UnwrapLinks"
		exclude-result-prefixes="suwl xi html rdf dc cvs rss db"
		version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/chunk-website.xsl"/>
  <xsl:import href="rdf-chunk.xsl"/>
  <xsl:import href="rdf.xsl"/>
  <xsl:import href="trl-chunk.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="links.xsl"/>
  <xsl:include href="sitemap.xsl"/>
  <xsl:include href="head.xsl"/>
  <xsl:include href="feeds.xsl"/>
  <xsl:include href="rss.xsl"/>
  <xsl:include href="atom.xsl"/>
  <xsl:include href="doap.xsl"/>
  <xsl:include href="urfm.xsl"/>
  <xsl:include href="foaf.xsl"/>
  <xsl:include href="header.xsl"/>
  <xsl:include href="docbook4-compat.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/main.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Module</dc:title>
    <cvs:date>$Date: 2009-10-26 23:58:47 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>FIXME</dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

   <xsl:param name="process.acronyms" select="'1'"/>
   <xsl:param name="acronyms.database.document" select="'glossary.xml'"/>
   <xsl:key name="glossentry" match="//db:glossentry" use="db:acronym"/>
<!-- ==================================================================== -->

<xsl:template name="object.class">
  <xsl:attribute name="class">
    <xsl:choose>
      <xsl:when test="@role">
	<xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
	<!--
	<xsl:value-of select="local-name(.)"/>
	-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>          
</xsl:template>

<xsl:template name="object.attrib">
  <xsl:choose>
    <xsl:when test="@id">
      <xsl:attribute name="id">
	<xsl:call-template name="object.id"/>
      </xsl:attribute>
      <xsl:call-template name="object.class"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="object.class"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="insert.class">
  <xsl:param name="value" select="name(.)"/>
  <xsl:if test="$value != ''">
    <xsl:attribute name="class">
      <xsl:value-of select="$value"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="acronym|html:acronym">
  <xsl:variable name="ca" select="."/>
  <xsl:variable name="aas" select="//*[name()='acronym']"/>
  <xsl:variable name="da" select="$aas[node()=$ca]"/>
  <xsl:variable name="fa" select="$da[1]"/>
  <xsl:variable name="cp" select="position()"/>
  
  <xsl:choose>
    <xsl:when test="$process.acronyms != '0'">
      <!--
	  <xsl:choose>
	  <xsl:when test="count($da)='1'">
	  <xsl:call-template name="process.acronyms"/>
	  </xsl:when>
	  <xsl:otherwise>
	  <xsl:if test="$da[position()=1]">
      -->
      <xsl:call-template name="process.acronyms"/>
      <!--
	  </xsl:if>
	  </xsl:otherwise>
	  </xsl:choose>
      -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.charseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process.acronyms">
  <xsl:variable name="acronyms.database" 
		select="document($acronyms.database.document, /)"/>
  <xsl:variable name="acronym">
    <xsl:apply-templates/>
  </xsl:variable>
  
  <xsl:variable name="term">
    <xsl:for-each select="$acronyms.database">
      <xsl:value-of select="key('glossentry', $acronym)/db:acronym[1]"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="title">
    <xsl:for-each select="$acronyms.database">
      <xsl:value-of select="normalize-space(key('glossentry', $acronym)/db:glossterm[1])"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$term='' and $title=''">
      <xsl:message>No entry found for acronym (<xsl:value-of select="$acronym"/>) in (<xsl:value-of select="$acronyms.database.document"/>)
      </xsl:message>
      <xsl:call-template name="inline.charseq"/>
    </xsl:when>
    <xsl:when test="$term='' and $title != ''">
      <xsl:message>No definition found for acronym (<xsl:value-of select="$acronym"/>) in (<xsl:value-of select="$acronyms.database.document"/>)
      </xsl:message>
      <xsl:call-template name="inline.charseq"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Definition (<xsl:value-of select="$title"/>) for acronym (<xsl:value-of select="$acronym"/>)
      </xsl:message>
      <acronym>
	<xsl:attribute name="title">
	  <xsl:value-of select="$title"/>
	</xsl:attribute>
	<xsl:value-of select="$term"/>
      </acronym>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
 
<xsl:template match="section">
  <div>
    <xsl:call-template name="object.attrib"/>
    <xsl:call-template name="language.attribute"/>
    <div class="{local-name(.)}">
      <xsl:for-each select="title">
	<xsl:call-template name="section.title"/>
      </xsl:for-each>
      <xsl:for-each select="subtitle">
	<xsl:call-template name="section.subtitle"/>
      </xsl:for-each>
      <xsl:apply-templates/>
      <xsl:call-template name="process.chunk.footnotes"/>
    </div>
  </div>
</xsl:template>

<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="allow-anchors" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="class" select="'title'"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="hlevel">
    <xsl:choose>
      <xsl:when test="$level &gt; 5">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$level + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="h{$hlevel}">
    <span>
      <xsl:copy-of select="$title"/>
    </span>
  </xsl:element>
<!--
<xsl:if test="count(/*/section) &gt; '3'">
<xsl:message terminate="yes"/>
<span class="backToUp">
</span>
</xsl:if>
-->
</xsl:template>

<xsl:template name="user.footer.template">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.sidebar.template">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="user.search-box">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template match="sidebar">
  <xsl:param name="page"/>
  <div>
    <xsl:if test="@id">
      <xsl:attribute name="id">
	<xsl:value-of select="@id"/>	  
      </xsl:attribute>	
    </xsl:if>
    <xsl:attribute name="class">
      <xsl:choose>
	<xsl:when test="@role">
	  <xsl:value-of select="@role"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="local-name(.)"/>	    
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates>
      <xsl:with-param name="page" select="$page"/>
    </xsl:apply-templates>
  </div>
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
	<xsl:text>twocol secnav</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$secnav != '0' and $sidebar != '0'">
      <xsl:attribute name="class">
	<xsl:text>threecol</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$secnav = '0' and $sidebar = '0'">
      <xsl:attribute name="class">
	<xsl:text>onecol</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message terminate="no">
	<xsl:text>
	Style sheet cannot detect presentation state of the page.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="hr.access">
  <hr class="{$access.class}"/>
</xsl:template>

<xsl:template name="html.attributes">
  <xsl:param name="doctype" select="$output.method"/>
  <xsl:choose>
    <xsl:when test="$doctype='xhtml10'">
      <xsl:attribute name="xml:lang">
          <xsl:value-of select="$site.lang"/>
        </xsl:attribute>
        <xsl:attribute name="lang">
          <xsl:value-of select="$site.lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$doctype='xhtml11'">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="$site.lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$doctype='xhtml401'">
        <xsl:attribute name="lang">
          <xsl:value-of select="$site.lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <!-- just do nothin' -->
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="processing-instruction('readmore')|
		     olink/processing-instruction('readmore')">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'Directive'"/>
    <xsl:with-param name="name" select="'readmore'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="processing-instruction('learnmore')|
		     olink/processing-instruction('learnmore')">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'Directive'"/>
    <xsl:with-param name="name" select="'learnmore'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="processing-instruction('backtotop')">
  <xsl:call-template name="link-backtotop">
    <xsl:with-param name="wrapper" select="''"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="webtoc">
  <xsl:variable name="webpage" select="ancestor::webpage"/>
  <xsl:variable name="relpath">
    <xsl:call-template name="root-rel-path">
      <xsl:with-param name="webpage" select="$webpage"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="pageid" select="$webpage/@id"/>

  <xsl:variable name="pages"
                select="$autolayout//*[$pageid=@id]/tocentry"/>

  <xsl:if test="count($pages) > 0">
    <ul class="{name(.)}">
      <xsl:for-each select="$pages">
	<li>
	  <p>
	    <a>
	      <xsl:attribute name="href">
		<xsl:choose>
		  <xsl:when test="@href">
		    <xsl:value-of select="@href"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="$relpath"/>
		    <xsl:value-of select="@dir"/>
		    <xsl:value-of select="$filename-prefix"/>
		    <xsl:value-of select="@filename"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:attribute name="title">
		<xsl:apply-templates select="/webpage/head/summary[1]"/>
	      </xsl:attribute>
	      <xsl:apply-templates select="title"/>
	      <xsl:if test="//head/summary">
		<xsl:text>-- </xsl:text>
		<xsl:apply-templates select="//head/summary[1]"/>
	      </xsl:if>
	    </a>
	  </p>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>

<xsl:template match="summary">
  <span class="{name(.)}">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="table/title">
  <caption>
    <xsl:apply-templates/>
  </caption>
</xsl:template>

<xsl:template match="blockquote">
  <blockquote>
    <xsl:if test="@lang or @xml:lang">
      <xsl:call-template name="language.attribute"/>
    </xsl:if>
    <xsl:call-template name="object.class"/>
    <xsl:if test="attribution/ulink/@url and 
		  starts-with(attribution/ulink/@url, 'http://')">
      <xsl:attribute name="cite">
	<xsl:value-of select="attribution/ulink/@url"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates select="para"/>
    <xsl:if test="attribution">
      <span class="attribution">
	<xsl:text>&#8212;</xsl:text>
	<xsl:apply-templates select="attribution"/>
      </span>
    </xsl:if>
  </blockquote>
</xsl:template>

<xsl:template match="blockquote/para">
  <p class="quote">
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="blockquote/attribution">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="site-author">
  <xsl:choose>
    <xsl:when test="$site.author != ''">
      <xsl:value-of select="$site.author"/>
    </xsl:when>
    <xsl:when test="$autolayout/autolayout/copyright/holder">
      <xsl:for-each select="$autolayout/autolayout/copyright/holder">
	<xsl:value-of select="."/>
	<xsl:if test="position() &gt; 1">
	  <xsl:text>, </xsl:text>
	</xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:when test="$autolayout/autolayout/config[@param='title']/@value">
      <xsl:value-of select="$autolayout/autolayout/config[@param='title']/@value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>No site author found</xsl:text>
    </xsl:otherwise>
  </xsl:choose>  
</xsl:template>

<xsl:template match="config[@param='DOAP']|
		     config[@param='URFM']|
		     config[@param='FOAF']"
	      mode="external">
  <xsl:variable name="id" select="/webpage/@id"/>
  <xsl:variable name="role" select="@param"/>
  <xsl:variable name="href" select="document(@value, .)"/>
  <xsl:choose>
    <xsl:when test="not($href)">
      <xsl:message>
	<xsl:text>External file processing failed: [</xsl:text>
	<xsl:value-of select="@value"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="@param='URFM'">
	<xsl:call-template name="urfm">
	  <xsl:with-param name="href" select="$href"/>
	</xsl:call-template>
      </xsl:if>
      <xsl:if test="@param='DOAP'">
	<xsl:call-template name="doap">
	  <xsl:with-param name="href" select="$href"/>
	  <xsl:with-param name="id" select="$id"/>
	</xsl:call-template>
      </xsl:if>
      <xsl:if test="@param='FOAF'">
	<xsl:call-template name="foaf">
	  <xsl:with-param name="href" select="$href"/>
	  <xsl:with-param name="id" select="$id"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="html:*">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="ulink">
  <xsl:variable name="link">
    <a class="{local-name(.)}">
	    <!-- support for  rel='license' microformat -->
      <xsl:if test="@url=$site.license">
        <xsl:attribute name="rel">
          <xsl:value-of select="'license'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@id">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@xreflabel">
        <xsl:attribute name="title">
	        <xsl:value-of select="@xreflabel"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
      <xsl:if test="$ulink.target != ''">
        <xsl:attribute name="target">
          <xsl:value-of select="$ulink.target"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="count(child::node())=0">
          <xsl:value-of select="@url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="function-available('suwl:unwrapLinks')">
      <xsl:copy-of select="suwl:unwrapLinks($link)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$link"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="root-rel-path">
  <xsl:param name="webpage" select="ancestor-or-self::webpage"/>
  <xsl:variable name="tocentry" select="$autolayout//*[$webpage/@id=@id]"/>
  <xsl:apply-templates select="$tocentry" mode="toc-rel-path"/>
</xsl:template>



</xsl:stylesheet>

