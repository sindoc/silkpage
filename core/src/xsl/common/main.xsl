<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		exclude-result-prefixes=" xi html rdf dc cvs rss db " 
		version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/website/current/xsl/website-common.xsl"/>
  <xsl:import href="rdf-chunk.xsl"/>
  <xsl:import href="rdf.xsl"/>
  <xsl:include href="olink.xsl"/>
  <xsl:include href="param.xsl"/>
  <xsl:include href="links.xsl"/>
  <xsl:include href="sitemap.xsl"/>
  <xsl:include href="head.xsl"/>
  <xsl:include href="feeds.xsl"/>
  <xsl:include href="rss.xsl"/>
  <xsl:include href="xlink.xsl"/>
  <xsl:include href="doap.xsl"/>
  <xsl:include href="urfm.xsl"/>
  <xsl:include href="foaf.xsl"/>

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/main.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Module</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:51 $</cvs:date>
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
        <xsl:when test="@id">
    	  <xsl:call-template name="object.id"/>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="name(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
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
      <xsl:call-template name="object.class"/>
      <xsl:call-template name="language.attribute"/>
      <xsl:for-each select="title">
        <xsl:call-template name="section.title"/>
      </xsl:for-each>
      <xsl:for-each select="subtitle">
        <xsl:call-template name="section.subtitle"/>
      </xsl:for-each>
      <xsl:apply-templates/>
      <xsl:call-template name="process.chunk.footnotes"/>
    </div>
  </xsl:template>

<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="allow-anchors" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="class" select="'title'"/>

  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
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
</xsl:template>

<xsl:template name="user.search-box">
    <xsl:param name="node" select="."/>
  </xsl:template>
  <xsl:template match="sidebar">
    <xsl:param name="page" select="''"/>
    <xsl:apply-templates>
      <xsl:with-param name="page" select="$page"/>
    </xsl:apply-templates>
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
          <xsl:text>Style sheet cannot detect presentation state of the page.</xsl:text>
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

<xsl:template match="processing-instruction('arrowup')">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'Directive'"/>
    <xsl:with-param name="name" select="'arrowup'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="processing-instruction('arrowleft')">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'Directive'"/>
    <xsl:with-param name="name" select="'arrowleft'"/>
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

</xsl:stylesheet>
