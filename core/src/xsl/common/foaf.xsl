<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:cvsf="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		extension-element-prefixes=" html rdf rdfs cvs xlink urfm doap rss cvsf date foaf dc "
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/foaf.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common FOAF</dc:title>
    <cvs:date>$Date: 2006-11-06 12:01:42 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 -2005 MarkupWare.</dc:rights>
    <dc:description>
     This stylesheet displays FOAF files as HTML.
    </dc:description>
  </rdf:Description>
  
  <xsl:output indent="yes" method="xml"/>

<!-- ==================================================================== -->

<xsl:template name="foaf">
  <xsl:param name="href"/>
  <xsl:param name="id"/>
  <xsl:choose>
    <xsl:when test="$href//foaf:Organization
		    or $href//foaf:Person">
      <div class="{$foaf.label}">
	<xsl:choose>
	  <xsl:when test="$id = $href//foaf:*/dc:identifier">
	    <xsl:apply-templates select="$href//foaf:*[dc:identifier=$id]"/>
	  </xsl:when>
	  <xsl:when test="$id = $clients-all.label">
	    <ul>
	      <xsl:apply-templates select="$href//foaf:Organization|foaf:Person" mode="all"/>      
	    </ul>
	  </xsl:when>
	  <!--
	  <xsl:when test="$id = $clients.label">
	    <xsl:for-each select="$href//foaf:*[dc:category/@rdf:resource=$href//foaf:*/dc:category/@rdf:resource][1]">
	      <xsl:variable name="cat" select="dc:category/@rdf:resource"/>
	      <h2>
		<xsl:call-template name="gentext.template">
		  <xsl:with-param name="context" select="'Category'"/>
		  <xsl:with-param name="name" select="$cat"/>
		</xsl:call-template>      
	      </h2>
	    </xsl:for-each>
	  </xsl:when>
	  -->
	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>
		Unable to process FOAF file. 
	      </xsl:text>
	    </xsl:message>      
	  </xsl:otherwise>
	</xsl:choose>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Unable to process FOAF file</xsl:text>
      </xsl:message>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="foaf:Organization|foaf:Person">
  <xsl:apply-templates select="foaf:logo"/>
  <xsl:apply-templates select="foaf:homepage"/>
  <xsl:if test="dc:category">
    <p class="category">
      <strong>
	<xsl:call-template name="gentext.template">
	  <xsl:with-param name="context" select="'DOAP'"/>
	  <xsl:with-param name="name" select="'category'"/>
	</xsl:call-template>
	<xsl:value-of select="$biblioentry.item.separator"/>
	<xsl:call-template name="gentext.space"/>        
      </strong>
      <xsl:apply-templates select="dc:category"/>
    </p>
  </xsl:if>
  <xsl:if test="dc:description">
    <div class="desc">
      <xsl:for-each select="dc:description/text()">
        <p>
          <xsl:value-of select="."/>
        </p>
      </xsl:for-each>
    </div>
  </xsl:if>
  <xsl:if test="rdfs:seeAlso/doap:Project[@rdf:about != '']">
    <div class="contribs">
      <xsl:call-template name="sponsor-contribution"/>
      <ol>
	<xsl:apply-templates select="rdfs:seeAlso/doap:Project[@rdf:about != '']"/>
      </ol>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="foaf:Organization|foaf:Person" mode="all">
  <xsl:variable name="name" select="foaf:name[1]/text()"/>
  <li class="{dc:identifier}">
     <a href="{@rdf:about}" title="{$name}">
      <xsl:value-of select="$name"/>
    </a>
  </li>
</xsl:template>

<xsl:template match="foaf:maker|rdfs:seeAlso[@rdf:resource=//foaf:*/@rdf:about]"> 
  <xsl:variable name="ref" select="@rdf:resource"/>
  <xsl:variable name="sponsor" select="//foaf:*[@rdf:about=$ref]"/>
  <a href="{$sponsor/@rdf:about}"
       title="{normalize-space($sponsor/foaf:name[1])}">
      <xsl:value-of select="$sponsor/foaf:name[1]"/>	
    </a>
    <xsl:if test="following-sibling::foaf:maker">
      <xsl:text>, </xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="foaf:logo">
  <div class="{local-name(.)}">
    <img src="{@rdf:resource}" alt="{../foaf:name/text()}"/>
  </div>
</xsl:template>

</xsl:stylesheet>
