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
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		exclude-result-prefixes=" html cvs " 
		version="1.0">

  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/rdf.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common RDF</dc:title>
    <cvs:date>$Date: 2009-10-17 15:11:29 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>
      This stylesheet controls the generation of RDF files for webpages.
    </dc:description>
  </rdf:Description>

  <xsl:output indent="yes" method="xml" encoding="UTF-8"/>

<!-- ==================================================================== -->

<xsl:template match="webpage" mode="rdf">
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
  <xsl:variable name="seeAlso" select="config[@param='DOAP']|
				       config[@param='URFM']|
				       config[@param='FOAF']|
				       config[@param='RSS10']"/>
  <xsl:text>&#10;</xsl:text>
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>type="text/xsl" href="</xsl:text>
      <xsl:value-of select="$rdf.to.html.stylesheet.path"/>
      <xsl:text>"</xsl:text>
    </xsl:processing-instruction>
    <rdf:RDF>
      <rdf:Description>
	<xsl:attribute name="rdf:about">
	  <xsl:value-of select="$pageurl"/>
	</xsl:attribute>
	<xsl:apply-templates select="./head/title" mode="rdf"/>
	<dc:date>
	  <xsl:call-template name="rcsdate.format"/>
        </dc:date>
        <xsl:apply-templates select="$autolayout/autolayout/copyright[1]|./head/copyright[1]|./head/summary[1]" mode="rdf"/>
        <rdf:type>
          <xsl:call-template name="taxonomy.entry">
	    <xsl:with-param name="name" select="'Webpage'"/>
          </xsl:call-template>
        </rdf:type>
	<dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
	<dc:format>application/xml</dc:format>
	<dc:identifier><xsl:value-of select="$id"/></dc:identifier>
        <dc:contributor>
	  <xsl:call-template name="taxonomy.entry">
	    <xsl:with-param name="name" select="'SilkaPage'"/>
	  </xsl:call-template>	  
	</dc:contributor>
	<dc:creator>
	  <xsl:call-template name="site-author"/>
	</dc:creator>
	<dc:publisher>
	  <xsl:call-template name="taxonomy.entry">
	    <xsl:with-param name="name" select="$site.id"/>
	  </xsl:call-template>
	</dc:publisher>
	<xsl:apply-templates select="$seeAlso" mode="rdf"/>
	<xsl:if test="starts-with($site.license,'http://creativecommons.org/licenses/')">
	  <cc:license rdf:resource="{$site.license}"/>
	</xsl:if>
      </rdf:Description>
      <xsl:apply-templates select="$seeAlso" mode="rdf.resource"/>
      <xsl:if test="starts-with($site.license,'http://creativecommons.org/licenses/')">
	<xsl:call-template name="page-cc-license"/>	
      </xsl:if>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="summary" mode="rdf">
    <dc:description>
      <xsl:apply-templates/>
    </dc:description>
  </xsl:template>

  <xsl:template match="title" mode="rdf">
    <dc:title>
      <xsl:apply-templates/>
    </dc:title>
  </xsl:template>
  
  <xsl:template name="taxonomy.entry">
    <xsl:param name="name"/>
    <xsl:attribute name="rdf:resource">
      <xsl:value-of select="$markupware.taxonomy.url"/>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="$name"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="copyright" mode="rdf">
    <dc:rights>
      <xsl:call-template name="gentext.element.name"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="year" mode="footer.mode"/>
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="holder" mode="rdf"/>
    </dc:rights>
  </xsl:template>
  <xsl:template match="holder" mode="rdf">
    <xsl:apply-templates/>
    <xsl:if test="@role">
      <xsl:call-template name="gentext.space"/>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@role"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="position() != last()">, </xsl:if>
</xsl:template>

<xsl:template match="config[@param='DOAP']|
		     config[@param='URFM']|
		     config[@param='FOAF']|
		     config[@param='RSS10']"
	      mode="rdf">
  <xsl:variable name="file" select="document(@value, /)"/>
  <xsl:variable name="urfm-in-doap" select="document($file//doap:Project/doap:download-page/@rdf:resource, .)"/>
  <rdfs:seeAlso>
    <xsl:attribute name="rdf:resource">
      <xsl:if test="@param='RSS10'">
	<xsl:value-of select="$file//rss:channel/@rdf:about"/>
      </xsl:if>
      <xsl:if test="@param='DOAP'">
	<xsl:choose>
	  <xsl:when test="$file//rdf:Description/@rdf:about">
	    <xsl:value-of select="$file//rdf:Description/@rdf:about"/>
	  </xsl:when>
	  <xsl:when test="$file//doap:Project/dc:identifier[1]">
	    <xsl:value-of select="$file//doap:Project/dc:identifier[1]"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$file//doap:Project/doap:homepage[1]"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
      
      <xsl:if test="@param='URFM'">
	<xsl:value-of select="$file//urfm:Channel/@rdf:about"/>      
      </xsl:if>
      
      <xsl:if test="@param='FOAF'">
	<xsl:value-of select="$file//rdf:Description/@rdf:about"/>
      </xsl:if>
      
    </xsl:attribute>
  </rdfs:seeAlso>

  <xsl:if test="$urfm-in-doap">
    <rdfs:seeAlso>
      <xsl:attribute name="rdf:resource">
	<xsl:value-of select="$urfm-in-doap//urfm:Channel/@rdf:about"/>      
      </xsl:attribute>
    </rdfs:seeAlso>
  </xsl:if>

