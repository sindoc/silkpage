<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:html="http://www.w3.org/1999/xhtml" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
		xmlns:dc="http://purl.org/dc/elements/1.1/" 
		xmlns:dct="http://purl.org/dc/terms/" 
		xmlns:cvs="http://www.markupware.com/metadata/cvs#" 
		xmlns:rss="http://purl.org/rss/1.0/"
		xmlns:foaf="http://xmlns.com/foaf/0.1/"
		xmlns:urfm="http://purl.org/urfm/"
		xmlns:doap="http://usefulinc.com/ns/doap#"
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:exsl="http://exslt.org/common" 
		xmlns:fc="http://silkpage.markupware.com/feeds-config"
		extension-element-prefixes=" exsl "
		exclude-result-prefixes=" dc dct exsl fc rdf xlink urfm rdfs 
					 doap cvs date atom foaf html "
		version="1.0">
  
  <rdf:Description rdf:about="http://silkpage.markupware.com/release/core/current/src/xsl/common/feeds-config.xsl">
    <rdf:type rdf:resource="http://www.markupware.com/metadata/taxonomy#XSL"/>
    <dc:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>
    <dc:format>application/xsl+xml</dc:format>
    <dc:title>SilkPage Core XSLT, Common Feeds Configuration</dc:title>
    <cvs:date>$Date: 2009-03-23 19:02:48 $</cvs:date>
    <dc:rights>Copyright &#xA9; 2004 MarkupWare.</dc:rights>
    <dc:description>Given a chunk of DOAP files, this stylesheet generates an Atom feed.</dc:description>
  </rdf:Description>
  
  <!-- ==================================================================== -->

  <xsl:param name="user.feeds.basedir"/>
  
<xsl:template match="fc:feeds">
  <xsl:apply-templates select="fc:feed"/>
</xsl:template>

