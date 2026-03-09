<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		xmlns:skos="http://www.w3.org/2004/02/skos/core#"
		exclude-result-prefixes=" xi html rdf dc cvs rss db " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/dbgls2skos.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, DocBook Glossary to SKOS</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:50 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:license rdf:resource="http://www.markupware.com/metadata/license#SilkPage"/>
    <dc:description>
      This stylesheet transforms glossaries from DocBook to SKOS
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml"/>

   <xsl:param name="process.acronyms" select="'1'"/>
   <xsl:param name="acronyms.database.document" select="'glossary.xml'"/>


   <xsl:key name="glossentry" match="//db:glossentry" use="db:glossterm"/>
<!-- ==================================================================== -->

  <xsl:template match="glossary">
    <xsl:choose>
      <xsl:when test="$process.acronyms != '0'">
        <xsl:call-template name="process.acronyms"/>
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
	 <xsl:value-of select="key('glossentry', $acronym)/db:glossterm[1]"/>
       </xsl:for-each>
     </xsl:variable>
     <xsl:variable name="title">
       <xsl:for-each select="$acronyms.database">
         <xsl:value-of select="normalize-space(key('glossentry', $acronym)/db:glossdef/db:para/db:glossterm[1])"/>
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
 
</xsl:stylesheet>
