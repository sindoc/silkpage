<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:cc="http://web.resource.org/cc/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:xweb="xalan://com.nwalsh.xalan.Website" 
		xmlns:sweb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Website"
		exclude-result-prefixes=" atom xlink rss html rdf rdfs doap urfm  foaf dc cvs xweb sweb cc " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/rdf.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common RDF</dc:title>
    <cvs:date>$Date: 2005-07-28 22:05:53 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This stylesheet controls the generation of RDF files for webpages.
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

<!-- ==================================================================== -->

  <xsl:template match="webpage" mode="rdf.mode">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="tocentry" select="$autolayout/autolayout//*[$id=@id]"/>
    <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc                                    |$autolayout/autolayout/toc[1])[last()]"/>
    <xsl:variable name="pageurl">
      <xsl:value-of select="$site.url"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$tocentry/@page"/>
    </xsl:variable>
    <xsl:text>&#10;</xsl:text>
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>type="text/xsl" href="/rdf-html.xsl"</xsl:text>
    </xsl:processing-instruction>
    <xsl:element name="rdf:RDF">
      <xsl:element name="rdf:Description">
        <xsl:attribute name="rdf:about">
          <xsl:value-of select="$pageurl"/>
        </xsl:attribute>
        <xsl:apply-templates select="./head/title" mode="rdf.mode"/>
        <dc:date>
          <xsl:call-template name="rcsdate.format"/>
        </dc:date>
        <xsl:apply-templates select="$autolayout/autolayout/copyright[1]   |./head/copyright[1]   |./head/summary[1]" mode="rdf.mode"/>
        <rdf:type>
          <xsl:call-template name="taxonomy.entry">
            <xsl:with-param name="entry" select="'Webpage'"/>
          </xsl:call-template>
        </rdf:type>
        <xsl:element name="dc:type">
          <xsl:attribute name="rdf:resource">
            <xsl:text>http://purl.org/dc/dcmitype/Text</xsl:text>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="dc:format">
          <xsl:text>application/xml</xsl:text>
        </xsl:element>
        <xsl:element name="dc:identifier">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="cc:license">
          <xsl:attribute name="rdf:resource">
	    <xsl:value-of select="$site.license"/>
	  </xsl:attribute>
	</xsl:element>
        <xsl:element name="dc:contributor">
          <xsl:call-template name="taxonomy.entry">
            <xsl:with-param name="entry" select="'SilkaPage'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="dc:author">
	  <xsl:value-of select="$site.author"/>
        </xsl:element>
        <xsl:element name="dc:publisher">
          <xsl:call-template name="taxonomy.entry">
            <xsl:with-param name="entry" select="$site.id"/>
          </xsl:call-template>
        </xsl:element>
	<xsl:apply-templates select="link[@xlink:role != '']" mode="rdf.mode"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="summary" mode="rdf.mode">
    <dc:description>
      <xsl:apply-templates/>
    </dc:description>
  </xsl:template>

  <xsl:template match="title" mode="rdf.mode">
    <dc:title>
      <xsl:apply-templates/>
    </dc:title>
  </xsl:template>
  
  <xsl:template name="taxonomy.entry">
    <xsl:param name="entry"/>
    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="$markupware.taxonomy.url"/>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="$entry"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="copyright" mode="rdf.mode">
    <dc:rights>
      <xsl:call-template name="gentext.element.name"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="year" mode="footer.mode"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="holder" mode="rdf.mode"/>
    </dc:rights>
  </xsl:template>
  <xsl:template match="holder" mode="rdf.mode">
    <xsl:apply-templates/>
    <xsl:if test="@role">
      <xsl:call-template name="gentext.space"/>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@role"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

<xsl:template match="link" mode="rdf.mode">
  <xsl:variable name="file" select="document(@xlink:href, /)"/>
  <xsl:variable name="urfm-in-doap" select="document($file//doap:Project/doap:download-page/@rdf:resource, .)"/>
  <rdfs:seeAlso>
    <xsl:if test="@xlink:role=$namespace.rss">
      <rss:channel>
	<xsl:copy-of select="$file//rss:channel/@rdf:about
			     |$file//rss:channel/rss:title[1]
			     |$file//rss:channel/rss:description[1]"/>
      </rss:channel>
    </xsl:if>
    <xsl:if test="@xlink:role=$namespace.doap">
      <doap:Project>
	<xsl:if test="$file//rdf:Description/@rdf:about">
	  <xsl:copy-of select="$file//rdf:Description/@rdf:about"/>
	</xsl:if>
	<xsl:if test="$file//doap:Project/dc:identifier[1]">
	  <xsl:copy-of select="$file//doap:Project/dc:identifier[1]"/>
	</xsl:if>
	<xsl:copy-of select="$file//doap:Project/doap:homepage[1]
			     |$file//doap:Project/doap:name[1]"/>
      </doap:Project>
    </xsl:if>

    <xsl:if test="@xlink:role=$namespace.urfm">
      <urfm:Channel>
	<xsl:copy-of select="$file//urfm:Channel/@rdf:about"/>      
      </urfm:Channel>
    </xsl:if>

    <xsl:if test="@xlink:role=$namespace.atom">
      <atom:feed>
	<xsl:copy-of select="$file/atom:feed/atom:title[1]
			     |$file/atom:feed/atom:summary[1]
			     |$file/atom:feed/atom:id[1]"/>
	
      </atom:feed>
    </xsl:if>
    <xsl:if test="@xlink:role=$namespace.foaf">
      <foaf:Document>
	<xsl:if test="$file//rdf:Description/@rdf:about">
	  <xsl:copy-of select="$file//rdf:Description/@rdf:about"/>
	</xsl:if>
      </foaf:Document>
    </xsl:if>
  </rdfs:seeAlso>
  <xsl:if test="$urfm-in-doap">
  <rdfs:seeAlso>
    <urfm:Channel>
      <xsl:copy-of select="$urfm-in-doap//urfm:Channel/@rdf:about"/>      
    </urfm:Channel>
  </rdfs:seeAlso>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