<xsl:template match="fc:feed">

  <xsl:variable name="feed" select="@xml:id"/>
  <xsl:variable name="basedir" select="$user.feeds.basedir"/>
  <xsl:variable name="atom" select="fc:outputs/fc:output[@type='Atom']/@ext"/>
  <xsl:variable name="atom-out" select="concat($user.feeds.basedir,$feed,$atom)"/>      
  <xsl:variable name="rss10" select="fc:outputs/fc:output[@type='RSS10']/@ext"/>
  <xsl:variable name="rss10-out" select="concat($user.feeds.basedir,$feed,$rss10)"/>      
  
  <xsl:if test="//fc:feeds/fc:generate[@feed=$feed]">
    <!-- FOAF agents to Atom feed -->
    <xsl:if test="fc:inputs/@type = 'FOAF' and
		  fc:outputs/fc:output/@type = 'Atom'">
      <exsl:document href="{$atom-out}" encoding="UTF-8" method="xml" indent="yes">
	<atom:feed>
	  <xsl:copy-of select="atom:*|../atom:*|dc:*|../dc:*"/>
	  <xsl:call-template name="atom-media-type"/>
	  <xsl:apply-templates select="fc:inputs" mode="foaf2atom"/>
	</atom:feed>
      </exsl:document>
      <xsl:call-template name="check-atom">
	<xsl:with-param name="file" select="$atom-out"/>
      </xsl:call-template>
    </xsl:if>
    <!-- FOAF agents to RSS 1.0 feed -->
    <xsl:if test="fc:inputs/@type = 'FOAF' and
		  fc:outputs/fc:output/@type = 'RSS10'">
      <xsl:variable name="foaf" select="document(fc:inputs/@href,.)"/>
      <!--
	  <xsl:choose>
	  <xsl:when test="not(fc:inputs/@href)">
	  <xsl:message terminate="yes">
	  <xsl:text>Unable to parse: [</xsl:text>
	  <xsl:value-of select="fc:inputs/@href"/>
	  <xsl:text>]</xsl:text>
	  </xsl:message>
	  </xsl:when>
	  <xsl:otherwise>
	  <xsl:value-of select="document(fc:inputs/@href,.)"/>
	  </xsl:otherwise>
	  </xsl:choose>
	  </xsl:variable>
      -->
      <exsl:document href="{$rss10-out}" encoding="UTF-8" method="xml" indent="yes">
	<rdf:RDF>
	  <rss:channel>
	    <xsl:call-template name="rdfabout-attrib"/>
	    <xsl:apply-templates select="atom:*" mode="atom2rss10"/>
	    <xsl:call-template name="rss10-media-type"/>
	    <xsl:copy-of select="dc:*|../dc:*"/>
	    <rss:items>
	      <rdf:Seq>
		<xsl:for-each select="$foaf//foaf:*">
		  <rdf:li rdf:resource="{@rdf:about}"/>
		</xsl:for-each>
	      </rdf:Seq>
	    </rss:items>		
	  </rss:channel>
	  <xsl:apply-templates select="$foaf//foaf:*" mode="foaf2rss10"/>
	</rdf:RDF>
      </exsl:document>
      <xsl:call-template name="check-rss10">
	<xsl:with-param name="file" select="$rss10-out"/>
      </xsl:call-template>
    </xsl:if>
    <!-- Multiple DOAD files to Atom feed -->
    <xsl:if test="fc:inputs/@type = 'DOAP' and
		  fc:outputs/fc:output/@type = 'Atom'">
      <exsl:document href="{$atom-out}" encoding="UTF-8" method="xml" indent="yes">
	<atom:feed>
	  <xsl:copy-of select="atom:*|../atom:*|dc:*|../dc:*"/>
	  <xsl:call-template name="atom-media-type"/>
	  <xsl:apply-templates select="fc:inputs" mode="doaps2atom"/>
	</atom:feed>
      </exsl:document>
      <xsl:call-template name="check-atom">
	<xsl:with-param name="file" select="$atom-out"/>
      </xsl:call-template>
    </xsl:if>
    <!-- Multiple DOAP files to RSS 1.0 feed -->
    <xsl:if test="fc:inputs/@type = 'DOAP' and 
    		  fc:outputs/fc:output/@type = 'RSS10'">
      <exsl:document href="{$rss10-out}" encoding="UTF-8" method="xml" indent="yes">
	<rdf:RDF>
	  <rss:channel>
	    <xsl:call-template name="rdfabout-attrib"/>
	    <xsl:apply-templates select="atom:*" mode="atom2rss10"/>
	    <xsl:call-template name="rss10-media-type"/>
	    <xsl:copy-of select="dc:*|../dc:*"/>
	    <rss:items>
	      <rdf:Seq>
		<xsl:apply-templates select="fc:inputs/fc:input" mode="rdfseq"/>
	      </rdf:Seq>
	    </rss:items>
	  </rss:channel>
	  <xsl:apply-templates select="fc:inputs/fc:input" mode="doaps2rss10"/>
	</rdf:RDF>
      </exsl:document>
      <xsl:call-template name="check-rss10">
	<xsl:with-param name="file" select="$rss10-out"/>
      </xsl:call-template>
    </xsl:if>
    <!-- Atom entries to RSS 1.0 feed -->
    <xsl:if test="fc:inputs/@type = 'Atom'
		  and fc:outputs/fc:output/@type = 'RSS10'">
      <exsl:document href="{$rss10-out}" encoding="UTF-8" method="xml" indent="yes">
	<rdf:RDF>
	  <xsl:choose>
	    <xsl:when test="fc:inputs/fc:input/atom:entry">
	      <rss:channel>
		<xsl:call-template name="rdfabout-attrib"/>
		<xsl:apply-templates select="atom:*" mode="atom2rss10"/>
		<xsl:call-template name="rss10-media-type"/>
		<xsl:copy-of select="dc:*|../dc:*"/>
		<rss:items>
		  <rdf:Seq>
		    <xsl:apply-templates select="fc:inputs/fc:input/atom:entry" mode="rdfseq"/>
		  </rdf:Seq>
		</rss:items>
	      </rss:channel>
	      <xsl:apply-templates select="fc:inputs/fc:input/atom:entry" mode="atom2rss10"/>
	    </xsl:when>
	    <xsl:when test="document(fc:inputs/@href, .)/fc:input/atom:entry">
	      <rss:channel>
		<xsl:call-template name="rdfabout-attrib"/>
		<xsl:apply-templates select="atom:*" mode="atom2rss10"/>
		<xsl:call-template name="rss10-media-type"/>
		<xsl:copy-of select="dc:*|../dc:*"/>
		<rss:items>
		  <rdf:Seq>
		    <xsl:apply-templates select="document(fc:inputs/@href, .)/fc:input/atom:entry" mode="rdfseq"/>
		  </rdf:Seq>
		</rss:items>
	      </rss:channel>
	      <xsl:apply-templates select="document(fc:inputs/@href, .)/fc:input/atom:entry" mode="atom2rss10"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:message>
	      <xsl:text>Unable to detect the type of transformation</xsl:text>
	      </xsl:message>
	    </xsl:otherwise>
	  </xsl:choose>
	</rdf:RDF>
      </exsl:document>
      <xsl:call-template name="check-rss10">
	<xsl:with-param name="file" select="$rss10-out"/>
      </xsl:call-template>
    </xsl:if>
    <!-- Atom entries to Atom feed -->
    <xsl:if test="fc:inputs/@type = 'Atom'
		  and fc:outputs/fc:output/@type = 'Atom'">
      <exsl:document href="{$atom-out}" encoding="UTF-8" method="xml" indent="yes">
	<atom:feed>
	  <xsl:copy-of select="atom:*|../atom:*|dc:*|../dc:*"/>
	  <xsl:call-template name="atom-media-type"/>
	  <xsl:choose>
	    <xsl:when test="fc:inputs/fc:input/atom:entry">
	      <xsl:apply-templates select="fc:inputs/fc:input/atom:entry" mode="atom2atom"/>
	    </xsl:when>
	    <xsl:when test="document(fc:inputs/@href, .)/fc:input/atom:entry">
	      <xsl:apply-templates select="document(fc:inputs/@href, .)/fc:input/atom:entry" mode="atom2atom"/>	      
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:message>
		<xsl:text>Unable to detect the type of transformation</xsl:text>
	      </xsl:message>
	    </xsl:otherwise>
	  </xsl:choose>
	</atom:feed>
      </exsl:document>
      <xsl:call-template name="check-atom">
	<xsl:with-param name="file" select="$atom-out"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="fc:inputs" mode="foaf2atom">
  <xsl:variable name="href" select="document(@href, .)"/>
  <xsl:choose>
    <xsl:when test="not($href)">
      <xsl:message terminate="yes">
	<xsl:text>Unable to parse: [</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="$href//foaf:Organization|
			$href//foaf:Person">
	  <xsl:apply-templates select="$href//foaf:Organization|
				       $href//foaf:Person" mode="foaf2atom"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message>
	    <xsl:text>foaf:Organization and foaf:Person are only supported
	    </xsl:text>
	  </xsl:message>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="fc:inputs" mode="doaps2atom">
  <!-- Ignore this -->
  <xsl:if test="fc:source[@type='Layout']">
    <xsl:variable name="path" select="'/home/she/ws/cvs/dixite/web/www.dixite.com/src/xml/en/feeds'"/>
    <xsl:variable name="prefix" select="'references'"/>
    <xsl:variable name="href" select="document(concat($path, '/', fc:source/@href), .)"/>
    <xsl:variable name="ref" select="$href//tocentry[@page]"/>
    <xsl:variable name="page" select="document(concat($path, '/../', concat(substring-before($href//tocentry[starts-with(@page,$prefix)]/*/*/@page,fc:source/@suffix),@suffix)))"/>
    <xsl:choose>
      <xsl:when test="not($href)">
	<xsl:message terminate="yes">
	  <xsl:text>Unable to read: [</xsl:text>
	  <xsl:value-of select="fc:source[@type='Layout']/@href"/>
	  <xsl:text>]</xsl:text>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="document($page/config[@param='DOAP']/@value)//doap:Project" mode="doaps2atom"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:apply-templates select="fc:input" mode="doaps2atom"/>
</xsl:template>

<xsl:template match="fc:input" mode="doaps2atom">
  <xsl:variable name="href" select="document(@href, .)"/>
  <xsl:choose>
    <xsl:when test="not($href)">
      <xsl:message terminate="yes">
	<xsl:text>Unable to parse: [</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$href//doap:Project" mode="doaps2atom"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="fc:input" mode="doaps2rss10">
  <xsl:variable name="href" select="document(@href, .)"/>
  <xsl:choose>
    <xsl:when test="not($href)">
      <xsl:message terminate="yes">
	<xsl:text>Unable to parse: [</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$href//doap:Project" mode="doaps2rss10">
	<xsl:with-param name="link-suffix" select="../@link-suffix"/>
	<xsl:with-param name="title-prefix" select="../@title-prefix"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="fc:input" mode="rdfseq">
  <xsl:variable name="href" select="document(@href, .)"/>
  <xsl:choose>
    <xsl:when test="not($href)">
      <xsl:message terminate="yes">
	<xsl:text>Unable to parse: [</xsl:text>
	<xsl:value-of select="@href"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$href//doap:Project" mode="rdfseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="doap:Project" mode="doaps2atom">
  <xsl:variable name="project-id" select="dc:identifier[1]/text()"/>
  <xsl:variable name="latest-release" select="document(doap:download-page/@rdf:resource, .)//urfm:Channel/urfm:releases/urfm:Release[urfm:package/@rdf:resource=$project-id]/urfm:created"/>
  <atom:entry>
    <xsl:apply-templates mode="doaps2atom"
			 select="doap:name|doap:description|doap:shortdesc
				 |doap:created|dc:identifier|doap:homepage"/>
    <atom:updated>
      <xsl:choose>
	<xsl:when test="$latest-release">
	  <xsl:value-of select="$latest-release"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="doap:created[1]"/>
	</xsl:otherwise>
      </xsl:choose>
    </atom:updated>
  </atom:entry>
</xsl:template>

<xsl:template match="foaf:Person|foaf:Organization" mode="foaf2atom">
  <atom:entry>
    <xsl:apply-templates mode="foaf2atom"
			 select="foaf:name|foaf:homepage"/>
    <xsl:apply-templates mode="dc2atom"
			 select="dc:description|dc:date"/>
    <atom:updated>
      <xsl:if test="dc:date[1]">
	<xsl:value-of select="dc:date[1]"/>
      </xsl:if>
    </atom:updated>
  </atom:entry>
</xsl:template>

<xsl:template match="foaf:Person|foaf:Organization" mode="foaf2rss10">
  <rss:item>
    <xsl:apply-templates mode="foaf2rss10" select="foaf:name"/>
    <xsl:apply-templates mode="dc2rss10" select="dc:description|dc:date"/>
  </rss:item>
</xsl:template>

<xsl:template match="doap:Project" mode="doaps2rss10">
  <xsl:param name="link-suffix"/>
  <xsl:param name="title-prefix"/>
  <rss:item>
    <xsl:attribute name="rdf:about">
      <xsl:choose>
	<xsl:when test="dc:identifier">
	  <xsl:value-of select="dc:identifier"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="doap:homepage/@rdf:resource"/>	  
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates mode="doaps2rss10"
			 select="doap:name|doap:description|doap:shortdesc
				 |doap:created|dc:identifier|doap:homepage">
      <xsl:with-param name="link-suffix" select="$link-suffix"/>
      <xsl:with-param name="title-prefix" select="$title-prefix"/>
      </xsl:apply-templates>
  </rss:item>
</xsl:template>

<xsl:template match="doap:Project" mode="rdfseq">
  <rdf:li>
    <xsl:attribute name="rdf:resource">
      <xsl:choose>
	<xsl:when test="dc:identifier">
	  <xsl:value-of select="dc:identifier"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="doap:homepage/@rdf:resource"/>	  
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </rdf:li>
</xsl:template>

<xsl:template match="atom:entry" mode="rdfseq">
  <rdf:li>
    <xsl:call-template name="rdfresource-attrib"/>
  </rdf:li>
</xsl:template>

<xsl:template match="doap:description" mode="doaps2atom">
  <atom:content>
    <xsl:call-template name="common-attrib"/>
    <xsl:choose>
      <xsl:when test="html:*">
	<xsl:attribute name="type">
	  <xsl:value-of select="'xhtml'"/>
	</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
	<xsl:attribute name="type">
	  <xsl:value-of select="'text'"/>
	</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </atom:content>
</xsl:template>

<xsl:template match="doap:description" mode="doaps2rss10">
  <rss:description>
    <xsl:call-template name="common-attrib"/>
    <!--<xsl:call-template name="rdfparseType-Literal"/>-->
    <xsl:apply-templates/>
  </rss:description>
</xsl:template>

<xsl:template match="doap:shortdesc" mode="doaps2atom">
  <atom:summary type="text">
    <xsl:call-template name="common-attrib"/>
    <xsl:apply-templates/>
  </atom:summary>
</xsl:template>

<xsl:template match="doap:shortdesc" mode="doaps2rss10">
  <dc:description>
    <xsl:call-template name="common-attrib"/>
    <xsl:apply-templates/>
  </dc:description>
</xsl:template>

<xsl:template match="doap:name" mode="doaps2atom">
  <atom:title type="text">
    <xsl:call-template name="common-attrib"/>
    <xsl:apply-templates/>
  </atom:title>
</xsl:template>

<xsl:template match="doap:name" mode="doaps2rss10">
  <xsl:param name="title-prefix"/>
  <xsl:variable name="sponsor" select="../rdfs:seeAlso/@rdf:resource"/>
  <rss:title>
    <xsl:call-template name="common-attrib"/>
    <xsl:if test="$title-prefix = 'CLIENT_NAME' and
		  /*/foaf:*[@rdf:about=$sponsor]">
      <xsl:value-of select="/*/foaf:*[@rdf:about=$sponsor]/foaf:name[1]"/>
      <xsl:text> - </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </rss:title>
</xsl:template>

<xsl:template match="dc:identifier" mode="doaps2atom">
  <atom:id>
    <xsl:apply-templates/>
  </atom:id>
</xsl:template>

<xsl:template match="dc:identifier" mode="doaps2rss10">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="doap:homepage" mode="doaps2atom">
  <atom:link rel="alternate" type="text/html">
    <xsl:attribute name="href">
      <xsl:value-of select="@rdf:resource"/>
    </xsl:attribute>
  </atom:link>
</xsl:template>

<xsl:template match="doap:homepage" mode="doaps2rss10">
  <xsl:param name="link-suffix"/>
  <rss:link>
    <xsl:value-of select="@rdf:resource"/>
    <xsl:if test="$link-suffix != ''">
      <xsl:value-of select="$link-suffix"/>
    </xsl:if>
  </rss:link>
</xsl:template>

<xsl:template match="doap:created" mode="doaps2atom">
  <atom:published>
    <xsl:apply-templates/>      
  </atom:published>
</xsl:template>

<xsl:template match="doap:created" mode="doaps2rss10">
  <dc:date>
    <xsl:apply-templates/>      
  </dc:date>
</xsl:template>

<xsl:template match="atom:title" mode="atom2rss10">
  <rss:title>
    <xsl:call-template name="common-attrib"/>
    <xsl:apply-templates/>
  </rss:title>
</xsl:template>

<xsl:template match="atom:subtitle" mode="atom2rss10">
  <rss:description>
    <xsl:call-template name="common-attrib"/>
    <xsl:apply-templates/>
  </rss:description>
</xsl:template>

<xsl:template match="atom:entry" mode="atom2rss10">
  <rss:item>
    <xsl:call-template name="rdfabout-attrib"/>
    <xsl:call-template name="common-attrib"/>
    <xsl:if test="not(atom:link[@rel='alternate']) and atom:id[1]">
      <rss:link>
	<xsl:value-of select="atom:id"/>
      </rss:link>
    </xsl:if>
    <xsl:apply-templates mode="atom2rss10"/>
  </rss:item>
</xsl:template>

<xsl:template match="atom:summary" mode="atom2rss10">
  <rss:description>
    <xsl:call-template name="common-attrib"/>
    <!--<xsl:call-template name="rdfparseType-Literal"/>-->
    <xsl:apply-templates/>
  </rss:description>
</xsl:template>

<xsl:template match="atom:content" mode="atom2rss10">
  <rss:description>
    <xsl:call-template name="common-attrib"/>
    <!--<xsl:call-template name="rdfparseType-Literal"/>-->
    <xsl:apply-templates/>
  </rss:description>
</xsl:template>

<xsl:template match="atom:published" mode="atom2rss10">
  <dc:date>
    <xsl:apply-templates/>
  </dc:date>
</xsl:template>

<xsl:template match="atom:updated" mode="atom2rss10">
  <dct:modified>
    <xsl:apply-templates/>
  </dct:modified>
</xsl:template>

<xsl:template match="atom:category" mode="atom2rss10">
  <dc:subject>
    <xsl:value-of select="@label"/>
  </dc:subject>
</xsl:template>

<xsl:template match="atom:id" mode="atom2rss10">
  <xsl:variable name="rss-ext" select="../fc:outputs/fc:output[@type='RSS10']/@ext"/>
  <xsl:variable name="atom-ext" select="../fc:outputs/fc:output[@type='Atom']/@ext"/>
  <xsl:variable name="id">
    <xsl:apply-templates/>    
  </xsl:variable>
  <dc:identifier>
    <xsl:choose>
      <xsl:when test="ancestor::atom:entry">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="concat(substring-before($id,$atom-ext),$rss-ext)"/>	
      </xsl:otherwise>
    </xsl:choose>
  </dc:identifier>
</xsl:template>

<xsl:template match="atom:rights" mode="atom2rss10">
  <dc:rights>
    <xsl:apply-templates/>
  </dc:rights>
</xsl:template>

<xsl:template match="atom:author" mode="atom2rss10">
  <xsl:apply-templates select="atom:name" mode="atom2rss10"/>
</xsl:template>

<xsl:template match="atom:name" mode="atom2rss10">
  <dc:publisher>
    <xsl:apply-templates/>
  </dc:publisher>
</xsl:template>

<xsl:template match="atom:link[@rel='alternate'][@type='text/html']" mode="atom2rss10">
  <rss:link>
    <xsl:value-of select="@href"/>
  </rss:link>
</xsl:template>

<xsl:template name="common-attrib">
  <xsl:if test="@xml:lang">
    <xsl:attribute name="xml:lang">
      <xsl:value-of select="@xml:lang"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="rss10-media-type">
  <xsl:element name="dc:format">
    <xsl:text>application/rdf+xml</xsl:text>
  </xsl:element>
</xsl:template>

<xsl:template name="atom-media-type">
  <xsl:element name="dc:format">
    <xsl:text>application/atom+xml</xsl:text>
  </xsl:element>
</xsl:template>

<xsl:template name="rdfabout-attrib">
  <xsl:call-template name="assign-id">
    <xsl:with-param name="container-attrib" select="'rdf:about'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="rdfresource-attrib">
  <xsl:call-template name="assign-id">
    <xsl:with-param name="container-attrib" select="'rdf:resource'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="assign-id">
  <xsl:param name="container-attrib"/>
  <xsl:param name="container-element"/>
  <xsl:variable name="rss-ext" select="fc:outputs/fc:output[@type='RSS10']/@ext"/>
  <xsl:variable name="atom-ext" select="fc:outputs/fc:output[@type='Atom']/@ext"/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="dc:identifier[1]">
	<xsl:if test="starts-with(dc:identifier[1],'http://')
		      or starts-with(dc:identifier[1],'https://:')
		      or starts-with(dc:identifier[1],'urn:')">
	  <xsl:value-of select="dc:identifier[1]"/>
	</xsl:if>
      </xsl:when>
      <xsl:when test="atom:id[1] and not(ancestor-or-self::atom:entry)">
	<xsl:value-of select="concat(substring-before(atom:id[1],$atom-ext),$rss-ext)"/>
      </xsl:when>
      <xsl:when test="atom:id[1] and ancestor-or-self::atom:entry">
	<xsl:value-of select="atom:id[1]"/>
      </xsl:when>
      <xsl:when test="atom:link[@rel='alternate'][@type='text/html']">
	<xsl:value-of select="atom:link[@rel='alternate'][@type='text/html']/@href"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$container-attrib != ''">
      <xsl:attribute name="{$container-attrib}">
	<xsl:value-of select="$id"/>
      </xsl:attribute>   
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{$container-element}">
	<xsl:value-of select="$id"/>
      </xsl:element>    	    
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="rdfparseType-Literal">
  <xsl:if test="html:*
		or @type = 'xhtml'">
    <xsl:attribute name="rdf:parseType">
      <xsl:value-of select="'Literal'"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="atom:entry" mode="atom2atom">
  <atom:entry>
    <xsl:copy-of select="atom:*"/>
    <xsl:if test="not(atom:link[@rel='alternate']) and atom:id[1]">
      <atom:link rel="alternate" type="text/html" href="{atom:id}"/>
    </xsl:if>
  </atom:entry>
</xsl:template>

<xsl:template match="dc:description" mode="dc2atom">
  <atom:summary type="text">
    <xsl:apply-templates/>
  </atom:summary>
</xsl:template>

<xsl:template match="foaf:name" mode="foaf2atom">
  <atom:title>
    <xsl:apply-templates/>
  </atom:title>
</xsl:template>

<xsl:template match="foaf:name" mode="foaf2rss10">
  <rss:title>
    <xsl:apply-templates/>
  </rss:title>
</xsl:template>

<xsl:template match="dc:description" mode="dc2rss10">
  <rss:description>
    <xsl:apply-templates/>
  </rss:description>
</xsl:template>

<xsl:template match="dc:date" mode="dc2atom">
  <atom:published>
    <xsl:apply-templates/>
  </atom:published>
</xsl:template>

<xsl:template match="dc:date" mode="dc2rss10">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="html:*">
  <xsl:variable name="ns" select="namespace-uri()"/>
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="xmlns">
      <xsl:value-of select="$ns"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="html:a">
  <xsl:element name="{local-name(.)}">
    <xsl:if test="@xlink:href">
      <xsl:attribute name="href">
	<xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@xlink:title">
      <xsl:attribute name="title">
	<xsl:value-of select="@xlink:title"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@href">
      <xsl:copy-of select="@href"/>
    </xsl:if>
    <xsl:if test="@title">
      <xsl:copy-of select="@title"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="dc:*">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template name="check-atom">
  <xsl:param name="file" select="''"/>
  <xsl:variable name="feed" select="document($file, .)"/>
  <xsl:choose>
    <xsl:when test="$feed != '' and $feed/atom:feed">
      <xsl:message>
	<xsl:text>Writing Atom Feed: [</xsl:text>
	<xsl:value-of select="$file"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>Atom feed: Failed to generate</xsl:text>
      </xsl:message>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="check-rss10">
  <xsl:param name="file" select="''"/>
  <xsl:variable name="feed" select="document($file, .)"/>
  <xsl:choose>
    <xsl:when test="$feed != '' and $feed//rss:channel">
      <xsl:message>
	<xsl:text>Writing RSS 1.0: [</xsl:text>
	<xsl:value-of select="$file"/>
	<xsl:text>]</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
	<xsl:text>RSS 1.0: Failed to generate</xsl:text>
      </xsl:message>      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
