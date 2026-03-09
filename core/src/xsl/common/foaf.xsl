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

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/urfm.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common FOAF</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:51 $</cvs:date>
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
	  <xsl:when test="$id = $href//foaf:*/dc:identifier
			  and starts-with($id,$partner.label)">
	    <xsl:apply-templates select="$href//foaf:*[dc:identifier=$id]" mode="partner"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message>
	      <xsl:text>
		Unable to process FOAF file to retrieve the infotmation 
		about the partner. Please make sure that the value of 
		webpage ID starts with $partner.label parameter and is equal 
		to the dc:identifier property in the class where the partner 
		is described.
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

<xsl:template match="foaf:Organization|foaf:Person" mode="sponsor">
  <xsl:apply-templates select="foaf:homepage|dc:description"/>
</xsl:template>

<xsl:template match="foaf:Organization|foaf:Person" mode="partner">
  <xsl:apply-templates select="foaf:homepage|dc:description"/>
</xsl:template>

<xsl:template match="foaf:maker"> 
  <xsl:variable name="ref" select="@rdf:resource"/>
  <xsl:variable name="sponsor" select="//foaf:*[@rdf:about=$ref]"/>
    <a>
      <xsl:attribute name="href">
	<xsl:value-of select="$sponsor/@rdf:about"/>
	<xsl:value-of select="$html.ext"/>
      </xsl:attribute>
      <xsl:attribute name="title">
	<xsl:value-of select="$sponsor/foaf:name[1]"/>	
      </xsl:attribute>
      <xsl:value-of select="$sponsor/foaf:name[1]"/>	
    </a>
    <xsl:if test="following-sibling::foaf:maker">
      <xsl:text>, </xsl:text>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
  