</xsl:template>

<xsl:template match="config[@param='DOAP']|
		     config[@param='URFM']|
		     config[@param='FOAF']|
		     config[@param='RSS10']"
	      mode="rdf.resource">

  <xsl:variable name="file" select="document(@value, /)"/>
  <xsl:variable name="urfm-in-doap" select="document($file//doap:Project/doap:download-page/@rdf:resource, .)"/>

    <xsl:if test="@param='RSS10'">
      <rss:channel>
	<xsl:copy-of select="$file//rss:channel/@rdf:about
			     |$file//rss:channel/rss:title[1]
			     |$file//rss:channel/rss:description[1]"/>
      </rss:channel>
    </xsl:if>
    <xsl:if test="@param='DOAP'">
      <doap:Project>
	<xsl:if test="$file//rdf:Description/@rdf:about">
	  <xsl:copy-of select="$file//rdf:Description/@rdf:about"/>
	</xsl:if>
	<xsl:if test="$file//doap:Project/dc:identifier[1]">
	  <xsl:copy-of select="$file//doap:Project/dc:identifier[1]"/>
	</xsl:if>
	<xsl:copy-of select="$file//doap:Project/doap:homepage[1]
			     |$file//doap:Project/doap:name[1]"/>
	<xsl:if test="$urfm-in-doap">
	  <rdfs:seeAlso rdf:resource="{$urfm-in-doap//urfm:Channel/@rdf:about}"/>
	</xsl:if>
      </doap:Project>
    </xsl:if>

    <xsl:if test="@param='URFM'">
      <xsl:call-template name="resources.urfm">
	<xsl:with-param name="source" select="$file"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="$urfm-in-doap">
      <xsl:call-template name="resources.urfm">
	<xsl:with-param name="source" select="$urfm-in-doap"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:if test="@param='FOAF'">
      <foaf:Document>
	<xsl:if test="$file//rdf:Description/@rdf:about">
	  <xsl:copy-of select="$file//rdf:Description/@rdf:about"/>
	</xsl:if>
      </foaf:Document>
    </xsl:if>
</xsl:template>

<xsl:template name="page-cc-license">
  <xsl:variable name="license" select="substring-after($site.license,'http://creativecommons.org/licenses/')"/>

  <cc:License rdf:about="{$site.license}">
    <xsl:if test="contains($license,'by')">
      <cc:requires rdf:resource="http://web.resource.org/cc/Attribution"/>
      <cc:requires rdf:resource="http://web.resource.org/cc/Notice" />
    </xsl:if>
    <xsl:if test="not(contains($license,'nd'))">
      <cc:permits rdf:resource="http://web.resource.org/cc/Reproduction"/>
      <cc:permits rdf:resource="http://web.resource.org/cc/Distribution"/>
    </xsl:if>
    <xsl:if test="contains($license,'sa')">
      <cc:requires rdf:resource="http://web.resource.org/cc/Copyleft" />
    </xsl:if>
    <xsl:if test="contains($license,'nc')">
      <cc:prohibits rdf:resource="http://web.resource.org/cc/CommercialUse" />
    </xsl:if>
  </cc:License>

</xsl:template>

<xsl:template name="resources.urfm">
  <xsl:param name="source"/>
  <urfm:Channel>
    <xsl:if test="$source//urfm:Channel/@rdf:about">
      <xsl:attribute name="rdf:about">
	<xsl:value-of select="$source//urfm:Channel/@rdf:about"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="$source//urfm:Channel/urfm:title[1]">
      <urfm:title>
	<xsl:value-of select="$source//urfm:Channel/urfm:title[1]"/>
      </urfm:title>
    </xsl:if>
    <xsl:if test="$source//urfm:Channel/urfm:link[1]">
      <urfm:link>
	<xsl:value-of select="$source//urfm:Channel/urfm:link[1]"/>
      </urfm:link>
    </xsl:if>
    <xsl:if test="$source//urfm:Channel/urfm:description[1]">
      <urfm:description>
	<xsl:value-of select="$source//urfm:Channel/urfm:description[1]"/>
      </urfm:description>
    </xsl:if>
  </urfm:Channel>
</xsl:template>
</xsl:stylesheet>
